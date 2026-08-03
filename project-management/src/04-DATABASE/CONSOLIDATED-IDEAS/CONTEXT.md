# project-management/src/04-DATABASE/CONSOLIDATED-IDEAS

**Stage 2** — the unified schema. One document per domain, written by
`workflows/17-consolidate-design-work/` once every story has been planned, reconciling the
per-story designs in `../USER-STORY-IDEAS/` into the schema that actually gets built.

## Directory Tree

```text
project-management/src/04-DATABASE/CONSOLIDATED-IDEAS/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── DB-CONSOLIDATED-000-TEMPLATE.md   ← copy this to consolidate a domain
└── DB-CONSOLIDATED-<DOMAIN>.md       ← one document per schema domain
```

**Naming:** `DB-CONSOLIDATED-<DOMAIN>.md` — `<DOMAIN>` in `SCREAMING-KEBAB-CASE`
(e.g. `DB-CONSOLIDATED-IDENTITY-AND-AUDIT.md`). No `US###`: a consolidated document spans
stories by definition.

## What it holds

Per domain: the canonical tables and columns, every FK with its delete behaviour, the PII
classification, the RLS scope columns with their policies and indexes, the index strategy, and
the lock-safe migration order. Plus — and this is the part that makes it a _consolidation_ —
a **resolution log**: every duplicate, divergence, orphan, and contradiction found across the
stage-1 designs, the canonical form chosen, the alternative rejected, and why.

Full shape: `DB-CONSOLIDATED-000-TEMPLATE.md`.

## This is what gets built

A migration written from a `../USER-STORY-IDEAS/` design rather than from here reintroduces
exactly the fragmentation consolidation removed. Workflow `18-backend-code` reads this folder.

## Resolutions that are hard to reverse become ADRs

Where a consolidation choice is hard to undo, or a later decision would need to explicitly
supersede it, it is raised as an `ADR-###` in `../../14-DECISIONS/` and cited from here rather
than buried in the resolution log.

## When to write one

- During `workflows/17-consolidate-design-work/`, after every story has cleared `16-story-plans`
- Never mid-cycle with stories still to plan — the second pass invalidates the first

## Cross-references

- `DB-CONSOLIDATED-000-TEMPLATE.md` — the per-domain consolidation template
- `../USER-STORY-IDEAS/` — the frozen stage-1 designs this reconciles
- `../IMPLEMENTATION/` — the per-story records of what was actually built from this
- `../../14-DECISIONS/` — where a hard-to-reverse resolution is recorded
- `../../16-STORY-PLANS/` — plans that may need correcting when this changes a shape
- `code/docs/DATABASE.md` — constraints, scope columns, lock-safe migration shape
- `project-management/workflows/17-consolidate-design-work/` — the workflow that produces these

**Last Updated**: <%DATE%>
