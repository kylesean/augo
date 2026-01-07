#!/usr/bin/env python3
"""Intelligent Prepare Transfer Script
- Validates amount
- Fuzzy matches accounts based on user hints
- Pre-populates GenUI component
"""
from __future__ import annotations

import asyncio
import json
import logging
import os
import sys
from io import StringIO
from pathlib import Path
from typing import Any
from uuid import UUID

# CRITICAL: Suppress ALL output during imports
# This prevents print() and log messages from polluting the JSON stdout
logging.disable(logging.CRITICAL)
os.environ["LOG_LEVEL"] = "CRITICAL"

# Capture stdout during imports
_original_stdout = sys.stdout
sys.stdout = StringIO()

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent.parent.parent))

# Now import app modules (all output will be captured and discarded)
from app.core.database import db_manager  # noqa: E402  # noqa: E402
from app.services.account_service import AccountService  # noqa: E402

# Restore stdout
sys.stdout = _original_stdout


def fuzzy_match_account(accounts: list[Any], hint: str) -> list[str]:
    """Find account IDs that match the given hint (name or type)."""
    if not hint:
        return []

    hint = hint.lower().strip()
    matches = []

    for acc in accounts:
        name = acc.name.lower()
        acc_type = (acc.type or "").lower()
        # Match name or type
        if hint in name or hint in acc_type:
            matches.append(str(acc.id))

    return matches


async def main() -> None:
    """Execution entry point for the skill script."""
    user_uuid_str = os.environ.get("USER_ID")
    if not user_uuid_str:
        print(json.dumps({"success": False, "error": "USER_ID not set"}))
        sys.exit(1)

    # 1. Parse Arguments (Support both CLI flags and stdin)
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--amount", type=float)
    parser.add_argument("--source_hint", type=str)
    parser.add_argument("--target_hint", type=str)
    parser.add_argument("--memo", type=str)
    args, unknown = parser.parse_known_args()

    options = {}

    # Priority 1: CLI Arguments
    if args.amount is not None:
        options["amount"] = args.amount
    if args.source_hint:
        options["source_hint"] = args.source_hint
    if args.target_hint:
        options["target_hint"] = args.target_hint
    if args.memo:
        options["memo"] = args.memo

    # Priority 2: stdin (JSON)
    if not sys.stdin.isatty():
        try:
            stdin_data = sys.stdin.read().strip()
            if stdin_data:
                stdin_options = json.loads(stdin_data)
                # Only overwrite if CLI didn't provide it
                for k, v in stdin_options.items():
                    if k not in options or options[k] is None:
                        options[k] = v
        except Exception:
            pass

    # 2. Validate Amount (Optional now as UI provides input)
    amount = options.get("amount", 0.0)
    if isinstance(amount, (int, float, str)):
        try:
            amount = float(amount)
        except (ValueError, TypeError):
            amount = 0.0

    # We no longer block on amount <= 0 here because the UI will have an input field.
    # However, we still pass it along if the AI identified it.

    # 2. Extract Hints
    source_hint = options.get("source_hint") or options.get("source_account")
    target_hint = options.get("target_hint") or options.get("target_account")

    try:
        async with db_manager.session_factory() as session:
            account_service = AccountService(session)
            # Fetch ALL active accounts (we'll filter ASSETS in Python for more control)
            all_accounts = await account_service.list_user_accounts(UUID(user_uuid_str))

            # 1. Filter Asset Accounts Only
            asset_accounts = [acc for acc in all_accounts if acc.nature == "ASSET"]

            # 2. AUDIT FAILURES
            if not asset_accounts:
                print(
                    json.dumps(
                        {
                            "success": False,
                            "error_type": "NO_ACCOUNTS",
                            "message": "User has no asset accounts. Cannot perform transfer.",
                        }
                    )
                )
                return

            if len(asset_accounts) == 1:
                print(
                    json.dumps(
                        {
                            "success": False,
                            "error_type": "SINGLE_ACCOUNT",
                            "account_name": asset_accounts[0].name,
                            "message": f"User only has one asset account: {asset_accounts[0].name}. Transfer requires at least two.",
                        }
                    )
                )
                return

            # Formatting accounts for UI
            formatted_accounts = []
            for acc in asset_accounts:
                formatted_accounts.append(
                    {
                        "id": str(acc.id),
                        "name": acc.name,
                        "type": acc.type or "UNKNOWN",
                        "balance": float(acc.current_balance),
                        "currency": acc.currency_code or "CNY",
                    }
                )

            # 3. Intelligent Selection Logic
            suggested_source_id = options.get("source_account_id")
            suggested_target_id = options.get("target_account_id")

            # Try to match source if not explicitly provided by ID
            if not suggested_source_id and source_hint:
                matches = fuzzy_match_account(asset_accounts, source_hint)
                if len(matches) == 1:
                    suggested_source_id = matches[0]

            # Try to match target if not explicitly provided by ID
            if not suggested_target_id and target_hint:
                matches = fuzzy_match_account(asset_accounts, target_hint)
                if len(matches) == 1:
                    suggested_target_id = matches[0]

            # Final output structure - use camelCase for GenUI consistency
            output = {
                "success": True,
                "componentType": "TransferWizard",  # RENAMED from TransferPathBuilder
                "sourceAccounts": formatted_accounts,
                "targetAccounts": formatted_accounts,
                "preselectedSourceId": suggested_source_id,
                "preselectedTargetId": suggested_target_id,
                "amount": max(0.0, amount),
                "memo": options.get("memo", ""),
                "currency": options.get("currency", "CNY"),
            }

            print(json.dumps(output, ensure_ascii=False))

    except Exception as e:
        print(
            json.dumps({"success": False, "error": str(e), "message": "Failed to audit accounts and prepare transfer"})
        )
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
