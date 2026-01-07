"""Logging configuration and setup for the application.

This module provides structured logging configuration using structlog,
with environment-specific formatters and handlers. It supports both
console-friendly development logging and JSON-formatted production logging.
"""

from __future__ import annotations

import json
import logging
import sys
from contextvars import ContextVar
from datetime import datetime, timedelta
from pathlib import Path
from typing import (
    Any,
)

import structlog

from app.core.config import (
    Environment,
    settings,
)

# Ensure log directory exists
settings.LOG_DIR.mkdir(parents=True, exist_ok=True)

# Context variables for storing request-specific data
_request_context: ContextVar[dict[str, Any] | None] = ContextVar("request_context", default=None)


def bind_context(**kwargs: Any) -> None:
    """Bind context variables to the current request.

    Args:
        **kwargs: Key-value pairs to bind to the logging context
    """
    current = _request_context.get()
    _request_context.set({**(current or {}), **kwargs})


def clear_context() -> None:
    """Clear all context variables for the current request."""
    _request_context.set({})


def get_context() -> dict[str, Any]:
    """Get the current logging context.

    Returns:
        Dict[str, Any]: Current context dictionary
    """
    return _request_context.get() or {}


def add_context_to_event_dict(logger: Any, method_name: str, event_dict: dict[str, Any]) -> dict[str, Any]:
    """Add context variables to the event dictionary.

    This processor adds any bound context variables to each log event.

    Args:
        logger: The logger instance
        method_name: The name of the logging method
        event_dict: The event dictionary to modify

    Returns:
        Dict[str, Any]: Modified event dictionary with context variables
    """
    context = get_context()
    if context:
        event_dict.update(context)
    return event_dict


def get_log_file_path() -> Path:
    """Get the current log file path based on date and environment.

    Returns:
        Path: The path to the log file
    """
    env_prefix = settings.ENVIRONMENT.value
    return settings.LOG_DIR / f"{env_prefix}-{datetime.now().strftime('%Y-%m-%d')}.jsonl"


class JsonlFileHandler(logging.Handler):
    """Custom handler for writing JSONL logs to daily files with rotation support.

    Features:
    - Daily log file rotation (date-based naming)
    - Size-based rotation (max 50MB per file)
    - Automatic cleanup of old log files (keeps last 30 days)
    - Backup file numbering (.1, .2, etc.)
    """

    MAX_FILE_SIZE = 50 * 1024 * 1024  # 50MB max file size
    MAX_BACKUP_COUNT = 5  # Keep up to 5 backup files per day
    MAX_DAYS_TO_KEEP = 30  # Keep logs for 30 days

    def __init__(self, file_path: Path):
        """Initialize the JSONL file handler.

        Args:
            file_path: Path to the log file where entries will be written.
        """
        super().__init__()
        self.file_path = file_path
        self._current_date = datetime.now().strftime("%Y-%m-%d")
        self._cleanup_old_logs()

    def _get_current_file_path(self) -> Path:
        """Get the current log file path, updating if date changed."""
        current_date = datetime.now().strftime("%Y-%m-%d")
        if current_date != self._current_date:
            self._current_date = current_date
            self.file_path = get_log_file_path()
            self._cleanup_old_logs()
        return self.file_path

    def _should_rotate(self) -> bool:
        """Check if the current log file should be rotated based on size."""
        try:
            if self.file_path.exists():
                return self.file_path.stat().st_size >= self.MAX_FILE_SIZE
        except OSError:
            pass
        return False

    def _rotate_file(self) -> None:
        """Rotate the current log file by renaming with backup number."""
        if not self.file_path.exists():
            return

        # Find the next available backup number
        for i in range(self.MAX_BACKUP_COUNT, 0, -1):
            old_backup = self.file_path.with_suffix(f".jsonl.{i}")
            new_backup = self.file_path.with_suffix(f".jsonl.{i + 1}")
            if old_backup.exists():
                if i == self.MAX_BACKUP_COUNT:
                    # Delete oldest backup
                    old_backup.unlink()
                else:
                    old_backup.rename(new_backup)

        # Rename current file to .1
        backup_path = self.file_path.with_suffix(".jsonl.1")
        self.file_path.rename(backup_path)

    def _cleanup_old_logs(self) -> None:
        """Remove log files older than MAX_DAYS_TO_KEEP days."""
        try:
            log_dir = self.file_path.parent
            if not log_dir.exists():
                return

            cutoff_date = datetime.now() - timedelta(days=self.MAX_DAYS_TO_KEEP)

            for log_file in log_dir.glob("*.jsonl*"):
                try:
                    # Extract date from filename (format: {env}-YYYY-MM-DD.jsonl)
                    file_name = log_file.stem.split(".")[0]  # Remove backup suffix
                    date_part = file_name.split("-", 1)[-1] if "-" in file_name else None

                    if date_part:
                        try:
                            file_date = datetime.strptime(date_part, "%Y-%m-%d")
                            if file_date < cutoff_date:
                                log_file.unlink()
                        except ValueError:
                            # Unable to parse date, skip this file
                            pass
                except OSError:
                    pass
        except Exception:  # nosec B110
            # Don't let cleanup errors affect logging
            pass

    def emit(self, record: logging.LogRecord) -> None:
        """Emit a record to the JSONL file."""
        try:
            import re

            # Check for rotation before writing
            file_path = self._get_current_file_path()
            if self._should_rotate():
                self._rotate_file()

            # Remove ANSI escape codes from the message
            message = record.getMessage()
            # Pattern to match ANSI escape sequences
            ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
            clean_message = ansi_escape.sub("", message)

            log_entry = {
                "timestamp": datetime.fromtimestamp(record.created).isoformat(),
                "level": record.levelname,
                "message": clean_message,
                "module": record.module,
                "function": record.funcName,
                "filename": record.pathname,
                "line": record.lineno,
                "environment": settings.ENVIRONMENT.value,
            }
            if hasattr(record, "extra"):
                log_entry.update(record.extra)

            with open(file_path, "a", encoding="utf-8") as f:
                f.write(json.dumps(log_entry, ensure_ascii=False) + "\n")
        except Exception:
            self.handleError(record)

    def close(self) -> None:
        """Close the handler."""
        super().close()


def get_structlog_processors(include_file_info: bool = True) -> list[Any]:
    """Get the structlog processors based on configuration.

    Args:
        include_file_info: Whether to include file information in the logs

    Returns:
        List[Any]: List of structlog processors
    """
    # Set up processors that are common to both outputs
    processors = [
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        # Add context variables (user_uuid, session_id, etc.) to all log events
        add_context_to_event_dict,
    ]

    # Add callsite parameters if file info is requested
    if include_file_info:
        processors.append(
            structlog.processors.CallsiteParameterAdder(
                {
                    structlog.processors.CallsiteParameter.FILENAME,
                    structlog.processors.CallsiteParameter.FUNC_NAME,
                    structlog.processors.CallsiteParameter.LINENO,
                    structlog.processors.CallsiteParameter.MODULE,
                    structlog.processors.CallsiteParameter.PATHNAME,
                }
            )
        )

    # Add environment info
    processors.append(lambda _, __, event_dict: {**event_dict, "environment": settings.ENVIRONMENT.value})

    return processors


def setup_logging() -> None:
    """Configure structlog with different formatters based on environment.

    In development: pretty console output
    In staging/production: structured JSON logs
    """
    # Determine log level from settings
    log_level_map = {
        "DEBUG": logging.DEBUG,
        "INFO": logging.INFO,
        "WARNING": logging.WARNING,
        "ERROR": logging.ERROR,
        "CRITICAL": logging.CRITICAL,
    }
    log_level = log_level_map.get(settings.LOG_LEVEL.upper(), logging.INFO)

    # Create file handler for JSON logs
    file_handler = JsonlFileHandler(get_log_file_path())
    file_handler.setLevel(log_level)

    # Create console handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(log_level)

    # Get shared processors
    shared_processors = get_structlog_processors(
        # Include detailed file info only in development and test
        include_file_info=settings.ENVIRONMENT in [Environment.DEVELOPMENT, Environment.TEST]
    )

    # Configure standard logging
    logging.basicConfig(
        format="%(message)s",
        level=log_level,
        handlers=[file_handler, console_handler],
    )

    # Suppress verbose logs from third-party libraries
    # These libraries produce excessive DEBUG/TRACE logs
    logging.getLogger("httpx").setLevel(logging.WARNING)
    logging.getLogger("httpcore").setLevel(logging.WARNING)
    logging.getLogger("duckduckgo_search").setLevel(logging.WARNING)
    logging.getLogger("urllib3").setLevel(logging.WARNING)
    logging.getLogger("requests").setLevel(logging.WARNING)
    logging.getLogger("mem0").setLevel(logging.WARNING)
    logging.getLogger("openai").setLevel(logging.WARNING)

    # Configure structlog with separate formatters for console and file
    # File always uses JSON, console uses colors in development
    if settings.LOG_FORMAT == "console":
        # Development: Console with colors, File with JSON
        # We need to use a custom processor that routes to different renderers
        structlog.configure(
            processors=[
                *shared_processors,
                # Use ConsoleRenderer for pretty output (only affects console)
                structlog.dev.ConsoleRenderer(colors=True),
            ],
            wrapper_class=structlog.stdlib.BoundLogger,
            logger_factory=structlog.stdlib.LoggerFactory(),
            cache_logger_on_first_use=True,
        )
    else:
        # Production: JSON logging everywhere
        structlog.configure(
            processors=[
                *shared_processors,
                structlog.processors.JSONRenderer(),
            ],
            wrapper_class=structlog.stdlib.BoundLogger,
            logger_factory=structlog.stdlib.LoggerFactory(),
            cache_logger_on_first_use=True,
        )


# Initialize logging
setup_logging()

# Create logger instance
logger = structlog.get_logger()


def configure_log_level(level: str) -> None:
    """Dynamically configure log level at runtime.

    Args:
        level: Log level string (DEBUG, INFO, WARNING, ERROR, CRITICAL)
    """
    log_level_map = {
        "DEBUG": logging.DEBUG,
        "INFO": logging.INFO,
        "WARNING": logging.WARNING,
        "ERROR": logging.ERROR,
        "CRITICAL": logging.CRITICAL,
    }

    log_level = log_level_map.get(level.upper(), logging.INFO)
    logging.getLogger().setLevel(log_level)

    logger.info(
        "log_level_changed",
        new_level=level.upper(),
    )


# Log initialization
logger.info(
    "logging_initialized",
    environment=settings.ENVIRONMENT.value,
    log_level=settings.LOG_LEVEL,
    log_format=settings.LOG_FORMAT,
    debug=settings.DEBUG,
    log_dir=str(settings.LOG_DIR),
)
