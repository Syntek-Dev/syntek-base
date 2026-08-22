# project-management/src/07-COMPONENTS

The component library, in **three stages** over one cumulative deliverable. Each story records
the components it needs (`USER-STORY-IDEAS/`); once every story is planned,
`18-consolidate-design-work` merges the duplicates into one component set
(`CONSOLIDATED-IDEAS/`) and re-runs the generator; after the code ships, each story records what
actually landed in the django-components library (`IMPLEMENTATION/`).

The **PDF stays one document**. `component-build/` is the cumulative deliverable, regenerated at
consolidation — there is no per-story component sheet.

## Directory Tree

```text
project-management/src/07-COMPONENTS/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── USER-STORY-IDEAS/        ← stage 1: per-story component needs (workflow 07)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── COMP-IDEA-US000-TEMPLATE.md
│   └── COMP-IDEA-US###-<DESCRIPTOR>.md
├── CONSOLIDATED-IDEAS/      ← stage 2: the unified component set (workflow 18)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── COMP-CONSOLIDATED-000-TEMPLATE.md
│   └── COMP-CONSOLIDATED-<FAMILY>.md
├── IMPLEMENTATION/          ← stage 3: components as shipped, per story (workflow 22)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── COMP-IMPL-US000-TEMPLATE.md
│   └── COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── component-build/         ← the cumulative deliverable — one PDF for the project
    ├── CONTEXT.md · CLAUDE.md
    ├── components.py        ← palette + macros + assembly + CLI
    ├── section-*.tex        ← editable component section partials
    ├── components.tex       ← GENERATED — do not hand-edit
    └── components.pdf       ← GENERATED — the deliverable component sheet
```

## Why three stages over one deliverable

Two stories, planned weeks apart, both need "a small pill showing state". Neither is wrong;
neither can see the other. Left alone that ships as two components with different padding, two
sets of states, and two places to fix a bug.

Stage 1 lets each story state its need honestly. Stage 2 is where somebody sees one story's status
badge and another's tag chip side by side and decides they are one component with two variants.
**Most stage-1 records should read "reused existing"** — the ones proposing something new are
the signal.

## The three stages

| Stage                 | Written by  | Scope      | Naming                                       |
| --------------------- | ----------- | ---------- | -------------------------------------------- |
| `USER-STORY-IDEAS/`   | workflow 07 | one story  | `COMP-IDEA-US###-<DESCRIPTOR>.md`            |
| `CONSOLIDATED-IDEAS/` | workflow 18 | one family | `COMP-CONSOLIDATED-<FAMILY>.md`              |
| `IMPLEMENTATION/`     | workflow 22 | one story  | `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` |

`<FAMILY>` ∈ `BUTTONS`, `FORMS`, `BADGES`, `ALERTS`, `CARDS`, `NAVIGATION`, `FEEDBACK` — matching
the `component-build/section-*.tex` partials. **Stage 1 is frozen once stage 2 runs.**

## Cross-references

- `USER-STORY-IDEAS/CONTEXT.md` · `CONSOLIDATED-IDEAS/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md`
- `component-build/CONTEXT.md` — the build layout, run commands, and requirements
- `../06-BRAND-GUIDE/` — shares this palette
- `../08-WIREFRAMES/` — the screens built from these components
- `code/src/django/components/` — where implemented components live
- `code/docs/DESIGN-TOKENS.md` · `code/docs/ACCESSIBILITY.md`
- `project-management/workflows/07-component-designs/` — produces stage 1
- `project-management/workflows/18-consolidate-design-work/` — produces stage 2

**Last Updated**: <%DATE%>
