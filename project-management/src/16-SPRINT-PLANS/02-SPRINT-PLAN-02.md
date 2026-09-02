# SPRINT-PLAN-02 — The citation gate stops depending on the git index

**Last Updated**: 02/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-02.md` · **Capacity:** 8 SP Must + 5 SP Should = 13 / 11 · **Stories:** 2

---

## Sprint Goal

> The citation gate gives the same verdict on the same sentence whether or not the file is
> committed, and the absence guide is born behind it.

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`. The authorities this
> sprint defers to are `code/docs/GATE-REPORTING.md` for how a gate's result is reported,
> `code/docs/FORWARD-VOICE.md` for what a document may promise about a tree it will be read in,
> and `code/docs/DOCUMENTATION-LENGTH.md` for what a documentation file may weigh. Where a
> story's wording and those guides differ, the guides win.

## Sprint Reference Documents

| Area               | Source                                                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-02.md`                                                                                                            |
| User stories       | `../02-STORIES/US004.md` · `../02-STORIES/US003.md`                                                                                     |
| Feature maps       | `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slice `S-06` · `../01-FEATURE-MAPS/MAP-ABSENCE.md` slice `S-01`                              |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                       |
| User flows         | **N/A** — both read `User Flow: N/A`; no user journey in scope                                                                          |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                             |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                        |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path                                                                                  |
| Security           | **N/A** — both read `Security: N/A`; no protected action and no new endpoint                                                            |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` · `../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` — both **Signed off** |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                          |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface                                                                                 |
| Logging            | **N/A** — both read `Logging: N/A`; no log line                                                                                         |
| Decisions          | Four ADRs bind this sprint — two authored by US004, two inherited. Listed under _Sprint-wide Constraints_                               |

---

## Stories

### Must

| ID    | Title                                                                                 | Phases touched               | SP  | Story plan                                                      | Git branch                      |
| ----- | ------------------------------------------------------------------------------------- | ---------------------------- | --- | --------------------------------------------------------------- | ------------------------------- |
| US004 | The citation gate stops depending on the git index, and the PM tree becomes checkable | Script + docs — no code lane | 8   | `../17-STORY-PLANS/STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` | `us004/citation-gate-git-index` |

**8 SP committed against a capacity of 11.**

### Should

| ID    | Title                                                                        | Phases touched           | SP  | Story plan                                            | Git branch            |
| ----- | ---------------------------------------------------------------------------- | ------------------------ | --- | ----------------------------------------------------- | --------------------- |
| US003 | Absence gets an owning guide, born under 270 with every clause's tier stated | Docs only — no code lane | 5   | `../17-STORY-PLANS/STORY-PLAN-US003-ABSENCE-GUIDE.md` | `us003/absence-guide` |

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
  guide US003 creates, and `S-06` names the dependency in its own acceptance. Not yet cut into
  stories; not `DEFERRED.md` rows.
- **`MAP-NAVIGATION` slice `S-01`** — the citation edge set stops being discarded. It changes the
  same script US004 edits and must not land first. Blocked by US004, not deferred.
- **`GAPS.md`'s 01/09/2026 entry** — the three shipped files still instructing the `CONTEXT.md`
  index row. Adjacent to US004's subject and owned by no slice on any map; explicitly out.
- **The `MAP-GATE-PARITY` question** — whether a gate means the same thing in a generated project.
  `ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` is one instance of it and claims none of
  its scope.

---

## Build order — US004 before US003, and SPRINT-01 before both

**Within the sprint: US004 first, and the order is not free.** US003's acceptance reads
`doc-references.sh` as a diff against a recorded baseline, and US004 removes the defect that
baseline exists for. Building US004 first means US003 is worked against a gate that simply passes,
and the regime `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` imposes is
never exercised. Settled at `03-sprint-planning`, 02/09/2026.

**US003 needs a revision pass before it is worked.** Three parts of it are written against a
defect that will be gone by the time anyone opens it: the Gherkin scenario _"The citation gate is
read against a recorded baseline, never as a bare pass"_, the QA task recording before/after
finding counts, and the ADR above. The correction belongs to whoever picks US003 up.
`../03-SPRINTS/SPRINT-02.md` → _Dependencies_ carries it.

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
| US003 | `../17-STORY-PLANS/STORY-PLAN-US003-ABSENCE-GUIDE.md`           | Not started |

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

| Story | Deliverable                                                                                                 | Proven by                                                        |
| ----- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| US004 | Five repairs to `code/src/scripts/audits/doc-references.sh`, one register mechanism, one shipped-file sweep | The script's own `--self-test`: fixture pairs plus direct probes |
| US003 | `code/docs/ABSENCE.md` plus its registration, tier markers and reciprocity edits                            | Five documentation gates and a human read-across                 |

**US004 is the sprint's first story with an automated proof.** Its `--self-test` is the only
executable check either story ships, and `../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`
section 6 carries the method: measure by executing a patched scratch copy, never by reading.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, in build order. `22-implementation-documentation` runs between the lane above and
this phase and is a merge gate — it writes each story's `../18-TESTS/US###-TEST-STATUS.md` and
`US###-MANUAL-TESTING.md`, which **US004's own register rows make citable in advance**.

---

## Sprint-wide Constraints

### GDPR (`../09-GDPR/`)

**N/A** — both stories read `GDPR: N/A`. No personal data is read, written or logged; both ship
documentation and one shell script that reads repository files and emits paths.

### Security (`../10-SECURITY/`)

**N/A** as a flag, with one property worth asserting anyway: US004's self-test probe **writes
inside the repository**. It must create its file under a path the repository already owns, never
in `/tmp` with a predictable name, and remove it on every exit path. Recorded in
`../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` section 5.

### QA & SEO

Both QA plans are **Signed off**; SEO reads `N/A` on both stories. The sprint's QA union names
**two types** — US003's five-gate manual value and US004's unit value, the sprint's first
automated one.

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

- **`doc-references.sh` never reports a plain pass here.** Six findings survive US004 whatever it
  does — three citations of `code/docs/ABSENCE.md` belonging to US003, three of
  `code/src/scripts/audits/SLOP-FAMILY.md` belonging to **US002 in SPRINT-01**. Every survivor is
  named with the story that owns it.
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
- [ ] The five documentation gates US003's QA flag names run, and their output recorded
- [ ] `syntax/lint.sh` and `syntax/check.sh` pass, including ShellCheck over the edited script
- [ ] `code/src/scripts/audits/CONTEXT.md` is not grown — US002 owns that file's shape

---

## Sprint Definition of Done

- [ ] **US004 is Completed** — its own DoD complete, verified by a reviewer
- [ ] **US003 is Completed, or explicitly carried to SPRINT-03** with its reason recorded in
      `../03-SPRINTS/SPRINT-02.md`; a `Should` is never dropped silently
- [ ] All sprint-level verification checks passed
- [ ] No open HIGH/CRITICAL security findings — **N/A**, the sprint's Security flag reads `N/A`
- [ ] GDPR requirements implemented and verified — **N/A**, the GDPR flag reads `N/A`
- [ ] QA scenarios passing — manual for US003, the self-test for US004
- [ ] Both stories' implementation records written by `22-implementation-documentation`
- [ ] PRs merged and the version bumped
- [ ] `../03-SPRINTS/SPRINT-02.md` `**Status:**` set to `Done`

---

## Branch Naming Reference

Per `project-management/docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`.

| Story | Branch                          |
| ----- | ------------------------------- |
| US004 | `us004/citation-gate-git-index` |
| US003 | `us003/absence-guide`           |
