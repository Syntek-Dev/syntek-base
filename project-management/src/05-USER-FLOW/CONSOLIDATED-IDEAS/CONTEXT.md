# project-management/src/05-USER-FLOW/CONSOLIDATED-IDEAS

**Stage 2** — whole journeys. One document per interaction **area**, written by
`workflows/18-consolidate-design-work/` once every story has been planned, stitching the
per-story fragments in `../USER-STORY-IDEAS/` into the journey that wireframes and code follow.

## Directory Tree

```text
project-management/src/05-USER-FLOW/CONSOLIDATED-IDEAS/
├── CONTEXT.md                            ← this file
├── CLAUDE.md                             ← operating rules for this folder
├── USER-FLOW-CONSOLIDATED-000-TEMPLATE.md ← copy this to consolidate an area
└── USER-FLOW-CONSOLIDATED-<AREA>.md      ← one document per interaction area
```

**Naming:** `USER-FLOW-CONSOLIDATED-<AREA>.md` — `<AREA>` in `SCREAMING-KEBAB-CASE`
(e.g. `USER-FLOW-CONSOLIDATED-SIGN-UP.md`). No `US###`: a journey spans stories by definition.

## What it holds

The end-to-end journey for one area: every screen, decision node, and transition in sequence,
with both outcomes resolved at every node **across the whole journey**. Plus a **seam log** —
each handoff between story fragments, and whether it joined cleanly, left a gap, or contradicted
another fragment.

## The gaps are the point

A story maps its own slice and stops. Consolidation finds the state one story leaves the user in
that no other story picks up — the verification email nobody handles bouncing, the consent
refusal with no path onward. Those are not edge cases; they are whole missing journeys, and they
surface here or in production.

A gap that needs new capability becomes a **new user story** through `02-story-creation/`, never
a quiet addition here.

## When to write one

- During `workflows/18-consolidate-design-work/`, after every story has cleared `17-story-plans`
- Never mid-cycle with stories still to plan

## Cross-references

- `USER-FLOW-CONSOLIDATED-000-TEMPLATE.md` — the per-area consolidation template
- `../USER-STORY-IDEAS/` — the frozen fragments this stitches
- `../IMPLEMENTATION/` — the per-story records of what was built from this
- `../../08-WIREFRAMES/CONSOLIDATED-IDEAS/` — the screens that realise these journeys
- `../../09-GDPR/` — where data touchpoints get a lawful basis
- `../../17-STORY-PLANS/` — plans that may need correcting when a journey changes
- `project-management/workflows/18-consolidate-design-work/` — the workflow that produces these

**Last Updated**: <%DATE%>
