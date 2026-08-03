@./CONTEXT.md

# CLAUDE.md — workflows/03-database-migration/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts, cross-references — imported above) → this file.

## Purpose (one line)

The procedure for any Django schema change — new model, altered field, index, or
migration — from `STEPS.md` through the `CHECKLIST.md` sign-off.

## How to work here

- **Routing:** this is a governance folder, not code — you follow the workflow, you
  do not edit it lightly. Schema work → `stack-django` skill (Opus). Read
  `CONTEXT.md` first; enter `STEPS.md` only when explicitly triggered; close with
  `CHECKLIST.md`. Hard gates named in `CONTEXT.md` must be read before Step 1:
  `code/docs/data-structures/SCHEMA-DESIGN.md` and, for any PII column,
  `code/docs/encryption/FIELD-ENCRYPTION.md`.
- **Model:** Opus to run the workflow (design + data-handling judgement)
  and a mechanical wording or numbering fix to the workflow files themselves.
- **Concrete steps:** generate migrations with `code/src/scripts/database/migrate.sh make`
  → verify with `migrate.sh check` → apply and inspect state with `showmigrations`.
  **Never run `manage.py`, `python`, or `docker` directly.** An approved schema
  document from `project-management/workflows/04-database-schema/` must precede this work.
- **Definition of done:** every `CHECKLIST.md` item ticked; migrations green in
  `migrate.sh check`; RLS policy updated alongside the schema where scoped.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Never hand-edit a generated migration** after committing; **never delete or
  modify an applied migration** — squash, never rewrite history.
- **Any new PII column** requires field encryption applied before commit
  (`code/docs/encryption/FIELD-ENCRYPTION.md`) — this is a hard gate, not a follow-up.
- Test against the test database before touching dev; destructive changes (dropped
  columns, renamed fields) need explicit data-handling.
- Editing these workflow `.md` files: keep each **≤ 300 code lines** (instructional-file limit).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Generated elsewhere (never authored here):** the migration files this workflow
  produces live under each app's `migrations/`, written by `migrate.sh make`.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`; schema
  approvals referenced as `US###`.
