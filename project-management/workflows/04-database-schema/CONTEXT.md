# Workflow: Database Schema Design

**Last Updated**: <%DATE%>

Schema is the most expensive thing to change after it ships, and the cheapest before the first
migration. This gate exists to spend the thinking while it is still cheap.

## Directory Tree

```text
project-management/workflows/04-database-schema/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

**Entry condition: the story's `DB` flag is not `N/A`.** The flag is set at
`02-story-creation` from the feature map's slice row, and it means the story creates or modifies a model. A story whose
`DB` flag reads `N/A` skips this gate, and every downstream checklist reads the flag
rather than demanding this gate's artefact unconditionally
(`project-management/docs/planning/CADENCE.md`).

Use this workflow before writing any Django model or migration — whenever a new
data structure, relationship, or schema change is being planned.

## Key concepts

- Schema design happens before code — models must reflect a reviewed, agreed design
- Documents are saved to `project-management/src/04-DATABASE/`
- Changes that affect existing data require an explicit migration strategy
- All schema decisions must align with `code/docs/data-structures/SCHEMA-DESIGN.md`

## Cross-references

### Governing documents

- `code/docs/data-structures/SCHEMA-DESIGN.md` — naming and index conventions; violations block model creation (PostgreSQL, normalisation, indexes, FK, migrations)
- `code/docs/encryption/FIELD-ENCRYPTION.md` — PII fields must be flagged and encrypted in the schema before coding begins

### Related reading

- `project-management/src/04-DATABASE/` — where schema design documents are saved
- `project-management/src/02-STORIES/` — the story driving the schema change
- `code/docs/data-structures/DOMAIN-MODELLING.md` — value objects, enums, aggregates, domain modelling conventions
- `code/docs/rls/FUNDAMENTALS.md` — row-level security policy design alongside schema changes
- `code/docs/security/AUTH-AND-AUTHZ.md` — database security, enumeration prevention, and IDOR considerations
- `project-management/docs/GDPR-GUIDE.md` — data classification for new personal data fields
- `code/workflows/03-database-migration/` — implements this schema, but is entered from
  `19-backend-code/` once the story plan (17) is signed off — **not** directly from here
