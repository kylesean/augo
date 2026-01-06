# Augo Project Makefile
# This is a thin wrapper that delegates to ./server/manage.sh
# For detailed command help, run: cd server && ./manage.sh

.PHONY: help install setup start dev test lint format clean \
        docker-up docker-down docker-logs docker-build \
        client-run client-build

# Default target
help:
	@echo "Augo Project Commands"
	@echo "====================="
	@echo ""
	@echo "Quick Start:"
	@echo "  make setup-all - Full setup (server & client)"
	@echo "  make setup     - Initial project setup (server)"
	@echo "  make start     - Start server locally"
	@echo "  make dev       - Start server in dev mode (alias for start)"
	@echo ""
	@echo "Development:"
	@echo "  make lint      - Run linting checks"
	@echo "  make format    - Format code"
	@echo "  make test      - Run tests"
	@echo ""
	@echo "Database Migrations:"
	@echo "  make db-migrate MSG='description' - Generate migration from model changes"
	@echo "  make db-upgrade                   - Apply pending migrations"
	@echo "  make db-downgrade                 - Rollback last migration"
	@echo "  make db-current                   - Show current migration version"
	@echo "  make db-check                     - Check if schema is in sync"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-up   - Build and start all Docker services"
	@echo "  make docker-down - Stop all Docker services"
	@echo "  make docker-logs - View Docker logs"
	@echo ""
	@echo "Client (Flutter):"
	@echo "  make client-run   - Run Flutter client"
	@echo "  make client-build - Build Flutter release"
	@echo ""
	@echo "For more commands: cd server && ./manage.sh"

# ============================================================
# Server Commands (delegate to manage.sh)
# ============================================================

install:
	cd server && uv sync
	cd client && flutter pub get

setup:
	cd server && ./manage.sh setup

setup-all: setup
	cd client && flutter pub get

start:
	cd server && ./manage.sh start

dev: start

test:
	cd server && ./manage.sh test

lint:
	cd server && ./manage.sh lint

format:
	cd server && ./manage.sh format

bootstrap:
	cd server && ./manage.sh bootstrap

# ============================================================
# Database Migration Commands
# ============================================================

# Generate a new migration from model changes
# Usage: make db-migrate MSG="add_user_avatar_field"
db-migrate:
ifndef MSG
	$(error MSG is required. Usage: make db-migrate MSG="description")
endif
	cd server && uv run alembic revision --autogenerate -m "$(MSG)"

# Apply all pending migrations
db-upgrade:
	cd server && uv run alembic upgrade head

# Rollback the last migration
db-downgrade:
	cd server && uv run alembic downgrade -1

# Show migration history
db-history:
	cd server && uv run alembic history --verbose

# Show current migration version
db-current:
	cd server && uv run alembic current

# Check if models match database schema
db-check:
	cd server && uv run alembic check

# Stamp database with a specific revision without running migrations
# Usage: make db-stamp REV="001"
db-stamp:
ifndef REV
	$(error REV is required. Usage: make db-stamp REV="001")
endif
	cd server && uv run alembic stamp $(REV)

# ============================================================
# Docker Commands
# ============================================================

docker-up:
	cd server && ./manage.sh docker-up
	@echo "Checking services status..."
	@sleep 3
	@cd server && uv run python scripts/show_qr.py

docker-down:
	cd server && ./manage.sh docker-down

docker-logs:
	cd server && ./manage.sh docker-logs

docker-build:
	cd server && ./scripts/build-docker.sh production

# ============================================================
# Client (Flutter) Commands
# ============================================================

client-run:
	cd client && flutter run

client-build:
	cd client && flutter build apk --release

client-test:
	cd client && flutter test

client-analyze:
	cd client && flutter analyze

# ============================================================
# Utilities
# ============================================================

clean:
	rm -rf server/.venv
	rm -rf server/__pycache__
	rm -rf server/.pytest_cache
	rm -rf client/build

# Generate secure keys
gen-keys:
	@echo "JWT_SECRET_KEY=$$(cd server && uv run python -c 'import secrets; print(secrets.token_hex(32))')"
	@echo "ENCRYPTION_KEY=$$(cd server && uv run python -c 'from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())')"

# ============================================================
# Security & Quality Commands
# ============================================================

# Run dependency security audit
audit:
	cd server && uv run pip-audit --strict

# Run type checking with mypy
typecheck:
	cd server && uv run mypy .

# Run all quality checks (lint, typecheck, audit)
check-all: lint typecheck audit
	@echo "All quality checks passed!"