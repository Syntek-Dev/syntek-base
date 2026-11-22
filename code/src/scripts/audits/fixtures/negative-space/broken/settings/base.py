"""Fixture base settings for negative-space.sh --self-test (US008). Never imported.

The `csrf-cookie-httponly-absent` positive. The assignment below is commented out, and a
commented-out assignment is ABSENT: a match is anchored to an assignment at the start of a
line, so neither this docstring nor the comment may satisfy the presence clause.
"""

from __future__ import annotations

SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = "Lax"
# CSRF_COOKIE_HTTPONLY = True
