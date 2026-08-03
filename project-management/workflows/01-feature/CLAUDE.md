@./CONTEXT.md

# CLAUDE.md — workflows/01-feature/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, the two modes, the reading order — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The discovery gate — chart a feature's decision frontier with wayfinder and settle it node by
node, producing the resolved `MAP-<FEATURE>.md` that every later planning gate reads instead of
re-asking the same questions.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `planner` agent (Fable), loading
  `.claude/skills/wayfinder/SKILL.md`. Grilling nodes open `grill-with-docs`; research nodes use
  `research`; tracer nodes use `prototype`. The hard gate — the wayfinder skill itself — must be
  read before Step 1.
- **Model:** Fable throughout — mapping a decision frontier and settling trade-offs is the
  reasoning tier the whole implementation builds on. Opus only for mechanical touches: a link
  fix, moving a resolved row, a date bump.
- **Concrete steps:** load the context in the documented order → CHART (pin the destination, map
  the frontier breadth-first, wire blocking edges, write the map, fire research nodes) → then
  RESOLVE one node per session until no blocker remains open → graduate every outcome to its real
  home → satisfy `CHECKLIST.md`.
- **Definition of done:** the destination and out-of-scope bounds are written and confirmed;
  every knowable decision is a node or honestly parked in fog of war; no blocking node remains
  unresolved; every resolved node links to the artefact it became.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`agent`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Charting is one session and settles nothing but research nodes.** The temptation is to answer
  a node while it is in front of you. Do not — a frontier drawn and a frontier resolved are
  different acts, and mixing them produces a map shaped by whatever was easiest to answer first.
- **Look facts up; only ask about genuine trade-offs.** `code-review-graph` → Read/Grep/Glob →
  `.claude/plugins/*.py` → `context7`. A question whose answer is in the repo is not a decision
  node, and asking it spends the one resource this workflow is protecting: <%DEVELOPER_NAME%>'s attention.
- **The map is an index, never a vault.** A node's detail lives in the ADR, plan, or story it
  graduates to. A map that accumulates the reasoning becomes the thing nobody reads.
- **Fog of war is honest, not embarrassing.** Something in scope but not yet sharp enough to
  state as a decision goes there. Forcing it into a node produces a decision made on nothing.
- **Do not write stories here.** Stories are cut in `02-story-creation`, from the map. A story
  written during discovery bypasses its own gate.
- **Every resolved node graduates.** An answer left only on the map is lost the moment the map is
  superseded — it belongs in an ADR, a plan, a story, `GAPS.md`, or `DEFERRED.md`.
- Documentation workflow — no code. Instructional `.md` files ≤ 300 code lines (the map artefact
  itself is exempt).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the map `MAP-<FEATURE>.md` under
  `src/01-FEATURE/`.
- **Produced by following it:** ADRs in `src/14-DECISIONS/`, `GAPS.md`/`DEFERRED.md` entries, and
  the resolved-decision links the map carries.
- Maps `MAP-<FEATURE>.md` — `<FEATURE>` in `SCREAMING-KEBAB-CASE`; workflow folders
  `NN-kebab-case/`; dates DD/MM/YYYY.
