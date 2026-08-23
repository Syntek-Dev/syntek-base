# project-management/src/05-USER-FLOW/USER-STORY-IDEAS

**Stage 1** — per-story flow fragments. One document per user story, written during that story's
pass through `workflows/05-user-flow-design/`, mapping only the journey slice **that story**
introduces or changes.

## Directory Tree

```text
project-management/src/05-USER-FLOW/USER-STORY-IDEAS/
├── CONTEXT.md                             ← this file
├── CLAUDE.md                              ← operating rules for this folder
├── USER-FLOW-IDEA-US000-TEMPLATE.md       ← copy this to map a story's flow
└── USER-FLOW-IDEA-US###-<DESCRIPTOR>.md   ← one fragment per story with a journey
```

**Naming:** `USER-FLOW-IDEA-US###-<DESCRIPTOR>.md` — story number zero-padded, descriptor in
`SCREAMING-KEBAB-CASE`.

## Map the slice, not the journey

A story owns part of a journey. Map the screens, decision points, transitions, and data
touchpoints **this story** introduces — using what earlier stories already mapped, without
extending your fragment to cover ground they own.

Where your slice hands off to, or picks up from, another story's, **note the seam** rather than
absorbing it. Those notes are what `18-consolidate-design-work` stitches from, and a seam
flagged at design time is far cheaper than a discontinuity found during consolidation.

Every decision node still resolves **both** outcomes within your slice — a fragment with a
dangling failure path is incomplete, not deferred.

## Frozen at consolidation

Once `18-consolidate-design-work` runs, every file here is frozen. The whole journeys live in
`../CONSOLIDATED-IDEAS/`.

## When to write one

- During a story's pass through `workflows/05-user-flow-design/`, before it reaches `15-decisions`
- A story that introduces no user-facing journey needs no file here

## Cross-references

- `USER-FLOW-IDEA-US000-TEMPLATE.md` — the per-story fragment template
- `../CONSOLIDATED-IDEAS/` — where fragments are stitched into whole journeys
- `../CONTEXT.md` — the folder overview and the three stages
- `../../02-STORIES/` — the stories these fragments serve
- `project-management/workflows/05-user-flow-design/` — the workflow that produces these

**Last Updated**: <%DATE%>
