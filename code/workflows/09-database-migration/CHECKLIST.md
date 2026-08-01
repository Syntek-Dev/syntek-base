---
workflow: 09-database-migration
phase: build
agent: database
skills: [stack-django]
model: opus
---

# Django Database Migration — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (DATA-STRUCTURES.md) · **External — Framework & Language Docs → Backend** (Django 6.x) · **External — Testing** for supporting references.

## Execution Checklist

- [ ] Migration generated and reviewed — matches intended schema change · _opus_
- [ ] Migration applied successfully to dev database · _opus_
- [ ] `showmigrations` confirms clean state · _opus_
- [ ] All existing tests still pass after migration · _opus_
- [ ] No data loss for existing records (if altering existing fields) · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Migration file committed alongside model changes
- [ ] Tests green
- [ ] Committed and pushed
