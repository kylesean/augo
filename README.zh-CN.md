# Augo: Self-Hosted & Privacy-First AI Financial Assistant

Augo 是一款专注于 **数据主权** 和 **绝对隐私** 的开源 AI 财务助手。与中心化财务应用不同，Augo 专为 **私有化部署** 设计，让您 100% 掌控自己的财务记录和资产数据。

[English Edition](./README.md)

## 🛡️ 隐私与主权至上

- **数据主权**: 部署在您自己的硬件或私有云中，财务历史记录永不离开您的基础设施。
- **隐私设计**: 无第三方数据挖掘，您掌控加密密钥和访问权限。
- **家庭导向**: 在私有的共享环境中安全地管理个人账户或协调家庭财务。
- **透明 AI**: 本地运行任务编排，在不泄露财务秘密的前提下利用 AI 的能力。

## 🌟 核心功能

- **自然交互**: 通过语音或文本与理解上下文的 AI 助手记录交易。
- **私有化智能**: 深度分析消费模式和预算健康状况，所有计算均在本地完成。
- **动态界面 (GenUI)**: 基于 Google A2UI 协议，界面会根据交互内容实时生成和演变。
- **全球支持**: 内置多货币支持，配合私有汇率管理系统。
- **主动管理**: 智能预算预警和财务健康评分，量身定制家庭理财建议。

## 🚀 核心技术

Augo 基于前沿的技术栈构建：

- **Generative UI (A2UI)**: 实现动态界面生成，提供无缝且具备上下文感知能力的用户体验。
- **Agentic Reasoning (LangGraph)**: 由 **LangGraph** 驱动，支持复杂的多步骤财务推理和工具交互。
- **现代技术栈**: 后端使用 **Python 3.13 (FastAPI)** + **uv** 动力，前端使用 **Flutter** 提供极致的移动端体验。
- **存储**: 使用 **PostgreSQL (pgvector)** 进行结构化数据和向量化记忆存储。

---

## 🛠️ 快速开始

### 前置条件

- **Docker & Docker Compose** (推荐)
- **Python 3.13** (本地开发需要，推荐安装 [uv](https://github.com/astral-sh/uv))
- **Flutter SDK** (客户端开发需要)

---

### 🐳 Docker 部署 (推荐)

这是最简单、最快捷的运行方式，包含数据库、Redis 以及监控系统。

1. **克隆仓库**:
   ```bash
   git clone https://github.com/kylesean/augo.git
   cd augo
   ```
2. **环境配置**:
   ```bash
   cp server/.env.example server/.env
   # 编辑 server/.env，填入您的 API 密钥 (OpenAI/DeepSeek 等)
   ```
3. **一键启动**:
   ```bash
   make docker-up
   ```
   *启动后，终端会显示一个二维码，方便移动端快速扫描连接。*

4. **常用 Docker 命令**:
   - 停止服务：`make docker-down`
   - 查看日志：`make docker-logs`

---

### 💻 本地开发部署

如果您希望在本地进行开发或直接运行：

1. **一键安装环境**:
   ```bash
   make setup-all
   ```
   *这将安装 Python (`uv`) 和 Flutter 的依赖，并初始化数据库。*

2. **启动后端服务**:
   ```bash
   make start
   ```
   *后端启动后会显示二维码，供手机客户端连接。*

3. **运行 Flutter 客户端**:
   ```bash
   make client-run
   ```

---

### 📝 常用快捷命令 (Makefile)

项目根目录的 `Makefile` 提供了一系列便捷指令：

| 命令 | 说明 |
| :--- | :--- |
| `make setup-all` | 初始化后端数据库并安装全量依赖 |
| `make start` | 启动本地后端服务 (FastAPI) |
| `make docker-up` | 构建并启动所有 Docker 服务 (含 DB/Redis/Monitoring) |
| `make docker-down` | 停止并移除 Docker 容器 |
| `make lint` | 运行 Python 代码规范检查 (Ruff) |
| `make format` | 自动修复 Python 代码格式 |
| `make test` | 运行后端单元测试 |
| `make client-run` | 在连接的设备上运行 Flutter 客户端 |
| `make gen-keys` | 生成项目所需的加密密钥 (JWT & Fernet) |

---

## 🗺️ 项目结构

- `/client`: 基于 Forui 设计系统的精品 Flutter 应用。
- `/server`: 高性能 FastAPI 后端，集成 LangGraph 智能体。
- `/docker-compose.yml`: 全栈编排（API, DB, Redis, Prometheus, Grafana）。
- `/docs`: 详细文档：
  - [架构概览](docs/ARCHITECTURE.md)
  - [私有化部署指南](docs/SELF_HOSTING.md)

## 📄 开源协议

本项目采用 [AGPLv3 License](LICENSE) 协议。

## 🤝 贡献指南

我们欢迎各种形式的贡献！请阅读 [贡献指南](CONTRIBUTING.md) 了解如何参与项目。

---

Email: jkxsai@gmail.com WeChat: Ky1eSean
