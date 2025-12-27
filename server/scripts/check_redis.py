import os
import sys

import redis

# Add parent directory to path to import app
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from app.core.config import settings

    print(f"Connecting to Redis at {settings.REDIS_HOST}:{settings.REDIS_PORT} (DB: {settings.REDIS_DB})...")

    r = redis.Redis(
        host=settings.REDIS_HOST,
        port=settings.REDIS_PORT,
        db=settings.REDIS_DB,
        password=settings.REDIS_PASSWORD,
        socket_connect_timeout=5,
    )

    if r.ping():
        print("Redis connection successful!")
        sys.exit(0)
    else:
        print("\033[91mError: Redis ping failed.\033[0m")
        sys.exit(1)

except Exception as e:
    error_msg = str(e)
    print(f"\033[91mError: Could not connect to Redis server. {error_msg}\033[0m")
    sys.exit(1)
