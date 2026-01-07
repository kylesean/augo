"""Transaction Query Service - Shared business logic for transaction queries.

This service provides a unified interface for querying transactions, used by both:
- FastAPI endpoints (/api/v1/transactions)
- LangGraph tools (@tool search_transactions)

Best practice: Business logic lives here, not in API routes or tool definitions.
"""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import cast as type_cast
from uuid import UUID

from pydantic import BaseModel, Field
from sqlalchemy import String, and_, cast, desc, func, or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import db_manager
from app.core.logging import logger
from app.models.transaction import Transaction
from app.schemas.transaction import TransactionDisplayValue
from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency

# ============================================================================
# Enums
# ============================================================================


class TransactionType(str, Enum):
    """交易类型枚举"""

    EXPENSE = "EXPENSE"
    INCOME = "INCOME"
    TRANSFER = "TRANSFER"


# ============================================================================
# Response Models with Computed Fields
# ============================================================================

# TransactionDisplayValue has been moved to app.schemas.transaction


class TransactionItem(BaseModel):
    """单个交易记录的响应模型"""

    id: str
    user_uuid: str
    type: str
    amount: float
    amount_original: str
    currency: str
    category_key: str | None = None
    description: str | None = None
    transaction_at: str
    transaction_timezone: str
    location: str | None = None
    tags: list[str] | None = None
    source: str
    status: str
    raw_input: str | None = None
    source_account_id: str | None = None
    target_account_id: str | None = None
    created_at: str | None = None
    updated_at: str | None = None
    display: TransactionDisplayValue

    @classmethod
    def from_transaction(
        cls, tx: Transaction, display_currency: str = "CNY", exchange_rate: float = 1.0
    ) -> TransactionItem:
        """从 Transaction 模型创建响应实例

        Args:
            tx: 交易模型
            display_currency: 目标显示币种
            exchange_rate: 从基准币种 (CNY) 到目标币种的汇率
        """
        # 换算金额
        amount_val = float(tx.amount)
        if display_currency != BASE_CURRENCY:
            amount_val = amount_val * exchange_rate

        return cls(
            id=str(tx.id),
            user_uuid=str(tx.user_uuid),
            type=tx.type,
            amount=round(amount_val, 2),
            amount_original=str(tx.amount_original),
            currency=display_currency,
            category_key=tx.category_key,
            description=tx.description or "",
            transaction_at=tx.transaction_at.isoformat() if tx.transaction_at else None,
            transaction_timezone=tx.transaction_timezone,
            location=tx.location,
            tags=tx.tags,
            source=tx.source,
            status=tx.status,
            raw_input=tx.raw_input,
            source_account_id=str(tx.source_account_id) if tx.source_account_id else None,
            target_account_id=str(tx.target_account_id) if tx.target_account_id else None,
            created_at=type_cast(datetime, tx.created_at).isoformat() if tx.created_at else None,
            updated_at=type_cast(datetime, tx.updated_at).isoformat() if tx.updated_at else None,
            display=TransactionDisplayValue.from_params(amount=amount_val, tx_type=tx.type, currency=display_currency),
        )


class TransactionQueryResult(BaseModel):
    """交易查询结果"""

    items: list[TransactionItem]
    total: int
    page: int
    per_page: int
    pages: int
    has_more: bool


# ============================================================================
# Query Parameters
# ============================================================================


class TransactionQueryParams(BaseModel):
    """交易查询参数"""

    keyword: str | None = Field(None, description="关键词搜索（描述、地点、标签）")
    min_amount: float | None = Field(None, description="最小金额（绝对值）")
    max_amount: float | None = Field(None, description="最大金额（绝对值）")
    transaction_types: list[TransactionType] | None = Field(None, description="交易类型列表")
    category_keys: list[str] | None = Field(None, description="分类键列表")
    tags: list[str] | None = Field(None, description="标签列表")
    start_date: str | None = Field(None, description="开始日期 (ISO 8601)")
    end_date: str | None = Field(None, description="结束日期 (ISO 8601)")
    date: str | None = Field(None, description="指定日期 (YYYY-MM-DD)，用于首页日历")
    page: int = Field(1, ge=1, description="页码")
    per_page: int = Field(20, ge=1, le=100, description="每页数量")


# ============================================================================
# Service Implementation
# ============================================================================


def _parse_date_to_utc(date_str: str, end_of_day: bool = False) -> datetime | None:
    """将日期字符串解析为 UTC 时区的 datetime 对象。

    使用 dateutil.parser 处理各种日期格式，包括:
    - ISO 8601 带时区: 2025-12-25T00:00:00+08:00
    - ISO 8601 UTC: 2025-12-25T00:00:00Z
    - 纯日期: 2025-12-25 (默认 UTC 00:00:00)

    Args:
        date_str: 日期字符串
        end_of_day: 如果为 True，设置为当天 23:59:59.999999 UTC

    Returns:
        UTC 时区的 datetime 对象，解析失败返回 None
    """
    if not date_str:
        return None

    try:
        from dateutil import (
            parser as dateutil_parser,
            tz,
        )

        # dateutil 自动处理各种格式，包括 'Z' 后缀
        dt = dateutil_parser.parse(date_str)

        # 如果是 naive datetime，假定为 UTC
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=tz.UTC)
        else:
            # 转换为 UTC
            dt = dt.astimezone(tz.UTC)

        # 设置为当天结束
        if end_of_day:
            dt = dt.replace(hour=23, minute=59, second=59, microsecond=999999)

        return dt

    except (ValueError, TypeError):
        return None


class TransactionQueryService:
    """交易查询服务 - 核心业务逻辑

    使用方式:
        # 在 API 端点中
        service = TransactionQueryService(db_session)
        result = await service.search(user_uuid, params)

        # 在 LangGraph 工具中
        async with db_manager.session_factory() as session:
            service = TransactionQueryService(session)
            result = await service.search(user_uuid, params)
    """

    def __init__(self, db: AsyncSession):
        """初始化服务

        Args:
            db: 异步数据库会话
        """
        self.db = db

    async def search(self, user_uuid: str, params: TransactionQueryParams) -> TransactionQueryResult:
        """搜索交易记录

        Args:
            user_uuid: 用户 UUID
            params: 查询参数

        Returns:
            TransactionQueryResult 包含分页的交易列表
        """
        try:
            # 构建基础查询条件
            conditions = [Transaction.user_uuid == UUID(user_uuid)]

            # 关键词搜索：匹配 description, location, tags
            if params.keyword:
                keyword_pattern = f"%{params.keyword}%"
                conditions.append(
                    or_(
                        Transaction.description.ilike(keyword_pattern),  # type: ignore
                        Transaction.location.ilike(keyword_pattern),  # type: ignore
                        cast(Transaction.tags, String).ilike(keyword_pattern),  # type: ignore
                    )
                )

            # 金额范围
            if params.min_amount is not None:
                conditions.append(func.abs(Transaction.amount) >= params.min_amount)
            if params.max_amount is not None:
                conditions.append(func.abs(Transaction.amount) <= params.max_amount)

            # 交易类型
            if params.transaction_types:
                type_values = [t.value for t in params.transaction_types]
                conditions.append(Transaction.type.in_(type_values))  # type: ignore

            # 分类
            if params.category_keys:
                conditions.append(Transaction.category_key.in_(params.category_keys))  # type: ignore

            # 标签（JSONB contains）
            if params.tags:
                for tag in params.tags:
                    conditions.append(Transaction.tags.contains([tag]))

            # 日期范围
            if params.start_date:
                start_dt = _parse_date_to_utc(params.start_date, end_of_day=False)
                if start_dt:
                    conditions.append(Transaction.transaction_at >= start_dt)

            if params.end_date:
                end_dt = _parse_date_to_utc(params.end_date, end_of_day=True)
                if end_dt:
                    conditions.append(Transaction.transaction_at <= end_dt)

            # 指定日期（用于首页日历）
            if params.date:
                day_start = _parse_date_to_utc(params.date, end_of_day=False)
                day_end = _parse_date_to_utc(params.date, end_of_day=True)
                if day_start and day_end:
                    conditions.append(Transaction.transaction_at >= day_start)
                    conditions.append(Transaction.transaction_at <= day_end)

            # 构建查询
            stmt = select(Transaction).where(and_(*conditions))

            # 计算总数
            count_stmt = select(func.count()).select_from(stmt.subquery())
            total_result = await self.db.execute(count_stmt)
            total = total_result.scalar() or 0

            # 计算分页
            pages = (total + params.per_page - 1) // params.per_page if total > 0 else 0
            has_more = params.page < pages

            # 排序和分页
            stmt = stmt.order_by(desc(Transaction.transaction_at))
            stmt = stmt.offset((params.page - 1) * params.per_page).limit(params.per_page)

            # 执行查询
            result = await self.db.execute(stmt)
            transactions = result.scalars().all()

            # 获取汇率和用户偏好币种
            display_currency = await get_user_display_currency(self.db, UUID(user_uuid))
            exchange_rate = await get_exchange_rate_from_base(display_currency)

            # 转换为响应模型
            items = [
                TransactionItem.from_transaction(tx, display_currency=display_currency, exchange_rate=exchange_rate)
                for tx in transactions
            ]

            logger.info(
                "transaction_query_complete",
                user_uuid=user_uuid,
                total=total,
                page=params.page,
                returned=len(items),
            )

            return TransactionQueryResult(
                items=items, total=total, page=params.page, per_page=params.per_page, pages=pages, has_more=has_more
            )

        except Exception as e:
            logger.error(
                "transaction_query_failed",
                user_uuid=user_uuid,
                error=str(e),
                exc_info=True,
            )
            raise

    async def get_feed(
        self,
        user_uuid: str,
        date: str | None = None,
        transaction_type: TransactionType | None = None,
        page: int = 1,
        per_page: int = 20,
    ) -> TransactionQueryResult:
        """获取首页交易 Feed

        Args:
            user_uuid: 用户 UUID
            date: 可选的日期过滤 (YYYY-MM-DD)
            transaction_type: 可选的交易类型过滤
            page: 页码
            per_page: 每页数量

        Returns:
            TransactionQueryResult
        """
        params = TransactionQueryParams(
            date=date, transaction_types=[transaction_type] if transaction_type else None, page=page, per_page=per_page
        )
        return await self.search(user_uuid, params)


# ============================================================================
# Singleton for use in LangGraph tools
# ============================================================================


async def query_transactions(user_uuid: str, params: TransactionQueryParams) -> TransactionQueryResult:
    """便捷函数：在 LangGraph 工具中使用

    自动创建数据库会话并执行查询。

    Args:
        user_uuid: 用户 UUID
        params: 查询参数

    Returns:
        TransactionQueryResult
    """
    async with db_manager.session_factory() as session:
        service = TransactionQueryService(session)
        return await service.search(user_uuid, params)
