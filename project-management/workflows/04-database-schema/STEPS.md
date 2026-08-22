---
workflow: 04-database-schema
phase: design
skills: [database, stack-django]
model: fable
---

# Database Schema Design — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step          | Section                                                                                                            |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| All steps     | **Internal — Live Artefacts** → src/04-DATABASE/                                                                   |
| Schema design | **Internal — Guides** → project-management/docs/gdpr/COMPLIANCE.md (data classification for PII fields, retention) |

---

## Steps

### Step 1 — Grill, then Identify Entities and Relationships

> **Model:** fable · **MCP:** code-review-graph

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> — entities and their real-world meaning,
relationships and cardinality, ownership/tenancy (RLS scope), constraints and
invariants, PII fields and lawful basis, retention, and expected query shapes. Record
resolved terminology in the nearest `CONTEXT.md` glossary and hard-to-reverse calls as
an ADR in `project-management/src/15-DECISIONS/`.

Then list all entities involved, their fields, data types, constraints, and how they
relate to one another (one-to-many, many-to-many, etc.).

Reference `code/docs/data-structures/SCHEMA-DESIGN.md` for naming and indexing conventions.

### Step 2 — Document the Schema

> **Model:** opus

Create a schema document in `project-management/src/04-DATABASE/`.

Name the file descriptively, e.g. `DB-<FEATURE>-DD-MM-YYYY.md`.

Include:

- Entity list with field names, types, nullability, and defaults
- Relationship diagram or description
- Index strategy
- Any constraints (unique, check, foreign key)
- Migration strategy if altering existing data

### Step 3 — Review

> **Model:** opus

Review the schema document for:

- Correctness against the user story acceptance criteria
- Normalisation — avoid redundant data
- Performance — indexes on all foreign keys and frequent query fields
- No breaking changes to existing data without a documented migration path

### Step 4 — Sign Off

The schema document must be agreed before any model code is written.
Record sign-off as a comment in the document or via PR review.

### Step 5 — Hand the Approved Schema Forward

The approved schema is a **prerequisite** for the migration, not an immediate trigger. It is
consumed at two points:

| Consumer                                | When                                                                       |
| --------------------------------------- | -------------------------------------------------------------------------- |
| `13-api-design/`                        | Next design gate — the Ninja Schema models must reflect this schema        |
| `19-backend-code/`                      | Implementation phase — the models and services are built from it           |
| `code/workflows/03-database-migration/` | Driven **from** `19-backend-code/`, once the story plan (17) is signed off |

Never write the migration here, and do not enter `code/workflows/03-database-migration/`
directly from this workflow — it runs inside the backend build phase.

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
