"""Local development settings."""

from __future__ import annotations

import os
from pathlib import Path

from .base import *  # noqa: F403

DEBUG = os.environ.get("DEBUG", "true").lower() == "true"

ALLOWED_HOSTS = ["*"]

# The browser reaches the dev stack through nginx on host port 81, never Django's
# container port 8000 — which is unpublished, so an origin naming it can never match.
CSRF_TRUSTED_ORIGINS = [
    "http://dev.<%PROJECT_SLUG%>.localhost:81",
    "http://127.0.0.1:81",
    "http://localhost:81",
]

# MAILERS, not EMAIL_BACKEND: Django 6.1 deprecates the whole EMAIL_* family with a
# RemovedInDjango70Warning, and the two forms are mutually exclusive — defining MAILERS
# alongside any deprecated EMAIL_* setting raises ImproperlyConfigured rather than
# preferring one (django/conf/__init__.py). "default" is the alias Django looks for
# (django/core/mail/handler.py).
MAILERS = {
    "default": {"BACKEND": "django.core.mail.backends.console.EmailBackend"},
}

# A variable the view never passed renders as an empty string by default, so a typo looks
# like absent data. This makes it visible instead. Deliberately absent from staging and
# production: a non-empty value stops filters applying to invalid variables, so
# `{{ missing|default:"x" }}` would render the marker rather than "x" — a behaviour change,
# not a diagnostic. It is a partial aid even here, because `{% if %}`, `{% for %}` and
# `{% regroup %}` read an invalid variable as None and never consult it.
TEMPLATES[0]["OPTIONS"]["string_if_invalid"] = "[INVALID TEMPLATE VARIABLE: %s]"

# code/src/logs — gitignored runtime logs, shared with the dev tooling.
_LOGS_DIR = Path(__file__).resolve().parents[4] / "src" / "logs"
_LOGS_DIR.mkdir(exist_ok=True)

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "{asctime} {levelname} {name} {message}",
            "style": "{",
            "datefmt": "%Y-%m-%d %H:%M:%S",
        },
    },
    "handlers": {
        "console": {"class": "logging.StreamHandler", "formatter": "verbose"},
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "filename": _LOGS_DIR / "django.log",
            "maxBytes": 10 * 1024 * 1024,
            "backupCount": 5,
            "formatter": "verbose",
        },
    },
    "root": {"handlers": ["console", "file"], "level": "DEBUG"},
    "loggers": {
        "django": {"handlers": ["console", "file"], "level": "INFO", "propagate": False},
        # DEBUG on this logger emits full SQL — keep it at WARNING so query
        # parameters never reach the log files.
        "django.db.backends": {"handlers": ["file"], "level": "WARNING", "propagate": False},
    },
}
