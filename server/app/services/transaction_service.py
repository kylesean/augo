"""Transaction service for managing financial transactions."""

from datetime import date, datetime, timezone
from decimal import Decimal
from typing import Optional
from uuid import UUID, uuid4

import structlog
from sqlalchemy import and_, case, desc, func, or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import BusinessError, NotFoundError
from app.models.base import utc_now
from app.models.financial_account import FinancialAccount
from app.models.transaction import (
    RecurringTransaction,
    Transaction,
    TransactionComment,
    TransactionShare,
)
from app.models.user import User, UserSettings
from app.schemas.transaction import TransactionDisplayValue
from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency

logger = structlog.get_logger(__name__)


class TransactionService:
    """交易服务：处理财务交易相关的业务逻辑"""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_financial_account(self, account_id: UUID, user_uuid: UUID) -> Optional[FinancialAccount]:
        """获取并验证财务账户"""
        query = select(FinancialAccount).where(
            and_(FinancialAccount.id == account_id, FinancialAccount.user_uuid == user_uuid)
        )
        result = await self.db.execute(query)
        return result.scalar_one_or_none()

    async def create_transaction(
        self,
        user_uuid: UUID,
        amount: float,
        transaction_type: str = "expense",
        transaction_at: Optional[datetime] = None,
        category_key: str = "OTHERS",
        currency: str = "CNY",
        raw_input: Optional[str] = None,
        source_account_id: Optional[UUID] = None,
        target_account_id: Optional[UUID] = None,
        subject: str = "SELF",
        intent: str = "SURVIVAL",
        tags: Optional[list[str]] = None,
    ) -> dict:
        """创建单笔交易记录

        遵循“先记录，后关联”的原则，默认不联动余额。
        """
        tx_type = transaction_type.lower()
        transfer_amount = Decimal(str(amount))
        tx_time = transaction_at or datetime.now(timezone.utc)

        # 验证逻辑已由工具层处理，Service 层主要负责持久化
        source_acc = None
        target_acc = None

        if source_account_id:
            source_acc = await self.get_financial_account(source_account_id, user_uuid)
            if not source_acc:
                return {
                    "success": False,
                    "message": f"Source account not found: {source_account_id}",
                }

        if target_account_id:
            target_acc = await self.get_financial_account(target_account_id, user_uuid)
            if not target_acc:
                return {
                    "success": False,
                    "message": f"Target account not found: {target_account_id}",
                }

        # 创建记录
        transaction = Transaction(
            id=uuid4(),
            user_uuid=user_uuid,
            type=tx_type.upper(),
            raw_input=raw_input or "",
            description=None,
            amount_original=transfer_amount,
            amount=transfer_amount,
            currency=currency,
            transaction_at=tx_time,
            transaction_timezone=str(tx_time.tzinfo or "UTC"),
            category_key=category_key.upper() if category_key else "OTHERS",
            subject=subject.upper() if subject else "SELF",
            intent=intent.upper() if intent else "SURVIVAL",
            tags=tags or [],
            source="AI",
            status="CLEARED",
            source_account_id=source_account_id,
            target_account_id=target_account_id,
        )

        self.db.add(transaction)

        # 转账场景：立即更新账户余额
        if tx_type == "transfer" and source_acc and target_acc:
            # 转出账户扣减
            source_acc.current_balance -= transfer_amount
            source_acc.updated_at = datetime.now(timezone.utc)
            # 转入账户增加
            target_acc.current_balance += transfer_amount
            target_acc.updated_at = datetime.now(timezone.utc)

        await self.db.commit()
        await self.db.refresh(transaction)

        # 拼装返回结果 (用于 GenUI 渲染)
        result = {
            "success": True,
            "transaction_id": str(transaction.id),
            "amount": float(amount),
            "currency": currency,
            "type": tx_type.upper(),
            "category_key": transaction.category_key,
            "subject": transaction.subject,
            "intent": transaction.intent,
            "tags": transaction.tags,
            "transaction_at": transaction.transaction_at.isoformat(),
            "status": "success",
            "raw_input": transaction.raw_input,
            "account_linked": source_acc is not None or target_acc is not None,
        }

        if tx_type != "transfer":
            linked_acc = source_acc or target_acc
            if linked_acc:
                result["linked_account"] = {
                    "id": str(linked_acc.id),
                    "name": linked_acc.name,
                    "type": linked_acc.type,
                }
        else:
            if source_acc and target_acc:
                result["transfer_info"] = {
                    "source_account": {
                        "id": str(source_acc.id),
                        "name": source_acc.name,
                        "type": source_acc.type,
                    },
                    "target_account": {
                        "id": str(target_acc.id),
                        "name": target_acc.name,
                        "type": target_acc.type,
                    },
                }

        return result

    async def get_transaction_feed(
        self,
        user_uuid: UUID,
        date_filter: Optional[str] = None,
        type_filter: str = "all",
        page: int = 1,
        limit: int = 10,
    ) -> dict:
        """获取交易流列表（包含自动汇率转换）"""
        from app.schemas.transaction import TransactionDisplayValue
        from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency

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
        query = query.order_by(desc(Transaction.transaction_at), desc(Transaction.id))

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
                    "transactionAt": tx.transaction_at.isoformat(),
                    "tags": tx.tags or [],
                    "createdAt": tx.created_at.isoformat(),
                    "updatedAt": tx.updated_at.isoformat(),
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

    async def get_transaction_detail(self, transaction_id: UUID, user_uuid: UUID) -> Optional[dict]:
        """获取交易详情（包含评论）

        Args:
            transaction_id: 交易ID
            user_uuid: 用户UUID

        Returns:
            交易详情字典（包含评论），如果不存在则返回None
        """
        from sqlalchemy.orm import selectinload

        from app.models.shared_space import SharedSpace, SpaceTransaction

        query = (
            select(Transaction)
            .options(selectinload(Transaction.comments))
            .where(and_(Transaction.id == transaction_id, Transaction.user_uuid == user_uuid))
        )
        result = await self.db.execute(query)
        transaction = result.scalar_one_or_none()

        if not transaction:
            return None

        # 获取汇率和用户偏好币种
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = await get_exchange_rate_from_base(display_currency)

        # 获取关联的共享空间
        spaces_query = (
            select(SharedSpace)
            .join(SpaceTransaction, SpaceTransaction.space_id == SharedSpace.id)
            .where(SpaceTransaction.transaction_id == transaction_id)
        )
        spaces_result = await self.db.execute(spaces_query)
        associated_spaces = spaces_result.scalars().all()
        spaces_data = [{"id": str(s.id), "name": s.name} for s in associated_spaces]

        # 获取评论用户信息
        comments_data = []
        for comment in transaction.comments:
            # 查询评论者信息
            user_query = select(User).where(User.uuid == comment.user_uuid)
            user_result = await self.db.execute(user_query)
            user = user_result.scalar_one_or_none()

            comments_data.append(
                {
                    "id": comment.id,
                    "transactionId": str(comment.transaction_id),
                    "userUuid": str(comment.user_uuid),
                    "userName": user.username if user else "Unknown",
                    "userAvatarUrl": user.avatar_url if user else None,
                    "parentCommentId": comment.parent_comment_id,
                    "commentText": comment.comment_text,
                    "mentionedUserIds": comment.mentioned_user_ids or [],
                    "createdAt": comment.created_at.isoformat() if comment.created_at else None,
                    "updatedAt": comment.updated_at.isoformat() if comment.updated_at else None,
                }
            )

        # 转换为字典并添加计算字段（换算金额）
        amount_val = float(transaction.amount)
        if display_currency != BASE_CURRENCY:
            amount_val = amount_val * float(exchange_rate) if exchange_rate else amount_val

        return {
            "id": str(transaction.id),
            "userUuid": str(transaction.user_uuid),
            "type": transaction.type,
            "amount": round(amount_val, 2),  # 使用换算后的金额
            "amountOriginal": str(transaction.amount_original) if transaction.amount_original else None,
            "currency": display_currency,  # 使用用户偏好币种
            "categoryKey": transaction.category_key,
            "rawInput": transaction.raw_input,
            "description": transaction.description,
            "transactionAt": transaction.transaction_at.isoformat() if transaction.transaction_at else None,
            "transactionTimezone": transaction.transaction_timezone,
            "sourceAccountId": transaction.source_account_id,
            "targetAccountId": transaction.target_account_id,
            "tags": transaction.tags or [],
            "location": transaction.location,
            "latitude": str(transaction.latitude) if transaction.latitude else None,
            "longitude": str(transaction.longitude) if transaction.longitude else None,
            "source": transaction.source,
            "status": transaction.status,
            "createdAt": transaction.created_at.isoformat() if transaction.created_at else None,
            "updatedAt": transaction.updated_at.isoformat() if transaction.updated_at else None,
            "comments": comments_data,
            "commentCount": len(comments_data),
            "spaces": spaces_data,
            "display": TransactionDisplayValue.from_params(
                amount=amount_val, tx_type=transaction.type, currency=display_currency
            ).model_dump(),
        }

    async def delete_transaction(
        self,
        transaction_id: UUID,
        user_uuid: UUID,
    ) -> bool:
        """删除交易记录

        Args:
            transaction_id: 交易ID (UUID对象)
            user_uuid: 用户UUID (UUID对象，用于验证所有权)

        Returns:
            是否删除成功

        Raises:
            NotFoundError: 交易不存在
            BusinessError: 无权限删除
        """
        # 查询交易记录
        query = select(Transaction).where(Transaction.id == transaction_id)
        result = await self.db.execute(query)
        transaction = result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("Transaction")

        # 验证所有权
        if transaction.user_uuid != user_uuid:
            raise BusinessError("无权限删除此交易", "PERMISSION_DENIED")

        # 删除交易记录（关联的 comments 和 shares 会通过 ORM cascade 自动删除）
        await self.db.delete(transaction)
        await self.db.commit()

        logger.info(
            "transaction_deleted",
            transaction_id=str(transaction_id),
            user_uuid=str(user_uuid),
        )

        return True

    async def create_batch_transactions(
        self,
        user_uuid: UUID,
        data: dict,
    ) -> dict:
        """批量创建交易

        基准币种方案：
        - amount_original: 原始输入金额
        - amount: 换算成 CNY 的基准金额
        - currency: 原始币种（如果未指定，使用用户的 primaryCurrency）
        - exchange_rate: 存储时的汇率快照
        """
        from uuid import UUID as PyUUID

        from app.models.base import utc_now
        from app.schemas.transaction import TransactionDisplayValue
        from app.services.exchange_rate_service import exchange_rate_service
        from app.utils.currency_utils import BASE_CURRENCY, get_user_display_currency

        transactions_data = data.get("transactions", [])
        source_account_id = data.get("source_account_id")
        created_transactions = []

        # 获取用户的默认货币（primaryCurrency）作为未指定货币时的默认值
        user_default_currency = await get_user_display_currency(self.db, user_uuid)
        logger.debug(
            "batch_create_using_default_currency", user_uuid=str(user_uuid), default_currency=user_default_currency
        )

        for item in transactions_data:
            amount_original = Decimal(str(item["amount"]))
            # 使用用户的 primaryCurrency 作为默认值，而不是硬编码 CNY
            currency = (item.get("currency") or user_default_currency).upper()

            # 换算成 CNY 基准金额
            if currency == BASE_CURRENCY:
                amount = abs(amount_original)
                exchange_rate = Decimal("1.0")
            else:
                # 使用 convert 获取汇率 (convert 1 unit to get rate)
                rate = await exchange_rate_service.convert(
                    amount=1.0,
                    from_currency=currency,
                    to_currency=BASE_CURRENCY,
                )
                if rate is not None:
                    exchange_rate = Decimal(str(rate))
                    amount = abs(amount_original) * exchange_rate
                else:
                    # 汇率获取失败，按 1:1 处理（保留原始金额）
                    exchange_rate = Decimal("1.0")
                    amount = abs(amount_original)
                    logger.warning(
                        "exchange_rate_not_found",
                        currency=currency,
                        amount=str(amount_original),
                    )

            tx = Transaction(
                id=uuid4(),
                user_uuid=user_uuid,
                type=item.get("transaction_type", "EXPENSE").upper(),
                amount=amount.quantize(Decimal("0.00000001")),  # CNY 基准
                amount_original=abs(amount_original),
                currency=currency,
                exchange_rate=exchange_rate.quantize(Decimal("0.00000001")),
                category_key=item.get("category_key", "OTHERS"),
                tags=item.get("tags", []),
                raw_input=item.get("raw_input"),
                source_account_id=PyUUID(source_account_id) if source_account_id else None,
                transaction_at=utc_now(),
                transaction_timezone="Asia/Shanghai",
                source="AI",
                status="CLEARED",
            )
            self.db.add(tx)
            created_transactions.append(tx)

        await self.db.commit()

        # 刷新所有记录以获取 ID
        for tx in created_transactions:
            await self.db.refresh(tx)

        return {
            "success": True,
            "count": len(created_transactions),
            "account_id": str(source_account_id) if source_account_id else None,
            "transactions": [
                {
                    "id": str(tx.id),
                    "amount": str(tx.amount),
                    "type": tx.type,
                    "tags": tx.tags,
                    "category_key": tx.category_key,
                    "originalAmount": str(tx.amount_original),
                    "originalCurrency": tx.currency,
                    "display": TransactionDisplayValue.from_params(
                        amount=float(tx.amount_original), tx_type=tx.type, currency=tx.currency
                    ).model_dump(),
                }
                for tx in created_transactions
            ],
        }

    async def update_batch_transactions_account(
        self,
        user_uuid: UUID,
        transaction_ids: list[str],
        account_id: Optional[str],
    ) -> dict:
        """批量更新交易关联账户"""
        results = []
        for tx_id in transaction_ids:
            try:
                res = await self.update_transaction_account(
                    transaction_id=UUID(tx_id), user_uuid=user_uuid, account_id=account_id
                )
                results.append(res)
            except Exception as e:
                logger.error("batch_update_tx_failed", tx_id=tx_id, error=str(e))

        return {"success": True, "count": len(results), "account_id": account_id}

    async def update_transaction_account(
        self,
        transaction_id: UUID,
        user_uuid: UUID,
        account_id: Optional[str],
    ) -> dict:
        """更新交易的关联账户

        支持跨币种账户关联：
        - 如果交易币种与账户币种不同，使用实时汇率换算
        - 账户余额按账户本地币种扣减/增加

        Args:
            transaction_id: 交易ID
            user_uuid: 用户UUID
            account_id: 新的账户ID，传 None 表示取消关联

        Returns:
            更新后的交易详情

        Raises:
            NotFoundError: 交易或账户不存在
            BusinessError: 无权限
        """
        from uuid import UUID as PyUUID

        from app.services.exchange_rate_service import ExchangeRateService

        # 查询交易
        query = select(Transaction).where(Transaction.id == transaction_id)
        result = await self.db.execute(query)
        transaction = result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("Transaction")

        # 验证所有权
        if transaction.user_uuid != user_uuid:
            raise BusinessError("无权限修改此交易", "PERMISSION_DENIED")

        # 获取交易类型
        is_expense = transaction.type == "EXPENSE"
        is_income = transaction.type == "INCOME"

        # 根据交易类型确定使用哪个账户字段
        # 支出 → source_account_id（付款账户）
        # 收入 → target_account_id（收款账户）
        if is_expense:
            old_account_id = transaction.source_account_id
        elif is_income:
            old_account_id = transaction.target_account_id
        else:
            # 转账类型暂不支持单一账户关联
            old_account_id = transaction.source_account_id

        new_account_id = PyUUID(account_id) if account_id else None

        # 如果账户没有变化，直接返回
        if old_account_id == new_account_id:
            return await self.get_transaction_detail(transaction_id, user_uuid)

        # 获取交易的原始金额和币种（用于跨币种换算）
        # 优先使用原始金额/币种，回退到 amount/currency
        tx_original_amount = transaction.amount_original or transaction.amount
        tx_currency = (transaction.currency or BASE_CURRENCY).upper()

        # 初始化汇率服务
        exchange_rate_service = ExchangeRateService()

        # 1. 回滚旧账户余额
        if old_account_id:
            old_account_query = select(FinancialAccount).where(
                and_(
                    FinancialAccount.id == old_account_id,
                    FinancialAccount.user_uuid == user_uuid,
                )
            )
            old_account_result = await self.db.execute(old_account_query)
            old_account = old_account_result.scalar_one_or_none()

            if old_account:
                old_account_currency = (old_account.currency_code or BASE_CURRENCY).upper()

                # 计算在旧账户币种下的金额
                if tx_currency == old_account_currency:
                    rollback_amount = abs(Decimal(str(tx_original_amount)))
                else:
                    # 需要汇率换算
                    converted = await exchange_rate_service.convert(
                        amount=float(abs(Decimal(str(tx_original_amount)))),
                        from_currency=tx_currency,
                        to_currency=old_account_currency,
                    )
                    if converted is None:
                        logger.warning(
                            "exchange_rate_conversion_failed_rollback",
                            tx_currency=tx_currency,
                            account_currency=old_account_currency,
                        )
                        # 回滚时汇率获取失败，使用原金额作为近似值
                        rollback_amount = abs(Decimal(str(tx_original_amount)))
                    else:
                        rollback_amount = Decimal(str(converted))

                # 回滚：支出时加回去，收入时减回去
                if is_expense:
                    old_account.current_balance += rollback_amount
                elif is_income:
                    old_account.current_balance -= rollback_amount
                old_account.updated_at = utc_now()

                logger.info(
                    "account_balance_rollback",
                    account_id=str(old_account_id),
                    tx_currency=tx_currency,
                    account_currency=old_account_currency,
                    rollback_amount=str(rollback_amount),
                )

        # 2. 更新新账户余额
        if new_account_id:
            new_account_query = select(FinancialAccount).where(
                and_(
                    FinancialAccount.id == new_account_id,
                    FinancialAccount.user_uuid == user_uuid,
                )
            )
            new_account_result = await self.db.execute(new_account_query)
            new_account = new_account_result.scalar_one_or_none()

            if not new_account:
                raise NotFoundError("Account")

            new_account_currency = (new_account.currency_code or BASE_CURRENCY).upper()

            # 计算在新账户币种下的金额
            if tx_currency == new_account_currency:
                deduct_amount = abs(Decimal(str(tx_original_amount)))
                used_exchange_rate = Decimal("1.0")
            else:
                # 需要汇率换算：从交易币种转换到账户币种
                converted = await exchange_rate_service.convert(
                    amount=float(abs(Decimal(str(tx_original_amount)))),
                    from_currency=tx_currency,
                    to_currency=new_account_currency,
                )
                if converted is None:
                    raise BusinessError(
                        f"无法获取 {tx_currency} 到 {new_account_currency} 的汇率，请稍后重试",
                        "EXCHANGE_RATE_UNAVAILABLE",
                    )
                deduct_amount = Decimal(str(converted))
                # 计算使用的汇率
                used_exchange_rate = (
                    deduct_amount / abs(Decimal(str(tx_original_amount))) if tx_original_amount else Decimal("1.0")
                )

            # 更新余额：支出时扣减，收入时增加
            if is_expense:
                new_account.current_balance -= deduct_amount
            elif is_income:
                new_account.current_balance += deduct_amount
            new_account.updated_at = utc_now()

            logger.info(
                "account_balance_updated",
                account_id=str(new_account_id),
                tx_currency=tx_currency,
                account_currency=new_account_currency,
                original_amount=str(tx_original_amount),
                deduct_amount=str(deduct_amount),
                exchange_rate=str(used_exchange_rate),
            )

        # 3. 更新交易的账户关联（根据类型设置正确的字段）
        if is_expense:
            transaction.source_account_id = new_account_id
        elif is_income:
            transaction.target_account_id = new_account_id
        else:
            # 转账默认设置 source
            transaction.source_account_id = new_account_id
        transaction.updated_at = utc_now()

        await self.db.commit()

        logger.info(
            "transaction_account_updated",
            transaction_id=str(transaction_id),
            old_account_id=str(old_account_id) if old_account_id else None,
            new_account_id=str(new_account_id) if new_account_id else None,
        )

        return await self.get_transaction_detail(transaction_id, user_uuid)

    async def search_transactions(self, user_uuid: str, filters: dict) -> dict:
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
                    Transaction.description.ilike(f"%{keyword}%"),
                    Transaction.location.ilike(f"%{keyword}%"),
                )
            )

        # 金额范围
        if min_amount := filters.get("min_amount"):
            query = query.where(Transaction.amount >= str(min_amount))
        if max_amount := filters.get("max_amount"):
            query = query.where(Transaction.amount <= str(max_amount))

        # 分类筛选
        if categories := filters.get("categories"):
            query = query.where(Transaction.category_key.in_(categories))

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
        if type := filters.get("type"):
            if type:
                query = query.where(Transaction.amount > "0")
            else:
                query = query.where(Transaction.amount < "0")

        # 排序
        query = query.order_by(desc(Transaction.transaction_at))

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
                    "transaction_at": tx.transaction_at.isoformat(),
                    "payment_method": tx.payment_method,
                    "tags": tx.tags or [],
                    "created_at": tx.created_at.isoformat(),
                    "updated_at": tx.updated_at.isoformat(),
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

    async def create_recurring_transaction(self, user_uuid: str, data: dict) -> dict:
        """创建周期性交易规则

        Args:
            user_uuid: 用户ID
            data: 周期性交易数据

        Returns:
            创建的周期性交易字典
        """
        from uuid import UUID as PyUUID

        # Explicitly validate RRULE to ensure data integrity
        if "recurrence_rule" in data:
            try:
                RecurringTransaction.validate_recurrence_rule(data["recurrence_rule"])
            except ValueError as e:
                # Re-raise as ValueError so it's handled by exception handler or business error
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
            user_uuid=PyUUID(user_uuid),
            type=data["type"],
            source_account_id=PyUUID(data["source_account_id"]) if data.get("source_account_id") else None,
            target_account_id=PyUUID(data["target_account_id"]) if data.get("target_account_id") else None,
            amount_type=data.get("amount_type", "FIXED"),
            requires_confirmation=data.get("requires_confirmation", False),
            amount=str(data["amount"]),
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
        end_date: Optional[date] = None,
        exception_dates: Optional[list] = None,
    ) -> Optional[datetime]:
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
            timezone,
        )

        from dateutil.rrule import rrulestr

        try:
            # 使用 UTC 时区，与 RRULE 中的 UNTIL 保持一致
            dtstart = dt.combine(start_date, dt.min.time(), tzinfo=timezone.utc)
            rrule = rrulestr(rrule_str, dtstart=dtstart)

            now = dt.now(timezone.utc)
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
            "start_date": recurring_tx.start_date.isoformat(),
            "end_date": recurring_tx.end_date.isoformat() if recurring_tx.end_date else None,
            "exception_dates": recurring_tx.exception_dates or [],
            "last_generated_at": recurring_tx.last_generated_at.isoformat()
            if recurring_tx.last_generated_at
            else None,
            "next_execution_at": recurring_tx.next_execution_at.isoformat()
            if recurring_tx.next_execution_at
            else None,
            "description": recurring_tx.description,
            "is_active": recurring_tx.is_active,
            "created_at": recurring_tx.created_at.isoformat(),
            "updated_at": recurring_tx.updated_at.isoformat(),
        }

    async def list_recurring_transactions(
        self, user_uuid: str, type_filter: Optional[str] = None, is_active: Optional[bool] = None
    ) -> list[dict]:
        """获取周期性交易列表

        Args:
            user_uuid: 用户ID (UUID字符串)
            type_filter: 类型过滤 (EXPENSE, INCOME, TRANSFER)
            is_active: 激活状态过滤

        Returns:
            周期性交易列表
        """
        from uuid import UUID as PyUUID

        # 构建查询
        query = select(RecurringTransaction).where(RecurringTransaction.user_uuid == PyUUID(user_uuid))

        # 类型过滤
        if type_filter:
            query = query.where(RecurringTransaction.type == type_filter.upper())

        # 激活状态过滤
        if is_active is not None:
            query = query.where(RecurringTransaction.is_active == is_active)

        # 按创建时间降序排列
        query = query.order_by(desc(RecurringTransaction.created_at))

        result = await self.db.execute(query)
        recurring_txs = result.scalars().all()

        return [self._recurring_tx_to_dict(tx) for tx in recurring_txs]

    async def get_recurring_transaction(self, recurring_id: str, user_uuid: str) -> Optional[dict]:
        """获取周期性交易详情

        Args:
            recurring_id: 周期性交易ID (UUID字符串)
            user_uuid: 用户ID (UUID字符串)

        Returns:
            周期性交易字典，如果不存在则返回None
        """
        from uuid import UUID as PyUUID

        try:
            rid = PyUUID(recurring_id)
        except ValueError:
            return None

        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.id == rid,
                RecurringTransaction.user_uuid == PyUUID(user_uuid),
            )
        )
        result = await self.db.execute(query)
        recurring_tx = result.scalar_one_or_none()

        if not recurring_tx:
            return None

        return self._recurring_tx_to_dict(recurring_tx)

    async def update_recurring_transaction(self, recurring_id: str, user_uuid: str, data: dict) -> Optional[dict]:
        """更新周期性交易

        Args:
            recurring_id: 周期性交易ID (UUID字符串)
            user_uuid: 用户ID (UUID字符串)
            data: 更新数据

        Returns:
            更新后的周期性交易字典，如果不存在则返回None
        """
        from uuid import UUID as PyUUID

        try:
            rid = PyUUID(recurring_id)
        except ValueError:
            return None

        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.id == rid,
                RecurringTransaction.user_uuid == PyUUID(user_uuid),
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
            recurring_tx.source_account_id = PyUUID(data["source_account_id"]) if data["source_account_id"] else None
        if "target_account_id" in data:
            recurring_tx.target_account_id = PyUUID(data["target_account_id"]) if data["target_account_id"] else None
        if "amount_type" in data:
            recurring_tx.amount_type = data["amount_type"]
        if "requires_confirmation" in data:
            recurring_tx.requires_confirmation = data["requires_confirmation"]
        if "amount" in data:
            recurring_tx.amount = str(data["amount"])
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

    async def delete_recurring_transaction(self, recurring_id: str, user_uuid: str) -> bool:
        """删除周期性交易

        Args:
            recurring_id: 周期性交易ID (UUID字符串)
            user_uuid: 用户ID (UUID字符串)

        Returns:
            是否删除成功
        """
        from uuid import UUID as PyUUID

        try:
            rid = PyUUID(recurring_id)
        except ValueError:
            return False

        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.id == rid,
                RecurringTransaction.user_uuid == PyUUID(user_uuid),
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
        end_date: Optional[date],
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
            timezone,
        )

        from dateutil.rrule import rrulestr

        try:
            # 使用 UTC 时区，与 RRULE 中的 UNTIL 保持一致
            dtstart = dt.combine(start_date, dt.min.time(), tzinfo=timezone.utc)
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

    async def forecast_cash_flow(
        self,
        user_uuid: UUID,
        forecast_days: int = 60,
        granularity: str = "daily",
        scenarios: Optional[list[dict]] = None,
    ) -> dict:
        """预测未来现金流"""
        from datetime import timedelta
        from decimal import Decimal

        from app.models.financial_settings import FinancialSettings

        # 1. 获取基础数据
        # 获取用户设置 (改为读取 FinancialSettings)
        settings_query = select(FinancialSettings).where(FinancialSettings.user_uuid == user_uuid)
        settings_result = await self.db.execute(settings_query)
        settings = settings_result.scalar_one_or_none()
        safety_threshold = settings.safety_threshold if settings else Decimal("0.00")

        # 计算当前总余额（从 financial_accounts 表获取）
        # 资产类账户（ASSET）计入正值，负债类账户（LIABILITY）计入负值
        accounts_query = select(
            func.coalesce(
                func.sum(
                    case(
                        (FinancialAccount.nature == "ASSET", FinancialAccount.initial_balance),
                        (FinancialAccount.nature == "LIABILITY", -FinancialAccount.initial_balance),
                        else_=0,
                    )
                ),
                0,
            )
        ).where(and_(FinancialAccount.user_uuid == user_uuid, FinancialAccount.include_in_net_worth.is_(True)))
        balance_result = await self.db.execute(accounts_query)
        current_balance = balance_result.scalar() or Decimal("0.00")
        current_balance_str = str(current_balance)

        # 计算平均日消费（过去30天的支出记录）
        thirty_days_ago = datetime.now() - timedelta(days=30)
        # 先获取每日支出总和
        daily_expense_query = (
            select(
                func.date(Transaction.transaction_at).label("tx_date"),
                func.sum(Transaction.amount).label("daily_total"),
            )
            .where(
                and_(
                    Transaction.user_uuid == user_uuid,
                    Transaction.amount < 0,  # 支出为负数
                    Transaction.transaction_at >= thirty_days_ago,
                )
            )
            .group_by(func.date(Transaction.transaction_at))
        )

        daily_expense_result = await self.db.execute(daily_expense_query)
        daily_expenses = daily_expense_result.all()

        if daily_expenses:
            total_spending = sum(row.daily_total for row in daily_expenses)
            days_with_spending = len(daily_expenses)
            avg_daily_spending = total_spending / max(days_with_spending, 1)
        else:
            avg_daily_spending = Decimal("-100.00")  # 默认值

        avg_daily_spending_str = str(avg_daily_spending)

        # 确保是负数（支出应为负）
        if Decimal(avg_daily_spending_str) > 0:
            avg_daily_spending_str = str(-abs(Decimal(avg_daily_spending_str)))

        # 2. 聚合所有未来事件
        events_by_date = {}
        start_date = datetime.now().date()
        forecast_end_date = start_date + timedelta(days=forecast_days)

        # a. 处理周期性事件
        recurring_query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.user_uuid == user_uuid,
                RecurringTransaction.is_active.is_(True),
            )
        )
        recurring_result = await self.db.execute(recurring_query)
        recurring_txs = recurring_result.scalars().all()

        for tx in recurring_txs:
            try:
                # 获取exception_dates列表
                exception_dates_list = tx.exception_dates or []
                exception_dates_set = set(exception_dates_list)

                occurrences = self.parse_rrule_occurrences(
                    tx.recurrence_rule,
                    tx.start_date,
                    tx.end_date,
                    start_date,
                    forecast_end_date,
                )
                for occ_date in occurrences:
                    date_str = occ_date.isoformat()
                    # 跳过排除日期
                    if date_str in exception_dates_set:
                        continue
                    if date_str not in events_by_date:
                        events_by_date[date_str] = []
                    events_by_date[date_str].append(
                        {
                            "description": tx.description or "周期性交易",
                            "amount": str(tx.amount),  # amount 现在是 Decimal 类型
                        }
                    )
            except Exception as e:
                logger.error(f"Error processing recurring transaction {tx.id}: {e}")
                continue

        # b. 处理模拟场景事件
        if scenarios:
            for scenario in scenarios:
                date_str = scenario["date"]
                if date_str not in events_by_date:
                    events_by_date[date_str] = []
                events_by_date[date_str].append(
                    {
                        "description": scenario["description"],
                        "amount": str(scenario["amount"]),
                    }
                )

        # 3. 循环计算每日余额
        raw_daily_breakdown = []
        balance = Decimal(current_balance_str)

        for i in range(forecast_days):
            current_date = start_date + timedelta(days=i)
            date_str = current_date.isoformat()

            daily_events = events_by_date.get(date_str, []).copy()
            daily_events.append(
                {
                    "description": "日常消费(预测)",
                    "amount": avg_daily_spending_str,
                }
            )

            daily_net = Decimal("0.00")
            for event in daily_events:
                daily_net += Decimal(event["amount"])

            balance += daily_net

            raw_daily_breakdown.append(
                {
                    "date": date_str,
                    "closingBalance": str(balance),
                    "events": daily_events,
                }
            )

        # 4. 根据granularity参数对结果进行聚合
        aggregated_breakdown = self._aggregate_breakdown(raw_daily_breakdown, granularity)

        # 5. 计算预警和汇总信息
        warnings = self._calculate_warnings(raw_daily_breakdown, safety_threshold)
        summary = self._calculate_summary(current_balance_str, raw_daily_breakdown)

        return {
            "dailyBreakdown": aggregated_breakdown,
            "warnings": warnings,
            "summary": summary,
        }

    def _aggregate_breakdown(self, daily_breakdown: list[dict], granularity: str) -> list[dict]:
        """根据粒度聚合数据

        Args:
            daily_breakdown: 每日明细列表
            granularity: 粒度 ('daily', 'weekly', 'monthly')

        Returns:
            聚合后的明细列表
        """
        if granularity == "daily" or not daily_breakdown:
            return daily_breakdown

        from collections import defaultdict
        from datetime import datetime

        grouped_data = defaultdict(list)

        for day in daily_breakdown:
            date_obj = datetime.fromisoformat(day["date"])

            if granularity == "weekly":
                # 使用ISO周数作为分组键
                group_key = date_obj.strftime("%Y-W%W")
            elif granularity == "monthly":
                # 使用年-月作为分组键
                group_key = date_obj.strftime("%Y-%m")
            else:
                group_key = day["date"]

            grouped_data[group_key].append(day)

        # 格式化聚合结果
        aggregated = []
        for _group_key, days_in_group in grouped_data.items():
            last_day_data = days_in_group[-1]

            # 收集所有关键事件（排除日常消费预测）
            all_events = []
            for day in days_in_group:
                for event in day["events"]:
                    if event["description"] != "日常消费(预测)":
                        all_events.append(event)

            aggregated.append(
                {
                    "date": last_day_data["date"],
                    "closingBalance": last_day_data["closingBalance"],
                    "events": all_events,
                }
            )

        return aggregated

    def _calculate_warnings(self, raw_daily_breakdown: list[dict], safety_threshold: str) -> list[dict]:
        """计算预警信息

        Args:
            raw_daily_breakdown: 原始每日明细
            safety_threshold: 安全阈值

        Returns:
            预警列表
        """
        from datetime import datetime
        from decimal import Decimal

        warnings = {}
        threshold = Decimal(safety_threshold)

        for day in raw_daily_breakdown:
            balance = Decimal(day["closingBalance"])
            if balance < threshold:
                date_obj = datetime.fromisoformat(day["date"])
                date_str = day["date"]
                warnings[date_str] = {
                    "date": date_str,
                    "message": f"在 {date_obj.month}月{date_obj.day}日后, 您的余额将低于安心线。",
                }

        return list(warnings.values())

    def _calculate_summary(self, start_balance: str, raw_daily_breakdown: list[dict]) -> dict:
        """计算汇总信息

        Args:
            start_balance: 起始余额
            raw_daily_breakdown: 原始每日明细

        Returns:
            汇总字典
        """
        from decimal import Decimal

        if not raw_daily_breakdown:
            return {
                "startBalance": start_balance,
                "endBalance": start_balance,
                "totalIncome": "0.00",
                "totalExpense": "0.00",
            }

        total_income = Decimal("0.00")
        total_expense = Decimal("0.00")

        for day in raw_daily_breakdown:
            for event in day["events"]:
                amount = Decimal(event["amount"])
                if amount > 0:
                    total_income += amount
                else:
                    total_expense += amount

        return {
            "startBalance": start_balance,
            "endBalance": raw_daily_breakdown[-1]["closingBalance"],
            "totalIncome": str(total_income),
            "totalExpense": str(total_expense),
        }

    async def get_comments_for_transaction(self, transaction_id: int, user_uuid: int) -> list[dict]:
        """获取交易的评论列表

        Args:
            transaction_id: 交易ID
            user_uuid: 当前用户ID

        Returns:
            评论列表
        """
        # 首先验证交易是否存在且属于用户
        tx_query = select(Transaction).where(
            and_(Transaction.id == transaction_id, Transaction.user_uuid == user_uuid)
        )
        tx_result = await self.db.execute(tx_query)
        transaction = tx_result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("Transaction")

        # 查询评论及相关用户信息
        query = (
            select(
                TransactionComment,
                User.username.label("user_name"),
                User.avatar_url.label("user_avatar_url"),
            )
            .join(User, TransactionComment.user_uuid == User.uuid)
            .where(TransactionComment.transaction_id == transaction_id)
            .order_by(TransactionComment.created_at.asc())
        )

        result = await self.db.execute(query)
        comments_data = result.all()

        if not comments_data:
            return []

        # 格式化评论数据
        formatted_comments = []
        for comment, user_name, user_avatar_url in comments_data:
            # 如果有父评论，获取被回复用户的信息
            replied_to_user_uuid = None
            replied_to_user_name = None

            if comment.parent_comment_id:
                parent_query = (
                    select(TransactionComment, User.username)
                    .join(User, TransactionComment.user_uuid == User.uuid)
                    .where(TransactionComment.id == comment.parent_comment_id)
                )
                parent_result = await self.db.execute(parent_query)
                parent_data = parent_result.first()

                if parent_data:
                    parent_comment, parent_user_name = parent_data
                    replied_to_user_uuid = str(parent_comment.user_uuid)
                    replied_to_user_name = parent_user_name

            formatted_comments.append(
                {
                    "id": str(comment.id),
                    "transactionId": str(comment.transaction_id),
                    "userId": str(comment.user_uuid),
                    "userName": user_name or "默认昵称",
                    "userAvatarUrl": user_avatar_url or "assets/images/avatars/default_avatar.png",
                    "parentCommentId": str(comment.parent_comment_id) if comment.parent_comment_id else None,
                    "commentText": comment.comment_text,
                    "repliedToUserId": replied_to_user_uuid,
                    "repliedToUserName": replied_to_user_name,
                    "createdAt": comment.created_at.isoformat(),
                    "updatedAt": comment.updated_at.isoformat() if comment.updated_at else None,
                }
            )

        return formatted_comments

    async def add_comment(
        self,
        transaction_id: int,
        user_uuid: int,
        comment_text: str,
        parent_comment_id: Optional[int] = None,
    ) -> dict:
        """添加交易评论

        Args:
            transaction_id: 交易ID
            user_uuid: 用户ID
            comment_text: 评论内容
            parent_comment_id: 父评论ID（可选）

        Returns:
            新创建的评论字典
        """
        # 验证评论内容
        if not comment_text or not comment_text.strip():
            logger.warning(
                "empty_comment_rejected",
                user_uuid=user_uuid,
                transaction_id=transaction_id,
            )
            raise BusinessError("评论内容不能为空", "TRANSACTION_COMMENT_NULL")

        # 验证交易是否存在
        tx_query = select(Transaction).where(Transaction.id == transaction_id)
        tx_result = await self.db.execute(tx_query)
        transaction = tx_result.scalar_one_or_none()

        if not transaction:
            logger.warning(
                "transaction_not_found_for_comment",
                user_uuid=user_uuid,
                transaction_id=transaction_id,
            )
            raise NotFoundError("Transaction")

        # 如果有父评论，验证父评论是否有效
        if parent_comment_id is not None:
            parent_query = select(TransactionComment).where(
                and_(
                    TransactionComment.id == parent_comment_id,
                    TransactionComment.transaction_id == transaction_id,
                )
            )
            parent_result = await self.db.execute(parent_query)
            parent_comment = parent_result.scalar_one_or_none()

            if not parent_comment:
                raise BusinessError("父评论不存在", "INVALID_PARENT_COMMENT_ID")

            # 确保父评论本身不是子评论（单层回复结构）
            if parent_comment.parent_comment_id is not None:
                raise BusinessError("不能回复子评论", "INVALID_PARENT_COMMENT_ID")

        # 创建新评论
        new_comment = TransactionComment(
            transaction_id=transaction_id,
            user_uuid=user_uuid,
            comment_text=comment_text,
            parent_comment_id=parent_comment_id,
        )

        self.db.add(new_comment)
        await self.db.commit()
        await self.db.refresh(new_comment)

        logger.info(
            "comment_created",
            user_uuid=user_uuid,
            transaction_id=transaction_id,
            comment_id=new_comment.id,
            is_reply=bool(parent_comment_id),
        )

        # 获取完整的评论信息（包含用户信息）
        query = (
            select(
                TransactionComment,
                User.username.label("user_name"),
                User.avatar_url.label("user_avatar_url"),
            )
            .join(User, TransactionComment.user_uuid == User.uuid)
            .where(TransactionComment.id == new_comment.id)
        )

        result = await self.db.execute(query)
        comment_data = result.first()

        if not comment_data:
            raise BusinessError("获取新评论数据失败", "STORE_COMMENT_FAILED")

        comment, user_name, user_avatar_url = comment_data

        # 如果有父评论，获取被回复用户的信息
        replied_to_user_uuid = None
        replied_to_user_name = None

        if parent_comment_id:
            parent_query = (
                select(TransactionComment, User.username)
                .join(User, TransactionComment.user_uuid == User.uuid)
                .where(TransactionComment.id == parent_comment_id)
            )
            parent_result = await self.db.execute(parent_query)
            parent_data = parent_result.first()

            if parent_data:
                parent_comment, parent_user_name = parent_data
                replied_to_user_uuid = str(parent_comment.user_uuid)
                replied_to_user_name = parent_user_name

        return {
            "id": str(comment.id),
            "transactionId": str(comment.transaction_id),
            "userId": str(comment.user_uuid),
            "userName": user_name or "匿名用户",
            "userAvatarUrl": user_avatar_url or "assets/images/avatars/default_avatar.png",
            "parentCommentId": str(comment.parent_comment_id) if comment.parent_comment_id else None,
            "commentText": comment.comment_text,
            "repliedToUserId": replied_to_user_uuid,
            "repliedToUserName": replied_to_user_name,
            "createdAt": comment.created_at.isoformat(),
            "updatedAt": comment.updated_at.isoformat() if comment.updated_at else None,
        }

    async def delete_comment(self, comment_id: int, user_uuid: int) -> bool:
        """删除评论

        Args:
            comment_id: 评论ID
            user_uuid: 用户ID

        Returns:
            是否删除成功
        """
        # 查询评论
        query = select(TransactionComment).where(TransactionComment.id == comment_id)
        result = await self.db.execute(query)
        comment = result.scalar_one_or_none()

        if not comment:
            return False

        # 验证权限
        if comment.user_uuid != user_uuid:
            raise BusinessError("你没有权限删除该评论", "PERMISSION_DENIED")

        # 删除评论（如果有外键级联删除，子评论会自动删除）
        await self.db.delete(comment)
        await self.db.commit()

        return True
