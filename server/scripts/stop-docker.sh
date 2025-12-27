#!/bin/bash
set -e

# Script to stop and remove Docker containers

if [ $# -ne 1 ]; then
    echo "Usage: $0 <environment>"
    echo "Environments: development, staging, production"
    exit 1
fi

ENV=$1

# Validate environment
if [[ ! "$ENV" =~ ^(development|staging|production)$ ]]; then
    echo "Invalid environment. Must be one of: development, staging, production"
    exit 1
fi

echo "Stopping and removing all Augo services for $ENV environment..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$SERVER_DIR/.." && pwd)"
ENV_FILE="$SERVER_DIR/.env.$ENV"

cd "$PROJECT_ROOT"

if [ -f "$ENV_FILE" ]; then
    APP_ENV=$ENV docker compose --env-file "$ENV_FILE" down
else
    APP_ENV=$ENV docker compose down
fi

echo "Augo services stopped and removed successfully"
