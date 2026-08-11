# project-management/src/04-DATABASE

Database design, in **three stages**. Each story designs the schema it needs
(`USER-STORY-IDEAS/`); once every story is planned, `17-consolidate-design-work` reconciles
those into one schema (`CONSOLIDATED-IDEAS/`); after the code ships, each story records what
was actually built (`IMPLEMENTATION/`). Rendered ERDs live in `ERD-DIAGRAMS/`.

## Directory Tree

```text
project-management/src/04-DATABASE/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── USER-STORY-IDEAS/        ← stage 1: per-story schema design (workflow 04)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── DB-IDEA-US000-TEMPLATE.md
│   └── DB-IDEA-US###-<DESCRIPTOR>.md
├── CONSOLIDATED-IDEAS/      ← stage 2: the unified schema (workflow 17)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── DB-CONSOLIDATED-000-TEMPLATE.md
│   └── DB-CONSOLIDATED-<DOMAIN>.md
├── IMPLEMENTATION/          ← stage 3: what shipped, per story (workflow 21)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── DB-IMPL-US000-TEMPLATE.md
│   └── DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── ERD-DIAGRAMS/            ← rendered ERD images — cumulative, spans all stages
    ├── CONTEXT.md · CLAUDE.md
    └── erd-<domain>.png
```

## Why three stages

Stories are planned **one at a time** through workflows `01`–`13`, so each story designs the
tables it needs without waiting for the rest of the backlog. That compounds well — story 7 is
designed against six stories' worth of settled schema — but it guarantees drift: two stories
will model the same entity differently, or each add a `created_by` with a different delete
behaviour.

`17-consolidate-design-work` is the second half of that bargain: it reconciles the per-story
designs into one schema before any migration is written. **Schema is the expensive kind of
drift** — a fragmented schema gets costlier with every story that ships on top of it, unlike a
duplicated button — which is why `16` resolves this folder first.

## The three stages

| Stage                 | Written by  | Scope     | Naming                                     |
| --------------------- | ----------- | --------- | ------------------------------------------ |
| `USER-STORY-IDEAS/`   | workflow 04 | one story | `DB-IDEA-US###-<DESCRIPTOR>.md`            |
| `CONSOLIDATED-IDEAS/` | workflow 17 | a domain  | `DB-CONSOLIDATED-<DOMAIN>.md`              |
| `IMPLEMENTATION/`     | workflow 21 | one story | `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` |

Descriptors in `SCREAMING-KEBAB-CASE`; `<DOMAIN>` kebab-case; dates DD/MM/YYYY.

**Stage 1 is frozen once stage 2 runs** — never rewritten. It records what each story asked for
and why, which is the evidence when a consolidated decision is later questioned.

## Cross-references

- `USER-STORY-IDEAS/CONTEXT.md` · `CONSOLIDATED-IDEAS/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md`
- `code/docs/DATABASE.md` — the data-layer rules every stage must satisfy
- `code/docs/DATA-STRUCTURES.md` — naming, indexing, and modelling conventions
- `code/docs/RLS-GUIDE.md` — row-level security policy conventions
- `code/docs/ENCRYPTION-GUIDE.md` — field-level PII encryption pipeline
- `project-management/workflows/04-database-schema/` — produces stage 1
- `project-management/workflows/17-consolidate-design-work/` — produces stage 2

**Last Updated**: <%DATE%>
