"""Fixture settings for negative-space.sh --self-test (US008, QA-05). Never imported.

Three `cookie-scope-widened` positives written in assignment forms other than `NAME = value`:
annotated, chained and augmented. Each binds the setting all the same.
"""

from __future__ import annotations

SESSION_COOKIE_DOMAIN: str = ".example.com"
SHARED_DOMAIN = CSRF_COOKIE_DOMAIN = ".example.com"
SESSION_COOKIE_PATH = "/"
SESSION_COOKIE_PATH += "app/"
