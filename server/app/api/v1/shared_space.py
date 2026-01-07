"""Shared space API endpoints."""

from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.exceptions import AuthorizationError, BusinessError, NotFoundError
from app.core.responses import error_response, get_error_code_int, success_response
from app.models.user import User
from app.schemas.shared_space import (
    AddTransactionToSpaceRequest,
    CreateSpaceRequest,
    JoinWithCodeRequest,
    UpdateSpaceRequest,
)
from app.services.shared_space_service import SharedSpaceService

router = APIRouter(prefix="/shared-spaces", tags=["shared-spaces"])


@router.get("")
async def get_shared_spaces(
    page: int = 1,
    limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get user's shared spaces.

    Returns a list of shared spaces that the current user is a member of.
    """
    service = SharedSpaceService(db)
    spaces = await service.get_user_spaces(current_user.uuid, page, limit)
    return success_response(data=spaces)


@router.post("")
async def create_shared_space(
    request: CreateSpaceRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Create a new shared space.

    Creates a new shared space, with the creator automatically becoming the owner.
    """
    service = SharedSpaceService(db)
    space = await service.create_space(
        user_uuid=current_user.uuid,
        name=request.name,
        description=request.description,
    )

    # Get full space details
    space_dict = await service.get_space_detail(space.id, current_user.uuid)
    return success_response(data=space_dict)


@router.get("/{space_id}")
async def get_shared_space_detail(
    space_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get shared space details.

    Returns the details of a specific shared space, including member list and transaction statistics.
    """
    service = SharedSpaceService(db)
    space_dict = await service.get_space_detail(space_id, current_user.uuid)
    return success_response(data=space_dict)


@router.put("/{space_id}")
async def update_shared_space(
    space_id: UUID,
    request: UpdateSpaceRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Update shared space info.

    Updates the information of a specific shared space (only for administrators/creators).
    """
    service = SharedSpaceService(db)
    space_dict = await service.update_space(
        space_id=space_id,
        user_uuid=current_user.uuid,
        name=request.name,
        description=request.description,
        status=request.status,
    )
    return success_response(data=space_dict)


@router.delete("/{space_id}")
async def delete_shared_space(
    space_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Delete a shared space.

    Deletes a specific shared space (only for creators).
    """
    service = SharedSpaceService(db)
    await service.delete_space(space_id, current_user.uuid)
    return success_response(data={"message": "Space deleted successfully"})


@router.post("/{space_id}/invite-code")
async def generate_invite_code(
    space_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Generate an invite code.

    Generates an invite code for inviting others to join the space.
    """
    service = SharedSpaceService(db)
    invite = await service.generate_invite_code(
        space_id=space_id,
        user_uuid=current_user.uuid,
    )
    return success_response(data=invite)


@router.post("/join-with-code")
async def join_space_with_code(
    request: JoinWithCodeRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Joins a shared space using an invite code."""
    service = SharedSpaceService(db)
    space_dict = await service.join_with_code(request.code, current_user.uuid)
    return success_response(data=space_dict)


@router.post("/{space_id}/leave")
async def leave_space(
    space_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Leave a shared space."""
    service = SharedSpaceService(db)
    await service.leave_space(space_id, current_user.uuid)
    return success_response(data={"message": "Leave space successfully"})


@router.delete("/{space_id}/members/{user_id}")
async def remove_member(
    space_id: UUID,
    user_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Remove a member from the space (only for administrators/creators)."""
    service = SharedSpaceService(db)
    target_uuid = UUID(user_id)
    await service.remove_member(space_id, current_user.uuid, target_uuid)
    return success_response(data={"message": "Remove member successfully"})


@router.get("/{space_id}/settlement")
async def get_space_settlement(
    space_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get settlement info for the space."""
    service = SharedSpaceService(db)
    settlement = await service.get_settlement(space_id, current_user.uuid)
    return success_response(data=settlement)


@router.get("/{space_id}/transactions")
async def get_space_transactions(
    space_id: UUID,
    page: int = 1,
    limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get transactions in the space."""
    service = SharedSpaceService(db)
    transactions = await service.get_space_transactions(
        space_id=space_id,
        user_uuid=current_user.uuid,
        page=page,
        limit=limit,
    )
    return success_response(data=transactions)


@router.post("/{space_id}/transactions")
async def add_transaction_to_space(
    space_id: UUID,
    request: AddTransactionToSpaceRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Add a transaction to the space."""
    service = SharedSpaceService(db)
    result = await service.add_transaction_to_space(
        space_id=space_id,
        user_uuid=current_user.uuid,
        transaction_id=request.transaction_id,
    )
    return success_response(data=result)
