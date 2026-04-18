# project-management/src/DATABASE

Database design documentation for the syntek-website project.

## Directory Tree

```text
project-management/src/DATABASE/
├── CONTEXT.md                           ← this file
├── SCHEMA-<DESCRIPTOR>.md               ← schema design documents
├── ERD-<DESCRIPTOR>.md                  ← entity-relationship diagrams
└── MIGRATION-NOTES-<DESCRIPTOR>.md      ← migration decisions and runbooks
```

**Naming:** `SCHEMA-<DESCRIPTOR>.md` for schema docs, `ERD-<DESCRIPTOR>.md` for entity-relationship diagrams, `MIGRATION-NOTES-<DESCRIPTOR>.md` for migration decisions.

Contents include: ERDs, table design decisions, indexing strategies, RLS policy decisions, migration runbooks.

Related code: `code/src/backend/apps/*/migrations/`
Related guide: `code/docs/RLS-GUIDE.md`, `code/docs/ENCRYPTION-GUIDE.md`
