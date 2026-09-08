# SPRINT-PLAN-02 — The audits register regains its headroom, and the absence guide is born behind it

**Last Updated**: 08/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-02.md` · **Capacity:** 3 SP Must + 5 SP Should = 8 / 11 · **Stories:** 2

<!-- Read "**Capacity:** 8 / 11 · **Stories:** 1" from 05/09/2026 until 07/09/2026, when US004 moved
     to SPRINT-03 and US002 and US003 arrived on the US007 re-plan that ../03-SPRINTS/SPRINT-02.md
     -> Notes records. The figure is unchanged and the members are not — US004's 8 left, US002's 3
     and US003's 5 arrived — so the recomputation is written out rather than left to look like
     inaction: 3 + 5 = 8, and the tier split is new. The title read "The citation gate stops
     depending on the git index" for the same period. -->

<!-- Read "8 SP Must + 5 SP Should = 13 / 11" and "Stories: 2" until 05/09/2026, when US003 moved
     to SPRINT-03 before either sprint was worked. This plan no longer needs grace; the reasoning
     that admitted it is kept under Should rather than deleted, because it is the record of a
     decision that was taken. ../03-SPRINTS/SPRINT-02.md was corrected the same day. -->

---

## Sprint Goal

> The audits register regains the headroom nine new gates need, and the absence guide is born
> behind it.

<!-- The goal read "The citation gate gives the same verdict on the same sentence whether or not
     the file is committed." from 05/09/2026 until 07/09/2026, when US004 left for SPRINT-03. A
     goal naming a deliverable no member carries is drift; ../03-SPRINTS/SPRINT-02.md rewrote its
     own goal the same day from the two members' titles and Client Summaries, and this plan
     carries that text verbatim rather than a paraphrase, so the two cannot drift apart. The
     closing clause is deliberately the one this plan cut on 05/09/2026 — see the comment below —
     because the deliverable it names is back. -->

<!-- The goal carried "and the absence guide is born behind it" until 05/09/2026, when US003 moved
     to SPRINT-03. A goal naming a deliverable no member carries is drift; ../03-SPRINTS/SPRINT-02.md
     cut the same clause for the same reason on the same day. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`. The authorities this
> sprint defers to are `code/docs/DOCUMENTATION-LENGTH.md` for what a documentation file may
> weigh — US002's 230 target and US003's under-270 birth clause are both its figures —
> `code/docs/DOCUMENTATION-PAIRING.md` for which half of a pair a line belongs in, and
> `code/docs/GATE-REPORTING.md` for how a gate's result is reported. Where a story's wording and
> those guides differ, the guides win.

<!-- Until 07/09/2026 this clause named code/docs/FORWARD-VOICE.md — US004's authority for what a
     document may promise about a tree it will be read in — and not DOCUMENTATION-PAIRING.md. The
     first went with the story; the second arrived with US002, whose fourth scenario moves
     operating rules across a pair. -->

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                               |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-02.md`                                                                                                                                                                                         |
| User stories       | `../02-STORIES/US002.md` · `../02-STORIES/US003.md`                                                                                                                                                                  |
| Feature maps       | `../01-FEATURE-MAPS/MAP-ABSENCE.md` slice `S-01` (US003) · `../01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` slice `S-04`, whose Flags column names US002's shrink as a **precondition** — US002 owns no slice row |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                    |
| User flows         | **N/A** — both read `User Flow: N/A`; no user journey in scope                                                                                                                                                       |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                          |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                     |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path                                                                                                                                                               |
| Security           | **N/A** — both read `Security: N/A`; no protected action and no new endpoint                                                                                                                                         |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` · `../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` — both **Signed off**                                                                             |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                       |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface                                                                                                                                                              |
| Logging            | **N/A** — both read `Logging: N/A`; no log line                                                                                                                                                                      |
| Decisions          | Six ADRs bind this sprint — two written at US002's gates, two at US003's, two inherited from US001. Listed under _Sprint-wide Constraints_                                                                           |

**Every `N/A` above is a flag reading `N/A` in both stories, not a gate anyone forgot** — the
distinction `code/docs/GATE-REPORTING.md` requires. Twelve of the thirteen flags are `N/A` in both
members; only `QA` is live.

**Both QA plans carry a `Sprint` field that names a sprint the story has since left** — US002's
reads `SPRINT-01`, US003's reads `SPRINT-03` with a comment recording the 05/09/2026 move. Neither
is this plan's to edit; the gaps, scenarios and gates in each are properties of the story, not of
the sprint that carries it, so nothing this plan relies on is affected.

<!-- 05/09/2026: the User stories and QA rows named US003 and its QA plan until the story moved to
     SPRINT-03. Both then named US004 alone; the story and its plan were carried by
     ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md.
     07/09/2026: US003 and its QA plan are back in both rows, returned from SPRINT-03 on the
     re-plan; US004 and QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md left for SPRINT-03, and the
     Feature maps row's "MAP-RULE-OWNERSHIP.md slice S-06" went with them. This comment is kept
     because the first move happened; the table above is the live fact. -->

---

## Stories

### Must

| ID    | Title                                                        | Phases touched           | SP  | Story plan                                                          | Git branch                       |
| ----- | ------------------------------------------------------------ | ------------------------ | --- | ------------------------------------------------------------------- | -------------------------------- |
| US002 | The audits register regains the headroom nine new gates need | Docs only — no code lane | 3   | `../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` | `us002/audits-register-headroom` |

**3 SP committed against a capacity of 11.**

**US002 arrives from SPRINT-01 on 07/09/2026, and it is the reason this cascade exists.** US007 —
the story status vocabulary gets one owner — was cut that day at 5 SP `Must Have`, and it has to
ship before US002, because US002 unblocks `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slice
`S-03`, which builds `register-indexes.sh` and its `broken/` + `clean/` status fixtures against
whichever `**Status:**` vocabulary is canonical on the day they are written. <%DEVELOPER_NAME%>
settled the shape as a full cascade across all four records rather than an execution reorder, and
US002 moving one sprint later is the first link of it. `../03-SPRINTS/SPRINT-02.md` → _Notes_
carries the four-record table.

**US002 cannot take a demotion.** It is the sprint's only committed work, and it unblocks nine
audit registrations across eight slices and seven maps — every story that adds a script under
`code/src/scripts/audits/` needs three counted lines in a register with two lines of headroom.

<!-- The Must table held US004 — "The citation gate stops depending on the git index, and the PM
     tree becomes checkable", Script + docs — no code lane, 8 SP,
     ../17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md, us004/citation-gate-git-index
     — from 02/09/2026 until 07/09/2026, with "8 SP committed against a capacity of 11" beneath
     it. Both moved with the story to ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md. -->

### Should

| ID    | Title                                                                        | Phases touched           | SP  | Story plan                                               | Git branch            |
| ----- | ---------------------------------------------------------------------------- | ------------------------ | --- | -------------------------------------------------------- | --------------------- |
| US003 | Absence gets an owning guide, born under 270 with every clause's tier stated | Docs only — no code lane | 5   | `../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` | `us003/absence-guide` |

**US003 is back, and the first move is not pretended away.** It was this plan's `Should` stretch
from 02/09/2026, left for SPRINT-03 on 05/09/2026 to give a single-member all-`Must` sprint some
give, and returns on 07/09/2026 because SPRINT-03 now holds US004 alone and its give is the
reserved carry below rather than a second member. **Its demotion to `Should Have` on 02/09/2026
stands, and for the same reason:** this sprint still needs a member that can slip without the
sprint failing, nothing inside it depends on US003, and the five slices US003 blocks are not yet
cut. The `Must` tier is now US002's 3 SP rather than US004's 8, which makes the stretch a larger
share of the sprint than before — 5 of 8 rather than 5 of 13 — and that is the correct shape for a
sprint whose committed work is small and whose stretch has somewhere reserved to go.

**This is a re-plan, not a carry-over**, on both moves. A carry-over is a `Should` a worked sprint
failed to reach, and it arrives in the next sprint carrying that failure; no sprint has been
worked, so US003 left with nothing attached on 05/09/2026 and returns with nothing attached on
07/09/2026. Every story's `**Status:**` stays `Open`; only membership moves.

**Its 5 SP carry is reserved into SPRINT-03, and the story is not split.** The Definition of Done
below provides that US003 is **Completed** here or explicitly carried to `../03-SPRINTS/SPRINT-03.md`,
which reserves the 5 SP from its side and stands at 8 / 11 without it, 13 / 11 with it. This is
the same shape US003 held in SPRINT-03 until today — `Should Have`, 5 SP, its carry reserved to the
next record — one sprint earlier. It is a **scheduling reservation, not a Part A / Part B**: no new
story number exists, and `project-management/docs/planning/SPRINTS.md`'s one permitted narrowing
of a flag union does not apply because nothing is split.

**This plan is inside capacity at 8 / 11 and needs no grace.** Grace is SPRINT-04's story now,
and a different shape: `../03-SPRINTS/SPRINT-04.md` takes 13 / 11 as **US005 (5) + US006 (8),
both `Must`** — the one case `project-management/docs/planning/CADENCE.md` reserves grace for,
chosen by <%DEVELOPER_NAME%> over a `SPRINT-05` holding US006 alone. There the grace covers the
commitment. The history below records this plan taking grace at 13 / 11 on 02/09/2026 as **8
`Must` + 5 `Should`** — "grace covers the ceiling, not the commitment" — and a reader should not
carry that reading across to SPRINT-04; the two records took grace for different reasons and each
says which.

**Its backlog priority is unchanged in substance.** US003 remains wave 0 of the absence map's
cutting order with no upstream of its own; `Should` is a scheduling tier for this sprint, and it is
`Should` rather than `Could` precisely because five slices wait on it.

**History, from 05/09/2026 — superseded by the return above.**

<!-- The paragraphs below were this section's live text from 05/09/2026 until 07/09/2026, when
     US003 returned. Kept verbatim as the record of the first move; the arithmetic they give was
     true when written and describes neither sprint now. -->

_None._ **US003 moved to `../03-SPRINTS/SPRINT-03.md` on 05/09/2026**, before either sprint was
worked, and its `Should` tier travelled with it unchanged into
`../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`.

**This is a re-plan, not a carry-over**, and the distinction is load-bearing. A carry-over is a
`Should` a worked sprint failed to reach, and it arrives in the next sprint carrying that failure;
neither sprint has been worked, so US003 leaves with nothing attached and SPRINT-03 receives a
stretch tier rather than a debt. **This plan is back inside capacity at 8 / 11 and needs no
grace** — the 13 SP ceiling went with the story, and the `Must` tier was never the part that
overshot.

**The reasoning that admitted it is kept below rather than deleted**, on the grounds
`../03-SPRINTS/SPRINT-02.md` keeps its own Notes: it is the record of a decision that was actually
taken. **Read it as history.**

**History, from 02/09/2026 — superseded by the move above, and by the return above that.**

**Demoted from `Must Have` at this gate on 02/09/2026, and recorded in all three artefacts** —
the story, `../03-SPRINTS/SPRINT-02.md` and here — rather than tiered at sprint level only, so no
reader finds two of them disagreeing on one field. `project-management/docs/planning/SPRINTS.md`
is explicit that an all-Must plan has no give and "the first surprise breaks it"; this sprint
admitted 13 SP against a capacity of 11, and US003 is the only member that can slip without the
sprint failing. **Nothing inside SPRINT-02 depends on it**, and the five slices it blocks on
`../01-FEATURE-MAPS/MAP-ABSENCE.md` are not yet cut into stories.

**US004 cannot take the demotion.** It is the sprint's only blocking work: slice `S-01` on
`../01-FEATURE-MAPS/MAP-NAVIGATION.md` waits behind it, and it retires a workaround every story
in this backlog currently carries.

**Its backlog priority is unchanged in substance.** US003 remains wave 0 of the absence map's
cutting order with no upstream; `Should` is a scheduling tier for this sprint, and it is `Should`
rather than `Could` precisely because five slices wait on it.

### Could

_None._

### Won't (this sprint)

- **`MAP-ABSENCE` slices `S-02` to `S-06`** — the Python `None` clause, the HTMX contract, the
  optional-surface remainders, tiers and mechanical legs, and consumer wiring. Every one cites the
  guide US003 creates, and `S-06` names the dependency in its own acceptance. **Since 07/09/2026
  they block on a member of this sprint again**, as they did until 05/09/2026; three of them
  (`S-02`, `S-03`, `S-04`) also inherit US003's crib back-link obligation. Not yet cut into
  stories; not `DEFERRED.md` rows.
- **The nine audit registrations US002 unblocks** — across eight slices and seven maps, each
  needing three counted lines in the register US002 shrinks. The full table is in
  `../02-STORIES/US002.md` → _Dependencies_. Blocked by US002, not deferred; none is yet a story.
- **US004 itself** — this plan's `Must` tier from 02/09/2026 until 07/09/2026, when it moved to
  `../03-SPRINTS/SPRINT-03.md` on the re-plan, before either sprint was worked. Recorded here as a
  `Won't` rather than left absent, on the rule this plan applied to US003 on 05/09/2026: a story
  this plan carried must stay findable from it. Its `Must` tier, its `--self-test` proof, its four
  ADRs' binding on it, and its own unblocking chain into `../01-FEATURE-MAPS/MAP-NAVIGATION.md`
  slice `S-01` all travelled with it — `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`.
- **Filling the 3 SP of headroom** — declined, on `project-management/docs/planning/CADENCE.md`'s
  reading that capacity is a trigger and not a target. US002's natural successors are the nine
  registering slices and US003's are the five absence slices, none of them cut, so any story that
  could fill 3 SP here today would be unrelated to both — the padding that guide tells a record to
  call out. `../03-SPRINTS/SPRINT-02.md` is **closed** at two members by decision.

<!-- Until 07/09/2026 this list read: "MAP-ABSENCE slices S-02 to S-06 — … Since 05/09/2026 they
     block on a story in another sprint, not on a member of this one: US003 is in SPRINT-03, so
     the five slices sit a sprint further out than this plan first recorded"; "US003 itself — this
     plan's Should tier until 05/09/2026, when it moved to ../03-SPRINTS/SPRINT-03.md … Recorded
     here as a Won't rather than left absent, because a story this plan carried must stay findable
     from it. Its tier, its ordering constraint and its revision pass all travelled with it —
     ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md -> Should"; "MAP-NAVIGATION slice S-01 — the citation
     edge set stops being discarded. It changes the same script US004 edits and must not land
     first. Blocked by US004, not deferred"; "GAPS.md's 01/09/2026 entry — the three shipped files
     still instructing the CONTEXT.md index row. Adjacent to US004's subject and owned by no slice
     on any map; explicitly out"; and "The MAP-GATE-PARITY question — whether a gate means the same
     thing in a generated project. ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md is one
     instance of it and claims none of its scope." The US003 bullet is retired because the story is
     a member again; the three US004-adjacent bullets went to SPRINT-03 with the story. -->

---

## Build order — US002 then US003, behind SPRINT-01 and ahead of SPRINT-03

**Within the sprint the order is set by tier, not by dependency.** Neither member's story names an
upstream, and neither depends on the other: `../02-STORIES/US003.md` names US002 as parallel work
that "neither blocks", and they share no file — US002 edits the `code/src/scripts/audits/` pair and
creates `slop-family/` beneath it; US003 creates `code/docs/ABSENCE.md` and edits four `SKILL.md`
files, `README.md`, three index surfaces and the drift table. The committed `Must` is worked first
and the stretch `Should` second, so an overrun costs the stretch and never the commitment.

**Across sprints this plan takes execution order `02`, and the number was checked rather than
copied.** The build order settled 07/09/2026 runs SPRINT-01 (US007 then US001), this sprint (US002
then US003), SPRINT-03 (US004), SPRINT-04 (US005 then US006) — number order — and
`../03-SPRINTS/SPRINT-03.md` → _Dependencies_ records the same check from its side. Three
constraints put it there:

- **Upstream, and the reason for the cascade: US007 in SPRINT-01 ships before US002.**
  `../02-STORIES/US007.md` → _Dependencies_ states it — the status fixtures US002's line of work
  builds are string-compared against whichever vocabulary is canonical when they are written, so
  the vocabulary is settled first. **`../02-STORIES/US002.md`'s own Dependencies still read "No
  upstream dependencies"** — true of its content, and now false of its ordering. That story-file
  edit is owed by `02-story-creation` and is not made here.
- **Reversed, and recorded rather than left to be discovered: US003 is now built before US004.**
  The US004-before-US003 ordering settled at `03-sprint-planning` on 02/09/2026 — and carried
  across US003's move on 05/09/2026 as a cross-sprint constraint — turns round on this re-plan.
  `../02-STORIES/US004.md` → _Dependencies_, _Collision with US003, named at cutting_, admits
  either order: "if US003 lands first, the three `code/docs/ABSENCE.md` forward references resolve
  on their own. Whichever lands second reads the other's disposition rather than re-deriving it."
  US003 was only ever blocked in ordering, not in content — its baseline-diff scenario is written
  for exactly the regime it is now worked under. Two consequences follow. The **revision pass** of
  05/09/2026 — recast that scenario, its before/after QA task and
  `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` as a plain pass once US004
  has landed — is **inapplicable while US003 is worked here**, and revives only if US003 carries
  into SPRINT-03 and is worked after US004 there. And **US004, landing second, reads US003's
  disposition**: the `code/docs/ABSENCE.md` survivors its Verification Checks name at cutting will
  have cleared before it is worked.
- **Downstream, and concrete: US002 before US004, now SPRINT-02 → SPRINT-03.** US002 shrinks
  `code/src/scripts/audits/CONTEXT.md` from **298 to 230 counted lines**, and US004 must edit a row
  in that file against a 300-line hard limit — recorded as `AC-GAP-9` of
  `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`. This plan argued the same edge on
  05/09/2026 as "SPRINT-01 before SPRINT-02"; it is the same direction one sprint later on each
  side, and it now agrees with the build order rather than fighting it.

**`../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` was brought into line with this order on
07/09/2026, and says so in its own header** (verified 08/09/2026). Its second header note records
the return to SPRINT-02 and that the US004-before-US003 order is reversed; the paragraph that
called the plan "more current than its story" — because "US004 lands first and removes the defect
all three exist for" — now opens "Since 07/09/2026 this paragraph holds only in the carry case",
and _The citation gate, corrected_ is scoped the same way. So the story's baseline-diff scenario is
the live regime here, and the plan's plain-pass procedure applies only if the story carries into
SPRINT-03 behind US004. Its `| Sprint |` row reads `SPRINT-02 · Wave 0 · build order 2`. Nothing
on that plan is owed to this order.

<!-- The paragraph read, from 07/09/2026 until 08/09/2026: "**STORY-PLAN-US003-ABSENCE-GUIDE.md is
     written for the reversed order and says so.** Its header block states that "US004 lands first
     and removes the defect all three exist for" and that the plan is therefore "more current than
     its story". Under this re-plan that is the stale half: the story's baseline-diff scenario is
     the live regime here, and the plan's corrected procedure applies only in the carry case. The
     repoint — that block, and the `| Sprint |` row beside it — is `17-story-plans`' to make and
     is named in _Story Plans_ below." The repoint it names was made in the same pass, by the
     agent rewriting that plan while this one was being rewritten; as a description of the plan's
     05/09/2026 state it was accurate history, and as a description of the file on disk it was
     wrong by the time the change was committed. -->

<!-- The section title read "Build order — SPRINT-01 before US004, and US004 before US003 across a
     sprint boundary" from 05/09/2026 until 07/09/2026, and its body argued four things, all of
     them US004's: that within the sprint there was no order left to set because US004 was the
     whole of it; that the US004-before-US003 constraint had become cross-sprint on 05/09/2026 and
     was restated in ../03-SPRINTS/SPRINT-03.md and ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md; that
     US003's revision pass had travelled with the story and belonged to whoever picked it up; and
     that pulling this plan ahead of 01-SPRINT-PLAN-01.md was declined because SPRINT-01 had
     already paid for the workaround US004 retires — "it is written into US001's two ADRs, both QA
     plans and both sets of acceptance criteria". The first three are reversed or re-stated above;
     the fourth is moot, because the story whose pulling-ahead was declined is no longer here. An
     earlier comment in this section recorded that the revision-pass obligation "moved to
     SPRINT-03 with the story rather than to GAPS.md" on 05/09/2026; it has come back with US003 in
     its new conditional form, above. -->

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. Both plans exist,
written on 02/09/2026, and both carry a `| Sprint |` row repointed to this sprint on 07/09/2026.

| Story | Story plan (`../17-STORY-PLANS/`)                                   | Status      |
| ----- | ------------------------------------------------------------------- | ----------- |
| US002 | `../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` | Not started |
| US003 | `../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md`            | Not started |

**Both cells read `Not started`, and the value is knowingly false** (08/09/2026). It is a value in
no status set anywhere in this repository, and both plans it points at carry `Open` in their own
`| Status |` header row. It is left standing BY DESIGN, on the position `01-SPRINT-PLAN-01.md` →
_Story Plans_ took on 07/09/2026 and <%DEVELOPER_NAME%> settled on 08/09/2026: correcting it is
US007's Scenario 8, which names this plan's `Not started` cells among the three live mirror cells
it changes to the value each plan's own `Status` field carries — and a re-plan that moves
membership does not pre-empt a scheduled story's own acceptance criterion. Neither plan is
`Blocked`: US002's upstream constraint (US007) is ordering, not content, and US003's is the same;
a plan marked anything other than `Blocked` asserts its blockers are cleared for content, which
both are. US007 counted three such cells at cutting — two in `01-SPRINT-PLAN-01.md`, one here;
after the cascade there are still three — one there, two here — a population US007 re-measures at
implementation rather than inherits.

<!-- The column read "Not started" — for US004's row, and for US003's before 05/09/2026 — until
     07/09/2026, `Open` for both rows from 07/09/2026 until 08/09/2026, and "Not started" again
     since. The 07/09/2026 edit was justified by this paragraph, superseded 08/09/2026: "**The
     Status column mirrors each plan's own line 9.** Both read `Open`, and that word is written
     here because it is the one the plans carry — US007 settled that this column takes a value
     from the canonical eleven-value story-status set and nothing else. Neither is `Blocked`:
     US002's upstream constraint (US007) is ordering, not content, and US003's is the same; a plan
     marked anything other than `Blocked` asserts its blockers are cleared for content, which both
     are." Its own comment read: "The column read "Not started" for both rows until 07/09/2026 — a
     value in no status set anywhere in this repository, and false against plans that read Open.
     Corrected on the re-plan rather than carried, because US007, the story this cascade exists to
     schedule, is the one that settled which values the column may hold." Reverted because US007
     has not shipped: a scheduled story has settled nothing yet, and its Scenario 8 names these
     cells as ITS edit. 01-SPRINT-PLAN-01.md read the same rule the other way on the same day and
     left its cell alone; the two plans now agree. -->

**Both `| Sprint |` rows agree with this plan, and were repointed in the same change** (verified
08/09/2026). US002's reads `SPRINT-02 · Wave 0 · build order 1`; US003's reads
`SPRINT-02 · Wave 0 · build order 2` — the string it carried at authoring, reached by two moves its
header notes record. Each keeps its superseded value in a dated comment. The rows were
`17-story-plans`' to repoint and were repointed on 07/09/2026 as the story-plan half of the
six-artefact discipline; `../03-SPRINTS/SPRINT-02.md` → _Notes_ named the debt on the day it was
paid, and nothing on either row is owed.

<!-- The paragraph read, from 07/09/2026 until 08/09/2026: "**Both `| Sprint |` rows are stale,
     and neither is this plan's to repoint.** US002's reads `SPRINT-01 · Wave 0 · build order 1`;
     US003's reads `SPRINT-03 · Wave 0 · build order 2`. Against this plan both should read
     `SPRINT-02`, with US002 at build order 1 and US003 at build order 2. `17-story-plans` owns
     the rows and `../03-SPRINTS/SPRINT-02.md` → _Notes_ names the debt; until it is paid, a
     reader should trust this plan and its record over the plans' headers." Written while the
     story plans were being repointed in parallel in the same pass, so it was false by the time
     the change was committed; corrected against the plans as they stand on disk. -->

**There is no Plans Index row for either**, and that is a decision rather than an omission.
`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slice `S-01` creates `../17-STORY-PLANS/STORY-PLAN-INDEX.md`
and repoints the citations that already name it; the file does not exist today, and this plan does
not pre-empt a claimed slice by building one.

<!-- US003's row sat below US004's until 05/09/2026, when the story moved to SPRINT-03; its plan
     was indexed by ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md instead.
     07/09/2026: US003's row is back, below US002's, returned from SPRINT-03 on the re-plan; US004's
     row — ../17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md — left for SPRINT-03 and
     03-SPRINT-PLAN-03.md indexes it now. This comment is kept because the first move happened;
     the table above is the live fact.
     08/09/2026: both paths in this comment are pre-rename names, kept as written. US003's plan is
     now ../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md and US004's
     ../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md. -->

<!-- 08/09/2026 — STORY-PLAN FILENAMES GAINED AN `<exec-order>-` PREFIX, and every live citation in
     this plan was repointed the same day: US002's plan is `03-STORY-PLAN-US002-…` and US003's
     `04-STORY-PLAN-US003-…`. The form is
     `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, the prefix 2-digit zero-padded,
     `00-` the template. The prefix is the story's position in the settled build order ACROSS THE
     WHOLE BACKLOG — not its sprint, and not a per-sprint counter — which is why this sprint's two
     members read `03-` and `04-` rather than `01-` and `02-`. It is RENUMBERED whenever build
     order changes: had US003 stayed carried into SPRINT-03, its prefix would still be `04-`
     because the build order, not the sprint, is what the number records.

     THAT IS THE OPPOSITE OF THE RULE GOVERNING THIS FILE'S OWN NAME. ./CLAUDE.md says a sprint
     plan is `<exec-order>-SPRINT-PLAN-<sprint-number>.md` and that a mismatch between the two
     segments is deliberate and must NOT be "corrected" — a sprint plan carries TWO numbers and the
     PAIR carries the meaning. A story plan carries ONE, so its prefix must track build order or it
     says nothing. Do not read the sprint-plan guardrail across to `../17-STORY-PLANS/`.

     A naming sweep only: no membership, capacity, tier, status or build order moved with it, and
     the dated comments here quote the pre-rename names they were written against. -->

---

## Phase Breakdown

**Neither story enters a code lane.** The four-phase backend → API → frontend → PR sequence in
`project-management/docs/planning/SPRINTS.md` maps stories by the layers they touch, and these two
touch none of them. The phases are recorded as `N/A` with a reason rather than deleted, per
`code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**N/A** — no model, service, migration or business logic. Both stories read `Backend: N/A`.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema. Both read `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. Both read `Frontend: N/A`.

### The lane these stories actually run in

| Story | Deliverable                                                                                                                                                          | Proven by                                                                               |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| US002 | `code/src/scripts/audits/CONTEXT.md` from 298 to 230 counted lines, its four missing Dependencies rows added, the AI-slop rationale into a bound `slop-family/` pair | Three documentation gates, a human read-across of every new route, and a 27-row dry run |
| US003 | `code/docs/ABSENCE.md` plus its registration on five surfaces, tier markers on every clause, and the reciprocity edits to four skills                                | Five documentation gates and a human read-across against the six `TYPES-*` guides       |

**This sprint ships no executable proof, and it did until 07/09/2026.** US004's `--self-test` was
the only automated check this plan carried, and it left with the story. Both members are now
verified by gates that read Markdown plus checks only a person can do — the read-acrosses, US002's
register-inventory balance, US003's Codd primary-source check — which is why the manual checks in
`../03-SPRINTS/SPRINT-02.md` → _Tasks_ are load-bearing rather than ceremonial.

<!-- US004's row — "Five repairs to code/src/scripts/audits/doc-references.sh, one register
     mechanism, one shipped-file sweep", proven by "The script's own --self-test: fixture pairs
     plus direct probes" — moved to ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md with the story on
     07/09/2026, together with the paragraph beneath it: "US004 is the sprint's first story with an
     automated proof. Its --self-test is the only executable check this sprint ships, and
     QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md section 6 carries the method: measure by executing a
     patched scratch copy, never by reading."
     US003's row — code/docs/ABSENCE.md, proven by five documentation gates and a read-across —
     moved to 03-SPRINT-PLAN-03.md with the story on 05/09/2026, and returned with it on
     07/09/2026, above. -->

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, US002 then US003. `22-implementation-documentation` runs between the lane above and
this phase and is a merge gate — it writes each story's `../18-TESTS/US###-TEST-STATUS.md` and
`US###-MANUAL-TESTING.md`, and both members' baselines, inventories and read-across records land
in the latter.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story plan and the spec it cites.

### GDPR (`../09-GDPR/`)

**N/A** — both stories read `GDPR: N/A`. No personal data is read, written or logged; both ship
Markdown, and US002 additionally moves Markdown between two files in a scripts directory.

### Security (`../10-SECURITY/`)

**N/A** — both read `Security: N/A`. No state-changing endpoint, no permission check, no
user-supplied ID, so neither the OWASP A01 nor the IDOR rule has a surface to bind.

<!-- Until 07/09/2026 this section read: "N/A as a flag, with one property worth asserting anyway:
     US004's self-test probe writes inside the repository. It must create its file under a path
     the repository already owns, never in /tmp with a predictable name, and remove it on every
     exit path. Recorded in QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md section 5." The property is
     US004's and travelled with it; neither member here writes a probe file. -->

### QA & SEO

Both QA plans are **Signed off** and neither carries an unresolved `AC-GAP` — US002 found eleven
from 24 adversarially tested candidates and resolved all eleven; US003 found seven and resolved all
seven at its own gate. SEO reads `N/A` on both stories.

**The sprint's QA union names one type, manual, across six gates — recomputed 07/09/2026 and
changed in one row.** The unit type — the gate self-test and its fixture pair — entered this union
with US004 alone and left with it, because a union narrows only when a member leaves;
`routing-skills.sh` and `skill-conformance.sh`, which left with US003 on 05/09/2026, return with
it; and `docs-pairing.sh`, which US002 alone names, enters. The result is the union of
`../02-STORIES/US002.md` and `../02-STORIES/US003.md` and nothing more.
`../03-SPRINTS/SPRINT-02.md`'s FLAGS comment records the same recomputation, and the spelling
decision that goes with it — all six names written with `.sh`, following SPRINT-03's precedent,
where US002's flag carries the suffix and US003's does not. **Neither story's own flag is rewritten
to match the other.**

<!-- Until 07/09/2026 this section read: "US004's QA plan is Signed off; SEO reads N/A. The
     sprint's QA union narrowed to US004's half on 05/09/2026 — its unit value, the sprint's first
     automated one, alongside the documentation gates it runs. The five-gate manual value entered
     this union with US003 and left with it. A union narrows only when a member leaves, which is
     exactly this case: US003 moved to SPRINT-03 whole. This is not the Part A / Part B narrowing
     SPRINTS.md permits, and ../03-SPRINTS/SPRINT-02.md records the same recomputation against its
     own flag table on the same day." The narrowing it records happened; the union it describes is
     SPRINT-03's now. -->

### Decisions binding this sprint

| ADR                                                                    | Binds                                                                                                                        |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` | The AI-slop rationale splits into `slop-family/CONTEXT.md`, a path `docs-length.sh` measures — never a bare sibling          |
| `../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`   | A gate that cannot open the files under test leaves the `QA` manifest; one that reads them but cannot decide stays, narrowed |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`  | A red `doc-references.sh` is read as an identity diff against a recorded baseline. **Still in force** — see below            |
| `../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md` | US003's crib cells cite nothing that does not yet exist; `S-02`, `S-03` and `S-04` retro-fit their own back-links            |
| `../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`  | Prose doctrine is verified by human read-across; `doctrine-drift.sh` is a regression guard only                              |
| `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` | No gate verifies a PM `src/` instance citation in either form; every such citation here is human-checked                     |

**One ADR in the set supersedes another, and the superseded record is not listed.**
`ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH` supersedes
`../15-DECISIONS/ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES-02-09-2026.md` on a measured false
claim — the split rule stands, the named target did not, because a bare `SLOP-FAMILY.md` sibling is
bound by no length gate. The superseded record's own header says so.

**And one is still in force against the reading US003's story plan assumes.**
`ADR-US003-CITATION-GATE-BASELINE-DIFF` retires when its repair — US004 — lands **and the gate goes
green**, a conjunction, and it calls for a superseding record nobody has yet written. US004 now
lands in SPRINT-03, **after** this sprint, so the baseline discipline stands for both members here
with no plain-pass reading available to either.

<!-- Until 07/09/2026 the table held four ADRs — ADR-US004-INSTANCE-ARTEFACT-CITER-TEST ("Check 2
     reads the citing file's name, never is_template_only()"), ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS
     ("A PROJECT-PATHS.md row may name a class; ### is three digits exactly"),
     ADR-US001-PROSE-DOCTRINE-VERIFICATION, and ADR-US003-CITATION-GATE-BASELINE-DIFF with the
     binding "Retires by its own terms when US004 lands — not superseded". The two US004 records
     went with the story to 03-SPRINT-PLAN-03.md; the BASELINE-DIFF binding is rewritten above
     because its retirement is no longer something this sprint can see. -->

### Gate honesty — the constraint specific to this sprint

**Neither gate this sprint leans on can fully read what this sprint writes, and the one that could
repair the third is a sprint away.** Three rules apply throughout, from `code/docs/GATE-REPORTING.md`:

- **`doctrine-drift.sh` is blind to US002 and prose-blind to US003.** Its scan roots exclude
  `code/src/scripts/**`, so it cannot open either file US002 edits — removed from that story's `QA`
  manifest and recorded `N/A` with its cause (`ADR-US002-BLIND-GATE-LEAVES-THE-FLAG`). For US003
  it reads fenced code only: a green run says the registered claims are undisturbed, including
  US003's new `owned` row, and says **nothing** about absence doctrine appearing in two homes. It
  is never reported as though it had.
- **`doc-references.sh` never reports a plain pass here, for either member.** Its repair is US004,
  in SPRINT-03, so every run this sprint makes is read as an identity diff against a baseline each
  member captures before its first edit. The survivors are named with their owners, and **both
  classes are this sprint's**: the forward references to `code/docs/ABSENCE.md` — three in US003's
  own artefact, and more in every record that has since named the guide — clear the moment US003's
  guide lands; the citations of `code/src/scripts/audits/SLOP-FAMILY.md` are US002's to disposition
  when it ships, and they will never resolve on their own, because the superseding ADR moved the
  target to `slop-family/CONTEXT.md`. **No tree-wide count is quoted in this plan.** The
  05/09/2026 figure in `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` predates this re-plan's edits to
  four sprint records, and a count is only comparable against a run in the same git-index state;
  the figure that matters is the one each member records by identity in its own
  `../18-TESTS/US###-MANUAL-TESTING.md`.
- **A baseline is only comparable against a run in the same git-index state.** US004's QA plan
  measured a 24-finding swing on this tree between the same bytes untracked and tracked, every one
  a `[template-only citation]`. Record the index state beside any figure, and do **not** silence the
  class with `doc-references: template-only` markers — the marker would be a lie the moment the
  files land.

<!-- Until 07/09/2026 this section opened "This sprint's subject is a gate, so it is the sprint
     most able to lie about one" and its first rule read: "doc-references.sh never reports a plain
     pass here. Findings survive US004 whatever it does, and they are tree-wide facts its run will
     meet, not SPRINT-02 members. Re-measured 05/09/2026: four citations of
     code/src/scripts/audits/SLOP-FAMILY.md — in ../02-STORIES/US004.md, ../03-SPRINTS/SPRINT-02.md,
     ../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md and this plan itself — every one
     owned by US002 in SPRINT-01. The code/docs/ABSENCE.md survivors left with US003 and are now
     SPRINT-03's; ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md carries them." Its second and third rules
     — "A fixture that passes both scripts proves nothing. Every new case is run against the
     pre-change script and must fail there" and "Measure by executing. Two claims in US004 made by
     reading the script were wrong, and both became AC-gaps" — were US004's and travelled with it.
     A nested comment recorded that the 02/09/2026 text had said "Six findings survive US004
     whatever it does — three citations of code/docs/ABSENCE.md belonging to US003, three of
     SLOP-FAMILY.md belonging to US002", and that both halves were wrong after US003's first move.
     Both survivor classes are this sprint's again since 07/09/2026, above. -->

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-02.md` → _Verification Checks_ and is not restated here.

- [ ] `doc-references.sh` — read as an identity diff against each member's recorded baseline, never
      as a pass; no shipped file either member writes or edits adds an unresolved citation of any
      class; every survivor named with the story that owns it
- [ ] `docs-length.sh --path code/src/scripts/audits --limit 1` — `code/src/scripts/audits/CONTEXT.md`
      at or under **230** counted lines and its sibling `CLAUDE.md` at or under **200** (US002);
      `code/docs/ABSENCE.md` under **270** at birth (US003); no file either member edits that
      already sits at or above 270 grows at all
- [ ] `docs-pairing.sh` — neither half of the audits pair carries the other's headings after US002's
      move, and `code/src/scripts/audits/slop-family/` carries both halves of its own; the gate exits
      0 today as well, so **which rules moved is recorded by hand**
- [ ] `doctrine-drift.sh` — US003's `owned` row green and no existing claim forked; recorded `N/A`
      with its cause for US002, and never reported as having checked either story's prose
- [ ] `routing-skills.sh` and `skill-conformance.sh` — **US003's alone**; every frontmatter name
      resolves and clause 14 is discharged for `backend`, `frontend`, `code-reviewer` and `refactor`
- [ ] `syntax/lint.sh` and `syntax/check.sh` pass
- [ ] US002's 27-row dry run into the shrunk register recorded, with the resulting figure; its
      before/after register inventory balances, deletion share and relocation share stated separately
- [ ] Both read-acrosses done — US002's of every new route against the section it names, US003's
      against the six `code/docs/data-structures/TYPES-*.md` files
- [ ] `doc-references.sh --self-test` — **N/A here since 07/09/2026**; it entered this plan with
      US004 and is the proof of a script this sprint no longer edits

<!-- Until 07/09/2026 this list read: "doc-references.sh — no finding of the three classes US004
     owns; every survivor named" · "doc-references.sh --self-test exits 0, probe count risen by one
     case per repair" · "US004's own gates run, and their output recorded" · "syntax/lint.sh and
     syntax/check.sh pass, including ShellCheck over the edited script" · "code/src/scripts/audits/CONTEXT.md
     is not grown — US002 owns that file's shape". The first four were US004's and went with it;
     the fifth is inverted, because the owner of that file's shape is now a member here and shrinks
     it. -->

---

## Sprint Definition of Done

- [ ] **US002 is Completed** — its own DoD complete, verified by a reviewer
- [ ] **US003 is Completed, or explicitly carried to SPRINT-03** with its reason recorded in
      `../03-SPRINTS/SPRINT-02.md` and mirrored in `../03-SPRINTS/SPRINT-03.md`, which reserves the
      5 SP from its side; a `Should` is never dropped silently, and **US003 has already moved
      twice** — out of this sprint on 05/09/2026 and back into it on 07/09/2026 — so a carry
      records all three moves. In the carry case the revision pass named under _Build order_
      revives, and only then
- [ ] All sprint-level verification checks passed
- [ ] No open HIGH/CRITICAL security findings — **N/A**, the sprint's Security flag reads `N/A`
- [ ] GDPR requirements implemented and verified — **N/A**, the GDPR flag reads `N/A`
- [ ] QA scenarios passing — manual for both members; this sprint ships no automated proof
- [ ] Both stories' implementation records written by `22-implementation-documentation`
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-02.md` `**Status:**` set to `Done`

<!-- Two rows replaced on 07/09/2026. The first read "US004 is Completed — its own DoD complete,
     verified by a reviewer"; US004 is SPRINT-03's. The second read: "No Should Have story remains
     here. US003 was this plan's stretch tier and moved to ../03-SPRINTS/SPRINT-03.md on
     05/09/2026, before either sprint was worked, with its reason recorded under Should above. It
     was not dropped and it was not silent." True from 05/09/2026 until 07/09/2026, when US003
     returned and the carry clause became live again — reserving into SPRINT-03 now rather than,
     as SPRINT-03's own clause did until today, into SPRINT-04. The row "QA scenarios passing —
     US004's self-test" and "US004's implementation records written" were rewritten for the two
     members above. -->

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story | Branch                           |
| ----- | -------------------------------- |
| US002 | `us002/audits-register-headroom` |
| US003 | `us003/absence-guide`            |

<!-- US003's branch row moved with the story to ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md on
     05/09/2026 — and returned with it on 07/09/2026, above. US004's row, us004/citation-gate-git-index,
     left for the same plan on 07/09/2026. -->
