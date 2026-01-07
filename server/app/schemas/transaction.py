"""Transaction schemas for request/response validation."""

from datetime import datetime
from decimal import Decimal
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator


# Request schemas
class TransactionDisplayValue(BaseModel):
    """Unified display format for financial amounts.

    The client should render these fields directly without any logic.
    Compact formatting (万/亿 vs K/M) is handled by client based on user's Locale.

    Fields:
    - sign: '+', '-', or empty
    - value: Plain formatted amount with 2 decimals, e.g., '1234.56'
    - valueFormatted: With thousand separators, e.g., '1,234.56'
    - currencySymbol: e.g., '¥' or '$'
    - fullString: Complete display string, e.g., '- ¥1,234.56'
    """

    sign: str = Field(description="Symbol: '+', '-', or empty")
    value: str = Field(description="Plain formatted amount, e.g., '1234.56'")
    valueFormatted: str = Field(description="With thousand separators, e.g., '1,234.56'")
    currencySymbol: str = Field(description="Currency symbol, e.g., '¥' or '$'")
    fullString: str = Field(description="Complete string with separators, e.g., '- ¥1,234.56'")

    model_config = ConfigDict(populate_by_name=True)

    @classmethod
    def from_params(cls, amount: float, tx_type: str, currency: str = "CNY") -> "TransactionDisplayValue":
        """Factory method to create display value from raw parameters."""
        # 1. Determine Sign
        tx_type_upper = tx_type.upper()
        if tx_type_upper == "INCOME":
            sign = "+"
        elif tx_type_upper == "EXPENSE":
            sign = "-"
        else:
            sign = ""

        # 2. Format Value (plain)
        abs_amount = abs(float(amount))
        value_str = f"{abs_amount:.2f}"

        # 3. Format Value with thousand separators
        value_formatted = f"{abs_amount:,.2f}"

        # 4. Map Currency Symbol
        currency_map = {
            "CNY": "¥",
            "USD": "$",
            "EUR": "€",
            "GBP": "£",
            "JPY": "¥",
            "CAD": "C$",
            "AUD": "A$",
            "INR": "₹",
            "RUB": "₽",
            "HKD": "HK$",
            "TWD": "NT$",
        }
        symbol = currency_map.get(currency.upper(), currency or "¥")

        # 5. Build Full String (with thousand separators)
        if sign:
            full = f"{sign} {symbol}{value_formatted}"
        else:
            full = f"{symbol}{value_formatted}"

        return cls(sign=sign, value=value_str, valueFormatted=value_formatted, currencySymbol=symbol, fullString=full)


class UpdateAccountRequest(BaseModel):
    """更新交易关联账户请求"""

    account_id: str | None = Field(None, description="关联账户 ID，传 null 表示取消关联")


class UpdateBatchAccountRequest(BaseModel):
    """批量更新交易关联账户请求"""

    transaction_ids: list[str] = Field(..., description="交易 ID 列表")
    account_id: str | None = Field(..., description="关联账户 ID")


class CreateTransactionItem(BaseModel):
    """单笔交易创建信息

    【重要】每笔交易必须有独立的标签，描述该笔交易的具体内容。
    例如 "咖啡25，吉野家35" 应该产生：
    - 交易1: tags=["咖啡", "饮品"], amount=25
    - 交易2: tags=["吉野家", "午餐"], amount=35
    """

    amount: float = Field(..., gt=0, description="交易金额")
    tags: list[str] = Field(
        ...,
        min_length=1,
        description="""【必填】该笔交易的独立标签，描述具体消费内容。
每笔交易的标签必须不同！
示例：
- "咖啡" → ["咖啡", "饮品"]
- "吉野家" → ["吉野家", "午餐"]
- "打车" → ["打车", "通勤"]""",
    )
    transaction_type: Literal["expense", "income", "transfer"] = Field(default="expense")
    category_key: str = Field(default="OTHERS")
    raw_input: str | None = Field(None, description="该笔交易对应的原始输入片段")


class BatchCreateTransactionRequest(BaseModel):
    """批量创建交易请求"""

    transactions: list[CreateTransactionItem] = Field(..., min_length=1)
    source_account_id: str | None = Field(None, description="可选的全局关联账户 ID")


class TransactionSearchRequest(BaseModel):
    """搜索交易请求"""

    keyword: str | None = None
    min_amount: str | None = Field(None, description="Minimum amount as string")
    max_amount: str | None = Field(None, description="Maximum amount as string")
    categories: list[str] | None = None
    payment_methods: list[str] | None = None
    tags: list[str] | None = None
    start_date: str | None = None
    end_date: str | None = None
    page: int = Field(default=1, ge=1)
    per_page: int = Field(default=10, ge=1, le=100)

    @field_validator("min_amount", "max_amount")
    @classmethod
    def validate_amount(cls, v: str | None) -> str | None:
        """Validate amount string if provided."""
        if v is None:
            return None
        try:
            Decimal(v)  # Just validate, don't normalize for search
            return v
        except Exception as e:
            raise ValueError(f"Invalid amount format: {e}")


class RecurringTransactionCreateRequest(BaseModel):
    """创建周期性交易请求"""

    # Required fields
    type: str = Field(..., description="Transaction type: EXPENSE, INCOME, TRANSFER")
    amount: str = Field(..., description="Transaction amount as string")
    recurrence_rule: str  # RRULE format
    start_date: str  # YYYY-MM-DD

    # Optional account references
    source_account_id: str | None = Field(None, description="Source account UUID")
    target_account_id: str | None = Field(None, description="Target account UUID")

    # Amount settings
    amount_type: str = Field(default="FIXED", description="FIXED or ESTIMATE")
    requires_confirmation: bool = Field(default=False, description="Requires confirmation before generating")
    currency: str = Field(default="CNY", description="Currency code (CNY, USD, JPY, etc.)")

    # Classification
    category_key: str | None = Field(default="OTHERS", description="Category key")
    tags: list[str] | None = Field(default=None, description="Tags list")

    # Rule settings
    timezone: str = Field(default="Asia/Shanghai", description="Timezone for the rule")
    end_date: str | None = None  # YYYY-MM-DD
    exception_dates: list[str] | None = None

    # Metadata
    description: str | None = None
    is_active: bool = True

    @field_validator("amount")
    @classmethod
    def validate_amount(cls, v: str) -> str:
        """Validate and normalize amount string."""
        try:
            decimal_val = Decimal(v)
            return f"{decimal_val:.8f}"
        except Exception as e:
            raise ValueError(f"Invalid amount format: {e}")

    @field_validator("type")
    @classmethod
    def validate_type(cls, v: str) -> str:
        """Validate transaction type."""
        valid_types = {"EXPENSE", "INCOME", "TRANSFER"}
        if v.upper() not in valid_types:
            raise ValueError(f"Type must be one of: {', '.join(valid_types)}")
        return v.upper()

    @field_validator("amount_type")
    @classmethod
    def validate_amount_type(cls, v: str) -> str:
        """Validate amount type."""
        valid_types = {"FIXED", "ESTIMATE"}
        if v.upper() not in valid_types:
            raise ValueError(f"Amount type must be one of: {', '.join(valid_types)}")
        return v.upper()


class RecurringTransactionCreate(BaseModel):
    """Recurring transaction creation schema (camelCase support)"""

    # Required fields
    type: str = Field(..., description="Transaction type: EXPENSE, INCOME, TRANSFER")
    amount: str = Field(..., description="Transaction amount")
    recurrenceRule: str = Field(..., description="RRULE format recurrence rule", alias="recurrence_rule")
    startDate: str = Field(..., description="Start date (YYYY-MM-DD)", alias="start_date")

    # Optional account references
    sourceAccountId: str | None = Field(None, description="Source account UUID", alias="source_account_id")
    targetAccountId: str | None = Field(None, description="Target account UUID", alias="target_account_id")

    # Amount settings
    amountType: str = Field(default="FIXED", description="FIXED or ESTIMATE", alias="amount_type")
    requiresConfirmation: bool = Field(
        default=False, description="Requires confirmation", alias="requires_confirmation"
    )
    currency: str = Field(default="CNY", description="Currency code")

    # Classification
    categoryKey: str | None = Field(default="OTHERS", description="Category key", alias="category_key")
    tags: list[str] | None = Field(default=None, description="Tags list")

    # Rule settings
    timezone: str = Field(default="Asia/Shanghai", description="Timezone")
    endDate: str | None = Field(None, description="End date (YYYY-MM-DD)", alias="end_date")
    exceptionDates: list[str] | None = Field(None, description="Exception dates", alias="exception_dates")

    # Metadata
    description: str | None = Field(None, description="Transaction description")
    isActive: bool = Field(default=True, alias="is_active")

    # Allow both camelCase and snake_case
    model_config = ConfigDict(populate_by_name=True)


class RecurringTransactionUpdateRequest(BaseModel):
    """更新周期性交易请求"""

    # Transaction type
    type: str | None = None

    # Account references
    source_account_id: str | None = None
    target_account_id: str | None = None

    # Amount settings
    amount_type: str | None = None
    requires_confirmation: bool | None = None
    amount: str | None = None
    currency: str | None = None

    # Classification
    category_key: str | None = None
    tags: list[str] | None = None

    # Rule settings
    recurrence_rule: str | None = None
    timezone: str | None = None
    start_date: str | None = None
    end_date: str | None = None
    exception_dates: list[str] | None = None

    # Execution control
    next_execution_at: str | None = None

    # Metadata
    description: str | None = None
    is_active: bool | None = None

    @field_validator("amount")
    @classmethod
    def validate_amount(cls, v: str | None) -> str | None:
        """Validate and normalize amount string if provided."""
        if v is None:
            return None
        try:
            decimal_val = Decimal(v)
            return f"{decimal_val:.8f}"
        except Exception as e:
            raise ValueError(f"Invalid amount format: {e}")

    @field_validator("type")
    @classmethod
    def validate_type(cls, v: str | None) -> str | None:
        """Validate transaction type if provided."""
        if v is None:
            return None
        valid_types = {"EXPENSE", "INCOME", "TRANSFER"}
        if v.upper() not in valid_types:
            raise ValueError(f"Type must be one of: {', '.join(valid_types)}")
        return v.upper()

    @field_validator("amount_type")
    @classmethod
    def validate_amount_type(cls, v: str | None) -> str | None:
        """Validate amount type if provided."""
        if v is None:
            return None
        valid_types = {"FIXED", "ESTIMATE"}
        if v.upper() not in valid_types:
            raise ValueError(f"Amount type must be one of: {', '.join(valid_types)}")
        return v.upper()


class CashFlowForecastRequest(BaseModel):
    """现金流预测请求"""

    forecast_days: int = Field(default=60, ge=1, le=365)
    granularity: str = Field(default="daily")
    scenarios: list[dict] | None = None

    @field_validator("granularity")
    @classmethod
    def validate_granularity(cls, v: str) -> str:
        """验证粒度参数"""
        if v not in ["daily", "weekly", "monthly"]:
            raise ValueError("granularity must be one of: daily, weekly, monthly")
        return v


class CommentCreateRequest(BaseModel):
    """创建评论请求"""

    comment_text: str = Field(min_length=1)
    parent_comment_id: int | None = None


# Response schemas
class TransactionResponse(BaseModel):
    """交易响应"""

    id: str  # UUID as string
    user_uuid: str
    type: str  # EXPENSE, INCOME, TRANSFER
    source_account_id: str | None = None  # UUID as string
    target_account_id: str | None = None  # UUID as string
    amount: str  # Decimal as string
    amount_original: str  # Original amount
    currency: str
    category_key: str  # Category key
    description: str | None
    transaction_at: datetime  # Transaction timestamp
    transaction_timezone: str  # Original timezone
    location: str | None
    tags: list[str] | None
    source: str  # MANUAL, AI, IMPORT
    status: str  # CLEARED, PENDING
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class TransactionDetailResponse(BaseModel):
    """交易详情响应"""

    id: str  # UUID as string
    user_uuid: str
    type: str
    amount: str
    amount_original: str
    currency: str
    exchange_rate: str | None
    category_key: str
    description: str | None
    transaction_at: datetime
    transaction_timezone: str
    tags: list[str] | None
    location: str | None
    latitude: str | None
    longitude: str | None
    source: str
    status: str
    raw_input: str
    source_account_id: str | None = None  # UUID as string
    target_account_id: str | None = None  # UUID as string
    shared_space_id: int | None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class CommentResponse(BaseModel):
    """评论响应"""

    id: str
    transaction_id: str
    user_uuid: str
    user_name: str
    user_avatar_url: str
    parent_comment_id: str | None
    comment_text: str
    replied_to_user_uuid: str | None
    replied_to_user_name: str | None
    created_at: str
    updated_at: str | None


class RecurringTransactionResponse(BaseModel):
    """周期性交易响应"""

    id: str  # UUID as string
    user_uuid: str  # UUID as string

    # Transaction type
    type: str  # EXPENSE, INCOME, TRANSFER

    # Account references
    source_account_id: str | None = None
    target_account_id: str | None = None

    # Amount settings
    amount_type: str
    requires_confirmation: bool
    amount: str
    currency: str

    # Classification
    category_key: str | None
    tags: list[str] | None

    # Rule settings
    recurrence_rule: str
    timezone: str
    start_date: str
    end_date: str | None
    exception_dates: list[str] | None

    # Execution control
    last_generated_at: datetime | None
    next_execution_at: datetime | None

    # Metadata
    description: str | None
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class ForecastDayBreakdown(BaseModel):
    """预测日明细"""

    date: str
    closingBalance: str
    events: list[dict]


class ForecastWarning(BaseModel):
    """预测预警"""

    date: str
    message: str


class ForecastSummary(BaseModel):
    """预测汇总"""

    startBalance: str
    endBalance: str
    totalIncome: str
    totalExpense: str


class CashFlowForecastResponse(BaseModel):
    """现金流预测响应"""

    dailyBreakdown: list[ForecastDayBreakdown]
    warnings: list[ForecastWarning]
    summary: ForecastSummary


class PaginatedTransactionResponse(BaseModel):
    """分页交易响应"""

    data: list[TransactionResponse]
    meta: dict
