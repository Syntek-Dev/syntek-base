# project-management/src/05-BRAND-GUIDE

The brand guidelines. The deliverable is a **PDF** generated from a Python script that holds
the brand tokens (colour, typography, spacing, logo rules, voice) as its source of truth and
typesets them with LaTeX — swatches, type specimens, and spacing bars drawn from the data.

## Directory Tree

```text
project-management/src/05-BRAND-GUIDE/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules for this folder
└── guide-build/            ← the brand-guide build (generator + generated outputs)
    ├── CONTEXT.md
    ├── CLAUDE.md
    ├── brand_guide.py      ← SOURCE OF TRUTH — brand tokens + rules, and the LaTeX renderer
    ├── brand-guide.tex     ← GENERATED — do not hand-edit
    └── brand-guide.pdf     ← GENERATED — the deliverable brand guide
```

## What the guide covers

The generated PDF has, as full visual pages: a cover, **colour** (brand / neutral / semantic
swatches), **typography** (families + type scale specimens), **spacing & radius**, **logo**
usage rules, and **voice & tone** — plus a **token appendix** (motion, elevation, dark mode,
icons) recorded as tables. The base template ships a **generic placeholder brand**; a new
project fills in its own tokens in `guide-build/brand_guide.py` and re-runs.

## Authoring / updating the guide

Edit the `INPUTS` in `guide-build/brand_guide.py`, then run `python3 brand_guide.py` (see
`guide-build/CONTEXT.md`). Never hand-edit the generated `.tex`/`.pdf`. Commit the `.py`,
`.tex`, and `.pdf` together.

## Cross-references

- `guide-build/CONTEXT.md` — the build layout, run commands, and requirements
- `project-management/src/00-ASSETS/LOGOS/` — logo source files the guide's logo rules point to
- `code/docs/DESIGN-TOKENS.md` — the code-side, DB-canonical design-token system
- `project-management/workflows/05-brand-guides/` — the brand-guide workflow (STEPS + CHECKLIST)

**Last Updated**: {{DATE}}
