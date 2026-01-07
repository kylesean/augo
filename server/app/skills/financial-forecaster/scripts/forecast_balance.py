#!/usr/bin/env python3
"""Finance Forecast Script - Cash Flow Prediction

This script uses ForecastService to predict future cash flow.
It follows AgentSkills.io best practice: scripts call services for data.

Usage:
    uv run python app/skills/finance-analyst/scripts/forecast_finance.py --days 30
    uv run python app/skills/finance-analyst/scripts/forecast_finance.py --simulate-purchase --amount 5000 --description "Purchase"

Environment:
    USER_ID: Required. User UUID (injected by execute tool).

Output (JSON):
    {
        "success": true,
        "type": "CashFlowForecastChart",  # GenUI component type
        ...forecast data...
    }

Note:
    No aiInsight field - LLM generates insights in user's language.
"""

import argparse
import asyncio
import json
import os
import sys
from datetime import date, datetime, timedelta
from decimal import Decimal
from pathlib import Path
from typing import Any, Dict, List, Optional
from uuid import UUID


def json_serializer(obj: Any) -> Any:
    """JSON serializer for objects not serializable by default."""
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError(f"Type {type(obj)} not serializable")


# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent.parent.parent))

from app.core.database import db_manager  # noqa: E402  # noqa: E402
from app.services.forecast_service import ForecastService  # noqa: E402  # noqa: E402


async def main() -> None:
    """Execution entry point for the skill script."""
    parser = argparse.ArgumentParser(description="Forecast cash flow")
    parser.add_argument("--days", type=int, default=30, help="Forecast period in days")
    parser.add_argument("--simulate-purchase", action="store_true", help="Simulate a purchase")
    parser.add_argument("--amount", type=float, default=0, help="Purchase amount")
    parser.add_argument("--description", type=str, default="Purchase", help="Purchase description")
    args = parser.parse_args()

    # Get user ID from environment
    user_id = os.environ.get("USER_ID")
    if not user_id:
        print(json.dumps({"success": False, "error": "USER_ID environment variable not set"}, ensure_ascii=False))
        sys.exit(1)

    try:
        user_uuid = UUID(user_id)

        async with db_manager.session_factory() as session:
            service = ForecastService(session)

            if args.simulate_purchase and args.amount > 0:
                # Simulate purchase impact
                purchase_date = date.today()

                result = await service.simulate_purchase(
                    user_uuid=user_uuid,
                    amount=Decimal(str(args.amount)),
                    purchase_date=purchase_date,
                    description=args.description,
                )

                # Convert to dict
                result_dict = result.to_dict()

                # Add purchase info
                result_dict["purchase_analysis"] = {
                    "purchase_date": purchase_date.isoformat(),
                    "purchase_amount": -abs(args.amount),
                    "description": args.description,
                }

            else:
                # Standard forecast
                result = await service.generate_cash_flow_forecast(
                    user_uuid=user_uuid,
                    forecast_days=args.days,
                )

                # Convert to dict
                result_dict = result.to_dict()

            # Output with GenUI signal
            # Note: No aiInsight - LLM generates insights in user's language
            output = {
                "success": True,
                # GenUI signal - CamelCase naming
                "type": "CashFlowForecastChart",
                "title": "未来财务趋势预测",
                # Forecast data
                **result_dict,
            }

            print(json.dumps(output, ensure_ascii=False, indent=2, default=json_serializer))

    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}, ensure_ascii=False))
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
