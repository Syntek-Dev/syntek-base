---
workflow: 05-user-flow-design
phase: design
agent: planner
skills: [global-workflow]
model: fable
---

# User Flow Design — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/docs/RESPONSIVE-DESIGN.md` (breakpoints and device data — the PM-layer file of that name is a redirect stub) · `project-management/REFERENCES.md` → **Internal — Live Artefacts** (src/05-USER-FLOW/) for supporting references.

## Execution Checklist

- [ ] Product area is identified and scoped
- [ ] All entry points to the area are listed
- [ ] Happy path is fully mapped — no missing transitions
- [ ] All alternative paths are covered (unauthenticated, validation failure, cancellation)
- [ ] Every decision node has a success and failure outcome
- [ ] Personal data touchpoints are annotated on each step
- [ ] Each step is linked to its corresponding user story (`US###.md`)
- [ ] File saved at `project-management/src/05-USER-FLOW/USER-FLOW-<AREA>.md`

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Flow reviewed and agreed before wireframing begins
- [ ] GDPR data touchpoints complete and ready for `09-gdpr-compliance/`
- [ ] Document committed and pushed
