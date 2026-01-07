"""Attachment processing service for handling file attachments in conversations."""
from __future__ import annotations

import base64
from pathlib import Path
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.core.logging import logger
from app.models.attachment import Attachment


class AttachmentProcessor:
    """Service for processing and managing file attachments."""

    def __init__(self, db_session: AsyncSession):
        """Initialize the attachment processor.

        Args:
            db_session: Async database session
        """
        self.db_session = db_session

    async def load_attachments(self, attachment_ids: list[UUID], user_uuid: UUID) -> list[dict]:
        """Load attachments from database by IDs.

        Args:
            attachment_ids: List of attachment IDs to load
            user_uuid: User ID for permission check

        Returns:
            List of attachment dictionaries with metadata and access URLs
        """
        if not attachment_ids:
            return []

        try:
            result = await self.db_session.execute(
                select(Attachment).where(Attachment.id.in_(attachment_ids)).where(Attachment.user_uuid == user_uuid)
            )
            attachments = result.scalars().all()

            if not attachments:
                logger.warning(
                    "no_attachments_found",
                    attachment_ids=attachment_ids,
                    user_uuid=user_uuid,
                )
                return []

            processed_attachments = []
            for attachment in attachments:
                file_path = Path(settings.UPLOAD_DIR) / attachment.object_key

                processed_attachment = {
                    "id": attachment.id,
                    "filename": attachment.filename,
                    "object_key": attachment.object_key,
                    "mime_type": attachment.mime_type,
                    "size": attachment.size,
                    "type": self._get_attachment_type(attachment.mime_type or ""),
                    "file_path": str(file_path),
                    "access_url": await self._get_access_url(attachment, file_path),
                }
                processed_attachments.append(processed_attachment)

            logger.debug(
                "attachments_loaded",
                count=len(processed_attachments),
                user_uuid=user_uuid,
            )

            return processed_attachments
        except Exception as e:
            logger.error(
                "failed_to_load_attachments",
                attachment_ids=attachment_ids,
                error=str(e),
            )
            return []

    def _get_attachment_type(self, mime_type: str) -> str:
        """Determine attachment type from MIME type.

        Args:
            mime_type: MIME type string

        Returns:
            Attachment type: 'image', 'text', 'document', or 'other'
        """
        if mime_type.startswith("image/"):
            return "image"

        text_types = [
            "text/plain",
            "text/markdown",
            "text/csv",
            "application/json",
            "application/xml",
            "text/xml",
        ]
        if mime_type in text_types:
            return "text"

        document_types = [
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "application/vnd.ms-excel",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        ]
        if mime_type in document_types:
            return "document"

        return "other"

    async def _get_access_url(self, attachment: Attachment, file_path: Path) -> str:
        """Get access URL for an attachment.

        For images, returns base64 data URL.
        For other files, returns API URL.

        Args:
            attachment: Attachment model instance
            file_path: Path to the file

        Returns:
            Access URL string
        """
        mime_type = attachment.mime_type or ""
        # For images, convert to base64 data URL
        if mime_type.startswith("image/"):
            try:
                if file_path.exists():
                    with open(file_path, "rb") as f:
                        image_data = f.read()
                    base64_data = base64.b64encode(image_data).decode("utf-8")
                    return f"data:{mime_type};base64,{base64_data}"
            except Exception as e:
                logger.error(
                    "failed_to_convert_image_to_base64",
                    attachment_id=attachment.id,
                    error=str(e),
                )

        # Fallback to API URL
        return f"{settings.API_V1_STR}/files/view/{attachment.id}"

    def get_image_attachments(self, attachments: list[dict]) -> list[dict]:
        """Filter attachments to get only images.

        Args:
            attachments: List of attachment dictionaries

        Returns:
            List of image attachments
        """
        return [att for att in attachments if att.get("type") == "image"]

    def process_attachments_to_text(self, attachments: list[dict], user_text: str) -> str:
        """Process attachments and combine with user text.

        For text files, embeds content.
        For images, adds description.
        For other files, adds metadata.

        Args:
            attachments: List of attachment dictionaries
            user_text: Original user input text

        Returns:
            Processed text with attachment information
        """
        if not attachments:
            return user_text

        processed_text = user_text

        for attachment in attachments:
            att_type = attachment.get("type")

            if att_type == "text":
                processed_text += self._process_text_file(attachment)
            elif att_type == "document":
                processed_text += self._process_document(attachment)
            elif att_type == "image":
                # Images are handled separately via imageUrl
                pass
            else:
                processed_text += self._process_other_file(attachment)

        return processed_text

    def _process_text_file(self, attachment: dict) -> str:
        """Process a text file attachment.

        Args:
            attachment: Attachment dictionary

        Returns:
            Formatted text content
        """
        try:
            file_path = Path(attachment["file_path"])
            if file_path.exists():
                with open(file_path, encoding="utf-8") as f:
                    content = f.read()

                # Limit content length
                max_length = 10000
                if len(content) > max_length:
                    content = content[:max_length] + "\n...(内容已截断)"

                return f"\n\n[附件: {attachment['filename']}]\n```\n{content}\n```"
        except Exception as e:
            logger.error(
                "failed_to_read_text_file",
                attachment_id=attachment["id"],
                error=str(e),
            )

        return f"\n\n[附件: {attachment['filename']} - 读取失败]"

    def _process_document(self, attachment: dict) -> str:
        """Process a document attachment.

        Args:
            attachment: Attachment dictionary

        Returns:
            Formatted document information
        """
        size_formatted = self._format_file_size(attachment["size"])
        return f"\n\n[文档附件: {attachment['filename']}, 大小: {size_formatted}]"

    def _process_other_file(self, attachment: dict) -> str:
        """Process other file types.

        Args:
            attachment: Attachment dictionary

        Returns:
            Formatted file information
        """
        size_formatted = self._format_file_size(attachment["size"])
        return f"\n\n[附件: {attachment['filename']}, 类型: {attachment['mime_type']}, 大小: {size_formatted}]"

    def _format_file_size(self, size_bytes: int) -> str:
        """Format file size in human-readable format.

        Args:
            size_bytes: File size in bytes

        Returns:
            Formatted size string
        """
        if size_bytes < 1024:
            return f"{size_bytes} B"
        elif size_bytes < 1048576:
            return f"{size_bytes / 1024:.2f} KB"
        else:
            return f"{size_bytes / 1048576:.2f} MB"

    def format_attachments_for_storage(self, attachments: list[dict]) -> list[dict]:
        """Format attachments for database storage.

        Args:
            attachments: List of attachment dictionaries

        Returns:
            List of formatted attachment metadata
        """
        return [
            {
                "id": att["id"],
                "filename": att["filename"],
                "object_key": att["object_key"],
                "mime_type": att["mime_type"],
                "size": att["size"],
                "type": att["type"],
            }
            for att in attachments
        ]
