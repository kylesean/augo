<p align="center">
  <img src="client/assets/images/logo.png" width="120" alt="Augo Logo">
</p>

<h1 align="center">Augo</h1>

<p align="center">
  <ins><b>支持私有化部署的 AI 个人财务助理</b></ins>
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

Augo 是一款开源的 AI 财务助理，核心特点是支持私有化部署。它能帮你管理个人或家庭的财务账目，数据和 AI 记忆通过私有环境存储，可以根据需要灵活接入不同的云端或本地大模型。

---

## 🛠️ 功能特性

### 基于 Agent 架构的财务处理
Augo 使用 **LangGraph** 进行任务编排。它不仅能记录流水，还能通过对话理解你的需求，支持多步骤的财务查询、自动纠错并保留长短期的财务背景信息。

### 支持多种模型接入
Augo 不绑定特定的 AI 服务商：
- **云端接入**: 支持接入 OpenAI、DeepSeek 等主流模型。
- **本地接入**: 支持通过 **Ollama** 等框架接入本地模型，适合拥有个人算力设备的用户。

### 语音与隐私交互
支持集成 [asr_server](https://github.com/kylesean/asr_server) 项目（基于开源 ASR 方案深度定制）：
- **自建语音识别**: 可以在本地部署 ASR 服务。
- **灵活切换**: 支持在系统原生语音和本地语音服务间切换，让语音数据尽量留在本地。

### Skill 技能扩展
采用类 **Anthropic Skills** 规范的插件机制。通过增加不同的 Skill 脚本，可以让助手具备更专业的分析能力（如消费分析、预算规划等）。

### 交互界面
基于 **Google A2UI** 协议实现。界面组件（如分析图表、详情卡片）由 AI 根据对话内容动态推送，前端使用 [forui](https://github.com/duobaseio/forui) UI 组件库。

## 🏠 部署与使用场景

- **NAS 私有部署**: 适配 **群晖 (Synology)**、**威联通 (QNAP)** 等常见 NAS 系统。通过 Docker 一键部署，让家用服务器兼具财务管理功能。
- **家庭共享**: 支持多成员协同，数据存储在本地数据库中，由用户完全控制。
- **开发者调试**: 提供 Makefile 工具链。

## ⚙️ 技术栈

- **后端**: **Python 3.13** + **FastAPI**，使用 **uv** 管理依赖。
- **AI 编排**: **LangGraph** + **Mem0**。
- **前端**: **Flutter** + [forui](https://github.com/duobaseio/forui)。
- **存储**: **PostgreSQL (pgvector)** 存储账目信息与向量数据。

---

## 🚀 快速开始

### 前置条件
- **Docker & Docker Compose** (推荐)
- **AI 模型 API Key** 或 **本地大模型地址**

---

### 🐳 Docker 部署

1. **获取代码**:
   ```bash
   git clone https://github.com/kylesean/augo.git && cd augo
   ```
2. **环境配置**:
   ```bash
   cp server/.env.example server/.env
   # 在 server/.env 中填入你的 Key 或地址
   ```
3. **启动**:
   ```bash
   make docker-up
   ```
   *启动后扫描终端二维码即可连接 App。*

---

## 🗺️ 项目结构
- `/client`: Flutter 客户端源码。
- `/server`: FastAPI 后端源码。
- `/docker-compose.yml`: Docker 集群配置。

## 📄 开源协议
本项目采用 [AGPLv3 License](LICENSE) 协议。

---

Email: jkxsai@gmail.com | WeChat: Ky1eSean
