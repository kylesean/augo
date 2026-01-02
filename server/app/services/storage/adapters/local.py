"""Local filesystem storage adapter.

Provides async file operations for server-side local storage.
Uses aiofiles for async I/O and generates JWT-signed URLs for downloads.
"""

import hashlib
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import AsyncGenerator, Optional

import aiofiles
import aiofiles.os

from app.core.config import settings
from app.core.logging import logger
from app.models.storage_config import StorageConfig
from app.services.storage.adapters.base import (
    StorageAdapter,
    StorageError,
    StorageNotFoundError,
    StorageReadOnlyError,
)
from app.utils.auth import create_access_token


class LocalAdapter(StorageAdapter):
    """Local filesystem storage adapter.

    Stores files on the server's local filesystem with date-based
    directory structure. Generates JWT-signed URLs for secure access.

    Attributes:
        config: StorageConfig with base_path pointing to upload directory
        base_path: Resolved absolute path to storage root
    """

    def __init__(self, config: StorageConfig):
        """Initialize local storage adapter.

        Args:
            config: StorageConfig with base_path (relative or absolute)
        """
        super().__init__(config)
        # Resolve base path relative to project root if not absolute
        raw_path = Path(config.base_path)
        if raw_path.is_absolute():
            self.base_path = raw_path
        else:
            # Relative to project root
            self.base_path = Path(settings.UPLOAD_DIR).parent.parent / config.base_path

    async def initialize(self) -> None:
        """Ensure base directory exists."""
        await aiofiles.os.makedirs(self.base_path, exist_ok=True)
        self._initialized = True
        logger.info(
            "local_adapter_initialized",
            base_path=str(self.base_path)
        )

    def _resolve_path(self, object_key: str) -> Path:
        """Resolve object_key to absolute path with security check.

        Args:
            object_key: Relative path within storage

        Returns:
            Absolute path to file

        Raises:
            StorageError: If path traversal is detected
        """
        # Combine base path with file key
        full_path = (self.base_path / object_key).resolve()

        # Security check: prevent path traversal
        if not str(full_path).startswith(str(self.base_path.resolve())):
            logger.error(
                "path_traversal_attempt",
                object_key=object_key,
                resolved=str(full_path),
                base=str(self.base_path)
            )
            raise StorageError(f"Invalid file path: {object_key}")

        return full_path

    def _generate_object_key(self, filename: str) -> str:
        """Generate a unique object key with date-based structure.

        Creates structure: YYYY/MM/DD/uuid_originalname.ext

        Args:
            filename: Original filename

        Returns:
            Generated object key
        """
        now = datetime.now(timezone.utc)
        date_path = now.strftime("%Y/%m/%d")

        # Extract extension and sanitize filename
        ext = Path(filename).suffix.lower() or ""
        safe_name = "".join(
            c for c in Path(filename).stem
            if c.isalnum() or c in "-_"
        )[:50]

        # Generate unique identifier
        unique_id = uuid.uuid4().hex[:12]

        return f"{date_path}/{unique_id}_{safe_name}{ext}"

    async def save(
        self,
        file_stream: AsyncGenerator[bytes, None],
        filename: str,
        content_type: Optional[str] = None,
    ) -> str:
        """Save file to local filesystem.

        Args:
            file_stream: Async generator yielding file bytes
            filename: Original filename
            content_type: Optional MIME type (not used for local)

        Returns:
            Generated object_key (relative path within storage)

        Raises:
            StorageReadOnlyError: If storage is read-only
            StorageError: If save fails
        """
        self._check_writable()

        object_key = self._generate_object_key(filename)
        full_path = self._resolve_path(object_key)

        try:
            # Ensure parent directory exists
            await aiofiles.os.makedirs(full_path.parent, exist_ok=True)

            # Write file content
            async with aiofiles.open(full_path, "wb") as f:
                async for chunk in file_stream:
                    await f.write(chunk)

            logger.info(
                "local_file_saved",
                object_key=object_key,
                path=str(full_path)
            )
            return object_key

        except Exception as e:
            logger.error(
                "local_file_save_failed",
                object_key=object_key,
                error=str(e)
            )
            raise StorageError(f"Failed to save file: {e}")

    async def save_bytes(
        self,
        content: bytes,
        filename: str,
        content_type: Optional[str] = None,
    ) -> str:
        """Save bytes content to local filesystem (convenience method).

        Args:
            content: File content as bytes
            filename: Original filename
            content_type: Optional MIME type

        Returns:
            Generated object_key
        """
        async def bytes_generator():
            yield content

        return await self.save(bytes_generator(), filename, content_type)

    async def get_download_url(
        self,
        object_key: str,
        expire_seconds: int = 3600,
        filename: Optional[str] = None,
    ) -> str:
        """Generate JWT-signed URL for file access.

        Creates a URL pointing to /api/files/view/{attachment_id}
        with a signed token for authentication.

        Args:
            object_key: Object key (used in JWT payload)
            expire_seconds: URL validity in seconds
            filename: Optional original filename

        Returns:
            Signed URL like /api/files/view?token=xxx&object_key=xxx
        """
        # Create JWT token with file access claims
        token_data = {
            "object_key": object_key,
            "storage_config_id": self.config.id,
            "exp": datetime.now(timezone.utc) + timedelta(seconds=expire_seconds),
        }

        if filename:
            token_data["filename"] = filename

        # Use existing auth utility to create token
        token = create_access_token(
            data={"sub": f"file:{object_key}", "file_access": token_data},
            expires_delta=timedelta(seconds=expire_seconds)
        )

        # Build URL
        base_url = getattr(settings, "APP_URL", "http://localhost:8000").rstrip("/")
        return f"{base_url}/api/files/stream?token={token}"

    async def get_stream(
        self,
        object_key: str,
    ) -> AsyncGenerator[bytes, None]:
        """Stream file content asynchronously.

        Args:
            object_key: Object key (relative path)

        Yields:
            File content in chunks

        Raises:
            StorageNotFoundError: If file doesn't exist
        """
        full_path = self._resolve_path(object_key)

        if not full_path.exists():
            raise StorageNotFoundError(f"File not found: {object_key}")

        try:
            async with aiofiles.open(full_path, "rb") as f:
                while chunk := await f.read(8192):
                    yield chunk
        except Exception as e:
            logger.error("local_file_read_failed", object_key=object_key, error=str(e))
            raise StorageError(f"Failed to read file: {e}")

    async def delete(self, object_key: str) -> bool:
        """Delete file from local filesystem.

        Args:
            object_key: Object key to delete

        Returns:
            True if deleted, False if didn't exist

        Raises:
            StorageReadOnlyError: If storage is read-only
        """
        self._check_writable()

        full_path = self._resolve_path(object_key)

        if not full_path.exists():
            return False

        try:
            await aiofiles.os.remove(full_path)
            logger.info("local_file_deleted", object_key=object_key)
            return True
        except Exception as e:
            logger.error("local_file_delete_failed", object_key=object_key, error=str(e))
            raise StorageError(f"Failed to delete file: {e}")

    async def exists(self, object_key: str) -> bool:
        """Check if file exists in local storage.

        Args:
            object_key: Object key to check

        Returns:
            True if exists
        """
        try:
            full_path = self._resolve_path(object_key)
            return full_path.exists()
        except StorageError:
            return False

    async def get_file_info(self, object_key: str) -> Optional[dict]:
        """Get file metadata from local filesystem.

        Args:
            object_key: Object key

        Returns:
            File info dict or None
        """
        try:
            full_path = self._resolve_path(object_key)
            if not full_path.exists():
                return None

            stat = full_path.stat()
            return {
                "size": stat.st_size,
                "modified": datetime.fromtimestamp(stat.st_mtime, tz=timezone.utc),
                "content_type": None,  # Would need mimetypes detection
            }
        except Exception:
            return None

    async def calculate_hash(self, object_key: str) -> Optional[str]:
        """Calculate SHA256 hash of file.

        Args:
            object_key: Object key

        Returns:
            SHA256 hex digest or None if file not found
        """
        try:
            full_path = self._resolve_path(object_key)
            if not full_path.exists():
                return None

            sha256 = hashlib.sha256()
            async with aiofiles.open(full_path, "rb") as f:
                while chunk := await f.read(8192):
                    sha256.update(chunk)

            return sha256.hexdigest()
        except Exception:
            return None
