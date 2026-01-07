"""Transaction query service for search and feed operations."""

from datetime import datetime
from typing import Any, cast
from uuid import UUID

import structlog
from sqlalchemy import desc, func, or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.transaction import Transaction
from app.schemas.transaction import TransactionDisplayValue
from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency

logger = structlog.get_logger(__name__)


class TransactionQueryService:
    """Service for transaction query and search operations."""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_transaction_feed(
        self,
        user_uuid: UUID,
        date_filter: str | None = None,
        type_filter: str = "all",
        page: int = 1,
        limit: int = 10,
    ) -> dict:
        """获取交易流列表（包含自动汇率转换）"""
        # 1. 获取用户偏好币种和汇率
        display_currency = await get_user_display_currency(self.db, user_uuid)
        rate = await get_exchange_rate_from_base(display_currency)

        # 2. 构建查询
        query = select(Transaction).where(Transaction.user_uuid == user_uuid)

        # 日期过滤
        if date_filter:
            try:
                filter_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
                query = query.where(func.date(Transaction.transaction_at) == filter_date)
            except ValueError:
                logger.warning(f"Invalid date format: {date_filter}")

        # 类型过滤
        if type_filter == "income":
            query = query.where(Transaction.type == "INCOME")
        elif type_filter == "expense":
            query = query.where(Transaction.type == "EXPENSE")

        # 排序
        query = query.order_by(Transaction.transaction_at.desc(), Transaction.id.desc())

        # 计算总数
        count_query = select(func.count()).select_from(query.subquery())
        total_result = await self.db.execute(count_query)
        total = total_result.scalar() or 0

        # 分页
        offset = (page - 1) * limit
        query = query.offset(offset).limit(limit)

        # 执行查询
        result = await self.db.execute(query)
        transactions = result.scalars().all()

        # 3. 组装数据并执行换算
        data = []
        for tx in transactions:
            amount_val = float(tx.amount)
            # 如果不是基准货币，则进行换算
            if display_currency != BASE_CURRENCY:
                amount_val = round(amount_val * float(rate), 2)

            data.append(
                {
                    "id": str(tx.id),
                    "userUuid": str(tx.user_uuid),
                    "type": tx.type,
                    "amount": amount_val,
                    "currency": display_currency,
                    "categoryKey": tx.category_key,
                    "description": tx.description,
                    "transactionAt": cast(datetime, tx.transaction_at).isoformat(),
                    "tags": tx.tags or [],
                    "createdAt": cast(datetime, tx.created_at).isoformat(),
                    "updatedAt": cast(datetime, tx.updated_at).isoformat(),
                    "display": TransactionDisplayValue.from_params(
                        amount=amount_val, tx_type=tx.type, currency=display_currency
                    ).model_dump(),
                }
            )

        return {
            "data": data,
            "meta": {
                "total": total,
                "current_page": page,
                "per_page": limit,
                "last_page": (total + limit - 1) // limit if total > 0 else 1,
                "has_more": total > page * limit,
            },
        }

    async def search_transactions(self, user_uuid: UUID, filters: dict) -> dict:
        """搜索交易记录

        Args:
            user_uuid: 用户UUID
            filters: 搜索过滤条件

        Returns:
            包含搜索结果和分页信息的字典
        """
        # 构建基础查询
        query = select(Transaction).where(Transaction.user_uuid == user_uuid)

        # 关键字搜索
        if keyword := filters.get("keyword"):
            query = query.where(
                or_(
                    Transaction.description.ilike(f"%{keyword}%"),  # type: ignore
                    Transaction.location.ilike(f"%{keyword}%"),  # type: ignore
                )
            )

        # 金额范围
        if min_amount := filters.get("min_amount"):
            query = query.where(Transaction.amount >= min_amount)
        if max_amount := filters.get("max_amount"):
            query = query.where(Transaction.amount <= max_amount)

        # 分类筛选
        if categories := filters.get("categories"):
            query = query.where(Transaction.category_key.in_(categories))  # type: ignore

        # 标签筛选
        if tags := filters.get("tags"):
            for tag in tags:
                query = query.where(Transaction.tags.contains([tag]))

        # 日期范围
        if start_date := filters.get("start_date"):
            try:
                start_dt = datetime.strptime(start_date, "%Y-%m-%d")
                query = query.where(Transaction.transaction_at >= start_dt)
            except ValueError:
                logger.warning(f"Invalid start_date format: {start_date}")

        if end_date := filters.get("end_date"):
            try:
                end_dt = datetime.strptime(end_date, "%Y-%m-%d")
                query = query.where(Transaction.transaction_at <= end_dt)
            except ValueError:
                logger.warning(f"Invalid end_date format: {end_date}")

        # 收入/支出筛选
        if type_val := filters.get("type"):
            if type_val:
                query = query.where(Transaction.amount > 0)
            else:
                query = query.where(Transaction.amount < 0)

        # 排序
        query = query.order_by(Transaction.transaction_at.desc())

        # 分页
        page = filters.get("page", 1)
        per_page = filters.get("per_page", 10)
        offset = (page - 1) * per_page

        # 计算总数
        count_query = select(func.count()).select_from(query.subquery())
        total_result = await self.db.execute(count_query)
        total = total_result.scalar() or 0

        # 执行查询
        query = query.offset(offset).limit(per_page)
        result = await self.db.execute(query)
        transactions = result.scalars().all()

        return {
            "data": [
                {
                    "id": tx.id,
                    "user_uuid": tx.user_uuid,
                    "amount": str(tx.amount),
                    "category_key": tx.category_key,
                    "description": tx.description,
                    "transaction_at": cast(datetime, tx.transaction_at).isoformat(),
                    "tags": tx.tags or [],
                    "created_at": cast(datetime, tx.created_at).isoformat(),
                    "updated_at": cast(datetime, tx.updated_at).isoformat(),
                }
                for tx in transactions
            ],
            "meta": {
                "total": total,
                "current_page": page,
                "per_page": per_page,
                "last_page": (total + per_page - 1) // per_page if total > 0 else 1,
                "has_more": total > page * per_page,
            },
        }
