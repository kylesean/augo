"""Memory tools for Agentic RAG.

Allows the agent to search for user context, preferences, and long-term facts.
"""

from typing import Optional
from langchain_core.tools import tool
from app.services.memory import get_memory_service
from app.core.logging import logger
from .context import current_user_id

@tool
async def search_personal_context(query: str) -> str:
    """Search for the user's historical personal context, including financial goals, budget limits, 
    risk tolerance, and household information.
    
    CRITICAL: Use this tool PROACTIVELY when:
    - The user asks for planning, advice, or strategy (e.g., "Suggest a budget", "How am I doing?").
    - The user refers to persistent goals, targets, or "the plan" which is not in current chat.
    - You need to know user preferences (e.g., categorization habits, family context).
    
    DO NOT use for simple balance checks or single transaction lookups.
    
    Args:
        query: Search keywords for the context needed (e.g., 'retirement goal', 'budget limits', 'family').
    """
    user_id = current_user_id.get()
    if not user_id:
        return "Error: No user_id found in context. Cannot search memories."
    
    try:
        service = await get_memory_service()
        memories = await service.search_memories(
            user_uuid=user_id,
            query=query,
            limit=5,
            categories=["financial_profile", "preference", "household", "conversation"]
        )
        
        if not memories:
            return f"No relevant personal context found for '{query}'."
            
        formatted = service.format_memories_for_prompt(memories)
        logger.info("memory_tool_search_success", user_id=user_id, query=query, result_count=len(memories))
        return f"Found the following personal context for '{query}':\n{formatted}"
        
    except Exception as e:
        logger.error("memory_tool_search_failed", error=str(e), user_id=user_id)
        return f"Error occurred while searching memories: {str(e)}"

# Collection of memory tools
memory_tools = [search_personal_context]
