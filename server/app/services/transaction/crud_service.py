"""Transaction CRUD service for basic transaction operations."""

from datetime import UTC, datetime
from decimal import Decimal
from typing import Any, cast
from uuid import UUID, uuid4

import structlog
from sqlalchemy import Select, and_, asc, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.exceptions import BusinessError, NotFoundError
from app.models.base import utc_now
from app.models.financial_account import FinancialAccount
from app.models.transaction import Transaction, TransactionComment
from app.models.user import User
from app.schemas.transaction import TransactionDisplayValue
from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency

logger = structlog.get_logger(__name__)


class TransactionCRUDService:
    """Service for basic transaction CRUD operations."""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_financial_account(self, account_id: UUID, user_uuid: UUID) -> FinancialAccount | None:
        """Get and validate financial account."""
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
        transaction_at: datetime | None = None,
        category_key: str = "OTHERS",
        currency: str = "CNY",
        raw_input: str | None = None,
        source_account_id: UUID | None = None,
        target_account_id: UUID | None = None,
        subject: str = "SELF",
        intent: str = "SURVIVAL",
        tags: list[str] | None = None,
    ) -> dict:
        """Create a single transaction record

        Follow the principle of "record first, then link" and defaults to not linking balance.
        """
        tx_type = transaction_type.lower()
        transfer_amount = Decimal(str(amount))
        tx_time = transaction_at or datetime.now(UTC)

        # Validation logic has been handled by the utility layer, Service layer mainly responsible for persistence
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

        # Create record
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

        # Transfer scenario: immediately update account balance
        if tx_type == "transfer" and source_acc and target_acc:
            # Deduct from source account
            source_acc.current_balance -= transfer_amount
            source_acc.updated_at = datetime.now(UTC)
            # Add to target account
            target_acc.current_balance += transfer_amount
            target_acc.updated_at = datetime.now(UTC)

        await self.db.commit()
        await self.db.refresh(transaction)

        # Assemble return result (for GenUI rendering)
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

    async def get_transaction_detail(self, transaction_id: UUID, user_uuid: UUID) -> dict | None:
        """Get transaction details (including comments)

        Args:
            transaction_id: Transaction ID
            user_uuid: User UUID

        Returns:
            Transaction details dictionary (including comments), returns None if not found
        """
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

        # Get exchange rate and user preferred currency
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = await get_exchange_rate_from_base(display_currency)

        # Get associated shared spaces
        spaces_query = (
            select(SharedSpace)
            .join(SpaceTransaction, SpaceTransaction.space_id == SharedSpace.id)
            .where(SpaceTransaction.transaction_id == transaction_id)
        )
        spaces_result = await self.db.execute(spaces_query)
        associated_spaces = spaces_result.scalars().all()
        spaces_data = [{"id": str(s.id), "name": s.name} for s in associated_spaces]

        # Get comment user information
        comments_data = []
        for comment in transaction.comments:
            # Query comment author information
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
                    "createdAt": cast(datetime, comment.created_at).isoformat() if comment.created_at else None,
                    "updatedAt": cast(datetime, comment.updated_at).isoformat() if comment.updated_at else None,
                }
            )

        # Convert to dictionary and add calculated fields (converted amount)
        amount_val = float(transaction.amount)
        if display_currency != BASE_CURRENCY:
            amount_val = amount_val * float(exchange_rate) if exchange_rate else amount_val

        return {
            "id": str(transaction.id),
            "userUuid": str(transaction.user_uuid),
            "type": transaction.type,
            "amount": round(amount_val, 2),  # Use converted amount
            "amountOriginal": str(transaction.amount_original) if transaction.amount_original else None,
            "currency": display_currency,  # Use user preferred currency
            "categoryKey": transaction.category_key,
            "rawInput": transaction.raw_input,
            "description": transaction.description,
            "transactionAt": cast(datetime, transaction.transaction_at).isoformat() if transaction.transaction_at else None,
            "transactionTimezone": transaction.transaction_timezone,
            "sourceAccountId": transaction.source_account_id,
            "targetAccountId": transaction.target_account_id,
            "tags": transaction.tags or [],
            "location": transaction.location,
            "latitude": str(transaction.latitude) if transaction.latitude else None,
            "longitude": str(transaction.longitude) if transaction.longitude else None,
            "source": transaction.source,
            "status": transaction.status,
            "createdAt": cast(datetime, transaction.created_at).isoformat() if transaction.created_at else None,
            "updatedAt": cast(datetime, transaction.updated_at).isoformat() if transaction.updated_at else None,
            "comments": comments_data,
            "commentCount": len(comments_data),
            "spaces": spaces_data,
            "sourceThreadId": str(transaction.source_thread_id) if transaction.source_thread_id else None,
            "display": TransactionDisplayValue.from_params(
                amount=amount_val, tx_type=transaction.type, currency=display_currency
            ).model_dump(),
        }

    async def delete_transaction(
        self,
        transaction_id: UUID,
        user_uuid: UUID,
    ) -> bool:
        """Delete transaction record

        Args:
            transaction_id: Transaction ID (UUID object)
            user_uuid: User UUID (UUID object, used for ownership verification)

        Returns:
            Whether the deletion was successful

        Raises:
            NotFoundError: Transaction not found
            BusinessError: Permission denied
        """
        # Query transaction record
        query = select(Transaction).where(Transaction.id == transaction_id)
        result = await self.db.execute(query)
        transaction = result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("Transaction")

        # Verify ownership
        if transaction.user_uuid != user_uuid:
            raise BusinessError("Permission denied to delete this transaction", "PERMISSION_DENIED")

        # Delete transaction record (associated comments and shares will be automatically deleted through ORM cascade)
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
        source_thread_id: UUID | None = None,
    ) -> dict:
        """Batch create transactions

        Base currency scheme:
        - amount_original: Original input amount
        - amount: Base amount converted to CNY
        - currency: Original currency (if not specified, use the user's primaryCurrency)
        - exchange_rate: Exchange rate snapshot at the time of storage
        """
        from app.services.exchange_rate_service import exchange_rate_service

        transactions_data = data.get("transactions", [])
        source_account_id = data.get("source_account_id")
        created_transactions = []

        # Get user's default currency (primaryCurrency) as the default value when currency is not specified
        user_default_currency = await get_user_display_currency(self.db, user_uuid)
        logger.debug(
            "batch_create_using_default_currency", user_uuid=str(user_uuid), default_currency=user_default_currency
        )

        for item in transactions_data:
            amount_original = Decimal(str(item["amount"]))
            # Use user's primaryCurrency as default value, instead of hardcoding CNY
            currency = (item.get("currency") or user_default_currency).upper()

            # Convert to CNY base amount
            if currency == BASE_CURRENCY:
                amount = abs(amount_original)
                exchange_rate_val = Decimal("1.0")
            else:
                # Use convert to get exchange rate (convert 1 unit to get rate)
                rate = await exchange_rate_service.convert(
                    amount=1.0,
                    from_currency=currency,
                    to_currency=BASE_CURRENCY,
                )
                if rate is not None:
                    exchange_rate_val = Decimal(str(rate))
                    amount = abs(amount_original) * exchange_rate_val
                else:
                    # Exchange rate not found, handle as 1:1 (keep original amount)
                    exchange_rate_val = Decimal("1.0")
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
                amount=amount.quantize(Decimal("0.00000001")),
                amount_original=abs(amount_original),
                currency=currency,
                exchange_rate=exchange_rate_val.quantize(Decimal("0.00000001")),
                category_key=item.get("category_key", "OTHERS"),
                tags=item.get("tags", []),
                raw_input=item.get("raw_input"),
                source_account_id=UUID(str(source_account_id)) if source_account_id else None,
                transaction_at=utc_now(),
                transaction_timezone="Asia/Shanghai",
                source="AI",
                status="CLEARED",
                source_thread_id=source_thread_id,
            )
            self.db.add(tx)
            created_transactions.append(tx)

        await self.db.commit()

        # Refresh all records to get IDs
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
        transaction_ids: list[UUID],
        account_id: UUID | None,
    ) -> dict:
        """Batch update transaction account"""
        results = []
        for tx_id in transaction_ids:
            try:
                res = await self.update_transaction_account(
                    transaction_id=tx_id, user_uuid=user_uuid, account_id=account_id
                )
                results.append(res)
            except Exception as e:
                logger.error("batch_update_tx_failed", tx_id=str(tx_id), error=str(e))

        return {"success": True, "count": len(results), "account_id": account_id}

    async def update_transaction_account(
        self,
        transaction_id: UUID,
        user_uuid: UUID,
        account_id: UUID | None,
    ) -> dict | None:
        """Update transaction account

        Support cross-currency account association:
        - If the transaction currency is different from the account currency, use real-time exchange rate to convert
        - Account balance is deducted/increased in the account's local currency"

        Args:
            transaction_id: Transaction ID
            user_uuid: User UUID
            account_id: New account ID, pass None to cancel association

        Returns:
            Updated transaction details

        Raises:
            NotFoundError: Transaction or account not found
            BusinessError: Permission denied
        """
        from app.services.exchange_rate_service import ExchangeRateService

        query = select(Transaction).where(Transaction.id == transaction_id)
        result = await self.db.execute(query)
        transaction = result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("Transaction")

        # Verify ownership
        if transaction.user_uuid != user_uuid:
            raise BusinessError("Permission denied to modify this transaction", "PERMISSION_DENIED")

        # Get transaction type
        is_expense = transaction.type == "EXPENSE"
        is_income = transaction.type == "INCOME"

        # Determine which account field to use based on transaction type
        # Expense → source_account_id (payment account)
        # Income → target_account_id (receipt account)
        if is_expense:
            old_account_id = transaction.source_account_id
        elif is_income:
            old_account_id = transaction.target_account_id
        else:
            # Transfer type does not support single account association
            old_account_id = transaction.source_account_id

        new_account_id = account_id

        # If the account has not changed, return directly
        if old_account_id == new_account_id:
            return await self.get_transaction_detail(transaction_id, user_uuid)

        # Get transaction original amount and currency (for cross-currency conversion)
        # Prioritize using original amount/currency, fallback to amount/currency
        tx_original_amount = transaction.amount_original or transaction.amount
        tx_currency = (transaction.currency or BASE_CURRENCY).upper()

        # Initialize exchange rate service
        exchange_rate_svc = ExchangeRateService()

        # Rollback old account balance
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

                # Calculate amount in old account currency
                if tx_currency == old_account_currency:
                    rollback_amount = abs(Decimal(str(tx_original_amount)))
                else:
                    # Need exchange rate conversion
                    converted = await exchange_rate_svc.convert(
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
                        # Exchange rate conversion failed, use original amount as approximate value
                        rollback_amount = abs(Decimal(str(tx_original_amount)))
                    else:
                        rollback_amount = Decimal(str(converted))

                # Rollback: add back for expense, subtract for income
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

        # 2. Update new account balance
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

            # Calculate amount in new account currency
            if tx_currency == new_account_currency:
                deduct_amount = abs(Decimal(str(tx_original_amount)))
            else:
                # Need exchange rate conversion: convert from transaction currency to account currency
                converted = await exchange_rate_svc.convert(
                    amount=float(abs(Decimal(str(tx_original_amount)))),
                    from_currency=tx_currency,
                    to_currency=new_account_currency,
                )
                if converted is None:
                    raise BusinessError(
                        f"Unable to get exchange rate from {tx_currency} to {new_account_currency}, please try again later",
                        "EXCHANGE_RATE_UNAVAILABLE",
                    )
                deduct_amount = Decimal(str(converted))

            # Update balance: deduct for expense, add for income
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
            )

        # 3. Update transaction account association (set correct field based on type)
        if is_expense:
            transaction.source_account_id = new_account_id
        elif is_income:
            transaction.target_account_id = new_account_id
        else:
            # Transfer default sets source_account_id
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

    # ===== Comment Operations =====

    async def get_comments_for_transaction(self, transaction_id: UUID, user_uuid: UUID) -> list[dict]:
        """Get transaction comments list

        Args:
            transaction_id: Transaction ID
            user_uuid: Current user ID

        Returns:
            List of comments
        """
        # First verify if the transaction exists and belongs to the user
        tx_query = select(Transaction).where(
            and_(Transaction.id == transaction_id, Transaction.user_uuid == user_uuid)
        )
        tx_result = await self.db.execute(tx_query)
        transaction = tx_result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("Transaction")

        # Query comments and related user information
        query = (
            select(
                TransactionComment,
                User.username.label("user_name"),  # type: ignore
                User.avatar_url.label("user_avatar_url"),  # type: ignore
            )
            .join(User, TransactionComment.user_uuid == User.uuid)
            .where(TransactionComment.transaction_id == transaction_id)
            .order_by(TransactionComment.created_at.asc())
        )

        result = await self.db.execute(query)
        comments_data = result.all()

        if not comments_data:
            return []

        # Format comment data
        formatted_comments = []
        for comment, user_name, user_avatar_url in comments_data:
            # If there is a parent comment, get the information of the user being replied to
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
                    "userName": user_name or "default_name",
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
        transaction_id: UUID,
        user_uuid: UUID,
        comment_text: str,
        parent_comment_id: int | None = None,
    ) -> dict:
        """Add transaction comment

        Args:
            transaction_id: Transaction ID
            user_uuid: User ID
            comment_text: Comment content
            parent_comment_id: Optional parent comment ID

        Returns:
            New comment dictionary
        """
        # Validate comment content
        if not comment_text or not comment_text.strip():
            logger.warning(
                "empty_comment_rejected",
                user_uuid=user_uuid,
                transaction_id=transaction_id,
            )
            raise BusinessError("Comment content cannot be empty", "TRANSACTION_COMMENT_NULL")

        # Validate transaction exists
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

        # If there is a parent comment, validate the parent comment
        if parent_comment_id is not None:
            parent_comment_query = select(TransactionComment).where(
                and_(
                    TransactionComment.id == parent_comment_id,
                    TransactionComment.transaction_id == transaction_id,
                )
            )
            parent_comment_result = await self.db.execute(parent_comment_query)
            parent_comment = parent_comment_result.scalar_one_or_none()

            if not parent_comment:
                raise BusinessError("Parent comment does not exist", "INVALID_PARENT_COMMENT_ID")

            # Ensure the parent comment is not a child comment (single-level reply structure)
            if parent_comment.parent_comment_id is not None:
                raise BusinessError("Cannot reply to a child comment", "INVALID_PARENT_COMMENT_ID")

        # Create new comment
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

        # Get complete comment information (including user information)
        query = (
            select(
                TransactionComment,
                User.username.label("user_name"),  # type: ignore
                User.avatar_url.label("user_avatar_url"),  # type: ignore
            )
            .join(User, TransactionComment.user_uuid == User.uuid)
            .where(TransactionComment.id == new_comment.id)
        )

        result = await self.db.execute(query)
        comment_data = result.first()

        if not comment_data:
            raise BusinessError("Failed to retrieve new comment data", "STORE_COMMENT_FAILED")

        comment, user_name, user_avatar_url = comment_data

        # If there is a parent comment, get the information of the user being replied to
        replied_to_user_uuid = None
        replied_to_user_name = None

        if parent_comment_id:
            reply_context_query: Select[Any] = (
                select(TransactionComment, User.username)
                .join(User, TransactionComment.user_uuid == User.uuid)
                .where(TransactionComment.id == parent_comment_id)
            )
            reply_context_result = await self.db.execute(reply_context_query)
            reply_context_data = reply_context_result.first()

            if reply_context_data:
                parent_comment_obj, parent_user_name = reply_context_data
                replied_to_user_uuid = str(parent_comment_obj.user_uuid)
                replied_to_user_name = parent_user_name

        return {
            "id": str(comment.id),
            "transactionId": str(comment.transaction_id),
            "userId": str(comment.user_uuid),
            "userName": user_name or "Anonymous",
            "userAvatarUrl": user_avatar_url or "assets/images/avatars/default_avatar.png",
            "parentCommentId": str(comment.parent_comment_id) if comment.parent_comment_id else None,
            "commentText": comment.comment_text,
            "repliedToUserId": replied_to_user_uuid,
            "repliedToUserName": replied_to_user_name,
            "createdAt": comment.created_at.isoformat(),
            "updatedAt": comment.updated_at.isoformat() if comment.updated_at else None,
        }

    async def delete_comment(self, comment_id: int, user_uuid: UUID) -> bool:
        """Delete comment

        Args:
            comment_id: Comment ID
            user_uuid: User UUID

        Returns:
            Whether the comment was deleted successfully
        """
        # Query comment
        query = select(TransactionComment).where(TransactionComment.id == comment_id)
        result = await self.db.execute(query)
        comment = result.scalar_one_or_none()

        if not comment:
            return False

        # Verify permissions
        if comment.user_uuid != user_uuid:
            raise BusinessError("You do not have permission to delete this comment", "PERMISSION_DENIED")

        # Delete comment (if foreign key cascade delete, child comments will be automatically deleted)
        await self.db.delete(comment)
        await self.db.commit()

        return True
