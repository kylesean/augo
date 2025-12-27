"""Statistics schemas for request/response validation."""

from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, Field

# Re-export for backward compatibility
__all__ = []


# ============================================================================
# Request Schemas
# ============================================================================


class StatisticsQueryParams(BaseModel):
    """Common query parameters for statistics endpoints."""

    time_range: str = Field(default="month", description="Time range: week, month, year, or custom")
    start_date: Optional[str] = Field(default=None, description="Start date for custom range (ISO 8601 format)")
    end_date: Optional[str] = Field(default=None, description="End date for custom range (ISO 8601 format)")
    account_types: Optional[str] = Field(default=None, description="Comma-separated list of account types to filter")


# ============================================================================
# Response Schemas
# ============================================================================


class StatisticsOverviewResponse(BaseModel):
    """Response for statistics overview endpoint."""

    totalBalance: str = Field(..., description="Total balance as string")
    totalIncome: str = Field(..., description="Total income for period")
    totalExpense: str = Field(..., description="Total expense for period")
    incomeChangePercent: float = Field(..., description="Income change percentage compared to previous period")
    expenseChangePercent: float = Field(..., description="Expense change percentage compared to previous period")
    netChangePercent: float = Field(..., description="Net cash flow change percentage compared to previous period")
    balanceNote: str = Field(default="实时资产余额", description="Note explaining the balance value")
    periodStart: datetime = Field(..., description="Period start datetime")
    periodEnd: datetime = Field(..., description="Period end datetime")


class TrendDataPoint(BaseModel):
    """Single data point for trend chart."""

    date: str = Field(..., description="Date string or label")
    amount: str = Field(..., description="Amount as string (Decimal)")
    label: str = Field(..., description="Display label for x-axis")


class TrendDataResponse(BaseModel):
    """Response for trend data endpoint."""

    dataPoints: List[TrendDataPoint] = Field(..., description="List of trend data points")
    timeRange: str = Field(..., description="Time range used")
    transactionType: str = Field(..., description="Transaction type: expense or income")


class CategoryBreakdownItem(BaseModel):
    """Single category breakdown item."""

    categoryKey: str = Field(..., description="Category key identifier")
    categoryName: str = Field(..., description="Display name for category")
    amount: str = Field(..., description="Total amount for category")
    percentage: float = Field(..., description="Percentage of total")
    color: str = Field(..., description="Hex color for chart")
    icon: str = Field(..., description="Icon/emoji for category")


class CategoryBreakdownResponse(BaseModel):
    """Response for category breakdown endpoint."""

    items: List[CategoryBreakdownItem] = Field(..., description="List of category breakdowns")
    total: str = Field(..., description="Total amount across all categories")


class TopTransactionItem(BaseModel):
    """Single top transaction item."""

    id: str = Field(..., description="Transaction UUID")
    description: str = Field(..., description="Transaction description")
    amount: str = Field(..., description="Transaction amount")
    categoryKey: str = Field(..., description="Category key")
    categoryName: str = Field(..., description="Category display name")
    transactionAt: datetime = Field(..., description="Transaction datetime")
    icon: str = Field(..., description="Icon/emoji for category")


class TopTransactionsResponse(BaseModel):
    """Response for top transactions endpoint."""

    items: List[TopTransactionItem] = Field(..., description="List of top transactions")
    sortBy: str = Field(..., description="Sort method: amount or date")
    total: int = Field(..., description="Total count of transactions matching filters")
    page: int = Field(default=1, description="Current page number")
    pageSize: int = Field(default=10, description="Items per page")
    hasMore: bool = Field(default=False, description="Whether there are more items to load")


class CashFlowResponse(BaseModel):
    """Response for cash flow analysis endpoint."""

    # Core cash flow metrics
    totalIncome: str = Field(..., description="Total income for period")
    totalExpense: str = Field(..., description="Total expense for period")
    netCashFlow: str = Field(..., description="Net cash flow (income - expense)")

    # Financial ratios
    savingsRate: float = Field(..., description="Savings rate percentage: (income - expense) / income * 100")
    expenseToIncomeRatio: float = Field(..., description="Expense to income ratio percentage: expense / income * 100")

    # Category breakdown ratios
    essentialExpenseRatio: float = Field(
        default=0.0, description="Essential expenses (housing, food, transport, medical) / total expense"
    )
    discretionaryExpenseRatio: float = Field(
        default=0.0, description="Discretionary expenses (entertainment, shopping) / total expense"
    )

    # Comparison
    incomeChangePercent: float = Field(..., description="Income change vs previous period")
    expenseChangePercent: float = Field(..., description="Expense change vs previous period")
    savingsRateChange: float = Field(..., description="Savings rate change vs previous period (percentage points)")

    # Period info
    periodStart: datetime = Field(..., description="Period start datetime")
    periodEnd: datetime = Field(..., description="Period end datetime")


class HealthScoreDimension(BaseModel):
    """Individual health score dimension."""

    name: str = Field(..., description="Dimension name")
    score: int = Field(..., ge=0, le=100, description="Score 0-100")
    weight: float = Field(..., description="Weight in total calculation")
    description: str = Field(..., description="Description of this dimension")
    status: str = Field(..., description="Status: excellent, good, fair, or poor")


class HealthScoreResponse(BaseModel):
    """Response for financial health score endpoint."""

    # Overall score
    totalScore: int = Field(..., ge=0, le=100, description="Overall financial health score 0-100")
    grade: str = Field(..., description="Grade: A (90+), B (75-89), C (60-74), D (45-59), F (<45)")

    # Dimension breakdowns
    dimensions: List[HealthScoreDimension] = Field(..., description="Individual dimension scores")

    # Suggestions
    suggestions: List[str] = Field(default_factory=list, description="Improvement suggestions based on scores")

    # Period info
    periodStart: datetime = Field(..., description="Period start datetime")
    periodEnd: datetime = Field(..., description="Period end datetime")
