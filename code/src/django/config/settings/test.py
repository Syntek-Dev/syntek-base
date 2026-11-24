"""pytest-django settings — fast, hermetic, no external cache required."""

from __future__ import annotations

import os

from .base import *  # noqa: F403

DEBUG = False

ALLOWED_HOSTS = ["*"]

# Unsalted MD5 is orders of magnitude faster than the production hasher and is
# safe here because the test database never leaves the runner.
PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]

# In-memory cache so the suite runs without a live Valkey.
CACHES = {
    "default": {"BACKEND": "django.core.cache.backends.locmem.LocMemCache"},
}

# See dev.py for why this is MAILERS rather than EMAIL_BACKEND. locmem keeps sent mail in
# django.core.mail.outbox for assertions instead of delivering it.
MAILERS = {
    "default": {"BACKEND": "django.core.mail.backends.locmem.EmailBackend"},
}

# Matches dev, so a template assertion fails on a variable the view never passed rather than
# quietly comparing two empty strings. Kept out of staging and production, where a non-empty
# value would stop filters applying to invalid variables and change what renders.
TEMPLATES[0]["OPTIONS"]["string_if_invalid"] = "[INVALID TEMPLATE VARIABLE: %s]"

if os.environ.get("TEST_DATABASE_URL"):
    import dj_database_url

    DATABASES = {"default": dj_database_url.config(env="TEST_DATABASE_URL")}

# One console with no formatter, root at WARNING. It carries the request_id filter only so the
# every-handler invariant holds in every environment. The `django` logger matches staging and
# production — WARNING, no handlers of its own, propagating — so DEFAULT_LOGGING's console and
# mail_admins handlers do not survive here either.
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "filters": {
        "request_id": {"()": "apps.core.observability.RequestIDFilter"},
    },
    "handlers": {
        "console": {"class": "logging.StreamHandler", "filters": ["request_id"]},
    },
    "root": {"handlers": ["console"], "level": "WARNING"},
    "loggers": {
        "django": {"handlers": [], "level": "WARNING"},
    },
}
