import os
import sys
from urllib import parse
from pymongo import MongoClient

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config import *

def connect_mongodb() -> MongoClient:
    username = parse.quote_plus(MONGODB_DATABASE['user'])
    password = parse.quote_plus(MONGODB_DATABASE['password'])

    if username and password:
        uri = f"mongodb://{username}:{password}@{MONGODB_DATABASE['host']}:{MONGODB_DATABASE['port']}/"
    elif username and not password:
        uri = f"mongodb://{username}@{MONGODB_DATABASE['host']}:{MONGODB_DATABASE['port']}/"
    else:
        uri = f"mongodb://{MONGODB_DATABASE['host']}:{MONGODB_DATABASE['port']}/"

    return MongoClient(uri)
