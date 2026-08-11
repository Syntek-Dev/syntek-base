# Workflow: Django Database Migration

A migration is the one change that is expensive to reverse once it reaches a deployed database.
The procedure is separate so the lock-safety and constraint questions are asked before the file
is generated, not after it has run.

## Directory Tree

```text
code/workflows/03-database-migration/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding new models, altering fields, or making any schema change
that requires a Django migration.

## Key concepts

- Migrations are version-controlled — never hand-edit generated files after committing
- Test against the test database before applying to dev
- Destructive changes (dropping columns, renaming fields) require careful data handling
- Run `showmigrations` to confirm state before and after

## Cross-references

### Governing documents

- `code/docs/data-structures/SCHEMA-DESIGN.md` — naming and index conventions; violations produce broken migrations (PostgreSQL schema design, normalisation, indexes, FK, soft deletes)
- `code/docs/encryption/FIELD-ENCRYPTION.md` — required when adding any PII column; must be applied before committing

### Related reading

- `code/docs/rls/TESTING-AND-AUDIT.md` — row-level security policy updates and new module checklist
- `code/docs/rls/FUNDAMENTALS.md` — RLS policy must be updated alongside schema changes
- `code/docs/data-structures/DOMAIN-MODELLING.md` — domain constraints on new fields
- `project-management/workflows/04-database-schema/` — the approved schema document is a hard
  prerequisite; that workflow designs the schema, this one implements it
- `project-management/workflows/18-backend-code/` — **this workflow is entered from there**, not
  directly from `04-database-schema/`: the migration is written during the backend build phase,
  once the story plan (`16-story-plans/`) is signed off
- `code/docs/architecture/CORE-AND-SCALING.md` — shard key is `tenant_id`; a new user-owned table must carry it (readiness + ADR-016 co-location)
