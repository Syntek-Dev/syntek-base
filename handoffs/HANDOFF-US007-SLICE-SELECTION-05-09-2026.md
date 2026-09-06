# HANDOFF — US007 slice selection

**Written**: 05/09/2026 · **Branch**: `pm/story-creation` · **HEAD at write**: `c6df520`
**Workflow in play**: `project-management/workflows/02-story-creation/` Step 0

---

## Goal

Decide which feature-map slice becomes **`US007`**, then cut it through
`02-story-creation`. Sam has settled that **`SPRINT-03` stays closed at 10/11 SP** and `US007`
lands in **`SPRINT-04` or `SPRINT-05`**.

---

## Done

**Nothing was written to the repository this session.** It was a read-and-analyse pass; no
artefact under `project-management/src/` was created or edited. What landed is the analysis
below, and it is recorded here because its inputs are expensive to re-derive.

- **Cross-map slice census completed** — all 12 maps in
  `project-management/src/01-FEATURE-MAPS/`, **66 slice rows, 61 uncut, 5 cut**
  (`US001`, `US003`, `US004`, `US005`, `US006`). Counts independently re-verified per map by a
  completeness critic; no row was dropped.
- **Three candidates survived an adversarial refutation pass** — none refuted, both
  `02-story-creation` Step 0 preconditions confirmed holding for each.
- **Ranked shortlist produced** — 11 candidates, 50 uncut slices excluded with a stated reason
  each.

---

## In-flight

**The decision itself is open.** Sam was asked to choose and has not yet answered.

### The recommendation on the table

**`US007` = `MAP-SCRIPT-GUARDS` S-02, "The seed presence gate", 2 SP.**

- `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md:68` — the slice row; node `N-005`
  resolved, flag manifest present.
- `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md:165` — **the only on-record
  "cut this now" authorisation in the folder**: _"`S-02` may be cut by
  `workflows/02-story-creation/` whenever it is wanted."_
- Deliverable is one file: `.github/scripts/shipped-artefacts.sh` — a third loop in check 4 after
  `:224` over the `SEEDED` array (`:105`), a sixth probe after `:280`, and header claims at
  `:36-37`, `:41-43`, `:48-49`.
- Fits `SPRINT-04` beside `US006` at **10/11 SP**.

### The runner-up, and why the order matters

**`MAP-REGISTER-INDEXES` S-01, 5 SP, blast radius 11** —
`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:342`. Highest blast radius on the
board; the deadlock-breaker five sibling maps are parked on. **Cut order is free, but build order
is forced**: S-01's `seed-lands` QA clause passes vacuously until S-02's loop exists
(`.github/scripts/shipped-artefacts.sh:215-224` asserts only `NAMED_SHIPPED` and `SHIPPED_GLOBS`),
which is the false-green `code/docs/GATE-REPORTING.md` forbids. **The two must not be merged** —
`MAP-SCRIPT-GUARDS.md` Out-of-scope rules the fold out by name, and `MAP-REGISTER-INDEXES` N-003
cites the seed gate as an _input_ it must not own. At 5 SP it opens `SPRINT-05`.

### The third candidate, which no slice table contains

**The story `**Status:**` vocabulary reconciliation** — `GAPS.md:337-361`, marked "nothing blocks
it". Five shipped surfaces define one field two ways:
`.claude/skills/completion/SKILL.md:37-41` (five states) against
`project-management/docs/planning/STORIES.md:79-93` (eleven ClickUp states, "the canonical set"),
plus `project-management/workflows/23-pr-and-review/STEPS.md:73-74`, which **instructs a
transition the shipped completion skill forbids**.

It sits **upstream** of the two candidates above: `MAP-REGISTER-INDEXES` N-003's gate will
string-equal this field, so shipping S-01/S-03 first bakes an ambiguous field into a gate.
`project-management/src/02-STORIES/US002.md:11-22` is the standing precedent that a story need not
come from a slice row.

---

## Next

**Ask Sam to pick between `MAP-SCRIPT-GUARDS` S-02 and the `GAPS.md:337-361` status-vocabulary
reconciliation, then open the `grill-with-docs` pass on the winner** per
`project-management/workflows/02-story-creation/STEPS.md` Step 1.

---

## Next skills

`story` + `grill-with-docs` + `global-workflow` (model: **fable**, per
`02-story-creation/STEPS.md` frontmatter). Add `sprint` if the `SPRINT-03` closure below is taken
in the same pass.

---

## Open questions

1. **Which candidate is `US007`** — S-02 (ready, authorised, 2 SP, fits `SPRINT-04`) or the
   status-vocabulary reconciliation (upstream of two ranked candidates, no slice row)?
2. **Is `SPRINT-03`'s record to be corrected in this pass?** Its capacity line still reads
   _"inside capacity, and still admitting"_ — `project-management/src/03-SPRINTS/SPRINT-03.md:15`
   — which now contradicts Sam's call. `SPRINT-01.md` Notes carry the precedent for closing a
   ledger by decision rather than by fill. **Not yet actioned.**

---

## Artefacts

| Path                                                                                                                                                             | What it is                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md:68`, `:165`                                                                                         | Candidate 1 slice row and its cut authorisation                            |
| `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:342`                                                                                             | Candidate 2 slice row                                                      |
| `GAPS.md:337-361`                                                                                                                                                | Candidate 3 — the status-vocabulary entry                                  |
| `project-management/src/03-SPRINTS/SPRINT-03.md:15`, `:316-318`                                                                                                  | The capacity line to correct; the 5 SP carry reserved into `SPRINT-04`     |
| `project-management/src/02-STORIES/US006.md`                                                                                                                     | `SPRINT-04`'s only current member, 8 SP                                    |
| `project-management/workflows/02-story-creation/STEPS.md`                                                                                                        | The procedure to run next                                                  |
| `project-management/docs/planning/STORIES.md`                                                                                                                    | Cutting doctrine, estimation thresholds                                    |
| `/home/sam-dev/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/c2103b8b-075e-4d66-ac11-cf510224e754/subagents/workflows/wf_388bca46-305/journal.jsonl` | The full census — one result line per agent, **local only, not committed** |

---

## Facts measured this session that the artefacts get wrong

Carried here because each was verified against the tree and each would otherwise be re-derived.
**None has been written into the repo** — they belong to whichever story or tidy pass takes them.

- **`SPRINT-04` does not exist on disk.** `project-management/src/03-SPRINTS/` holds `SPRINT-01`
  to `SPRINT-03` only. `SPRINT-03.md:316-318` reserves a **5 SP carry** into it should `US003`
  slip — so `SPRINT-04` is 10/11 with a 2 SP `US007`, or 15/11 if `US003` slips.
- **The citation gate is red at 22 findings** (`GAPS.md:387-444`), and that entry states the fix
  must not be attempted until `US004` establishes the mechanism. Whatever ships next inherits it.
- **The 01/09/2026 cross-map cutting order has no artefact of record.** It exists only across nine
  sites — `US001.md:54`, `:67`; `US002.md:98`; `US003.md:58`, `:99`; `SPRINT-01.md:61`;
  `01-SPRINT-PLAN-01.md:93`; `02-SPRINT-PLAN-02.md:101`; `03-SPRINT-PLAN-03.md:88` — mostly inside
  HTML comments. "Wave 0" is asserted by each story about itself and defined nowhere in
  `project-management/docs/planning/`.
- **`MAP-GATE-PARITY` S-01, S-02, S-04, S-06 are retired, not missing** — `MAP-GATE-PARITY.md:489-513`
  records each retirement with a date and destination. Six live rows is correct.
- **`SPRINT-00-TEMPLATE.md:10` already carries `**Status:** Planned`** (commit `82ec176`,
  02/09/2026), yet `MAP-REGISTER-INDEXES.md:213` and `:391` still list it as work to do.
- **The Plans Index citations number 10 across 6 files, not the 8** `MAP-REGISTER-INDEXES.md:212`,
  `:264` and `:392` claim: `workflows/17-story-plans/CLAUDE.md:23`, `:30`; `STEPS.md:131`;
  `CHECKLIST.md:82`; `CONTEXT.md:47`; `src/17-STORY-PLANS/CLAUDE.md:26`;
  `STORY-PLAN-US000-TEMPLATE.md:16`, `:625`, `:646`, `:773`.
- **`MAP-RETRY-AND-IDEMPOTENCY.md:394` and `US005.md:160` both say "they share no file" — false.**
  `US005` edits `code/docs/performance/API-AND-MONITORING.md:57`, S-09 reduces `:33-34` of the same
  file, and `US001` via N-007 rewrites it from `:41`.
