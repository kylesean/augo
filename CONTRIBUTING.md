# Contributing to Augo

First off, thank you for considering contributing to **Augo**! It's people like you that make the open source community such an amazing place to learn, inspire, and create.

## Code of Conduct

By participating in this project, you are expected to uphold our [Code of Conduct](CODE_OF_CONDUCT.md).

## How Can I Contribute?

### Reporting Bugs

- Check the [Issues tab](https://github.com/kylesean/augo/issues) to see if the bug has already been reported.
- If not, create a new issue. Use a clear and descriptive title.
- Provide a step-by-step reproduction of the issue.
- Include environment details (OS, Python version, Flutter version).

### Suggesting Enhancements

- Open a new issue with the tag "enhancement".
- Describe the feature you'd like to see and why it would be useful.
- If possible, provide mockups or workflow diagrams.

### Pull Requests

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes.
4. Ensure your code follows the project's style (run `make lint` and `make format` for backend).
5. Submit a pull request with a clear description of the changes.

## Development Setup

### Backend (Python 3.13 / FastAPI)

1. Install [uv](https://github.com/astral-sh/uv).
2. Run `make setup` to install dependencies and initialize the environment.
3. Use `make dev` or `make start` to run the development server.

### Frontend (Flutter)

1. Ensure you have Flutter 3.x installed.
2. Run `make setup-all` from the root or navigate to `client` and run `flutter pub get`.
3. Run `make client-run` or `flutter run`.

## Coding Standards

### Backend
- Use type hints for all function signatures.
- Follow Google-style docstrings.
- Use `ruff` for linting and formatting.

### Frontend
- Follow the official [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.
- Use Riverpod for state management.
- Ensure UI components align with the Forui design system.

## License

By contributing, you agree that your contributions will be licensed under the project's [AGPLv3 License](LICENSE).
