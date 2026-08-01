---
workflow: 02-daily-development
phase: setup
agent: git
skills: [global-workflow]
model: opus
---

# Daily Development — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (CLI-TOOLING.md, TOOLING-GUIDE.md) · **Internal → Cross-layer references** (GIT-GUIDE.md) · **External — Tools & CLI** for supporting references.

## Execution Checklist

- [ ] On a feature branch, not on `testing`, `dev`, `staging`, or `main` · _opus_
- [ ] Branch is up to date with `testing` · _opus_
- [ ] All containers healthy before starting work · _opus_
- [ ] Backend linter passes before committing · _opus_
- [ ] Frontend linter and type-check pass before committing · _opus_
- [ ] Backend and frontend test suites pass before pushing · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Work committed with a well-formed commit message · _opus_
- [ ] Branch pushed to remote · _opus_
