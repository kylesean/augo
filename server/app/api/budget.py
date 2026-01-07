"""Budget API routes for managing user budgets."""

from __future__ import annotations

from collections.abc import AsyncGenerator
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import db_manager
from app.core.dependencies import get_current_user
from app.core.responses import success_response
from app.models.budget import BudgetScope, BudgetStatus
from app.models.user import User
from app.schemas.budget import (
    BudgetCreateRequest,
    BudgetRebalanceRequest,
    BudgetResponse,
    BudgetSettingsResponse,
    BudgetSettingsUpdateRequest,
    BudgetSuggestion,
    BudgetSummaryResponse,
    BudgetUpdateRequest,
)
from app.services.budget_service import BudgetService

router = APIRouter(prefix="/budgets", tags=["Budget"])


async def get_db() -> AsyncGenerator[AsyncSession]:
    """Get database session."""
    async with db_manager.session_factory() as session:
        yield session


# ============================================================================
# Budget CRUD
# ============================================================================


@router.post("", response_model=BudgetResponse, status_code=status.HTTP_201_CREATED)
async def create_budget(
    request: BudgetCreateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Create a new budget.

    Creates either a total budget (scope=TOTAL) or a category-specific budget
    (scope=CATEGORY with category_key).

    Only one active total budget and one active category budget per category
    are allowed for each user.
    """
    service = BudgetService(db)

    # Check for duplicate
    existing = await service.get_user_budgets(
        current_user.uuid,
        status=BudgetStatus.ACTIVE,
        scope=BudgetScope(request.scope) if isinstance(request.scope, str) else request.scope,
    )

    for budget in existing:
        if request.scope == BudgetScope.TOTAL and budget.is_total_budget:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Active total budget already exists. Please pause or archive it first.",
            )
        if request.scope == BudgetScope.CATEGORY and budget.category_key == request.category_key:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"Active budget for category '{request.category_key}' already exists.",
            )

    budget = await service.create_budget(current_user.uuid, request)
    period = await service.get_or_create_current_period(budget)

    return success_response(
        data=await service._build_budget_response(budget, period),
        http_status=201,
    )


@router.get("", response_model=list[BudgetResponse])
async def get_budgets(
    scope: str | None = None,
    status_filter: str | None = None,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Get all budgets for the current user.

    Args:
        scope: Optional filter by scope (TOTAL or CATEGORY).
        status_filter: Optional filter by status (ACTIVE, PAUSED, ARCHIVED).
        current_user: The current authenticated user.
        db: The database session.
    """
    service = BudgetService(db)

    scope_enum = BudgetScope(scope) if scope else None
    status_enum = BudgetStatus(status_filter) if status_filter else None

    budgets = await service.get_user_budgets(
        current_user.uuid,
        status=status_enum,
        scope=scope_enum,
    )

    responses = []
    for budget in budgets:
        period = await service.get_or_create_current_period(budget)
        period = await service.update_period_spent_amount(budget, period)
        responses.append(await service._build_budget_response(budget, period))

    return success_response(data=responses)


@router.get("/summary", response_model=BudgetSummaryResponse)
async def get_budget_summary(
    include_paused: bool = False,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Get budget summary with budgets and alerts.

    Args:
        include_paused: If True, also include paused budgets in the summary.
        current_user: The current authenticated user.
        db: The database session.
    """
    service = BudgetService(db)
    return success_response(data=await service.get_budget_summary(current_user.uuid, include_paused=include_paused))


@router.get("/suggestions", response_model=list[BudgetSuggestion])
async def get_budget_suggestions(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Get AI-generated budget suggestions based on historical spending.

    Returns suggestions for total budget and top problem categories.
    """
    service = BudgetService(db)

    suggestions = []

    # Total budget suggestion
    total_suggestion = await service.suggest_budget(current_user.uuid)
    suggestions.append(total_suggestion)

    # Category suggestions for problem categories
    problem_categories = await service.detect_problem_categories(current_user.uuid)
    for category_key in problem_categories[:3]:  # Top 3 problem categories
        category_suggestion = await service.suggest_budget(current_user.uuid, category_key=category_key)
        suggestions.append(category_suggestion)

    return success_response(data=suggestions)


@router.get("/{budget_id}", response_model=BudgetResponse)
async def get_budget(
    budget_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Get a specific budget by ID."""
    service = BudgetService(db)

    budget = await service.get_budget(budget_id, current_user.uuid)
    if not budget:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Budget not found")

    period = await service.get_or_create_current_period(budget)
    period = await service.update_period_spent_amount(budget, period)

    return success_response(data=await service._build_budget_response(budget, period))


@router.put("/{budget_id}", response_model=BudgetResponse)
async def update_budget(
    budget_id: UUID,
    request: BudgetUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Update a budget."""
    service = BudgetService(db)

    budget = await service.update_budget(budget_id, current_user.uuid, request)
    if not budget:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Budget not found")

    period = await service.get_or_create_current_period(budget)
    period = await service.update_period_spent_amount(budget, period)

    return success_response(data=await service._build_budget_response(budget, period))


@router.delete("/{budget_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_budget(
    budget_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> None:
    """Delete a budget."""
    service = BudgetService(db)

    success = await service.delete_budget(budget_id, current_user.uuid)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Budget not found")


# ============================================================================
# Rebalance
# ============================================================================


@router.post("/rebalance", status_code=status.HTTP_200_OK)
async def rebalance_budgets(
    request: BudgetRebalanceRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Rebalance amount between two budgets.

    Transfers budget allocation from one budget to another.
    Useful when one category is under budget and another needs more.
    """
    service = BudgetService(db)

    success = await service.rebalance(
        request.from_budget_id,
        request.to_budget_id,
        request.amount,
        current_user.uuid,
    )

    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="One or more budgets not found")

    return success_response(message="Budget rebalanced successfully")


# ============================================================================
# Settings
# ============================================================================


@router.get("/settings/me", response_model=BudgetSettingsResponse)
async def get_budget_settings(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Get current user's budget settings."""
    service = BudgetService(db)
    settings = await service.get_or_create_settings(current_user.uuid)

    return success_response(
        data=BudgetSettingsResponse(
            user_uuid=settings.user_uuid,
            warning_threshold=settings.warning_threshold,
            alert_threshold=settings.alert_threshold,
            overspend_behavior=settings.overspend_behavior,
            weekly_summary_enabled=settings.weekly_summary_enabled,
            weekly_summary_day=settings.weekly_summary_day,
            monthly_summary_enabled=settings.monthly_summary_enabled,
            anomaly_detection_enabled=settings.anomaly_detection_enabled,
            anomaly_threshold=float(settings.anomaly_threshold),
            quiet_hours_start=settings.quiet_hours_start,
            quiet_hours_end=settings.quiet_hours_end,
        )
    )


@router.put("/settings/me", response_model=BudgetSettingsResponse)
async def update_budget_settings(
    request: BudgetSettingsUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> JSONResponse:
    """Update current user's budget settings."""
    service = BudgetService(db)
    settings = await service.update_settings(current_user.uuid, request)

    return success_response(
        data=BudgetSettingsResponse(
            user_uuid=settings.user_uuid,
            warning_threshold=settings.warning_threshold,
            alert_threshold=settings.alert_threshold,
            overspend_behavior=settings.overspend_behavior,
            weekly_summary_enabled=settings.weekly_summary_enabled,
            weekly_summary_day=settings.weekly_summary_day,
            monthly_summary_enabled=settings.monthly_summary_enabled,
            anomaly_detection_enabled=settings.anomaly_detection_enabled,
            anomaly_threshold=float(settings.anomaly_threshold),
            quiet_hours_start=settings.quiet_hours_start,
            quiet_hours_end=settings.quiet_hours_end,
        )
    )
