# Changelog

All notable changes to **Augo** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Note**: During alpha development, this changelog is updated only at version releases.
> For detailed changes between releases, see the [Git commit history](https://github.com/kylesean/augo/commits/main).

## [0.1.1-alpha] - 2025-12-28

### Fixed
- **Critical**: Fixed application crash on first launch when server URL is not configured. Previously required `--dart-define=API_BASE_URL=xxx` to start the app; now the app gracefully shows the server configuration page.
- **Critical**: Fixed crash when opening Speech Settings page without `--dart-define=SPEECH_WS_HOST=xxx`. Users can now configure WebSocket host directly in the settings UI.
- Added `ConfigurationCheckInterceptor` to validate server configuration before making network requests.
- Added `ServerNotConfiguredException` for clearer error handling when server is not configured.

## [0.1.0-alpha] - 2025-12-27

### Added
- Initial alpha release of **Augo**, the privacy-first AI financial assistant.
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
