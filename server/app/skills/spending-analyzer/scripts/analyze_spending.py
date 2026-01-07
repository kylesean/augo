#!/usr/bin/env python3
"""Budget Analysis Script - Spending Pattern Analysis

Directly queries the database to analyze spending patterns and suggest budgets.
Follows AgentSkills.io best practice: scripts access data directly via DB.

Usage:
    python app/skills/budget-expert/scripts/analyze_budget.py

    Or with options via stdin JSON:
    echo '{"days": 90, "category": "FOOD_DINING"}' | python analyze_budget.py

Environment:
    USER_ID: Required. User UUID (injected by bash tool).

Output (JSON):
    {
        "success": true,
        "componentType": "BudgetAnalysisCard",
        "by_category": {...},
        "trends": {...},
        "top_spenders": [...],
        "suggestions": [...],
        "total_expense": 0.0,
        "period_days": 90
    }

Note:
    - All category names are returned as keys (e.g., "FOOD_DINING")
    - Frontend GenUI components handle localization via i18n
    - LLM generates localized text responses based on SKILL.md rules
"""

from __future__ import annotations

import asyncio
import json
import os
import sys
from collections import defaultdict
from datetime import datetime, timedelta
from decimal import Decimal
from pathlib import Path
from typing import Any, cast

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent.parent.parent))

from uuid import UUID

from app.core.database import db_manager  # noqa: E402
from app.services.transaction_query_service import (  # noqa: E402
    TransactionQueryParams,
    TransactionQueryService,
)


def analyze_spending(transactions: list[dict[str, Any]], days: int = 90) -> dict:
    """Analyze spending patterns from transaction records.

    Returns structured data only - no localized text.
    """
    if not transactions:
        return {
            "by_category": {},
            "by_month": {},
            "trends": {},
            "top_spenders": [],
            "suggestions": [],
            "total_expense": 0,
        }

    # Group by category and month
    by_category: dict[str, dict[str, Any]] = defaultdict(
        lambda: {"total": Decimal("0"), "count": 0, "transactions": []}
    )
    by_month: dict[str, dict[str, Any]] = defaultdict(lambda: {"total": Decimal("0"), "count": 0})

    all_expenses = []

    for tx in transactions:
        if tx.get("type", "").upper() != "EXPENSE":
            continue

        amount = Decimal(str(tx.get("amount", 0)))
        category = tx.get("category_key", "OTHERS")
        tx_date = tx.get("transaction_at", tx.get("created_at", ""))[:10]
        month = tx_date[:7] if tx_date else "unknown"

        by_category[category]["total"] += amount
        by_category[category]["count"] += 1
        by_category[category]["transactions"].append(
            {
                "amount": float(amount),
                "date": tx_date,
                "description": tx.get("description", ""),
            }
        )

        by_month[month]["total"] += amount
        by_month[month]["count"] += 1

        all_expenses.append(
            {
                "amount": float(amount),
                "category": category,
                "description": tx.get("description", ""),
                "date": tx_date,
            }
        )

    # Calculate totals and trends
    total_expense = sum((c["total"] for c in by_category.values()), Decimal("0"))

    # Format category breakdown
    category_breakdown = {}
    for cat, data in by_category.items():
        pct = float(data["total"] / total_expense * 100) if total_expense > 0 else 0
        category_breakdown[cat] = {
            "total": float(data["total"]),
            "count": data["count"],
            "percentage": round(pct, 1),
            "avg_per_tx": float(data["total"] / data["count"]) if data["count"] > 0 else 0,
        }

    # Monthly trends
    months = sorted(by_month.keys())
    month_data = {m: {"total": float(by_month[m]["total"]), "count": by_month[m]["count"]} for m in months}

    # Trend calculation
    trends = {}
    if len(months) >= 2:
        last_month = cast(Decimal, by_month[months[-1]]["total"])
        prev_month = cast(Decimal, by_month[months[-2]]["total"])
        change = last_month - prev_month
        change_pct = float(change / prev_month * 100) if prev_month > 0 else 0
        trends["month_over_month"] = {
            "change_amount": float(change),
            "change_percent": round(change_pct, 1),
            "direction": "up" if change > 0 else "down" if change < 0 else "flat",
        }

    # Top spenders
    top_spenders = sorted(all_expenses, key=lambda x: x["amount"], reverse=True)[:5]

    # Generate suggestions (structured data, not localized text)
    suggestions = []
    sorted_cats = sorted(category_breakdown.items(), key=lambda x: x[1]["total"], reverse=True)

    if sorted_cats:
        top_cat = sorted_cats[0]
        if top_cat[1]["percentage"] > 40:
            suggestions.append(
                {"type": "high_percentage", "category_key": top_cat[0], "percentage": top_cat[1]["percentage"]}
            )

    if trends.get("month_over_month", {}).get("direction") == "up":
        pct = float(trends["month_over_month"]["change_percent"])
        if pct > 20:
            suggestions.append({"type": "monthly_increase", "percentage": pct})

    # Find high-frequency small expenses
    small_frequent: dict[str, int] = defaultdict(int)
    for tx in all_expenses:
        if tx["amount"] < 50:
            small_frequent[tx["category"]] += 1

    for cat, count in small_frequent.items():
        if count >= 10:
            suggestions.append({"type": "frequent_small", "category_key": cat, "count": count})

    return {
        "by_category": category_breakdown,
        "by_month": month_data,
        "trends": trends,
        "top_spenders": top_spenders,
        "suggestions": suggestions,
        "total_expense": float(total_expense),
        "transaction_count": len(all_expenses),
        "period_days": days,
    }


async def main() -> None:
    """Execution entry point for the skill script."""
    """Main entry point."""
    user_uuid_str = os.environ.get("USER_ID")
    if not user_uuid_str:
        print(json.dumps({"success": False, "error": "USER_ID environment variable not set"}))
        sys.exit(1)

    # Parse options from stdin
    options = {}
    if not sys.stdin.isatty():
        try:
            stdin_data = sys.stdin.read().strip()
            if stdin_data:
                options = json.loads(stdin_data)
        except (json.JSONDecodeError, ValueError):
            pass

    days = options.get("days", 90)
    category = options.get("category")

    try:
        user_uuid = UUID(user_uuid_str)

        end_date = datetime.now().date()
        start_date = end_date - timedelta(days=days)

        async with db_manager.session_factory() as session:
            service = TransactionQueryService(session)

            params = TransactionQueryParams(
                start_date=start_date.isoformat(),
                end_date=end_date.isoformat(),
                transaction_types=["EXPENSE"],
                per_page=100,
            )

            if category:
                params.category_keys = [category]

            result = await service.search(str(user_uuid), params)

            # Convert to dict format
            transactions = []
            for item in result.items:
                transactions.append(
                    {
                        "transaction_at": item.created_at,
                        "amount": item.amount_original,
                        "type": item.type,
                        "category_key": item.category_key,
                        "description": item.description,
                    }
                )

            # Analyze (returns structured data only)
            analysis = analyze_spending(transactions, days)

            output = {
                "success": True,
                "componentType": "BudgetAnalysisCard",
                "title": "消费支出分析",  # 显式指定标题，解决职责正交化后的语意对齐
                **analysis,
            }

            print(json.dumps(output, ensure_ascii=False, indent=2))

    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}, ensure_ascii=False))
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
