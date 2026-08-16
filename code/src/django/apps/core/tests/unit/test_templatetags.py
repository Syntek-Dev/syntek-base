"""The ``{% request_id %}`` tag — specifically, that it works where a context processor cannot.

Rendered with an **empty** ``Context`` and no request, because that is exactly how Django
renders ``500.html``. A tag that only worked with a request context would satisfy every
ordinary page and fail on the one page the identifier exists for.
"""

from __future__ import annotations

from django.template import Context, Template

import pytest

from apps.core.templatetags.core import request_id

pytestmark = pytest.mark.unit


def _render() -> str:
    """Render the tag the way the 500 page does — empty context, no request."""
    return Template("{% load core %}{% request_id %}").render(Context())


class TestRequestIdTag:
    def test_renders_the_identifier_with_no_context_at_all(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """The 500.html case: no request, no context processors, still an identifier."""
        monkeypatch.setattr("apps.core.templatetags.core.current_request_id", lambda: "abc123")

        assert _render() == "abc123"

    def test_renders_empty_outside_a_request(self) -> None:
        """Empty is a real answer — a stale identifier resolves to the wrong tracker event."""
        assert _render() == ""

    def test_is_callable_directly(self) -> None:
        assert request_id() == ""

    def test_is_registered_as_a_simple_tag(self) -> None:
        from apps.core.templatetags.core import register

        assert "request_id" in register.tags
