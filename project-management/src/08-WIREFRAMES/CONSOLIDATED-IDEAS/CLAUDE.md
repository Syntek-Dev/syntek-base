@./CONTEXT.md

# CLAUDE.md — src/08-WIREFRAMES/CONSOLIDATED-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/08-WIREFRAMES/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-2 scope, rebuilt-not-merged — imported above) → this file.

## Purpose (one line)

Stage-2 screen set — the per-story wireframes rebuilt on the consolidated components as
`WF-###-<Screen-Name>.html`, plus a `WF-CONSOLIDATED-<AREA>.md` record of what was reconciled.

## How to work here

- **Routing:** produced only by `workflows/17-consolidate-design-work/`, and only **after**
  `../../07-COMPONENTS/CONSOLIDATED-IDEAS/` and `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` are
  settled — this stage consumes both.
- **Model:** Fable for the rebuild and the reconciliation decisions; Opus for renames, copy
  fixes, and breakpoint checks.
- **Concrete steps:** inventory every `../USER-STORY-IDEAS/` screen → identify duplicates and
  near-duplicates → rebuild each surviving screen on the consolidated components, against the
  consolidated journey → record the merge log → open every screen at every declared breakpoint →
  run the accessibility pass.
- **Definition of done:** every stage-1 screen is rebuilt, merged into another, or recorded as
  dropped with a reason; no screen carries a bespoke element the component set now covers; every
  screen renders over `file://` at every breakpoint; British English.

## Guardrails

- **Rebuild, do not patch.** Editing a stage-1 screen until it looks close enough leaves its
  original assumptions in place. Compose it again from the consolidated components — that is
  what makes the set consistent by construction.
- **Order matters.** Components and flows consolidate first. Rebuilding screens on an undecided
  component set means doing it twice.
- **No bespoke elements survive.** A consolidated screen still carrying a story's one-off card
  or badge has not been consolidated — the component set covers it or the component set is wrong.
- **Never edit `../USER-STORY-IDEAS/`.** Stage 1 is frozen.
- **Self-contained only** — the sole dependency stays `../SHARED/wireframe.css`.
- **Token-first** — `--wf-*` variables and `wf-*` classes only.
- **Mobile screens must not rest intent on hover, scrollbars, or browser chrome.**
- **A screen change must correct any story plan that assumed the old layout.**
- **Consolidation never adds scope** — a screen nobody's story needed is a new `US###`.

## Output & naming

- **Hand-written:** the rebuilt screens and the merge records.
- **Template:** `WF-CONSOLIDATED-000-TEMPLATE.md` — the copy source; do not delete.
- **Generated:** none — screens are authored by hand.
- Screens `WF-###-<Screen-Name>.html` (no `IDEA` marker, no story number); mobile
  `WF-###-MOBILE-<Screen-Name>.html`; records `WF-CONSOLIDATED-<AREA>.md`; dates DD/MM/YYYY.
