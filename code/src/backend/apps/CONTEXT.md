# code/src/backend/apps

Django applications for the Syntek Studio website backend. Each app is a self-contained module
with its own models, services, and GraphQL types.

## Directory Tree

```text
apps/
├── __init__.py
├── core/                    ← root GraphQL schema, shared utilities, field encryption
└── users/                   ← authentication and user management
```

> Additional apps (e.g. `content/`) are added as the project grows. Each new app is scaffolded
> with `code/src/scripts/development/new-django-app.sh`.

## App Registry

| App          | Django label | Purpose                                           |
| ------------ | ------------ | ------------------------------------------------- |
| `apps.core`  | `core`       | Root Strawberry GraphQL schema, Fernet encryption |
| `apps.users` | `users`      | Custom `AUTH_USER_MODEL`, authentication          |

## Conventions

- Each app is a Python package registered in `INSTALLED_APPS` as `"apps.<name>"`.
- Business logic lives in a `services.py` or `services/` module — resolvers stay thin.
- Every service method performing ≥ 2 writes must use `transaction.atomic()`.
- GraphQL types and resolvers go in a `schema.py` module within the app.
- Permissions are checked explicitly in every GraphQL mutation (OWASP A01).

## Cross-references

- `code/src/backend/CONTEXT.md` — full backend stack overview
- `code/docs/ARCHITECTURE-PATTERNS.md` — Django app and service layer patterns
- `code/docs/API-DESIGN.md` — Strawberry GraphQL conventions
