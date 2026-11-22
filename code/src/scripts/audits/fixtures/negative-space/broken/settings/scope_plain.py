"""Fixture settings for negative-space.sh --self-test (US008, QA-03). Never imported.

The two plain scope combinations no other module plants, so all four of SESSION/CSRF x
DOMAIN/PATH trip on their own: production.py carries SESSION_COOKIE_DOMAIN, dev.py
CSRF_COOKIE_PATH, and this module the other two.
"""

from __future__ import annotations

CSRF_COOKIE_DOMAIN = ".example.com"
SESSION_COOKIE_PATH = "/app"
