---
workflow: 06-brand-guides
phase: design
agent: frontend
skills: [stack-htmx-templates]
model: fable
---

# Brand Guides — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (RESPONSIVE-DESIGN.md) · **Internal — Live Artefacts** (src/06-BRAND-GUIDE/) for supporting references.

## Execution Checklist

- [ ] Brand principles (personality, tone, visual direction) documented
- [ ] Full colour palette defined with hex values and semantic roles
- [ ] All colour combinations pass WCAG 2.2 AA contrast ratios
- [ ] Typography defined: typefaces, scale, weights, line heights
- [ ] Spacing scale defined with named tokens
- [ ] Layout breakpoints documented (build-time only — not DB tokens)
- [ ] Token records created or updated via the design-token admin area
- [ ] CSS variables generated and confirmed correct
- [ ] CSS variables consumed correctly by the frontend (no raw hex values or hard-coded sizes)
- [ ] Token migration plan documented if existing tokens are changing

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Brand guide agreed before component design begins
- [ ] Design token system updated and verified
- [ ] Document committed and pushed
