# SPRINT-07

**Last Updated**: 20/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The four indexes that shipped declaring their own debt are backfilled — every story,
sprint, decision and story plan carries a row with its own status mirrored verbatim and a summary
written for someone who has not opened it — while the `.copier/` seeds stay blank.

<!-- Derived from the title and Client Summary of US011, the sole member, and from the deliverable
     column of the appended slice `S-05` on
     project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md — the derivation
     project-management/src/03-SPRINTS/SPRINT-03.md used on 07/09/2026 for a record with one
     member.

     Narrow by construction, and narrower than project-management/src/03-SPRINTS/SPRINT-06.md's.
     `S-05` was appended at `02-story-creation` on 20/09/2026 when `S-02` split at the register
     seam; this goal names the four-register half and nothing else. The mechanism the rows go into
     is SPRINT-06's, `S-03`'s gate is uncut, and a goal reaching into either would re-merge halves
     the split exists to keep apart. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 / 11 SP** — inside capacity, **OPEN to admission**, and
holding **no `Must` tier at all**: its sole member is a `Should`, and the tier
`project-management/docs/planning/SPRINTS.md` requires is **reserved and absent** rather than
skipped. See Notes.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story admitted,
     never edit it directly.
     Computed 20/09/2026 on US011's admission at opening — the union over one member is that
     member's table, copied verbatim from project-management/src/02-STORIES/US011.md including the
     reasoning its Security row carries in place of a bare N/A. One row carries values: QA names
     integration and manual types. Twelve rows read N/A.

     SECURITY READS N/A AND THE ROW CARRIES ITS REASONING RATHER THAN THE BARE VALUE, which is the
     member's own choice and is reproduced rather than flattened. The story writes real syntek-base
     rows into four in-tree files whose `.copier/` seeds must stay blank, and a leak would ship this
     repository's backlog into every generated project permanently — but the control for that is
     built and gated by US010 in project-management/src/03-SPRINTS/SPRINT-06.md, whose `ST03` and
     `ST04` require every seed authored blank and proved so, and whose enlarged `SEEDED` array puts
     all seven files under `.github/scripts/shipped-artefacts.sh`. This member introduces no control
     and changes none; it is EXERCISED BY that gate, which is a QA assertion rather than a security
     design. US006.md:15-22's rule cuts both ways, and a flag filled for a gate with nothing to
     decide is as much noise as a flag skipped for one that has. If `10-security-checks` reads it
     differently this is the row to change, and the union here changes with it.

     ONE WORD IN THAT ROW IS NOT VERBATIM, and it is the only one. The member's row ends "Reasoning
     in full in the Provenance block above"; a sprint record has no Provenance block, so it reads
     "FLAGS block above" here and points at this comment. Named because
     project-management/docs/planning/SPRINTS.md allows the union exactly one narrowing — a Part A /
     Part B split — and nothing else, so a substitution made for legibility is recorded rather than
     left for a reader to find by diffing. Everything else in the row, including its backticks, is
     the member's own.

     THESE ARE FIRST-PASS VALUES. On 20/09/2026 no artefact under
     project-management/src/10-SECURITY/ or project-management/src/11-QA/ names US011, and it has no
     story plan. Per code/docs/GATE-REPORTING.md this is a gate not yet entered, reported as such —
     not a gate that found nothing. -->

| Flag       | Value                                                                                                                                                                                                                     |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                       |
| User Flow  | N/A                                                                                                                                                                                                                       |
| Brand      | N/A                                                                                                                                                                                                                       |
| Components | N/A                                                                                                                                                                                                                       |
| Wireframes | N/A                                                                                                                                                                                                                       |
| GDPR       | N/A                                                                                                                                                                                                                       |
| Security   | N/A — the seed-purity control is `US010`'s `ST03`/`ST04` and its enlarged `SEEDED` array; this story adds no control and is exercised by that one. Reasoning in full in the FLAGS block above                             |
| QA         | integration, manual — generated-tree grep (no syntek-base row reaches a seed); `shipped-artefacts.sh --self-test` unchanged and green; row-per-instance and status-string-equality read by hand across the four registers |
| SEO        | N/A                                                                                                                                                                                                                       |
| API        | N/A                                                                                                                                                                                                                       |
| Logging    | N/A                                                                                                                                                                                                                       |
| Backend    | N/A                                                                                                                                                                                                                       |
| Frontend   | N/A                                                                                                                                                                                                                       |

---

## Story Summary

| ID    | Title                                                                                               | MoSCoW      | SP  |
| ----- | --------------------------------------------------------------------------------------------------- | ----------- | --- |
| US011 | The four indexes that shipped blank get their 43 rows, and each register stops claiming it is empty | Should Have | 8   |

**Total:** 8 SP — **0 committed, 8 stretch.** This record has **no `Must` tier**, which is the
inverse of the defect `project-management/docs/planning/SPRINTS.md` warns about and is recorded in
the Notes rather than repaired by relabelling the member.

<!-- US011 is added to this table rather than referenced from it because
     project-management/docs/planning/SPRINTS.md computes the flag union and the capacity FROM this
     table, and a story in no Story Summary is counted nowhere — SPRINT-04's reading of 07/09/2026.
     US011 sits in no other record's table; its own `**Status:**` reads `Open`, and this record
     moves it nowhere.

     The `Should` is the member's own, settled at cutting on 20/09/2026 with a written warrant: the
     four indexes ship from SPRINT-06 DECLARING their incompleteness and naming this story, so the
     falsehood that would have made this a `Must` never reaches the tree. It is NOT relabelled here.
     project-management/docs/planning/SPRINTS.md derives a record's tiers FROM its stories, and a
     record editing a member's priority to satisfy its own doctrine inverts the derivation — the
     option was put at `03-sprint-planning` on 20/09/2026 (Q1) and declined. -->

## Dependencies

- **Blocked by US010**, in `project-management/src/03-SPRINTS/SPRINT-06.md`. That story creates the
  four index files, designs their tails and ordering rules, and writes the `Backfill owed — US011`
  line this one removes. **There is nothing for this record's member to edit until it ships**, and
  US011's own `## Dependencies` states the same edge from its side.
- **This is the only hard sequencing edge in the record, and it is a sprint-level one.** SPRINT-06
  must close, or at least US010 must land, before this sprint's member can start. Sprint numbering
  is not execution order (`project-management/docs/planning/SPRINTS.md` -> _Sequencing_), but here
  the two agree: `SPRINT-06` builds before `SPRINT-07` because its member is this one's blocker.
- **Nothing else blocking.** Verified 20/09/2026 at cutting against US001 to US010, all
  `Status: Open`: none of them writes an index file, and none renames an artefact in the four
  registers US011 backfills.
- **`MAP-REGISTER-INDEXES.md` `S-03` — the gate — ships after this sprint.** `N-003` asserts
  presence, symmetry and status; this record's member is what makes its symmetry and status clauses
  testable against a populated register rather than an empty one. The sequencing is explicit: `S-03`
  is not a dependency of this record, this record is a precondition of `S-03` being meaningful.
- **`20-FINDINGS` and `21-BUGS` are out of scope, and the absence is a measurement.** Both held zero
  instances on 20/09/2026, so SPRINT-06 ships their indexes legitimately empty with no debt line. If
  either has gained an instance by the time this sprint runs, it is US010's own presence clause to
  satisfy and not this record's backfill — named so the boundary is not re-drawn at the keyboard.
- **US011 does not block on US004**, for the reason SPRINT-04 recorded for US006, SPRINT-05 for
  US008 and SPRINT-06 for US010.
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` is a
  reporting regime and sequences nothing. See Verification Checks.
- **Sprint numbering and build order agree.** The settled build order is the prefix on each plan in
  `project-management/src/17-STORY-PLANS/` — nine plans on disk on 20/09/2026, `01-` to `09-` — with
  US010 tenth at a reserved `10-` and US011 eleventh at a reserved `11-`. Both are **reserved
  numbers, not plans**: `17-story-plans` writes them, and nothing here may cite either as one
  (SPRINT-04's rule for US006's `07-`). Nothing is renumbered. When `16-sprint-plans` writes this
  sprint's plan, both segments of `{exec-order}-SPRINT-PLAN-{sprint-number}.md` read `07`.
- **Nothing carries into this record, and what may carry OUT of it has no named destination yet.**
  US003's carry is reserved into SPRINT-03 and US009's into SPRINT-06; neither reaches here, and no
  record reserves anything to this one. In the other direction the record can only say what is true
  on 20/09/2026: **US011 is a `Should`, so it can be dropped, and a dropped `Should` is never
  dropped silently** — but there is no `SPRINT-08` to reserve it into, and this record will not
  invent one. The Definition of Done below states the disposal in both branches and binds the
  reservation to be **named the moment a receiving record exists**, which is the discipline
  `project-management/src/03-SPRINTS/SPRINT-05.md` had to be corrected into on 20/09/2026 after its
  own "the next record" was written against a record that did not exist.
- **`Blocked` is a story status, not a sprint one.** US011's own `**Status:**` reads `Open` and this
  record moves it nowhere — the blocking edge is recorded in both stories and in both records, and a
  status flip is `.claude/skills/completion/SKILL.md`'s to make when the work actually starts.

## Notes

**This record has no `Must` tier, and that is stated rather than papered over.**
`project-management/docs/planning/SPRINTS.md` -> _MoSCoW_ is explicit: "A plan must contain at least
the **Must** tier; **Should** and **Could** are stretch and are dropped first when capacity
tightens." This record contains only a `Should`. Three consequences follow, and each is disposed of
below rather than left to be discovered:

- **The template's Definition of Done goes vacuous.** "All stories in the Story Summary are
  individually marked **Done**" is scoped to the `Must` tier in every record here; with no `Must`
  the sprint could close having delivered nothing and still satisfy it. The Definition of Done below
  keeps that row, marks it `N/A` with its reason per `code/docs/GATE-REPORTING.md`, and adds the
  member-keyed row that actually binds.
- **"Dropped first" has no referent.** A `Should` is dropped so the `Must` tier can land. With one
  member there is nothing to be dropped **for** — dropping it empties the sprint rather than
  protecting anything. **MoSCoW is a relative ordering between members, and at one member it is
  inert.** Settled at `03-sprint-planning` on 20/09/2026 (Q1).
- **The tier is reserved, not skipped.** This record is **OPEN to admission** precisely so a `Must`
  can anchor it, which is the distinction between a gap that is known and one that is hidden.

**Why the member was not simply relabelled `Must`.** It was the option put at the same gate and
declined. US011's `Should` carries a written warrant at cutting — the four indexes it fills ship
from SPRINT-06 **declaring** their incompleteness and naming this story, so the false-emptiness that
would have made it a `Must` on this epic's own thesis never reaches the tree, and nothing is blocked
from shipping by its absence. `project-management/docs/planning/SPRINTS.md` derives a record's tiers
from its stories; a record that edits a member's priority to satisfy its own doctrine has inverted
the derivation and lost the warrant in the process.

**Why the record was opened now rather than held until a `Must` existed.** That was also put and
declined. The alternative leaves a cut story in no Story Summary, counted nowhere — which is the
exact argument that opened `project-management/src/03-SPRINTS/SPRINT-05.md` on 09/09/2026 for US008
and `project-management/src/03-SPRINTS/SPRINT-06.md` on 20/09/2026 for US010 — and
`project-management/src/02-STORIES/US011.md` already asserts this membership from its own side, so
holding the record would leave a story naming a record that does not exist. **Nothing in the tree
refuses a seventh record**, measured 20/09/2026 across `project-management/` and `.claude/`.

**An 8 SP `Should` has no other record to enter, and that is arithmetic rather than a call.**
Measured 20/09/2026:

| Record      | Stands at                             | With US011's 8 SP   | Reading                      |
| ----------- | ------------------------------------- | ------------------- | ---------------------------- |
| `SPRINT-01` | 10 / 11, CLOSED                       | 18 / 11             | Over grace                   |
| `SPRINT-02` | 8 / 11, CLOSED                        | 16 / 11             | Over grace                   |
| `SPRINT-03` | 8 / 11, or 13 / 11 with US003's carry | 16 / 11, or 21 / 11 | Over grace either way        |
| `SPRINT-04` | 13 / 11, at grace, CLOSED             | 21 / 11             | Over grace, from the ceiling |
| `SPRINT-05` | 13 / 11, at grace, CLOSED             | 21 / 11             | Over grace, from the ceiling |
| `SPRINT-06` | 8 / 11, closed, holding a reservation | 16 / 11             | Over grace, and displaces it |

The `SPRINT-06` row is the one that matters, because it is the record a reader will reach for first:
8 + 8 is 16 / 11, over both capacity and the 13 SP grace ceiling, **and** it would displace US009's
reserved carry. The two stories cannot share a record, which is what the slice split at
`02-story-creation` on 20/09/2026 produced and what both stories' own Dependencies sections already
state.

**The backlog register.** Every live record carries this table and the copies are identical; **this
record is `SPRINT-07`**. It became a live register on 17/09/2026, when US009 was placed into
SPRINT-05 — until that day it stood in three records only, four rows long, and was scoped to the
07/09/2026 cascade alone.

| Sprint      | Members, in build order                                         | SP                                                          |
| ----------- | --------------------------------------------------------------- | ----------------------------------------------------------- |
| `SPRINT-01` | US007 (`Must`, 5) then US001 (`Must`, 5)                        | 10 / 11 — closed                                            |
| `SPRINT-02` | US002 (`Must`, 3) then US003 (`Should`, 5, stretch)             | 8 / 11 — closed                                             |
| `SPRINT-03` | US004 (`Must`, 8), plus US003's reserved 5 SP carry if it slips | 8 / 11 — closed, holding a reservation; 13 / 11 if it lands |
| `SPRINT-04` | US005 (`Must`, 5) then US006 (`Must`, 8)                        | 13 / 11 — at grace, closed                                  |
| `SPRINT-05` | US008 (`Must`, 8) then US009 (`Should`, 5, stretch)             | 13 / 11 — at grace, closed                                  |
| `SPRINT-06` | US010 (`Must`, 8), plus US009's reserved 5 SP carry if it slips | 8 / 11 — closed, holding a reservation; 13 / 11 if it lands |
| `SPRINT-07` | US011 (`Should`, 8)                                             | 8 / 11 — open, `Must` tier absent                           |

Each record owns its own row, and **every record carries the whole table**: a membership or a
capacity change is written into every copy in the same change. It is maintained by hand — no gate
reads it, and that cost is filed in `GAPS.md` (17/09/2026). Rule:
`project-management/docs/planning/SPRINTS.md`. Obligation:
`project-management/src/03-SPRINTS/CLAUDE.md`.

<!-- This record's own row is the only one in the table whose SP cell states a posture rather than a
     closure: "open, `Must` tier absent". It is written that way because "8 / 11" alone would read
     as an ordinary under-filled sprint and hide the thing this record most needs a backlog reader
     to know. The register's other six rows are unchanged in meaning from 17/09/2026; the prose
     above lost its hardcoded count and the SPRINT-05 row was repaired, both at 03-sprint-planning
     on 20/09/2026 (Q4 and Q3) and both recorded in
     project-management/src/03-SPRINTS/SPRINT-06.md's own register comment rather than restated
     here. -->

**Capacity: 8 / 11 — inside capacity, 3 SP of headroom, and genuinely open.** Unlike
`project-management/src/03-SPRINTS/SPRINT-06.md`, whose 3 SP is spoken for by US009's reserved
carry, this record's headroom is unclaimed. `project-management/docs/planning/CADENCE.md` ->
_Sprint capacity — the trigger_ owns both figures as generation-time answers,
`SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`; in this template repository the table is unrendered and
the 11 and 13 every record uses are the `copier.yml` defaults. <!-- doc-references: template-only -->
`project-management/docs/planning/SPRINTS.md` -> _Capacity_ asks that an under-capacity sprint be
called out in the notes rather than padded; called out here, and the 3 SP is not padded with a story
cut to fill it.

**`Timeline: TBD`, so scope-against-duration is unmeasurable and is recorded as such.**
`project-management/workflows/03-sprint-planning/CHECKLIST.md` asks that "Scope is realistic for
the sprint duration"; with no dates that box has nothing to divide the points by, and **it is
marked unmeasurable rather than ticked**. No record in `project-management/src/03-SPRINTS/` has
ever carried a date, and inventing one here would put the only unmeasured figure in this file into
the line a reader trusts most. Per `code/docs/GATE-REPORTING.md` a check that could not run is
reported, never passed. It becomes answerable the moment a timeline is set.

**OPEN to admission, and what would change the position.** Each is <%DEVELOPER_NAME%>'s call at the
time, not this record's to pre-empt:

- **A `Must` of 3 SP or less supplies the tier this record lacks.** That is the admission this
  record is held open for. **At exactly 3 SP it lands the record on 11 / 11, which is not "inside
  capacity" but AT it** — `project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the
  trigger_ makes that the fill trigger, so such an admission closes this record and owes it a plan
  in the same breath. A `Must` of 1 or 2 SP goes in with headroom to spare and does not.
- **A `Must` of 5 SP** would stand it at 13 / 11 and at grace, with the `Should` tier still at 8.
  `project-management/docs/planning/CADENCE.md` is explicit that grace "exists for one situation —
  the next story would overshoot, and splitting it would produce two halves that make no sense
  alone", and that "a sprint that habitually runs to it means the capacity figure is wrong".
  **The threshold is on grace TAKEN, and two records have taken it** — SPRINT-04 (07/09/2026) and
  SPRINT-05 (17/09/2026). **A third is the signal**, which is the same threshold and the same
  population `project-management/src/03-SPRINTS/SPRINT-05.md` states in its own CLOSED paragraph;
  the two are cross-referenced rather than stated twice, and a `Must` of 5 SP here would be that
  third. Two further records — SPRINT-03 and SPRINT-06 — **licence** 13 against a reserved carry
  without having taken it, so four of the seven sit at or above the figure on paper. That looser
  count is context, **not a second threshold**: CADENCE's rule is about a sprint that habitually
  _runs to_ grace, and a carry that has not landed has run to nothing.
- **A second `Should` of any size** is refused. It deepens the defect rather than repairing it: a
  record with two droppable members and nothing to protect is not a sprint, it is a queue.
- **A `Must` of 8** is 16 / 11 and is refused on arithmetic before it is argued.

**A candidate that has not cleared the specify tier is not counted** (`CADENCE.md` -> _When a sprint
plan is written_: "resolve it or drop it back to the backlog rather than planning a sprint around
it"). The uncut slices on `MAP-REGISTER-INDEXES.md` — `S-03` and `S-04` — are the obvious candidates
for the `Must` this record wants, and **neither is a story**; this record pre-counts neither.
`project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md`, charted by a concurrent
session and untracked on 20/09/2026 at 21 open / 9 blocking, can produce no story and is likewise
not counted.

**No `07-SPRINT-PLAN-07.md` is written, and its absence is by rule, not omission.** The record's
ledger and the plan's count are two different numbers, and this record is at neither trigger.

- **The ledger counts every admitted story: 8.** A story is admitted at gate `03` and the ledger
  moves then. 8 of 11 is not the fill trigger.
- **The plan counts only stories that have cleared the specify tier: 0.** `CADENCE.md` -> _When a
  sprint plan is written_ names prerequisites that must hold for **every story in the filling
  sprint**, and US011 satisfies none: measured 20/09/2026 it has no ADR and records one ADR
  candidate in its own `## Decisions`; it is named by no artefact under
  `project-management/src/10-SECURITY/` or `project-management/src/11-QA/`; and it has no story
  plan, `11-` being a reserved number rather than a file.

`project-management/src/16-SPRINT-PLANS/CLAUDE.md` forbids a plan without a matching record — "do
not create an orphan plan" — and nothing forbids a record without a plan; that is a record's
ordinary state between opening and filling.

**The citation gate is inherited red, and this record adds its own findings to it — expected, not a
regression.** `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026` governs: the baseline is captured
before the first edit, read as a diff, and never reported as the gate passing while the baseline
stands. `copier.yml:157` excludes `/project-management/src/**`, so no record ships and the <!-- doc-references: template-only -->
shipped-file citation rule does not apply to one; that is `GAPS.md`'s entry of 02/09/2026, whose fix
is US004. <%DEVELOPER_NAME%> settled on 20/09/2026 that these findings **wait for US004** rather
than carrying interim `doc-references: template-only` markers. **Nothing is suppressed, and the figures are recorded rather than promised** — this
paragraph pointed at "the measured figures in the Verification Checks below" when none existed,
which an independent review on 20/09/2026 called correctly as worse than silence, and the numbers
below are the repair.

**Measured 20/09/2026, at HEAD `53d9196`, with the whole change staged.**
`bash code/src/scripts/audits/doc-references.sh --path project-management/src/03-SPRINTS` exits
`1` and reports **170 citations that do not resolve** across the folder — **142 instance, 27
dangling, 1 template-only, 0 plan-prefix**. Per file: `CONTEXT.md` 1 · SPRINT-01 17 · SPRINT-02
31 · SPRINT-03 31 · SPRINT-04 26 · SPRINT-05 18 · **SPRINT-06 23** · **SPRINT-07 23**.

**This record's own 23 are instance citations and nothing else — 0 dangling, 0 template-only.**
That matters twice. A `dangling` finding would be this record's own defect, a path it wrote that
does not resolve, and there are none. The `instance` class is the inherited one US004 fixes: a
record in house style cites artefacts by full path in backticks, which the gate does not flag, and
the bare `US###` and `SPRINT-##` names it does flag are unavoidable in a record whose subject is
stories and sprints.

---

## Acceptance Criteria

One outcome, one member.

**US011** — the four indexes `project-management/src/03-SPRINTS/SPRINT-06.md` shipped declaring
their own debt carry one row per instance, counted from the tree at implementation time and never
from the figure of 43 the story was cut against; each row's `Status` mirrors the artefact's own
value verbatim, read from the carrier that register actually uses — the bold `**Status:**` prose
line for `02-STORIES`, `03-SPRINTS` and `15-DECISIONS`, the backticked table cell for
`17-STORY-PLANS` — with no register's vocabulary translated into another's; `DECISION-INDEX.md`
carries the `Supersedes` / `Superseded by` tail US010 designed, with every `Superseded` ADR naming
its replacement and no chain dangling; the one ADR whose status value carries a trailing HTML
comment is handled and its divergence from `N-003`'s string-equality clause recorded, **without
that ADR being edited**; each index honours the ordering rule its own file states; the
`Backfill owed — US011` line is gone from all four files and from nothing else, with
`FINDING-INDEX.md` and `BUG-INDEX.md` untouched; and a generated project still receives all four
blank, with no syntek-base literal in any of them and no leak reported by
`.github/scripts/shipped-artefacts.sh`.

### Security Acceptance Criteria — N/A

<!-- REMOVED BY FLAG, and the removal is stated rather than silent. The sprint's Security row reads
     N/A because its sole member's does, and the template says to remove this section when it does.
     Per code/docs/GATE-REPORTING.md a removed section reads as a gate that did not apply — which is
     correct here, and is why this comment stands in its place rather than a checklist of rows
     nothing would bind.

     WHAT THE N/A DOES NOT MEAN. It does not mean the member is risk-free: it writes 43-odd real
     syntek-base rows into files whose seeds must stay blank, and a leak would be permanent. It
     means the control for that hazard is built, gated and owned ELSEWHERE — US010's `ST03` and
     `ST04` and its enlarged `SEEDED` array, in
     project-management/src/03-SPRINTS/SPRINT-06.md — and that this member exercises it rather than
     adding to it. The assertion that would catch a regression is the first QA row below, and it is
     deliberately an integration criterion rather than a security one. If `10-security-checks` reads
     it differently, the member's flag changes, this union changes with it, and this section is
     written. -->

### QA Acceptance Criteria — Automated

<!-- First-pass from the manifest; no QA-PLAN-US011-* exists under
     project-management/src/11-QA/PLANNING/ on 20/09/2026. Rewritten at gate 11's close. -->

- [ ] The `[3/4] Template Generation` job generates a project on **both** answer sets
      (`INCLUDE_MOBILE` false and true) and a grep over each generated tree finds no `US###`,
      `SPRINT-##`, `ADR-US###` or `STORY-PLAN-US###` literal inside any index file
- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` passes **unchanged** — this sprint
      adds no registration and must not need one; a change here means an index moved or a seed was
      polluted
- [ ] `bash code/src/scripts/audits/doc-references.sh` — every one of the 43-odd links this sprint
      writes resolves; read as a diff against the baseline per ADR-US003 and never as a bare pass
- [ ] `bash code/src/scripts/audits/docs-length.sh` passes — the four indexes are register artefacts
      under `src/` and exempt from the 300-line ceiling, but the audit is run so the **exemption is
      proved rather than assumed**
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` passes
- [ ] Coverage floors — **N/A**, and marked rather than deleted. The member ships Markdown only; the
      Backend flag reads `N/A` and no Python is added, so the floor has nothing to bind

### QA Acceptance Criteria — Manual

<!-- Manual is the load-bearing half here, not the residue. No script can judge whether one line of
     plain English describes an ADR to someone who has not read it, and that bar is `N-002`'s. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US011-MANUAL-TESTING.md` carries a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in the member's QA plan — which gate `11` has
      yet to write; until it exists this row cannot be ticked, and its absence is not a pass

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Measurement and Backfill Tasks

<!-- The template has no documentation-tasks section and this sprint's deliverable is entirely
     documentation, so its work is carried here on SPRINT-05's precedent, which carried US008's
     five-guide rewrite under its Backend Tasks. -->

| Story | Task                                                                                                                                | Done |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US011 | Re-count the instances in all four registers against `N-003`'s instance test and record the count with its date — do not inherit 43 | [ ]  |
| US011 | Confirm `20-FINDINGS` and `21-BUGS` still hold zero; if not, hand back to US010's presence clause rather than absorbing it          | [ ]  |
| US011 | Read each register's status carrier and confirm it is still the one measured 20/09/2026 — three prose lines, one table cell         | [ ]  |
| US011 | Fill `STORY-INDEX.md` — one row per `US###.md`, ascending by identifier                                                             | [ ]  |
| US011 | Fill `SPRINT-INDEX.md` — one row per `SPRINT-##.md`, ascending by number                                                            | [ ]  |
| US011 | Fill `DECISION-INDEX.md` — ascending by identifier, with the `Supersedes` / `Superseded by` tail filled for every chain             | [ ]  |
| US011 | Fill `STORY-PLAN-INDEX.md` — ascending by identifier, status read from the table cell with the backticks stripped                   | [ ]  |
| US011 | Write every `Summary` for a reader who has not opened the artefact — never the filename restated                                    | [ ]  |
| US011 | Remove the `Backfill owed — US011` line from all four files, and from nothing else                                                  | [ ]  |
| US011 | Record the trailing-HTML-comment divergence on the one ADR, the reading taken, and why that ADR was not edited                      | [ ]  |
| US011 | Update each touched `CONTEXT.md`'s `**Last Updated**` date where its index section's wording changes                                | [ ]  |
| US011 | **Verify, do not re-cut** the `S-05` row on `MAP-REGISTER-INDEXES.md`; if a cell has drifted, repair it and say so                  | [ ]  |

### Security Tasks — N/A

<!-- Removed by flag, and stated rather than silent — the sprint's Security row reads N/A. The
     seed-purity work this sprint depends on is US010's, listed in
     project-management/src/03-SPRINTS/SPRINT-06.md -> Security Tasks, and duplicating it here would
     put one obligation in two records. What this sprint owes is the assertion that it did not
     regress that control, and that is the first QA row above. -->

### QA Tasks — Automated

- [ ] US011 — add the generated-tree grep for the four registers' literals to the generation job, on
      **both** `INCLUDE_MOBILE` poles
- [ ] US011 — run `shipped-artefacts.sh --self-test` and confirm it needs **no** edit, with the
      result recorded in `project-management/src/18-TESTS/US011-TEST-STATUS.md`
- [ ] US011 — run `doc-references.sh`, `docs-length.sh` and `docs-pairing.sh` over the changed tree

### QA Tasks — Manual

- [ ] US011 — row-by-row walk-through of all four indexes against their folders, recorded: every
      instance present, no orphan rows, every `Status` string-equal to the file's, every `Updated`
      date correct
- [ ] US011 — summary legibility pass: every `Summary` read by someone who has not opened the
      artefact and confirmed to convey what it is — a filename restated in prose fails
- [ ] US011 — supersession-chain walk across `DECISION-INDEX.md`, end to end, recorded
- [ ] US011 — the re-measured population recorded beside the cut-time figure of 43, with its date,
      so the drift between cutting and building is visible
- [ ] US011 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint's Frontend,
      Components and Wireframes rows read `N/A`; no page, component or interactive surface is added

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The checks with nothing to look at are marked N/A with a reason rather than deleted: per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. This sprint ships Markdown
     only — no Python, no bash, no YAML — so it is the thinnest verification surface any record here
     has carried, and the rows that survive are stated rather than assumed. -->

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` exits 0 and is **unchanged** — this
      sprint registers nothing new, and a diff in that script is a signal rather than a pass
- [ ] **The `[3/4] Template Generation` job is green on both answer sets** — the four backfilled
      indexes carry no instance rows in either generated tree
- [ ] `bash code/src/scripts/audits/doc-references.sh --path project-management/src/03-SPRINTS`
      — **the scoped run, and the one this record was measured on.** At the gate that opened this
      record (20/09/2026, HEAD `53d9196`, whole change staged) it exits `1` with **170** citations
      that do not resolve across the folder — 142 instance, 27 dangling, 1 template-only, 0
      plan-prefix — of which **this record contributes 23, all of them the inherited instance
      class and none of them dangling**. The Notes carry the per-file split. **The criterion for
      this sprint is that this record's `dangling` count stays at 0**: a dangling finding is a path
      this record wrote that does not resolve, and it is the only class here that would be this
      record's own defect. The scoped run completes in about 45 seconds, so there is no excuse for
      reporting it unmeasured
- [ ] `bash code/src/scripts/audits/doc-references.sh` (whole tree) — **read as a diff against the
      baseline captured before the first edit**, per ADR-US003, and never as a bare pass while that
      baseline stands. This sprint writes 43-odd new links and every one must resolve; a rise in the
      `dangling` class is this sprint's own defect, while a rise in `instance` is the inherited
      class US004 fixes. **The two are distinguished in the report, not aggregated.** Measured
      20/09/2026 staged, this record's dangling count is **0**. **The whole-tree pass was NOT RUN at
      the gate that opened this record** — it takes over ten minutes against the scoped run's 45
      seconds — and per `code/docs/GATE-REPORTING.md` that is reported rather than inferred away
      from the folder figure above
- [ ] `bash code/src/scripts/audits/docs-length.sh` — run to **prove the register-artefact
      exemption** rather than assume it. The four indexes grow by 43-odd rows between them and are
      exempt from the 300-line ceiling as `src/` register artefacts; the exemption is the gate's to
      confirm. No `CONTEXT.md` grows by more than a date in this sprint
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; the member creates no
      directory and edits existing pairs' `**Last Updated**` dates at most
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only. A green run says the
      registered claims are undisturbed and says **nothing** about a row's `Status` matching the
      artefact it names; that is the manual row-by-row walk-through's job and is never reported as
      though the gate had done it
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, the member adds no routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — markdownlint-cli2 over the four backfilled
      indexes. **No ShellCheck caveat applies to this sprint**, unlike SPRINT-05 and SPRINT-06: the
      member changes no shell script, so the gap between `lint.sh`'s legs and what a bash change
      needs is not reached here
- [ ] `bash code/src/scripts/syntax/check.sh` passes — **regression only.** Its basedpyright leg
      reads Python and this sprint adds none; run so the absence is measured rather than assumed
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, the sprint's DB flag reads `N/A`
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — the suite runs as a regression and passes;
      the coverage floor has nothing to bind, the sprint adding no Python
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A**, the sprint's Security flag reads `N/A`
      and the section above records what that does and does not mean. The seed-purity control it
      leans on is signed off in `project-management/src/03-SPRINTS/SPRINT-06.md`, not here
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** —
      **N/A**, and marked rather than deleted. This record has **no `Must` tier**; the row is kept so
      that its emptiness is read as the known gap recorded in the Notes rather than as a criterion
      quietly satisfied. Per `code/docs/GATE-REPORTING.md`, a removed row reads as a gate that did
      not apply, and this one applies with nothing to bind
- [ ] **The sole member is disposed of in writing, on whichever branch it takes — and exactly one
      branch is taken.** **DELIVERED:** US011 is marked **Completed**, and every row below headed
      _deliver branch_ binds as written. **DROPPED:** the drop and its reason are recorded in three
      places in the same change — here, in `project-management/src/02-STORIES/US011.md`, and in the
      backlog register in every copy. **There is no `SPRINT-08` to reserve the 8 SP into**, and this
      record does not invent one: the reservation is recorded as **owed and unplaced**, and is named
      the moment a receiving record is opened — the discipline
      `project-management/src/03-SPRINTS/SPRINT-05.md` had to be corrected into on 20/09/2026, its
      own "the next record" having been written against a record that did not exist. On that branch
      every row below headed _deliver branch_ reads **N/A — dropped**, with the drop as its reason.
      **A `Should` is never dropped silently, and an empty sprint is a closed sprint only when the
      drop is written into all three places** — the rows the branch turns `N/A` are marked, not
      deleted, per `code/docs/GATE-REPORTING.md`

- [ ] **If a `Must` is admitted during the sprint, the Must-tier row — the FIRST row of this
      section — ceases to be `N/A` and governs from that moment**, and this row records what else
      moves with it: every `Must Have` story is individually **Completed**; **US011 stops being "the
      sole member"** and the row above is re-read with it as the stretch tier — the first work
      dropped if the `Must` overruns, and dropping it does not fail the sprint, so on that reading
      the drop branch no longer empties the record; and the FLAGS table, the capacity line, the
      Notes' admission bullets and the backlog register are all recomputed in the same change.
      **Until a `Must` is admitted this row binds nothing** — it is written now so that the
      admission this record is held open for does not arrive with its consequences unstated
- [ ] **US010 landed before this sprint's member started.** Confirmed rather than assumed: the four
      indexes exist, carry their `Backfill owed — US011` line, and their tails and ordering rules are
      the ones US010 designed. If any of that is absent this sprint cannot start, and the blocking
      edge is recorded in `project-management/src/03-SPRINTS/SPRINT-06.md` from the other side
- [ ] All sprint-level acceptance criteria met and verified by a reviewer — _deliver branch_. The
      Acceptance Criteria section holds exactly one outcome, US011's, so on the drop branch this
      row reads **N/A — dropped**
- [ ] All sprint-level tasks checked off — _deliver branch_. Every task row in this record is keyed
      `US011`, so on the drop branch this row reads **N/A — dropped**
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in the member's QA plan — once gate `11` has
      written it. _Deliver branch_: gate `11` may never run on a dropped story, so on the drop
      branch this row reads **N/A — dropped, gate 11 not entered**, which is a skip and never a pass
- [ ] The QA row of the FLAGS table, and the sections it governs, were recomputed when gate `11`
      closed, and the union still equals US011's table. **The Security row is re-asked at gate `10`
      rather than assumed to stay `N/A`** — the member's own flag names that gate as the one entitled
      to overturn it. _Deliver branch_; on the drop branch neither gate runs and this row reads
      **N/A — dropped**. If a `Must` was admitted, the union is that story's unioned with US011's
      and this row binds against both
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)
