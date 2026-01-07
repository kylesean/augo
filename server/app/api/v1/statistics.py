"""Statistics API endpoints for financial analysis."""

from typing import Optional

from fastapi import APIRouter, Depends, Query
from fastapi.responses import JSONResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.logging import logger
from app.core.responses import error_response, get_error_code_int, success_response
from app.models.user import User
from app.services.statistics_service import StatisticsService

router = APIRouter(prefix="/statistics", tags=["statistics"])


@router.get("/overview")
async def get_statistics_overview(
    time_range: str = Query(default="month", description="Time range: week, month, year, or custom"),
    start_date: Optional[str] = Query(default=None, description="Start date for custom range (ISO 8601)"),
    end_date: Optional[str] = Query(default=None, description="End date for custom range (ISO 8601)"),
    account_types: Optional[str] = Query(default=None, description="Comma-separated account types to filter"),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get statistics overview including balance, income, expense, and change percentage."""
    try:
        service = StatisticsService(db)

        # Parse account types if provided
        account_type_list = None
        if account_types:
            account_type_list = [t.strip() for t in account_types.split(",")]

        result = await service.get_overview(
            user_uuid=current_user.uuid,
            time_range=time_range,
            start_date=start_date,
            end_date=end_date,
            account_types=account_type_list,
        )

        return success_response(data=result.model_dump(), message="Statistics overview retrieved successfully")
    except Exception as e:
        logger.error(
            "failed_to_get_statistics_overview",
            error=str(e),
            user_uuid=str(current_user.uuid),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve statistics overview",
            http_status=500,
        )


@router.get("/trends")
async def get_trend_data(
    time_range: str = Query(default="month"),
    transaction_type: str = Query(default="expense", description="Transaction type: expense or income"),
    start_date: Optional[str] = Query(default=None),
    end_date: Optional[str] = Query(default=None),
    account_types: Optional[str] = Query(default=None),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get trend data for chart visualization."""
    try:
        service = StatisticsService(db)

        account_type_list = None
        if account_types:
            account_type_list = [t.strip() for t in account_types.split(",")]

        result = await service.get_trend_data(
            user_uuid=current_user.uuid,
            time_range=time_range,
            transaction_type=transaction_type,
            start_date=start_date,
            end_date=end_date,
            account_types=account_type_list,
        )

        return success_response(data=result.model_dump(), message="Trend data retrieved successfully")
    except Exception as e:
        logger.error(
            "failed_to_get_trend_data",
            error=str(e),
            user_uuid=str(current_user.uuid),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve trend data",
            http_status=500,
        )


@router.get("/categories")
async def get_category_breakdown(
    time_range: str = Query(default="month"),
    start_date: Optional[str] = Query(default=None),
    end_date: Optional[str] = Query(default=None),
    account_types: Optional[str] = Query(default=None),
    transaction_type: str = Query(default="expense", description="Transaction type: expense or income"),
    limit: int = Query(default=10, ge=1, le=50),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get breakdown by category for specified transaction type."""
    try:
        service = StatisticsService(db)

        account_type_list = None
        if account_types:
            account_type_list = [t.strip() for t in account_types.split(",")]

        result = await service.get_category_breakdown(
            user_uuid=current_user.uuid,
            time_range=time_range,
            start_date=start_date,
            end_date=end_date,
            account_types=account_type_list,
            transaction_type=transaction_type,
            limit=limit,
        )

        return success_response(data=result.model_dump(), message="Category breakdown retrieved successfully")
    except Exception as e:
        logger.error(
            "failed_to_get_category_breakdown",
            error=str(e),
            user_uuid=str(current_user.uuid),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve category breakdown",
            http_status=500,
        )


@router.get("/top-transactions")
async def get_top_transactions(
    time_range: str = Query(default="month"),
    start_date: Optional[str] = Query(default=None),
    end_date: Optional[str] = Query(default=None),
    account_types: Optional[str] = Query(default=None),
    transaction_type: str = Query(default="expense", description="Transaction type: expense or income"),
    sort_by: str = Query(default="amount", description="Sort by: amount or date"),
    page: int = Query(default=1, ge=1),
    size: int = Query(default=10, ge=1, le=50),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get top transactions for the period."""
    try:
        service = StatisticsService(db)

        account_type_list = None
        if account_types:
            account_type_list = [t.strip() for t in account_types.split(",")]

        result = await service.get_top_transactions(
            user_uuid=current_user.uuid,
            time_range=time_range,
            start_date=start_date,
            end_date=end_date,
            account_types=account_type_list,
            transaction_type=transaction_type,
            sort_by=sort_by,
            page=page,
            size=size,
        )

        return success_response(data=result.model_dump(), message="Top transactions retrieved successfully")
    except Exception as e:
        logger.error(
            "failed_to_get_top_transactions",
            error=str(e),
            user_uuid=str(current_user.uuid),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve top transactions",
            http_status=500,
        )


@router.get("/cash-flow")
async def get_cash_flow_analysis(
    time_range: str = Query(default="month"),
    start_date: Optional[str] = Query(default=None),
    end_date: Optional[str] = Query(default=None),
    account_types: Optional[str] = Query(default=None),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get comprehensive cash flow analysis for the period.

    Returns key financial metrics including:
    - Net cash flow (income - expense)
    - Savings rate percentage
    - Expense to income ratio
    - Essential vs discretionary expense breakdown
    - Period-over-period comparison
    """
    try:
        service = StatisticsService(db)

        account_type_list = None
        if account_types:
            account_type_list = [t.strip() for t in account_types.split(",")]

        result = await service.get_cash_flow(
            user_uuid=current_user.uuid,
            time_range=time_range,
            start_date=start_date,
            end_date=end_date,
            account_types=account_type_list,
        )

        return success_response(data=result.model_dump(), message="Cash flow analysis retrieved successfully")
    except Exception as e:
        logger.error(
            "failed_to_get_cash_flow",
            error=str(e),
            user_uuid=str(current_user.uuid),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve cash flow analysis",
            http_status=500,
        )


@router.get("/health-score")
async def get_health_score(
    time_range: str = Query(default="month"),
    start_date: Optional[str] = Query(default=None),
    end_date: Optional[str] = Query(default=None),
    account_types: Optional[str] = Query(default=None),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get financial health score based on multiple dimensions.

    Calculates a comprehensive score (0-100) based on:
    - Savings Rate (40% weight)
    - Expense Control (35% weight)
    - Income Stability (25% weight)

    Returns grade (A-F), dimension breakdowns, and improvement suggestions.
    """
    try:
        service = StatisticsService(db)

        account_type_list = None
        if account_types:
            account_type_list = [t.strip() for t in account_types.split(",")]

        result = await service.get_health_score(
            user_uuid=current_user.uuid,
            time_range=time_range,
            start_date=start_date,
            end_date=end_date,
            account_types=account_type_list,
        )

        return success_response(data=result.model_dump(), message="Health score retrieved successfully")
    except Exception as e:
        logger.error(
            "failed_to_get_health_score",
            error=str(e),
            user_uuid=str(current_user.uuid),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve health score",
            http_status=500,
        )
