"""Fixture UAT settings for negative-space.sh --self-test (US008, R3). Never imported.

A third TLS-serving module: it turns on SECURE_SSL_REDIRECT, so it serves over HTTPS like
staging.py and production.py, yet keeps plain cookie names. `cookie-host-prefix-absent` must
read it although its name is neither of those two.
"""

from __future__ import annotations

SECURE_SSL_REDIRECT = True
SESSION_COOKIE_NAME = "sessionid"
CSRF_COOKIE_NAME = "csrftoken"
