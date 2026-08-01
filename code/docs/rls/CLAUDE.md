@./CONTEXT.md

# CLAUDE.md — code/docs/rls/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The row-level-security sub-documents behind `code/docs/RLS-GUIDE.md` — RLS
fundamentals, middleware and Django Ninja endpoint integration, reusable PostgreSQL
policy templates, and RLS testing and audit.

## How to work here

- **Routing:** documentation, not code — `doc-writer`, `database`, or
  `:security` agent (Opus). Governs user-scoped, row-isolated work under `stack-django`.
  Opus for mechanical touches.
- **Concrete steps:** edit the relevant sub-doc → keep `code/docs/RLS-GUIDE.md` a thin
  index → policy templates must be correct SQL that applies cleanly via a Django
  migration run through `code/src/scripts/database/migrate.sh`. Cross-link `SECURITY.md`
  where IDOR and permission concerns overlap.
- **Definition of done:** templates match the RLS actually enforced in the DB; testing
  guidance covers the bypass cases; each file ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split and demote the
  parent to an index if a file exceeds it.
- RLS is defence-in-depth, **not** a substitute for the explicit per-endpoint
  permission check or caller-ownership verification — document it as layered, never as
  a replacement for application-level authorisation.
- Policy templates must fail closed — no template that defaults to visible-to-all.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/RLS-GUIDE.md`.
