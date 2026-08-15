"""Fixture MCP assembly point for negative-space.sh --self-test. Never imported.

Two positives at once. No middleware carrying FastMCP's tool hook, so
`mcp-error-middleware-absent` fires; and the error-masking flag left at the framework's own
default, so `mcp-masking-off` fires too. The default is what earns that second clause a gate:
it hands an InvariantViolation's register key and its debug detail straight to the model.
"""

from __future__ import annotations

from collections.abc import Callable


def build_server(factory: Callable[..., object]) -> object:
    """Assemble the one server — as a project does before reading the doctrine."""
    return factory(name="fixture")
