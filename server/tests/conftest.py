from typing import AsyncGenerator, Generator
from unittest.mock import MagicMock
from uuid import uuid4

import pytest
import pytest_asyncio
from appmain import app
from appmodels.user import User
from fastapi.testclient import TestClient
from sqlalchemy import text
from sqlalchemy.dialects import postgresql
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.ext.compiler import compiles
from sqlalchemy.pool import StaticPool
from sqlmodel import SQLModel

from app.core.database import get_session
from app.core.dependencies import get_current_user

# --- Type Compilation Hacks for SQLite ---
# These allow using Postgres-specific types (JSONB, UUID) in SQLite tests


@compiles(postgresql.JSONB, "sqlite")
def compile_jsonb(element, compiler, **kw):
    return "JSON"


@compiles(postgresql.UUID, "sqlite")
def compile_uuid(element, compiler, **kw):
    return "VARCHAR(36)"


@compiles(postgresql.TIMESTAMP, "sqlite")
def compile_timestamp(element, compiler, **kw):
    return "DATETIME"


@compiles(postgresql.INET, "sqlite")
def compile_inet(element, compiler, **kw):
    return "VARCHAR(45)"


# Import all models to ensure they are registered in metadata
from app.models import *  # noqa: F401, F403, E402

# --- Fixtures ---


@pytest_asyncio.fixture(scope="function")
async def async_db_engine() -> AsyncGenerator[AsyncEngine, None]:
    """Create a reusable SQLite engine.
    Use StaticPool to share data in memory across the session.
    """
    engine = create_async_engine(
        "sqlite+aiosqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )

    # Initialize DB schema
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)

    yield engine

    await engine.dispose()


@pytest_asyncio.fixture(scope="function")
async def db_session(async_db_engine: AsyncEngine) -> AsyncGenerator[AsyncSession, None]:
    """Yields an async session.
    Rolls back transaction after each test to ensure isolation.
    """
    connection = await async_db_engine.connect()
    transaction = await connection.begin()

    session_factory = async_sessionmaker(
        bind=connection,
        class_=AsyncSession,
        expire_on_commit=False,
    )

    async with session_factory() as session:
        yield session

    await transaction.rollback()
    await connection.close()


@pytest.fixture(scope="module")
def client() -> Generator[TestClient, None, None]:
    with TestClient(app) as c:
        yield c


@pytest.fixture(autouse=True)
def mock_settings():
    """Mock settings if needed."""
    pass


@pytest_asyncio.fixture(scope="function")
async def test_user(db_session: AsyncSession) -> User:
    """Create a test user in the database."""
    user = User(
        uuid=uuid4(),
        username="integration_test_user",
        email="integration@example.com",
        password="hashed_password",
        registration_type="email",
        timezone="Asia/Shanghai",
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)
    return user


@pytest.fixture(scope="function")
def client_with_auth(
    client: TestClient, db_session: AsyncSession, test_user: User
) -> Generator[TestClient, None, None]:
    """Returns a TestClient with authorized user and test database session.
    Overrides FastAPI dependencies.
    """

    async def override_get_session():
        yield db_session

    async def override_get_current_user():
        return test_user

    app.dependency_overrides[get_session] = override_get_session
    app.dependency_overrides[get_current_user] = override_get_current_user

    yield client

    app.dependency_overrides.clear()
