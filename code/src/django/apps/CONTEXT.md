# code/src/django/apps

Django applications for the project backend. **Currently empty** — the package exists so
the first domain module has a home, and so `apps.<name>` resolves as an import root.

**Last Updated**: {{DATE}}

## Directory Tree

```text
apps/
├── __init__.py      ← empty package marker
├── CONTEXT.md       ← this file
└── CLAUDE.md        ← operating rules
```

## App Registry

_No apps registered._ Each app added here gets a row below — Django label, purpose, and
the models it owns — and a line in `INSTALLED_APPS` as `apps.<name>`.

| App | Django label | Purpose |
| --- | ------------ | ------- |
| —   | —            | —       |

## Creating an app

`bash code/src/scripts/development/new-django-app.sh <app_name>` — the script wires the
package, its `apps.py`, and its registration. Never `manage.py startapp` or
`django-admin startapp`.

## Conventions

- Each app is a Python package registered in `INSTALLED_APPS` as `"apps.<name>"`.
- Business logic lives in a `services.py` or `services/` module — views and endpoints
  stay thin.
- Every service method performing ≥ 2 writes uses `transaction.atomic()`.
- Request/response schema models go in a `schema/` package within the app (or
  `schema.py` for a simple single-file case).
- Permissions are checked explicitly in every state-changing endpoint (OWASP A01).
- Every app package carries its own `CONTEXT.md` + `CLAUDE.md` pair.

## Before the first app

This tree is **pre-migration**. `code/docs/DATABASE.md` lists the invariants that are
cheap to settle now and expensive to retrofit — scope columns and the policies that read
them, database-level constraints, and the custom-user-model decision. Read it before the
first model.

## Cross-references

- `code/src/django/CONTEXT.md` — the Django project baseline
- `code/docs/DATABASE.md` — pre-flight data-layer rules
- `code/docs/ARCHITECTURE-PATTERNS.md` — Django app and service-layer patterns
