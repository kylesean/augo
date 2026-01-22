from collections.abc import AsyncGenerator, Generator
from unittest.mock import MagicMock
from uuid import uuid4

import pytest
import pytest_asyncio
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

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.main import app
from app.models.user import User

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
from app.models.base import Base  # noqa: F401, E402

# --- Fixtures ---


@pytest_asyncio.fixture(scope="function")
async def async_db_engine() -> AsyncGenerator[AsyncEngine]:
    """Create a reusable SQLite engine for tests.
    Use StaticPool to share data in memory across the session.
    """
    engine = create_async_engine(
        "sqlite+aiosqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )

    # Initialize DB schema
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    yield engine

    await engine.dispose()


@pytest_asyncio.fixture(scope="function", autouse=True)
async def setup_db_manager(async_db_engine: AsyncEngine) -> None:
    """Inject the test engine into the global db_manager before each test.
    This ensures the app's startup lifespan (init_db) uses the SQLite engine.
    """
    from app.core.database import db_manager

    db_manager._engine = async_db_engine
    db_manager.init_session_factory()


@pytest_asyncio.fixture(scope="function")
async def db_session(async_db_engine: AsyncEngine) -> AsyncGenerator[AsyncSession]:
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


@pytest.fixture(scope="function")
def client() -> Generator[TestClient]:
    with TestClient(app) as c:
        yield c


@pytest.fixture(autouse=True)
def setup_test_env(monkeypatch):
    """Setup test environment variables and core mocks."""
    # 1. Inject mandatory keys to prevent init errors
    monkeypatch.setenv("APP_ENV", "test")
    monkeypatch.setenv("DATABASE_URL", "sqlite+aiosqlite:///:memory:")
    monkeypatch.setenv("ENCRYPTION_KEY", "v3u8eA7-R5i_oX6DozID8lH_l6ApxfGqI8Xh-8o9mG4=")
    monkeypatch.setenv("OPENAI_API_KEY", "sk-test-key-for-unit-tests")
    monkeypatch.setenv("JWT_SECRET_KEY", "test-secret-key")

    # 2. Prevent mem0 from actually trying to connect to anything
    from unittest.mock import AsyncMock

    from mem0 import AsyncMemory

    # We mock from_config so MemoryService initialization succeeds seamlessly
    mock_mem0 = AsyncMock(spec=AsyncMemory)
    monkeypatch.setattr(AsyncMemory, "from_config", AsyncMock(return_value=mock_mem0))

    return mock_mem0


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
def client_with_auth(client: TestClient, db_session: AsyncSession, test_user: User) -> Generator[TestClient]:
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
