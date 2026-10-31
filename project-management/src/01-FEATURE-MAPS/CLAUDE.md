@./CONTEXT.md

# CLAUDE.md — src/01-FEATURE-MAPS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what a map holds, the index, the not-finished rule — imported above) → this file.

## Purpose (one line)

The feature decision maps — one `MAP-<FEATURE>.md` per feature, charting its decision frontier
and recording each node as it is settled; the foundation every later planning gate reads.

## How to work here

- **Routing:** never author here free-hand — maps come from `workflows/01-feature-map/` via the
  `planner` skill loading `.claude/skills/wayfinder/SKILL.md`. CHART writes the map; RESOLVE
  updates it one node per session.
- **Model:** Opus throughout — charting a frontier and settling trade-offs is substantive
  judgement; moving a resolved row, fixing a link, or updating the index is a mechanical touch.
- **Concrete steps:** copy `MAP-000-TEMPLATE.md` → `MAP-<FEATURE>.md` → fill destination, notes,
  frontier (typed and blocker-wired), fog of war, out of scope → set `**Status:** Charting` and
  a `**Status note:**` → `bash project-management/src/00-ASSETS/scripts/pm-board.sh --write` →
  on each RESOLVE session, move the settled node to Resolved decisions with a link to what it
  became, redraw the frontier, advance the status (`Resolving` → `Blockers Clear` → `Complete`)
  and regenerate the board. Once `Complete` with every slice cut, `pm-archive.sh MAP-<FEATURE>`
  closes and archives it.
- **Definition of done:** destination and bounds confirmed; every node typed and wired; every
  resolved node links to its artefact; the status line current and the board regenerated;
  British English; DD/MM/YYYY.

## Guardrails

- **Index, not vault.** A node's reasoning lives in the ADR, plan, or story it graduates to. A
  map that grows the detail becomes the document nobody reads, which defeats its only purpose.
- **Every resolved node graduates.** An answer left only here dies with the map. It belongs in
  `../15-DECISIONS/`, a plan, a story, `GAPS.md`, or `DEFERRED.md`.
- **Register claimed is a claim, never a close.** A map records which `GAPS.md` / `DEFERRED.md`
  entries the feature will retire, so the intent survives into the stories cut from it. Marking
  `✅ CLOSED` or deleting a `DEFERRED.md` row is `workflows/22-implementation-documentation/`'s,
  against shipped code — never done from a map.
- **Fog of war stays honest.** Do not promote something to a node to make the map look complete —
  a decision node with nothing behind it produces a decision made on nothing.
- **Do not settle nodes during charting.** CHART draws the frontier; RESOLVE settles it. Mixing
  them biases the map towards whatever was easiest to answer in the moment.
- **The map is not a story list.** Stories are cut in `workflows/02-story-creation/` from the
  resolved map; a story written here bypasses its own gate.
- **Blocking nodes gate stories; the rest do not.** Requiring a fully-resolved map before writing
  a story means never writing one.
- **Status is one of five words, and `Closed` is never typed.** `Charting` · `Resolving` ·
  `Blockers Clear` · `Complete` · `Closed`, colon inside the bold, owned by the `completion`
  skill; only `pm-archive.sh` sets `Closed`.
- **`archive/` is frozen.** A closed map is never edited (`pm-board.sh --check` fails on it, bar
  the archive rename and `pm-archive.sh`'s reference rewrites); new work makes a new map. Look a
  map up by name across this folder and `archive/`.
- **Documentation only** — no code, secrets, or `.env` content.
- Root-level artefacts under `src/` are exempt from the 300-line limit; `CONTEXT.md` and this
  file are not.

## Output & naming

- **Hand-written:** every `MAP-<FEATURE>.md`.
- **Template:** `MAP-000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** `FEATURE-MAPS-BOARD.md` (committed) and `feature-maps-board.json` / `.html`
  (gitignored), by `pm-board.sh --write` — never hand-edit. `archive/` is written only by
  `pm-archive.sh`.
- Maps `MAP-<FEATURE>.md` (`SCREAMING-KEBAB-CASE`); nodes `N-###`; stories `US###`;
  decisions `ADR-###`; dates DD/MM/YYYY.
