#!/bin/bash
# ==============================================================================
# Docker Entrypoint Script
# ==============================================================================
# This script handles application initialization:
# 1. Environment variable loading
# 2. Service connectivity checks
# 3. Database migrations (Alembic)
# 4. External component initialization (LangGraph, Mem0)
# ==============================================================================

set -e

# ==============================================================================
# Environment Loading
# ==============================================================================

echo "Starting with environment: ${APP_ENV:-development}"

# Load environment variables from .env files
load_env_file() {
    local env_file=$1
    if [ -f "$env_file" ]; then
        echo "Loading environment from $env_file"
        while IFS= read -r line || [[ -n "$line" ]]; do
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$line" ]] && continue
            key=$(echo "$line" | cut -d '=' -f 1)
            if [[ -z "${!key}" ]]; then
                export "$line"
            fi
        done <"$env_file"
        return 0
    fi
    return 1
}

if ! load_env_file ".env.${APP_ENV}"; then
    if ! load_env_file ".env"; then
        echo "Warning: No .env file found. Using system environment variables."
    fi
fi

# ==============================================================================
# Required Environment Variables Check
# ==============================================================================

required_vars=("JWT_SECRET_KEY" "OPENAI_API_KEY")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
    echo "ERROR: Missing required environment variables:"
    for var in "${missing_vars[@]}"; do
        echo "  - $var"
    done
    exit 1
fi

echo ""
echo "Configuration:"
echo "  Environment: ${APP_ENV:-development}"
echo "  LLM Model: ${DEFAULT_LLM_MODEL:-Not set}"

# ==============================================================================
# Service Connectivity Checks
# ==============================================================================

echo ""
echo "Verifying service connectivity..."
export PYTHONPATH=.

if command -v python &>/dev/null; then
    echo "Checking Database..."
    python scripts/check_db.py || (sleep 5 && python scripts/check_db.py) || exit 1

    echo "Checking Redis (optional)..."
    python scripts/check_redis.py || echo "Redis not available - continuing without cache"
fi

# ==============================================================================
# Database Migrations (Alembic)
# ==============================================================================

echo ""
echo "Running database migrations..."
alembic upgrade head
echo "Database migrations completed."

# ==============================================================================
# External Component Initialization
# ==============================================================================

echo ""
echo "Initializing external components (LangGraph, Mem0)..."
python scripts/bootstrap.py
echo "Bootstrap completed."

# ==============================================================================
# Start Application
# ==============================================================================

echo ""
echo "Starting application..."
exec "$@"
