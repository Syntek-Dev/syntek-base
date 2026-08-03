# project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS

**Stage 2** — the screen set that gets built. Written by `workflows/17-consolidate-design-work/`
once every story has been planned: the per-story screens in `../USER-STORY-IDEAS/` rebuilt on
the consolidated components, plus a record of what was reconciled.

## Directory Tree

```text
project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── WF-CONSOLIDATED-000-TEMPLATE.md     ← copy this to record an area's reconciliation
├── WF-CONSOLIDATED-<AREA>.md           ← the merge record, one per area
├── WF-###-<Screen-Name>.html           ← the screens a developer builds from
└── WF-###-MOBILE-<Screen-Name>.html    ← mobile screens, sharing their counterpart's number
```

**Naming:** screens take the plain `WF-###-<Screen-Name>.html` form — the stage-1 `IDEA` marker
and story number drop away, because a consolidated screen belongs to the product, not a story.

## Rebuilt, not merged

These are not stage-1 files with the differences edited out. Each screen is **rebuilt** on the
consolidated component set from `../../07-COMPONENTS/CONSOLIDATED-IDEAS/`, against the
consolidated journey from `../../05-USER-FLOW/CONSOLIDATED-IDEAS/`.

That distinction matters. Patching two stories' screens to look similar leaves both carrying
their original assumptions; rebuilding both on the decided components makes them consistent by
construction — and surfaces the screens that turn out to be the same screen.

## What the merge record holds

Per area: which stage-1 screens fed it, which turned out to be duplicates, which components
replaced a story's bespoke element, and any screen dropped or added. Plus the breakpoint check
and the accessibility pass over the rebuilt set.

## When to write one

- During `workflows/17-consolidate-design-work/`, **after** components and flows are consolidated
  — this stage depends on both
- Never mid-cycle with stories still to plan

## Cross-references

- `WF-CONSOLIDATED-000-TEMPLATE.md` — the per-area merge record template
- `../USER-STORY-IDEAS/` — the frozen per-story screens this rebuilds from
- `../SHARED/` — the stylesheet these screens link
- `../../07-COMPONENTS/CONSOLIDATED-IDEAS/` — the components these are rebuilt on
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — the journeys these screens realise
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA over the rebuilt set

**Last Updated**: <%DATE%>
