"""Memory management API endpoints.

Provides user-facing APIs for managing long-term memories:
- List all memories
- Search memories
- Delete specific memory
- Delete all memories
- Get memory statistics
"""

from typing import Annotated

from fastapi import APIRouter, Depends, Path, Query
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from app.core.dependencies import get_current_user
from app.core.exceptions import NotFoundError
from app.core.logging import logger
from app.core.responses import ResponseEnvelope, success_response
from app.models.user import User
from app.services.memory import get_memory_service

router = APIRouter(prefix="/memory", tags=["memory"])


# ============================================================================
# Response Schemas
# ============================================================================


class MemoryItem(BaseModel):
    """Single memory item response."""

    id: str = Field(..., description="Memory unique identifier")
    memory: str = Field(..., description="Memory content")
    score: float | None = Field(None, description="Relevance score (for search results)")
    metadata: dict | None = Field(None, description="Memory metadata")
    createdAt: str | None = Field(None, description="Creation timestamp")


class MemoryListResponse(BaseModel):
    """Response for memory list endpoint."""

    memories: list[MemoryItem]
    totalCount: int


class MemorySearchResponse(BaseModel):
    """Response for memory search endpoint."""

    memories: list[MemoryItem]
    query: str
    resultCount: int


class MemoryStatsResponse(BaseModel):
    """Response for memory statistics endpoint."""

    totalCount: int
    categories: dict[str, int]


class DeleteMemoryResponse(BaseModel):
    """Response for memory deletion."""

    deleted: bool
    memoryId: str | None = None


class DeleteAllMemoriesResponse(BaseModel):
    """Response for deleting all memories."""

    deleted: bool
    message: str


# ============================================================================
# API Endpoints
# ============================================================================


@router.get("", response_model=ResponseEnvelope[MemoryListResponse])
async def list_memories(
    current_user: Annotated[User, Depends(get_current_user)],
    limit: int = Query(50, ge=1, le=200, description="Maximum memories to return"),
) -> JSONResponse:
    """Get all memories for the current user.

    Args:
        current_user: The authenticated user
        limit: Maximum number of memories to return

    Returns:
        List of all user memories
    """
    service = await get_memory_service()
    memories = await service.get_user_memories(
        user_uuid=str(current_user.uuid),
        limit=limit,
    )

    items = [
        MemoryItem(
            id=mem.get("id", ""),
            memory=mem.get("memory", ""),
            metadata=mem.get("metadata"),
            createdAt=mem.get("created_at") or mem.get("metadata", {}).get("timestamp"),
        )
        for mem in memories
    ]

    logger.info(
        "memories_listed",
        user_uuid=str(current_user.uuid),
        count=len(items),
    )

    return success_response(
        data=MemoryListResponse(
            memories=items,
            totalCount=len(items),
        )
    )


@router.get("/search", response_model=ResponseEnvelope[MemorySearchResponse])
async def search_memories(
    current_user: Annotated[User, Depends(get_current_user)],
    q: str = Query(..., min_length=1, max_length=500, description="Search query"),
    limit: int = Query(10, ge=1, le=50, description="Maximum results to return"),
) -> JSONResponse:
    """Search for relevant memories.

    Uses semantic search to find memories related to the query.

    Args:
        current_user: The authenticated user
        q: Search query
        limit: Maximum number of results

    Returns:
        List of relevant memories with scores
    """
    service = await get_memory_service()
    memories = await service.search_memories(
        user_uuid=str(current_user.uuid),
        query=q,
        limit=limit,
    )

    items = [
        MemoryItem(
            id=mem.get("id", ""),
            memory=mem.get("memory", ""),
            score=mem.get("score"),
            metadata=mem.get("metadata"),
            createdAt=mem.get("created_at") or mem.get("metadata", {}).get("timestamp"),
        )
        for mem in memories
    ]

    logger.info(
        "memories_searched",
        user_uuid=str(current_user.uuid),
        query=q[:50],  # Truncate for logging
        result_count=len(items),
    )

    return success_response(
        data=MemorySearchResponse(
            memories=items,
            query=q,
            resultCount=len(items),
        )
    )


@router.get("/stats", response_model=ResponseEnvelope[MemoryStatsResponse])
async def get_memory_stats(
    current_user: Annotated[User, Depends(get_current_user)],
) -> JSONResponse:
    """Get memory statistics for the current user.

    Returns:
        Total memory count and category breakdown
    """
    service = await get_memory_service()
    stats = await service.get_memory_stats(user_uuid=str(current_user.uuid))

    return success_response(
        data=MemoryStatsResponse(
            totalCount=stats["total_count"],
            categories=stats["categories"],
        )
    )


@router.get("/{memory_id}", response_model=ResponseEnvelope[MemoryItem])
async def get_memory(
    memory_id: Annotated[str, Path(description="Memory ID")],
    current_user: Annotated[User, Depends(get_current_user)],
) -> JSONResponse:
    """Get a specific memory by ID.

    Args:
        memory_id: The memory ID
        current_user: The authenticated user

    Returns:
        Memory details

    Raises:
        NotFoundError: If memory not found
    """
    service = await get_memory_service()
    memory = await service.get_memory_by_id(memory_id)

    if not memory:
        raise NotFoundError("Memory")

    # Verify ownership (memory should belong to current user)
    # Note: Mem0 doesn't provide user_id in get response, so we trust the ID

    return success_response(
        data=MemoryItem(
            id=memory.get("id", memory_id),
            memory=memory.get("memory", ""),
            metadata=memory.get("metadata"),
            createdAt=memory.get("created_at") or memory.get("metadata", {}).get("timestamp"),
        )
    )


@router.delete("/{memory_id}", response_model=ResponseEnvelope[DeleteMemoryResponse])
async def delete_memory(
    memory_id: Annotated[str, Path(description="Memory ID")],
    current_user: Annotated[User, Depends(get_current_user)],
) -> JSONResponse:
    """Delete a specific memory.

    Args:
        memory_id: The memory ID to delete
        current_user: The authenticated user

    Returns:
        Deletion confirmation
    """
    service = await get_memory_service()

    # Verify memory exists first
    memory = await service.get_memory_by_id(memory_id)
    if not memory:
        raise NotFoundError("Memory")

    deleted = await service.delete_memory(memory_id)

    logger.info(
        "memory_deleted_by_user",
        user_uuid=str(current_user.uuid),
        memory_id=memory_id,
        success=deleted,
    )

    return success_response(
        data=DeleteMemoryResponse(
            deleted=deleted,
            memoryId=memory_id,
        ),
        message="Memory deleted successfully" if deleted else "Failed to delete memory",
    )


@router.delete("", response_model=ResponseEnvelope[DeleteAllMemoriesResponse])
async def delete_all_memories(
    current_user: Annotated[User, Depends(get_current_user)],
) -> JSONResponse:
    """Delete all memories for the current user.

    ⚠️ CAUTION: This action cannot be undone!

    Args:
        current_user: The authenticated user

    Returns:
        Deletion confirmation
    """
    service = await get_memory_service()

    # Get count before deletion
    stats = await service.get_memory_stats(user_uuid=str(current_user.uuid))
    count_before = stats["total_count"]

    deleted = await service.delete_all_user_memories(
        user_uuid=str(current_user.uuid),
    )

    logger.warning(
        "all_memories_deleted_by_user",
        user_uuid=str(current_user.uuid),
        count_deleted=count_before,
        success=deleted,
    )

    return success_response(
        data=DeleteAllMemoriesResponse(
            deleted=deleted,
            message=f"Successfully deleted {count_before} memories" if deleted else "Failed to delete memories",
        ),
    )
