"""Storage configuration service.

Provides CRUD operations for StorageConfig with credential encryption
and user default storage initialization.
"""
from __future__ import annotations

from sqlalchemy import desc, select

from sqlalchemy import desc, select
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.core.logging import logger
from app.models.storage_config import ProviderType, StorageConfig
from app.utils.encryption import credential_encryption


class StorageConfigService:
    """Service for managing storage configurations.

    Handles CRUD operations with credential encryption/decryption
    and user default storage initialization.
    """

    def __init__(self, db: AsyncSession):
        """Initialize service with database session.

        Args:
            db: Async database session
        """
        self.db = db

    async def create(
        self,
        user_uuid: UUID,
        provider_type: str,
        name: str,
        base_path: str,
        credentials: dict | None = None,
        is_readonly: bool = True,
    ) -> StorageConfig:
        """Create a new storage configuration.

        Args:
            user_uuid: Owner user ID
            provider_type: Provider type (local_uploads, s3_compatible, webdav)
            name: User-friendly display name
            base_path: Root path or bucket name
            credentials: Connection credentials (will be encrypted)
            is_readonly: Whether storage is read-only

        Returns:
            Created StorageConfig model

        Raises:
            ValueError: If provider_type is invalid
        """
        from app.core.exceptions import ValidationError

        # Validate provider type
        valid_types = [pt.value for pt in ProviderType]
        if provider_type not in valid_types:
            raise ValidationError(message=f"Invalid provider_type: {provider_type}. Must be one of: {valid_types}")

        # Encrypt credentials if provided
        encrypted_creds = {}
        if credentials:
            encrypted_creds = {"_encrypted": credential_encryption.encrypt_credentials(credentials)}

        config = StorageConfig(
            user_uuid=user_uuid,
            provider_type=provider_type,
            name=name,
            base_path=base_path,
            credentials=encrypted_creds,
            is_readonly=is_readonly,
        )

        self.db.add(config)
        await self.db.commit()
        await self.db.refresh(config)

        logger.info(
            "storage_config_created", config_id=config.id, user_uuid=user_uuid, provider_type=provider_type, name=name
        )

        return config

    async def get_by_id(
        self,
        config_id: int,
        user_uuid: UUID | None = None,
    ) -> StorageConfig | None:
        """Get storage config by ID.

        Args:
            config_id: Config ID
            user_uuid: Optional user ID for ownership check

        Returns:
            StorageConfig or None
        """
        query = select(StorageConfig).where(StorageConfig.id == config_id)

        if user_uuid is not None:
            query = query.where(StorageConfig.user_uuid == user_uuid)

        result = await self.db.execute(query)
        return result.scalar_one_or_none()

    async def get_user_configs(
        self,
        user_uuid: UUID,
        provider_type: str | None = None,
    ) -> list[StorageConfig]:
        """Get all storage configs for a user.

        Args:
            user_uuid: User ID
            provider_type: Optional filter by provider type

        Returns:
            List of StorageConfig models
        """
        query = select(StorageConfig).where(StorageConfig.user_uuid == user_uuid)

        if provider_type:
            query = query.where(StorageConfig.provider_type == provider_type)

        query = query.order_by(StorageConfig.created_at.desc())

        result = await self.db.execute(query)
        return list(result.scalars().all())

    async def get_default_local(self, user_uuid: UUID) -> StorageConfig | None:
        """Get user's default local storage config.

        Args:
            user_uuid: User ID

        Returns:
            Default local StorageConfig or None
        """
        query = (
            select(StorageConfig)
            .where(
                StorageConfig.user_uuid == user_uuid,
                StorageConfig.provider_type == ProviderType.LOCAL_UPLOADS.value,
            )
            .order_by(StorageConfig.created_at.asc())
            .limit(1)
        )

        result = await self.db.execute(query)
        return result.scalar_one_or_none()

    async def ensure_default_local(self, user_uuid: UUID) -> StorageConfig:
        """Ensure user has a default local storage config.

        Creates one if it doesn't exist.

        Args:
            user_uuid: User ID

        Returns:
            Default local StorageConfig
        """
        existing = await self.get_default_local(user_uuid)
        if existing:
            return existing

        return await self.create(
            user_uuid=user_uuid,
            provider_type=ProviderType.LOCAL_UPLOADS.value,
            name="本地存储",
            base_path="storage/uploads",
            is_readonly=False,
        )

    async def update(
        self,
        config_id: int,
        user_uuid: UUID,
        name: str | None = None,
        base_path: str | None = None,
        credentials: dict | None = None,
        is_readonly: bool | None = None,
    ) -> StorageConfig | None:
        """Update a storage configuration.

        Args:
            config_id: Config ID
            user_uuid: Owner user ID (for authorization)
            name: New display name
            base_path: New base path
            credentials: New credentials (will be encrypted)
            is_readonly: New readonly flag

        Returns:
            Updated StorageConfig or None if not found
        """
        config = await self.get_by_id(config_id, user_uuid)
        if not config:
            return None

        if name is not None:
            config.name = name

        if base_path is not None:
            config.base_path = base_path

        if credentials is not None:
            config.credentials = {"_encrypted": credential_encryption.encrypt_credentials(credentials)}

        if is_readonly is not None:
            config.is_readonly = is_readonly

        await self.db.commit()
        await self.db.refresh(config)

        logger.info("storage_config_updated", config_id=config_id, user_uuid=user_uuid)

        return config

    async def delete(self, config_id: int, user_uuid: UUID) -> bool:
        """Delete a storage configuration.

        Note: Will fail if attachments still reference this config.

        Args:
            config_id: Config ID
            user_uuid: Owner user ID (for authorization)

        Returns:
            True if deleted, False if not found
        """
        config = await self.get_by_id(config_id, user_uuid)
        if not config:
            return False

        await self.db.delete(config)
        await self.db.commit()

        logger.info("storage_config_deleted", config_id=config_id, user_uuid=user_uuid)

        return True

    def decrypt_credentials(self, config: StorageConfig) -> dict:
        """Decrypt credentials from a storage config.

        Args:
            config: StorageConfig with encrypted credentials

        Returns:
            Decrypted credentials dict
        """
        if not config.credentials:
            return {}

        encrypted = config.credentials.get("_encrypted")
        if not encrypted:
            # Credentials might be stored unencrypted (migration case)
            return config.credentials

        return credential_encryption.decrypt_credentials(encrypted)

    def mask_credentials(self, config: StorageConfig) -> dict:
        """Get masked credentials for API response.

        Args:
            config: StorageConfig

        Returns:
            Masked credentials safe for display
        """
        creds = self.decrypt_credentials(config)
        return credential_encryption.mask_credentials(creds)
