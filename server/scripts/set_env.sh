# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced, not executed."
    echo "Usage: source ./scripts/set_env.sh [development|staging|production]"
    exit 1
fi

# Detect 'uv' tool
if ! command -v uv &> /dev/null; then
    echo -e "\033[0;33mWarning: 'uv' not found. It is recommended for managing dependencies.\033[0m"
    echo "Visit https://github.com/astral-sh/uv for installation instructions."
fi

# Define color codes for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Default environment is development
ENV=${1:-development}

# Validate environment
if [[ ! "$ENV" =~ ^(development|staging|production|test)$ ]]; then
    echo -e "${RED}Error: Invalid environment. Choose development, staging, production, or test.${NC}"
    return 1
fi

# Set environment variables
export APP_ENV=$ENV

# Get script directory and project root
# Using a simpler approach that works for most shells when sourced
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Determine the environment file to use
# We use .env as the single source of truth
if [ -f "$PROJECT_ROOT/.env" ]; then
    ENV_FILE="$PROJECT_ROOT/.env"
else
    echo -e "${YELLOW}No .env file found.${NC}"
    
    EXAMPLE_FILE="$PROJECT_ROOT/.env.example"
    if [ ! -f "$EXAMPLE_FILE" ]; then
        echo -e "${RED}Error: .env.example not found at $EXAMPLE_FILE${NC}"
        return 1
    fi

    # Interactive prompt for .env creation
    read -p "Would you like to create .env from template? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Error: Setup cannot continue without a .env file.${NC}"
        return 1
    else
        cp "$EXAMPLE_FILE" "$PROJECT_ROOT/.env"
        ENV_FILE="$PROJECT_ROOT/.env"
        echo -e "${GREEN}Created .env from template.${NC}"
        echo -e "${YELLOW}------------------------------------------------------------${NC}"
        echo -e "${PURPLE}Action Required: Please open and edit your '.env' file now.${NC}"
        echo -e "Update ${GREEN}POSTGRES_PASSWORD${NC}, ${GREEN}OPENAI_API_KEY${NC}, etc."
        echo -e "${YELLOW}------------------------------------------------------------${NC}"
        read -p "Press [Enter] after you have finished editing '.env' to continue setup..."
        echo -e "${GREEN}Continuing setup...${NC}"
    fi
fi

# Export variables if file exists
if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
    echo -e "${GREEN}Successfully exported variables from $ENV_FILE${NC}"
fi

# Print current environment
echo -e "\n${GREEN}======= ENVIRONMENT SUMMARY =======${NC}"
echo -e "${GREEN}Environment:     ${YELLOW}$ENV${NC}"
echo -e "${GREEN}Project root:    ${YELLOW}$PROJECT_ROOT${NC}"
echo -e "${GREEN}Project name:    ${YELLOW}${PROJECT_NAME:-Not set}${NC}"
echo -e "${GREEN}API version:     ${YELLOW}${VERSION:-Not set}${NC}"

echo -e "${GREEN}Database host:   ${YELLOW}${POSTGRES_HOST:-${DB_HOST:-Not set}}${NC}"
echo -e "${GREEN}Database port:   ${YELLOW}${POSTGRES_PORT:-${DB_PORT:-Not set}}${NC}"
echo -e "${GREEN}Database name:   ${YELLOW}${POSTGRES_DB:-${DB_NAME:-Not set}}${NC}"
echo -e "${GREEN}Database user:   ${YELLOW}${POSTGRES_USER:-${DB_USER:-Not set}}${NC}"

echo -e "${GREEN}LLM model:       ${YELLOW}${DEFAULT_LLM_MODEL:-Not set}${NC}"
if [ -z "$OPENAI_API_KEY" ] && [ -z "$DEEPSEEK_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${RED}Warning: No LLM API keys found (OPENAI_API_KEY, etc. is empty)${NC}"
fi

echo -e "${GREEN}Log level:       ${YELLOW}${LOG_LEVEL:-Not set}${NC}"
echo -e "${GREEN}Debug mode:      ${YELLOW}${DEBUG:-Not set}${NC}"

# Create helper functions
start_app() {
    echo -e "${GREEN}Starting application in $ENV environment...${NC}"
    cd "$PROJECT_ROOT" && uvicorn app.main:app --reload --port 8000
}

# Define the function for use in the shell (handle both bash and zsh)
if [[ -n "$BASH_VERSION" ]]; then
    export -f start_app
elif [[ -n "$ZSH_VERSION" ]]; then
    # For ZSH, we redefine the function (no export -f)
    function start_app() {
        echo -e "${GREEN}Starting application in $ENV environment...${NC}"
        cd "$PROJECT_ROOT" && uvicorn app.main:app --reload --port 8000
    }
else
    echo -e "${YELLOW}Warning: Unsupported shell. Using fallback method.${NC}"
    # No function export for other shells
fi

# Print help message
echo -e "\n${GREEN}Available commands:${NC}"
echo -e "  ${YELLOW}start_app${NC} - Start the application in $ENV environment"

# Create aliases for environments
alias dev_env="source '$SCRIPT_DIR/set_env.sh' development"
alias stage_env="source '$SCRIPT_DIR/set_env.sh' staging"
alias prod_env="source '$SCRIPT_DIR/set_env.sh' production"

echo -e "  ${YELLOW}dev_env${NC} - Switch to development environment"
echo -e "  ${YELLOW}stage_env${NC} - Switch to staging environment"
echo -e "  ${YELLOW}prod_env${NC} - Switch to production environment"
