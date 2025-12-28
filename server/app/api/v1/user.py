"""User management API endpoints with unified response format."""

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Path
from fastapi.responses import JSONResponse
from sqlmodel.ext.asyncio.session import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.exceptions import NotFoundError
from app.core.logging import logger
from app.core.responses import ResponseEnvelope, success_response
from app.models.user import User
from app.schemas.user import (
    CreateFinancialAccountRequest,
    FinancialAccountResponse,
    FinancialAccountsResponse,
    FinancialSafetyLineRequest,
    FinancialSafetyLineResponse,
    OnboardingStatusResponse,
    SaveFinancialAccountsRequest,
    SaveFinancialAccountsResponse,
    UpdateFinancialAccountRequest,
    UpdateUserProfileRequest,
    UserInfoResponse,
    UserSettingsRequest,
    UserSettingsResponse,
)
from app.services.user_service import UserService

router = APIRouter(prefix="/user", tags=["user"])


@router.get("", response_model=ResponseEnvelope[UserInfoResponse])
async def get_current_user_info(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Get current user information.

    Args:
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with user information
    """
    user_info = UserInfoResponse(
        id=str(current_user.uuid),
        email=current_user.email,
        mobile=current_user.mobile,
        username=current_user.username,
        avatarUrl=current_user.avatar_url,
        createdAt=current_user.created_at.isoformat().replace("+00:00", "Z"),
        updatedAt=current_user.updated_at.isoformat().replace("+00:00", "Z"),
        clientLastLoginAt=(
            current_user.client_last_login_at.isoformat().replace("+00:00", "Z")
            if current_user.client_last_login_at
            else None
        ),
    )

    return success_response(data=user_info)


@router.patch("", response_model=ResponseEnvelope[UserInfoResponse])
async def update_user_profile(
    request: UpdateUserProfileRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Update current user's profile.

    Args:
        request: Profile update data (username and/or avatarUrl)
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with updated user information
    """
    service = UserService(db)
    result = await service.update_user_profile(
        current_user.uuid, username=request.username, avatar_url=request.avatarUrl
    )

    return success_response(data=UserInfoResponse(**result), message="Profile updated successfully")


@router.post("/financial-accounts", response_model=ResponseEnvelope[SaveFinancialAccountsResponse])
async def save_financial_accounts(
    request: SaveFinancialAccountsRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Save or update user's financial accounts.

    Deletes all existing financial accounts and creates new ones.

    Args:
        request: Financial accounts data
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with total balance and update timestamp
    """
    service = UserService(db)

    # Convert Pydantic models to dicts
    accounts_data = [account.model_dump() for account in request.accounts]

    result = await service.save_financial_accounts(current_user.uuid, accounts_data)

    return success_response(
        data=SaveFinancialAccountsResponse(**result), message="Financial accounts saved successfully"
    )


@router.get("/financial-accounts", response_model=ResponseEnvelope[FinancialAccountsResponse])
async def get_financial_accounts(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Get user's financial accounts.

    Args:
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with list of financial accounts and total balance
    """
    service = UserService(db)
    result = await service.get_user_financial_accounts(current_user.uuid)

    # Convert to response format
    accounts = [
        FinancialAccountResponse(
            id=acc["id"],
            name=acc["name"],
            nature=acc["nature"],
            type=acc["type"],
            currencyCode=acc["currencyCode"],
            initialBalance=acc["initialBalance"],
            currentBalance=acc.get("currentBalance", acc["initialBalance"]),
            includeInNetWorth=acc["includeInNetWorth"],
            includeInCashFlow=acc.get("includeInCashFlow", False),
            display=acc.get("display"),
            status=acc["status"],
            createdAt=acc["createdAt"],
            updatedAt=acc["updatedAt"],
        )
        for acc in result["accounts"]
    ]

    return success_response(
        data=FinancialAccountsResponse(
            accounts=accounts, totalBalance=result["totalBalance"], lastUpdatedAt=result["lastUpdatedAt"]
        )
    )


@router.post("/financial-accounts/create", response_model=ResponseEnvelope[FinancialAccountResponse])
async def create_financial_account(
    request: CreateFinancialAccountRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Create a single financial account.

    Args:
        request: Financial account data
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with created account
    """
    service = UserService(db)
    result = await service.create_financial_account(current_user.uuid, request.model_dump())

    return success_response(
        data=FinancialAccountResponse(
            id=result["id"],
            name=result["name"],
            nature=result["nature"],
            type=result["type"],
            currencyCode=result["currencyCode"],
            initialBalance=result["initialBalance"],
            includeInNetWorth=result["includeInNetWorth"],
            status=result["status"],
            createdAt=result["createdAt"],
            updatedAt=result["updatedAt"],
        ),
        message="Financial account created successfully",
    )


@router.patch("/financial-accounts/{account_id}", response_model=ResponseEnvelope[FinancialAccountResponse])
async def update_financial_account(
    account_id: Annotated[UUID, Path(description="Account ID (UUID)")],
    request: UpdateFinancialAccountRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Update a financial account.

    Args:
        account_id: The account ID to update
        request: Updated account data
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with updated account
    """
    service = UserService(db)
    result = await service.update_financial_account(
        current_user.uuid, account_id, request.model_dump(exclude_unset=True)
    )

    if result is None:
        raise NotFoundError("Financial account")

    return success_response(
        data=FinancialAccountResponse(
            id=result["id"],
            name=result["name"],
            nature=result["nature"],
            type=result["type"],
            currencyCode=result["currencyCode"],
            initialBalance=result["initialBalance"],
            includeInNetWorth=result["includeInNetWorth"],
            status=result["status"],
            createdAt=result["createdAt"],
            updatedAt=result["updatedAt"],
        ),
        message="Financial account updated successfully",
    )


@router.delete("/financial-accounts/{account_id}")
async def delete_financial_account(
    account_id: Annotated[UUID, Path(description="Account ID (UUID)")],
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Delete a financial account.

    Args:
        account_id: The account ID to delete
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with success message
    """
    service = UserService(db)
    deleted = await service.delete_financial_account(current_user.uuid, account_id)

    if not deleted:
        raise NotFoundError("Financial account")

    return success_response(message="Financial account deleted successfully")


@router.patch("/financial-settings", response_model=ResponseEnvelope[FinancialSafetyLineResponse])
async def update_financial_safety_line(
    request: FinancialSafetyLineRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Update user's financial safety line threshold.

    Args:
        request: Safety threshold data
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with updated threshold and timestamp
    """
    logger.info(
        "update_financial_safety_line", user_uuid=str(current_user.uuid), threshold=request.safetyBalanceThreshold
    )

    service = UserService(db)
    result = await service.update_financial_safety_line(current_user.uuid, request.safetyBalanceThreshold)

    return success_response(
        data=FinancialSafetyLineResponse(**result), message="Financial safety line updated successfully"
    )


@router.get("/onboarding/status", response_model=ResponseEnvelope[OnboardingStatusResponse])
async def check_onboarding_status(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Check if user has completed onboarding.

    Onboarding is complete when user has:
    - At least one financial account
    - At least one recurring income transaction
    - At least one recurring expense transaction

    Args:
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with onboarding completion status
    """
    service = UserService(db)
    result = await service.check_onboarding_status(current_user.uuid)

    return success_response(data=OnboardingStatusResponse(**result))


@router.put("/settings", response_model=ResponseEnvelope[UserSettingsResponse])
async def update_user_settings(
    request: UserSettingsRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_session)],
) -> JSONResponse:
    """Update user settings.

    Args:
        request: Settings data
        current_user: The authenticated user
        db: Database session

    Returns:
        Unified response with updated settings
    """
    service = UserService(db)
    settings = await service.update_user_settings(
        current_user.uuid,
        safety_balance_threshold=request.safetyBalanceThreshold,
        estimated_avg_daily_spending=request.estimatedAvgDailySpending,
    )

    settings_response = UserSettingsResponse(
        defaultCurrency="CNY",  # Placeholder - not in current schema
        timezone="Asia/Shanghai",  # Placeholder - not in current schema
        estimatedAvgDailySpending=settings.avg_daily_spending,
        safetyBalanceThreshold=settings.safety_balance_threshold,
        createdAt=settings.created_at.isoformat().replace("+00:00", "Z"),
        updatedAt=settings.updated_at.isoformat().replace("+00:00", "Z"),
    )

    return success_response(data=settings_response, message="User settings updated successfully")
