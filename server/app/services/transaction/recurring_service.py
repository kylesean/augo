"""Recurring transaction service for scheduled transactions."""

from datetime import UTC, date, datetime
from decimal import Decimal
from typing import Any, cast
from uuid import UUID

import structlog
from sqlalchemy import and_, desc, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import BusinessError
from app.models.base import utc_now
from app.models.transaction import RecurringTransaction

logger = structlog.get_logger(__name__)


class RecurringTransactionService:
    """Service for recurring transaction operations."""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def create_recurring_transaction(self, user_uuid: UUID, data: dict) -> dict:
        """创建周期性交易规则

        Args:
            user_uuid: 用户ID
            data: 周期性交易数据

        Returns:
            创建的周期性交易字典
        """
        # Explicitly validate RRULE to ensure data integrity
        if "recurrence_rule" in data:
            try:
                RecurringTransaction.validate_recurrence_rule(data["recurrence_rule"])
            except ValueError as e:
                raise BusinessError(f"Invalid recurrence rule: {e}", error_code="INVALID_RECURRENCE_RULE")

        start_date = datetime.strptime(data["start_date"], "%Y-%m-%d").date()
        end_date = datetime.strptime(data["end_date"], "%Y-%m-%d").date() if data.get("end_date") else None
        exception_dates = data.get("exception_dates", [])

        # 计算下次执行日期
        next_execution = self._calculate_next_execution(
            data["recurrence_rule"],
            start_date,
            end_date,
            exception_dates,
        )

        recurring_tx = RecurringTransaction(
            user_uuid=user_uuid,
            type=data["type"],
            source_account_id=UUID(str(data["source_account_id"])) if data.get("source_account_id") else None,
            target_account_id=UUID(str(data["target_account_id"])) if data.get("target_account_id") else None,
            amount_type=data.get("amount_type", "FIXED"),
            requires_confirmation=data.get("requires_confirmation", False),
            amount=Decimal(str(data["amount"])),
            currency=data.get("currency", "CNY"),
            category_key=data.get("category_key", "OTHERS"),
            tags=data.get("tags"),
            recurrence_rule=data["recurrence_rule"],
            timezone=data.get("timezone", "Asia/Shanghai"),
            start_date=start_date,
            end_date=end_date,
            exception_dates=exception_dates,
            description=data.get("description"),
            is_active=data.get("is_active", True),
            next_execution_at=next_execution,
        )

        self.db.add(recurring_tx)
        await self.db.commit()
        await self.db.refresh(recurring_tx)

        return self._recurring_tx_to_dict(recurring_tx)

    def _calculate_next_execution(
        self,
        rrule_str: str,
        start_date: date,
        end_date: date | None = None,
        exception_dates: list | None = None,
    ) -> datetime | None:
        """计算下次执行日期

        Args:
            rrule_str: RRULE 字符串（UNTIL 必须带 UTC 时区标记 Z）
            start_date: 规则开始日期
            end_date: 规则结束日期
            exception_dates: 排除日期列表

        Returns:
            下次执行的 datetime (UTC)，如果无法计算则返回 None
        """
        from datetime import (
            datetime as dt,
        )

        from dateutil.rrule import rrulestr

        try:
            # 使用 UTC 时区，与 RRULE 中的 UNTIL 保持一致
            dtstart = dt.combine(start_date, dt.min.time(), tzinfo=UTC)
            rrule = rrulestr(rrule_str, dtstart=dtstart)

            now = dt.now(UTC)
            exception_set = set(exception_dates or [])

            for occurrence in rrule:
                # 跳过过去的日期
                if occurrence <= now:
                    continue
                # 跳过排除日期
                if occurrence.date().isoformat() in exception_set:
                    continue
                # 检查是否超过结束日期
                if end_date and occurrence.date() > end_date:
                    return None
                return occurrence
            return None
        except Exception as e:
            logger.warning(f"Failed to calculate next execution: {e}")
            return None

    def _recurring_tx_to_dict(self, recurring_tx: RecurringTransaction) -> dict:
        """Convert RecurringTransaction model to dict response."""
        return {
            "id": str(recurring_tx.id),
            "user_uuid": str(recurring_tx.user_uuid),
            "type": recurring_tx.type,
            "source_account_id": str(recurring_tx.source_account_id) if recurring_tx.source_account_id else None,
            "target_account_id": str(recurring_tx.target_account_id) if recurring_tx.target_account_id else None,
            "amount_type": recurring_tx.amount_type,
            "requires_confirmation": recurring_tx.requires_confirmation,
            "amount": str(recurring_tx.amount),
            "currency": recurring_tx.currency,
            "category_key": recurring_tx.category_key,
            "tags": recurring_tx.tags,
            "recurrence_rule": recurring_tx.recurrence_rule,
            "timezone": recurring_tx.timezone,
            "start_date": cast(datetime, recurring_tx.start_date).isoformat(),
            "end_date": cast(datetime, recurring_tx.end_date).isoformat() if recurring_tx.end_date else None,
            "exception_dates": recurring_tx.exception_dates or [],
            "last_generated_at": cast(datetime, recurring_tx.last_generated_at).isoformat()
            if recurring_tx.last_generated_at
            else None,
            "next_execution_at": cast(datetime, recurring_tx.next_execution_at).isoformat()
            if recurring_tx.next_execution_at
            else None,
            "description": recurring_tx.description,
            "is_active": recurring_tx.is_active,
            "created_at": cast(datetime, recurring_tx.created_at).isoformat(),
            "updated_at": cast(datetime, recurring_tx.updated_at).isoformat(),
        }

    async def list_recurring_transactions(
        self, user_uuid: UUID, type_filter: str | None = None, is_active: bool | None = None
    ) -> list[dict]:
        """获取周期性交易列表

        Args:
            user_uuid: 用户ID (UUID字符串)
            type_filter: 类型过滤 (EXPENSE, INCOME, TRANSFER)
            is_active: 激活状态过滤

        Returns:
            周期性交易列表
        """
        # 构建查询
        query = select(RecurringTransaction).where(RecurringTransaction.user_uuid == user_uuid)

        # 类型过滤
        if type_filter:
            query = query.where(RecurringTransaction.type == type_filter.upper())

        # 激活状态过滤
        if is_active is not None:
            query = query.where(RecurringTransaction.is_active == is_active)

        # 按创建时间降序排列
        query = query.order_by(RecurringTransaction.created_at.desc())

        result = await self.db.execute(query)
        recurring_txs = result.scalars().all()

        return [self._recurring_tx_to_dict(tx) for tx in recurring_txs]

    async def get_recurring_transaction(self, recurring_id: UUID, user_uuid: UUID) -> dict | None:
        """获取周期性交易详情

        Args:
            recurring_id: 周期性交易ID (UUID字符串)
            user_uuid: 用户ID (UUID字符串)

        Returns:
            周期性交易字典，如果不存在则返回None
        """
        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.id == recurring_id,
                RecurringTransaction.user_uuid == user_uuid,
            )
        )
        result = await self.db.execute(query)
        recurring_tx = result.scalar_one_or_none()

        if not recurring_tx:
            return None

        return self._recurring_tx_to_dict(recurring_tx)

    async def update_recurring_transaction(self, recurring_id: UUID, user_uuid: UUID, data: dict) -> dict | None:
        """更新周期性交易

        Args:
            recurring_id: 周期性交易ID (UUID字符串)
            user_uuid: 用户ID (UUID字符串)
            data: 更新数据

        Returns:
            更新后的周期性交易字典，如果不存在则返回None
        """
        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.id == recurring_id,
                RecurringTransaction.user_uuid == user_uuid,
            )
        )
        result = await self.db.execute(query)
        recurring_tx = result.scalar_one_or_none()

        if not recurring_tx:
            return None

        # 更新字段
        if "type" in data:
            recurring_tx.type = data["type"]
        if "source_account_id" in data:
            recurring_tx.source_account_id = UUID(str(data["source_account_id"])) if data["source_account_id"] else None
        if "target_account_id" in data:
            recurring_tx.target_account_id = UUID(str(data["target_account_id"])) if data["target_account_id"] else None
        if "amount_type" in data:
            recurring_tx.amount_type = data["amount_type"]
        if "requires_confirmation" in data:
            recurring_tx.requires_confirmation = data["requires_confirmation"]
        if "amount" in data:
            recurring_tx.amount = Decimal(str(data["amount"]))
        if "currency" in data:
            recurring_tx.currency = data["currency"]
        if "category_key" in data:
            recurring_tx.category_key = data["category_key"]
        if "tags" in data:
            recurring_tx.tags = data["tags"]
        if "recurrence_rule" in data:
            recurring_tx.recurrence_rule = data["recurrence_rule"]
        if "timezone" in data:
            recurring_tx.timezone = data["timezone"]
        if "start_date" in data:
            recurring_tx.start_date = datetime.strptime(data["start_date"], "%Y-%m-%d").date()
        if "end_date" in data:
            recurring_tx.end_date = (
                datetime.strptime(data["end_date"], "%Y-%m-%d").date() if data["end_date"] else None
            )
        if "exception_dates" in data:
            recurring_tx.exception_dates = data["exception_dates"]
        if "description" in data:
            recurring_tx.description = data["description"]
        if "is_active" in data:
            recurring_tx.is_active = data["is_active"]

        # 如果规则、日期或激活状态变更，重新计算下次执行日期
        should_recalculate = any(
            key in data for key in ["recurrence_rule", "start_date", "end_date", "exception_dates", "is_active"]
        )

        if should_recalculate and recurring_tx.is_active:
            recurring_tx.next_execution_at = self._calculate_next_execution(
                recurring_tx.recurrence_rule,
                recurring_tx.start_date,
                recurring_tx.end_date,
                recurring_tx.exception_dates,
            )
        elif not recurring_tx.is_active:
            # 禁用时清空下次执行日期
            recurring_tx.next_execution_at = None

        recurring_tx.updated_at = utc_now()

        await self.db.commit()
        await self.db.refresh(recurring_tx)

        return self._recurring_tx_to_dict(recurring_tx)

    async def delete_recurring_transaction(self, recurring_id: UUID, user_uuid: UUID) -> bool:
        """删除周期性交易

        Args:
            recurring_id: 周期性交易ID (UUID字符串)
            user_uuid: 用户ID (UUID字符串)

        Returns:
            是否删除成功
        """
        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.id == recurring_id,
                RecurringTransaction.user_uuid == user_uuid,
            )
        )
        result = await self.db.execute(query)
        recurring_tx = result.scalar_one_or_none()

        if not recurring_tx:
            return False

        await self.db.delete(recurring_tx)
        await self.db.commit()

        return True

    def parse_rrule_occurrences(
        self,
        rrule_string: str,
        start_date: date,
        end_date: date | None,
        forecast_start: date,
        forecast_end: date,
    ) -> list[date]:
        """解析RRULE并生成指定范围内的日期

        Args:
            rrule_string: RRULE字符串（UNTIL 必须带 UTC 时区标记 Z）
            start_date: 规则开始日期
            end_date: 规则结束日期
            forecast_start: 预测开始日期
            forecast_end: 预测结束日期

        Returns:
            日期列表
        """
        from datetime import (
            datetime as dt,
        )

        from dateutil.rrule import rrulestr

        try:
            # 使用 UTC 时区，与 RRULE 中的 UNTIL 保持一致
            dtstart = dt.combine(start_date, dt.min.time(), tzinfo=UTC)
            rrule = rrulestr(rrule_string, dtstart=dtstart)

            # 确定实际的结束日期
            actual_end = forecast_end
            if end_date and end_date < forecast_end:
                actual_end = end_date

            # 生成日期范围内的所有出现日期
            occurrences = []
            for occurrence in rrule:
                occ_date = occurrence.date()
                if occ_date < forecast_start:
                    continue
                if occ_date > actual_end:
                    break
                occurrences.append(occ_date)

            return occurrences
        except Exception as e:
            logger.error(f"Error parsing RRULE: {rrule_string}, error: {e}")
            return []
