from decimal import Decimal
from uuid import uuid4

import pytest

from app.models.financial_account import FinancialAccount
from app.models.user import User
from app.services.account_service import AccountService


@pytest.mark.asyncio
async def test_list_user_accounts(db_session):
    # Setup User
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="acc_user", email="acc@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    # Setup Accounts
    acc1 = FinancialAccount(
        id=uuid4(),
        user_uuid=user_uuid,
        name="Cash",
        type="CASH",
        nature="ASSET",
        initial_balance=Decimal("100.0"),
        current_balance=Decimal("100.0"),
        currency_code="CNY",
        status="ACTIVE",
    )
    acc2 = FinancialAccount(
        id=uuid4(),
        user_uuid=user_uuid,
        name="Bank",
        type="DEPOSIT",
        nature="ASSET",
        initial_balance=Decimal("1000.0"),
        current_balance=Decimal("1000.0"),
        currency_code="CNY",
        status="ACTIVE",
    )

    db_session.add_all([acc1, acc2])
    await db_session.commit()

    # Action
    service = AccountService(db_session)
    accounts = await service.list_user_accounts(user_uuid)

    # Assert
    assert len(accounts) == 2
    names = {a.name for a in accounts}
    assert "Cash" in names
    assert "Bank" in names


@pytest.mark.asyncio
async def test_get_account_by_id(db_session):
    # Setup
    user_uuid = uuid4()
    user = User(uuid=user_uuid, username="u2", email="u2@e.com", password="pwd", registration_type="email")
    db_session.add(user)
    await db_session.commit()

    acc_id = uuid4()
    acc = FinancialAccount(
        id=acc_id,
        user_uuid=user_uuid,
        name="Test Acc",
        type="CASH",
        nature="ASSET",
        initial_balance=Decimal("50.0"),
        current_balance=Decimal("50.0"),
        currency_code="USD",
        status="ACTIVE",
    )
    db_session.add(acc)
    await db_session.commit()

    # Action
    service = AccountService(db_session)
    fetched = await service.get_account_by_id(acc_id, user_uuid)

    # Assert
    assert fetched is not None
    assert fetched.id == acc_id
    assert fetched.name == "Test Acc"
