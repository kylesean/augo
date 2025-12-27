"""Tests for LangGraph Agent Architecture

Verifies tool loading and system prompts.
"""

from unittest.mock import MagicMock, patch

import pytest


def test_tools_module_imports():
    """Test that tool modules are imported correctly."""
    from app.core.langgraph.tools import skill_exclusive_tools, tools

    assert tools is not None
    assert skill_exclusive_tools is not None
    # skill_exclusive_tools is now empty since skills moved to script-based execution
    assert isinstance(skill_exclusive_tools, dict)


def test_system_prompt_loading():
    """Test that the system prompt loads correctly."""
    from app.core.prompts import get_stable_system_prompt

    prompt = get_stable_system_prompt()
    assert prompt is not None
    assert "You are Augo" in prompt or "Augo" in prompt
