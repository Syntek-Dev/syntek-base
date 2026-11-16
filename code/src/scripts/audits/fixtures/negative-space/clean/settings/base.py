"""Fixture base settings for negative-space.sh --self-test (US008). Never imported.

The doctrine as it ships: HttpOnly on the CSRF cookie in the shared module, the SECURE
lines left to the environment modules. The commented Domain line below must be neither a
finding nor a pass.
"""

from __future__ import annotations

SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = "Lax"
CSRF_COOKIE_HTTPONLY = True
# SESSION_COOKIE_SECURE and CSRF_COOKIE_SECURE are intentionally absent — dev serves HTTP.
# SESSION_COOKIE_DOMAIN = ".example.com"
