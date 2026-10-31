# SPRINT-08

**Last Updated**: 31/10/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Debugging an incident runs through the scripts against structured logs: the 09 workflow
is honest and every log line carries a request_id.

<!-- Settled 31/10/2026, 03-sprint-planning grilling round 1 Q1 (<%DEVELOPER_NAME%>). Derived from
     the title and Client Summary of US013, the sole member, and from the slice CUT-PLAN.md P8
     reserves as this record's second member — RULE-OWNERSHIP `S-07`, US014 (provisional), the
     structured-logging slice. The first clause is US013's; "every log line carries a request_id"
     is US014's working title, and it is in the goal BY CALL, not by drift.
     project-management/src/03-SPRINTS/SPRINT-02.md recorded on 05/09/2026 that a goal naming a
     deliverable no member carries is a defect; this goal names one member's deliverable and one
     reservation's, and the reservation is stated in the Notes below. If US014 is cut and admitted,
     the goal already reads true of both members. If US014 is not admitted here, the goal is
     rewritten in that change from the members it then has — SPRINT-07's rewrite of 21/09/2026
     is the precedent. Worded so that a re-pricing of US014 at its own cut does not reach it: no
     figure, no estimate and no file count appears in the sentence. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **3 SP Must = 3 / 11 SP** — inside capacity, one member,
all-`Must`, and **OPEN to admission**, with the remaining 8 SP reserved by
`project-management/src/02-STORIES/CUT-PLAN.md` P8 for US014. 3 / 11 is not the fill trigger, so
no plan is owed by this admission. See Notes.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story admitted,
     never edit it directly.
     Computed 31/10/2026 on US013's admission at opening — the union over one member is that
     member's table, copied verbatim from project-management/src/02-STORIES/US013.md, including the
     reasoning its GDPR row carries in place of a bare N/A. One row carries a value: QA names the
     manual type, the four doc gates and the generated-project check. Twelve rows read N/A. Nothing
     in either row is substituted or reworded.

     THESE ARE FIRST-PASS VALUES. On 31/10/2026 no artefact under
     project-management/src/11-QA/ names US013, it has no manual testing guide in
     project-management/src/18-TESTS/MANUAL/, and it has no story plan. Its one gate that runs,
     11-qa-checks, runs before US014 is cut (CUT-PLAN.md P1: one story at a time). Per
     code/docs/GATE-REPORTING.md this is a gate not yet entered, reported as such — not a gate
     that found nothing. When gate 11 closes, the union is recomputed here from the member's table
     as that gate leaves it.

     RECOMPUTED 31/10/2026 AT 11-qa-checks, from US013's table as that gate left it, copied
     verbatim: the QA row now searches case-insensitively (11-qa-checks grilling round 1, Q6), and
     the Security, SEO and Logging rows carry a one-line inline reason as the GDPR row does (Claude's
     call, accepted in the same round). No row changed between N/A and a value. The "first-pass"
     paragraph above is the record of the opening and is kept as written: gate 11 has run
     (project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md) but is not
     closed, because the plan is not signed off and AC-GAP-5 is OPEN.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 2 (Q10, Q11): AC-GAP-5 is RESOLVED into
     US013 — four LogQL-bound Loki sites held literal, STEPS.md:176 reworded vendor-free, the
     LOG_AGGREGATOR count 12. US013's flag table did not change, so the union above stands. Gate 11
     is still not closed: the plan is not signed off, and its qa-tester dispatch is owed.

     AMENDED 31/10/2026 after the 11-qa-checks qa-tester run: eleven findings, seven folded into
     the plan and US013 (wording and task repairs, no flag moved), and five gaps opened with
     <%DEVELOPER_NAME%> as AC-GAP-6 to -10 (one finding split between the two). US013's flag table
     did not change, so the union above stands. Gate 11 is still not closed: five [OPEN] gaps and
     no sign-off.

     RECOMPUTED 31/10/2026 after 11-qa-checks grilling round 3 (Q12 to Q16): AC-GAP-6 to -10
     RESOLVED into US013. Its QA row changed in wording, not between N/A and a value — the
     unmarked-literal grep now runs on the non-default Bugsink / Fluent Bit render only, and the CI
     default paths check only that every token renders (Q13) — and is copied here verbatim. Gate 11
     has no [OPEN] gap and its qa-tester run is done; it closes on <%DEVELOPER_NAME%>'s sign-off.

     AMENDED 31/10/2026 after the scoped qa-tester re-check of round 3: AC-GAP-11 and -12 are
     [OPEN] in the QA plan, waiting on <%DEVELOPER_NAME%>. US013's QA row is unchanged, so nothing
     is recopied; the previous paragraph is kept as the record of round 3, and Gate 11 is not
     closed until both are ruled.

     AMENDED 31/10/2026 after 11-qa-checks grilling round 4 (Q17, Q18): AC-GAP-11 and -12
     RESOLVED into US013 — Alloy also leaves the TEMPLATE-GUIDE/05-ANSWERS.md:124 copy of the help
     list, the two "proven alternates" lists go to Out of Scope and the DEFERRED.md entry, and the
     recorded reason is that Alloy is the reference deployment's own shipper. US013's flag table
     did not change, so nothing is recopied. Gate 11 has no [OPEN] gap, its qa-tester run and
     scoped re-check are done; it closes on <%DEVELOPER_NAME%>'s sign-off. -->

| Flag       | Value                                                                                                                                                                                                                                                                                                                                                                            |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| User Flow  | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| Brand      | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| Components | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| Wireframes | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| GDPR       | N/A — the personal-data path left this slice for S-07 and S-08 when Batch E split (Q14, 27/08/2026)                                                                                                                                                                                                                                                                              |
| Security   | N/A — no authentication, permission, endpoint or personal-data path; the edit set is Markdown and `copier.yml` comment and help text                                                                                                                                                                                                                                             |
| QA         | manual — `docs-length.sh`, `docs-pairing.sh`, `doc-references.sh`, `doctrine-drift.sh`; generated-project check — on every render path the template offers, every token in scope renders; on the non-default Bugsink / Fluent Bit render only, no unmarked vendor literal survives, searched case-insensitively, in `code/workflows/09-debugging-with-logs/` or `code/src/logs/` |
| SEO        | N/A — no public page; every file edited is developer documentation                                                                                                                                                                                                                                                                                                               |
| API        | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| Logging    | N/A — a document about logs: no logger, event, field, level or retention is added or changed                                                                                                                                                                                                                                                                                     |
| Backend    | N/A                                                                                                                                                                                                                                                                                                                                                                              |
| Frontend   | N/A                                                                                                                                                                                                                                                                                                                                                                              |

---

## Story Summary

| ID    | Title                                                                                                                      | MoSCoW    | SP  |
| ----- | -------------------------------------------------------------------------------------------------------------------------- | --------- | --- |
| US013 | The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause | Must Have | 3   |

**Total:** 3 SP — all committed, no stretch tier. One member; the 8 SP P8 reserves for US014 is
**not** counted here, because US014 is not cut. See Notes.

<!-- US013 admitted 31/10/2026 at 03-sprint-planning, cut the same day from
     project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md slice `S-01` (nodes N-001, N-012
     and N-013). The row reads Must Have at 3 SP, matching
     project-management/src/02-STORIES/US013.md: the `Must` was settled 21/09/2026 (CUT-PLAN.md,
     MAP-RULE-OWNERSHIP round, Q6) and the 3 SP the same day, confirmed at cut. This record derives
     its tiers FROM its stories and edits neither figure. Its `**Status:**` reads `Open` and this
     record moves it nowhere. US013 sits in no other record's table. -->

## Dependencies

- **US013 has no upstream dependency.** `MAP-RULE-OWNERSHIP.md` has an empty frontier and an
  unblocked gate to stories; N-001, N-012 and N-013 are settled, and no open story edits the 09
  folder or the `code/src/logs/` pair (`project-management/src/02-STORIES/US013.md` ->
  Dependencies). `SPRINT-01` to `SPRINT-07` are all closed, so this record is the only one that
  could receive it.
- **US013 unblocks four slices by merge order, not by a blocking edge.** `S-07` (US014,
  provisional), `S-03` (US017, provisional), `S-04` (US020, provisional) and `S-08` (`Held` on
  MAP-BUN-TOPOLOGY) all edit the 09 folder and merge **after** US013, rebasing onto it. `S-07` is
  the one P8 places in this record; the build order inside the record is therefore US013 then
  US014, which is also P8's order.
- **US013 does not block on US004**, for the reason SPRINT-04 to SPRINT-07 each record for their
  own members: the citation gate's baseline-diff regime
  (`project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`)
  is a reporting regime and sequences nothing. US013's own QA criterion reads `doc-references.sh`
  under it unless US004 has landed and the gate is green.
- **Sprint numbering and build order agree.** The settled build order is the prefix on each plan in
  `project-management/src/17-STORY-PLANS/` — twelve plans on disk on 31/10/2026, `01-` to `12-` —
  and US013 builds thirteenth, at a **reserved `13-`**. It is a **reserved number, not a plan**,
  until `17-story-plans` writes it, and nothing here may cite it as a plan before then (SPRINT-04's
  rule for US006's `07-`). This is this gate's reading on SPRINT-07's precedent of 21/09/2026, not
  a call made on the day; it moves if build order does.
- **Nothing carries into this record, and nothing is reserved out of it.** US003's carry is
  reserved into SPRINT-03 and US009's into SPRINT-06. SPRINT-07's US011 has a drop branch with no
  receiving record, and this record does not become one: see Notes.
- **`Blocked` is a story status, not a sprint one.** US013's own `**Status:**` reads `Open`, and a
  status flip is `.claude/skills/completion/SKILL.md`'s to make when the work starts.

## Notes

**This record opens with its first admitted story, as SPRINT-05, SPRINT-06 and SPRINT-07 each
did.** `project-management/src/03-SPRINTS/SPRINT-07.md` -> Notes recorded on 21/09/2026 that "A
new admission opens SPRINT-08" and that it "is opened by the first story admitted to it, at
`03-sprint-planning` … and not in advance". US013 is that story, cut and admitted on 31/10/2026.
It is the first story cut since SPRINT-07 closed by call, and the first cut under CUT-PLAN.md's
one-story-at-a-time rule (P1).

**The rest of this record is reserved, and the reservation is stated here rather than in the
register.** `project-management/src/02-STORIES/CUT-PLAN.md` P8 (27/09/2026) gives SPRINT-08 to
RULE-OWNERSHIP: US013 then US014, at 11 / 11. US014 is **provisional** — slice `S-07` on
`MAP-RULE-OWNERSHIP.md`, priced at 8 SP in CUT-PLAN.md's cut order and not yet cut — so it is a
reservation, not a member. It is not in the Story Summary, it is not counted in the capacity
figure, and the backlog register's row names US013 alone (settled 31/10/2026, 03-sprint-planning
grilling round 1 Q2). Under P1, US013's own QA gate, `11-qa-checks`, runs before US014 is cut.
US014's admission is `03-sprint-planning`'s at that time, on the figure its own cut gives it.

**The backlog register.** Every live record carries this table and the copies are identical; **this
record is `SPRINT-08`**. It became a live register on 17/09/2026, when US009 was placed into
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
| `SPRINT-07` | US012 (`Must`, 2) then US011 (`Should`, 8, stretch)             | 10 / 11 — closed                                            |
| `SPRINT-08` | US013 (`Must`, 3)                                               | 3 / 11 — open                                               |

Each record owns its own row, and **every record carries the whole table**: a membership or a
capacity change is written into every copy in the same change. It is maintained by hand — no gate
reads it, and that cost is filed in `GAPS.md` (17/09/2026). Rule:
`project-management/docs/planning/SPRINTS.md`. Obligation:
`project-management/src/03-SPRINTS/CLAUDE.md`.

<!-- ONE ROW ADDED, 31/10/2026 at 03-sprint-planning: this record's own, on its opening with
     US013 (settled 31/10/2026, 03-sprint-planning grilling round 1 Q2). The other seven rows are
     copied from SPRINT-07.md's register as it stood at 39b9fcf and did not move; checked against
     each record's own capacity line as well as against the other copies, per
     project-management/src/03-SPRINTS/CLAUDE.md, and every row agrees with its source. The
     history of those rows is in the dated comments under the register in SPRINT-01 to SPRINT-07,
     and is not restated here. -->

**Capacity: 3 / 11 — inside capacity, all committed, and under capacity by 8 SP, called out rather
than padded.** The 8 SP is **spoken for** by P8's reservation above, as SPRINT-06's 3 SP was by
US009's reserved carry, and it is not padded with a story cut to fill it.
`project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_ owns both figures
as generation-time answers, `SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`; in this template repository
the table is unrendered and the 11 and 13 every record uses are the `copier.yml` defaults. <!-- doc-references: template-only -->
3 / 11 is not the fill trigger, so this admission owes no `16-sprint-plans` or `17-story-plans`
pass. If US014 is admitted at its priced 8 SP, the record lands on **11 / 11 — at capacity, the fill
trigger** — and owes its plan then, written once every member has cleared the specify tier
(`project-management/docs/planning/SPRINTS.md` -> _Capacity_).

**`Timeline: TBD`, so scope-against-duration is unmeasurable and is recorded as such.**
`project-management/workflows/03-sprint-planning/CHECKLIST.md` asks that "Scope is realistic for
the sprint duration"; with no dates that box has nothing to divide the points by, and **it is
marked unmeasurable rather than ticked**. No record in `project-management/src/03-SPRINTS/` has
ever carried a date, and this one follows SPRINT-07's reading of the same box. Per
`code/docs/GATE-REPORTING.md` a check that could not run is reported, never passed. It becomes
answerable the moment a timeline is set.

**OPEN to admission, and what would change the position** — each <%DEVELOPER_NAME%>'s call at the
time, and not this record's to pre-empt:

- **US014 at its priced 8 SP** lands the record on 11 / 11, the fill trigger, which closes it on
  arithmetic and owes the plan. That is the admission P8 anticipates.
- **US014 re-priced at its own cut.** At 9 or 10 SP it stands the record at 12 or 13 / 11, in grace;
  SPRINT-04 and SPRINT-05 have taken grace, and `CADENCE.md` reads "a sprint that habitually runs to
  it means the capacity figure is wrong", so a third is the signal SPRINT-05's and SPRINT-07's Notes
  both name. Past 10 SP it is over the 13 SP ceiling and is refused on arithmetic before it is
  argued. The goal is worded to survive either reading (Q1).
- **Any other story** would spend the reservation P8 holds, and is refused for that reason unless P8
  is amended first, in `project-management/src/02-STORIES/CUT-PLAN.md`.

**SPRINT-07's US011 still has no receiving record, and nothing moves.** SPRINT-07's Definition of
Done carries a drop branch for its `Should` stretch and binds the reservation to be named "the
moment a receiving record is opened". This record is opened, and it is **not** that record: under
P8 it is full at 11 / 11 with US013 and US014, and US011's 8 SP on top is 19 / 11, past the 13 SP
grace ceiling. Placing a dropped US011 therefore stays owed to `03-sprint-planning`, as SPRINT-07
records, and this record names nothing for it. SPRINT-07 is annotated in this change to say this
record now exists.

---

## Acceptance Criteria

One outcome, the sole member's: workflow 09 and the `code/src/logs/` pair carry no raw `docker`
call and no unmarked vendor literal; their vendor names render from the project's own answers; and
09 ends at the root cause, with a verification step that runs nothing it does not own. The four
documentation gates and the generated-project check in the QA flag run against it, each under the
regime the Verification Checks give it. The seven Gherkin scenarios are US013's own and are not
restated here (`project-management/src/02-STORIES/US013.md` -> Acceptance Criteria).

<!-- AMENDED 31/10/2026 after 11-qa-checks grilling round 3: "six" until then. Q14 added a seventh
     scenario to US013 — a dev fault rooted at Step 2 is routed to 10-debug. -->

### QA Acceptance Criteria — Manual

<!-- The automated QA sections are removed: this sprint's QA flag names a manual type and no
     automated one, matching its member, which ships documentation and no code path. Every other
     discipline section is removed with its N/A flag, per the template. Per
     code/docs/GATE-REPORTING.md the skip is recorded here rather than left to be inferred. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/MANUAL/US013-MANUAL-TESTING.md` carries a tester sign-off
      block — a path that does not exist on 31/10/2026; `17-story-plans` writes it
- [x] **No `[OPEN]` acceptance-criteria gap remains** in US013's QA plan,
      `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`, written at
      `11-qa-checks` on 31/10/2026 — AC-GAP-1 to -5 resolved into the story the same day (AC-GAP-5
      in 11-qa-checks grilling round 2), and AC-GAP-6 to -10, raised by the `qa-tester` run of
      31/10/2026, resolved into it in 11-qa-checks grilling round 3 the same day; and AC-GAP-11 and
      -12, raised by the scoped `qa-tester` re-check of 31/10/2026, resolved into it in
      11-qa-checks grilling round 4 the same day. **No gap is `[OPEN]`**; the plan's sign-off is
      <%DEVELOPER_NAME%>'s

<!-- AMENDED 31/10/2026 at 11-qa-checks: the criterion above read "in US013's QA plan, which
     `11-qa-checks` writes under `project-management/src/11-QA/PLANNING/` and which does not exist
     on 31/10/2026" until the plan was written the same day. -->

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file —
`project-management/src/02-STORIES/US013.md` -> Tasks carries seventeen documentation tasks and is not
restated here.

<!-- AMENDED 31/10/2026 at 11-qa-checks: "twelve" until then. The gate added two tasks to the story
     — the browser-SDK rewording (11-qa-checks grilling round 1, Q7) and LOG_AGGREGATOR's help text
     (Q9) — and amended the tokenisation task's counts and exemptions (Q7, Q8). "Fourteen" became
     "fifteen" the same day, when an independent review of the 11-qa pass gave the Q8 S-07 record its
     own task (a dated note on the S-07 row of MAP-RULE-OWNERSHIP.md). Still fifteen after
     11-qa-checks grilling round 2 (31/10/2026, Q10, Q11): the STEPS.md:176 rewording was folded into
     the tokenise task, whose LOG_AGGREGATOR count moved from 11 to 12, and the S-07 note task now
     names its four literal sites. "Fifteen" became "sixteen" after the 11-qa-checks qa-tester run
     (31/10/2026), which added the CHECKLIST.md:43 references task (item 11); its other folded
     findings amended existing tasks. "Sixteen" became "seventeen" after 11-qa-checks grilling
     round 3 (31/10/2026), which added the CHECKLIST.md:38 rewording task (Q15) and amended the
     marker (Q12), 10-debug re-home (Q14) and LOG_AGGREGATOR help-text (Q16) tasks. Still
     seventeen after 11-qa-checks grilling round 4 (31/10/2026, Q17, Q18): the 05-ANSWERS.md:124
     mirror and the restated reason amended the LOG_AGGREGATOR help-text task; none was added. -->

<!-- AMENDED 31/10/2026 after 11-qa-checks grilling round 3 (Q13): the generated-project QA task
     below read "run on every render path the template offers and on one extra answer set …, the
     vendor-literal search case-insensitive" until then. -->

### QA Tasks — Manual

- [ ] US013 — the four documentation gates run, and their output recorded in its manual testing
      guide, `doc-references.sh` read as a diff against the baseline captured before the first edit
- [ ] US013 — the generated-project check: on the two CI default render paths, only that every
      token renders and every token name is a defined question; on one extra `sed` render with
      `ERROR_TRACKING=Bugsink` and `LOG_AGGREGATOR=Fluent Bit`, and there only, the case-insensitive
      unmarked-vendor-literal search; the paths it ran and their run IDs recorded
- [ ] US013 — each routed command typed as written against a running dev stack, its output recorded
- [ ] US013 — the human read-across: the truncate stated once between 09 Step 2 and
      `code/src/logs/CONTEXT.md`, and no sentence in scope reading wrongly with a substituted name
- [ ] US013 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation only, and per code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file US013 edits crosses 270 counted lines
      without a dated allowance
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — both pairs US013 edits keep their four H2s
- [ ] `bash code/src/scripts/audits/doc-references.sh` — **read as a diff against the baseline
      captured before the first edit**, per
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
      unless US004 has landed and the gate is green; never reported as a bare pass while the
      baseline stands
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression guard only**: it reads fenced
      code, so the prose half of US013 is the read-across, never this gate
- [ ] The generated-project check, with the render paths it ran recorded
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — the leg that reads Markdown
- [ ] `bash code/src/scripts/syntax/check.sh` — **N/A**, it has no Markdown leg and this sprint
      ships Markdown only
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A**, the sprint's Security flag reads `N/A`
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] All stories in the Story Summary are individually marked **Completed** (their own DoD
      complete) — US013, the sole `Must`
- [ ] **Admitting a story recomputes this record in the same change** — the FLAGS union, the Story
      Summary, the capacity line, the Notes' admission position, the goal if its members no longer
      carry it, and the backlog register in every copy
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in any member's QA plan
- [ ] The `DEFERRED.md` entry for the out-of-scope vendor literals written, and items 1-2 of
      `GAPS.md`'s 17/09/2026 entry closed, both by `22-implementation-documentation`, as US013's own
      Definition of Done provides
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)
