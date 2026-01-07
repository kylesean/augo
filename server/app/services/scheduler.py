"""Application scheduler service for background task scheduling.

This module provides a clean APScheduler-based background task scheduling
system with a modular job registration pattern.

Architecture:
- AppScheduler: Core scheduler lifecycle management
- ScheduledJob: Abstract base for domain-specific jobs
- Job modules: Each domain registers its own jobs

Usage:
    from app.services.scheduler import app_scheduler, init_scheduler

    # In lifespan:
    await init_scheduler()
"""

from abc import ABC, abstractmethod

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

from app.core.config import settings
from app.core.logging import logger


class ScheduledJob(ABC):
    """Abstract base class for scheduled jobs.

    Each domain (transactions, memory, etc.) should implement this
    interface to register its jobs with the scheduler.
    """

    @property
    @abstractmethod
    def job_id(self) -> str:
        """Unique identifier for this job."""
        pass

    @property
    @abstractmethod
    def job_name(self) -> str:
        """Human-readable name for this job."""
        pass

    @property
    @abstractmethod
    def trigger(self) -> CronTrigger:
        """Cron trigger defining when the job runs."""
        pass

    @abstractmethod
    async def execute(self) -> None:
        """Execute the job logic."""
        pass


class AppScheduler:
    """Core application scheduler.

    Manages APScheduler lifecycle and provides job registration.
    """

    def __init__(self) -> None:
        self._scheduler: AsyncIOScheduler | None = None
        self._jobs: list[ScheduledJob] = []

    def register_job(self, job: ScheduledJob) -> None:
        """Register a job to be scheduled on init."""
        self._jobs.append(job)

    def init(self) -> None:
        """Initialize the scheduler with all registered jobs."""
        if self._scheduler is not None:
            return

        self._scheduler = AsyncIOScheduler(
            job_defaults={
                "coalesce": True,
                "max_instances": 1,
                "misfire_grace_time": 3600,
            }
        )

        # Add all registered jobs
        for job in self._jobs:
            self._scheduler.add_job(
                job.execute,
                trigger=job.trigger,
                id=job.job_id,
                name=job.job_name,
                replace_existing=True,
            )
            logger.info(
                "scheduled_job_registered",
                job_id=job.job_id,
                job_name=job.job_name,
            )

        logger.info(
            "scheduler_initialized",
            total_jobs=len(self._jobs),
        )

    def start(self) -> None:
        """Start the scheduler."""
        if self._scheduler is None:
            self.init()

        if not self._scheduler.running:
            self._scheduler.start()
            logger.info("scheduler_started")

    def shutdown(self) -> None:
        """Shutdown the scheduler."""
        if self._scheduler is not None and self._scheduler.running:
            self._scheduler.shutdown(wait=False)
            logger.info("scheduler_stopped")

    def is_running(self) -> bool:
        """Check if the scheduler is running."""
        return self._scheduler is not None and self._scheduler.running


# Global scheduler instance
app_scheduler = AppScheduler()


# ============================================================================
# Job Implementations
# ============================================================================


class RecurringTransactionJob(ScheduledJob):
    """Process due recurring transactions daily."""

    @property
    def job_id(self) -> str:
        return "process_recurring_transactions"

    @property
    def job_name(self) -> str:
        return "Process Due Recurring Transactions"

    @property
    def trigger(self) -> CronTrigger:
        return CronTrigger(hour=0, minute=5)

    async def execute(self) -> None:
        from app.services.recurring_transaction_jobs import process_due_transactions

        await process_due_transactions()


class UpdateNextExecutionJob(ScheduledJob):
    """Update next execution dates for recurring transactions hourly."""

    @property
    def job_id(self) -> str:
        return "update_next_execution_dates"

    @property
    def job_name(self) -> str:
        return "Update Next Execution Dates"

    @property
    def trigger(self) -> CronTrigger:
        return CronTrigger(hour="*", minute=30)

    async def execute(self) -> None:
        from app.services.recurring_transaction_jobs import update_next_execution_dates

        await update_next_execution_dates()


class ExchangeRateUpdateJob(ScheduledJob):
    """Update exchange rates daily."""

    @property
    def job_id(self) -> str:
        return "update_exchange_rates"

    @property
    def job_name(self) -> str:
        return "Update Exchange Rates"

    @property
    def trigger(self) -> CronTrigger:
        return CronTrigger(
            hour=settings.EXCHANGE_RATE_CRON_HOUR,
            minute=settings.EXCHANGE_RATE_CRON_MINUTE,
        )

    async def execute(self) -> None:
        from app.services.exchange_rate_service import update_exchange_rates

        await update_exchange_rates()


class MemoryCleanupJob(ScheduledJob):
    """Clean up old user memories daily."""

    @property
    def job_id(self) -> str:
        return "cleanup_user_memories"

    @property
    def job_name(self) -> str:
        return "Cleanup Old User Memories"

    @property
    def trigger(self) -> CronTrigger:
        return CronTrigger(hour=3, minute=0)

    async def execute(self) -> None:
        from app.services.memory_cleanup_jobs import cleanup_all_user_memories

        await cleanup_all_user_memories()


# ============================================================================
# Register all jobs
# ============================================================================


def _register_all_jobs() -> None:
    """Register all scheduled jobs with the app scheduler."""
    app_scheduler.register_job(RecurringTransactionJob())
    app_scheduler.register_job(UpdateNextExecutionJob())

    if settings.EXCHANGE_RATE_API_URL:
        app_scheduler.register_job(ExchangeRateUpdateJob())

    app_scheduler.register_job(MemoryCleanupJob())


# Register jobs on module load
_register_all_jobs()


# ============================================================================
# Public API
# ============================================================================


async def init_scheduler() -> None:
    """Initialize and start the application scheduler."""
    app_scheduler.init()
    app_scheduler.start()


async def shutdown_scheduler() -> None:
    """Shutdown the application scheduler."""
    app_scheduler.shutdown()
