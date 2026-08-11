@./CONTEXT.md

# CLAUDE.md — workflows/18-backend-code/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, governing documents — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The backend implementation workflow — build the Django models, services, and business
logic for a story via TDD, once the database schema is approved and migrations are
applied.

## How to work here

- **Routing:** this workflow _drives code_, so implementation runs under the
  `stack-django` skill (Opus) alongside `code/workflows/02-tdd-cycle/` and
  `03-database-migration/`. Hard gates to read first: `PRACTICAL-RULES.md`,
  `security/AUTH-AND-AUTHZ.md`, `testing/COVERAGE.md`, `encryption/FIELD-ENCRYPTION.md`.
- **Model:** Opus for services, models, and tests and renames or running
  a script.
- **Concrete steps:** write failing tests first (TDD) → put business logic in
  `services` (Ninja endpoints stay thin) → migrations via
  `code/src/scripts/database/migrate.sh make` → tests via
  `code/src/scripts/tests/*.sh`, lint/type-check via `code/src/scripts/syntax/*.sh`.
  **Never run `pytest`, `python`, `manage.py`, or `docker` directly.** Satisfy
  `CHECKLIST.md`; next is `workflows/19-api-code/`.
- **Definition of done:** coverage floor met (75% all / 90% auth); every service
  method doing ≥ 2 writes wrapped in `transaction.atomic()`; PII encrypted before the
  first commit; checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Permission and IDOR checks precede any service method** (OWASP A01);
  user-supplied IDs verified against caller ownership.
- **Every service method doing ≥ 2 writes uses `transaction.atomic()`;** PII fields
  encrypted (AES-256-GCM) before the first commit.
- Source files ≤ 750 lines (800 grace); secrets via environment only; `DEBUG=False`
  outside local.
- All operations go through `code/src/scripts/**/*.sh` — never raw tooling.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the code itself lands in
  `code/src/django/apps/<name>/`.
- **Generated (never hand-edit):** per-app `migrations/NNNN_*.py` from the migration
  runner.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; stories
  referenced as `US###`; dates DD/MM/YYYY.
