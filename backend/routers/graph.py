import os
import sys
import json
import traceback
from fastapi import APIRouter, HTTPException, Body

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config.paths import DB_JSON_PATH, BACKEND_ROOT
from config.db import ADMIN_KEY
from db.mongodb_operations import connect_mongodb
from knowledge_graph.builder import KnowledgeGraphBuilder
from routers.chat import current_pool
from utils.error_logger import log_error

router = APIRouter()

@router.post("/verify_admin")
def verify_admin(password: str = Body(..., embed=True)):
    """验证管理员密码，用于打开图谱管理"""
    if password == ADMIN_KEY:
        return {"success": True, "message": "密码正确"}
    return {"success": False, "message": "密码错误"}

@router.get("/get_graphs")
def get_graphs():
    """获取所有图谱映射"""
    try:
        with open(DB_JSON_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)

        graphs = []
        # 从DB_KG中提取图谱映射
        if 'DB_KG' in data:
            for db_name, kg_name in data['DB_KG'].items():
                graphs.append({
                    'name': db_name,
                    'mapping': kg_name
                })

        return {"graphs": graphs}
    except Exception as e:
        log_error("graph", "get_graphs", e)
        print(f"加载图谱列表失败: {e}")
        return {"graphs": []}

@router.delete("/delete_graph")
def delete_graph(name: str = Body(...), mapping: str = Body(...)):
    """删除图谱映射"""
    try:
        # 加载db.json文件
        with open(DB_JSON_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # 检查并删除DB_KG中的映射
        if 'DB_KG' in data and name in data['DB_KG']:
            del data['DB_KG'][name]

        # 检查并删除KG_DB中的映射
        if 'KG_DB' in data and mapping in data['KG_DB']:
            del data['KG_DB'][mapping]

        # 保存修改后的文件
        with open(DB_JSON_PATH, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        client = connect_mongodb()
        if mapping in client.list_database_names():
            client.drop_database(mapping)
        client.close()

        return {"success": True, "message": "图谱删除成功"}
    except Exception as e:
        log_error("graph", "delete_graph", e, name=name, mapping=mapping)
        print(f"删除图谱失败: {e}")
        raise HTTPException(status_code=500, detail="删除图谱失败")

@router.delete("/create_graph")
def create_graph(database_name: str = Body(..., embed=True)):
    try:
        builder = KnowledgeGraphBuilder(database_name, current_pool)
        builder.build_entities_from_database()
        builder.save_to_mongodb(f"kg:{database_name}")
        return {"message": f"Database {database_name} kg created successfully", "kg_loaded": True}
    except Exception as e:
        log_error("graph", "create_graph", e, database_name=database_name)
        raise HTTPException(status_code=500, detail=f"Failed to create kg: {str(e)}")