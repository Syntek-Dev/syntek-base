"""US014 — the ``request_id`` on lines logged while a real request is served (U-client).

Scenario IDs are ``QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md`` Section 2's. Each view below is a
throwaway fixture mounted only through ``pytest.mark.urls`` on this module — no route ships.

``caplog`` is never used: its handler runs no handler filters, so it cannot see the one under
test. Every test captures through a ``StringIO`` handler carrying the filter and the minimal
formatter, attached to the logger under test and removed afterwards.

Two mechanisms are pinned, and both must hold:

* a view that **returns** a 4xx is logged by Django after ``RequestIDMiddleware`` has reset its
  ``ContextVar``, so the line's id comes from the filter's fallback to ``request.request_id``
  (HP-08, HP-09, EC-05, EC-22 — the P1 + P2 joint exit);
* a view that **raises** is logged inside the chain, so the ``ContextVar`` covers it (HP-10).
"""

from __future__ import annotations

import io
import logging
import re
import sys
import threading
from collections.abc import Iterator
from typing import Any

from django.core.exceptions import BadRequest, PermissionDenied
from django.http import (
    HttpRequest,
    HttpResponse,
    HttpResponseBadRequest,
    HttpResponseServerError,
    StreamingHttpResponse,
)
from django.test import AsyncClient, Client, RequestFactory
from django.urls import path

import pytest

from apps.core.middleware import RequestIDMiddleware
from apps.core.tests.unit.observability_support import FIXED_KEYS, capturing_handler, lines_of

pytestmark = [
    pytest.mark.story("US014"),
    pytest.mark.urls("apps.core.tests.unit.test_observability_requests"),
]

MINTED = re.compile(r"[0-9a-f]{32}")
# Well formed against the middleware's ``[A-Za-z0-9._-]{1,200}`` — the edge-set id in production.
INBOUND = "abc-123_XY.z"

# (path, status, the level ``log_response`` writes it at) — a returned 4xx and a returned 5xx.
RETURNED = [
    pytest.param("/returned-400/", 400, "WARNING", id="returned-400"),
    pytest.param("/returned-500/", 500, "ERROR", id="returned-500"),
]
SOURCES = [pytest.param(None, id="minted"), pytest.param(INBOUND, id="inbound")]
VIEW_LOGGER = "us014.view"
_view_log = logging.getLogger(VIEW_LOGGER)


# ── Fixture views — mounted nowhere but this module's urlpatterns ────────────


def warn_view(request: HttpRequest) -> HttpResponse:
    _view_log.warning("sync view")
    return HttpResponse("ok")


async def async_warn_view(request: HttpRequest) -> HttpResponse:
    _view_log.warning("async view")
    return HttpResponse("ok")


def returned_bad_request_view(request: HttpRequest) -> HttpResponse:
    return HttpResponseBadRequest("no")


def returned_server_error_view(request: HttpRequest) -> HttpResponse:
    return HttpResponseServerError("no")


def permission_denied_view(request: HttpRequest) -> HttpResponse:
    raise PermissionDenied


def bad_request_view(request: HttpRequest) -> HttpResponse:
    raise BadRequest("user a@example.com")


def streaming_view(request: HttpRequest) -> StreamingHttpResponse:
    def body() -> Iterator[bytes]:
        _view_log.warning("streamed")
        yield b"chunk"

    return StreamingHttpResponse(body())


def thread_view(request: HttpRequest) -> HttpResponse:
    _view_log.warning("view thread")
    worker = threading.Thread(target=lambda: _view_log.warning("spawned thread"))
    worker.start()
    worker.join()
    return HttpResponse("ok")


urlpatterns = [
    path("warn/", warn_view),
    path("async-warn/", async_warn_view),
    path("returned-400/", returned_bad_request_view),
    path("returned-500/", returned_server_error_view),
    path("denied/", permission_denied_view),
    path("bad-request/", bad_request_view),
    path("stream/", streaming_view),
    path("thread/", thread_view),
]


@pytest.fixture
def captured() -> Iterator[io.StringIO]:
    """The filter and minimal formatter on ``django.request`` and the views' logger."""
    handler, stream = capturing_handler("minimal")
    loggers = [logging.getLogger("django.request"), _view_log]
    for logger in loggers:
        logger.addHandler(handler)
    try:
        yield stream
    finally:
        for logger in loggers:
            logger.removeHandler(handler)
        handler.close()


def _only_line(stream: io.StringIO, logger: str) -> dict[str, Any]:  # DICT-OK: a parsed line
    lines = [line for line in lines_of(stream) if line.get("logger") == logger]
    assert len(lines) == 1, lines
    return lines[0]


class TestCorrelatedInsideTheChain:
    """HP-07, HP-07b, HP-10 — the ``ContextVar`` covers records logged inside the chain."""

    def test_a_sync_view_line_carries_the_minted_id(self, captured: io.StringIO) -> None:
        """HP-07, ``Client``."""
        response = Client().get("/warn/")

        assert MINTED.fullmatch(response["X-Request-ID"])
        assert _only_line(captured, VIEW_LOGGER)["request_id"] == response["X-Request-ID"]

    @pytest.mark.asyncio
    @pytest.mark.parametrize("url", ["/warn/", "/async-warn/"], ids=["sync-view", "async-view"])
    async def test_async_client(self, captured: io.StringIO, url: str) -> None:
        """HP-07 through ``AsyncClient``; HP-07b for an ``async def`` view."""
        response = await AsyncClient().get(url)

        assert MINTED.fullmatch(response["X-Request-ID"])
        assert _only_line(captured, VIEW_LOGGER)["request_id"] == response["X-Request-ID"]

    def test_a_raised_permission_denied_is_correlated(self, captured: io.StringIO) -> None:
        """HP-10, ``Client`` — logged by ``response_for_exception`` inside the chain."""
        response = Client().get("/denied/")

        line = _only_line(captured, "django.request")
        assert response.status_code == 403
        assert line["level"] == "WARNING"
        assert line["request_id"] == response["X-Request-ID"]

    @pytest.mark.asyncio
    async def test_a_raised_permission_denied_under_async_client(
        self, captured: io.StringIO
    ) -> None:
        """HP-10, ``AsyncClient``."""
        response = await AsyncClient().get("/denied/")

        assert response.status_code == 403
        assert _only_line(captured, "django.request")["request_id"] == response["X-Request-ID"]


class TestReturnedErrorsTakeTheStoredId:
    """HP-08, HP-09, EC-05, EC-22 — logged after the chain has reset the ``ContextVar``."""

    def test_a_returned_400_carries_the_id(self, captured: io.StringIO) -> None:
        """HP-08."""
        response = Client().get("/returned-400/")

        line = _only_line(captured, "django.request")
        assert response.status_code == 400
        assert line["level"] == "WARNING"
        assert line["request_id"] is not None
        assert line["request_id"] == response["X-Request-ID"]
        assert line["status_code"] == 400
        assert "request" not in line
        assert set(line) == FIXED_KEYS | {"status_code"}

    @pytest.mark.asyncio
    async def test_a_returned_400_under_async_client(self, captured: io.StringIO) -> None:
        """HP-09 — the path production runs, ``get_response_async``."""
        response = await AsyncClient().get("/returned-400/")

        line = _only_line(captured, "django.request")
        assert response.status_code == 400
        assert line["request_id"] is not None
        assert line["request_id"] == response["X-Request-ID"]
        assert line["status_code"] == 400
        assert "request" not in line

    @pytest.mark.parametrize("inbound", SOURCES)
    @pytest.mark.parametrize(("url", "status", "level"), RETURNED)
    def test_each_returned_error_and_id_source_under_client(
        self, captured: io.StringIO, url: str, status: int, level: str, inbound: str | None
    ) -> None:
        """HP-08 — 4xx and 5xx, minted and well-formed inbound, through ``Client``."""
        headers = {} if inbound is None else {"X-Request-ID": inbound}
        response = Client().get(url, headers=headers)

        _assert_returned_line(captured, response, status, level, inbound)

    @pytest.mark.asyncio
    @pytest.mark.parametrize("inbound", SOURCES)
    @pytest.mark.parametrize(("url", "status", "level"), RETURNED)
    async def test_each_returned_error_and_id_source_under_async_client(
        self, captured: io.StringIO, url: str, status: int, level: str, inbound: str | None
    ) -> None:
        """HP-09 — the same matrix through ``AsyncClient``, the path production runs."""
        # ``headers=``, not ``HTTP_*`` keywords: ``AsyncClient`` puts those in the scope, not META.
        headers = {} if inbound is None else {"X-Request-ID": inbound}
        response = await AsyncClient().get(url, headers=headers)

        _assert_returned_line(captured, response, status, level, inbound)

    def test_a_rejected_inbound_id_never_reaches_the_line(self, captured: io.StringIO) -> None:
        """EC-05 — the filter never falls back to ``request.META``."""
        response = Client().get("/returned-400/", HTTP_X_REQUEST_ID="bad id!")

        raw = captured.getvalue()
        line = _only_line(captured, "django.request")
        assert MINTED.fullmatch(response["X-Request-ID"])
        assert line["request_id"] == response["X-Request-ID"]
        assert "bad id!" not in raw

    def test_a_non_ascii_path_is_logged_escaped(self, captured: io.StringIO) -> None:
        """EC-22 — Django escapes the path argument, and the line is ASCII."""
        response = Client().get("/café/")

        raw = captured.getvalue()
        line = _only_line(captured, "django.request")
        assert response.status_code == 404
        assert raw.isascii()
        assert r"Not Found: /caf\\xe9/" in raw
        assert line["request_id"] == response["X-Request-ID"]


def _assert_returned_line(
    captured: io.StringIO, response: Any, status: int, level: str, inbound: str | None
) -> None:
    line = _only_line(captured, "django.request")
    assert response.status_code == status
    assert line["level"] == level
    assert line["status_code"] == status
    assert line["request_id"] == response["X-Request-ID"]
    if inbound is None:
        assert MINTED.fullmatch(line["request_id"])
    else:
        assert line["request_id"] == inbound


class TestTheMessageIsNotScrubbed:
    """EC-11 — the narrowed claim, tested as stated so the residue stays visible."""

    def test_bad_request_text_reaches_message_and_not_exc_info(self, captured: io.StringIO) -> None:
        response = Client().get("/bad-request/")

        line = _only_line(captured, "django.request")
        exc = line.get("exc_info")
        assert response.status_code == 400
        assert line["message"] == "user a@example.com: /bad-request/"
        assert isinstance(exc, dict)
        assert exc["type"] == "BadRequest"
        assert "a@example.com" not in str(exc)


class TestUncorrelatedOutsideTheExtent:
    """EC-06, EC-21, EC-21b — isolation where overlap is real, and the documented nulls."""

    def test_two_overlapping_requests_keep_their_own_ids(self, rf: RequestFactory) -> None:
        """EC-06 — threads behind a barrier: gathered ``AsyncClient`` calls never overlap."""
        handler, stream = capturing_handler("minimal")
        logger = logging.Logger("us014.barrier")
        logger.addHandler(handler)
        barrier = threading.Barrier(2, timeout=5)
        errors: list[BaseException] = []

        def serve(name: str) -> None:
            def get_response(request: HttpRequest) -> HttpResponse:
                barrier.wait()
                logger.warning(name)
                return HttpResponse("ok")

            try:
                RequestIDMiddleware(get_response)(rf.get("/", HTTP_X_REQUEST_ID=f"id-{name}"))
            except BaseException as error:  # surfaced on the main thread
                errors.append(error)

        workers = [threading.Thread(target=serve, args=(name,)) for name in ("a", "b")]
        for worker in workers:
            worker.start()
        for worker in workers:
            worker.join(timeout=10)

        assert errors == []
        by_message = {line["message"]: line["request_id"] for line in lines_of(stream)}
        assert by_message == {"a": "id-a", "b": "id-b"}

    def test_a_streamed_body_logged_after_the_view_is_null(self, captured: io.StringIO) -> None:
        """EC-21 — the generator runs after the middleware's ``finally``, as on a real server."""
        response = Client().get("/stream/")
        assert response.streaming
        assert b"".join(response.streaming_content) == b"chunk"  # type: ignore[arg-type]

        line = _only_line(captured, VIEW_LOGGER)
        assert MINTED.fullmatch(response["X-Request-ID"])
        assert "request_id" in line
        assert line["request_id"] is None

    def test_a_thread_the_view_starts_is_uncorrelated_on_the_default_build(
        self, captured: io.StringIO
    ) -> None:
        """EC-21b — read the build's flag rather than assume it."""
        response = Client().get("/thread/")

        lines = {line["message"]: line for line in lines_of(captured)}
        assert lines["view thread"]["request_id"] == response["X-Request-ID"]
        inherits = bool(getattr(sys.flags, "thread_inherit_context", 0))
        expected = response["X-Request-ID"] if inherits else None
        assert lines["spawned thread"]["request_id"] == expected
