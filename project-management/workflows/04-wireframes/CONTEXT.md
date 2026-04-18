# Workflow: Wireframes

## Directory Tree

```text
project-management/workflows/04-wireframes/
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
- Documents are saved to `project-management/src/WIREFRAMES/`
- Every interactive element must have a defined state (default, hover, focus, error, empty)
- Wireframes drive the component structure in `code/src/frontend/src/components/`

## Cross-references

- `project-management/src/WIREFRAMES/` — where wireframe documents are saved
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements for all interactive components
- `code/workflows/01-new-feature/` — follow this after wireframes are approved
