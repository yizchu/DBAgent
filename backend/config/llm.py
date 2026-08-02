import os
import sys
from openai import OpenAI

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config.kg import MAX_EXAMPLES
from config.paths import *

DEEPSEEK_CLIENT = OpenAI(
    api_key="<your_api_key>",
    base_url="<api_base_url>",
)

'''
ENTITY_NAME_RULE = """
在知识图谱中，各个分类（包括列colomn、表table、数据库database、统计信息statistic四个label）的实体id是根据以下两条规则生成的：
1、开头是类别（colomn/table/database/statistic），之后紧跟":"，冒号后的内容根据类别不同而不同。
2、对于任意可能的数据库名A、表名B和列名C：
    id为"database:A"的实体代表数据库A，id为"table:A.B"的实体代表数据库A下的表B，id为"colomn:A.B.C"的实体代表数据库A下的表B中的列C。
    id为"statistic:A.."的实体代表数据库A的统计信息，并且该实体一定被id为"database:A"的实体指向。
    id为"statistic:A.B."的实体代表数据库A下的表B的统计信息，并且该实体一定被id为"table:A.B"的实体指向。
    id为"statistic:A.B.C"的实体代表数据库A下的表B中的列C的统计信息，并且该实体一定被id为"colomn:A.B.C"的实体指向。
"""
'''

ENTITY_NAME_RULE = """
在知识图谱中，各个分类（包括列colomn、表table、数据库database三个label）的实体id是根据以下两条规则生成的：
1、开头是类别（colomn/table/database），之后紧跟":"，冒号后的内容根据类别不同而不同。
2、对于任意可能的数据库名A、表名B和列名C：
    id为"database:A"的实体代表数据库A，id为"table:A.B"的实体代表数据库A下的表B，id为"colomn:A.B.C"的实体代表数据库A下的表B中的列C。
"""

# text2sql 系统提示词
def text2sql_SP(kg_info: str):
    return f"""你是一个专业的SQL工程师，你的任务是根据“数据库知识图谱”，将用户的问题转化为精准、可执行的SQL查询语句用于查询mysql数据库。
核心原则：
1. 严格基于由数据库转化而来的知识图谱，严禁幻觉出不存在的表或字段。
2. 生成的SQL可在mysql数据库中成功执行，不会报错，与mysql保留字或特殊字符冲突的表名、列名等标识符应该用反引号包裹起来。
3. 字符串匹配时，一律使用模糊匹配。宁愿多，也不要漏。
4、遇到最值问题时，不能简单做排序然后取前几条，必须考虑到多解的情况。比如查询前几名的数据，可能存在多条记录都是同一名次。
5、生成的SQL应尽可能简洁高效，不含任何注释。除了SQL查询语句，不要输出其他内容。

注意事项：
1. 每月的第一周从每月的第一个周一开始。

“数据库知识图谱”包含实体、实体属性和关系。列实体属性中的"examples"是从原数据库对应列抽取出的一些样本，如果样本只有None一个，则说明该列的所有值都是None。
每个实体属性中的"name"是数据库名或表名或列名，为了区分name相同的不同实体，知识图谱会为每个实体分配一个实体id。
{ENTITY_NAME_RULE}

以下是完整的“数据库知识图谱”：
{kg_info}
"""


def generate_dbdoc_analysis_prompt(database_server: str = "mysql", database_name: str = None, db_doc: str = None):
    """
    生成用于分析数据库文档的提示词
    Parameters:
        database_name (str): 数据库名
        db_doc (str): 数据库文档正文 或 保存路径
    Returns:
        db_doc_analysis_prompt (str): 用于分析数据库文档的提示词
    """
    if database_name:
        db_doc_analysis_prompt = f"""
        以下是名为{database_name}的{database_server}数据库包含的表及列的说明：
        """ .strip() + '\n'
    else:
        db_doc_analysis_prompt = f"""
        以下是当前{database_server}数据库包含的表及列的说明：
        """ .strip() + '\n'

    try:
        with open(db_doc, 'r', encoding='utf-8') as f:
            db_doc_content = f.read()
        print(f' - success: Open file "{db_doc}"')
    except:
        print(f' - notice: db_doc is not a file path, directly use it as db_doc_content.')
        db_doc_content = db_doc
    db_doc_analysis_prompt += db_doc_content

    return db_doc_analysis_prompt
