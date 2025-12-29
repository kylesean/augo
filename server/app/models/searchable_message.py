"""Searchable message model for full-text search.

This table implements the "dual-write" pattern for efficient message content search.
Messages are synced here from LangGraph checkpoints for fast PostgreSQL full-text search.
"""

import uuid as uuid_lib

from sqlalchemy import Column, Text
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlmodel import Field

from app.models.base import BaseModel


class SearchableMessage(BaseModel, table=True):
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

    id: uuid_lib.UUID = Field(
        default_factory=uuid_lib.uuid4,
        sa_type=PG_UUID(as_uuid=True),
        primary_key=True,
        description="UUID primary key",
    )
    thread_id: uuid_lib.UUID = Field(
        sa_type=PG_UUID(as_uuid=True),
        index=True,
        description="LangGraph thread_id / session_id",
    )
    user_uuid: uuid_lib.UUID = Field(
        sa_type=PG_UUID(as_uuid=True),
        index=True,
        description="User UUID for access control",
    )
    role: str = Field(max_length=20, description="'user' or 'assistant'")
    content: str = Field(
        sa_column=Column(Text, nullable=False),
        description="Message text content",
    )

    # Note: For PostgreSQL full-text search with Chinese support,
    # you can add a GENERATED column with tsvector in a migration:
    #
    # ALTER TABLE searchable_messages
    # ADD COLUMN search_vector tsvector
    # GENERATED ALWAYS AS (to_tsvector('simple', content)) STORED;
    #
    # CREATE INDEX idx_searchable_messages_search ON searchable_messages USING GIN(search_vector);
    #
    # For now, we use jieba tokenization in Python + ILIKE for Chinese support.
