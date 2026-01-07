"""S3-compatible storage adapter.

Provides async file operations for S3/MinIO object storage.
Uses s3fs/aiobotocore for async operations and generates presigned URLs.
"""

import uuid
from datetime import datetime, timezone
from typing import Any, AsyncGenerator, Optional

from app.core.logging import logger
from app.models.storage_config import StorageConfig
from app.services.storage.adapters.base import (
    StorageAdapter,
    StorageError,
    StorageNotFoundError,
)
from app.utils.encryption import credential_encryption


class S3Adapter(StorageAdapter):
    """S3-compatible object storage adapter.

    Supports AWS S3, MinIO, and other S3-compatible services.
    Uses aiobotocore for async operations.

    Credentials format in StorageConfig.credentials:
    {
        "endpoint_url": "https://s3.amazonaws.com" or "http://minio:9000",
        "access_key": "...",
        "secret_key": "...",
        "region": "us-east-1"  # optional
    }
    """

    def __init__(self, config: StorageConfig):
        """Initialize S3 adapter.

        Args:
            config: StorageConfig with S3 credentials and bucket name
        """
        super().__init__(config)
        self._session: Any = None
        self._client: Any = None
        self._credentials: dict = {}

    async def initialize(self) -> None:
        """Initialize S3 client with credentials.

        Decrypts credentials and creates aiobotocore session.
        """
        try:
            # Decrypt credentials
            creds_raw = self.config.credentials
            if isinstance(creds_raw, str) and creds_raw:
                self._credentials = credential_encryption.decrypt_credentials(creds_raw)
            elif isinstance(creds_raw, dict):
                self._credentials = creds_raw
            else:
                self._credentials = {}

            self._initialized = True
            logger.info(
                "s3_adapter_initialized",
                bucket=self.config.base_path,
                endpoint=self._credentials.get("endpoint_url", "default"),
            )
        except Exception as e:
            logger.error("s3_adapter_init_failed", error=str(e))
            raise StorageError(f"Failed to initialize S3 adapter: {e}")

    async def _get_client(self) -> Any:
        """Get or create S3 client context manager."""
        import aiobotocore.session

        if self._session is None:
            self._session = aiobotocore.session.get_session()

        from typing import cast

        return cast(
            Any,
            self._session.create_client(  # type: ignore
                "s3",
                endpoint_url=self._credentials.get("endpoint_url"),
                aws_access_key_id=self._credentials.get("access_key"),
                aws_secret_access_key=self._credentials.get("secret_key"),
                region_name=self._credentials.get("region", "us-east-1"),
            ),
        )

    @property
    def bucket(self) -> str:
        """Get bucket name from config."""
        return self.config.base_path

    def _generate_object_key(self, filename: str) -> str:
        """Generate unique S3 object key.

        Creates structure: YYYY/MM/DD/uuid_filename.ext

        Args:
            filename: Original filename

        Returns:
            S3 object key
        """
        from pathlib import Path

        now = datetime.now(timezone.utc)
        date_prefix = now.strftime("%Y/%m/%d")

        ext = Path(filename).suffix.lower() or ""
        safe_name = "".join(c for c in Path(filename).stem if c.isalnum() or c in "-_")[:50]

        unique_id = uuid.uuid4().hex[:12]
        return f"{date_prefix}/{unique_id}_{safe_name}{ext}"

    async def save(
        self,
        file_stream: AsyncGenerator[bytes, None],
        filename: str,
        content_type: Optional[str] = None,
    ) -> str:
        """Upload file to S3 bucket.

        Args:
            file_stream: Async generator yielding file bytes
            filename: Original filename
            content_type: Optional MIME type

        Returns:
            S3 object key

        Raises:
            StorageReadOnlyError: If storage is read-only
            StorageError: If upload fails
        """
        self._check_writable()

        object_key = self._generate_object_key(filename)

        try:
            # Collect all chunks (S3 needs full content or multipart)
            chunks = []
            async for chunk in file_stream:
                chunks.append(chunk)
            content = b"".join(chunks)

            async with await self._get_client() as client:
                put_args = {
                    "Bucket": self.bucket,
                    "Key": object_key,
                    "Body": content,
                }
                if content_type:
                    put_args["ContentType"] = content_type

                await client.put_object(**put_args)

            logger.info("s3_file_uploaded", bucket=self.bucket, key=object_key, size=len(content))
            return object_key

        except Exception as e:
            logger.error("s3_upload_failed", bucket=self.bucket, error=str(e))
            raise StorageError(f"Failed to upload to S3: {e}")

    async def get_download_url(
        self,
        object_key: str,
        expire_seconds: int = 3600,
        filename: Optional[str] = None,
    ) -> str:
        """Generate presigned URL for S3 object.

        Args:
            object_key: S3 object key
            expire_seconds: URL validity in seconds
            filename: Optional filename for Content-Disposition

        Returns:
            Presigned URL
        """
        try:
            async with await self._get_client() as client:
                params = {
                    "Bucket": self.bucket,
                    "Key": object_key,
                }

                if filename:
                    params["ResponseContentDisposition"] = f'attachment; filename="{filename}"'

                url = await client.generate_presigned_url(
                    "get_object",
                    Params=params,
                    ExpiresIn=expire_seconds,
                )
                from typing import cast

                return cast(str, url)

        except Exception as e:
            logger.error("s3_presign_failed", bucket=self.bucket, key=object_key, error=str(e))
            raise StorageError(f"Failed to generate presigned URL: {e}")

    async def get_stream(
        self,
        object_key: str,
    ) -> AsyncGenerator[bytes, None]:
        """Stream S3 object content.

        Args:
            object_key: S3 object key

        Yields:
            Object content in chunks

        Raises:
            StorageNotFoundError: If object doesn't exist
        """
        try:
            async with await self._get_client() as client:
                response = await client.get_object(
                    Bucket=self.bucket,
                    Key=object_key,
                )

                async with response["Body"] as stream:
                    async for chunk in stream.iter_chunks():
                        yield chunk

        except client.exceptions.NoSuchKey:
            raise StorageNotFoundError(f"Object not found: {object_key}")
        except Exception as e:
            if "NoSuchKey" in str(e):
                raise StorageNotFoundError(f"Object not found: {object_key}")
            logger.error("s3_stream_failed", bucket=self.bucket, key=object_key, error=str(e))
            raise StorageError(f"Failed to stream S3 object: {e}")

    async def delete(self, object_key: str) -> bool:
        """Delete object from S3 bucket.

        Args:
            object_key: S3 object key

        Returns:
            True if deleted (S3 always returns success)

        Raises:
            StorageReadOnlyError: If storage is read-only
        """
        self._check_writable()

        try:
            async with await self._get_client() as client:
                await client.delete_object(
                    Bucket=self.bucket,
                    Key=object_key,
                )

            logger.info("s3_object_deleted", bucket=self.bucket, key=object_key)
            return True

        except Exception as e:
            logger.error("s3_delete_failed", bucket=self.bucket, key=object_key, error=str(e))
            raise StorageError(f"Failed to delete S3 object: {e}")

    async def exists(self, object_key: str) -> bool:
        """Check if object exists in S3.

        Args:
            object_key: S3 object key

        Returns:
            True if exists
        """
        try:
            async with await self._get_client() as client:
                await client.head_object(
                    Bucket=self.bucket,
                    Key=object_key,
                )
                return True
        except Exception:
            return False

    async def get_object_info(self, object_key: str) -> Optional[dict]:
        """Get object metadata from S3.

        Args:
            object_key: S3 object key

        Returns:
            Object metadata or None
        """
        try:
            async with await self._get_client() as client:
                response = await client.head_object(
                    Bucket=self.bucket,
                    Key=object_key,
                )
                return {
                    "size": response.get("ContentLength"),
                    "modified": response.get("LastModified"),
                    "content_type": response.get("ContentType"),
                }
        except Exception:
            return None
