import os
import sys
import json
import time
import base64
import bidict
import shutil
import traceback
from collections import defaultdict
from sqlglot import parse_one, exp
from fastapi import APIRouter, HTTPException, Body
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from knowledge_graph.builder import KnowledgeGraphBuilder
from db import *
from config import *
from knowledge_graph import KnowledgeGraph
from llm import *
from utils.error_logger import log_error

chat_router = APIRouter()

class ChatState:
    def __init__(self):
        # 存储所有会话id和会话名称的映射关系
        self.session_map : bidict.bidict = bidict.bidict()
        # 缓存所有会话名称和对应的数据库名称
        self.session_names: list[str] = []
        self.database_names: list[str] = []

        # 存储当前会话的知识图谱和消息记录
        self.current_kg: KnowledgeGraph = None
        self.current_database: str = None
        self.history_messages: list[dict] = []
        self.current_messages: list[dict] = []
        self.current_session: str = None    # 当前会话的唯一标识符
        self.current_question: str = None
        self.current_results: list = None
        self.current_messages_path : str = None

current_pool = ConnectionPool()
user_states: dict[str, ChatState] = defaultdict(ChatState)

def convert_bytes_to_str(data):
    """
    递归遍历数据，将所有 bytes 类型转换为字符串
    先尝试 UTF-8 解码，如果失败则尝试 GBK 解码，最后使用 base64 编码
    """
    if isinstance(data, bytes):
        try:
            return data.decode('utf-8')
        except UnicodeDecodeError:
            try:
                return data.decode('gbk')
            except UnicodeDecodeError:
                return "base64:" + base64.b64encode(data).decode('utf-8')
    elif isinstance(data, dict):
        return {key: convert_bytes_to_str(value) for key, value in data.items()}
    elif isinstance(data, list):
        return [convert_bytes_to_str(item) for item in data]
    else:
        return data

# 获取可用数据库列表
@chat_router.get("/databases")
def get_databases():
    try:
        connection, cursor = connect_mysql()
        cursor.execute("SHOW DATABASES")
        databases = cursor.fetchall()
        connection.close()
        cursor.close()
        databases = [list(db.values())[0]
                     for db in databases
                     if list(db.values())[0] not in ['information_schema', 'performance_schema', 'sys']]
        return {"databases": databases}
    except Exception as e:
        log_error("chat", "get_databases", e)
        raise HTTPException(status_code=500, detail=f"Failed to get databases: {str(e)}")

# 获取可用会话列表
@chat_router.get("/sessions")
def get_sessions(user_id: str = "default_user"):
    try:
        if user_id not in user_states and len(user_states) >= MAX_USERS:
            raise HTTPException(status_code=503, detail=f"服务器用户数量已达上限，请稍后再试")

        user_state = user_states[user_id]
        user_history_root = get_user_history_root(user_id)

        if user_state.session_names and user_state.database_names:
            return {"sessions": user_state.session_names, "databases": user_state.database_names}

        history_json = os.path.join(user_history_root, 'history.json')
        try:
            with open(history_json, 'r', encoding='utf-8') as f:
                history = json.load(f)
        except:
            with open(history_json, 'w', encoding='utf-8') as f:
                json.dump({}, f, ensure_ascii=False, indent=4)
            history = {}

        user_state.session_map = bidict.bidict()
        user_state.session_names, user_state.database_names = [], []
        session_dirs = sorted(os.listdir(user_history_root))
        for session_dir in session_dirs:
            session_path = os.path.join(user_history_root, session_dir)
            if os.path.isdir(session_path):
                system_file = os.path.join(session_path, 'system.json')
                if os.path.exists(system_file):
                    if session_dir in history:
                        user_state.session_map[session_dir] = history[session_dir]
                        user_state.session_names.append(history[session_dir])
                    else:
                        # 是尚未提出过问题的新会话
                        user_state.session_map[session_dir] = session_dir
                        user_state.session_names.append(session_dir)
                    user_state.database_names.append(session_dir[session_dir.find('_')+1:])
                else:
                    shutil.rmtree(session_path)

        return {"sessions": user_state.session_names, "databases": user_state.database_names}
    except HTTPException:
        raise
    except Exception as e:
        log_error("chat", "get_sessions", e, user_id=user_id)
        raise HTTPException(status_code=500, detail=f"Failed to get sessions: {str(e)}")

@chat_router.post("/select_chat")
def select_chat(chat_name: str = Body(None, embed=True),
                database_name: str = Body(None, embed=True),
                graph_name: str = Body(None, embed=True),
                user_id: str = Body("default_user", embed=True)):

    global current_pool

    try:
        user_state = user_states[user_id]
        user_history_root = get_user_history_root(user_id)

        try:
            builder = KnowledgeGraphBuilder(database_name, current_pool)
            print(f"Loading database: {database_name}")
            builder.build_from_mongodb(graph_name)
            user_state.current_kg = builder.kg
            user_state.current_database = database_name
        except Exception as e:
            log_error("chat", "select_chat", e, database_name=database_name, graph_name=graph_name)
            raise HTTPException(status_code=500, detail=f"Failed to load database: {str(e)}")

        user_state.history_messages, user_state.current_messages = [], []
        user_state.current_messages_path = None
        if chat_name:
            session_id = user_state.session_map.inverse[chat_name]
            session_dir = os.path.join(user_history_root, session_id)
            system_json = os.path.join(session_dir, 'system.json')
            with open(system_json, 'r', encoding='utf-8') as f:
                text2sql_system_prompt = json.load(f)
            user_state.history_messages.append(text2sql_system_prompt)
            history_jsons = sorted([f for f in os.listdir(session_dir)
                                    if f.endswith('.json') and f != 'system.json'])
            for history_json in history_jsons:
                history_json = os.path.join(session_dir, history_json)
                with open(history_json, 'r', encoding='utf-8') as f:
                    content = f.read().strip()
                    if content:
                        content = json.loads(content)
                        if content[0]['role'] == 'user':
                            user_state.history_messages.extend(content)
        else:
            # 新建聊天
            session_id = f"{int(time.time()*1000)}_{database_name}"
            session_dir = os.path.join(user_history_root, session_id)
            os.makedirs(session_dir, exist_ok=True)
            text2sql_system_prompt = text2sql_SP(user_state.current_kg.generate_kginfo())
            text2sql_system_prompt = {"role": "system", "content": text2sql_system_prompt}
            system_json = os.path.join(session_dir, 'system.json')
            user_state.session_map[session_id] = session_id
            user_state.session_names.append(session_id)
            user_state.database_names.append(database_name)
            with open(system_json, 'w', encoding='utf-8') as f:
                json.dump(text2sql_system_prompt, f, ensure_ascii=False, indent=4)
            user_state.history_messages = [text2sql_system_prompt]

        # 更新当前会话名称
        user_state.current_session = session_id
    except HTTPException:
        raise HTTPException(status_code=400)
    except Exception as e:
        log_error("chat", "select_chat", e, chat_name=chat_name, database_name=database_name, user_id=user_id)
        raise HTTPException(status_code=500, detail=f"Failed to select chat: {str(e)}")

# 处理用户问题并输出结果
@chat_router.post("/ask_question")
def ask_question(question: str = Body(..., embed=True), user_id: str = Body("default_user", embed=True)):
    global current_pool

    user_state = user_states[user_id]
    user_history_root = get_user_history_root(user_id)

    def save_to_history():
        nonlocal user_state
        # 自动保存消息到历史记录
        if user_state.current_messages_path:
            with open(user_state.current_messages_path, 'w', encoding='utf-8') as f:
                json.dump(user_state.current_messages, f, ensure_ascii=False, indent=4)
            user_state.current_messages_path = None
        else:
            ntime = int(time.time()*1000)
            now_json_path = f'{user_history_root}/{user_state.current_session}/{ntime}.json'
            with open(now_json_path, 'w', encoding='utf-8') as f:
                json.dump(user_state.current_messages, f, ensure_ascii=False, indent=4)

    if not user_state.current_kg or not user_state.current_database or \
        not current_pool or not user_state.current_session or not user_state.history_messages:
        log_error("chat", "ask_question", None, question=question, user_id=user_id)
        raise HTTPException(status_code=400, detail="Please select a database first")

    if user_state.current_session not in user_state.session_map or \
        user_state.session_map[user_state.current_session] == user_state.current_session:
        new_session_name = f"{user_state.current_session[:user_state.current_session.find('_')]}_{question}"
        user_state.session_map[user_state.current_session] = new_session_name
        try:
            user_state.session_names[user_state.session_names.index(user_state.current_session)] = new_session_name
        except:
            user_state.session_names.append(new_session_name)
            user_state.database_names.append(user_state.current_database)
        with open(f"{user_history_root}/history.json", 'w', encoding='utf-8') as f:
            json.dump(dict(user_state.session_map), f, ensure_ascii=False, indent=4)

    user_state.current_question = question
    user_state.current_messages.append({"role": "user", "content": question})

    first_reasoning, sql, results, output_content = "", "", None, ""

    try:
        first_reasoning, sql = text2sql(user_state.history_messages + user_state.current_messages)
        connection, cursor = current_pool.connect(user_state.current_database)
        cursor.execute(sql)
        results = cursor.fetchall()
        user_state.current_results = results
        if 'connection' in locals() and 'cursor' in locals():
            current_pool.close(connection, cursor)

        #second_reasoning, output_content = one_chat([{"role": "system", "content": sql2text_SP},
        #                                            {"role": "user", "content": f"查询结果为{results}"}])
    except Exception as e:
        user_state.current_messages.append({"role": "assistant", "content": ""})
        user_state.history_messages.extend(user_state.current_messages)
        save_to_history()

        log_error("chat", "ask_question", e, question=question, user_id=user_id)
        raise HTTPException(status_code=500, detail=f"Failed to chat: {str(e)}")

    user_state.current_messages.append({"role": "assistant", "content": sql})
    user_state.history_messages.extend(user_state.current_messages)
    save_to_history()

    user_state.current_messages = []

    return {
        "reasoning": first_reasoning,
        "sql": sql,
        "results": results,
        "output": output_content
    }


# 如果用户对答案不满意，可以重新生成回答
@chat_router.post("/regenerate")
def regenerate_output(question_index: int = Body(..., embed=True), user_id: str = Body("default_user", embed=True)):
    try:
        user_state = user_states[user_id]
        user_history_root = get_user_history_root(user_id)

        session_dir = os.path.join(user_history_root, user_state.current_session)
        os.makedirs(session_dir, exist_ok=True)
        history_jsons = sorted([f for f in os.listdir(session_dir)
                                if f.endswith('.json') and f != 'system.json'])

        user_state.current_messages_path = os.path.join(session_dir, history_jsons[question_index])

        with open(user_state.current_messages_path, 'r', encoding='utf-8') as f:
            content = f.read().strip()
        if content:
            content = json.loads(content)
            question = content[0]["content"]

        history_messages_ = user_state.history_messages[user_state.history_messages.index(content[-1])+1:]
        user_state.history_messages = user_state.history_messages[:user_state.history_messages.index(content[0])]

        ans = ask_question(question, user_id)
        user_state.history_messages.extend(history_messages_)

        return ans
    except HTTPException:
        raise
    except Exception as e:
        log_error("chat", "regenerate_output", e, question_index=question_index, user_id=user_id)
        raise HTTPException(status_code=500, detail=f"Failed to regenerate: {str(e)}")

@chat_router.post("/get_data")
def get_data(question_index: int = Body(..., embed=True), user_id: str = Body("default_user", embed=True)):
    global current_pool

    user_state = user_states[user_id]
    user_history_root = get_user_history_root(user_id)

    def transform_sql(input_sql: str, server: str = "mysql") -> str:
        """
        递归处理 UNION / INTERSECT / EXCEPT，对于每个 SELECT 块：
        1. 提取所有提到的列（SELECT、JOIN、WHERE 中）
        2. 保留表连接逻辑，且连接条件的等值列只保留一个
        3. 保留筛选条件（下述代码已确保考虑周全）
        4. 移除 ORDER BY、LIMIT、GROUP BY、HAVING、DISTINCT 等
        """
        parsed = parse_one(input_sql, dialect=server)
        transformed_node = _process_node_recursive(parsed, server=server)
        return transformed_node.sql(dialect=server, pretty=True)

    def _process_node_recursive(node, server: str):
        """
        递归处理 AST 节点的核心调度器
        """
        # 情况 1: 遇到子查询（括号包裹的语句），提取内部节点并递归处理，保留括号
        if isinstance(node, exp.Subquery):
            inner_node = _process_node_recursive(node.this, server=server)
            return exp.Subquery(this=inner_node)

        # 情况 2: 遇到 UNION / INTERSECT / EXCEPT，递归处理左右子节点
        if isinstance(node, exp.Union):
            new_left = _process_node_recursive(node.left, server=server)
            new_right = _process_node_recursive(node.right, server=server)

            return exp.Union(
                this=new_left,
                expression=new_right,
            )

        if isinstance(node, exp.Intersect):
            new_left = _process_node_recursive(node.left, server=server)
            new_right = _process_node_recursive(node.right, server=server)

            return exp.Intersect(
                this=new_left,
                expression=new_right,
            )

        if isinstance(node, exp.Except):
            new_left = _process_node_recursive(node.left, server=server)
            new_right = _process_node_recursive(node.right, server=server)

            return exp.Except(
                this=new_left,
                expression=new_right,
            )

        # 情况 3: 遇到 SELECT 语句块，进行具体转换
        if isinstance(node, exp.Select):
            return _transform_single_select(node, server=server)

        # 其他情况，直接返回副本
        return node.copy()

    def _transform_single_select(select_node, server: str):
        """
        处理单个 SELECT 语句块（不包含 UNION）
        """
        mentioned_columns = set()
        join_eq_pairs = []
        aliases = set()
        has_star = False
        star_table = None

        for node in select_node.walk():
            if isinstance(node, exp.Alias):
                aliases.add(node.alias)

        for node in select_node.walk():
            # 提取列引用
            if isinstance(node, exp.Column):
                try:
                    if str(node.this) not in aliases:
                        mentioned_columns.add(node.sql(dialect=server))
                except:
                    mentioned_columns.add(node.sql(dialect=server))

            # 处理星号表达式（SELECT * 或 SELECT table.*）
            if isinstance(node, exp.Star):
                has_star = True
                star_table = node.this.sql(dialect=server) if node.this else None

            # 提取 JOIN 等值对
            if isinstance(node, exp.EQ):
                left, right = node.left, node.right
                if isinstance(left, exp.Column) and isinstance(right, exp.Column):
                    join_eq_pairs.append((left.sql(dialect=server), right.sql(dialect=server)))

        # 处理列去重（JOIN 等值列二选一）
        final_columns = list(mentioned_columns)
        for col1, col2 in join_eq_pairs:
            if col1 in final_columns and col2 in final_columns:
                final_columns.remove(col2)

        if has_star:
            if star_table:
                new_select = exp.Select(expressions=[exp.Star(this=parse_one(star_table, dialect=server))])
            else:
                new_select = exp.Select(expressions=[exp.Star()])
        else:
            new_select = exp.Select(
                expressions=[exp.Column(this=parse_one(col, dialect=server)) for col in final_columns]
            )

        from_clause = select_node.find(exp.From)
        if from_clause:
            new_select.set("from_", from_clause.copy())

        joins = select_node.args.get("joins")
        if joins:
            for join in joins:
                new_select.append("joins", join.copy())

        where_clause = select_node.args.get("where")
        if where_clause:
            new_select.set("where", where_clause.copy())

        return new_select

    session_dir = os.path.join(user_history_root, user_state.current_session)
    os.makedirs(session_dir, exist_ok=True)
    history_jsons = sorted([f for f in os.listdir(session_dir)
                            if f.endswith('.json') and f != 'system.json'])

    user_state.current_messages_path = os.path.join(session_dir, history_jsons[question_index])
    with open(user_state.current_messages_path, 'r', encoding='utf-8') as f:
        content = f.read().strip()
    if content:
        content = json.loads(content)
        try:
            sql = content[1]["content"]
        except:
            raise HTTPException(status_code=400, detail="Invalid message format")
    try:
        sql = transform_sql(sql)
        print(sql)
        connection, cursor = current_pool.connect(user_state.current_database)
        cursor.execute(sql)
        data = cursor.fetchall()
        data = convert_bytes_to_str(data)
    except Exception as e:
        log_error("chat", "get_data", e, question_index=question_index, user_id=user_id)
        raise HTTPException(status_code=400, detail="Invalid SQL query")
    finally:
        if 'connection' in locals() and 'cursor' in locals():
            current_pool.close(connection, cursor)

    return {"data": data, "sql": sql}

# 删除会话
@chat_router.post("/delete_session")
def delete_session(session_name: str = Body(..., embed=True),
                   user_id: str = Body("default_user", embed=True)):

    user_state = user_states[user_id]
    user_history_root = get_user_history_root(user_id)

    try:
        session_id = user_state.session_map.inverse[session_name]
        session_path = os.path.join(user_history_root, session_id)
        if os.path.exists(session_path) and os.path.isdir(session_path):
            shutil.rmtree(session_path)
            try:
                del user_state.database_names[user_state.session_names.index(user_state.session_map[session_id])]
                user_state.session_names.remove(user_state.session_map[session_id])
                user_state.session_map.pop(session_id, None)
            except:
                pass
            with open(f"{user_history_root}/history.json", 'w', encoding='utf-8') as f:
                json.dump(dict(user_state.session_map), f, ensure_ascii=False, indent=4)
            return {"message": f"Session {session_id} deleted successfully"}
        else:
            raise HTTPException(status_code=404, detail="Session not found")
    except Exception as e:
        log_error("chat", "delete_session", e, session_name=session_name, user_id=user_id)
        raise HTTPException(status_code=500, detail=f"Failed to delete session: {str(e)}")

# 删除消息
@chat_router.post("/delete_message")
def delete_message(question_index: int = Body(..., embed=True), user_id: str = Body("default_user", embed=True)):

    user_state = user_states[user_id]
    user_history_root = get_user_history_root(user_id)

    session_dir = os.path.join(user_history_root, user_state.current_session)
    os.makedirs(session_dir, exist_ok=True)
    history_jsons = sorted([f for f in os.listdir(session_dir)
                            if f.endswith('.json') and f != 'system.json'])

    history_json = os.path.join(session_dir, history_jsons[question_index])
    #history_sql = os.path.join(session_dir, history_jsons[question_index].replace('.json', '.sql'))

    with open(history_json, 'r', encoding='utf-8') as f:
        content = f.read().strip()
    if content:
        content = json.loads(content)

    user_state.history_messages = user_state.history_messages[:user_state.history_messages.index(content[0])] + \
                                  user_state.history_messages[user_state.history_messages.index(content[-1])+1:]

    try:
        os.remove(history_json)
        #os.remove(history_sql)
    except:
        pass

@chat_router.post("/logout")
def logout(user_id: str = Body("default_user", embed=True)):
    if user_id in user_states:
        del user_states[user_id]
        return {"message": "用户已成功退出"}
    else:
        return {"message": "用户未登录"}