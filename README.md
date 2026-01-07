<p align="center">
  <img src="client/assets/images/logo.png" width="120" alt="Augo Logo">
</p>

<h1 align="center">Augo</h1>

<p align="center">
  <ins><b>面向未来的 Agentic AI 原生财务管理中心</b></ins>
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

Augo 是一款原生为 **Agentic AI** 时代打造的开源财务管理中心。它不仅仅是一个记账软件，更是您的个人财务“大脑”。

在算力日渐普及、端侧模型飞速发展的今天，我们相信每个人、每个家庭未来都会拥有属于自己的 **“私有智能算力中心”**。Augo 的设计初衷正是为了切合这一未来趋势：将复杂的 AI 编排逻辑、用户记忆和敏感数据锚定在您的私有环境（如 NAS、家庭服务器）中，同时灵活接入云端或本地的各种大模型能力，实现数据主权与前沿智能的完美平衡。

---

## 🚀 为什么选择 Augo？

### 🧠 Agentic AI 原生架构
Augo 深度集成 **LangGraph**，支持复杂的多步骤财务推理。它不再依赖简单的关键词匹配，而是像人类专家一样理解您的意图，能够自动纠错并维护长短期财务记忆。

### 🧩 灵活的 Model-Agnostic 接入
您可以根据需要自由切换模型：
- **混合智能**: 将敏感任务路由至私有环境处理，将通用请求发送至云端高性能模型。
- **未来就绪**: 完美支持接入 **Ollama**, **LocalAI** 等本地推理框架，完美切合未来端侧算力中心场景。

### 🎙️ 极致隐私的语音交互
Augo 支持集成自研的 [asr_server](https://github.com/kylesean/asr_server) 开源项目：
- **私有化 ASR 服务**: 支持在 NAS 或本地离线部署 ASR（自动语音识别）服务。
- **自如切换**: 您可以灵活切换系统原生语音引擎与自建语音服务。后者更轻量，且语音数据全程不出本地，提供极致的隐私防护。

### 🛠️ 标准化 Skill 扩展
采用类 **Anthropic Skills** 的规范化插件机制。开发者或高级用户可以轻松定义新的财务分析技能，如“投资风险评估”、“家庭税务规划”等，让 AI 具备无限的专业深度。

### 🎨 交互革命：Google A2UI
基于 **Generative UI (A2UI)** 协议，界面不再是死板的静态表单。AI 会根据当前的分析结果，实时生成最合适的 UI 组件（如预算分析卡片、现金流趋势图），实现真正的“界面随心而动”。

## 🌎 使用与部署方案

- **家庭私有智能中心**: 完美适配 **群晖 (Synology)**、**威联通 (QNAP)** 等 NAS，通过 Docker 一键编排，将您的 NAS 变成私有财务 AI 服务器。
- **数据主权与隐私**: 在享受顶级 AI 能力的同时，核心财务流水和用户画像始终保存在您自己的数据库中。
- **开发者与极客**: 完整的 Makefile 工具链支持，让您在本地快速实验各类 AI Agent 逻辑。

## ⚙️ 核心技术栈

- **智能大脑**: **LangGraph** 任务编排 + **Mem0** 智能记忆系统。
- **后端**: **Python 3.13** + **FastAPI**，使用 **uv** 进行极致的性能管理。
- **前端**: **Flutter** 移动端应用，采用优秀的 [forui](https://github.com/duobaseio/forui) UI 组件库，提供极致的交互体验。
- **数据底座**: **PostgreSQL (pgvector)** 统一管理结构化财务数据与向量知识库。

---

## 🛠️ 快速开始

### 前置条件
- **Docker & Docker Compose** (推荐)
- **AI 模型 API 密钥** (如 DeepSeek, OpenAI, Claude) 或 **本地大模型入口** (Ollama)

---

### 🐳 一键部署 (Docker)

1. **获取代码**:
   ```bash
   git clone https://github.com/kylesean/augo.git && cd augo
   ```
2. **配置环境**:
   ```bash
   cp server/.env.example server/.env
   # 在 server/.env 中填入您的模型配置
   ```
3. **启动服务**:
   ```bash
   make docker-up
   ```
   *启动后，手机扫描终端显示的二维码即可开启您的私有 AI 财务助手。*

---

## 🗺️ 项目结构
- `/client`: Premium Flutter App 源码（基于 [forui](https://github.com/duobaseio/forui)）。
- `/server`: 支持 Agentic 编排的 FastAPI 后端。
- `/docker-compose.yml`: 生产级容器编排。

## 📄 开源协议
本项目采用 [AGPLv3 License](LICENSE) 协议。

---

Email: jkxsai@gmail.com | WeChat: Ky1eSean
