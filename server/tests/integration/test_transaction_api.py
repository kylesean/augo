from datetime import datetime, timezone
from decimal import Decimal
from uuid import uuid4

import pytest
from sqlalchemy import select

from app.models.transaction import Transaction


@pytest.mark.asyncio
async def test_get_transactions_api(client_with_auth, db_session, test_user):
    # 1. Setup: Create settings and transactions
    from app.models.financial_settings import FinancialSettings

    settings = FinancialSettings(user_uuid=test_user.uuid, primary_currency="USD")
    db_session.add(settings)

    tx1 = Transaction(
        id=uuid4(),
        user_uuid=test_user.uuid,
        type="EXPENSE",
        amount=Decimal("50.0"),
        amount_original=Decimal("50.0"),
        currency="USD",
        transaction_at=datetime.now(timezone.utc),
        status="CLEARED",
        category_key="FOOD",
        description="Lunch",
    )
    db_session.add(tx1)
    await db_session.commit()

    # 2. Action: Call API
    response = client_with_auth.get("/api/v1/transactions")

    # 3. Assert
    assert response.status_code == 200
    data = response.json()["data"]
    # items inside data (from Page)
    items = data.get("items", data)
    assert len(items) >= 1

    # Check if tx1 is in items
    tx_ids = [item["id"] for item in items]
    assert str(tx1.id) in tx_ids

    # Find our specific transaction
    tx_data = next(item for item in items if item["id"] == str(tx1.id))
    # Compare as float to avoid string formatting mismatches
    assert float(tx_data["amount"]) == 50.0


@pytest.mark.asyncio
async def test_create_batch_transactions_api(client_with_auth, db_session, test_user):
    # 1. Prepare Payload
    payload = {
        "transactions": [
            {
                "amount": 100.0,
                "currency": "USD",
                "tags": ["food"],
                "transaction_type": "expense",
                "category_key": "FOOD",
                "raw_input": "lunch 100",
            },
            {
                "amount": 200.0,
                "currency": "USD",
                "tags": ["transport"],
                "transaction_type": "expense",
                "category_key": "TRANSPORT",
                "raw_input": "taxi 200",
            },
        ]
    }

    # 2. Action
    response = client_with_auth.post("/api/v1/transactions/batch", json=payload)

    # 3. Assert Response
    assert response.status_code == 200
    data = response.json()["data"]
    assert data["success"] is True
    assert data["count"] == 2

    # 4. Verify DB
    query = select(Transaction).where(Transaction.user_uuid == test_user.uuid)
    result = await db_session.execute(query)
    transactions = result.scalars().all()
    # Might be more than 2 if other tests ran, but at least 2
    assert len(transactions) >= 2

    # Check specific amounts (stored as positive in CNY base, but here 1:1 with USD)
    amounts = {float(tx.amount_original) for tx in transactions}
    assert 100.0 in amounts
    assert 200.0 in amounts


@pytest.mark.asyncio
async def test_delete_transaction_api(client_with_auth, db_session, test_user):
    # 1. Setup
    tx = Transaction(
        id=uuid4(),
        user_uuid=test_user.uuid,
        type="EXPENSE",
        amount=Decimal("10.0"),
        amount_original=Decimal("10.0"),
        currency="USD",
        transaction_at=datetime.now(timezone.utc),
        status="CLEARED",
    )
    db_session.add(tx)
    await db_session.commit()

    # 2. Action
    response = client_with_auth.delete(f"/api/v1/transactions/{tx.id}")

    # 3. Assert
    assert response.status_code == 200

    # 4. Verify Gone
    query = select(Transaction).where(Transaction.id == tx.id)
    result = await db_session.execute(query)
    assert result.scalar_one_or_none() is None
