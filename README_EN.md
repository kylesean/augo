<p align="center">
  <img src="client/assets/images/logo.png" width="120" alt="Augo Logo">
</p>

<h1 align="center">Augo</h1>

<p align="center">
  <ins><b>Self-Hosted AI Financial Assistant</b></ins>
</p>

<p align="center">
  <a href="https://github.com/kylesean/augo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3"></a>
  <a href="https://www.python.org/downloads/release/python-3130/"><img src="https://img.shields.io/badge/Python-3.13-blue.svg" alt="Python 3.13"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-Environment-02569B.svg" alt="Flutter"></a>
  <a href="https://github.com/kylesean/augo/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"></a>
</p>

<p align="center">
  <a href="./README.md">简体中文</a> | <a href="./README_EN.md">English</a>
</p>

<p align="center">
  <img src="client/assets/images/record-transactions.png" width="24%" />
  <img src="client/assets/images/analysis.png" width="24%" />
  <img src="client/assets/images/skills.png" width="24%" />
  <img src="client/assets/images/transfer.png" width="24%" />
</p>

---

Augo is an open-source AI financial assistant that supports self-hosting. It helps you manage personal or family finances while keeping data and AI memory on your own infrastructure. It can be flexibly connected to various cloud or local LLMs.

---

## 🛠️ Features

### Agent-Based Financial Processing
Powered by **LangGraph**, Augo goes beyond simple transaction logging. It understands your intent through natural conversation, supporting multi-step financial queries, self-correction, and long-term context retention.

### Model-Agnostic Connectivity
Augo doesn't lock you into a single AI provider:
- **Cloud Models**: Connect to OpenAI, DeepSeek, and other mainstream providers.
- **Local Models**: Use **Ollama** or other frameworks to run models on your own hardware for maximum privacy.

### Voice & Privacy
Integrates with the [asr_server](https://github.com/kylesean/asr_server) open-source project:
- **Self-Hosted ASR**: Deploy your own voice recognition service.
- **Switchable Engines**: Easily switch between system-native and local ASR services to keep voice data within your network.

### Skill-Based Extensions
Uses a plugin mechanism inspired by **Anthropic Skills**. You can add specialized Skill scripts to give the assistant advanced capabilities like spending analysis or budget planning.

### User Interaction
Implements the **Google A2UI** protocol, where UI components (charts, detail cards) are pushed dynamically by the AI based on the conversation context. The frontend is built with the [forui](https://github.com/duobaseio/forui) UI library.

## 🏠 Deployment Scenarios

- **NAS Self-Hosting**: Optimized for **Synology**, **QNAP**, and other common NAS systems using one-click Docker deployment.
- **Family Sharing**: Supports multiple members with centralized data storage under your full control.
- **Developer Friendly**: Includes a full Makefile toolchain for local development.

## ⚙️ Tech Stack

- **Backend**: **Python 3.13** + **FastAPI**, with **uv** for dependency management.
- **Orchestration**: **LangGraph** + **Mem0**.
- **Frontend**: **Flutter** + [forui](https://github.com/duobaseio/forui).
- **Storage**: **PostgreSQL (pgvector)** for financial records and vector data.

---

## 🚀 Quick Start

### Prerequisites
- **Docker & Docker Compose** (Recommended)
- **AI Model API Key** or **Local LLM endpoint**

---

### 🐳 Docker Deployment

1. **Clone the repo**:
   ```bash
   git clone https://github.com/kylesean/augo.git && cd augo
   ```
2. **Configure Environment**:
   ```bash
   cp server/.env.example server/.env
   # Update server/.env with your Keys or local endpoint
   ```
3. **Start**:
   ```bash
   make docker-up
   ```
   *Scan the terminal QR code with your mobile app to connect.*

---

## 🗺️ Project Structure
- `/client`: Flutter client source code.
- `/server`: FastAPI backend source code.
- `/docker-compose.yml`: Docker orchestration configuration.

## 📄 License
Licensed under AGPLv3.

---

Email: jkxsai@gmail.com | WeChat: Ky1eSean
