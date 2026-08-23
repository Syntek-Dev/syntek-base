"""Fixture views for static-analysis.sh --self-test. Never imported, never routed.

The counterparts to broken/views_taint.py. Every flow starts at the same request
attribute and reaches the same kind of sink, but passes through a sanitiser the rule
recognises — or reaches no sink at all. None of the four taint rules should fire.
"""

from __future__ import annotations

import os
import shlex

from django.db import connection
from django.http import HttpRequest, HttpResponse
from django.shortcuts import redirect
from django.urls import reverse

EXPORT_FORMATS = {"csv": "text/csv", "json": "application/json"}


def search(request: HttpRequest) -> HttpResponse:
    """Parameterised: the statement is a literal and the term is bound, never spliced."""
    term = request.GET["q"]
    with connection.cursor() as cursor:
        cursor.execute(
            "SELECT id, title FROM catalogue_item WHERE title LIKE %s",
            [f"%{term}%"],
        )
        rows = cursor.fetchall()
    return HttpResponse(str(rows))


def calculate(request: HttpRequest) -> HttpResponse:
    """No interpreter in the path: the request selects a key, it never supplies code."""
    requested = request.POST["format"]
    content_type = EXPORT_FORMATS.get(requested, "text/plain")
    return HttpResponse("ok", content_type=content_type)


def archive(request: HttpRequest) -> HttpResponse:
    """shlex.quote is the sanitiser the rule recognises for a shell sink."""
    name = request.GET["name"]
    os.system("tar -czf /tmp/export.tgz " + shlex.quote(name))
    return HttpResponse("queued")


def go_next(request: HttpRequest) -> HttpResponse:
    """reverse() resolves a route name, so no request value reaches the Location header."""
    route = request.GET["next"]
    target = reverse(
        route if route in {"catalogue:index", "account:home"} else "catalogue:index"
    )
    return redirect(target)
