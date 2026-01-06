import pytest
import asyncio
from unittest.mock import AsyncMock, MagicMock, patch
from uuid import uuid4
from app.services.memory import get_memory_service
from app.core.langgraph.simple_agent import SimpleLangChainAgent
from app.core.langgraph.tools.context import current_user_id

@pytest.mark.asyncio
async def test_memory_extraction_boundary():
    """验证事实提取的边界感：有价值记录，无价值忽略"""
    service = await get_memory_service()
    user_id = str(uuid4())
    
    # 模拟 LLM 响应 (BaseMessage 类型)
    from langchain_core.messages import AIMessage
    
    with patch("app.services.llm.llm_service.call", new_callable=AsyncMock) as mock_call:
        # 场景 1: 包含长期价值的事实
        mock_call.return_value = AIMessage(content="User has a mortgage with ICBC paying 8000 per month.")
        
        valuable_chat = [
            {"role": "user", "content": "我的房贷是在工行办的，每个月要还 8000 元。"},
            {"role": "assistant", "content": "好的，我已经记下了您的房贷信息。"}
        ]
        result = await service.add_conversation_memory(user_id, valuable_chat)
        assert result["success"] is True
        assert result.get("extracted") is not False
        
        # 场景 2: 纯临时指令（噪音）
        mock_call.return_value = AIMessage(content="NONE")
        result_noise = await service.add_conversation_memory(user_id, [{"role": "user", "content": "查查余额"}])
        assert result_noise.get("extracted") is False

@pytest.mark.asyncio
async def test_agent_proactive_memory_tool_call():
    """验证 Agent 中间件的行为（目前改为 passive）"""
    # 彻底 Mock 掉 LLM 以避免网络延迟和挂起
    with patch("app.services.llm.llm_service.call", new_callable=AsyncMock) as mock_call:
        from app.core.langgraph.middleware.memory import LongTermMemoryMiddleware
        from langchain_core.messages import HumanMessage
        
        middleware = LongTermMemoryMiddleware()
        
        # 此时 check before_invoke 是否由于我们的修改而不再执行检索
        messages = [HumanMessage(content="根据我之前的预算目标建议一下")]
        config = {"configurable": {"user_uuid": str(uuid4())}}
        
        # 在我们的新设计中，中间件应该直接返回，不做检索
        processed_msgs, _ = await middleware.before_invoke(messages, config)
        
        # 验证消息没被修改（即没有注入 "# 用户相关记忆"）
        assert len(processed_msgs) == 1
        assert "用户相关记忆" not in processed_msgs[0].content

@pytest.mark.asyncio
async def test_memory_tool_functionality():
    """直接测试 memory 工具的逻辑"""
    from app.core.langgraph.tools.memory_tools import search_personal_context
    
    user_id = str(uuid4())
    current_user_id.set(user_id)
    
    with patch("app.services.memory.memory_service.MemoryService.search_memories", new_callable=AsyncMock) as mock_search:
        mock_search.return_value = [{"memory": "User wants to save 5000 per month", "score": 0.9}]
        
        result = await search_personal_context.ainvoke({"query": "budget caps"})
        assert "save 5000 per month" in result
        assert "Found the following" in result
