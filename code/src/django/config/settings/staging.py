"""Staging settings — production-shaped, with a separate host and credentials."""

from __future__ import annotations

import os

from .base import *  # noqa: F403

DEBUG = False

ALLOWED_HOSTS = [h.strip() for h in os.environ.get("ALLOWED_HOSTS", "").split(",") if h.strip()]

CSRF_TRUSTED_ORIGINS = [
    o.strip() for o in os.environ.get("CSRF_TRUSTED_ORIGINS", "").split(",") if o.strip()
]

# TLS terminates at the edge proxy, so Django learns the original scheme from the
# forwarded header rather than the socket.
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_NAME = "__Host-sessionid"
CSRF_COOKIE_NAME = "__Host-csrftoken"

# Content-hashed filenames, collected ahead of the container starting, so the edge
# can cache static assets indefinitely.
STORAGES = {
    "default": {"BACKEND": "django.core.files.storage.FileSystemStorage"},
    "staticfiles": {
        "BACKEND": "django.contrib.staticfiles.storage.ManifestStaticFilesStorage",
    },
}

# Minimal JSON to stdout — the five fixed keys, only duration_ms, status_code and method, and a
# message-free exc_info, each line held to 16 KiB (ADR-US014). Root at WARNING. The `django`
# logger is declared with no handlers so Django's DEFAULT_LOGGING console and mail_admins
# handlers do not survive; it propagates to root. This dict is identical in staging.py and
# production.py, and the suite asserts it (config/settings/CLAUDE.md, the LOGGING exception).
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "filters": {
        "request_id": {"()": "apps.core.observability.RequestIDFilter"},
    },
    "formatters": {
        "json": {"()": "apps.core.observability.JSONFormatter", "mode": "minimal"},
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "stream": "ext://sys.stdout",
            "formatter": "json",
            "filters": ["request_id"],
        },
    },
    "root": {"handlers": ["console"], "level": "WARNING"},
    "loggers": {
        "django": {"handlers": [], "level": "WARNING"},
    },
}
