# SPRINT-PLAN-03 — Retry doctrine gets its single owner, and absence gets one beside it

**Last Updated**: 05/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-03.md` · **Capacity:** 5 SP Must + 5 SP Should = 10 / 11 · **Stories:** 2

---

## Sprint Goal

> Exactly one layer decides to repeat a failed operation and every budget says how long it may
> take, and every `return None` in the tree means one stated thing.

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`. The authorities this
> sprint defers to are `code/docs/DOCUMENTATION-LENGTH.md` for what a documentation file may
> weigh, `code/docs/GATE-REPORTING.md` for how a gate's result is reported, and
> `code/docs/FORWARD-VOICE.md` for what a document may promise about a tree it will be read in.
> Where a story's wording and those guides differ, the guides win.
>
> **One authority for this sprint does not exist yet.** US005's four rules are stated inside the
> `code/docs/reliability/` family, and that family is US001's deliverable in SPRINT-01. Until it
> lands there is no home to defer to — which is the whole of why this sprint's first member is
> blocked rather than merely sequenced.

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                          |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-03.md`                                                                                                                                                                                    |
| User stories       | `../02-STORIES/US005.md` · `../02-STORIES/US003.md`                                                                                                                                                             |
| Feature maps       | `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` slice `S-02` · `../01-FEATURE-MAPS/MAP-ABSENCE.md` slice `S-01`                                                                                               |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                               |
| User flows         | **N/A** — both read `User Flow: N/A`; no user journey in scope                                                                                                                                                  |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                     |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path                                                                                                                                                          |
| Security           | `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` · `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — both **Signed off**, US005's alone |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` · `../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` — both **Signed off**                                                                     |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                  |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface                                                                                                                                                         |
| Logging            | **N/A** — both read `Logging: N/A`; no log line                                                                                                                                                                 |
| Decisions          | Five ADRs bind this sprint — one authored by US005, four inherited. Listed under _Sprint-wide Constraints_                                                                                                      |

**This is the first sprint plan whose Security row is not `N/A`**, and the row names two
artefacts rather than one because the security gate ran in two halves: the STRIDE model and the
posture assessment that synthesises it. Both are US005's; US003 contributes nothing to either.

---

## Stories

### Must

| ID    | Title                                                                          | Phases touched           | SP  | Story plan                                                          | Git branch                          |
| ----- | ------------------------------------------------------------------------------ | ------------------------ | --- | ------------------------------------------------------------------- | ----------------------------------- |
| US005 | Exactly one layer decides to retry, and every budget says how long it may take | Docs only — no code lane | 5   | `../17-STORY-PLANS/STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` | `us005/retry-ownership-and-budgets` |

**5 SP committed against a capacity of 11.**

**US005 cannot take a demotion.** It is the sprint's only blocking work: slices `S-04`, `S-05`
and `S-06` on `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` all wait behind it, and `S-05`'s
`retry-discipline.sh` claims row pins this doctrine's exact wording. A slip here stalls three
slices, not one.

### Should

| ID    | Title                                                                        | Phases touched           | SP  | Story plan                                            | Git branch            |
| ----- | ---------------------------------------------------------------------------- | ------------------------ | --- | ----------------------------------------------------- | --------------------- |
| US003 | Absence gets an owning guide, born under 270 with every clause's tier stated | Docs only — no code lane | 5   | `../17-STORY-PLANS/STORY-PLAN-US003-ABSENCE-GUIDE.md` | `us003/absence-guide` |

**US003 arrives from SPRINT-02, and its `Should` tier travelled with it unchanged.** It was
demoted at `16-sprint-plans` on 02/09/2026 because SPRINT-02 stood at 13 SP against a capacity of
11; it moved here on 05/09/2026 because SPRINT-03 had opened as a single all-`Must` member, which
`project-management/docs/planning/SPRINTS.md` warns against — a plan with no give, where the first
surprise breaks it. **One move, two problems solved:** SPRINT-02 returned to 8 / 11 and this
sprint gained the only give it could honestly have.

**There was no give available from inside the retry map.** `S-04`, `S-05` and `S-06` all block on
US005 itself, and `S-03` and `S-09` are not yet cut into stories. US003 is give this sprint can
actually drop: if US005 overruns, the `Should` slips and the sprint still succeeds.

**Its backlog priority is unchanged in substance.** US003 remains wave 0 of the absence map's
cutting order with no upstream of its own; `Should` is a scheduling tier for this sprint, and it
is `Should` rather than `Could` precisely because five slices wait on it.

### Could

_None._

### Won't (this sprint)

- **`../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` slices `S-04`, `S-05` and `S-06`** — the
  example-repair sweep, the `retry-discipline.sh` gate, and the live-code fixes. All three block on
  US005 and none is yet cut into a story. Blocked, not deferred.
- **That map's slice `S-09`** — the `how-to/src/OUTBOUND-TIMEOUTS.md` register, split out of `S-02`
  at story creation on 04/09/2026. It runs **beside** US005 and blocks on nothing; it is out of
  this sprint because it is not cut into a story, not because it waits.
- **That map's slice `S-03`** — idempotency doctrine, the other half of the same rule. Named as a
  runs-beside dependency at US005's QA gate (`AC-GAP-11`). Not yet a story.
- **`../01-FEATURE-MAPS/MAP-ABSENCE.md` slices `S-02` to `S-06`** — every one cites the guide US003
  creates, and `S-06` names the dependency in its own acceptance. Not yet cut into stories.
- **US006** — cut from `../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` on 05/09/2026 at 8 SP `Must
Have`. **Settled the same day: it opens SPRINT-04.** The counterfactual is dated, because the
  arithmetic moved under it: **at the moment the question was live this sprint stood at 5 SP
  all-`Must`**, and US006's 8 SP would have taken it to 13 — its grace ceiling. US003 was admitted
  the same day, so against the sprint as it now stands US006 would give **18 SP (13 Must, 5
  Should)** — over grace, not at it. Either way grace is for a story that would split badly, not
  for one that arrives while there is room.

---

## Build order — SPRINT-01, then SPRINT-02, then this sprint

**This plan takes execution order `03`, and it is derived rather than assumed.**
`../03-SPRINTS/SPRINT-03.md` flags that the exec-order segment "may therefore not read `03`",
because sprint numbering is not execution order and this is the first sprint record in which
**every** member is blocked by a story in an earlier sprint. Worked through, the two constraints
put it back on `03`:

| Member | Blocked by       | In        | Built at |
| ------ | ---------------- | --------- | -------- |
| US005  | US001 — content  | SPRINT-01 | `01`     |
| US003  | US004 — ordering | SPRINT-02 | `02`     |

Both blockers sit in sprints already scheduled ahead of this one, so honouring the dependency
chain and honouring the sprint number give the same answer. **The mismatch SPRINT-03 warned
about did not materialise, and that is worth recording** — a reader who finds `03` on both
segments should know it was checked rather than copied.

**The two blocks are different in kind, and only one of them is real content.**

- **US005 waits on US001 absolutely.** Its four rules are stated _inside_ `code/docs/reliability/`,
  and that directory exists in no branch and no commit. There is no partial start: the family is
  the target. US001 is SPRINT-01's second story by **recommendation, not dependency** — that plan
  states the two are independent, share no file, and that nothing fails if the order is reversed —
  so US005 waits on one story, behind two if SPRINT-01's recommended order is honoured.
- **US003 waits on US004 only for order.** Its acceptance reads `doc-references.sh` as a diff
  against a recorded baseline, and US004 removes the defect that baseline exists for. Building
  US004 first means US003 is worked against a gate that simply passes. Settled at
  `03-sprint-planning` on 02/09/2026, and **it survived the story's move here** as a cross-sprint
  constraint rather than an intra-sprint one.

**Within this sprint the two members are free.** They share no file — US005 writes retry doctrine
into `code/docs/reliability/`, US003 creates `code/docs/ABSENCE.md` — and neither blocks the
other. Work them in either order once their respective blockers clear.

**The `build order 1` / `build order 2` on the two story-plan headers is a recommendation, not a
constraint** — it records which blocker clears first (US001 at execution order `01`, US004 at
`02`), on the precedent `01-SPRINT-PLAN-01.md` sets for saying so explicitly. Nothing fails if the
order is reversed.

**US003 needs a revision pass before it is worked, and it is not this plan's to make.** Three
parts of it are written against a defect that will be gone by the time anyone opens it: the
Gherkin scenario _"The citation gate is read against a recorded baseline, never as a bare pass"_,
the QA task recording before/after finding counts, and
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`. That ADR **retires by its
own terms** when US004 lands rather than being superseded. The correction belongs to whoever picks
US003 up; `../03-SPRINTS/SPRINT-03.md` → _Dependencies_ carries it, and
`../17-STORY-PLANS/STORY-PLAN-US003-ABSENCE-GUIDE.md` already plans against the corrected state.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here.

| Story | Story plan (`../17-STORY-PLANS/`)                                   | Status      |
| ----- | ------------------------------------------------------------------- | ----------- |
| US005 | `../17-STORY-PLANS/STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` | **Blocked** |
| US003 | `../17-STORY-PLANS/STORY-PLAN-US003-ABSENCE-GUIDE.md`               | `Open`      |

**The two statuses differ deliberately.** `../17-STORY-PLANS/CLAUDE.md` makes a plan marked
anything other than `Blocked` an assertion that its blockers are cleared, and the
parallel-worktree DAG reads it. US005's target directory does not exist, so its plan carries
`Blocked` — the first in this repository to do so. US003's blocker is build order against a story
that changes no file it touches, which is a sequencing fact the plan states in prose rather than a
status.

**There is no Plans Index row for either**, and that is a decision rather than an omission. The
index eight artefacts already cite has never existed; `../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`
slice `S-01` **creates `../17-STORY-PLANS/STORY-PLAN-INDEX.md`** — the file all eight citations
should have named — and repoints them. The claim lives on that map's _Register claimed_ table; the entry was re-triaged
off `GAPS.md`, so that register is **not** where a reader will find it.
Building an index here would pre-empt a claimed slice and add a ninth citation of a surface about
to be named something else.

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

| Story | Deliverable                                                                                                | Proven by                                                         |
| ----- | ---------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| US005 | Four rules into the `code/docs/reliability/` family, one budget table, four budget contradictions repaired | Three documentation gates, a hand recomputation and a read-across |
| US003 | `code/docs/ABSENCE.md` plus its registration, tier markers and reciprocity edits                           | Five documentation gates and a human read-across                  |

**This sprint ships no executable proof at all**, and it is the first since SPRINT-01 of which
that is true — US004's `--self-test` went back to SPRINT-02 with it. Both members are verified by
gates that read Markdown plus checks only a person can do: US005's hand recomputation of the
derived worst-case column, and both stories' read-across for a rule stated in two homes. Recorded
here because a sprint with no automated proof needs its manual checks to be load-bearing rather
than ceremonial.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, each behind its own blocker. `22-implementation-documentation` runs between the lane
above and this phase and is a merge gate — it writes each story's `../18-TESTS/US###-TEST-STATUS.md`
and `US###-MANUAL-TESTING.md`, and it owns the `GAPS.md` and `DEFERRED.md` writes this sprint
produces, including US005's unenforced-window entry.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story plan and the spec it cites.

### GDPR (`../09-GDPR/`)

**N/A** — both stories read `GDPR: N/A`. No personal data is read, written or logged; both ship
Markdown.

### Security (`../10-SECURITY/`)

**Live, and US005's alone.** US003's Security flag reads `N/A` and contributes nothing here.

The gate closed 05/09/2026 with **twelve findings across five of the six STRIDE categories —
eleven `INFO` and one `LOW`**. Elevation of privilege is recorded as considered-and-not-applicable
(no principal changes hands in a retry), which is a deliberate `N/A` and not an unexamined letter. Nothing is CRITICAL or HIGH, so nothing blocks this plan, and no record
is opened under `../10-SECURITY/VULNERABILITIES/PLANNING/`. **That is a decision with its reason,
never an audit that found nothing:** the escalation rule is written against exploitability and
there is no retry in this tree to exploit.

Three properties bind the sprint, and the **twelve** developer constraints behind them are in
`../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` Section 7 —
eleven on the doctrine's wording plus the one task that outlives the document. Not restated here:

- **The severities expire.** Every `INFO` is a fact about a tree in which nothing outbound
  retries, measured 05/09/2026. Read them **with** the promotion-trigger table in
  `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`
  Section 3a: **three** rows are design-state `HIGH` — TM-01, TM-02 and TM-04 — and each names the
  story that will meet it. The assessment's own summary says four by counting TM-02 twice; three
  rows carry the mark.
- **The constraints are on wording, because wording is all this sprint ships.** They are
  checkable by reading the shipped guide, not by running anything.
- **TM-02 is the one finding that is live now**, and it is live precisely because the rule ships
  without its gate. `DEFERRED.md` records the unenforced window at ship, naming slice `S-05` as
  owner and the first client-wiring story as its deadline.

**`AUDITS/` did not fire**, and the skip is recorded rather than reported as a pass: a code audit
reads shipped code and this sprint ships none. It fires at the first story that wires a client.

### QA & SEO

Both QA plans are **Signed off** and neither carries an unresolved `AC-GAP` — US005's fifteen all
resolved 05/09/2026, US003's seven at its own gate. SEO reads `N/A` on both stories.

The sprint's QA union names **one type, manual, across five gates**: US005's three documentation
gates plus the `routing-skills.sh` and `skill-conformance.sh` that entered this union with US003.
Recomputed on US003's admission on 05/09/2026, and the union is carried in full rather than
narrowed.

### Decisions binding this sprint

| ADR                                                                    | Binds                                                                                   |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md`   | One layer decides; layers beneath make a single attempt; SDK retries clamped by default |
| `../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`  | Prose doctrine is verified by human read-across; `doctrine-drift.sh` is a guard only    |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`  | A red `doc-references.sh` is read as a diff. **Still in force** — see below             |
| `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` | The full-path citation form, and that no gate verifies a PM `src/` instance citation    |
| `../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md` | US003's crib cells cite nothing that does not yet exist                                 |

**One ADR in that list was corrected rather than superseded**, and a reader should not mistake
that for drift: `ADR-US005-ONE-LAYER-DECIDES-TO-RETRY`'s worked clamp literal was wrong and was
fixed in place on 05/09/2026 across the ADR, `../02-STORIES/US005.md` and the map's `N-008`, the
record not having reached a commit. **The vendor semantics behind it are per-story depth and live
in `../17-STORY-PLANS/STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` → _The clamp's correct
form_**, not here.

**And one is still in force, against the reading the story assumes.**
`ADR-US003-CITATION-GATE-BASELINE-DIFF` retires when slice `S-06` lands **and the gate goes
green** — a conjunction, and the second half will not hold for this sprint, because correct
forward references survive. The ADR also calls for a **new record to supersede it** rather than
being edited, and nobody has written one. The baseline discipline therefore stands for both
members.

### Gate honesty — the constraint specific to this sprint

**Neither gate this sprint leans on can read what this sprint writes**, so three rules apply
throughout, from `code/docs/GATE-REPORTING.md`:

- **`doctrine-drift.sh` reads fenced code only.** Both members ship prose doctrine. A green run
  says the registered claims are undisturbed and says **nothing** about retry doctrine or absence
  doctrine appearing in two homes. It is never reported as though it had.
- **`doc-references.sh` never reports a plain pass for US005.** Forward references to
  `code/docs/reliability/` and `how-to/src/OUTBOUND-TIMEOUTS.md` survive whatever the story does,
  and each is named with the story or slice that owns it. **US003's half of this may become a
  plain pass** — if US004 has landed, its baseline procedure is unnecessary and its plan says so.
- **A baseline is only comparable against a run in the same git-index state.** The QA plan
  measured a **24-finding swing** on this tree between the same bytes untracked and tracked, every
  one a `[template-only citation]`. Record the index state beside any figure, and do **not**
  silence the class with `doc-references: template-only` markers — the marker would be a lie the
  moment the files land.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-03.md` → _Verification Checks_ and is not restated here.

- [ ] `doc-references.sh` — read as a diff, never as a pass. **Measured 05/09/2026 with this plan
      and US005's story plan present and untracked: 151 tree-wide** — 67 `[dangling path]`, 60
      `[template-only citation]`, 24 `[instance citation]`. Count the script's **finding lines**,
      not `grep` hits over its whole output: its explanatory footer repeats the class labels, and
      a first pass here reported a breakdown summing to 152 against a stated 151. The QA plan's
      **56** and `../02-STORIES/US005.md`'s **53** both predate this session and US006's
      artefacts; none of the three is comparable without its index state. Every survivor named
      with its owner
- [ ] `docs-length.sh` — no file created or edited this sprint at or above the warn tier without a
      dated allowance; `code/docs/TASK-AUTHORING.md` at 266 is the file to watch
- [ ] `doctrine-drift.sh` — regression only, with its prose blind spot stated rather than implied
- [ ] `routing-skills.sh` and `skill-conformance.sh` — **US003's alone**; US005 adds no frontmatter
- [ ] `syntax/lint.sh` and `syntax/check.sh` pass
- [ ] US005's derived worst-case column recomputed by hand on a default row **and** on the webhook
      override row, both arithmetic strings written out
- [ ] Both read-acrosses done — US005's across six guides, US003's across the six `TYPES-*` files

---

## Sprint Definition of Done

- [ ] **US005 is Completed** — its own DoD complete, verified by a reviewer
- [ ] **US003 is Completed, or explicitly carried to SPRINT-04** with its reason recorded in
      `../03-SPRINTS/SPRINT-03.md`; a `Should` is never dropped silently, and **US003 has already
      moved once**, so a second move records both
- [ ] All sprint-level verification checks passed
- [ ] No open HIGH/CRITICAL security finding — **applies**, and this is the first sprint plan for
      which it does. Twelve findings closed at `INFO`/`LOW`; the design-state promotions are not
      this sprint's to perform
- [ ] Any security finding whose promotion trigger fired during the sprint is re-assessed in
      `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at its present-state severity
- [ ] `DEFERRED.md` carries US005's unenforced-window entry, naming slice `S-05` as owner
- [ ] GDPR requirements implemented and verified — **N/A**, the GDPR flag reads `N/A`
- [ ] QA scenarios passing — manual for both members; this sprint ships no automated proof
- [ ] Both stories' implementation records written by `22-implementation-documentation`
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-03.md` `**Status:**` set to `Done`

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story | Branch                              |
| ----- | ----------------------------------- |
| US005 | `us005/retry-ownership-and-budgets` |
| US003 | `us003/absence-guide`               |
