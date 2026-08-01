@./CONTEXT.md

# CLAUDE.md — django/apps/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(app registry + conventions, imported above) → this file → the target app's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The Django application registry — currently empty; each domain module added here owns its
own models, services, and endpoints, and registers as `apps.<name>`.

## How to work here

- **Routing:** backend app work → `stack-django` skill (Opus). **New app →
  `code/src/scripts/development/new-django-app.sh <name>`** — never `manage.py startapp`.
- **Grill first:** the first apps set the module boundaries everything later inherits, and
  nothing has migrated yet. Open app or schema design with a grilling pass
  (`.claude/skills/grill-with-docs`), not a fixed question list.
- **Model:** Opus for all app logic, tests, and mechanical touches.
- **Concrete steps:** read the target app's `CONTEXT.md` → business logic in
  `services.py`/`services/` (endpoints stay thin) → schema models under the app's
  `schema/` package → migrations via `code/src/scripts/database/migrate.sh make` →
  tests via `code/src/scripts/tests/*.sh`.
- **Definition of done:** app registered as `apps.<name>`; permission module in place
  where visibility is scoped; coverage floor met; the app's `CONTEXT.md` + `CLAUDE.md`
  pair written; the registry table in this folder's `CONTEXT.md` updated.

## Guardrails

- **Every state-changing endpoint carries an explicit permission check** (OWASP A01);
  user-supplied IDs verified against caller ownership — no IDOR.
- **Every service method doing ≥ 2 writes uses `transaction.atomic()`.**
- **Data invariants belong in the database** — FKs with explicit delete behaviour,
  `NOT NULL`, `UNIQUE`, and `CHECK` on every bounded column. Read `code/docs/DATABASE.md`
  before the first model; this tree is still pre-migration, so it is all cheap now.
- Keep complementary apps and their **separate permission modules** distinct — do not
  merge the visibility of two concerns because they happen to share a screen.
- Secrets via environment only; `DEBUG=False` outside local.
- Files **≤ 750 lines (800 grace)**; every new app package gets a `CONTEXT.md` + `CLAUDE.md`.

## Output & naming

- **Hand-written:** each app's `*.py` — models, services, schema, tests.
- **Generated (never hand-edit):** per-app `migrations/NNNN_*.py`.
- App packages `snake_case`, registered `apps.<name>`; documentation
  `SCREAMING-SNAKE-CASE.md`; stories referenced as `US###`.
