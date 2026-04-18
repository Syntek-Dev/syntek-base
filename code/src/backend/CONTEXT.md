# code/src/backend — Django Project

This is the Django 6.0.4 + Strawberry GraphQL backend for the Syntek Studio website.

## Stack

| Component       | Technology                        | Environments  |
| --------------- | --------------------------------- | ------------- |
| Language        | Python 3.14                       | all           |
| Framework       | Django 6.0.4                      | all           |
| GraphQL         | Strawberry GraphQL 0.314.3        | all           |
| Database        | PostgreSQL 18                     | all           |
| Server          | Gunicorn + Uvicorn / Nginx        | all           |
| Cache/Queue     | Valkey (latest stable at release) | all           |
| Tests           | pytest, pytest-django             | all           |
| Media storage   | Cloudinary                        | all           |
| Error tracking  | Glitchtip (Sentry SDK)            | staging, prod |
| Log aggregation | Loki (via Promtail on server)     | staging, prod |
| Metrics         | Prometheus + django-prometheus    | staging, prod |
| Dashboards      | Grafana                           | staging, prod |

## Directory Layout (post-setup)

```text
backend/
├── apps/               # Django applications
│   ├── core/           # Root schema, shared utilities
│   ├── users/          # Authentication and user management
│   └── content/        # Site content models
├── config/
│   ├── settings/       # base.py, local.py, production.py
│   ├── urls.py
│   └── wsgi.py
├── manage.py
└── pyproject.toml      # Dependencies, ruff, pyright config
```

## Key Entry Points

| Path                       | Purpose                        |
| -------------------------- | ------------------------------ |
| `apps/core/schema.py`      | Root Strawberry GraphQL schema |
| `config/settings/base.py`  | Shared Django settings         |
| `config/settings/local.py` | Local development overrides    |
| `config/urls.py`           | URL routing                    |

## Standards

- All code must follow `code/docs/CODING-PRINCIPLES.md`
- Business logic in services, not resolvers — keep resolvers thin
- Every service method doing ≥ 2 writes must use `transaction.atomic()`
- GraphQL mutations require explicit permission checks (OWASP A01)

## Cross-references

- `code/docs/ARCHITECTURE-PATTERNS.md` — Django app and service layer patterns
- `code/docs/API-DESIGN.md` — Strawberry GraphQL conventions
- `code/docs/SECURITY.md` — permission and IDOR requirements
- `code/docs/DATA-STRUCTURES.md` — model and schema design
- `code/docs/LOGGING.md` — logging config, Glitchtip, Loki, Prometheus, Grafana, Cloudinary
