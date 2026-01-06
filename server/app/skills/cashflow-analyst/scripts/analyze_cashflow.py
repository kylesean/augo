#!/usr/bin/env python3
"""Finance Analysis Script - Cash Flow and Health Scoring

This script uses StatisticsService to analyze user's financial health.
It follows AgentSkills.io best practice: scripts call services for data.

Usage:
    uv run python app/skills/finance-analyst/scripts/analyze_finance.py --days 90

Environment:
    USER_ID: Required. User UUID (injected by execute tool).

Output (JSON):
    {
        "success": true,
        "type": "CashFlowCard",  # GenUI component type
        ...data fields...
    }

Note:
    No aiInsight field - LLM generates insights in user's language.
"""

import argparse
import asyncio
import json
import os
import sys
from datetime import date, datetime
from pathlib import Path
from uuid import UUID


def json_serializer(obj):
    """JSON serializer for objects not serializable by default."""
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError(f"Type {type(obj)} not serializable")


# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent.parent.parent))

from app.core.database import db_manager  # noqa: E402  # noqa: E402
from app.services.statistics_service import StatisticsService  # noqa: E402


def time_range_to_days(time_range: str) -> int:
    """Convert time_range string to days."""
    mapping = {
        "week": 7,
        "month": 30,
        "quarter": 90,
        "year": 365,
    }
    return mapping.get(time_range, 30)


def days_to_time_range(days: int) -> str:
    """Convert days to time_range string."""
    if days <= 7:
        return "week"
    elif days <= 30:
        return "month"
    elif days <= 90:
        return "quarter"
    else:
        return "year"


async def main():
    """Execution entry point for the skill script."""
    parser = argparse.ArgumentParser(description="Analyze financial health")
    parser.add_argument("--days", type=int, default=90, help="Analysis period in days")
    args = parser.parse_args()

    # Get user ID from environment
    user_id = os.environ.get("USER_ID")
    if not user_id:
        print(json.dumps({"success": False, "error": "USER_ID environment variable not set"}, ensure_ascii=False))
        sys.exit(1)

    try:
        user_uuid = UUID(user_id)
        time_range = days_to_time_range(args.days)

        async with db_manager.session_factory() as session:
            service = StatisticsService(session)

            # Get cash flow analysis
            cash_flow_obj = await service.get_cash_flow(
                user_uuid=user_uuid,
                time_range=time_range,
            )

            # Get health score
            health_score_obj = await service.get_health_score(
                user_uuid=user_uuid,
                time_range=time_range,
            )

            # Convert Pydantic objects to dicts
            cash_flow = cash_flow_obj.model_dump()
            health_score = health_score_obj.model_dump()

            # Output with GenUI signal
            # Note: No aiInsight - LLM generates insights in user's language
            output = {
                "success": True,
                # GenUI signal - CamelCase naming
                "type": "CashFlowCard",
                "title": "收支平衡与健康报告",
                # Cash flow data (for GenUI component)
                "netCashFlow": cash_flow.get("netCashFlow", 0),
                "savingsRate": cash_flow.get("savingsRate", 0),
                "totalIncome": cash_flow.get("totalIncome", 0),
                "totalExpense": cash_flow.get("totalExpense", 0),
                "expenseToIncomeRatio": cash_flow.get("expenseToIncomeRatio", 0),
                "essentialExpenseRatio": cash_flow.get("essentialExpenseRatio", 0),
                "discretionaryExpenseRatio": cash_flow.get("discretionaryExpenseRatio", 0),
                "incomeChangePercent": cash_flow.get("incomeChangePercent", 0),
                "expenseChangePercent": cash_flow.get("expenseChangePercent", 0),
                "savingsRateChange": cash_flow.get("savingsRateChange", 0),
                # Health score data
                "healthScore": health_score.get("totalScore", 0),
                "healthGrade": health_score.get("grade", "C"),
                "healthDimensions": health_score.get("dimensions", []),
                "suggestions": health_score.get("suggestions", []),
                # Raw data for LLM reference
                "analysis": cash_flow,
                "health_score": health_score,
            }

            print(json.dumps(output, ensure_ascii=False, indent=2, default=json_serializer))

    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}, ensure_ascii=False))
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
