"""Database connection and session management (SQLAlchemy + asyncpg).

This module provides async SQLAlchemy engine, session management, and database utilities
for ORM operations (User, Transaction, Session, etc.).

Note: This is SEPARATE from pg_pool.py which uses psycopg3 for LangGraph checkpointer.
The two pools connect to the same database but use different drivers:
- database.py: SQLAlchemy + asyncpg (for ORM)
- pg_pool.py: psycopg3 (for LangGraph, required by AsyncPostgresSaver)
"""

from __future__ import annotations

import uuid
from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager
from typing import TYPE_CHECKING, Any, cast

from sqlalchemy import delete, desc, select, text
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.pool import NullPool
from sqlmodel import SQLModel

from app.core.config import settings
from app.core.logging import logger


class DatabaseManager:
    """Manages database connections and sessions."""

    def __init__(self) -> None:
        """Initialize database manager with engine and session factory."""
        self._engine: AsyncEngine | None = None
        self._session_factory: async_sessionmaker[AsyncSession] | None = None

    def init_engine(self) -> AsyncEngine:
        """Initialize async SQLAlchemy engine with connection pooling.

        Returns:
            AsyncEngine: Configured async database engine
        """
        if self._engine is not None:
            return self._engine

        # Configure connection pool based on environment
        # For async engines, SQLAlchemy 2.0+ uses NullPool by default with asyncpg
        # This is the recommended approach for async operations
        pool_kwargs = {
            "poolclass": NullPool,  # Use NullPool for async engines
            "echo": False,  # Disable SQL query logging
        }

        self._engine = create_async_engine(
            settings.database_url,
            **pool_kwargs,
        )

        logger.info(
            "database_engine_initialized",
            host=settings.POSTGRES_HOST,
            database=settings.POSTGRES_DB,
            pool_size=settings.POSTGRES_POOL_SIZE,
        )

        return self._engine

    def init_session_factory(self) -> async_sessionmaker[AsyncSession]:
        """Initialize session factory for creating database sessions.

        Returns:
            async_sessionmaker: Session factory for creating async sessions
        """
        if self._session_factory is not None:
            return self._session_factory

        if self._engine is None:
            self.init_engine()

        self._session_factory = async_sessionmaker(
            bind=self._engine,
            class_=AsyncSession,
            expire_on_commit=False,  # Don't expire objects after commit
            autocommit=False,
            autoflush=False,
        )

        logger.info("database_session_factory_initialized")

        return self._session_factory

    @property
    def engine(self) -> AsyncEngine:
        """Get the database engine, initializing if necessary."""
        if self._engine is None:
            return self.init_engine()
        return self._engine

    @property
    def session_factory(self) -> async_sessionmaker[AsyncSession]:
        """Get the session factory, initializing if necessary."""
        if self._session_factory is None:
            return self.init_session_factory()
        return self._session_factory

    async def create_tables(self) -> None:
        """Create all database tables defined in SQLModel metadata."""
        async with self.engine.begin() as conn:
            await conn.run_sync(SQLModel.metadata.create_all)
        logger.info("database_tables_created")

    async def drop_tables(self) -> None:
        """Drop all database tables. Use with caution!"""
        async with self.engine.begin() as conn:
            await conn.run_sync(SQLModel.metadata.drop_all)
        logger.warning("database_tables_dropped")

    async def close(self) -> None:
        """Close database engine and cleanup connections."""
        if self._engine is not None:
            await self._engine.dispose()
            logger.info("database_engine_closed")
            self._engine = None
            self._session_factory = None

    async def health_check(self) -> bool:
        """Check database connectivity and health.

        Returns:
            bool: True if database is healthy, False otherwise
        """
        try:
            async with self.session_factory() as session:
                # Execute a simple query to verify connection
                result = await session.execute(text("SELECT 1"))
                result.scalar()
            return True
        except Exception as e:
            logger.error("database_health_check_failed", error=str(e), exc_info=True)
            return False


# Global database manager instance
db_manager = DatabaseManager()


async def get_session() -> AsyncGenerator[AsyncSession]:
    """Dependency for getting async database sessions.

    Yields:
        AsyncSession: Async database session

    Example:
        ```python
        @app.get("/users")
        async def get_users(session: AsyncSession = Depends(get_session)):
            result = await session.execute(select(User))
            return result.scalars().all()
        ```
    """
    session = db_manager.session_factory()
    try:
        yield session
    except Exception:
        await session.rollback()
        raise
    else:
        await session.commit()
    finally:
        await session.close()


@asynccontextmanager
async def get_session_context() -> AsyncGenerator[AsyncSession]:
    """Context manager for getting async database sessions.

    Yields:
        AsyncSession: Async database session

    Example:
        ```python
        async with get_session_context() as session:
            result = await session.execute(select(User))
            users = result.scalars().all()
        ```
    """
    async with db_manager.session_factory() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()


async def init_db() -> None:
    """Initialize database on application startup."""
    db_manager.init_engine()
    db_manager.init_session_factory()

    # Check database health
    is_healthy = await db_manager.health_check()
    if not is_healthy:
        logger.error("database_initialization_failed")
        raise RuntimeError("Failed to connect to database")

    logger.info("database_initialized_successfully")


async def close_db() -> None:
    """Close database connections on application shutdown."""
    await db_manager.close()


# ============================================================================
# Session Repository - Async CRUD for ChatSession
# ============================================================================


class SessionRepository:
    """Repository for ChatSession CRUD operations.

    Provides async database operations for session management.
    Uses dependency injection pattern - receives session in constructor.

    Example:
        ```python
        async with get_session_context() as db:
            repo = SessionRepository(db)
            session = await repo.create(session_id, user_uuid)
        ```
    """

    def __init__(self, db: AsyncSession):
        """Initialize repository with database session.

        Args:
            db: Async database session
        """
        self.db = db

    async def create(
        self,
        session_id: uuid.UUID,
        user_uuid: uuid.UUID,
        name: str = "",
    ) -> ChatSession:
        """Create a new chat session.

        Args:
            session_id: Unique session identifier
            user_uuid: Owner's UUID
            name: Optional session name (defaults to empty string)

        Returns:
            ChatSession: The created session
        """
        from app.models.session import Session as ChatSession

        chat_session = ChatSession(
            id=session_id,
            user_uuid=user_uuid,
            name=name,
        )
        self.db.add(chat_session)
        await self.db.commit()
        await self.db.refresh(chat_session)

        logger.info(
            "session_created",
            session_id=session_id,
            user_uuid=user_uuid,
            name=name,
        )

        return chat_session

    async def get(
        self,
        session_id: uuid.UUID,
    ) -> ChatSession | None:
        """Get a session by ID.

        Args:
            session_id: Session identifier

        Returns:
            ChatSession if found, None otherwise
        """
        from app.models.session import Session as ChatSession

        result = await self.db.execute(select(ChatSession).where(ChatSession.id == session_id))
        return result.scalar_one_or_none()

    async def get_by_user(
        self,
        user_uuid: uuid.UUID,
    ) -> list[ChatSession]:
        """Get all sessions for a user.

        Args:
            user_uuid: User's UUID

        Returns:
            List of ChatSession objects
        """
        from app.models.session import Session as ChatSession

        result = await self.db.execute(
            select(ChatSession)
            .where(ChatSession.user_uuid == user_uuid)
            .order_by(cast(Any, ChatSession.created_at).desc())
        )
        return list(result.scalars().all())

    async def update_name(
        self,
        session_id: uuid.UUID,
        name: str,
    ) -> ChatSession | None:
        """Update a session's name.

        Args:
            session_id: Session identifier
            name: New session name

        Returns:
            Updated ChatSession if found, None otherwise
        """
        from app.models.session import Session as ChatSession

        result = await self.db.execute(select(ChatSession).where(ChatSession.id == session_id))
        chat_session = result.scalar_one_or_none()

        if chat_session:
            chat_session.name = name
            await self.db.commit()
            await self.db.refresh(chat_session)

            logger.info(
                "session_name_updated",
                session_id=session_id,
                name=name,
            )

        return chat_session

    async def delete(
        self,
        session_id: uuid.UUID,
    ) -> bool:
        """Delete a session by ID.

        Args:
            session_id: Session identifier

        Returns:
            True if deleted, False if not found
        """
        from app.models.session import Session as ChatSession

        result = await self.db.execute(delete(ChatSession).where(ChatSession.id == session_id))
        await self.db.commit()

        deleted = bool(getattr(result, "rowcount", 0) > 0)
        if deleted:
            logger.info("session_deleted", session_id=session_id)

        return deleted


# Type hint for forward reference
if TYPE_CHECKING:
    from app.models.session import Session as ChatSession
