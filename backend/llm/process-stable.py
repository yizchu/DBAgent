import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from config import *

def one_chat(messages: list[dict]):
    """
    和 LLM 进行一次对话。
    返回 思考内容 和 回答。
    """
    response = DEEPSEEK_CLIENT.chat.completions.create(
        model="deepseek-reasoner",
        messages=messages,
        stream=False
    )
    reasoning_content = response.choices[0].message.reasoning_content
    output_content = response.choices[0].message.content

    return reasoning_content, output_content