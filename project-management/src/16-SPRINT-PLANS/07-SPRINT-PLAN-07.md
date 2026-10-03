# SPRINT-PLAN-07 — A seed that fails to land is reported, and the four indexes that shipped declaring their debt are backfilled

**Last Updated**: 03/10/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-07.md` · **Capacity:** 2 SP Must + 8 SP Should = 10 / 11 — inside capacity, the 1 SP of headroom left unpadded, **CLOSED** to admission by call on 21/09/2026 · **Stories:** 2

<!-- Written 03/10/2026 by a `16-sprint-plans` run, in a change of its own (settled 28/09/2026,
     16-sprint-plans grilling round 1 Q1, which ruled that both this plan and SPRINT-06's are
     written and set no order between them), and committed after
     ../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md. The record was closed by call at 10 / 11 on 21/09/2026, and the close, not a fill, owes
     this plan (../03-SPRINTS/SPRINT-07.md -> Notes; ../02-STORIES/CUT-PLAN.md P6). It waited on its
     members' gate documents: both QA plans were committed on 27/09/2026 and signed off on
     30/09/2026, when gate 11 closed for each (settled 30/09/2026, 16-sprint-plans grilling round 3
     Q9), and gate 10 owes neither member an artefact, Security being read by its flag (settled
     28/09/2026, 16-sprint-plans grilling round 1 Q2). So this plan is written AFTER every
     prerequisite holds, which ../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md was not.

     STEP 0 drew its round from the recorded answers (.claude/skills/grilling/SKILL.md -> A decision
     already recorded is a fact). The residue went to <%DEVELOPER_NAME%> as round 9 of the
     16-sprint-plans grilling and was answered on 03/10/2026: Q21, that US012 owes a manual testing
     guide, and Q22, that each guide is written straight after its story plan and committed with
     it. Q20 bound SPRINT-06's change and left this record's stale passages to this one.

     Both segments of this file's name read `07`, and that is an AGREEMENT rather than a
     coincidence: ./CLAUDE.md rules that a mismatch between the exec-order prefix and the
     sprint-number suffix is deliberate information and must NOT be "corrected", so a reader who
     knows that guardrail should also know this pair was derived and found to agree. _Build order_
     below shows the derivation. The plan MIRRORS the record; where the two would disagree the
     record wins, and the disagreement is named here rather than resolved by paraphrase. One is
     named, under _Sprint Definition of Done_. -->

---

## Sprint Goal

> A seeded file that fails to land in a generated project is reported by the template-integrity
> gate rather than silently tolerated, and the gate's header stops claiming a coverage it lacks; and
> the four indexes that shipped declaring their own debt are backfilled — every story, sprint,
> decision and story plan carries a row with its own status mirrored verbatim and a summary written
> for someone who has not opened it — while the `.copier/` seeds stay blank.

<!-- The record's `**Goal:**` line, verbatim, on ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md's
     convention that a plan carries the record's goal rather than a paraphrase so the two cannot
     drift. It is written in build order — US012 then US011 — for a sprint whose two members come
     from two epics, Script Guards and Register Indexes, and meet at the seeds: one asserts they
     land, the other that they land blank. The record rewrote it on 21/09/2026 when US012 was
     admitted. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`.
>
> The authorities this sprint defers to are `code/docs/GATE-REPORTING.md` for how a gate's result
> is reported, `.claude/CLAUDE.md` Section 6 for the script-first rule that keeps every
> generated-tree run in CI, and — for US011's status column —
> `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`, the one read rule every
> register's `Status` is mirrored under. `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` node `N-005` and
> `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` node `N-006` are the argued record of each slice and
> are not re-opened here. Where a story's wording and those guides differ, the guides win.
>
> **This sprint has a hard upstream edge that no member owns.** US011 edits four files that do not
> exist until US010 ships them, and US010 is SPRINT-06's member. See _Build order_ below; the edge
> is a Definition of Done row, never a cleared dependency.

## Sprint Reference Documents

| Area                      | Source                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition         | `../03-SPRINTS/SPRINT-07.md`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| User stories              | `../02-STORIES/US012.md` and `../02-STORIES/US011.md`, in build order                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Feature maps              | `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-02` (US012) and `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slice `S-05` (US011)                                                                                                                                                                                                                                                                                                                                                                                |
| Upstream sprint           | `../03-SPRINTS/SPRINT-06.md`, planned by `../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` — its member US010 creates the four index files US011 fills, and grows the `SEEDED` array US012's loop reads                                                                                                                                                                                                                                                                                                                     |
| Database                  | **N/A** — both read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| User flows                | **N/A** — both read `User Flow: N/A`; no user journey in scope                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Brand & components        | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Wireframes                | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| GDPR                      | **N/A** — both read `GDPR: N/A`; no personal-data path. US011's rows name artefacts, never people                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Security                  | **N/A by flag, both members, each for a reason of its own** — no artefact under `../10-SECURITY/` is owed for either (settled 28/09/2026, 16-sprint-plans grilling round 1 Q2). US010's two signed-off plans, `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` and `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md`, are the only security artefacts naming either member, and overturn neither `N/A`. See _Sprint-wide Constraints_ |
| QA                        | `../11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` — **Signed off** 30/09/2026, `Reviewed` from 21/09/2026, nine gaps found, nine resolved; `../11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md` — **Signed off** 30/09/2026, `Reviewed` from 27/09/2026, thirteen found, thirteen resolved                                                                                                                                                                                                            |
| SEO                       | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| API design                | **N/A** — both read `API: N/A`; no Django Ninja surface and no MCP tool                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Logging                   | **N/A** — both read `Logging: N/A`; no log line. Check 4's finding prints to the `[3/4]` job's output, which is a report and not a log                                                                                                                                                                                                                                                                                                                                                                              |
| Decisions                 | **Two records bind, one inherited and one US010's; neither member authors one.** Listed under _Sprint-wide Constraints_                                                                                                                                                                                                                                                                                                                                                                                             |
| **Story plans**           | **Neither exists.** Two names are reserved under `../17-STORY-PLANS/` and are written by `17-story-plans` after this plan — see _Story Plans — the code master_                                                                                                                                                                                                                                                                                                                                                     |
| **Manual testing guides** | **Neither exists, and both are owed.** Each is authored under `../18-TESTS/MANUAL/` by `17-story-plans` Step 7.2, from the specs and before any code, straight after its story plan and committed with it (settled 03/10/2026, 16-sprint-plans grilling round 9 Q21 and Q22). The automated record under `../18-TESTS/AUTOMATED/` is written at `22-implementation-documentation`                                                                                                                                   |

**Every `N/A` above is a flag reading `N/A` in both stories, not a gate anyone forgot** — the
distinction `code/docs/GATE-REPORTING.md` requires. Each skipped gate is recorded with its reason
rather than omitted.

**Twelve of the thirteen flags read `N/A` in both members, and `QA` is the only gate that runs.**
`Backend` reads `N/A` in both, and both still write executable change — US012 one bash script, US011
one grep step in a CI workflow. The flag names the Django surface, not whether code is written, so
the lane each story runs in is stated under _Phase Breakdown_ rather than inferred from it.

**This plan is written after every prerequisite closed, not before them.** Gate `11` closed for both
members on 30/09/2026, when <%DEVELOPER_NAME%> signed both QA plans off; a `Reviewed` plan does not
close it (settled 30/09/2026, 16-sprint-plans grilling round 3 Q9). Gate `10` owes neither member an
artefact. Gate `15` holds for both: US012 records no decision, and US011's one candidate is
subsumed by the read-rule record, `Accepted` and committed in `0c5e635` on 27/09/2026. So the count
this plan is written on — both members, 10 SP — is honest from 30/09/2026, the date
`../03-SPRINTS/SPRINT-07.md` -> _Notes_ gives it, and the plan follows that date rather than
preceding it.

---

## Stories

### Must

| ID    | Title                                                                                | Phases touched                          | SP  | Story plan                                                                                     | Git branch                                             |
| ----- | ------------------------------------------------------------------------------------ | --------------------------------------- | --- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| US012 | A seeded file that never lands is reported, and the gate's header claim becomes true | Script + header contract — no code lane | 2   | _none yet — "11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md" reserved, written by `17-story-plans`_ | _not yet set — fixed by its story plan's `Branch` row_ |

### Should

| ID    | Title                                                                                                    | Phases touched                                 | SP  | Story plan                                                                                          | Git branch                                             |
| ----- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------- | --- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| US011 | The four indexes that shipped blank get a row per instance, and each register stops claiming it is empty | Markdown backfill + one CI grep — no code lane | 8   | _none yet — "12-STORY-PLAN-US011-REGISTER-INDEX-BACKFILL.md" reserved, written by `17-story-plans`_ | _not yet set — fixed by its story plan's `Branch` row_ |

<!-- 03/10/2026: both Story plan and both Git branch cells are deliberately unfilled.
     `17-story-plans` has not run for either member, and ../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md
     set the precedent for US007 on 07/09/2026, followed by ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md
     for US006 on 08/09/2026 and by ../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md, written
     on 17/09/2026 with both cells unfilled and filled at Step 10 on 18/09/2026: leave the cells as
     a stated absence, then fill them at that workflow's Step 10 from
     the plan's own `Branch` row once the plan exists — taken from the plan, never invented here.
     The reserved names are written in double quotes rather than backticks because
     code/src/scripts/audits/doc-references.sh reads backticked tokens, comments included, and a
     plan name with no file behind it is a citation of something that does not exist. Each
     descriptor matches its story's QA plan, as every existing pair does. Titles are the record's
     Story Summary cells, verbatim. -->

**Total: 10 SP against a capacity of 11 — 2 committed, 8 stretch, inside capacity, and CLOSED to
further admission.** Rows are in build order, US012 then US011. The 1 SP of headroom is not padded:
nothing coming fits it, which is the reason <%DEVELOPER_NAME%> gave for the close on 21/09/2026, and
`../03-SPRINTS/SPRINT-07.md` -> _Notes_ carries the arithmetic this plan mirrors rather than
restates.

**The `Must` is small beside the stretch, and that is a correct shape rather than a thin one.**
`../../docs/planning/SPRINTS.md` -> _MoSCoW_ asks for at least the `Must` tier and warns only
against a plan in which everything is `Must`. Each priority is its member's own and is not
re-derived here: US012's `Must` was settled in the MAP-SCRIPT-GUARDS interview round of 21/09/2026
(Q2) and kept on its narrowed rationale in that day's follow-up round (Q3); US011's `Should` was
settled at cutting and declined for relabelling twice, the second time on 27/09/2026 (US010 / US011
gate grilling, round 3 Q19).

### Could

_None._

### Won't (this sprint)

- **`../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` slice `S-03` — the index gate.** It follows US011
  and is unscheduled: `N-003`'s presence clause is red on the four debt-carrying indexes until US011
  lands, so `S-03` is not pulled ahead of it (settled 21/09/2026, US010 / US011 gate grilling,
  round 1 Q1), and `../02-STORIES/CUT-PLAN.md` P8 leaves it `Proposed` with no sprint. **This sprint
  is a precondition of `S-03`, not a dependency on it.**
- **Slice `S-04` of the same map** — artefact frontmatter. Uncut, and in no record.
- **The `20-FINDINGS` and `21-BUGS` indexes.** Both held zero instances when US011 was cut, so
  US010 ships them legitimately empty with no debt line. If either has gained an instance by the
  time US011 runs, it is US010's presence clause to satisfy and not this sprint's backfill.
- **Growing `SEEDED`, and whether a seed's content is right.** The first is US010's; the second is
  US010's `ST03`, `ST04` and `ST06`. US012 asserts presence and leaves the script's "What it CANNOT
  check" paragraph unchanged.
- **The root seeds** — `README.md`, the version-state files, `GAPS.md`, `DEFERRED.md` and
  `.claude/MEMORY.md`. The `[3/4]` job already asserts each present by other means, so they are
  outside US012's loop.
- **Editing `../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`.** US011 reads
  its `Status` line as `Proposed` under the read rule and does not touch the record; its sign-off
  belongs to US004 and is scheduled nowhere.
- **Admitting a third story.** The record is CLOSED by call at 10 / 11, and a new admission opens
  SPRINT-08 — which `../02-STORIES/CUT-PLAN.md` P8 gives to RULE-OWNERSHIP at 11 / 11, so it would
  not receive a dropped US011 either. See _Sprint Definition of Done_.

---

## Build order — US012 then US011, and both name segments read `07`

**This plan takes execution order `07`, and the number was derived rather than copied.**

| Member | Blocked by                                                                                                                       | In        | Built at |
| ------ | -------------------------------------------------------------------------------------------------------------------------------- | --------- | -------- |
| US012  | Nothing — `MAP-SCRIPT-GUARDS.md` records an empty frontier, and `S-02` depends on nothing `S-01` ships                           | —         | —        |
| US011  | US010 — it creates the four index files, their tails and ordering rules, and the `Backfill owed — US011` line this story removes | SPRINT-06 | `06`     |

Every earlier sprint's members are built at `01` to `05`, and SPRINT-06's plan builds US010 at `06`,
so honouring the dependency chain and honouring the sprint number give the same answer and both
segments read `07`. The record predicted it (`../03-SPRINTS/SPRINT-07.md` -> _Dependencies_), and a
reader who finds `07` on both should know it was checked rather than assumed.

**US012 builds first.** It is the `Must`, and `../../docs/planning/SPRINTS.md` -> _MoSCoW_ makes
the stretch tier the work dropped first, the reading SPRINT-05 took on 17/09/2026 for US008 ahead of
US009; and US011 waits on US010 while US012 waits on nothing. The order inside the record is that
gate's reading rather than a call <%DEVELOPER_NAME%> made on the day, and the record says it is
reversible by moving one reservation back. Nothing has moved it, and the story-plan order follows
it (settled 03/10/2026, 16-sprint-plans grilling round 9 Q22; see _Story Plans — the code master_).

**US011's blocker is a Definition of Done row, not a cleared dependency.** US010 reads
`Status: Open` and is unbuilt, measured 03/10/2026. A plan may be written while its member's
blocker is unbuilt, because the plan precedes the build; US011's build may not start until the four
indexes exist, each carrying its `Backfill owed — US011` line, with the tails and ordering rules
US010 designed. The record carries that check as a Definition of Done row and so does this plan.
**US012 is not held by it**: if US010 slips, US012 still builds.

**US010 and US012 write the same script, and neither waits for the other.** US010 grows `SEEDED` in
`.github/scripts/shipped-artefacts.sh` from one entry to eight; US012 adds the check-4 loop that
reads it and the `--self-test` probe that proves the loop. Neither blocks the other in either order
(settled 21/09/2026, MAP-SCRIPT-GUARDS interview round, Q1), but **one region is shared by
design**: the comment above `SEEDED`, which both stories rewrite, and whichever lands second
extends the other's wording rather than contradicting it (`../02-STORIES/US010.md` ->
_Dependencies_, as amended 27/09/2026; `../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` -> _Build
order_). Build order expects US010's array first, then this sprint's loop, but the landing order is
not fixed: `../02-STORIES/CUT-PLAN.md` P9 (27/09/2026) lifted the two sessions' holds and fixed no
order.

**US011 runs that script and does not edit it.** Its "passes unchanged" criterion reads US011's own
diff and holds whichever of US011 and US012 lands first; landing US012 first means US011 is
exercised by the stronger check.

**Neither member blocks on US004.**
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` is a
reporting regime and sequences nothing; see _Gate honesty_.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. **Neither member's
plan exists.** `17-story-plans` writes both after this plan, because its Step 1 gathers the sprint
plan first; the prefixes are reserved rather than assigned by this file.

| Story | Story plan (`../17-STORY-PLANS/`)                                                                                                                                                       | Status              |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| US012 | _no file — "11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md" is the reserved name, its descriptor matching the story's QA plan as every existing pair does; written by `17-story-plans`_      | _no plan to mirror_ |
| US011 | _no file — "12-STORY-PLAN-US011-REGISTER-INDEX-BACKFILL.md" is the reserved name, its descriptor matching the story's QA plan as every existing pair does; written by `17-story-plans`_ | _no plan to mirror_ |

The run on disk is contiguous `00-` to `09-`, measured 03/10/2026. **The prefix is the story's
position in the settled build order across the whole backlog, not its sprint and not a per-sprint
counter** — US010 tenth at a reserved "10-" (ninth if US009's carry lands in SPRINT-06, a swap
`../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` states), then US012 eleventh at "11-" and US011 twelfth
at "12-" either way — and it is renumbered whenever that order changes;
`../17-STORY-PLANS/CLAUDE.md` owns that rule. US012's and US011's reservations are recorded in their
own stories, under each one's _Dependencies_; US010's is SPRINT-06's to state. None of the three
numbers is a file yet.

<!-- 03/10/2026 — THE STATUS COLUMN, AND THE POPULATION IT WILL JOIN. The column takes the house
     shape ../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md uses. Until a plan exists its cell reads "_no plan
     to mirror_", the no-file convention ../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md set for US007 on
     07/09/2026 and ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md followed for US006 on 08/09/2026. When `17-story-plans` writes a plan, its Step 10 repoints the row at the file and
     the cell takes "Not started": a value in no status set, held pending ../02-STORIES/US007.md
     Scenario 8, on the reasoning 05-SPRINT-PLAN-05.md's own Status comment records. The plan's
     own `| Status |` header row is NOT mirrored here.

     THESE TWO ROWS ADD NOTHING TO THE POPULATION SCENARIO 8 COUNTS TODAY, and that is flagged so
     the later additions are not silent. Measured 03/10/2026 across the six live sprint plans,
     ../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md committed ahead of this one: NINE "Not started" cells —
     US007 and US001 in ../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md, US002 and US003 in
     ../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md, US005 and US006 in
     ../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md, US008 and US009 in
     ../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md — the eight that file counted on 18/09/2026 — and the
     ninth, 06-SPRINT-PLAN-06.md's US009 reserved-carry row, which that plan records as the ninth
     and the second to point at US009's plan. Each row here joins the population when its plan is
     written before US007 ships; the pass that writes it re-counts immediately before its edit rather than inheriting this
     figure, as Scenario 8 already says. ../02-STORIES/US007.md is NOT edited by this pass. -->

**Each story plan is followed by its manual testing guide, in the same `17-story-plans` run and the
same commit** (settled 03/10/2026, 16-sprint-plans grilling round 9 Q22). Step 7.2 authors the
guide under `../18-TESTS/MANUAL/` from the specs before any code, Step 9 reviews plan and guide
together, and Step 10 cross-links them. The order is US010's plan and guide, then US012's, both
after one round of `17-story-plans` grilling; then US011's, once US010's plan is committed. **US012
owes a guide although its QA flag names the unit type alone** (settled 03/10/2026, 16-sprint-plans
grilling round 9 Q21): since 30/09/2026 Step 7.2 authors one for every story, and
`../../workflows/23-pr-and-review/STEPS.md` Step 6 verifies both test records for every story. What
either guide holds is its story plan's to decide, from the specs, and is not designed here.

**That prefix rule is the opposite of the rule governing this file's own name.** `./CLAUDE.md` says
a sprint plan is named for two numbers, exec order and sprint, and that a mismatch between them is
deliberate information that must never be "corrected". A story plan carries one, so its prefix must
track build order or it says nothing. Do not read either guardrail across to the other folder.

---

## Phase Breakdown

**Neither story enters a code lane.** The four-phase backend -> API -> frontend -> PR sequence in
`../../docs/planning/SPRINTS.md` maps stories by the layers they touch. The phases neither story
touches are recorded as `N/A` with a reason rather than deleted, per `code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**N/A** — both read `Backend: N/A`. No Python, model, service or migration. Both members still ship
executable change, carried in the lane table below; which PM workflow each story plan enters to
build it is that plan's to state.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema, and no MCP tool. Both read `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. Both read `Frontend: N/A`.

### The lane these stories actually run in

| Story | Deliverable                                                                                                                                                                                                                                                                                                      | Proven by                                                                                                                                                                                                                                                                                                             |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US012 | One file, `.github/scripts/shipped-artefacts.sh`: a check-4 loop over every `SEEDED` entry, its finding carrying the seed's own repair, the closing guidance stopped sending a seed finding to the allowlist, a sixth `--self-test` probe on the last `SEEDED` entry, and the header contract rewritten to match | `--self-test` in CI's `[3/4]` job on the pushed story branch — a deliberately red commit evidenced by the probe's own line, then green at **6 probes** — a string test of the probe's substring, the no-negation read recorded at review, ShellCheck recorded as run or not run, and its manual testing guide, walked |
| US011 | One row per instance in the four indexes, each `Status` mirrored under the read rule, `DECISION-INDEX.md`'s supersession tail filled, each index's ordering rule honoured, the four `Backfill owed — US011` lines removed, and a generated-tree grep for the four registers' literals added to the `[3/4]` job   | The grep on every render path, the three `shipped-*` scripts unchanged by its diff, a link-resolution check over the four indexes, the three manual walks the record lists — row by row, summary legibility, the supersession chain — and its manual testing guide, walked                                            |

**Neither member's headline risk is reachable by any suite this repository runs locally, and the
manual checks are load-bearing.** US012's is a check that stays silent; it is observed only by CI's
`[3/4]` job on the pushed branch, red then green, because no project script generates a tree and a
raw `uvx copier copy` is what `.claude/CLAUDE.md` Section 6 bans — a hand-built fixture is lawful
for iterating and indicative only. US011's is a summary nobody can read or a row whose status has
drifted, and no script judges either. The record's _Tasks_ section carries both lists and is not
restated here.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, US012 then US011, each behind its own gate. `22-implementation-documentation` runs
between the lane above and this phase and is a merge gate: it writes each story's test-status record
under `../18-TESTS/AUTOMATED/` and walks its manual testing guide under `../18-TESTS/MANUAL/` —
**US012's included** (settled 03/10/2026, 16-sprint-plans grilling round 9 Q21) — and it owns this
sprint's register writes. For US011 that is the `GAPS.md` entry for TM-10's window, dated the day it
is written: once US011 ships, the four backfilled indexes read complete with no gate until `S-03` is
cut, and `S-03` is unscheduled. For US012 it is marking the `S-02` row of `MAP-SCRIPT-GUARDS.md`'s
_Register claimed_ table retired against the shipped change; **no `GAPS.md` row is closed**, the
entry having been removed at charting.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story's acceptance criteria and the spec it
cites.

### GDPR (`../09-GDPR/`)

**N/A.** Both flags read `GDPR: N/A`. No personal data is collected, stored or exported by either
member. US011's rows name stories, sprints, decisions and plans; US012's finding names a file path.

### Security (`../10-SECURITY/`)

**N/A for both members, read by flag, and each `N/A` carries a reason of its own** (settled
28/09/2026, 16-sprint-plans grilling round 1 Q2). No threat model or assessment was written for
either, and none is owed. **That is a flag reading, never "the security gate passed"**: no security
check ran for either member.

- **US012** adds a presence assertion to a CI integrity gate — no authentication, no personal data,
  no endpoint, and no control whose pass condition it loosens. Its one failure mode is silence, and
  silence is what its self-test probe proves against: a QA assertion rather than a security design.
- **US011** writes real rows into four in-tree files whose `.copier/` seeds must stay blank, and a
  leak would be permanent. The control for that is US010's — `ST03`, `ST04` and `ST06`, gated in
  `.github/scripts/shipped-registers.sh` — and US011 introduces and changes no control; it is
  exercised by that one.

**US010's two gate-`10` plans, signed off on 28/09/2026, are the only security artefacts naming
either member, and they overturn neither `N/A`.** TM-09 and TM-10 bear on this sprint most directly,
both `LOW`: TM-09 places seed presence with US012's loop and probe and seed content with US010's
`ST06`, and TM-10 routes the window after US011 ships to the `GAPS.md` entry under _Phase 4_.

**The flag-blind wording is routed, not fixed here.** `../../workflows/16-sprint-plans/STEPS.md`
Step 1, its `CHECKLIST.md` and `../../docs/planning/CADENCE.md`'s prerequisite list ask for a threat
model and assessment without the flag condition. That defect goes to `GAPS.md` through US010's
gate-`22` pass (`../03-SPRINTS/SPRINT-06.md` -> _Index and Seed Tasks_), and it holds back neither
member, both Security rows reading `N/A`.

### QA (`../11-QA/`)

**Twenty-two acceptance-criteria gaps were found across the two members — nine and thirteen — and
all twenty-two are resolved**, US012's `[RESOLVED] 21/09/2026` and US011's `[RESOLVED] 27/09/2026`,
each fed back into its story as an acceptance criterion or a task. Two were blocking, both US011's.
Both plans were committed on 27/09/2026 — US012's in `488e197`, US011's in `b1ca05a` — and signed
off by <%DEVELOPER_NAME%> on 30/09/2026, when gate `11` closed for each (settled 30/09/2026,
16-sprint-plans grilling round 3 Q9). `../11-QA/PLANNING/CLAUDE.md` gates a sprint plan on no
`[OPEN]` acceptance-criteria gap remaining, and that gate is satisfied rather than waived. The close
at `Signed off` is round 3 Q9's, a rule no folder file states yet, which goes to `GAPS.md` through
US010's gate-`22` pass (`../03-SPRINTS/SPRINT-06.md` -> _Index and Seed Tasks_).

**Both members owe a manual testing guide, and US012's flag does not exempt it** (settled 03/10/2026,
16-sprint-plans grilling round 9 Q21). US012's QA value names the unit type alone, and the record
said until 03/10/2026 that it owed no manual-testing record; that was written on 21/09/2026 at
US012's admission and committed on 27/09/2026 in `488e197`, both before `17-story-plans` Step 7.2
made the guide unconditional on 30/09/2026, and the record is corrected in
the same change as this plan. Both guides are authored at Step 7.2 and walked at
`22-implementation-documentation`.

### SEO (`../12-SEO/`)

**N/A.** Both flags read `SEO: N/A`. No public page, route or metadata surface is added or changed.

### Decisions binding this sprint

| ADR                                                                                     | Authored at                                                               | What it binds                                                                                                                                                                                                                      |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`                        | `15-decisions` for US010, 21/09; committed `Accepted` in `0c5e635`, 27/09 | US011: every row's `Status`, and `DECISION-INDEX.md`'s tail values, read by one rule — bold markers, backticks, any trailing HTML comment and everything from the first middle dot onward removed, then trimmed. US011 owns no ADR |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` | Inherited; supersedes its predecessor, 30/09                              | Binds every story in this backlog until the citation gate is green. US011's citation criterion is read against it as a baseline diff; US012's criteria run no citation gate                                                        |

**One superseded record is named beside its successor rather than dropped.**
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` reads `Superseded` since
30/09/2026; its successor restates it unchanged but for the manual testing guide's path (settled
30/09/2026, 16-sprint-plans grilling round 6 Q17; settled 30/09/2026, 16-sprint-plans grilling round
7 Q18). **US012 records no decision**, its _Decisions_ section stating none was hard to reverse.
Both binding records read `Accepted`, measured 03/10/2026.

### Gate honesty — the constraint specific to this sprint

`code/docs/GATE-REPORTING.md` applies to every sprint; these readings are specific to this one and
must not be softened in any record it produces.

- **The self-test reads one generated tree, and the full check reads every one.** This plan's
  checklist and the record's generation row carry US012's own words: "The
  `[3/4] Template Generation` job is green on every render path the template offers (today:
  `INCLUDE_MOBILE` true and false) — the self-test at `audit-template.yml:225` and the full run at
  `:228`". Measured 03/10/2026, `.github/workflows/audit-template.yml:225` runs `--self-test` over
  the `INCLUDE_MOBILE` false tree alone, and `:228` runs the full check over both. The record's row
  read until 03/10/2026 as though the self-test covered every tree, and is corrected in the same
  change as this plan. No record may read a green self-test as proof over every tree.
- **US012's red run is evidenced by the probe's own line, never by the exit code alone.** A tree
  lacking the seed aborts the probe's `mv` with the same exit 1 and no probe line. Both run IDs are
  recorded in the story's test-status record.
- **The whole-tree citation gate is inherited red and this sprint does not move it.** US004 has not
  landed. US011's criterion is read as a diff against the baseline captured before its first edit,
  with the detector's `git hash-object` beside it, never as a bare pass; a rise in `dangling` is the
  sprint's own defect, a rise in `instance` the inherited class US004 fixes, and the two are reported
  apart. The record's own criterion is that its `dangling` count stays at 0. **The figures the
  record carries are dated 20/09/2026 to 03/10/2026**, the latest being the same change's own
  re-measurement of the record alone — 39 instance findings and 0 dangling, measured 03/10/2026 —
  and none is restated here as current.
- **`doc-references.sh` cannot see a Markdown link.** It reads backticked tokens only, so the links
  US011's rows carry are proved by the link-resolution check, never by a green citation run.
- **US011's population is counted at implementation, never inherited.** Measured 03/10/2026 under
  each register's positive filename pattern: 12 + 7 + 25 + 9 = 53 tracked instances, against the 43
  US011 was cut on and the "47 tracked on 27/09/2026" the record still carries; and six ADRs read
  `Superseded`, against the three of twenty US011's provenance counted on 20/09/2026. The three
  story plans reserved at "10-", "11-" and "12-" add to the fourth register once written. None of
  these is a target.
- **ShellCheck has no project script, and `lint.sh` has no YAML leg.** US012 edits a bash script and
  US011 edits `.github/workflows/audit-template.yml`. ShellCheck is run by hand and recorded as run
  or as not run, **never as a `lint.sh` pass**; the workflow edit is proved by the `[3/4]` job going
  green.
- **A green `doctrine-drift.sh` run says nothing about a row's `Status`.** That is the manual
  row-by-row walk's job, and is never reported as though the gate had done it.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, `pnpm`, `uv` or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-07.md` -> _Verification Checks_ and is not restated here.

- [ ] `bash .github/scripts/shipped-artefacts.sh --self-test <generated-tree>` exits 0 with **6
      probes** — US012's, in CI's `[3/4]` job on the pushed story branch, and changed in this sprint
      by US012's diff alone
- [ ] The `[3/4] Template Generation` job is green on every render path the template offers
      (today: `INCLUDE_MOBILE` true and false) — the self-test at `audit-template.yml:225` and the
      full run at `:228`, with every seed asserted present (US012); the self-test reads one
      generated tree, today the `INCLUDE_MOBILE` false one, and the full run reads every one. US011's
      grep finds no instance literal in any generated tree's four indexes, the 000 template
      identifiers excepted
- [ ] US012's red run recorded before its green one, each by run ID, the red evidenced by the
      probe's own zero-finding line
- [ ] `shipped-registers.sh` (with `--self-test`) and `shipped-ai.sh --self-test` pass, **unchanged
      by US011's diff**
- [ ] The link-resolution check over the four indexes — every Markdown link resolves, the count of
      links checked recorded beside the count of rows
- [ ] `doc-references.sh` — read per _Gate honesty_: the record's `dangling` count stays at 0, and
      US011's whole-tree figure is a per-citer diff against its recorded baseline
- [ ] `docs-length.sh` — run to prove the register-artefact exemption for the four indexes rather
      than assume it
- [ ] `docs-pairing.sh` and `doctrine-drift.sh` pass — regression only; neither member creates a
      directory
- [ ] `lint.sh` passes — the Markdown leg over the four indexes
- [ ] ShellCheck over `.github/scripts/shipped-artefacts.sh` — **recorded as run or as not run**,
      never as a `lint.sh` pass
- [ ] `check.sh` and `tests/all.sh --coverage` pass — **regression only**; neither member ships
      Python, and the coverage floor has nothing to bind
- [ ] Both manual testing guides walked at `22-implementation-documentation`, every row marked, and
      signed off — US012's on both branches (settled 03/10/2026, 16-sprint-plans grilling round 9
      Q21); US011's, its three walks included and signed off by a tester other than its author as
      its story requires, _deliver branch_, reading **N/A — dropped** on the drop branch
- [ ] `migrate.sh check` — **N/A**, neither member touches a model
- [ ] `routing-skills.sh` — **N/A**, neither member adds routing frontmatter
- [ ] Template, component, cross-browser, responsive and accessibility (WCAG 2.2 AA) checks —
      **N/A**, this sprint adds no page, component or interactive surface
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] GDPR, Security, Logging and SEO criteria — **N/A**, each flag reads `N/A` in both stories

---

## Sprint Definition of Done

- [ ] **The `Must` story is Completed — US012.** Its plan's own DoD complete and verified by a
      reviewer, once `17-story-plans` has written that plan under its reserved "11-"
- [ ] **US011 is disposed of in writing, on exactly one branch.** **Delivered:** it is Completed,
      and every row below headed _deliver branch_ binds as written. **Dropped:** the drop and its
      reason are recorded in the record, in US011's story and in the backlog register in every
      copy, in the same change; US011's half of every row below headed _deliver branch_ reads
      **N/A — dropped**, marked rather than deleted, and US012's half binds as written. It is the
      stretch tier and the first work dropped if US012 overruns, and dropping it does not fail the
      sprint. **No record can receive it** — SPRINT-08 does not exist, and once opened is
      RULE-OWNERSHIP's at 11 / 11 — so its placement is owed to `03-sprint-planning`, and wherever
      it lands, it lands ahead of `S-03`
- [ ] **US010 landed before US011 started — confirmed, not assumed.** The four indexes exist, carry
      their `Backfill owed — US011` line, and have the tails and ordering rules US010 designed. If
      any of that is absent US011 cannot start; US012 can
- [ ] All sprint-level acceptance criteria met and verified by a reviewer — US012's on both
      branches; US011's _deliver branch_
- [ ] All sprint-level tasks checked off — every task keyed US012 on both branches; every task keyed
      US011 _deliver branch_
- [ ] All sprint-level verification checks passed
- [ ] No open Critical or High security finding — **N/A by flag**: both Security flags read `N/A`,
      no security check runs for either member, and nothing US010's signed-off gate-`10` plans
      raise overturns either. Never reported as a security pass
- [ ] No `[OPEN]` gap remains in either member's QA plan — twenty-two resolved, none reopened.
      US011's half is _deliver branch_: a skip on the drop branch, never a pass
- [ ] Both stories' test records written by `22-implementation-documentation` — the test-status
      record under `../18-TESTS/AUTOMATED/`, and the manual testing guide authored at
      `17-story-plans` Step 7.2 and walked. US012's on both branches, its map claim marked retired
      and no `GAPS.md` row closed; US011's _deliver branch_, with its TM-10 `GAPS.md` entry written
      and dated the day it is written
- [ ] GDPR constraints implemented and verified — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] `../03-SPRINTS/SPRINT-07.md` `**Status:**` set to `Done`
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-07.md` (optional)

<!-- 03/10/2026: the rows above are drawn from ../03-SPRINTS/SPRINT-07.md -> Definition of Done
     and from the folder template's, and where a source disagrees with the record the record wins.
     The _deliver branch_ keying is the record's, carried row for row.

     THREE RECORD ROWS ARE NOT CARRIED. (1) The row that recomputes the record on a `Must`'s
     admission: the record is closed by call, so it binds nothing this plan sequences. (2) The row
     that recomputes the FLAGS table's QA row at gate 11's close: record housekeeping, which the
     record states in the past tense from gate 11's close on 30/09/2026, and its Security-by-flag
     reading is the security row above. (3) "GDPR gaps
     identified during the sprint documented here": the template's GDPR row above stands for it,
     and both read N/A.

     TWO ROWS COME FROM THE TEMPLATE AND ARE NOT DoD ROWS IN THE RECORD. (1) The Critical or High
     security finding row, read N/A by flag. (2) The test-records row, in the house shape of
     ../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md's and 06's implementation-records row, standing in for
     the template's "All QA scenarios passing (automated and manual)" row: it gathers obligations the
     record carries under QA Acceptance Criteria — Manual and under Tasks, not as DoD rows. The
     template's "version bumped if this sprint produces a release" and "Gaps found during the sprint
     recorded" rows have no counterpart in the record and are not added.

     ONE DISAGREEMENT IS NAMED. The record merges to `main` (or the active release branch), while
     ../../docs/planning/SPRINTS.md -> Development phases ends Phase 4 with a merge to `testing` and
     the folder template reads "the integration branch". The record's wording is carried, and the
     difference is left to the record's owner, `03-sprint-planning`, rather than resolved here. -->

---

## Branch Naming Reference

Per `../../docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story | Branch                                                               |
| ----- | -------------------------------------------------------------------- |
| US012 | _not yet set — the `Branch` row of US012's story plan, once written_ |
| US011 | _not yet set — the `Branch` row of US011's story plan, once written_ |

Neither is invented here. `17-story-plans` sets each, and this table is filled from the plan when it
exists — the precedent `../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` set for US007 on 07/09/2026. US012's red run
is a deliberately red commit pushed to its `us012/` branch, so that CI's `[3/4]` job runs it
(`../02-STORIES/US012.md` -> _QA Tasks — Automated_).

**Both branches are cut from `main`, and not yet**, on the reasoning
`../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` recorded on 02/09/2026. Every planning artefact these
stories depend on — the stories, this plan, the QA plans, the read-rule ADR and the sprint record —
lives on `pm/story-creation` and none of it is merged to `main`, so a branch cut from `main` today
could see none of it. The sequence is: every story completes its planning workflows -> `pm/story-creation`
is raised as a PR to `main` -> the `us###/` branches are cut from `main` and the stories implemented,
US010 ahead of US011.
