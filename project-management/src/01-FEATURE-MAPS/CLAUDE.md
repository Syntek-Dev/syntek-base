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
- **Model:** Fable — charting a frontier and settling trade-offs is the reasoning tier
  everything downstream builds on. Opus only for moving a resolved row, fixing a link, or
  updating the index.
- **Concrete steps:** copy `MAP-000-TEMPLATE.md` → `MAP-<FEATURE>.md` → fill destination, notes,
  frontier (typed and blocker-wired), fog of war, out of scope → add the index row in
  `CONTEXT.md` → on each RESOLVE session, move the settled node to Resolved decisions with a link
  to what it became, and redraw the frontier.
- **Definition of done:** destination and bounds confirmed; every node typed and wired; every
  resolved node links to its artefact; the index row current; British English; DD/MM/YYYY.

## Guardrails

- **Index, not vault.** A node's reasoning lives in the ADR, plan, or story it graduates to. A
  map that grows the detail becomes the document nobody reads, which defeats its only purpose.
- **Every resolved node graduates.** An answer left only here dies with the map. It belongs in
  `../14-DECISIONS/`, a plan, a story, `GAPS.md`, or `DEFERRED.md`.
- **Register claimed is a claim, never a close.** A map records which `GAPS.md` / `DEFERRED.md`
  entries the feature will retire, so the intent survives into the stories cut from it. Marking
  `✅ CLOSED` or deleting a `DEFERRED.md` row is `workflows/21-implementation-documentation/`'s,
  against shipped code — never done from a map.
- **Fog of war stays honest.** Do not promote something to a node to make the map look complete —
  a decision node with nothing behind it produces a decision made on nothing.
- **Do not settle nodes during charting.** CHART draws the frontier; RESOLVE settles it. Mixing
  them biases the map towards whatever was easiest to answer in the moment.
- **The map is not a story list.** Stories are cut in `workflows/02-story-creation/` from the
  resolved map; a story written here bypasses its own gate.
- **Blocking nodes gate stories; the rest do not.** Requiring a fully-resolved map before writing
  a story means never writing one.
- **Documentation only** — no code, secrets, or `.env` content.
- Root-level artefacts under `src/` are exempt from the 300-line limit; `CONTEXT.md` and this
  file are not.

## Output & naming

- **Hand-written:** every `MAP-<FEATURE>.md` and the index in `CONTEXT.md`.
- **Template:** `MAP-000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none.
- Maps `MAP-<FEATURE>.md` (`SCREAMING-KEBAB-CASE`); nodes `N-###`; stories `US###`;
  decisions `ADR-###`; dates DD/MM/YYYY.
