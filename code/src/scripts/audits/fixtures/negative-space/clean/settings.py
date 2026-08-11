"""Fixture settings for negative-space.sh --self-test. Never imported.

The middleware clause reads the MIDDLEWARE list and nothing else, so the correlation
identifier is wired here exactly as the real baseline wires it.
"""

from __future__ import annotations

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "apps.core.middleware.RequestIDMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
]
