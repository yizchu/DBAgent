import os
import sys
import logging
from datetime import datetime

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from config.paths import BACKEND_ROOT

LOG_DIR = os.path.join(BACKEND_ROOT, 'log')

os.makedirs(LOG_DIR, exist_ok=True)

def get_error_logger(module_name: str) -> logging.Logger:
    logger = logging.getLogger(f"error_{module_name}")

    if not logger.handlers:
        logger.setLevel(logging.ERROR)

        today = datetime.now().strftime("%Y-%m-%d")
        log_file = os.path.join(LOG_DIR, f"error_{module_name}_{today}.log")

        file_handler = logging.FileHandler(log_file, encoding='utf-8')
        file_handler.setLevel(logging.ERROR)

        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        file_handler.setFormatter(formatter)

        logger.addHandler(file_handler)

    return logger

def log_error(module_name: str, route_name: str, error: Exception, **kwargs):
    logger = get_error_logger(module_name)

    error_msg = f"[Route: {route_name}] Error: {str(error)}"
    if kwargs:
        error_msg += f" | Context: {kwargs}"

    logger.error(error_msg, exc_info=True)