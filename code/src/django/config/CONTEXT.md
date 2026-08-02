# code/src/django/config

Django project configuration package — root URL conf, the ASGI/WSGI entry points, and the
environment-split settings.

## Directory Tree

```text
config/
├── __init__.py
├── asgi.py          ← ASGI entry point (Uvicorn workers under Gunicorn)
├── CONTEXT.md       ← this file
├── CLAUDE.md        ← operating rules
├── settings/        ← environment-specific settings modules
│   ├── base.py      ← shared settings (all environments inherit)
│   ├── dev.py       ← local development
│   ├── production.py
│   ├── staging.py
│   ├── test.py      ← pytest-django
│   ├── CONTEXT.md
│   └── CLAUDE.md
├── urls.py          ← root URL conf
└── wsgi.py          ← WSGI entry point (collectstatic tooling / fallback)
```

## URL Routes

| Path        | Handler                | Purpose                             |
| ----------- | ---------------------- | ----------------------------------- |
| `/control/` | `django.contrib.admin` | Django admin — superuser/staff only |

Under `DEBUG`, `staticfiles_urlpatterns()` is appended so the dev server serves
`/static/` from the finders.

> **Django admin must never mount at `/admin/`.** That prefix is reserved for the
> project's own admin surface. The mount point is `DJANGO_ADMIN_PATH` (default
> `control/`, environment-overridable). See `code/docs/URL-STRATEGY.md`.

There is no health, metrics, API, or SEO route at baseline. Each is added by the feature
that needs it — and `code/src/docker/docker-compose.dev.yml` currently probes `/` for its
backend healthcheck, so the first route added should account for that.

## Entry Points

| File      | Protocol | Used by                            |
| --------- | -------- | ---------------------------------- |
| `asgi.py` | ASGI     | Gunicorn + Uvicorn workers         |
| `wsgi.py` | WSGI     | Fallback / `collectstatic` tooling |

Both read `DJANGO_SETTINGS_MODULE` from the environment, defaulting to
`config.settings.dev`. `asgi.py` is a plain Django ASGI application — no Channels
`ProtocolTypeRouter`, no WebSocket route.

> **`asgi.py` is the one file a FastMCP surface changes.** Adding an MCP tool server turns it
> into a Starlette router mounting FastMCP at `/mcp/` beside Django at `/`, with the FastMCP
> lifespan hoisted to the outer application. That mount sits **outside Django's middleware
> chain** — no session, no CSRF, no `login_required` — which is why it authenticates itself.
> Nothing is mounted at baseline; the shape, the import-order trap, and the session-mode
> decision are in `code/docs/mcp-server/MOUNTING.md`.

## Cross-references

- `code/src/django/config/settings/CONTEXT.md` — settings detail per environment
- `code/docs/URL-STRATEGY.md` — route naming and the admin-path rule
- `code/src/docker/CONTEXT.md` — how the entry points are wired in Docker
