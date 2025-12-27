#!/bin/bash
set -e

# Augo Assistant - Unified Management Script
# This script provides a central entry point for all development and deployment tasks.

# COLORS
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

function help() {
    echo -e "${GREEN}Augo Assistant Management Tool${NC}"
    echo "Usage: ./manage.sh <command> [env]"
    echo ""
    echo "Commands:"
    echo "  setup            - Initial setup: create .env from example, install deps, bootstrap db"
    echo "  start            - Start the application locally using .env"
    echo "  bootstrap        - Run database initialization (LangGraph + Mem0)"
    echo "  docker-up        - Build and start Docker containers"
    echo "  docker-down      - Stop and remove Docker containers"
    echo "  docker-logs      - Follow Docker container logs"
    echo "  lint             - Run linting checks (Ruff)"
    echo "  format           - Run code formatting (Ruff/Black)"
    echo "  test             - Run tests"
    echo ""
    echo "Note: Most commands use .env by default. [env] argument is optional."
}

if [ $# -lt 1 ]; then
    help
    exit 1
fi

COMMAND=$1
ENV=${2:-development}

# Special handling for commands that don't need environment
if [[ "$COMMAND" =~ ^(lint|format|test)$ ]]; then
    case $COMMAND in
        lint)
            uv run ruff check .
            ;;
        format)
            uv run ruff format .
            ;;
        test)
            uv run pytest
            ;;
    esac
    exit 0
fi

# LOAD ENVIRONMENT
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ ! -f "scripts/set_env.sh" ]; then
    echo -e "${RED}Error: scripts/set_env.sh not found. Run from server root.${NC}"
    exit 1
fi

# Source environment variables (non-interactive in scripts unless setup)
if [ "$COMMAND" == "setup" ]; then
    source scripts/set_env.sh "$ENV"
else
    # Non-interactive source
    source scripts/set_env.sh "$ENV" &> /dev/null || true
fi

case $COMMAND in
    setup)
        echo -e "${GREEN}Starting setup for $ENV environment...${NC}"
        
        # Connectivity Check Loop
        while true; do
            echo -e "${GREEN}Verifying database connectivity...${NC}"
            if uv run python scripts/check_db.py; then
                break
            else
                echo -e ""
                echo -e "${YELLOW}Wait! Database is not ready yet.${NC}"
                echo -e "1. Ensure Postgres is running."
                echo -e "2. Check ${PURPLE}.env${NC} for correct ${GREEN}POSTGRES_PASSWORD${NC}."
                echo -e ""
                read -p "Press [Enter] to re-verify connectivity, or Ctrl+C to abort..."
                # Re-source .env in case it was edited
                set -a
                [ -f .env ] && source .env
                set +a
            fi
        done

        uv sync
        echo -e "${GREEN}Bootstrapping database...${NC}"
        export PYTHONPATH=$PYTHONPATH:.
        uv run python scripts/bootstrap.py
        echo -e "${GREEN}Setup complete!${NC}"
        echo -e ""
        echo -e "${YELLOW}===== NEXT STEPS =====${NC}"
        echo -e "1. Check your ${PURPLE}.env${NC} for ${GREEN}OPENAI_API_KEY${NC} or other LLM keys."
        echo -e "2. Start the server with: ${GREEN}./manage.sh start${NC}"
        echo -e "${YELLOW}======================${NC}"
        ;;
    start)
        echo -e "${GREEN}Starting application in $ENV...${NC}"
        export PYTHONPATH=$PYTHONPATH:.
        # Show QR code for mobile app configuration
        uv run python scripts/show_qr.py 2>/dev/null || true
        # Bind to 0.0.0.0 to allow LAN access
        uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
        ;;
    bootstrap)
        echo -e "${GREEN}Initializing database components...${NC}"
        export PYTHONPATH=$PYTHONPATH:.
        uv run python scripts/bootstrap.py
        ;;
    docker-up)
        echo -e "${GREEN}Starting Docker for $ENV...${NC}"
        bash scripts/build-docker.sh "$ENV"
        bash scripts/run-docker.sh "$ENV"
        bash scripts/ensure-db-user.sh "$ENV"
        ;;
    docker-down)
        bash scripts/stop-docker.sh "$ENV"
        ;;
    docker-logs)
        bash scripts/logs-docker.sh "$ENV"
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        help
        exit 1
        ;;
esac
