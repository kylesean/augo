from datetime import UTC, date, datetime, timedelta, timezone
from decimal import Decimal
from uuid import uuid4

import pytest

from app.models.budget import Budget, BudgetPeriod, BudgetPeriodStatus, BudgetPeriodType, BudgetScope, BudgetStatus
from app.models.transaction import Transaction
from app.models.user import User
from app.schemas.budget import BudgetCreateRequest
from app.services.budget_service import BudgetService


@pytest.mark.asyncio
async def test_create_budget(db_session):
    # 1. Setup User
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="budget_user", email="budget@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    # 2. Setup Service
    service = BudgetService(db_session)

    # 3. Create Budget
    request = BudgetCreateRequest(
        name="Food Budget",
        amount=1000.0,
        scope="CATEGORY",
        category_key="FOOD",
        period_type="MONTHLY",
        currency_code="CNY",
    )

    budget = await service.create_budget(user_uuid, request)

    # 4. Verify Budget Created
    assert budget is not None
    assert budget.name == "Food Budget"
    assert budget.amount == Decimal("1000.0")
    assert budget.owner_uuid == user_uuid

    # 5. Verify Initial Period Created
    # We need to refresh/load periods because create_budget commits internally
    await db_session.refresh(budget, ["periods"])
    assert len(budget.periods) == 1

    period = budget.periods[0]
    assert period.adjusted_target == Decimal("1000.0")
    assert period.status == BudgetPeriodStatus.ON_TRACK.value

    # Check if period covers today
    today = date.today()
    assert period.period_start <= today <= period.period_end


@pytest.mark.asyncio
async def test_calculate_spent_amount(db_session):
    # 1. Setup User
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="spender", email="spender@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    # 2. Create Transactions (2 expenses in FOOD, 1 in TRANSPORT)
    today = datetime.now(UTC)

    t1 = Transaction(
        id=uuid4(),
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("50.0"),
        amount_original=Decimal("50.0"),
        currency="CNY",
        transaction_at=today,
        category_key="FOOD",
        status="CLEARED",
        raw_input="lunch",
    )
    t2 = Transaction(
        id=uuid4(),
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("30.0"),
        amount_original=Decimal("30.0"),
        currency="CNY",
        transaction_at=today,
        category_key="FOOD",
        status="CLEARED",
        raw_input="snack",
    )
    t3 = Transaction(  # Different category
        id=uuid4(),
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("20.0"),
        amount_original=Decimal("20.0"),
        currency="CNY",
        transaction_at=today,
        category_key="TRANSPORT",
        status="CLEARED",
        raw_input="bus",
    )
    # Income shouldn't count
    t4 = Transaction(
        id=uuid4(),
        user_uuid=user_uuid,
        type="INCOME",
        amount=Decimal("1000.0"),
        amount_original=Decimal("1000.0"),
        currency="CNY",
        transaction_at=today,
        category_key="SALARY",
        status="CLEARED",
        raw_input="salary",
    )

    db_session.add_all([t1, t2, t3, t4])
    await db_session.commit()

    # 3. Test Calculation
    service = BudgetService(db_session)

    # Calculate for FOOD
    start_date = today.date()
    end_date = today.date()

    spent_food = await service.calculate_spent_amount(user_uuid, start_date, end_date, category_key="FOOD")
    assert spent_food == Decimal("80.0")  # 50 + 30

    # Calculate Total (all categories)
    spent_total = await service.calculate_spent_amount(user_uuid, start_date, end_date, category_key=None)
    assert spent_total == Decimal("100.0")  # 50 + 30 + 20


@pytest.mark.asyncio
async def test_update_period_status(db_session):
    # 1. Setup User and Budget
    user_uuid = uuid4()
    user = User(
        uuid=user_uuid, username="status_user", email="status@example.com", password="hash", registration_type="email"
    )
    db_session.add(user)
    await db_session.commit()

    service = BudgetService(db_session)
    request = BudgetCreateRequest(name="Small Budget", amount=100.0, scope="CATEGORY", category_key="TEST")
    budget = await service.create_budget(user_uuid, request)
    await db_session.refresh(budget, ["periods"])
    period = budget.periods[0]

    # 2. Add transaction that exceeds budget
    tx = Transaction(
        id=uuid4(),
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("150.0"),
        amount_original=Decimal("150.0"),
        currency="CNY",
        transaction_at=datetime.now(UTC),
        category_key="TEST",
        status="CLEARED",
        raw_input="big expense",
    )
    db_session.add(tx)
    await db_session.commit()

    # 3. Update Period
    updated_period = await service.update_period_spent_amount(budget, period)

    # 4. Verify Status
    assert updated_period.spent_amount == Decimal("150.0")
    assert updated_period.status == BudgetPeriodStatus.EXCEEDED.value
