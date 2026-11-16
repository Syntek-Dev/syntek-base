"""Fixture dev settings for negative-space.sh --self-test (US008). Never imported.

A `cookie-scope-widened` positive in a module no presence clause reads: absence is asserted
over every module in the directory, and a Path other than "/" breaks the __Host- contract.
"""

from __future__ import annotations

DEBUG = True
CSRF_COOKIE_PATH = "/app"
