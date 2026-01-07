"""Storage adapter factory.

Factory pattern for creating appropriate storage adapters
based on StorageConfig provider type.
"""
from __future__ import annotations

from app.core.logging import logger
from app.models.storage_config import ProviderType, StorageConfig
from app.services.storage.adapters.base import StorageAdapter, StorageError


class StorageAdapterFactory:
    """Factory for creating storage adapters.

    Provides a centralized way to instantiate the correct adapter
    based on storage configuration type.

    Usage:
        config = await get_storage_config(config_id)
        adapter = await StorageAdapterFactory.create(config)
        url = await adapter.get_download_url(object_key)
    """

    # Registry of adapter classes by provider type
    _adapters: dict[str, type[StorageAdapter]] = {}

    @classmethod
    def register(cls, provider_type: str, adapter_class: type[StorageAdapter]) -> None:
        """Register an adapter class for a provider type.

        Args:
            provider_type: Provider type string (e.g., 'local_uploads')
            adapter_class: StorageAdapter subclass
        """
        cls._adapters[provider_type] = adapter_class
        logger.debug("adapter_registered", provider_type=provider_type)

    @classmethod
    async def create(cls, config: StorageConfig) -> StorageAdapter:
        """Create and initialize a storage adapter.

        Args:
            config: StorageConfig model with credentials

        Returns:
            Initialized StorageAdapter instance

        Raises:
            StorageError: If provider type is not supported
        """
        # Lazy import to avoid circular dependencies
        cls._ensure_adapters_registered()

        adapter_class = cls._adapters.get(config.provider_type)

        if adapter_class is None:
            raise StorageError(
                f"Unsupported storage provider: {config.provider_type}. Supported: {list(cls._adapters.keys())}"
            )

        # Create and initialize adapter
        adapter = adapter_class(config)
        await adapter.initialize()

        logger.info(
            "adapter_created",
            provider_type=config.provider_type,
            storage_name=config.name,
            is_readonly=config.is_readonly,
        )

        return adapter

    @classmethod
    def _ensure_adapters_registered(cls) -> None:
        """Register all built-in adapters if not already registered."""
        if cls._adapters:
            return

        # Import adapters
        from app.services.storage.adapters.local import LocalAdapter
        from app.services.storage.adapters.s3 import S3Adapter
        from app.services.storage.adapters.webdav import WebDAVAdapter

        # Register adapters
        cls.register(ProviderType.LOCAL_UPLOADS.value, LocalAdapter)
        cls.register(ProviderType.S3_COMPATIBLE.value, S3Adapter)
        cls.register(ProviderType.WEBDAV.value, WebDAVAdapter)

    @classmethod
    def get_supported_providers(cls) -> list[str]:
        """Get list of supported provider types.

        Returns:
            List of provider type strings
        """
        cls._ensure_adapters_registered()
        return list(cls._adapters.keys())
