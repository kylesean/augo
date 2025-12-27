# 🚀 Augo v0.1.0-alpha: 隐私优先的 AI 财务助手

我们很高兴地宣布 Augo 第一个 Alpha 版本的发布！这是一个专注于**数据主权**、**自部署**和**生成实时 UI** 的个人财务助手。

### 🌟 核心亮点
*   **🧠 LangGraph 驱动的智能决策**: 采用 LangGraph 状态图架构，支持复杂的财务逻辑推理、多轮对话和长期记忆管理（Mem0）。
*   **🎨 生成式 UI (GenUI)**: 基于 Google A2UI 协议实现 Event-driven 交互，AI 能直接在 Flutter 客户端渲染图表、交互式表单和财务分析结果。
*   **🔒 隐私第一 & 数字化主权**: 强力支持容器化自部署（Docker），你的财务数据和对话隐私完全由你掌控。
*   **🌍 全球化设计**: 内置多语言支持与实时汇率转换系统，能够跨币种管理你的资产。

### 📦 文档与配置
*   **[自部署指南 (Self-Hosting)](docs/SELF_HOSTING.md)**: 覆盖了从 Docker 启动到反向代理（SSL）的完整步骤。
*   **[系统架构说明 (Architecture)](docs/ARCHITECTURE.md)**: 深入剖析了 A2UI 协议、LangGraph 节点流与安全模型。
*   **`.env.example`**: 全新整理的分类配置模板，秒级上手初始化。

### 🛠️ 关键改进与优化
*   **安全性 (Security)**: 
    *   修复了 Filesystem Tools 中的命令注入风险，采用了更安全的执行机制。
    *   移除了所有硬编码的 API Key，所有敏感信息均通过环境变量解析。
*   **稳定性 (Stability)**:
    *   修复了 24 个历史测试用例，确保 100% 测试通过率。
    *   优化了 Docker 镜像构建，解决了 entrypoint 路径与 Python 模块加载问题。
*   **架构升级**: 
    *   AI 技能（Skills）迁移至独立的脚本执行模式，显著提升了 LLM 上下文效率和执行可靠性。
    *   统一了全项目的版本管理逻辑。

### ⚠️ 已知限制 (Alpha 阶段)
*   目前仅建议单用户或家庭内部使用。
*   财务预测与分析模型仍需更多真实数据样本来磨合。

---

**Augo** - *Empowering your financial future with private AI.*
