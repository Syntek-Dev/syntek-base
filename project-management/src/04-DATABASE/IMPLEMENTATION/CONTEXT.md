# project-management/src/04-DATABASE/IMPLEMENTATION

**Stage 3** — what actually shipped. One record per user story, written during
`workflows/22-implementation-documentation/`, confirming with code evidence that the story's
migrations match the consolidated schema in `../CONSOLIDATED-IDEAS/`.

## Directory Tree

```text
project-management/src/04-DATABASE/IMPLEMENTATION/
├── CONTEXT.md                                 ← this file
├── CLAUDE.md                                  ← operating rules for this folder
├── DB-IMPL-US000-TEMPLATE.md                  ← copy this to record a story's schema build
└── DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md   ← one record per story that shipped schema
```

**Naming:** `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Reuse the descriptor from the story's
stage-1 design where one exists.

## What it holds

Per story: the migrations that shipped, each consolidated table and column marked
Present / Changed / Missing with the migration file as evidence, the constraints and indexes as
actually created, PII encryption verified, RLS policy and index confirmed present, and any
justified deviation from the consolidated schema.

## Deviation is the signal

A record that matches the consolidated schema exactly is unremarkable. A record with a deviation
is the interesting one — it means either the consolidation was wrong or the build was, and
saying which is the point of writing this down. An unexplained deviation is a defect, not a
footnote.

## Cross-references

- `DB-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — the schema these records verify the build against
- `../USER-STORY-IDEAS/` — the frozen stage-1 design, for tracing intent
- `../CONTEXT.md` — the folder overview and the three stages
- `../../20-FINDINGS/` — where a divergence worth carrying forward is recorded
- `code/docs/DATABASE.md` — the rules the shipped schema must satisfy
- `project-management/workflows/22-implementation-documentation/` — where these are written

**Last Updated**: <%DATE%>
