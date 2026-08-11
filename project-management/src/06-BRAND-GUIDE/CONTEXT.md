# project-management/src/06-BRAND-GUIDE

The brand guidelines, in **three stages** over one cumulative deliverable. Each story records
the tokens it needs (`USER-STORY-IDEAS/`); once every story is planned,
`17-consolidate-design-work` reconciles them into one token set (`CONSOLIDATED-IDEAS/`) and
re-runs the generator; after the code ships, each story records what actually landed in the
token layer (`IMPLEMENTATION/`).

The **PDF stays one document**. `guide-build/` is the cumulative deliverable, regenerated at
consolidation — there is no per-story brand guide.

## Directory Tree

```text
project-management/src/06-BRAND-GUIDE/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── USER-STORY-IDEAS/        ← stage 1: per-story token needs (workflow 06)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── BRAND-IDEA-US000-TEMPLATE.md
│   └── BRAND-IDEA-US###-<DESCRIPTOR>.md
├── CONSOLIDATED-IDEAS/      ← stage 2: the unified token set (workflow 17)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── BRAND-CONSOLIDATED-000-TEMPLATE.md
│   └── BRAND-CONSOLIDATED-<DOMAIN>.md
├── IMPLEMENTATION/          ← stage 3: tokens as shipped, per story (workflow 21)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── BRAND-IMPL-US000-TEMPLATE.md
│   └── BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── guide-build/             ← the cumulative deliverable — one PDF for the project
    ├── CONTEXT.md · CLAUDE.md
    ├── brand_guide.py       ← SOURCE OF TRUTH — brand tokens + the LaTeX renderer
    ├── brand-guide.tex      ← GENERATED — do not hand-edit
    └── brand-guide.pdf      ← GENERATED — the deliverable brand guide
```

## Why three stages over one deliverable

A story needs a colour, a weight, a spacing step — and asks for it in isolation. Five stories
later there are three greys that differ by 2%, two "danger" reds, and a spacing scale with gaps.
Nobody chose that; it accumulated.

Stage 1 captures each story's ask honestly, without pretending the story can see the whole
system. Stage 2 is where somebody looks at all of it at once, decides the real palette and
scale, and re-runs `brand_guide.py` so the deliverable reflects it. **Most stage-1 records
should read "reused existing"** — that is the healthy outcome, and the ones that do not are the
signal worth acting on.

## The three stages

| Stage                 | Written by  | Scope     | Naming                                        |
| --------------------- | ----------- | --------- | --------------------------------------------- |
| `USER-STORY-IDEAS/`   | workflow 06 | one story | `BRAND-IDEA-US###-<DESCRIPTOR>.md`            |
| `CONSOLIDATED-IDEAS/` | workflow 17 | a domain  | `BRAND-CONSOLIDATED-<DOMAIN>.md`              |
| `IMPLEMENTATION/`     | workflow 21 | one story | `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` |

`<DOMAIN>` ∈ `COLOUR`, `TYPOGRAPHY`, `SPACING`, `LOGO`, `VOICE` — or the whole set in one
document on a small project. **Stage 1 is frozen once stage 2 runs.**

## Cross-references

- `USER-STORY-IDEAS/CONTEXT.md` · `CONSOLIDATED-IDEAS/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md`
- `guide-build/CONTEXT.md` — the build layout, run commands, and requirements
- `../07-COMPONENTS/` — shares this palette; the two must stay in step
- `../00-ASSETS/LOGOS/` — the logo sources the guide's rules point at
- `code/docs/DESIGN-TOKENS.md` — the code-side, DB-canonical token system
- `code/docs/ACCESSIBILITY.md` — contrast and legibility the palette must satisfy
- `project-management/workflows/06-brand-guides/` — produces stage 1
- `project-management/workflows/17-consolidate-design-work/` — produces stage 2

**Last Updated**: <%DATE%>
