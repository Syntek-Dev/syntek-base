@./CONTEXT.md

# CLAUDE.md — code/docs/data-structures/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the data-structures standard — fundamentals, domain
modelling, anti-patterns, refactoring, PostgreSQL schema design, and the six-part
types-over-dictionaries family — behind the `code/docs/DATA-STRUCTURES.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; consumed before any model or
  schema change and by the `03-database-migration` workflow.
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`FUNDAMENTALS.md`,
  `DOMAIN-MODELLING.md`, `ANTI-PATTERNS.md`, `REFACTORING.md`, `SCHEMA-DESIGN.md`) →
  keep `DATA-STRUCTURES.md` a thin index and update the `CONTEXT.md` file table on any
  change → verify length with `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** guidance matches the shipped models and PostgreSQL 18
  schema; each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **`ANTI-PATTERNS.md` names the defects; the `TYPES-*` family states the rule.** Never restate
  one in the other — a pattern gets a link, not a second explanation
  (`code/src/scripts/audits/doctrine-drift.sh` is the gate). The same line divides
  `TYPES-OVER-DICTIONARIES.md` from `TYPES-EXCEPTIONS.md`: the standard never lists an
  exception, and the exceptions file never restates the standard.
- **A change to the `DICT-OK:` marker string is a change to a script.** The marker is parsed by
  `code/src/scripts/audits/dict-discipline.sh`; edit the guide and the script's clause `M`
  together, and run `dict-discipline.sh --self-test` before committing either.
- **A surface guide may not contradict its surface's own principles guide.** In particular
  `TYPES-TYPESCRIPT.md` must not mandate branded ID types — `code/docs/MOBILE-CODING-PRINCIPLES.md`
  Section 3 declined them at baseline with a stated trigger, and that decision is the owner's.
- **Schema advice must stay migration-safe:** changes flow through
  `code/src/scripts/database/migrate.sh`, never hand-edited migrations — the guide
  must never suggest otherwise.
- PII-bearing fields point at `code/docs/ENCRYPTION-GUIDE.md`, not a bespoke recipe.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/DATA-STRUCTURES.md`.
