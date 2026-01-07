"""File upload service (Local Storage Only).

最佳实践：将文件处理和数据库操作分开。
1. 先处理所有文件（验证、压缩、保存到磁盘）
2. 然后一次性批量插入数据库记录
3. 单次 commit
"""

from __future__ import annotations

import hashlib
import io
import mimetypes
import uuid
from collections.abc import AsyncGenerator
from datetime import UTC, datetime
from pathlib import Path
from typing import Any
from uuid import UUID

import aiofiles
import aiofiles.os
from fastapi import UploadFile
from PIL import Image
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from starlette.concurrency import run_in_threadpool

from app.core.config import settings
from app.core.exceptions import BusinessException
from app.core.logging import logger
from app.models.attachment import Attachment
from app.models.storage_config import ProviderType, StorageConfig
from app.services.storage.adapters.base import StorageAdapter
from app.services.storage.adapters.factory import StorageAdapterFactory

# ============================================================================
# 文件类型配置
# ============================================================================

IMAGE_EXTENSIONS = {"jpg", "jpeg", "png", "gif", "webp", "bmp", "ico", "svg"}
IMAGE_MIME_TYPES = {
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
    "image/bmp",
    "image/x-icon",
    "image/svg+xml",
}

DOCUMENT_EXTENSIONS = {
    "pdf",
    "doc",
    "docx",
    "xls",
    "xlsx",
    "ppt",
    "pptx",
    "txt",
    "md",
    "csv",
    "json",
    "xml",
    "html",
    "htm",
    "rtf",
    "odt",
    "ods",
    "odp",
}
DOCUMENT_MIME_TYPES = {
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "application/vnd.ms-powerpoint",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "text/plain",
    "text/markdown",
    "text/csv",
    "application/json",
    "application/xml",
    "text/xml",
    "text/html",
    "application/rtf",
    "application/vnd.oasis.opendocument.text",
    "application/vnd.oasis.opendocument.spreadsheet",
    "application/vnd.oasis.opendocument.presentation",
}

ALLOWED_EXTENSIONS = IMAGE_EXTENSIONS | DOCUMENT_EXTENSIONS
ALLOWED_MIME_TYPES = IMAGE_MIME_TYPES | DOCUMENT_MIME_TYPES
COMPRESSIBLE_FORMATS = {"jpg", "jpeg", "png", "webp"}


class UploadService:
    """文件上传服务（支持本地存储和 S3 兼容存储）。

    根据 settings.STORAGE_PROVIDER 自动选择存储后端：
    - local_uploads: 本地文件系统
    - s3_compatible: S3 兼容存储（Supabase、MinIO、AWS S3）
    """

    MAX_FILE_SIZE: int = settings.MAX_UPLOAD_SIZE
    UPLOAD_DIR: Path = settings.UPLOAD_DIR
    IMAGE_MAX_WIDTH: int = 1920
    IMAGE_MAX_HEIGHT: int = 1920
    IMAGE_QUALITY: int = 85

    def __init__(self, db: AsyncSession):
        self.db = db
        self._adapter: StorageAdapter | None = None

    async def upload_files(
        self,
        files: list[UploadFile],
        user_uuid: UUID,
        compress: bool = True,
        thread_id: UUID | None = None,
    ) -> tuple[list[dict], list[dict]]:
        """批量上传文件。

        最佳实践：
        1. 先处理所有文件（文件 I/O，不涉及数据库）
        2. 批量创建数据库记录（单次 commit）

        Args:
            files: 文件列表
            user_uuid: 用户 UUID (str or UUID object)
            compress: 是否压缩图片
            thread_id: 可选的会话 ID

        Returns:
            (成功列表, 失败列表)
        """
        # ====================================================================
        # 阶段 1：获取存储配置并初始化适配器
        # ====================================================================
        storage_config_id, storage_config = await self._get_or_create_storage_config(user_uuid)
        self._adapter = await StorageAdapterFactory.create(storage_config)

        # ====================================================================
        # 阶段 2：处理所有文件（纯文件 I/O，无数据库操作）
        # ====================================================================
        processed = []  # 成功处理的文件信息
        failed = []  # 失败的文件

        for file in files:
            try:
                file_info = await self._process_and_save_file(
                    file=file,
                    user_uuid=user_uuid,
                    compress=compress,
                )
                processed.append(file_info)
            except BusinessException as e:
                failed.append(
                    {
                        "filename": file.filename,
                        "error": e.message,
                        "errorCode": e.error_code,
                    }
                )
            except Exception as e:
                logger.error("file_process_error", filename=file.filename, error=str(e))
                failed.append(
                    {
                        "filename": file.filename,
                        "error": "文件处理失败",
                        "errorCode": "PROCESS_FAILED",
                    }
                )

        if not processed:
            return [], failed

        # ====================================================================
        # 阶段 3：批量创建数据库记录（单次数据库操作）
        # ====================================================================
        attachments = []
        for info in processed:
            attachment = Attachment(
                user_uuid=user_uuid,
                storage_config_id=storage_config_id,
                thread_id=thread_id,
                filename=info["filename"],
                object_key=info["object_key"],
                mime_type=info["mime_type"],
                size=info["size"],
                hash=info["hash"],
            )
            attachments.append(attachment)

        # 批量添加
        self.db.add_all(attachments)
        await self.db.commit()

        # 刷新获取 ID
        for att in attachments:
            await self.db.refresh(att)

        # ====================================================================
        # 阶段 4：构建返回结果
        # ====================================================================
        base_url = settings.APP_URL.rstrip("/")
        successful = []

        for i, att in enumerate(attachments):
            info = processed[i]
            # Convert UUID to string for JSON serialization
            att_id = str(att.id)
            successful.append(
                {
                    "id": att_id,
                    "attachmentId": att_id,
                    "originalName": info["filename"],
                    "filename": info["filename"],
                    "objectKey": info["object_key"],
                    "uri": f"{base_url}/api/v1/files/view/{att_id}",
                    "size": info["size"],
                    "mimeType": info["mime_type"],
                    "hash": info["hash"],
                    "compressed": info["compressed"],
                    "threadId": str(thread_id) if thread_id else None,
                }
            )

        logger.info(
            "batch_upload_completed",
            user_uuid=user_uuid,
            total=len(files),
            successful=len(successful),
            failed=len(failed),
        )

        return successful, failed

    async def _get_or_create_storage_config(self, user_uuid: UUID) -> tuple[int | None, StorageConfig]:
        """获取或创建用户的默认存储配置。

        根据 settings.STORAGE_PROVIDER 确定存储后端类型。

        Args:
            user_uuid: 用户 UUID

        Returns:
            Tuple[config_id, StorageConfig]
        """
        target_provider = settings.STORAGE_PROVIDER

        stmt = select(StorageConfig).where(
            StorageConfig.user_uuid == user_uuid,
            StorageConfig.provider_type == target_provider,
        )
        result = await self.db.execute(stmt)
        config = result.scalar_one_or_none()

        if config:
            return config.id, config

        # 创建新配置
        if target_provider == ProviderType.S3_COMPATIBLE.value:
            # S3 兼容存储配置
            new_config = StorageConfig(
                user_uuid=user_uuid,
                provider_type=target_provider,
                name="S3 存储",
                base_path=settings.S3_BUCKET,
                credentials={
                    "endpoint_url": settings.S3_ENDPOINT,
                    "access_key": settings.S3_ACCESS_KEY,
                    "secret_key": settings.S3_SECRET_KEY,
                    "region": settings.S3_REGION,
                },
                is_readonly=False,
            )
        else:
            # 默认本地存储
            new_config = StorageConfig(
                user_uuid=user_uuid,
                provider_type=ProviderType.LOCAL_UPLOADS.value,
                name="本地存储",
                base_path=str(self.UPLOAD_DIR),
                is_readonly=False,
            )

        self.db.add(new_config)
        await self.db.commit()
        await self.db.refresh(new_config)

        logger.info(
            "storage_config_created",
            user_uuid=user_uuid,
            config_id=new_config.id,
            provider=target_provider,
        )
        return new_config.id, new_config

    async def _process_and_save_file(
        self,
        file: UploadFile,
        user_uuid: UUID,
        compress: bool,
    ) -> dict:
        """处理并保存单个文件（支持本地存储和 S3 适配器）。

        Returns:
            包含文件信息的字典
        """
        upload_id = f"up_{uuid.uuid4().hex[:8]}"

        # 1. 校验并读取文件
        content = await self._validate_and_read(file)

        # 2. 获取扩展名和 MIME 类型
        filename = file.filename or "unnamed_file"
        extension = self._get_extension(filename)
        mime_type = file.content_type
        guessed_type, _ = mimetypes.guess_type(filename)
        if guessed_type:
            mime_type = guessed_type

        # 3. 压缩图片（如果需要）
        compressed = False
        if compress and extension.lower() in COMPRESSIBLE_FORMATS:
            # Run blocking image compression in threadpool to avoid blocking event loop
            content, _ = await run_in_threadpool(self._compress_image, content, extension)
            compressed = True

        # 4. 计算哈希
        file_hash = hashlib.sha256(content).hexdigest()

        # 5. 生成存储路径
        object_key = self._generate_object_key(extension, upload_id)

        # 6. 保存文件（根据适配器类型选择方式）
        if self._adapter and settings.STORAGE_PROVIDER != "local_uploads":
            # 使用适配器保存到远程存储（S3/Supabase）
            async def content_generator() -> AsyncGenerator[bytes]:
                yield content

            object_key = await self._adapter.save(
                file_stream=content_generator(),
                filename=filename,
                content_type=mime_type,
            )
            logger.debug(
                "file_saved_via_adapter",
                upload_id=upload_id,
                filename=file.filename,
                size=len(content),
                provider=settings.STORAGE_PROVIDER,
            )
        else:
            # 本地存储：直接写入磁盘
            file_path = self.UPLOAD_DIR / object_key
            await aiofiles.os.makedirs(file_path.parent, exist_ok=True)
            async with aiofiles.open(file_path, "wb") as f:
                await f.write(content)
            logger.debug(
                "file_saved_locally",
                upload_id=upload_id,
                filename=file.filename,
                size=len(content),
            )

        return {
            "filename": file.filename,
            "object_key": object_key,
            "mime_type": mime_type,
            "size": len(content),
            "hash": file_hash,
            "compressed": compressed,
        }

    # =========================================================================
    # 其他公共方法
    # =========================================================================

    async def get_file_path(self, attachment_id: UUID, user_uuid: UUID) -> tuple[Path, Attachment]:
        """获取附件的本地文件路径。

        Args:
            attachment_id: 附件 ID
            user_uuid: 用户 UUID
        """
        stmt = select(Attachment).where(
            Attachment.id == attachment_id,
            Attachment.user_uuid == user_uuid,
        )
        result = await self.db.execute(stmt)
        attachment = result.scalar_one_or_none()

        if not attachment:
            raise BusinessException(
                message="附件不存在或无权访问",
                status_code=404,
                error_code="FILE_NOT_FOUND",
            )

        # 构建绝对文件路径（FileResponse 需要绝对路径）
        file_path = (self.UPLOAD_DIR / attachment.object_key).resolve()

        if not file_path.exists():
            raise BusinessException(
                message="文件不存在",
                status_code=404,
                error_code="FILE_NOT_FOUND",
            )

        return file_path, attachment

    async def delete_file(self, attachment_id: UUID, user_uuid: UUID) -> bool:
        """删除文件。"""
        file_path, attachment = await self.get_file_path(attachment_id, user_uuid)

        if file_path.exists():
            await aiofiles.os.remove(file_path)

        await self.db.delete(attachment)
        await self.db.commit()
        return True

    # =========================================================================
    # 私有辅助方法
    # =========================================================================

    async def _validate_and_read(self, file: UploadFile) -> bytes:
        """校验并读取文件。"""
        if not file.filename:
            raise BusinessException(
                message="文件名不能为空",
                status_code=400,
                error_code="INVALID_FILENAME",
            )

        extension = self._get_extension(file.filename)
        if extension.lower() not in ALLOWED_EXTENSIONS:
            raise BusinessException(
                message=f"不支持的文件类型: .{extension}",
                status_code=400,
                error_code="INVALID_FILE_TYPE",
            )

        content = await file.read()

        if len(content) > self.MAX_FILE_SIZE:
            size_mb = self.MAX_FILE_SIZE / (1024 * 1024)
            raise BusinessException(
                message=f"文件大小超过限制 ({size_mb:.1f}MB)",
                status_code=400,
                error_code="FILE_TOO_LARGE",
            )

        if len(content) == 0:
            raise BusinessException(
                message="文件内容为空",
                status_code=400,
                error_code="FILE_EMPTY",
            )

        return content

    def _get_extension(self, filename: str) -> str:
        """获取文件扩展名。"""
        if "." not in filename:
            return ""
        return filename.rsplit(".", 1)[-1].lower()

    def _generate_object_key(self, extension: str, upload_id: str) -> str:
        """生成存储路径。"""
        now = datetime.now(UTC)
        date_path = now.strftime("%Y/%m/%d")
        unique_suffix = uuid.uuid4().hex[:12]
        return f"{date_path}/{upload_id}_{unique_suffix}.{extension}"

    def _compress_image(self, content: bytes, extension: str) -> tuple[bytes, int]:
        """压缩图片（同步方法）。"""
        try:
            image = Image.open(io.BytesIO(content))
            original_width, original_height = image.size

            # 调整尺寸
            if original_width > self.IMAGE_MAX_WIDTH or original_height > self.IMAGE_MAX_HEIGHT:
                ratio = original_width / original_height
                if original_width > original_height:
                    new_width = self.IMAGE_MAX_WIDTH
                    new_height = int(new_width / ratio)
                else:
                    new_height = self.IMAGE_MAX_HEIGHT
                    new_width = int(new_height * ratio)
                image = image.resize((new_width, new_height), Image.Resampling.LANCZOS)

            # RGBA -> RGB
            if image.mode == "RGBA" and extension.lower() in ("jpg", "jpeg"):
                background = Image.new("RGB", image.size, (255, 255, 255))
                background.paste(image, mask=image.split()[3])
                image = background

            # 保存
            buffer = io.BytesIO()
            format_map = {"jpg": "JPEG", "jpeg": "JPEG", "png": "PNG", "webp": "WEBP"}
            save_format = format_map.get(extension.lower(), "PNG")

            save_kwargs = {}
            if save_format == "JPEG":
                save_kwargs = {"quality": self.IMAGE_QUALITY, "optimize": True}
            elif save_format == "PNG":
                save_kwargs = {"optimize": True}
            elif save_format == "WEBP":
                save_kwargs = {"quality": self.IMAGE_QUALITY}

            image.save(buffer, format=save_format, **save_kwargs)
            compressed = buffer.getvalue()
            return compressed, len(compressed)

        except Exception as e:
            logger.warning("compression_failed", error=str(e))
            # 压缩失败时返回原内容
            return content, len(content)
