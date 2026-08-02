import os
from pathlib import Path

BACKEND_ROOT = Path(__file__).resolve().parent.parent

HISTORY_ROOT = BACKEND_ROOT / 'history'
DB_JSON_PATH = BACKEND_ROOT / 'config' / 'db.json'

EVAL_RESULT_PATH = BACKEND_ROOT / 'eval'

def get_user_history_root(user_id):
    user_history_root = os.path.join(HISTORY_ROOT, user_id)
    os.makedirs(user_history_root, exist_ok=True)
    return user_history_root