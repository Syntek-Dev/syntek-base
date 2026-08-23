"""``RequestIDMiddleware`` — the correlation identifier, and the two ways it can go wrong.

The failure modes worth a test are both about *not* trusting things: an inbound header is
untrusted input echoed back into a response, and a ``ContextVar`` left set outlives the
request on a reused worker thread.
"""

from __future__ import annotations

from django.http import HttpResponse
from django.test import RequestFactory

import pytest

from apps.core.middleware import RequestIDMiddleware, current_request_id

pytestmark = pytest.mark.unit


def _middleware(seen: list[str] | None = None) -> RequestIDMiddleware:
    """Middleware whose inner view records the identifier visible while it runs."""

    def view(request: object) -> HttpResponse:
        if seen is not None:
            seen.append(current_request_id())
        return HttpResponse("ok")

    return RequestIDMiddleware(view)


class TestInboundIdentifier:
    """Reuse a well-formed one; never trust a malformed one."""

    def test_reuses_a_well_formed_inbound_identifier(self, rf: RequestFactory) -> None:
        request = rf.get("/", HTTP_X_REQUEST_ID="abc-123_XY.z")

        response = _middleware()(request)

        assert response["X-Request-ID"] == "abc-123_XY.z"

    @pytest.mark.parametrize(
        "hostile",
        [
            "has spaces",
            "<script>alert(1)</script>",
            "a" * 201,
            "id\r\nX-Injected: yes",
            "",
        ],
    )
    def test_replaces_anything_malformed_with_a_minted_identifier(
        self, rf: RequestFactory, hostile: str
    ) -> None:
        """The header is echoed into a response and rendered on an error page."""
        request = rf.get("/", HTTP_X_REQUEST_ID=hostile)

        response = _middleware()(request)

        assert response["X-Request-ID"] != hostile
        assert len(response["X-Request-ID"]) == 32

    def test_mints_one_when_no_header_arrives(self, rf: RequestFactory) -> None:
        response = _middleware()(rf.get("/"))

        assert len(response["X-Request-ID"]) == 32


class TestContextVarLifecycle:
    """A value left set would be reported against the next request the thread serves."""

    def test_the_identifier_is_readable_inside_the_view(self, rf: RequestFactory) -> None:
        seen: list[str] = []

        response = _middleware(seen)(rf.get("/", HTTP_X_REQUEST_ID="inside-view"))

        assert seen == ["inside-view"]
        assert response["X-Request-ID"] == "inside-view"

    def test_it_is_reset_after_the_response(self, rf: RequestFactory) -> None:
        _middleware()(rf.get("/", HTTP_X_REQUEST_ID="leaky"))

        assert current_request_id() == ""

    def test_it_is_reset_even_when_the_view_raises(self, rf: RequestFactory) -> None:
        """The ``finally`` branch — the one an exception path would otherwise skip."""

        def exploding_view(request: object) -> HttpResponse:
            raise RuntimeError("view blew up")

        middleware = RequestIDMiddleware(exploding_view)

        with pytest.raises(RuntimeError):
            middleware(rf.get("/", HTTP_X_REQUEST_ID="leaky"))

        assert current_request_id() == ""

    def test_it_is_empty_outside_a_request(self) -> None:
        assert current_request_id() == ""
