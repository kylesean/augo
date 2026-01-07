<p align="center">
  <img src="client/assets/images/logo.png" width="120" alt="Augo Logo">
</p>

<h1 align="center">Augo</h1>

<p align="center">
  <ins><b>Future-Ready Agentic AI Financial Hub</b></ins>
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

**Augo** is an open-source financial management hub natively built for the **Agentic AI** era. It is not just a ledger, but your personal financial "brain."

As edge computing power becomes more accessible and local models evolve rapidly, we believe that every individual and family will eventually have their own **"Private AI Compute Center."** Augo is designed for this future: anchoring complex AI orchestration, user memory, and sensitive data in your private environment (e.g., NAS, home server) while flexibly connecting to any cloud or local LLM.

---

## 🚀 Why Augo?

### 🧠 Agentic AI Native Architecture
Augo deeply integrates **LangGraph** for multi-step financial reasoning. It goes beyond simple keyword matching, understanding your intent like a human expert, with self-correction and long-term financial memory loops.

### 🧩 Model-Agnostic Flexibility
Switch models as you see fit:
- **Hybrid Intelligence**: Route sensitive tasks to private local models and general requests to high-performance cloud LLMs.
- **Future-Ready**: Built-in support for local inference frameworks like **Ollama** and **LocalAI**, perfectly matching the upcoming trend of edge AI compute clusters.

### 🎙️ Privacy-First Voice Interaction
Augo supports integration with the [asr_server](https://github.com/kylesean/asr_server) open-source project:
- **Self-Hosted ASR**: Deploy your own ASR (Automatic Speech Recognition) service on NAS or local hardware for offline processing.
- **Engine Switching**: Seamlessly switch between system-native voice engines and your self-hosted ASR service. The latter is lightweight, ultra-private, and keeps your voice data entirely within your local network.

### 🛠️ Standardized Skill Extensions
Leverages a plugin mechanism inspired by **Anthropic Skills**. Developers and power users can easily define new financial skills—such as "Investment Risk Assessment" or "Tax Planning"—giving the AI infinite specialized depth.

### 🎨 Interaction Revolution: Google A2UI
Powered by the **Generative UI (A2UI)** protocol, your interface is no longer a static set of forms. The AI generates the most relevant UI components (e.g., budget analysis cards, cashflow trend charts) in real-time based on the conversation context.

## 🌎 Deployment & Scenarios

- **Home AI Hub**: Optimized for **Synology**, **QNAP**, and other NAS systems. Use Docker to turn your NAS into a private financial AI server.
- **Data Sovereignty with Power**: Enjoy top-tier AI capabilities while keeping core financial records and user profiles within your own database.
- **Geeks & Developers**: A comprehensive Makefile-driven toolchain for rapid experimentation with AI Agent logic.

## ⚙️ Core Technology

- **Intelligence**: **LangGraph** orchestration + **Mem0** intelligent memory.
- **Back-end**: **Python 3.13** + **FastAPI**, with **uv** for high-performance package management.
- **Front-end**: Premium **Flutter** app built with the [forui](https://github.com/duobaseio/forui) UI component library.
- **Data Foundation**: **PostgreSQL (pgvector)** for unified structured records and vector knowledge storage.

---

## 🛠️ Quick Start

### Prerequisites
- **Docker & Docker Compose** (Recommended)
- **Model API Keys** (DeepSeek, OpenAI, Claude) or **Local LLM Entry** (Ollama)

---

### 🐳 One-Click Deployment (Docker)

1. **Clone the Repo**:
   ```bash
   git clone https://github.com/kylesean/augo.git && cd augo
   ```
2. **Configure Environment**:
   ```bash
   cp server/.env.example server/.env
   # Update server/.env with your LLM configuration
   ```
3. **Launch**:
   ```bash
   make docker-up
   ```
   *Scan the QR code in the terminal with your mobile app to start your private AI financial journey.*

---

## 🗺️ Project Structure
- `/client`: Premium Flutter App source code (powered by [forui](https://github.com/duobaseio/forui)).
- `/server`: FastAPI backend with Agentic orchestration.
- `/docker-compose.yml`: Production-ready orchestration.

## 📄 License
Licensed under AGPLv3.

---

Email: jkxsai@gmail.com | WeChat: Ky1eSean
