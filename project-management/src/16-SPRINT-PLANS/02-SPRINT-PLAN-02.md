# SPRINT-PLAN-02 — The citation gate stops depending on the git index

**Last Updated**: 05/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-02.md` · **Capacity:** 8 / 11 · **Stories:** 1

<!-- Read "8 SP Must + 5 SP Should = 13 / 11" and "Stories: 2" until 05/09/2026, when US003 moved
     to SPRINT-03 before either sprint was worked. This plan no longer needs grace; the reasoning
     that admitted it is kept under Should rather than deleted, because it is the record of a
     decision that was taken. ../03-SPRINTS/SPRINT-02.md was corrected the same day. -->

---

## Sprint Goal

> The citation gate gives the same verdict on the same sentence whether or not the file is
> committed.

<!-- The goal carried "and the absence guide is born behind it" until 05/09/2026, when US003 moved
     to SPRINT-03. A goal naming a deliverable no member carries is drift; ../03-SPRINTS/SPRINT-02.md
     cut the same clause for the same reason on the same day. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** US004 carries `DB: N/A` and `User Flow: N/A`. The authorities this
> sprint defers to are `code/docs/GATE-REPORTING.md` for how a gate's result is reported,
> `code/docs/FORWARD-VOICE.md` for what a document may promise about a tree it will be read in,
> and `code/docs/DOCUMENTATION-LENGTH.md` for what a documentation file may weigh. Where a
> story's wording and those guides differ, the guides win.

## Sprint Reference Documents

| Area               | Source                                                                                                    |
| ------------------ | --------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-02.md`                                                                              |
| User stories       | `../02-STORIES/US004.md`                                                                                  |
| Feature maps       | `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06`                                                   |
| Database           | **N/A** — US004 reads `DB: N/A`; no model, migration or RLS policy in scope                               |
| User flows         | **N/A** — US004 reads `User Flow: N/A`; no user journey in scope                                          |
| Brand & components | **N/A** — US004 reads `Brand: N/A` and `Components: N/A`; no rendered surface                             |
| Wireframes         | **N/A** — US004 reads `Wireframes: N/A`; no screen                                                        |
| GDPR               | **N/A** — US004 reads `GDPR: N/A`; no personal-data path                                                  |
| Security           | **N/A** — US004 reads `Security: N/A`; no protected action and no new endpoint                            |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — **Signed off**                             |
| SEO                | **N/A** — US004 reads `SEO: N/A`; no public page                                                          |
| API design         | **N/A** — US004 reads `API: N/A`; no Django Ninja surface                                                 |
| Logging            | **N/A** — US004 reads `Logging: N/A`; no log line                                                         |
| Decisions          | Four ADRs bind this sprint — two authored by US004, two inherited. Listed under _Sprint-wide Constraints_ |

<!-- 05/09/2026: the User stories and QA rows named US003 and its QA plan until the story moved to
     SPRINT-03. Both now name US004 alone; the story and its plan are carried by
     ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md. -->

---

## Stories

### Must

| ID    | Title                                                                                 | Phases touched               | SP  | Story plan                                                      | Git branch                      |
| ----- | ------------------------------------------------------------------------------------- | ---------------------------- | --- | --------------------------------------------------------------- | ------------------------------- |
| US004 | The citation gate stops depending on the git index, and the PM tree becomes checkable | Script + docs — no code lane | 8   | `../17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` | `us004/citation-gate-git-index` |

**8 SP committed against a capacity of 11.**

### Should

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

**History, from 02/09/2026 — superseded by the move above.**

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
  guide US003 creates, and `S-06` names the dependency in its own acceptance. **Since 05/09/2026
  they block on a story in another sprint**, not on a member of this one: US003 is in SPRINT-03,
  so the five slices sit a sprint further out than this plan first recorded. Not yet cut into
  stories; not `DEFERRED.md` rows.
- **US003 itself** — this plan's `Should` tier until 05/09/2026, when it moved to
  `../03-SPRINTS/SPRINT-03.md` before either sprint was worked, so that SPRINT-03 gained the give
  an all-`Must` plan has none of and this one returned to 8 / 11 without grace. Recorded here as a
  `Won't` rather than left absent, because a story this plan carried must stay findable from it.
  Its tier, its ordering constraint and its revision pass all travelled with it —
  `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` → _Should_.
- **`MAP-NAVIGATION` slice `S-01`** — the citation edge set stops being discarded. It changes the
  same script US004 edits and must not land first. Blocked by US004, not deferred.
- **`GAPS.md`'s 01/09/2026 entry** — the three shipped files still instructing the `CONTEXT.md`
  index row. Adjacent to US004's subject and owned by no slice on any map; explicitly out.
- **The `MAP-GATE-PARITY` question** — whether a gate means the same thing in a generated project.
  `ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` is one instance of it and claims none of
  its scope.

---

## Build order — SPRINT-01 before US004, and US004 before US003 across a sprint boundary

**Within the sprint there is no order left to set — US004 is the whole of it.** The ordering
constraint this plan settled did not leave with US003: **it became cross-sprint on 05/09/2026.**
US003's acceptance reads `doc-references.sh` as a diff against a recorded baseline, and US004
removes the defect that baseline exists for. Building US004 first means US003 is worked against a
gate that simply passes, and the regime
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` imposes is never exercised.
Settled at `03-sprint-planning`, 02/09/2026, and unchanged by the move.

**It is restated where the story now lives rather than left only here.**
`../03-SPRINTS/SPRINT-03.md` → _Dependencies_ and `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` →
_Build order_ both carry it, because a constraint recorded only in the sprint a story has left is
a constraint nobody reads. It stays in this plan too: the half of it this sprint owes is US004
landing first.

**US003's revision pass travelled with the story on 05/09/2026.** Three parts of it are written
against a defect that will be gone by the time anyone opens it: the Gherkin scenario _"The citation
gate is read against a recorded baseline, never as a bare pass"_, the QA task recording
before/after finding counts, and the ADR above. The correction belongs to whoever picks US003 up,
and `../03-SPRINTS/SPRINT-03.md` → _Dependencies_ now carries it.

<!-- That obligation was recorded here against ../03-SPRINTS/SPRINT-02.md -> Dependencies until
     05/09/2026. It moved to SPRINT-03 with the story rather than to GAPS.md, because it belongs
     in the record whoever picks US003 up will actually read. -->

**Across sprints: this plan takes execution order `02`, behind `01-SPRINT-PLAN-01.md`**, and the
obvious argument for pulling it ahead was declined. US004 makes the citation gate trustworthy, so
building it first would spare SPRINT-01 a workaround — but SPRINT-01 has **already paid** for
that workaround: it is written into US001's two ADRs, both QA plans and both sets of acceptance
criteria. Pulling ahead creates churn rewriting signed-off artefacts rather than saving cost.

**The dependency runs the other way, and it is concrete.** US002 shrinks
`code/src/scripts/audits/CONTEXT.md` from **298 to 230 counted lines**, and US004 must edit a row
in that file against a 300-line hard limit. Building SPRINT-01 first removes a constraint US004
otherwise works around — recorded as AC-GAP-9 of
`../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here.

| Story | Story plan (`../17-STORY-PLANS/`)                               | Status      |
| ----- | --------------------------------------------------------------- | ----------- |
| US004 | `../17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` | Not started |

<!-- US003's row sat below US004's until 05/09/2026, when the story moved to SPRINT-03; its plan
     is indexed by ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md instead. -->

---

## Phase Breakdown

**US004 does not enter a code lane.** The four-phase backend → API → frontend → PR sequence in
`project-management/docs/planning/SPRINTS.md` maps stories by the layers they touch, and these two
touch none of them. The phases are recorded as `N/A` with a reason rather than deleted, per
`code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**N/A** — no model, service, migration or business logic. US004 reads `Backend: N/A`.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema. Both read `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. Both read `Frontend: N/A`.

### The lane these stories actually run in

| Story | Deliverable                                                                                                 | Proven by                                                        |
| ----- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| US004 | Five repairs to `code/src/scripts/audits/doc-references.sh`, one register mechanism, one shipped-file sweep | The script's own `--self-test`: fixture pairs plus direct probes |

<!-- US003's row — code/docs/ABSENCE.md, proven by five documentation gates and a read-across —
     moved to ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md with the story on 05/09/2026. -->

**US004 is the sprint's first story with an automated proof.** Its `--self-test` is the only
executable check this sprint ships, and `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`
section 6 carries the method: measure by executing a patched scratch copy, never by reading.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

US004 alone. `22-implementation-documentation` runs between the lane above and
this phase and is a merge gate — it writes each story's `../18-TESTS/US###-TEST-STATUS.md` and
`US###-MANUAL-TESTING.md`, which **US004's own register rows make citable in advance**.

---

## Sprint-wide Constraints

### GDPR (`../09-GDPR/`)

**N/A** — US004 reads `GDPR: N/A`. No personal data is read, written or logged; it ships
documentation and one shell script that reads repository files and emits paths.

### Security (`../10-SECURITY/`)

**N/A** as a flag, with one property worth asserting anyway: US004's self-test probe **writes
inside the repository**. It must create its file under a path the repository already owns, never
in `/tmp` with a predictable name, and remove it on every exit path. Recorded in
`../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` section 5.

### QA & SEO

US004's QA plan is **Signed off**; SEO reads `N/A`. **The sprint's QA union narrowed to US004's
half on 05/09/2026** — its unit value, the sprint's first automated one, alongside the
documentation gates it runs. The five-gate manual value entered this union with US003 and left
with it.

**A union narrows only when a member leaves**, which is exactly this case: US003 moved to
SPRINT-03 whole. This is not the Part A / Part B narrowing
`project-management/docs/planning/SPRINTS.md` permits, and `../03-SPRINTS/SPRINT-02.md` records
the same recomputation against its own flag table on the same day.

### Decisions binding this sprint

| ADR                                                                      | Binds                                                                       |
| ------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| `../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`   | Check 2 reads the citing file's name, never `is_template_only()`            |
| `../15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md` | A `PROJECT-PATHS.md` row may name a class; `###` is three digits exactly    |
| `../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`    | Prose doctrine is verified by human read-across; `doctrine-drift.sh` guards |
| `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`    | **Retires by its own terms when US004 lands** — not superseded              |

### Gate honesty — the constraint specific to this sprint

**This sprint's subject is a gate, so it is the sprint most able to lie about one.** Three rules
apply throughout, from `code/docs/GATE-REPORTING.md`:

- **`doc-references.sh` never reports a plain pass here.** Findings survive US004 whatever it
  does, and they are **tree-wide facts its run will meet, not SPRINT-02 members**. Re-measured
  05/09/2026: four citations of `code/src/scripts/audits/SLOP-FAMILY.md` — in
  `../02-STORIES/US004.md`, `../03-SPRINTS/SPRINT-02.md`,
  `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` and this plan itself — every one
  owned by **US002 in SPRINT-01**. The `code/docs/ABSENCE.md` survivors left with US003
  and are now SPRINT-03's; `../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` carries them. Every survivor
  is named with the story that owns it.

  <!-- Read "Six findings survive US004 whatever it does — three citations of code/docs/ABSENCE.md
       belonging to US003, three of SLOP-FAMILY.md belonging to US002" until 05/09/2026. Both
       halves were wrong after US003's move: the ABSENCE.md half is no longer this sprint's, and
       the SLOP-FAMILY count is four rather than three — this plan's own citation is the fourth. -->

- **A fixture that passes both scripts proves nothing.** Every new case is run against the
  pre-change script and must fail there.
- **Measure by executing.** Two claims in US004 made by reading the script were wrong, and both
  became AC-gaps. The story's own figures are reproduced at implementation, not inherited.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-02.md` → _Verification Checks_ and is not restated here.

- [ ] `doc-references.sh` — no finding of the three classes US004 owns; every survivor named
- [ ] `doc-references.sh --self-test` exits 0, probe count risen by one case per repair
- [ ] US004's own gates run, and their output recorded
- [ ] `syntax/lint.sh` and `syntax/check.sh` pass, including ShellCheck over the edited script
- [ ] `code/src/scripts/audits/CONTEXT.md` is not grown — US002 owns that file's shape

---

## Sprint Definition of Done

- [ ] **US004 is Completed** — its own DoD complete, verified by a reviewer
- [ ] **No `Should Have` story remains here.** US003 was this plan's stretch tier and moved to
      `../03-SPRINTS/SPRINT-03.md` on 05/09/2026, before either sprint was worked, with its reason
      recorded under _Should_ above. It was not dropped and it was not silent
- [ ] All sprint-level verification checks passed
- [ ] No open HIGH/CRITICAL security findings — **N/A**, the sprint's Security flag reads `N/A`
- [ ] GDPR requirements implemented and verified — **N/A**, the GDPR flag reads `N/A`
- [ ] QA scenarios passing — US004's self-test
- [ ] US004's implementation records written by `22-implementation-documentation`
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-02.md` `**Status:**` set to `Done`

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`.

| Story | Branch                          |
| ----- | ------------------------------- |
| US004 | `us004/citation-gate-git-index` |

<!-- US003's branch row moved with the story to ../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md on
     05/09/2026. -->
