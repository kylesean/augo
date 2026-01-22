from datetime import UTC, datetime, timezone
from decimal import Decimal
from uuid import UUID, uuid4

import pytest
from sqlalchemy import func, select

from app.models.financial_account import FinancialAccount
from app.models.transaction import Transaction
from app.models.user import User
from app.services.transaction_service import TransactionService


@pytest.mark.asyncio
async def test_create_transaction_simple(db_session):
    # 1. Setup User
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="test_user", email="test@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    # 2. Setup Service
    service = TransactionService(db_session)

    # 3. Execute
    result = await service.create_transaction(
        user_uuid=user_uuid,
        amount=100.0,
        category_key="FOOD",
        raw_input="lunch 100",
        transaction_type="expense",
        tags=["food", "lunch"],
    )

    # 4. Verify Response
    assert result["success"] is True
    assert result["amount"] == 100.0
    assert result["category_key"] == "FOOD"
    assert result["type"] == "EXPENSE"
    assert result["tags"] == ["food", "lunch"]

    # 5. Verify DB
    tx_id = UUID(result["transaction_id"])  # Cast to UUID object
    query = select(Transaction).where(Transaction.id == tx_id)
    db_result = await db_session.execute(query)
    tx_record = db_result.scalar_one()

    assert tx_record is not None
    assert tx_record.user_uuid == user_uuid
    assert float(tx_record.amount) == 100.0
    assert tx_record.category_key == "FOOD"
    assert tx_record.tags == ["food", "lunch"]


@pytest.mark.asyncio
async def test_get_transaction_feed_pagination(db_session):
    # 1. Setup User
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="test_user_2", email="test2@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    # 2. Create 15 dummy transactions
    for i in range(15):
        tx = Transaction(
            id=uuid4(),
            user_uuid=user_uuid,
            type="EXPENSE",
            amount=Decimal(10.0 + i),
            amount_original=Decimal(10.0 + i),
            currency="CNY",
            transaction_at=datetime.now(UTC),
            status="CLEARED",
        )
        db_session.add(tx)
    await db_session.commit()

    # 3. Test Pagination (Page 1, limit 10)
    service = TransactionService(db_session)
    result_p1 = await service.get_transaction_feed(user_uuid=user_uuid, page=1, limit=10)

    assert len(result_p1["data"]) == 10
    assert result_p1["meta"]["total"] == 15
    assert result_p1["meta"]["has_more"] is True

    # 4. Test Pagination (Page 2, limit 10)
    result_p2 = await service.get_transaction_feed(user_uuid=user_uuid, page=2, limit=10)

    assert len(result_p2["data"]) == 5
    assert result_p2["meta"]["has_more"] is False


@pytest.mark.asyncio
async def test_delete_transaction(db_session):
    # 1. Setup User
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="test_user_3", email="test3@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    # 2. Create Transaction
    tx_id = uuid4()
    tx = Transaction(
        id=tx_id,
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("50.0"),
        amount_original=Decimal("50.0"),
        currency="CNY",
        transaction_at=datetime.now(UTC),
        status="CLEARED",
    )
    db_session.add(tx)
    await db_session.commit()

    # 3. Delete
    service = TransactionService(db_session)
    success = await service.delete_transaction(tx_id, user_uuid)

    assert success is True

    # 4. Verify Gone
    query = select(Transaction).where(Transaction.id == tx_id)
    db_result = await db_session.execute(query)
    assert db_result.scalar_one_or_none() is None
