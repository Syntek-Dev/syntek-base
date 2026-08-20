"""Shared Django settings — every environment module imports from here.

This is the project baseline: Django's own defaults plus the infrastructure wiring
the repository already provides (PostgreSQL via ``dj-database-url``, Valkey via
``django-valkey``, server-rendered UI via ``django-components``). The only local
applications registered are ``apps.core`` and ``apps.health``; neither owns a model,
and ``apps/`` is otherwise awaiting its first domain module.

``DEBUG`` is deliberately absent: each environment module reads it from the
environment so the value always comes from the matching ``.env.<environment>``
file.
"""

from __future__ import annotations

import os
from pathlib import Path

import dj_database_url
from django_components import ComponentsSettings

BASE_DIR = Path(__file__).resolve().parent.parent.parent

SECRET_KEY = os.environ["SECRET_KEY"]

ALLOWED_HOSTS: list[str] = []

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # Third-party. django-components is the project's only component system; registering
    # it installs the `{% component %}` tag library and the autodiscovery pass that
    # imports each component module at AppConfig.ready(). Where those modules are looked
    # for is COMPONENTS, below.
    "django_components",
    # Local. `core` owns no models — it is registered so `apps.core` is a real app
    # rather than a bare package, and so app-loading order is explicit once it has any.
    "apps.core",
    # `health` owns no models either. Registered because its probes and views are app
    # code, and because an unregistered package cannot carry an AppConfig.
    "apps.health",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    # Third in the pipeline by doctrine, which puts security headers first — so a response
    # SecurityMiddleware short-circuits itself (the SSL redirect) carries no correlation
    # identifier. Accepted: that redirect never reaches application code, so there is
    # nothing to correlate it to.
    "apps.core.middleware.RequestIDMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        # APP_DIRS is absent rather than False: Django refuses a backend that sets both it
        # and an explicit `loaders` list, and django-components must be a loader for a
        # component's HTML to be findable at all. `app_directories.Loader` below is exactly
        # what APP_DIRS = True installs, so naming the loaders costs nothing.
        "OPTIONS": {
            # Cached in every environment, where Django would otherwise do it for itself
            # only when DEBUG is False. Safe in dev because the container runs Uvicorn with
            # --reload watching *.html, so a template edit restarts the process rather than
            # relying on the loader's cache being reset. See
            # code/src/docker/django/entrypoint.dev.sh.
            "loaders": [
                (
                    "django.template.loaders.cached.Loader",
                    [
                        "django.template.loaders.filesystem.Loader",
                        "django.template.loaders.app_directories.Loader",
                        "django_components.template_loader.Loader",
                    ],
                ),
            ],
            # `{% component %}` without a `{% load component_tags %}` at the head of every
            # template that renders one. The alternative is a line of ceremony per page,
            # forgotten once and then diagnosed as a missing component.
            "builtins": ["django_components.templatetags.component_tags"],
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

# The two places a django-component may live, which are django-components' own defaults
# made explicit. `dirs` is the top-level root, for a component more than one app renders;
# `app_dirs` is the folder name searched inside every installed app, for a component that
# app owns. Which of the two any given component belongs in is decided by ownership, and
# code/docs/FRONTEND-CODING-PRINCIPLES.md is the one place that rule is stated.
#
# Explicit because the default here is not what it looks like: django-components falls back
# to STATICFILES_DIRS whenever COMPONENTS.dirs is unset and STATICFILES_DIRS is not, so
# omitting this would silently make BASE_DIR / "static" the top-level component root.
#
# Neither directory exists yet and neither has to. An app-level folder is skipped unless it
# is on disk; a top-level dir is only ever globbed, and must be an absolute path.
COMPONENTS = ComponentsSettings(
    dirs=[BASE_DIR / "components"],
    app_dirs=["components"],
)

WSGI_APPLICATION = "config.wsgi.application"
ASGI_APPLICATION = "config.asgi.application"

# PostgreSQL, supplied as a URL by the Docker environment file. conn_max_age keeps
# connections warm across requests; conn_health_checks discards one that the server
# has already closed rather than failing the request that inherits it.
DATABASES = {
    "default": dj_database_url.config(
        env="DATABASE_URL",
        conn_max_age=600,
        conn_health_checks=True,
    ),
}

REDIS_URL = os.environ.get("REDIS_URL", "redis://cache:6379/0")

# Valkey speaks the RESP protocol, so the Redis-compatible client is correct here.
# IGNORE_EXCEPTIONS keeps a cache outage from taking the site down — a failed cache
# read degrades to a miss.
CACHES = {
    "default": {
        "BACKEND": "django_valkey.cache.ValkeyCache",
        "LOCATION": REDIS_URL,
        "TIMEOUT": 300,
        "OPTIONS": {
            "CLIENT_CLASS": "django_valkey.client.DefaultClient",
            "IGNORE_EXCEPTIONS": True,
        },
    },
}

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = "Lax"
# SESSION_COOKIE_SECURE is intentionally absent — dev inherits Django's default of
# False (correct for localhost over HTTP); staging and production each set it True.

# Django's own admin never mounts at /admin/: that prefix is reserved for the project's
# own admin surface, and a guessable path draws credential-stuffing traffic. Configurable
# so a deployment can move it again without a code change.
DJANGO_ADMIN_PATH = os.environ.get("DJANGO_ADMIN_PATH", "control/")

# How long /health/ready/ may serve a memoised verdict. Short by design: it exists so an
# external prober cannot stampede PostgreSQL and Valkey, not to make the endpoint cheap.
# Raising it past a probe interval means the status page reports the previous interval.
HEALTH_CACHE_TTL_SECONDS = int(os.environ.get("HEALTH_CACHE_TTL_SECONDS", "15"))

LANGUAGE_CODE = "en-gb"
TIME_ZONE = "Europe/London"
USE_I18N = True
USE_TZ = True

STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_DIRS = [BASE_DIR / "static"]

# Django's own two finders, named so a third can join them. A component's CSS and JS sit
# beside the component rather than under static/, and neither default finder looks there.
STATICFILES_FINDERS = [
    "django.contrib.staticfiles.finders.FileSystemFinder",
    "django.contrib.staticfiles.finders.AppDirectoriesFinder",
    "django_components.finders.ComponentsFileSystemFinder",
]

MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "mediafiles"

STORAGES = {
    "default": {"BACKEND": "django.core.files.storage.FileSystemStorage"},
    "staticfiles": {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"},
}

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# Minimal console logging. Each environment module replaces this wholesale with the
# handlers appropriate to it.
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
    },
    "root": {"handlers": ["console"], "level": "INFO"},
}
