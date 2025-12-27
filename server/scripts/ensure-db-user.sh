#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <environment>"
  echo "Environments: development, staging, production"
  exit 1
fi

ENV=$1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env.$ENV"

if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from $ENV_FILE for database initialization"
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
else
  echo "Warning: $ENV_FILE not found. Falling back to current environment for database initialization."
fi

POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
POSTGRES_DB=${POSTGRES_DB:-augo_db}

DOCKER_COMPOSE_BIN=${DOCKER_COMPOSE_BIN:-docker compose}
IFS=' ' read -r -a DC_CMD <<< "$DOCKER_COMPOSE_BIN"

echo "Waiting for PostgreSQL service to be ready..."
MAX_ATTEMPTS=30
SLEEP_SECONDS=2
attempt=1

until "${DC_CMD[@]}" exec -T db pg_isready -U postgres >/dev/null 2>&1; do
  if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
    echo "PostgreSQL service did not become ready in time."
    exit 1
  fi
  attempt=$((attempt + 1))
  sleep "$SLEEP_SECONDS"
done

echo "Ensuring role '$POSTGRES_USER' and database '$POSTGRES_DB' exist"

# Run initialization queries
echo "Checking and creating role..."
"${DC_CMD[@]}" exec -T db psql -U postgres -c "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$POSTGRES_USER') THEN CREATE ROLE \"$POSTGRES_USER\" WITH LOGIN PASSWORD '$POSTGRES_PASSWORD'; END IF; END \$\$;"

echo "Checking and creating database..."
# Checking database existence and creating it if missing
DB_EXISTS=$("${DC_CMD[@]}" exec -T db psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'")
if [ "$DB_EXISTS" != "1" ]; then
    "${DC_CMD[@]}" exec -T db psql -U postgres -c "CREATE DATABASE \"$POSTGRES_DB\" OWNER \"$POSTGRES_USER\";"
else
    echo "Database '$POSTGRES_DB' already exists."
fi

echo "Granting privileges..."
"${DC_CMD[@]}" exec -T db psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"$POSTGRES_DB\" TO \"$POSTGRES_USER\";"

# Crucial for AI projects: Ensure pgvector extension
echo "Ensuring pgvector extension in database '$POSTGRES_DB'"
"${DC_CMD[@]}" exec -T db psql -U postgres -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS vector;"

echo "PostgreSQL initialization completed successfully"

