---
workflow: 08-wireframes
phase: design
agent: frontend
skills: [stack-htmx-templates]
model: fable
---

# Wireframes — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/docs/RESPONSIVE-DESIGN.md` (breakpoints and device data — the PM-layer file of that name is a redirect stub) · `project-management/REFERENCES.md` → **Internal — Live Artefacts** (src/08-WIREFRAMES/) for supporting references.

## Execution Checklist

- [ ] All pages and components in scope are covered
- [ ] Happy path and all edge cases (empty, loading, error) have wireframes
- [ ] All interactive element states defined (default, hover, focus, disabled, error, success)
- [ ] Navigation and routing annotated — no dead ends
- [ ] Accessibility notes included (focus order, ARIA roles, colour contrast)
- [ ] Linked to the corresponding user story (`US###.md`)
- [ ] Screen saved at `project-management/src/08-WIREFRAMES/USER-STORY-IDEAS/WF-IDEA-US###-<Screen-Name>.html` — **stage 1.** `CONSOLIDATED-IDEAS/` is workflow `17`'s, and its screens drop the `IDEA` marker and the story number
- [ ] Self-contained — opens over `file://` with nothing to fetch; only dependency is `SHARED/wireframe.css`
- [ ] Composed from `wf-*` classes and `--wf-*` tokens — no raw colour or spacing literals
- [ ] Laid out **within the committed direction** — every screen checked against the six axes in `code/docs/VISUAL-DESIGN.md` § 3, not against taste
- [ ] The screen is not the shipped template's three-up in new clothes — if it repeats one card row, that is a decision with a reason, not a default

> **The script gate runs at `17`, not here.** § 4.1's repetition tell and § 4.2's rhythm clause are
> properties of a page **set**, and this workflow produces one screen at a time. `DESIGN.md` →
> _The design-time gate_.

### Mobile screens (mobile-only)

**Skip if the project has no mobile surface** — inapplicable, not unmet.

- [ ] Named `WF-###-MOBILE-<Screen-Name>.html`, sharing its web counterpart's number where one exists
- [ ] Composed at a phone viewport (390 × 844 reference), not full window width
- [ ] No intent carried by **hover** — there is no hover on touch
- [ ] No intent carried by a **scrollbar** — a native scroll view shows none
- [ ] Navigation drawn explicitly — there is no URL bar, back button, or tab
- [ ] Touch targets sized to the platform minimum (44 pt iOS / 48 dp Android)

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
- [ ] `09-gdpr-compliance/` triggered as the next gate — **not** a code workflow; 02–16 must
      complete before any implementation begins
