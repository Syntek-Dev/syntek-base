"""Fixture ASGI entry point for negative-space.sh --self-test. Never imported.

The known negative: the request-id middleware sits on the router, above both mounts, so one
request carries one identifier whichever mount it reaches. Django's own middleware stays
where it is — `clean/settings.py` is the other half of that pair.
"""

from __future__ import annotations


class RequestIDASGIMiddleware:
    """Peer of apps.core.middleware.RequestIDMiddleware, one layer further out."""


ROUTES = ["/mcp", "/"]
ROUTER_MIDDLEWARE: list[type] = [RequestIDASGIMiddleware]
