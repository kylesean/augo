"""Searchable message model for full-text search.

This table implements the "dual-write" pattern for efficient message content search.
Messages are synced here from LangGraph checkpoints for fast PostgreSQL full-text search.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import UTC, datetime
from typing import TYPE_CHECKING
from uuid import UUID, uuid4 as uuid4_factory

from sqlalchemy import String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, col

if TYPE_CHECKING:
    pass


class SearchableMessage(Base):
    """Searchable message for full-text search.

    This is a "flat" table optimized for search, separate from LangGraph's
    checkpoint storage. Messages are dual-written here during chat processing.

    Attributes:
        id: UUID primary key
        thread_id: LangGraph thread_id (same as session_id)
        user_uuid: Owner's UUID for access control
        role: Message role - 'user' or 'assistant'
        content: Message text content for search
        created_at: When the message was created
        updated_at: When the record was last updated
    """

    __tablename__ = "searchable_messages"

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    thread_id: Mapped[UUID] = col.uuid_column(index=True)
    user_uuid: Mapped[UUID] = col.uuid_column(index=True)
    role: Mapped[str] = mapped_column(String(20))
    content: Mapped[str] = col.text_column()
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)
