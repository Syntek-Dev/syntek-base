# HANDOFF — MAP-PROGRESSIVE-ENHANCEMENT, frontier closed to two

**Written**: 31/08/2026 · **Session**: C (wayfinder resolve ×2 + a wayfinder doctrine change) ·
**Branch**: `main`, nothing committed

## Goal

Take `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` through
`/wayfinder resolve` to a closed frontier. It closed to **two** nodes, not zero — both promoted
out of Fog of war by this sitting's own outcomes, which is the honest result and is recorded as
such on the map.

## Done

### 1 — The wayfinder node type was wrong, and was fixed first

Batch D stalled on a definition defect: `task` read _"manual unblocking work: provision infra, run
a migration script, seed data"_ and was used that way in **none of its 42 instances across 8
maps**. Renamed to **`build`** — _the work a slice's story carries: named on the map, never done
on it_ — resolving when its **deliverable and acceptance** reach its slice row, and no further.

- `.claude/skills/wayfinder/SKILL.md` — 7 sites, incl. a new anti-pattern _Performing a build node_
- `project-management/workflows/01-feature-map/STEPS.md` — Steps 6, 7, 8, and 8a rewritten
- `project-management/workflows/01-feature-map/CHECKLIST.md` — 4 items added
- `project-management/workflows/01-feature-map/CLAUDE.md:19`
- `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md` — legend, a `build` example row,
  the six-column Slices table, and the rule that a build node is always `Blocking a story? = no`.
  **This file ships** (`copier.yml:158` re-includes `**/*TEMPLATE*`)

`tracer` survives **and gains a mode**: any node may be probed with `/prototype` before it
resolves, without being re-typed.

**Slices are now canonical at six columns** — `Slice | Story | Title | Nodes | Acceptance | Flags`,
with _Acceptance is what must be true, Flags is which gates run_ written down. Swept across all
ten maps plus the template; 42 `task` → `build`; 9 type legends. `TBD` cells carry a dated note
saying they are **unbackfilled, not empty**.

### 2 — Eleven nodes resolved on MAP-PROGRESSIVE-ENHANCEMENT

Batch D (N-014, N-015, N-020) then batches C, E, F, G (N-013, N-016, N-021, N-017, N-018, N-019,
N-023, N-025). Map moved **11 open → 2**, **14 resolved → 25**. Every decision and its acceptance
is on the map; nothing is summarised here.

### 3 — Six of the map's own claims failed re-measurement and are corrected in place

The cost citation (`+210 MiB` was the 3-engine total; Firefox alone is `+108 MiB`), five drifted
Lightning CSS line numbers, `shared/src/css/` already fixed by `ea78457`, N-018's `Blocked by`
naming a node resolved 15/08, `"nine prefixes"` being 9 properties **and** 5 values, and a Notes
row asserting an empty `GAPS.md` that is 346 lines with four open entries.

### 4 — Registers and memory

- `GAPS.md` — one new dated entry carrying **both** of this sitting's deferrals
- `.claude/MEMORY.md` — four patterns and one project-state fact
- `DEFERRED.md` — **untouched, deliberately** (see Open questions)

**Gates:** `docs-length`, `docs-pairing`, `doc-references`, `doctrine-drift` all exit 0; prettier
and markdownlint clean on every file this session touched.

## In-flight

**Nothing half-written.** All edits are complete and gated. Three things to know before resuming:

- **`MAP-PROGRESSIVE-ENHANCEMENT.md:5`** — `Frontier open: 2 · Blocking open: 0 · Resolved: 25`.
  The resolved table holds **26** rows; `N-006` is retained struck and **not counted**, its
  decision having been overturned by N-026. A naive row-count reads the header as off by one.
- **`MAP-PROGRESSIVE-ENHANCEMENT.md` Slices** — six of eight cuttable (`S-01`, `S-02`, `S-03`,
  `S-05`, `S-06`, `S-07`). `S-04` and `S-08` each hold one of the two promoted nodes.
- **`MAP-PROGRESSIVE-ENHANCEMENT.md` Frontier** — `N-027` and `N-028`, both `grilling`, both
  takeable, neither blocking.

### The tree is shared, and another session is live in it

`project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md` was written by a **concurrent session**
at 21:30 — a 712-line diff that is not this session's. Its two markdownlint errors (`:670`
MD003, `:673` MD026 — a paragraph followed by `---` parsing as a setext heading) belong to that
work and were deliberately left alone. This session's own sweep also touched that file earlier
(columns + legend), so **its diff now mixes two sessions**. `GAPS.md` and
`MAP-REGISTER-INDEXES.md` likewise carry Session B's uncommitted work.

**Never `git add -A`. Stage by explicit path.**

## Next

Run `/wayfinder resolve` on **N-027 and N-028** — the last two nodes, both `grilling`, both
takeable, and genuinely one sitting. N-027 asks who owns the `hx-boost` ban once N-013's gate
enforces it (stated in ten places across four guides, enforced by nothing today). N-028 asks
whether the engine matrix becomes a per-project first-time-setup item, since a generated project
would otherwise inherit ~984 MB of browser downloads it never chose.

**Before cutting any story from this map**, the `GAPS.md` re-triage (`01-feature-map` Step 2)
remains a hard gate and is still marked `STALE 21/08/2026` in the map's own checklist. It now
gates every slice, not just `S-01`, and `GAPS.md` has grown again today.

## Next skills

`wayfinder` → `grill-with-docs` for N-027 and N-028. Then `02-story-creation` for the six cuttable
slices. Per `project-management/src/01-FEATURE-MAPS/CLAUDE.md:18`, charting and settling run on
**Fable**; Opus only for moving a resolved row or fixing a link. **This session ran on Opus**, so
the map again records Fable-tier decisions taken on Opus.

## Artefacts

- `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` — the map
- `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md` — the shipped legend and column set
- `.claude/skills/wayfinder/SKILL.md` · `project-management/workflows/01-feature-map/` — the
  `build` doctrine
- `research/BROWSER-DIVERGENCE-NO-BUILD-CSS.md` · `research/RUNG-TWO-NATIVE-HTML-CSS.md` — the
  evidence `S-03` and `S-07` build on. **Both are undated and name no re-measurer**; `S-03`'s
  Acceptance obliges fixing that
- `GAPS.md` — the 31/08/2026 entry carrying both deferrals
- `.claude/MEMORY.md` — the patterns from this session
- `handoffs/HANDOFF-PE-MAP-RESOLVE-31-08-2026.md` — the previous handoff, **now spent**
- `e84e84c` — Session B's commit; `b03b6ab` — the base both sessions started from

## Open questions

- **Whether `DEFERRED.md` should ever be writable from a map.** This session routed both deferrals
  to `GAPS.md` because `DEFERRED.md`'s own rule targets a named future `US###` written from an
  implementation doc, and no story has been cut. The rule held, but the wayfinder graduation table
  still lists `DEFERRED.md` as a destination — those two may want reconciling.
- **Whether the ten-map ADR sweep can run.** Carried unanswered from the previous handoff. Session
  B's index-row sweep is still uncommitted, so the collision window has **not** closed.
- **Whether the resolve order across the ten maps is confirmed policy** — carried unanswered from
  two handoffs now; still a recommendation, never ratified.
- **Whether `handoffs/HANDOFF-PE-MAP-RESOLVE-31-08-2026.md` should be pruned.** Its work has
  resumed and completed, which is the skill's stated condition for pruning, but it is untracked
  and deleting it is unrecoverable — left in place for <%DEVELOPER_NAME%> to decide.
