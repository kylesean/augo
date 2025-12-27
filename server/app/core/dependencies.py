"""Dependency injection functions for FastAPI endpoints.

This module provides reusable dependency functions for:
- Database session management
- Redis client access
- User authentication
- Session management
"""

from typing import AsyncGenerator, Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select

from app.core.database import get_session
from app.core.logging import bind_context, logger
from app.models.user import User
from app.utils.auth import verify_token

# Security scheme for JWT authentication
security = HTTPBearer()


async def get_redis_client():
    """Get Redis client for caching and session management.

    Yields:
        Redis client instance or None if not configured
    """
    redis_client = None
    try:
        from redis import asyncio as redis_async

        from app.core.config import settings

        redis_client = await redis_async.from_url(
            settings.redis_url,
            encoding="utf-8",
            decode_responses=False,
        )
    except Exception as e:
        logger.warning("redis_connection_init_failed", error=str(e))
        redis_client = None

    try:
        yield redis_client
    finally:
        if redis_client is not None:
            try:
                await redis_client.aclose()
            except Exception:
                pass


async def get_current_user_uuid(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> str:
    """Extract and verify user ID from JWT token.

    Args:
        credentials: HTTP authorization credentials containing JWT token

    Returns:
        str: User UUID from token

    Raises:
        HTTPException: If token is invalid or missing
    """
    try:
        token = credentials.credentials
        user_uuid = verify_token(token)

        if user_uuid is None:
            logger.error("invalid_token", token_part=token[:10] + "...")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )

        return user_uuid

    except ValueError as ve:
        logger.error("token_validation_failed", error=str(ve), exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Invalid token format",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_current_user(
    user_uuid: str = Depends(get_current_user_uuid),
    db: AsyncSession = Depends(get_session),
) -> User:
    """Get the current authenticated user from database.

    Args:
        user_uuid: User UUID from JWT token
        db: Database session

    Returns:
        User: The authenticated user object

    Raises:
        HTTPException: If user not found in database
    """
    try:
        # Query user by UUID
        query = select(User).where(User.uuid == user_uuid)
        result = await db.execute(query)
        user = result.scalar_one_or_none()

        if user is None:
            logger.error("user_not_found", user_uuid=user_uuid)
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found",
                headers={"WWW-Authenticate": "Bearer"},
            )

        # Bind user context for logging
        bind_context(user_uuid=user.uuid)

        return user

    except HTTPException:
        raise
    except Exception as e:
        logger.error("get_current_user_failed", error=str(e), exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to retrieve user information"
        )


async def require_auth(
    user: User = Depends(get_current_user),
) -> User:
    """Require authentication for an endpoint.

    This is an alias for get_current_user that makes the intent clearer
    when used as a dependency.

    Args:
        user: The authenticated user

    Returns:
        User: The authenticated user object
    """
    return user


class OptionalAuth:
    """Optional authentication dependency.

    Returns the user if authenticated, None otherwise.
    Useful for endpoints that work differently for authenticated vs anonymous users.
    """

    async def __call__(
        self,
        credentials: Optional[HTTPAuthorizationCredentials] = Depends(HTTPBearer(auto_error=False)),
        db: AsyncSession = Depends(get_session),
    ) -> Optional[User]:
        """Get current user if authenticated, None otherwise.

        Args:
            credentials: Optional HTTP authorization credentials
            db: Database session

        Returns:
            Optional[User]: User object if authenticated, None otherwise
        """
        if credentials is None:
            return None

        try:
            token = credentials.credentials
            user_uuid = verify_token(token)

            if user_uuid is None:
                return None

            # Query user by UUID
            query = select(User).where(User.uuid == user_uuid)
            result = await db.execute(query)
            user = result.scalar_one_or_none()

            if user:
                bind_context(user_uuid=user.uuid)

            return user

        except Exception as e:
            logger.warning("optional_auth_failed", error=str(e))
            return None


# Create instance for use as dependency
optional_auth = OptionalAuth()


async def get_user_session_data(
    user: User = Depends(get_current_user),
    redis_client=Depends(get_redis_client),
) -> dict:
    """Get user session data from Redis.

    Args:
        user: The authenticated user
        redis_client: Redis client

    Returns:
        dict: Session data or empty dict if not found
    """
    if redis_client is None:
        return {}

    try:
        session_key = f"user_session:{user.uuid}"
        session_data = await redis_client.get(session_key)

        if session_data:
            import json

            return json.loads(session_data.decode())

        return {}

    except Exception as e:
        logger.warning("get_session_data_failed", user_uuid=user.uuid, error=str(e))
        return {}


async def save_user_session_data(
    session_data: dict,
    user: User = Depends(get_current_user),
    redis_client=Depends(get_redis_client),
) -> bool:
    """Save user session data to Redis.

    Args:
        session_data: Data to save in session
        user: The authenticated user
        redis_client: Redis client

    Returns:
        bool: True if saved successfully
    """
    if redis_client is None:
        logger.warning("redis_not_available", message="Session data not saved")
        return False

    try:
        import json

        session_key = f"user_session:{user.uuid}"

        # Store session data with 30-day expiration
        await redis_client.setex(
            session_key,
            30 * 24 * 60 * 60,  # 30 days
            json.dumps(session_data),
        )

        logger.info("session_data_saved", user_uuid=user.uuid)
        return True

    except Exception as e:
        logger.error("save_session_data_failed", user_uuid=user.uuid, error=str(e))
        return False
