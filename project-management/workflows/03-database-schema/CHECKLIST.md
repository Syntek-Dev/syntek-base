---
workflow: 03-database-schema
phase: design
agent: database
skills: [stack-django]
model: fable
---

# Database Schema Design — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (gdpr/COMPLIANCE.md) · **Internal — Live Artefacts** (src/03-DATABASE/) for supporting references.

## Execution Checklist

- [ ] All entities and fields documented with types, nullability, and defaults
- [ ] Relationships described clearly (one-to-many, many-to-many, etc.)
- [ ] Index strategy documented for foreign keys and high-frequency query fields
- [ ] Migration strategy documented if altering existing data
- [ ] Schema aligns with `code/docs/data-structures/SCHEMA-DESIGN.md` conventions
- [ ] Document saved at `project-management/src/03-DATABASE/DB-<FEATURE>-DD-MM-YYYY.md`

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Schema reviewed and signed off before any model code is written
- [ ] Document committed and pushed
- [ ] Handed forward to `12-api-design/` (next design gate) and recorded as the prerequisite for
      `16-backend-code/`, which drives `code/workflows/03-database-migration/` — the migration is
      **not** triggered from here
