"""Fixture views for static-analysis.sh --self-test. Never imported, never routed.

Trips all four taint rules in request-to-sink-taint.yml. Each function carries an
unbroken flow from a request attribute to a sink, with no sanitiser in between —
which is the only thing that distinguishes these from their `clean/` counterparts.
"""

from __future__ import annotations

import os

from django.db import connection
from django.http import HttpRequest, HttpResponse
from django.shortcuts import redirect


def search(request: HttpRequest) -> HttpResponse:
    """request-data-reaching-raw-sql: the term is concatenated into the statement."""
    term = request.GET["q"]
    with connection.cursor() as cursor:
        cursor.execute(
            "SELECT id, title FROM catalogue_item WHERE title LIKE '%" + term + "%'"
        )
        rows = cursor.fetchall()
    return HttpResponse(str(rows))


def calculate(request: HttpRequest) -> HttpResponse:
    """request-data-reaching-code-execution: the expression is evaluated."""
    expression = request.POST["expression"]
    return HttpResponse(str(eval(expression)))


def archive(request: HttpRequest) -> HttpResponse:
    """request-data-reaching-shell: the name reaches a shell unquoted."""
    name = request.GET["name"]
    os.system("tar -czf /tmp/export.tgz " + name)
    return HttpResponse("queued")


def go_next(request: HttpRequest) -> HttpResponse:
    """request-data-reaching-redirect: an open redirect, host never checked."""
    destination = request.GET["next"]
    return redirect(destination)
