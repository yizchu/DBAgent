import sqlite3

def connect_sqlite(sqlite_db_path: str):
    connection = sqlite3.connect(sqlite_db_path)
    cursor = connection.cursor()
    return connection, cursor


if __name__ == '__main__':
    connection, cursor = connect_sqlite("C:\\cza\\python_work\\python projects\\DBAgent\\backend\\db\\spider_data\\test_database\\vehicle_rent\\vehicle_rent.sqlite")
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    print(tables)
    print(f"There are {len(tables)} tables.")