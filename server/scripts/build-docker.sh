#!/bin/bash
set -e

# Script to securely build Docker images without exposing secrets in build output

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

echo "Building Docker image for $ENV environment"

# Get the directory where this script is located and change to server directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$(dirname "$SCRIPT_DIR")"
cd "$SERVER_DIR"

echo "Working directory: $(pwd)"

# Check if env file exists
ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Warning: $ENV_FILE not found. Creating from .env.example"
    if [ ! -f .env.example ]; then
        echo "Error: .env.example not found"
        exit 1
    fi
    cp .env.example "$ENV_FILE"
    echo "Please update $ENV_FILE with your configuration before running the container"
fi

echo "Loading environment variables from $ENV_FILE (secrets masked)"

# Securely load environment variables
set -a
source "$ENV_FILE"
set +a

# Add a helper to mask any set values
mask_env() {
    local value="$1"
    if [ -z "$value" ]; then
        echo "Not set"
    else
        echo "********"
    fi
}

# Print confirmation with masked values
echo "Environment: $ENV"
echo "Database host: $(mask_env "${POSTGRES_HOST:-${DB_HOST:-}}")"
echo "Database port: $(mask_env "${POSTGRES_PORT:-${DB_PORT:-}}")"
echo "Database name: $(mask_env "${POSTGRES_DB:-${DB_NAME:-}}")"
echo "Database user: $(mask_env "${POSTGRES_USER:-${DB_USER:-}}")"
echo "API keys: ******** (masked for security)"

# Build the Docker image
docker build --no-cache \
    --build-arg APP_ENV="$ENV" \
    -t augo-api:"$ENV" .

echo "Docker image augo-api:$ENV built successfully"
