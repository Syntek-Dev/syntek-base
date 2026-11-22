"""Fixture staging settings for negative-space.sh --self-test (US008). Never imported.

A `cookie-host-prefix-absent` positive: both SECURE lines are present, the CSRF cookie is
prefixed, and the session cookie keeps a plain name a subdomain can overwrite.
"""

from __future__ import annotations

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_NAME = "sessionid"
CSRF_COOKIE_NAME = "__Host-csrftoken"
