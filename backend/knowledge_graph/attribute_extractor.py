import os
import sys
from decimal import Decimal
from pydantic import BaseModel
from typing import Literal, Union
import random
from datetime import date, datetime

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from db import *
from config import *

Tab = "    "

class TableAttribute(BaseModel):
    # 实体分类
    classification: Literal["table"] = "table"
    # 表名
    name: str = ""
    # 表注释
    comment: Union[str, None] = None
    # 存储引擎
    engine: Union[str, None] = None
    # 字符集
    charset: str = "utf8mb4_unicode_ci"

class ColumnAttribute(BaseModel):
    # 实体分类
    classification: Literal["column"] = "column"
    # 列名
    name: str = ""
    # 列注释
    comment: Union[str, None] = None
    # 列数据类型
    column_type: Union[str, None] = None
    # 是否主键
    is_primary_key: Union[bool, None] = None
    # 是否唯一键
    is_unique_key: Union[bool, None] = None
    # 是否索引
    is_index: Union[bool, None] = None
    # 是否可为空
    is_nullable: Union[str, None] = None
    # 列顺序
    ordinal_position: Union[int, None] = None
    # 抽样
    examples: Union[list, None] = None

def normalize(examples: list) -> list:
    """
    将原始数据中一些特殊的数据类型转换为mongodb能解码的类型。
    """
    for i in range(len(examples)):
        example = examples[i]
        if type(example) == date:
            examples[i] = example.isoformat()
        elif type(example) == datetime:
            examples[i] = example.strftime("%Y-%m-%d %H:%M:%S")
        elif type(example) == Decimal:
            examples[i] = float(example)
        elif type(example) == dict:
            example = [[key, value] for key, value in example.items()]
            for j in range(len(example)):
                if type(example[j][0]) == date:
                    example[j][0] = example[j][0].isoformat()
                elif type(example[j][0]) == datetime:
                    example[j][0] = example[j][0].strftime("%Y-%m-%d %H:%M:%S")
                elif type(example[j][0]) == Decimal:
                    example[j][0] = float(example[j][0])
                if type(example[j][1]) == date:
                    example[j][1] = example[j][1].isoformat()
                elif type(example[j][1]) == datetime:
                    example[j][1] = example[j][1].strftime("%Y-%m-%d %H:%M:%S")
                elif type(example[j][1]) == Decimal:
                    example[j][1] = float(example[j][1])
            examples[i] = dict(example)

    return examples

def get_table_attributes(database_name: str, table_name: str, pool: ConnectionPool) -> TableAttribute:
    connection, cursor = pool.connect(database=database_name)
    cursor.execute(f"""
        SELECT
            TABLE_COMMENT,
            ENGINE,
            TABLE_COLLATION
        FROM
            INFORMATION_SCHEMA.TABLES
        WHERE
            TABLE_SCHEMA = '{database_name}' AND
            TABLE_NAME = '{table_name}'
    """)
    table_info = cursor.fetchone()

    table_attributes = TableAttribute(name = table_name)

    if table_info:
        # 表注释
        if table_info['TABLE_COMMENT']:
            table_attributes.comment = table_info['TABLE_COMMENT']
        # 存储引擎
        if table_info['ENGINE']:
            table_attributes.engine = table_info['ENGINE']
        # 字符集
        if table_info['TABLE_COLLATION']:
            collation = table_info['TABLE_COLLATION']
            table_attributes.charset = collation
    '''
    # 抽样表记录
    cursor.execute(f"""
        SELECT
            *
        FROM
            {table_name}
    """)
    rows = cursor.fetchall()
    if rows:
        rows.sort(key = lambda x: sum(0 if (value or value == 0) else 1 for value in x.values()))
        columns = list(rows[0].keys())
        examples = []
        covered_columns = set()

        for row in rows:
            if any((key not in covered_columns and (value or value == 0))
                   for key, value in row.items()):
                examples.append(row)
                for key, value in row.items():
                    if value or value == 0:
                        covered_columns.add(key)
                if len(covered_columns) == len(columns) or len(examples) == MAX_EXAMPLES:
                    break
        examples = normalize(examples)
        table_attributes.examples = examples

    if 'connection' in locals() and 'cursor' in locals():
        pool.close(connection, cursor)
    '''

    #print(table_attributes)
    #sys.exit(0)

    return table_attributes


def get_col_attributes(database_name: str, table_name: str, pool: ConnectionPool) -> dict[str, ColumnAttribute]:
    """
    获取列的属性 \n
    col_attributes = {
        "column:database_name.table_name.column_name": ColumnAttribute, ......
    }
    """
    col_attributes = {}
    connection, cursor = pool.connect(database=database_name)

    # 获取列基本信息（除外键信息）
    cursor.execute(f"""
        SELECT
            COLUMN_NAME,
            COLUMN_COMMENT,
            COLUMN_TYPE,
            COLUMN_KEY,
            IS_NULLABLE,
            ORDINAL_POSITION
        FROM
            INFORMATION_SCHEMA.COLUMNS
        WHERE
            TABLE_SCHEMA = '{database_name}' AND
            TABLE_NAME = '{table_name}'
    """)
    columns = cursor.fetchall()
    columns = sorted(columns, key = lambda x: x['ORDINAL_POSITION'])
    print(f"{Tab}There are {len(columns)} columns in table:{database_name}.{table_name}, ", end='')

    # 获取外键列
    cursor.execute(f"""
        SELECT
            COLUMN_NAME
        FROM
            INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE
            TABLE_SCHEMA = '{database_name}' AND
            TABLE_NAME = '{table_name}' AND
            REFERENCED_TABLE_SCHEMA IS NOT NULL AND
            REFERENCED_TABLE_NAME IS NOT NULL AND
            REFERENCED_COLUMN_NAME IS NOT NULL
    """)
    result = cursor.fetchall()
    print(f"{len(result)} foreign keys among them.")
    foreign_keys : set = {x['COLUMN_NAME'] for x in result}

    for column in columns:
        if column['COLUMN_NAME'] != None:
            col_attribute = ColumnAttribute(
                name = column['COLUMN_NAME'],
                ordinal_position = int(column['ORDINAL_POSITION']),
            )
            # 列注释
            if column['COLUMN_COMMENT']:
                col_attribute.comment = column['COLUMN_COMMENT']
            # 数据类型
            if column['COLUMN_TYPE']:
                col_attribute.column_type = column['COLUMN_TYPE']
            # 键类型
            if column['COLUMN_KEY'] != None:
                if column['COLUMN_KEY'] == 'PRI':
                    col_attribute.is_primary_key = True
                    col_attribute.is_unique_key = True
                    col_attribute.is_index = True
                elif column['COLUMN_KEY'] == 'UNI':
                    col_attribute.is_primary_key = False
                    col_attribute.is_unique_key = True
                    col_attribute.is_index = True
                elif column['COLUMN_KEY'] == 'MUL':
                    col_attribute.is_primary_key = False
                    col_attribute.is_unique_key = False
                    col_attribute.is_index = True
                else:
                    col_attribute.is_primary_key = False
                    col_attribute.is_unique_key = False
                    col_attribute.is_index = False
            '''
            # 是否外键
            if column['COLUMN_NAME'] in foreign_keys:
                col_attribute.is_foreign_key = True
            else:
                col_attribute.is_foreign_key = False
            '''
            # 是否允许为空
            if column['IS_NULLABLE']:
                col_attribute.is_nullable = column['IS_NULLABLE']
            # 抽样
            cursor.execute(f"""
                SELECT
                    DISTINCT `{column['COLUMN_NAME']}`
                FROM
                    {database_name}.{table_name}
            """)
            results = cursor.fetchall()
            examples = [result[column['COLUMN_NAME']] for result in
                        random.sample(results, min(MAX_EXAMPLES, len(results)))]
            examples = normalize(examples)
            col_attribute.examples = examples

            col_attributes[f"column:{database_name}.{table_name}.{column['COLUMN_NAME']}"] = col_attribute

    if 'connection' in locals() and 'cursor' in locals():
        pool.close(connection, cursor)

    #print(col_attributes)
    #sys.exit(0)

    return col_attributes