# code/src/django/config/settings

Environment-specific Django settings. Every environment module imports from `base.py` and
overrides only what differs. The active module is selected via `DJANGO_SETTINGS_MODULE`,
injected by the Docker environment file.

## Directory Tree

```text
config/settings/
├── __init__.py      ← package marker — the settings package, not a settings module
├── base.py          ← shared settings (all environments)
├── CONTEXT.md       ← this file
├── CLAUDE.md        ← operating rules
├── dev.py           ← local development
├── production.py    ← production
├── staging.py       ← staging
└── test.py          ← pytest-django test runner
```

## Settings Module Map

| File            | `DJANGO_SETTINGS_MODULE`     | Key overrides                                                                                                                                                                                                                                                                      |
| --------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `base.py`       | _(never used directly)_      | Apps, middleware, DB, cache, i18n, static — all shared. **No `LOGGING`**: each environment module carries its own                                                                                                                                                                  |
| `dev.py`        | `config.settings.dev`        | `DEBUG` from env, `ALLOWED_HOSTS=["*"]`, `:81` CSRF origins plus `DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA` (worktree overlay; wildcard or malformed raises), `string_if_invalid`; `LOGGING` wide JSON to console and a `RotatingFileHandler` at `code/src/logs/django.log`, root `DEBUG` |
| `staging.py`    | `config.settings.staging`    | `DEBUG=False`, env `ALLOWED_HOSTS`, secure, `__Host-`-named cookies; `LOGGING` minimal JSON to stdout, root `WARNING`, `django` at `WARNING` with no handlers                                                                                                                      |
| `production.py` | `config.settings.production` | As staging, plus HSTS; its `LOGGING` is identical to staging's, deliberately                                                                                                                                                                                                       |
| `test.py`       | `config.settings.test`       | MD5 hasher, in-memory cache and email, `string_if_invalid`; `LOGGING` one console handler, no formatter, no file, root `WARNING`                                                                                                                                                   |

## Critical Settings (base.py)

| Setting                   | Value                                   | Notes                                                                                                                                                      |
| ------------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SECRET_KEY`              | `os.environ["SECRET_KEY"]`              | Required — the process fails to start if it is missing                                                                                                     |
| `DATABASES`               | `dj_database_url` ← `DATABASE_URL`      | PostgreSQL; `conn_max_age=600`, health checks on                                                                                                           |
| `CACHES`                  | `django_valkey.cache.ValkeyCache`       | `IGNORE_EXCEPTIONS` — a cache outage degrades to a miss                                                                                                    |
| `REDIS_URL`               | env, default `redis://cache:6379/0`     | Compose service name                                                                                                                                       |
| `INSTALLED_APPS`          | `django.contrib.*` only                 | No third-party apps at baseline                                                                                                                            |
| `MIDDLEWARE`              | Django defaults + `RequestIDMiddleware` | No third-party middleware; the one local entry stamps `X-Request-ID` on every response                                                                     |
| `string_if_invalid`       | _absent from `base.py`_                 | `dev.py` and `test.py` only — a non-empty value stops filters applying to invalid variables, so it never ships onward                                      |
| `AUTH_USER_MODEL`         | _(unset — `auth.User`)_                 | **Decide before the first migration**                                                                                                                      |
| `DJANGO_ADMIN_PATH`       | `control/` (env-overridable)            | Django admin never mounts at `/admin/`                                                                                                                     |
| `LANGUAGE_CODE`           | `en-gb`                                 | British English throughout                                                                                                                                 |
| `TIME_ZONE`               | `Europe/London`                         | `USE_TZ=True`                                                                                                                                              |
| `DEBUG`                   | _absent_                                | Each environment module reads it from the `DEBUG` env var                                                                                                  |
| `SESSION_COOKIE_HTTPONLY` | `True`                                  | Shared — the session cookie is never readable from page script                                                                                             |
| `SESSION_COOKIE_SAMESITE` | `"Lax"`                                 | Shared — Django's default, stated explicitly                                                                                                               |
| `SESSION_COOKIE_SECURE`   | _absent_                                | `staging.py` and `production.py` set `True`; dev inherits Django's `False`, which is correct for localhost over HTTP                                       |
| `CSRF_COOKIE_SECURE`      | _absent_                                | Same shape as `SESSION_COOKIE_SECURE`: `staging.py` and `production.py` set `True`; dev inherits Django's `False`                                          |
| `CSRF_COOKIE_HTTPONLY`    | `True`                                  | Shared — the CSRF cookie is never readable from page script; the token reaches a form through `{% csrf_token %}`                                           |
| `SESSION_COOKIE_NAME`     | _absent_                                | `staging.py` and `production.py` set `"__Host-sessionid"`; dev inherits Django's plain `sessionid`, because a browser rejects an insecure `__Host-` cookie |
| `CSRF_COOKIE_NAME`        | _absent_                                | `staging.py` and `production.py` set `"__Host-csrftoken"`; dev inherits Django's plain `csrftoken`, for the same reason                                    |

Every handler in every `LOGGING` carries the `request_id` filter from `apps.core.observability`
(`code/docs/logging/DJANGO-LOGGING.md`).

## Not yet configured

The baseline has **no** CORS handling (`django-cors-headers` is declared but unregistered),
no static-file middleware, no error tracking, no Celery, and no Channels. Each is wired by
the feature that first needs it — the absences are deliberate, not oversights, and the one
with teeth is CORS: introducing an API surface is the moment `CORS_ALLOWED_ORIGINS` and the
`corsheaders` registration both become load-bearing.

## Cross-references

- `code/src/django/config/settings/CLAUDE.md` — the operating rules: what may go in
  `base.py`, the CORS allowlist requirement, and the secrets rule
- `code/src/docker/CONTEXT.md` — env files and `DJANGO_SETTINGS_MODULE` injection
- `code/docs/SECURITY.md` — security settings requirements
