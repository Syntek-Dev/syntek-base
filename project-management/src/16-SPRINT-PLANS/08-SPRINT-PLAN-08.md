# SPRINT-PLAN-08 — The 09 debugging workflow runs through the scripts, and every log line carries a request_id

**Last Updated**: 01/11/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-08.md` · **Capacity:** 11 SP Must = 11 / 11 — at capacity, the fill trigger, all committed · **Stories:** 2

<!-- Written 01/11/2026 by a `16-sprint-plans` run. The record reached the fill trigger on
     01/11/2026 when US014 was admitted at 8 SP (../03-SPRINTS/SPRINT-08.md -> Notes), and the fill,
     not a close by call, owes this plan. It waited on every member clearing the specify tier
     (../../docs/planning/SPRINTS.md -> Capacity): US013's one live gate, 11, closed 31/10/2026
     (c4a5245); US014's gates 09, 10, 11 and 14 closed 01/11/2026 (5441954) and its ADR was
     accepted the same day (7f09c03), closing gate 15. So this plan is written AFTER every
     prerequisite holds, as ./07-SPRINT-PLAN-07.md was.

     STEP 0 drew its round from the recorded answers (.claude/skills/grilling/SKILL.md -> A decision
     already recorded is a fact). Every question in the Step 0 table was answered by an artefact:
     the fill (the record's Capacity line), the MoSCoW split (both members' MoSCoW sections), build
     order (the record's Dependencies, the reserved 13- and 14-), cross-sprint dependencies (the
     same), oversizing (US014's Story Points, reconfirmed after its gates), and the prerequisites
     (measured: every gate plan reads Signed off, no AC-GAP or LOG-GAP is [OPEN], the security
     assessment raises 0 CRITICAL and 0 HIGH). The residue went to <%DEVELOPER_NAME%> as
     16-sprint-plans grilling round 1 on 01/11/2026: Q1, what this plan says if US008 has not merged
     when US014 is ready — answered option 1, US014 waits, and the edge is a Definition of Done row.

     Both segments of this file's name read `08`, and that is an AGREEMENT rather than a
     coincidence: ./CLAUDE.md rules that a mismatch between the exec-order prefix and the
     sprint-number suffix is deliberate information and must NOT be "corrected". Plans 01- to 07-
     each build in sprint order, nothing in this sprint is pulled ahead of its number, and its one
     cross-sprint edge (US008, SPRINT-05) points backwards, so the eighth plan builds eighth. The
     plan MIRRORS the record; where the two would disagree the record wins, and the disagreement is
     named here rather than resolved by paraphrase. -->

---

## Sprint Goal

> Debugging an incident runs through the scripts against structured logs: the 09 workflow is
> honest and every log line carries a request_id.

<!-- The record's `**Goal:**` line, verbatim, on ./02-SPRINT-PLAN-02.md's convention that a plan
     carries the record's goal rather than a paraphrase so the two cannot drift. Settled 31/10/2026
     and confirmed 01/11/2026 on US014's admission as reading true of both members
     (../03-SPRINTS/SPRINT-08.md:8-24). The first clause is US013's, the second US014's. -->

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** neither member touches a model or a user journey.
>
> The authorities this sprint defers to are
> `../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` for the line contract, the
> collector contract and minimisation in place of redaction; `code/docs/GATE-REPORTING.md` for how a
> gate's result is reported; and `.claude/CLAUDE.md` Section 6 for the script-first rule.
> `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` slices `S-01` (N-001, N-012, N-013) and `S-07` (N-020)
> are the argued record of each story and are not re-opened here.
>
> **This sprint has one hard upstream edge that no member owns.** US014 rewrites all five settings
> modules and must merge after US008, which sits in the closed
> `project-management/src/03-SPRINTS/SPRINT-05.md` and still reads `Open`. See _Build order_
> below; the edge is a Definition of Done row, never a cleared dependency.

## Sprint Reference Documents

| Area              | Source                                                                                                                                                                                                                              |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sprint definition | `../03-SPRINTS/SPRINT-08.md`                                                                                                                                                                                                        |
| User stories      | `../02-STORIES/US013.md` · `../02-STORIES/US014.md`                                                                                                                                                                                 |
| Feature map       | `../01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` — `S-01` (US013), `S-07` (US014) · cut order `../02-STORIES/CUT-PLAN.md` P8                                                                                                              |
| Database          | **N/A** — neither member touches a model                                                                                                                                                                                            |
| User flows        | **N/A** — no user journey                                                                                                                                                                                                           |
| Brand & wireframe | **N/A** — no frontend story                                                                                                                                                                                                         |
| GDPR              | `../09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md` (US014 only; US013's flag reads `N/A`)                                                                                                                             |
| Security          | `../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` · `../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` (US014 only)                                     |
| QA                | `../11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` · `../11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md`                                                                                                         |
| SEO               | **N/A** — no public page                                                                                                                                                                                                            |
| API design        | **N/A** — no endpoint                                                                                                                                                                                                               |
| Logging           | `../14-LOGGING/PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md` (US014 only)                                                                                                                                              |
| Decisions         | `../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` · `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (the `doc-references.sh` reading regime both members are checked under) |
| **Story plans**   | Reserved `13-` (US013) and `14-` (US014) — **numbers, not plans**, until `17-story-plans` writes them                                                                                                                               |

---

## Stories

### Must

| ID    | Title                                                                                                                      | Phases touched                          | SP  | Story plan                                                         | Git branch                      |
| ----- | -------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- | --- | ------------------------------------------------------------------ | ------------------------------- |
| US013 | The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause | Docs + `copier.yml` text — no code lane | 3   | `../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` | `us013/log-debug-workflow-seam` |
| US014 | Structured JSON logging with a `request_id` on every entry, queried by Compose service label                               | Backend                                 | 8   | `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` | `us014/structured-json-logging` |

### Should

None. The record is all-`Must` at 11 / 11, with no stretch tier (`../03-SPRINTS/SPRINT-08.md` ->
Story Summary).

### Could

None.

### Won't (this sprint)

None named. The record is closed to admission from 01/11/2026; SPRINT-07's dropped US011, should it
drop, has no receiving record here (19 / 11 is past the grace ceiling) and stays owed to
`03-sprint-planning` (`../03-SPRINTS/SPRINT-08.md` -> Notes).

<!-- The template's "Avoid an all-Must sprint" is not met, and that is recorded rather than
     corrected: both Musts were settled 21/09/2026 (CUT-PLAN.md, MAP-RULE-OWNERSHIP round, Q6) and
     confirmed at each cut, and P8 gives this record to the two of them alone. A Should cannot be
     added without spending a reservation P8 does not hold. -->

---

## Build order — US013 then US014, and both name segments read `08`

- **US013 builds first, at `13-`.** It has no upstream dependency
  (`../02-STORIES/US013.md` -> Dependencies).
- **US014 builds second, at `14-`,** and merges after US013, rebasing onto its edits to 09
  Step 4, 09 `CONTEXT.md` and the `code/src/logs/` pair.
- **US014 merges after US008** (`../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`).
  US008 edits `base.py`, `staging.py`, `production.py` and `EDGE-REQUIREMENTS.md` and pins
  `dev.py` and `test.py`; US014 rewrites all five settings modules and adds a log section to
  `EDGE-REQUIREMENTS.md`, so it lands second. **If US008 has not merged when US014 is otherwise
  ready, US014 waits** — its status moves to `Blocked`, which is `completion`'s call, and the sprint
  cannot reach `Done` without it (settled 01/11/2026, 16-sprint-plans grilling round 1 Q1). It is
  never landed first with US008 rebased onto it: that reverses the settled order and stales US008's
  story plan.
- **Amended 01/11/2026 — US013 and US008 are hard start gates for US014** (17-story-plans grilling
  round 2 Q3). No work on US014, its before-first-edit baselines included, starts until both have
  merged, and its branch is cut from `main` after both. This supersedes, for US014's start, the
  merge-order-only reading in the two bullets above; the merge order itself is unchanged. At
  `17-story-plans` Step 10 US014 moved `Open` -> `Blocked`, and US013 `Open` -> `Pending`.
- **Neither blocks on US004.** `doc-references.sh` is read under the baseline-diff regime unless
  US004 has landed and the gate is green.

The numbers move if build order does. Until 01/11/2026 both were reservations, which nothing here
could cite as a plan (SPRINT-04's rule for US006's `07-`); `17-story-plans` wrote both that day.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. **Both plans exist.**
`17-story-plans` wrote each on 01/11/2026, after this plan — its Step 1 gathers the sprint plan
first — and its Step 10 repointed each row below at its file. Neither prefix was assigned by this
file; each is the reservation the record held.

| Story | Story plan (`../17-STORY-PLANS/`)                                  | Manual testing guide (`../18-TESTS/MANUAL/`) |
| ----- | ------------------------------------------------------------------ | -------------------------------------------- |
| US013 | `../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` | `../18-TESTS/MANUAL/US013-MANUAL-TESTING.md` |
| US014 | `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` | `../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` |

**Each manual testing guide is written straight after its story plan and committed with it**
(settled 03/10/2026, 16-sprint-plans grilling round 9 Q22). Both members owe one: US013's QA flag
names a manual type, and US014's QA plan carries manual scenarios beside its unit suite.

**No status column, and no status line on this plan.** `SPRINT-PLANS-BOARD.md` shows this plan
under `SPRINT-08`'s status, and `STORY-PLANS-BOARD.md` shows each story plan under its `US###`'s.

---

## Phase Breakdown

Tests are written **alongside** each phase, never after. The phases a member does not touch are
recorded as `N/A` with a reason rather than deleted, per `code/docs/GATE-REPORTING.md`.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**Stories:** US014
**Key deliverables:**

- `apps/core/observability.py` — the hand-written JSON formatter and the `request_id` filter, per
  the ADR's line contract
- `LOGGING` rewritten in all five settings modules — the filter on every handler, per-environment
  levels and field sets (dev wide; staging and production minimal, with the allowlist)
- `apps/core/tests/unit/test_observability.py`, marked `story("US014")`
- The collector contract in `EDGE-REQUIREMENTS.md` and the must-edit documentation set the story
  lists

No model, service or migration. The field-level detail is the story plan's.

### Phase 2 — API (`../../workflows/20-api-code`)

**N/A** — no Django Ninja router, endpoint or Schema, and no MCP tool. Both read `API: N/A`.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**N/A** — no view, template, component or CSS. Both read `Frontend: N/A`.

### The lane US013 runs in

| Story | Deliverable                                                                                                                                                                                       | Proven by                                                                                                                                                                                                                                                   |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US013 | The 09 debugging workflow's steps run through the scripts, its vendor names render from the Copier answers, and it stops at the root cause — Markdown and `copier.yml` comment and help text only | The four doc gates (`docs-length.sh`, `docs-pairing.sh`, `doc-references.sh` under the baseline regime, `doctrine-drift.sh` as regression only), the generated-project check on every render path the template offers, and its manual testing guide, walked |

US013 ships no Python, and `Backend: N/A` stands; which PM workflow its story plan enters to build
it is that plan's to state.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

Both stories, US013 then US014, each behind its own gate. `22-implementation-documentation` runs
between the build and this phase and is a merge gate: it writes each story's test-status record
under `../18-TESTS/AUTOMATED/`, walks each manual testing guide under `../18-TESTS/MANUAL/`, and
owns this sprint's register write — the `DEFERRED.md` entry for US013's out-of-scope vendor
literals, as US013's own Definition of Done provides. Items 1-2 of `GAPS.md`'s 17/09/2026 entry left
the register on 01/11/2026 (`.claude/CLAUDE.md` Section 9), so there is nothing to close. US014 does
not open its PR until US008 has merged.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story plan and the spec it cites. Every row
is US014's; US013's GDPR, Security, SEO and Logging flags read `N/A`.

### GDPR (`../09-GDPR/`)

- Personal data is **incidental** — no new field is collected. Request paths, remote addresses and
  exception text may reach stdout; the answer is **field minimisation, not redaction**: staging and
  production serialise only the fixed keys and the allowlisted extras, and `message` is not
  scrubbed. The lawful basis, retention numbers and rights position are surfaced to each generated
  project's controller, not decided here.

### Security (`../10-SECURITY/`)

- OWASP **A09:2025** is the surface. Twenty findings across all six STRIDE categories: **0
  CRITICAL, 0 HIGH, 0 MEDIUM, 18 LOW, 2 INFO** — nothing gates this sprint and nothing escalates
  to `VULNERABILITIES/`. Nine LOWs promote across seven trigger rows, and each stays the
  assessment's to track.
- Staging and production emit the exception **type and frames, never the exception message**; the
  `django` logger runs at `WARNING` there.

### QA (`../11-QA/`)

- Both QA plans are **Signed off**; US013's twelve gaps and US014's eighteen are all `[RESOLVED]`.
  No `[OPEN]` acceptance-criteria gap remains in either.
- US014's unit suite asserts the filter on every handler in every environment, the field set, the
  `TZ`-independent UTC timestamp and the allowlist; `apps/core` stays at or above the coverage floor.

### Logging (`../14-LOGGING/`)

- The story **is** the pipeline: the formatter and the `request_id` filter on every handler
  Django's `LOGGING` declares, `request_id` always present and `null` outside the middleware's
  extent, the app stream only, no named loggers. The logging plan is **Signed off** with no
  `[OPEN]` row; the exclusion check is run at `22`.

### SEO (`../12-SEO/`)

- **N/A** — no public page this sprint.

### Decisions binding this sprint

- `../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` — **Accepted**. The line
  contract, the collector contract keyed on the Compose service label with an environment label,
  the edge setting `X-Request-ID` unconditionally, and minimisation in place of redaction. Where a
  story plan and the ADR differ, the ADR wins until superseded.

---

## Sprint Verification Checklist

Run via the project scripts under `code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`,
`pytest`, `pnpm`, `uv` or `docker` call. The full per-check list with its `N/A` reasons is
`../03-SPRINTS/SPRINT-08.md` -> _Verification Checks_ and is not restated here.

- [ ] `docs-length.sh`, `docs-pairing.sh` and `doctrine-drift.sh` pass — `doctrine-drift.sh` as a
      regression guard only
- [ ] `doc-references.sh` read as a diff against the baseline captured before the first edit,
      unless US004 has landed and the gate is green
- [ ] The generated-project check, with the render paths it ran recorded (US013)
- [ ] `lint.sh` and `check.sh` pass — Markdown for both members, US014's Python
- [ ] `negative-space.sh` passes — `RequestIDMiddleware` stays listed (US014)
- [ ] `tests/all.sh --coverage` passes — US014's unit suite, `apps/core` at or above the floor
- [ ] US014's logging plan satisfied and the exclusion check run; its GDPR tasks checked off and
      its security criteria signed off
- [ ] Both manual testing guides walked at `22-implementation-documentation`, every row marked, and
      signed off
- [ ] `migrate.sh check` — **N/A**, neither member touches a model
- [ ] Template, component and accessibility (WCAG 2.2 AA) checks — **N/A**, no page or interactive
      surface
- [ ] SEO criteria — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] No secrets, debug flags or hardcoded IDs introduced

---

## Sprint Definition of Done

- [ ] **Both `Must` stories are Completed — US013 and US014**, each story plan's own Definition of
      Done complete and verified by a reviewer
- [ ] **US014 merged after US008.** Until US008 merges, US014 waits — `Blocked` is `completion`'s
      call — and this sprint cannot reach `Done` (settled 01/11/2026, 16-sprint-plans grilling
      round 1 Q1). **Since 17-story-plans grilling round 2 Q3 (01/11/2026), US014 also does not
      start until US013 and US008 have both merged**
- [ ] US014 merged after US013, rebased onto its edits to the 09 folder and the `code/src/logs/`
      pair
- [ ] No open Critical or High security finding
- [ ] US014's GDPR constraints implemented and verified per `../09-GDPR/`; GDPR gaps found during
      the sprint documented in the record
- [ ] All QA scenarios passing, automated and manual, per `../11-QA/`; no `[OPEN]` gap in either
      QA plan
- [ ] The `DEFERRED.md` entry for the out-of-scope vendor literals written by
      `22-implementation-documentation` (US013); items 1-2 of `GAPS.md`'s 17/09/2026 entry already
      left the register on 01/11/2026
- [ ] All changes merged to `main` (or the active release branch); CI passing
- [ ] Sprint `**Status:**` set to `Done` by `completion`; version bumped if this sprint produces a
      release
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-08.md` (optional)

---

## Branch Naming Reference

Per `../../docs/GIT-GUIDE.md`: `us###/<kebab-descriptor>`, five words or fewer.

| Story | Branch                          |
| ----- | ------------------------------- |
| US013 | `us013/log-debug-workflow-seam` |
| US014 | `us014/structured-json-logging` |

Neither is invented here. `17-story-plans` set each on 01/11/2026, and this table was filled from
each plan's `Branch` row — the precedent `./01-SPRINT-PLAN-01.md` set on 07/09/2026. Both rows read
"_not yet set — the `Branch` row of its story plan_" until then.

**Both branches are cut from `main`, and not yet**, on the reasoning `./01-SPRINT-PLAN-01.md`
recorded on 02/09/2026: every planning artefact these stories depend on lives on
`pm/story-creation`, none of it merged to `main`. The sequence is: the planning workflows complete
-> `pm/story-creation` is raised as a PR to `main` -> the `us###/` branches are cut from `main` and
the stories implemented, US013 ahead of US014; US014's branch is cut only after US013 and US008
have both merged (17-story-plans grilling round 2 Q3).
