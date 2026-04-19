# code/src/backend/apps/users — migrations

Auto-generated Django migration files for the `users` app.

## Current Migrations

| File              | Description                                                                          |
| ----------------- | ------------------------------------------------------------------------------------ |
| `0001_initial.py` | Creates `users_user` with Fernet-encrypted PII fields (first_name, last_name, email) |

## Rules

- Never edit migration files by hand — use `code/src/scripts/database/migrate.sh make`.
- Never delete or modify applied migrations — squash if needed, never rewrite history.
- Always run `code/src/scripts/database/migrate.sh check` in CI to confirm no unapplied migrations.

## Cross-references

- `code/src/scripts/database/CONTEXT.md` — migration runner scripts
- `code/src/backend/apps/users/CONTEXT.md` — users app overview
