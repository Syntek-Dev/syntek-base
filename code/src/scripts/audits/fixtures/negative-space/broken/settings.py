"""Fixture settings for negative-space.sh --self-test. Never imported.

MIDDLEWARE without the correlation identifier — the `request-id-middleware-absent`
positive. Note the mention in this docstring: apps.core.middleware.RequestIDMiddleware is
named here and the clause must still fire, because a comment is not the wiring.
"""

from __future__ import annotations

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
]
