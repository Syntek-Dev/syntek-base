# SPRINT-03

**Last Updated**: 07/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The citation gate gives one verdict on one sentence whichever side of the git index its
file sits, and the project-management tree it could never read becomes checkable — so no story
after this one carries a written baseline to subtract from a red run.

<!-- The goal read "Retry doctrine gets its single owner, and the absence guide it was waiting
     behind ships beside it — exactly one layer decides to repeat an operation, and every
     `return None` in the tree means one stated thing." until 07/09/2026, when US005 moved to
     SPRINT-04 and US003 to SPRINT-02 in the US007 re-plan. Both halves named a deliverable no
     member now carries, which project-management/src/03-SPRINTS/SPRINT-02.md's goal comment of
     05/09/2026 records as the drift a goal must not hold. The replacement is derived from the
     title and Client Summary of US004, the sole member. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 / 11 SP** — inside capacity, all-`Must`, and **closed to
admission, holding a reservation**: SPRINT-02 reserves US003's 5 SP `Should` carry to this
record, and if it lands this sprint is **13 / 11 SP** and at grace. See Notes.

<!-- The capacity line read "5 SP Must + 5 SP Should = 10 / 11 SP — inside capacity, and CLOSED.
     See Notes." from 06/09/2026, and "5 SP Must + 5 SP Should = 10 / 11 SP — inside capacity, and
     still admitting" from 05/09/2026 before that. Superseded 07/09/2026: both figures were US005's
     5 plus US003's 5, and neither story is a member now. -->

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 05/09/2026 on US005's admission — the union over one member is that member's table.
     Recomputed 05/09/2026 when the security gate widened US005's Security value from "retry
     amplification" to four subjects (QA-PLAN-US005 AC-GAP-15). Precedent for a same-day gate
     widening is SPRINT-01, whose QA row moved when QA-PLAN-US001 AC-GAP-6 landed.
     Recomputed 05/09/2026 on US003's admission from SPRINT-02, and CHANGED in one row: US003's
     QA value added routing-skills and skill-conformance to the three US005 names.
     RECOMPUTED 07/09/2026 on the re-plan — US005 and US003 DEPARTED, US004 ARRIVED — and CHANGED
     in two rows. The union over one member is that member's table, so this is US004's, copied
     verbatim including its .sh spelling. Security narrows to N/A: the four-subject value was
     US005's alone, and a union narrows only when a member leaves, which is this case and not the
     Part A / Part B narrowing SPRINTS.md permits — the story did not split, it moved. QA becomes
     US004's two-type value — unit over the gate's own self-test and fixture pair, the first
     automated type this record has carried, plus manual over three documentation gates — and
     loses routing-skills.sh and skill-conformance.sh, which entered with US003 alone.
     US003's RESERVED CARRY IS NOT PRE-COMPUTED INTO THIS UNION. The union is computed from the
     Story Summary below, and US003 sits in SPRINT-02's. A row carried here "because US003 might
     arrive" would be an independently-authored value, which is what SPRINT-02's 05/09/2026
     amendment corrected in its own table. If the carry lands, recompute on arrival: the QA row
     widens by US003's two gates and nothing else moves, US003's other twelve rows being N/A.
     Twelve rows stay N/A because the member edits one bash script, its fixtures, one register
     and four Markdown files: no model, no endpoint, no screen, no personal-data path, no log
     line, no public page. -->

| Flag       | Value                                                                                                     |
| ---------- | --------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                       |
| User Flow  | N/A                                                                                                       |
| Brand      | N/A                                                                                                       |
| Components | N/A                                                                                                       |
| Wireframes | N/A                                                                                                       |
| GDPR       | N/A                                                                                                       |
| Security   | N/A                                                                                                       |
| QA         | unit — gate self-test, fixture pair · manual — `docs-length.sh`, `doc-references.sh`, `doctrine-drift.sh` |
| SEO        | N/A                                                                                                       |
| API        | N/A                                                                                                       |
| Logging    | N/A                                                                                                       |
| Backend    | N/A                                                                                                       |
| Frontend   | N/A                                                                                                       |

---

## Story Summary

| ID    | Title                                                                                 | MoSCoW    | SP  |
| ----- | ------------------------------------------------------------------------------------- | --------- | --- |
| US004 | The citation gate stops depending on the git index, and the PM tree becomes checkable | Must Have | 8   |

**Total:** 8 SP — all committed, no stretch tier at opening. **US003's 5 SP `Should` carry is
reserved to this record from SPRINT-02**; if it arrives the total is 13 SP, 8 committed and 5
stretch. It is not counted until it does.

<!-- US005 (Must Have, 5 SP) and US003 (Should Have, 5 SP) were here until 07/09/2026. US005 is now
     in project-management/src/03-SPRINTS/SPRINT-04.md and US003 in
     project-management/src/03-SPRINTS/SPRINT-02.md. Both are removed from this table rather than
     struck through, on the precedent SPRINT-02.md's own Story Summary comment set on 05/09/2026:
     SPRINTS.md computes this sprint's flag union and capacity FROM this table, and a story in two
     Story Summaries is counted twice. The move and its reasoning are in the Notes. -->

## Dependencies

- **US004 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`, whose map has an
  empty frontier and whose `Gate to stories` records `02-story-creation` as unblocked. Its place
  third in the build order is the re-plan's arithmetic, not a blocker — stated so that nobody goes
  looking for one. The two members this record held until 07/09/2026 were each blocked by a story
  in an earlier sprint; the one it holds now is blocked by nothing.
- **The US004-before-US003 ordering — settled 02/09/2026, carried across US003's move here on
  05/09/2026 — is REVERSED by this re-plan, and US004's own story provided for that at cutting.**
  US003 now sits in `project-management/src/03-SPRINTS/SPRINT-02.md`, built ahead of this sprint.
  `project-management/src/02-STORIES/US004.md` Dependencies, _Collision with US003, named at
  cutting_, names both orders: if US003 lands first, the three `code/docs/ABSENCE.md` forward
  references resolve on their own, and whichever lands second reads the other's disposition rather
  than re-deriving it. US004 is now the second to land and reads US003's — the guide exists, those
  three findings are gone, and the "six survivors known at cutting" are re-measured rather than
  inherited, which US004's own acceptance already requires. **The revision pass this record carried
  for US003 from 05/09/2026** — rewriting its baseline-diff scenario as a plain pass once US004 has
  landed — **is not owed in SPRINT-02**, where US003 is worked under exactly the regime its scenario
  was written for. It is owed again in one case only: the carry recorded in the Definition of Done.
- **US004 depends on no SPRINT-01 or SPRINT-02 member for content, and shares no file with any of
  them.** It edits `code/src/scripts/audits/doc-references.sh` and its fixtures,
  `how-to/src/PROJECT-PATHS.md`, `code/docs/FORWARD-VOICE.md`, and the shipped files its widened
  gate exposes. One touch-point is ordered rather than blocked: it replaces text **within** the
  `doc-references.sh` row of `code/src/scripts/audits/CONTEXT.md` and never adds a line, because
  US002 owns that file's headroom at 298 of 300 code lines. US002 now builds ahead of this sprint,
  in SPRINT-02; if it has landed, the register carries the headroom US002 built and the ordinary
  ratchet applies, and if it has not, the never-add-a-line constraint stands as written.
- **US004 unblocks** slice `S-01` on `project-management/src/01-FEATURE-MAPS/MAP-NAVIGATION.md`,
  which changes the same script's citation emit and must not land first, and it **retires the
  baseline-diff regime** of
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` by
  that record's own terms — with the caveat `03-SPRINT-PLAN-03.md` recorded on 05/09/2026, which
  survives the re-plan: the ADR retires when the repair lands **and the gate goes green**, a
  conjunction, and it calls for a superseding record nobody has yet written. A plain pass is not
  promised here; see Verification Checks.
- **This sprint's contingency is a dependency in the other direction.** SPRINT-02's Definition of
  Done reserves its `Should` — US003, 5 SP — to this record. It is not a blocker; it is an
  arithmetic risk on the capacity line, and it is the same shape SPRINT-04 carried from this record
  between 05/09/2026 and 07/09/2026.
- **Sprint numbering and execution order agree for this sprint, and that was checked rather than
  copied.** The build order settled 07/09/2026 runs SPRINT-01 (US007 then US001), SPRINT-02 (US002
  then US003), this sprint (US004), SPRINT-04 (US005 then US006) — number order. The exec-order
  segment of `project-management/src/16-SPRINT-PLANS/{exec-order}-SPRINT-PLAN-03.md` therefore
  reads `03`. The plan on disk under that name, however, is written for US005 and US003 and is
  superseded in every section, not only its capacity line; see Notes.
- **`Blocked` is a story status, not a sprint one.** Unchanged from 05/09/2026, and now moot for the
  member: US004 waits on nothing, so no story `**Status:**` moves on account of this sprint.

<!-- The Dependencies this record carried from 05/09/2026 to 07/09/2026 were written for US005 and
     US003, and each of their facts has a home now that neither is a member: US005's block on US001
     (the code/docs/reliability/ family) and the three slices it unblocks (S-04, S-05, S-06 on
     MAP-RETRY-AND-IDEMPOTENCY) and the two that run beside it (S-03, S-09) travelled with the
     story to SPRINT-04; US003's ordering behind US004, its revision pass, and the five absence
     slices it unblocks travelled with it to SPRINT-02 — the ordering reversed, as the second
     bullet above records; and the statement that both members were blocked by an earlier sprint,
     with the exec-order warning that followed from it, is superseded by the first and sixth
     bullets. Pointer rather than full text, on the precedent SPRINT-02.md set for this record's
     own Dependencies on 05/09/2026: the facts live in the story files and the receiving records,
     and a second copy here would be the drift the union rule exists to stop. -->

## Notes

**The re-plan of 07/09/2026: US005 and US003 left, US004 arrived, and every sprint record moved.**
`project-management/src/02-STORIES/US007.md` — the story `**Status:**` vocabulary gets one owner,
`Must Have`, 5 SP — was cut on 07/09/2026 and must ship **before** US002, because US002 builds
`register-indexes.sh` and its status fixtures against whichever vocabulary is canonical on the day
it ships. Sam settled the shape as a full cascade rather than an execution reorder: US007 opens
SPRINT-01 ahead of US001; US002 moves SPRINT-01 → SPRINT-02 with US003 as its stretch tier behind
it; US004 moves SPRINT-02 → here; US005 moves here → SPRINT-04 beside US006. The final figures are
SPRINT-01 at 10 / 11, SPRINT-02 at 8 / 11, this sprint at 8 / 11 (13 / 11 if the carry lands), and
SPRINT-04 at 13 / 11 — grace, taken deliberately and recorded there. No SPRINT-05 is opened. **It
is a re-plan, not a carry-over** — the distinction this record drew on 05/09/2026 for US003's first
move: every sprint is `Planned` and unworked and no Definition of Done has been reached, so each
move is recorded in the departing and receiving records rather than ticked off in one.

**US003 has now moved twice, and the reservation it carries has turned round.** SPRINT-02 → here on
05/09/2026, as the `Should` give this sprint lacked; here → SPRINT-02 on 07/09/2026, as the stretch
tier behind US002. In SPRINT-02 it holds the shape it held here — `Should Have`, 5 SP, its carry
reserved to the next record — one sprint earlier, and the next record is now this one. **The story
is not split** (Q9 of the 07/09/2026 pass: a scheduling split, never a story split) and no new
story number is cut. A third move would be a carry into this sprint at SPRINT-02's close, recorded
in both records and in the story file as the first two were.

**The all-`Must` weakness this record repaired on 05/09/2026 is back, and the reservation is its
contingent repair.** US004 alone is a single all-`Must` member — the shape
`project-management/docs/planning/SPRINTS.md` warns has no give, where the first surprise breaks
it. On 05/09/2026 the fix was to admit US003 as a `Should`; on 07/09/2026 US003 is committed one
sprint earlier and the fix is conditional. Two futures, both recorded now rather than discovered
later:

| If US003…              | This sprint stands at                  | Reading                                                                                         |
| ---------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------- |
| completes in SPRINT-02 | **8 / 11 SP**, all `Must`              | Inside capacity. The weakness stands, and this record has no other give it can honestly hold    |
| carries to SPRINT-03   | **13 / 11 SP** — 8 `Must` + 5 `Should` | **At grace**, and the weakness is repaired: the carry is give that can slip again if US004 runs |

**The second is the better sprint, and it is SPRINT-02's close to trigger, not this record's call
to take.** SPRINT-04 recorded this same reading of this same contingency on 05/09/2026, and it
transfers here unchanged: `project-management/docs/planning/CADENCE.md` reserves grace for a story
that would otherwise split badly, and a carry-over is not that — but a carry arriving into a
single-member sprint buys a stretch tier rather than an overcommitment, because the `Must` tier
stays at 8 either way. **If US003 carries here, do not read the 13 as an overrun.** Whoever closes
SPRINT-02 makes the call and records it in both records.

**This sprint is closed to admission at one member and 8 / 11 SP, and what it holds is a
reservation, not headroom.** The 3 SP under capacity and the 2 SP of grace above it are together
exactly US003's 5. Admitting a further story would either spend the room the reservation needs or,
with the carry landed, take this sprint past grace — the position that refused US006 on
05/09/2026. That is arithmetic rather than a call, and it is recorded as arithmetic: the closure
**by decision** at 10 / 11 recorded on 06/09/2026 was about a member set that no longer exists and
is superseded below.

<!-- The paragraph replaced here read: "**This sprint is CLOSED at two members and 10 of 11 SP, by
     decision rather than by fill** (06/09/2026). The earlier reading had it closed by arithmetic —
     1 SP of headroom is not a slot — while leaving the door open to a small story that cleared its
     specify tier first. That door is now shut by a call, which is the stronger closure:
     `project-management/docs/planning/CADENCE.md:117-118` is explicit that capacity is a **trigger
     and not a target**, so ten is a correct sprint rather than an under-filled one. `SPRINT-01.md`
     carries the precedent for closing a ledger this way." Written 06/09/2026 and never committed;
     superseded 07/09/2026 by the re-plan, which removed both members the figure counted. The
     CADENCE reading it cites is right and is not what changed. -->

<!-- The paragraph replaced here read: "**Nothing further is admitted here.** `US007` — the next
     story cut, reconciling the two story `**Status:**` vocabularies (`GAPS.md` 01/09/2026) — goes
     to `SPRINT-04` beside `US006`, not here. This does not disturb the 5 SP carry the Definition of
     Done below reserves: that clause governs `US003` slipping **out** of this sprint at close, and
     is unaffected by refusing a story **in**." Written 06/09/2026 and never committed; superseded
     07/09/2026 and WRONG on its main claim: US007 opens SPRINT-01, first in the build order, because
     US002 has to build against the vocabulary US007 makes canonical. The refusal of US007 HERE was
     right for the wrong reason and stands: this record now holds US004 plus a reservation. The
     carry clause the paragraph mentions has since turned round and governs US003 slipping IN. -->

<!-- The paragraph replaced here read: "**This sprint is still admitting.** 1 SP of headroom is not
     a slot, so in practice it is closed by arithmetic rather than by decision — but nothing here
     forecloses a small story that clears its specify tier before either blocker lands." True when
     written on 05/09/2026 and superseded the next day by Sam's call that the sprint stays closed at
     10 / 11. Kept rather than erased, so the closure reads as a decision that was taken rather than
     a headroom that quietly vanished. -->

**US006 was refused admission here on 05/09/2026, and the refusal stands on new arithmetic.** The
paragraph that argued it is kept below as history, because it is the record of a decision that was
taken; its figures — 5 SP all-`Must`, then 10 / 11 — were US005's and US003's and describe no
member now here. Measured against this record as it stands, US006's 8 SP would give 16 / 11
without the carry and 21 / 11 with it: over grace either way. US006 stays in SPRINT-04, now beside
US005, and `project-management/src/02-STORIES/US006.md` Dependencies records SPRINT-04 as the
sprint it opens, so the two records still agree.

<!-- History, superseded 07/09/2026 by the re-plan. The three paragraphs below described this
     record between 05/09/2026 and 07/09/2026, when its members were US005 and US003. Kept in full
     because two of them are the record of decisions actually taken — the US003 move and the US006
     refusal — and nothing else holds their reasoning.

     "**US003 moved here from SPRINT-02 on 05/09/2026, before either sprint was worked.** SPRINT-02
     was admitted at 13 SP against a capacity of 11 — at grace — with US004 as its 8 SP `Must` and
     US003 as a 5 SP `Should` stretch on top. Moving the stretch out puts **SPRINT-02 back inside
     capacity at 8 / 11 and leaves this sprint at 10 / 11**, and neither sprint now needs grace. It
     is a re-plan rather than a carry-over: SPRINT-02's Definition of Done provides for US003 being
     carried at **close**, and this happened before it opened, so the move is recorded in both
     records rather than ticked off there."

     "**It also repairs this sprint's one real weakness.** Opened with US005 alone, SPRINT-03 was a
     single all-`Must` member, which `project-management/docs/planning/SPRINTS.md` warns against — a
     plan with no give, where the first surprise breaks it. There was no honest way to fix that
     from within the retry map: `S-04`, `S-05` and `S-06` all block on US005 itself, and `S-03` and
     `S-09` are not yet cut. US003 is give this sprint can actually drop: if US005 overruns, the
     `Should` slips and the sprint still succeeds."

     "**US006 is not admitted here, and that was a live question.** It was cut from
     `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` in a parallel session on
     05/09/2026 at 8 SP `Must Have`, and its own Dependencies section names this sprint as the one
     it joins. **Settled 05/09/2026: US006 goes to SPRINT-04.** The counterfactual is dated, because
     the arithmetic moved under it the same day: **at the moment the question was live this sprint
     stood at 5 SP all-`Must`**, so US006's 8 SP would have taken it to 13 — its grace ceiling,
     which is the figure `project-management/src/02-STORIES/US006.md` records. US003 was admitted
     afterwards, so measured against the sprint as it now stands US006 would give **18 SP (13 Must,
     5 Should)** — over grace rather than at it. Either reading refuses it, and grace is for a story
     that would split badly, not for a story that arrives while there is room. **US006's own story
     file has since been corrected in that session** — as of 05/09/2026 its Dependencies section
     records `SPRINT-04` as the sprint it opens, so the two records agree." -->

<!-- The sentence replaced here read: "US006's own story file still says otherwise and is being
     written in that other session; correcting it belongs to that session, not this record." True
     when written and superseded the same day, 05/09/2026, when that session recorded the reversal
     in US006's Dependencies. Kept rather than erased, so the deferral reads as a decision that was
     honoured rather than one that was never made. -->

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) — the prerequisite holds for
the sole member, and the plan on disk does not describe it.** US004 cleared `15-decisions` on
02/09/2026: `project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` carries
no `[OPEN]` gap — nine found, nine resolved — and both its ADRs are written, so
`project-management/docs/planning/CADENCE.md`'s no-unresolved-gap prerequisite is satisfied.
`project-management/src/17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` exists; its
`| Sprint |` row reads `SPRINT-02` until the re-plan's story-plan touch lands. But
`project-management/src/16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` was written on 05/09/2026 for US005
and US003 and is superseded in every section — capacity line, Sprint Goal, story tables,
constraints, build order — while the plan that describes US004 alone at 8 / 11 is, as of this
writing, `02-SPRINT-PLAN-02.md`. Reconciling the two is a `16-sprint-plans` run with its own gate
and its own grilling pass, not an edit this record makes. **Until it runs, this record is the
authoritative statement of SPRINT-03's membership and the plan is not.**

<!-- The paragraph replaced here read: "**Sprint plans (`16-sprint-plans`) and story plans
     (`17-story-plans`) run for this sprint once every member has cleared `15-decisions`.** Both
     have. US005's QA plan carried one `[OPEN]` acceptance-criteria gap during this session — the
     boto3 clamp literal, `AC-GAP-1` — and it closed the same day, so
     `project-management/docs/planning/CADENCE.md`'s no-unresolved-gap prerequisite is satisfied
     for both members." True on 05/09/2026 and superseded 07/09/2026: neither member it counts is
     here, and the plan it licensed now describes a sprint that no longer exists. -->

---

## Acceptance Criteria

One outcome, one member.

**US004** — `code/src/scripts/audits/doc-references.sh` gives the same verdict on the same
citation whether or not its file is committed, polices the nine shipped files copier lifts out
of the exempt trees, checks the `project-management/src/` tree without firing on naming
conventions, and exits `0` on a clean tree — so no story after this one needs a written baseline
to read it against.

<!-- US005's and US003's outcomes moved with the stories on 07/09/2026 — US005's to
     project-management/src/03-SPRINTS/SPRINT-04.md, US003's to
     project-management/src/03-SPRINTS/SPRINT-02.md. Pointer rather than full text, on the
     precedent SPRINT-02.md's Acceptance Criteria comment set on 05/09/2026 for this record's
     arrival of US003. -->

<!-- The Security Acceptance Criteria section is REMOVED as of 07/09/2026, and the removal is a
     gate that does not apply here, not a gate skipped. Between 05/09/2026 and 07/09/2026 this was
     the first sprint record to keep the section — six rows, every one naming US005 explicitly and
     the last recording that US003 contributed nothing to it. US005 moved to SPRINT-04 and the six
     rows with it; the union's Security row now reads N/A on US004's own flag, and the template
     removes the section for a flag reading N/A. Per code/docs/GATE-REPORTING.md: US004's security
     gate was entered at 02-story-creation and read N/A at its story — a story that edits one bash
     script and Markdown, with no runtime, no principal and no data path — which is a decision with
     a reason, not an absent tool. -->

### QA Acceptance Criteria — Automated

<!-- New to this record on 07/09/2026: its QA union names a unit type for the first time, and its
     single member is the only contributor to every row below. Mirrors the rows SPRINT-02.md
     carried for the same story from 02/09/2026 to 07/09/2026. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0, its probe count
      risen by one case per repair US004 makes
- [ ] Every fixture case US004 adds fails against the pre-change script and passes against the
      post-change one — a fixture that passes both proves nothing
- [ ] The fixture tree stays exempt from an ordinary run, and the existing direct assertion for
      that still passes
- [ ] No existing probe is weakened to accommodate a change; any moved expected count carries
      its justification in the probe's own comment
- [ ] Coverage floors — **N/A**, the member ships no Python path; US004's proof is the script's
      own `--self-test`

### QA Acceptance Criteria — Manual

<!-- US005's and US003's manual criteria moved with the stories on 07/09/2026. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US004-MANUAL-TESTING.md` carries a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in
      `project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — nine
      found, nine resolved 02/09/2026

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

<!-- The Security Tasks table — three rows, all US005's — moved with the story to SPRINT-04 on
     07/09/2026; the union's Security row reads N/A and the template removes the section. -->

### QA Tasks — Automated

- [ ] US004 — the self-test runs and its output is recorded in
      `project-management/src/18-TESTS/US004-TEST-STATUS.md`
- [ ] US004 — each new fixture case is run against both the pre- and post-change script, and
      both results recorded
- [ ] US004 — the temporary-untracked-file probe for the population fix re-runs both set builders
      and carries a `trap`, so a failure between creation and assertion leaks nothing into the
      working tree

### QA Tasks — Manual

- [ ] US004 — the whole-tree run is recorded before and after, with both finding counts, both
      exit codes and the delta
- [ ] US004 — the tracked-versus-untracked A/B is reproduced before any edit and again after,
      with the git index restored each time
- [ ] US004 — every finding the widened gate exposes is classified in writing as genuine,
      generic-noun false positive, or another story's, with none left unclassified
- [ ] US004 — each repaired shipped file is re-read in place and its sentence confirmed to still
      read true
- [ ] US004 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

<!-- US005's six manual checks and US003's eight moved with the stories on 07/09/2026 — to
     SPRINT-04 and SPRINT-02 respectively. -->

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships one
     bash script and Markdown, and per code/docs/GATE-REPORTING.md a skip is never reported as a
     pass. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh` — **no finding remains of the three classes
      US004 owns** — the git-index class, the instance-citer class and the dangling
      `project-management/src/` class — and every survivor is named with the story that owns it, in
      `project-management/src/18-TESTS/US004-TEST-STATUS.md`. **Which survivors stand is a fact
      about the build order, and the order has changed under this check since it was written for
      SPRINT-02.** The six known at US004's cutting — three citations of `code/docs/ABSENCE.md`
      owned by US003, three of `code/src/scripts/audits/SLOP-FAMILY.md` owned by US002 — belong to
      stories now scheduled **ahead** of this sprint in SPRINT-02, so if SPRINT-02 completed in
      full they have cleared before US004 is worked; if US003 slipped here, its three stand until it
      lands. Two classes this order cannot clear: US006's forward references to
      `code/src/scripts/_lib/posture-guard.sh`, in SPRINT-04, and US005's to
      `how-to/src/OUTBOUND-TIMEOUTS.md`, owned by an uncut slice. The set is **re-measured at
      implementation, never inherited from this list**, and a bare pass is reported only if the run
      actually exits 0 — `QA-PLAN-US004-CITATION-GATE-GIT-INDEX` AC-GAP-3 stands: completion of
      US004 does not of itself make this a pass
- [ ] `bash code/src/scripts/audits/doc-references.sh --self-test` exits 0
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance; `how-to/src/PROJECT-PATHS.md` and
      `code/docs/FORWARD-VOICE.md` are the files US004 grows. `code/src/scripts/audits/CONTEXT.md`
      is not grown while at 298 code lines as that gate measures them — unless US002, now ahead of
      this sprint in SPRINT-02, has landed and built the headroom, in which case the ordinary ratchet
      applies. See Dependencies
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression only**; US004 adds no claims
      row. US003's new `owned` row, which this check named from 05/09/2026 to 07/09/2026, moved to
      SPRINT-02 with the story
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A here since 07/09/2026**; it entered
      this record with US003 on 05/09/2026 and ran only against that story's routing frontmatter.
      US004 adds no frontmatter. Marked with its reason rather than deleted, per
      `code/docs/GATE-REPORTING.md`; if US003 carries here, it applies again
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` — **N/A here since 07/09/2026**; same
      reason and same condition as the row above
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; the member creates no
      directory and so owes no new pair
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass,
      including ShellCheck over the script US004 edits
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a Python
      path; the member's proof is the script's own `--self-test`
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component
      added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **N/A since 07/09/2026**, the sprint's Security
      flag reads `N/A`. It applied here between 05/09/2026 and 07/09/2026 on US005's flag alone,
      and applies now in SPRINT-04, where US005 sits beside a second story whose Security flag is
      live
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

<!-- Two checks this record carried from 05/09/2026 to 07/09/2026 are gone rather than N/A'd,
     because they named a member's file and not a gate: the doc-references baseline "captured
     05/09/2026 at **56**" was US005's QA plan's figure, and "`code/docs/TASK-AUTHORING.md` at 266
     is the file to watch" was a file only US005's retry doctrine edits touched. Both travelled to
     SPRINT-04 with the story. -->

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its
      own DoD complete) — US004 alone
- [ ] **The carry-over question is disposed of in writing, either way.** US003's 5 SP `Should`
      carry is reserved to this record by SPRINT-02's Definition of Done. If US003 carried here, it
      is **Completed** here or explicitly carried on again with its reason recorded in both records
      and in `project-management/src/02-STORIES/US003.md` — a `Should` is never dropped silently,
      and **US003 has already moved twice** (SPRINT-02 → SPRINT-03 on 05/09/2026, SPRINT-03 →
      SPRINT-02 on 07/09/2026), so a third move records all three. If it did not carry, that is
      stated here rather than left as an unexplained 8 / 11. **In the carry case US004 is worked
      first and US003's baseline-diff scenario is read as a plain pass**: the revision pass this
      record carried from 05/09/2026 to 07/09/2026 applies again in that case, and in that case
      only

<!-- The row replaced here read: "The `Should Have` story is either **Completed** or explicitly
     carried to SPRINT-04 with its reason recorded here; it is never dropped silently. US003 has
     already moved once, from SPRINT-02, and a second move records both." Written 05/09/2026 when
     US003 was this sprint's stretch tier, and cited by project-management/src/02-STORIES/US006.md
     and by 03-SPRINT-PLAN-03.md:357-359 as the live reservation to SPRINT-04. Superseded
     07/09/2026: the reservation now runs INTO this record from SPRINT-02, not out of it to
     SPRINT-04, and SPRINT-04 no longer carries a contingent figure — it stands at 13 / 11 by
     decision. -->

- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in the member's QA plan
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Retrospective notes captured (optional — link or inline)

<!-- The row "Security findings whose promotion trigger fired during the sprint are re-assessed in
     project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/ rather than left at their
     present-state severity" was US005's — its threat model's design-state promotions — and moved
     with the story to SPRINT-04 on 07/09/2026. The union's Security row reads N/A. -->
