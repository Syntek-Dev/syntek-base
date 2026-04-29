# Workflow: Django Database Migration

> **Agent hints — Model:** Sonnet · **MCP:** `docfork` + `context7` (Django migrations)

## Directory Tree

```text
code/workflows/09-database-migration/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding new models, altering fields, or making any schema change
that requires a Django migration.

## Prerequisites

- [ ] Database containers are running
- [ ] No uncommitted previous migrations

## Key concepts

- Migrations are version-controlled — never hand-edit generated files after committing
- Test against the test database before applying to dev
- Destructive changes (dropping columns, renaming fields) require careful data handling
- Run `showmigrations` to confirm state before and after

## Cross-references

- `code/docs/DATA-STRUCTURES.md` — schema design principles
