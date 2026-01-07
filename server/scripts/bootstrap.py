"""Database bootstrap script.

This script initializes external components not managed by Alembic:
- pgvector extension (required before Mem0)
- LangGraph checkpoint tables
- Mem0 vector storage tables

Business tables are managed by Alembic migrations.
"""

import asyncio
import sys

from app.core.config import settings
from app.core.logging import logger


async def ensure_pgvector():
    """Ensure pgvector extension is enabled.

    This is run before Alembic migrations as a prerequisite for Mem0.
    Note: The extension is also created in migration 0001, but we need
    it here for Mem0 initialization which happens before migrations.
    """
    from sqlalchemy import text
    from sqlalchemy.ext.asyncio import create_async_engine

    connection_url = (
        f"postgresql+asyncpg://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}"
        f"@{settings.POSTGRES_HOST}:{settings.POSTGRES_PORT}/{settings.POSTGRES_DB}"
    )
    engine = create_async_engine(connection_url)

    try:
        async with engine.begin() as conn:
            await conn.execute(text('CREATE EXTENSION IF NOT EXISTS "vector"'))
            logger.info("bootstrap_pgvector_extension_ensured")
    except Exception as e:
        logger.warning("bootstrap_pgvector_failed", error=str(e))
    finally:
        await engine.dispose()


async def init_langgraph():
    """Initialize LangGraph checkpoint tables.

    These tables are managed by LangGraph, not Alembic.
    """
    try:
        from app.core.langgraph.simple_agent import SimpleLangChainAgent

        agent = SimpleLangChainAgent()
        checkpointer = await agent._get_checkpointer()
        if checkpointer:
            await checkpointer.setup()
        logger.info("bootstrap_langgraph_tables_initialized")
    except Exception as e:
        logger.error("bootstrap_langgraph_init_failed", error=str(e))
        raise


async def init_mem0():
    """Initialize Mem0 storage tables.

    These tables are managed by Mem0, not Alembic.
    """
    try:
        from app.services.memory.memory_service import MemoryService

        # get_instance() initializes Mem0 and creates its tables
        await MemoryService.get_instance()
        logger.info("bootstrap_mem0_storage_initialized")
    except Exception as e:
        logger.error("bootstrap_mem0_init_failed", error=str(e))
        raise


async def main():
    """Main bootstrap routine.

    This script should be run AFTER Alembic migrations.
    It initializes external components (LangGraph, Mem0) that manage
    their own tables outside of Alembic.
    """
    logger.info("bootstrap_started", env=settings.ENVIRONMENT.value)

    try:
        # 1. Ensure pgvector is enabled (for Mem0)
        await ensure_pgvector()

        # 2. Initialize external components
        await asyncio.gather(init_langgraph(), init_mem0())

        logger.info("bootstrap_completed_successfully")
    except Exception as e:
        logger.critical("bootstrap_failed", error=str(e))
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
