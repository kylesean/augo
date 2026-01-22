"""Home page API endpoints.

Provides endpoints for home page data including:
- Total expense summary
- Calendar month heatmap details
"""

from calendar import monthrange
from datetime import datetime
from typing import Any, cast

from fastapi import APIRouter, Depends, Query
from fastapi.responses import JSONResponse
from sqlalchemy import and_, case, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.logging import logger
from app.core.responses import error_response, get_error_code_int, success_response
from app.models.transaction import Transaction
from app.models.user import User

router = APIRouter(prefix="/home", tags=["home"])


@router.get("/total-expense")
async def get_total_expense(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get user's expense summary, including today, month, year, and total expense.

    Base currency scheme:
    - amount field stores CNY base amount
    - returns converted to user preferred display_currency

    Performance optimization: use single query + conditional aggregation, avoid N+1 queries

    Returns:
       Unified response format, containing detailed expense statistics
    """
    from app.utils.currency_utils import (
        convert_base_to_display,
        get_currency_symbol,
        get_user_display_currency,
    )

    try:
        now = datetime.now()
        start_of_day = datetime(now.year, now.month, now.day)
        start_of_month = datetime(now.year, now.month, 1)
        start_of_year = datetime(now.year, 1, 1)

        user_id = str(current_user.uuid)

        # Get user's preferred currency
        display_currency = await get_user_display_currency(db, current_user.uuid)
        currency_symbol = get_currency_symbol(display_currency)

        # Use single query + conditional aggregation to get all statistics (optimization: avoid 4 independent queries)
        result = await db.execute(
            select(
                func.coalesce(
                    func.sum(
                        case((cast(Any, Transaction.transaction_at >= start_of_day), Transaction.amount), else_=0)
                    ),
                    0,
                ).label("today"),
                func.coalesce(
                    func.sum(
                        case((cast(Any, Transaction.transaction_at >= start_of_month), Transaction.amount), else_=0)
                    ),
                    0,
                ).label("month"),
                func.coalesce(
                    func.sum(
                        case((cast(Any, Transaction.transaction_at >= start_of_year), Transaction.amount), else_=0)
                    ),
                    0,
                ).label("year"),
                # Total expense history
                func.coalesce(func.sum(Transaction.amount), 0).label("total"),
            ).where(
                and_(
                    cast(Any, Transaction.user_uuid == user_id),
                    cast(Any, Transaction.type == "EXPENSE"),
                )
            )
        )
        row = result.one()

        today_expense_cny = float(row.today or 0)
        month_expense_cny = float(row.month or 0)
        year_expense_cny = float(row.year or 0)
        total_expense_cny = float(row.total or 0)

        # Convert to user preferred currency
        today_expense = await convert_base_to_display(today_expense_cny, display_currency)
        month_expense = await convert_base_to_display(month_expense_cny, display_currency)
        year_expense = await convert_base_to_display(year_expense_cny, display_currency)
        total_expense = await convert_base_to_display(total_expense_cny, display_currency)

        return success_response(
            data={
                "total_expense": total_expense,
                "today_expense": today_expense,
                "month_expense": month_expense,
                "year_expense": year_expense,
                "display_currency": display_currency,
                "currency": display_currency,  # Keep for backward compatibility
                "display": {
                    "value": f"{total_expense:,.2f}",
                    "currencySymbol": currency_symbol,
                    "fullString": f"{currency_symbol}{total_expense:,.2f}",
                },
            },
            message="Expense statistics retrieved successfully",
        )
    except Exception as e:
        logger.error(f"Failed to retrieve expense statistics: {str(e)}")
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve expense statistics",
            http_status=500,
        )


@router.get("/calendar-month-details")
async def get_calendar_month_details(
    year: int = Query(..., ge=2000, le=2100, description="Year"),
    month: int = Query(..., ge=1, le=12, description="Month"),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """Get calendar month details for the specified month.

    Base currency scheme:
    - amount field stores CNY base amount
    - get exchange rate once, convert all amounts to display currency

    Args:
        year: Year
        month: Month
        current_user: Current user
        db: Database session

    Returns:
        Unified response format, containing daily expense summary and heat level
    """
    from app.utils.currency_utils import (
        get_currency_symbol,
        get_exchange_rate_from_base,
        get_user_display_currency,
    )

    try:
        # Get user's preferred currency and exchange rate
        display_currency = await get_user_display_currency(db, current_user.uuid)
        currency_symbol = get_currency_symbol(display_currency)
        exchange_rate = await get_exchange_rate_from_base(display_currency)

        # Get number of days in the month
        _, days_in_month = monthrange(year, month)

        # Build date range
        start_date = datetime(year, month, 1)
        if month == 12:
            end_date = datetime(year + 1, 1, 1)
        else:
            end_date = datetime(year, month + 1, 1)

        # Query daily expense totals (CNY base)
        result = await db.execute(
            select(
                func.date(Transaction.transaction_at).label("date"),
                func.coalesce(func.sum(Transaction.amount), 0).label("total"),
            )
            .where(
                and_(
                    cast(Any, Transaction.user_uuid == str(current_user.uuid)),
                    cast(Any, Transaction.type == "EXPENSE"),
                    cast(Any, Transaction.transaction_at >= start_date),
                    cast(Any, Transaction.transaction_at < end_date),
                )
            )
            .group_by(func.date(Transaction.transaction_at))
        )
        # Convert to user preferred currency
        daily_totals = {row.date: round(float(row.total) * exchange_rate, 2) for row in result.all()}

        # Calculate monthly total expense
        total_expense_for_month = round(sum(daily_totals.values()), 2)

        # Get list of non-zero expense amounts for percentile calculation
        non_zero_amounts = sorted([v for v in daily_totals.values() if v > 0])

        def get_heat_level(amount: float) -> str:
            """基于百分位计算热力等级"""
            if amount <= 0:
                return "none"
            if not non_zero_amounts:
                return "none"

            # find the percentage of amounts below the given amount
            count_below = sum(1 for x in non_zero_amounts if x < amount)
            percentile = count_below / len(non_zero_amounts)

            if percentile < 0.25:
                return "low"
            elif percentile < 0.50:
                return "medium"
            elif percentile < 0.75:
                return "high"
            else:
                return "veryHigh"

        # Build daily summaries
        daily_summaries = []
        for day in range(1, days_in_month + 1):
            date_obj = datetime(year, month, day).date()
            total_expense = daily_totals.get(date_obj, 0.0)
            heat_level = get_heat_level(total_expense)

            daily_summaries.append(
                {
                    "date": date_obj.isoformat(),
                    "totalExpense": total_expense,
                    "heatLevel": heat_level,
                }
            )

        return success_response(
            data={
                "year": year,
                "month": month,
                "totalExpenseForMonth": total_expense_for_month,
                "dailySummaries": daily_summaries,
                "display_currency": display_currency,
                "currency_symbol": currency_symbol,
                "exchange_rate": exchange_rate,
            },
            message="Calendar month details retrieved successfully",
        )
    except Exception:
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve calendar month details",
            http_status=500,
        )
