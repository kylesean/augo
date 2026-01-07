"""Attachment processing middleware for multimodal LLM interactions.

This middleware handles image and document attachments in chat messages:
- Images: Converted to base64 and injected as multimodal content
- Documents: Text extraction for context injection (Phase 2)

Based on LangChain 1.0 middleware best practices.
"""

import base64
from pathlib import Path
from typing import Any, List, Optional
from uuid import UUID

import aiofiles
from langchain_core.messages import BaseMessage, HumanMessage
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.core.langgraph.middleware.base import BaseMiddleware
from app.core.logging import logger
from app.models.attachment import Attachment


class AttachmentMiddleware(BaseMiddleware):
    """Middleware for processing message attachments.

    This middleware:
    1. Extracts attachment references from the config
    2. Loads attachment metadata from database
    3. Classifies attachments (image/document)
    4. For images: converts to base64, builds multimodal messages
    5. For documents: extracts text for context (Phase 2)

    Follows LangChain 1.0 middleware best practices.
    """

    name = "AttachmentMiddleware"

    # Supported image MIME types for multimodal LLM
    IMAGE_MIME_TYPES = {
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/webp",
    }

    # Supported document MIME types (Phase 2)
    DOCUMENT_MIME_TYPES = {
        "application/pdf",
        "text/plain",
        "text/markdown",
    }

    def __init__(self, db_session_factory: Any) -> None:
        """Initialize with database session factory.

        Args:
            db_session_factory: Callable that returns AsyncSession
        """
        self.db_session_factory = db_session_factory

    async def before_invoke(
        self,
        messages: list[BaseMessage],
        config: dict,
    ) -> tuple[list[BaseMessage], dict]:
        """Process attachments before agent invocation.

        Args:
            messages: List of messages to send to agent
            config: Configuration dict for agent invocation

        Returns:
            Modified (messages, config) tuple with attachments processed
        """
        # Extract attachment IDs from config
        attachment_ids = config.get("configurable", {}).get("attachment_ids", [])
        user_uuid = config.get("configurable", {}).get("user_uuid")

        if not attachment_ids:
            logger.debug("attachment_middleware_skipped_no_attachments")
            return messages, config

        if not user_uuid:
            logger.warning("attachment_middleware_skipped_no_user_uuid")
            return messages, config

        # Get thread_id (session_id) from config for attachment linking
        thread_id = config.get("configurable", {}).get("thread_id")

        try:
            # Load attachments from database and update thread_id
            attachments = await self._load_attachments(attachment_ids, user_uuid, thread_id=thread_id)

            if not attachments:
                logger.warning(
                    "attachment_middleware_no_attachments_found",
                    requested_ids=attachment_ids,
                    user_uuid=user_uuid,
                )
                return messages, config

            # Classify attachments
            images, documents = self._classify_attachments(attachments)

            # Process images (Phase 1)
            if images:
                messages = await self._inject_images(messages, images)
                logger.info(
                    "attachment_images_injected",
                    image_count=len(images),
                    user_uuid=user_uuid,
                )

            # Register documents for RAG tool (Phase 2+)
            if documents:
                config = await self._register_documents(config, documents)
                logger.info(
                    "attachment_documents_registered",
                    document_count=len(documents),
                    user_uuid=user_uuid,
                )

            return messages, config

        except Exception as e:
            logger.error(
                "attachment_middleware_failed",
                error=str(e),
                attachment_ids=attachment_ids,
                user_uuid=user_uuid,
            )
            # Continue without attachments on error
            return messages, config

    async def _load_attachments(
        self,
        attachment_ids: List[str],
        user_uuid: str,
        thread_id: Optional[str] = None,
    ) -> List[Attachment]:
        """Load attachments from database and optionally link to thread.

        Args:
            attachment_ids: List of attachment UUIDs
            user_uuid: User UUID for authorization
            thread_id: Optional thread/session ID to link attachments to

        Returns:
            List of Attachment objects
        """
        from sqlalchemy import update

        async with self.db_session_factory() as session:
            # Convert string IDs to UUIDs
            uuids = [UUID(aid) for aid in attachment_ids]

            # Query by user_uuid (string)
            stmt = select(Attachment).where(
                Attachment.id.in_(uuids),
                Attachment.user_uuid == user_uuid,
            )
            result = await session.execute(stmt)
            attachments = list(result.scalars().all())

            # Update thread_id for attachments that don't have one yet
            if thread_id and attachments:
                thread_id_str = str(thread_id)  # Ensure thread_id is string
                for att in attachments:
                    if att.thread_id is None:
                        att.thread_id = thread_id_str
                await session.commit()
                logger.info(
                    "attachments_linked_to_thread",
                    thread_id=thread_id,
                    attachment_count=len(attachments),
                )

            logger.debug(
                "attachments_loaded",
                requested=len(attachment_ids),
                found=len(attachments),
                thread_id=thread_id,
            )

            return attachments

    def _classify_attachments(
        self,
        attachments: List[Attachment],
    ) -> tuple[List[Attachment], List[Attachment]]:
        """Classify attachments into images and documents.

        Args:
            attachments: List of attachments to classify

        Returns:
            Tuple of (images, documents)
        """
        images = []
        documents = []

        for att in attachments:
            if att.mime_type in self.IMAGE_MIME_TYPES:
                images.append(att)
            elif att.mime_type in self.DOCUMENT_MIME_TYPES:
                documents.append(att)
            else:
                logger.debug(
                    "attachment_type_unknown",
                    attachment_id=str(att.id),
                    mime_type=att.mime_type,
                )

        return images, documents

    async def _inject_images(
        self,
        messages: list[BaseMessage],
        images: List[Attachment],
    ) -> list[BaseMessage]:
        """Convert images to base64 and inject into messages.

        For cloud LLMs (OpenAI, DeepSeek), we must use base64 since
        they cannot access localhost URLs.

        Args:
            messages: List of messages
            images: List of image attachments

        Returns:
            Modified messages with multimodal content
        """
        # Build image parts
        image_parts = []
        for img in images:
            try:
                b64_data = await self._read_image_as_base64(img)
                image_parts.append(
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:{img.mime_type};base64,{b64_data}",
                            "detail": "auto",
                        },
                    }
                )
                logger.debug(
                    "image_converted_to_base64",
                    attachment_id=str(img.id),
                    filename=img.filename,
                )
            except Exception as e:
                logger.error(
                    "image_conversion_failed",
                    attachment_id=str(img.id),
                    error=str(e),
                )

        if not image_parts:
            return messages

        # Find last user message and convert to multimodal
        for i in range(len(messages) - 1, -1, -1):
            msg = messages[i]
            if isinstance(msg, HumanMessage):
                # Convert to multimodal format
                text_content = msg.content if isinstance(msg.content, str) else str(msg.content)
                multimodal_content = [
                    {"type": "text", "text": text_content},
                    *image_parts,
                ]

                # 保存 attachment_ids 到 additional_kwargs，用于后续历史加载
                attachment_ids = [str(img.id) for img in images]
                messages[i] = HumanMessage(
                    content=multimodal_content,
                    additional_kwargs={
                        **getattr(msg, "additional_kwargs", {}),
                        "attachment_ids": attachment_ids,
                    },
                )
                break

        return messages

    async def _read_image_as_base64(self, attachment: Attachment) -> str:
        """Read image file and encode as base64.

        Args:
            attachment: Image attachment

        Returns:
            Base64 encoded string
        """
        file_path = Path(settings.UPLOAD_DIR) / attachment.object_key

        if not file_path.exists():
            raise FileNotFoundError(f"Image file not found: {file_path}")

        async with aiofiles.open(file_path, "rb") as f:
            content = await f.read()

        return base64.b64encode(content).decode("utf-8")

    async def _register_documents(
        self,
        config: dict,
        documents: List[Attachment],
    ) -> dict:
        """Register documents in config for RAG tool access.

        Phase 2: Simple text extraction
        Phase 3: Vector store integration

        Args:
            config: Current config dict
            documents: List of document attachments

        Returns:
            Modified config with documents registered
        """
        doc_contexts = []

        for doc in documents:
            try:
                # Phase 2: Simple text extraction
                text = await self._extract_document_text(doc)
                doc_contexts.append(
                    {
                        "id": str(doc.id),
                        "filename": doc.filename,
                        "mime_type": doc.mime_type,
                        "text": text[:4000],  # Limit context length
                    }
                )
            except Exception as e:
                logger.error(
                    "document_extraction_failed",
                    attachment_id=str(doc.id),
                    error=str(e),
                )

        if doc_contexts:
            config.setdefault("configurable", {})
            config["configurable"]["available_documents"] = doc_contexts

        return config

    async def _extract_document_text(self, attachment: Attachment) -> str:
        """Extract text from document.

        Currently supports:
        - Plain text (.txt)
        - Markdown (.md)
        - PDF (Phase 2+, requires additional library)

        Args:
            attachment: Document attachment

        Returns:
            Extracted text content
        """
        file_path = Path(settings.UPLOAD_DIR) / attachment.object_key

        if not file_path.exists():
            raise FileNotFoundError(f"Document file not found: {file_path}")

        # Plain text and markdown
        if attachment.mime_type in {"text/plain", "text/markdown"}:
            async with aiofiles.open(file_path, "r", encoding="utf-8") as f:
                return await f.read()

        # PDF - placeholder for Phase 2
        if attachment.mime_type == "application/pdf":
            return f"[PDF 文档: {attachment.filename}，PDF 解析功能即将上线]"

        return f"[文档: {attachment.filename}]"
