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

EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"

if os.environ.get("TEST_DATABASE_URL"):
    import dj_database_url

    DATABASES = {"default": dj_database_url.config(env="TEST_DATABASE_URL")}

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {"console": {"class": "logging.StreamHandler"}},
    "root": {"handlers": ["console"], "level": "WARNING"},
}
