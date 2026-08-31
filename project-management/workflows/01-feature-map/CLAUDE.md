@./CONTEXT.md

# CLAUDE.md — workflows/01-feature-map/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, the two modes, the reading order — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The discovery gate — chart a feature's decision frontier with wayfinder and settle it node by
node, producing the resolved `MAP-<FEATURE>.md` that every later planning gate reads instead of
re-asking the same questions.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `planner` skill (Fable), loading
  `.claude/skills/wayfinder/SKILL.md`. Grilling nodes open `grill-with-docs`; research nodes use
  `research`; tracer nodes use `prototype`, which **any** node may also be probed with before it
  resolves. **Build nodes are specified onto their slice row and never performed here** — the work
  belongs to the story `02-story-creation` cuts. The hard gate — the wayfinder skill itself — must
  be read before Step 1.
- **Model:** Fable throughout — mapping a decision frontier and settling trade-offs is the
  reasoning tier the whole implementation builds on. Opus only for mechanical touches: a link
  fix, moving a resolved row, a date bump.
- **Concrete steps:** load the context in the documented order → CHART (pin the destination, map
  the frontier breadth-first, wire blocking edges, write the map with its **Slices** manifest,
  fire research nodes) → then RESOLVE a batch of related nodes per session until no blocker
  remains open → graduate every outcome to its real home → satisfy `CHECKLIST.md`.
- **Definition of done:** the destination and out-of-scope bounds are written and confirmed;
  every knowable decision is a node or honestly parked in fog of war; no blocking node remains
  unresolved; every resolved node links to the artefact it became.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Charting is one session and settles nothing but research nodes.** The temptation is to answer
  a node while it is in front of you. Do not — a frontier drawn and a frontier resolved are
  different acts, and mixing them produces a map shaped by whatever was easiest to answer first.
- **Facts up, decisions asked** — the `grilling` skill's rule, not restated here. `code-review-graph` → Read/Grep/Glob →
  `.claude/plugins/*.py` → `context7`. A question whose answer is in the repo is not a decision
  node, and asking it spends the one resource this workflow is protecting: <%DEVELOPER_NAME%>'s attention.
- **The map is an index, never a vault.** A node's detail lives in the ADR, plan, or story it
  graduates to. A map that accumulates the reasoning becomes the thing nobody reads.
- **Fog of war is honest, not embarrassing.** Something in scope but not yet sharp enough to
  state as a decision goes there. Forcing it into a node produces a decision made on nothing.
- **Do not write stories here.** A slice graduates to a **Slices** row carrying its flag
  manifest — never to `US###.md`, and never with a story number reserved. `02-story-creation`
  cuts the story and allocates the number. A story written during discovery bypasses its own gate.
- **Every resolved node graduates.** An answer left only on the map is lost the moment the map is
  superseded — it belongs in an ADR, a plan, a story, `GAPS.md`, or `DEFERRED.md`.
- **Read the register before charting, and triage all of it.** `GAPS.md` and `DEFERRED.md` are not
  write-only. Every open entry gets a verdict — closes / blocks / unrelated — because a feature
  charted without them re-decides what a past story already deferred, and silently leaves the debt
  it happens to retire unrecorded.
- **Claim, never close.** This workflow writes claimed entries onto the map; it does not mark
  `✅ CLOSED` or delete a `DEFERRED.md` row. That is
  `22-implementation-documentation`'s, against shipped code — editing the register here puts a gap
  in the closed state with nothing built behind it.
- **Step 0 suggests; it never chooses.** Candidates are put to <%DEVELOPER_NAME%> ranked, and nothing is
  written until one is picked. A candidate that is really one story routes to `02-story-creation`
  rather than being inflated into a map.
- Documentation workflow — no code. Instructional `.md` files ≤ 300 code lines (the map artefact
  itself is exempt).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the map `MAP-<FEATURE>.md` under
  `src/01-FEATURE-MAPS/`.
- **Produced by following it:** ADRs in `src/15-DECISIONS/`, `GAPS.md`/`DEFERRED.md` entries, and
  the resolved-decision links the map carries.
- Maps `MAP-<FEATURE>.md` — `<FEATURE>` in `SCREAMING-KEBAB-CASE`; workflow folders
  `NN-kebab-case/`; dates DD/MM/YYYY.
