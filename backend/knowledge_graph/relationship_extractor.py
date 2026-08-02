import os
import sys
import random
import math
from concurrent.futures import ThreadPoolExecutor, as_completed

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from db import *
from config import *

def generate_table_col_relationships(database_name: str, table_name: str, pool: ConnectionPool) -> list[dict]:
    """
    table -[has_column]-> column

    Returns:
        table_column_relationships = [{
            'source': table_entity_id,
            'target': col_entity_id,
            'source-to-target relation': 'has_column'
        } , ......
        ]
    """
    connection, cursor = pool.connect(database=database_name)
    table_entity_id = f"table:{database_name}.{table_name}"
    table_col_relationships = []

    cursor.execute(f"""
        SELECT
            COLUMN_NAME
        FROM
            INFORMATION_SCHEMA.COLUMNS
        WHERE
            TABLE_SCHEMA = '{database_name}' AND
            TABLE_NAME = '{table_name}'
    """)
    columns = [column['COLUMN_NAME'] for column in cursor.fetchall()]
    for column_name in columns:
        col_entity_id = f"column:{database_name}.{table_name}.{column_name}"
        table_col_relationships.append({
            'source': table_entity_id,
            'target': col_entity_id,
            'source-to-target relation': 'has_column'
        })

    if "connection" in locals() and "cursor" in locals():
        pool.close(connection, cursor)

    return table_col_relationships


def check_foreign_key(source: str, target: str, pool: ConnectionPool) -> bool:
    """
    检查是否可能存在从 source 到 target 的外键关系。
    """
    try:
        source_parts = source.split(':')[-1].split('.')
        target_parts = target.split(':')[-1].split('.')

        if len(source_parts) != 3 or len(target_parts) != 3:
            return False

        source_database = source_parts[0]
        source_table = source_parts[1]
        source_column = source_parts[2]
        target_database = target_parts[0]
        target_table = target_parts[1]
        target_column = target_parts[2]

        if source_table == target_table:
            return False

        connection1, cursor1 = pool.connect(database=source_database)
        connection2, cursor2 = pool.connect(database=target_database)

        cursor1.execute(f"""SELECT DISTINCT {source_column}
            FROM {source_database}.{source_table}
            WHERE {source_column} IS NOT NULL
        """)
        source_values = set(row[source_column] for row in cursor1.fetchall() if row[source_column])

        cursor2.execute(f"""SELECT DISTINCT {target_column}
            FROM {target_database}.{target_table}
            WHERE {target_column} IS NOT NULL
        """)
        target_values = set(row[target_column] for row in cursor2.fetchall() if row[target_column])

        cnt = 0
        for source_value in source_values:
            if source_value and source_value in target_values:
                cnt += 1
        if cnt / len(source_values) > FK_THRES:
            return True

        cnt = 0
        for target_value in target_values:
            if target_value and target_value in source_values:
                cnt += 1
        if cnt / len(target_values) > FK_THRES:
            return True

        return False

    except Exception as e:
        print(e)
        return False
    finally:
        if "connection1" in locals() and "cursor1" in locals():
            pool.close(connection1, cursor1)
        if "connection2" in locals() and "cursor2" in locals():
            pool.close(connection2, cursor2)


def get_crosstable_col_relationships(database_name: str, pool: ConnectionPool) -> list[dict]:
    """
    提取跨表的两列之间的关系（外键关系）。
    """
    connection, cursor = pool.connect(database=database_name)
    col_relationships = []
    cursor.execute(f"""
        SELECT
            CONSTRAINT_NAME,
            TABLE_NAME,
            COLUMN_NAME,
            REFERENCED_TABLE_NAME,
            REFERENCED_COLUMN_NAME
        FROM
            information_schema.KEY_COLUMN_USAGE
        WHERE
            REFERENCED_TABLE_SCHEMA = '{database_name}'
    """)
    foreign_keys = cursor.fetchall()

    for foreign_key in foreign_keys:
        #constraint_name = foreign_key['CONSTRAINT_NAME']
        source_entity_id = f"column:{database_name}.{foreign_key['TABLE_NAME']}.{foreign_key['COLUMN_NAME']}"
        target_entity_id = f"column:{database_name}.{foreign_key['REFERENCED_TABLE_NAME']}.{foreign_key['REFERENCED_COLUMN_NAME']}"
        col_relationships.append({
            'source': source_entity_id,
            'target': target_entity_id,
            'source-to-target relation': 'foreign_key'
        })

    return col_relationships


def explore_crosstable_col_relationships(kg_info: str, database_name: str, pool: ConnectionPool) -> list[dict]:
    """
    探索跨表的两列之间关系。
    """
    print(f"Exploring cross-table column relationships: ")
    col_relationships = []

    system_prompt = f"""{ENTITY_NAME_RULE}
    知识图谱包含实体、实体属性和关系。列实体属性中的"examples"是从原数据库对应列抽取出的一些样本，如果样本只有None一个，则说明该列的所有值都是None。
    以下是完整的知识图谱：
    {kg_info}
    """
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user",
         "content": '根据知识图谱，除了已经显式定义的外键关系外，是否还存在可能的外键关系？任何可能存在逻辑关系的实体都有可能存在隐藏的关系，所以尽情推理和假设。如果有，以 entity_id -[foreign_key]-> entity_id 格式输出，一行输出一个关系。如果没有，输出"None"。不要生成额外的内容。'}
    ]
    while True:
        print(f"-------- Epoch {len(messages) >> 1} --------")
        response = DEEPSEEK_CLIENT.chat.completions.create(
            model="deepseek-reasoner",
            messages=messages,
            stream=False
        )
        potential_relationships = response.choices[0].message.content
        if potential_relationships == "None":
            print("No more foreign key relationships.")
            print("-------------------------")
            break
        messages.append({"role": "assistant", "content": potential_relationships})
        message = "经过验证：\n"

        predict_relationships = []
        for line in potential_relationships.splitlines():
            if line.strip():
                try:
                    source, target = line.strip().split(' -[foreign_key]-> ')
                    predict_relationships.append((source, target))
                except ValueError:
                    continue

        with ThreadPoolExecutor(max_workers=MAX_CONCURRENCY) as executor:
            future_to_relationship = {
                executor.submit(check_foreign_key, source, target, pool): (source, target)
                for source, target in predict_relationships
            }

            for future in as_completed(future_to_relationship):
                source, target = future_to_relationship[future]
                try:
                    if future.result():
                        col_relationships.append({
                            'source': source,
                            'target': target,
                            'source-to-target relation': 'foreign_key'
                        })
                        print(f"{source} -[foreign_key]-> {target}  √")
                        message += f"{source} -[foreign_key]-> {target} 可能成立\n"
                    else:
                        print(f"{source} -[foreign_key]-> {target}  ×")
                        message += f"{source} -[foreign_key]-> {target} 可能不成立\n"
                except Exception as e:
                    print(f" - Error: Valid {source} -[foreign_key]-> {target}: {e}", file=sys.stderr)
        message += '根据知识图谱，除了已经显式定义和已经被你找出的外键关系外，是否还存在可能的外键关系？任何可能存在逻辑关系的实体都有可能存在隐藏的关系，所以尽情推理和假设。如果有，以 entity_id -[foreign_key]-> entity_id 格式输出，一行输出一个关系。如果没有，输出"None"。不要生成额外的内容。'
        messages.append({"role": "user", "content": message})

    return col_relationships

