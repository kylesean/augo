"""Filesystem Tools Module

Providing core system tools via DeepAgents' FilesystemBackend:
- ls: List directory contents
- read_file: Read file content
- write_file: Write to a file
- edit_file: Edit file content
- execute: Execute shell commands (bash)

Mapped to the project root directory for accessing skills and other project files.
"""

import os
import subprocess
from pathlib import Path
from typing import List, Optional

from deepagents.backends.filesystem import FilesystemBackend
from deepagents.backends.protocol import ExecuteResponse
from deepagents.backends.sandbox import SandboxBackendProtocol
from langchain_core.tools import BaseTool, tool
from pydantic import BaseModel, Field

from app.core.logging import logger

# 项目根目录
PROJECT_ROOT = Path(__file__).parent.parent.parent.parent.parent


class LocalFilesystemBackend(FilesystemBackend, SandboxBackendProtocol):
    """Local filesystem backend supporting command execution.

    Inherits from FilesystemBackend for file operations and implements
    SandboxBackendProtocol's execute interface for local shell command execution.
    """

    def execute(self, command: str) -> ExecuteResponse:
        """Execute a bash command in the local environment (synchronous).

        NOTE: In production, a restricted SandboxBackend (like Docker) should be used.
        Direct execution on the host is for development convenience.
        """
        try:
            # 注入 USER_ID 和 LANG 环境变量
            from app.core.langgraph.tools import current_session_language, current_user_id

            env = os.environ.copy()
            user_id = current_user_id.get()
            if user_id:
                env["USER_ID"] = user_id

            # 注入会话语言
            session_lang = current_session_language.get()
            if session_lang:
                env["LANG"] = session_lang

            # 使用 subprocess 执行命令
            # cwd 设置为 self.cwd (项目根目录)
            result = subprocess.run(
                command,
                shell=True,
                cwd=self.cwd,
                env=env,
                capture_output=True,
                text=True,
                timeout=30,  # 30秒超时
            )

            # 合并 stdout 和 stderr，因为 ExecuteResponse 只接受 output
            output = result.stdout
            if result.stderr:
                output += f"\nstderr:\n{result.stderr}"

            return ExecuteResponse(output=output, exit_code=result.returncode)

        except subprocess.TimeoutExpired:
            return ExecuteResponse(output="Error: Command execution timed out after 30 seconds", exit_code=124)
        except Exception as e:
            return ExecuteResponse(output=f"Error executing command: {str(e)}", exit_code=1)


# 1. 配置后端：使用支持执行的自定义后端
fs_backend = LocalFilesystemBackend(root_dir=PROJECT_ROOT, virtual_mode=False)

# 3. 自定义工具封装
# 直接调用 backend 的方法，规避 DeepAgents ToolRuntime 的复杂注入机制


# --- read_file ---
class ReadFileInput(BaseModel):
    """Input for reading a file."""
    path: str = Field(..., description="Path of the file to read")


@tool("read_file", args_schema=ReadFileInput)
def read_file_tool(path: str):
    """Read the content of a file."""
    try:
        content = fs_backend.read(path)
        return content
    except Exception as e:
        return f"Error reading file: {str(e)}"


# --- ls ---
class LsInput(BaseModel):
    """Input for listing directory contents."""
    path: str = Field(".", description="Directory path to list (defaults to current directory)")


@tool("ls", args_schema=LsInput)
def ls_tool(path: str = "."):
    """List directory contents."""
    try:
        # 使用 ls_info 获取详细信息，或者简单的 list
        # ls_info 返回结构化数据
        items = fs_backend.ls_info(path)
        # 格式化输出
        output = []
        for item in items:
            # 兼容对象和字典访问
            is_dir = item.is_dir if hasattr(item, "is_dir") else item.get("is_dir", False)
            name = item.name if hasattr(item, "name") else item.get("name", "unknown")

            type_str = "DIR" if is_dir else "FILE"
            output.append(f"{type_str:4} {name}")
        return "\n".join(output)
    except Exception as e:
        return f"Error listing directory: {str(e)}"


# --- write_file ---
class WriteFileInput(BaseModel):
    """Input for writing a file to the artifact directory."""
    path: str = Field(..., description="Relative path for the output file (e.g., 'landing-page.html')")
    content: str = Field(..., description="Content to write to the file")


@tool("write_file", args_schema=WriteFileInput)
def write_file_tool(path: str, content: str):
    """Write content to a file in user's artifact directory.

    Files are automatically saved to: artifacts/{user_id}/{path}
    The URL to access the file will be returned.
    """
    from app.core.langgraph.tools import current_user_id

    try:
        user_id = current_user_id.get()
        if not user_id:
            return "Error: User ID not available"

        # 构建用户专属输出路径
        user_artifact_dir = Path("artifacts") / user_id
        full_path = user_artifact_dir / path

        # 确保目录存在
        full_path.parent.mkdir(parents=True, exist_ok=True)

        # 使用绝对路径写入（fs_backend.write 使用相对于 root_dir 的路径）
        relative_path = str(full_path)
        fs_backend.write(relative_path, content)

        # 返回访问 URL
        access_url = f"/artifacts/{user_id}/{path}"
        return {
            "success": True,
            "message": f"Successfully wrote {len(content)} bytes",
            "path": relative_path,
            "url": access_url,
            "componentType": "artifact_link",
            "artifactUrl": access_url,
            "artifactName": Path(path).name,
        }
    except Exception as e:
        return f"Error writing file: {str(e)}"


# --- execute (bash) ---
class ExecuteInput(BaseModel):
    """Input for executing a bash command."""
    command: str = Field(..., description="The bash command to execute")


@tool("execute", args_schema=ExecuteInput)
def execute_tool(command: str):
    """Execute a bash command (typically within the app/skills/ directory)."""
    # 直接调用我们自定义 backend 的 execute 方法
    response = fs_backend.execute(command)

    # 尝试从输出中提取 JSON 以触发 GenUI
    import json

    result_data = {"output": response.output, "exit_code": response.exit_code, "success": response.exit_code == 0}

    # 在输出中查找 JSON 块
    # 脚本可能会在 JSON 之前输出环境加载日志
    output = response.output

    # 找到第一个 { 和最后一个 } 之间的内容
    first_brace = output.find("{")
    last_brace = output.rfind("}")

    if first_brace != -1 and last_brace != -1 and last_brace > first_brace:
        json_candidate = output[first_brace : last_brace + 1]

        try:
            json_output = json.loads(json_candidate)
            if isinstance(json_output, dict):
                # 成功解析，合并到 result_data（保持 componentType 等字段）
                result_data.update(json_output)
                # 移除原始 output 以减少 token 消耗（JSON 已被解析）
                result_data["output"] = "(JSON parsed successfully)"
                logger.info(
                    "execute_tool_json_parsed",
                    has_component_type="componentType" in json_output,
                    component_type=json_output.get("componentType"),
                )
        except json.JSONDecodeError as e:
            logger.warning(
                "execute_tool_json_parse_failed",
                error=str(e),
                json_candidate_length=len(json_candidate),
            )
    else:
        logger.debug(
            "execute_tool_no_json_found",
            has_first_brace=first_brace != -1,
            has_last_brace=last_brace != -1,
        )

    return result_data


# --- 导出工具列表 ---
# 包含 execute 供 Skills 使用脚本
filesystem_tools: List[BaseTool] = [
    read_file_tool,
    ls_tool,
    write_file_tool,  # 写入文件到用户专属目录 artifacts/{user_id}/
    execute_tool,  # Skills 通过脚本执行分析逻辑
]

# 记录日志
tool_names = [t.name for t in filesystem_tools]
logger.info("filesystem_tools_initialized", tools=tool_names)
