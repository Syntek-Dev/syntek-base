"""Fixture settings for negative-space.sh --self-test (US008, R1 / QA-04). Never imported.

Two `cookie-scope-widened` positives inside a conditional block: an indented assignment
still widens the scope whenever its branch runs, so indentation must not hide it.
"""

from __future__ import annotations

SHARE_ACROSS_SUBDOMAINS = False

if SHARE_ACROSS_SUBDOMAINS:
    CSRF_COOKIE_DOMAIN = ".example.com"
    SESSION_COOKIE_PATH = "/app"
