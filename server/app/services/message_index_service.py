"""Message Index Service for dual-write pattern.

This service handles writing chat messages to the searchable_messages table,
enabling full-text search across conversation history.

The dual-write pattern:
1. Primary storage: LangGraph checkpoints (source of truth for conversation state)
2. Secondary storage: searchable_messages table (optimized for full-text search)
"""

from uuid import UUID

from sqlalchemy import delete

from app.core.database import get_session_context
from app.core.logging import logger
from app.models.searchable_message import SearchableMessage


class MessageIndexService:
    """Service for indexing chat messages for full-text search.

    This service implements the "write" side of the dual-write pattern.
    Messages are indexed asynchronously to avoid blocking the chat stream.
    """

    async def index_message(
        self,
        thread_id: UUID,
        user_uuid: UUID,
        role: str,
        content: str,
    ) -> SearchableMessage | None:
        """Index a single message for full-text search.

        Args:
            thread_id: LangGraph thread_id (same as session_id)
            user_uuid: Owner's UUID for access control
            role: Message role - 'user' or 'assistant'
            content: Message text content

        Returns:
            SearchableMessage if successful, None otherwise
        """
        if not content or not content.strip():
            logger.debug(
                "message_index_skipped_empty",
                thread_id=thread_id,
                role=role,
            )
            return None

        try:
            # Create searchable message record
            message = SearchableMessage(
                thread_id=thread_id,
                user_uuid=user_uuid,
                role=role,
                content=content.strip(),
            )

            # Write to database
            async with get_session_context() as db:
                db.add(message)
                await db.commit()
                await db.refresh(message)

            logger.debug(
                "message_indexed",
                thread_id=thread_id,
                role=role,
                content_length=len(content),
                message_id=str(message.id),
            )

            return message

        except Exception as e:
            # Log error but don't fail - indexing is non-critical
            logger.error(
                "message_index_failed",
                thread_id=thread_id,
                role=role,
                error=str(e),
                exc_info=True,
            )
            return None

    async def index_user_message(
        self,
        thread_id: UUID,
        user_uuid: UUID,
        content: str,
    ) -> SearchableMessage | None:
        """Index a user message.

        Convenience method for indexing user messages.

        Args:
            thread_id: Session/thread ID
            user_uuid: User's UUID
            content: Message content

        Returns:
            SearchableMessage if successful, None otherwise
        """
        return await self.index_message(
            thread_id=thread_id,
            user_uuid=user_uuid,
            role="user",
            content=content,
        )

    async def index_assistant_message(
        self,
        thread_id: UUID,
        user_uuid: UUID,
        content: str,
    ) -> SearchableMessage | None:
        """Index an assistant message.

        Convenience method for indexing assistant responses.

        Args:
            thread_id: Session/thread ID
            user_uuid: User's UUID
            content: Message content

        Returns:
            SearchableMessage if successful, None otherwise
        """
        return await self.index_message(
            thread_id=thread_id,
            user_uuid=user_uuid,
            role="assistant",
            content=content,
        )

    async def delete_thread_messages(
        self,
        thread_id: UUID,
    ) -> int:
        """Delete all indexed messages for a thread.

        Called when a session/thread is deleted or cleared.

        Args:
            thread_id: Session/thread ID

        Returns:
            Number of messages deleted
        """
        try:
            async with get_session_context() as db:
                stmt = delete(SearchableMessage).where(SearchableMessage.thread_id == thread_id)
                result = await db.execute(stmt)
                await db.commit()
                deleted_count = getattr(result, "rowcount", 0) or 0

            logger.info(
                "thread_messages_deleted",
                thread_id=thread_id,
                deleted_count=deleted_count,
            )

            return deleted_count

        except Exception as e:
            logger.error(
                "thread_messages_delete_failed",
                thread_id=thread_id,
                error=str(e),
                exc_info=True,
            )
            return 0


# Singleton instance
message_index_service = MessageIndexService()
