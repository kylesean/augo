"""History service for LangGraph conversation history with attachment URL hydration.

This service provides functionality to:
- Retrieve conversation history from LangGraph checkpointer
- Dynamically inject temporary signed URLs for attachments
- Support message format transformation for frontend consumption
"""

from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.core.logging import logger
from app.models.attachment import Attachment
from app.models.storage_config import StorageConfig
from app.services.storage.adapters import StorageAdapterFactory


class HistoryService:
    """Service for managing conversation history with attachment hydration.

    Handles reading LangGraph checkpoints and injecting temporary signed URLs
    for attachments referenced in messages via attachment_id in additional_kwargs.
    """

    def __init__(self, db: AsyncSession):
        """Initialize history service.

        Args:
            db: Async database session
        """
        self.db = db

    async def hydrate_message_attachments(
        self,
        messages: List[Dict[str, Any]],
        user_uuid: str,
        expire_seconds: int = 3600,
    ) -> List[Dict[str, Any]]:
        """Hydrate messages with temporary signed URLs for attachments.

        Scans messages for attachment_id references and injects temporary
        download URLs that can be used by the frontend.

        Args:
            messages: List of message dicts (from LangGraph state or checkpoint)
            user_uuid: User UUID for permission validation
            expire_seconds: URL expiration time in seconds

        Returns:
            Messages with injected attachment URLs
        """
        if not messages:
            return messages

        # Collect all attachment IDs from messages
        attachment_ids = set()
        for msg in messages:
            # Check additional_kwargs for attachment_id
            additional_kwargs = msg.get("additional_kwargs", {})
            if "attachment_id" in additional_kwargs:
                attachment_ids.add(additional_kwargs["attachment_id"])

            # Check for attachments list in content
            if isinstance(msg.get("content"), list):
                for item in msg["content"]:
                    if isinstance(item, dict) and "attachment_id" in item:
                        attachment_ids.add(item["attachment_id"])

        if not attachment_ids:
            return messages

        # Fetch attachments and their storage configs
        attachment_urls = await self._get_attachment_urls(
            list(attachment_ids),
            user_uuid,
            expire_seconds,
        )

        # Inject URLs into messages
        hydrated_messages = []
        for msg in messages:
            hydrated_msg = msg.copy()

            # Hydrate additional_kwargs
            additional_kwargs = hydrated_msg.get("additional_kwargs", {})
            if "attachment_id" in additional_kwargs:
                att_id = additional_kwargs["attachment_id"]
                if att_id in attachment_urls:
                    additional_kwargs["attachment_url"] = attachment_urls[att_id]["url"]
                    additional_kwargs["attachment_info"] = attachment_urls[att_id]
                hydrated_msg["additional_kwargs"] = additional_kwargs

            # Hydrate content list items
            if isinstance(hydrated_msg.get("content"), list):
                hydrated_content = []
                for item in hydrated_msg["content"]:
                    if isinstance(item, dict) and "attachment_id" in item:
                        att_id = item["attachment_id"]
                        if att_id in attachment_urls:
                            item = item.copy()
                            item["attachment_url"] = attachment_urls[att_id]["url"]
                            item["attachment_info"] = attachment_urls[att_id]
                    hydrated_content.append(item)
                hydrated_msg["content"] = hydrated_content

            hydrated_messages.append(hydrated_msg)

        logger.info(
            "messages_hydrated",
            message_count=len(messages),
            attachment_count=len(attachment_ids),
            hydrated_count=len(attachment_urls),
        )

        return hydrated_messages

    async def _get_attachment_urls(
        self,
        attachment_ids: List[int],
        user_uuid: str,
        expire_seconds: int,
    ) -> Dict[int, Dict[str, Any]]:
        """Fetch attachments and generate temporary URLs.

        Args:
            attachment_ids: List of attachment IDs to fetch
            user_uuid: User ID for permission check
            expire_seconds: URL expiration time

        Returns:
            Dict mapping attachment_id to URL info
        """
        if not attachment_ids:
            return {}

        # Fetch attachments with storage configs
        stmt = (
            select(Attachment, StorageConfig)
            .join(StorageConfig, Attachment.storage_config_id == StorageConfig.id)
            .where(
                Attachment.id.in_(attachment_ids),
                Attachment.user_uuid == user_uuid,
            )
        )
        result = await self.db.execute(stmt)
        rows = result.all()

        # Generate URLs for each attachment
        urls = {}
        for attachment, storage_config in rows:
            try:
                adapter = await StorageAdapterFactory.create(storage_config)
                object_key = attachment.object_key

                url = await adapter.get_download_url(
                    object_key,
                    expire_seconds=expire_seconds,
                    filename=attachment.filename,
                )

                urls[attachment.id] = {
                    "url": url,
                    "filename": attachment.filename,
                    "mime_type": attachment.mime_type,
                    "size": attachment.size,
                    "expires_at": (datetime.now(timezone.utc).timestamp() + expire_seconds),
                }

            except Exception as e:
                logger.warning(
                    "attachment_url_generation_failed",
                    attachment_id=attachment.id,
                    error=str(e),
                )
                continue

        return urls

    async def get_thread_attachments(
        self,
        thread_id: str,
        user_uuid: str,
        expire_seconds: int = 3600,
    ) -> List[Dict[str, Any]]:
        """Get all attachments for a conversation thread with URLs.

        Args:
            thread_id: LangGraph thread/conversation ID
            user_uuid: User ID for permission check
            expire_seconds: URL expiration time

        Returns:
            List of attachment info dicts with temporary URLs
        """
        stmt = (
            select(Attachment, StorageConfig)
            .join(StorageConfig, Attachment.storage_config_id == StorageConfig.id)
            .where(
                Attachment.thread_id == thread_id,
                Attachment.user_uuid == user_uuid,
            )
            .order_by(Attachment.created_at.desc())
        )
        result = await self.db.execute(stmt)
        rows = result.all()

        attachments = []
        for attachment, storage_config in rows:
            try:
                adapter = await StorageAdapterFactory.create(storage_config)
                object_key = attachment.object_key

                url = await adapter.get_download_url(
                    object_key,
                    expire_seconds=expire_seconds,
                    filename=attachment.filename,
                )

                attachments.append(
                    {
                        "id": attachment.id,
                        "url": url,
                        "filename": attachment.filename,
                        "mime_type": attachment.mime_type,
                        "size": attachment.size,
                        "created_at": attachment.created_at.isoformat() + "Z",
                        "expires_at": (datetime.now(timezone.utc).timestamp() + expire_seconds),
                    }
                )

            except Exception as e:
                logger.warning(
                    "thread_attachment_url_failed",
                    attachment_id=attachment.id,
                    thread_id=thread_id,
                    error=str(e),
                )
                continue

        logger.info(
            "thread_attachments_fetched",
            thread_id=thread_id,
            attachment_count=len(attachments),
        )

        return attachments

    async def format_conversation_history(
        self,
        messages: List[Any],
        user_uuid: int,
        expire_seconds: int = 3600,
    ) -> List[Dict[str, Any]]:
        """Format LangGraph messages for frontend consumption.

        Converts LangChain message objects to frontend-friendly format
        and hydrates attachment URLs.

        Args:
            messages: List of LangChain message objects
            user_uuid: User ID for permission check
            expire_seconds: URL expiration time

        Returns:
            Formatted message list with hydrated attachments
        """
        from langchain_core.messages import AIMessage, HumanMessage, ToolMessage

        formatted = []
        for msg in messages:
            # Convert to dict format
            msg_dict = {
                "id": getattr(msg, "id", None),
                "role": self._get_message_role(msg),
                "content": msg.content if hasattr(msg, "content") else str(msg),
                "additional_kwargs": getattr(msg, "additional_kwargs", {}),
            }

            # Add tool-specific fields
            if isinstance(msg, ToolMessage):
                msg_dict["tool_call_id"] = getattr(msg, "tool_call_id", None)
                msg_dict["name"] = getattr(msg, "name", None)

            # Add AI message tool calls
            if isinstance(msg, AIMessage) and hasattr(msg, "tool_calls"):
                msg_dict["tool_calls"] = msg.tool_calls

            formatted.append(msg_dict)

        # Hydrate attachment URLs
        return await self.hydrate_message_attachments(
            formatted,
            user_uuid,
            expire_seconds,
        )

    def _get_message_role(self, msg: Any) -> str:
        """Determine message role from LangChain message type."""
        from langchain_core.messages import AIMessage, HumanMessage, SystemMessage, ToolMessage

        if isinstance(msg, HumanMessage):
            return "user"
        elif isinstance(msg, AIMessage):
            return "assistant"
        elif isinstance(msg, ToolMessage):
            return "tool"
        elif isinstance(msg, SystemMessage):
            return "system"
        else:
            return "unknown"
