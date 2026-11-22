"""Fixture staging settings for negative-space.sh --self-test (US008). Never imported.

Both __Host- names beside the SECURE lines they depend on, in the same module.
"""

from __future__ import annotations

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_NAME = "__Host-sessionid"
CSRF_COOKIE_NAME = "__Host-csrftoken"
