# code/src/django — Django Project

The Django project at its **baseline**: Django's own defaults plus the infrastructure
wiring this repository provides (PostgreSQL, Valkey, the environment-split settings).
The only application code is `apps/core` — project-wide primitives — and `apps/health`,
which answers the liveness and readiness probes. Neither owns a model; `apps/` is otherwise
awaiting its first domain module.

**Last Updated**: <%DATE%>

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

## Directory Tree

```text
django/
├── apps/                   # Django applications
│   ├── __init__.py
│   ├── core/               # shipped: schema bases, exception trees, middleware, command base (no models)
│   ├── health/             # shipped: /health/ liveness + /health/ready/ readiness (no models)
│   ├── CONTEXT.md
│   └── CLAUDE.md
├── config/                 # project configuration package
│   ├── settings/           # base.py, dev.py, staging.py, production.py, test.py
│   ├── urls.py             # health routes at /health/, Django admin at /control/
│   ├── asgi.py
│   └── wsgi.py
├── static/                 # static asset source — the global HTMX error handler only
│   └── js/observability.js
├── templates/              # project template directory — the 500 page only
│   └── 500.html
├── tests/                  # project-level suites (per-app tests live in apps/<app>/tests/)
│   ├── CONTEXT.md
│   ├── CLAUDE.md
│   └── e2e/                # browser suite — playwright-python + axe (see its CONTEXT.md)
├── CHANGELOG.md            # this deployable's own changelog — independent of the root's
├── conftest.py             # root pytest configuration
├── CONTEXT.md              ← this file
├── CLAUDE.md               # operating rules
├── manage.py               # Django CLI entry point — invoked through the scripts, never directly
├── pyrightconfig.json      # basedpyright roots and strictness for this package
├── RELEASES.md             # this deployable's release notes
└── VERSION-HISTORY.md      # this deployable's version history
```

> `pyproject.toml` and `uv.lock` live at the **project root**, not inside `django/`.

## Key Entry Points

| Path                      | Purpose                                                 |
| ------------------------- | ------------------------------------------------------- |
| `config/settings/base.py` | Shared settings — all environments inherit              |
| `config/urls.py`          | Root URL conf — `/health/` and the admin at `/control/` |
| `manage.py`               | Django CLI entry point                                  |

## What the baseline deliberately omits

No custom user model (`AUTH_USER_MODEL` is Django's `auth.User`), no third-party apps in
`INSTALLED_APPS`, no third-party middleware, no API layer, no base template or components, and
no domain models or migrations. Adding any of these is a deliberate act, recorded where the
project's conventions require.

`templates/` and `static/` are **not** empty, and the exception is narrow: each holds the one
file that carries a correctness rule rather than a design decision — the 500 page Django
resolves without any application asking it to, and the global HTMX error handler that stops a
5xx replacing nothing. Both are copy-placeholder until first-time setup. What is still absent on
that surface, and what each item waits on, is `code/docs/FRONTEND-CODING-PRINCIPLES.md`
Section _What is not built yet_.

## Cross-references

- `code/src/django/CLAUDE.md` — the operating rules for this project: the service-layer
  boundary, the permission and transaction requirements, and the baseline's guardrails
- `code/docs/DATABASE.md` — pre-flight data-layer rules; settle these before migrating
- `code/docs/ARCHITECTURE-PATTERNS.md` — Django app and service-layer patterns
- `code/docs/URL-STRATEGY.md` — why Django admin is at `/control/`, never `/admin/`
- `code/src/docker/CONTEXT.md` — how this project is containerised
