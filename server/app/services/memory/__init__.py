"""Memory services for long-term memory management.

This module provides centralized memory management using Mem0
for intelligent memory extraction and retrieval in AI conversations.

MemoryService provides:
- Automatic memory extraction from conversations
- Semantic search for relevant memories
- CRUD operations for user memories
- Memory statistics and analytics
"""

from app.services.memory.memory_service import MemoryService, get_memory_service

__all__ = [
    "MemoryService",
    "get_memory_service",
]
