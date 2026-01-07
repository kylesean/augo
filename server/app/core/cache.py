"""Redis caching service with decorators and utilities.

This module provides Redis connection management, caching decorators,
and cache invalidation strategies for the application.
"""

import functools
import json
import pickle
from collections.abc import Callable
from typing import Any, cast

from redis.asyncio import Redis
from redis.asyncio.connection import ConnectionPool

from app.core.config import settings
from app.core.logging import logger


class CacheManager:
    """Manages Redis connections and caching operations."""

    def __init__(self) -> None:
        """Initialize cache manager."""
        self._pool: ConnectionPool | None = None
        self._redis: Redis | None = None

    def init_pool(self) -> ConnectionPool:
        """Initialize Redis connection pool.

        Returns:
            ConnectionPool: Configured Redis connection pool
        """
        if self._pool is not None:
            return self._pool

        self._pool = ConnectionPool.from_url(
            settings.redis_url,
            max_connections=settings.REDIS_POOL_SIZE,
            decode_responses=False,  # We'll handle encoding/decoding
            socket_keepalive=True,
            socket_connect_timeout=5,
            retry_on_timeout=True,
        )

        logger.info(
            "redis_pool_initialized",
            host=settings.REDIS_HOST,
            port=settings.REDIS_PORT,
            pool_size=settings.REDIS_POOL_SIZE,
        )

        return self._pool

    def get_client(self) -> Redis:
        """Get Redis client instance.

        Returns:
            Redis: Redis client instance
        """
        if self._redis is None:
            if self._pool is None:
                self.init_pool()
            self._redis = Redis(connection_pool=self._pool)

        return self._redis

    async def close(self) -> None:
        """Close Redis connections and cleanup."""
        if self._redis is not None:
            await self._redis.aclose()
            self._redis = None

        if self._pool is not None:
            await self._pool.aclose()
            self._pool = None

        logger.info("redis_connections_closed")

    async def health_check(self) -> bool:
        """Check Redis connectivity and health.

        Returns:
            bool: True if Redis is healthy, False otherwise
        """
        try:
            client = self.get_client()
            await cast(Any, client.ping())
            return True
        except Exception as e:
            logger.error("redis_health_check_failed", error=str(e))
            return False

    async def get(self, key: str, deserialize: bool = True) -> Any:
        """Get value from cache.

        Args:
            key: Cache key
            deserialize: Whether to deserialize the value (default: True)

        Returns:
            Cached value or None if not found
        """
        try:
            client = self.get_client()
            value = await client.get(key)

            if value is None:
                return None

            if deserialize:
                try:
                    # Try JSON first (for simple types)
                    return json.loads(value)
                except (json.JSONDecodeError, TypeError):
                    # Fall back to pickle for complex objects
                    return pickle.loads(value)

            return value

        except Exception as e:
            logger.error("cache_get_failed", key=key, error=str(e))
            return None

    async def set(
        self,
        key: str,
        value: Any,
        ttl: int | None = None,
        serialize: bool = True,
    ) -> bool:
        """Set value in cache.

        Args:
            key: Cache key
            value: Value to cache
            ttl: Time to live in seconds (None = no expiration)
            serialize: Whether to serialize the value (default: True)

        Returns:
            bool: True if successful, False otherwise
        """
        try:
            client = self.get_client()

            if serialize:
                try:
                    # Try JSON first (for simple types)
                    serialized_value: str | bytes = json.dumps(value)
                except (TypeError, ValueError):
                    # Fall back to pickle for complex objects
                    serialized_value = pickle.dumps(value)
            else:
                serialized_value = value

            if ttl:
                await client.setex(key, ttl, serialized_value)
            else:
                await client.set(key, serialized_value)

            logger.debug("cache_set", key=key, ttl=ttl)
            return True

        except Exception as e:
            logger.error("cache_set_failed", key=key, error=str(e))
            return False

    async def delete(self, key: str) -> bool:
        """Delete key from cache.

        Args:
            key: Cache key to delete

        Returns:
            bool: True if key was deleted, False otherwise
        """
        try:
            client = self.get_client()
            result = await client.delete(key)
            logger.debug("cache_delete", key=key, deleted=bool(result))
            return bool(result)
        except Exception as e:
            logger.error("cache_delete_failed", key=key, error=str(e))
            return False

    async def delete_pattern(self, pattern: str) -> int:
        """Delete all keys matching a pattern.

        Args:
            pattern: Redis key pattern (e.g., "user:*")

        Returns:
            int: Number of keys deleted
        """
        try:
            client = self.get_client()
            keys = []
            async for key in client.scan_iter(match=pattern):
                keys.append(key)

            if keys:
                deleted = await client.delete(*keys)
                logger.info("cache_pattern_delete", pattern=pattern, count=deleted)
                return int(deleted)

            return 0

        except Exception as e:
            logger.error("cache_pattern_delete_failed", pattern=pattern, error=str(e))
            return 0

    async def exists(self, key: str) -> bool:
        """Check if key exists in cache.

        Args:
            key: Cache key

        Returns:
            bool: True if key exists, False otherwise
        """
        try:
            client = self.get_client()
            result = await client.exists(key)
            return bool(result)
        except Exception as e:
            logger.error("cache_exists_failed", key=key, error=str(e))
            return False

    async def increment(self, key: str, amount: int = 1) -> int | None:
        """Increment a counter in cache.

        Args:
            key: Cache key
            amount: Amount to increment by (default: 1)

        Returns:
            New value after increment, or None on error
        """
        try:
            client = self.get_client()
            result = await client.incrby(key, amount)
            return int(result)
        except Exception as e:
            logger.error("cache_increment_failed", key=key, error=str(e))
            return None

    async def expire(self, key: str, ttl: int) -> bool:
        """Set expiration time for a key.

        Args:
            key: Cache key
            ttl: Time to live in seconds

        Returns:
            bool: True if successful, False otherwise
        """
        try:
            client = self.get_client()
            result = await client.expire(key, ttl)
            return bool(result)
        except Exception as e:
            logger.error("cache_expire_failed", key=key, error=str(e))
            return False


# Global cache manager instance
cache_manager = CacheManager()


def cache_key(*args: Any, **kwargs: Any) -> str:
    """Generate cache key from function arguments.

    Args:
        *args: Positional arguments
        **kwargs: Keyword arguments

    Returns:
        str: Generated cache key
    """
    # Filter out non-serializable arguments
    serializable_args = []
    for arg in args:
        if isinstance(arg, (str, int, float, bool, type(None))):
            serializable_args.append(str(arg))

    serializable_kwargs = {k: str(v) for k, v in kwargs.items() if isinstance(v, (str, int, float, bool, type(None)))}

    key_parts = serializable_args + [f"{k}={v}" for k, v in sorted(serializable_kwargs.items())]
    return ":".join(key_parts)


def cached(
    ttl: int | None = 300,
    key_prefix: str | None = None,
    key_builder: Callable[..., str] | None = None,
) -> Callable[[Callable], Callable]:
    """Decorator for caching function results.

    Args:
        ttl: Time to live in seconds (default: 300, None = no expiration)
        key_prefix: Prefix for cache key (default: function name)
        key_builder: Custom function to build cache key from arguments

    Example:
        ```python
        @cached(ttl=600, key_prefix="user")
        async def get_user(user_uuid: str):
            # Expensive database query
            return user

        # Cache key will be: "user:123"
        user = await get_user(123)
        ```
    """

    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        async def wrapper(*args: Any, **kwargs: Any) -> Any:
            # Build cache key
            if key_builder:
                key = key_builder(*args, **kwargs)
            else:
                prefix = key_prefix or func.__name__
                suffix = cache_key(*args, **kwargs)
                key = f"{prefix}:{suffix}" if suffix else prefix

            # Try to get from cache
            cached_value = await cache_manager.get(key)
            if cached_value is not None:
                logger.debug("cache_hit", key=key, function=func.__name__)
                return cached_value

            # Cache miss - execute function
            logger.debug("cache_miss", key=key, function=func.__name__)
            result = await func(*args, **kwargs)

            # Store in cache
            if result is not None:
                await cache_manager.set(key, result, ttl=ttl)

            return result

        return wrapper

    return decorator


def cache_invalidate(key_pattern: str) -> Callable[[Callable], Callable]:
    """Decorator for invalidating cache after function execution.

    Args:
        key_pattern: Redis key pattern to invalidate (e.g., "user:*")

    Example:
        ```python
        @cache_invalidate("user:*")
        async def update_user(user_uuid: str, data: dict):
            # Update user in database
            return updated_user
        ```
    """

    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        async def wrapper(*args: Any, **kwargs: Any) -> Any:
            result = await func(*args, **kwargs)

            # Invalidate cache after successful execution
            deleted = await cache_manager.delete_pattern(key_pattern)
            logger.info("cache_invalidated", pattern=key_pattern, count=deleted, function=func.__name__)

            return result

        return wrapper

    return decorator


async def init_cache() -> None:
    """Initialize Redis cache on application startup."""
    cache_manager.init_pool()

    # Check Redis health
    is_healthy = await cache_manager.health_check()
    if not is_healthy:
        logger.warning("redis_initialization_failed_continuing_without_cache")
        # Don't raise error - allow app to run without cache
    else:
        logger.info("redis_initialized_successfully")


async def close_cache() -> None:
    """Close Redis connections on application shutdown."""
    await cache_manager.close()
