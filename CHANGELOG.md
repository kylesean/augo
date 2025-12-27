# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0-alpha] - 2025-12-27

### Added
- Initial alpha release of AI Financial Assistant.
- Core FastAPI backend with LangGraph agent support.
- Flutter mobile client with GenUI (Server-driven UI) capabilities.
- Transaction management, budget analysis, and financial forecasting features.
- Integration with Langfuse for AI observability.
- Docker and Docker Compose support for easy deployment.
- Comprehensive [Self-Hosting](docs/SELF_HOSTING.md) and [Architecture](docs/ARCHITECTURE.md) guides.
- Detailed `.env.example` with categorized configurations for easy setup.

### Changed
- Transitioned AI skills to a more robust script-based execution model for improved security and performance.
- Centralized project versioning with a root `VERSION` file.
- Improved color system consistency across the mobile client.
- Optimized Docker builds using multi-stage builds.

### Fixed
- **Security**: Fixed critical shell injection vulnerability in filesystem tools.
- **Security**: Removed hardcoded API keys from binary and source code.
- Fixed AI streaming timeout issues on the client side.
- Resolved various UI rendering inconsistencies.
- Fixed Docker entrypoint path issues for Python module loading.
- Fixed 24+ failing unit and integration tests to ensure 100% test pass rate.

