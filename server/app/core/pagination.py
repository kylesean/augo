"""Unified pagination and streaming utilities.

This module provides:
- Standardized pagination response format
- Cursor-based pagination for large datasets
- Streaming utilities for large result sets
- Pagination schemas for API responses
"""

from __future__ import annotations

from collections.abc import AsyncGenerator
from typing import Any, TypeVar

from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy import Select, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.logging import logger

T = TypeVar("T")


class PaginationParams(BaseModel):
    """Standard pagination parameters.

    Attributes:
        page: Page number (1-indexed)
        per_page: Items per page
        max_per_page: Maximum items per page (safety limit)
    """

    page: int = Field(default=1, ge=1, description="Page number (1-indexed)")
    per_page: int = Field(default=10, ge=1, le=100, description="Items per page")

    @property
    def offset(self) -> int:
        """Calculate offset for SQL query.

        Returns:
            int: Offset value
        """
        return (self.page - 1) * self.per_page

    @property
    def limit(self) -> int:
        """Get limit for SQL query.

        Returns:
            int: Limit value
        """
        return self.per_page


class PaginationMeta(BaseModel):
    """Pagination metadata.

    Attributes:
        page: Current page number
        per_page: Items per page
        total: Total number of items
        pages: Total number of pages
        has_next: Whether there is a next page
        has_prev: Whether there is a previous page
    """

    page: int = Field(description="Current page number")
    per_page: int = Field(description="Items per page")
    total: int = Field(description="Total number of items")
    pages: int = Field(description="Total number of pages")
    has_next: bool = Field(description="Whether there is a next page")
    has_prev: bool = Field(description="Whether there is a previous page")


class PaginatedResponse[T](BaseModel):
    """Generic paginated response.

    Attributes:
        items: List of items for current page
        meta: Pagination metadata
    """

    items: list[T] = Field(description="List of items")
    meta: PaginationMeta = Field(description="Pagination metadata")

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "items": [{"id": 1, "name": "Item 1"}, {"id": 2, "name": "Item 2"}],
                "meta": {
                    "page": 1,
                    "per_page": 10,
                    "total": 25,
                    "pages": 3,
                    "has_next": True,
                    "has_prev": False,
                },
            }
        }
    )


class CursorPaginationParams(BaseModel):
    """Cursor-based pagination parameters.

    Cursor-based pagination is more efficient for large datasets
    and real-time data where offset-based pagination can be slow.

    Attributes:
        cursor: Cursor value (typically an ID or timestamp)
        limit: Number of items to return
        direction: Direction to paginate ('next' or 'prev')
    """

    cursor: str | None = Field(default=None, description="Cursor value")
    limit: int = Field(default=10, ge=1, le=100, description="Number of items")
    direction: str = Field(default="next", pattern="^(next|prev)$", description="Pagination direction")


class CursorPaginationMeta(BaseModel):
    """Cursor pagination metadata.

    Attributes:
        next_cursor: Cursor for next page
        prev_cursor: Cursor for previous page
        has_next: Whether there is a next page
        has_prev: Whether there is a previous page
        count: Number of items in current page
    """

    next_cursor: str | None = Field(default=None, description="Cursor for next page")
    prev_cursor: str | None = Field(default=None, description="Cursor for previous page")
    has_next: bool = Field(description="Whether there is a next page")
    has_prev: bool = Field(description="Whether there is a previous page")
    count: int = Field(description="Number of items in current page")


class CursorPaginatedResponse[T](BaseModel):
    """Generic cursor-paginated response.

    Attributes:
        items: List of items
        meta: Cursor pagination metadata
    """

    items: list[T] = Field(description="List of items")
    meta: CursorPaginationMeta = Field(description="Cursor pagination metadata")


async def paginate(
    session: AsyncSession,
    query: Select[Any],
    params: PaginationParams,
) -> PaginatedResponse[Any]:
    """Execute paginated query and return standardized response.

    Args:
        session: Database session
        query: SQLAlchemy select query
        params: Pagination parameters

    Returns:
        PaginatedResponse: Paginated results with metadata

    Example:
        ```python
        from sqlalchemy import select
        from app.models.user import User

        query = select(User).where(User.is_active == True)
        params = PaginationParams(page=1, per_page=20)
        result = await paginate(session, query, params)
        ```
    """
    # Get total count
    count_query = select(func.count()).select_from(query.subquery())
    count_result = await session.execute(count_query)
    total = count_result.scalar() or 0

    # Calculate pagination metadata
    pages = (total + params.per_page - 1) // params.per_page if total > 0 else 0
    has_next = params.page < pages
    has_prev = params.page > 1

    # Apply pagination to query
    paginated_query = query.limit(params.limit).offset(params.offset)

    # Execute query
    result = await session.execute(paginated_query)
    items = list(result.scalars().all())

    # Build response
    meta = PaginationMeta(
        page=params.page,
        per_page=params.per_page,
        total=total,
        pages=pages,
        has_next=has_next,
        has_prev=has_prev,
    )

    return PaginatedResponse(items=items, meta=meta)


async def paginate_cursor(
    session: AsyncSession,
    query: Select[Any],
    params: CursorPaginationParams,
    cursor_field: str = "id",
) -> CursorPaginatedResponse[Any]:
    """Execute cursor-based paginated query.

    Args:
        session: Database session
        query: SQLAlchemy select query
        params: Cursor pagination parameters
        cursor_field: Field to use as cursor (default: "id")

    Returns:
        CursorPaginatedResponse: Cursor-paginated results with metadata

    Example:
        ```python
        from sqlalchemy import select
        from app.models.conversation import Conversation

        query = select(Conversation).where(Conversation.user_uuid == user_uuid)
        params = CursorPaginationParams(cursor=None, limit=20)
        result = await paginate_cursor(session, query, params, cursor_field="created_at")
        ```
    """
    # Apply cursor filter if provided
    if params.cursor:
        # Parse cursor (in real implementation, you might want to encode/decode)
        cursor_value = params.cursor

        if params.direction == "next":
            query = query.where(getattr(query.column_descriptions[0]["entity"], cursor_field) > cursor_value)
        else:  # prev
            query = query.where(getattr(query.column_descriptions[0]["entity"], cursor_field) < cursor_value)

    # Fetch one extra item to determine if there are more pages
    fetch_limit = params.limit + 1
    paginated_query = query.limit(fetch_limit)

    # Execute query
    result = await session.execute(paginated_query)
    items = list(result.scalars().all())

    # Determine if there are more pages
    has_more = len(items) > params.limit
    if has_more:
        items = items[: params.limit]

    # Build cursors
    next_cursor = None
    prev_cursor = None

    if items:
        if params.direction == "next":
            has_next = has_more
            has_prev = params.cursor is not None
            if has_next:
                next_cursor = str(getattr(items[-1], cursor_field))
            if has_prev:
                prev_cursor = str(getattr(items[0], cursor_field))
        else:  # prev
            has_next = params.cursor is not None
            has_prev = has_more
            if has_next:
                next_cursor = str(getattr(items[-1], cursor_field))
            if has_prev:
                prev_cursor = str(getattr(items[0], cursor_field))
    else:
        has_next = False
        has_prev = params.cursor is not None

    # Build response
    meta = CursorPaginationMeta(
        next_cursor=next_cursor,
        prev_cursor=prev_cursor,
        has_next=has_next,
        has_prev=has_prev,
        count=len(items),
    )

    return CursorPaginatedResponse(items=items, meta=meta)


async def stream_query_results(
    session: AsyncSession,
    query: Select[Any],
    batch_size: int = 100,
) -> AsyncGenerator[Any]:
    """Stream query results in batches to avoid loading all data into memory.

    This is useful for processing large datasets without memory issues.

    Args:
        session: Database session
        query: SQLAlchemy select query
        batch_size: Number of items to fetch per batch

    Yields:
        Individual items from the query result

    Example:
        ```python
        from sqlalchemy import select
        from app.models.transaction import Transaction

        query = select(Transaction).where(Transaction.user_uuid == user_uuid)

        async for transaction in stream_query_results(session, query, batch_size=500):
            # Process each transaction
            await process_transaction(transaction)
        ```
    """
    offset = 0

    while True:
        # Fetch a batch
        batch_query = query.limit(batch_size).offset(offset)
        result = await session.execute(batch_query)
        items = list(result.scalars().all())

        if not items:
            break

        # Yield each item
        for item in items:
            yield item

        # If we got fewer items than batch_size, we're done
        if len(items) < batch_size:
            break

        offset += batch_size

        logger.debug("stream_query_batch_processed", offset=offset, batch_size=batch_size)


async def stream_query_batches(
    session: AsyncSession,
    query: Select[Any],
    batch_size: int = 100,
) -> AsyncGenerator[list[Any]]:
    """Stream query results as batches.

    This is useful when you want to process items in batches rather than individually.

    Args:
        session: Database session
        query: SQLAlchemy select query
        batch_size: Number of items per batch

    Yields:
        Batches of items from the query result

    Example:
        ```python
        from sqlalchemy import select
        from app.models.message import Message

        query = select(Message).where(Message.conversation_id == conversation_id)

        async for batch in stream_query_batches(session, query, batch_size=100):
            # Process batch of messages
            await process_message_batch(batch)
        ```
    """
    offset = 0

    while True:
        # Fetch a batch
        batch_query = query.limit(batch_size).offset(offset)
        result = await session.execute(batch_query)
        items = list(result.scalars().all())

        if not items:
            break

        yield items

        # If we got fewer items than batch_size, we're done
        if len(items) < batch_size:
            break

        offset += batch_size

        logger.debug("stream_query_batch_yielded", offset=offset, batch_size=batch_size, count=len(items))


# Convenience functions for common use cases


def create_pagination_response[T](
    items: list[T],
    page: int,
    per_page: int,
    total: int,
) -> PaginatedResponse[T]:
    """Create a pagination response from already-fetched data.

    Useful when you've already executed the query and just need to format the response.

    Args:
        items: List of items
        page: Current page number
        per_page: Items per page
        total: Total number of items

    Returns:
        PaginatedResponse: Formatted pagination response

    Example:
        ```python
        items = [...]  # Already fetched
        response = create_pagination_response(
            items=items,
            page=1,
            per_page=20,
            total=150
        )
        ```
    """
    pages = (total + per_page - 1) // per_page if total > 0 else 0
    has_next = page < pages
    has_prev = page > 1

    meta = PaginationMeta(
        page=page,
        per_page=per_page,
        total=total,
        pages=pages,
        has_next=has_next,
        has_prev=has_prev,
    )

    return PaginatedResponse(items=items, meta=meta)


def get_pagination_params(
    page: int | None = None,
    per_page: int | None = None,
    default_per_page: int = 10,
    max_per_page: int = 100,
) -> PaginationParams:
    """Create pagination params with validation and defaults.

    Args:
        page: Page number (optional)
        per_page: Items per page (optional)
        default_per_page: Default items per page
        max_per_page: Maximum items per page

    Returns:
        PaginationParams: Validated pagination parameters

    Example:
        ```python
        # In API endpoint
        @app.get("/users")
        async def get_users(
            page: int | None = None,
            per_page: int | None = None
        ):
            params = get_pagination_params(page, per_page)
            # Use params...
        ```
    """
    page = max(1, page or 1)
    per_page = min(max(1, per_page or default_per_page), max_per_page)

    return PaginationParams(page=page, per_page=per_page)
