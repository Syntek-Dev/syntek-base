@./CONTEXT.md

# CLAUDE.md — src/03-DATABASE/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(schema-doc shape + naming, imported above) → this file → the `ERD-DIAGRAMS/`
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The database-design record — one comprehensive `DB-<FEATURE>-DD-MM-YYYY.md` per schema
design (tables, relationships, PII, RLS, indexes, migration strategy, ERD), plus the
rendered ERD diagrams in `ERD-DIAGRAMS/`.

## How to work here

- **Routing:** schema-design work runs through
  `project-management/workflows/03-database-schema/` (`STEPS.md` + `CHECKLIST.md`); use
  `database` for heavier modelling. This is _design documentation_ — the tables it
  describes are created in `code/src/django/apps/*/` under Django migrations, never here.
- **Model:** Fable for schema design, RLS decisions, and PII classification; Opus for
  mechanical touches — a status flip or a rename fix.
- **Concrete steps:** copy `DB-000-TEMPLATE.md` → name it `DB-<FEATURE>-DD-MM-YYYY.md` →
  complete every section (scope, decisions, tables, cross-app FKs, PII, RLS, indexes,
  migration, ERD) → export the ERD to `ERD-DIAGRAMS/erd-<domain>.png` on sign-off.
- **Definition of done:** schema doc complete and reviewed; PII fields flagged and
  classified; a migration strategy exists for affected data; ERD source and rendered
  diagram agree; British English.

## Guardrails

- **Design, not code** — no migrations, models, secrets, or `.env` content land here;
  the schema is _specified_ in the doc and _enforced_ in `code/`.
- **PII is flagged at design time** — every personal-data column enters via the doc's PII
  Classification section, and row-scoped tables via its RLS section, before the migration
  is written.
- Instructional `.md` (`CONTEXT.md`) ≤ 300 code lines; the schema-design artefacts
  themselves are exempt.

## Output & naming

- **Hand-written:** `DB-<FEATURE>-DD-MM-YYYY.md` schema designs and `DB-000-TEMPLATE.md`.
- **Template:** `DB-000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated (never hand-edit):** the rendered PNGs under `ERD-DIAGRAMS/` — regenerate
  from the doc's Mermaid ERD source when the schema changes.
- Docs `DB-<FEATURE>-DD-MM-YYYY.md`; ERD images `erd-<domain>.png` (kebab-case); stories
  referenced as `US###`; dates DD/MM/YYYY.
