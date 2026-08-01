# Workflow: Component Designs

**Last Updated**: {{DATE}}

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

- Components are designed in Figma using brand tokens — never raw hex values
- Every component requires all states: default, hover, focus, disabled, error, success, empty
- Figma Code Connect maps component designs to codebase implementations
- Always check the django-components library (`code/src/django/components/`) before
  designing a new component. If an existing component covers the need (even with minor
  CSS token overrides), reuse it rather than designing from scratch.

### Constraint-based flexible layout

All components in the component library use **`layoutMode: 'NONE'`** (frame with absolute
child positioning). Responsiveness is achieved entirely through **Figma child constraints**, not
auto-layout. This means every child element must have its constraints explicitly set:

| Element role                            | Horizontal | Vertical  |
| --------------------------------------- | ---------- | --------- |
| Background fill rectangle               | `STRETCH`  | `STRETCH` |
| Left-pinned content (logo, card start)  | `MIN`      | `CENTER`  |
| Right-pinned content (CTA, hamburger)   | `MAX`      | `CENTER`  |
| Centred content (hero text, quotes)     | `CENTER`   | `MIN`     |
| Full-width text or divider              | `STRETCH`  | `MIN`     |
| Proportionally scaled image placeholder | `SCALE`    | `STRETCH` |
| Fixed-position badge (e.g. status dot)  | `MAX`      | `MAX`     |

When a component instance is placed in a wireframe frame, it is resized as:
`inst.resize(breakpointWidth, inst.height)` — width matches the breakpoint; natural height is
preserved. The STRETCH background fills the full width; constrained children stay correctly
positioned without distortion.

**Do not use proportional scaling** (`scale = bp.W / inst.width; inst.resize(bp.W, inst.height * scale)`)
— this causes tall components to balloon at large breakpoints.

**In-place rebuild pattern**: When correcting an existing component, clear its children and
rebuild using the same COMPONENT node (same key). Instances in wireframe files auto-update when
the library is re-published — no need to re-place instances.

### 13 wireframe breakpoints

| Name | Width (px) | Navbar variant |
| ---- | ---------- | -------------- |
| Base | 320        | Mobile         |
| xs   | 360        | Mobile         |
| sm   | 430        | Mobile         |
| xmd  | 600        | Mobile         |
| md   | 768        | Mobile         |
| xlg  | 1024       | Desktop        |
| hd   | 1280       | Desktop        |
| lg   | 1920       | Desktop        |
| xl   | 2560       | Desktop        |
| 2xl  | 3840       | Desktop        |
| 3xl  | 5760       | Desktop        |
| 4xl  | 7680       | Desktop        |
| 5xl  | 10240      | Desktop        |

Desktop threshold: W ≥ 1024 → `Navbar/Desktop`; W < 1024 → `Navbar/Mobile`.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA on all interactive components (CLAUDE.md §8); must inform design decisions from the start

### Soft references — consult during execution

- `code/docs/responsive/BREAKPOINTS.md` — mobile-first design principles; every component must be designed at 360 px portrait first
- `code/docs/responsive/CONTAINER-QUERIES.md` — container query implementation; components adapt to their container, not the viewport
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — where each interaction runs (server, HTMX, Alpine); component design determines interactivity requirements
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — component-level performance targets (lazy loading, bundle impact)
- `code/docs/DESIGN-TOKENS.md` — tokens must be used; no raw hex values in component designs
- `code/src/django/components/` — check the django-components library before designing any new component
- `project-management/workflows/05-brand-guides/` — brand decisions that feed these designs
- `project-management/workflows/07-wireframes/` — follow this after components are approved
- `code/src/django/components/` — where implemented components live
