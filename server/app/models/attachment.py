"""Attachment model for unified file storage.

This module defines the Attachment model for storing file metadata
with support for multiple storage sources and LangGraph integration.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING, Any, Optional
from uuid import UUID, uuid4 as uuid4_factory

import sqlalchemy as sa
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.storage_config import StorageConfig


class Attachment(Base):
    """Unified attachment index model.

    Central metadata registry for files, linking to storage configs
    and optionally to LangGraph threads for conversation context.

    Attributes:
        id: Primary key (UUID)
        user_uuid: Foreign key to users table
        storage_config_id: Foreign key to storage_configs table
        thread_id: LangGraph thread/conversation ID (optional)
        filename: Original filename for display
        object_key: Relative path or object key within storage source
        mime_type: File MIME type
        size: File size in bytes
        hash: SHA256 hash for deduplication and instant upload
        meta_info: AI analysis metadata (OCR results, image descriptions, etc.)
        created_at: Timestamp when attachment was created
        updated_at: Timestamp when attachment was last updated
        storage_config: Relationship to storage configuration
        user: Relationship to user (owner)
    """

    __tablename__ = "attachments"

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True, column="uuid")
    storage_config_id: Mapped[int] = mapped_column(
        Integer,
        sa.ForeignKey("storage_configs.id", ondelete="SET NULL"),
        index=True,
    )
    thread_id: Mapped[UUID | None] = col.uuid_column(index=True, nullable=True)

    filename: Mapped[str] = mapped_column(String(255))
    object_key: Mapped[str] = mapped_column(String(1024))
    mime_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    size: Mapped[int | None] = mapped_column(Integer, nullable=True)
    hash: Mapped[str | None] = mapped_column(String(64), index=True, nullable=True)
    meta_info: Mapped[dict[str, Any]] = col.jsonb_column()
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    storage_config: Mapped[StorageConfig | None] = relationship(
        "StorageConfig",
        back_populates="attachments",
    )

    @property
    def display_name(self) -> str:
        """Get display name for the attachment."""
        return self.filename or "Unknown File"

    @property
    def is_image(self) -> bool:
        """Check if attachment is an image."""
        if not self.mime_type:
            return False
        return self.mime_type.startswith("image/")

    @property
    def is_pdf(self) -> bool:
        """Check if attachment is a PDF."""
        return self.mime_type == "application/pdf"
