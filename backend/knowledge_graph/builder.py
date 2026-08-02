import os
import sys
import json

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from knowledge_graph.attribute_extractor import *
from knowledge_graph.relationship_extractor import *
from db import *
from config import *

class KnowledgeGraph:
    def __init__(self, database_name: str):
        self.database_name = database_name
        self.entities = {
            'database': set(),
            'table': set(),
            'column': set(),
        }
        self.relationships = []
        self.attributes = {}

    def add_entity(self, entity_id: str, entity_classification: str):
        """添加实体
        Args:
            entity_id: 实体
            entity_classification: database, table, column
        """
        self.entities[entity_classification].add(entity_id)

    def add_relationship(self, source_id, target_id, relation):
        """添加关系 source_id -[relation]-> target_id \n
        读作 source_id 以 relation 关系指向 target_id
        Args:
            source_id: 源实体，指向目标实体
            target_id: 目标实体，被源实体指向
            relation: has_table, has_column, foreign_key
        """
        self.relationships.append({
            'source': source_id,
            'target': target_id,
            'source-to-target relation': relation
        })

    def get_relationships(self, entity_id, relationship_type=None):
        """获取实体的所有关系
        """
        result = []
        for rel in self.relationships:
            if rel['source'] == entity_id or rel['target'] == entity_id:
                if relationship_type is None or rel['source-to-target relation'] == relationship_type:
                    result.append(rel)
        return result

    def generate_kginfo(self) -> str:
        """
        Returns:
            kg_info = f'''
            id为 {entity_id} 的实体属性: {attribute.model_dump()} , \n
            ...... \n
            source -[relationship]-> target , \n
            ...... \n
            '''
        """
        kg_info = ""

        for entity, attribute in self.attributes.items():
            kg_info += f"id为 {entity} 的实体属性: {attribute.model_dump()}\n"
        for relationship in self.relationships:
            kg_info += f"{relationship['source']} -[{relationship['source-to-target relation']}]-> {relationship['target']}\n"

        with open("temp_kginfo.txt", "w", encoding="utf-8") as f:
            f.write(kg_info)

        return kg_info


class KnowledgeGraphBuilder:
    def __init__(self, database_name: str, pool: ConnectionPool = ConnectionPool()):
        self.kg = KnowledgeGraph(database_name)
        self.pool = pool

    def build_entities_from_one_table(self, table_name: str):
        """
        构建单一表及表下所有列的实体。\n
        连接数据库提取属性。
        """
        table_entity_id = f"table:{self.kg.database_name}.{table_name}"
        self.kg.add_entity(table_entity_id, 'table')

        table_attributes = get_table_attributes(self.kg.database_name, table_name, self.pool)
        self.kg.attributes[table_entity_id] = table_attributes

        col_attributes = get_col_attributes(self.kg.database_name, table_name, self.pool)
        for col_entity_id, col_attribute in col_attributes.items():
            self.kg.add_entity(col_entity_id, 'column')
            self.kg.attributes[col_entity_id] = col_attribute

        # 构建表与列关系
        table_col_relationships = generate_table_col_relationships(self.kg.database_name, table_name, self.pool)
        self.kg.relationships.extend(table_col_relationships)

    def build_entities_from_database(self, get_foreign_keys: bool = True, get_hidden_relationships: bool = True):
        """
        构建单一数据库下所有表及表下所有列的实体。\n
        连接数据库提取属性和关系（数据库与表的关系、表与列的关系、跨表的列与列关系）。
        """
        connection, cursor = self.pool.connect(database=self.kg.database_name)
        print(f" - Success: Connect to {self.kg.database_name}.")

        db_entity_id = f"database:{self.kg.database_name}"
        self.kg.add_entity(db_entity_id, "database")

        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        print(f"There are {len(tables)} tables in database:{self.kg.database_name}.")

        for table in tables:
            table_name = list(table.values())[0]
            table_entity_id = f"table:{self.kg.database_name}.{table_name}"
            self.build_entities_from_one_table(table_name)
            self.kg.add_relationship(db_entity_id, table_entity_id, "has_table")

        # 构建跨表的列与列关系（外键关系）
        if get_foreign_keys:
            col_relationships = get_crosstable_col_relationships(self.kg.database_name, self.pool)
            self.kg.relationships.extend(col_relationships)

        # 调用大模型发现隐藏的列与列关系（外键关系）
        if get_hidden_relationships:
            col_relationships = explore_crosstable_col_relationships(self.kg.generate_kginfo(), self.kg.database_name, self.pool)
            self.kg.relationships.extend(col_relationships)

        if 'connection' in locals() and 'cursor' in locals():
            self.pool.close(connection, cursor)

    def parse_db_doc(self, db_doc: str):
        """
        优先用从数据库中获取的属性信息，如果build的时候没有获取到，则用db_doc中的信息补充。
        Todo
        """
        pass

    def save_to_mongodb(self, mongodb_database_name: str):
        client = connect_mongodb()
        print(f" - Success: Connect to MongoDB.")
        if mongodb_database_name not in client.list_database_names():
            client.admin.command("create", mongodb_database_name)
            print(f" - Success: Create MongoDB database '{mongodb_database_name}'.")
        db = client[mongodb_database_name]
        db_tables = list(self.kg.entities.keys()) + ['relationships']

        for db_table in db_tables:
            if db_table in db.list_collection_names():
                db[db_table].delete_many({})

        for entity_type in self.kg.entities:
            collection = db[entity_type]
            collection.create_index('entity_id', unique=True)
            for entity_id in self.kg.entities[entity_type]:
                row = {'entity_id': entity_id}
                if entity_id in self.kg.attributes:
                    row.update(self.kg.attributes[entity_id])
                collection.insert_one(row)
            print(f"{Tab}Saved {len(self.kg.entities[entity_type])} {entity_type} entities.")

        collection = db['relationships']
        collection.insert_many(self.kg.relationships)
        print(f"{Tab}Saved {len(self.kg.relationships)} relationships.")

        client.close()

        db_json = os.path.join(BACKEND_ROOT, 'config/db.json')
        if not os.path.exists(db_json):
            with open(db_json, 'w', encoding='utf-8') as f:
                json.dump({"DB_KG": {}, "KG_DB": {}}, f, ensure_ascii=False, indent=4)
        with open(db_json, 'r', encoding='utf-8') as f:
            db_info = json.load(f)
        db_info['DB_KG'][self.kg.database_name] = mongodb_database_name
        db_info['KG_DB'][mongodb_database_name] = self.kg.database_name
        with open(db_json, 'w', encoding='utf-8') as f:
            json.dump(db_info, f, indent=4, ensure_ascii=False)

    def build_from_mongodb(self, mongodb_database_name: str, silent: bool = False):
        client = connect_mongodb()
        if not silent:
            print(f" - Success: Connect to MongoDB.")
        db = client[mongodb_database_name]

        for entity_type in self.kg.entities:
            collection = db[entity_type]
            for row in collection.find():
                entity_id = row['entity_id']
                self.kg.add_entity(entity_id, entity_type)
                attribute = {k: v for k, v in row.items() if k not in ['_id', 'entity_id']}
                if attribute:
                    if entity_type == "table":
                        attribute = TableAttribute(**attribute)
                    elif entity_type == "column":
                        attribute = ColumnAttribute(**attribute)
                    self.kg.attributes[entity_id] = attribute
            if not silent:
                print(f"{Tab}Loaded {collection.count_documents({})} {entity_type} entities.")

        collection = db['relationships']
        for row in collection.find():
            self.kg.relationships.append(row)
        if not silent:
            print(f"{Tab}Loaded {collection.count_documents({})} relationships.")

        client.close()


if __name__ == "__main__":
    builder = KnowledgeGraphBuilder("cre_Doc_and_collections")
    builder.build_entities_from_database(get_foreign_keys=False)
    builder.save_to_mongodb("kgfb:cre_Doc_and_collections")

    # 再从mongodb中读取数据构建知识图谱检查是否和存入的一致
    #builder_ = KnowledgeGraphBuilder("pilot_1")
    #builder_.build_from_mongodb("kg:pilot_1")
    #assert builder.kg.entities == builder_.kg.entities, "Knowledge Graph entities are not consistent."
    #assert builder.kg.attributes == builder_.kg.attributes, "Knowledge Graph attributes are not consistent."
    #assert builder.kg.relationships == builder_.kg.relationships, "Knowledge Graph relationships are not consistent."
    #print("Knowledge Graph is consistent.")

    print(builder.kg.generate_kginfo())