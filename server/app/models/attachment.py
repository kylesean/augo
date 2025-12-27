"""Attachment model for unified file storage.

This module defines the Attachment model for storing file metadata
with support for multiple storage sources and LangGraph integration.
"""

import uuid as uuid_lib
from typing import TYPE_CHECKING, Optional

from sqlalchemy import Column, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlmodel import Field, Relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.storage_config import StorageConfig
    from app.models.user import User


class Attachment(BaseModel, table=True):
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

    # Primary key as UUID (matches actual database schema)
    id: Optional[uuid_lib.UUID] = Field(
        default_factory=uuid_lib.uuid4,
        sa_column=Column(UUID(as_uuid=True), primary_key=True, default=uuid_lib.uuid4),
    )

    user_uuid: uuid_lib.UUID = Field(foreign_key="users.uuid", index=True)

    # Foreign key to storage configuration
    storage_config_id: int = Field(foreign_key="storage_configs.id", index=True)

    # LangGraph thread/conversation ID for context association
    thread_id: Optional[str] = Field(default=None, sa_column=Column(Text, index=True))

    # Original filename for display
    filename: str = Field(max_length=255)

    # File path/key within storage source (relative to base_path)
    # e.g., S3 key: "photos/2025/01.jpg" or local: "user_1/chat_abc/file.pdf"
    object_key: str = Field(max_length=1024)

    # File metadata
    mime_type: Optional[str] = Field(default=None, max_length=100)
    size: Optional[int] = Field(default=None)  # Bytes

    # SHA256 hash for deduplication and instant upload detection
    hash: Optional[str] = Field(default=None, max_length=64, index=True)

    # AI analysis metadata (OCR results, image descriptions, document summaries)
    # Stored to avoid repeated computation
    meta_info: Optional[dict] = Field(
        default_factory=dict,
        sa_column=Column(JSONB, default={}),
    )

    # Relationships
    storage_config: Optional["StorageConfig"] = Relationship(back_populates="attachments")

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
