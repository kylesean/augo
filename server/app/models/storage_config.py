"""Storage configuration model for multi-source storage management.

This module defines the StorageConfig model for managing various storage sources:
- Local filesystem (server uploads)
- S3-compatible storage (MinIO, AWS S3)
- WebDAV protocols (NAS, cloud drives)

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import TYPE_CHECKING, Any, Optional
from uuid import UUID

from sqlalchemy import Boolean, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.attachment import Attachment


class ProviderType(str, Enum):
    """Supported storage provider types.

    Attributes:
        LOCAL_UPLOADS: Local filesystem storage (server-side uploads directory)
        S3_COMPATIBLE: S3-compatible object storage (AWS S3, MinIO, etc.)
        WEBDAV: WebDAV protocol (Synology NAS, NextCloud, etc.)
    """

    LOCAL_UPLOADS = "local_uploads"
    S3_COMPATIBLE = "s3_compatible"
    WEBDAV = "webdav"


class StorageConfig(Base):
    """Storage adapter configuration model.

    Stores user-configured storage sources (local disk, NAS S3, WebDAV).
    Supports multiple storage backends per user with encrypted credentials.

    Attributes:
        id: Primary key (auto-increment)
        user_uuid: Foreign key to users table
        provider_type: Storage provider type (local_uploads, s3_compatible, webdav)
        name: User-friendly display name
        base_path: Root path or bucket name
        credentials: Encrypted JSONB containing endpoint, access_key, secret_key, etc.
        is_readonly: Whether Agent can write to this storage (user NAS usually True)
        created_at: Timestamp when config was created
        updated_at: Timestamp when config was last updated
        attachments: Relationship to attachments stored in this config
    """

    __tablename__ = "storage_configs"

    id: Mapped[int | None] = mapped_column(primary_key=True, autoincrement=True)
    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", column="uuid")

    provider_type: Mapped[str] = mapped_column(String(50))
    name: Mapped[str] = mapped_column(String(100))
    base_path: Mapped[str] = mapped_column(String(255))
    credentials: Mapped[dict[str, Any]] = col.jsonb_column()
    is_readonly: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    attachments: Mapped[list[Attachment]] = relationship(
        "Attachment",
        back_populates="storage_config",
    )

    @property
    def is_local(self) -> bool:
        """Check if this is a local filesystem storage."""
        return self.provider_type == ProviderType.LOCAL_UPLOADS.value

    @property
    def is_s3(self) -> bool:
        """Check if this is an S3-compatible storage."""
        return self.provider_type == ProviderType.S3_COMPATIBLE.value

    @property
    def is_webdav(self) -> bool:
        """Check if this is a WebDAV storage."""
        return self.provider_type == ProviderType.WEBDAV.value

    @property
    def can_write(self) -> bool:
        """Check if writes (save/delete) are allowed on this storage."""
        return not self.is_readonly
