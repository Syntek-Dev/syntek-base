# MAP-GENERATION-COVERAGE — Every valid offered configuration generates a complete, gated project

**Charted**: 19/11/2026 · **Charted by**: Sam and Claude · **Workflow**: `01-feature-map`
**Charted at**: `543054d6` (selectors re-inspected there)
**Status:** Charting
**Status note:** charted 19/11/2026 from the withdrawn US021's content; the case list, the split
and the map-first ruling arrived settled; five blocking grilling nodes and two research nodes are
open, and the destination awaits Sam's confirmation
**Frontier open**: 8 · **Blocking open**: 5 · **Resolved**: 4

> **Committed here, never shipped.** `copier.yml` `_exclude` empties `project-management/src/**`
> at generation, so this map is syntek-base's own record and never reaches a generated project.
>
> **Why this map exists.** US010's re-cut (grilling 19/11/2026, round 4 Q1) split the 72-case
> `[3/4]` generation matrix out of US010. It was first cut straight to a story, US021 (commit
> `37cbc958`), and **withdrawn the same day** on Sam's ruling (19/11/2026): stories are cut only
> from a map's slice, `CUT-PLAN.md` P14 pauses every cut until US001 to US014 are on `main`, and
> the number was never validly allocated (`CUT-PLAN.md` → _What this is not_: a number is
> allocated only when a `US###.md` is saved under `02-story-creation`). This map is the home the
> matrix waits in. Its draft text is recoverable with
> `git show 37cbc958:project-management/src/02-STORIES/US021.md` — a **draft**, not settled design.
>
> **N-001 to N-004 arrived settled**, each cited to its sitting. Charting settled nothing else:
> every Frontier node is open, and resolving them is a later grilling with Sam.

---

## Destination

_Proposed 19/11/2026, drafted from the withdrawn US021's acceptance; awaits Sam's confirmation at
the first RESOLVE batch._ Every one of the 72 valid configuration cases is generated from the
recorded source SHA and passes every gate applicable to it, each with its own evidence; a missing
case, an unrun gate or a selector the matrix does not enumerate is reported, never absorbed.

**What "done" makes true downstream** (charting note, not part of the destination): US012's
"every render path" criteria become measurable, and the four optional surfaces CI never generates
today (ClickUp declined, Rust, desktop, Wagtail) are generated on every run that claims coverage.

---

## Notes

| Field                    | Value                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Template-integrity CI: `.github/workflows/audit-template.yml` job `[3/4] Template Generation`, `copier.yml` selectors, the `.github/scripts/shipped-*.sh` gates, `pm-board.sh --check` in a generated tree                                                                                                                                                        |
| Skills to load           | `grill-with-docs` (every grilling node); `research` (N-009, N-010); `cicd` (the job, Rust provisioning); `test-writer` and `qa-tester` (the probes); `global-workflow`                                                                                                                                                                                            |
| Standing preferences     | **Sam, 19/11/2026:** map first, never a story straight from a re-cut; P14 holds. **Template:** `audit-template.yml` may contain no GitHub expression syntax, which rules out a job `matrix:`; the workflow stays `contents: read`; "could not look" is never "clean" (`code/docs/GATE-REPORTING.md`); every dev operation runs through `code/src/scripts/**/*.sh` |
| Consumers                | **US010** — its plan holds the case list it no longer builds; **US011** — absorbed into US010, its landing-run clause read the full matrix; **US012** — its "every render path" criteria stay unmeasured until this map's slice is cut and lands. None waits on this map to merge                                                                                 |
| Cross-map                | **Risk, not a hold (CUT-PLAN.md P11):** MAP-NATIVE-MOBILE-SURFACE S-01 may delete `INCLUDE_MOBILE`, which changes the case count (F-01), not the slice's shape                                                                                                                                                                                                    |
| Umbrella ADRs            | None owed by the map. The gate rows follow `../15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md`, consumed, never amended; any ADR a node earns is authored by the slice's story (`../15-DECISIONS/CLAUDE.md`)                                                                                                                          |
| Register entries triaged | 0 closes · 0 blocks · 51 unrelated — 45 open dated `GAPS.md` entries, the 16/08/2026 sitting's three _Still open_ bullets, and 3 `DEFERRED.md` rows; SL-1 to SL-3 exempt; six `✅ CLOSED` entries not open                                                                                                                                                        |

---

## Register claimed

**Nothing claimed.** Every open entry is **unrelated**: none is retired by generating the 72 cases,
and none stands in the way of it. Three sit near this map and were read in full, because a
per-case gate would **surface** a recurrence of each without being its fix:

- `GAPS.md` 06/11/2026 — a project generated with the default answers fails `sync-trees.sh` — a
  content fix to the tree rows; the matrix would detect it, not repair it.
- `GAPS.md` 05/11/2026 — the `.copier/` seed bodies are read by no citation clause — a
  `doc-references.sh` clause, not a render.
- `GAPS.md` 12/11/2026 — residue of the template-only reference sweep — four items; whether the
  per-case optional-paths gate retires its export-README presence item (F-025) is F-02, not a
  claim, because a partial claim would remove an entry three-quarters of which this map does not
  carry.

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                                                                                                                                            | Type     | Settled    | Became                                                                                                                                                                                               |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| N-001 | **The case list:** five offered booleans and three postures; desktop only with Rust; 12 surface rows x ClickUp 2 x posture 3 = **72** cases, `CFG-<row>-C<0\|1>-P<0\|1\|2>`; the 24 desktop-without-Rust tuples excluded as invalid                                                                 | grilling | 09/10/2026 | `../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` → _Every valid offered configuration — approved 09/10/2026_ (grill-with-docs Q4); selectors re-inspected at `543054d6`, unchanged |
| N-002 | **The evidence rule:** each case rendered from one recorded SHA with normal copy tasks; effective answers read from its `.copier-answers.yml`; failures accumulated; a missing prerequisite is an unrun case, never green; a gate is N/A only where its group is absent and the absence is asserted | grilling | 09/10/2026 | the same plan section (its two paragraphs after the case table, and its closing paragraph)                                                                                                           |
| N-003 | **The split:** the matrix leaves US010, which stays 8 SP; US012 records exhaustive coverage as unmeasured until it lands                                                                                                                                                                            | grilling | 19/11/2026 | `../02-STORIES/US010.md` → _Re-cut — 19/11/2026_, round 4 Q1                                                                                                                                         |
| N-004 | **Map first:** the split is charted here, not cut to a story; US021 is withdrawn and its number returned, because no number was validly allocated (P14)                                                                                                                                             | grilling | 19/11/2026 | this map; the withdrawal commit; the dated notes in US010, its plan, QA plan and manual guide, US012, SPRINT-06, `06-SPRINT-PLAN-06.md` and `CUT-PLAN.md`                                            |

---

## Slices

| Slice | Story | Title                                                                 | Nodes                                                                                                    | Acceptance                                                                                                                                                                                                                                                                              | Flags                                                                                                                                                                                            | Carries                                                                                                                                  |
| ----- | ----- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| S-01  | —     | Every valid offered configuration generates a complete, gated project | N-001 ✅ · N-002 ✅ · N-005 ⛔ · N-006 ⛔ · N-007 ⛔ · N-008 ⛔ · N-009 ○ · N-010 ○ · N-011 ⛔ · N-012 ○ | 72 distinct case IDs rendered and gated per run that claims coverage, each with its own evidence; a missing or duplicated case, a selector the matrix does not enumerate, and an unrun prerequisite each reported by name, never green; one failing case never hides the cases after it | Security: CI supply chain — `contents: read`, no secret or write token, every new action pinned by SHA, Rust only from the pinned toolchain, synthetic posture answers · QA: integration, manual | F-01 (INCLUDE_MOBILE may be deleted); F-03 (shared-file comparison cost); F-04 (US012's criteria re-pointed); F-05 (advisory split seam) |

**Not cuttable** while any `⛔` node is open, and **not cut while P14 holds** (`../02-STORIES/CUT-PLAN.md`).
The withdrawn US021 drafted a full flag table, Gherkin and task list for this row; the cut reads
it as a draft and re-derives each from the settled nodes.

---

## Frontier

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                  | Type     | Blocked by            | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------- | ----------------- |
| N-009 | **Cost and time, measured.** Wall time of one complete render plus its gates on the current `[3/4]` job, the Rust-enabled render's extra (lock task, toolchain), and the runner-minute budget the repository runs under                                                                                                                                   | research | none                  | no                |
| N-010 | **Rust provisioning today.** Where the pinned toolchain is declared, and which existing workflow installs it and how                                                                                                                                                                                                                                      | research | none                  | no                |
| N-011 | **The gate list, re-based.** Confirm the per-case gates against US010's re-cut: the eight generated boards in place of the seven indexes, a board-content row (byte-identical to seed, `pm-board.sh --check` green), the joined-line search as the one instruction row, the literal grep and link check dropped. The withdrawn US021's table is the draft | grilling | none                  | yes               |
| N-005 | **Execution shape.** One sequential loop, sharded jobs with literal case lists, or a separate workflow outside the rendered tree — with no GitHub expression syntax in `audit-template.yml` (US021 open question 1)                                                                                                                                       | grilling | N-009                 | yes               |
| N-006 | **Trigger.** The full 72 on every pull request into the chain, or a narrower trigger (pushes to `testing` and up, or a path filter on `copier.yml`, `.copier/` and the render script) with the two-case loop for the rest; whatever runs less than every PR says so in its job name (US021 open question 2)                                               | grilling | N-005, N-009          | yes               |
| N-007 | **Rust provisioning.** The job installs the pinned toolchain itself, or uses a runner image carrying it; the 36 Rust-enabled cases depend on it (US021 open question 3)                                                                                                                                                                                   | grilling | N-010                 | yes               |
| N-008 | **Evidence retention.** A retained tree or an immutable gate log per case, and for how long (US021 open question 4)                                                                                                                                                                                                                                       | grilling | N-005                 | yes               |
| N-012 | **The 72-case run itself** — enumeration from one source, the selector-drift and missing/duplicate probes red first, per-case evidence, accumulated failures, every gate row generalised to every case                                                                                                                                                    | build    | N-005 to N-008, N-011 | no                |

**Takeable edge:** N-009, N-010 and N-011. **Not dispatched at this chart** — the research nodes
are left for the first RESOLVE session, by Sam's instruction that this sitting charts only.

---

## Fog of war

- **F-01 — `INCLUDE_MOBILE` may be deleted** — MAP-NATIVE-MOBILE-SURFACE S-01 would halve the
  matrix to 36; the selector-drift probe is what makes that land in the same change. Sharpens
  when that map resolves.
- **F-02 — the sweep residue's export-README presence item** — whether S-01's optional-paths gate
  retires F-025 of the `GAPS.md` 12/11/2026 entry, or that item stays with the entry. Sam's call
  at the first RESOLVE batch.
- **F-03 — the shared-file consistency gate's cost** — comparing common rendered files across
  every selector edge grows with the case count; not sharp until N-009 measures a render.
- **F-04 — US012's "every render path" criteria** — re-pointed to S-01's runs at US012's own
  pass; the cut must name the runs US012 reads.
- **F-05 — the advisory split seam** — if the cut prices S-01 above 8, the seam is the case
  enumeration with its evidence record against the per-case gate rows (CUT-PLAN.md P2).

---

## Out of scope

| Ruled out                                                            | Why                                                                                                                        |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Free-text branding and numeric capacity answers                      | Not offered configuration branches; their validators and substitution boundaries are separate tests (N-001's plan section) |
| The template-source self-tests and the shared-AI copy/update fixture | They prove their detector or update seam, not the 72 trees, and run separately (N-002's plan section)                      |
| Running any case against a deployed environment                      | Posture answers are synthetic render inputs, never a route to an environment (`.claude/CLAUDE.md` Section 0)               |

---

## Session log

| Date       | Node settled | Outcome                                                                  | Frontier redrawn |
| ---------- | ------------ | ------------------------------------------------------------------------ | ---------------- |
| 19/11/2026 | —            | Charted; N-001 to N-004 arrived settled; eight nodes open, five blocking | [x]              |

---

## Gate to stories

- [ ] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it, is carried here in substance, and is gone
      from `GAPS.md` / `DEFERRED.md` (`01-feature-map` Step 2) — none claimed
- [x] Every knowable decision is a node or in fog of war; every fog item has an `F-NN`
- [x] Every fog item a cut must take is in its slice's **Carries** cell
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved**
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest** — every gate it needs, `N/A` omitted

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked** — and,
for this map, once P14 releases cutting.
