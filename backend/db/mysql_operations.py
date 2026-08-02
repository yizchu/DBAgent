import os
import sys
import re
import pymysql
import sqlite3

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from config import *
from db.connection_pool import ConnectionPool

def connect_mysql(cursorclass: pymysql.cursors.Cursor = pymysql.cursors.DictCursor):
    connection = pymysql.connect(
        host=MYSQL_DATABASE['host'],
        port=MYSQL_DATABASE['port'],
        user=MYSQL_DATABASE['user'],
        password=MYSQL_DATABASE['password'],
        charset=MYSQL_DATABASE['charset'],
        cursorclass=cursorclass
    )

    cursor = connection.cursor()

    return connection, cursor


class MysqlConnection:
    def __init__(self, pool: ConnectionPool, database: str = None):
        self.connection, self.cursor = pool.connect(database)

    def execute_sql(self, sql: str):
        """
        Execute SQL in the given connection.

        Parameters:
            database: Database name.
            sql: SQL statement.
        """
        sql = re.sub(r'--.*', '', sql.strip())
        sql_commands = sql.split(';')
        for command in sql_commands:
            command = command.strip()
            if command:
                print(command)
                self.cursor.execute(command)
        self.connection.commit()

    def close(self):
        self.connection.close()
        self.cursor.close()

def import_sqlite_to_mysql(sqlite_db_path: str, mysql_database: str):
    """
    将SQLite数据库中的数据导入到MySQL的同名数据库中

    参数:
        sqlite_db_path: SQLite数据库文件路径
        mysql_database: MySQL数据库名称
    """
    # 连接SQLite数据库
    sqlite_conn = sqlite3.connect(sqlite_db_path)
    sqlite_cursor = sqlite_conn.cursor()

    # 获取SQLite数据库中的所有表
    sqlite_cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = sqlite_cursor.fetchall()
    tables = list(reversed(tables))

    # 连接MySQL数据库
    mysql_conn, mysql_cursor = connect_mysql()
    mysql_cursor.execute(f"USE {mysql_database};")

    try:
        for table in tables:
            table_name = table[0]
            # 跳过SQLite系统表
            if table_name.startswith('sqlite_'):
                continue

            print(f"处理表: {table_name}")

            # 获取表的所有列
            sqlite_cursor.execute(f"PRAGMA table_info({table_name});")
            columns = sqlite_cursor.fetchall()
            column_names = [col[1] for col in columns]

            # 获取表中的所有数据
            sqlite_cursor.execute(f"SELECT * FROM {table_name};")
            rows = sqlite_cursor.fetchall()

            if not rows:
                print(f"表 {table_name} 没有数据，跳过")
                continue

            # 构建插入SQL语句
            placeholders = ', '.join(['%s'] * len(column_names))
            columns_str = ', '.join(column_names)
            insert_sql = f"INSERT INTO {table_name} ({columns_str}) VALUES ({placeholders});"

            # 批量插入数据
            mysql_cursor.executemany(insert_sql, rows)
            mysql_conn.commit()
            print(f"成功导入表 {table_name} 的 {len(rows)} 条数据")

    except Exception as e:
        print(f"导入过程中发生错误: {e}")
        mysql_conn.rollback()
    finally:
        # 关闭连接
        sqlite_cursor.close()
        sqlite_conn.close()
        mysql_conn.close()

def import_csv_to_mysql(csv_file_path: str, mysql_database: str):
    mysql_conn, mysql_cursor = connect_mysql()
    mysql_cursor.execute(f"USE {mysql_database};")
    with open(csv_file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            line = line.strip()
            if line:
                mysql_cursor.execute(f"INSERT INTO {mysql_database}.{os.path.basename(csv_file_path).split('.')[0]} VALUES ({line});")
                mysql_conn.commit()
                print(f"成功导入数据 {line}")


if __name__ == '__main__':

    def convert_bytes_to_str(data):
        """
        递归遍历数据，将所有 bytes 类型转换为字符串
        先尝试 UTF-8 解码，如果失败则尝试 GBK 解码，最后使用 base64 编码
        """
        import base64

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

    conn, cursor = connect_mysql(cursorclass=pymysql.cursors.Cursor)
    cursor.execute("USE commute;")
    cursor.execute('''
        SELECT
        *
        FROM commute.assoc_bk_user_attendance_dd_eagle0922 AS a
        JOIN commute.assoc_bk_user AS u
        ON a.userid = u.id
        WHERE
        a.work_date >= '2025-08-01'
        AND a.work_date < '2025-09-01'
        AND a.is_work_day = 1
        AND (
            a.on_duty IS NULL OR a.on_duty > '09:00:00'
        )
                   ''')
    results = cursor.fetchall()
    data = convert_bytes_to_str(results)
    print(data)

