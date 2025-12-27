# Augo: Self-Hosted & Privacy-First AI Financial Assistant

Augo is a premium, open-source AI financial assistant designed for individuals and families who prioritize **data sovereignty** and **absolute privacy**. Unlike centralized financial apps, Augo is built to be **self-hosted**, giving you 100% ownership of your financial records and intellectual property.

## 🛡️ Privacy & Sovereignty First

- **Own Your Data**: Deploy on your own hardware or private cloud. Your financial history never leaves your infrastructure.
- **Privacy by Design**: No third-party data mining or cloud eavesdropping. You control the encryption keys and access.
- **Personal & Family Oriented**: Securely manage individual accounts or coordinate household finances in a private, shared environment.
- **Transparent AI**: Run your orchestration locally. Leverage the power of AI without compromising your financial secrets.

## 🌟 Key Features

- **Natural Interaction**: Record transactions via voice or text with a human-like assistant that understands context.
- **Privatized Intelligence**: Deep analysis of spending patterns and budget health, computed on your own terms.
- **Dynamic Interface**: A responsive, AI-driven experience that adapts to your financial queries in real-time.
- **Global Ready**: Built-in multi-currency support with private exchange rate management.
- **Proactive Management**: Smart budget alerts and financial health scoring tailored for your family's needs.

## 🚀 Core Technology


Augo is built on a cutting-edge technological foundation:

- **Generative UI (A2UI)**: Implements dynamic interface generation based on the **Google A2UI protocol**, providing a seamless, context-aware user experience that evolves during the conversation.
- **Agentic reasoning (LangGraph)**: Powered by the **LangGraph Agent framework**, enabling complex multi-step financial reasoning and tool interaction.
- **Anthropic Skills Compatible**: Fully compatible with the **Anthropic Skills specification**, allowing the AI to execute precise financial operations through a standardized toolset.
- **Modern Stack**: Built with **Python 3.13 (FastAPI)** on the backend and **Flutter** for a premium, responsive cross-platform mobile experience.

---

## �️ Getting Started

### Prerequisites

- **Docker & Docker Compose** (Recommended)
- **Python 3.13** (for local development)
- **PostgreSQL 16** and **Redis**
- **Flutter SDK** (for client development)

---

### 🐳 Docker Deployment (Recommended)

The easiest way to get the Augo backend up and running is via Docker.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/augo-assistant.git
   cd augo-assistant
2. **Setup environment variables**:
   ```bash
   cd server
   cp .env.example .env.production
   # Edit .env.production with your API keys (OpenAI/DeepSeek, etc.)
   ```
3. **Start the stack**:
   ```bash
   cd ..
   make docker-up ENV=production
   ```
4. **Verify**:
   Access the API health check at `http://localhost:8000/api/v1/health`.

---

### 💻 Local Deployment
For developers who want to run everything locally:

1. **Initial Setup (Everything)**:
   ```bash
   make setup-all
   ```
   *This initializes the backend database and installs both Flutter and Python dependencies.*

2. **Start the server**:
   ```bash
   make start
   ```
   *The server will display a QR code in the terminal to help you easily configure your mobile app.*
   *The server will display a QR code in the terminal to help you easily configure your mobile app.*

---

### � Client Setup (Flutter)

1. **Navigate to client directory**:
   ```bash
   cd client
   ```
2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```
4. **Connect to Server**:
   Scan the QR code displayed by the backend or manually input your server URL (e.g., `http://192.168.x.x:8000`).

---

## 🗺️ Project Structure

- `/client`: Premium Flutter application using the Forui design system.
- `/server`: High-performance FastAPI backend with LangGraph agents.
- `/docker-compose.yml`: Full stack orchestration (API, DB, Redis, Monitoring).
- `/docs`: Detailed documentation:
  - [Architecture Overview](docs/ARCHITECTURE.md)
  - [Private Self-Hosting Guide](docs/SELF_HOSTING.md)


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

---

Built with ❤️ by the Augo Team.
