---
workflow: 08-debugging
phase: verify
agent: debugger
skills: [global-workflow]
model: opus
---

# Debugging — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **External — Debugging & Observability** · **External — Tools & CLI** for supporting references.

## Execution Checklist

- [ ] Root cause identified and documented · _opus_
- [ ] Fix implemented and tested · _opus_
- [ ] Tests passing (no regressions introduced) · _opus_
- [ ] If a significant bug: bug report saved to `project-management/src/20-BUGS/` · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] The problem no longer occurs · _opus_
- [ ] Tests confirm the fix · _opus_
- [ ] Committed and pushed · _opus_
