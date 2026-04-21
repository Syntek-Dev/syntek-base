# Database Schema Design — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Identify Entities and Relationships

List all entities involved, their fields, data types, constraints, and how they
relate to one another (one-to-many, many-to-many, etc.).

Reference `code/docs/DATA-STRUCTURES.md` for naming and indexing conventions.

### Step 2 — Document the Schema

Create a schema document in `project-management/src/03-DATABASE/`.

Name the file descriptively, e.g. `DB-<FEATURE>-DD-MM-YYYY.md`.

Include:

- Entity list with field names, types, nullability, and defaults
- Relationship diagram or description
- Index strategy
- Any constraints (unique, check, foreign key)
- Migration strategy if altering existing data

### Step 3 — Review

Review the schema document for:

- Correctness against the user story acceptance criteria
- Normalisation — avoid redundant data
- Performance — indexes on all foreign keys and frequent query fields
- No breaking changes to existing data without a documented migration path

### Step 4 — Sign Off

The schema document must be agreed before any model code is written.
Record sign-off as a comment in the document or via PR review.

### Step 5 — Proceed to Migration

Once approved, follow `code/workflows/09-database-migration/` to implement.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
