# Workflow: Wireframes

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/08-wireframes/
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
- Documents are saved to `project-management/src/08-WIREFRAMES/`
- Every interactive element must have a defined state (default, hover, focus, error, empty)
- Wireframes drive the component structure in `code/src/django/components/`

- Before specifying a new UI element in a wireframe, confirm it does not already exist in
  the django-components library (`code/src/django/components/`). Reuse existing components
  where possible to avoid redundant design and implementation work.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA must be considered at layout stage; interactive element states required from the start

### Soft references — consult during execution

- `code/docs/responsive/BREAKPOINTS.md` — device data and orientation stats; all wireframes start at 360 px portrait and scale up
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — wireframe page structure determines the server, HTMX and Alpine split
- `code/docs/URL-STRATEGY.md` — URL and route structure that wireframe navigation must follow
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — page structure choices affect Core Web Vitals (LCP, CLS)
- `project-management/src/08-WIREFRAMES/` — where wireframe documents are saved
- `project-management/src/05-USER-FLOW/` — wireframes must implement the agreed user flows
- `project-management/workflows/07-component-designs/` — component library to draw from
- `project-management/workflows/09-gdpr-compliance/` — follow this after wireframes are approved
- `project-management/workflows/10-security-checks/` — run after GDPR compliance
- `project-management/workflows/11-qa-checks/` — run after security checks
