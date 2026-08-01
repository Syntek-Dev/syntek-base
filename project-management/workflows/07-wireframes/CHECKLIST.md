---
workflow: 07-wireframes
phase: design
agent: frontend
skills: [stack-htmx-templates]
model: fable
---

# Wireframes — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (RESPONSIVE-DESIGN.md) · **Internal — Live Artefacts** (src/07-WIREFRAMES/) for supporting references.

## Execution Checklist

- [ ] All pages and components in scope are covered
- [ ] Happy path and all edge cases (empty, loading, error) have wireframes
- [ ] All interactive element states defined (default, hover, focus, disabled, error, success)
- [ ] Navigation and routing annotated — no dead ends
- [ ] Accessibility notes included (focus order, ARIA roles, colour contrast)
- [ ] Linked to the corresponding user story (`US###.md`)
- [ ] Document saved at `project-management/src/07-WIREFRAMES/WF-US###-<DESCRIPTOR>.md`

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Wireframes reviewed and signed off before frontend development begins
- [ ] Document committed and pushed
- [ ] `08-gdpr-compliance/` triggered as the next gate — **not** a code workflow; 01–15 must
      complete before any implementation begins
