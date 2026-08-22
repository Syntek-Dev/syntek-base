# Workflow: Brand Guides

**Last Updated**: <%DATE%>

Brand decides how the product sounds and looks before anything is drawn, because retrofitting a
palette or a voice across built screens costs an order of magnitude more than settling it once.

## Directory Tree

```text
project-management/workflows/06-brand-guides/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

**Entry condition: the story's `Brand` flag is not `N/A`.** The flag is set at
`02-story-creation` from the feature map's slice row, and it means the story introduces or consumes a design token. A story whose
`Brand` flag reads `N/A` skips this gate, and every downstream checklist reads the flag
rather than demanding this gate's artefact unconditionally
(`project-management/docs/planning/CADENCE.md`).

Use this workflow when establishing or updating the visual brand identity — colour palette,
typography, spacing, and tone. Brand decisions must be agreed before component design begins.

## Brand workflow

Brand decisions flow through four stages:

```text
1. Ideation — Claude Design (claude.ai/design)
   └── Generate logo concepts, typography combinations, colour palette options

2. Decision record — project-management/src/06-BRAND-GUIDE/
   └── BRAND-COLOURS.md, BRAND-TYPOGRAPHY.md, BRAND-SPACING.md, BRAND-LOGOS.md
       Document the finalised values: hex codes, typeface names, spacing scale, logo variants

3. Client presentation — guide-build/brand-guide.pdf
   └── The cumulative deliverable, generated from brand_guide.py at consolidation
       Sections: Colours · Typography · Spacing · Logos · Icons

4. Implementation — src/07-COMPONENTS/ + Django design token system
   └── The component set built from the decision records
       Tokens fed into the design-token admin area → CSS variables → frontend stylesheet
```

## Key concepts

- Brand decisions feed directly into the DB-driven design token system
  (colours, typography, spacing stored via the design-token admin area → CSS custom properties → frontend stylesheet)
- Breakpoints are build-time only and are not DB-driven
- A brand guide change that alters existing tokens requires a token migration plan
- `guide-build/brand-guide.pdf` is client-facing — keep it clean and presentation-ready
- The markdown files in `src/06-BRAND-GUIDE/` are the internal specification Claude reads
  when building the component set in `src/07-COMPONENTS/`

## Cross-references

### Governing documents

None — brand guide work is a design phase; no code safety gates apply.

### Related reading

- `code/docs/RESPONSIVE-DESIGN.md` — device data, mobile-first design principles,
  and logo variant requirements; read before defining any brand assets
- `code/docs/ACCESSIBILITY.md` — colour contrast (WCAG AA 4.5:1), typography legibility, and focus indicator requirements
- `code/docs/DESIGN-TOKENS.md` — DB-driven token system that brand decisions feed into
- `project-management/src/06-BRAND-GUIDE/` — finalised brand decision records (markdown)
- `project-management/workflows/07-component-designs/` — follow this after brand guides are agreed
- `code/src/django/` — CSS custom properties from the token system will be consumed in the token-driven vanilla CSS of the Django templates and django-components
