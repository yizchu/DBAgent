import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from config import *


def text2sql(messages: list[dict]):
    """
    返回 思考内容 和 sql查询语句。
    """
    trial = 3
    while trial:
        try:
            response = DEEPSEEK_CLIENT.chat.completions.create(
                model="deepseek-reasoner",
                messages=messages,
                stream=False
            )
            reasoning_content = response.choices[0].message.reasoning_content
            output_content = response.choices[0].message.content
            sql = output_content.replace("```sql", "").replace("```", "").strip()

            break
        except Exception as e:
            print(f"- Error: text2sql trial {4-trial}, {e}")
            trial -= 1
            if trial == 0:
                raise Exception(" - Error: Text2sql timeout.")

    print("-Success: text2sql")
    return reasoning_content, sql