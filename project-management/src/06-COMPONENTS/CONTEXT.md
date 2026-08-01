# project-management/src/06-COMPONENTS

The component library. The deliverable is a **PDF** generated from a Python script that renders
an indicative set of UI components — enough to give a client a feel for the interface — using
the same token palette as the brand guide, typeset with LaTeX/tcolorbox.

## Directory Tree

```text
project-management/src/06-COMPONENTS/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
└── component-build/         ← the component-library build (generator + partials + outputs)
    ├── CONTEXT.md
    ├── CLAUDE.md
    ├── components.py        ← palette + preamble/macros + assembly + CLI
    ├── section-*.tex        ← editable component section partials (buttons, forms, …)
    ├── components.tex       ← GENERATED — do not hand-edit
    └── components.pdf       ← GENERATED — the deliverable component sheet
```

## What the sheet covers

The generated PDF shows, as visual pages: a cover, an overview, then **buttons** (variants /
sizes / states), **form controls** (inputs, selection, toggles), **badges & alerts**, **cards**,
**navigation** (navbar, tabs, breadcrumb, pagination), and **avatars & feedback** (progress,
skeleton, tooltip). The set is **indicative, not a production kit** — its purpose is to convey
look and feel. The base template ships a **generic placeholder brand** sharing the brand guide's
palette; a new project fills in its own tokens in `component-build/components.py` and re-runs.

## Authoring / updating the sheet

Edit the palette in `component-build/components.py`, or a `section-<name>.tex` partial, then run
`python3 components.py` (see `component-build/CONTEXT.md`). Never hand-edit the generated
`.tex`/`.pdf`. Commit the `.py`, the `section-*.tex`, the `.tex`, and the `.pdf` together.

## Cross-references

- `component-build/CONTEXT.md` — the build layout, run commands, and requirements
- `project-management/src/05-BRAND-GUIDE/` — the brand guide, which shares the token palette
- `code/docs/DESIGN-TOKENS.md` — the code-side, DB-canonical design-token system
- `project-management/workflows/06-component-designs/` — the component-design workflow

**Last Updated**: {{DATE}}
