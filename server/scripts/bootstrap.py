"""Bootstrap script for initializing database resources.

This script ensures that:
1. The Postgres `pgvector` extension is enabled.
2. LangGraph checkpoint tables are initialized.
3. Mem0 storage collections are initialized.
"""

import asyncio
import sys
from typing import Optional

from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine

from app.core.config import settings
from app.core.langgraph.simple_agent import SimpleLangChainAgent
from app.core.logging import logger


async def ensure_pgvector():
    """Enable pgvector extension if not present."""
    connection_url = (
        f"postgresql+asyncpg://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}"
        f"@{settings.POSTGRES_HOST}:{settings.POSTGRES_PORT}/{settings.POSTGRES_DB}"
    )
    engine = create_async_engine(connection_url)

    try:
        async with engine.connect() as conn:
            await conn.execute(text("CREATE EXTENSION IF NOT EXISTS vector;"))
            await conn.commit()
            logger.info("bootstrap_pgvector_extension_ensured")
    except Exception as e:
        logger.error("bootstrap_pgvector_extension_failed", error=str(e))
        # Don't exit here, might already exist or user might not have superuser rights
        # but the extension might already be there.
    finally:
        await engine.dispose()


async def init_langgraph():
    """Initialize LangGraph checkpoint tables."""
    try:
        agent = SimpleLangChainAgent()
        # This calls AsyncPostgresSaver.setup() internally
        await agent._get_checkpointer()
        logger.info("bootstrap_langgraph_tables_initialized")
    except Exception as e:
        logger.error("bootstrap_langgraph_init_failed", error=str(e))
        raise


async def init_mem0():
    """Initialize Mem0 storage using MemoryService."""
    try:
        from app.services.memory import get_memory_service

        # Instantiating MemoryService will trigger table creation in pgvector
        _ = await get_memory_service()
        logger.info("bootstrap_mem0_storage_initialized")
    except Exception as e:
        logger.error("bootstrap_mem0_init_failed", error=str(e))
        raise


async def init_business_tables():
    """Initialize business application tables."""
    try:
        # Import models to register them with SQLModel metadata
        import app.models  # noqa: F401
        from app.core.database import db_manager

        await db_manager.create_tables()
        logger.info("bootstrap_business_tables_initialized")
    except Exception as e:
        logger.error("bootstrap_business_init_failed", error=str(e))
        raise


async def main():
    """Execution entry point for the script."""
    """Main bootstrap routine."""
    logger.info("bootstrap_started", env=settings.ENVIRONMENT.value)

    try:
        # 1. Extensions first
        await ensure_pgvector()

        # 2. Components & Business Tables
        await asyncio.gather(init_langgraph(), init_mem0(), init_business_tables())

        logger.info("bootstrap_completed_successfully")
    except Exception as e:
        logger.critical("bootstrap_failed", error=str(e))
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
