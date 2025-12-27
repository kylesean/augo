#!/usr/bin/env python3
"""List all shared spaces available to the user."""

import asyncio
import json
import os
import sys
from pathlib import Path

# 将项目根目录加入路径，以便导入 app
sys.path.append(str(Path(__file__).parent.parent.parent.parent.parent))

from uuid import UUID

from app.core.database import db_manager  # noqa: E402  # noqa: E402
from app.services.shared_space_service import SharedSpaceService  # noqa: E402


async def main():
    """Execution entry point for the skill script."""
    # 从环境变量获取身份（由 SkillMiddleware 注入）
    user_uuid_str = os.environ.get("USER_ID")
    if not user_uuid_str:
        print(json.dumps({"success": False, "error": "User context missing"}))
        return

    try:
        user_uuid = UUID(user_uuid_str)
        async with db_manager.session_factory() as session:
            service = SharedSpaceService(session)
            result = await service.get_user_spaces(user_uuid)

            # get_user_spaces 返回的是 {"spaces": [...], "total": ...}
            spaces = result.get("spaces", []) if result else []

            print(json.dumps({"success": True, "spaces": spaces}))
    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}))


if __name__ == "__main__":
    asyncio.run(main())
