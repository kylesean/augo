"""Abstract base class for storage adapters.

Defines the unified interface for all storage backends (local, S3, WebDAV).
All adapters must implement async methods for file operations.
"""

from abc import ABC, abstractmethod
from typing import AsyncGenerator, Optional

from app.models.storage_config import StorageConfig


class StorageAdapter(ABC):
    """Abstract base class for storage adapters.

    All storage backends must implement this interface to provide
    a unified API for file operations across different storage sources.

    Attributes:
        config: StorageConfig model containing adapter configuration
    """

    def __init__(self, config: StorageConfig):
        """Initialize adapter with storage configuration.

        Args:
            config: StorageConfig model with credentials and settings
        """
        self.config = config
        self._initialized = False

    async def initialize(self) -> None:
        """Perform async initialization (connection pooling, etc.).

        Override this method in subclasses if async initialization is needed.
        """
        self._initialized = True

    @abstractmethod
    async def save(
        self,
        file_stream: AsyncGenerator[bytes, None],
        filename: str,
        content_type: Optional[str] = None,
    ) -> str:
        """Upload a file to storage.

        Args:
            file_stream: Async generator yielding file content bytes
            filename: Original filename (used for extension detection)
            content_type: Optional MIME type

        Returns:
            object_key: Storage-internal relative path/key for the file

        Raises:
            StorageReadOnlyError: If storage is marked as read-only
            StorageError: If upload fails
        """
        pass

    @abstractmethod
    async def get_download_url(
        self,
        object_key: str,
        expire_seconds: int = 3600,
        filename: Optional[str] = None,
    ) -> str:
        """Get a browser-accessible temporary URL for file download.

        For S3/MinIO: Generate presigned URL
        For Local: Generate JWT-signed URL pointing to /api/files/view

        Args:
            object_key: Storage-internal file path/key
            expire_seconds: URL validity duration in seconds
            filename: Optional original filename for Content-Disposition

        Returns:
            Temporary signed URL accessible by browser

        Raises:
            StorageError: If URL generation fails
        """
        pass

    @abstractmethod
    async def get_stream(
        self,
        object_key: str,
    ) -> AsyncGenerator[bytes, None]:
        """Get file content as an async stream.

        Used by AI Agent to read file contents for processing.

        Args:
            object_key: Storage-internal file path/key

        Yields:
            Chunks of file content as bytes

        Raises:
            FileNotFoundError: If file doesn't exist
            StorageError: If read fails
        """
        pass

    @abstractmethod
    async def delete(self, object_key: str) -> bool:
        """Delete a file from storage.

        Args:
            object_key: Storage-internal file path/key

        Returns:
            True if file was deleted, False if file didn't exist

        Raises:
            StorageReadOnlyError: If storage is marked as read-only
            StorageError: If deletion fails
        """
        pass

    @abstractmethod
    async def exists(self, object_key: str) -> bool:
        """Check if a file exists in storage.

        Args:
            object_key: Storage-internal file path/key

        Returns:
            True if file exists, False otherwise
        """
        pass

    async def get_file_info(self, object_key: str) -> Optional[dict]:
        """Get file metadata (size, modified time, etc.).

        Args:
            object_key: Storage-internal file path/key

        Returns:
            Dictionary with file info or None if not found:
            {
                "size": int,  # bytes
                "modified": datetime,
                "content_type": str | None
            }
        """
        return None

    def _check_writable(self) -> None:
        """Check if storage allows write operations.

        Raises:
            StorageReadOnlyError: If storage is read-only
        """
        if self.config.is_readonly:
            raise StorageReadOnlyError(
                f"Storage '{self.config.name}' is read-only. "
                "Cannot perform write operations."
            )


class StorageError(Exception):
    """Base exception for storage operations."""
    pass


class StorageReadOnlyError(StorageError):
    """Raised when attempting write operation on read-only storage."""
    pass


class StorageNotFoundError(StorageError):
    """Raised when file is not found in storage."""
    pass
