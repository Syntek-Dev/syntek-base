@./CONTEXT.md

# CLAUDE.md — workflows/03-database-schema/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

Design and sign off a database schema — fields, relationships, constraints, and
migration strategy — **before** any Django model or migration is written.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`. **Hard gates:** read
  `code/docs/data-structures/SCHEMA-DESIGN.md` (naming/index conventions) and
  `code/docs/encryption/FIELD-ENCRYPTION.md` (PII flagging) before Step 1 — violations
  block model creation.
- **Model:** Fable — schema design is architectural.
- **ADR groundwork:** when a schema decision hinges on a stack choice or feeds an
  ADR/PLAN, load `.claude/skills/research/SKILL.md` for a primary-source-cited note.
- **Concrete steps:** confirm a driving `US###` exists and requirements are understood
  → design tables, relationships, indexes, and the migration strategy for existing data
  → flag every PII field for encryption → save the design to
  `project-management/src/03-DATABASE/`. Implementation follows in
  `code/workflows/09-database-migration/` — never write the migration here.
- **Definition of done:** design aligns with `SCHEMA-DESIGN.md`, PII fields are flagged
  and classified, a migration strategy exists for affected data, checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **PII must be flagged and marked for Fernet encryption at design time** — not
  retrofitted after coding (`code/docs/encryption/FIELD-ENCRYPTION.md`).
- Consider RLS scope (`code/docs/rls/FUNDAMENTALS.md`) and IDOR/enumeration
  (`code/docs/security/AUTH-AND-AUTHZ.md`) while the schema is on paper.
- Data-affecting changes need an explicit migration strategy; no uncommitted migration
  should exist for the affected app before you start.
- Documentation only — this folder produces a reviewed design, not code.

## Output & naming

- **Hand-written:** `SCHEMA-*.md`, `ERD-*.md`, `MIGRATION-NOTES-*.md` in
  `src/03-DATABASE/`; `STEPS.md`/`CHECKLIST.md` updates.
- Documentation files `SCREAMING-SNAKE-CASE.md`; stories referenced as `US###`;
  dates DD/MM/YYYY.
