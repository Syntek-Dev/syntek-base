# SPRINT-PLAN-06 — The seven register indexes are born seeded, and the map index leaves the file that ships

**Last Updated**: 03/10/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-06.md` · **Capacity:** 8 / 11 — 13 / 11 if US009's reserved carry lands · **Stories:** 1, plus one reservation

<!-- Written 03/10/2026 by a `16-sprint-plans` run. The title is US010's, the sole member, on the
     precedent ./03-SPRINT-PLAN-03.md set for a record with one member.

     OWED BY CALL, NOT BY FILL. The record stands at 8 / 11, under the fill trigger, and
     ../../docs/planning/CADENCE.md writes a sprint plan "the moment its sprint fills". This one
     is written because <%DEVELOPER_NAME%> ruled that this record's plan and SPRINT-07's are written
     once US010's security plans were signed off (settled 28/09/2026, 16-sprint-plans grilling
     round 1 Q1). The departure from CADENCE's order is recorded in ../03-SPRINTS/SPRINT-06.md ->
     Notes and in ../03-SPRINTS/SPRINT-07.md -> Notes, and is not re-argued here.

     THIS CHANGE TOUCHES THIS PLAN AND ../03-SPRINTS/SPRINT-06.md ONLY (settled 03/10/2026,
     16-sprint-plans grilling round 9 Q20). Story Plans below names what that leaves undone and
     who does it. SPRINT-07's plan follows in a change of its own.

     Both segments of this file's name read `06`, and that is an AGREEMENT rather than a
     coincidence: ./CLAUDE.md rules that a mismatch between `<exec-order>` and `<sprint-number>` is
     deliberate information and must NOT be "corrected", so a reader who knows that guardrail should
     also know this pair was derived and found to agree. _Build order_ below shows the derivation.
     The plan MIRRORS the record; where the two would disagree the record wins, and the
     disagreement is named here rather than resolved by paraphrase.

     TWO CITATION SERIES, NEVER CONFLATED. "settled DD/MM/YYYY, grilling round N QX" is the
     US010 / US011 gate-grilling series, as US010.md and the record write it; US011 cites the same
     rounds. "16-sprint-plans grilling round N QX" is this gate's series. Each series numbers its
     questions across its own rounds, so the same Q number recurs: US010's "grilling round 3 Q14"
     (27/09/2026) is not this gate's "round 4 Q14" (16-sprint-plans). Every citation below carries
     its date and its series. -->

---

## Sprint Goal

> Every register folder gains an index file of its own, born seeded and seed-once so no
> `copier update` can overwrite a filled one; the feature-map index is backfilled and leaves the
> `CONTEXT.md` that ships; and every shipped site still instructing the old index row stops doing
> so.

<!-- The record's `**Goal:**` line, verbatim, on ./02-SPRINT-PLAN-02.md's convention that a plan
     carries the record's goal rather than a paraphrase so the two cannot drift. The record derives
     it from US010's title and Client Summary and from slices `S-01` and the narrowed `S-02`; it
     holds no count, since gate 11 found twenty-four sites where the story had counted six. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** US010 carries `DB: N/A` and `User Flow: N/A`.
>
> The authorities this sprint defers to are `code/docs/GATE-REPORTING.md` for how a gate's result
> is reported, and the two US010 decision records under _Decisions binding this sprint_ for the map
> Status format and the rule an index uses to read a Status. `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`
> is the argued record of the register-index design, frontier empty since 31/08/2026, and is not
> re-opened here. Where the story's wording and those records differ, the records win.

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-06.md`                                                                                                                                                                                                                                                                                                                                               |
| User stories       | `../02-STORIES/US010.md` — the sole member. `../02-STORIES/US009.md` in the carry case only; it is SPRINT-05's stretch, reserved here and not a member                                                                                                                                                                                                                     |
| Feature maps       | `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slices `S-01` and the narrowed `S-02` (US010)                                                                                                                                                                                                                                                                                 |
| Database           | **N/A** — US010 reads `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                                                                                                                                                                                |
| User flows         | **N/A** — US010 reads `User Flow: N/A`; no user journey in scope                                                                                                                                                                                                                                                                                                           |
| Brand & components | **N/A** — US010 reads `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                                                                                                                                                                              |
| Wireframes         | **N/A** — US010 reads `Wireframes: N/A`; no screen                                                                                                                                                                                                                                                                                                                         |
| GDPR               | **N/A** — US010 reads `GDPR: N/A`; no personal-data path. The indexes list artefacts, never people                                                                                                                                                                                                                                                                         |
| Security           | **Live, two artefacts, both Signed off, corrected in place 28/09/2026:** `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` and `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md`. See _Sprint-wide Constraints_                                                                               |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — **Signed off** 30/09/2026, `Reviewed` from 27/09/2026, twenty-three gaps found, twenty-three resolved                                                                                                                                                                                                       |
| SEO                | **N/A** — US010 reads `SEO: N/A`; no public page                                                                                                                                                                                                                                                                                                                           |
| API design         | **N/A** — US010 reads `API: N/A`; no Django Ninja surface and no MCP tool                                                                                                                                                                                                                                                                                                  |
| Logging            | **N/A** — US010 reads `Logging: N/A`; no log line                                                                                                                                                                                                                                                                                                                          |
| Decisions          | **Three records bind this sprint** — two authored by US010 at `15-decisions` on 21/09/2026 and one inherited. Listed under _Sprint-wide Constraints_                                                                                                                                                                                                                       |
| **Story plans**    | **None exists for the member.** US010's prefix "10-" is reserved and not written; `17-story-plans` writes it. In the carry case: `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`, written 18/09/2026                                                                                                                                                                |
| Test records       | **None exists for the member.** Its manual testing guide lands under `../18-TESTS/MANUAL/`, authored by `17-story-plans` Step 7.2 from the specs straight after the story plan and committed with it; its test-status record lands under `../18-TESTS/AUTOMATED/`, written by `22-implementation-documentation`. Neither is cited here by filename, because neither exists |

**Every `N/A` above is a flag reading `N/A` in US010, not a gate anyone forgot** — the distinction
`code/docs/GATE-REPORTING.md` requires. Each skipped gate is recorded with its reason rather than
omitted.

**Eleven of the thirteen flags are `N/A`, and `Backend` is one of them although the member edits a
Python file.** That file is `.github/scripts/shipped-ai.py`, a template-only CI probe outside
`code/src/django/`, and `Backend` governs application code; the record says so in its FLAGS
comment. Security and QA are the two live flags.

### Prerequisites, gate by gate

`../../workflows/16-sprint-plans/STEPS.md` Step 1 asks each gate's artefact complete and committed,
read by its flag. Measured 03/10/2026:

| Gate             | US010 flag | State                                                                                                                                        |
| ---------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `15` Decisions   | —          | **Met.** Both US010 records read `Accepted`, committed with the story in `0c5e635` on 27/09/2026                                             |
| `09` GDPR        | `N/A`      | **N/A by flag**                                                                                                                              |
| `10` Security    | Live       | **Met, 28/09/2026.** Both plans committed in `0c5e635`, signed off on 28/09/2026 and committed as signed off in `90600c9`                    |
| `11` QA          | Live       | **Met, 30/09/2026**, when the plan was signed off; it had read `Reviewed` with no `[OPEN]` gap from 27/09/2026, which did not close the gate |
| `12` SEO         | `N/A`      | **N/A by flag**                                                                                                                              |
| `13` API design  | `N/A`      | **N/A by flag**                                                                                                                              |
| `14` Logging     | `N/A`      | **N/A by flag**                                                                                                                              |
| Story validation | —          | **Met.** Role/goal/benefit, MoSCoW, Gherkin, Dependencies, Tasks and an 8 SP estimate are all present in `../02-STORIES/US010.md`            |

**Three procedure texts are flag-blind, and each is read by its flag rather than as written.**
Step 1's security line, the workflow checklist's security box and
`../../docs/planning/CADENCE.md` -> _When a sprint plan is written_ ask for the security gate's work
of every story; CADENCE asks the same of GDPR. They are read by flag (settled 28/09/2026,
16-sprint-plans grilling round 1 Q2; the GDPR half by the call recorded 28/09/2026 at that gate).
Here the reading changes nothing for Security, whose flag is live, and spares GDPR, whose flag reads
`N/A`. **Gate `11` closes only when its plan reads `Signed off`**, as gate `10` does (settled
30/09/2026, 16-sprint-plans grilling round 3 Q9), a rule no procedure writes down yet. Nothing is
repaired here: one `GAPS.md` entry naming the three defects — the flag-blind Security and GDPR
prerequisites and the unwritten gate-`11` rule — is US010's gate-`22` work (see _Phase 4_).

**The ledger and the plan count the same 8, and the plan's count dates from 30/09/2026**, when
gate `11` closed last. `../../docs/planning/SPRINTS.md` -> _Capacity_ keeps the two numbers apart;
the record states both under _Notes_.

---

## Stories

### Must

| ID    | Title                                                                                    | Phases touched                                      | SP  | Story plan                                                          | Git branch                                             |
| ----- | ---------------------------------------------------------------------------------------- | --------------------------------------------------- | --- | ------------------------------------------------------------------- | ------------------------------------------------------ |
| US010 | The seven register indexes are born seeded, and the map index leaves the file that ships | Docs + copier seed seam + CI scripts — no code lane | 8   | _none yet — `17-story-plans` has not run for US010; "10-" reserved_ | _not yet set — fixed by its story plan's `Branch` row_ |

**8 SP committed against a capacity of 11.**

**US010 cannot take a demotion.** Its own MoSCoW comment rests the `Must` on a queue rather than an
urgency: six maps carry an unticked `Gate to stories` index-row box, five of them parked on this
slice shipping (measured 21/09/2026); a live `GAPS.md` entry of 01/09/2026 waits on it; and US011 in
SPRINT-07 has nothing to edit until the seven files exist. A slip here stalls all three.

<!-- Both Story plan and Git branch cells are deliberately unfilled. `17-story-plans` has not run
     for US010, and ./01-SPRINT-PLAN-01.md set the precedent for US007 on 07/09/2026, followed by
     ./04-SPRINT-PLAN-04.md for US006 on 08/09/2026 and ./05-SPRINT-PLAN-05.md on 17/09/2026: leave the cells as a stated absence, then fill them from
     the plan's own `Branch` row once that plan exists — taken from the plan, never invented here.
     The reserved prefix is written in double quotes, not backticks, because
     code/src/scripts/audits/doc-references.sh reads backticked tokens and a name that does not
     exist yet would be recorded as a citation that does not resolve. -->

### Should

_None committed._ **US009's 5 SP `Should` carry is reserved into this plan from SPRINT-05**, and
this section holds that reservation rather than a member. `../03-SPRINTS/SPRINT-05.md` ->
_Definition of Done_ reserves it here if US009 is dropped rather than delivered, and the record
holds it from this side.

**The all-`Must` weakness stands, and the reservation is its only contingent repair.** US010 alone is
a single all-`Must` member — the shape `../../docs/planning/SPRINTS.md` warns has no give, where the
first surprise breaks it. No other `Should` can be this record's give: US003's carry is reserved into
SPRINT-03, US009's is already reserved here and cannot be counted twice, and US011 at 8 SP would
stand this record at 16 / 11. Two futures, both recorded now rather than discovered later:

| If US009                                                | This plan stands at                    | Reading                                                                                         |
| ------------------------------------------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------- |
| completes in SPRINT-05, or is dropped after this closes | **8 / 11 SP**, all `Must`              | Inside capacity. The weakness stands, and this plan has no other give it can honestly hold      |
| is dropped from SPRINT-05 while this record is open     | **13 / 11 SP** — 8 `Must` + 5 `Should` | **At grace**, and the weakness is repaired: the carry is give that can slip again if US010 runs |

**The second is the better sprint, and it is SPRINT-05's close to trigger, not this plan's call to
take.** The 3 SP under capacity and the 2 SP of grace above it are together exactly US009's 5, and
the grace is held for that carry and for nothing else (<%DEVELOPER_NAME%>'s call at
`03-sprint-planning`, 20/09/2026). If US009 carries here, do not read the 13 as an overrun.
Whoever closes SPRINT-05 makes the call and records it in both records and in
`../02-STORIES/US009.md`.

**A landed carry re-opens this plan.** It is revised in the same change that admits US009, never
left describing a one-member sprint that now has two (`../03-SPRINTS/SPRINT-06.md` ->
_Definition of Done_). That change also swaps two story-plan prefixes; see _Build order_.

### Could

_None._

### Won't (this sprint)

- **`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slice `S-03`** — the index gate, `N-003` and
  `N-004`. It ships after US011, not after this sprint alone: `N-003`'s presence clause has no
  debt-line clause, so run before US011 it is red on the four indexes this sprint ships declaring
  their own debt. `../02-STORIES/CUT-PLAN.md` P8 (27/09/2026) leaves it `Proposed` with no sprint.
  Sequencing, not omission.
- **The same map's slice `S-04`** — artefact frontmatter across `project-management/src/`. Uncut,
  and in no record.
- **Slice `S-05`, which is US011** — backfilling the four indexes this sprint ships declared but
  empty. It is SPRINT-07's stretch tier and is **blocked by this sprint**. At 8 SP it would stand
  this record at 16 / 11, over grace, and is refused on arithmetic before it is argued.
- **TM-14's seed-if-absent update migration and TM-18's guard refusing an existing target.** Each is
  a second `copier.yml` decision, the trigger that would take US010 to 13 and back to
  `01-feature-map`. US010 documents both hazards in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` and
  routes both complete fixes to `GAPS.md` through gate `22` (settled 27/09/2026, grilling round 3
  Q15).
- **The memory-survival probe's identical blind case** — `.github/scripts/shipped-ai.py`'s second
  tag never changes the memory seed. Routed to `GAPS.md` through gate `22`, not built (settled
  27/09/2026, grilling round 3 Q16).
- **Repairing the sprint-plan prerequisites.** Writing the one `GAPS.md` entry is US010's
  gate-`22` work and is in scope; repairing `../../workflows/16-sprint-plans/STEPS.md`, its
  checklist and `../../docs/planning/CADENCE.md` is not (settled 28/09/2026, 16-sprint-plans
  grilling round 1 Q2, the GDPR half by the call recorded 28/09/2026 at that gate; settled
  30/09/2026, 16-sprint-plans grilling round 3 Q9, the routing of that rule here accepted, settled
  30/09/2026, 16-sprint-plans grilling round 5 Q16).
- **The TM-10 window's `GAPS.md` entry** — written at US011's gate-`22` pass, when the window from
  US011 shipping to `S-03`'s cut opens, not at US010's (call recorded 27/09/2026 with US010's
  grilling round 6).
- **Admitting another story.** The 3 SP of headroom belong to the reservation. Anything arriving is
  refused on arithmetic: a second 8 SP `Must` would stand this record at 16 / 11.

---

## Build order — this sprint sixth, US010 tenth, and both name segments read `06`

**This plan takes execution order `06`, and the number was derived rather than copied.** The member
has no blocking upstream dependency:

| Member | Blocked by                                                                                                                                 | In  | Built at |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------ | --- | -------- |
| US010  | Nothing — `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` records `Frontier open: 0 · Blocking open: 0`, and its deadlock ruling names `S-01` | —   | —        |

Every earlier sprint's members are built at `01` to `05`, and SPRINT-05's last member is US009,
ninth across the backlog. US010 builds tenth. **Its place is arithmetic, not a blocker**, stated so
that nobody goes looking for one. Honouring the dependency chain and honouring the sprint number
give the same answer, so both segments read `06`; a reader who finds `06` on both should know it
was checked rather than assumed.

**US010 does not block on US004**, on the reasoning SPRINT-04 recorded for US006 and SPRINT-05 for
US008. The citation-gate regime under _Decisions binding this sprint_ is a reporting rule — "A story
cannot be blocked on a gate it is forbidden to repair" — and sequences nothing.

**Four adjacencies are ordered rather than blocked**, each a rebase and never a wait (re-measured
21/09/2026 and 27/09/2026 against the widened write set, per `../02-STORIES/US010.md` ->
_Dependencies_):

- **US012 (SPRINT-07)** edits `.github/scripts/shipped-artefacts.sh`'s check 4 and the comment above
  `SEEDED`, which US010 rewrites too. Build order expects US010 first, but the landing order is not
  fixed: whichever lands second extends the other's wording (`../02-STORIES/CUT-PLAN.md` P9,
  27/09/2026, which lifted the two sessions' holds and fixed no order).
- **US009 (SPRINT-05)** adds a grep inside the same `[3/4]` job of
  `.github/workflows/audit-template.yml`.
- **US008 (SPRINT-05)** adds rows to `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` and edits
  `../../workflows/24-release/CHECKLIST.md`, neither on a line US010 repairs.
- **US015**, provisional and unplaced, edits other lines of three guide files US010 corrects. US010
  merges first and US015 rebases (settled 27/09/2026, grilling round 3 Q14).

**US010 unblocks US011, and that edge is hard.** US011 backfills four index files this sprint
creates and has nothing to edit until they exist. `../03-SPRINTS/SPRINT-07.md` records it from the
other side, and both stories name it, so a later reader cannot re-merge the two halves of a slice
split at `02-story-creation`.

### The carry case swaps two prefixes

**If US009's carry lands, the intra-sprint order is US010 then US009**: the `Must` builds first, on
`../../docs/planning/CADENCE.md`'s one-story-at-a-time rule and the precedent
`./05-SPRINT-PLAN-05.md` set for US008 ahead of US009.

**That reorders the backlog, so two story-plan prefixes swap.** US010 would build ninth and US009
tenth, so US010's plan takes "09-" in place of the reserved "10-", and US009's plan, on disk as
`../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`, is renumbered to "10-". The plans, their
rows in `./05-SPRINT-PLAN-05.md` and in this plan, and every citation of them move in the same change
that admits US009 (`../../workflows/17-story-plans/STEPS.md` Step 2 -> _Renumber when build order
changes_). **This plan's own name does not move**: SPRINT-05 keeps US008 and still builds before
this sprint, so the sprint-level order is unchanged. The record's "US009 builds ninth and US010
tenth" is the no-carry reading.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. **The member's plan does
not exist yet.** The reserved-carry row points at a plan that does, so whoever takes the carry finds
it from this index; it is not a membership claim.

| Story                  | Story plan (`../17-STORY-PLANS/`)                                                                                               | Status              |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| US010                  | _no file — the prefix "10-" is reserved, tenth in the settled build order; written by `17-story-plans`, which has its own gate_ | _no plan to mirror_ |
| US009 — reserved carry | `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`                                                                          | Not started         |

The run on disk is contiguous `00-` to `09-`, measured 03/10/2026. **The prefix is the story's
position in the settled build order across the whole backlog, not its sprint and not a per-sprint
counter**, and it is renumbered whenever that order changes; `../17-STORY-PLANS/CLAUDE.md` owns that
rule. **That is the opposite of the rule governing this file's own name**: a sprint plan carries two
numbers and a mismatch between them is information, while a story plan carries one, so its prefix
must track build order or it says nothing. Do not read either guardrail across to the other folder.

<!-- 03/10/2026 — THE STATUS COLUMN, AND THE POPULATION IT JOINS. The table takes the house shape
     the five live sprint plans use. The column follows ./05-SPRINT-PLAN-05.md's definition and is
     not restated here.

     THE US010 ROW IS A NO-FILE ROW and adds no cell to the population, on the convention
     ./01-SPRINT-PLAN-01.md set for US007 on 07/09/2026 and ./04-SPRINT-PLAN-04.md followed for
     US006 on 08/09/2026: there is no plan for the cell to mirror. ./05-SPRINT-PLAN-05.md is not a
     precedent for it, its rows of 17/09/2026 having held reserved prefixes in a table with no
     Status column. When `17-story-plans` Step 10 writes the plan, it replaces the reserved-prefix
     cell with the path and fills the Status cell as this section defines the column, and the row
     then joins the population.

     THE US009 ROW READS "Not started" BY DESIGN, and the value is KNOWINGLY FALSE: it is a value in
     no status set anywhere in this repository, and the plan it points at carries `Open` in its own
     `| Status |` header row, which is NOT mirrored here. It takes that value on the rule
     ../02-STORIES/US007.md Scenario 8 states — "re-counted immediately before the edit, a plan
     written between now and then joining the population and taking the same rule".
     ./03-SPRINT-PLAN-03.md's verbatim mirror of `Open` on its reserved-carry row is the second
     live convention and is deliberately NOT followed; the template's legend
     {Draft / Ready / In Progress / Done} is a fourth vocabulary and is not used either.

     THIS ROW ADDS TO THE POPULATION SCENARIO 8 COUNTS, flagged so the addition is not silent.
     RE-COUNTED 03/10/2026 across the five live sprint plans, immediately before this edit: EIGHT
     `Not started` cells — US007 and US001 in ./01-SPRINT-PLAN-01.md, US002 and US003 in
     ./02-SPRINT-PLAN-02.md, US005 and US006 in ./04-SPRINT-PLAN-04.md, US008 and US009 in
     ./05-SPRINT-PLAN-05.md. This cell is the NINTH, and the second to point at US009's plan. The
     story owner re-counts before their own edit rather than inheriting this figure.
     ../02-STORIES/US007.md is NOT edited by this pass. -->

### What this change leaves undone, and who does it

- **US010's reservation is not yet recorded in the story.**
  `../../workflows/17-story-plans/STEPS.md` Step 2 records a reserved number in the story that owns
  it as well as in the sprint plan's index. `../02-STORIES/US011.md` and `../02-STORIES/US012.md`
  record theirs; `../02-STORIES/US010.md` does not, measured 03/10/2026. The row above and
  `../03-SPRINTS/SPRINT-06.md` -> _Dependencies_ carry the reservation meanwhile, and **US010's
  story-plan commit records it**, when Step 10 item 3 references the plan in the story. This change
  does not edit the story (settled 03/10/2026, 16-sprint-plans grilling round 9 Q20).
- **`17-story-plans` runs after both sprint plans, for US010, US012 and US011** — once SPRINT-07's
  plan is committed in a change of its own after this one, because that workflow's Step 1 gathers
  the sprint plan first (settled 28/09/2026, 16-sprint-plans grilling round 1 Q4;
  `../03-SPRINTS/SPRINT-07.md` -> _Notes_ records the same order for that record's two members). **Each story's manual testing guide is written
  straight after its plan, at Step 7.2, and committed with it**: US010's plan and guide in one
  change and US012's in the next, both after one round of that workflow's grilling, then US011's
  plan and guide once US010's plan is committed (settled 03/10/2026, 16-sprint-plans grilling
  round 9 Q22).

---

## Phase Breakdown

**The member does not enter a code lane.** The four-phase backend -> API -> frontend -> PR sequence
in `../../docs/planning/SPRINTS.md` maps stories by the layers they touch, and US010 touches none of
them. The phases are recorded as `N/A` with a reason rather than deleted, per
`code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**N/A** — no model, service, migration or business logic. US010 reads `Backend: N/A`. Its one Python
edit is the CI probe `.github/scripts/shipped-ai.py`, outside `code/src/django/`.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema, and no MCP tool. US010 reads `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. US010 reads `Frontend: N/A`.

### The lane this story actually runs in

| Story | Deliverable                                                                                                                                                                                                                                                                                                                                                            | Proven by                                                                                                                                                                                                                                                    |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| US010 | Seven in-tree index files, one feature-map index backfilled; seven `.copier/` seeds moved by seven lines inside the existing copy-gated seed task; the seed allowlist grown; a third seed family in `.github/scripts/shipped-registers.sh` and an update probe in `.github/scripts/shipped-ai.py`; every map's Status header; every shipped instruction site repointed | The `shipped-artefacts.sh`, `shipped-registers.sh` and `shipped-ai.sh` self-tests, the `[3/4] Template Generation` job on every render path the template offers, and the manual walk-throughs — row by row, enum derivation, and every repaired site re-read |

**The manual checks are load-bearing, not ceremonial.** An index row's Summary is prose written for a
human, and no script can judge whether one line of plain English describes a map to someone who has
not read it; that bar is `N-002`'s. The task-level list is `../03-SPRINTS/SPRINT-06.md` -> _Tasks_.

**The automated update probe is trusted only once it has been seen to fail.** A probe whose
template leaves the seeds unchanged cannot see an index silently reverted by an update (TM-04), so
the update probe in `.github/scripts/shipped-ai.py` changes every index seed between its two tags and
must be seen red with the copy gate removed before it is trusted green.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

US010 alone, behind no blocker. `22-implementation-documentation` runs between the lane above and
this phase and is a merge gate. It writes the story's test-status record under
`../18-TESTS/AUTOMATED/` and walks its manual testing guide under `../18-TESTS/MANUAL/` — the guide
`17-story-plans` authors from the specs before code, straight after the story plan and committed with
it. And it owns this sprint's register writes, as the sole writer of `GAPS.md`:

- **One closure** — `GAPS.md`'s 01/09/2026 entry on the `CONTEXT.md` index-row instruction, which
  this story claims, closed against the shipped change and dated the day it closes.
- **Four openings, each dated the day gate `22` writes it** — TM-14's seed-if-absent migration,
  TM-18's guard, the memory-survival probe's blind case, and the one entry naming the three
  sprint-plan prerequisite defects. None is backdated to the day its answer was settled.

The TM-10 window's entry is not among them: it is US011's to write (see _Won't_).

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in the story's acceptance criteria and the spec it
cites.

### GDPR (`../09-GDPR/`)

**N/A.** US010 reads `GDPR: N/A`. No personal data is collected, stored, exported or logged; the
indexes name artefacts, never people, and no seed may name a syntek-base instance.

### Security (`../10-SECURITY/`)

**Live, two artefacts, and no `CRITICAL` or `HIGH` — signed off on 28/09/2026, five days before this
plan was written.** Eighteen threats across all six STRIDE categories, seventeen from the `security`
skill's pass and TM-18 from the independent pass: **0 CRITICAL, 0 HIGH, 4 MEDIUM, 12 LOW, 2 INFO**,
re-counted 03/10/2026 from the threat model's STRIDE table. Both plans read `Signed off`, each
corrected in place on 28/09/2026; the correction moved no finding, severity or constraint, and no
Section 3a promotion trigger has fired. Nothing was written to `../10-SECURITY/VULNERABILITIES/PLANNING/`.

**That zero is a measured outcome with its reason, never "the security gate passed".** Every threat
resolves to `MEDIUM` or below _because no index seed exists yet, no generated project holds an
index, the chain is copy-gated on update today, and this repository has one developer_. The threat
model's Section 3a names the event that promotes each — bar TM-10, whose trigger was retired
27/09/2026 (grilling round 3 Q21; call recorded 27/09/2026 with round 6) — and **three promote to
`HIGH`**: TM-01, TM-03 and TM-04.

Three findings shape what this sprint builds:

- **TM-01 and TM-04 — seed-once, and a probe that can fail.** A seed line outside the copy gate
  stops the file being seed-once, and what follows depends on nothing anyone controls: a filled
  index quietly restored, merged in silence, or left with conflict markers. Nothing today would
  notice, and the obvious probe cannot fail, because a template that never changes a seed passes
  whether or not the gate exists. So every line sits inside the one existing chain, ahead of its
  `rmdir`, in the chain's one-line form, and the update probe changes every index seed between its
  two tags and must be seen red with the gate removed. TM-01 promotes to `HIGH` when the chain is next
  split, reordered or given a second task, in a release a filled project updates across; TM-04 when
  the first generated project fills an index.
- **TM-02 — the leak the generated-tree check cannot see.** A negation in `_exclude` re-including an
  index path leaks this repository's rows, and the check that reads a generated tree admits a
  seeded path by name. It holds at `MEDIUM` only while the glob-matched no-negation clause closes
  it.
- **TM-03 — a seed cut from a populated in-tree index is a one-way door.** Its rows would ship to
  every project generated afterwards, so emptiness is proved by a check, never trusted. It promotes
  to `HIGH` when a seed is refreshed from its in-tree sibling after US011 has written rows there.

**Two real hazards are documented here and fixed elsewhere.** TM-14, a project generated before this
story receiving the routes but never the files, and TM-18, `copier recopy` moving a blank seed over a
filled index, are written into `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` by US010; their complete
fixes are routed through gate `22` (settled 27/09/2026, grilling round 3 Q15), and each promotes to
`MEDIUM` on its trigger.

### QA (`../11-QA/`)

**Twenty-three acceptance-criteria gaps — three blocking, fourteen material, six minor — and all
twenty-three are `[RESOLVED] 27/09/2026`**, each fed back into the story or the record. AC-GAP-2 was
the last (settled 27/09/2026, grilling round 7 Q34). `../11-QA/PLANNING/CLAUDE.md` gates a sprint
plan on exactly this, and the gate is satisfied rather than waived.

**Gate `11` closed on 30/09/2026**, when <%DEVELOPER_NAME%> signed the plan off. It had read
`Reviewed` since 27/09/2026, and a `Reviewed` plan does not close the gate (settled 30/09/2026,
16-sprint-plans grilling round 3 Q9).

**The QA union names unit, integration and manual**, and the record's QA row is US010's own, verbatim:
the reservation contributes nothing to it until it lands. In the carry case the record recomputes the
union in the change that admits US009: QA gains that story's subjects and no new type, and Security
its supply-chain subject.

### SEO (`../12-SEO/`)

**N/A.** US010 reads `SEO: N/A`. No public page, route or metadata surface is added or changed.

### Decisions binding this sprint

| ADR                                                                                     | Authored at           | What it binds                                                                                                                                                                 |
| --------------------------------------------------------------------------------------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`                  | `15-decisions`, 21/09 | A map's Status header is one of five plain values, any prose after the first middle dot; every live map re-derived by measurement against the map's own counts                |
| `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`                        | `15-decisions`, 21/09 | One rule for reading any register's Status into an index row, across all seven registers; US011 applies it and `S-03` inherits it                                             |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` | Inherited, 30/09      | A red `doc-references.sh` is read as a diff against a baseline captured before the first edit. It supersedes the 02/09/2026 record and restates it unchanged but for one path |

**All three read `Accepted`, measured 03/10/2026.** Both US010 records were written `Proposed` on
21/09/2026 and accepted after an independent review, before the US010 commit `0c5e635` of
27/09/2026 (settled 27/09/2026, grilling round 4 Q27 to Q29).

**One decision is declined on the record and two records do not bind.** The four incomplete indexes
ship declaring their own debt, with no ADR (settled 21/09/2026, grilling round 2 Q10), on reasons
US010 -> _Decisions_ states. `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
reads `Superseded`, and only its successor binds.
`../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` reads `Proposed`; its
sign-off is the read-rule record's Follow-on, and it binds nothing here.

### Gate honesty — the constraint specific to this sprint

`code/docs/GATE-REPORTING.md` applies to every sprint; four readings are specific to this one and
must not be softened in any record it produces.

- **The whole-tree citation gate is read as a baseline diff, never as a pass.** The baseline is
  captured before the first edit, with HEAD and the index state beside it. If US004 has landed and
  the gate has gone green, the plain-pass reading applies; both branches are named in the record.
- **ShellCheck and the `shipped-ai.py` lint are recorded as run or as not run**, never as a
  `lint.sh` pass. `lint.sh`'s legs are ruff, markdownlint-cli2, ESLint and clippy, and none reads
  either script.
- **`check.sh` is regression only.** Its type-check leg reads `code/src/django/` alone, and this
  sprint's one Python edit sits outside it.
- **`doctrine-drift.sh` says nothing about the indexes agreeing with their registers.** A green run
  means the registered claims are undisturbed, and is never reported as though it meant more.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, `pnpm`, `uv` or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-06.md` -> _Verification Checks_ and is not restated here.

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test` exits 0 with the enlarged allowlist —
      proving the seeds are not reported as leaks, never that they landed
- [ ] `bash .github/scripts/shipped-registers.sh --self-test` and
      `bash .github/scripts/shipped-ai.sh --self-test` exit 0, every new probe seen red before it is
      seen green, the seed-row probe among them
- [ ] The `[3/4] Template Generation` job is green on every render path the template offers, all
      seven index files present in each generated tree
- [ ] `doc-references.sh` — read per _Gate honesty_. The record's own scoped figures are dated
      20/09/2026, at HEAD `53d9196` with that change staged, and are not current; the criterion is
      that the record's `dangling` count stays at 0, re-measured in a stated index state
- [ ] `docs-length.sh` — the seven `CONTEXT.md` files under `project-management/src/` and the
      `project-management/workflows/` files the site repair edits stay clear of the 270 ratchet
      without a dated allowance
- [ ] `docs-pairing.sh` passes — more than regression here: an index file must not be mistaken for
      either half of a pair
- [ ] `doctrine-drift.sh` — regression only, per _Gate honesty_
- [ ] `syntax/lint.sh` passes over what it reads, and ShellCheck and the probe's lint are recorded as
      run or not run
- [ ] `syntax/check.sh` passes — regression only
- [ ] `tests/all.sh` is green as a regression — the coverage floor has nothing to bind, the sprint
      adding no application Python
- [ ] `migrate.sh check`, `routing-skills.sh`, template and component tests, and the WCAG 2.2 AA
      walk-through — **N/A**, the member touches no model, adds no routing frontmatter and renders no
      surface
- [ ] US010's manual walk-throughs are recorded in its manual testing guide under
      `../18-TESTS/MANUAL/`, and a tester other than the author has signed them off
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] All security acceptance criteria signed off — **applies**, Sections 7.1 to 7.8 and 7.13 to
      7.15 of the assessment
- [ ] GDPR, Logging and SEO criteria — **N/A**, each flag reads `N/A`

---

## Sprint Definition of Done

- [ ] **The `Must` story is Completed — US010.** Its story plan's own DoD complete and verified by a
      reviewer, once `17-story-plans` has written that plan under "10-", or "09-" in the carry case
- [ ] **The carry-over question is disposed of in writing, either way.** If US009 carried here, it is
      Completed here or carried on again with its reason recorded in both records and in
      `../02-STORIES/US009.md`, and this plan was revised in the change that admitted it. If it did
      not carry, that is stated rather than left as an unexplained 8 / 11
- [ ] **The carry's deadline is the record's close.** If US009 is still undecided then, the close
      waits on that decision or the reservation is released in writing
- [ ] **US011 is unblocked, confirmed rather than assumed**: the four indexes it backfills exist and
      carry their `Backfill owed — US011` line
- [ ] All sprint-level verification checks passed
- [ ] **No open Critical or High security finding.** Zero of each at present state, as signed off on
      28/09/2026; at design state TM-01, TM-03 and TM-04 read `HIGH` (the threat model's Section
      3a). Any finding whose promotion trigger fired during the sprint is re-assessed in
      `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at its present-state severity
- [ ] No `[OPEN]` gap remains in the member's QA plan — twenty-three resolved on 27/09/2026, none
      reopened
- [ ] GDPR constraints implemented and verified — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] US010's implementation records written by `22-implementation-documentation`: `GAPS.md`'s
      01/09/2026 entry closed, and the four entries routed to that gate opened, each dated the day it
      is written — never backdated
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-06.md` `**Status:**` set to `Done`
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-06.md` (optional) — **and one subject
      is named in advance**: this plan and SPRINT-07's were written by call under the fill trigger,
      a departure from `../../docs/planning/CADENCE.md`'s order that both records note

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story                   | Branch                                                                           |
| ----------------------- | -------------------------------------------------------------------------------- |
| US010                   | _not yet set — fixed by its story plan's `Branch` row_                           |
| US009 — carry case only | `us009/hook-arming` — the `Branch` row of US009's story plan, written 18/09/2026 |

Neither is invented here. `17-story-plans` sets each, and this table is filled from the plan when it
exists — the precedent `./01-SPRINT-PLAN-01.md` set for US007 on 07/09/2026.

**The branch is cut from `main`, and not yet**, on the reasoning `./01-SPRINT-PLAN-01.md` recorded
on 02/09/2026. Every planning artefact US010 depends on — the story, its threat model, assessment
and QA plan, both ADRs, the record and this plan — sits on `pm/story-creation`, which is not merged
to `main`. The sequence is: every story completes its planning workflows -> `pm/story-creation` is
raised as a PR to `main` -> the `us###/` branches are cut from `main` and the stories implemented.
