"""Financial settings API endpoints."""

from typing import Annotated

from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.responses import success_response
from app.models.user import User
from app.schemas.user import (
    FinancialSettingsResponseSchema,
    UpdateFinancialSettingsRequest,
)
from app.services.user_service import UserService

router = APIRouter(prefix="/financial-settings", tags=["financial-settings"])


@router.get("")
async def get_financial_settings(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Get current user's financial settings.

    Args:
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with financial settings
    """
    user_service = UserService(db)
    settings = await user_service.get_financial_settings(current_user.uuid)

    return success_response(
        data=FinancialSettingsResponseSchema(
            safetyThreshold=str(settings.safety_threshold),
            dailyBurnRate=str(settings.daily_burn_rate),
            burnRateMode=settings.burn_rate_mode,
            primaryCurrency=settings.primary_currency,
            monthStartDay=settings.month_start_day,
            updatedAt=settings.updated_at.isoformat() if settings.updated_at else None,
        ),
        message="Financial settings retrieved successfully",
    )


@router.patch("")
async def update_financial_settings(
    request: UpdateFinancialSettingsRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Update current user's financial settings.

    Uses UPSERT to create settings if they don't exist.

    Args:
        request: Settings update data
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with updated financial settings
    """
    user_service = UserService(db)
    settings = await user_service.update_financial_settings(
        user_uuid=current_user.uuid,
        safety_threshold=request.safetyThreshold,
        daily_burn_rate=request.dailyBurnRate,
        burn_rate_mode=request.burnRateMode,
        primary_currency=request.primaryCurrency,
        month_start_day=request.monthStartDay,
    )

    return success_response(
        data=FinancialSettingsResponseSchema(
            safetyThreshold=str(settings.safety_threshold),
            dailyBurnRate=str(settings.daily_burn_rate),
            burnRateMode=settings.burn_rate_mode,
            primaryCurrency=settings.primary_currency,
            monthStartDay=settings.month_start_day,
            updatedAt=settings.updated_at.isoformat() if settings.updated_at else None,
        ),
        message="Financial settings updated successfully",
    )
