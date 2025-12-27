"""StreamProcessor - 流处理编排者

职责：
- 协调 LangGraph 流与 GenUI 事件生成
- 编排策略执行（渲染策略、文本过滤策略）
- 管理事件缓冲和释放

设计原则：
- 编排者模式：只负责协调，不负责具体逻辑
- 依赖注入：策略通过构造函数注入
- 开闭原则：通过更换策略扩展行为
"""

from typing import Any, AsyncGenerator, Optional

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

    async def process_stream(
        self,
        agent,
        input_data: dict[str, Any] | None,
        config: dict[str, Any],
        session_id: str,
        user_uuid: Optional[str] = None,
    ) -> AsyncGenerator[GenUIEvent, None]:
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

            logger.info(
                "stream_processor_complete",
                session_id=session_id,
                buffered_events=len(event_buffer),
            )

    async def _process_chunk(
        self,
        mode: str,
        chunk: Any,
        session_id: str,
        event_buffer: list[GenUIEvent],
    ) -> AsyncGenerator[GenUIEvent, None]:
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
        session_id: str,
        event_buffer: list[GenUIEvent],
    ) -> AsyncGenerator[GenUIEvent, None]:
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
    ) -> AsyncGenerator[GenUIEvent, None]:
        """处理 custom 模式"""
        if isinstance(chunk, dict) and chunk.get("type") == "progress":
            yield GenUIEvent(
                type="ui_progress",
                content=chunk.get("message", ""),
            )

    async def _process_updates_mode(
        self,
        chunk: dict[str, Any],
        session_id: str,
        event_buffer: list[GenUIEvent],
    ) -> AsyncGenerator[GenUIEvent, None]:
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
