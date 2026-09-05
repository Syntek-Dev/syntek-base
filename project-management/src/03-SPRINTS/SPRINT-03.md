# SPRINT-03

**Last Updated**: 05/09/2026 **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

**Goal:** Retry doctrine gets its single owner, and the absence guide it was waiting behind ships
beside it — exactly one layer decides to repeat an operation, and every `return None` in the tree
means one stated thing.

**Status:** Planned

<!-- The sprint status vocabulary and its transitions are owned by
     `.claude/skills/completion/SKILL.md` -> The status vocabulary. Not restated here. -->

**Timeline:** TBD · **Capacity:** **5 SP Must + 5 SP Should = 10 / 11 SP** — inside capacity, and
still admitting

<!-- FLAGS — the union of the member stories' flags. Recompute this table on every story
     admitted, never edit it directly.
     Computed 05/09/2026 on US005's admission — the union over one member is that member's table.
     Recomputed 05/09/2026 when the security gate widened US005's Security value from "retry
     amplification" to four subjects (QA-PLAN-US005 AC-GAP-15). Precedent for a same-day gate
     widening is SPRINT-01, whose QA row moved when QA-PLAN-US001 AC-GAP-6 landed.
     Recomputed 05/09/2026 on US003's admission from SPRINT-02, and CHANGED in one row: US003's
     QA value adds routing-skills and skill-conformance to the three US005 names. Its other
     twelve rows are N/A and change nothing, including Security — the widened value is US005's
     alone. Per SPRINTS.md the union is never narrowed, so both halves are carried in full.
     SPELLING, so it is not read as drift: US005's flag writes the script names with .sh and
     US003's without. The union writes all five with .sh; the full paths are in the Verification
     Checks, and neither story's own flag is rewritten to match the other.
     Eleven rows stay N/A because both members ship documentation only: no model, no endpoint, no
     screen, no personal-data path, no log line, no public page. -->

| Flag       | Value                                                                                                            |
| ---------- | ---------------------------------------------------------------------------------------------------------------- |
| DB         | N/A                                                                                                              |
| User Flow  | N/A                                                                                                              |
| Brand      | N/A                                                                                                              |
| Components | N/A                                                                                                              |
| Wireframes | N/A                                                                                                              |
| GDPR       | N/A                                                                                                              |
| Security   | retry amplification · untrusted `Retry-After` · duplicate execution · attempt-log leakage                        |
| QA         | manual — `docs-length.sh`, `doc-references.sh`, `doctrine-drift.sh`, `routing-skills.sh`, `skill-conformance.sh` |
| SEO        | N/A                                                                                                              |
| API        | N/A                                                                                                              |
| Logging    | N/A                                                                                                              |
| Backend    | N/A                                                                                                              |
| Frontend   | N/A                                                                                                              |

---

## Story Summary

| ID    | Title                                                                          | MoSCoW      | SP  |
| ----- | ------------------------------------------------------------------------------ | ----------- | --- |
| US005 | Exactly one layer decides to retry, and every budget says how long it may take | Must Have   | 5   |
| US003 | Absence gets an owning guide, born under 270 with every clause's tier stated   | Should Have | 5   |

**Total:** 10 SP — **5 committed, 5 stretch**

## Dependencies

- **Both members are blocked by a story in an earlier sprint, and neither blocker has shipped.**
  This is the first sprint record in which that is true of every member, and it is the fact that
  governs when this sprint can start rather than when it is full.
- **US005 is blocked by `project-management/src/02-STORIES/US001.md`** — a SPRINT-01 member, still
  `Open`, in a sprint that is `Planned`. US005's four rules are stated **inside** the
  `code/docs/reliability/` family, and that family is US001's deliverable; it exists in no branch
  and no commit today.
- **US003 is blocked in ordering, not in content, by
  `project-management/src/02-STORIES/US004.md`** — a SPRINT-02 member. US003's acceptance reads
  `doc-references.sh` as a diff against a recorded baseline, and US004 removes the defect that
  baseline exists for. SPRINT-02 settled on 02/09/2026 that US004 is built first, so that US003 is
  worked against a gate that simply passes. **That ordering survived US003's move here** — it is
  now a cross-sprint constraint rather than an intra-sprint one, which is exactly the kind of fact
  a move like this loses if it is not restated.
- **US003 arrives carrying a revision pass**, recorded in SPRINT-02 and repeated here because the
  obligation travels with the story. Three parts of it are written against a defect US004 removes:
  the Gherkin scenario _"The citation gate is read against a recorded baseline, never as a bare
  pass"_, the QA task recording before/after finding counts, and
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`. Once
  US004 lands, that scenario should read as a plain pass. **The correction belongs to whoever picks
  US003 up.**
- **`project-management/docs/planning/SPRINTS.md` is explicit that sprint numbering is not
  execution order**, and that a story is never scheduled ahead of its blocker. **The exec-order
  segment of this sprint's plan may therefore not read `03`.**
  `project-management/src/16-SPRINT-PLANS/{exec-order}-SPRINT-PLAN-03.md` carries a build-sequence
  segment and a sprint-number segment, and they diverge deliberately when a sprint must be built
  out of number order. Flagged here rather than left to be rediscovered at `16-sprint-plans`,
  because the skill that names that file will not re-derive two cross-sprint blockers. **Do not
  "correct" the mismatch if it appears.**
- **`Blocked` is a story status, not a sprint one.** This sprint's `Status` stays `Planned`; the
  blockers are recorded here and in the stories, and it is each story's own `Status` that moves if
  its wait becomes real.
- **The two members share no file and neither blocks the other.** US005 writes retry doctrine into
  `code/docs/reliability/`; US003 creates `code/docs/ABSENCE.md`. They may be worked in either
  order once their respective blockers clear.
- **US005 unblocks three slices** on
  `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` — `S-04` (the
  example-repair sweep), `S-05` (the `retry-discipline.sh` gate, whose claims row pins this
  doctrine's wording) and `S-06` (the live-code fixes). None is yet cut into a story.
- **US003 unblocks five slices** on
  `project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md` — `S-02` (the Python `None` clause),
  `S-03` (the HTMX contract), `S-04` (the optional-surface remainders), `S-05` (tiers and the
  mechanical legs) and `S-06` (consumer wiring). Every one cites the guide US003 creates.
- **Two slices run beside US005 and neither blocks it:** `S-09`, the outbound timeout register
  split out of `S-02` at story creation, and `S-03` on the same map, the idempotency half of the
  same rule — named as a runs-beside dependency at the QA gate on 05/09/2026 (`AC-GAP-11`).

## Notes

**US003 moved here from SPRINT-02 on 05/09/2026, before either sprint was worked.** SPRINT-02 was
admitted at 13 SP against a capacity of 11 — at grace — with US004 as its 8 SP `Must` and US003 as
a 5 SP `Should` stretch on top. Moving the stretch out puts **SPRINT-02 back inside capacity at
8 / 11 and leaves this sprint at 10 / 11**, and neither sprint now needs grace. It is a re-plan
rather than a carry-over: SPRINT-02's Definition of Done provides for US003 being carried at
**close**, and this happened before it opened, so the move is recorded in both records rather than
ticked off there.

**It also repairs this sprint's one real weakness.** Opened with US005 alone, SPRINT-03 was a
single all-`Must` member, which `project-management/docs/planning/SPRINTS.md` warns against — a
plan with no give, where the first surprise breaks it. There was no honest way to fix that from
within the retry map: `S-04`, `S-05` and `S-06` all block on US005 itself, and `S-03` and `S-09`
are not yet cut. US003 is give this sprint can actually drop: if US005 overruns, the `Should` slips
and the sprint still succeeds.

**US006 is not admitted here, and that was a live question.** It was cut from
`project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` in a parallel session on 05/09/2026
at 8 SP `Must Have`, and its own Dependencies section names this sprint as the one it joins.
**Settled 05/09/2026: US006 goes to SPRINT-04.** The counterfactual is dated, because the
arithmetic moved under it the same day: **at the moment the question was live this sprint stood at
5 SP all-`Must`**, so US006's 8 SP would have taken it to 13 — its grace ceiling, which is the
figure `project-management/src/02-STORIES/US006.md` records. US003 was admitted afterwards, so
measured against the sprint as it now stands US006 would give **18 SP (13 Must, 5 Should)** — over
grace rather than at it. Either reading refuses it, and grace is for a story that would split
badly, not for a story that arrives while there is room. **US006's own
story file has since been corrected in that session** — as of 05/09/2026 its Dependencies section
records `SPRINT-04` as the sprint it opens, so the two records agree.

<!-- The sentence replaced here read: "US006's own story file still says otherwise and is being
     written in that other session; correcting it belongs to that session, not this record." True
     when written and superseded the same day, 05/09/2026, when that session recorded the reversal
     in US006's Dependencies. Kept rather than erased, so the deferral reads as a decision that was
     honoured rather than one that was never made. -->

**This sprint is still admitting.** 1 SP of headroom is not a slot, so in practice it is closed by
arithmetic rather than by decision — but nothing here forecloses a small story that clears its
specify tier before either blocker lands.

**Sprint plans (`16-sprint-plans`) and story plans (`17-story-plans`) run for this sprint once
every member has cleared `15-decisions`.** Both have. US005's QA plan carried one `[OPEN]`
acceptance-criteria gap during this session — the boto3 clamp literal, `AC-GAP-1` — and it closed
the same day, so `project-management/docs/planning/CADENCE.md`'s no-unresolved-gap prerequisite is
satisfied for both members.

---

## Acceptance Criteria

Two independent outcomes, one per member, and the five documentation gates run clean against both.

**US005** — cross-surface retry doctrine states four things once, in the reliability family: who
decides to repeat an operation, how an inbound `Retry-After` is honoured, what every retry's
budget is, and why circuit breakers are deferred. Every guide that previously stated a competing
budget either cites the family or carries a number that agrees with it; no worked example in the
tree demonstrates a shape the doctrine bans; and no guide is left telling a reader the opposite of
the owner rule.

**US003** — `code/docs/ABSENCE.md` exists as the single owner of what an absence means — six kinds
and a five-surface runtime crib — born inside the length ratchet, registered on every surface it
owes, with each clause carrying an honest enforcement tier and every rule another guide already
owns cited rather than restated.

### Security Acceptance Criteria

<!-- Kept, and this is the first sprint record to keep them: SPRINT-01 and SPRINT-02 both deleted
     this section because their Security flag read N/A. The template's rows are replaced rather
     than filled, because every one of them names a runtime control — rate limits, audit rows,
     HTML escaping, ABAC — and this sprint ships no runtime. What replaces them is the eleven
     developer constraints the security gate produced, which are constraints on the doctrine's
     wording. Substituting rather than deleting, per code/docs/GATE-REPORTING.md: a section
     removed reads as a gate that did not apply, and this one did.
     ALL OF IT IS US005's. US003's Security flag reads N/A, so it contributes nothing here — which
     is why every row names US005 explicitly rather than "this sprint". -->

- [ ] The eleven developer constraints in
      `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md`
      Section 7 are satisfied by the doctrine's wording, each checkable by reading the shipped guide
- [ ] **No CRITICAL or HIGH finding is open.** The gate closed 05/09/2026 with twelve findings —
      eleven `INFO`, one `LOW` — so nothing blocks sprint planning and nothing is escalated to
      `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/`. That is a decision with its
      reason recorded, not an audit that found nothing
- [ ] The present-state severities are read **with** the promotion-trigger table in
      `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`
      Section 3a. Four rows are design-state `HIGH`; every `INFO` here is a fact about a tree in
      which nothing retries, and it expires at the first wired client
- [ ] `DEFERRED.md` records the unenforced window at ship — the rule exists and
      `retry-discipline.sh` does not — naming slice `S-05` as owner and the first client-wiring
      story as its deadline (TM-02, the one non-`INFO` finding)
- [ ] **US003 contributes no security criterion, and that is recorded rather than inferred** —
      its Security flag reads `N/A`, so the union's Security value is US005's alone
- [ ] No secrets, debug flags, or hardcoded credentials are introduced in this sprint

### QA Acceptance Criteria — Manual

<!-- The automated QA sections are removed: this sprint's QA flag names a manual type and no
     automated one, matching both members, which ship documentation and no code path between them.
     Per code/docs/GATE-REPORTING.md the skip is recorded here rather than left to be inferred. -->

- [ ] All manual checks listed in the QA Tasks section below are complete and signed off
- [ ] `project-management/src/18-TESTS/US005-MANUAL-TESTING.md` and
      `project-management/src/18-TESTS/US003-MANUAL-TESTING.md` each carry a tester sign-off block
- [ ] **No `[OPEN]` acceptance-criteria gap remains** in either member's QA plan —
      `project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` (all
      fifteen resolved 05/09/2026) or
      `project-management/src/11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md`

---

## Tasks

All tasks below are sprint-level rollups. Detailed task lists live in each story file.

### Security Tasks

| Story | Task                                                                                         | Done |
| ----- | -------------------------------------------------------------------------------------------- | ---- |
| US005 | Satisfy the eleven doctrine-wording constraints from the assessment's Section 7              | [ ]  |
| US005 | Write the `DEFERRED.md` entry for the unenforced window, naming `S-05` and its deadline      | [ ]  |
| US005 | Confirm each design-state promotion trigger names a story or slice that can actually meet it | [ ]  |

### QA Tasks — Manual

- [ ] US005 — the three documentation gates named in its own flag run, and their output recorded in
      `project-management/src/18-TESTS/US005-MANUAL-TESTING.md`, read as a diff against the
      baselines captured in the QA plan's Section 7 (`doc-references.sh` at **56**, 05/09/2026)
- [ ] US005 — the retry-statement inventory is captured **before** any edit, with US001's landing
      state recorded beside it, and it balances at close
- [ ] US005 — the derived worst-case column is recomputed by hand on a default row **and** on the
      webhook override row, with both arithmetic strings written out
- [ ] US005 — the human read-across across six guides finds no budget stated in two homes and no
      guide stating the inverse of the owner rule
- [ ] US005 — a reader who opens `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md:265` cold
      reaches the breaker deferral in one hop, and `code/docs/NEGATIVE-SPACE.md:226` reads true
      after the repoint whichever story made it
- [ ] US005 — a tester other than the author has signed the walk-through off
- [ ] US003 — the five documentation gates run, and their output recorded in
      `project-management/src/18-TESTS/US003-MANUAL-TESTING.md`
- [ ] US003 — **if US004 has landed, the baseline-diff scenario is read as a plain pass**; the
      baseline is captured first only if US003 is somehow worked ahead of US004. Carried from
      SPRINT-02 with the story on 05/09/2026, because the obligation is the story's and not the
      sprint's
- [ ] US003 — the revision pass named in Dependencies is applied before the story is worked: the
      baseline-diff scenario, the before/after QA task, and
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
- [ ] US003 — a human read-across of the new guide against the six
      `code/docs/data-structures/TYPES-*.md` files; no rule stated in two homes
- [ ] US003 — the Codd primary source checked before its attribution row is written, to confirm
      derivation rather than convergence
- [ ] US003 — a developer who opens the guide cold can name which of the six kinds a given
      `return None` means, without opening a second file
- [ ] US003 — a tester other than the author has signed the walk-through off
- [ ] Cross-browser, responsive and accessibility walk-throughs — **N/A**, this sprint adds no
      page, component or interactive surface

---

## Verification Checks

Run all of the following before closing the sprint. All must pass.

Every command is a project script under `code/src/scripts/**/*.sh` — never a raw `python`,
`manage.py`, `pytest`, or `docker` call.

<!-- The code-path checks are marked N/A with a reason rather than deleted: this sprint ships
     documentation only, and per code/docs/GATE-REPORTING.md a skip is never reported as a pass. -->

- [ ] `bash code/src/scripts/audits/doc-references.sh` — **read as a diff, not as a pass**, per
      `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`,
      because the gate's own repair has not landed. Baseline captured 05/09/2026 at **56**; every
      survivor named with the story that owns it. A bare pass is unavailable to this sprint
- [ ] `bash code/src/scripts/audits/docs-length.sh` — no file created or edited this sprint enters
      the warn tier without a dated allowance; `code/docs/TASK-AUTHORING.md` at 266 is the file to
      watch
- [ ] `bash code/src/scripts/audits/doctrine-drift.sh` — regression only. It reads fenced code and
      this sprint's doctrine is prose, per
      `project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`; a
      green run says nothing about retry doctrine appearing in two homes and is never reported as
      though it had
- [ ] `bash code/src/scripts/syntax/lint.sh` and `bash code/src/scripts/syntax/check.sh` pass
- [ ] `bash code/src/scripts/audits/routing-skills.sh` — every name in US003's routing frontmatter
      resolves. **US003's alone**; US005 adds no frontmatter
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` — clause 14 discharged for every skill
      US003's guide names. **US003's alone**
- [ ] `bash code/src/scripts/audits/docs-pairing.sh` — regression only; neither member creates a
      directory. The reliability family's pair is US001's deliverable, in SPRINT-01
- [ ] `bash code/src/scripts/database/migrate.sh check` — **N/A**, no story here touches a model
- [ ] `bash code/src/scripts/tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] Template, django-component, and HTMX-partial tests — **N/A**, no template or component added
- [ ] No secrets, debug flags, or hardcoded IDs introduced in this sprint
- [ ] All GDPR tasks checked off — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] Every story's logging plan satisfied — **N/A**, the sprint's Logging flag reads `N/A`
- [ ] All security acceptance criteria signed off — **applies**, and this is the first sprint for
      which it does
- [ ] SEO acceptance criteria signed off — **N/A**, the sprint's SEO flag reads `N/A`
- [ ] Accessibility (WCAG 2.2 AA) — **N/A**, this sprint renders no interactive surface

---

## Definition of Done

- [ ] **Every `Must Have` story** in the Story Summary is individually marked **Completed** (its
      own DoD complete) — US005 alone
- [ ] The `Should Have` story is either **Completed** or explicitly carried to SPRINT-04 with its
      reason recorded here; it is never dropped silently. US003 has already moved once, from
      SPRINT-02, and a second move records both
- [ ] All sprint-level acceptance criteria met and verified by a reviewer
- [ ] All sprint-level tasks checked off
- [ ] All verification checks passed
- [ ] No `[OPEN]` acceptance-criteria gap remains in either member's QA plan
- [ ] No outstanding TODO or FIXME comments introduced in this sprint
- [ ] All changes merged to `main` (or the active release branch)
- [ ] Sprint `**Status:**` set to `Done`
- [ ] GDPR gaps identified during the sprint documented here — **N/A**, the GDPR flag reads `N/A`
- [ ] Security findings whose promotion trigger fired during the sprint are re-assessed in
      `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/` rather than left at their
      present-state severity
- [ ] Retrospective notes captured (optional — link or inline)
