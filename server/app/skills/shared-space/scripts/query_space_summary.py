#!/usr/bin/env python3
"""Query summary of a shared space or all spaces for the user.

Usage:
    # 查询所有空间的汇总
    python app/skills/shared-space/scripts/query_space_summary.py

    # 查询指定空间的汇总
    echo '{"space_id": 123}' | python app/skills/shared-space/scripts/query_space_summary.py
"""

import asyncio
import json
import os
import sys
from datetime import UTC, datetime
from pathlib import Path

# 将项目根目录加入路径
sys.path.append(str(Path(__file__).parent.parent.parent.parent.parent))

from uuid import UUID

from sqlalchemy import func, select

from app.core.database import db_manager  # noqa: E402  # noqa: E402
from app.services.shared_space_service import SharedSpaceService  # noqa: E402


async def main() -> None:
    """Execution entry point for the skill script."""
    # 从环境变量获取用户身份
    user_uuid_str = os.environ.get("USER_ID")
    if not user_uuid_str:
        print(json.dumps({"success": False, "error": "User context missing"}))
        return

    # 非阻塞检测 stdin 是否有数据
    space_id = None
    import select as select_mod

    if select_mod.select([sys.stdin], [], [], 0.0)[0]:
        try:
            stdin_data = sys.stdin.read().strip()
            if stdin_data:
                params = json.loads(stdin_data)
                space_id = params.get("space_id")
        except (json.JSONDecodeError, ValueError):
            pass

    try:
        user_uuid = UUID(user_uuid_str)
        async with db_manager.session_factory() as session:
            service = SharedSpaceService(session)

            # 获取用户的所有空间
            spaces_result = await service.get_user_spaces(user_uuid)
            spaces = spaces_result.get("spaces", []) if spaces_result else []

            if not spaces:
                print(json.dumps({"success": True, "message": "你还没有加入任何共享空间", "spaces": [], "total": 0}))
                return

            # 如果指定了 space_id，只查询该空间
            if space_id:
                spaces = [s for s in spaces if str(s.get("id")) == str(space_id)]
                if not spaces:
                    print(json.dumps({"success": False, "error": f"未找到 ID 为 {space_id} 的共享空间"}))
                    return

            # 为每个空间计算统计数据

            from app.models.shared_space import SpaceTransaction
            from app.models.transaction import Transaction

            summaries = []
            for space in spaces:
                sid = space.get("id")

                # 查询该空间本月的交易统计
                now = datetime.now(UTC)
                month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

                # 查询本月总支出
                stmt = (
                    select(
                        func.coalesce(func.sum(Transaction.amount), 0).label("total_expense"),
                        func.count(Transaction.id).label("transaction_count"),
                    )
                    .join(SpaceTransaction, Transaction.id == SpaceTransaction.transaction_id)
                    .where(
                        SpaceTransaction.space_id == sid,
                        Transaction.transaction_at >= month_start,
                        Transaction.type == "EXPENSE",
                    )
                )
                result = await session.execute(stmt)
                stats = result.first()

                if stats:
                    total_expense = float(stats.total_expense or 0)
                    tx_count = stats.transaction_count or 0
                else:
                    total_expense = 0.0
                    tx_count = 0

                summaries.append(
                    {
                        "id": str(sid),
                        "name": space.get("name"),
                        "role": space.get("role"),
                        "thisMonth": {
                            "totalExpense": total_expense,
                            "transactionCount": tx_count,
                            "period": f"{now.year}年{now.month}月",
                        },
                    }
                )

            print(
                json.dumps(
                    {
                        "success": True,
                        "spaces": summaries,
                        "total": len(summaries),
                        "query_time": datetime.now(UTC).isoformat(),
                    },
                    ensure_ascii=False,
                )
            )

    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}))


if __name__ == "__main__":
    asyncio.run(main())
