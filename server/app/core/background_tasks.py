"""后台任务管理

提供异步任务执行功能，类似 Hyperf 的 AsyncQueue。

支持两种方式：
1. FastAPI BackgroundTasks - 简单轻量，适合快速任务
2. ARQ (可选) - 基于 Redis 的任务队列，支持重试和持久化
"""

import asyncio
from functools import wraps
from typing import Any, Callable

from app.core.logging import logger


class BackgroundTaskManager:
    """后台任务管理器

    提供统一的后台任务接口，支持多种执行方式。
    """

    @staticmethod
    async def run_in_background(func: Callable[..., Any], *args: Any, **kwargs: Any) -> None:
        """在后台运行任务（fire-and-forget）

        使用 asyncio.create_task 在后台执行任务，不阻塞当前请求。
        适合不需要持久化的轻量级任务。

        Args:
            func: 要执行的异步函数
            *args: 位置参数
            **kwargs: 关键字参数
        """

        async def _wrapped_task() -> None:
            try:
                logger.debug(
                    "background_task_started",
                    function=func.__name__,
                )
                await func(*args, **kwargs)
                logger.debug(
                    "background_task_completed",
                    function=func.__name__,
                )
            except Exception as e:
                logger.error(
                    "background_task_failed",
                    function=func.__name__,
                    error=str(e),
                    exc_info=True,
                )

        # 创建后台任务
        asyncio.create_task(_wrapped_task())

    @staticmethod
    def background_task(func: Callable) -> Callable:
        """装饰器：将函数标记为后台任务

        使用方式:
            @background_task
            async def send_email(to: str, subject: str):
                ...

            # 调用时会自动在后台执行
            await send_email("user@example.com", "Welcome")
        """

        @wraps(func)
        async def wrapper(*args: Any, **kwargs: Any) -> None:
            await BackgroundTaskManager.run_in_background(func, *args, **kwargs)

        return wrapper


# 全局实例
background_task_manager = BackgroundTaskManager()


# ============================================================================
# ARQ 集成（可选）
# ============================================================================

"""
如果需要更强大的任务队列功能（重试、持久化、分布式），可以使用 ARQ。

安装:
    pip install arq

配置 (app/core/config.py):
    REDIS_HOST = "localhost"
    REDIS_PORT = 6379

创建 worker (app/workers/tasks.py):
    from arq import create_pool
    from arq.connections import RedisSettings

    async def send_verification_code(ctx, code_type: str, account: str):
        from app.services.code_manager import code_manager
        await code_manager.send_code(code_type, account)

    class WorkerSettings:
        redis_settings = RedisSettings(host='localhost', port=6379)
        functions = [send_verification_code]

启动 worker:
    arq app.workers.tasks.WorkerSettings

在代码中使用:
    from arq import create_pool
    from arq.connections import RedisSettings

    redis = await create_pool(RedisSettings())
    await redis.enqueue_job('send_verification_code', 'email', 'user@example.com')
"""


# ============================================================================
# Celery 集成（可选）
# ============================================================================

"""
如果需要企业级任务队列，可以使用 Celery。

安装:
    pip install celery[redis]

配置 (celery_app.py):
    from celery import Celery

    celery_app = Celery(
        'tasks',
        broker='redis://localhost:6379/0',
        backend='redis://localhost:6379/0'
    )

    @celery_app.task
    def send_verification_code_task(code_type: str, account: str):
        # 注意：Celery 任务必须是同步的，或使用 celery-aio
        import asyncio
        from app.services.code_manager import code_manager
        asyncio.run(code_manager.send_code(code_type, account))

启动 worker:
    celery -A celery_app worker --loglevel=info

在代码中使用:
    from celery_app import send_verification_code_task
    send_verification_code_task.delay('email', 'user@example.com')
"""
