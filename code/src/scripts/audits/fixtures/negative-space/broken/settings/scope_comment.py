"""Fixture settings for negative-space.sh --self-test (US008, QA-01). Never imported.

Two `cookie-scope-widened` positives whose trailing comment quotes a root-Path assignment.
A comment is not code: it must neither hide the Domain nor make the Path root.
"""

from __future__ import annotations

SESSION_COOKIE_DOMAIN = ".example.com"  # not SESSION_COOKIE_PATH = "/"
CSRF_COOKIE_PATH = "/app"  # was _PATH = "/"
