@./CONTEXT.md

# CLAUDE.md — code/src/django/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(stack, layout, entry points — imported above) → this file → the target
`apps/` or `config/` `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The Django project at baseline — an empty `apps/` package, the environment-split
`config/settings/`, and root URL routing; PostgreSQL with a Valkey cache, and every
other dependency declared but unwired.

## How to work here

- **Routing:** Django Python (models, services, endpoints) → `stack-django` skill (Opus).
  New app → `code/src/scripts/development/new-django-app.sh <name>` — **never**
  `manage.py startapp`. Start substantive changes from the matching
  `code/workflows/NN-…/` procedure.
- **Grill first:** this tree is pre-migration, so schema and app-boundary choices are
  still cheap to change and expensive to get wrong. Substantial work opens with a
  grilling pass (`.claude/skills/grill-with-docs`) before code is written.
- **Model:** Opus for services, endpoints, templates, tests, and mechanical touches.
- **Concrete steps:** read the governing `code/docs/` guide → business logic in
  `services` (keep views and endpoints thin) → migrations via
  `code/src/scripts/database/migrate.sh make` → tests via `code/src/scripts/tests/*.sh`
  → lint/type-check via `code/src/scripts/syntax/*.sh`. **Never run `pytest`, `python`,
  `manage.py`, or `docker` directly.**
- **Definition of done:** coverage floor met (75%, 90% auth); every mutating operation
  permission-checked; migrations green in `migrate.sh check`; `CONTEXT.md` updated.

## Guardrails

- **Anything re-added to `INSTALLED_APPS` or `MIDDLEWARE` is a deliberate choice** — the
  baseline carries `django.contrib.*` plus `apps.core`, and Django's default middleware plus
  `RequestIDMiddleware`. Nothing third-party is registered. Add a dependency when the feature
  needs it, not in anticipation.
- **`AUTH_USER_MODEL` is Django's `auth.User`.** Swapping to a custom model after the
  first migration requires manual FK surgery — decide before the first `migrate`.
- **Every state-changing endpoint carries an explicit permission check** (OWASP A01);
  user-supplied IDs verified against caller ownership — no IDOR.
- **Business logic lives in services, never in a view or an endpoint** — the adapter layer
  stays thin so a second adapter can sit beside the first
  (`code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`).
- **Every service method doing ≥ 2 writes uses `transaction.atomic()`.**
- `DEBUG=False` in every non-local settings module; all secrets via environment only.
- **Django's admin lives at `/control/`, never `/admin/`** — see `code/docs/URL-STRATEGY.md`.
- Files **≤ 750 lines (800 grace)**; every new package gets a `CONTEXT.md` + `CLAUDE.md`.

## Output & naming

- **Hand-written:** `apps/**/*.py`, `config/settings/*.py`, `config/urls.py`, templates,
  tests.
- **Generated (never hand-edit):** migration files under each app's `migrations/`.
- App packages `snake_case` (registered as `apps.<name>`); documentation
  `SCREAMING-SNAKE-CASE.md`.
