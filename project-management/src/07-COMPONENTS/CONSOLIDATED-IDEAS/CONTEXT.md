# project-management/src/07-COMPONENTS/CONSOLIDATED-IDEAS

**Stage 2** — the decided component set. Written by `workflows/17-consolidate-design-work/` once
every story has been planned, merging the per-story needs in `../USER-STORY-IDEAS/` into one set
of components with variants, and re-running `../component-build/components.py`.

## Directory Tree

```text
project-management/src/07-COMPONENTS/CONSOLIDATED-IDEAS/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── COMP-CONSOLIDATED-000-TEMPLATE.md   ← copy this to consolidate a component family
└── COMP-CONSOLIDATED-<FAMILY>.md       ← one per family
```

**Naming:** `COMP-CONSOLIDATED-<FAMILY>.md` — `<FAMILY>` ∈ `BUTTONS`, `FORMS`, `BADGES`,
`ALERTS`, `CARDS`, `NAVIGATION`, `FEEDBACK`, matching the `../component-build/section-*.tex`
partials.

## What it holds

Per family: the canonical components with their variants and full state matrices, and a
**merge log** — every pair of per-story needs that turned out to be one component, every need
served by an existing component, and every genuinely new one, each with the reason.

## One component, several variants

The commonest outcome is not "these are duplicates, delete one" but "these are one component
with two variants". One story's status badge and another's tag chip become `Badge` with `status`
and `tag` variants — one implementation, one set of states, one place to fix a bug.

Deciding that requires seeing both needs at once, which is why it cannot happen at stage 1.

## Accessibility is a gate here

Every consolidated component carries its full state matrix **including focus**, its keyboard
interaction, and its announced role. WCAG 2.2 AA is not a later pass
(`code/docs/ACCESSIBILITY.md`) — a component whose focus state is undecided is not consolidated.

## When to write one

- During `workflows/17-consolidate-design-work/`, after every story has cleared `16-story-plans`
- Alongside `../../06-BRAND-GUIDE/CONSOLIDATED-IDEAS/` — they share a palette

## Cross-references

- `COMP-CONSOLIDATED-000-TEMPLATE.md` — the consolidation template
- `../USER-STORY-IDEAS/` — the frozen per-story needs this merges
- `../component-build/` — regenerated from the decisions recorded here
- `../../06-BRAND-GUIDE/CONSOLIDATED-IDEAS/` — the shared palette
- `../../08-WIREFRAMES/CONSOLIDATED-IDEAS/` — the screens rebuilt on this set
- `code/src/django/components/` — where these get implemented
- `code/docs/ACCESSIBILITY.md` — the WCAG 2.2 AA gate

**Last Updated**: <%DATE%>
