# Workflow: Wireframes

## Directory Tree

```text
project-management/workflows/07-wireframes/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow before building any new page, screen, or significant UI component.
Wireframes must be agreed before frontend development begins.

## Prerequisites

- [ ] User story exists covering the page or feature being designed
- [ ] Acceptance criteria are understood (what the user must be able to do)
- [ ] WCAG 2.2 AA accessibility requirements have been noted

## Key concepts

- Wireframes represent layout and interaction — not final visual design
- Web and app wireframes are built in Figma using the [team templates](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629) — use the web wireframe template for Next.js screens and the mobile wireframe template for Expo screens
- Markdown or Excalidraw is acceptable for early sketches, but final signed-off wireframes live in Figma
- Documents are saved to `project-management/src/07-WIREFRAMES/`
- Every interactive element must have a defined state (default, hover, focus, error, empty)
- Wireframes drive the component structure in `code/src/frontend/src/components/` and `code/src/mobile/src/components/`

## Cross-references

- `project-management/src/07-WIREFRAMES/` — where wireframe documents are saved
- `project-management/docs/RESPONSIVE-DESIGN.md` — mobile-first design rationale and viewport tiers to wireframe against
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements for all interactive components
- `code/docs/RESPONSIVE-DESIGN.md` — breakpoint tokens for annotating layouts
- `code/workflows/01-new-feature/` — follow this after wireframes are approved
