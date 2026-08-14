"""Fixture ASGI entry point for negative-space.sh --self-test. Never imported.

The `mcp-request-id-absent` positive: two mounts, and nothing above them minting the
correlation identifier. A tool call and a page request become two records joined by a
timestamp, which is the state the rule exists to prevent.
"""

from __future__ import annotations

ROUTES = ["/mcp", "/"]
ROUTER_MIDDLEWARE: list[type] = []
