---
workflow: 01-first-time-setup
phase: setup
agent: setup
skills: [global-workflow]
model: opus
---

# First-Time Setup — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (DEVELOPMENT.md) · **External — Tools & CLI** for supporting references.

## Execution Checklist

- [ ] Repository cloned · _opus_
- [ ] `.env.dev` populated with required values · _opus_
- [ ] All containers start and report healthy · _opus_
- [ ] Migrations applied successfully · _opus_
- [ ] Public site accessible at http://localhost:8000/ · _opus · claude-in-chrome_
- [ ] API docs (OpenAPI) accessible at http://localhost:8000/api/docs · _opus · claude-in-chrome_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All services running without errors · _opus_
- [ ] Can log in to Django Admin · _opus · claude-in-chrome_
