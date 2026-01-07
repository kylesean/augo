"""Shared space service for managing collaborative spaces."""
from __future__ import annotations

import secrets
from collections import defaultdict
from datetime import UTC, datetime, timedelta
from decimal import Decimal
from typing import Any, cast
from uuid import UUID

import structlog
from sqlalchemy import and_, desc, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.exceptions import AuthorizationError, BusinessError, ErrorCode, NotFoundError
from app.models.shared_space import (
    SharedSpace,
    SpaceMember,
    SpaceTransaction,
)
from app.models.transaction import Transaction
from app.models.user import User

logger = structlog.get_logger(__name__)


class SharedSpaceService:
    """Service for managing shared spaces and their transactions."""

    def __init__(self, db: AsyncSession):
        self.db = db

    # =========================================================================
    # Space CRUD Operations
    # =========================================================================

    async def create_space(self, user_uuid: UUID, name: str, description: str | None = None) -> SharedSpace:
        """Create a new shared space.

        Args:
            user_uuid: Creator's UUID
            name: Space name
            description: Optional description

        Returns:
            Created SharedSpace instance
        """
        space = SharedSpace(
            name=name,
            description=description,
            creator_uuid=user_uuid,
            status="active",
        )
        self.db.add(space)
        await self.db.flush()

        # Add creator as owner member
        member = SpaceMember(
            space_id=space.id,
            user_uuid=user_uuid,
            role="OWNER",
            status="ACCEPTED",
        )
        self.db.add(member)
        await self.db.commit()
        await self.db.refresh(space)

        logger.info("shared_space_created", space_id=space.id, creator=str(user_uuid))
        return space

    async def get_user_spaces(self, user_uuid: UUID, page: int = 1, limit: int = 20) -> dict[str, Any]:
        """Get all spaces the user is a member of with pagination.

        Args:
            user_uuid: User's UUID
            page: Page number
            limit: Items per page

        Returns:
            Dictionary with 'items' (list of spaces) and 'total' count
        """
        offset = (page - 1) * limit

        # Base query for filtering
        base_filter = and_(
            SpaceMember.user_uuid == user_uuid, SpaceMember.status == "ACCEPTED", SharedSpace.status == "active"
        )

        # Count total
        count_query = select(func.count(SharedSpace.id)).join(SpaceMember).where(base_filter)
        count_result = await self.db.execute(count_query)
        total = count_result.scalar() or 0

        # Query spaces
        query = (
            select(SharedSpace, SpaceMember.role)
            .join(SpaceMember, SharedSpace.id == SpaceMember.space_id)
            .where(base_filter)
            .options(selectinload(SharedSpace.creator))
            .order_by(SharedSpace.created_at.desc())
            .offset(offset)
            .limit(limit)
        )

        result = await self.db.execute(query)
        rows = result.all()

        # Build response with transaction counts
        items = []
        for space, role in rows:
            stats = await self._get_space_financial_stats(space.id)
            items.append(
                self._space_to_dict(
                    space,
                    tx_count=stats["transaction_count"],
                    total_expense=stats["total_expense"],
                    member_contributions=stats["member_contributions"],
                    role=role,
                )
            )

        return {"spaces": items, "total": total, "page": page, "limit": limit}

    async def get_space_detail(self, space_id: UUID, user_uuid: UUID) -> dict[str, Any]:
        """Get detailed space info including members.

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID

        Returns:
            Space dictionary with full details

        Raises:
            NotFoundError: Space not found
            AuthorizationError: User not a member
        """
        # Verify membership
        member = await self._verify_membership(space_id, user_uuid)

        query = (
            select(SharedSpace)
            .where(SharedSpace.id == space_id)
            .options(
                selectinload(SharedSpace.members).selectinload(SpaceMember.user),
            )
        )
        result = await self.db.execute(query)
        space = result.scalar_one_or_none()

        if not space:
            raise NotFoundError("shared space not found")

        # Load creator separately to ensure it's loaded
        creator_query = select(User).where(User.uuid == space.creator_uuid)
        creator_result = await self.db.execute(creator_query)
        creator = creator_result.scalar_one_or_none()

        # Aggregate financial statistics
        stats = await self._get_space_financial_stats(space_id)

        return self._space_to_dict_with_creator(
            space,
            creator,
            tx_count=stats["transaction_count"],
            total_expense=stats["total_expense"],
            member_contributions=stats["member_contributions"],
            include_members=True,
            role=member.role,
        )

    async def update_space(
        self,
        space_id: UUID,
        user_uuid: UUID,
        name: str | None = None,
        description: str | None = None,
        status: str | None = None,
    ) -> dict[str, Any]:
        """Update space info (owner/admin only).

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID
            name: New name
            description: New description
            status: New status

        Returns:
            Updated space dictionary

        Raises:
            NotFoundError: Space not found
            AuthorizationError: User not owner/admin
        """
        await self._verify_admin(space_id, user_uuid)

        query = select(SharedSpace).where(SharedSpace.id == space_id)
        result = await self.db.execute(query)
        space = result.scalar_one_or_none()

        if not space:
            raise NotFoundError("shared space not found")

        if name is not None:
            space.name = name
        if description is not None:
            space.description = description
        if status is not None:
            space.status = status

        await self.db.commit()
        await self.db.refresh(space)

        stats = await self._get_space_financial_stats(space_id)
        return self._space_to_dict(space, stats["transaction_count"])

    async def delete_space(self, space_id: UUID, user_uuid: UUID) -> bool:
        """Delete a space (owner only).

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID

        Returns:
            True if deleted

        Raises:
            NotFoundError: Space not found
            AuthorizationError: User not owner
        """
        await self._verify_owner(space_id, user_uuid)

        query = select(SharedSpace).where(SharedSpace.id == space_id)
        result = await self.db.execute(query)
        space = result.scalar_one_or_none()

        if not space:
            raise NotFoundError("shared space not found")

        await self.db.delete(space)
        await self.db.commit()

        logger.info("shared_space_deleted", space_id=space_id, by_user=str(user_uuid))
        return True

    # =========================================================================
    # Invitation Management
    # =========================================================================

    async def generate_invite_code(self, space_id: UUID, user_uuid: UUID, expires_days: int = 1) -> dict[str, Any]:
        """Generate a new invite code for the space.

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID
            expires_days: Days until expiration (default: 1 day)

        Returns:
            Invite code dictionary

        Raises:
            AuthorizationError: User not owner/admin
            NotFoundError: Space not found
        """
        await self._verify_admin(space_id, user_uuid)

        # Get space
        query = select(SharedSpace).where(SharedSpace.id == space_id)
        result = await self.db.execute(query)
        space = result.scalar_one_or_none()

        if not space:
            raise NotFoundError("shared space not found")

        # Generate 6-digit numeric invite code
        code = "".join(secrets.choice("0123456789") for _ in range(6))
        expires_at = datetime.now(UTC) + timedelta(days=expires_days)

        # Update space with new invite code
        space.invite_code = code
        space.invite_code_expires_at = expires_at
        await self.db.commit()
        await self.db.refresh(space)

        return {
            "code": code,
            "spaceId": str(space_id),
            "spaceName": space.name,
            "expiresAt": expires_at.isoformat(),
        }

    async def join_with_code(self, code: str, user_uuid: UUID) -> dict[str, Any]:
        """Join a space using invite code.

        Args:
            code: Invitation code
            user_uuid: Joining user's UUID

        Returns:
            Space dictionary

        Raises:
            NotFoundError: Invalid code
            BusinessError: Code expired or already a member
        """
        # Find space by invite code
        query = select(SharedSpace).where(SharedSpace.invite_code == code)
        result = await self.db.execute(query)
        space = result.scalar_one_or_none()

        if not space:
            raise NotFoundError("invalid invitation code")

        # Check expiration
        if space.invite_code_expires_at and space.invite_code_expires_at < datetime.now(UTC):
            raise BusinessError("invitation code expired", error_code=ErrorCode.VALIDATION_ERROR)

        # Check if already a member
        member_query = select(SpaceMember).where(
            and_(SpaceMember.space_id == space.id, SpaceMember.user_uuid == user_uuid)
        )
        member_result = await self.db.execute(member_query)
        existing_member = member_result.scalar_one_or_none()

        if existing_member:
            if existing_member.status == "ACCEPTED":
                raise BusinessError("you are already a member", error_code=ErrorCode.ALREADY_MEMBER_OR_HAS_BEEN_INVITED)
            else:
                # Update existing pending membership
                existing_member.status = "ACCEPTED"
        else:
            # Add as new member
            member = SpaceMember(
                space_id=space.id,
                user_uuid=user_uuid,
                role="MEMBER",
                status="ACCEPTED",
            )
            self.db.add(member)

        await self.db.commit()

        # Return space info
        return await self.get_space_detail(cast(UUID, space.id), user_uuid)

    # =========================================================================
    # Member Management
    # =========================================================================

    async def leave_space(self, space_id: UUID, user_uuid: UUID) -> bool:
        """Leave a space.

        Args:
            space_id: Space ID
            user_uuid: Leaving user's UUID

        Returns:
            True if left

        Raises:
            BusinessError: Owner cannot leave
        """
        # Check if user is owner
        query = select(SpaceMember).where(and_(SpaceMember.space_id == space_id, SpaceMember.user_uuid == user_uuid))
        result = await self.db.execute(query)
        member = result.scalar_one_or_none()

        if not member:
            raise NotFoundError("you are not a member of this space")

        if member.role == "OWNER":
            raise BusinessError(
                "space owner cannot leave space, please transfer or delete space first",
                error_code=ErrorCode.PERMISSION_DENIED,
            )

        await self.db.delete(member)
        await self.db.commit()

        logger.info("member_left_space", space_id=space_id, user=str(user_uuid))
        return True

    async def remove_member(self, space_id: UUID, user_uuid: UUID, target_user_uuid: UUID) -> bool:
        """Remove a member from space (owner/admin only).

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID
            target_user_uuid: User to remove

        Returns:
            True if removed

        Raises:
            AuthorizationError: Not authorized
            BusinessError: Cannot remove owner
        """
        await self._verify_admin(space_id, user_uuid)

        # Cannot remove self via this method
        if user_uuid == target_user_uuid:
            raise BusinessError("please use leave space function", error_code=ErrorCode.INVALID_ACTION)

        # Find target member
        query = select(SpaceMember).where(
            and_(SpaceMember.space_id == space_id, SpaceMember.user_uuid == target_user_uuid)
        )
        result = await self.db.execute(query)
        member = result.scalar_one_or_none()

        if not member:
            raise NotFoundError("user is not a member of this space")

        if member.role == "OWNER":
            raise BusinessError("cannot remove space owner", error_code=ErrorCode.PERMISSION_DENIED)

        await self.db.delete(member)
        await self.db.commit()

        logger.info("member_removed", space_id=space_id, removed=str(target_user_uuid), by=str(user_uuid))
        return True

    # =========================================================================
    # Transaction Management
    # =========================================================================

    async def add_transaction_to_space(self, space_id: UUID, user_uuid: UUID, transaction_id: UUID) -> dict[str, Any]:
        """Add a transaction to the space.

        Args:
            space_id: Space ID
            user_uuid: Adding user's UUID
            transaction_id: Transaction to add

        Returns:
            Space transaction info

        Raises:
            AuthorizationError: Not a member
            BusinessError: Transaction already in space
        """
        from app.core.exceptions import ErrorCode

        await self._verify_membership(space_id, user_uuid)

        # Verify transaction exists and belongs to user
        tx_query = select(Transaction).where(Transaction.id == transaction_id)
        tx_result = await self.db.execute(tx_query)
        transaction = tx_result.scalar_one_or_none()

        if not transaction:
            raise NotFoundError("transaction", error_code=ErrorCode.TRANSACTION_NOT_EXISTS)

        if transaction.user_uuid != user_uuid:
            raise AuthorizationError("can only add your own transactions to shared space")

        # Check if already in space
        existing_query = select(SpaceTransaction).where(
            and_(SpaceTransaction.space_id == space_id, SpaceTransaction.transaction_id == transaction_id)
        )
        existing_result = await self.db.execute(existing_query)
        if existing_result.scalar_one_or_none():
            # 优化：不再抛出异常，而是返回友好信息告知已关联
            return {"message": "交易已在该空间中", "already_exists": True}

        space_tx = SpaceTransaction(
            space_id=space_id,
            transaction_id=transaction_id,
            added_by_user_uuid=user_uuid,
        )
        self.db.add(space_tx)
        await self.db.commit()

        return {"message": "transaction added to space"}

    async def create_transaction_for_space(
        self,
        user_uuid: UUID,
        space_id: UUID,
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
    ) -> dict[str, Any]:
        """Create a transaction and immediately add it to a shared space."""
        from app.services.transaction_service import TransactionService

        tx_service = TransactionService(self.db)
        result = await tx_service.create_transaction(
            user_uuid=user_uuid,
            amount=amount,
            transaction_type=transaction_type,
            transaction_at=transaction_at,
            category_key=category_key,
            currency=currency,
            raw_input=raw_input,
            source_account_id=source_account_id,
            target_account_id=target_account_id,
            subject=subject,
            intent=intent,
            tags=tags,
        )

        if result.get("success"):
            tx_id = UUID(result["transaction_id"])
            await self.add_transaction_to_space(space_id=space_id, user_uuid=user_uuid, transaction_id=tx_id)

        return result

    async def record_shared_transactions(
        self,
        user_uuid: UUID,
        space_id: UUID,
        data: dict[str, Any],
    ) -> dict[str, Any]:
        """Record multiple transactions and link them to a shared space."""
        from app.services.transaction_service import TransactionService

        tx_service = TransactionService(self.db)
        result = await tx_service.create_batch_transactions(user_uuid, data)

        if result.get("success"):
            # Link all created transactions to the space
            for tx_item in result.get("transactions", []):
                tx_id = UUID(tx_item["id"])
                try:
                    await self.add_transaction_to_space(space_id=space_id, user_uuid=user_uuid, transaction_id=tx_id)
                except Exception as e:
                    logger.error(
                        "failed_to_link_batch_transaction_to_space",
                        transaction_id=str(tx_id),
                        space_id=space_id,
                        error=str(e),
                    )

        return result

    async def get_space_transactions(
        self, space_id: UUID, user_uuid: UUID, page: int = 1, limit: int = 20
    ) -> list[dict[str, Any]]:
        """Get transactions in a space.

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID
            page: Page number
            limit: Items per page

        Returns:
            List of transaction dictionaries
        """
        await self._verify_membership(space_id, user_uuid)
        offset = (page - 1) * limit

        query = (
            select(SpaceTransaction)
            .where(SpaceTransaction.space_id == space_id)
            .options(
                selectinload(SpaceTransaction.transaction),
                selectinload(SpaceTransaction.added_by),
            )
            .order_by(SpaceTransaction.created_at.desc())
            .offset(offset)
            .limit(limit)
        )

        result = await self.db.execute(query)
        space_txs = result.scalars().all()

        return [self._space_transaction_to_dict(st) for st in space_txs]

    # =========================================================================
    # Settlement Calculation
    # =========================================================================

    async def get_settlement(self, space_id: UUID, user_uuid: UUID) -> dict[str, Any]:
        """Calculate settlement for the space.

        This calculates who owes whom based on transactions in the space.

        Args:
            space_id: Space ID
            user_uuid: Requesting user's UUID

        Returns:
            Settlement dictionary
        """
        await self._verify_membership(space_id, user_uuid)

        # Get all transactions in space
        query = (
            select(SpaceTransaction)
            .where(SpaceTransaction.space_id == space_id)
            .options(
                selectinload(SpaceTransaction.transaction),
                selectinload(SpaceTransaction.added_by),
            )
        )
        result = await self.db.execute(query)
        space_txs = result.scalars().all()

        # Get all members
        members_query = (
            select(SpaceMember)
            .where(and_(SpaceMember.space_id == space_id, SpaceMember.status == "ACCEPTED"))
            .options(selectinload(SpaceMember.user))
        )
        members_result = await self.db.execute(members_query)
        members = members_result.scalars().all()

        member_count = len(members)
        if member_count == 0:
            return {
                "spaceId": str(space_id),
                "items": [],
                "totalAmount": "0.00",
                "calculatedAt": datetime.now(UTC).isoformat(),
                "isSettled": True,
            }

        # Calculate balances: positive = others owe this person, negative = owes others
        balances: dict[UUID, Decimal] = defaultdict(Decimal)
        total_amount = Decimal("0")

        for st in space_txs:
            tx = st.transaction
            if tx and tx.type == "EXPENSE":
                # Person who paid gets credit
                payer_uuid = st.added_by_user_uuid
                amount = Decimal(str(tx.amount))
                share = amount / member_count

                # Payer's balance increases (others owe them)
                balances[payer_uuid] += amount - share

                # Everyone else's balance decreases (they owe)
                for member in members:
                    if member.user_uuid != payer_uuid:
                        balances[member.user_uuid] -= share

                total_amount += amount

        # Create settlement items (who pays whom)
        items = []
        debtors = [(u, b) for u, b in balances.items() if b < 0]
        creditors = [(u, b) for u, b in balances.items() if b > 0]

        # Build user lookup
        user_map = {m.user_uuid: m.user for m in members}

        for debtor_uuid, debt in debtors:
            remaining = abs(debt)
            for creditor_uuid, credit in creditors:
                if remaining <= 0 or credit <= 0:
                    continue

                settle_amount = min(remaining, credit)
                if settle_amount > Decimal("0.01"):
                    debtor_user = user_map.get(debtor_uuid)
                    creditor_user = user_map.get(creditor_uuid)

                    items.append(
                        {
                            "fromUserId": str(debtor_uuid),
                            "fromUsername": debtor_user.username if debtor_user else "Unknown",
                            "toUserId": str(creditor_uuid),
                            "toUsername": creditor_user.username if creditor_user else "Unknown",
                            "amount": f"{settle_amount:.2f}",
                        }
                    )

                remaining -= settle_amount

        return {
            "spaceId": str(space_id),
            "items": items,
            "totalAmount": f"{total_amount:.2f}",
            "calculatedAt": datetime.now(UTC).isoformat(),
            "isSettled": len(items) == 0,
        }

    # =========================================================================
    # Helper Methods
    # =========================================================================

    async def _verify_membership(self, space_id: UUID, user_uuid: UUID) -> SpaceMember:
        """Verify user is a member of the space."""
        query = select(SpaceMember).where(
            and_(
                SpaceMember.space_id == space_id, SpaceMember.user_uuid == user_uuid, SpaceMember.status == "ACCEPTED"
            )
        )
        result = await self.db.execute(query)
        member = result.scalar_one_or_none()

        if not member:
            raise AuthorizationError("you are not a member of this space")
        return member

    async def _verify_admin(self, space_id: UUID, user_uuid: UUID) -> SpaceMember:
        """Verify user is owner or admin."""
        member = await self._verify_membership(space_id, user_uuid)
        if member.role not in ("OWNER", "ADMIN"):
            raise AuthorizationError("you need admin permissions")
        return member

    async def _verify_owner(self, space_id: UUID, user_uuid: UUID) -> SpaceMember:
        """Verify user is owner."""
        member = await self._verify_membership(space_id, user_uuid)
        if member.role != "OWNER":
            raise AuthorizationError("you need owner permissions")
        return member

    async def _get_space_financial_stats(self, space_id: UUID) -> dict[str, Any]:
        """Retrieve aggregated financial statistics data across spatial dimensions."""
        # 1. Total count (including all types)
        count_query = select(func.count()).where(SpaceTransaction.space_id == space_id)
        count_result = await self.db.execute(count_query)
        tx_count = count_result.scalar() or 0

        # 2. Total expense (only EXPENSE type)
        expense_query = (
            select(func.sum(Transaction.amount))
            .join(SpaceTransaction, Transaction.id == SpaceTransaction.transaction_id)
            .where(and_(SpaceTransaction.space_id == space_id, Transaction.type == "EXPENSE"))
        )
        expense_result = await self.db.execute(expense_query)
        total_expense = expense_result.scalar() or Decimal("0")

        # 3. Total contributions by each member (only EXPENSE type)
        contribution_query = (
            select(SpaceTransaction.added_by_user_uuid, func.sum(Transaction.amount))
            .join(Transaction, Transaction.id == SpaceTransaction.transaction_id)
            .where(and_(SpaceTransaction.space_id == space_id, Transaction.type == "EXPENSE"))
            .group_by(SpaceTransaction.added_by_user_uuid)
        )
        contribution_result = await self.db.execute(contribution_query)
        contributions = {row[0]: row[1] for row in contribution_result.all()}

        return {"transaction_count": tx_count, "total_expense": total_expense, "member_contributions": contributions}

    def _space_to_dict(
        self,
        space: SharedSpace,
        tx_count: int = 0,
        total_expense: Decimal = Decimal("0"),
        member_contributions: dict[UUID, Decimal] | None = None,
        include_members: bool = False,
        role: str | None = None,
    ) -> dict[str, Any]:
        """Convert space to dictionary."""
        data: dict[str, Any] = {
            "id": str(space.id),
            "name": space.name,
            "role": role,
            "description": space.description,
            "creator": {
                "id": str(space.creator.uuid) if space.creator else str(space.creator_uuid),
                "username": space.creator.username if space.creator else "Unknown",
                "avatarUrl": getattr(space.creator, "avatar_url", None) if space.creator else None,
            },
            "createdAt": cast(datetime, space.created_at).isoformat() if space.created_at else None,
            "updatedAt": cast(datetime, space.updated_at).isoformat() if space.updated_at else None,
            "transactionCount": tx_count,
            "totalExpense": f"{total_expense:.2f}",
        }

        if include_members and space.members:
            contributions = member_contributions or {}
            data["members"] = [
                {
                    "userId": str(m.user_uuid),
                    "username": m.user.username if m.user else "Unknown",
                    "avatarUrl": getattr(m.user, "avatar_url", None) if m.user else None,
                    "role": m.role,
                    "status": m.status,
                    "createdAt": cast(datetime, m.created_at).isoformat() if m.created_at else None,
                    "contributionAmount": f"{contributions.get(m.user_uuid, Decimal('0')):.2f}",
                }
                for m in space.members
                if m.status == "ACCEPTED"
            ]

            # Get current valid invite code
            if space.invite_code:
                is_valid = not space.invite_code_expires_at or space.invite_code_expires_at > datetime.now(
                    UTC
                )
                if is_valid:
                    data["currentInviteCode"] = space.invite_code
                    data["inviteCodeExpiresAt"] = (
                        space.invite_code_expires_at.isoformat() if space.invite_code_expires_at else None
                    )

        return data

    def _space_to_dict_with_creator(
        self,
        space: SharedSpace,
        creator: User | None,
        tx_count: int = 0,
        total_expense: Decimal = Decimal("0"),
        member_contributions: dict[UUID, Decimal] | None = None,
        include_members: bool = False,
        role: str | None = None,
    ) -> dict[str, Any]:
        """Convert space to dictionary with externally loaded creator."""
        data: dict[str, Any] = {
            "id": str(space.id),
            "name": space.name,
            "role": role,
            "description": space.description,
            "creator": {
                "id": str(creator.uuid) if creator else str(space.creator_uuid),
                "username": creator.username if creator else "Unknown",
                "avatarUrl": getattr(creator, "avatar_url", None) if creator else None,
            },
            "createdAt": cast(datetime, space.created_at).isoformat() if space.created_at else None,
            "updatedAt": cast(datetime, space.updated_at).isoformat() if space.updated_at else None,
            "transactionCount": tx_count,
            "totalExpense": f"{total_expense:.2f}",
        }

        if include_members and space.members:
            contributions = member_contributions or {}
            data["members"] = [
                {
                    "userId": str(m.user_uuid),
                    "username": m.user.username if m.user else "Unknown",
                    "avatarUrl": getattr(m.user, "avatar_url", None) if m.user else None,
                    "role": m.role,
                    "status": m.status,
                    "createdAt": cast(datetime, m.created_at).isoformat() if m.created_at else None,
                    "contributionAmount": f"{contributions.get(m.user_uuid, Decimal('0')):.2f}",
                }
                for m in space.members
                if m.status == "ACCEPTED"
            ]

            # Get current valid invite code
            if space.invite_code:
                is_valid = not space.invite_code_expires_at or space.invite_code_expires_at > datetime.now(
                    UTC
                )
                if is_valid:
                    data["currentInviteCode"] = space.invite_code
                    data["inviteCodeExpiresAt"] = (
                        space.invite_code_expires_at.isoformat() if space.invite_code_expires_at else None
                    )

        return data

    def _space_transaction_to_dict(self, st: SpaceTransaction) -> dict[str, Any]:
        """Convert space transaction to dictionary."""
        from app.schemas.transaction import TransactionDisplayValue

        tx = st.transaction
        amount = float(tx.amount) if tx else 0.0
        tx_type = tx.type if tx else "EXPENSE"
        currency = tx.currency if tx else "CNY"

        # 使用统一的金额显示格式
        display = TransactionDisplayValue.from_params(amount=amount, tx_type=tx_type, currency=currency)

        return {
            "id": str(tx.id) if tx else "",
            "type": tx_type,
            "amount": str(tx.amount) if tx else "0",
            "currency": currency,
            "description": tx.description if tx else None,
            "categoryKey": tx.category_key if tx else "",
            "transactionAt": cast(datetime, tx.transaction_at).isoformat() if tx and tx.transaction_at else None,
            "addedByUsername": st.added_by.username if st.added_by else "Unknown",
            "addedAt": cast(datetime, st.created_at).isoformat() if st.created_at else None,
            "display": display.model_dump(),  # 添加统一的金额显示格式
        }
