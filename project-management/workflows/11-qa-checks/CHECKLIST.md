---
workflow: 11-qa-checks
phase: verify
skills: [qa-tester, stack-django, stack-htmx-templates]
model: fable
---

# QA Checks — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (QA-GUIDE.md) · **Internal — Live Artefacts** (src/11-QA/PLANNING/) for supporting references.

## Execution Checklist

- [ ] All in-scope user stories identified
- [ ] Every wireframe reviewed for happy path, error states, and edge cases
- [ ] Accessibility and responsive behaviour noted for each screen
- [ ] `qa-tester` skill run for each story
- [ ] `QA-US###-<DESCRIPTION>.md` created for every story in `project-management/src/11-QA/PLANNING/`
- [ ] Missing acceptance criteria fed back into the relevant `US###.md` files
- [ ] No stories with unresolved acceptance criteria gaps remain

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] QA documents exist for every in-scope story
- [ ] All user stories have complete acceptance criteria
- [ ] QA documentation committed and pushed
- [ ] Ready to proceed to `workflows/15-sprint-plans`
