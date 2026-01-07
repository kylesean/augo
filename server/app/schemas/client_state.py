"""Client State Mutation Schema

定义客户端允许操作的状态子集，用于 GenUI 原子模式。
这是 Client 与 Server 共享 StateGraph 的协议契约。
"""

from __future__ import annotations

from typing import Any, Literal

from pydantic import BaseModel, Field


class ClientStateMutation(BaseModel):
    """客户端状态突变

    GenUI 原子模式协议：
    - Client 在消息请求中附带 state mutation
    - Server 在图执行前原子性地应用 mutation

    设计原则：
    1. 白名单制：只有显式定义的字段才能被 Client 修改
    2. 类型安全：严格的 Pydantic 验证
    3. 可扩展：新增工具只需传入 tool_name

    Attributes:
        ui_mode: 控制图入口路由
        tool_name: 要直接执行的内部工具名
        tool_params: 工具参数
    """

    ui_mode: Literal["idle", "direct_execute"] | None = Field(
        default=None, description="UI 模式：idle=走 agent，direct_execute=跳过 LLM 直接执行工具"
    )
    tool_name: str | None = Field(default=None, description="要直接执行的工具名（需在内部工具注册表中）")
    tool_params: dict[str, Any] | None = Field(default=None, description="工具参数，ui_mode=direct_execute 时必须提供")

    model_config = {"extra": "ignore"}

    def to_state_dict(self) -> dict:
        """转换为可合并到 AgentState 的字典

        只包含非 None 的字段，避免覆盖已有状态。
        """
        result: dict[str, Any] = {}
        if self.ui_mode is not None:
            result["ui_mode"] = self.ui_mode
        if self.tool_name is not None:
            result["tool_name"] = self.tool_name
        if self.tool_params is not None:
            result["tool_params"] = self.tool_params
        return result
