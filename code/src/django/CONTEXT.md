# code/src/django — Django Project

The Django project at its **baseline**: Django's own defaults plus the infrastructure
wiring this repository provides (PostgreSQL, Valkey, the environment-split settings).
No application code — `apps/` is an empty package awaiting the first domain module.

**Last Updated**: {{DATE}}

## Stack

| Component   | Technology                            | Environments |
| ----------- | ------------------------------------- | ------------ |
| Language    | Python 3.14                           | all          |
| Framework   | Django 6.x                            | all          |
| Database    | PostgreSQL 18 (via `dj-database-url`) | all          |
| Cache       | Valkey (via `django-valkey`)          | all          |
| Server      | Gunicorn + Uvicorn                    | all          |
| Tests       | pytest, pytest-django                 | all          |
| Browser e2e | pytest-playwright + axe-core-python   | on demand    |

Everything else declared in the root `pyproject.toml` — Django Ninja, django-components,
django-htmx, Channels, Celery, Cloudinary, Sentry, and the rest — is
**available but unwired**. Each is registered when the feature that needs it is built.

## Directory Layout

```text
django/
├── apps/                   # Django applications — currently empty
│   ├── __init__.py
│   ├── CONTEXT.md
│   └── CLAUDE.md
├── config/                 # project configuration package
│   ├── settings/           # base.py, dev.py, staging.py, production.py, test.py
│   ├── urls.py             # Django admin at /control/ only
│   ├── asgi.py
│   └── wsgi.py
├── static/                 # static asset source (empty)
├── templates/              # project template directory (empty)
├── tests/                  # project-level suites (per-app tests live in apps/<app>/tests/)
│   ├── CONTEXT.md
│   ├── CLAUDE.md
│   └── e2e/                # browser suite — playwright-python + axe (see its CONTEXT.md)
├── CHANGELOG.md
├── conftest.py             # root pytest configuration
├── CONTEXT.md              ← this file
├── CLAUDE.md
├── manage.py
├── pyrightconfig.json
├── RELEASES.md
└── VERSION-HISTORY.md
```

> `pyproject.toml` and `uv.lock` live at the **project root**, not inside `django/`.

## Key Entry Points

| Path                      | Purpose                                     |
| ------------------------- | ------------------------------------------- |
| `config/settings/base.py` | Shared settings — all environments inherit  |
| `config/urls.py`          | Root URL conf — Django admin at `/control/` |
| `manage.py`               | Django CLI entry point                      |

## What the baseline deliberately omits

No custom user model (`AUTH_USER_MODEL` is Django's `auth.User`), no third-party apps in
`INSTALLED_APPS`, no third-party middleware, no API layer, no templates or components, and
no domain models or migrations. Adding any of these is a deliberate act, recorded where the
project's conventions require.

## Standards

- All code follows `code/docs/CODING-PRINCIPLES.md`
- Business logic in services, not views or endpoints
- Every service method doing ≥ 2 writes uses `transaction.atomic()`
- Every state-changing endpoint carries an explicit permission check (OWASP A01)
- Read `code/docs/DATABASE.md` **before** the first model or migration — the baseline is
  pre-migration, so every invariant it names is still cheap to settle

## Cross-references

- `code/docs/DATABASE.md` — pre-flight data-layer rules; settle these before migrating
- `code/docs/ARCHITECTURE-PATTERNS.md` — Django app and service-layer patterns
- `code/docs/URL-STRATEGY.md` — why Django admin is at `/control/`, never `/admin/`
- `code/src/docker/CONTEXT.md` — how this project is containerised
