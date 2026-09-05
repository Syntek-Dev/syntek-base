# SPRINT-04

**Last Updated**: 05/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** The rule that only Claude's compliance enforces becomes a guard the destructive scripts
enforce themselves — six of them read the deployment posture, and five refuse above `development`
unless the operator names the live posture out loud.

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **8 / 11 SP** — inside capacity, all-`Must`, and **still
admitting**. The figure is contingent: SPRINT-03 reserves a 5 SP carry to this record, and if it
lands this sprint is 13 / 11 and at grace. See Notes.

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 05/09/2026 on US006's admission — the union over one member is that member's table.
     Two rows carry values, and both moved at a gate rather than at cutting: Security was widened
     at 10-security-checks on 05/09/2026 from the eight criteria the story carried, and QA was
     widened at 11-qa-checks the same day when the four-versus-six carrier-state count was
     replaced by a single enumerated proof-case list (QA-PLAN-US006 AC-GAP-7). Precedent for a
     same-day gate widening reaching the sprint's union is SPRINT-03, whose Security row moved on
     US005's assessment and whose QA row moved on US003's admission.
     Eleven rows stay N/A because this sprint ships a bash helper, six shell callers, one CI
     workflow line, two registers and three Markdown files: no model, no endpoint, no screen, no
     personal-data path, no log line, no public page. -->

| Flag       | Value                                                                                                         |
| ---------- | ------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                           |
| User Flow  | N/A                                                                                                           |
| Brand      | N/A                                                                                                           |
| Components | N/A                                                                                                           |
| Wireframes | N/A                                                                                                           |
| GDPR       | N/A                                                                                                           |
| Security   | fail-open carrier read · template stand-down · control removal · unrecoverable carrier · CI standing override |
| QA         | unit — guard self-test over the enumerated proof-case list; manual — that same list walked by hand            |
| SEO        | N/A                                                                                                           |
| API        | N/A                                                                                                           |
| Logging    | N/A                                                                                                           |
| Backend    | N/A                                                                                                           |
| Frontend   | N/A                                                                                                           |

---

## Story Summary

| ID    | Title                                                                                        | MoSCoW    | SP  |
| ----- | -------------------------------------------------------------------------------------------- | --------- | --- |
| US006 | The destructive dev scripts read the deployment posture, and refuse to run above development | Must Have | 8   |

**Total:** 8 SP — all committed, no stretch tier. **This is the sprint's known weakness**; see
Notes.

## Dependencies

- **US006 has no upstream dependency.** It is cut from
  `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` slice `S-01`, whose map records
  `Frontier open: 0 · Blocking open: 0` and whose `Gate to stories` states both slices may be cut
  now.
- **One ordering constraint, and it is cross-sprint.** US006's citation-gate Verification Check is
  written against two different regimes depending on whether **US004** — SPRINT-02's sole `Must` —
  has landed. US004 retires the baseline-diff regime of
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` by its
  own terms, after which this gate exits `0` on a clean tree and is read as a plain pass. **US006
  does not block on US004** — the check names both branches explicitly, which is what
  `QA-PLAN-US006-POSTURE-GUARD` AC-GAP-15 closed — but building SPRINT-02 first removes a branch
  rather than resolving it, and sprint numbering is not execution order.
- **US006 collides with no other story's files.** It writes into none of `code/docs/ABSENCE.md`
  (US003 creates it), `code/docs/reliability/` (US001 creates it), or
  `code/src/scripts/audits/CONTEXT.md` (US002 owns its headroom, at 298 of 300 **code** lines as
  `audits/docs-length.sh` measures them). The last was a live risk at slice selection: hosting the
  guard's proof in a new `audits/` gate would have cost two rows in that file, and the proof went
  to `database/migrate.sh --self-test` instead.
- **US006 does not unblock `S-02`** ("The seed presence gate") on its own map. The two slices share
  no file — `S-02` writes only `.github/scripts/shipped-artefacts.sh` — and widening US006 to carry
  both was declined at slice selection for want of a shared seam. **`S-02` is the obvious second
  member of this sprint and is not yet cut into a story.**
- **US006 runs beside US005 and shares no file with it.** US005 is parallel work on
  `MAP-RETRY-AND-IDEMPOTENCY` in SPRINT-03. Since US006 moved to this record on 05/09/2026 the two
  sessions share no artefact at all — the sprint record was the one overlap — which is what makes
  path-scoped staging on `pm/story-creation` safe for both without a worktree.
- **This sprint's own contingency is a dependency in the other direction:** SPRINT-03's Definition
  of Done reserves a carry to **this record**. See Notes; it is not a blocker, it is an arithmetic
  risk on the capacity line.

## Notes

**This sprint opens with one all-`Must` member, and that is its known weakness rather than an
oversight.** `project-management/docs/planning/SPRINTS.md` is explicit: "**Avoid a plan where
everything is Must.** If every story is Must, the sprint has no give and the first surprise breaks
it." SPRINT-03 hit the same shape on opening and named it "this sprint's one real weakness", and
repaired it by admitting US003 as a `Should`. **No such repair is available here.** The candidate
give is `S-02` on the same map, which is not cut into a story; every other open slice belongs to a
different map and a different session. Recorded rather than papered over, and it is the reason
this record stays open to admission.

**The capacity figure is contingent, and the contingency is SPRINT-03's to exercise.**
`project-management/src/03-SPRINTS/SPRINT-03.md` Definition of Done provides that its `Should Have`
member — US003, 5 SP — is "either **Completed** or explicitly carried to SPRINT-04 with its reason
recorded", and `project-management/src/16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` repeats it. So there
are two futures for this line and both are recorded now rather than discovered later:

| If US003…              | This sprint stands at                  | Reading                                                                                  |
| ---------------------- | -------------------------------------- | ---------------------------------------------------------------------------------------- |
| completes in SPRINT-03 | **8 / 11 SP**, all `Must`              | Inside capacity. The all-`Must` weakness above stands and this record is still admitting |
| carries to SPRINT-04   | **13 / 11 SP** — 8 `Must` + 5 `Should` | **At grace**, and the weakness is repaired: the carry is give that can slip again        |

**The second is the better sprint, and it is not this record's decision to take.** Grace is
reserved for a story that would otherwise split badly, and a carry-over is not that — but a carry
arriving into a single-member sprint is precisely the case where 13 SP buys a stretch tier rather
than an overcommitment, because the `Must` tier stays at 8 either way. **If US003 carries here, do
not treat the 13 as an overrun**; that reading is what SPRINT-02 recorded when its own grace
covered "the ceiling, not the commitment". Whoever closes SPRINT-03 makes the call and records it
in both records.

**US006's own Dependencies section cited the wrong reservation until 05/09/2026, and the
correction is why this table exists.** It named "the 5 SP `Should Have` carry-over that SPRINT-02's
Definition of Done reserves" — but SPRINT-02 exercised that reservation the same day, moving US003
to SPRINT-03, and its DoD now reads "**No `Should Have` story remains here.**" The live reservation
is SPRINT-03's. Caught at `11-qa-checks` as `QA-PLAN-US006-POSTURE-GUARD` AC-GAP-16 and corrected
in place in the story, superseded text preserved.

**US006 was refused admission to SPRINT-03 on 05/09/2026, and the arithmetic that refused it is
recorded there rather than re-argued here.** SPRINT-03 stood at 5 SP all-`Must` when the question
was live, so 8 more would have taken it to 13 — its grace ceiling — and displaced the reservation
above. Measured against SPRINT-03 as it now stands, at 10 / 11, US006 would give 18 SP: over grace
rather than at it. Either reading refuses it. Opening this record was <%DEVELOPER_NAME%>'s call.

**This record was opened after gates `10`, `11` and `15`, not at `03`, and the deviation is
deliberate.** `project-management/docs/planning/CADENCE.md` fixes the running order
`02 → 03 → … → 15`. SPRINT-03 states the precedent in its own Notes: a sprint record opens when its
member has cleared the specify tier, because gates `10` and `11` supply the record's Security and
QA sections and gate `15` supplies the decisions those sections rest on. Opening at `03` would mean
authoring sections those gates immediately rewrite — which is not hypothetical here, since gate
`11` widened the QA flag value this record's union carries.

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint once
every member has cleared `15-decisions`.** US006 has: its QA plan
(`project-management/src/11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md`) carries no `[OPEN]` gap —
all twenty-two resolved 05/09/2026 — and both its ADRs are written and `Accepted`:
`project-management/src/15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` and
`project-management/src/15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md`, the
second carrying a dated erratum on the size of the fail-closed set. CADENCE's
no-unresolved-gap prerequisite is therefore satisfied for the sole member, and `16` may run
whenever the carry-over question above is settled. **Do not run `16` before it is**, because the
plan is written against a settled story set and this one has two possible shapes.

---

## Acceptance Criteria

One outcome, one member.

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
     them is the twelve developer constraints the security gate produced and this sprint's QA gate
     amended. Substituting rather than deleting, per code/docs/GATE-REPORTING.md: a section removed
     reads as a gate that did not apply, and this one did — it is the story's whole subject.
     ALL OF IT IS US006's, this record having one member. -->

- [ ] The **twelve** developer constraints in `project-management/src/02-STORIES/US006.md` Section 7.1 to
      Section 7.12 are satisfied, each checkable by reading the shipped helper and its six callers.
      **Eleven of the twelve are Section 7 of
      `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md`;
      three of those eleven were amended and a twelfth added at `11-qa-checks` on 05/09/2026** —
      where the story and the assessment now disagree, the story is the corrected record and the
      assessment is the one to update
- [ ] **No CRITICAL or HIGH finding is open.** The gate closed 05/09/2026 with eighteen findings
      across all six STRIDE categories — 0 CRITICAL, 0 HIGH, 9 MEDIUM, 7 LOW, 2 INFO — so nothing
      blocks sprint planning and nothing escalates to
      `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/`. That is a decision with its
      reason recorded, not an audit that found nothing
- [ ] The present-state severities are read **with** the promotion-trigger table in
      `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md`.
      **Five findings promote to HIGH at the first staging surface**, and TM-02 and TM-08 promote at
      the first `copier update` run against a project above `development` — every MEDIUM here is a
      fact about a tree with nothing deployed, and it expires the day that stops being true
- [ ] **The four fail-open paths the story left open at cutting are closed**, and each is verified
      as closed rather than assumed: the unconstrained override in a damaged carrier (AC-GAP-4),
      the unforwardable override across the `seed-dev.sh` shell-out (AC-GAP-3), the compose-target
      assertion with no criterion and no test (AC-GAP-11), and the CI override with no named owner
      (AC-GAP-13)
- [ ] The guard call is asserted **present** in each of the six bound scripts, as a line-order
      comparison — a tested function is not an enforced control (TM-03)
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint — the guard
      reads the answers file, prints the posture, and prints nothing else from it (TM-15)

### QA Acceptance Criteria — Automated

<!-- New at US006's admission, and this is the first sprint since SPRINT-02 whose QA union names an
     automated type. Its single member is the only contributor to every row. -->

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
- [ ] Coverage floors — **N/A**, this sprint ships no Python path; the proof is the `--self-test`,
      and there is no Django code path for the floor to measure

### QA Acceptance Criteria — Manual

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US006-MANUAL-TESTING.md` carries a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in
      `project-management/src/11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` — twenty-two found,
      twenty-two resolved 05/09/2026

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in the story file.

### Security Tasks

| Story | Task                                                                                                                     | Done |
| ----- | ------------------------------------------------------------------------------------------------------------------------ | ---- |
| US006 | Satisfy Section 7.1 to Section 7.12, and update `ASSESSMENT-PLAN-US006-POSTURE-GUARD` Section 7 to match the amended set | [ ]  |
| US006 | Confirm each design-state promotion trigger names a surface or event that can actually fire it                           | [ ]  |
| US006 | Assert the guard call present in all six bound scripts by line-order comparison                                          | [ ]  |
| US006 | Name the CI override's owner and trigger beside the literal at `.github/workflows/test-e2e.yml:133`                      | [ ]  |

### QA Tasks — Automated

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

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships a
     bash helper, six shell callers, one workflow line and Markdown, and per
     code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/database/migrate.sh --self-test` exits 0
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass —
      ShellCheck clean over the new helper and all six callers, with the `# shellcheck source=`
      directive resolving in each
- [ ] `bash code/src/scripts/audits/doc-references.sh` — **which reading applies is contingent on
      US004 and both branches are named, per `QA-PLAN-US006-POSTURE-GUARD` AC-GAP-15.** If US004 has
      landed, it exits `0` on a clean tree and is read as a plain pass, the baseline-diff regime
      having retired by its own terms. If it has not, it is read as a diff against the baseline
      recorded in the QA plan's Section 7 — and never as a bare pass. **Two figures, both measured
      05/09/2026 at HEAD `c6df520`, and the diff is between them, not against either alone:**
      **103 tree-wide and 9 on `US006.md`** on the clean tree before this sprint's artefacts were
      written, and **127 tree-wide** with them staged. Every one of the 24 added is an instance
      citation of a PM artefact — the class `ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`
      exempts — or a forward reference to `code/docs/ABSENCE.md`, `code/docs/reliability/` or this
      story's own `posture-guard.sh`, each clearing when US003, US001 or US006 lands. **None is of
      a class this sprint owns.** The index state is recorded beside every figure because it must
      be: the same tree gave 153 an hour earlier, when a parallel session's two plan files were
      still untracked and contributed 69 of the difference
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance, and `code/src/scripts/audits/CONTEXT.md` is unchanged
      at **298 code lines as that gate measures them**, not the 357 `wc -l` reports. US002 in
      SPRINT-01 owns its headroom
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` passes — this sprint edits both halves of the
      `code/src/scripts/_lib/` pair, adding the helper to `CONTEXT.md` and the caller contract to
      `CLAUDE.md`. It creates no new directory and so owes no new pair
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — **regression only.** This sprint adds no
      claims row, and the guard's contract is prose. A green run says the registered claims are
      undisturbed and says **nothing** about the posture rule appearing in two homes; it is never
      reported as though it had
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — **N/A**, this sprint adds no routing
      frontmatter. Marked with its reason rather than deleted
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a Python path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies**, and unlike SPRINT-03 it is this
      sprint's whole subject rather than one member's contribution
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its own
      DoD complete) — US006 alone
- [ ] **The carry-over question is disposed of in writing, either way.** If US003 carried here from
      SPRINT-03 it is `Completed` or carried on again with its reason recorded in both records; if
      it did not, that is stated here rather than left as an unexplained 8 / 11
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in the member's QA plan
- [ ] `ASSESSMENT-PLAN-US006-POSTURE-GUARD` Section 7 has been updated to the amended twelve, so the
      security record and the story no longer disagree
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity
- [ ] Retrospective notes captured (optional — link or inline)
