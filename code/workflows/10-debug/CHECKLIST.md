---
workflow: 10-debug
phase: verify
skills: [bugfix, stack-django, stack-htmx-templates]
model: opus
---

# Debug — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (LOGGING.md, TESTING.md) · **External — Testing** for supporting references.

## Pre-Conditions

- [ ] Bug is reproducible
- [ ] Failing test written that pins the bug (test must fail before the fix)

---

## Execution Checklist

- [ ] Root cause identified — not just the symptom · _opus_
- [ ] Fix is minimal — no unrelated refactoring in the same commit · _opus_
- [ ] Regression test passes after the fix · _opus_
- [ ] All other existing tests still pass · _opus_
- [ ] Coverage not reduced by the change · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Regression test committed alongside the fix
- [ ] Bug report in `project-management/src/20-BUGS/` updated or closed if one exists
- [ ] Committed and pushed
