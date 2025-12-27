"""Application configuration management.

This module handles environment-specific configuration loading, parsing, and management
for the application. It includes environment detection, .env file loading, and
configuration value parsing using Pydantic Settings.
"""

import os
from enum import Enum
from pathlib import Path
from typing import List, Optional

from dotenv import load_dotenv
from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


# Define environment types
class Environment(str, Enum):
    """Application environment types.

    Defines the possible environments the application can run in:
    development, staging, production, and test.
    """

    DEVELOPMENT = "development"
    STAGING = "staging"
    PRODUCTION = "production"
    TEST = "test"


# Determine environment
def get_environment() -> Environment:
    """Get the current environment.

    Returns:
        Environment: The current environment (development, staging, production, or test)
    """
    match os.getenv("APP_ENV", "development").lower():
        case "production" | "prod":
            return Environment.PRODUCTION
        case "staging" | "stage":
            return Environment.STAGING
        case "test":
            return Environment.TEST
        case _:
            return Environment.DEVELOPMENT


# Load appropriate .env file based on environment
def load_env_file():
    """Load environment-specific .env file with priority:
    1. .env (the main user-config)
    2. .env.{env} (environment-specific override)
    3. .env.local (local developer override)
    """
    env = get_environment()
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))

    # Priority order
    env_files = [
        os.path.join(base_dir, ".env"),
        os.path.join(base_dir, f".env.{env.value}"),
        os.path.join(base_dir, ".env.local"),
    ]

    # Load all existing env files in reverse priority (so highest priority loads last and overrides)
    loaded_any = False
    for env_file in reversed(env_files):
        if os.path.isfile(env_file):
            load_dotenv(dotenv_path=env_file, override=True)
            loaded_any = True

    return ".env" if loaded_any else None


ENV_FILE = load_env_file()


class Settings(BaseSettings):
    """Application settings using Pydantic Settings.

    Automatically loads configuration from environment variables and .env files.
    Provides type validation and environment-specific defaults.
    """

    model_config = SettingsConfigDict(
        env_file=ENV_FILE,
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
        # Don't try to parse JSON for these fields
        env_parse_none_str="null",
    )

    # Environment
    ENVIRONMENT: Environment = Field(default_factory=get_environment)

    # Application Settings
    PROJECT_NAME: str = "Augo"
    VERSION: str = "0.1.0"
    DESCRIPTION: str = "AI-powered expense tracking and financial management system"
    API_V1_STR: str = "/api/v1"
    DEBUG: bool = False

    # CORS Settings
    ALLOWED_ORIGINS: str = "*"

    # Langfuse Configuration
    LANGFUSE_PUBLIC_KEY: str = ""
    LANGFUSE_SECRET_KEY: str = ""
    LANGFUSE_HOST: str = "https://cloud.langfuse.com"

    # LLM Configuration
    OPENAI_API_KEY: str = Field("", validation_alias="OPENAI_API_KEY")
    OPENAI_BASE_URL: Optional[str] = Field(None, validation_alias="OPENAI_BASE_URL")
    DEFAULT_LLM_MODEL: str = "gpt-4o-mini"
    DEFAULT_LLM_TEMPERATURE: float = 0.2
    MAX_TOKENS: int = 2000
    MAX_LLM_CALL_RETRIES: int = 3

    # Long term memory Configuration (Mem0)
    # Supported Embedder Providers: "openai", "ollama", "huggingface", "azure_openai"
    LONG_TERM_MEMORY_MODEL: str = "gpt-4o-mini"  # LLM for memory extraction
    LONG_TERM_MEMORY_EMBEDDER_PROVIDER: str = "openai"  # openai, ollama, huggingface
    LONG_TERM_MEMORY_EMBEDDER_MODEL: str = "text-embedding-3-small"
    LONG_TERM_MEMORY_EMBEDDER_DIMS: int = 1024  # Embedding dimensions
    LONG_TERM_MEMORY_COLLECTION_NAME: str = "longterm_memory"
    LONG_TERM_MEMORY_EMBEDDER_API_KEY: Optional[str] = None  # For openai/huggingface
    LONG_TERM_MEMORY_EMBEDDER_BASE_URL: Optional[str] = None  # For openai-compatible APIs
    LONG_TERM_MEMORY_OLLAMA_BASE_URL: Optional[str] = None  # For ollama: http://localhost:11434

    # JWT Configuration
    JWT_SECRET_KEY: str = Field(default="change-this-secret-key-in-production")
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_TOKEN_EXPIRE_DAYS: int = 30

    # Base Directory
    BASE_DIR: Path = Field(default=Path(__file__).parent.parent.parent)

    # Logging Configuration
    LOG_DIR: Path = Field(default_factory=lambda: Path(__file__).parent.parent.parent / "logs")
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "json"  # "json" or "console"

    # PostgresSQL Configuration
    POSTGRES_HOST: str = "localhost"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "augo"
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "postgres"
    POSTGRES_POOL_SIZE: int = 20
    POSTGRES_MAX_OVERFLOW: int = 10
    CHECKPOINT_TABLES: List[str] = ["checkpoint_blobs", "checkpoint_writes", "checkpoints"]

    # Redis Configuration
    REDIS_HOST: str = "localhost"
    REDIS_PORT: int = 6379
    REDIS_DB: int = 0
    REDIS_PASSWORD: Optional[str] = None
    REDIS_POOL_SIZE: int = 10

    # Exchange Rate API Configuration
    EXCHANGE_RATE_API_URL: Optional[str] = None  # e.g., https://v6.exchangerate-api.com/v6/{API_KEY}/latest/USD
    EXCHANGE_RATE_CACHE_KEY: str = "exchange_rates:usd"  # Redis key for caching exchange rates
    EXCHANGE_RATE_CACHE_TTL: int = 86400  # Cache TTL in seconds (24 hours)
    EXCHANGE_RATE_CRON_HOUR: int = 0  # Hour to run the scheduled update (UTC)
    EXCHANGE_RATE_CRON_MINUTE: int = 0  # Minute to run the scheduled update (UTC)

    # File Upload Configuration
    UPLOAD_DIR: Path = Field(default_factory=lambda: Path(__file__).parent.parent.parent / "storage" / "uploads")
    MAX_UPLOAD_SIZE: int = 10485760  # 10MB
    ALLOWED_MIME_TYPES: str = "image/jpeg,image/png,image/webp,application/pdf"

    # Storage System Configuration
    ENCRYPTION_KEY: Optional[str] = None  # Fernet key for credential encryption
    FILE_URL_EXPIRE_SECONDS: int = 3600  # Signed URL expiration time
    APP_URL: str = "http://localhost:8000"  # Base URL for signed URLs

    # Rate Limiting Configuration
    RATE_LIMIT_DEFAULT: str = "200 per day,50 per hour"
    RATE_LIMIT_CHAT: str = "30 per minute"
    RATE_LIMIT_CHAT_STREAM: str = "20 per minute"
    RATE_LIMIT_MESSAGES: str = "50 per minute"
    RATE_LIMIT_LOGIN: str = "20 per minute"
    RATE_LIMIT_REGISTER: str = "10 per hour"

    @property
    def RATE_LIMIT_ENDPOINTS(self) -> dict:
        """Get rate limit configuration for endpoints."""
        return {
            "root": [self.RATE_LIMIT_DEFAULT],
            "health": [self.RATE_LIMIT_DEFAULT],
            "register": [self.RATE_LIMIT_REGISTER],
            "login": [self.RATE_LIMIT_LOGIN],
            "chat": [self.RATE_LIMIT_CHAT],
            "chat_stream": [self.RATE_LIMIT_CHAT_STREAM],
            "messages": [self.RATE_LIMIT_MESSAGES],
        }

    # Verification Code Settings
    CODE_EXPIRY_SECONDS: int = 300  # 5 minutes
    SMS_PROVIDER: str = "mock"  # mock, aliyun, twilio
    EMAIL_PROVIDER: str = "mock"  # mock, smtp

    # SMTP Settings
    SMTP_HOST: str = "localhost"
    SMTP_PORT: int = 587
    SMTP_USER: Optional[str] = None
    SMTP_PASSWORD: Optional[str] = None
    SMTP_FROM_EMAIL: str = "noreply@localhost"
    SMTP_FROM_NAME: str = "Augo"

    # Evaluation Configuration
    EVALUATION_LLM: str = "gpt-4o"
    EVALUATION_BASE_URL: str = "https://api.openai.com/v1"
    EVALUATION_API_KEY: Optional[str] = None
    EVALUATION_SLEEP_TIME: int = 10

    # Monitoring
    ENABLE_METRICS: bool = False
    METRICS_PORT: int = 9090

    @property
    def allowed_origins_list(self) -> List[str]:
        """Get CORS origins as a list."""
        if isinstance(self.ALLOWED_ORIGINS, list):
            return self.ALLOWED_ORIGINS
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",") if origin.strip()]

    @property
    def allowed_mime_types_list(self) -> List[str]:
        """Get allowed MIME types as a list."""
        if isinstance(self.ALLOWED_MIME_TYPES, list):
            return self.ALLOWED_MIME_TYPES
        return [mime.strip() for mime in self.ALLOWED_MIME_TYPES.split(",") if mime.strip()]

    @field_validator("LOG_DIR", "UPLOAD_DIR", mode="before")
    @classmethod
    def parse_path(cls, v) -> Path:
        """Convert string to Path object."""
        if isinstance(v, Path):
            return v
        return Path(v)

    @property
    def database_url(self) -> str:
        """Get PostgresSQL database URL for SQLAlchemy."""
        return (
            f"postgresql+asyncpg://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}"
            f"@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )

    @property
    def database_url_sync(self) -> str:
        """Get PostgresSQL database URL for synchronous operations (Alembic)."""
        return (
            f"postgresql://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}"
            f"@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )

    @property
    def redis_url(self) -> str:
        """Get Redis connection URL."""
        if self.REDIS_PASSWORD:
            return f"redis://:{self.REDIS_PASSWORD}@{self.REDIS_HOST}:{self.REDIS_PORT}/{self.REDIS_DB}"
        return f"redis://{self.REDIS_HOST}:{self.REDIS_PORT}/{self.REDIS_DB}"

    def model_post_init(self, __context) -> None:
        """Apply environment-specific settings after initialization."""
        # Handle aliases for LLM settings if not established by Pydantic
        # This provides a fallback if the user uses legacy naming like OPENAI_API_BASE
        if not self.OPENAI_BASE_URL:
            self.OPENAI_BASE_URL = os.getenv("OPENAI_API_BASE")

        if not self.OPENAI_API_KEY:
            self.OPENAI_API_KEY = os.getenv("DEEPSEEK_API_KEY") or os.getenv("LLM_API_KEY")

        # Apply environment-specific overrides
        if self.ENVIRONMENT == Environment.DEVELOPMENT:
            if "DEBUG" not in os.environ:
                self.DEBUG = True
            if "LOG_LEVEL" not in os.environ:
                self.LOG_LEVEL = "DEBUG"
            if "LOG_FORMAT" not in os.environ:
                self.LOG_FORMAT = "console"
        elif self.ENVIRONMENT == Environment.PRODUCTION:
            if "DEBUG" not in os.environ:
                self.DEBUG = False
            if "LOG_LEVEL" not in os.environ:
                self.LOG_LEVEL = "WARNING"
        elif self.ENVIRONMENT == Environment.STAGING:
            if "DEBUG" not in os.environ:
                self.DEBUG = False
            if "LOG_LEVEL" not in os.environ:
                self.LOG_LEVEL = "INFO"

        # Ensure directories exist
        self.LOG_DIR.mkdir(parents=True, exist_ok=True)
        self.UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

        # Sanitize proxy environment variables to prevent Pydantic validation errors
        # Change socks:// to socks5:// as "socks" is not a recognized scheme by httpx/pydantic
        for proxy_var in ["HTTP_PROXY", "HTTPS_PROXY", "ALL_PROXY", "http_proxy", "https_proxy", "all_proxy"]:
            val = os.environ.get(proxy_var)
            if val and val.startswith("socks://"):
                new_val = val.replace("socks://", "socks5://", 1)
                os.environ[proxy_var] = new_val


# Create settings instance
settings = Settings()
