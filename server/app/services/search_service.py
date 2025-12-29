"""Search service for conversation full-text search.

Provides session title search with Chinese tokenization support using jieba.
"""

import re
from typing import Optional

import jieba
from sqlmodel import select

from app.core.database import get_session_context
from app.core.logging import logger
from app.models.session import Session
from app.schemas.search import HighlightRange, SearchResult
from app.utils.types import UUIDLike


class SearchService:
    """Service for full-text search of conversation sessions.

    Currently supports searching session titles with Chinese tokenization.
    Uses jieba for Chinese word segmentation and PostgreSQL ILIKE for matching.
    """

    def __init__(self):
        """Initialize search service."""
        # Initialize jieba (lazy loading, first call may be slow)
        jieba.setLogLevel(20)  # Suppress jieba logs

    def tokenize_query(self, query: str) -> list[str]:
        """Tokenize search query using jieba for Chinese text.

        Uses jieba.cut_for_search mode which is optimized for search engines.
        Also handles English words and mixed content.

        Args:
            query: Raw search query string

        Returns:
            List of tokens for search
        """
        # Use jieba's search mode for better recall
        tokens = list(jieba.cut_for_search(query))
        # Filter out empty tokens and single chars that are common
        tokens = [t.strip() for t in tokens if t.strip() and len(t.strip()) >= 1]
        # Remove duplicates while preserving order
        seen = set()
        unique_tokens = []
        for t in tokens:
            if t not in seen:
                seen.add(t)
                unique_tokens.append(t)
        return unique_tokens

    def generate_highlights(self, text: str, query: str, field: str) -> list[HighlightRange]:
        """Generate highlight ranges for matching text.

        Finds all occurrences of query tokens in text and returns their positions.

        Args:
            text: Text to search in
            query: Original search query
            field: Field name ('title' or 'snippet')

        Returns:
            List of HighlightRange objects
        """
        highlights = []
        query_lower = query.lower()
        text_lower = text.lower()

        # First, try to match the entire query
        start_idx = 0
        while True:
            idx = text_lower.find(query_lower, start_idx)
            if idx == -1:
                break
            highlights.append(
                HighlightRange(
                    start=idx,
                    end=idx + len(query),
                    field=field,
                )
            )
            start_idx = idx + 1

        # If no full match, try tokenized matching
        if not highlights:
            tokens = self.tokenize_query(query)
            for token in tokens:
                token_lower = token.lower()
                start_idx = 0
                while True:
                    idx = text_lower.find(token_lower, start_idx)
                    if idx == -1:
                        break
                    highlights.append(
                        HighlightRange(
                            start=idx,
                            end=idx + len(token),
                            field=field,
                        )
                    )
                    start_idx = idx + 1

        # Sort by start position and remove overlaps
        highlights.sort(key=lambda h: h.start)
        merged = []
        for h in highlights:
            if not merged or h.start >= merged[-1].end:
                merged.append(h)
            elif h.end > merged[-1].end:
                # Extend the previous highlight
                merged[-1] = HighlightRange(
                    start=merged[-1].start,
                    end=h.end,
                    field=field,
                )
        return merged

    async def search_sessions(
        self,
        user_uuid: UUIDLike,
        query: str,
        limit: int = 20,
    ) -> list[SearchResult]:
        """Search user's session titles.

        Uses PostgreSQL ILIKE for pattern matching.
        Tokenizes query for better Chinese language support.

        Args:
            user_uuid: User's UUID (UUID or string)
            query: Search query string
            limit: Maximum number of results

        Returns:
            List of SearchResult objects with highlights
        """
        if not query.strip():
            return []

        # Tokenize for matching
        tokens = self.tokenize_query(query)
        if not tokens:
            return []

        logger.info(
            "search_sessions_start",
            user_uuid=user_uuid,
            query=query,
            tokens=tokens,
            limit=limit,
        )

        try:
            # Build ILIKE patterns for each token
            # Search sessions where title contains any of the tokens
            from sqlalchemy import or_

            async with get_session_context() as db:
                # Build query with OR conditions for each token
                base_query = select(Session).where(Session.user_uuid == str(user_uuid))

                conditions = []
                for token in tokens:
                    # Escape special characters for LIKE
                    escaped_token = token.replace("%", r"\%").replace("_", r"\_")
                    conditions.append(Session.name.ilike(f"%{escaped_token}%"))

                if conditions:
                    base_query = base_query.where(or_(*conditions))

                # Order by updated_at descending and limit
                base_query = base_query.order_by(Session.updated_at.desc()).limit(limit)

                result = await db.execute(base_query)
                results = result.scalars().all()

            # Convert to SearchResult with highlights
            search_results = []
            for s in results:
                title_highlights = self.generate_highlights(s.name, query, "title")
                search_results.append(
                    SearchResult(
                        id=str(s.id),  # Convert UUID to string
                        title=s.name,
                        snippet=s.name,  # For now, snippet is same as title
                        message_id=None,
                        created_at=s.created_at,
                        updated_at=s.updated_at,
                        highlights=title_highlights,
                    )
                )

            logger.info(
                "search_sessions_complete",
                user_uuid=user_uuid,
                result_count=len(search_results),
            )

            return search_results

        except Exception as e:
            logger.error(
                "search_sessions_failed",
                user_uuid=user_uuid,
                query=query,
                error=str(e),
                exc_info=True,
            )
            raise

    async def search_messages(
        self,
        user_uuid: UUIDLike,
        query: str,
        limit: int = 20,
    ) -> list[SearchResult]:
        """Search user's message content from searchable_messages table.

        Uses PostgreSQL ILIKE for pattern matching.
        Returns message content snippets with highlights.

        Args:
            user_uuid: User's UUID (UUID or string)
            query: Search query string
            limit: Maximum number of results

        Returns:
            List of SearchResult objects with message snippets
        """
        if not query.strip():
            return []

        tokens = self.tokenize_query(query)
        if not tokens:
            return []

        logger.info(
            "search_messages_start",
            user_uuid=user_uuid,
            query=query,
            tokens=tokens,
            limit=limit,
        )

        try:
            from sqlalchemy import or_

            from app.models.searchable_message import SearchableMessage

            async with get_session_context() as db:
                base_query = select(SearchableMessage).where(SearchableMessage.user_uuid == str(user_uuid))

                conditions = []
                for token in tokens:
                    escaped_token = token.replace("%", r"\%").replace("_", r"\_")
                    conditions.append(SearchableMessage.content.ilike(f"%{escaped_token}%"))

                if conditions:
                    base_query = base_query.where(or_(*conditions))

                # Order by created_at descending and limit
                base_query = base_query.order_by(SearchableMessage.created_at.desc()).limit(limit)

                result = await db.execute(base_query)
                results = result.scalars().all()

            # Convert to SearchResult with snippets
            search_results = []
            for msg in results:
                # Create snippet (truncate if too long)
                content = msg.content
                snippet = content[:150] + "..." if len(content) > 150 else content

                # Generate highlights for the snippet
                snippet_highlights = self.generate_highlights(snippet, query, "snippet")

                search_results.append(
                    SearchResult(
                        id=str(msg.thread_id),  # session_id - 转换 UUID 为字符串
                        title="",  # Will be filled by combined_search
                        snippet=snippet,
                        message_id=str(msg.id),
                        created_at=msg.created_at,
                        updated_at=msg.updated_at,
                        highlights=snippet_highlights,
                    )
                )

            logger.info(
                "search_messages_complete",
                user_uuid=user_uuid,
                result_count=len(search_results),
            )

            return search_results

        except Exception as e:
            logger.error(
                "search_messages_failed",
                user_uuid=user_uuid,
                query=query,
                error=str(e),
                exc_info=True,
            )
            raise

    async def combined_search(
        self,
        user_uuid: UUIDLike,
        query: str,
        limit: int = 20,
    ) -> list[SearchResult]:
        """Search both session titles and message content.

        Combines results from session title search and message content search,
        deduplicating by session_id and prioritizing title matches.

        Args:
            user_uuid: User's UUID (UUID or string)
            query: Search query string
            limit: Maximum number of results

        Returns:
            List of SearchResult objects
        """
        # Search session titles first
        title_results = await self.search_sessions(user_uuid, query, limit)

        # Search message content
        try:
            message_results = await self.search_messages(user_uuid, query, limit)
        except Exception as e:
            # If message table doesn't exist yet (migration not run), just use title results
            logger.warning(
                "message_search_skipped",
                error=str(e),
            )
            message_results = []

        # Build result set, deduplicating by session_id
        seen_sessions = {r.id for r in title_results}
        combined = list(title_results)

        for msg_result in message_results:
            if msg_result.id not in seen_sessions:
                # Try to get session title
                try:
                    async with get_session_context() as db:
                        stmt = select(Session).where(Session.id == msg_result.id)
                        result = await db.execute(stmt)
                        session_obj = result.scalar_one_or_none()
                        if session_obj:
                            msg_result.title = session_obj.name
                except Exception:
                    pass

                combined.append(msg_result)
                seen_sessions.add(msg_result.id)

                if len(combined) >= limit:
                    break

        return combined[:limit]


# Singleton instance
search_service = SearchService()
