"""Storage configuration model for multi-source storage management.

This module defines the StorageConfig model for managing various storage sources:
- Local filesystem (server uploads)
- S3-compatible storage (MinIO, AWS S3)
- WebDAV protocols (NAS, cloud drives)
"""

import uuid
from enum import Enum
from typing import TYPE_CHECKING, Optional

import sqlalchemy as sa
from sqlalchemy import Column
from sqlalchemy.dialects.postgresql import JSONB, UUID as PG_UUID
from sqlmodel import Field, Relationship

from app.models.base import BaseModel

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


class StorageConfig(BaseModel, table=True):
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

    id: Optional[int] = Field(default=None, primary_key=True, sa_column_kwargs={"autoincrement": True})
    user_uuid: uuid.UUID = Field(
        sa_column=Column(
            PG_UUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False, index=True
        )
    )

    # Provider type: 'local_uploads', 's3_compatible', 'webdav'
    provider_type: str = Field(max_length=50)

    # User-friendly display name
    name: str = Field(max_length=100)

    # Root path or bucket name
    # S3: bucket name; Local: absolute path (e.g., /var/www/uploads)
    base_path: str = Field(max_length=255)

    # Encrypted credentials (Endpoint, AccessKey, SecretKey, WebDAV Password, etc.)
    # Encrypted at application layer before storing
    credentials: Optional[dict] = Field(default_factory=dict, sa_column=Column(JSONB, default={}))

    # Read-only flag: user NAS should default to True to prevent Agent from deleting files
    is_readonly: bool = Field(default=True)

    # Relationship to attachments using this storage config
    attachments: list["Attachment"] = Relationship(back_populates="storage_config")

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
