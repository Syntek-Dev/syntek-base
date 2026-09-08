# SPRINT-PLAN-04 — Retry doctrine gets its single owner, and the posture rule gets a guard

**Last Updated**: 08/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-04.md` · **Capacity:** 5 SP Must + 8 SP Must = 13 / 11 — at grace, taken deliberately (07/09/2026), all-`Must`, **CLOSED** · **Stories:** 2

<!-- Written 08/09/2026 by a `16-sprint-plans` run against a settled story set — the run
     ../03-SPRINTS/SPRINT-04.md -> _Notes_ said on 07/09/2026 was owed and had not happened.
     Both segments of this file's name read `04`, and that is an AGREEMENT rather than a
     coincidence: ./CLAUDE.md rules that a mismatch between `<exec-order>` and `<sprint-number>`
     is deliberate information, so a reader who knows that guardrail should also know this pair
     was derived and found to agree. _Build order_ below shows the derivation. The plan MIRRORS
     the record; where the two would disagree, the record wins and the disagreement is named
     here rather than resolved by paraphrase. -->

---

## Sprint Goal

> Retry doctrine gets its single owner, and the posture rule gets a guard — exactly one layer
> decides to repeat a failed operation and every budget says how long it may take, and six
> destructive scripts read the deployment posture, five of them refusing above `development`
> unless the operator names the live posture out loud.

<!-- The record's `**Goal:**` line, verbatim, on ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md's
     convention that a plan carries the record's goal rather than a paraphrase so the two cannot
     drift. It is written in build order — US005 then US006 — for a sprint with two subjects, and
     it is not narrowed to either member's deliverable: the record's own goal comment names a
     goal carrying one of two members' deliverables as the drift SPRINT-02 recorded on 05/09/2026
     when it lost US003. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`. The authorities this
> sprint defers to are `code/docs/GATE-REPORTING.md` for how a gate's result is reported,
> `code/docs/DOCUMENTATION-LENGTH.md` for what a documentation file may weigh, and — for US006 —
> `.claude/CLAUDE.md` Section 0, the posture rule the guard enforces, with
> `how-to/src/DEPLOYMENT-POSTURE.md` as its per-surface register and
> `code/src/scripts/_lib/CLAUDE.md` for the helper contract the new helper joins. Where a story's
> wording and those guides differ, the guides win.
>
> **One authority for this sprint does not exist yet, and it is why the first member is blocked
> rather than merely sequenced.** US005's four rules are stated **inside** the reliability family
> under "code/docs/reliability/", and that family is US001's deliverable in SPRINT-01. Until it
> lands there is no home to defer to. `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` carried this
> paragraph from 05/09/2026 until 07/09/2026 and recorded that the block travelled with the story
> and was SPRINT-04's to state; this is where it is stated.

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-04.md`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| User stories       | `../02-STORIES/US005.md` · `../02-STORIES/US006.md`                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| Feature maps       | `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` slice `S-02` (US005) · `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-01` (US006)                                                                                                                                                                                                                                                                                                                                                 |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                                                                                                                                                                                                                                                                                       |
| User flows         | **N/A** — both read `User Flow: N/A`; no user journey in scope                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                                                                                                                                                                                                                                                                                             |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Security           | **Live, both members, two artefacts each.** US005: `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` (Signed off) and `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` (Signed off, corrected in place 05/09/2026). US006: `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` (Reviewed) and `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` (Reviewed) |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — **Signed off**, fifteen gaps found, fifteen resolved · `../11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` — **Signed off**, twenty-two found, twenty-two resolved                                                                                                                                                                                                                                                    |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Logging            | **N/A** — both read `Logging: N/A`; no log line                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Decisions          | Six ADRs bind this sprint — one authored by US005, two by US006, three inherited. Listed under _Sprint-wide Constraints_                                                                                                                                                                                                                                                                                                                                                                |
| **Story plans**    | `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — written 05/09/2026, repointed 07/09/2026 · `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — written 08/09/2026 under the reserved `07-`, indexed here the same day                                                                                                                                                                                                                                   |

<!-- 08/09/2026, `17-story-plans` Step 10 for US006: the Story plans cell's second half read
     "US006's — **does not exist**: `17-story-plans` has not run for it; the number `07-` is
     reserved and no path is invented here". The plan was written later that day under the
     reserved name and the cell now points at it. -->

**Every `N/A` above is a flag reading `N/A` in both stories, not a gate anyone forgot** — the
distinction `code/docs/GATE-REPORTING.md` requires. Eleven of the thirteen flags are `N/A` in
both members; `Security` and `QA` are live, and `Backend` and `Frontend` are among the eleven,
which is why the phase breakdown below is mostly empty. Each skipped gate is recorded with its
reason rather than omitted.

**This is the first sprint plan whose Security row is not `N/A`, and the first in which two
stories contribute to it.** `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` held that distinction for
US005 alone from 05/09/2026 to 07/09/2026 and recorded, when the story left, that the plan
inheriting the two-artefact row would be this one. The four artefacts' `Status` fields are quoted
verbatim above: US005's pair read `Signed off`, US006's pair read `Reviewed`. The record treats
both gates as closed — US006's on 05/09/2026 with eighteen findings and no CRITICAL or HIGH — and
this plan mirrors the record; the word each artefact carries is reported as found, not upgraded.

**Two of US005's gate artefacts carry a `Sprint` field naming a sprint the story has since left.**
Its QA plan reads "SPRINT-03 — retry doctrine gets its single owner" and its assessment the
same; both were written on 05/09/2026 when US005 was a SPRINT-03 member. Neither is this plan's to
edit — the gaps, scenarios and constraints in each are properties of the story, not of the sprint
that carries it — and `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` set the precedent for leaving such
a field alone on 07/09/2026. US006's two carry "SPRINT-04" and agree with this plan.

---

## Stories

### Must

| ID    | Title                                                                                        | Phases touched               | SP  | Story plan                                                             | Git branch                          |
| ----- | -------------------------------------------------------------------------------------------- | ---------------------------- | --- | ---------------------------------------------------------------------- | ----------------------------------- |
| US005 | Exactly one layer decides to retry, and every budget says how long it may take               | Docs only — no code lane     | 5   | `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` | `us005/retry-ownership-and-budgets` |
| US006 | The destructive dev scripts read the deployment posture, and refuse to run above development | Script + docs — no code lane | 8   | `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`               | `us006/posture-guard`               |

<!-- 08/09/2026, `17-story-plans` Step 10 for US006: the US006 row's Story plan cell read
     "_none yet — `17-story-plans` has not run for US006; `07-` reserved_" and its Git branch cell
     "_not yet set — fixed by its story plan's `Branch` row_". The plan exists under the reserved
     name, and its `| Branch |` row reads `us006/posture-guard` — taken from the plan, not
     invented here, as the US005 cells were. -->

**Total: 13 SP against a capacity of 11 — at the grace ceiling, all `Must`, and CLOSED to further
admission.** Rows are in build order, US005 then US006, settled 07/09/2026. The figure is settled,
not contingent: nothing carries into this record, and `../03-SPRINTS/SPRINT-04.md` -> _Notes_
carries the reasoning this plan mirrors rather than restates.

**The grace was taken deliberately, and the record says it is not quite the case grace is for.**
`project-management/docs/planning/CADENCE.md` -> _Sprint capacity — the trigger_ owns both figures
as generation-time answers — `SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`, rendered into its table
per project; in this template repository the table is unrendered, and the 11 and 13 every record
here uses are the defaults `copier.yml` gives those two answers — and reserves grace for one <!-- doc-references: template-only -->
situation, a story that would otherwise split badly. US005 is not being split; it overshoots by 2
SP whole. The alternative was a SPRINT-05 holding US006 alone at 8 / 11 — a single-member
all-`Must` sprint, the shape SPRINT-03 called its one real weakness on opening — and
<%DEVELOPER_NAME%> chose the grace over that on 07/09/2026. One sprint of four at grace by plan is
not the habitual case CADENCE warns about; the check on that reading is the one CADENCE itself
names, revisiting both figures after two sprints against measured velocity.

**Neither member can take a demotion, and the all-`Must` weakness is accepted rather than
repaired.** `project-management/docs/planning/SPRINTS.md` warns that a plan where everything is
`Must` has no give and the first surprise breaks it. This is the first sprint whose `Must` tier
alone exceeds capacity — 13 SP committed, no stretch tier, no headroom to admit one — and the
reading `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` gave its own grace on 02/09/2026, that it
"covers the ceiling, not the commitment", does not transfer: here the commitment **is** 13. US005
cannot slip without stalling three slices on its map; US006 is the guard itself, and a sprint that
ships half of a fail-closed control ships nothing. What is true and is not a repair: the two share
no file and neither blocks the other, so an overrun in one does not stall the other — but the
sprint still needs both. Recorded plainly because the record records it plainly.

### Should

_None. The sprint is closed at grace, and the repair SPRINT-03 used — admitting a `Should` — is
foreclosed by the closure._

### Could

_None._

### Won't (this sprint)

- **`../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-02`** — the seed presence gate. It shares
  no file with US006, widening US006 to carry it was declined at slice selection for want of a
  shared seam, and it is not cut into a story. **This record is closed to it regardless**, at the
  hard ceiling; when it is cut it takes a later sprint.
- **`../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` slices `S-04`, `S-05` and `S-06`** — the
  example-repair sweep, the retry-discipline gate whose claims row pins this doctrine's wording,
  and the live-code fixes. All three block on US005 and none is yet cut. Blocked, not deferred.
- **Slices `S-03` and `S-09` on the same map** — the idempotency half of the same rule, and the
  outbound timeout register split out of `S-02` at story creation. Both run beside US005 and
  neither blocks it (`AC-GAP-11` of US005's QA plan named `S-03` as a runs-beside dependency on
  05/09/2026). Out because they are not cut into stories, not because they wait.
- **US003's reserved carry** — it does not reach this record. Since 07/09/2026 US003 is
  SPRINT-02's stretch tier with its 5 SP carry reserved into SPRINT-03, one sprint earlier than
  before; the clause that reserves it lives in `../03-SPRINTS/SPRINT-02.md` -> _Definition of
  Done_. If it somehow arrived here anyway, 13 / 11 would become 18 / 11 — over grace — which the
  record refuses on arithmetic before it is argued.
- **A SPRINT-05** — declined on 07/09/2026 in favour of the grace above. No fifth record is
  created, and none is implied by this plan.

---

## Build order — US005 then US006, behind SPRINT-01, SPRINT-02 and SPRINT-03

**This plan takes execution order `04`, and the number was derived rather than copied.** One
member has a blocker and one has none, and the blocker sits in the first sprint of the sequence:

| Member | Blocked by                                                                                        | In        | Built at |
| ------ | ------------------------------------------------------------------------------------------------- | --------- | -------- |
| US005  | US001, for content — its four rules are stated inside a family US001 creates                      | SPRINT-01 | `01`     |
| US006  | Nothing — `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` records `Frontier open: 0 · Blocking open: 0` | —         | —        |

The build order settled 07/09/2026 runs SPRINT-01 (US007 then US001), SPRINT-02 (US002 then
US003), SPRINT-03 (US004), then this sprint (US005 then US006) — number order throughout — so
honouring the dependency chain and honouring the sprint number give the same answer. **Every
blocker of every member sits in an earlier-numbered sprint**, which is what
`../03-SPRINTS/SPRINT-04.md` -> _Notes_ said the exec-order segment would rest on, and it does.
A reader who finds `04` on both segments should know it was checked rather than assumed.

**US005 waits on US001 absolutely, and the wait lengthened on 07/09/2026.** Its four rules are
stated _inside_ "code/docs/reliability/", and that directory exists in no branch and no commit
(re-verified 08/09/2026). There is no partial start: the family is the target. US001 is
SPRINT-01's second story behind US007, so US005 sits three sprints behind its blocker rather than
the two it sat behind as a SPRINT-03 member. `../02-STORIES/US005.md` -> _Dependencies_ states the
block and the map records it directly: `S-01` gates `S-02`, because `S-02` writes into whatever
the owner names.

**Within the sprint the order is a decision, not a derivation.** The two members share no file —
US005 writes retry doctrine into the reliability family and repairs six existing guides plus
`code/docs/NEGATIVE-SPACE.md` and its own map; US006 writes a new `_lib/` helper, six scripts, one
CI workflow line, the `_lib/` pair, `how-to/src/DEPLOYMENT-POSTURE.md`, `how-to/docs/CLI-TOOLING.md`,
five call-site documents and its own map — and neither blocks the other. US005 first is the record's
call of 07/09/2026 about which outcome the sprint reaches first, taken there and mirrored here.
Nothing fails if the order is reversed once US005's blocker clears; until it clears, US006 is the
only member that can start, and the order in practice may well be US006 first.

**Three cross-sprint touch-points are ordered rather than blocked, and all three run from an
earlier sprint into this one.**

- **US004's repair of the citation gate (SPRINT-03).** Both members' `doc-references.sh` checks
  are written against two regimes depending on whether US004 has landed — a plain pass on a clean
  tree once it has, a diff against each member's own recorded baseline until then. SPRINT-03 is
  built before this sprint, so the plain-pass branch is the expected one; neither member blocks on
  it, and the record names both branches for both. See _Gate honesty_.
- **US002's headroom (SPRINT-02).** US002 shrinks `code/src/scripts/audits/CONTEXT.md` from 298 to
  230 counted lines. US006 leaves that file unchanged — hosting the guard's proof in a new
  `audits/` gate would have cost three counted lines in it, and the proof went to
  `database/migrate.sh --self-test` instead — so the edge is a fact worth knowing, not a constraint
  on this sprint.
- **US003's guide (SPRINT-02).** Neither member writes into "code/docs/ABSENCE.md". US006's own
  Dependencies record the non-collision; nothing here waits on it.

**The `build order 1` on US005's story-plan header is a recommendation, not a constraint**, on the
precedent `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` set for saying so. That plan's `| Sprint |`
row reads "SPRINT-04 · Wave 1 · build order 1", repointed by `17-story-plans` on 07/09/2026 —
first of {US005, US006} now, where it was first of {US005, US003} — and the wave number is the
story's position in its map's cutting order, which does not move with the sprint. US006's plan,
written 08/09/2026, takes build order 2 — its `| Sprint |` row reads "SPRINT-04 · Wave 1 · build
order 2", and its own header comment derives the `07-` prefix from the same backlog order.

<!-- 08/09/2026, later the same day: the closing sentence above read "US006's plan, when written,
     takes build order 2." until `17-story-plans` wrote the plan and Step 10 repointed this file. -->

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. Both plans exist.
US005's was written 05/09/2026 and repointed 07/09/2026; US006's was written 08/09/2026 by
`17-story-plans`, taking the number `07-` that had been reserved for it that morning, and this
table was repointed at it the same day by that workflow's Step 10.

| Story | Story plan (`../17-STORY-PLANS/`)                                      | Status      |
| ----- | ---------------------------------------------------------------------- | ----------- |
| US005 | `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` | Not started |
| US006 | `../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`               | Not started |

<!-- 08/09/2026 — THE STATUS COLUMN. US005's cell reads "Not started", and the value is
     KNOWINGLY FALSE: it is a value in no status set anywhere in this repository, and the plan it
     points at carries `Blocked` in its own `| Status |` header row. It is written this way BY
     DESIGN, on the position ../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md took on 07/09/2026 and
     ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md was reverted to on 08/09/2026 — both re-read before
     this plan was written, and ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md too, which reads
     `Open`/`Open` because it mirrored each plan's own field verbatim from the day it was written
     and never held "Not started". Correcting the value is ../02-STORIES/US007.md Scenario 8's OWN
     ACCEPTANCE CRITERION: US007 is scheduled in SPRINT-01, it is the story that settles which
     values this column may hold, and a new plan does not pre-empt a scheduled story's acceptance
     criterion any more than a re-plan does. The template's legend for this column,
     {Draft / Ready / In Progress / Done}, is the fourth vocabulary Scenario 8 names, and it is
     not used here either.

     THIS PLAN ADDS TO THE POPULATION SCENARIO 8 COUNTS, and it is flagged here so the addition is
     not silent. US007 re-counted that population on 08/09/2026 as THREE cells — US001's row in
     ../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md, and the US002 and US003 rows in
     ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md. This plan's US005 row is a FOURTH. The US006 row adds
     none today, because there is no plan for it to mirror and it follows the no-file convention
     01-SPRINT-PLAN-01 set for US007; it joins the population if `17-story-plans` writes US006's
     plan before US007 ships and the row then takes the same value. The story owner re-counts
     before the edit rather than inheriting a count — Scenario 8 already says so — and a silent
     addition is how that criterion goes stale. ../02-STORIES/US007.md is not edited by this run. -->

<!-- 08/09/2026, `17-story-plans` Step 10 for US006 — THE RESERVATION TAKEN UP. The section's
     opening paragraph read "US005's plan exists; US006's does not — `17-story-plans` has not run
     for it, and it is a prerequisite of implementation this plan cannot supply. What US006 has is
     a reserved **number**, `07-`, held for the plan when it is written; the row below records
     the reservation and not a file." The US006 row read, verbatim: "_no file —
     "07-STORY-PLAN-US006-POSTURE-GUARD.md" is the reserved name, its descriptor matching the
     story's QA plan as every existing pair does; the plan does not exist (re-checked
     08/09/2026); written by `17-story-plans`, which has its own gate_" with Status
     "_no plan to mirror_". The plan now exists under exactly that name and the row points at it.

     THE STATUS CELL reads "Not started" BY DESIGN, as the comment above defines the column: the
     US005 cell's value, knowingly in no status set, held pending ../02-STORIES/US007.md
     Scenario 8. The plan's own `| Status |` header reads `Open`, and that value is NOT mirrored
     here, on the same reasoning the US005 row does not mirror its plan's `Blocked`. The
     condition the comment above named — "it joins the population if `17-story-plans` writes
     US006's plan before US007 ships and the row then takes the same value" — has been met: this
     row is now a FIFTH cell in the population Scenario 8 counts (US001 in 01-SPRINT-PLAN-01,
     US002 and US003 in 02-SPRINT-PLAN-02, US005 and US006 here). Flagged so the addition is not
     silent. ../02-STORIES/US007.md is NOT edited by this pass — a concurrent run owns it — and
     the story owner re-counts before the edit, as Scenario 8 already says. -->

**US005's plan carries `Blocked`, and that is the truthful value.** `../17-STORY-PLANS/CLAUDE.md`
makes a plan marked anything other than `Blocked` an assertion that its blockers are cleared, and
the parallel-worktree DAG reads it. US005's target directory exists in no branch and no commit, so
its plan is the first in this repository to carry `Blocked`, and `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`
recorded on 07/09/2026 that the sprint plan which would index that row was this one. US006's
plan, when written, has no upstream and will not carry `Blocked` unless something changes.
Written later on 08/09/2026, it carries `Open`, and its own header blockquote states why that is not
drift from US005's `Blocked`.

**Three rows on US005's plan agree with this plan, and none is owed.** Its `| Sprint |` row reads
"SPRINT-04 · Wave 1 · build order 1" and its `| Branch |` row reads
`us005/retry-ownership-and-budgets` — both taken from the plan, not invented here. Its
`Sprint plan` row under _Reference Documents (code/docs gate map)_ now names this file.
<!-- That row read "None yet" — "04-SPRINT-PLAN-04.md is not written as of 08/09/2026;
     ../03-SPRINTS/SPRINT-04.md is authoritative until 16-sprint-plans runs for SPRINT-04" — and
     this paragraph opened "Two rows on US005's plan agree with this plan, and one is owed",
     naming the repoint as "the one debt this run creates rather than pays". Both were written
     while this file was being authored and were true for the minutes between. The repoint landed
     later the same day, so the debt is paid and the sentence describing it as outstanding would
     have sent a reader to a correct file looking for a defect — the failure mode
     ../03-SPRINTS/SPRINT-01.md -> _Notes_ records from the 07/09/2026 cascade. Superseded text
     kept above rather than deleted. -->

**There is no Plans Index row for either, and that is a decision rather than an omission.** The
index file eight earlier artefacts once cited has never existed; `../17-STORY-PLANS/CONTEXT.md` ->
_The plans index_ records its absence as a decision, and the folder-level index is deferred to the
register-index work charted in `../01-FEATURE-MAPS/`. **This table is where a story plan is indexed
against its sprint.** A reader is not told to add a row to any index file, because there is none.

<!-- 08/09/2026 — THE STORY-PLAN PREFIX. The plans in ../17-STORY-PLANS/ carry an
     `<exec-order>-` prefix as of this date: the story's position in the settled build order
     ACROSS THE WHOLE BACKLOG — US007 `01`, US001 `02`, US002 `03`, US003 `04`, US004 `05`,
     US005 `06`, US006 `07` — RENUMBERED whenever build order changes. It is neither a sprint
     number nor a per-sprint counter, which is why this sprint's two members read `06-` and the
     reserved `07-` rather than `01-` and `02-`: sixth and seventh of seven.

     THAT IS THE OPPOSITE OF THE RULE GOVERNING THIS FILE'S OWN NAME. ./CLAUDE.md says a sprint
     plan is `<exec-order>-SPRINT-PLAN-<sprint-number>.md` and that a mismatch between the two
     segments is deliberate and must NOT be "corrected" — two numbers, and the PAIR carries the
     meaning. A story plan carries ONE, so its prefix must track build order or it says nothing.
     Do not read the sprint-plan guardrail across to ../17-STORY-PLANS/; that folder's CLAUDE.md
     owns its rule. Both numbers of this file's name read `04` for the reason _Build order_
     gives, and that agreement says something precise by being checked. -->

---

## Phase Breakdown

**Neither story enters a code lane.** The four-phase backend -> API -> frontend -> PR sequence in
`project-management/docs/planning/SPRINTS.md` maps stories by the layers they touch, and these two
touch none of them. The phases are recorded as `N/A` with a reason rather than deleted, per
`code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**N/A** — no model, service, migration or business logic. Both stories read `Backend: N/A`.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema, and no MCP tool. Both read `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. Both read `Frontend: N/A`.

### The lane these stories actually run in

| Story | Deliverable                                                                                                                                                                                                                                            | Proven by                                                                                                                         |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| US005 | Four rules into the reliability family, one budget table with a derived worst-case column, the breaker deferral, two pointer repairs, four budget contradictions repaired across three guides                                                          | Three documentation gates, a hand recomputation of the worst-case column, and a human read-across of six guides                   |
| US006 | One `_lib/` helper with a two-mode entry point, six callers wired, one CI workflow line, the `_lib/` pair, `how-to/src/DEPLOYMENT-POSTURE.md` and `how-to/docs/CLI-TOOLING.md`, five call-site documents and its map's one surviving divergence re-cut | `database/migrate.sh --self-test` over twenty-one fixture cases with the stack down, plus the same proof-case list walked by hand |

**This sprint ships one executable proof and one body of prose, and the manual checks are
load-bearing for both.** US006's `--self-test` is the only automated check the sprint ships, and
it is dispatched ahead of that script's command validator and its `container_running` check so it
runs with the stack down. US005 ships no executable surface at all — it is verified by gates that
read Markdown plus checks only a person can do, the hand recomputation and the read-across — which
is why the manual rows in `../03-SPRINTS/SPRINT-04.md` -> _Tasks_ are not ceremonial.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, US005 then US006, each behind its own gate — US005's behind US001 landing.
`22-implementation-documentation` runs between the lane above and this phase and is a merge gate:
it writes each story's test-status and manual-testing records under `../18-TESTS/` — US005's
baseline, inventory, arithmetic strings and read-across; US006's twenty-one observed exit codes and
messages, and the ShellCheck run recorded as run or as not run — and it owns the two register
writes this sprint produces: the `DEFERRED.md` entry for US005's unenforced window, naming slice
`S-05` as owner and the first client-wiring story as its deadline, and the `GAPS.md` closure of the
31/08/2026 posture entry `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-01` claims.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story plan and the spec it cites.

### GDPR (`../09-GDPR/`)

**N/A** — both stories read `GDPR: N/A`. No personal data is read, written or logged: US005 ships
prose, and US006's guard reads the answers file, prints the posture, and prints nothing else from
it.

### Security (`../10-SECURITY/`)

**Live, for both members — the first sprint plan of which that is true, and the first where two
stories contribute.** The sprint's Security union names nine subjects: US005's four (retry
amplification, untrusted `Retry-After`, duplicate execution, attempt-log leakage) and US006's five
(fail-open carrier read, template stand-down, control removal, unrecoverable carrier, CI standing
override). `../03-SPRINTS/SPRINT-04.md` -> FLAGS carries the recomputation of 07/09/2026.

**US005 — twelve findings across five of the six STRIDE categories, eleven `INFO` and one `LOW`.**
Elevation of privilege is recorded as considered-and-not-applicable. Nothing is CRITICAL or HIGH,
so nothing blocks this plan and no record is opened under `../10-SECURITY/VULNERABILITIES/PLANNING/`
— a decision with its reason, never an audit that found nothing: the escalation rule is written
against exploitability and there is no retry in this tree to exploit. Three properties bind the
sprint, and the **eleven** developer constraints behind them are Section 7 of the assessment:

- **The severities expire.** Every `INFO` is a fact about a tree in which nothing outbound retries.
  Read them **with** the promotion-trigger table in the threat model's Section 3a: **three** rows
  are design-state `HIGH` — TM-01, TM-02 and TM-04. The assessment's own summary once said four by
  counting TM-02 twice and now carries the erratum; the record verified three on 08/09/2026, and
  three is the figure this plan carries.
- **The constraints are on wording, because wording is all US005 ships.** Each is checkable by
  reading the shipped guide, not by running anything.
- **TM-02 is the one finding live now**, because the rule ships without its gate — the
  retry-discipline gate is slice `S-05`'s and is not cut. `DEFERRED.md` records the unenforced
  window at ship.

**US006 — eighteen findings across all six STRIDE categories: 0 CRITICAL, 0 HIGH, 9 MEDIUM, 7 LOW,
2 INFO.** The dominant threat class has no attacker in it — the control mis-reading its own inputs,
or standing down when it should not. Nothing blocks this plan; nothing escalates. Four properties
bind the sprint:

- **The twelve developer constraints are `../02-STORIES/US006.md` Section 7.1 to 7.12** — eleven
  are Section 7 of the assessment, three of those amended and a twelfth added at `11-qa-checks` on
  05/09/2026. Where the story and the assessment disagree, the story is the corrected record and
  the assessment is the one to update — a Definition of Done row below.
- **The severities expire here too.** Five findings promote to HIGH at the first staging surface,
  and TM-02 and TM-08 at the first `copier update` run against a project above `development`;
  every MEDIUM is a fact about a tree with nothing deployed.
- **Four fail-open paths the story left open at cutting were closed at the QA gate**, each verified
  closed rather than assumed: the unconstrained override in a damaged carrier (AC-GAP-4), the
  unforwardable override across the `seed-dev.sh` shell-out (AC-GAP-3), the compose-target
  assertion with no criterion and no test (AC-GAP-11), and the CI override with no named owner
  (AC-GAP-13).
- **A tested function is not an enforced control** (TM-03): the guard call is asserted **present**
  in each of the six bound scripts by line-order comparison, ahead of the first destructive
  command.

**`AUDITS/` does not fire for either member**, and the skip is recorded rather than reported as a
pass: a code audit reads shipped code, and this sprint ships prose and one bash helper. It fires at
the first story that wires a client or a runtime surface.

### QA & SEO

Both QA plans are **Signed off** and neither carries an unresolved `AC-GAP` — US005 found fifteen
and resolved all fifteen on 05/09/2026 (`AC-GAP-1`, the boto3 clamp literal, was the one gap
`[OPEN]` during its session and closed the same day); US006 found twenty-two from 42 candidates
over five adversarial lenses plus a second pass over the gate's own output, and resolved all
twenty-two the same day. **Verified 08/09/2026 by reading both files:** every `[OPEN]` string that
survives in either sits inside a dated HTML comment describing a gap that closed on 05/09/2026;
neither carries a live one. SEO reads `N/A` on both stories.

**The sprint's QA union names two types, and it widened on 07/09/2026.** Unit — US006's guard
self-test over the enumerated proof-case list, the sprint's one automated proof. Manual — US005's
three documentation gates, `docs-length.sh`, `doc-references.sh` and `doctrine-drift.sh`, plus
US006's proof-case list walked by hand. Neither value narrowed: per
`project-management/docs/planning/SPRINTS.md` the union narrows only for a Part A / Part B split,
and US005 did not split, it moved. The three gates are written with `.sh` as US005's flag writes
them; US006's flag names no script, and neither story's own flag is rewritten to match the other.

### Decisions binding this sprint

| ADR                                                                       | Binds                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md`      | **One layer decides to repeat an operation; every layer beneath makes a single attempt; SDK transport retries are clamped off by default**, the delegation escape hatch being a row in the outbound timeout register. Corrected in place 05/09/2026: the worked clamp is `total_max_attempts: 1`, because in a `Config` object `max_attempts` excludes the initial request and the literal it first named permitted two attempts                                                                                                                                                                           |
| `../15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md`    | **`.copier-answers.yml` is the one carrier, read once per invocation from `$PROJECT_ROOT` resolved via `BASH_SOURCE`, and the guard fails closed on every state but two** — a rendered carrier naming `development`, or a template checkout proven by `copier.yml` at the root, tested only after the carrier holds no legal posture. No state defaults to `development`; a refusal exits `4`; a damaged carrier has no override, its recovery path is repair; the helper is a new `_lib/` return contract (0 permit, 4 refuse, never `exit`) <!-- doc-references: template-only -->                       |
| `../15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md` | **The override is `--force-posture <posture>`, space-separated, and must name the posture the project is at now**, so an invocation pasted from history dies when the posture rises. It buys nothing else: `--yes` is inert above `development`; the flag, not the terminal, carries the authorisation; it is not honoured where no posture can be read; it is forwarded verbatim across the `server.sh` -> `seed-dev.sh` shell-out; the CI literal has a named owner and `\|\| true` is dropped. **Erratum, dated:** the fail-closed set is eight, not seven — the unrecognised carrier value was omitted |
| `../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`     | Prose doctrine is verified by human read-across; `doctrine-drift.sh` is a regression guard only. Binds US005's four rules and the guard's contract alike — neither adds a claims row                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`     | A red `doc-references.sh` is read as a diff against a recorded baseline, never as a bare pass. **Contingent here**: it retires by its own terms when US004 lands and the gate goes green, and SPRINT-03 is built before this sprint — see _Gate honesty_                                                                                                                                                                                                                                                                                                                                                   |
| `../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`    | Check 2 of the citation gate reads the citing file's name; instance citations of PM artefacts by a PM artefact are exempt. It is the class the record names for the 24 findings US006's staged artefacts add, none of which this sprint owns                                                                                                                                                                                                                                                                                                                                                               |

The first three are the ADRs the two stories authored at their own gates. The three inherited are
the records `../03-SPRINTS/SPRINT-04.md` -> _Verification Checks_ cites for the gates both members
run, carried here on the precedent `../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md` set on 05/09/2026 for
inheriting a record a story's own list does not name.

**Two ADRs in that list were corrected in place rather than superseded, on the same terms, and a
reader should not mistake either for drift.** US005's clamp literal and the override record's
fail-closed count were both wrong when first written and both fixed on 05/09/2026 before either
record reached a commit, so no reader could have relied on them; each carries a dated erratum
rather than a supersession chain. **The vendor semantics behind the clamp are per-story depth** and
live in `../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` -> _The clamp's
correct form_, not here.

### Gate honesty — the constraint specific to this sprint

**One member ships a gate-shaped control and the other ships prose no gate can read**, so both
directions of `code/docs/GATE-REPORTING.md` apply. Six rules hold throughout:

- **`doc-references.sh` — which reading applies is contingent on US004, and both branches are
  named for both members.** If US004 has landed — the expected case — the gate exits `0` on a
  clean tree and is read as a plain pass for both. If it has not, each member is read as a diff
  against **its own** recorded baseline and never as a bare pass, and the two baselines are **not**
  comparable with each other because they were measured in different git-index states: US005's is
  56, measured 05/09/2026 with its artefacts untracked; US006's is 103 tree-wide and 9 on its own
  story at HEAD `c6df520` on a clean tree, 127 with its artefacts staged. A story worked here
  re-captures its own baseline immediately before its first edit, in the index state it will be
  measured in, and records that state beside the figure. No count of **today's** tree is measured
  or quoted here: the two figures above are the members' own recorded baselines, each carried with
  the index state it was taken in.
  <!-- The closing sentence read "No tree-wide count is quoted in this plan." until 08/09/2026,
       when it was corrected: the same bullet quotes US006's 103 tree-wide and 127 staged, so the
       two could not both be true. The point being made was that this plan measures nothing of its
       own, not that no tree-wide figure appears — the members' recorded baselines are quoted
       precisely so a reader can tell which index state each was taken in. Corrected here rather
       than in a section about reporting gates honestly being left self-contradictory. -->
- **A baseline is only comparable against a run in the same git-index state.** US005's QA plan
  measured a 24-finding swing on this tree between the same bytes untracked and tracked, every one
  a `[template-only citation]`. Do **not** silence the class with `doc-references: template-only`
  markers on either member's artefacts — the marker would be a lie the moment the files land.
- **`doctrine-drift.sh` is a regression guard for both members, never a duplicate detector.** It
  reads fenced code only. US005's doctrine is prose and the guard's contract is prose; neither adds
  a claims row. A green run says the registered claims are undisturbed and says **nothing** about
  retry doctrine or the posture rule appearing in two homes; it is never reported as though it had.
- **ShellCheck is US006's own expectation, and no project script carries it.** `lint.sh`'s legs
  are ruff, markdownlint-cli2, ESLint and clippy (`code/src/scripts/syntax/CONTEXT.md`), and as of
  08/09/2026 no script under `code/src/scripts/`, no CI job and no lefthook entry runs ShellCheck —
  only `# shellcheck source=` directives exist. Run by hand over the new helper and all six
  callers, with the directive resolving in each, and recorded in US006's manual-testing record as
  run or as not run — never as a `lint.sh` pass. `syntax/check.sh` is **N/A**: it type-checks
  Python, TypeScript and Rust and has no shell, YAML or Markdown leg.
- **No pre-change comparison is claimed for US006's fixtures.** There is no pre-change guard for a
  fixture to fail against, and the permitting cases proceed identically before and after the change
  — recorded because the criterion it replaces is one US004's plan legitimately carries
  (`QA-PLAN-US006-POSTURE-GUARD` AC-GAP-6). Refusing cases assert exit code **and** message prefix
  together; permitting cases assert completion at exit 0; the self-test carries a `trap` and writes
  outside a temporary directory nowhere.
- **`docs-length.sh` — two files to watch, and measured with the gate, never `wc -l`.**
  `code/docs/TASK-AUTHORING.md` sits at 266 and US005 edits it; `code/src/scripts/audits/CONTEXT.md`
  sits at 298 code lines as that gate measures them and US006 leaves it unchanged — US002 owns its
  headroom in SPRINT-02. No file created or edited this sprint enters the warn tier without a dated
  allowance.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-04.md` -> _Verification Checks_ and is not restated here.

- [ ] `bash code/src/scripts/database/migrate.sh --self-test` exits 0 **with the stack down** —
      US006's alone; one fixture case per entry in the enumerated proof-case list, cases 1 to 21,
      none omitted and none doubled up
- [ ] `doc-references.sh` — read per _Gate honesty_: a plain pass for both if US004 has landed, a
      diff against each member's own re-captured baseline if not, with the index state recorded
      beside every figure; every survivor named with the story that owns it
- [ ] `docs-length.sh` — `code/docs/TASK-AUTHORING.md` does not enter the warn tier without a
      dated allowance; `code/src/scripts/audits/CONTEXT.md` is not grown
- [ ] `docs-pairing.sh` passes — US006 edits both halves of the `code/src/scripts/_lib/` pair,
      adding the helper to `CONTEXT.md` and the caller contract to `CLAUDE.md`; US005 creates no
      directory, the reliability family's pair being US001's deliverable. No new pair is owed
- [ ] `doctrine-drift.sh` — regression only, for both members; never reported as having checked
      prose
- [ ] `syntax/lint.sh` passes over what it reads — the Markdown leg over US005's guides and
      US006's three Markdown files; ShellCheck is recorded separately, per _Gate honesty_
- [ ] `routing-skills.sh` — **N/A**, neither member adds routing frontmatter
- [ ] `syntax/check.sh` — **N/A**, no Python, TypeScript or Rust source is added or edited
- [ ] `migrate.sh check` — **N/A**, no story here touches a model
- [ ] `tests/all.sh --coverage` — **N/A**, no story here ships a Python path; coverage floors have
      nothing to measure
- [ ] Template, django-component and HTMX-partial tests — **N/A**, no template or component added
- [ ] US005's retry-statement inventory captured **before** any edit with US001's landing state
      recorded beside it, and balanced at close; the derived worst-case column recomputed by hand
      on a default row **and** the webhook override row, both arithmetic strings written out; the
      read-across across six guides finds no budget stated in two homes and no guide stating the
      inverse of the owner rule
- [ ] US006's ten carrier states walked by hand against a scratch answers file; the template case
      walked in this repository across all six scripts with the answers file confirmed unmodified;
      `up --seed --force-posture <live posture>` walked end to end across the shell-out; the
      refusal message read as an operator would read it, its suggested command pasted verbatim; the
      damaged-carrier refusal confirmed to suggest a repair and name no posture; both
      `server.sh down --volumes` paths walked at `development` with no added friction
- [ ] A tester other than the author has signed each walk-through off
- [ ] No secrets, debug flags or hardcoded IDs introduced — US005 ships prose; US006's guard
      prints the posture and nothing else from the answers file (TM-15)
- [ ] All security acceptance criteria signed off — **applies to both members**
- [ ] GDPR, Logging and SEO criteria — **N/A**, each flag reads `N/A`
- [ ] Cross-browser, responsive and accessibility (WCAG 2.2 AA) walk-throughs — **N/A**, this
      sprint adds no page, component or interactive surface

---

## Sprint Definition of Done

- [ ] **Every `Must` story is Completed — US005 and US006, both.** Each story plan's own DoD
      complete and verified by a reviewer, US006's once `17-story-plans` has written it. There is
      no `Should` tier, so a slip in either fails the sprint; that is the cost recorded under
      _Stories_, not a surprise
- [ ] **Nothing carries into this record, and nothing is expected to.** If US003 arrives anyway it
      is recorded in both records with its reason, and the 13 / 11 above becomes 18 / 11 — over
      grace — which is refused on arithmetic before it is argued
- [ ] All sprint-level verification checks passed
- [ ] **No open Critical or High security finding — applies**, for both members and for the first
      time in a sprint plan. Twelve closed at INFO/LOW for US005, eighteen at MEDIUM/LOW/INFO for
      US006; any finding whose promotion trigger fired during the sprint is re-assessed in
      `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at its present-state severity
- [ ] `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` Section 7
      updated to the amended twelve, so the security record and the story no longer disagree
- [ ] GDPR constraints implemented and verified — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] All QA scenarios passing per `../11-QA/` — US006's self-test and both manual walk-throughs
      signed off by a second tester; no `[OPEN]` gap remains in either member's QA plan
- [ ] Both stories' implementation records written by `22-implementation-documentation`;
      `DEFERRED.md` carries US005's unenforced-window entry naming `S-05`; `GAPS.md`'s 31/08/2026
      posture entry closed
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-04.md` `**Status:**` set to `Done`
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-04.md` (optional)

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story | Branch                              |
| ----- | ----------------------------------- |
| US005 | `us005/retry-ownership-and-budgets` |
| US006 | `us006/posture-guard`               |

<!-- 08/09/2026, `17-story-plans` Step 10 for US006: the US006 row read "_not yet set_ — fixed by
     the `Branch` row of US006's story plan when `17-story-plans` runs; not invented here". The
     plan's `| Branch |` row reads `us006/posture-guard` — a two-word descriptor, under the five-word limit —
     and the value is taken from it. -->

**Both branches are cut from `main`, and not yet**, on the reasoning
`../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` recorded on 02/09/2026. Every planning artefact these
stories depend on — the stories, this plan, the QA plans, the ADRs and the sprint record — is
uncommitted on `pm/story-creation`, and US006's story plan joined them there only on 08/09/2026,
so a branch cut from `main` today could not see any of it. The sequence is: every story completes
its planning workflows -> `pm/story-creation` is raised as a PR to `main` -> the `us###/` branches
are cut from `main` and the stories implemented. US005's branch additionally waits on US001 landing,
because the directory it writes into does not exist until then.

<!-- 08/09/2026, later the same day: the first sentence's closing clause read "and US006's own
     per-story loop has not reached `17-story-plans`" until that workflow ran for it. -->
