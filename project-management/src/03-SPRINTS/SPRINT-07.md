# SPRINT-07

**Last Updated**: 27/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** A seeded file that fails to land in a generated project is reported by the
template-integrity gate rather than silently tolerated, and the gate's header stops claiming a
coverage it lacks; and the four indexes that shipped declaring their own debt are backfilled —
every story, sprint, decision and story plan carries a row with its own status mirrored verbatim
and a summary written for someone who has not opened it — while the `.copier/` seeds stay blank.

<!-- REWRITTEN 21/09/2026, when US012 was admitted as this record's `Must` tier. The goal above
     read, from 20/09/2026 until that day: "The four indexes that shipped declaring their own debt
     are backfilled — every story, sprint, decision and story plan carries a row with its own
     status mirrored verbatim and a summary written for someone who has not opened it — while the
     `.copier/` seeds stay blank." A goal naming one of two members' deliverables is the drift
     SPRINT-02 recorded on 05/09/2026, so it is rewritten from both members' titles and Client
     Summaries in build order — US012 then US011 — on
     project-management/src/03-SPRINTS/SPRINT-05.md's rewrite of 17/09/2026 for the same event.
     The two members come from different epics, Script Guards and Register Indexes, which is the
     ordinary shape here. The narrowness argued in the comment below still binds US011's half,
     which reaches into neither SPRINT-06's mechanism nor `S-03`'s gate; US012's half is one
     slice, `S-02` on project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md, whole. The two
     halves meet at the seeds — one asserts they land, the other that they land blank — and
     neither states the other's check. -->

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

**Timeline:** TBD · **Capacity:** **2 SP Must + 8 SP Should = 10 / 11 SP** — inside capacity,
two members, the `Must` tier **supplied** by US012 on 21/09/2026, and **CLOSED to further
admission** by call the same day: the **1 SP of headroom** is not spoken for, and nothing coming
fits it (<%DEVELOPER_NAME%>'s call at `03-sprint-planning`, 21/09/2026). A new admission opens
SPRINT-08. The close owes this sprint's plan and two story plans, and none is written yet. See
Notes.

<!-- Read "... **1 SP of headroom**, and still **OPEN to admission** on a narrower reading than the
     one it opened on. 10 / 11 is not the fill trigger, so no plan is owed. See Notes." from US012's
     admission until later on 21/09/2026, when <%DEVELOPER_NAME%> closed the record by call in the
     follow-up round of that day (Q1; see Notes). The figure and the members did not move; the
     admission posture and the plan position did. -->

<!-- Read "**8 / 11 SP** — inside capacity, **OPEN to admission**, and holding **no `Must` tier at
     all**: its sole member is a `Should`, and the tier
     `project-management/docs/planning/SPRINTS.md` requires is **reserved and absent** rather than
     skipped. See Notes." from 20/09/2026 until 21/09/2026. Recomputed on US012's admission at
     03-sprint-planning, <%DEVELOPER_NAME%>'s call in the MAP-SCRIPT-GUARDS interview round of
     that day (Q2). -->

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
     not a gate that found nothing.

     RECOMPUTED 21/09/2026 on US012's admission, per the rule at the head of this comment, and
     CHANGED in two rows. The union is now over two members, US012's table and US011's, both read
     from project-management/src/02-STORIES/ that day. Eleven rows are N/A in both and stay N/A.
     SECURITY stays N/A — the union of N/A with N/A — and the row now carries BOTH members'
     reasoning, each the member's own and each distinct: US011 is exercised by a control US010
     owns, and US012 adds a presence assertion to a CI integrity gate with no authentication, no
     personal data, no endpoint and no control whose pass condition it loosens. Neither reason is
     the other's, so neither is flattened into a shared one. QA gains the unit type US012 names —
     `shipped-artefacts.sh --self-test` with the seeded-deletion probe — beside US011's integration
     and manual types.
     THE TWO QA HALVES NAME THE SAME SCRIPT AND DO NOT CONFLICT. US012 changes
     `.github/scripts/shipped-artefacts.sh`; US011's value says the same self-test runs "unchanged
     and green". That clause reads US011's OWN diff — it "adds no registration and must not need
     one" — and holds whichever of the two lands first, as
     project-management/src/02-STORIES/US012.md -> Dependencies records from US012's side. It is
     carried verbatim rather than reworded to say so, and the reading is stated here instead.
     WHAT IS NOT VERBATIM, and it is the whole list. Each member's value is prefixed with its ID
     in the Security and QA rows, so a reader can tell whose half is whose; the two Security halves
     share one leading "N/A —" where each member's row opens with its own; the union's type list
     heads the QA row; and both Security halves end on the one "Reasoning in full in the FLAGS
     block above" where each member's own row points at its Provenance block, which a sprint
     record does not have — the substitution recorded above for US011 on 20/09/2026, now made for
     US012 on the same ground. Everything else in both rows is the member's own.
     US012'S VALUES ARE NOT FIRST-PASS. Its one gate that runs, `11-qa-checks`, closed on
     21/09/2026 in project-management/src/11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md with
     all nine gaps resolved into the story and the QA value unchanged; `10-security-checks` is
     skipped by its flag, which names that gate as the one entitled to overturn it. US011's half
     is still first-pass, for the reason stated above.

     RECOMPUTED 27/09/2026, per the rule at the head of this comment, on the write-back of the
     US010 / US011 gate grilling into project-management/src/02-STORIES/US011.md. No story was
     admitted or dropped; the recompute is owed because a member's table moved. CHANGED in two
     rows, both in US011's half. US012's table was re-read from the same folder that day and is
     unchanged — its 27/09/2026 amendment touched its first Gherkin scenario only.
     SECURITY stays N/A. US011's value now names the control as US010's `ST03`, `ST04` and `ST06`,
     gated in `.github/scripts/shipped-registers.sh`, where it had read "`ST03`/`ST04` and its
     enlarged `SEEDED` array". The member amended its reasoning from `10-security-checks` of
     21/09/2026 (TM-09, assessment Section 7.12): `SEEDED` is an allowlist, whose presence half is
     US012's check-4 loop and deletion probe, and not the seed-purity control. The 20/09/2026
     paragraph above paraphrased the earlier reading and is kept as that day's; the row carries
     the member's corrected value.
     QA keeps its type list — unit, integration, manual. US011's half gains
     `shipped-registers.sh` (with `--self-test`) and `shipped-ai.sh --self-test` beside the
     `shipped-artefacts.sh` self-test, the read rule on its status string-equality, and a check
     that every Markdown link resolves (QA-PLAN-US011 AC-GAP-1, AC-GAP-7 and AC-GAP-11). The two
     scripts it adds are US010's, changed in project-management/src/03-SPRINTS/SPRINT-06.md.
     US012 edits neither, so `shipped-artefacts.sh` stays the only script the two QA halves share,
     read as recorded above.
     WHAT IS NOT VERBATIM is still the list above, and nothing joins it. The member's own row now
     writes US010 without backticks, and the union follows it. US011's half is no longer first-pass
     in content, because it carries gate `11`'s write-back, and that gate's plan,
     project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md, reads
     `Reviewed` as measured the same day, all thirteen gaps resolved into the story on 27/09/2026.
     It is untracked, and is committed with US011.
     AMENDED 27/09/2026 after two verified passes of that write-back. The last sentence read "But
     that gate's plan, [the same path], still reads `Draft` as measured today, and its close is for
     that gate's own step to record." The plan moved to `Reviewed` later that day. Both members'
     tables were re-read then, and the union is unchanged by the move. -->

| Flag       | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| DB         | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| User Flow  | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Brand      | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Components | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Wireframes | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| GDPR       | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Security   | N/A — US012: no authentication, personal data or endpoint; a presence assertion added to a CI integrity gate, loosening no control · US011: the seed-purity control is US010's ST03, ST04 and ST06, gated in `.github/scripts/shipped-registers.sh`; this story adds no control and is exercised by that one. Reasoning in full in the FLAGS block above                                                                                                                                                                                                                                                                                                                                                                             |
| QA         | unit, integration, manual — US012: unit — `shipped-artefacts.sh --self-test`: the seeded-deletion probe (exactly one finding), plus the existing seed cases — the clean baseline, now asserting every seed landed, and check 3's map-leak probe beside the seed · US011: integration, manual — generated-tree grep (no syntek-base row reaches a seed); `shipped-artefacts.sh --self-test`, `shipped-registers.sh` (with `--self-test`) and `shipped-ai.sh --self-test` unchanged and green; row-per-instance and status string-equality under the read rule (project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md) read by hand across the four registers; every Markdown link checked for resolution |
| SEO        | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| API        | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Logging    | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Backend    | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Frontend   | N/A                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

---

## Story Summary

| ID    | Title                                                                                                    | MoSCoW      | SP  |
| ----- | -------------------------------------------------------------------------------------------------------- | ----------- | --- |
| US012 | A seeded file that never lands is reported, and the gate's header claim becomes true                     | Must Have   | 2   |
| US011 | The four indexes that shipped blank get a row per instance, and each register stops claiming it is empty | Should Have | 8   |

**Total:** 10 SP — **2 committed, 8 stretch.** Rows listed in build order. The `Must` tier this
record opened without is supplied by US012 (21/09/2026) rather than by relabelling US011; see
Notes.

<!-- 27/09/2026: the US011 row's title read "The four indexes that shipped blank get their 43 rows,
     and each register stops claiming it is empty" until that day. It now mirrors the member's
     title as its gate write-back left it (QA-PLAN-US011 AC-GAP-12). The literal is dropped because
     the population is measured at implementation time — 47 tracked on 27/09/2026 — and never
     inherited. No estimate moved: US011 stays 8 SP (settled 27/09/2026, grilling round 4 Q26) and
     US012 stays 2 SP. So the SP column, the total and the capacity line stand. -->

<!-- Read "**Total:** 8 SP — **0 committed, 8 stretch.** This record has **no `Must` tier**, which
     is the inverse of the defect `project-management/docs/planning/SPRINTS.md` warns about and is
     recorded in the Notes rather than repaired by relabelling the member." from 20/09/2026 until
     21/09/2026. -->

<!-- US012 admitted 21/09/2026 at 03-sprint-planning, cut the same day from
     project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md slice `S-02`. It is this record's
     first and only `Must`. The row reads Must Have at 2 SP, matching
     project-management/src/02-STORIES/US012.md; both were <%DEVELOPER_NAME%>'s, settled in the
     MAP-SCRIPT-GUARDS interview round of that day (Q2). The warrant for the `Must` is the story's
     own and is written in its MoSCoW comment — the gate's header asserts a coverage check 4 does
     not have — and the story records its fit with this record as a consequence, not as the reason.
     That is the derivation this record declined to invert for US011 on 20/09/2026 (Q1), holding
     in the other direction: a record's tiers are computed FROM its stories. Its `**Status:**`
     reads `Open` and this record moves it nowhere. US012 sits in no other record's table. -->

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

- **US011 is blocked by US010**, in `project-management/src/03-SPRINTS/SPRINT-06.md`. That story
  creates the four index files, designs their tails and ordering rules, and writes the
  `Backfill owed — US011` line this one removes. **There is nothing for US011 to edit until it
  ships**, and US011's own `## Dependencies` states the same edge from its side.
- **This is the only hard sequencing edge in the record, and it binds the stretch tier, not the
  committed one.** SPRINT-06 must close, or at least US010 must land, before US011 can start.
  Sprint numbering is not execution order (`project-management/docs/planning/SPRINTS.md` ->
  _Sequencing_), but here the two agree: `SPRINT-06` builds before `SPRINT-07` because its member
  is US011's blocker. **US012 waits on nothing** (below), so no edge holds this record's `Must`
  behind SPRINT-06 — only the build order does.
- **Nothing else blocking US011.** Verified 20/09/2026 at cutting against US001 to US010, all
  `Status: Open`: none of them writes an index file, and none renames an artefact in the four
  registers US011 backfills.
- **`MAP-REGISTER-INDEXES.md` `S-03` — the gate — follows this sprint, and is unscheduled.**
  `N-003` asserts presence, symmetry and status. US011 is the condition of `S-03` landing green,
  not merely of it being meaningful. Run first, `N-003`'s presence clause is red on the four
  indexes that carry a debt line, so `S-03` is not pulled ahead of US011 (settled 21/09/2026,
  grilling round 1 Q1). US011 is also what makes the symmetry and status clauses testable against
  a populated register rather than an empty one. `S-03` has no sprint: it stays `Proposed` at
  map-order row 10 of `project-management/src/02-STORIES/CUT-PLAN.md`, and SPRINT-08 is
  RULE-OWNERSHIP's (P8, 27/09/2026). The sequencing is explicit: `S-03` is not a dependency of
  this record, and this record is a precondition of `S-03`.
- **`20-FINDINGS` and `21-BUGS` are out of scope, and the absence is a measurement.** Both held zero
  instances on 20/09/2026, so SPRINT-06 ships their indexes legitimately empty with no debt line. If
  either has gained an instance by the time this sprint runs, it is US010's own presence clause to
  satisfy and not this record's backfill — named so the boundary is not re-drawn at the keyboard.
- **Neither member blocks on US004**, for the reason SPRINT-04 recorded for US006, SPRINT-05 for
  US008 and SPRINT-06 for US010.
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` is a
  reporting regime and sequences nothing. See Verification Checks.
- **US012 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-02`, node `N-005`,
  resolved 01/09/2026, on a map that reads `Frontier open: 0 · Blocking open: 0` and releases the
  slice because it "depends on nothing S-01 ships". `S-01` is US006, SPRINT-04's, and the two
  stories share no file (`project-management/src/02-STORIES/US006.md` -> Dependencies).
- **US012 and US010 edit the same script, and neither blocks the other in either order.** US010
  grows `SEEDED` in `.github/scripts/shipped-artefacts.sh` from one entry to eight; US012 adds the
  check-4 loop that reads it and the `--self-test` probe that proves the loop. Growing `SEEDED`
  without the loop is harmless, and once the loop lands it covers every seeded file, US010's seven
  indexes included; the two edits sit in different regions of the file, so whichever lands second
  rebases rather than waits. Build order puts US010 first, so the expected landing is SPRINT-06's
  array, then this record's loop. **The seeded-deletion probe moved from US010 to US012 on
  21/09/2026** (Q1 of that day's MAP-SCRIPT-GUARDS round) because the probe tests the loop, and one
  story owns both; both stories record the move from their own side, and
  `project-management/src/03-SPRINTS/SPRINT-06.md`'s QA flag lost `seed-deleted` in the same
  change.
- **US012 and US011 share this record and one script, and neither blocks the other.** US011 runs
  `shipped-artefacts.sh --self-test` and does not edit it; its "passes unchanged" criterion reads
  US011's own diff and holds whichever of the two lands first
  (`project-management/src/02-STORIES/US012.md` -> Dependencies). Build order lands US012 first, so
  US011 is exercised by the stronger check. US010 is the only other story of US001 to US011 that
  writes the script, measured at US012's cutting on 21/09/2026.
- **Sprint numbering and build order agree, and the order inside this record is `Must` first.** The
  settled build order is the prefix on each plan in `project-management/src/17-STORY-PLANS/` — nine
  plans on disk on 21/09/2026, `01-` to `09-` — with US010 tenth at a reserved `10-`, **US012
  eleventh at a reserved `11-`**, and **US011 twelfth at a reserved `12-`**. All three are
  **reserved numbers, not plans**: `17-story-plans` writes them, and nothing here may cite any as
  one (SPRINT-04's rule for US006's `07-`). **US011's reservation moved from `11-` to `12-` on
  21/09/2026, and it is the only position in the backlog that moved.** US012 builds ahead of it
  because the `Must` ships before the stretch — SPRINT-05's reading of 17/09/2026 for US008 and
  US009 — and because US011 waits on US010 while US012 waits on nothing.
  `project-management/docs/planning/STORIES.md` renumbers a plan's prefix whenever build order
  changes, which is why the reservation moves with the order rather than being kept; neither
  number was ever a file, so nothing on disk is renumbered. When `16-sprint-plans` writes this
  sprint's plan, both segments of `{exec-order}-SPRINT-PLAN-{sprint-number}.md` read `07`.
- **Nothing carries into this record, and what may carry OUT of it has no named destination yet.**
  US003's carry is reserved into SPRINT-03 and US009's into SPRINT-06; neither reaches here, and no
  record reserves anything to this one. In the other direction the record can only say what is true
  on 20/09/2026: **US011 is a `Should`, so it can be dropped, and a dropped `Should` is never
  dropped silently** — but there is no `SPRINT-08` to reserve it into, and this record will not
  invent one. The Definition of Done below states the disposal in both branches and binds the
  reservation to be **named the moment a receiving record exists**, which is the discipline
  `project-management/src/03-SPRINTS/SPRINT-05.md` had to be corrected into on 20/09/2026 after its
  own "the next record" was written against a record that did not exist. Updated 27/09/2026: nor
  is SPRINT-08 that record once it opens, because CUT-PLAN.md P8 fills it at 11 / 11. Placing a
  dropped US011 is therefore owed to `03-sprint-planning`, and the Definition of Done carries the
  arithmetic. **US012 carries nowhere**: it is the `Must`, and
  `project-management/docs/planning/SPRINTS.md` -> _MoSCoW_ defines that tier as the one the sprint
  fails without.
- **`Blocked` is a story status, not a sprint one.** US012's and US011's own `**Status:**` lines
  read `Open` and this record moves neither — the blocking edge on US011 is recorded in both
  stories and in both records, and a status flip is `.claude/skills/completion/SKILL.md`'s to make
  when the work actually starts.

<!-- RESCOPED 21/09/2026 on US012's admission. The bullets above that were written on 20/09/2026
     of "this record's member" or "this sprint's member" meant US011, the only member there was,
     and now name it; no edge they state moved. The sequencing bullet gained its last sentence,
     "US011 does not block on US004" became "Neither member", and the three US012 bullets are new.
     The build-order bullet read, until that day: "**Sprint numbering and build order agree.** The
     settled build order is the prefix on each plan in `project-management/src/17-STORY-PLANS/` —
     nine plans on disk on 20/09/2026, `01-` to `09-` — with US010 tenth at a reserved `10-` and
     US011 eleventh at a reserved `11-`. Both are **reserved numbers, not plans** ... Nothing is
     renumbered." The ordering inside the record is this gate's reading on SPRINT-05's precedent,
     not a call <%DEVELOPER_NAME%> made on the day; US012.md states the two stories are
     order-independent, so it is reversible by moving one reservation back. -->

<!-- AMENDED 27/09/2026, on US011's gate write-back. The `S-03` bullet opened
     "**`MAP-REGISTER-INDEXES.md` `S-03` — the gate — ships after this sprint.**" from 20/09/2026.
     It also read "US011 is what makes its symmetry and status clauses testable" and closed "this
     record is a precondition of `S-03` being meaningful". It is brought into line with
     project-management/src/02-STORIES/US011.md -> Dependencies as that write-back left it. The
     presence clause makes US011 the condition of `S-03` landing green (round 1 Q1). `S-03` is
     unscheduled (CUT-PLAN.md P8), which supersedes the 21/09/2026 settlement that cut it into a
     new SPRINT-08 (round 1 Q1's second half, round 2 Q13). The carry bullet gained its sentence on
     SPRINT-08 for the same reason. No edge this record holds moved. -->

## Notes

**This record opened on 20/09/2026 with no `Must` tier, and said so rather than papering over it.
The tier was supplied on 21/09/2026 by US012; the reasoning of the day it opened is kept below,
because it is what the admission had to satisfy.**
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

<!-- The bold sentence opening the paragraph above read "**This record has no `Must` tier, and that
     is stated rather than papered over.**" from 20/09/2026 until 21/09/2026. The rest of that
     paragraph and its three bullets are as written on 20/09/2026, in that day's tense. -->

**The tier is supplied, by the admission this record was held open for (21/09/2026).** US012 —
`Must Have`, 2 SP, cut that day from `MAP-SCRIPT-GUARDS.md` `S-02` — is admitted as the committed
tier, and US011 becomes the stretch. Each consequence above is disposed of in turn:

- **The Definition of Done's `Must`-tier row stops being `N/A` and binds US012.** The sprint can no
  longer close having delivered nothing.
- **"Dropped first" has its referent.** US011 is the work dropped if US012 overruns, and dropping it
  no longer empties the record. MoSCoW is a relative ordering between members; at two it acts.
- **The reserved tier is filled rather than absent**, so the reason the record was held open is
  discharged. What that does to the admission posture is set out below.

The `Must` is small beside the stretch — 2 SP committed against 8 — and that is a correct shape
rather than a thin one: `project-management/docs/planning/SPRINTS.md` -> _MoSCoW_ asks for at least
the `Must` tier and warns only against a plan where everything is `Must`. **The priority is
US012's own, not this record's.** The story's MoSCoW comment carries the warrant — the gate's header
claims a coverage check 4 does not have — and records the fit with this record as a consequence,
which is the derivation the paragraph below refused to invert for US011.

**Why US011 was not simply relabelled `Must`.** It was the option put at the same gate and
declined. US011's `Should` carries a written warrant at cutting — the four indexes it fills ship
from SPRINT-06 **declaring** their incompleteness and naming this story, so the false-emptiness that
would have made it a `Must` on this epic's own thesis never reaches the tree. One thing is held back
by its absence. `S-03`, the gate on `MAP-REGISTER-INDEXES.md`, cannot land green without US011,
because `N-003`'s presence clause is red on the four debt-carrying indexes until US011 lands — and
`S-03` is unscheduled (`project-management/src/02-STORIES/CUT-PLAN.md` P8, map-order row 10).
Dropping US011 still leaves four honest files rather than four false ones, but it holds `S-03` back
with it. The priority stays `Should` (settled 27/09/2026, grilling round 3 Q19).
`project-management/docs/planning/SPRINTS.md` derives a record's tiers from its stories; a record
that edits a member's priority to satisfy its own doctrine has inverted the derivation and lost the
warrant in the process.

<!-- CORRECTED 27/09/2026 (settled that day, grilling round 3 Q19). The paragraph above ended its
     warrant "and nothing is blocked from shipping by its absence" from 20/09/2026, carried from
     US011's MoSCoW rationale. The member corrected that sentence on 27/09/2026 because it was false
     of its one downstream consumer, and this copy follows it. The priority and the refusal to
     relabel are unchanged. -->

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

**US012's 2 SP fitted other records on arithmetic, so its placement here was a call, and the
difference is recorded.** Measured 21/09/2026:

| Record      | Stands at                                                         | With US012's 2 SP   | Reading                                    |
| ----------- | ----------------------------------------------------------------- | ------------------- | ------------------------------------------ |
| `SPRINT-01` | 10 / 11, CLOSED                                                   | 12 / 11             | Into grace, and closed by call             |
| `SPRINT-02` | 8 / 11, CLOSED                                                    | 10 / 11             | Fits capacity, and closed by call          |
| `SPRINT-03` | 8 / 11, closed, holding a reservation; 13 / 11 with US003's carry | 10 / 11, or 15 / 11 | Over grace if the carry lands              |
| `SPRINT-04` | 13 / 11, at grace, CLOSED                                         | 15 / 11             | Over grace, from the ceiling               |
| `SPRINT-05` | 13 / 11, at grace, CLOSED                                         | 15 / 11             | Over grace, from the ceiling               |
| `SPRINT-06` | 8 / 11, closed, holding a reservation                             | 10 / 11, or 15 / 11 | Over grace if the carry lands              |
| `SPRINT-07` | 8 / 11, open, `Must` tier absent                                  | 10 / 11             | Fits capacity, open, and supplies the tier |

Only `SPRINT-02` and this record take 2 SP inside capacity without spending the grace a reserved
carry needs, and `SPRINT-02` is closed by <%DEVELOPER_NAME%>'s call of 07/09/2026 — a ledger is
closed by a call, not only by a ceiling. `SPRINT-03` and `SPRINT-06` are both closed as well, and
could take it only by spending the grace their reserved 5 SP carries need: 8 + 2 + 5 is 15 / 11.
This record was the one open record, and the one whose missing tier a `Must` repairs.
<%DEVELOPER_NAME%> placed US012 here on 21/09/2026 (Q2), and
`project-management/src/02-STORIES/US012.md` records `SPRINT-06` as closed to admission and not a
candidate.

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
| `SPRINT-07` | US012 (`Must`, 2) then US011 (`Should`, 8, stretch)             | 10 / 11 — closed                                            |

Each record owns its own row, and **every record carries the whole table**: a membership or a
capacity change is written into every copy in the same change. It is maintained by hand — no gate
reads it, and that cost is filed in `GAPS.md` (17/09/2026). Rule:
`project-management/docs/planning/SPRINTS.md`. Obligation:
`project-management/src/03-SPRINTS/CLAUDE.md`.

<!-- THE SAME ROW CHANGED AGAIN LATER ON 21/09/2026, at 03-sprint-planning. The SPRINT-07 row's
     SP cell read "10 / 11 — open" from US012's admission, recorded below, until
     <%DEVELOPER_NAME%> closed that record to further admission by call at 10 / 11: its 1 SP of
     headroom is not spoken for, and the next map's slices estimate at 3 to 8 SP, so nothing
     coming fits it. It reads "closed" as the SPRINT-01 and SPRINT-02 rows do for a close by call,
     and its members did not move. A new admission opens SPRINT-08, which the first story admitted
     to it creates and which does not exist yet. No other row moved; checked against each record's
     own capacity line as well as against the other copies, per
     project-management/src/03-SPRINTS/CLAUDE.md, and every row agrees with its source. -->

<!-- ONE ROW CHANGED, 21/09/2026 at 03-sprint-planning. The `SPRINT-07` row read
     "US011 (`Should`, 8)" and "8 / 11 — open, `Must` tier absent" from 20/09/2026 until that day.
     US012 (`Must`, 2), cut the same day from
     project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md slice `S-02`, was admitted as that
     record's `Must` tier and builds ahead of US011, which becomes its stretch; the record stands at
     10 / 11, inside capacity and short of the fill trigger. No other row moved. Checked against
     each record's own capacity line as well as against the other copies, per
     project-management/src/03-SPRINTS/CLAUDE.md, and every row agrees with its source. -->

<!-- UPDATED AGAIN LATER ON 21/09/2026, on the close by call: this record's row reads
     "10 / 11 — closed", in the words SPRINT-01's and SPRINT-02's rows use for the same kind of
     close, and no row in the table now reads open. The Notes carry the close and what it owes.
     The comment below is as written at US012's admission, the one beneath it as written on
     20/09/2026. -->

<!-- UPDATED 21/09/2026: this record's row now reads "10 / 11 — open", and the `Must`-tier clause
     left the cell with the absence it named. It is still the only row in the table that reads
     open; the Notes carry what remains admissible, and the cell does not try to. The comment below
     is as written on 20/09/2026. -->

<!-- This record's own row is the only one in the table whose SP cell states a posture rather than a
     closure: "open, `Must` tier absent". It is written that way because "8 / 11" alone would read
     as an ordinary under-filled sprint and hide the thing this record most needs a backlog reader
     to know. The register's other six rows are unchanged in meaning from 17/09/2026; the prose
     above lost its hardcoded count and the SPRINT-05 row was repaired, both at 03-sprint-planning
     on 20/09/2026 (Q4 and Q3) and both recorded in
     project-management/src/03-SPRINTS/SPRINT-06.md's own register comment rather than restated
     here. -->

**Capacity: 10 / 11 — inside capacity, 2 committed and 8 stretch, and 1 SP of headroom
(21/09/2026).** US012's admission spent 2 of the 3 SP this record opened with. The 1 SP left is
unclaimed: unlike `project-management/src/03-SPRINTS/SPRINT-06.md`, whose 3 SP is spoken for by
US009's reserved carry, nothing is reserved into this record. `project-management/docs/planning/CADENCE.md` ->
_Sprint capacity — the trigger_ owns both figures as generation-time answers,
`SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`; in this template repository the table is unrendered and
the 11 and 13 every record uses are the `copier.yml` defaults. <!-- doc-references: template-only -->
The same section reads: "Capacity is a **trigger**, not a target to fill exactly."
`project-management/docs/planning/SPRINTS.md` -> _Capacity_ asks that an under-capacity sprint be
called out in the notes rather than padded; called out here, and the 1 SP is not padded with a story
cut to fill it.

<!-- Read "**Capacity: 8 / 11 — inside capacity, 3 SP of headroom, and genuinely open.** Unlike
     `project-management/src/03-SPRINTS/SPRINT-06.md`, whose 3 SP is spoken for by US009's reserved
     carry, this record's headroom is unclaimed." and "the 3 SP is not padded with a story cut to
     fill it" from 20/09/2026 until 21/09/2026. The sourcing of the two figures is unchanged. -->

**`Timeline: TBD`, so scope-against-duration is unmeasurable and is recorded as such.**
`project-management/workflows/03-sprint-planning/CHECKLIST.md` asks that "Scope is realistic for
the sprint duration"; with no dates that box has nothing to divide the points by, and **it is
marked unmeasurable rather than ticked**. No record in `project-management/src/03-SPRINTS/` has
ever carried a date, and inventing one here would put the only unmeasured figure in this file into
the line a reader trusts most. Per `code/docs/GATE-REPORTING.md` a check that could not run is
reported, never passed. It becomes answerable the moment a timeline is set.

**CLOSED to further admission by call (21/09/2026), and the 1 SP of headroom is not spoken for —
nothing coming fits it.** <%DEVELOPER_NAME%> settled at `03-sprint-planning` on 21/09/2026 that
this record admits nothing further at 10 / 11 SP. It was Q1 of that day's follow-up round — three
questions US012's QA gate and its admission here left open, distinct from the MAP-SCRIPT-GUARDS
interview round this record cites as Q1 and Q2 above. **The reason is the size of what comes
next**: the next map's slices estimate at 3 to 8 SP, so no story in view fits the last 1 SP. A
3 SP story would stand this record at 13 / 11 and make it the third to take grace, which is the
signal the bullets below name rather than room; anything larger is past the ceiling. The estimate
is <%DEVELOPER_NAME%>'s, given with the call: no map under
`project-management/src/01-FEATURE-MAPS/` records story points, measured 21/09/2026, so it is the
call's stated reason and not a figure this record measured. Nothing is reserved into the 1 SP, as
the capacity paragraph above records, and it is left unused rather than padded. Closed by
decision, on SPRINT-01's and SPRINT-02's precedents of 07/09/2026 and SPRINT-06's of
20/09/2026: a ledger is closed by a call, not only by a ceiling.

<!-- CITATION CORRECTED AT REVIEW, 21/09/2026. As first written, the middle precedent read
     "SPRINT-03's of 05/09/2026", inherited from SPRINT-05's and SPRINT-06's CLOSED paragraphs.
     It disagrees with the record it cites: SPRINT-03's close by call is dated 06/09/2026 in its
     own Notes (on 05/09/2026 it was "still admitting"), and that call was superseded on
     07/09/2026 — SPRINT-03 now stands closed on arithmetic, "That is arithmetic rather than a
     call". The close-by-call precedents that still stand are SPRINT-01 and SPRINT-02 (both
     07/09/2026) and SPRINT-06 (20/09/2026) — the set the register comment in every copy names.
     A citation is a fact looked up, not a call, so it is corrected here rather than asked.
     SPRINT-05's and SPRINT-06's CLOSED paragraphs, committed before this change, still carry the
     inherited citation; correcting them is a separate follow-up. -->

**A new admission opens SPRINT-08, and that record does not exist yet.** It is opened by the first
story admitted to it, at `03-sprint-planning` — as SPRINT-05, SPRINT-06 and this record each were
— and not in advance, so this change does not create it. Until it exists there is no receiving
record, which is also why the Definition of Done's drop branch for US011 still names none.
Updated 27/09/2026: `project-management/src/02-STORIES/CUT-PLAN.md` P8 gives that record to
RULE-OWNERSHIP, US013 then US014 at 11 / 11. It still does not exist, and once it opens it is full,
so it cannot receive US011's 8 SP either. The Definition of Done carries the arithmetic.

**As admitted, 21/09/2026, and superseded by the close above the same day — OPEN to admission
then, on a narrower reading: the tier it was held open for had arrived, and 1 SP of headroom was
what remained.** No call to close the record had been recorded at admission — the course
`project-management/src/03-SPRINTS/SPRINT-01.md` and
`project-management/src/03-SPRINTS/SPRINT-06.md` took, a ledger being closed by a call and not only
by a ceiling — so it read open until the call above was made. What would change the position, each
<%DEVELOPER_NAME%>'s call at the time and not this record's to pre-empt:

- **A story of 1 SP, of either tier, lands the record on 11 / 11 — AT capacity, which is the fill
  trigger** (`project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_).
  Such an admission closes this record and owes it a plan in the same breath, and the plan can be
  written only once every member has cleared the specify tier, which US011 has not — see the plan
  paragraph below.
- **A story of 2 or 3 SP** stands it at 12 or 13 / 11, in grace. `CADENCE.md` reads: "Grace exists
  for one situation: the next story would overshoot, and splitting it would produce two halves that
  make no sense alone", and "a sprint that habitually runs to it means the capacity figure is
  wrong". Two records have taken it — SPRINT-04 (07/09/2026) and SPRINT-05 (17/09/2026) — and **a
  third is the signal**, the threshold this record's 20/09/2026 bullet below and SPRINT-05's CLOSED
  paragraph both state. Such an admission here would be that third.
- **A second `Should` is no longer refused for its tier.** The 20/09/2026 refusal below rested on "a
  record with two droppable members and nothing to protect"; with US012 in, there is something to
  protect, and a `Should` is bound by the arithmetic above like any other story.
- **A story of 5 SP or more** is 15 / 11 or over, past the grace ceiling, and is refused on
  arithmetic before it is argued.

<!-- SUPERSEDED LATER ON 21/09/2026 by the close by call above. The bold sentence opening this
     block read "**Still OPEN to admission (21/09/2026), on a narrower reading: the tier it was
     held open for has arrived, and 1 SP of headroom is what remains.**" from US012's admission
     until the close, and the sentence after it read "No call to close the record is recorded —
     the course `project-management/src/03-SPRINTS/SPRINT-01.md` and
     `project-management/src/03-SPRINTS/SPRINT-06.md` took, a ledger being closed by a call and
     not only by a ceiling — so it reads open until one is made." over the same span. Both were put
     into the past tense at the close: this comment does not render, and in the present tense the
     block read open on the page beneath the CLOSED paragraph. The rest of the block is as written
     then, in that moment's tense. None of its bullets fired — no story was admitted after US012 —
     and the one thing it said would settle the position, a call to close the record, is what
     happened. It is kept because its arithmetic is what the close rests on, and because the
     grace-signal threshold its second bullet states is the one the close cites. -->

**As opened, 20/09/2026 — OPEN to admission, and what would change the position.** Each is
<%DEVELOPER_NAME%>'s call at the time, not this record's to pre-empt:

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

<!-- The first bullet fired on 21/09/2026, exactly as it read: US012 is a `Must` of 2 SP and went in
     with headroom to spare, owing no plan. The second and fourth are overtaken by the arithmetic
     above — a `Must` of 5 or 8 now lands at 15 or 18 / 11 — and the third by the bullet above that
     lifts it. They are kept because they are what the admission had to satisfy, and because the
     grace-signal threshold the second states is the one the bullets above cite. -->

**A candidate that has not cleared the specify tier is not counted** (`CADENCE.md` -> _When a sprint
plan is written_: "resolve it or drop it back to the backlog rather than planning a sprint around
it"). The uncut slices on `MAP-REGISTER-INDEXES.md` — `S-03` and `S-04` — were the obvious
candidates for the `Must` this record wanted on 20/09/2026, and **neither is a story**; the tier
came instead from `MAP-SCRIPT-GUARDS.md`, whose `S-02` was cut as US012, and this record pre-counts
neither of the two. `project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md`, charted
by a concurrent session and committed on 20/09/2026 in `50e22ad` — its header still reading 21 open
/ 9 blocking on 21/09/2026 — can produce no story and is likewise not counted.

<!-- CORRECTED 21/09/2026. Read, from 20/09/2026: "The uncut slices on `MAP-REGISTER-INDEXES.md` —
     `S-03` and `S-04` — are the obvious candidates for the `Must` this record wants, and **neither
     is a story**; this record pre-counts neither.
     `project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md`, charted by a concurrent
     session and untracked on 20/09/2026 at 21 open / 9 blocking, can produce no story and is
     likewise not counted." The first sentence is re-tensed because the `Must` it looked for has
     arrived. "Untracked" WAS TRUE WHEN WRITTEN and is corrected rather than struck: this record
     opened in `9901d9c` at 16:51 on 20/09/2026 and the map was committed in `50e22ad` at 16:57 the
     same day, so the word went stale six minutes after it was written.
     project-management/src/03-SPRINTS/SPRINT-06.md -> Dependencies carries the same correction. -->

**The close owes this record its plan, and `07-SPRINT-PLAN-07.md` is not written yet — owed, not
omitted.** Closed with nothing reserved into it, the record's story set is settled, and
`project-management/docs/planning/SPRINTS.md` -> _Two artefacts, two moments_ writes the plan
"once, against a settled story set". <%DEVELOPER_NAME%>'s call names what the close owes:
`16-sprint-plans` for this record, and `17-story-plans` for US012 at its reserved `11-` and for
US011 at its reserved `12-`. **None of the three is written in the change that closed the record,
and none is dated, because a prerequisite is unmet.**
`project-management/workflows/16-sprint-plans/STEPS.md` Step 1 requires the gate documents to be
"complete and committed before writing the sprint plan", and on 21/09/2026 neither member's are.
US012's QA plan is complete — `Reviewed`, all nine gaps resolved, four of them settled by
<%DEVELOPER_NAME%> — but untracked, so not committed. US011's belongs to the concurrent session:
a `Draft` with thirteen `[OPEN]` gaps, whose resolutions that session holds back until this one's
work is committed. **That hold lifted on 27/09/2026:** US012's work now runs alongside US010's and US011's
(`project-management/src/02-STORIES/CUT-PLAN.md` P9), so neither waits for the other's commit;
the commit prerequisite above still stands. US011's plan has since been written back: it reads
`Reviewed`, all thirteen gaps resolved into the story on 27/09/2026, and is untracked until the
US011 commit — complete, like US012's, and not yet committed. The two story plans wait on the sprint plan as well, because
`project-management/workflows/17-story-plans/STEPS.md` Step 1 gathers it first. The plans are
written once both members' gate documents are complete and committed, and not before. The ledger
and the plan still count differently:

- **The ledger counts every admitted story: 10.** A story is admitted at gate `03` and the ledger
  moves then. 10 of 11 is not the fill trigger; what owes the plan is the call, not a fill.
- **The plan counts only stories that have cleared the specify tier: 2, US012's.** `CADENCE.md` ->
  _When a sprint plan is written_ names prerequisites that must hold for **every story in the
  filling sprint**. **US012 meets them**, measured 21/09/2026: its QA plan,
  `project-management/src/11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md`, reads `Reviewed`
  with all nine `AC-GAP` entries resolved into the story, and the four that rested on a call
  settled by <%DEVELOPER_NAME%> the same day; its `## Decisions` records none, so
  `15-decisions` has nothing to accept or decline; GDPR, Security, SEO and API are skipped by flag,
  Security with its reason; and its acceptance criteria and estimate are complete. **US011 still
  satisfies none**: measured 20/09/2026 and unchanged at 16:40 on 21/09/2026, it had no ADR and
  recorded one ADR candidate in its own `## Decisions`; it was named by no artefact under
  `project-management/src/10-SECURITY/` or `project-management/src/11-QA/`; and it has no story
  plan, `12-` being a reserved number rather than a file. **A concurrent session has since put the
  second clause out of date and bears on the first**, all untracked:
  `project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md` and US010's two
  gate-`10` plans name US011, and
  `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`
  (`Proposed`) lists US011 as related. **As read on 27/09/2026, US011 meets the QA prerequisite in
  content and not yet the whole set.** Its QA plan reads `Reviewed`, all thirteen gaps resolved
  into the story that day, but is untracked until the US011 commit, and
  `project-management/workflows/16-sprint-plans/STEPS.md` Step 1 needs it committed; its decisions
  prerequisite waits on the read-rule ADR, as the next sentences record; and its story plan is
  unwritten. So US011 is not yet counted. Updated 21/09/2026 at `15-decisions`, written back
  27/09/2026: US011's ADR candidate is subsumed by
  `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`, recorded
  under US010. US011 carries no ADR of its own, and its decisions prerequisite is met when that
  record is signed off `Accepted`. It still reads `Proposed`, and is accepted in this pass, after
  an independent review and before the US010 commit (settled 27/09/2026, grilling round 4 Q27).

**So the plan the close owes waits on US011.** `CADENCE.md` binds every story in the filling
sprint, and "a story that cannot satisfy these is not ready to be counted towards the sprint".

**Story cutting does not wait for it.** <%DEVELOPER_NAME%> settled on 21/09/2026 that
`02-story-creation` continues into `SPRINT-08` while this record's plan, and `SPRINT-06`'s, wait on
their members' gate documents, and that both are written once those are committed.
`project-management/workflows/CONTEXT.md` -> _The planning cadence_ runs `16` and `17` "before
planning resumes"; this is a recorded departure from that order, not an oversight. It has
precedent, because US011 was cut and admitted after `SPRINT-06` closed on 20/09/2026 with no plan
written. It also costs little here. The next stories are cut from `MAP-RULE-OWNERSHIP.md`, and
only one of its slices touches a file this record's members edit: `S-09` (Batch H) edits
`.github/scripts/shipped-artefacts.sh` beside US012 (`MAP-RULE-OWNERSHIP.md:1011-1024`), so that
story names US012 in its dependencies.

<!-- 21/09/2026, on the close by call. The bold sentence opening this block read "**No ... is
     written, and its absence is by rule, not omission.** The record's ledger and the plan's count
     are two different numbers, and this record is at neither trigger."; the ledger bullet ended at
     "10 of 11 is not the fill trigger."; and the sentence after the bullets opened "**So a fill
     would owe a plan that waits on US011.**" — each from US012's admission until the close. Both
     counts are unchanged; what changed is that a call, not a fill, now owes the plan, and the
     plan is still unwritten. -->

<!-- Read "The ledger counts every admitted story: 8 ... 8 of 11 is not the fill trigger." and "The
     plan counts only stories that have cleared the specify tier: 0 ... US011 satisfies none ... `11-`
     being a reserved number rather than a file." from 20/09/2026 until 21/09/2026. US011's reserved
     number moved with the build order; see Dependencies. -->

<!-- AMENDED 27/09/2026 after two verified passes of the US010 / US011 write-back, when
     project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md reached
     `Reviewed`. The plan-count bullet named that plan "(`Draft`, thirteen `[OPEN]` gaps)" and closed
     "None yet meets a `CADENCE.md` prerequisite — a QA plan with unresolved gaps, an ADR not
     accepted — and US011's gate-`11` close rewrites this bullet"; this is that rewrite. The
     paragraph above the bullets gains the plan's state beside US012's. Both counts are unchanged:
     the ledger at 10, the plan at 2, US011 still short of the whole set. -->

`project-management/src/16-SPRINT-PLANS/CLAUDE.md` forbids a plan without a matching record — "do
not create an orphan plan" — and nothing forbids a record without a plan; that is a record's
ordinary state between opening and filling, and this record's between its close and the plan the
close owes.

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

**Re-measured 21/09/2026 on US012's admission, at HEAD `71a32d7` with the change unstaged — and
comparable, because every file in the folder is tracked.** The index caveat
`project-management/src/03-SPRINTS/SPRINT-06.md` records bites on an untracked citing file, and
none is in scope here; the proof is that the same run before this change's first edit reproduced
the 20/09/2026 staged figures exactly, 170 across the folder and 23 in this record. After the change
the scoped run exits `1` with **190** — **162 instance, 27 dangling, 1 template-only, 0
plan-prefix**. Per file: `CONTEXT.md` 1 · SPRINT-01 18 · SPRINT-02 32 · SPRINT-03 32 · SPRINT-04
27 · SPRINT-05 19 · **SPRINT-06 24** · **SPRINT-07 37**.

**All 20 new findings are the inherited instance class, and none is dangling.** Each sibling gains
one bare record name, from the dated register comment every copy carries. This record gains
fourteen: seven from the arithmetic table US012's placement is argued with, five from the paragraph
beneath it, one from its own copy of that register comment, and one from a Definition of Done row
keyed by story. **This record's `dangling` count is still 0**, which is the criterion the
Verification Checks set.

**Re-measured 21/09/2026 on the close by call, unstaged as before: unchanged.** The scoped run
exits `1` with 190 across the folder — the same 162 instance, 27 dangling and 1 template-only, and
the same count in every file, this record's 37 included. The close names records and stories in
plain prose rather than in backticks, which is what the gate reads, so it adds no finding.

**Re-measured 27/09/2026 on the recompute after US011's gate write-back — this file alone,
unstaged: down one, and still 0 dangling.**
`bash code/src/scripts/audits/doc-references.sh --path project-management/src/03-SPRINTS/SPRINT-07.md`
exits `1` with 41 instance findings before this change's first edit and 40 after. The one that went
is the backticked US010 that the FLAGS Security row dropped when it took the member's corrected
wording. The recompute writes records and stories in plain prose, as the close did. **The
folder-wide figure was not re-run**, because the sibling records are being amended in the same pass
and a folder figure taken now would describe no settled state; per `code/docs/GATE-REPORTING.md`
that is reported, not inferred from this file's count.

---

## Acceptance Criteria

Two outcomes, one per member, in build order.

**US012** — check 4 of `.github/scripts/shipped-artefacts.sh` asserts that every file named in
`SEEDED` landed in the generated project, however many entries the array holds, and reports one
that did not as a seed that did not land — pointing at its `mv .copier/` line in the copy-gated
`_tasks` entry, and never advising a `!` negation, in the finding or in the closing guidance printed
beneath it; `--self-test` gains a sixth probe that moves the last entry of `SEEDED` out of the
caller's generated tree and sees exactly one finding, and that probe is shown red against today's
check 4 before it is green; and the script's header, its `--help` text and the comments above
`SEEDED` and check 4 stop claiming a coverage the script lacks, with the "What it CANNOT check"
paragraph unchanged, because presence is asserted and content is not.

**US011** — the four indexes `project-management/src/03-SPRINTS/SPRINT-06.md` shipped declaring
their own debt carry one row per instance — a tracked file matching its register's filename pattern
(settled 27/09/2026, grilling round 3 Q22) — counted from the tree at implementation time and never
from the figure of 43 the story was cut against; each row's `Status` mirrors the artefact's own
value verbatim, read from the carrier that register actually uses — the bold `**Status:**` prose
line for `02-STORIES`, `03-SPRINTS` and `15-DECISIONS`, the backticked table cell for
`17-STORY-PLANS` — with no register's vocabulary translated into another's; `DECISION-INDEX.md`
carries the `Supersedes` / `Superseded by` tail US010 designed, with every `Superseded` ADR naming
its replacement and no chain dangling; every `Status` is read under the one read rule of
`project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`, under which
the one ADR carrying a trailing HTML comment reads `Proposed` and string-equals its row, the reading
recorded, **without that ADR being edited**; each index honours the ordering rule its own file
states; the `Backfill owed — US011` line is gone from all four files and from nothing else, with
`FINDING-INDEX.md` and `BUG-INDEX.md` untouched; and a generated project still receives all four
blank, with no syntek-base literal in any of them and no leak reported by
`.github/scripts/shipped-artefacts.sh`.

<!-- AMENDED 27/09/2026, on US011's gate write-back. The US011 paragraph read "the one ADR whose
     status value carries a trailing HTML comment is handled and its divergence from `N-003`'s
     string-equality clause recorded" from 20/09/2026. One read rule now governs every register's
     Status (settled 21/09/2026, grilling round 1 Q5), and under it no divergence remains to record
     (QA-PLAN-US011 AC-GAP-1 and AC-GAP-4). "One row per instance" now names the positive,
     per-register filename test (round 3 Q22) that replaced the negative one. -->

### Security Acceptance Criteria — N/A

<!-- REMOVED BY FLAG, and the removal is stated rather than silent. The sprint's Security row reads
     N/A because both members' do, and the template says to remove this section when it does.
     Per code/docs/GATE-REPORTING.md a removed section reads as a gate that did not apply — which is
     correct here, and is why this comment stands in its place rather than a checklist of rows
     nothing would bind.

     WHAT THE N/A DOES NOT MEAN. It does not mean the member is risk-free: it writes one real
     syntek-base row per instance — 47 tracked on 27/09/2026 — into files whose seeds must stay
     blank, and a leak would be permanent. It means the control for that hazard is built, gated and
     owned ELSEWHERE — US010's `ST03`, `ST04` and `ST06`, gated in
     `.github/scripts/shipped-registers.sh`, in project-management/src/03-SPRINTS/SPRINT-06.md —
     and that this member exercises it rather than adding to it. The assertion that would catch a
     regression is US011's generated-tree grep row below, and it is deliberately an integration
     criterion rather than a security one. If `10-security-checks` reads it differently, the
     member's flag changes, this union changes with it, and this section is written.

     US012, ADMITTED 21/09/2026, IS N/A FOR A REASON OF ITS OWN, and the paragraph above is US011's.
     US012 adds a presence assertion to a CI integrity gate: no authentication, no personal data, no
     endpoint, and no control whose pass condition it loosens. Its one failure mode is silence, and
     silence is what its self-test probe proves against — a QA assertion rather than a security
     design. It does not follow the US006 and US010 divergence, both of which ship a fail-closed
     control over a one-way door (project-management/src/02-STORIES/US012.md, Provenance block).
     The first sentence of this comment read "because its sole member's does" until that day.

     AMENDED 27/09/2026, on US011's gate write-back. The second paragraph read "43-odd real
     syntek-base rows" and "US010's `ST03` and `ST04` and its enlarged `SEEDED` array" until that
     day. The count is re-measured under the positive instance test (settled 27/09/2026, grilling
     round 3 Q22): 11 + 7 + 20 + 9 tracked. Untracked that day and not counted: US012.md and
     US010's two ADRs, each matching its pattern and counted once committed. The control is named
     as the member now names it (TM-09, assessment Section 7.12). `SEEDED` is an allowlist, not the
     seed-purity control, and is described as one wherever it is cited. -->

### QA Acceptance Criteria — Automated

<!-- First-pass from the manifest; no QA-PLAN-US011-* exists under
     project-management/src/11-QA/PLANNING/ on 20/09/2026. Rewritten at gate 11's close.
     Still true at 16:40 on 21/09/2026, when this record was last measured. A concurrent session
     has since written
     project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md, untracked
     and `Draft`, so US011's rows below stay first-pass until that gate closes.
     27/09/2026: they now carry that plan's gap resolutions, written back into US011 that day and
     mirrored below. The plan read `Draft` at that write-back, and reads `Reviewed` later the same
     day, all thirteen gaps resolved into the story; this comment said "The plan itself still reads
     `Draft`" until then (AMENDED 27/09/2026 after two verified passes of the write-back).
     US012's rows are NOT first-pass: its gate 11 closed on 21/09/2026 in
     project-management/src/11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md, and the rows below
     are drawn from the QA Acceptance Criteria that gate wrote back into its story. They lead the
     list because US012 builds first. -->

- [ ] US012 — `bash .github/scripts/shipped-artefacts.sh --self-test <generated-tree>` exits 0 as
      `.github/workflows/audit-template.yml` runs it, in CI's `[3/4]` job on the pushed story
      branch and never against a tree made with a raw `uvx copier copy`, with the seeded-deletion
      probe among its probes seeing exactly one finding and the success line counting **6 probes**
      where it counted 5
- [ ] US012 — the probe is shown **red before it is green**: committed and pushed without the loop,
      on a tree in which every seed is present, its own line reports zero findings while the other
      five probes pass. **The probe line is the evidence, never the exit code alone** — a tree
      lacking the seed aborts the probe's `mv` with the same exit 1 and no probe line. Both run IDs
      are recorded in the story's test-status record
- [ ] US012 — the existing seed cases still pass unchanged: the clean baseline, which now asserts
      every seeded file landed, and check 3's map-leak probe beside the seeded
      `MAP-SCALE-PLANNING.md`, which must still see exactly one finding
- [ ] US012 — the probe's substring runs from the moved path into the seed's own wording, shown by
      a string test against the named-file message; the **negative** half — no `!` negation advice
      in the finding or the closing guidance beneath it — is read at review and recorded as read,
      never as asserted
- [ ] US012 — a ShellCheck result over `.github/scripts/shipped-artefacts.sh` is recorded as clean,
      as findings, or as not run with its reason, and **never as a `lint.sh` pass**

- [ ] US011 — the `[3/4] Template Generation` job generates a project on every render path the
      template offers (today: `INCLUDE_MOBILE` true and false — settled 27/09/2026, grilling round
      3 Q23) and a grep over each generated tree finds no `US###`, `SPRINT-##`, `ADR-US###` or
      `STORY-PLAN-US###` literal inside any index file, the 000 template identifiers a seed may
      name excepted
- [ ] US011 — `bash .github/scripts/shipped-artefacts.sh --self-test` passes **unchanged by US011's
      diff** — US011 adds no registration and must not need one; a change from its diff means an
      index moved or a seed was polluted. US012 changes the script in the same sprint, and this
      criterion reads US011's own diff, never the file; `.github/scripts/shipped-registers.sh`
      (with `--self-test`) and `.github/scripts/shipped-ai.sh --self-test` likewise pass unchanged
      by US011's diff, as does the `shipped-ai.py` the wrapper execs. Both carry US010's
      index-seed checks (settled 21/09/2026, grilling round 1 Q2 and Q3), which US010 changes in
      SPRINT-06; US011 must need an edit to neither
- [ ] US011 — `bash code/src/scripts/audits/doc-references.sh`: read as a diff against the
      baseline per ADR-US003 and never as a bare pass; the Markdown links US011's rows carry are
      invisible to this gate (`code/src/scripts/audits/doc-references.sh:599` reads backticked
      tokens only)
- [ ] US011 — every Markdown link in the four indexes resolves: each target tested for existence
      from its index's folder, with the count of links checked recorded beside the count of rows
- [ ] US011 — `bash code/src/scripts/audits/docs-length.sh` passes — the four indexes are register
      artefacts under `src/` and exempt from the 300-line ceiling, but the audit is run so the
      **exemption is proved rather than assumed**
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` passes
- [ ] Coverage floors — **N/A**, and marked rather than deleted. Neither member ships Python —
      US011 ships Markdown plus its generated-tree grep in the `[3/4]` job of
      `.github/workflows/audit-template.yml`, and US012 one bash script — the Backend flag reads
      `N/A`, and the floor has nothing to bind

<!-- 21/09/2026, on US012's admission. The self-test row above read "`bash
     .github/scripts/shipped-artefacts.sh --self-test` passes **unchanged** — this sprint adds no
     registration and must not need one; a change here means an index moved or a seed was polluted"
     and was scoped to the sprint; US012 changes that script, so it is re-scoped to US011's diff,
     which is what it always tested (project-management/src/02-STORIES/US012.md -> Dependencies).
     The coverage row read "The member ships Markdown only". The generated-tree grep, doc-references
     and docs-length rows were unkeyed, and doc-references read "the 43-odd links this sprint
     writes"; all three are US011's alone, so they are keyed for the drop branch the Definition of
     Done settles by story key. Docs-pairing stays unkeyed, binding both. Lifted out of the list
     because Prettier re-indents a comment's continuation lines inside a list item on every pass —
     SPRINT-05's finding of 20/09/2026. -->

<!-- 27/09/2026, on US011's gate write-back (QA-PLAN-US011 AC-GAP-6, AC-GAP-7 and AC-GAP-11;
     settled that day, grilling round 3 Q23). Four changes, all in US011's rows. The generation row
     read "on **both** answer sets (`INCLUDE_MOBILE` false and true)"; it is reworded path-neutral,
     and it excepts the 000 template identifiers, as the member's own criterion does. The self-test
     row ended at "never the file", and gains US010's two index-seed scripts. The doc-references
     row read "every one of the 43-odd links US011 writes resolves", which that gate cannot see,
     because it reads backticked tokens only. The new link-resolution row carries that obligation
     instead. Every US011 row is keyed for the drop branch as before. Lifted out of the list for
     the Prettier reason recorded above. -->

### QA Acceptance Criteria — Manual

<!-- Manual is the load-bearing half here, not the residue. No script can judge whether one line of
     plain English describes an ADR to someone who has not read it, and that bar is `N-002`'s. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US011-MANUAL-TESTING.md` carries a tester sign-off block.
      US012's QA flag names no manual type, so it owes no manual-testing record
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in either member's QA plan. US012's closed on
      21/09/2026 with all nine resolved. US011's had not been written at 16:40 that day; a
      concurrent session opened it as a `Draft` with thirteen `[OPEN]` gaps, and on 27/09/2026 it
      reads `Reviewed`, all thirteen resolved into the story. Both plans are untracked until their
      stories' commits, and the row is ticked at close against the plans as committed, not before

<!-- 21/09/2026, on US012's admission. The sign-off row named US011's record alone, and the last row
     read "in the member's QA plan — which gate `11` has yet to write; until it exists this row
     cannot be ticked, and its absence is not a pass". Lifted out of the list for the Prettier
     reason recorded under QA Acceptance Criteria — Automated. -->

<!-- AMENDED 27/09/2026 after two verified passes of the US010 / US011 write-back. The QA-plan row
     closed "a concurrent session has since opened it as a `Draft` with thirteen `[OPEN]` gaps.
     Until they close this row cannot be ticked, and a `Draft` is not a pass" until that day, when
     project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md reached
     `Reviewed`. Lifted out of the list for the same Prettier reason. -->

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Script and Header-Contract Tasks

<!-- The template has no script-tasks section and US012's Backend flag reads N/A — it ships one bash
     script under .github/scripts/, not Python — so its work is carried under a heading of its own,
     on the precedent this record set for US011 below and SPRINT-05 set for US008's guide rewrite.
     The header contract is prose in the same file, so it travels with the script rather than
     splitting into a documentation section; the map's "Docs: the script's own header contract" is
     not one of the thirteen gates, which is why US012 carries it as tasks and not as a flag. -->

| Story | Task                                                                                                                                          | Done |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US012 | Add a third loop to check 4, beside the `NAMED_SHIPPED` loop, asserting every entry of `"${SEEDED[@]}"` landed — never `"${SEEDED}"`          | [ ]  |
| US012 | Give its finding the seed's repair — the path, then that it was seeded and did not land, then its `mv .copier/...` line — and no `!` negation | [ ]  |
| US012 | Stop the closing guidance printed beneath the findings sending a seed finding to the `copier.yml` allowlist                                   | [ ]  |
| US012 | Add the `--self-test` probe after the check-4 probe, moving the **last** entry of `SEEDED` by index expression — never a literal path         | [ ]  |
| US012 | Leave `SEEDED` itself alone — growing it is US010's, and the loop must pass on one entry or eight                                             | [ ]  |
| US012 | Rewrite the header contract — numbered list, too-tight and self-test paragraphs, exit-code lines, `--help`, the comments above `SEEDED`       | [ ]  |
| US012 | Leave the "What it CANNOT check" paragraph unchanged — presence is asserted, content is not                                                   | [ ]  |
| US012 | **Verify, do not re-cut** the `S-02` row on `MAP-SCRIPT-GUARDS.md`, and hand its `Register claimed` row to `22-implementation-documentation`  | [ ]  |

### Measurement and Backfill Tasks

<!-- The template has no documentation-tasks section and this sprint's deliverable is entirely
     documentation, so its work is carried here on SPRINT-05's precedent, which carried US008's
     five-guide rewrite under its Backend Tasks.
     21/09/2026: "entirely documentation" is US011's half now, not the sprint's — US012 ships one
     bash script, carried in the section above. -->

| Story | Task                                                                                                                                                                                                                                                                                                                | Done |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| US011 | Re-count the instances in all four registers against `N-003`'s positive, per-register filename test and record the count with its date — do not inherit 43                                                                                                                                                          | [ ]  |
| US011 | Confirm `20-FINDINGS` and `21-BUGS` still hold zero; if not, hand back to US010's presence clause rather than absorbing it                                                                                                                                                                                          | [ ]  |
| US011 | Read each register's status carrier and confirm it is still the one measured 20/09/2026 — three prose lines, one table cell                                                                                                                                                                                         | [ ]  |
| US011 | Fill `STORY-INDEX.md` — one row per `US###.md`, ascending by identifier                                                                                                                                                                                                                                             | [ ]  |
| US011 | Fill `SPRINT-INDEX.md` — one row per `SPRINT-##.md`, ascending by number                                                                                                                                                                                                                                            | [ ]  |
| US011 | Fill `DECISION-INDEX.md` — ascending by `US###` then Date, ties per the file's rule, with the `Supersedes` / `Superseded by` tail filled for every chain                                                                                                                                                            | [ ]  |
| US011 | Fill `STORY-PLAN-INDEX.md` — ascending by build-order prefix, status read from the table cell under the read rule                                                                                                                                                                                                   | [ ]  |
| US011 | Write every `Summary` for a reader who has not opened the artefact — never the filename restated                                                                                                                                                                                                                    | [ ]  |
| US011 | Remove the `Backfill owed — US011` line from all four files, and from nothing else                                                                                                                                                                                                                                  | [ ]  |
| US011 | Record which rows the read rule normalised, citing the read-rule ADR; that it reads the one trailing-comment ADR as `Proposed`, and why that ADR was not edited; and that no instance file was edited                                                                                                               | [ ]  |
| US011 | Update each touched `CONTEXT.md`'s `**Last Updated**` date where its index section's wording changes                                                                                                                                                                                                                | [ ]  |
| US011 | At its gate-`22` pass, write the `GAPS.md` entry for TM-10's window — once US011 ships, the four backfilled indexes read complete with no gate until `S-03` is cut, and `S-03` is unscheduled (CUT-PLAN.md P8); the entry is US011's because the window opens when it ships (call recorded 27/09/2026 with round 6) | [ ]  |
| US011 | **Verify, do not re-cut** the `S-05` row on `MAP-REGISTER-INDEXES.md`; if a cell has drifted, repair it and say so                                                                                                                                                                                                  | [ ]  |

<!-- 27/09/2026, on US011's gate write-back (settled 21/09/2026, grilling round 1 Q5 and Q7, and
     27/09/2026, round 3 Q17 and Q22; QA-PLAN-US011 AC-GAP-1 and AC-GAP-3). Four rows moved. The
     re-count read "against `N-003`'s instance test". The decision row read "ascending by
     identifier", and its ties are the file's rule: predecessor before successor, then filename.
     The story-plan row read "ascending by identifier, status read from the table cell with the
     backticks stripped". The recording row read "Record the trailing-HTML-comment divergence on
     the one ADR, the reading taken, and why that ADR was not edited". Each now follows the
     member's own task as its write-back left it.
     AMENDED 27/09/2026 at the final pass, following
     project-management/src/02-STORIES/US011.md -> Documentation Tasks as it now stands. One row is
     new, the TM-10 window's GAPS.md entry: US011's gate-22 pass writes it, gate 22 being the only
     writer of GAPS.md, and the window is TM-10's in
     project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md
     (call recorded 27/09/2026 with round 6). The member's matching Definition-of-Done line is not
     mirrored: this record's Definition of Done carries none of US011's story-specific lines — the
     S-05 row and the no-Backfill-owed line among them — and its sprint-level tasks row already
     binds the new task, keyed US011 and so deliver branch. No other row moved. -->

### Security Tasks — N/A

<!-- Removed by flag, and stated rather than silent — the sprint's Security row reads N/A. The
     seed-purity work this sprint depends on is US010's, listed in
     project-management/src/03-SPRINTS/SPRINT-06.md -> Security Tasks, and duplicating it here would
     put one obligation in two records. What this sprint owes is the assertion that it did not
     regress that control, and that is US011's generated-tree grep row above.
     21/09/2026: US012 adds no security task either — its Security row reads N/A for a reason of
     its own, stated in the Security Acceptance Criteria comment. "The first QA row above" read here
     until that day and stopped pointing at the grep row when US012's rows went first. -->

### QA Tasks — Automated

<!-- Every US012 run that needs a generated tree is a CI run of `[3/4]` on the pushed story branch.
     No project script generates a tree — that job is CI-only by design — and a raw `uvx copier
     copy` is what `.claude/CLAUDE.md` Section 6 bans; a hand-built fixture is lawful for iterating
     and indicative only (QA-PLAN-US012 AC-GAP-4). -->

- [ ] US012 — commit the probe alone and push; record the `[3/4]` run's ID and the probe's own
      zero-finding line as the red run, on a tree with every seed present
- [ ] US012 — commit the loop and push; record the green run's ID and its **6 probes** success
      line, and confirm from the same run that the full check over both generated trees exits 0
- [ ] US012 — confirm by a bash string test, which needs no tree, that the probe's substring does
      not match the named-file message for the same path
- [ ] US012 — read the seed finding and the closing guidance printed beneath it, and record that
      neither advises a `!` negation or an allowlist edit
- [ ] US012 — run ShellCheck by hand over the edited script and record the result, or record that
      it was not run and why
- [ ] US011 — add the generated-tree grep for the four registers' literals to the generation job, on
      every render path the template offers (today: `INCLUDE_MOBILE` true and false)
- [ ] US011 — run `shipped-artefacts.sh --self-test`, `shipped-registers.sh` (with `--self-test`)
      and `shipped-ai.sh --self-test`, and confirm US011's diff needs **no** edit to any of them,
      with the result recorded in `project-management/src/18-TESTS/US011-TEST-STATUS.md`
- [ ] US011 — run `doc-references.sh`, `docs-length.sh` and `docs-pairing.sh` over the changed tree,
      and the link-resolution check over the four indexes

### QA Tasks — Manual

- [ ] US011 — row-by-row walk-through of all four indexes against their folders, recorded: every
      instance present, no orphan rows, every `Status` string-equal to the file's value under the
      read rule, every `Updated` equal to its file's last commit date
- [ ] US011 — summary legibility pass: every `Summary` read by someone who has not opened the
      artefact and confirmed to convey what it is — a filename restated in prose fails
- [ ] US011 — supersession-chain walk across `DECISION-INDEX.md`, end to end, recorded
- [ ] US011 — the re-measured population recorded beside the cut-time figure of 43, with its date,
      so the drift between cutting and building is visible
- [ ] US011 — a tester other than the author has signed the walk-through off
- [ ] US012 — **N/A**, its QA flag names the unit type only; the finding-wording read above is
      recorded at review and is listed with the automated tasks it closes
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint's Frontend,
      Components and Wireframes rows read `N/A`; no page, component or interactive surface is added

<!-- 27/09/2026, on US011's gate write-back. Four US011 rows across the two QA task lists moved to
     follow the criteria above and the member's own tasks. The grep task read "on **both**
     `INCLUDE_MOBILE` poles" (round 3 Q23). The self-test task named `shipped-artefacts.sh` alone.
     The audit task ended at "over the changed tree", without the link-resolution check. The first
     manual row read "every `Status` string-equal to the file's, every `Updated` date correct"
     (settled 21/09/2026, grilling round 1 Q5 and Q6; QA-PLAN-US011 AC-GAP-1 and AC-GAP-2).
     AMENDED 27/09/2026 after two verified passes: the grep task's parenthesis read "(today: both
     `INCLUDE_MOBILE` poles)", and now reads "(today: `INCLUDE_MOBILE` true and false)", the
     member's own wording and this record's elsewhere. -->

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The checks with nothing to look at are marked N/A with a reason rather than deleted: per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. This sprint ships Markdown
     only — no Python, no bash, no YAML — so it is the thinnest verification surface any record here
     has carried, and the rows that survive are stated rather than assumed.
     21/09/2026: no longer Markdown only, and "no YAML" above was wrong when written. US012 ships
     one bash script under .github/scripts/, so the self-test and ShellCheck rows below are re-read
     for it. Neither member ships Python. US012 needs no CI edit — `audit-template.yml` already runs
     both the self-test and the full check over both answer sets — but US011's generated-tree grep
     (QA Tasks — Automated) edits the `[3/4]` job in `.github/workflows/audit-template.yml`, so a
     YAML edit has been in scope since the record opened. That edit is proved by the generation row
     below going green, not by `lint.sh`, which carries no YAML leg (measured 21/09/2026). -->

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test <generated-tree>` exits 0 with **6
      probes** — US012's criterion, run by the `[3/4]` job on the pushed branch. The script changes
      in this sprint **by US012's diff alone**: a change to it from US011's diff still means an index
      moved or a seed was polluted, and is a signal rather than a pass
- [ ] **The `[3/4] Template Generation` job is green on every render path the template offers**
      (today: `INCLUDE_MOBILE` true and false) — the self-test and the full check over every
      generated tree pass with every seed asserted present (US012), and the four backfilled indexes
      carry no instance rows in any generated tree (US011)
- [ ] `bash code/src/scripts/audits/doc-references.sh --path project-management/src/03-SPRINTS`
      — **the scoped run, and the one this record was measured on.** At the gate that opened this
      record (20/09/2026, HEAD `53d9196`, whole change staged) it exits `1` with **170** citations
      that do not resolve across the folder — 142 instance, 27 dangling, 1 template-only, 0
      plan-prefix — of which **this record contributes 23, all of them the inherited instance
      class and none of them dangling**. The Notes carry the per-file split. **The criterion for
      this sprint is that this record's `dangling` count stays at 0**: a dangling finding is a path
      this record wrote that does not resolve, and it is the only class here that would be this
      record's own defect. The scoped run completes in about 45 seconds, so there is no excuse for
      reporting it unmeasured. **Re-measured 21/09/2026 on US012's admission: 190 across the folder,
      37 in this record, all 20 new findings instance-class and this record's `dangling` count still
      0** — the Notes carry the split and why the unstaged figure is comparable
- [ ] `bash code/src/scripts/audits/doc-references.sh` (whole tree) — **read as a diff against the
      baseline captured before the first edit**, per ADR-US003, and never as a bare pass while that
      baseline stands. The Markdown links US011's rows carry — one per instance, 47 tracked on
      27/09/2026 — are invisible to this gate and are proved by the link-resolution check; a rise in
      the `dangling` class is this sprint's own defect, while a rise in `instance` is the inherited
      class US004 fixes. **The two are distinguished in the report, not aggregated.** Measured
      20/09/2026 staged, this record's dangling count is **0**. **The whole-tree pass was NOT RUN at
      the gate that opened this record** — it takes over ten minutes against the scoped run's 45
      seconds — and per `code/docs/GATE-REPORTING.md` that is reported rather than inferred away
      from the folder figure above. **Nor was it run at US012's admission on 21/09/2026**, for the
      same reason; only the scoped figure was re-measured
- [ ] `bash code/src/scripts/audits/docs-length.sh` — run to **prove the register-artefact
      exemption** rather than assume it. The four indexes grow by one row per instance between
      them, 47 tracked on 27/09/2026, and are exempt from the 300-line ceiling as `src/` register
      artefacts; the exemption is the gate's to confirm. No `CONTEXT.md` grows by more than a date
      in this sprint
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; neither member creates a
      directory, and US011 edits existing pairs' `**Last Updated**` dates at most
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only. A green run says the
      registered claims are undisturbed and says **nothing** about a row's `Status` matching the
      artefact it names; that is the manual row-by-row walk-through's job and is never reported as
      though the gate had done it
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, neither member adds routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/syntax/lint.sh` passes — markdownlint-cli2 over the four backfilled
      indexes. **The ShellCheck caveat applies again**, as in SPRINT-05 and SPRINT-06: US012 changes
      `.github/scripts/shipped-artefacts.sh`, and `lint.sh`'s legs carry no shell linter —
      re-measured by US012 on 21/09/2026, no lefthook entry, CI job, `syntax/` script or `audits/`
      script invokes ShellCheck. It is recorded as run or as not run, **never as a `lint.sh` pass**
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
      and the section above records what that does and does not mean. The seed-purity control
      US011 leans on is signed off in `project-management/src/03-SPRINTS/SPRINT-06.md`, not here;
      US012's reason is its own and is stated in the same section
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

<!-- 21/09/2026, on US012's admission. The first row read "`bash
     .github/scripts/shipped-artefacts.sh --self-test` exits 0 and is **unchanged** — this sprint
     registers nothing new, and a diff in that script is a signal rather than a pass"; the
     generation row named US011's half only; the lint row read "**No ShellCheck caveat applies to
     this sprint**, unlike SPRINT-05 and SPRINT-06: the member changes no shell script"; and the
     pairing, routing and security rows spoke of "the member". Each is re-read for two members, and
     US011's half of each is unchanged. -->

<!-- 27/09/2026, on US011's gate write-back. Three rows moved. The generation row read "green on
     both answer sets", "over both generated trees" and "in either generated tree", and is worded
     path-neutral (settled 27/09/2026, grilling round 3 Q23). The whole-tree doc-references row read
     "This sprint writes 43-odd new links and every one must resolve". The docs-length row read
     "The four indexes grow by 43-odd rows between them". Both counts are re-measured under the
     positive instance test (round 3 Q22). The links are handed to the link-resolution check,
     which doc-references cannot stand in for (QA-PLAN-US011 AC-GAP-6, AC-GAP-7 and AC-GAP-12).
     US012's half of the generation row moves in that wording only. -->

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its
      own DoD complete) — US012 alone. US011 is the `Should Have` stretch tier: it is the first work
      dropped if US012 overruns (`project-management/docs/planning/SPRINTS.md` -> _MoSCoW_), and
      dropping it does **not** fail the sprint
- [ ] **US011, the stretch tier, is disposed of in writing, on whichever branch it takes — and
      exactly one branch is taken.** **DELIVERED:** US011 is marked **Completed**, and every row
      below headed _deliver branch_ binds as written. **DROPPED:** the drop and its reason are
      recorded in three places in the same change — here, in
      `project-management/src/02-STORIES/US011.md`, and in the backlog register in every copy.
      **There is no `SPRINT-08` to reserve the 8 SP into**, and this record does not invent one: the
      reservation is recorded as **owed and unplaced**, and is named the moment a receiving record
      is opened — the discipline `project-management/src/03-SPRINTS/SPRINT-05.md` had to be
      corrected into on 20/09/2026, its own "the next record" having been written against a record
      that did not exist. **Nor will SPRINT-08 take it once opened**:
      `project-management/src/02-STORIES/CUT-PLAN.md` P8 (27/09/2026) gives that record to
      RULE-OWNERSHIP, US013 then US014 at 11 / 11, and 8 SP more is 19 / 11, past the 13 SP grace
      ceiling. Where a dropped US011 is reserved is therefore a placement **owed to
      `03-sprint-planning`**, and this record makes none. Wherever it lands, it lands ahead of
      `S-03`, whose presence clause is red on the four debt-carrying indexes until US011 lands
      (settled 21/09/2026, grilling round 1 Q1), and which is itself unscheduled (P8). On that
      branch US011's half of every row below headed _deliver branch_ reads **N/A — dropped**, with
      the drop as its reason, and US012's half binds as written. **A `Should` is never dropped
      silently** — the rows the branch turns `N/A` are marked, not deleted, per
      `code/docs/GATE-REPORTING.md`

- [ ] **Admitting a `Must` recomputes this record in the same change — exercised 21/09/2026, when
      US012 was admitted.** The Must-tier row, the FIRST row of this section, stopped being `N/A`
      and governs; US011 stopped being "the sole member" and is read as the stretch tier, so the
      drop branch no longer empties the record; and the FLAGS table, the capacity line, the Notes'
      admission bullets and the backlog register were recomputed in that change. **The record was
      closed to further admission by call later that day**, so none is expected — a new admission
      opens SPRINT-08. Were <%DEVELOPER_NAME%> to reopen this record, an admission would bind the
      same way, and a second `Must` would join US012 under the first row
- [ ] **US010 landed before US011 started.** Confirmed rather than assumed: the four indexes exist,
      carry their `Backfill owed — US011` line, and their tails and ordering rules are the ones
      US010 designed. If any of that is absent US011 cannot start — US012 can, waiting on nothing —
      and the blocking edge is recorded in `project-management/src/03-SPRINTS/SPRINT-06.md` from the
      other side
- [ ] All sprint-level acceptance criteria met and verified by a reviewer. The Acceptance Criteria
      section holds two outcomes: US012's binds on both branches, and US011's is _deliver branch_ —
      on the drop branch it reads **N/A — dropped**
- [ ] All sprint-level tasks checked off. Every row keyed `US012` binds on both branches; every row
      keyed `US011` is _deliver branch_, and on the drop branch reads **N/A — dropped**
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in either member's QA plan. US012's closed on
      21/09/2026 with all nine resolved; US011's, written by gate `11` later on 21/09/2026, reads
      `Reviewed` on 27/09/2026 with all thirteen resolved into the story, and binds as committed.
      _Deliver branch_ for US011: on the drop branch its half reads **N/A — dropped**, the plan
      binding nothing for a story that is not built, which is a skip and never a pass
- [ ] The QA row of the FLAGS table, and the sections it governs, were recomputed when gate `11`
      closed for each member, and the union still equals US012's table unioned with US011's.
      US012's gate closed on 21/09/2026 with its QA value unchanged; US011's plan reached
      `Reviewed` on 27/09/2026, and its half was recomputed from that write-back the same day (the
      FLAGS comment), binding as recomputed. **The Security row is re-asked at gate `10` rather than assumed to stay `N/A`** — each
      member's own flag names that gate as the one entitled to overturn it. US011's half is
      _deliver branch_; on the drop branch no further gate runs for it, its half reads
      **N/A — dropped**, and the union narrows to US012's table, a member having left
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)

<!-- 21/09/2026, on US012's admission, which the third row above had pre-stated. Until that day the
     first row read "— **N/A**, and marked rather than deleted. This record has **no `Must` tier**;
     the row is kept so that its emptiness is read as the known gap recorded in the Notes rather
     than as a criterion quietly satisfied"; the second opened "**The sole member is disposed of in
     writing**" and closed that "an empty sprint is a closed sprint only when the drop is written
     into all three places"; the third opened "**If a `Must` is admitted during the sprint**" and
     closed "**Until a `Must` is admitted this row binds nothing** — it is written now so that the
     admission this record is held open for does not arrive with its consequences unstated"; the
     fourth read "US010 landed before this sprint's member started"; and the acceptance-criteria,
     tasks, QA-plan and FLAGS rows were keyed to US011 alone. Every consequence the third row named
     moved in this change. -->

<!-- 21/09/2026, on the close by call later that day. The third row closed "**A further admission
     binds the same way**, and a second `Must` would join US012 under the first row" from US012's
     admission until the close. No other row here moved: the close changes the admission posture,
     not what the sprint must deliver, and the plans it owes are carried in the Notes rather than
     as a row, a plan being written before the build rather than delivered by it. -->

<!-- 27/09/2026, on US011's gate write-back. The drop-branch row gained the sentences between "a
     record that did not exist" and "On that branch" (QA-PLAN-US011 AC-GAP-5). As drafted on
     21/09/2026, that edit appended that a dropped US011 is reserved into SPRINT-08 once that record
     opens for `S-03` (round 1 Q1, round 2 Q13). CUT-PLAN.md P8 superseded that on 27/09/2026:
     SPRINT-08 is RULE-OWNERSHIP's, and `S-03` has no sprint. So the row states the recorded fact
     instead, and leaves the placement the draft would have made owed to `03-sprint-planning`
     rather than choosing one here. The ordering half of the draft survives: US011 lands ahead of
     `S-03` wherever it goes (US011.md -> MoSCoW Priority, round 3 Q19). The row's earlier
     sentence, that there is no SPRINT-08 to reserve the 8 SP into, still stands, because that
     record still does not exist. -->

<!-- AMENDED 27/09/2026 after two verified passes of the US010 / US011 write-back, when
     project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md reached
     `Reviewed`. Two rows moved. The QA-plan row read "US011's binds once gate `11` has written it",
     and its drop branch read "gate `11` may never run on a dropped story, so on the drop branch its
     half reads **N/A — dropped, gate 11 not entered**"; gate 11 has run, so the drop branch now
     rests on the story not being built. The FLAGS row read "US011's half binds at its own close"
     and "on the drop branch its gates do not run". No row's obligation changed. -->
