import os

from .base import *  # noqa: F401, F403

DEBUG = os.environ.get("DEBUG", "true").lower() == "true"

ALLOWED_HOSTS = ["*"]

CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:3001",
]

EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
