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
- [ ] Every component designed **within the committed direction** — checked against the six axes in `code/docs/VISUAL-DESIGN.md` § 3, never against taste
- [ ] Checked by eye against § 4.1 and § 4.2 — **no script gate here**: these artefacts are Figma and LaTeX, which none of the slop audits reads (`DESIGN.md` → _The design-time gate_)
- [ ] Every new component designed in Figma using brand tokens (no raw hex values) · _opus · MCP: figma_
- [ ] All states designed: default, hover, focus, disabled, error, success, empty/loading
- [ ] Props / variants annotated in Figma
- [ ] Accessibility annotations included: ARIA role, keyboard interaction, focus management
- [ ] Responsive behaviour documented
- [ ] WCAG 2.2 AA contrast ratios verified for all colour combinations
- [ ] Focus indicators visible and meet 3:1 contrast ratio
- [ ] Touch targets are at least 24 × 24 px
- [ ] Code Connect mappings registered for all Figma ↔ codebase component pairs · _opus · MCP: figma_

### Flexible layout constraints

- [ ] Every component uses `layoutMode: 'NONE'` (no auto-layout on the root frame)
- [ ] Background rectangle has `STRETCH × STRETCH` constraints
- [ ] Left-pinned children (logo, card content start) have `MIN × CENTER` constraints
- [ ] Right-pinned children (CTA, hamburger, close) have `MAX × CENTER` constraints
- [ ] Centred content (hero text, quotes, modal body) has `CENTER × MIN` constraints
- [ ] Full-width text or dividers have `STRETCH × MIN` constraints
- [ ] Image / media placeholders have `SCALE × STRETCH` constraints
- [ ] Fixed-position badges (status dot, notification pip) have `MAX × MAX` constraints
- [ ] No child element left with default `MIN × MIN` unless intentionally left-top-pinned
- [ ] Resized to 320 px width — backgrounds fill, pinned elements stay correctly positioned
- [ ] Resized to 10240 px width — no element distorts or detaches from its expected position
- [ ] If rebuilt in-place via Figma MCP: same COMPONENT node used (key preserved); library re-published after rebuild

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Component designs reviewed and signed off before frontend implementation begins
- [ ] Code Connect mappings committed
- [ ] Design artefacts accessible in Figma for frontend developers
