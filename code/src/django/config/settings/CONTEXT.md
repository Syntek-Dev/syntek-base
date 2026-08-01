# code/src/django/config/settings

Environment-specific Django settings. Every environment module imports from `base.py` and
overrides only what differs. The active module is selected via `DJANGO_SETTINGS_MODULE`,
injected by the Docker environment file.

## Directory Tree

```text
config/settings/
├── __init__.py
├── base.py          ← shared settings (all environments)
├── CONTEXT.md       ← this file
├── CLAUDE.md        ← operating rules
├── dev.py           ← local development
├── production.py    ← production
├── staging.py       ← staging
└── test.py          ← pytest-django test runner
```

## Settings Module Map

| File            | `DJANGO_SETTINGS_MODULE`     | Key overrides                                          |
| --------------- | ---------------------------- | ------------------------------------------------------ |
| `base.py`       | _(never used directly)_      | Apps, middleware, DB, cache, i18n, static — all shared |
| `dev.py`        | `config.settings.dev`        | `DEBUG` from env, `ALLOWED_HOSTS=["*"]`, file logging  |
| `staging.py`    | `config.settings.staging`    | `DEBUG=False`, env `ALLOWED_HOSTS`, secure cookies     |
| `production.py` | `config.settings.production` | As staging, plus HSTS                                  |
| `test.py`       | `config.settings.test`       | MD5 hasher, in-memory cache and email                  |

## Critical Settings (base.py)

| Setting             | Value                               | Notes                                                     |
| ------------------- | ----------------------------------- | --------------------------------------------------------- |
| `SECRET_KEY`        | `os.environ["SECRET_KEY"]`          | Required — the process fails to start if it is missing    |
| `DATABASES`         | `dj_database_url` ← `DATABASE_URL`  | PostgreSQL; `conn_max_age=600`, health checks on          |
| `CACHES`            | `django_valkey.cache.ValkeyCache`   | `IGNORE_EXCEPTIONS` — a cache outage degrades to a miss   |
| `REDIS_URL`         | env, default `redis://cache:6379/0` | Compose service name                                      |
| `INSTALLED_APPS`    | `django.contrib.*` only             | No third-party apps at baseline                           |
| `MIDDLEWARE`        | Django defaults only                | No third-party middleware at baseline                     |
| `AUTH_USER_MODEL`   | _(unset — `auth.User`)_             | **Decide before the first migration**                     |
| `DJANGO_ADMIN_PATH` | `control/` (env-overridable)        | Django admin never mounts at `/admin/`                    |
| `LANGUAGE_CODE`     | `en-gb`                             | British English throughout                                |
| `TIME_ZONE`         | `Europe/London`                     | `USE_TZ=True`                                             |
| `DEBUG`             | _absent_                            | Each environment module reads it from the `DEBUG` env var |

## Not yet configured

The baseline has **no** CORS handling (`django-cors-headers` is declared but unregistered),
no static-file middleware, no error tracking, no Celery, and no Channels. Each is wired by
the feature that first needs it. In particular: **`CORS_ALLOWED_ORIGINS` must be added as
an explicit allowlist — never `["*"]` — at the moment an API surface is introduced.**

## Rules

- `DEBUG` is intentionally absent from `base.py` — set it only in environment modules.
- All secrets (`SECRET_KEY`, database credentials) come from environment variables.
- `SESSION_COOKIE_SECURE` is absent from `base.py`; `staging.py` and `production.py` each
  set it `True`. Dev inherits Django's `False`, correct for localhost over HTTP.
- Settings that differ per environment go in the environment module; shared values in
  `base.py`.

## Cross-references

- `code/src/docker/CONTEXT.md` — env files and `DJANGO_SETTINGS_MODULE` injection
- `code/docs/SECURITY.md` — security settings requirements
