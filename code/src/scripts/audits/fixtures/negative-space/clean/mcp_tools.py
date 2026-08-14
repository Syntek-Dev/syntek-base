"""Fixture tool module for negative-space.sh --self-test. Never imported.

The known negative's tool module. It exists, so all three `mcp-*` clauses run here rather
than skipping — which is what makes `clean/` a proof and not an absence.
"""

from __future__ import annotations


def register(server: object) -> None:
    """Register this app's tools on the project's single FastMCP server."""
