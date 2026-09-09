# SPRINT-PLAN-03 — The citation gate stops depending on the git index, and the PM tree becomes checkable

<!-- The title read "SPRINT-PLAN-03 — Retry doctrine gets its single owner, and absence gets one
     beside it" from 05/09/2026 until 07/09/2026, when US005 moved to SPRINT-04 and US003 to
     SPRINT-02 in the US007 re-plan. Neither deliverable it named is a member's now; the
     replacement is the title of US004, the sole member. -->

**Last Updated**: 08/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-03.md` · **Capacity:** 8 / 11 — 13 / 11 if US003's reserved carry lands · **Stories:** 1, plus one reservation

<!-- Line 4 read "**Capacity:** 5 SP Must + 5 SP Should = 10 / 11 · **Stories:** 2" from
     05/09/2026, and was superseded twice before this rewrite reached it. On 06/09/2026
     ../03-SPRINTS/SPRINT-03.md closed at that figure by decision — "10 / 11 SP — inside capacity,
     and CLOSED" — and this line never followed it; on 07/09/2026 the re-plan removed both members
     the figure counted, and the record now reads "8 / 11 SP — inside capacity, all-Must, and
     closed to admission, holding a reservation ... if it lands this sprint is 13 / 11 SP and at
     grace". The line above mirrors that record. -->

---

## Sprint Goal

> The citation gate gives one verdict on one sentence whichever side of the git index its file
> sits, and the project-management tree it could never read becomes checkable — so no story after
> this one carries a written baseline to subtract from a red run.

<!-- The goal read "Exactly one layer decides to repeat a failed operation and every budget says
     how long it may take, and every `return None` in the tree means one stated thing." from
     05/09/2026 until 07/09/2026. Its first half was US005's deliverable and its second US003's,
     and neither story is a member now. A goal naming a deliverable no member carries is drift —
     the rule ../03-SPRINTS/SPRINT-02.md's goal comment of 05/09/2026 records, and which
     02-SPRINT-PLAN-02.md applied to itself the same day — so it is rewritten, not trimmed. The
     replacement mirrors ../03-SPRINTS/SPRINT-03.md's goal of 07/09/2026, derived from the title
     and Client Summary of US004. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** US004 carries `DB: N/A` and `User Flow: N/A`. The authorities this sprint
> defers to are `code/docs/GATE-REPORTING.md` for how a gate's result is reported,
> `code/docs/FORWARD-VOICE.md` for what a document may promise about a tree it will be read in,
> `how-to/src/PROJECT-PATHS.md` as the register of what may be promised, and
> `code/docs/DOCUMENTATION-LENGTH.md` for what a documentation file may weigh. Where a story's
> wording and those guides differ, the guides win.
>
> **Every authority this sprint defers to exists today.** The one this plan said did not — the
> `code/docs/reliability/` family US005's four rules are stated inside, which US001 creates in
> SPRINT-01 — bound US005 alone and left with it on 07/09/2026. No member here waits on a home that
> has yet to be built.

<!-- The second paragraph read: "**One authority for this sprint does not exist yet.** US005's
     four rules are stated inside the `code/docs/reliability/` family, and that family is US001's
     deliverable in SPRINT-01. Until it lands there is no home to defer to — which is the whole of
     why this sprint's first member is blocked rather than merely sequenced." True from 05/09/2026
     until 07/09/2026, when US005 moved to SPRINT-04; the block it describes travelled with the
     story and is SPRINT-04's to state. -->

## Sprint Reference Documents

| Area               | Source                                                                                                              |
| ------------------ | ------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-03.md`                                                                                        |
| User stories       | `../02-STORIES/US004.md`                                                                                            |
| Feature maps       | `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`                                                             |
| Database           | **N/A** — US004 reads `DB: N/A`; no model, migration or RLS policy in scope                                         |
| User flows         | **N/A** — US004 reads `User Flow: N/A`; no user journey in scope                                                    |
| Brand & components | **N/A** — US004 reads `Brand: N/A` and `Components: N/A`; no rendered surface                                       |
| Wireframes         | **N/A** — US004 reads `Wireframes: N/A`; no screen                                                                  |
| GDPR               | **N/A** — US004 reads `GDPR: N/A`; no personal-data path                                                            |
| Security           | **N/A** — US004 reads `Security: N/A`; one bash script and Markdown, with no runtime, no principal and no data path |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — **Signed off**, nine gaps found, nine resolved       |
| SEO                | **N/A** — US004 reads `SEO: N/A`; no public page                                                                    |
| API design         | **N/A** — US004 reads `API: N/A`; no Django Ninja surface                                                           |
| Logging            | **N/A** — US004 reads `Logging: N/A`; no log line                                                                   |
| Decisions          | Five ADRs bind this sprint — two authored by US004, three inherited. Listed under _Sprint-wide Constraints_         |

<!-- Until 07/09/2026 the User stories row named US005 and US003; Feature maps named
     MAP-RETRY-AND-IDEMPOTENCY S-02 and MAP-ABSENCE S-01; Security named
     THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md and ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md
     ("both Signed off, US005's alone"); QA named both stories' plans; and Decisions read "Five
     ADRs bind this sprint — one authored by US005, four inherited". Every one of those values was
     a departed member's. US005's travelled to SPRINT-04's record and US003's to SPRINT-02's; the
     `N/A` cells that read "both stories" now read US004 alone. -->

**This is no longer the sprint plan whose Security row is not `N/A`.** From 05/09/2026 to
07/09/2026 it was the first such plan, because US005's gate ran in two halves — the STRIDE model
and the posture assessment that synthesises it — and both were listed here. They left with the
story. US004's security gate was entered at `02-story-creation` and read `N/A` at its story, which
is a decision with a reason and not an absent tool (`code/docs/GATE-REPORTING.md`). The plan that
inherits the two-artefact row is SPRINT-04's, and **`04-SPRINT-PLAN-04.md` now exists** — written
on 08/09/2026 by a `16-sprint-plans` run of its own, through its own gate, and its Security row
carries both of US005's artefacts.

<!-- The paragraph's last sentence read, from 07/09/2026 until 09/09/2026: "The plan that inherits
     the two-artefact row is SPRINT-04's, and **04-SPRINT-PLAN-04.md does not yet exist** —
     authoring it is a 16-sprint-plans run of its own, with its own gate." True when written on
     07/09/2026; falsified on 08/09/2026, when 16-sprint-plans wrote
     project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md, and left standing by the pass of
     that day, which edited this plan elsewhere and did not revisit the sentence. Corrected
     09/09/2026. The ownership point survives: the plan was authored by its own run, through its
     own gate, not by this one. -->

<!-- The paragraph read: "**This is the first sprint plan whose Security row is not `N/A`**, and
     the row names two artefacts rather than one because the security gate ran in two halves: the
     STRIDE model and the posture assessment that synthesises it. Both are US005's; US003
     contributes nothing to either." True from 05/09/2026 until 07/09/2026. -->

---

## Stories

### Must

| ID    | Title                                                                                 | Phases touched               | SP  | Story plan                                                         | Git branch                      |
| ----- | ------------------------------------------------------------------------------------- | ---------------------------- | --- | ------------------------------------------------------------------ | ------------------------------- |
| US004 | The citation gate stops depending on the git index, and the PM tree becomes checkable | Script + docs — no code lane | 8   | `../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` | `us004/citation-gate-git-index` |

**8 SP committed against a capacity of 11.**

**US004 cannot take a demotion.** It is the sprint's only member and its only blocking work:
slice `S-01` on `../01-FEATURE-MAPS/MAP-NAVIGATION.md` changes the same script's citation emit and
waits behind it, and it retires the baseline-diff regime every story in this backlog currently
carries. A slip here stalls the navigation map and keeps that workaround alive for every story
after it.

<!-- The Must row read US005 — "Exactly one layer decides to retry, and every budget says how long
     it may take", Docs only — no code lane, 5 SP, STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md,
     us005/retry-ownership-and-budgets — with "5 SP committed against a capacity of 11" and the
     paragraph: "**US005 cannot take a demotion.** It is the sprint's only blocking work: slices
     S-04, S-05 and S-06 on MAP-RETRY-AND-IDEMPOTENCY all wait behind it, and S-05's
     retry-discipline.sh claims row pins this doctrine's exact wording. A slip here stalls three
     slices, not one." True from 05/09/2026 until 07/09/2026, when US005 moved to SPRINT-04. -->

### Should

_None committed._ **US003's 5 SP `Should` carry is reserved into this plan from SPRINT-02**, and
this section holds that reservation rather than a member.

**US003 has now moved twice, and the reservation it carries has turned round.** SPRINT-02 → here
on 05/09/2026, as the `Should` give this sprint lacked; here → SPRINT-02 on 07/09/2026, as the
stretch tier behind US002 — because US007 has to precede US002, and the cascade that followed put
US004 here in US005's place. In SPRINT-02 it holds the shape it held here — `Should Have`, 5 SP,
its carry reserved to the next record — one sprint earlier, and the next record is now this one.
**The story is not split** (Q9 of the 07/09/2026 pass: a scheduling split, never a story split),
no new story number is cut, and its `Should` tier and its demotion of 02/09/2026 stand unchanged.

**The all-`Must` weakness this plan repaired on 05/09/2026 is back, and the reservation is its
contingent repair.** US004 alone is a single all-`Must` member — the shape
`project-management/docs/planning/SPRINTS.md` warns has no give, where the first surprise breaks
it. On 05/09/2026 the fix was to admit US003 as a `Should`; on 07/09/2026 US003 is committed one
sprint earlier and the fix is conditional. Two futures, both recorded now rather than discovered
later:

| If US003…              | This plan stands at                    | Reading                                                                                         |
| ---------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------- |
| completes in SPRINT-02 | **8 / 11 SP**, all `Must`              | Inside capacity. The weakness stands, and this plan has no other give it can honestly hold      |
| carries to SPRINT-03   | **13 / 11 SP** — 8 `Must` + 5 `Should` | **At grace**, and the weakness is repaired: the carry is give that can slip again if US004 runs |

**The second is the better sprint, and it is SPRINT-02's close to trigger, not this plan's call to
take.** `project-management/docs/planning/CADENCE.md` → _Sprint capacity — the trigger_ owns both
figures as generation-time answers — `SPRINT_CAPACITY_SP` and `SPRINT_GRACE_SP`, rendered into its
table per project; in this template repository the table is unrendered, and the 11 and 13 every
record here uses are the defaults `copier.yml` gives those two answers — and reserves grace for <!-- doc-references: template-only -->
one situation, a story that would otherwise split badly, adding that it "is not a routine
allowance". A carry-over is not that situation — but a carry arriving into a single-member sprint
buys a stretch tier rather than an overcommitment, because the `Must` tier stays at 8 either way.
**If US003 carries here, do not read the 13 as an overrun.** Whoever closes SPRINT-02 makes the
call and records it in both records and in `../02-STORIES/US003.md`.

<!-- Until 08/09/2026 the sentence read "`CADENCE.md` → _Sprint capacity_ owns both figures —
     capacity 11 SP, grace 13 SP". CADENCE.md's table gives the two figures as
     `SPRINT_CAPACITY_SP` / `SPRINT_GRACE_SP` tokens, not as numbers; the numbers are copier.yml's
     defaults for those answers (11 and 13), which `../03-SPRINTS/SPRINT-04.md` -> _Notes_ stated
     on 08/09/2026 and this plan mirrors the same day. The arithmetic is unaffected. -->

**This plan is closed to admission at one member, and what it holds is a reservation, not
headroom.** The 3 SP under capacity and the 2 SP of grace above it are together exactly US003's 5.
Admitting a further story would either spend the room the reservation needs or, with the carry
landed, take this sprint past grace — the position that refused US006 on 05/09/2026.

<!-- History, superseded 07/09/2026. This section held US003 as a member from 05/09/2026, with its
     row — "Absence gets an owning guide, born under 270 with every clause's tier stated", Docs
     only — no code lane, 5 SP, STORY-PLAN-US003-ABSENCE-GUIDE.md, us003/absence-guide — and three
     paragraphs, kept because they are the record of the decision that was taken:

     "**US003 arrives from SPRINT-02, and its `Should` tier travelled with it unchanged.** It was
     demoted at `16-sprint-plans` on 02/09/2026 because SPRINT-02 stood at 13 SP against a capacity
     of 11; it moved here on 05/09/2026 because SPRINT-03 had opened as a single all-`Must` member,
     which `project-management/docs/planning/SPRINTS.md` warns against — a plan with no give, where
     the first surprise breaks it. **One move, two problems solved:** SPRINT-02 returned to 8 / 11
     and this sprint gained the only give it could honestly have."

     "**There was no give available from inside the retry map.** `S-04`, `S-05` and `S-06` all
     block on US005 itself, and `S-03` and `S-09` are not yet cut into stories. US003 is give this
     sprint can actually drop: if US005 overruns, the `Should` slips and the sprint still succeeds."

     "**Its backlog priority is unchanged in substance.** US003 remains wave 0 of the absence map's
     cutting order with no upstream of its own; `Should` is a scheduling tier for this sprint, and
     it is `Should` rather than `Could` precisely because five slices wait on it."

     The third paragraph is still true of the story and is now SPRINT-02's to carry. -->

### Could

_None._

### Won't (this sprint)

- **`../01-FEATURE-MAPS/MAP-NAVIGATION.md` slice `S-01`** — the citation edge set stops being
  discarded. It changes the same script US004 edits and must not land first. Blocked by US004, not
  deferred.
- **`GAPS.md`'s 01/09/2026 entry** — the three shipped files still instructing the `CONTEXT.md`
  index row. Adjacent to US004's subject and owned by no slice on any map; explicitly out.
- **The `MAP-GATE-PARITY` question** — whether a gate means the same thing in a generated project.
  `../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` is one instance of it and
  claims none of its scope.
- **US005** — this plan's `Must` from 05/09/2026 until 07/09/2026, when it moved to
  `../03-SPRINTS/SPRINT-04.md` beside US006 in the US007 re-plan. Everything that waited on it —
  `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` slices `S-04`, `S-05` and `S-06` — and the two
  that run beside it, `S-03` and `S-09`, travelled with it. Recorded here as a `Won't` rather than
  left absent, because a story this plan carried must stay findable from it.
- **US003** — this plan's `Should` from 05/09/2026 until 07/09/2026, now committed to
  `../03-SPRINTS/SPRINT-02.md` as the stretch tier behind US002, with its carry reserved here (see
  _Should_). `../01-FEATURE-MAPS/MAP-ABSENCE.md` slices `S-02` to `S-06`, every one of which cites
  the guide it creates, went with it.
- **US006** — refused admission here on 05/09/2026, and the refusal stands on new arithmetic. Its
  8 SP would give **16 / 11** without the carry and **21 / 11** with it: over grace either way. It
  stays in SPRINT-04, now its **second** member behind US005 in build order, and
  `../02-STORIES/US006.md` Dependencies records exactly that — it opened the record as sole
  member on 05/09/2026 and has been its second member since 07/09/2026 — so the story,
  `../03-SPRINTS/SPRINT-03.md` and this plan agree.
- **US007** — the story `**Status:**` vocabulary gets one owner, `Must Have`, 5 SP, cut 07/09/2026.
  A note on `../03-SPRINTS/SPRINT-03.md` of 06/09/2026, never committed, routed it to SPRINT-04
  beside US006; the record superseded it the next day, and it was wrong on its main claim: **US007
  opens SPRINT-01**, first in the build order, because US002 builds `register-indexes.sh` and its
  status fixtures against whichever vocabulary is canonical on the day it ships. Its refusal here
  was right for the wrong reason and stands.

<!-- The US006 bullet's last sentence read "It stays in SPRINT-04, now beside US005, and
     `../02-STORIES/US006.md` Dependencies records SPRINT-04 as the sprint it opens" until
     08/09/2026. "Opens" was true of 05/09/2026 and false since the cascade, which put US005
     ahead of it: the story file was corrected to "second member, behind US005 in build order" on
     07/09/2026, `../03-SPRINTS/SPRINT-03.md` -> _Notes_ corrected its identical sentence on
     08/09/2026, and this mirror plan follows it the same day. -->

<!-- The Won't list read, from 05/09/2026 until 07/09/2026: the three retry-map slices S-04, S-05
     and S-06 ("the example-repair sweep, the retry-discipline.sh gate, and the live-code fixes.
     All three block on US005 and none is yet cut into a story. Blocked, not deferred."); S-09, the
     how-to/src/OUTBOUND-TIMEOUTS.md register split out of S-02 at story creation on 04/09/2026
     ("It runs beside US005 and blocks on nothing; it is out of this sprint because it is not cut
     into a story, not because it waits."); S-03, idempotency doctrine, named as a runs-beside
     dependency at US005's QA gate (AC-GAP-11); MAP-ABSENCE S-02 to S-06 ("every one cites the
     guide US003 creates, and S-06 names the dependency in its own acceptance"); and US006, with the
     dated counterfactual: "at the moment the question was live this sprint stood at 5 SP all-Must,
     and US006's 8 SP would have taken it to 13 — its grace ceiling. US003 was admitted the same
     day, so against the sprint as it now stands US006 would give 18 SP (13 Must, 5 Should) — over
     grace, not at it. Either way grace is for a story that would split badly, not for one that
     arrives while there is room." The retry-map bullets travelled with US005 and the absence bullet
     with US003; the US006 figures were theirs and are re-measured in the bullet above. -->

---

## Build order — SPRINT-01, then SPRINT-02, then this sprint

**This plan takes execution order `03`, and it is derived rather than assumed — for the second
time.** On 05/09/2026 it was derived from two blockers in two earlier sprints, and the warning
`../03-SPRINTS/SPRINT-03.md` then carried — that the exec-order segment "may therefore not read
`03`" — did not materialise. On 07/09/2026 the derivation is simpler and the answer is the same:

| Member | Blocked by                                                                 | In  | Built at |
| ------ | -------------------------------------------------------------------------- | --- | -------- |
| US004  | Nothing — `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` has an empty frontier | —   | `03`     |

The build order settled 07/09/2026 runs SPRINT-01 (US007 then US001), SPRINT-02 (US002 then
US003), this sprint (US004), SPRINT-04 (US005 then US006) — number order throughout — so honouring
the dependency chain and honouring the sprint number give the same answer. **US004's place third
is the re-plan's arithmetic, not a blocker**, stated so that nobody goes looking for one. A reader
who finds `03` on both segments should know it was checked rather than copied.

<!-- The table read two rows — US005, blocked by US001 for content, in SPRINT-01, built at 01; and
     US003, blocked by US004 for ordering, in SPRINT-02, built at 02 — under the paragraph: "Both
     blockers sit in sprints already scheduled ahead of this one, so honouring the dependency
     chain and honouring the sprint number give the same answer. The mismatch SPRINT-03 warned
     about did not materialise, and that is worth recording." True from 05/09/2026 until
     07/09/2026; neither row's story is a member now. -->

**The ordering this plan carried is reversed, and US004's own story provided for it at cutting.**
The US004-before-US003 constraint — settled at `03-sprint-planning` on 02/09/2026 as intra-sprint,
carried across US003's move here on 05/09/2026 as cross-sprint — now runs the other way: US003 is
worked in SPRINT-02, ahead of this sprint, and US004 lands second. `../02-STORIES/US004.md`
Dependencies, _Collision with US003, named at cutting_, admits either order: if US003 lands first,
the three `code/docs/ABSENCE.md` forward references resolve on their own, and whichever lands
second reads the other's disposition rather than re-deriving it. US004 therefore reads US003's —
the guide exists, those three findings are gone, and the "six survivors known at cutting" are
re-measured rather than inherited, which US004's own acceptance already requires.

**Two touch-points are ordered rather than blocked, and both now run SPRINT-02 → SPRINT-03.**

- **US002's headroom.** US002 shrinks `code/src/scripts/audits/CONTEXT.md` from **298 to 230
  counted lines**, and US004 replaces text **within** that file's `doc-references.sh` row against a
  300-line hard limit — `AC-GAP-9` of `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.
  `02-SPRINT-PLAN-02.md` argued this on 05/09/2026 as "SPRINT-01 before SPRINT-02"; it is now
  "SPRINT-02 before SPRINT-03", the same direction one sprint later on each side. If US002 has
  landed, the register carries the headroom it built and the ordinary ratchet applies; if it has
  not, the never-add-a-line constraint stands as written.
- **US003's guide.** Named above. The three `code/docs/ABSENCE.md` survivors clear when the guide
  lands; US004 shares no file with US003 and builds correctly in either order.

**Within this sprint there is no order left to set — US004 is the whole of it.** If the carry
lands, the intra-sprint order is **US004 then US003** — the original order of 02/09/2026 — and that
order is what revives US003's revision pass: the Gherkin scenario _"The citation gate is read
against a recorded baseline, never as a bare pass"_, the QA task recording before/after finding
counts, and `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` are all written
against a defect US004 will by then have removed, and the scenario is read as a plain pass. **That
pass is not owed in SPRINT-02**, where US003 is worked under exactly the regime its scenario was
written for; it is owed here in the carry case only, and it belongs to whoever picks US003 up, not
to this plan.

**The `build order N` on the story-plan headers is a recommendation, not a constraint**, on the
precedent `01-SPRINT-PLAN-01.md` sets for saying so. Both headers were repointed by
`17-story-plans` on 07/09/2026: `../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`'s
`| Sprint |` row reads "SPRINT-03 · Wave 1 · build order 1" — first of one now, where it was first
of {US004, US003} — and `../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md`'s `| Sprint |` row
reads "SPRINT-02 · Wave 0 · build order 2", the same figure as at authoring with its meaning
reversed:
behind US002 as the stretch tier, not behind US004. In the carry case the figure fits again in its
original sense — second, behind US004. Wave numbers are positions in each map's cutting order and
do not move with the sprint. Nothing fails if the number is read either way — it was never a
constraint.

<!-- The passage this replaces read, from 05/09/2026 until 07/09/2026:

     "**The two blocks are different in kind, and only one of them is real content.**
     - **US005 waits on US001 absolutely.** Its four rules are stated _inside_
       `code/docs/reliability/`, and that directory exists in no branch and no commit. There is no
       partial start: the family is the target. US001 is SPRINT-01's second story by
       **recommendation, not dependency** — that plan states the two are independent, share no
       file, and that nothing fails if the order is reversed — so US005 waits on one story, behind
       two if SPRINT-01's recommended order is honoured.
     - **US003 waits on US004 only for order.** Its acceptance reads `doc-references.sh` as a diff
       against a recorded baseline, and US004 removes the defect that baseline exists for. Building
       US004 first means US003 is worked against a gate that simply passes. Settled at
       `03-sprint-planning` on 02/09/2026, and **it survived the story's move here** as a
       cross-sprint constraint rather than an intra-sprint one.
     **Within this sprint the two members are free.** They share no file — US005 writes retry
     doctrine into `code/docs/reliability/`, US003 creates `code/docs/ABSENCE.md` — and neither
     blocks the other. Work them in either order once their respective blockers clear.
     **The `build order 1` / `build order 2` on the two story-plan headers is a recommendation, not
     a constraint** — it records which blocker clears first (US001 at execution order `01`, US004
     at `02`), on the precedent `01-SPRINT-PLAN-01.md` sets for saying so explicitly. Nothing fails
     if the order is reversed.
     **US003 needs a revision pass before it is worked, and it is not this plan's to make.** Three
     parts of it are written against a defect that will be gone by the time anyone opens it: [the
     scenario, the QA task and the ADR named above]. That ADR **retires by its own terms** when
     US004 lands rather than being superseded. The correction belongs to whoever picks US003 up;
     `../03-SPRINTS/SPRINT-03.md` → _Dependencies_ carries it, and
     '../17-STORY-PLANS/STORY-PLAN-US003-ABSENCE-GUIDE.md' already plans against the corrected
     state."

     US005's block on US001 travelled to SPRINT-04 with the story. US003's ordering reversed and
     its revision pass became conditional, both as stated above. The SPRINT-01 order the first
     bullet cites — US001 second by recommendation — is itself superseded: since 07/09/2026
     SPRINT-01 runs US007 then US001. -->

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here.

| Story                  | Story plan (`../17-STORY-PLANS/`)                                  | Status |
| ---------------------- | ------------------------------------------------------------------ | ------ |
| US004                  | `../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` | `Open` |
| US003 — reserved carry | `../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md`           | `Open` |

**The Status column mirrors each plan's own `Status` field, verbatim** — the value in the named
file's `| Status |` header row, which carries the story-status set and nothing else. That has been
this plan's own convention since it was written on 05/09/2026, before US007 existed, and the
re-plan of 07/09/2026 kept it rather than chose it: the US004 row arrived carrying its plan's
`Open` as the US005 row had carried its plan's `Blocked`. `../02-STORIES/US007.md` Scenario 8 names
this convention as the one it will ratify onto every plan and onto the template's legend — a
ratification that is US007's to make when it ships, not this plan's to claim in advance
(08/09/2026). The same rule is why `01-SPRINT-PLAN-01.md` and `02-SPRINT-PLAN-02.md` leave their
`Not started` cells for that story to change: a re-plan that moves membership does not pre-empt a
scheduled story's own acceptance criterion, in either direction. The US003 row is a reservation,
not a membership claim: it is here so that whoever takes the carry finds the plan from this index,
and it is not a pre-computation of the FLAGS union, which `../03-SPRINTS/SPRINT-03.md` refuses for
the same story on the same grounds.

<!-- The paragraph's second sentence read, from 07/09/2026 until 08/09/2026: "That is the position
     `../02-STORIES/US007.md` ratifies onto every plan, and it is why neither cell reads a value
     from the template's legend." Reworded because it read as though the ratification were already
     in force; US007 is scheduled, not shipped, and 02-SPRINT-PLAN-02.md was reverted the same day
     for claiming the same thing. The cells are unchanged — verbatim mirroring predates US007 and
     is this plan's own. -->

**The two statuses now agree, and the agreement is as deliberate as the difference was.**
`../17-STORY-PLANS/CLAUDE.md` makes a plan marked anything other than `Blocked` an assertion that
its blockers are cleared, and the parallel-worktree DAG reads it. US004 waits on nothing — its map
has an empty frontier, and its place third in the build order is arithmetic rather than a blocker
— so its plan's `Open` is a truthful assertion. US003's only constraint was ever build order
against a story that changes no file it touches, a sequencing fact its plan states in prose rather
than as a status; in this plan it has no constraint at all until it arrives, and if it arrives
US004 has already landed. **The `Blocked` this plan indexed — US005's, the first plan in this
repository to carry it — left with the story.** Its target directory still exists in no branch and
no commit, its plan's `| Status |` row still reads `Blocked` (both re-verified 09/09/2026), and the
sprint plan that indexes that row is SPRINT-04's — written on 08/09/2026, it took over the indexing
that day, and its own _Story Plans — the code master_ states why US005's plan carries `Blocked`.

<!-- The sentence's last clause read "and the sprint plan that will index that row is SPRINT-04's,
     which is not yet written" from 07/09/2026, and "and the sprint plan that will index that row
     is SPRINT-04's, which is not yet written (re-verified 08/09/2026)" from 08/09/2026 until
     09/09/2026. The stamp was added by the same commit that wrote
     project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md — 8a03e3f, 08/09/2026 — so the
     clause was false at the instant it was re-verified. project-management/src/02-STORIES/US007.md
     -> Acceptance Criteria already reads this clause as superseded on 08/09/2026; corrected here on
     09/09/2026, which makes that reading true. -->

<!-- The passage read, from 05/09/2026 until 07/09/2026, over the rows US005 **Blocked** and US003
     `Open`: "**The two statuses differ deliberately.** `../17-STORY-PLANS/CLAUDE.md` makes a plan
     marked anything other than `Blocked` an assertion that its blockers are cleared, and the
     parallel-worktree DAG reads it. US005's target directory does not exist, so its plan carries
     `Blocked` — the first in this repository to do so. US003's blocker is build order against a
     story that changes no file it touches, which is a sequencing fact the plan states in prose
     rather than a status." The plan-versus-plan reasoning survives above; the rows it was about do
     not. ../02-STORIES/US007.md cites this passage by line, and the US005/US003 pair by name, as
     the position it ratifies; that citation is owed a re-resolve by the story, not by this
     plan. 08/09/2026: paid. US007.md re-resolved it by section name that day — its Scenarios 8
     and 11 now cite _Story Plans — the code master_ by name, describe the agreement-versus-
     difference reading above in their own words, and carry no line number into this plan. -->

**There is no Plans Index row for either**, and that is a decision rather than an omission. The
index eight artefacts already cite has never existed; `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`
slice `S-01` **creates `../17-STORY-PLANS/STORY-PLAN-INDEX.md`** — the file all eight citations
should have named — and repoints them. The claim lives on that map's _Register claimed_ table; the
entry was re-triaged off `GAPS.md`, so that register is **not** where a reader will find it.
Building an index here would pre-empt a claimed slice and add a ninth citation of a surface about
to be named something else. That slice is US002's line of work, and US002 now builds in SPRINT-02,
ahead of this sprint: if the index exists when this sprint is worked, its row is that mechanism's
to write, not a hand edit here.

<!-- 08/09/2026 — STORY-PLAN FILENAMES GAINED AN `<exec-order>-` PREFIX, and this plan's live
     citations were repointed the same day: US004's plan is `05-STORY-PLAN-US004-…` and US003's
     `04-STORY-PLAN-US003-…`. The form is
     `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, the prefix 2-digit zero-padded,
     `00-` the template. The prefix is the story's position in the settled build order ACROSS THE
     WHOLE BACKLOG — US007 `01`, US001 `02`, US002 `03`, US003 `04`, US004 `05`, US005 `06`, US006
     `07` — and it is RENUMBERED whenever build order changes. It is neither a sprint number nor a
     per-sprint counter.

     TWO THINGS A READER OF THIS PLAN WILL OTHERWISE TRIP ON.
     (1) _Build order_ above calls US004's place **third**; that is the third SPRINT in the
     sequence, which is why both segments of this file's own name read `03`. The story's place in
     the backlog's build order is fifth of seven, which is why its plan reads `05-`. Two different
     counts, both correct, over different populations.
     (2) The index table above lists US004's `05-` above US003's `04-`, because within this sprint
     US004 is the member and US003 the reserved carry. Nothing is out of order: US003 builds
     earlier, in SPRINT-02. Were the carry to land here instead, the build order itself would
     change and the prefixes would be renumbered to match — that is the convention, not a defect
     in it.

     AND THE OPPOSITE OF THE RULE GOVERNING THIS FILE'S OWN NAME. ./CLAUDE.md says a sprint plan is
     `<exec-order>-SPRINT-PLAN-<sprint-number>.md` and that a mismatch between the two segments is
     deliberate and must NOT be "corrected" — two numbers, and the PAIR carries the meaning. A
     story plan carries ONE number, so its prefix must track build order or it says nothing. Do not
     read that guardrail across to `../17-STORY-PLANS/`.

     A naming sweep only: membership, capacity, the reservation, the statuses and the build order
     are all untouched, and the dated comments in this file quote the pre-rename names. -->

---

## Phase Breakdown

**US004 does not enter a code lane.** The four-phase backend → API → frontend → PR sequence in
`project-management/docs/planning/SPRINTS.md` maps stories by the layers they touch, and this one
touches none of them. The phases are recorded as `N/A` with a reason rather than deleted, per
`code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**N/A** — no model, service, migration or business logic. US004 reads `Backend: N/A`.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema. US004 reads `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. US004 reads `Frontend: N/A`.

### The lane this story actually runs in

| Story | Deliverable                                                                                                 | Proven by                                                        |
| ----- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| US004 | Five repairs to `code/src/scripts/audits/doc-references.sh`, one register mechanism, one shipped-file sweep | The script's own `--self-test`: fixture pairs plus direct probes |

**This sprint ships executable proof again.** From 05/09/2026 to 07/09/2026 it shipped none — the
first plan since SPRINT-01 of which that was true, because US004's `--self-test` had gone to
SPRINT-02 with the story. It comes back here with it: the self-test is the only executable check
this sprint ships, and `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` Section 6
carries the method — measure by executing a patched scratch copy, never by reading. The manual
checks stay load-bearing beside it: the before/after whole-tree run, the tracked-versus-untracked
A/B, and a written classification of every finding the widened gate exposes.

**If the carry lands, one row joins this table** — US003's: `code/docs/ABSENCE.md` plus its
registration, tier markers and reciprocity edits, proven by five documentation gates and a human
read-across. That row is the one this plan carried from 05/09/2026 to 07/09/2026, kept below; it
is not re-added until the story is.

<!-- The lane table read two rows until 07/09/2026: "US005 | Four rules into the
     code/docs/reliability/ family, one budget table, four budget contradictions repaired | Three
     documentation gates, a hand recomputation and a read-across" and "US003 | code/docs/ABSENCE.md
     plus its registration, tier markers and reciprocity edits | Five documentation gates and a
     human read-across". The paragraph beneath read: "**This sprint ships no executable proof at
     all**, and it is the first since SPRINT-01 of which that is true — US004's `--self-test` went
     back to SPRINT-02 with it. Both members are verified by gates that read Markdown plus checks
     only a person can do: US005's hand recomputation of the derived worst-case column, and both
     stories' read-across for a rule stated in two homes. Recorded here because a sprint with no
     automated proof needs its manual checks to be load-bearing rather than ceremonial." -->

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

US004 alone, behind no blocker. `22-implementation-documentation` runs between the lane above and
this phase and is a merge gate — it writes the story's `../18-TESTS/US004-TEST-STATUS.md` and
`../18-TESTS/US004-MANUAL-TESTING.md`, which **US004's own register rows make citable in advance**, and it owns
the `GAPS.md` write this sprint produces: closing the 02/09/2026 entry against all three of its
retirement conditions, and correcting its stale blocked-by sentence rather than deleting it.

<!-- Read "Both stories, each behind its own blocker" and named "US005's unenforced-window entry"
     as the DEFERRED.md write this sprint produces, until 07/09/2026. That entry travelled to
     SPRINT-04 with US005. -->

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in the story plan and the spec it cites.

### GDPR (`../09-GDPR/`)

**N/A** — US004 reads `GDPR: N/A`. No personal data is read, written or logged; it ships one shell
script that reads repository files and emits paths, plus Markdown.

### Security (`../10-SECURITY/`)

**N/A as a flag, with one property worth asserting anyway:** US004's self-test probe for the
population fix **writes inside the repository**. It must create its file under a path the
repository already owns, never in `/tmp` with a predictable name, and remove it on every exit path
— it carries a `trap` for exactly that. Recorded in
`../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` Section 5.

**The live security section this plan carried left with US005 on 07/09/2026**, and the removal is
a gate that does not apply here, not a gate skipped. The union's Security row reads `N/A` on
US004's own flag; the twelve findings, the three design-state promotions and the twelve developer
constraints are SPRINT-04's to summarise, and the plan that does so was written on 08/09/2026 —
the summary is under its own _Security_, not here. `AUDITS/` still does not fire, for the same
reason as before: a code audit reads shipped code, and this sprint ships one bash script.

<!-- The clause read, from 07/09/2026 until 09/09/2026: "and the plan that will do so does not yet
     exist." True when written; falsified on 08/09/2026, when 16-sprint-plans wrote
     project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md with the summary under its
     Security section, and left standing by the pass of that day, which did not revisit it.
     Corrected 09/09/2026. Whose summary it is has not moved. -->

<!-- The section read, from 05/09/2026 until 07/09/2026:

     "**Live, and US005's alone.** US003's Security flag reads `N/A` and contributes nothing here.
     The gate closed 05/09/2026 with **twelve findings across five of the six STRIDE categories —
     eleven `INFO` and one `LOW`**. Elevation of privilege is recorded as
     considered-and-not-applicable (no principal changes hands in a retry), which is a deliberate
     `N/A` and not an unexamined letter. Nothing is CRITICAL or HIGH, so nothing blocks this plan,
     and no record is opened under `../10-SECURITY/VULNERABILITIES/PLANNING/`. **That is a decision
     with its reason, never an audit that found nothing:** the escalation rule is written against
     exploitability and there is no retry in this tree to exploit.
     Three properties bind the sprint, and the **twelve** developer constraints behind them are in
     `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` Section 7 —
     eleven on the doctrine's wording plus the one task that outlives the document. Not restated
     here:
     - **The severities expire.** Every `INFO` is a fact about a tree in which nothing outbound
       retries, measured 05/09/2026. Read them **with** the promotion-trigger table in
       `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`
       Section 3a: **three** rows are design-state `HIGH` — TM-01, TM-02 and TM-04 — and each names
       the story that will meet it. The assessment's own summary says four by counting TM-02
       twice; three rows carry the mark.
     - **The constraints are on wording, because wording is all this sprint ships.** They are
       checkable by reading the shipped guide, not by running anything.
     - **TM-02 is the one finding that is live now**, and it is live precisely because the rule
       ships without its gate. `DEFERRED.md` records the unenforced window at ship, naming slice
       `S-05` as owner and the first client-wiring story as its deadline.
     **`AUDITS/` did not fire**, and the skip is recorded rather than reported as a pass: a code
     audit reads shipped code and this sprint ships none. It fires at the first story that wires a
     client."

     Every figure in it is US005's and travelled with the story. The TM-02 correction — three rows
     carry the mark, not four — is a fact about the assessment and holds wherever it is next
     summarised. -->

### QA & SEO

US004's QA plan is **Signed off** and carries no unresolved `AC-GAP` — nine found, nine resolved
02/09/2026, two of them overturning premises the story was written on. SEO reads `N/A`.

**The sprint's QA union is US004's own value, and it names a unit type for the first time in this
plan** — the gate's self-test and fixture pair, alongside manual runs of `docs-length.sh`,
`doc-references.sh` and `doctrine-drift.sh`. It **narrowed** on 07/09/2026: the five-gate manual
value entered this union with US003 on 05/09/2026, and `routing-skills.sh` and
`skill-conformance.sh` left with it. A union narrows only when a member leaves, which is exactly
this case — US003 moved whole, so this is not the Part A / Part B narrowing
`project-management/docs/planning/SPRINTS.md` permits — and `../03-SPRINTS/SPRINT-03.md` records
the same recomputation against its own flag table on the same day. **The carry is not
pre-computed into it.** If US003 lands, the QA row widens by its two gates and nothing else moves,
US003's other twelve rows being `N/A`.

<!-- Read, until 07/09/2026: "Both QA plans are **Signed off** and neither carries an unresolved
     `AC-GAP` — US005's fifteen all resolved 05/09/2026, US003's seven at its own gate. SEO reads
     `N/A` on both stories. The sprint's QA union names **one type, manual, across five gates**:
     US005's three documentation gates plus the `routing-skills.sh` and `skill-conformance.sh`
     that entered this union with US003. Recomputed on US003's admission on 05/09/2026, and the
     union is carried in full rather than narrowed." -->

### Decisions binding this sprint

| ADR                                                                      | Binds                                                                                                                                                                            |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`   | Check 2 reads the citing file's name, never `is_template_only()`                                                                                                                 |
| `../15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md` | A `PROJECT-PATHS.md` row may name a class; `###` is three digits exactly                                                                                                         |
| `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`   | The full-path citation form, and that no gate verifies a PM `src/` instance citation. **US004 makes the second half false**, which the ADR names as its own retirement condition |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`    | A red `doc-references.sh` is read as a diff. **Still in force** — see below                                                                                                      |
| `../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`    | Prose doctrine is verified by human read-across; `doctrine-drift.sh` is a guard only                                                                                             |

The first four are the ADRs `../02-STORIES/US004.md` Decisions names. The fifth is inherited on
the precedent `02-SPRINT-PLAN-02.md` set for the same story on 05/09/2026; the story's own list
does not name it, and it is carried here because US004's one prose edit — `code/docs/FORWARD-VOICE.md`
Section 3 — is verified the way that ADR says, not because anything in the story cites it.

**One ADR retires on this sprint's own work, against the reading its story assumes.**
`ADR-US003-CITATION-GATE-BASELINE-DIFF` retires when slice `S-06` lands **and the gate goes
green** — a conjunction, and US004 **is** `S-06`. The second half will not hold when it lands,
because correct forward references survive it: US006's to
`code/src/scripts/_lib/posture-guard.sh`, in SPRINT-04, and US005's to
`how-to/src/OUTBOUND-TIMEOUTS.md`, owned by an uncut slice. The ADR also calls for a **new record
to supersede it** rather than being edited, and nobody has written one. The baseline discipline
therefore stands for US004 itself — its run is read as a diff and never reported as a plain pass
while a survivor stands, which is what `QA-PLAN-US004` AC-GAP-3 already requires.

<!-- The table read, until 07/09/2026: ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026 ("One
     layer decides; layers beneath make a single attempt; SDK retries clamped by default"),
     ADR-US001-PROSE-DOCTRINE-VERIFICATION, ADR-US003-CITATION-GATE-BASELINE-DIFF ("Still in force
     — see below"), ADR-US001-INSTANCE-CITATION-UNVERIFIED ("The full-path citation form, and that
     no gate verifies a PM src/ instance citation") and ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH
     ("US003's crib cells cite nothing that does not yet exist"). Two paragraphs followed. The
     first: "**One ADR in that list was corrected rather than superseded**, and a reader should
     not mistake that for drift: ADR-US005-ONE-LAYER-DECIDES-TO-RETRY's worked clamp literal was
     wrong and was fixed in place on 05/09/2026 across the ADR, ../02-STORIES/US005.md and the
     map's N-008, the record not having reached a commit. **The vendor semantics behind it are
     per-story depth and live in STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md → The clamp's
     correct form**, not here." The second read the baseline-diff ADR as standing "for both
     members", because "the second half will not hold for this sprint, because correct forward
     references survive". US005's ADR and its correction note travelled to SPRINT-04; US003's crib
     ADR to SPRINT-02; the baseline-diff reading is re-pointed above at the story that is now the
     repair. -->

### Gate honesty — the constraint specific to this sprint

**This sprint's subject is a gate, so it is the sprint most able to lie about one.** Four rules
apply throughout, from `code/docs/GATE-REPORTING.md`:

- **`doc-references.sh` never reports a plain pass here.** Findings survive US004 whatever it
  does, and **which survivors stand is a fact about the build order, which has changed under this
  plan.** The six known at US004's cutting — three citations of `code/docs/ABSENCE.md` owned by
  US003, three of `code/src/scripts/audits/SLOP-FAMILY.md` owned by US002 — belong to stories now
  scheduled **ahead** of this sprint in SPRINT-02, so if SPRINT-02 completed in full they have
  cleared before US004 is worked, and if US003 slipped here its three stand until it lands. Two
  classes this order cannot clear: US006's forward references to
  `code/src/scripts/_lib/posture-guard.sh` and US005's to `how-to/src/OUTBOUND-TIMEOUTS.md`. The
  set is **re-measured at implementation, never inherited from this list**, every survivor is
  named with its owner in `../18-TESTS/US004-TEST-STATUS.md`, and a bare pass is reported only if
  the run actually exits 0.
- **A baseline is only comparable against a run in the same git-index state** — and that
  dependence is the defect US004 removes, so it binds hardest before US004 lands.
  `../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` measured a **24-finding swing**
  on this tree between the same bytes untracked and tracked, every one a
  `[template-only citation]`. Record the index state beside any figure taken before the fix, and
  do **not** silence the class with `doc-references: template-only` markers — the marker would be
  a lie the moment the files land, and the story's own A/B is the proof the fix worked.
- **A fixture that passes both scripts proves nothing.** Every new case is run against the
  pre-change script and must fail there.
- **Measure by executing.** Two claims in US004 made by reading the script were wrong, and both
  became AC-gaps. The story's own figures — 44 findings at cutting, 16-to-38 on the
  `project-management/src/` arm — are reproduced at implementation, not inherited.

<!-- The section read three rules until 07/09/2026, headed "**Neither gate this sprint leans on
     can read what this sprint writes**": doctrine-drift.sh reads fenced code only, so a green run
     says nothing about retry or absence doctrine appearing in two homes; doc-references.sh never
     reports a plain pass for US005, whose forward references to code/docs/reliability/ and
     how-to/src/OUTBOUND-TIMEOUTS.md survive whatever the story does, while "US003's half of this
     may become a plain pass — if US004 has landed, its baseline procedure is unnecessary and its
     plan says so"; and the same-index-state rule with the 24-finding swing. The first rule was
     about prose doctrine and travelled with the two stories that ship it; the second is
     re-pointed at US004 above; the third survives because it is about the defect US004 fixes. -->

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-03.md` → _Verification Checks_ and is not restated here.

- [ ] `doc-references.sh` — read as a diff, never as a pass. No finding remains of the three
      classes US004 owns — the git-index class, the instance-citer class and the dangling
      `project-management/src/` class — and every survivor is named with its owner in
      `../18-TESTS/US004-TEST-STATUS.md`, with the git-index state recorded beside every figure
      taken before the fix. Which survivors stand depends on how SPRINT-02 closed; see _Gate
      honesty_
- [ ] `doc-references.sh --self-test` exits 0, its probe count risen by one case per repair, and
      every new fixture case shown to fail against the pre-change script
- [ ] `docs-length.sh` — `how-to/src/PROJECT-PATHS.md` and `code/docs/FORWARD-VOICE.md`, the files
      US004 grows, do not enter the warn tier without a dated allowance;
      `code/src/scripts/audits/CONTEXT.md` is not grown while at 298 unless US002 has landed and
      built the headroom
- [ ] `doctrine-drift.sh` — regression only; US004 adds no claims row
- [ ] `docs-pairing.sh` — regression only; US004 creates no directory
- [ ] `routing-skills.sh` and `skill-conformance.sh` — **N/A since 07/09/2026**; they entered this
      plan with US003 and ran against its frontmatter alone. US004 adds none. Both apply again if
      the carry lands
- [ ] `syntax/lint.sh` passes over what it reads — for US004 that is the Markdown leg,
      markdownlint-cli2, over the four Markdown files it edits; `syntax/check.sh` is **N/A**, it
      type-checks Python, TypeScript and Rust and has no shell or Markdown leg
- [ ] ShellCheck over the script US004 edits — **the story's own expectation, with no project
      script to satisfy it**: `lint.sh`'s legs are ruff, markdownlint-cli2, ESLint and clippy
      (`code/src/scripts/syntax/CONTEXT.md`), and as of 08/09/2026 no script under
      `code/src/scripts/`, no CI job and no lefthook entry runs ShellCheck — only
      `# shellcheck source=` and `# shellcheck disable=` directives exist. Run by hand and
      recorded in `../18-TESTS/US004-MANUAL-TESTING.md` as run or as not run, never as a
      `lint.sh` pass (`code/docs/GATE-REPORTING.md`)
- [ ] The before/after whole-tree run is recorded with both finding counts, both exit codes and
      the delta; the tracked-versus-untracked A/B is reproduced before any edit and again after,
      with the index restored each time
- [ ] Every finding the widened gate exposes is classified in writing — genuine, generic-noun
      false positive, or another story's — with none left unclassified, and each repaired shipped
      file is re-read in place
- [ ] A tester other than the author has signed the walk-through off

<!-- Until 08/09/2026 the syntax rows above were one: "`syntax/lint.sh` and `syntax/check.sh`
     pass, including ShellCheck over the script US004 edits". Neither script carries a ShellCheck
     leg, so the row promised a pass nothing could run to earn; split the same day into what the
     scripts read and what the story expects of itself, as `../03-SPRINTS/SPRINT-03.md` ->
     _Verification Checks_ was. -->

<!-- Three checks this plan carried from 05/09/2026 to 07/09/2026 are gone rather than N/A'd,
     because they named a departed member's file or figure and not a gate. The doc-references
     check read: "**Measured 05/09/2026 with this plan and US005's story plan present and
     untracked: 151 tree-wide** — 67 [dangling path], 60 [template-only citation], 24 [instance
     citation]. Count the script's **finding lines**, not grep hits over its whole output: its
     explanatory footer repeats the class labels, and a first pass here reported a breakdown
     summing to 152 against a stated 151. The QA plan's **56** and ../02-STORIES/US005.md's **53**
     both predate this session and US006's artefacts; none of the three is comparable without its
     index state." The 151 was a session measurement of the whole tree and is not inherited: the
     record's own check says the set is re-measured at implementation. The docs-length check named
     "code/docs/TASK-AUTHORING.md at 266 is the file to watch", a file only US005's retry doctrine
     touched. And two manual checks were the departed members' own: "US005's derived worst-case
     column recomputed by hand on a default row **and** on the webhook override row, both
     arithmetic strings written out", and "Both read-acrosses done — US005's across six guides,
     US003's across the six TYPES-* files". The finding-lines-not-grep-hits caution is a fact about
     the script's output and holds for US004's own before/after counts. -->

---

## Sprint Definition of Done

- [ ] **US004 is Completed** — its own DoD complete, verified by a reviewer, and
      `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06` carries its number
- [ ] **The carry-over question is disposed of in writing, either way.** US003's 5 SP `Should`
      carry is reserved into this plan by `../03-SPRINTS/SPRINT-02.md`'s Definition of Done and
      held by `../03-SPRINTS/SPRINT-03.md` from its side. If US003 carried here, it is
      **Completed** here or explicitly carried on again with its reason recorded in both records
      and in `../02-STORIES/US003.md` — a `Should` is never dropped silently, and **US003 has
      already moved twice** (SPRINT-02 → SPRINT-03 on 05/09/2026, SPRINT-03 → SPRINT-02 on
      07/09/2026), so a third move records all three. If it did not carry, that is stated here
      rather than left as an unexplained 8 / 11. **In the carry case US004 is worked first and
      US003's baseline-diff scenario is read as a plain pass** — the revision pass under _Build
      order_ applies in that case, and in that case only
- [ ] All sprint-level verification checks passed
- [ ] No open HIGH/CRITICAL security finding — **N/A**, the sprint's Security flag reads `N/A`. It
      applied here from 05/09/2026 to 07/09/2026 on US005's flag alone, and applies now in
      SPRINT-04
- [ ] GDPR requirements implemented and verified — **N/A**, the GDPR flag reads `N/A`
- [ ] QA scenarios passing — US004's self-test, and its manual walk-through signed off by a second
      tester; US003's five documentation gates as well, in the carry case
- [ ] US004's implementation records written by `22-implementation-documentation`, and `GAPS.md`'s
      02/09/2026 entry closed against all three of its retirement conditions
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-03.md` `**Status:**` set to `Done`

<!-- The first two rows read, from 05/09/2026 until 07/09/2026: "**US005 is Completed** — its own
     DoD complete, verified by a reviewer" and "**US003 is Completed, or explicitly carried to
     SPRINT-04** with its reason recorded in `../03-SPRINTS/SPRINT-03.md`; a `Should` is never
     dropped silently, and **US003 has already moved once**, so a second move records both." The
     second mirrored the record's clause of the same date, which ../02-STORIES/US006.md cited by
     line (`03-SPRINT-PLAN-03.md:357-359`) as the live reservation to SPRINT-04 until that story's
     own correction of 07/09/2026. Superseded 07/09/2026 on both halves: US003 has
     moved twice, and the carry now runs INTO this sprint from SPRINT-02, not out of it to
     SPRINT-04 — which stands at 13 / 11 by decision and no longer carries a contingent figure.
     Three further rows left with US005: "No open HIGH/CRITICAL security finding — **applies**,
     and this is the first sprint plan for which it does. Twelve findings closed at INFO/LOW; the
     design-state promotions are not this sprint's to perform"; "Any security finding whose
     promotion trigger fired during the sprint is re-assessed in
     ../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/ rather than left at its present-state severity";
     and "DEFERRED.md carries US005's unenforced-window entry, naming slice S-05 as owner". The QA
     row read "manual for both members; this sprint ships no automated proof", and the records row
     "Both stories' implementation records written by 22-implementation-documentation". -->

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story                   | Branch                          |
| ----------------------- | ------------------------------- |
| US004                   | `us004/citation-gate-git-index` |
| US003 — carry case only | `us003/absence-guide`           |

<!-- US005's row, `us005/retry-ownership-and-budgets`, left with the story on 07/09/2026. US003's
     row was a member's until the same day; it is kept, marked, because the branch name is the
     story's and applies here only if the carry lands. -->
