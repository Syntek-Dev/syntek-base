---
workflow: 07-component-designs
phase: design
skills: [frontend, stack-htmx-templates]
model: fable
---

# Component Designs — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/docs/RESPONSIVE-DESIGN.md` (breakpoints and device data — the PM-layer file of that name is a redirect stub) · `project-management/REFERENCES.md` → **Internal — Live Artefacts** (src/07-COMPONENTS/) for supporting references.

## Execution Checklist

- [ ] All required components identified from user flows and stories
- [ ] Existing components checked — no unnecessary new components created
- [ ] Every component designed **within the committed direction** — checked against the six axes in `code/docs/VISUAL-DESIGN.md` Section 3, never against taste
- [ ] Checked by eye against Section 4.1 and Section 4.2 — **no script gate here**: these artefacts are Markdown and LaTeX, which none of the slop audits reads (`DESIGN.md` → _The design-time gate_)
- [ ] Every new component designed against brand tokens (no raw hex values)
- [ ] All states designed: default, hover, focus, disabled, error, success, empty/loading
- [ ] Props / variants annotated in the component record
- [ ] Accessibility annotations included: ARIA role, keyboard interaction, focus management
- [ ] Responsive behaviour documented
- [ ] WCAG 2.2 AA contrast ratios verified for all colour combinations
- [ ] Focus indicators visible and meet 3:1 contrast ratio
- [ ] Touch targets are at least 24 × 24 px
- [ ] Every component mapped to its django-component, or recorded as new

### Responsive behaviour

- [ ] Designed mobile-first at 360 px portrait
- [ ] Holds at 320 px — backgrounds fill, pinned elements stay correctly positioned
- [ ] Holds at 10240 px — no element distorts or detaches from its expected position
- [ ] Adapts to its container rather than the viewport (`code/docs/responsive/CONTAINER-QUERIES.md`)
- [ ] Navbar variant correct either side of the 1024 px desktop threshold

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Component designs reviewed and signed off before frontend implementation begins
- [ ] Component-to-django-component mappings recorded
- [ ] Design artefacts committed under `project-management/src/07-COMPONENTS/` for frontend developers
