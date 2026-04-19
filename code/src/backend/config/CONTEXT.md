# code/src/backend/config

Django project configuration package. Contains URL routing, WSGI/ASGI entry points, a health
check view, and environment-split settings.

## Directory Tree

```text
config/
├── __init__.py
├── asgi.py                  ← ASGI entry point (Gunicorn + Uvicorn workers)
├── settings/                ← environment-specific settings files
│   ├── base.py              ← shared settings (all environments inherit this)
│   ├── dev.py               ← local development overrides
│   ├── production.py        ← production settings
│   ├── staging.py           ← staging settings
│   └── test.py              ← test runner settings (pytest-django)
├── urls.py                  ← root URL conf (admin, GraphQL, health)
├── views.py                 ← health check view
└── wsgi.py                  ← WSGI entry point (fallback / collectstatic tooling)
```

## URL Routes

| Path        | Handler                         | Purpose             |
| ----------- | ------------------------------- | ------------------- |
| `/admin/`   | `django.contrib.admin`          | Django admin UI     |
| `/graphql/` | `AsyncGraphQLView` (Strawberry) | GraphQL endpoint    |
| `/health/`  | `config.views.health_check`     | Load-balancer probe |

## Entry Points

| File      | Protocol | Used by                                            |
| --------- | -------- | -------------------------------------------------- |
| `asgi.py` | ASGI     | Gunicorn + Uvicorn workers (dev hot-reload + prod) |
| `wsgi.py` | WSGI     | Fallback / collectstatic tooling                   |

## Cross-references

- `code/src/backend/config/settings/CONTEXT.md` — settings detail per environment
- `code/src/backend/apps/core/schema.py` — root GraphQL schema mounted here
- `code/src/docker/CONTEXT.md` — how the ASGI entry point is wired in Docker
