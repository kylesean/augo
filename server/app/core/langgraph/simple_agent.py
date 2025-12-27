"""SimpleLangChainAgent - LangGraph 底层 API 实现

使用 LangGraph StateGraph 底层 API 构建的 Agent，
职责被分解到以下模块：
- agent/: 状态定义、节点函数、路由逻辑、图构建
- stream/: 流处理和 GenUI 适配
- middleware/: 动态上下文、长期记忆、附件处理

此文件作为 Facade 类，协调各模块的工作。
"""

from typing import AsyncGenerator, Optional
from urllib.parse import quote_plus

from langchain_core.messages import AIMessage, HumanMessage
from langgraph.checkpoint.postgres.aio import AsyncPostgresSaver
from langgraph.errors import GraphRecursionError
from psycopg_pool import AsyncConnectionPool

from app.core.config import settings
from app.core.langgraph.agent import build_agent_graph
from app.core.langgraph.middleware import (
    AttachmentMiddleware,
    DynamicContextMiddleware,
    LongTermMemoryMiddleware,
    MiddlewareAgent,
)
from app.core.langgraph.middleware.state_validator import state_validator
from app.core.langgraph.stream import StreamProcessor
from app.core.langgraph.tools import tools
from app.core.logging import logger
from app.core.prompts import get_stable_system_prompt
from app.schemas import Message
from app.schemas.client_state import ClientStateMutation
from app.schemas.genui import GenUIEvent
from app.services.llm import llm_service
from app.services.memory import MemoryService, get_memory_service


class SimpleLangChainAgent:
    """LangGraph Agent Facade

    协调图构建、流处理和 middleware 的工作。

    Architecture:
    - 使用 LangGraph StateGraph 底层 API 构建图
    - 使用 MiddlewareAgent 包装实现动态上下文和记忆
    - 使用 StreamProcessor 处理流式输出
    """

    def __init__(self):
        """初始化 Agent"""
        self.llm_service = llm_service
        self.llm_service.bind_tools(tools)

        self._agent = None
        self._conn_pool: Optional[AsyncConnectionPool] = None
        self._memory_service: Optional[MemoryService] = None
        self._middlewares: Optional[list] = None
        self._stream_processor = StreamProcessor()

        logger.info(
            "simple_agent_initialized",
            model=settings.DEFAULT_LLM_MODEL,
        )

    # =========================================================================
    # 内部组件初始化
    # =========================================================================

    async def _get_memory_service(self) -> MemoryService:
        """获取 MemoryService 实例（集中化的长期记忆管理）"""
        if self._memory_service is None:
            self._memory_service = await get_memory_service()
            logger.info("memory_service_initialized")
        return self._memory_service

    async def _get_checkpointer(self) -> AsyncPostgresSaver:
        """获取 PostgreSQL checkpointer（短期记忆）"""
        if self._conn_pool is None:
            connection_url = (
                "postgresql://"
                f"{quote_plus(settings.POSTGRES_USER)}:{quote_plus(settings.POSTGRES_PASSWORD)}"
                f"@{settings.POSTGRES_HOST}:{settings.POSTGRES_PORT}/{settings.POSTGRES_DB}"
            )

            self._conn_pool = AsyncConnectionPool(
                connection_url,
                open=False,
                max_size=settings.POSTGRES_POOL_SIZE,
                kwargs={
                    "autocommit": True,
                    "connect_timeout": 5,
                    "prepare_threshold": None,
                },
            )
            await self._conn_pool.open()

        checkpointer = AsyncPostgresSaver(self._conn_pool)
        await checkpointer.setup()
        return checkpointer

    async def _initialize_middlewares(self) -> list:
        """初始化 middleware 栈"""
        if self._middlewares is None:
            from app.core.database import get_session_context
            from app.core.langgraph.middleware import SkillConstraintMiddleware

            # LongTermMemoryMiddleware now uses MemoryService internally
            # No need to pass memory instance directly
            self._middlewares = [
                DynamicContextMiddleware(),
                LongTermMemoryMiddleware(
                    max_memories=5,
                    min_relevance_score=0.3,  # Only include relevant memories
                ),
                AttachmentMiddleware(get_session_context),
                SkillConstraintMiddleware(tools=tools),
            ]

            logger.info(
                "middlewares_initialized",
                count=len(self._middlewares),
            )

        return self._middlewares

    # =========================================================================
    # Agent 生命周期
    # =========================================================================

    async def get_agent(self):
        """获取或创建 Agent 实例

        Returns:
            MiddlewareAgent 包装的 Agent 图
        """
        if self._agent is not None:
            return self._agent

        # 使用自定义图构建（支持 direct_execute 节点）
        checkpointer = await self._get_checkpointer()
        graph = build_agent_graph(
            llm=self.llm_service.get_llm(),
            tools=tools,
            system_prompt=get_stable_system_prompt(),
            checkpointer=checkpointer,
        )

        # 包装应用层 middleware（动态上下文、长期记忆、附件处理）
        middlewares = await self._initialize_middlewares()
        self._agent = MiddlewareAgent(graph, middlewares)

        logger.info("agent_created")
        return self._agent

    # =========================================================================
    # 核心 API
    # =========================================================================

    async def get_genui_stream(
        self,
        messages: list[Message],
        session_id: str,
        user_uuid: Optional[str] = None,
        attachment_ids: Optional[list[str]] = None,
        client_state: Optional[ClientStateMutation] = None,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """GenUI 核心流处理器

        GenUI 原子模式的核心入口：
        - client_state 作为图的初始输入直接合并
        - 在图执行前进行状态校验
        - 校验失败时自动降级到 agent 节点

        Args:
            messages: 消息列表
            session_id: 会话 ID
            user_uuid: 用户 UUID
            attachment_ids: 附件 ID 列表
            client_state: 客户端状态突变（GenUI 原子模式）

        Yields:
            GenUIEvent 事件
        """
        agent = await self.get_agent()

        config = {
            "configurable": {
                "thread_id": session_id,
                "user_uuid": str(user_uuid) if user_uuid else None,  # 确保是字符串
                "attachment_ids": attachment_ids or [],
            },
        }

        # Add Langfuse callback for tracing
        langfuse_handler = self._get_langfuse_callback(session_id, user_uuid)
        if langfuse_handler:
            config["callbacks"] = [langfuse_handler]

        # 转换消息格式
        # CRITICAL FIX: 仅使用最后一条消息（新输入）作为图的输入
        # 客户端通常会发送完整的历史记录（包含之前的流式碎片），
        # 如果我们将整个历史再次传给 LangGraph，add_messages reducer 会将它们视为新消息
        # 并追加到现有状态中，导致严重的重复和碎片化问题。
        # 我们信任持久化层已保存历史，只处理增量输入。
        lc_messages = []
        if messages:
            last_msg = messages[-1]
            lc_messages = [
                HumanMessage(content=last_msg.content)
                if last_msg.role == "user"
                else AIMessage(content=last_msg.content)
            ]

        # 构建 input_data
        input_data = {"messages": lc_messages}

        # GenUI 原子模式：处理 client_state
        if client_state:
            # 防御性校验
            validation_result = state_validator.validate(client_state)

            if validation_result:
                # 校验通过：合并到图输入
                state_dict = client_state.to_state_dict()
                input_data.update(state_dict)
                logger.info(
                    "genui_atomic_mode",
                    session_id=session_id,
                    ui_mode=client_state.ui_mode,
                    tool_name=client_state.tool_name,
                )
            else:
                # 校验失败：降级到 agent 节点处理
                logger.warning(
                    "genui_atomic_mode_validation_failed",
                    session_id=session_id,
                    errors=validation_result.errors,
                )
                # 不设置 ui_mode，让 route_entry 路由到 agent

        # 委托给 StreamProcessor
        from app.core.langgraph.tools import current_user_id

        token = None
        if user_uuid:
            token = current_user_id.set(str(user_uuid))

        try:
            async for event in self._stream_processor.process_stream(
                agent=agent,
                input_data=input_data,
                config=config,
                session_id=session_id,
                user_uuid=user_uuid,
            ):
                yield event
        except GraphRecursionError:
            logger.warning(
                "agent_recursion_limit_exceeded",
                session_id=session_id,
            )
            yield GenUIEvent(
                type="text_delta",
                data="\n\n⚠️ 抱歉，我在执行这个任务时尝试了太多次仍未成功。请尝试简化你的请求，或者换一种方式描述。",
            )
            yield GenUIEvent(type="done")
        finally:
            if token:
                try:
                    current_user_id.reset(token)
                except ValueError:
                    pass

            # 强制刷新 Langfuse 数据上报
            if "langfuse_handler" in locals() and langfuse_handler and hasattr(langfuse_handler, "flush"):
                langfuse_handler.flush()

    async def get_session_state(self, session_id: str):
        """获取会话的当前 LangGraph 状态

        用于检查会话是否有未完成的执行（state.next != None）。

        Args:
            session_id: 会话 ID

        Returns:
            StateSnapshot 对象，包含 values 和 next 属性
        """
        agent = await self.get_agent()
        config = {"configurable": {"thread_id": session_id}}
        return await agent.aget_state(config)

    async def resume_stream(
        self,
        session_id: str,
        user_uuid: Optional[str] = None,
    ) -> AsyncGenerator[GenUIEvent, None]:
        """从 checkpoint 恢复未完成的流式执行

        当 get_session_state() 返回的 state.next 不为 None 时，
        可调用此方法从最新 checkpoint 恢复执行。

        Args:
            session_id: 会话 ID
            user_uuid: 用户 UUID

        Yields:
            GenUIEvent 事件
        """
        agent = await self.get_agent()

        config = {
            "configurable": {
                "thread_id": session_id,
                "user_uuid": str(user_uuid) if user_uuid else None,  # 确保是字符串
            },
        }

        # Add Langfuse callback for tracing
        langfuse_handler = self._get_langfuse_callback(session_id, user_uuid)
        if langfuse_handler:
            config["callbacks"] = [langfuse_handler]

        logger.info(
            "resume_stream_started",
            session_id=session_id,
            user_uuid=user_uuid,
        )

        # 传入 None 作为输入，从最新 checkpoint 恢复执行
        from app.core.langgraph.tools import current_user_id

        token = None
        if user_uuid:
            token = current_user_id.set(str(user_uuid))

        try:
            async for event in self._stream_processor.process_stream(
                agent=agent,
                input_data=None,  # 关键：None 表示从 checkpoint 恢复
                config=config,
                session_id=session_id,
                user_uuid=user_uuid,
            ):
                yield event
        except GraphRecursionError:
            logger.warning(
                "resume_stream_recursion_limit_exceeded",
                session_id=session_id,
            )
            yield GenUIEvent(
                type="text_delta",
                data="\n\n⚠️ 任务执行超过了最大尝试次数。请重新开始对话。",
            )
            yield GenUIEvent(type="done")
        finally:
            if token:
                try:
                    current_user_id.reset(token)
                except ValueError:
                    pass

            # 强制刷新 Langfuse 数据上报
            if "langfuse_handler" in locals() and langfuse_handler and hasattr(langfuse_handler, "flush"):
                langfuse_handler.flush()

        logger.info(
            "resume_stream_completed",
            session_id=session_id,
        )

    # NOTE: update_state 方法已移除
    # GenUI 原子模式不再需要单独的 state update API
    # 所有状态突变通过 get_genui_stream 的 client_state 参数原子性处理

    async def get_chat_history(self, session_id: str) -> list[Message]:
        """获取聊天历史

        Args:
            session_id: 会话 ID

        Returns:
            消息列表
        """
        agent = await self.get_agent()
        config = {"configurable": {"thread_id": session_id}}
        state = await agent.aget_state(config)

        if state.values and "messages" in state.values:
            result = []
            for msg in state.values["messages"]:
                if not isinstance(msg, (AIMessage, HumanMessage)):
                    continue
                if not msg.content:
                    continue

                text_content = self._extract_text_content(msg.content)
                if text_content:
                    result.append(
                        Message(
                            role="assistant" if isinstance(msg, AIMessage) else "user",
                            content=text_content,
                        )
                    )
            return result
        return []

    async def get_detailed_history(self, session_id: str, user_uuid: str = None) -> list[dict]:
        """获取会话的详细历史消息，包含 UI 组件和附件信息。

        从 LangGraph checkpoint 读取消息并解析：
        - AI 消息的 tool_calls
        - ToolMessage 中的 UI 组件数据（基于 TOOL_UI_MAP 映射）
        - 附件信息（通过 additional_kwargs 中的 attachment_id 关联）

        注意：AI 文本过滤已下沉到 StreamMiddleware (流层面) 完成，
        Checkpoint 中存储的是完整的原始消息，以保证 Agent 逻辑的连贯性。

        Args:
            session_id: 会话 ID
            user_uuid: 用户 ID (用于 Enrichment Layer 数据回填)

        Returns:
            符合客户端格式的消息列表（使用 camelCase 字段名）
        """
        import json
        import uuid

        from langchain_core.messages import ToolMessage

        agent = await self.get_agent()
        config = {"configurable": {"thread_id": session_id}}
        state = await agent.aget_state(config)

        if not state.values or "messages" not in state.values:
            return []

        messages = state.values["messages"]
        result = []

        # 第一步：预处理 - 收集 ToolMessage 的 UI 组件映射
        # (tool_call_id -> ui_component_data)
        tool_call_ui_map: dict[str, dict] = {}

        # 引入 ComponentDetector
        # 引入 Enrichment Layer
        from app.core.genui.enricher import EnricherRegistry
        from app.core.langgraph.stream import ComponentDetector
        from app.services.enrichers.transaction_enricher import transaction_enricher

        # 注册 Enricher (幂等)
        EnricherRegistry.register(transaction_enricher)

        for msg in messages:
            if isinstance(msg, ToolMessage):
                tool_name = getattr(msg, "name", None)
                tool_call_id = getattr(msg, "tool_call_id", None)

                # 提取工具执行结果（优先从 artifact 获取，否则从 content 解析）
                tool_result = getattr(msg, "artifact", None)
                if tool_result is None:
                    try:
                        content = msg.content
                        if isinstance(content, str):
                            tool_result = json.loads(content)
                        elif isinstance(content, dict):
                            tool_result = content
                    except Exception:
                        continue

                # 数据驱动：使用 ComponentDetector 统一检测
                if not isinstance(tool_result, dict):
                    continue

                # 使用 ComponentDetector 检测组件类型（包含业务覆盖规则）
                component_type = ComponentDetector.detect_with_overrides(tool_result, tool_name)

                if not component_type:
                    continue

                # 过滤失败的工具调用
                if not ComponentDetector.is_successful_result(tool_result):
                    continue

                msg_id = getattr(msg, "id", None) or str(uuid.uuid4())
                tool_call_ui_map[tool_call_id] = {
                    "surfaceId": f"history_{msg_id}",
                    "componentType": component_type,
                    "data": tool_result,
                    "mode": "historical",
                    "toolCallId": tool_call_id,
                    "toolName": tool_name,
                }

        # ============================================================
        # 处理 direct_execute_result（用于绕过 LLM 直接执行工具的结果）
        # ============================================================
        direct_execute_result = state.values.get("direct_execute_result")
        if direct_execute_result and direct_execute_result.get("success"):
            tool_name = direct_execute_result.get("tool_name", "")
            tool_result = direct_execute_result.get("data", {})

            if isinstance(tool_result, dict):
                # 使用 ComponentDetector 检测组件类型
                component_type = ComponentDetector.detect_with_overrides(tool_result, tool_name)

                if component_type and ComponentDetector.is_successful_result(tool_result):
                    de_id = "direct_execute_result"
                    tool_call_ui_map[de_id] = {
                        "surfaceId": f"history_de_{session_id}",
                        "componentType": component_type,
                        "data": tool_result,
                        "mode": "historical",
                        "toolCallId": de_id,
                        "toolName": tool_name,
                    }

        # Enrichment Layer: 实时数据回填
        # 遍历所有 UI 组件，尝试使用 Enricher 更新数据
        if user_uuid:
            for tc_id, ui_comp in tool_call_ui_map.items():
                component_type = ui_comp.get("componentType")
                if component_type and ui_comp.get("mode") == "historical":
                    # 只 enrich historical 模式的组件
                    original_data = ui_comp.get("data", {})

                    # 调用 Registry 进行 enrich
                    enriched_data = await EnricherRegistry.enrich_component(
                        component_name=component_type,
                        tool_call_id=tc_id,
                        data=original_data,
                        context={"user_uuid": user_uuid, "session_id": session_id},
                    )

                    if enriched_data != original_data:
                        ui_comp["data"] = enriched_data
                        logger.debug(
                            "component_enriched_success",
                            tool_call_id=tc_id,
                            component_type=component_type,
                        )

        # ------------------------------------------------------------
        # 补全历史状态：关联 TransferWizard 和其执行结果（解决交互式组件历史数据丢失问题）
        # ------------------------------------------------------------
        confirmed_params = None
        if direct_execute_result and direct_execute_result.get("success"):
            de_data = direct_execute_result.get("data", {})
            if de_data.get("componentType") == "TransferReceipt" or de_data.get("transfer_info"):
                # 记录转账成交参数 (注意: amount 位于顶层，account 详细信息可能在 transfer_info 内部)
                transfer_info = de_data.get("transfer_info") or {}
                source_acc = transfer_info.get("source_account") or {}
                target_acc = transfer_info.get("target_account") or {}

                confirmed_params = {
                    "amount": float(de_data.get("amount") or 0.0),
                    "source_id": str(source_acc.get("id") or de_data.get("source_account_id") or ""),
                    "target_id": str(target_acc.get("id") or de_data.get("target_account_id") or ""),
                }

        if confirmed_params:
            for ui_comp in tool_call_ui_map.values():
                if ui_comp.get("componentType") == "TransferWizard":
                    wizard_data = ui_comp.get("data", {})
                    # 更新 Wizard 数据为最终成交值（覆盖初始建议值）
                    if confirmed_params["source_id"]:
                        wizard_data["preselectedSourceId"] = confirmed_params["source_id"]
                    if confirmed_params["target_id"]:
                        wizard_data["preselectedTargetId"] = confirmed_params["target_id"]
                    if confirmed_params["amount"] > 0:
                        wizard_data["amount"] = confirmed_params["amount"]

                    # 标记为已确认，以便前端渲染为 Historical 状态
                    wizard_data["isConfirmed"] = True
                    logger.debug("history_wizard_data_auto_filled", surface_id=ui_comp.get("surfaceId"))

        logger.debug("tool_call_ui_map_built", count=len(tool_call_ui_map))

        # 第二步：构建并优化消息列表
        # 策略：收集所有消息 -> 分组 -> 智能合并 Assistant 文本
        raw_result = []
        for msg in messages:
            msg_id = getattr(msg, "id", None) or str(uuid.uuid4())

            # 跳过 ToolMessage（已在上面处理）
            if isinstance(msg, ToolMessage):
                continue

            # HumanMessage
            if isinstance(msg, HumanMessage):
                text_content = self._extract_text_content(msg.content)
                additional_kwargs = getattr(msg, "additional_kwargs", {}) or {}
                attachment_ids = additional_kwargs.get("attachment_ids", [])

                # Debug: 记录 HumanMessage 的原始内容结构
                content_type = type(msg.content).__name__
                content_length = len(msg.content) if isinstance(msg.content, (str, list)) else 0
                logger.debug(
                    "human_message_content_debug",
                    msg_id=msg_id,
                    content_type=content_type,
                    content_length=content_length,
                    has_additional_kwargs=bool(additional_kwargs),
                    attachment_ids_from_kwargs=attachment_ids,
                )

                if attachment_ids:
                    attachments_data = [
                        {
                            "id": att_id,
                            "filename": f"image_{i}.jpg",
                            "signedUrl": f"/api/v1/files/view/{att_id}",
                        }
                        for i, att_id in enumerate(attachment_ids)
                    ]
                else:
                    attachments_data = self._extract_attachment_ids(msg.content)

                logger.debug(
                    "human_message_attachments_extracted",
                    msg_id=msg_id,
                    attachment_count=len(attachments_data),
                    text_content_length=len(text_content),
                )

                raw_result.append(
                    {
                        "id": msg_id,
                        "role": "user",
                        "content": text_content,
                        "timestamp": None,
                        "toolCalls": [],
                        "uiComponents": [],
                        "attachments": attachments_data,
                    }
                )

            # AIMessage
            elif isinstance(msg, AIMessage):
                text_content = self._extract_text_content(msg.content)
                tool_calls_data = []
                ui_components = []

                # 注意：AI 文本过滤由 response_filter 在图层面完成
                # Checkpoint 中存储的已经是过滤后的消息
                if hasattr(msg, "tool_calls") and msg.tool_calls:
                    for tc in msg.tool_calls:
                        tc_id = tc.get("id", "")
                        tc_name = tc.get("name", "")
                        tool_calls_data.append(
                            {
                                "id": tc_id,
                                "name": tc_name,
                                "args": tc.get("args", {}),
                                "status": "success",  # 历史消息默认为成功状态
                            }
                        )
                        if tc_id in tool_call_ui_map:
                            ui_components.append(tool_call_ui_map[tc_id])
                            logger.debug("ui_component_matched", tc_id=tc_id, tool_name=tc_name)
                        else:
                            logger.debug(
                                "ui_component_not_found",
                                tc_id=tc_id,
                                tool_name=tc_name,
                                available_keys=list(tool_call_ui_map.keys())[:5],
                            )

                raw_result.append(
                    {
                        "id": msg_id,
                        "role": "assistant",
                        "content": text_content,
                        "timestamp": None,
                        "toolCalls": tool_calls_data,
                        "uiComponents": ui_components,
                        "attachments": [],
                    }
                )

        result = raw_result

        # ============================================================
        # 将 direct_execute_result 的 UI 组件添加到最后一个 AI 消息
        # 由于 direct_execute 节点的 AIMessage 没有 tool_calls，
        # 原有逻辑无法将 UI 组件关联到消息，需要在这里手动添加
        # ============================================================
        de_ui_component = tool_call_ui_map.get("direct_execute_result")
        if de_ui_component:
            # 找到最后一个 AI 消息（从后往前找）
            for i in range(len(result) - 1, -1, -1):
                if result[i].get("role") == "assistant":
                    result[i]["uiComponents"].append(de_ui_component)
                    logger.info(
                        "direct_execute_ui_appended_to_message",
                        message_id=result[i].get("id"),
                        component_type=de_ui_component.get("componentType"),
                    )
                    break

        logger.info(
            "detailed_history_retrieved",
            session_id=session_id,
            message_count=len(result),
            ui_component_count=len(tool_call_ui_map),
        )

        return result

    async def delete_session_history(self, session_id: str) -> None:
        """彻底删除会话的所有历史记录和 checkpoints。

        1. 使用 LangGraph 官方 API adelete_thread。
        2. 删除业务表 searchable_messages 中的记录。

        Args:
            session_id: 会话 ID
        """
        # 获取 checkpointer 实例
        checkpointer = await self._get_checkpointer()

        config = {"configurable": {"thread_id": session_id}}
        # 1. 使用 LangGraph 官方 API 删除整个 thread 的 checkpoints 和 writes
        await checkpointer.adelete_thread(config)

        # 2. 删除业务表中的消息索引 (searchable_messages)
        async with self._conn_pool.connection() as conn:
            await conn.execute(
                "DELETE FROM searchable_messages WHERE thread_id = %s",
                (session_id,),
            )

        logger.info(
            "session_history_deleted_cascade",
            session_id=session_id,
            cleared_tables=["langgraph_checkpoints", "searchable_messages"],
        )

    async def clear_chat_history(self, session_id: str) -> None:
        """清除聊天历史 (保留会话元数据，仅清理消息内容)

        Args:
            session_id: 会话 ID
        """
        await self.delete_session_history(session_id)
        logger.info("chat_history_cleared", session_id=session_id)

    async def cancel_last_turn(self, session_id: str) -> dict:
        """取消最后一轮对话

        使用 RemoveMessage 清理 checkpoint 状态。

        Args:
            session_id: 会话 ID

        Returns:
            包含 removed_count 和 removed_message_ids 的字典
        """
        from langchain_core.messages import RemoveMessage

        agent = await self.get_agent()
        config = {"configurable": {"thread_id": session_id}}

        state = await agent.aget_state(config)

        if not state.values or "messages" not in state.values:
            return {"removed_count": 0, "removed_message_ids": []}

        messages = state.values["messages"]

        if not messages:
            return {"removed_count": 0, "removed_message_ids": []}

        # 找到最后一个 HumanMessage
        last_human_idx = -1
        for i in range(len(messages) - 1, -1, -1):
            if isinstance(messages[i], HumanMessage):
                last_human_idx = i
                break

        if last_human_idx == -1:
            return {"removed_count": 0, "removed_message_ids": []}

        # 收集要删除的消息
        messages_to_remove = []
        for msg in messages[last_human_idx:]:
            msg_id = getattr(msg, "id", None)
            if msg_id:
                messages_to_remove.append(RemoveMessage(id=msg_id))

        if not messages_to_remove:
            return {"removed_count": 0, "removed_message_ids": []}

        # 更新状态
        await agent.aupdate_state(config, {"messages": messages_to_remove})

        removed_ids = [rm.id for rm in messages_to_remove]
        logger.info(
            "cancel_last_turn_success",
            session_id=session_id,
            removed_count=len(removed_ids),
        )

        return {
            "removed_count": len(removed_ids),
            "removed_message_ids": removed_ids,
        }

    # =========================================================================
    # 辅助方法
    # =========================================================================

    def _extract_text_content(self, content) -> str:
        """从消息内容中提取文本"""
        if isinstance(content, str):
            return content
        elif isinstance(content, list):
            text_parts = []
            for item in content:
                if isinstance(item, dict):
                    if item.get("type") == "text" and item.get("text"):
                        text_parts.append(item["text"])
                elif isinstance(item, str):
                    text_parts.append(item)
            return " ".join(text_parts)
        else:
            return str(content)

    def _extract_attachment_ids(self, content) -> list[dict]:
        """从消息内容中提取附件信息

        支持多种格式：
        1. Base64 data URI：{type: "image_url", image_url: {url: "data:..."}}
        2. 外部 URL：{type: "image_url", image_url: {url: "http://..."}}
        3. 带 attachment_id 的格式：{type: "image_url", attachment_id: "xxx", image_url: {...}}

        返回格式匹配客户端 ChatMessageAttachment 模型
        """
        import uuid as uuid_module

        attachments = []
        if isinstance(content, list):
            for idx, item in enumerate(content):
                if isinstance(item, dict):
                    # OpenAI multimodal 格式
                    if item.get("type") == "image_url":
                        image_url = item.get("image_url", {})
                        url = image_url.get("url", "")

                        # 优先使用 attachment_id（如果存在）
                        attachment_id = item.get("attachment_id")

                        if attachment_id:
                            # 使用 attachment_id 构造 URL
                            attachments.append(
                                {
                                    "id": attachment_id,
                                    "filename": f"image_{idx}.jpg",
                                    "signedUrl": f"/api/v1/files/view/{attachment_id}",
                                }
                            )
                        elif url.startswith("data:"):
                            # Base64 图片
                            mime_match = url.split(";")[0].replace("data:", "")
                            ext = mime_match.split("/")[1] if "/" in mime_match else "jpg"

                            attachments.append(
                                {
                                    "id": f"inline_{idx}_{str(uuid_module.uuid4())[:8]}",
                                    "filename": f"image_{idx}.{ext}",
                                    "signedUrl": url,  # data URI 作为 signedUrl
                                }
                            )
                        elif url.startswith(("http://", "https://", "/")):
                            # 外部 URL 或相对 URL
                            # 尝试从 URL 提取文件扩展名
                            ext = "jpg"
                            if "." in url.split("/")[-1]:
                                ext = url.split(".")[-1].split("?")[0][:4]

                            attachments.append(
                                {
                                    "id": f"url_{idx}_{str(uuid_module.uuid4())[:8]}",
                                    "filename": f"image_{idx}.{ext}",
                                    "signedUrl": url,
                                }
                            )
        return attachments

    async def _update_long_term_memory(
        self,
        user_uuid: Optional[str],
        messages: list[dict],
        session_id: Optional[str] = None,
        category: str = "conversation",
        additional_metadata: Optional[dict] = None,
    ) -> None:
        """Update long-term memory (background task).

        Uses MemoryService to extract and store relevant information
        from the conversation.

        Args:
            user_uuid: User identifier
            messages: Conversation messages in OpenAI format
            session_id: Optional session ID for context
            category: Memory category (conversation, preference, financial, etc.)
            additional_metadata: Extra metadata to store
        """
        if not user_uuid:
            return

        if not messages:
            return

        try:
            service = await self._get_memory_service()
            result = await service.add_conversation_memory(
                user_uuid=user_uuid,
                messages=messages,
                session_id=session_id,
                category=category,
                additional_metadata=additional_metadata,
            )

            if result.get("success"):
                logger.debug(
                    "long_term_memory_updated",
                    user_uuid=user_uuid,
                    session_id=session_id,
                    category=category,
                )
            else:
                logger.warning(
                    "long_term_memory_update_failed",
                    user_uuid=user_uuid,
                    error=result.get("error", "Unknown error"),
                )
        except Exception as e:
            logger.warning(
                "long_term_memory_update_failed",
                user_uuid=user_uuid,
                error=str(e),
            )

    def _get_langfuse_callback(self, thread_id: str, user_id: str = None):
        """获取 Langfuse Callback Handler 用于追踪执行过程。"""
        # 深度诊断日志
        logger.info(
            "langfuse_check",
            has_pub=bool(settings.LANGFUSE_PUBLIC_KEY),
            has_sec=bool(settings.LANGFUSE_SECRET_KEY),
            host=settings.LANGFUSE_HOST,
        )

        if not settings.LANGFUSE_PUBLIC_KEY or not settings.LANGFUSE_SECRET_KEY:
            logger.info("langfuse_config_missing_skipping_callback")
            return None

        try:
            from langfuse.langchain import CallbackHandler

            logger.info(
                "initializing_langfuse_callback", host=settings.LANGFUSE_HOST, thread_id=thread_id, user_id=user_id
            )
            # 直接初始化，SDK 会自动从环境变量读取密钥和 HOST
            handler = CallbackHandler()
            # 设置额外的 metadata
            handler.metadata = {"thread_id": str(thread_id), "user_id": str(user_id)}
            return handler
        except Exception as e:
            logger.error("failed_to_initialize_langfuse_callback", error=str(e))
            return None

    async def get_response(
        self,
        messages: list[Message],
        session_id: str,
        user_uuid: Optional[str] = None,
    ) -> list[Message]:
        """非流式获取响应（支持 Langfuse 追踪）"""
        agent = await self.get_agent()

        config = {
            "configurable": {
                "thread_id": session_id,
                "user_uuid": str(user_uuid) if user_uuid else None,
            },
        }

        # 添加 Langfuse 回调
        langfuse_handler = self._get_langfuse_callback(session_id, user_uuid)
        if langfuse_handler:
            config["callbacks"] = [langfuse_handler]

        lc_messages = []
        if messages:
            last_msg = messages[-1]
            lc_messages = [
                HumanMessage(content=last_msg.content)
                if last_msg.role == "user"
                else AIMessage(content=last_msg.content)
            ]

        input_data = {"messages": lc_messages}

        # 执行图
        result = await agent.ainvoke(input_data, config=config)

        # 提取最新消息
        if result and "messages" in result:
            new_msgs = result["messages"]
            # 找到最后一个 AI 消息
            for msg in reversed(new_msgs):
                if isinstance(msg, AIMessage) and msg.content:
                    text = self._extract_text_content(msg.content)
                    return [Message(role="assistant", content=text)]

        return []
