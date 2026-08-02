# Workflow: Database Schema Design

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/03-database-schema/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow before writing any Django model or migration — whenever a new
data structure, relationship, or schema change is being planned.

## Prerequisites

- [ ] User story exists covering the feature that requires the schema change
- [ ] Domain requirements are understood (fields, relationships, constraints)
- [ ] No existing migration is uncommitted for the affected app

## Key concepts

- Schema design happens before code — models must reflect a reviewed, agreed design
- Documents are saved to `project-management/src/03-DATABASE/`
- Changes that affect existing data require an explicit migration strategy
- All schema decisions must align with `code/docs/data-structures/SCHEMA-DESIGN.md`

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/data-structures/SCHEMA-DESIGN.md` — naming and index conventions; violations block model creation (PostgreSQL, normalisation, indexes, FK, migrations)
- `code/docs/encryption/FIELD-ENCRYPTION.md` — PII fields must be flagged and encrypted in the schema before coding begins

### Soft references — consult during execution

- `project-management/src/03-DATABASE/` — where schema design documents are saved
- `project-management/src/01-STORIES/` — the story driving the schema change
- `code/docs/data-structures/DOMAIN-MODELLING.md` — value objects, enums, aggregates, domain modelling conventions
- `code/docs/rls/FUNDAMENTALS.md` — row-level security policy design alongside schema changes
- `code/docs/security/AUTH-AND-AUTHZ.md` — database security, enumeration prevention, and IDOR considerations
- `project-management/docs/GDPR-GUIDE.md` — data classification for new personal data fields
- `code/workflows/09-database-migration/` — implements this schema, but is entered from
  `16-backend-code/` once the story plan (15) is signed off — **not** directly from here
