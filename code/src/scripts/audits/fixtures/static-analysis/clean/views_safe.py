"""Fixture views for static-analysis.sh --self-test. Never imported, never routed.

The counterparts to broken/views_safe.py. Each builds the same output without ever
handing raw markup to the template layer, so none of the three rules should fire.
"""

from __future__ import annotations

from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.utils.html import format_html


def render_bio(bio: str) -> str:
    """format_html escapes every interpolated argument; the literal parts stay markup."""
    return format_html("<p>{}</p>", bio)


def render_greeting(name: str) -> str:
    """Same shape, no f-string: the payload position is an escaped argument."""
    return format_html("<p>Hello, {}</p>", name)


def profile(request: HttpRequest, bio: str) -> HttpResponse:
    """Auto-escaping is left alone — the template renders under the engine's default."""
    return render(request, "profile.html", {"bio": bio})
