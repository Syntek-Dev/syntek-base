"""Local development settings."""

from __future__ import annotations

import os
from pathlib import Path
from urllib.parse import urlsplit

from django.core.exceptions import ImproperlyConfigured

from .base import *  # noqa: F403

DEBUG = os.environ.get("DEBUG", "true").lower() == "true"

ALLOWED_HOSTS = ["*"]

_EXTRA_ORIGINS_VAR = "DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA"


def _parse_extra_origins(raw: str) -> tuple[str, ...]:
    """Parse a comma-separated list of full origins (``scheme://host[:port]``).

    Whitespace is stripped and empty items ignored, so unset or blank yields nothing. A
    wildcard or anything that is not exactly an http(s) origin raises rather than being
    dropped or loosened: a trusted-origin list must never widen silently.
    """
    origins: list[str] = []
    for item in (part.strip() for part in raw.split(",")):
        if not item:
            continue
        if "*" in item:
            msg = f"{_EXTRA_ORIGINS_VAR}: wildcards are not allowed ({item!r})"
            raise ImproperlyConfigured(msg)
        try:
            parts = urlsplit(item)
            port = parts.port
        except ValueError as exc:
            msg = f"{_EXTRA_ORIGINS_VAR}: {item!r} is not a valid origin"
            raise ImproperlyConfigured(msg) from exc
        is_origin = (
            parts.scheme in {"http", "https"}
            and bool(parts.hostname)
            and parts.username is None
            and parts.path == ""
            and not parts.query
            and not parts.fragment
            and not any(char.isspace() for char in item)
            and (port is not None or not parts.netloc.endswith(":"))
        )
        if not is_origin:
            msg = (
                f"{_EXTRA_ORIGINS_VAR}: {item!r} is not an origin of the form scheme://host[:port]"
            )
            raise ImproperlyConfigured(msg)
        origins.append(item)
    return tuple(origins)


# The browser reaches the main dev stack through nginx on host port 81, never Django's
# container port 8000 — which is unpublished, so an origin naming it can never match.
# A worktree story stack is published on 127.0.0.NNN:3080 and dev nginx forwards Host
# without the port, so its origins never match the request host either: the overlay
# (docker-compose.usXXX.dev.yml.example) supplies them through
# DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA, appended here after the defaults.
CSRF_TRUSTED_ORIGINS = [
    "http://dev.<%PROJECT_SLUG%>.localhost:81",
    "http://127.0.0.1:81",
    "http://localhost:81",
    *_parse_extra_origins(os.environ.get(_EXTRA_ORIGINS_VAR, "")),
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

# Wide JSON — every extra and the full traceback, the fixed keys written after the extras so
# none can be displaced. Uncapped: this file never leaves the host (ADR-US014). Every handler
# carries the request_id filter; only Django's own lines are JSON, uvicorn's stay plain text.
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "filters": {
        "request_id": {"()": "apps.core.observability.RequestIDFilter"},
    },
    "formatters": {
        "json": {"()": "apps.core.observability.JSONFormatter", "mode": "wide"},
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "json",
            "filters": ["request_id"],
        },
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "filename": _LOGS_DIR / "django.log",
            "maxBytes": 10 * 1024 * 1024,
            "backupCount": 5,
            "formatter": "json",
            "filters": ["request_id"],
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
