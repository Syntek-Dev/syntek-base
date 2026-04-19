# code/src/backend/apps/core — migrations

Auto-generated Django migration files for the `core` app. The `core` app currently has no
database models, so this directory contains only the package `__init__.py`.

## Current State

| File          | Status              |
| ------------- | ------------------- |
| `__init__.py` | Package marker only |

New migrations are generated automatically when models are added to `apps.core`.

## Rules

- Never edit migration files by hand — use `code/src/scripts/database/migrate.sh make`.
- Never delete or modify applied migrations — squash if needed, never rewrite history.
- Always run `code/src/scripts/database/migrate.sh check` in CI to confirm no unapplied migrations.

## Cross-references

- `code/src/scripts/database/CONTEXT.md` — migration runner scripts
- `code/src/backend/apps/core/CONTEXT.md` — core app overview
