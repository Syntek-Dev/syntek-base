import os

from .base import *  # noqa: F401, F403

DEBUG = os.environ.get("DEBUG", "false").lower() == "true"

SECRET_KEY = os.environ.get("SECRET_KEY", "test-secret-key-not-for-production-use-only")

# 32 zero-bytes, base64-encoded — valid Fernet key for test runs only.
ENCRYPTION_KEY = os.environ.get("ENCRYPTION_KEY", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")

ALLOWED_HOSTS = ["*"]

EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"
