from datetime import date, timedelta
from decimal import Decimal
from uuid import uuid4

import pytest

from app.models.financial_account import FinancialAccount
from app.models.transaction import RecurringTransaction
from app.models.user import User
from app.services.forecast_service import ForecastService


@pytest.mark.asyncio
async def test_generate_cash_flow_forecast_basic(db_session):
    # 1. Setup User
    user_uuid = uuid4()
    user = User(uuid=user_uuid, username="forecast_u", email="f@e.com", password="pwd", registration_type="email")
    db_session.add(user)

    # 2. Setup Financial Account (Asset)
    acc = FinancialAccount(
        id=uuid4(),
        user_uuid=user_uuid,
        name="Bank",
        nature="ASSET",
        initial_balance=Decimal("10000.0"),
        current_balance=Decimal("10000.0"),
        status="ACTIVE",
        include_in_net_worth=True,
    )
    db_session.add(acc)

    # 3. Setup Recurring Transaction (Rent)
    # Starts today, monthly, 2000
    rt = RecurringTransaction(
        id=uuid4(),
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("2000.0"),
        currency="CNY",
        category_key="HOUSING",
        recurrence_rule="FREQ=MONTHLY;INTERVAL=1",
        start_date=date.today(),
        is_active=True,
        amount_type="FIXED",
        requires_confirmation=False,
        timezone="UTC",
    )
    db_session.add(rt)

    await db_session.commit()

    # 4. Action
    service = ForecastService(db_session)
    result = await service.generate_cash_flow_forecast(user_uuid, forecast_days=35, include_variable_spending=False)

    # 5. Assert
    assert result.success is True
    assert result.current_balance == Decimal("10000.0")

    # Check data points
    # Today or tomorrow should have the recurring event (depending on timezone/start_date logic)
    # start_date is today. RRULE should include today.

    found_rent = False
    for dp in result.data_points:
        for event in dp.events:
            if event.event_type == "RECURRING" and event.amount == -2000.0:
                found_rent = True
                break
    assert found_rent, "Recurring rent event not found in forecast"

    # Check balance at end (should be less than start)
    # 10000 - 2000 (month 1) - 2000 (month 2 if 35 days covers it)
    final_balance = result.data_points[-1].predicted_balance
    assert final_balance < 10000


@pytest.mark.asyncio
async def test_forecast_warnings(db_session):
    # Setup poor user
    user_uuid = uuid4()
    user = User(uuid=user_uuid, username="poor_u", email="p@e.com", password="pwd", registration_type="email")
    db_session.add(user)

    # Only 100 in bank
    acc = FinancialAccount(
        id=uuid4(),
        user_uuid=user_uuid,
        name="Bank",
        nature="ASSET",
        initial_balance=Decimal("100.0"),
        current_balance=Decimal("100.0"),
        status="ACTIVE",
        include_in_net_worth=True,
    )
    db_session.add(acc)

    # Big expense coming
    rt = RecurringTransaction(
        id=uuid4(),
        user_uuid=user_uuid,
        type="EXPENSE",
        amount=Decimal("500.0"),
        currency="CNY",
        category_key="BILL",
        recurrence_rule="FREQ=DAILY;INTERVAL=1",  # Daily 500!
        start_date=date.today(),
        is_active=True,
        amount_type="FIXED",
        requires_confirmation=False,
        timezone="UTC",
    )
    db_session.add(rt)
    await db_session.commit()

    service = ForecastService(db_session)
    result = await service.generate_cash_flow_forecast(user_uuid, forecast_days=5)

    # Assert Warnings
    assert len(result.warnings) > 0
    assert any(w.warning_type == "NEGATIVE_BALANCE" for w in result.warnings)


@pytest.mark.asyncio
async def test_simulate_purchase(db_session):
    user_uuid = uuid4()
    user = User(uuid=user_uuid, username="sim_u", email="s@e.com", password="pwd", registration_type="email")
    db_session.add(user)

    acc = FinancialAccount(
        id=uuid4(),
        user_uuid=user_uuid,
        name="Bank",
        nature="ASSET",
        initial_balance=Decimal("5000.0"),
        current_balance=Decimal("5000.0"),
        status="ACTIVE",
        include_in_net_worth=True,
    )
    db_session.add(acc)
    await db_session.commit()

    service = ForecastService(db_session)

    # Simulate buying a 2000 item
    result = await service.simulate_purchase(user_uuid, Decimal("2000.0"))

    # Check for SIMULATED event
    found_sim = False
    for dp in result.data_points:
        for event in dp.events:
            if event.event_type == "SIMULATED" and abs(event.amount) == 2000.0:
                found_sim = True

    assert found_sim
