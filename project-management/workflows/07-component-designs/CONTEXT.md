# Workflow: Component Designs

**Last Updated**: <%DATE%>

Components are where the brand becomes reusable. Designing them before screens is what stops
the same button being invented five times in five slightly different ways.

## Directory Tree

```text
project-management/workflows/07-component-designs/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

**Entry condition: the story's `Components` flag is not `N/A`.** The flag is set at
`02-story-creation` from the feature map's slice row, and it means the story introduces or reuses a component. A story whose
`Components` flag reads `N/A` skips this gate, and every downstream checklist reads the flag
rather than demanding this gate's artefact unconditionally
(`project-management/docs/planning/CADENCE.md`).

Use this workflow when designing reusable UI components before frontend implementation.
Run it after brand guides are agreed and before wireframing feature screens.

## Key concepts

- Components are designed against brand tokens — never raw hex values
- Every component requires all states: default, hover, focus, disabled, error, success, empty
- Every component record names the django-component it maps to, or records that it is new
- Always check the django-components library (`code/src/django/components/`) before
  designing a new component. If an existing component covers the need (even with minor
  CSS token overrides), reuse it rather than designing from scratch.

### Responsive behaviour

A component is designed **mobile-first at 360 px portrait** and must hold its shape across the
breakpoint set below. Two references own the mechanics and are not restated here:
`code/docs/responsive/BREAKPOINTS.md` (the breakpoint tokens and the device data behind them) and
`code/docs/responsive/CONTAINER-QUERIES.md` (a component adapts to its container, not the
viewport).

Sanity-check every design at both ends of the range — **320 px** and **10240 px**. Backgrounds
must fill, pinned elements must stay pinned, and nothing may distort or detach. A component that
only holds at one width is not designed.

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

Desktop threshold: W ≥ 1024 takes the desktop navbar; W < 1024 takes the mobile navbar.

## Cross-references

### Governing documents

- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA on all interactive components (CLAUDE.md Section 8); must inform design decisions from the start

### Related reading

- `code/docs/responsive/BREAKPOINTS.md` — mobile-first design principles; every component must be designed at 360 px portrait first
- `code/docs/responsive/CONTAINER-QUERIES.md` — container query implementation; components adapt to their container, not the viewport
- `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` — where each interaction runs (server, HTMX, Alpine); component design determines interactivity requirements
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — component-level performance targets (lazy loading, bundle impact)
- `code/docs/DESIGN-TOKENS.md` — tokens must be used; no raw hex values in component designs
- `code/src/django/components/` — check the django-components library before designing any new component
- `project-management/workflows/06-brand-guides/` — brand decisions that feed these designs
- `project-management/workflows/08-wireframes/` — follow this after components are approved
- `code/src/django/components/` — where implemented components live
