# HANDOFF — US010 and US011 are cut and the map is re-cut; nothing is committed and no sprint holds either story

**Written**: 20/09/2026 · **Branch**: `pm/story-creation` · **HEAD at writing**: `53d9196`
**Workflow just closed**: `project-management/workflows/02-story-creation/` — Steps 0 to 4, twice
**Next workflow**: `project-management/workflows/03-sprint-planning/` — `SPRINT-06` and `SPRINT-07`

---

## Goal

Cut the next story from the feature maps. A four-round grilling pass selected
`MAP-REGISTER-INDEXES.md` `S-01` out of ~55 eligible uncut slices, then split it — so the session
produced **two** stories rather than one, and re-cut the map to match. `02-story-creation` is
complete for both. **Nothing is committed**, and neither story belongs to a sprint yet.

---

## Done

### 1. The slice frontier was swept and the choice grilled to an empty frontier

Fifteen maps read; nine stories already cut from seven of them; **~55 slices eligible**. Four
rounds of `grilling` settled the selection and the shape. The decisions and their reasons are
written into the two stories' own provenance blocks — **do not re-litigate them**, read them
there:

| Settled                                                                                        | Where it is recorded                                       |
| ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| The slice: `MAP-REGISTER-INDEXES` `S-01`, over `GATE-PARITY` `S-05` and `SCRIPT-GUARDS` `S-02` | `US010.md` Provenance                                      |
| Split at the register seam → two stories, not one                                              | `US010.md` Provenance · `US011.md` Provenance              |
| Incomplete indexes ship **declaring their own debt**                                           | `US010.md` Q1 round 3 → its `Backfill owed — US011` clause |
| Map `**Status**` gains a four-value enum prefix, middle-dot separated                          | `US010.md` Provenance → _THE ENUM SEPARATOR IS_            |
| `US010` widened to the four surviving index-row instruction sites                              | `US010.md` Provenance → _WIDENED BEYOND THE SLICE_         |
| Security added to `US010`'s manifest; `N/A` on `US011`, with reasons                           | Both Provenance blocks                                     |

### 2. Two stories written

| File                                         | Lines | MoSCoW      | SP  | FLAGS                     |
| -------------------------------------------- | ----- | ----------- | --- | ------------------------- |
| `project-management/src/02-STORIES/US010.md` | 537   | Must Have   | 8   | QA + Security, 11 × `N/A` |
| `project-management/src/02-STORIES/US011.md` | 363   | Should Have | 8   | QA, 12 × `N/A`            |

Both: `**Epic:** Register Indexes`, `**Status:** Open`, 13 FLAGS rows with no blanks, Gherkin
acceptance criteria, per-gate tasks, verification checks, DoD. `US011` is **blocked by** `US010`.

### 3. The map re-cut — Step 4 plus three recorded acts beyond it

`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`, **+56 / −12**:

- `:349` `S-01` → `US010`; `Nodes` `N-001 · N-002 · N-005`; `Acceptance` back-filled from Batch A and B
- `:350` `S-02` → `US010`; **narrowed** to `MAP-INDEX.md` only; `Nodes` `N-006` (map half)
- `:353` **new `S-05`** → `US011`; `N-006` (four-register half)
- `:333` Slices preamble — Sam's _no story until the frontier is empty_ preference recorded **discharged**
- `:425` new `### Measured at 02-story-creation, 20/09/2026` — the six stale figures table
- `:607` Session log gains a 20/09/2026 row
- `:630` the deadlock box records the ruling **exercised**, and stays open — cutting is not shipping
- `:6` header `**Status**` now reads _cutting_ and names both stories

### 4. Six of the map's own figures measured stale, and one defect fixed in a story

Tabled at `MAP-REGISTER-INDEXES.md:425` so a later reader of that file does not act on them.
Headlines: the backfill population is **14 maps, not ten** (and 56 rows across all seven
registers, which is what forced the split); `copier.yml`'s `_tasks` block is `:973-984`, not
`:908-919`; `SPRINT-00-TEMPLATE.md`'s missing `**Status:**` rider is **already discharged**;
`17-STORY-PLANS/CONTEXT.md` **already has** the `## The plans index` H2 the map says it lacks.

**A real rendering defect was caught and fixed in `US011.md`**: its provenance quoted an ADR line
containing a literal `-->`, which closed the HTML comment early and would have spilled half the
block into the rendered story. Rewritten to describe the markers without reproducing them; the
correction is recorded in the file.

### 5. Gates

| Gate                                         | Result                                                                                                             |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `markdownlint-cli2` (all three files)        | **pass** — 0 issues                                                                                                |
| `prettier --write`                           | applied                                                                                                            |
| `audits/docs-length.sh`                      | **pass** — 784 files                                                                                               |
| `audits/docs-pairing.sh`                     | **pass**                                                                                                           |
| `audits/doc-references.sh` — the map         | **pass**, zero findings                                                                                            |
| `audits/doc-references.sh` — the two stories | **47 and 27 findings — NOT clean, and not new.** Same three classes as `US009.md`'s 10. See _Open questions_ below |

---

## In-flight

**Nothing is mid-edit.** All three files are complete and lint-clean. What is outstanding is
downstream work that has not started.

| Anchor                                        | State                                                                                                                                 |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Working tree                                  | `US010.md` and `US011.md` **untracked**; `MAP-REGISTER-INDEXES.md` **modified**. Nothing staged, nothing committed                    |
| `project-management/src/03-SPRINTS/`          | No `SPRINT-06` or `SPRINT-07`. `SPRINT-01`–`05` all closed; `04` and `05` at the 13 SP grace ceiling                                  |
| `US010.md:475` · `US011.md:311` — `Map Tasks` | Both rewritten to **verify, do not re-cut**. The gate's edits are done; a story re-cutting the map would be a second, unreviewed pass |
| `project-management/src/17-STORY-PLANS/`      | No `10-` or `11-` plan reserved. Nine plans exist, `01-` to `09-`                                                                     |

**A concurrent session is charting `project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md`**
— "Retire React Native; the mobile surface becomes Kotlin and Swift", `Status: Charting`, 21 open
/ 9 blocking, four slices, **untracked**. It is not mine and I have not touched it. It took the
map count from 14 to 15 mid-session, which is why **neither story holds a literal count**; both
assert one row per instance counted at implementation time. Coordinate before editing
`01-FEATURE-MAPS/` (`.ai/INSTRUCTIONS.md` → shared-artefact ownership).

---

## Next

**Run `project-management/workflows/03-sprint-planning/` to create `SPRINT-06` holding `US010`
alone (8 SP Must, inside the 11 SP capacity, no stretch tier).** `US011` at 8 SP `Should` cannot
join it — 16 SP breaches both capacity and the 13 SP grace — so `SPRINT-07` follows. Both stories'
_Dependencies_ sections already state this and both name their sprint; the records must agree.

Note for that gate: every `SPRINT-##.md` carries the same five-copy backlog register with **no
gate behind it** (`GAPS.md`, 17/09/2026). Two new records make it seven copies.

---

## Next skills

`sprint` (the workflow driver) · `grilling` (the gate opens with a pass) · `global-workflow`
(sprint record conventions). Then `git` when <%DEVELOPER_NAME%> wants the three files committed —
they are one logical change and should land together, since the stories cite `S-05` and the map is
where `S-05` exists.

---

## Open questions

- **`doc-references.sh` reports 47 findings on `US010.md` and 27 on `US011.md`, and I am not
  calling that clean.** The classes are `instance citation`, `template-only citation` and
  `plan prefix` — identical to `US009.md`'s 10 findings. `copier.yml:157` excludes
  `/project-management/src/**`, so a story never ships and the shipped-file citation rule does not
  apply to it: that is the `GAPS.md` entry of 02/09/2026, whose fix is **`US004`**. No finding is a
  genuinely broken path. **Decision left open:** whether these two stories should carry
  `doc-references: template-only` markers in the interim, or wait for `US004`. Nothing was
  suppressed.
- **Whether `S-03` (the index gate) should be pulled ahead of `US011`.** `US010` ships four indexes
  deliberately incomplete, and only `US011` closes that window. Named as the criterion to change in
  `US010.md`'s Provenance → _ONE THING THIS GATE DID NOT SETTLE_.

---

## Artefacts

- `project-management/src/02-STORIES/US010.md` · `US011.md` — the two stories
- `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` — the re-cut map; `S-01`, `S-02`, `S-05`
- `project-management/workflows/02-story-creation/STEPS.md` · `CHECKLIST.md` — the gate just run
- `project-management/workflows/03-sprint-planning/` — the gate to run next
- `project-management/docs/planning/STORIES.md` — the >8 advisory and ≥13 epic thresholds both stories are priced against
- `project-management/docs/planning/CADENCE.md` · `SPRINTS.md` — the per-story loop and sprint rules
- `project-management/src/02-STORIES/US004.md` — the `Nodes`/`Acceptance` back-fill precedent, and the fix for the citation gate
- `project-management/src/02-STORIES/US005.md` — the slice-split-at-this-gate precedent
- `project-management/src/02-STORIES/US006.md` `:15-22` — the manifest-divergence rule both stories cite
- `project-management/src/02-STORIES/US007.md` `:170` — binds `S-01` to re-measure the Plans Index population
- `project-management/src/02-STORIES/US009.md` — the register model both stories were written against
- `GAPS.md` — entries of 01/09/2026 (index-row instruction, **claimed by `US010`**), 02/09/2026 (citation gate), 17/09/2026 (sprint register)
