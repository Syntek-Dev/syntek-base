# SPRINT-04

**Last Updated**: 07/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Retry doctrine gets its single owner, and the posture rule gets a guard — exactly one
layer decides to repeat a failed operation and every budget says how long it may take, and six
destructive scripts read the deployment posture, five of them refusing above `development` unless
the operator names the live posture out loud.

<!-- The goal read "The rule that only Claude's compliance enforces becomes a guard the destructive
     scripts enforce themselves — six of them read the deployment posture, and five refuse above
     `development` unless the operator names the live posture out loud." until 07/09/2026, when
     US005 arrived from SPRINT-03 in the cascade re-plan recorded in the Notes. A goal naming only
     one of two members' deliverables is the drift SPRINT-02 recorded on 05/09/2026 when it lost
     US003. The goal is written in build order — US005 then US006 — on SPRINT-02's convention for a
     sprint with two subjects. -->

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **5 SP Must + 8 SP Must = 13 / 11 SP** — **at grace, taken
deliberately** (07/09/2026), all-`Must`, and **CLOSED** to further admission. See Notes.

<!-- Was "**8 / 11 SP** — inside capacity, all-`Must`, and **still admitting**. The figure is
     contingent: SPRINT-03 reserves a 5 SP carry to this record, and if it lands this sprint is
     13 / 11 and at grace. See Notes." until 07/09/2026. Both halves are superseded by the cascade
     re-plan: the figure is no longer contingent, because US005 arrived from SPRINT-03 and the US003
     carry is now reserved from SPRINT-02 into SPRINT-03 and reaches this record under no branch;
     and the record is no longer admitting, because 13 SP is the grace ceiling. Kept rather than
     erased, because it is the reasoning this record opened on. -->

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 05/09/2026 on US006's admission — the union over one member is that member's table.
     Two rows carried values, and both moved at a gate rather than at cutting: Security was widened
     at 10-security-checks on 05/09/2026 from the eight criteria the story carried, and QA was
     widened at 11-qa-checks the same day when the four-versus-six carrier-state count was
     replaced by a single enumerated proof-case list (QA-PLAN-US006 AC-GAP-7).
     Recomputed 07/09/2026 on US005's ARRIVAL from SPRINT-03, and CHANGED in two rows. Security
     widens from US006's five subjects to nine: US005 brings the four its own gate 10 settled —
     retry amplification, untrusted Retry-After, duplicate execution and attempt-log leakage
     (QA-PLAN-US005 AC-GAP-15). QA widens from US006's unit-plus-manual value to add US005's three
     manual documentation gates. Neither value is narrowed: per SPRINTS.md the union narrows only
     for a Part A / Part B split, and US005 did not split, it moved. US005's other eleven rows are
     N/A and change nothing.
     SPELLING, so it is not read as drift: US005's flag writes its gates with .sh and US006's flag
     names no script at all. The union writes the three gates with .sh, as US005 does; the full
     paths are in the Verification Checks, and neither story's own flag is rewritten.
     Eleven rows stay N/A because both members ship no model, no endpoint, no screen, no
     personal-data path, no log line and no public page: US005 is documentation only, and US006 is
     a bash helper, six shell callers, one CI workflow line, two registers and three Markdown
     files. -->

| Flag       | Value                                                                                                                                                                                                     |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                                                                                                                       |
| User Flow  | N/A                                                                                                                                                                                                       |
| Brand      | N/A                                                                                                                                                                                                       |
| Components | N/A                                                                                                                                                                                                       |
| Wireframes | N/A                                                                                                                                                                                                       |
| GDPR       | N/A                                                                                                                                                                                                       |
| Security   | retry amplification · untrusted `Retry-After` · duplicate execution · attempt-log leakage · fail-open carrier read · template stand-down · control removal · unrecoverable carrier · CI standing override |
| QA         | unit — guard self-test over the enumerated proof-case list; manual — `docs-length.sh`, `doc-references.sh`, `doctrine-drift.sh`, and that same proof-case list walked by hand                             |
| SEO        | N/A                                                                                                                                                                                                       |
| API        | N/A                                                                                                                                                                                                       |
| Logging    | N/A                                                                                                                                                                                                       |
| Backend    | N/A                                                                                                                                                                                                       |
| Frontend   | N/A                                                                                                                                                                                                       |

---

## Story Summary

| ID    | Title                                                                                        | MoSCoW    | SP  |
| ----- | -------------------------------------------------------------------------------------------- | --------- | --- |
| US005 | Exactly one layer decides to retry, and every budget says how long it may take               | Must Have | 5   |
| US006 | The destructive dev scripts read the deployment posture, and refuse to run above development | Must Have | 8   |

**Total:** 13 SP — **all committed, no stretch tier, 2 SP over capacity and at the grace ceiling.**
Rows are in build order, US005 then US006, settled 07/09/2026. **This is the sprint's known
weakness, and it is worse than when the record opened**; see Notes.

<!-- The total read "8 SP — all committed, no stretch tier. **This is the sprint's known weakness**;
     see Notes." until 07/09/2026, when US005 arrived from SPRINT-03. US005 was added to this table
     rather than referenced from it because SPRINTS.md computes the flag union and the capacity
     FROM this table, and a story in no Story Summary is counted nowhere. -->

## Dependencies

- **Build order is US005 then US006, and it was settled on 07/09/2026 rather than derived here.**
  The two members share no file and neither blocks the other, so the order is a decision about
  which outcome the sprint reaches first, not a constraint either story imposes.
- **US005 is blocked by `project-management/src/02-STORIES/US001.md`** — a SPRINT-01 member, still
  `Open`, in a sprint that is `Planned`. US005's four rules are stated **inside** the
  `code/docs/reliability/` family, and that family is US001's deliverable; it exists in no branch
  and no commit today. This constraint travelled with the story from SPRINT-03 on 07/09/2026, and
  the move lengthens the distance between blocker and blocked: SPRINT-01 now builds US007 then
  US001, and US005 sits three sprints later rather than two.
- **US006 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-01`, whose map records
  `Frontier open: 0 · Blocking open: 0` and whose `Gate to stories` states both slices may be cut
  now.
- **One ordering constraint on US006 is cross-sprint, and the sprint it points at changed on
  07/09/2026.** US006's citation-gate Verification Check is written against two different regimes
  depending on whether **US004** — now SPRINT-03's sole `Must`, moved there from SPRINT-02 in the
  cascade re-plan — has landed. US004 retires the baseline-diff regime of
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` by its
  own terms, after which this gate exits `0` on a clean tree and is read as a plain pass. **US006
  does not block on US004** — the check names both branches explicitly, which is what
  `QA-PLAN-US006-POSTURE-GUARD` AC-GAP-15 closed — and SPRINT-03 is built before this sprint, so
  the plain-pass branch is the expected one. **The same contingency now governs US005's citation
  check**, which its story wrote as a diff against a recorded baseline "because that repair has
  not landed"; see Verification Checks.
- **US006 collides with no other story's files, and every owner it names has moved sprint.** It
  writes into none of `code/docs/ABSENCE.md` (US003 creates it — SPRINT-02's stretch tier since
  07/09/2026, with its 5 SP carry reserved into SPRINT-03), `code/docs/reliability/` (US001
  creates it — SPRINT-01), or `code/src/scripts/audits/CONTEXT.md` (US002 owns its headroom, at
  298 of 300 **code** lines as `audits/docs-length.sh` measures them — SPRINT-02 since
  07/09/2026). The last was a live risk at slice selection: hosting the guard's proof in a new
  `audits/` gate would have cost two rows in that file, and the proof went to
  `database/migrate.sh --self-test` instead.
- **US005 and US006 share no file.** US005 writes retry doctrine into `code/docs/reliability/` and
  repairs six existing guides, `code/docs/NEGATIVE-SPACE.md` and its own feature map; US006 writes
  `code/src/scripts/_lib/posture-guard.sh`, six scripts, one CI workflow line, the `_lib/` pair,
  `how-to/src/DEPLOYMENT-POSTURE.md`, `how-to/docs/CLI-TOOLING.md`, five call-site documents and
  its own feature map. Since 07/09/2026 the two stories share this sprint record again — which was
  the one overlap US006's own Dependencies said the move to SPRINT-04 had removed — so path-scoped
  staging on `pm/story-creation` covers both stories' artefacts **and** this file.
- **US006 does not unblock `S-02`** ("The seed presence gate") on its own map. The two slices share
  no file — `S-02` writes only `.github/scripts/shipped-artefacts.sh` — and widening US006 to carry
  both was declined at slice selection for want of a shared seam. **`S-02` is not cut into a story,
  and this record is closed to it regardless**; see Notes.
- **US005 unblocks three slices** on
  `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` — `S-04` (the
  example-repair sweep), `S-05` (the `retry-discipline.sh` gate, whose claims row pins this
  doctrine's wording) and `S-06` (the live-code fixes). None is yet cut into a story. Carried from
  SPRINT-03 with the story on 07/09/2026.
- **Two slices run beside US005 and neither blocks it:** `S-09`, the outbound timeout register
  split out of `S-02` at story creation, and `S-03` on the same map, the idempotency half of the
  same rule — named as a runs-beside dependency at the QA gate on 05/09/2026 (`AC-GAP-11`).
- **Nothing carries into this record.** The US003 carry that SPRINT-03's Definition of Done
  reserved to SPRINT-04 is superseded: since 07/09/2026 US003 is SPRINT-02's stretch tier and its
  carry is reserved into **SPRINT-03**, one sprint earlier than before and never reaching here.
  The clause that reserves it now lives in SPRINT-02's Definition of Done. This record's capacity
  line is a settled figure, not an arithmetic risk.
- **`Blocked` is a story status, not a sprint one.** This sprint's `Status` stays `Planned`; US005's
  blocker is recorded here and in the story, and it is the story's own `Status` that moves if its
  wait becomes real.

<!-- The bullet replaced by "Nothing carries into this record" read: "**This sprint's own
     contingency is a dependency in the other direction:** SPRINT-03's Definition of Done reserves
     a carry to **this record**. See Notes; it is not a blocker, it is an arithmetic risk on the
     capacity line." True from 05/09/2026 until 07/09/2026, when the cascade moved US003 to
     SPRINT-02 with its carry reserved into SPRINT-03. Kept so the contingency reads as one that
     was recorded and then closed, not one that was never noticed.
     The bullet replaced by "US005 and US006 share no file" read: "**US006 runs beside US005 and
     shares no file with it.** US005 is parallel work on `MAP-RETRY-AND-IDEMPOTENCY` in SPRINT-03.
     Since US006 moved to this record on 05/09/2026 the two sessions share no artefact at all — the
     sprint record was the one overlap — which is what makes path-scoped staging on
     `pm/story-creation` safe for both without a worktree." The no-shared-file fact survives; the
     no-shared-artefact fact does not, because US005 is now a member here. -->

## Notes

**US005 arrived here from SPRINT-03 on 07/09/2026, before any sprint was worked, as the last move
of a four-sprint cascade.** US007 — the story `**Status:**` vocabulary, cut 07/09/2026 at 5 SP
`Must Have` — must ship **before** US002, because US002's line of work builds `register-indexes.sh`
and its status fixtures against whichever vocabulary is canonical on the day it ships. Rather than
reorder execution inside the existing membership, <%DEVELOPER_NAME%> settled a full cascade:

| Sprint      | Members, in build order                                    | SP                                  |
| ----------- | ---------------------------------------------------------- | ----------------------------------- |
| `SPRINT-01` | US007 (`Must`, 5) then US001 (`Must`, 5)                   | 10 / 11                             |
| `SPRINT-02` | US002 (`Must`, 3) then US003 (`Should`, 5, stretch)        | 8 / 11                              |
| `SPRINT-03` | US004 (`Must`, 8), plus US003's reserved carry if it slips | 8 / 11, or 13 / 11 with the carry   |
| `SPRINT-04` | US005 (`Must`, 5) then US006 (`Must`, 8)                   | 13 / 11 — grace, taken deliberately |

US007 is new into SPRINT-01; US002 moves SPRINT-01 to SPRINT-02; US003 moves SPRINT-03 to SPRINT-02
as the stretch tier, with its carry reserved into SPRINT-03 — the same shape it held in SPRINT-03,
one sprint earlier, and **not** a split of the story; US004 moves SPRINT-02 to SPRINT-03; US005
moves SPRINT-03 to here. US001 and US006 stay where they were. **No SPRINT-05 is created.** Every
sprint is `Planned` and unworked, so each move is a **re-plan rather than a carry-over** — the
distinction SPRINT-03 drew on 05/09/2026 when US003 moved out of SPRINT-02, and the precedent for
recording a move in both records rather than ticking a carry clause off in one. Each moved story
keeps its own `**Status:** Open`; this cascade moves membership and nothing else.

**This sprint takes grace, and takes it deliberately.** `project-management/docs/planning/CADENCE.md`
owns both figures — capacity 11 SP, grace 13 SP — and reads: "Grace exists for one situation: the
next story would overshoot, and splitting it would produce two halves that make no sense alone.
Grace is not a routine allowance — a sprint that habitually runs to it means the capacity figure is
wrong" (`CADENCE.md:119-121`). **This is not quite that situation, and the record says so rather
than stretching the doctrine to fit.** US005 is not being split; it overshoots by 2 SP whole. The
alternative was a `SPRINT-05` holding US006 alone at 8 / 11 — a single-member all-`Must` sprint,
the shape SPRINT-03 called "this sprint's one real weakness" on opening and this record called its own on
05/09/2026 — and <%DEVELOPER_NAME%> chose the grace over that on 07/09/2026. One sprint of four at
grace by plan is not the habitual case CADENCE warns about; the check on that reading is the one
CADENCE itself names, revisiting both figures after two sprints against measured velocity.
**SPRINT-04 is therefore CLOSED to further admission.** It stands at the hard ceiling, so nothing
is admitted regardless of what clears `15-decisions` next — `MAP-SCRIPT-GUARDS` `S-02` included,
when it is cut.

**The all-`Must` weakness this record opened with is now worse, and it is accepted rather than
repaired.** `project-management/docs/planning/SPRINTS.md` is explicit: "**Avoid a plan where
everything is Must.** If every story is Must, the sprint has no give and the first surprise breaks
it." On 05/09/2026 this record had one `Must` at 8 / 11 with 3 SP of room for a `Should`. It now
has **two `Must` stories at 13 / 11 with no room at all**: no stretch tier, no story that can slip
without the sprint failing its own Definition of Done, and no headroom in which to admit one.
SPRINT-02's reading that grace "covers the ceiling, not the commitment" — its `Must` tier stayed
inside capacity and the 5 SP above it was stretch — does not apply here, because **the commitment
itself is 13 SP**. This is the first sprint record whose `Must` tier alone exceeds capacity. The
repair SPRINT-03 used, admitting a `Should`, is foreclosed by the closure above. What is true and
is not a repair: the two members share no file and neither blocks the other, so an overrun in one
does not stall the other — but the sprint still needs both. Recorded plainly because it was the
price <%DEVELOPER_NAME%> paid on 07/09/2026 for not opening a fifth sprint around one story, and a
record that softened it would be recording a different decision.

<!-- The paragraph replaced here read: "**This sprint opens with one all-`Must` member, and that is
     its known weakness rather than an oversight.** `project-management/docs/planning/SPRINTS.md`
     is explicit: "**Avoid a plan where everything is Must.** If every story is Must, the sprint
     has no give and the first surprise breaks it." SPRINT-03 hit the same shape on opening and
     named it "this sprint's one real weakness", and repaired it by admitting US003 as a `Should`.
     **No such repair is available here.** The candidate give is `S-02` on the same map, which is
     not cut into a story; every other open slice belongs to a different map and a different
     session. Recorded rather than papered over, and it is the reason this record stays open to
     admission." True from 05/09/2026 until 07/09/2026. The weakness it names survives and has
     grown; the "stays open to admission" it ends on does not, because the record is now closed
     at grace. -->

<!-- The two-futures table and the three paragraphs around it are superseded in full by the
     cascade of 07/09/2026, and kept here because they were the reasoning this record opened on.
     They read:

     "**The capacity figure is contingent, and the contingency is SPRINT-03's to exercise.**
     `project-management/src/03-SPRINTS/SPRINT-03.md` Definition of Done provides that its
     `Should Have` member — US003, 5 SP — is "either **Completed** or explicitly carried to
     SPRINT-04 with its reason recorded", and
     `project-management/src/16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` repeats it. So there are two
     futures for this line and both are recorded now rather than discovered later:

     | If US003…              | This sprint stands at                  | Reading                          |
     | ---------------------- | -------------------------------------- | -------------------------------- |
     | completes in SPRINT-03 | **8 / 11 SP**, all `Must`              | Inside capacity. The all-`Must`  |
     |                        |                                        | weakness above stands and this   |
     |                        |                                        | record is still admitting        |
     | carries to SPRINT-04   | **13 / 11 SP** — 8 `Must` + 5 `Should` | **At grace**, and the weakness   |
     |                        |                                        | is repaired: the carry is give   |
     |                        |                                        | that can slip again              |

     **The second is the better sprint, and it is not this record's decision to take.** Grace is
     reserved for a story that would otherwise split badly, and a carry-over is not that — but a
     carry arriving into a single-member sprint is precisely the case where 13 SP buys a stretch
     tier rather than an overcommitment, because the `Must` tier stays at 8 either way. **If US003
     carries here, do not treat the 13 as an overrun**; that reading is what SPRINT-02 recorded
     when its own grace covered "the ceiling, not the commitment". Whoever closes SPRINT-03 makes
     the call and records it in both records."

     Neither future happened. US003 moved to SPRINT-02 with its carry reserved into SPRINT-03, so
     it reaches this record under no branch; and the 8 / 11 figure is gone because US005 arrived.
     The sprint stands at 13 / 11 — the second row's number — but for the opposite reason: both
     members are `Must`, so the 13 IS the commitment, and the "not an overrun" reading this table
     offered does not transfer. -->

**US006's own Dependencies section cited the wrong reservation until 05/09/2026, and has been
overtaken again since.** It named "the 5 SP `Should Have` carry-over that SPRINT-02's Definition of
Done reserves" — but SPRINT-02 exercised that reservation the same day, moving US003 to SPRINT-03,
and the live reservation became SPRINT-03's. Caught at `11-qa-checks` as
`QA-PLAN-US006-POSTURE-GUARD` AC-GAP-16 and corrected in place in the story, superseded text
preserved. **As of 07/09/2026 that correction is itself superseded**: the story's Dependencies
still describe SPRINT-03 at 10 / 11 with US003's carry reserved to SPRINT-04, and cite the carry
clause by line number in `SPRINT-03.md`. The clause now lives in SPRINT-02's Definition of Done and
reserves the carry into SPRINT-03. The story file belongs to the cascade, not to this record; the
divergence is named here so a reader of `US006.md` knows which record is current.

**US006 was refused admission to SPRINT-03 on 05/09/2026, and the arithmetic that refused it is
recorded there rather than re-argued here.** SPRINT-03 stood at 5 SP all-`Must` when the question
was live, so 8 more would have taken it to 13 — its grace ceiling — and displaced the reservation
above. Measured against SPRINT-03 as it stood on 05/09/2026, at 10 / 11, US006 would have given 18
SP: over grace rather than at it. Either reading refused it. Opening this record was
<%DEVELOPER_NAME%>'s call. **The question is moot since 07/09/2026** — SPRINT-03 now holds US004
alone at 8 / 11 — and US006 stays here by that day's decision, not by the earlier refusal.

**This record was opened after gates `10`, `11` and `15`, not at `03`, and the deviation is
deliberate.** `project-management/docs/planning/CADENCE.md` fixes the running order
`02 → 03 → … → 15`. SPRINT-03 states the precedent in its own Notes: a sprint record opens when its
member has cleared the specify tier, because gates `10` and `11` supply the record's Security and
QA sections and gate `15` supplies the decisions those sections rest on. Opening at `03` would mean
authoring sections those gates immediately rewrite — which is not hypothetical here, since gate
`11` widened the QA flag value this record's union carries.

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint once
every member has cleared `15-decisions`.** Both have. US006's QA plan
(`project-management/src/11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md`) carries no `[OPEN]` gap —
all twenty-two resolved 05/09/2026 — and both its ADRs are written and `Accepted`:
`project-management/src/15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` and
`project-management/src/15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md`, the
second carrying a dated erratum on the size of the fail-closed set. US005's QA plan
(`project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`) carried one
`[OPEN]` gap during its session — the boto3 clamp literal, `AC-GAP-1` — and it closed the same
day, 05/09/2026. CADENCE's no-unresolved-gap prerequisite is therefore satisfied for both members.
**The carry-over question that held `16` back is settled** (07/09/2026: nothing carries into this
record), so the plan may now be written — and **it has not been**. No
`project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` exists on 07/09/2026; authoring it
is a separate `16-sprint-plans` run with its own grilling pass and its own prerequisite gate, not
a side-effect of this re-plan. On the story-plan side, US005's plan exists
(`project-management/src/17-STORY-PLANS/STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`, written
05/09/2026 when it was a SPRINT-03 member — its `Sprint` row is the cascade's to re-resolve, not
this record's) and **US006's does not**; `17-story-plans` owns writing it and has its own gate.
When the sprint plan is written, its exec-order segment reads `04`: every blocker of every member
sits in an earlier-numbered sprint, so sprint number and build order agree here.

<!-- The paragraph replaced here ended: "CADENCE's no-unresolved-gap prerequisite is therefore
     satisfied for the sole member, and `16` may run whenever the carry-over question above is
     settled. **Do not run `16` before it is**, because the plan is written against a settled story
     set and this one has two possible shapes." True from 05/09/2026 until 07/09/2026, when the
     cascade settled the story set at US005 and US006 and removed the second shape. The clause did
     its job: no plan was written against a set that then changed. -->

---

## Acceptance Criteria

Two independent outcomes, one per member, and every documentation gate runs clean against both.

**US005** — cross-surface retry doctrine states four things once, in the reliability family: who
decides to repeat an operation, how an inbound `Retry-After` is honoured, what every retry's
budget is, and why circuit breakers are deferred. Every guide that previously stated a competing
budget either cites the family or carries a number that agrees with it; no worked example in the
tree demonstrates a shape the doctrine bans; and no guide is left telling a reader the opposite of
the owner rule.

**US006** — `code/src/scripts/_lib/posture-guard.sh` reads `DEPLOYMENT_POSTURE` from
`.copier-answers.yml` once per invocation and fails **closed** on everything it cannot positively
read as `development` or as this template repository. Five scripts refuse above `development`
unless the run names the live posture — `database/reset.sh`, `database/restore.sh`,
`database/seed-dev.sh`, and both `server.sh down --volumes` paths, plus `development/server.sh
up --seed` — and `database/migrate.sh` warns at every posture and proceeds. The guard proves itself
through `migrate.sh --self-test` over twenty-one fixture cases with the stack down,
`.github/workflows/test-e2e.yml` keeps working with an explicit override and no `|| true`, and
`how-to/src/DEPLOYMENT-POSTURE.md` stops telling its reader the rule is unenforced.

### Security Acceptance Criteria

<!-- Kept and substituted rather than filled: every row in the template names a runtime control —
     rate limits, audit rows, HTML escaping, ABAC — and this sprint ships no runtime. What replaces
     them is the developer constraints each member's security gate produced: eleven for US005,
     constraints on the doctrine's wording; twelve for US006, constraints on one helper's read
     path, amended at its QA gate. Substituting rather than deleting, per
     code/docs/GATE-REPORTING.md: a section removed reads as a gate that did not apply, and this
     one did for both members.
     BOTH MEMBERS CONTRIBUTE, and this is the first sprint record where the Security union has two
     contributors — which is why every row names its story rather than "this sprint". Until
     07/09/2026 this comment read "ALL OF IT IS US006's, this record having one member." -->

- [ ] **US005** — the eleven developer constraints in
      `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md`
      Section 7 are satisfied by the doctrine's wording, each checkable by reading the shipped guide
- [ ] **US005** — **no CRITICAL or HIGH finding is open.** Its gate closed 05/09/2026 with twelve
      findings — eleven `INFO`, one `LOW` — so nothing blocks sprint planning and nothing is
      escalated to `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/`. That is a
      decision with its reason recorded, not an audit that found nothing
- [ ] **US005** — the present-state severities are read **with** the promotion-trigger table in
      `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`
      Section 3a. Four rows are design-state `HIGH`; every `INFO` here is a fact about a tree in
      which nothing retries, and it expires at the first wired client
- [ ] **US005** — `DEFERRED.md` records the unenforced window at ship — the rule exists and
      `retry-discipline.sh` does not — naming slice `S-05` as owner and the first client-wiring
      story as its deadline (TM-02, the one non-`INFO` finding)
- [ ] **US006** — the **twelve** developer constraints in `project-management/src/02-STORIES/US006.md`
      Section 7.1 to Section 7.12 are satisfied, each checkable by reading the shipped helper and
      its six callers. **Eleven of the twelve are Section 7 of
      `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md`;
      three of those eleven were amended and a twelfth added at `11-qa-checks` on 05/09/2026** —
      where the story and the assessment now disagree, the story is the corrected record and the
      assessment is the one to update
- [ ] **US006** — **no CRITICAL or HIGH finding is open.** Its gate closed 05/09/2026 with eighteen
      findings across all six STRIDE categories — 0 CRITICAL, 0 HIGH, 9 MEDIUM, 7 LOW, 2 INFO — so
      nothing blocks sprint planning and nothing escalates to
      `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/`. That is a decision with its
      reason recorded, not an audit that found nothing
- [ ] **US006** — the present-state severities are read **with** the promotion-trigger table in
      `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md`.
      **Five findings promote to HIGH at the first staging surface**, and TM-02 and TM-08 promote at
      the first `copier update` run against a project above `development` — every MEDIUM here is a
      fact about a tree with nothing deployed, and it expires the day that stops being true
- [ ] **US006** — **the four fail-open paths the story left open at cutting are closed**, and each
      is verified as closed rather than assumed: the unconstrained override in a damaged carrier
      (AC-GAP-4), the unforwardable override across the `seed-dev.sh` shell-out (AC-GAP-3), the
      compose-target assertion with no criterion and no test (AC-GAP-11), and the CI override with
      no named owner (AC-GAP-13)
- [ ] **US006** — the guard call is asserted **present** in each of the six bound scripts, as a
      line-order comparison — a tested function is not an enforced control (TM-03)
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint — US005 ships
      prose; US006's guard reads the answers file, prints the posture, and prints nothing else from
      it (TM-15)

### QA Acceptance Criteria — Automated

<!-- US006's alone. US005's QA flag names a manual type and no automated one, so it contributes
     nothing here — recorded rather than inferred, per code/docs/GATE-REPORTING.md. Until
     07/09/2026 this comment read "Its single member is the only contributor to every row." -->

- [ ] `bash code/src/scripts/database/migrate.sh --self-test` exits 0, **with the stack down** —
      the arm dispatched ahead of that script's command validator and its `container_running` check
- [ ] One fixture case exists per entry in US006's enumerated proof-case list — **cases 1 to 21**, none
      omitted and none doubled up. Refusing cases assert exit code **and** message prefix together;
      permitting cases assert completion at exit 0
- [ ] **No pre-change comparison is claimed anywhere.** There is no pre-change guard for a fixture
      to fail against, and the permitting cases proceed identically before and after the change —
      recorded here because the criterion it replaces is one this repository's other sprints do
      legitimately carry (`QA-PLAN-US006-POSTURE-GUARD` AC-GAP-6)
- [ ] No fixture writes outside a temporary directory, and the self-test carries a `trap` so a
      failure mid-run leaks nothing into the working tree
- [ ] Coverage floors — **N/A**, neither member ships a Python path; US006's proof is the
      `--self-test`, US005 ships prose, and there is no Django code path for the floor to measure

### QA Acceptance Criteria — Manual

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US005-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/US006-MANUAL-TESTING.md` each carry a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in either member's QA plan —
      `project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` (all
      fifteen resolved 05/09/2026) or
      `project-management/src/11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` (twenty-two found,
      twenty-two resolved 05/09/2026)

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### Security Tasks

| Story | Task                                                                                                                     | Done |
| ----- | ------------------------------------------------------------------------------------------------------------------------ | ---- |
| US005 | Satisfy the eleven doctrine-wording constraints from the assessment's Section 7                                          | [ ]  |
| US005 | Write the `DEFERRED.md` entry for the unenforced window, naming `S-05` and its deadline                                  | [ ]  |
| US005 | Confirm each design-state promotion trigger names a story or slice that can actually meet it                             | [ ]  |
| US006 | Satisfy Section 7.1 to Section 7.12, and update `ASSESSMENT-PLAN-US006-POSTURE-GUARD` Section 7 to match the amended set | [ ]  |
| US006 | Confirm each design-state promotion trigger names a surface or event that can actually fire it                           | [ ]  |
| US006 | Assert the guard call present in all six bound scripts by line-order comparison                                          | [ ]  |
| US006 | Name the CI override's owner and trigger beside the literal at `.github/workflows/test-e2e.yml:133`                      | [ ]  |

### QA Tasks — Automated

<!-- US006's alone; US005 has no automated type. -->

- [ ] US006 — the `--self-test` runs and its output is recorded in
      `project-management/src/18-TESTS/US006-TEST-STATUS.md`
- [ ] US006 — all twenty-one proof cases are present and each is recorded with its observed exit code
      and message
- [ ] US006 — the damaged-carrier case is run **with** a validated override and **without** one, and
      both refusals recorded
- [ ] US006 — the compose-target case is run with no Docker daemon available, proving the check
      reads the environment rather than contacting one, and that it follows the caller's mode: the
      five refusing scripts refuse at exit 4, `migrate.sh` warns and proceeds

### QA Tasks — Manual

- [ ] US005 — the three documentation gates named in its own flag run, and their output recorded in
      `project-management/src/18-TESTS/US005-MANUAL-TESTING.md`, read as a diff against the
      baseline captured in the QA plan's Section 7 (`doc-references.sh` at **56**, 05/09/2026, with
      US005's artefacts untracked) — **or as a plain pass if US004 has landed**; see Verification
      Checks
- [ ] US005 — the retry-statement inventory is captured **before** any edit, with US001's landing
      state recorded beside it, and it balances at close
- [ ] US005 — the derived worst-case column is recomputed by hand on a default row **and** on the
      webhook override row, with both arithmetic strings written out
- [ ] US005 — the human read-across across six guides finds no budget stated in two homes and no
      guide stating the inverse of the owner rule
- [ ] US005 — a reader who opens `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md:265` cold
      reaches the breaker deferral in one hop, and `code/docs/NEGATIVE-SPACE.md:226` reads true
      after the repoint whichever story made it
- [ ] US005 — a tester other than the author has signed the walk-through off
- [ ] US006 — all ten carrier states (cases 1 to 10) walked by hand against a scratch answers file, with exit code
      and message recorded for each
- [ ] US006 — the template case walked **in this repository**, across all six scripts, with the
      answers file confirmed unmodified afterwards
- [ ] US006 — `up --seed --force-posture <live posture>` walked end to end, confirming the override
      crosses the shell-out into `seed-dev.sh` rather than dying at its option parser
- [ ] US006 — the refusal message read as an operator would read it: the posture it names is
      correct, and the command it suggests works verbatim when pasted
- [ ] US006 — the damaged-carrier refusal confirmed to suggest a **repair** rather than an override,
      and to name no posture
- [ ] US006 — both `server.sh down --volumes` paths walked at `development`, confirming the guard
      adds no friction to the ordinary path
- [ ] US006 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no page,
      component or interactive surface

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation, a bash helper, six shell callers, one workflow line and Markdown, and per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/database/migrate.sh --self-test` exits 0 — **US006's alone**
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass —
      Markdown lint and formatting over US005's guides; ShellCheck clean over US006's new helper and
      all six callers, with the `# shellcheck source=` directive resolving in each
- [ ] `bash code/src/scripts/audits/doc-references.sh` — **which reading applies is contingent on
      US004, now SPRINT-03's sole `Must`, and both branches are named for both members.** If US004
      has landed — the expected case, SPRINT-03 being built before this sprint — the gate exits `0`
      on a clean tree and is read as a plain pass for both, the baseline-diff regime of
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
      having retired by its own terms. If it has not, each member is read as a diff against **its
      own** recorded baseline, and never as a bare pass — and the two baselines are **not**
      comparable with each other, because they were measured in different git-index states:
      **US005's is 56**, measured 05/09/2026 with US005's artefacts untracked
      (`QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS` Section 7); **US006's is 103 tree-wide and 9 on
      `US006.md`**, measured 05/09/2026 at HEAD `c6df520` on a clean tree, and **127 tree-wide**
      with its artefacts staged, every one of the 24 added being an instance citation of a PM
      artefact — the class `ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` exempts — or a
      forward reference to `code/docs/ABSENCE.md`, `code/docs/reliability/` or US006's own
      `posture-guard.sh`, each clearing when US003, US001 or US006 lands. **None is of a class this
      sprint owns.** The index state is recorded beside every figure because it must be: the same
      tree gave 153 an hour earlier, when a parallel session's two plan files were still untracked
      and contributed 69 of the difference. A story worked here re-captures its own baseline
      immediately before its first edit, in the same index state it will be measured in
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance. Two files to watch: `code/docs/TASK-AUTHORING.md` at
      266, which US005 edits; and `code/src/scripts/audits/CONTEXT.md`, which US006 leaves unchanged
      at **298 code lines as that gate measures them**, not the 357 `wc -l` reports — US002 in
      SPRINT-02 owns its headroom
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` passes — US006 edits both halves of the
      `code/src/scripts/_lib/` pair, adding the helper to `CONTEXT.md` and the caller contract to
      `CLAUDE.md`; US005 creates no directory, the reliability family's pair being US001's
      deliverable in SPRINT-01. Neither member creates a directory, so no new pair is owed
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression only**, for both members.
      US005's doctrine is prose, per
      `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`, and
      the guard's contract is prose; neither adds a claims row. A green run says the registered
      claims are undisturbed and says **nothing** about retry doctrine or the posture rule appearing
      in two homes; it is never reported as though it had
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, neither member adds routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a Python path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies to both members**, and this is the
      first sprint record in which two stories contribute to it
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its own
      DoD complete) — **US005 and US006, both.** There is no `Should Have` tier here, so a slip in
      either fails the sprint; that is the cost recorded in the Notes, not a surprise
- [ ] **Nothing carries into this record, and nothing is expected to.** The US003 carry that
      SPRINT-03 reserved to SPRINT-04 is superseded: since 07/09/2026 US003 is SPRINT-02's stretch
      tier with its carry reserved into SPRINT-03, and that clause lives in SPRINT-02's Definition
      of Done. If US003 somehow arrives here anyway, it is recorded in both records with its reason,
      and the 13 / 11 above becomes 18 / 11 — over grace — which is refused on arithmetic before it
      is argued
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in either member's QA plan
- [ ] `ASSESSMENT-PLAN-US006-POSTURE-GUARD` Section 7 has been updated to the amended twelve, so the
      security record and the story no longer disagree
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity — for either member
- [ ] Retrospective notes captured (optional — link or inline)

<!-- The second row read: "**The carry-over question is disposed of in writing, either way.** If
     US003 carried here from SPRINT-03 it is `Completed` or carried on again with its reason
     recorded in both records; if it did not, that is stated here rather than left as an
     unexplained 8 / 11." True from 05/09/2026 until 07/09/2026, when the cascade reserved US003's
     carry into SPRINT-03 instead. Disposed of in writing, as it asked — the disposition is that
     the question no longer reaches this record. -->
