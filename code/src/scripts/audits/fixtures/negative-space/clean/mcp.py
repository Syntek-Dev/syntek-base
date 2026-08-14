"""Fixture MCP assembly point for negative-space.sh --self-test. Never imported.

The known negative for two clauses: one `on_call_tool` boundary rather than a `try/except`
per tool, and masking on, so the exception type alone decides what the model may read.
"""

from __future__ import annotations

from collections.abc import Callable


class ToolErrorMiddleware:
    """The one boundary the three error classes cross — never one per tool."""

    def on_call_tool(self, context: object, call_next: Callable[[object], object]) -> object:
        """Classify, log at the class's level, capture, and decide what is transmitted."""
        return call_next(context)


def build_server(factory: Callable[..., object]) -> object:
    """Assemble the one server, as code/docs/mcp-server/TOOL-DESIGN.md describes it."""
    return factory(name="fixture", mask_error_details=True)
