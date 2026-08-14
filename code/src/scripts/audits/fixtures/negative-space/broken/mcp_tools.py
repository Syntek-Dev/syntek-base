"""Fixture tool module for negative-space.sh --self-test. Never imported.

Its mere existence is what turns the three `mcp-*` clauses on. The surface is unwired at
baseline, so a project with no tools is never asked for the configuration tools need — the
same gating `htmx-handler-absent` uses on a template that carries `hx-`.
"""

from __future__ import annotations


def register(server: object) -> None:
    """Register this app's tools on the project's single FastMCP server."""
