# Workflow: Database Schema Design

> **Agent hints — Model:** Sonnet · **MCP:** `docfork` + `context7` (Django ORM, PostgreSQL), `mcp-mermaid` (ERD diagrams)

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
- All schema decisions must align with `code/docs/DATA-STRUCTURES.md`

## Cross-references

- `project-management/src/03-DATABASE/` — where schema design documents are saved
- `code/docs/DATA-STRUCTURES.md` — domain modelling and PostgreSQL conventions
- `code/workflows/09-database-migration/` — follow this after schema is approved
