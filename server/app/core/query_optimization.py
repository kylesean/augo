"""Query optimization utilities for reducing N+1 queries and improving performance.

This module provides utilities for:
- Eager loading relationships to avoid N+1 queries
- Query result caching
- Batch loading utilities
"""

from __future__ import annotations

from typing import Any, TypeVar, cast

from sqlalchemy import Select, desc, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload, selectinload
from sqlmodel import SQLModel

from app.core.cache import cache_manager
from app.core.logging import logger

T = TypeVar("T", bound=SQLModel)


class QueryOptimizer:
    """Utilities for optimizing database queries."""

    @staticmethod
    def with_relationships(query: Select[Any], *relationships: str) -> Select[Any]:
        """Add eager loading for specified relationships.

        This uses selectinload which is efficient for one-to-many relationships.

        Args:
            query: SQLAlchemy select query
            *relationships: Relationship names to eager load

        Returns:
            select: Query with eager loading options

        Example:
            ```python
            query = select(User)
            query = QueryOptimizer.with_relationships(
                query,
                "conversations",
                "financial_accounts"
            )
            result = await session.execute(query)
            users = result.scalars().all()
            # Now users.conversations and users.financial_accounts are loaded
            ```
        """
        for relationship in relationships:
            query = query.options(selectinload(cast(Any, relationship)))
        return query

    @staticmethod
    def with_joined_relationships(query: Select[Any], *relationships: str) -> Select[Any]:
        """Add eager loading using joins for specified relationships.

        This uses joinedload which is efficient for many-to-one relationships.

        Args:
            query: SQLAlchemy select query
            *relationships: Relationship names to eager load with joins

        Returns:
            select: Query with joined loading options

        Example:
            ```python
            query = select(Message)
            query = QueryOptimizer.with_joined_relationships(
                query,
                "conversation",
                "user"
            )
            result = await session.execute(query)
            messages = result.scalars().all()
            # Now messages.conversation and messages.user are loaded
            ```
        """
        for relationship in relationships:
            query = query.options(joinedload(cast(Any, relationship)))
        return query

    @staticmethod
    async def get_with_cache(
        session: AsyncSession,
        model: type[T],
        id_value: Any,
        cache_ttl: int = 300,
        relationships: list[str] | None = None,
    ) -> T | None:
        """Get a model instance by ID with caching.

        Args:
            session: Database session
            model: Model class
            id_value: ID value to lookup
            cache_ttl: Cache TTL in seconds (default: 300)
            relationships: List of relationships to eager load

        Returns:
            Model instance or None if not found

        Example:
            ```python
            user = await QueryOptimizer.get_with_cache(
                session,
                User,
                user_uuid,
                cache_ttl=600,
                relationships=["conversations", "financial_accounts"]
            )
            ```
        """
        cache_key = f"{model.__tablename__}:{id_value}"

        # Try cache first
        cached_data = await cache_manager.get(cache_key)
        if cached_data is not None:
            logger.debug("query_cache_hit", model=model.__name__, id=id_value)
            # Reconstruct model from cached data
            return model.model_validate(cached_data)

        # Cache miss - query database
        logger.debug("query_cache_miss", model=model.__name__, id=id_value)

        query = select(model).where(cast(Any, model).id == id_value)

        # Add eager loading if specified
        if relationships:
            for rel in relationships:
                query = query.options(selectinload(cast(Any, rel)))

        result = await session.execute(query)
        instance = result.scalar_one_or_none()

        # Cache the result
        if instance is not None:
            # Convert to dict for caching
            instance_dict = instance.model_dump()
            await cache_manager.set(cache_key, instance_dict, ttl=cache_ttl)

        return instance

    @staticmethod
    async def invalidate_cache(model: type[SQLModel], id_value: Any) -> bool:
        """Invalidate cache for a specific model instance.

        Args:
            model: Model class
            id_value: ID value

        Returns:
            bool: True if cache was invalidated

        Example:
            ```python
            await QueryOptimizer.invalidate_cache(User, user_uuid)
            ```
        """
        cache_key = f"{model.__tablename__}:{id_value}"
        return await cache_manager.delete(cache_key)

    @staticmethod
    async def batch_get(
        session: AsyncSession,
        model: type[T],
        ids: list[Any],
        relationships: list[str] | None = None,
    ) -> list[T]:
        """Batch get multiple model instances by IDs.

        This is more efficient than multiple individual queries.

        Args:
            session: Database session
            model: Model class
            ids: List of ID values
            relationships: List of relationships to eager load

        Returns:
            List of model instances

        Example:
            ```python
            users = await QueryOptimizer.batch_get(
                session,
                User,
                [1, 2, 3, 4, 5],
                relationships=["conversations"]
            )
            ```
        """
        if not ids:
            return []

        query = select(model).where(cast(Any, model).id.in_(ids))

        # Add eager loading if specified
        if relationships:
            for rel in relationships:
                query = query.options(selectinload(cast(Any, rel)))

        result = await session.execute(query)
        return list(result.scalars().all())


class PaginationHelper:
    """Helper for consistent pagination across queries."""

    @staticmethod
    def paginate_query(
        query: Select[Any],
        page: int = 1,
        per_page: int = 10,
        max_per_page: int = 100,
    ) -> Select[Any]:
        """Add pagination to a query.

        Args:
            query: SQLAlchemy select query
            page: Page number (1-indexed)
            per_page: Items per page
            max_per_page: Maximum items per page (safety limit)

        Returns:
            select: Query with pagination applied

        Example:
            ```python
            query = select(User)
            query = PaginationHelper.paginate_query(query, page=2, per_page=20)
            result = await session.execute(query)
            users = result.scalars().all()
            ```
        """
        # Validate and cap per_page
        per_page = min(max(1, per_page), max_per_page)

        # Validate page number
        page = max(1, page)

        # Calculate offset
        offset = (page - 1) * per_page

        return query.limit(per_page).offset(offset)

    @staticmethod
    async def get_paginated_result(
        session: AsyncSession,
        query: Select[Any],
        page: int = 1,
        per_page: int = 10,
        max_per_page: int = 100,
    ) -> dict[str, Any]:
        """Execute a paginated query and return results with metadata.

        Args:
            session: Database session
            query: SQLAlchemy select query
            page: Page number (1-indexed)
            per_page: Items per page
            max_per_page: Maximum items per page

        Returns:
            dict: Paginated results with metadata
                - items: List of results
                - page: Current page number
                - per_page: Items per page
                - total: Total number of items
                - pages: Total number of pages

        Example:
            ```python
            query = select(User).where(User.is_active == True)
            result = await PaginationHelper.get_paginated_result(
                session,
                query,
                page=1,
                per_page=20
            )
            # result = {
            #     "items": [...],
            #     "page": 1,
            #     "per_page": 20,
            #     "total": 150,
            #     "pages": 8
            # }
            ```
        """
        # Validate and cap per_page
        per_page = min(max(1, per_page), max_per_page)
        page = max(1, page)

        # Get total count (without pagination)
        from sqlalchemy import (
            func,
            select as sa_select,
        )

        # Create a count query from the original query
        count_query = sa_select(func.count()).select_from(query.subquery())
        count_result = await session.execute(count_query)
        total = count_result.scalar() or 0

        # Calculate total pages
        pages = (total + per_page - 1) // per_page if total > 0 else 0

        # Apply pagination
        paginated_query = PaginationHelper.paginate_query(
            query, page=page, per_page=per_page, max_per_page=max_per_page
        )

        # Execute query
        result = await session.execute(paginated_query)
        items = list(result.scalars().all())

        return {
            "items": items,
            "page": page,
            "per_page": per_page,
            "total": total,
            "pages": pages,
        }


# Convenience functions for common patterns


async def get_user_conversations_optimized(
    session: AsyncSession,
    user_uuid: int,
    page: int = 1,
    per_page: int = 10,
) -> dict[str, Any]:
    """Get user's conversations with optimized query.

    This is an example of how to use the optimization utilities.

    Args:
        session: Database session
        user_uuid: User ID
        page: Page number
        per_page: Items per page

    Returns:
        dict: Paginated conversations with metadata
    """
    from app.models.session import Session as ChatSession

    query = (
        select(ChatSession).where(ChatSession.user_uuid == user_uuid).order_by(desc(cast(Any, ChatSession.updated_at)))
    )

    # Add eager loading for messages (optional, depending on use case)

    return await PaginationHelper.get_paginated_result(session, query, page=page, per_page=per_page)


async def get_conversation_with_messages_optimized(
    session: AsyncSession,
    conversation_id: str,
    user_uuid: str,
) -> Any | None:
    """Get conversation with all messages in a single query.

    Args:
        session: Database session
        conversation_id: Conversation ID
        user_uuid: User UUID (for authorization)

    Returns:
        Conversation with messages or None
    """
    from app.models.session import Session as ChatSession

    query = select(ChatSession).where(ChatSession.id == conversation_id).where(ChatSession.user_uuid == user_uuid)

    # Eager load messages and their attachments
    query = QueryOptimizer.with_relationships(query, "messages")

    result = await session.execute(query)
    return result.scalar_one_or_none()


async def get_transactions_with_comments_optimized(
    session: AsyncSession,
    user_uuid: str,
    page: int = 1,
    per_page: int = 20,
) -> dict[str, Any]:
    """Get user's transactions with comments in optimized way.

    Args:
        session: Database session
        user_uuid: User ID
        page: Page number
        per_page: Items per page

    Returns:
        dict: Paginated transactions with metadata
    """
    from app.models.transaction import Transaction

    query = (
        select(Transaction)
        .where(Transaction.user_uuid == user_uuid)
        .order_by(desc(cast(Any, Transaction.transaction_at)))
    )

    # Eager load comments
    query = QueryOptimizer.with_relationships(query, "comments")

    return await PaginationHelper.get_paginated_result(session, query, page=page, per_page=per_page)
