# Workflow: Brand Guides

> **Agent hints — Model:** Sonnet · **MCP:** `figma`

## Directory Tree

```text
project-management/workflows/05-brand-guides/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when establishing or updating the visual brand identity — colour palette,
typography, spacing, and tone. Brand decisions must be agreed before component design begins.

## Prerequisites

- [ ] Product vision and target audience are understood
- [ ] No in-progress component design depends on tokens being changed

## Key concepts

- **Phase 1 — Generate:** Use [Claude Design by Anthropic Labs](https://www.anthropic.com/news/claude-design-anthropic-labs) to generate the initial logo concepts, colour palettes, typography, and visual direction. Document agreed outputs in `project-management/src/05-BRAND-GUIDE/` as `BRAND-<TOPIC>.md` files.
- **Phase 2 — Build:** Port those decisions into Figma using the [team templates](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629). The Figma brand guide is the shared design reference for all component and wireframe work.
- Brand decisions feed directly into the DB-driven design token system (colours, typography, spacing stored in Django admin → CSS variables → Tailwind v4)
- Breakpoints are build-time only and are not DB-driven
- A brand guide change that alters existing tokens requires a token migration plan

## Cross-references

- `project-management/workflows/06-component-designs/` — follow this after brand guides are agreed
- `project-management/docs/RESPONSIVE-DESIGN.md` — breakpoint token names and viewport tiers (breakpoints are build-time only, not DB-driven)
- `code/src/backend/` — design token models live here
- `code/src/frontend/` — Tailwind v4 configuration consumes the CSS variables
