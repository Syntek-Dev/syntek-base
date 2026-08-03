# project-management/src/04-DATABASE/USER-STORY-IDEAS

**Stage 1** — per-story schema design. One document per user story, written during that story's
pass through `workflows/04-database-schema/`, covering only the tables and columns **that story**
needs.

## Directory Tree

```text
project-management/src/04-DATABASE/USER-STORY-IDEAS/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for this folder
├── DB-IDEA-US000-TEMPLATE.md      ← copy this to design a story's schema
└── DB-IDEA-US###-<DESCRIPTOR>.md  ← one design per story that touches the schema
```

**Naming:** `DB-IDEA-US###-<DESCRIPTOR>.md` — story number zero-padded to three digits,
descriptor in `SCREAMING-KEBAB-CASE`.

## What it holds

The full schema-design scaffold, scoped to one story: scope and sources, key decisions,
conventions, tables, cross-app FKs, PII classification, RLS scoping, IDOR notes, index strategy,
migration strategy, and the Mermaid ERD. Full shape: `DB-IDEA-US000-TEMPLATE.md`.

## Design for the story, not the system

This is the deliberate half of the two-stage model. Design what **this story** needs, using what
earlier stories already settled — do not try to anticipate the whole schema, and do not
retro-fit an earlier story's design to match yours.

Where you notice a collision with an earlier story's design, **note it in the document** rather
than resolving it here. Those notes are the input `17-consolidate-design-work` works from, and a
collision flagged at design time is far cheaper to resolve than one discovered during
consolidation.

## Frozen at consolidation

Once `17-consolidate-design-work` runs, every file here is **frozen** — never edited again. It
is the record of what each story asked for and why, and the evidence when a consolidated
decision is questioned later. The unified schema lives in `../CONSOLIDATED-IDEAS/`.

## When to write one

- During a story's pass through `workflows/04-database-schema/`
- Before that story reaches `14-decisions`
- A story that touches no schema needs no file here — record `N/A` in its story plan instead

## Cross-references

- `DB-IDEA-US000-TEMPLATE.md` — the per-story design template
- `../CONSOLIDATED-IDEAS/` — where these are reconciled into one schema
- `../CONTEXT.md` — the folder overview and the three stages
- `../../02-STORIES/` — the stories these designs serve
- `code/docs/DATABASE.md` — the data-layer rules every design must satisfy
- `project-management/workflows/04-database-schema/` — the workflow that produces these

**Last Updated**: <%DATE%>
