"""Fixture settings for negative-space.sh --self-test (US008, QA2-01). Never imported.

Every cookie setting named here is named in a string or a comment, never bound or read
in code, so no cookie clause may name this module. This docstring spans lines:
SESSION_COOKIE_DOMAIN = ".example.com" and CSRF_COOKIE_HTTPONLY = False are prose here.
"""

from __future__ import annotations

# CSRF_COOKIE_NAME = "csrftoken"
COOKIE_NOTE = "set SESSION_COOKIE_NAME to a __Host- name; never CSRF_COOKIE_PATH = '/app'"
COOKIE_KEYS = {'SESSION_COOKIE_SECURE': True, "CSRF_COOKIE_DOMAIN": None}
ESCAPED_NOTE = "a quoted \"SESSION_COOKIE_PATH\" stays inside the string"
LEGACY_SESSION_COOKIE_DOMAIN_NOTE = ".example.com"
COOKIE_HELP = '''
CSRF_COOKIE_SECURE = False is prose in a triple-quoted string.
'''
