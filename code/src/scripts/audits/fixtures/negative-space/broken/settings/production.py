"""Fixture production settings for negative-space.sh --self-test (US008). Never imported.

Two positives in one module. `cookie-host-prefix-absent`: both names carry the prefix but
SESSION_COOKIE_SECURE = True, which the prefix depends on, is not in the same module.
`cookie-scope-widened`: a Domain is assigned, so a subdomain receives the cookie.
"""

from __future__ import annotations

CSRF_COOKIE_SECURE = True
SESSION_COOKIE_NAME = "__Host-sessionid"
CSRF_COOKIE_NAME = "__Host-csrftoken"
SESSION_COOKIE_DOMAIN = ".example.com"
