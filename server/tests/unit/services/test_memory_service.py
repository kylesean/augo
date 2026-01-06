"""Tests for MemoryService filters and cleanup functionality."""

import pytest
from unittest.mock import AsyncMock, MagicMock, patch
from uuid import uuid4
from datetime import datetime, timezone, timedelta


class TestMemoryServiceFilters:
    """Test cases for memory search filter functionality."""

    @pytest.fixture
    def mock_memory(self):
        """Create a mock AsyncMemory instance."""
        mock = AsyncMock()
        mock.search = AsyncMock()
        mock.get_all = AsyncMock()
        mock.delete = AsyncMock()
        return mock

    @pytest.mark.asyncio
    async def test_single_category_filter_format(self, mock_memory):
        """Verify single category filter uses correct Mem0 format."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup
        service = MemoryService()
        service._memory = mock_memory
        mock_memory.search.return_value = {"results": []}
        
        # Execute
        await service.search_memories(
            user_uuid="user-123",
            query="test query",
            categories=["financial_profile"],
        )
        
        # Verify filter format
        mock_memory.search.assert_called_once()
        call_kwargs = mock_memory.search.call_args[1]
        
        # Single category should use simple format: {"category": "value"}
        assert call_kwargs["filters"] == {"category": "financial_profile"}

    @pytest.mark.asyncio
    async def test_multiple_category_filter_format(self, mock_memory):
        """Verify multiple categories filter uses OR logic."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup
        service = MemoryService()
        service._memory = mock_memory
        mock_memory.search.return_value = {"results": []}
        
        # Execute with multiple categories
        await service.search_memories(
            user_uuid="user-123",
            query="test query",
            categories=["financial_profile", "preference", "household"],
        )
        
        # Verify filter format uses OR logic
        mock_memory.search.assert_called_once()
        call_kwargs = mock_memory.search.call_args[1]
        
        expected_filters = {
            "OR": [
                {"category": "financial_profile"},
                {"category": "preference"},
                {"category": "household"},
            ]
        }
        assert call_kwargs["filters"] == expected_filters

    @pytest.mark.asyncio
    async def test_no_category_filter_when_none(self, mock_memory):
        """Verify no filters applied when categories is None."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup
        service = MemoryService()
        service._memory = mock_memory
        mock_memory.search.return_value = {"results": []}
        
        # Execute without categories
        await service.search_memories(
            user_uuid="user-123",
            query="test query",
            categories=None,
        )
        
        # Verify no filters
        mock_memory.search.assert_called_once()
        call_kwargs = mock_memory.search.call_args[1]
        assert call_kwargs["filters"] is None

    @pytest.mark.asyncio
    async def test_infer_false_in_add(self, mock_memory):
        """Verify infer=False is passed to Mem0 add() to skip internal LLM."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup
        service = MemoryService()
        service._memory = mock_memory
        mock_memory.add = AsyncMock(return_value={"results": []})
        
        # Mock extract_salient_facts to return some facts
        with patch.object(service, "extract_salient_facts", new_callable=AsyncMock) as mock_extract:
            mock_extract.return_value = ["User has a budget goal of 5000 per month"]
            
            # Execute
            await service.add_conversation_memory(
                user_uuid="user-123",
                messages=[{"role": "user", "content": "My budget is 5000"}],
            )
        
        # Verify infer=False was passed
        mock_memory.add.assert_called_once()
        call_kwargs = mock_memory.add.call_args[1]
        assert call_kwargs.get("infer") is False


class TestMemoryServiceCleanup:
    """Test cases for memory cleanup functionality."""

    @pytest.fixture
    def mock_memory(self):
        """Create a mock AsyncMemory instance."""
        mock = AsyncMock()
        mock.get_all = AsyncMock()
        mock.delete = AsyncMock()
        return mock

    @pytest.mark.asyncio
    async def test_cleanup_old_memories_by_count(self, mock_memory):
        """Verify cleanup deletes excess memories when over limit."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup - 5 memories, max is 3
        service = MemoryService()
        service._memory = mock_memory
        
        now = datetime.now(timezone.utc)
        mock_memories = [
            {"id": f"mem_{i}", "created_at": (now - timedelta(days=i)).isoformat()}
            for i in range(5)
        ]
        
        mock_memory.get_all.return_value = {"results": mock_memories}
        mock_memory.delete.return_value = None
        
        # Execute with max_memories=3
        result = await service.cleanup_old_memories(
            user_uuid="user-123",
            max_memories=3,
            days_old=365,  # High value so time-based cleanup doesn't trigger
        )
        
        # Should delete 2 oldest memories (mem_3, mem_4)
        assert result["deleted_count"] == 2
        assert result["remaining_count"] == 3

    @pytest.mark.asyncio
    async def test_cleanup_old_memories_by_age(self, mock_memory):
        """Verify cleanup deletes memories older than threshold."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup - 3 old memories, 2 new ones
        service = MemoryService()
        service._memory = mock_memory
        
        now = datetime.now(timezone.utc)
        mock_memories = [
            {"id": "mem_new_1", "created_at": (now - timedelta(days=10)).isoformat()},
            {"id": "mem_new_2", "created_at": (now - timedelta(days=20)).isoformat()},
            {"id": "mem_old_1", "created_at": (now - timedelta(days=100)).isoformat()},
            {"id": "mem_old_2", "created_at": (now - timedelta(days=150)).isoformat()},
            {"id": "mem_old_3", "created_at": (now - timedelta(days=200)).isoformat()},
        ]
        
        mock_memory.get_all.return_value = {"results": mock_memories}
        mock_memory.delete.return_value = None
        
        # Execute with days_old=90
        result = await service.cleanup_old_memories(
            user_uuid="user-123",
            max_memories=1000,  # High value so count-based cleanup doesn't trigger
            days_old=90,
        )
        
        # Should delete 3 old memories
        assert result["deleted_count"] == 3
        assert result["remaining_count"] == 2

    @pytest.mark.asyncio
    async def test_cleanup_no_memories(self, mock_memory):
        """Verify cleanup handles empty memory list gracefully."""
        from app.services.memory.memory_service import MemoryService
        
        # Setup
        service = MemoryService()
        service._memory = mock_memory
        mock_memory.get_all.return_value = {"results": []}
        
        # Execute
        result = await service.cleanup_old_memories(
            user_uuid="user-123",
        )
        
        # Should return zeros
        assert result["deleted_count"] == 0
        assert result["remaining_count"] == 0
        
        # Should not attempt any deletions
        mock_memory.delete.assert_not_called()
