# Workflow: Component Designs

## Directory Tree

```text
project-management/workflows/06-component-designs/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when designing reusable UI components before frontend implementation.
Run it after brand guides are agreed and before wireframing feature screens.

## Prerequisites

- [ ] Brand guide is agreed and design tokens are defined
- [ ] User flows for the in-scope area exist (`project-management/src/04-USER-FLOW/`)
- [ ] User stories exist for the feature area

## Key concepts

- Components are designed in Figma using the [team templates](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629) — open the component template and work within it
- Use brand tokens (Figma variables from the brand guide file) — never raw hex values
- Every component requires all states: default, hover, focus, disabled, error, success, empty
- Figma Code Connect maps component designs to codebase implementations
- Reuse existing components before designing new ones

## Cross-references

- `project-management/workflows/05-brand-guides/` — brand decisions that feed these designs
- `project-management/workflows/07-wireframes/` — follow this after components are approved
- `project-management/docs/RESPONSIVE-DESIGN.md` — viewport tiers to design component variants against
- `code/src/frontend/src/components/` — where implemented components live
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements
- `code/docs/RESPONSIVE-DESIGN.md` — breakpoint tokens and mobile viewport set for annotation
