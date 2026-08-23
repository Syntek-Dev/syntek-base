# project-management/src/06-BRAND-GUIDE/CONSOLIDATED-IDEAS

**Stage 2** — the decided token set. Written by `workflows/18-consolidate-design-work/` once
every story has been planned, weighing all the per-story asks in `../USER-STORY-IDEAS/` together
and settling the palette, type scale, spacing, logo rules, and voice that actually ship.

This is also the stage that **re-runs `../guide-build/brand_guide.py`** — the one time the
deliverable PDF is regenerated in a planning cycle.

## Directory Tree

```text
project-management/src/06-BRAND-GUIDE/CONSOLIDATED-IDEAS/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── BRAND-CONSOLIDATED-000-TEMPLATE.md  ← copy this to consolidate a token domain
└── BRAND-CONSOLIDATED-<DOMAIN>.md      ← one per domain, or one for the whole set
```

**Naming:** `BRAND-CONSOLIDATED-<DOMAIN>.md` — `<DOMAIN>` ∈ `COLOUR`, `TYPOGRAPHY`, `SPACING`,
`LOGO`, `VOICE`. A small project may consolidate the whole set in one document.

## What it holds

The canonical token set per domain, and a **resolution log**: every near-duplicate, redundant,
and rejected ask across the stage-1 records, with the value chosen and the reason.

## The decision the stories could not make

A story asking for a fourth grey is being reasonable in isolation. Only here, with all the asks
side by side, is it visible that three of the four are within 2% of each other and one token
serves all of them. That judgement is the entire point of this stage — and it cannot be made
earlier, because the information does not exist until every story has asked.

Rejecting an ask is normal. Record which story asked and why the answer was no, so the next
cycle does not re-litigate it.

## Accessibility is a gate here

A consolidated palette that fails WCAG AA 4.5:1 on any stated pairing is not consolidated. Fix
the value, do not note it as a known issue.

## When to write one

- During `workflows/18-consolidate-design-work/`, after every story has cleared `17-story-plans`
- Never mid-cycle — regenerating the PDF twice in a cycle means the first run decided nothing

## Cross-references

- `BRAND-CONSOLIDATED-000-TEMPLATE.md` — the consolidation template
- `../USER-STORY-IDEAS/` — the frozen per-story asks this weighs
- `../guide-build/` — regenerated from the decisions recorded here
- `../../07-COMPONENTS/CONSOLIDATED-IDEAS/` — shares this palette; consolidate the two together
- `code/docs/DESIGN-TOKENS.md` — where the decided values become DB-canonical
- `code/docs/ACCESSIBILITY.md` — the contrast gate

**Last Updated**: <%DATE%>
