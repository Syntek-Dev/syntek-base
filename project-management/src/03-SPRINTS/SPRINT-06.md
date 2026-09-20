# SPRINT-06

**Last Updated**: 20/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Every register folder gains an index file of its own, born seeded and seed-once so no
`copier update` can overwrite a filled one; the feature-map index is backfilled and leaves the
`CONTEXT.md` that ships; and the six shipped sites still instructing the old index row stop doing
so.

<!-- Derived from the title and Client Summary of US010, the sole member, and from the deliverable
     column of the narrowed slices `S-01` and `S-02` on
     project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md — the derivation
     project-management/src/03-SPRINTS/SPRINT-03.md used on 07/09/2026 for a record with one
     member, and project-management/src/03-SPRINTS/SPRINT-05.md on 09/09/2026.

     Narrow by construction. The Register Indexes epic has five slices and this goal names two:
     `S-03` (the gate that reads these files) and `S-04` are uncut and belong to no record, and
     `S-05` is US011's, in project-management/src/03-SPRINTS/SPRINT-07.md. A goal naming their
     deliverables would be the drift project-management/src/03-SPRINTS/SPRINT-02.md recorded on
     05/09/2026 and SPRINT-03 on 07/09/2026. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 / 11 SP** — inside capacity, all-`Must`, and **closed to
admission, holding a reservation**: `project-management/src/03-SPRINTS/SPRINT-05.md` reserves
US009's 5 SP `Should` carry to this record, and if it lands this sprint is **13 / 11 SP** and at
grace. The grace is deliberately available for that carry and for nothing else
(<%DEVELOPER_NAME%>'s call at `03-sprint-planning`, 20/09/2026). See Notes.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 20/09/2026 on US010's admission at opening — the union over one member is that
     member's table, copied verbatim from project-management/src/02-STORIES/US010.md. Two rows
     carry values: Security carries the two seed-once subjects the story set at cutting, and QA
     names unit, integration and manual types. Eleven rows stay N/A: no model, no screen, no
     personal-data path, no public page, no Ninja surface, no log line, and — unlike
     project-management/src/03-SPRINTS/SPRINT-05.md — no Python either, the member shipping
     Markdown, YAML and one bash array.

     THE RESERVATION CONTRIBUTES NOTHING TO THIS UNION, and that is the rule rather than an
     oversight. project-management/docs/planning/SPRINTS.md computes the union FROM the Story
     Summary, and a reserved carry is not in it until it lands. If US009 arrives, this table is
     recomputed against project-management/src/02-STORIES/US009.md in the same change that admits
     it — which would widen Security with that story's supply-chain subject and add its subjects
     to QA without changing QA's types, US010 already naming unit, integration and manual. Measured
     20/09/2026: every other row reads N/A in BOTH stories, Backend included — US009 ships bash and
     one JSON manifest read, so its own Backend row is N/A, and the union would stay N/A. That
     differs from project-management/src/03-SPRINTS/SPRINT-05.md, whose Backend reads Yes on
     US008's settings modules alone.

     THESE ARE FIRST-PASS VALUES. On 20/09/2026 no artefact under
     project-management/src/10-SECURITY/ or project-management/src/11-QA/ names US010, and it has
     no story plan. project-management/docs/planning/CADENCE.md's rule is that the flag is a
     manifest and the gate owns the design, so the Security and QA rows here are recomputed when
     gates `10` and `11` close, on the precedent SPRINT-01 set when QA-PLAN-US001 AC-GAP-6 moved
     its QA row. Per code/docs/GATE-REPORTING.md these are gates not yet entered, reported as
     such — not gates that found nothing. -->

| Flag       | Value                                                                                                                                                                                                                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                                                                                         |
| User Flow  | N/A                                                                                                                                                                                                                                                                                         |
| Brand      | N/A                                                                                                                                                                                                                                                                                         |
| Components | N/A                                                                                                                                                                                                                                                                                         |
| Wireframes | N/A                                                                                                                                                                                                                                                                                         |
| GDPR       | N/A                                                                                                                                                                                                                                                                                         |
| Security   | seed-once integrity — all seven `_tasks` `mv` lines inside the existing `copy` gate, so no `copier update` can overwrite a project's filled index with a blank stub; no seed cut from a populated in-tree index                                                                             |
| QA         | unit, integration, manual — `shipped-artefacts.sh --self-test` (seed-lands, seed-deleted); generation smoke on both `INCLUDE_MOBILE` answer sets; update-does-not-overwrite; row-per-map and counts-match-header; the four instruction sites and the two template sites re-read as repaired |
| SEO        | N/A                                                                                                                                                                                                                                                                                         |
| API        | N/A                                                                                                                                                                                                                                                                                         |
| Logging    | N/A                                                                                                                                                                                                                                                                                         |
| Backend    | N/A                                                                                                                                                                                                                                                                                         |
| Frontend   | N/A                                                                                                                                                                                                                                                                                         |

<!-- THE COPIER DELIMITERS ARE NOT REPRODUCED ANYWHERE IN THIS FILE, and the omission is
     deliberate. `.github/scripts/check-template-tokens.sh` scans every non-exempt tracked file for
     the copier delimiter pair and fails anything between them that is not a bare upper-snake token
     name, which a quoted copier conditional is not. Its exemption list covers `project-management/src/01-FEATURE-MAPS/` but not
     `02-STORIES/` or `03-SPRINTS/`, and widening it would be wrong rather than merely bold: the
     `_exclude` re-includes mean `**/CONTEXT.md`, `**/CLAUDE.md` and `**/*TEMPLATE*` under that tree
     DO render, so a blanket folder exemption would stop gating files that genuinely ship. The gate
     has no way to say "this is a quoted example in a file that cannot render", so the `when:` key
     and its condition are named without the delimiters around them — and THIS COMMENT does not
     reproduce them either, which is why it describes the pair rather than showing it. The same
     technique US011 used for a literal HTML comment terminator on the same day. Measured 20/09/2026, when the
     pre-commit hook blocked on four sites across this file and the sprint record. -->

---

## Story Summary

| ID    | Title                                                                                    | MoSCoW    | SP  |
| ----- | ---------------------------------------------------------------------------------------- | --------- | --- |
| US010 | The seven register indexes are born seeded, and the map index leaves the file that ships | Must Have | 8   |

**Total:** 8 SP — all committed, no stretch tier at opening. **US009's 5 SP `Should` carry is
reserved to this record from `project-management/src/03-SPRINTS/SPRINT-05.md`**; if it arrives the
total is 13 SP, 8 committed and 5 stretch. It is not counted until it does.

<!-- US010 is added to this table rather than referenced from it because
     project-management/docs/planning/SPRINTS.md computes the flag union and the capacity FROM this
     table, and a story in no Story Summary is counted nowhere — SPRINT-04's reading of 07/09/2026.
     US010 sits in no other record's table; its own `**Status:**` reads `Open`, and this record
     moves it nowhere.

     The reservation is deliberately NOT a row. project-management/src/03-SPRINTS/SPRINT-03.md set
     the shape on 07/09/2026 when the same conditional arrived there from SPRINT-02: the carry is
     stated in prose beneath the table and in the Definition of Done, and it enters the table only
     if it lands. A conditional row would be counted by the union and the capacity arithmetic as
     though it were certain. -->

## Dependencies

- **US010 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slices `S-01` and the narrowed
  `S-02`, nodes `N-001`, `N-002`, `N-005` and `N-006`, all settled 31/08/2026 on a map whose
  frontier is empty. That map's `Gate to stories` records a deadlock ruling naming the slice by
  number — "`S-01` may be cut on that basis; the box closes when `S-01` ships" — and the ruling was
  exercised at `02-story-creation` on 20/09/2026. Its place tenth in the build order is arithmetic,
  not a blocker, stated so that nobody goes looking for one.
- **US010 unblocks US011, and `project-management/src/03-SPRINTS/SPRINT-07.md` says so from the
  other side.** US011 backfills four index files this story creates and has nothing to edit until
  they exist. The edge is stated in both records and in both stories so a later reader cannot
  re-merge the two halves of a slice that was split at `02-story-creation`.
- **`MAP-REGISTER-INDEXES.md` `S-03` — the gate that reads these files — ships after this sprint,
  not before.** `N-003` asserts presence, symmetry and status over the seven indexes and cannot run
  until they exist. Named so the absence of a gate in this sprint is read as sequencing rather than
  omission. This record schedules no part of `S-03`, and `S-04` likewise belongs to no record.
- **US010 does not block on US004, and the reason is the one SPRINT-04 recorded for US006 and
  SPRINT-05 for US008.**
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` is a
  reporting regime — "A story cannot be blocked on a gate it is forbidden to repair" — binding every
  story until `doc-references.sh` goes green; it sequences nothing. See Verification Checks.
- **US010 shares no file with any placed story.** Verified 20/09/2026 at cutting against US001 to
  US009, all `Status: Open`: none of them writes `copier.yml`'s `_tasks` list,
  `.github/scripts/shipped-artefacts.sh`'s `SEEDED` array, `.claude/skills/wayfinder/SKILL.md`, or
  any `CONTEXT.md` under `project-management/src/`. One adjacency is ordered rather than blocked:
  the story edits seven `CONTEXT.md` files under `project-management/src/`, and
  `code/src/scripts/audits/CONTEXT.md` — US002's headroom — is **not** among them.
- **A concurrent session is charting
  `project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md`**, untracked as of
  20/09/2026 and at 21 open / 9 blocking, so it can produce no story and enters no record. It is not
  a blocker — US010 indexes whatever maps exist when it is built, and no criterion in that story
  holds a literal count — but `.ai/INSTRUCTIONS.md` requires shared-artefact ownership to be
  coordinated, and `project-management/src/01-FEATURE-MAPS/` is shared between the two sessions.
- **Sprint numbering and build order agree, and that was checked rather than copied.** The settled
  build order is the prefix on each plan in `project-management/src/17-STORY-PLANS/` — `01-` US007,
  `02-` US001, `03-` US002, `04-` US003, `05-` US004, `06-` US005, `07-` US006, `08-` US008, `09-`
  US009, nine plans on disk on 20/09/2026 — and US010 builds tenth, behind SPRINT-05's last member.
  The next free prefix is `10-`, and that number is **reserved, not a plan**: `17-story-plans`
  writes it, and nothing here may cite it as one (SPRINT-04's rule for US006's `07-`, which has
  since been written). Nothing is renumbered:
  `project-management/docs/planning/STORIES.md` makes the prefix the position in the settled build
  order across the whole backlog and renumbers it whenever that order changes, and appending US010
  at the end changes no other story's position. When `16-sprint-plans` writes this sprint's plan,
  both segments of `{exec-order}-SPRINT-PLAN-{sprint-number}.md` read `06`.
- **One thing may carry into this record, and it is named rather than assumed.**
  `project-management/src/03-SPRINTS/SPRINT-05.md` -> Definition of Done reserves US009's 5 SP
  `Should` carry here if it is dropped rather than delivered. Nothing else can: SPRINT-01, SPRINT-02
  and SPRINT-04 are closed with nothing reserved out of them, and SPRINT-03 holds US003's
  reservation which runs into SPRINT-03, not out of it.
- **`Blocked` is a story status, not a sprint one.** US010 waits on nothing, so no story
  `**Status:**` moves on account of this record.

## Notes

**This record opens holding one all-`Must` member, which is the shape declined on 07/09/2026, and
it is opened knowing that — for the second time, on the same arithmetic that opened
`project-management/src/03-SPRINTS/SPRINT-05.md` on 09/09/2026.** What was declined is recorded in
`project-management/src/03-SPRINTS/SPRINT-04.md` -> Notes: the alternative to taking grace there
was a fifth record holding US006 alone, "a single-member all-`Must` sprint, the shape SPRINT-03
called 'this sprint's one real weakness' on opening", and <%DEVELOPER_NAME%> "chose the grace over
that". **Nothing in the tree refuses a sixth record.** That was measured on 20/09/2026 rather than
assumed: a search across `project-management/` and `.claude/` for a statement refusing a sixth or
seventh record returns none, and the three standing refusals SPRINT-05 had to date on opening were
each scoped to a fifth record in the 07/09/2026 cascade. `05-SPRINT-PLAN-05.md` -> _Won't (this
sprint)_ refuses **a third story into SPRINT-05**, which is a different refusal and stays true.

**The objection does not transfer, and the arithmetic says why.** Every record is closed to
admission, and an 8 SP `Must` clears none of them. Measured 20/09/2026:

| Record      | Stands at                             | With US010's 8 SP   | Reading                      |
| ----------- | ------------------------------------- | ------------------- | ---------------------------- |
| `SPRINT-01` | 10 / 11, CLOSED                       | 18 / 11             | Over grace                   |
| `SPRINT-02` | 8 / 11, CLOSED                        | 16 / 11             | Over grace                   |
| `SPRINT-03` | 8 / 11, or 13 / 11 with US003's carry | 16 / 11, or 21 / 11 | Over grace either way        |
| `SPRINT-04` | 13 / 11, at grace, CLOSED             | 21 / 11             | Over grace, from the ceiling |
| `SPRINT-05` | 13 / 11, at grace, CLOSED             | 21 / 11             | Over grace, from the ceiling |

An 8 SP `Must` story has no record to enter, and the only alternative is a `Must` story in no Story
Summary, counted nowhere. That is arithmetic rather than a call, and it is recorded as arithmetic —
the way SPRINT-03 recorded US006's refusal on 05/09/2026 and SPRINT-05 recorded US008's on
09/09/2026.

**The backlog register.** Every live record carries this table and the copies are identical; **this
record is `SPRINT-06`**. It became a live register on 17/09/2026, when US009 was placed into
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

<!-- THE REGISTER'S PROSE NO LONGER CARRIES A COUNT, settled at 03-sprint-planning on 20/09/2026
     (Q4). Every copy read "all five copies are identical" and "written into all five in the same
     change" from 17/09/2026 until that day, and this change would have made it seven — buying the
     same defect again at SPRINT-08. project-management/docs/planning/SPRINTS.md's own rule was
     already count-free ("written into every copy in the same change") and the records had added a
     count it never had; the wording above is the guide's. The table is where the count lives.
     project-management/src/03-SPRINTS/CLAUDE.md's "All five carry the same backlog register" was
     corrected in the same change, and the dated comment in
     project-management/docs/planning/SPRINTS.md is left alone: it describes the 17/09/2026
     decision as it was taken and is history rather than a live claim.

     THE SPRINT-05 ROW WAS STALE IN ALL FIVE COPIES AND IS REPAIRED HERE BEFORE IT PROPAGATES.
     It read "US009 (`Should`, 3, stretch)" and "11 / 11 — at capacity, closed" while
     project-management/src/03-SPRINTS/SPRINT-05.md's own capacity line read 13 / 11 at the grace
     ceiling: US009's re-estimate from 3 to 5 SP on 17/09/2026 moved that record's header, Story
     Summary and Total and never reached the register. All five copies agreed with each other and
     all five disagreed with their source. That is `GAPS.md`'s 17/09/2026 gap firing three days
     after it was filed, and on an axis its own proposed repair could not see — a script that
     compares copies to one another would have stayed green. Noted in that entry on 20/09/2026. -->

**Capacity: 8 / 11 — inside capacity, all committed, and under capacity by 3 SP, called out rather
than padded.** `project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_
owns both figures as generation-time answers, `SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`, rendered
into its table per project; in this template repository the table is unrendered, and the 11 and 13
every record here uses are the `copier.yml` defaults for those two answers. <!-- doc-references: template-only -->
The same section reads: "Capacity is a **trigger**, not a target to fill exactly." This sprint
lands on 8 because the only other cut story is an 8 SP `Should` that cannot fit beside it, which is
the same case. `project-management/docs/planning/SPRINTS.md` -> _Capacity_ asks that an
under-capacity sprint be called out in the notes rather than padded; called out here.

**`Timeline: TBD`, so scope-against-duration is unmeasurable and is recorded as such.**
`project-management/workflows/03-sprint-planning/CHECKLIST.md` asks that "Scope is realistic for
the sprint duration"; with no dates that box has nothing to divide the points by, and **it is
marked unmeasurable rather than ticked**. No record in `project-management/src/03-SPRINTS/` has
ever carried a date, and inventing one here would put the only unmeasured figure in this file into
the line a reader trusts most. Per `code/docs/GATE-REPORTING.md` a check that could not run is
reported, never passed. It becomes answerable the moment a timeline is set.

**CLOSED to further admission, and the 3 SP of headroom is not free — it is spoken for.**
`project-management/src/03-SPRINTS/SPRINT-05.md` -> Definition of Done reserves US009's 5 SP
`Should` carry to this record. **That reservation is larger than the headroom**, and the arithmetic
is `project-management/src/03-SPRINTS/SPRINT-03.md`'s exactly: 3 SP under capacity plus the 2 SP of
grace above it are together exactly the carry's 5. <%DEVELOPER_NAME%> settled at
`03-sprint-planning` on 20/09/2026 (Q7) that the grace is deliberately available for that carry and
for nothing else — so a record reading "open" while every point in it is claimed would be the drift
the register exists to prevent. Closed by decision, on SPRINT-01's precedent of 07/09/2026 and
SPRINT-03's of 05/09/2026: a ledger is closed by a call, not only by a ceiling.

**The all-`Must` weakness stands, and this record has no give it can honestly hold.**
`project-management/docs/planning/SPRINTS.md` is explicit: "**Avoid a plan where everything is
Must.** If every story is Must, the sprint has no give and the first surprise breaks it." The repair
SPRINT-05 eventually used — admitting a `Should` as a stretch tier — is unavailable here on
arithmetic rather than preference. **The backlog holds three `Should` stories, measured 20/09/2026,
and not one of them can be this record's give.** US003 is SPRINT-02's stretch with its carry
reserved into SPRINT-03 — placed, and moved twice already. US009 is SPRINT-05's stretch, and its
5 SP is **already** reserved forward into this record, so admitting it as give would double-count
the one conditional this record holds. US011 is unplaced only in the sense that its own record is
opened in the same change; at 8 SP it would stand this record at 16 / 11 and is refused on
arithmetic before it is argued. Cutting a third story to fill the room is the padding `SPRINTS.md` -> _Capacity_ tells a
record to call out instead. **What partly answers it is the reservation**: if US009 is dropped from
SPRINT-05 it arrives here as a 5 SP `Should`, and this record would then have the droppable work
whose absence is the defect — at 13 / 11, the shape SPRINT-03 has held since 07/09/2026. Until then
the weakness is real and is recorded the way SPRINT-03 recorded it on 07/09/2026 and SPRINT-05 on
09/09/2026: "the weakness stands, and this record has no other give it can honestly hold".

**No `06-SPRINT-PLAN-06.md` is written, and its absence is by rule, not omission.** The record's
ledger and the plan's count are two different numbers, and this record is at neither trigger.

- **The ledger counts every admitted story: 8.**
  `project-management/docs/planning/SPRINTS.md` -> _Two artefacts, two moments_ makes the record
  "the running ledger", opened early, and `CADENCE.md`'s per-story loop runs gate `03` second, so a
  story is admitted at cutting and the ledger moves then. 8 of 11 is not the fill trigger.
- **The plan counts only stories that have cleared the specify tier: 0.** `CADENCE.md` -> _When a
  sprint plan is written_ names the prerequisites that must hold for **every story in the filling
  sprint** — `15-decisions` cleared, GDPR review, security threat model and assessment, a QA plan
  with no unresolved `AC-GAP`, an SEO plan or `SEO: N/A` with a reason, an API contract or no Ninja
  surface — and closes: "A story that cannot satisfy these is **not ready to be counted towards the
  sprint**." US010 satisfies none of them.

Measured 20/09/2026. US010 has no ADR and records two ADR candidates in its own `## Decisions` for
`15-decisions` to accept or decline; it is named by no artefact under
`project-management/src/10-SECURITY/` or `project-management/src/11-QA/`, both of which its flags
say it enters; and it has no story plan, `10-` being a reserved number rather than a file. GDPR,
SEO, API, Logging, DB, Backend and Frontend are skipped by flag.
`project-management/src/16-SPRINT-PLANS/CLAUDE.md` forbids a plan without a matching record — "do
not create an orphan plan" — and nothing forbids a record without a plan; that is a record's
ordinary state between opening and filling.

**This record was opened at gate `03`, not after `10`, `11` and `15`, on SPRINT-05's precedent of
09/09/2026.** SPRINT-03 and SPRINT-04 opened after their members had cleared the specify tier,
because gates `10` and `11` supply the Security and QA sections. This one opens now because the
alternative is a `Must` story in no Story Summary, counted nowhere. The cost is the one the FLAGS
comment names: the Security and QA sections below are first-pass values from the manifest, each
rewritten at its gate's close.

**The citation gate is inherited red, and this record adds its own findings to it — expected, not a
regression.** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
governs: the baseline is captured before the first edit, read as a diff, and "never reported as the
gate passing while the baseline stands". The class is `instance citation` — a record in house style
cites artefacts by full path in backticks, which is not what the gate flags; the bare `US###` and
`SPRINT-##` names are. `copier.yml:157` excludes `/project-management/src/**`, so no record ships <!-- doc-references: template-only -->
and the shipped-file citation rule does not apply to one; that is `GAPS.md`'s entry of 02/09/2026,
whose fix is US004. <%DEVELOPER_NAME%> settled on 20/09/2026 that these findings **wait for US004**
rather than carrying interim `doc-references: template-only` markers. **Nothing is suppressed, and the figures are recorded rather than promised** — this
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

**The figure is index-dependent, and the index state is part of the number.** The gate decides
whether a citing file ships in `build_template_only`, which reads `git ls-files`: an untracked file
is not recognised as copier-excluded, `file_ships` stays true, and every citation it makes of a
per-project artefact is reported as template-only. Every figure above is measured with the whole
change staged, and a re-measurement is only comparable in that state — SPRINT-05's finding of
09/09/2026, which measured 21 untracked and 6 staged.

**This change demonstrated it again, and the numbers are recorded because they are the proof.**
Unstaged on 20/09/2026 this record measured **19** template-only findings and
`project-management/src/03-SPRINTS/SPRINT-07.md` **4**; staged, both read **0**. Those 23 were the
artefact of the index and never citations either record owed. An independent review measured the
unstaged state and reported them, which is the correct reading of what it saw — the index state is
part of the number, and a figure quoted without it is not comparable to one that has it.

---

## Acceptance Criteria

One outcome, one member.

**US010** — the seven registers that accumulate instances each carry an index file named for the
folder's own noun, singularised, sharing one spine of `Status · Instance · Summary · Updated` and
stating its own tail columns and ordering rule; `MAP-INDEX.md` carries one row per map counted from
the tree at implementation time, and every map's `**Status**` header begins with one of the four
enum values separated from any existing prose by a middle dot rather than an em-dash; the four
indexes this story does not backfill ship declaring their own debt and naming US011, while
`FINDING-INDEX.md` and `BUG-INDEX.md` are legitimately empty and name nothing; a generated project
receives all seven blank, seeded once inside the existing `copy` gate so no `copier update` can
overwrite a filled one, with `.github/scripts/shipped-artefacts.sh` admitting all seven; the map
index leaves `project-management/src/01-FEATURE-MAPS/CONTEXT.md` and every register's `CONTEXT.md`
routes to its own index; and the six shipped sites that still instruct the old index row stop doing
so, all three decline rationales disposed of rather than only the one with an owner.

### Security Acceptance Criteria

<!-- The template's rows name runtime controls — rate limits, audit rows, HTML escaping, ABAC — and
     the member ships Markdown, a YAML `_tasks` block and one bash array: no endpoint, no model, no
     session. What stands here is the manifest — the two subjects the story set at cutting, expanded
     into the five `ST` criteria its own file carries — as the entry condition gate `10` designs
     against. The `ST` numbers are the story's own bracketed allocations and are confirmed or
     renumbered by `10-security-checks`. Per code/docs/GATE-REPORTING.md this is a gate not yet
     entered, reported as such — not a gate that found nothing. -->

- [ ] **Seed-once integrity** — all seven `_tasks` `mv` lines sit inside the existing entry gated
      `when:` gate keyed on `_copier_operation == 'copy'`, asserted in the diff rather than assumed. An
      ungated `mv` overwrites a project's filled index with a blank stub on every `copier update`,
      which is the one-way door `copier.yml` names in its own words for `MEMORY.md`, `GAPS.md` and <!-- doc-references: template-only -->
      `DEFERRED.md` (US010/ST01)
- [ ] **Ordering inside the task** — all seven `mv` lines land **before** `rmdir .copier` in the
      same `&&` chain. A line after it silently no-ops and the project is generated without the
      index it was promised (US010/ST02)
- [ ] **No seed cut from a populated in-tree index** — each seed authored blank, or for
      `MAP-INDEX.md` with exactly one `TBD` row, and the emptiness **proved by a check, not
      trusted**, on the `shipped-memory.sh` / `shipped-registers.sh` precedent (US010/ST03)
- [ ] **No seed names a syntek-base instance** — map, story, sprint, decision, plan, finding or bug.
      A seed cut from this repository's own rows ships that content permanently and no later update
      can correct it (US010/ST04)
- [ ] **No new reach** — no network fetch, no credential read, and no write outside
      `project-management/src/`, `.copier/`, `copier.yml`, `.github/scripts/shipped-artefacts.sh`
      and `.claude/skills/wayfinder/SKILL.md` (US010/ST05)
- [ ] **No CRITICAL or HIGH finding is open** — cannot be ticked until gate `10` has run; the row is
      here so that its absence is not read as a pass
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

### QA Acceptance Criteria — Automated

<!-- First-pass from the manifest; no QA-PLAN-US010-* exists under
     project-management/src/11-QA/PLANNING/ on 20/09/2026. Rewritten at gate 11's close. -->

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` passes with the enlarged `SEEDED`
      array, and its planted-deletion probe still fires — a deleted seeded index is reported, not
      silently tolerated
- [ ] The `[3/4] Template Generation` job generates a project on **both** answer sets
      (`INCLUDE_MOBILE` false and true) and all seven index files are present in each generated tree
- [ ] A grep over each generated tree finds no `US###`, `SPRINT-##`, `ADR-US###` or `MAP-<FEATURE>`
      literal inside any index file, bar the seeded `MAP-SCALE-PLANNING.md` row
- [ ] A `copier update` probe against a generated project whose indexes have been edited asserts
      that **no** index file is reverted to its seed
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` passes — every register folder still carries
      its `CONTEXT.md` + `CLAUDE.md` pair, and an index file is not mistaken for one
- [ ] `bash code/src/scripts/audits/docs-length.sh` passes — the seven `CONTEXT.md` files each gain
      a section, and none crosses the 300-line ceiling or the 270 ratchet without a dated allowance
- [ ] Coverage floors — **N/A**, and marked rather than deleted. The member ships Markdown, YAML and
      one bash array; the Backend flag reads `N/A` and no Python is added, so the floor has nothing
      to bind. Unlike `project-management/src/03-SPRINTS/SPRINT-05.md`, which left this open because
      its member shipped settings modules

### QA Acceptance Criteria — Manual

<!-- Manual is load-bearing here: a row's Summary is prose written for a human, and no script can
     judge whether one line of plain English describes a map to someone who has not read it. That
     bar is `N-002`'s, not this record's. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US010-MANUAL-TESTING.md` carries a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in the member's QA plan — which gate `11` has
      yet to write; until it exists this row cannot be ticked, and its absence is not a pass

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Index and Seed Tasks

<!-- The template has no documentation-tasks section, and the member's deliverable is documentation
     plus a generation seam — so its index, seed and documentation work is carried here on
     SPRINT-05's precedent, which carried US008's five-guide rewrite under its Backend Tasks. -->

| Story | Task                                                                                                                                | Done |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US010 | Design the shared spine once, and each register's tail columns and ordering rule; state the order in every file                     | [ ]  |
| US010 | Create all seven index files in-tree on the `23-INCIDENTS/INCIDENT-INDEX.md` shape                                                  | [ ]  |
| US010 | Backfill `MAP-INDEX.md` one row per map, **re-counting the folder at implementation time** — the count moved 14 to 15 at cutting    | [ ]  |
| US010 | Add the `Backfill owed — US011` line to four indexes, and **not** to `FINDING-INDEX.md` or `BUG-INDEX.md`                           | [ ]  |
| US010 | Author seven blank `.copier/` seeds; give `.copier/MAP-INDEX.md` its one `TBD` row                                                  | [ ]  |
| US010 | Add seven `mv` lines to the `_tasks` entry, ahead of `rmdir .copier`, inside the existing `copy` gate                               | [ ]  |
| US010 | Grow `SEEDED` in `.github/scripts/shipped-artefacts.sh` from one entry to eight, and add the deletion probe                         | [ ]  |
| US010 | Prefix every map's `**Status**` header with its enum value, middle-dot separated, derived by measurement                            | [ ]  |
| US010 | Tick or re-justify every map's `Gate to stories` index-row box, disposing of **all three** decline rationales                       | [ ]  |
| US010 | Replace `## Map index` in `01-FEATURE-MAPS/CONTEXT.md`; add or rewrite the `## The index` H2 in the other six; leave `23-INCIDENTS` | [ ]  |
| US010 | Repoint the six instruction sites — `MAP-000-TEMPLATE.md`, `.claude/skills/wayfinder/SKILL.md`, `01-FEATURE-MAPS/CLAUDE.md`         | [ ]  |
| US010 | Re-measure the Plans Index citation population from the tree as it stands, per `US007.md`                                           | [ ]  |
| US010 | **Verify, do not re-cut** the `S-01`, `S-02` and `S-05` rows on `MAP-REGISTER-INDEXES.md`                                           | [ ]  |

### Security Tasks

| Story | Task                                                                                                          | Done |
| ----- | ------------------------------------------------------------------------------------------------------------- | ---- |
| US010 | Assert all seven `mv` lines inside the `copy` gate and ahead of `rmdir .copier` in the diff (ST01, ST02)      | [ ]  |
| US010 | Prove every `.copier/` seed empty by a check rather than trusting it (ST03)                                   | [ ]  |
| US010 | Confirm no seed names a syntek-base map, story, sprint, decision, plan, finding or bug (ST04)                 | [ ]  |
| US010 | Confirm the change adds no network fetch, no credential read and no write outside the five named paths (ST05) | [ ]  |
| US010 | Satisfy the developer constraints gate `10` produces, once it has run — on the pattern of US005's Section 7   | [ ]  |

### QA Tasks — Automated

- [ ] US010 — extend `shipped-artefacts.sh --self-test` with the seeded-index deletion probe, output
      recorded in `project-management/src/18-TESTS/US010-TEST-STATUS.md`
- [ ] US010 — add the generated-tree grep asserting no syntek-base literal appears in any index, on
      **both** `INCLUDE_MOBILE` poles
- [ ] US010 — add the `copier update` probe asserting no index is reverted to its seed
- [ ] US010 — run `docs-pairing.sh`, `doc-references.sh` and `docs-length.sh` over the changed tree

### QA Tasks — Manual

- [ ] US010 — row-by-row walk-through of `MAP-INDEX.md` against the map headers as they then stand,
      recorded: every `Status`, `Updated` and slice count matches its map's own header
- [ ] US010 — enum derivation walk-through across every map, with the reasoning for each value
      recorded — which are `Complete`, which are `Blockers clear — stories may start`, and why a map
      with open fog is not `Complete`
- [ ] US010 — re-read of the six repaired instruction sites, recorded
- [ ] US010 — the four incomplete indexes read as incomplete-and-owned rather than
      empty-and-correct, by a reader who has not read the story
- [ ] US010 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint's Frontend,
      Components and Wireframes rows read `N/A`; no page, component or interactive surface is added

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The checks with nothing to look at are marked N/A with a reason rather than deleted: per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. Unlike
     project-management/src/03-SPRINTS/SPRINT-05.md this sprint ships no Python, so the type-check
     leg has nothing to read. -->

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` exits 0 with the enlarged `SEEDED`
      array
- [ ] **The `[3/4] Template Generation` job is green on both answer sets** — all seven index files
      present in each generated tree, six of them with no instance rows
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
      baseline stands. If US004 — SPRINT-03's sole `Must`, built before this sprint — has landed and
      the gate has gone green, the plain-pass reading applies; both branches are named, as SPRINT-04
      named them for US005 and SPRINT-05 for US008. The story re-captures its own baseline
      immediately before its first edit, in the index state it will be measured in.
      **NOT RUN at the gate that opened this record**, and that is stated rather than left to be
      inferred from the scoped figure above: the whole-tree pass takes over ten minutes against the
      45 seconds the scoped one takes, and it was not completed on 20/09/2026. Per
      `code/docs/GATE-REPORTING.md` an unmeasured gate is reported, never passed — the folder figure
      above is not a whole-tree figure and must not be quoted as one
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance. **Files to watch: the seven `CONTEXT.md` files under
      `project-management/src/`, each of which gains a section.** The guard is the gate's reading at
      implementation time, not a literal in this file — `GAPS.md`'s entry of 17/09/2026 records what
      a bare line count costs. `code/src/scripts/audits/CONTEXT.md` is US002's headroom and is not
      touched by this sprint
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — **more than regression here.** The member
      adds a third `.md` file to seven directories that each carry a `CONTEXT.md` + `CLAUDE.md`
      pair, and the check must confirm an index file is not mistaken for either half
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only. A green run says the
      registered claims are undisturbed and says **nothing** about the seven indexes agreeing with
      the registers they describe; it is never reported as though it had
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, the member adds no routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — markdownlint-cli2 over the seven new index
      files, the seven `CONTEXT.md` files and every map whose header gains an enum prefix.
      **ShellCheck over the changed `shipped-artefacts.sh` is what a widened script asks for and
      `lint.sh` does not carry it**: its legs are ruff, markdownlint-cli2, ESLint and clippy, and no
      script under `code/src/scripts/`, no CI workflow and no lefthook entry runs ShellCheck. It is
      recorded in `project-management/src/18-TESTS/US010-MANUAL-TESTING.md` as run or as not run,
      never as a `lint.sh` pass, per `code/docs/GATE-REPORTING.md`
- [ ] `bash code/src/scripts/syntax/check.sh` passes — **regression only.** Its basedpyright leg
      reads Python and this sprint adds none; run so the absence is measured rather than assumed
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, the sprint's DB flag reads `N/A`
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — the suite runs as a regression and passes;
      the coverage floor has nothing to bind, the sprint adding no Python
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies**, against gate `10`'s output once it
      exists; the first-pass rows above are the manifest, not the sign-off
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its own
      DoD complete) — US010 alone, this record having no stretch tier at opening
- [ ] **The carry-over question is disposed of in writing, either way.** US009's 5 SP `Should` carry
      is reserved to this record by `project-management/src/03-SPRINTS/SPRINT-05.md`'s Definition of
      Done. If US009 carried here, it is **Completed** here or explicitly carried on again with its
      reason recorded in both records and in `project-management/src/02-STORIES/US009.md` — a
      `Should` is never dropped silently, and the backlog register is updated in every copy in the
      same change. If it did not carry, that is stated here rather than left as an unexplained
      8 / 11. **In the carry case this record stands at 13 / 11 and at grace**, which is the reading
      the capacity line above already licenses
- [ ] **The carry has a deadline, and it is this record's close.** If US009 is still undecided when
      this record would otherwise close, the close waits on that decision or the reservation is
      released in writing — a reservation with no expiry silently holds 5 SP of a record's give
      forever. **If US009 is dropped AFTER this record has closed**, its points do not land here:
      the drop is recorded in `project-management/src/03-SPRINTS/SPRINT-05.md` and the story is
      carried into whichever record is open at that moment, or recorded as owed and unplaced if
      none is. Build order makes that ordering unlikely — US009 builds ninth and US010 tenth — but
      unlikely is not impossible, and it is stated rather than left to be decided at the keyboard
- [ ] **A landed carry re-opens the sprint plan, if one has been written.**
      `project-management/docs/planning/SPRINTS.md` -> _Two artefacts, two moments_ makes the plan
      "written once, against a settled story set", so a carry arriving after
      `06-SPRINT-PLAN-06.md` exists un-settles that set: the plan is revised in the same change that
      admits the story, never left describing a one-member sprint that now has two
- [ ] **Nothing else carries into this record.** SPRINT-01, SPRINT-02 and SPRINT-04 are closed with
      nothing reserved out of them, and SPRINT-03's reservation runs into SPRINT-03. If a story
      arrives anyway it is recorded in both records with its reason and the capacity line
      recomputed — a second `Must` of 8 would be 16 / 11 and is refused on arithmetic before it is
      argued
- [ ] **This record unblocks `project-management/src/03-SPRINTS/SPRINT-07.md`**, whose sole member
      has nothing to edit until the seven index files exist. Confirmed rather than assumed at close:
      the four indexes US011 backfills exist and carry their `Backfill owed — US011` line
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in the member's QA plan — once gate `11` has
      written it
- [ ] The Security and QA rows of the FLAGS table, and the sections they govern, were recomputed
      when gates `10` and `11` closed. **Which union they must equal depends on the carry**, and
      both branches are named so that a reviewer ticking this row after a landed carry is not asked
      to tick a false statement: **no carry** — the union equals US010's table, this record having
      one member; **carry landed** — the union equals US010's unioned with US009's, which widens
      Security with that story's supply-chain subject and adds its subjects to QA, exactly as the
      FLAGS comment at the head of this record says it would
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity — once the threat model exists
- [ ] Retrospective notes captured (optional — link or inline)
