"""Fixture settings for negative-space.sh --self-test (US008, QA2-03). Never imported.

Compliant spellings nothing else pins: single-quoted root Path and __Host- name, trailing
comments on compliant lines (one quoting a non-root Path), and a hash inside a quoted
string. The module turns on Secure, so it is a TLS module and every presence clause reads
it. Each line here is host-only, so no cookie clause may name this module.
"""

from __future__ import annotations

SESSION_COOKIE_SECURE = True  # the prefix requires Secure
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_NAME = "__Host-session#id"  # a hash inside the string is not a comment
CSRF_COOKIE_NAME = '__Host-csrftoken'
CSRF_COOKIE_HTTPONLY = True  # note
SESSION_COOKIE_PATH = '/'
SESSION_COOKIE_PATH = "/"  # was "/app"
