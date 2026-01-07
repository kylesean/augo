"""EventGenerator - 纯事件生成器（原 GenUIAdapter 重构）

职责：
- 将 LangGraph 流事件转换为 GenUI 协议事件
- 不包含策略决策逻辑（已移至 RenderPolicy, TextFilterPolicy）
- 不包含组件检测逻辑（已移至 ComponentDetector）

设计原则：
- 单一职责：只负责事件格式转换
- 无状态：尽可能减少内部状态追踪
"""

import json
import time
import uuid
from datetime import datetime, timezone
from typing import Any, AsyncGenerator

from langchain_core.messages import AIMessage, ToolMessage

from app.core.langgraph.stream.component_detector import ComponentDetector
from app.core.logging import logger
from app.schemas.genui import GenUIEvent


class EventGenerator:
    """GenUI 事件生成器

    将 LangGraph 流输出转换为 GenUI 协议事件。

    职责边界：
    - 事件格式转换
    - Surface ID 生成
    - 时间戳追踪
    - 渲染策略决策 (RenderPolicy)
    - 文本过滤决策 (TextFilterPolicy)
    """

    def __init__(self) -> None:
        # 工具调用时间追踪（用于计算 duration_ms）
        self._tool_start_times: dict[str, float] = {}
        # 工具 ID 到名称的映射
        self._tool_id_to_name: dict[str, str] = {}
        # 已处理的工具调用 ID（避免重复发送 tool_call_start）
        self._processed_tool_calls: set[str] = set()
        # 流式 AI 回复积累（用于历史记录）
        self._ai_response_parts: list[str] = []

    def reset(self) -> None:
        """重置状态（每次新请求前调用）"""
        self._tool_start_times.clear()
        self._tool_id_to_name.clear()
        self._processed_tool_calls.clear()
        self._ai_response_parts.clear()

    def get_collected_response(self) -> str:
        """获取积累的 AI 回复文本"""
        return "".join(self._ai_response_parts)

    # =========================================================================
    # 消息流事件生成
    # =========================================================================

    async def process_message_chunk(
        self,
        chunk: tuple,
        session_id: str,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """处理 messages 模式的流块

        Args:
            chunk: (message_chunk, metadata) 元组
            session_id: 会话 ID

        Yields:
            GenUIEvent 事件
        """
        msg_chunk, metadata = chunk
        # msg_chunk.content contains the message part

        # 跳过 ToolMessage（在 updates 模式处理）
        if isinstance(msg_chunk, ToolMessage):
            return

        # 1. 处理文本内容
        if msg_chunk.content:
            async for event in self._process_text_content(msg_chunk.content):
                yield event

        # 2. 处理工具调用意图
        if isinstance(msg_chunk, AIMessage) and hasattr(msg_chunk, "tool_call_chunks"):
            tool_chunks = getattr(msg_chunk, "tool_call_chunks", None)
            if tool_chunks:
                async for event in self._process_tool_call_chunks(
                    tool_chunks,
                    session_id,
                ):
                    yield event

    async def _process_text_content(
        self,
        content: Any,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """处理文本内容"""
        if isinstance(content, str):
            if content:
                self._ai_response_parts.append(content)
                yield GenUIEvent(type="text_delta", content=content)

        elif isinstance(content, list):
            for item in content:
                if isinstance(item, dict):
                    item_type = item.get("type")
                    item_text = item.get("text", "")

                    if item_type == "text" and item_text:
                        self._ai_response_parts.append(item_text)
                        yield GenUIEvent(type="text_delta", content=item_text)

                    elif item_type == "reasoning_content" and item_text:
                        yield GenUIEvent(
                            type="reasoning_delta",
                            content=item_text,
                            metadata={"status": "thinking"},
                        )

                elif isinstance(item, str):
                    self._ai_response_parts.append(item)
                    yield GenUIEvent(type="text_delta", content=item)

    async def _process_tool_call_chunks(
        self,
        tool_call_chunks: list[dict],
        session_id: str,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """处理工具调用块

        发送 tool_call_start 事件通知客户端工具开始执行
        """
        # 临时存储活跃的工具调用
        active_calls: dict[int, dict[str, Any]] = {}

        for tc_chunk in tool_call_chunks:
            index = tc_chunk.get("index")
            if index is None:
                continue

            if index not in active_calls:
                active_calls[index] = {"id": None, "name": None}

            curr = active_calls[index]
            if tc_chunk.get("id"):
                curr["id"] = tc_chunk["id"]
            if tc_chunk.get("name"):
                curr["name"] = tc_chunk["name"]

            tool_id = curr["id"]
            tool_name = curr["name"]

            # 首次看到完整的工具调用
            if tool_id and tool_name and tool_id not in self._processed_tool_calls:
                self._processed_tool_calls.add(tool_id)
                self._tool_start_times[tool_id] = time.time()
                self._tool_id_to_name[tool_id] = tool_name

                # 发送 tool_call_start 事件（所有工具都发送）
                yield GenUIEvent(
                    type="tool_call_start",
                    data={
                        "id": tool_id,
                        "name": tool_name,
                        "timestamp": datetime.now(timezone.utc).isoformat(),
                    },
                )

    # =========================================================================
    # 更新流事件生成
    # =========================================================================

    async def process_updates_chunk(
        self,
        chunk: dict[str, Any],
        session_id: str,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """处理 updates 模式的流块

        Args:
            chunk: {node_name: node_output} 字典
            session_id: 会话 ID

        Yields:
            GenUIEvent 事件
        """
        from app.core.genui_protocol import (
            BeginRendering,
            BeginRenderingPayload,
            Component,
            SurfaceUpdate,
            SurfaceUpdatePayload,
        )

        for node_name, node_output in chunk.items():
            if node_name.startswith("__"):
                continue

            # ============================================================
            # 处理 direct_execute 节点
            # ============================================================
            if node_name == "direct_execute":
                result_data = node_output.get("direct_execute_result")
                if result_data and result_data.get("success"):
                    async for event in self._emit_component_events(
                        tool_result=result_data.get("data", {}),
                        tool_name=result_data.get("tool_name", ""),
                        session_id=session_id,
                        tool_call_id=None,  # direct_execute 没有 tool_call_id
                    ):
                        yield event
                continue

            # ============================================================
            # 处理 tools 节点
            # ============================================================
            if node_name == "tools":
                async for event in self._process_tools_node(node_output, session_id):
                    yield event

    async def _process_tools_node(
        self,
        node_output: Any,
        session_id: str,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """处理 tools 节点输出"""
        messages = []
        if isinstance(node_output, dict):
            messages = node_output.get("messages", [])
        elif isinstance(node_output, list):
            messages = node_output

        for msg in messages:
            if not self._is_tool_message(msg):
                continue

            tool_name, tool_call_id = self._extract_tool_info(msg)

            # 计算执行时长
            duration_ms = self._calculate_duration(tool_call_id)

            # 提取工具结果
            tool_result = self._extract_tool_result(msg)

            # 发送 tool_call_end 事件
            is_success = ComponentDetector.is_successful_result(tool_result)
            yield GenUIEvent(
                type="tool_call_end",
                data={
                    "id": tool_call_id or f"call_{tool_name}",
                    "name": tool_name,
                    "status": "success" if is_success else "error",
                    "duration_ms": duration_ms,
                    "result": json.dumps(tool_result, indent=2, ensure_ascii=False)
                    if isinstance(tool_result, dict)
                    else str(tool_result),
                    "error": tool_result.get("error") if isinstance(tool_result, dict) else None,
                },
            )

            # 发送 UI 组件事件
            async for event in self._emit_component_events(
                tool_result=tool_result,
                tool_name=tool_name,
                session_id=session_id,
                tool_call_id=tool_call_id,
            ):
                yield event

    async def _emit_component_events(
        self,
        tool_result: Any,
        tool_name: str,
        session_id: str,
        tool_call_id: str | None,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """生成 UI 组件事件（a2ui_message）"""
        from app.core.genui_protocol import (
            BeginRendering,
            BeginRenderingPayload,
            Component,
            SurfaceUpdate,
            SurfaceUpdatePayload,
        )

        # 使用 ComponentDetector 检测组件类型
        component_name = ComponentDetector.detect_with_overrides(tool_result, tool_name)

        # 调试日志：检查组件检测结果
        logger.debug(
            "component_detection",
            tool_name=tool_name,
            detected_component=component_name,
            has_component_type="componentType" in tool_result if isinstance(tool_result, dict) else False,
            result_keys=list(tool_result.keys()) if isinstance(tool_result, dict) else None,
        )

        if not component_name:
            return

        if not ComponentDetector.is_successful_result(tool_result):
            return

        # 生成 Surface ID 和 Component ID
        # 使用 tool_call_id 确保 surface ID 的唯一性和可追踪性
        if not tool_call_id:
            logger.warning(
                "missing_tool_call_id_for_component",
                tool_name=tool_name,
                component=component_name,
            )
            tool_call_id = uuid.uuid4().hex[:8]

        surface_id = f"surface_{session_id}_{tool_call_id}"
        component_id = f"comp_{tool_call_id}"

        logger.info(
            "emitting_genui_component",
            tool_name=tool_name,
            component=component_name,
            tool_call_id=tool_call_id,
            surface_id=surface_id,
        )

        # 注入 _surfaceId 到组件数据
        component_data = {**tool_result, "_surfaceId": surface_id}

        # 发送 SurfaceUpdate
        comp = Component(id=component_id, component={component_name: component_data})
        update_msg = SurfaceUpdate(surfaceUpdate=SurfaceUpdatePayload(surfaceId=surface_id, components=[comp]))
        yield GenUIEvent(type="a2ui_message", data=update_msg.model_dump())

        # 发送 BeginRendering
        render_msg = BeginRendering(beginRendering=BeginRenderingPayload(surfaceId=surface_id, root=component_id))
        yield GenUIEvent(type="a2ui_message", data=render_msg.model_dump())

    # =========================================================================
    # 辅助方法
    # =========================================================================

    def _is_tool_message(self, msg: Any) -> bool:
        """检查是否是 ToolMessage"""
        return isinstance(msg, ToolMessage) or (isinstance(msg, dict) and msg.get("role") == "tool")

    def _extract_tool_info(self, msg: Any) -> tuple[str, str | None]:
        """从消息中提取工具信息"""
        if isinstance(msg, dict):
            return msg.get("name", ""), msg.get("tool_call_id")
        return getattr(msg, "name", ""), getattr(msg, "tool_call_id", None)

    def _extract_tool_result(self, msg: Any) -> Any:
        """提取工具执行结果"""
        # 优先从 artifact 获取
        tool_result = getattr(msg, "artifact", None)
        if tool_result is None and isinstance(msg, dict):
            tool_result = msg.get("artifact")

        if tool_result is not None:
            return tool_result

        # 从 content 解析
        msg_content = getattr(msg, "content", None)
        if msg_content is None and isinstance(msg, dict):
            msg_content = msg.get("content", "")

        if isinstance(msg_content, dict):
            return msg_content
        elif isinstance(msg_content, str):
            try:
                return json.loads(msg_content)
            except (json.JSONDecodeError, TypeError):
                return {"result": msg_content}
        else:
            return {"result": str(msg_content)}

    def _calculate_duration(self, tool_call_id: str | None) -> int | None:
        """计算工具执行时长（毫秒）"""
        if not tool_call_id:
            return None
        start_time = self._tool_start_times.pop(tool_call_id, None)
        if start_time:
            return int((time.time() - start_time) * 1000)
        return None
