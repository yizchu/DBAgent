import os
import sys
import pymysql
import pymongo
from dbutils.pooled_db import PooledDB

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config import *

class ConnectionPool():
    def __init__(self, database_server: str = 'mysql'):
        self.pool = self.create_pool(database_server)

    def create_pool(self, database_server: str = 'mysql'):
        if database_server.lower() in ['mysql', 'pymysql']:
            return PooledDB(
                creator=pymysql,
                maxconnections=MAX_USERS,
                maxcached=MAX_USERS,
                maxshared=MAX_USERS,
                blocking=True,
                host=MYSQL_DATABASE['host'],
                port=MYSQL_DATABASE['port'],
                user=MYSQL_DATABASE['user'],
                password=MYSQL_DATABASE['password'],
                charset=MYSQL_DATABASE['charset'],
            )
        elif database_server.lower() in ['mongodb', 'pymongo', 'mongo']:
            return PooledDB(
                creator=pymongo,
                maxconnections=MAX_USERS,
                maxcached=MAX_USERS,
                maxshared=MAX_USERS,
                blocking=True,
                host=MONGODB_DATABASE['host'],
                port=MONGODB_DATABASE['port'],
                user=MONGODB_DATABASE['user'],
                password=MONGODB_DATABASE['password'],
                charset=MONGODB_DATABASE['charset'],
            )


    def connect(self, database: str=None, cursorclass: pymysql.cursors.Cursor=pymysql.cursors.DictCursor):
        connection = self.pool.connection()
        cursor = connection.cursor(cursor=cursorclass)
        if database:
            cursor.execute(f"USE {database}")
        return connection, cursor

    def close(self, connection, cursor):
        cursor.close()
        connection.close()