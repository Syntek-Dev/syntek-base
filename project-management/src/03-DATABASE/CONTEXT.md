# project-management/src/03-DATABASE

Database design documentation — one comprehensive per-feature schema design doc per
change (the workflow-03 output), plus rendered ERD diagrams. `DB-000-TEMPLATE.md` is the
template; copy it for every new schema design.

## Directory Tree

```text
project-management/src/03-DATABASE/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules for this folder
├── DB-000-TEMPLATE.md          ← schema-design template — copy for each new design
├── DB-<FEATURE>-DD-MM-YYYY.md  ← per-feature schema design docs (workflow-03 output)
└── ERD-DIAGRAMS/               ← rendered ERD images (PNG exports from the doc's Mermaid)
    ├── CONTEXT.md
    ├── CLAUDE.md
    └── erd-<domain>.png
```

**Naming:**

- `DB-<FEATURE>-DD-MM-YYYY.md` — per-feature schema design doc (workflow-03 output)
- `erd-<domain>.png` — rendered ERD image (kebab-case)

A schema design doc is comprehensive: scope, key decisions, conventions, tables,
cross-app FKs, PII classification, RLS scoping, IDOR notes, index strategy, migration
strategy, and the ERD (Mermaid). Full scaffold: `DB-000-TEMPLATE.md`.

## Rules

- **Design, not code** — the tables described here are created in
  `code/src/django/apps/*/` under Django migrations, never in this folder.
- **PII is flagged at design time** — every personal-data field enters via the doc's PII
  Classification section before its migration is written.

## Cross-references

- `code/docs/DATA-STRUCTURES.md` — naming, indexing, and modelling conventions
- `code/docs/RLS-GUIDE.md` — row-level security policy conventions
- `code/docs/ENCRYPTION-GUIDE.md` — field-level PII encryption pipeline

## Authoring a new schema design

Copy `DB-000-TEMPLATE.md` → name it `DB-<FEATURE>-DD-MM-YYYY.md` → complete every section
→ export the ERD to `ERD-DIAGRAMS/erd-<domain>.png` on sign-off.

**Last Updated**: {{DATE}}
