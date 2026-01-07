"""StreamProcessor - 流处理编排者

职责：
- 协调 LangGraph 流与 GenUI 事件生成
- 编排策略执行（渲染策略、文本过滤策略）
- 管理事件缓冲和释放
- 双写消息到 searchable_messages 表（全文搜索支持）

设计原则：
- 编排者模式：只负责协调，不负责具体逻辑
- 依赖注入：策略通过构造函数注入
- 开闭原则：通过更换策略扩展行为
"""

import asyncio
from collections.abc import AsyncGenerator
from typing import Any
from uuid import UUID

from app.core.langgraph.stream.event_generator import EventGenerator
from app.core.langgraph.stream.render_policy import (
    DefaultRenderPolicy,
    RenderDecision,
    RenderPolicy,
)
from app.core.langgraph.stream.text_filter_policy import (
    DefaultTextFilterPolicy,
    TextFilterPolicy,
)
from app.core.logging import logger
from app.schemas.genui import GenUIEvent
from app.services.message_index_service import message_index_service


class StreamProcessor:
    """LangGraph 流处理编排者

    负责协调 LangGraph 的多模式流输出，将其转换为 GenUI 事件。

    Architecture:
    - EventGenerator: 事件格式转换
    - RenderPolicy: 渲染决策（EMIT/BUFFER/SUPPRESS）
    - TextFilterPolicy: 文本过滤决策

    使用示例:
        processor = StreamProcessor()
        async for event in processor.process_stream(agent, input_data, config, session_id):
            yield event

        # 自定义策略
        processor = StreamProcessor(
            render_policy=CustomRenderPolicy(),
            text_filter_policy=CustomTextFilterPolicy(),
        )
    """

    def __init__(
        self,
        render_policy: RenderPolicy | None = None,
        text_filter_policy: TextFilterPolicy | None = None,
    ):
        """初始化处理器

        Args:
            render_policy: 渲染策略（默认使用 DefaultRenderPolicy）
            text_filter_policy: 文本过滤策略（默认使用 DefaultTextFilterPolicy）
        """
        self._render_policy = render_policy or DefaultRenderPolicy()
        self._text_filter_policy = text_filter_policy or DefaultTextFilterPolicy()
        self._event_generator = EventGenerator()

    def get_last_response(self) -> str:
        """Get the AI response text from the last stream processing.

        Returns:
            str: The collected AI response text
        """
        return self._event_generator.get_collected_response()

    async def process_stream(
        self,
        agent: Any,
        input_data: dict[str, Any] | None,
        config: dict[str, Any],
        session_id: UUID,
        user_uuid: UUID | None = None,
    ) -> AsyncGenerator[GenUIEvent]:
        """处理 LangGraph 流并生成 GenUI 事件

        Args:
            agent: LangGraph Agent 实例
            input_data: 图输入数据（None 表示从 checkpoint 恢复）
            config: 运行时配置
            session_id: 会话 ID
            user_uuid: 用户 UUID

        Yields:
            GenUIEvent 事件
        """
        self._event_generator.reset()
        event_buffer: list[GenUIEvent] = []

        # Extract user message for indexing
        user_message_content = self._extract_user_message(input_data)

        logger.info("stream_processor_start", session_id=session_id)

        try:
            async for mode, chunk in agent.astream(
                input_data,
                config=config,
                stream_mode=["messages", "custom", "updates"],
            ):
                async for event in self._process_chunk(
                    mode=mode,
                    chunk=chunk,
                    session_id=session_id,
                    event_buffer=event_buffer,
                ):
                    yield event

        except Exception as e:
            logger.error(
                "stream_processor_error",
                session_id=session_id,
                error=str(e),
                exc_info=True,
            )
            # 发送错误事件给客户端
            yield GenUIEvent(
                type="error",
                content=f"流处理错误: {str(e)}",
            )

        finally:
            # 1. 释放缓冲的事件
            for event in event_buffer:
                yield event

            # 2. 发送完成事件
            yield GenUIEvent(type="done")

            # 3. 双写消息到 searchable_messages 表（异步，不阻塞响应）
            if user_uuid and session_id:
                asyncio.create_task(
                    self._index_messages(
                        session_id=session_id,
                        user_uuid=user_uuid,
                        user_message=user_message_content,
                        ai_response=self._event_generator.get_collected_response(),
                    )
                )

            logger.info(
                "stream_processor_complete",
                session_id=session_id,
                buffered_events=len(event_buffer),
            )

    def _extract_user_message(self, input_data: dict[str, Any] | None) -> str:
        """从输入数据中提取用户消息内容

        Args:
            input_data: 图输入数据

        Returns:
            用户消息文本内容
        """
        if not input_data:
            return ""

        messages = input_data.get("messages", [])
        if not messages:
            return ""

        # 取最后一条消息（通常是用户消息）
        last_msg = messages[-1]

        # 支持多种消息格式
        if hasattr(last_msg, "content"):
            content = last_msg.content
        elif isinstance(last_msg, dict):
            content = last_msg.get("content", "")
        else:
            content = str(last_msg)

        # 处理多模态内容
        if isinstance(content, list):
            text_parts = []
            for item in content:
                if isinstance(item, dict) and item.get("type") == "text":
                    text_parts.append(item.get("text", ""))
                elif isinstance(item, str):
                    text_parts.append(item)
            return " ".join(text_parts)

        return str(content) if content else ""

    async def _index_messages(
        self,
        session_id: UUID,
        user_uuid: UUID,
        user_message: str,
        ai_response: str,
    ) -> None:
        """异步索引用户消息和 AI 回复到 searchable_messages 表

        这是双写模式的核心：将消息同时写入 LangGraph checkpoints 和
        searchable_messages 表，以支持高效的全文搜索。

        Args:
            session_id: 会话 ID
            user_uuid: 用户 UUID
            user_message: 用户消息内容
            ai_response: AI 回复内容
        """
        try:
            # Index user message
            if user_message and user_message.strip():
                await message_index_service.index_user_message(
                    thread_id=session_id,
                    user_uuid=user_uuid,
                    content=user_message,
                )

            # Index AI response
            if ai_response and ai_response.strip():
                await message_index_service.index_assistant_message(
                    thread_id=session_id,
                    user_uuid=user_uuid,
                    content=ai_response,
                )

            logger.debug(
                "messages_indexed",
                session_id=session_id,
                user_message_length=len(user_message) if user_message else 0,
                ai_response_length=len(ai_response) if ai_response else 0,
            )

        except Exception as e:
            # 索引失败不应影响主流程
            logger.warning(
                "message_indexing_failed",
                session_id=session_id,
                error=str(e),
            )

    async def _process_chunk(
        self,
        mode: str,
        chunk: Any,
        session_id: UUID,
        event_buffer: list[GenUIEvent],
    ) -> AsyncGenerator[GenUIEvent]:
        """处理单个流块

        Args:
            mode: 流模式 ("messages", "custom", "updates")
            chunk: 流块数据
            session_id: 会话 ID
            event_buffer: 事件缓冲区（用于 BUFFER 决策的事件）

        Yields:
            应该立即发送的 GenUIEvent
        """
        if mode == "messages":
            async for event in self._process_messages_mode(chunk, session_id, event_buffer):
                yield event

        elif mode == "custom":
            async for event in self._process_custom_mode(chunk):
                yield event

        elif mode == "updates":
            async for event in self._process_updates_mode(
                chunk,
                session_id,
                event_buffer,
            ):
                yield event

    async def _process_messages_mode(
        self,
        chunk: tuple,
        session_id: UUID,
        event_buffer: list[GenUIEvent],
    ) -> AsyncGenerator[GenUIEvent]:
        """处理 messages 模式

        注意：
        - 文本过滤策略在此应用
        - 渲染策略在此应用
        """
        msg_chunk, metadata = chunk
        node_name = metadata.get("langgraph_node", "")

        # 应用文本过滤策略
        should_suppress_text = self._text_filter_policy.should_suppress(node_name, metadata)

        async for event in self._event_generator.process_message_chunk(chunk, session_id):
            # 1. 文本过滤
            if event.type == "text_delta" and should_suppress_text:
                logger.debug(
                    "text_suppressed",
                    node_name=node_name,
                    content_length=len(event.content or ""),
                )
                continue

            # 2. 渲染策略
            decision = self._render_policy.decide(event, node_name)

            if decision == RenderDecision.EMIT:
                yield event
            elif decision == RenderDecision.BUFFER:
                event_buffer.append(event)
                logger.debug(
                    "event_buffered_messages_mode",
                    event_type=event.type,
                    node_name=node_name,
                )
            elif decision == RenderDecision.SUPPRESS:
                logger.debug(
                    "event_suppressed_messages_mode",
                    event_type=event.type,
                    node_name=node_name,
                )
                # 不做任何处理，事件被丢弃

    async def _process_custom_mode(
        self,
        chunk: dict[str, Any],
    ) -> AsyncGenerator[GenUIEvent]:
        """处理 custom 模式"""
        if isinstance(chunk, dict) and chunk.get("type") == "progress":
            yield GenUIEvent(
                type="ui_progress",
                content=chunk.get("message", ""),
            )

    async def _process_updates_mode(
        self,
        chunk: dict[str, Any],
        session_id: UUID,
        event_buffer: list[GenUIEvent],
    ) -> AsyncGenerator[GenUIEvent]:
        """处理 updates 模式

        注意：渲染策略在此应用
        """
        node_name = next(iter(chunk.keys())) if isinstance(chunk, dict) else ""

        async for event in self._event_generator.process_updates_chunk(chunk, session_id):
            decision = self._render_policy.decide(event, node_name)

            if decision == RenderDecision.EMIT:
                yield event

            elif decision == RenderDecision.BUFFER:
                event_buffer.append(event)
                logger.debug(
                    "event_buffered",
                    event_type=event.type,
                    node_name=node_name,
                )

            elif decision == RenderDecision.SUPPRESS:
                logger.debug(
                    "event_suppressed",
                    event_type=event.type,
                    node_name=node_name,
                )
                # 不做任何处理，事件被丢弃
