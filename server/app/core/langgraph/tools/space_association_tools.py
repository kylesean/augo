"""Space Association Tools - Direct Execute Tools for GenUI

These tools are called directly from UI via direct_execute, bypassing LLM.
Similar to execute_transfer for transfer confirmation.
"""

from __future__ import annotations

from typing import Any
from uuid import UUID

from langchain_core.runnables import RunnableConfig
from langchain_core.tools import tool

from app.core.database import db_manager
from app.core.logging import logger


def _get_user_uuid(config: RunnableConfig) -> UUID | None:
    """Extract user UUID from configuration"""
    val = config.get("configurable", {}).get("user_uuid")
    if val is None:
        return None
    return UUID(val) if isinstance(val, str) else val


@tool("associate_transactions_to_space")
async def associate_transactions_to_space(
    transaction_ids: list[str],
    space_id: str,
    surface_id: str | None = None,
    *,
    config: RunnableConfig,
) -> dict[str, Any]:
    """Associate existing transactions with a shared space.

    This is a GenUI atomic tool - called directly from UI via direct_execute,
    bypassing LLM. Used when user selects a space from SpaceSelectorCard.

    Args:
        transaction_ids: List of transaction IDs to associate
        space_id: Target shared space ID (UUID)
        surface_id: GenUI surface ID for UI updates
        config: LangChain runnable config

    Returns:
        SpaceAssociationReceipt component data
    """
    user_uuid = _get_user_uuid(config)
    if not user_uuid:
        return {
            "success": False,
            "message": "User not authenticated",
        }

    if not transaction_ids:
        return {
            "success": False,
            "message": "No transactions to associate",
        }

    try:
        from app.services.shared_space_service import SharedSpaceService

        async with db_manager.session_factory() as session:
            service = SharedSpaceService(session)

            # Get space details first
            space_detail = await service.get_space_detail(UUID(space_id), user_uuid)
            space_name = space_detail.get("name", f"空间 {space_id}")

            # Associate each transaction
            success_count = 0
            failed_ids = []

            for tx_id in transaction_ids:
                try:
                    await service.add_transaction_to_space(
                        space_id=UUID(space_id),
                        user_uuid=user_uuid,
                        transaction_id=UUID(tx_id),
                    )
                    success_count += 1
                except Exception as e:
                    logger.warning(
                        "failed_to_associate_transaction",
                        transaction_id=tx_id,
                        space_id=space_id,
                        error=str(e),
                    )
                    failed_ids.append(tx_id)

            # Build result
            result = {
                "success": True,
                "componentType": "SpaceAssociationReceipt",
                "space": {
                    "id": space_id,
                    "name": space_name,
                },
                "association": {
                    "total_count": len(transaction_ids),
                    "success_count": success_count,
                    "failed_count": len(failed_ids),
                },
                "message": f"成功将 {success_count} 笔交易关联到「{space_name}」" if success_count > 0 else "关联失败",
            }

            if surface_id:
                result["_surfaceId"] = surface_id

            logger.info(
                "transactions_associated_to_space",
                space_id=space_id,
                success_count=success_count,
                failed_count=len(failed_ids),
            )

            return result

    except Exception as e:
        logger.error(
            "associate_transactions_to_space_failed",
            error=str(e),
            space_id=space_id,
            transaction_count=len(transaction_ids),
            exc_info=True,
        )
        return {
            "success": False,
            "message": f"关联失败: {str(e)}",
        }


# Export
space_association_tools = [associate_transactions_to_space]
