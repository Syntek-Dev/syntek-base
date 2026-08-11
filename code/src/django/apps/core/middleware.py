"""Correlation identifier on every response, so one user report resolves to one tracker event."""

from __future__ import annotations

import re
import uuid
from collections.abc import Callable
from contextvars import ContextVar

from django.http import HttpRequest, HttpResponse

__all__ = ["RequestIDMiddleware", "current_request_id"]

# An inbound identifier is untrusted input — it is echoed into a response header and rendered
# on an error page — so it is constrained to a conservative alphabet and a bounded length
# rather than trusted because something in front usually sets it.
_INBOUND_PATTERN = re.compile(r"[A-Za-z0-9._-]{1,200}")

# A ContextVar rather than an attribute on the request, because the consumers — a logging
# filter, a template context processor, the error tracker — are not handed the request object.
# asgiref propagates context across the sync/async boundary in both directions, so this holds
# for a sync view running under ASGI.
_current_request_id: ContextVar[str] = ContextVar("request_id", default="")


def current_request_id() -> str:
    """Correlation identifier for the request being served; empty outside a request."""
    return _current_request_id.get()


class RequestIDMiddleware:
    """Guarantees a correlation identifier on every response, minting one when none arrived."""

    def __init__(self, get_response: Callable[[HttpRequest], HttpResponse]) -> None:
        self.get_response = get_response

    def __call__(self, request: HttpRequest) -> HttpResponse:
        # Reusing the identifier from upstream keeps one request to one value; minting a second
        # would split the same request's trail between the proxy's access log and this process.
        inbound = request.META.get("HTTP_X_REQUEST_ID", "")
        request_id = inbound if _INBOUND_PATTERN.fullmatch(inbound) else uuid.uuid4().hex

        # Resetting is not optional: a worker thread is reused across requests, so a value left
        # set would be reported against whichever request that thread serves next.
        token = _current_request_id.set(request_id)
        try:
            response = self.get_response(request)
            response["X-Request-ID"] = request_id
            return response
        finally:
            _current_request_id.reset(token)
