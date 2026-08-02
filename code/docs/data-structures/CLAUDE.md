@./CONTEXT.md

# CLAUDE.md — code/docs/data-structures/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the data-structures standard — fundamentals, domain
modelling, anti-patterns, refactoring, and PostgreSQL schema design — behind the
`code/docs/DATA-STRUCTURES.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; consumed before any model or
  schema change and by the `03-database-migration` workflow.
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`FUNDAMENTALS.md`,
  `DOMAIN-MODELLING.md`, `ANTI-PATTERNS.md`, `REFACTORING.md`, `SCHEMA-DESIGN.md`) →
  keep `DATA-STRUCTURES.md` a thin index and update the `CONTEXT.md` file table on any
  change → verify length with `code/src/scripts/audits/cloc.sh`.
- **Definition of done:** guidance matches the shipped models and PostgreSQL 18
  schema; each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **Schema advice must stay migration-safe:** changes flow through
  `code/src/scripts/database/migrate.sh`, never hand-edited migrations — the guide
  must never suggest otherwise.
- PII-bearing fields point at `code/docs/ENCRYPTION-GUIDE.md`, not a bespoke recipe.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/DATA-STRUCTURES.md`.
