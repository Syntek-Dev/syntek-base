---
workflow: 02-story-creation
phase: design
agent: user-story
skills: [global-workflow]
model: fable
---

# User Story Creation — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **External — Agile & Project Management** (User Story format) · **Internal — Live Artefacts** (src/02-STORIES/) for supporting references.

## Execution Checklist

- [ ] Story follows the standard format (role / goal / benefit)
- [ ] Acceptance criteria are specific and testable
- [ ] `**Status:**` header set to a valid ClickUp status (new stories → `Open`)
- [ ] Story number is sequential and not already taken
- [ ] File saved at the correct path: `project-management/src/02-STORIES/US###.md`

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Story is clear, unambiguous, and ready to plan
- [ ] Committed and pushed
- [ ] Accessibility criteria stated (WCAG 2.2 AA) — markup rules asserted in pytest, the resh` before raising PR (requires dev server running)
