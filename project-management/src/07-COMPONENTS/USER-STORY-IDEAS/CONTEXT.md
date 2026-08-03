# project-management/src/07-COMPONENTS/USER-STORY-IDEAS

**Stage 1** — per-story component needs. One short record per user story, written during that
story's pass through `workflows/07-component-designs/`, stating which components the story
**reuses** and which (if any) it needs that do not exist yet.

## Directory Tree

```text
project-management/src/07-COMPONENTS/USER-STORY-IDEAS/
├── CONTEXT.md                         ← this file
├── CLAUDE.md                          ← operating rules for this folder
├── COMP-IDEA-US000-TEMPLATE.md        ← copy this to record a story's component needs
└── COMP-IDEA-US###-<DESCRIPTOR>.md    ← one record per story
```

**Naming:** `COMP-IDEA-US###-<DESCRIPTOR>.md` — story number zero-padded, descriptor in
`SCREAMING-KEBAB-CASE`.

## Check the library first

Before proposing anything, look in `code/src/django/components/` and in
`../CONSOLIDATED-IDEAS/`. A token override on an existing component beats a new component, and
most stories genuinely need nothing new.

## Describe the need, not the solution

When a story does need something new, describe **what it must do** — the states it needs, the
content it holds, where it appears — rather than designing the final component. Two stories
describing needs can be recognised as one component at consolidation; two stories that each
designed a finished component cannot, because the differences look deliberate.

Where you notice an earlier story's record describing something similar, **note it**. Do not
merge them here — `17-consolidate-design-work` decides that with every story's needs in view.

**Do not edit `../component-build/`.** The generator is re-run once, at consolidation.

## Frozen at consolidation

Once `17-consolidate-design-work` runs, every file here is frozen. The decided component set
lives in `../CONSOLIDATED-IDEAS/`.

## Cross-references

- `COMP-IDEA-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — where these needs are merged and decided
- `../component-build/` — the cumulative deliverable, regenerated at consolidation
- `code/src/django/components/` — check here before proposing a new component
- `code/docs/ACCESSIBILITY.md` — the WCAG 2.2 AA obligations every component carries

**Last Updated**: <%DATE%>
