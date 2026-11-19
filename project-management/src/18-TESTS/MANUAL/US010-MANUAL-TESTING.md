# US010 — Manual Testing Guide

_The manual testing guide for US010 — the gates, the self-tests, the CI runs and the read-acrosses a tester follows step by step, and, once walked, whether each passed. Authored from the specs at `17-story-plans` Step 7.2 on 03/10/2026, before any code; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 19/11/2026 · **Story**: US010 · **Status**: Authored — not yet walked; re-cut 19/11/2026

- **Story:** `../../02-STORIES/US010.md` — the seven register indexes are born seeded, and the map index leaves the file that ships
- **Story plan:** `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the code master this guide was authored beside
- **Branch:** `us010/seeded-register-indexes`
- **Surface:** Gate — every row runs a gate or a `.github/scripts/` self-test, reads a CI run by its recorded ID, or reads a file in the repository. No stack, no browser
- **Authored from:** `../../02-STORIES/US010.md` (Acceptance Criteria and its twenty scenarios, Security Acceptance Criteria ST01 to ST08, QA Acceptance Criteria — Automated and — Manual, Tasks, Verification Checks, Definition of Done); `../../11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (Sections 1 to 8); `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (Sections 3, 3a and 3b); `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (Section 7); `../../15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md` and `../../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (Decision); `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (Decision); `../../16-SPRINT-PLANS/06-SPRINT-PLAN-06.md` (the lane, Phase 4, Gate honesty, Sprint Verification Checklist); `../../03-SPRINTS/SPRINT-06.md` (QA Acceptance Criteria — Manual, QA Tasks — Manual, Verification Checks); `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (Approach P0 to P4, Key Decisions, Testing); and, at the re-cut of 19/11/2026, `../../02-STORIES/US010.md` -> _Re-cut — 19/11/2026_ and its re-cut criteria, `../../15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md` and the plan's re-cut phase plan. No `04`–`09`, `12`–`14` artefact exists for this story: those flags read `N/A`. Never code.

> **Authored before code, walked after it.** Which workflow writes which part of this file, and
> when, is `../CLAUDE.md` → _The record lifecycle_. Every rule for filling it — authoring, open
> questions, row IDs, the two citation columns, the build captures, marking, amendments and the
> browser contract — is this folder's `CLAUDE.md`. Neither is restated here.
>
> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.

---

## Preconditions and environment

**Approved integration correction 09/10/2026 — clean landing HEAD.** Before any
base-to-HEAD reach or unchanged-content comparison, capture the landing HEAD, post-rebase base
and `git status --porcelain=v1 --untracked-files=all`. The status output must be empty: no staged,
working-tree or untracked change. Record that capture outside the checkout until the comparison
is complete; writing this guide's results afterwards does not retrospectively establish a clean
checkout. Any pending change prevents the HEAD-only row being marked Pass. The captured HEAD
must be the commit rendered by the run whose evidence is read.

Before commit, assess the prospective change separately with
`git diff --name-only <recorded post-rebase base SHA>` (tracked on-disk content),
`git diff --cached --name-only <recorded post-rebase base SHA>` (index content),
plus `git ls-files --others --exclude-standard` (untracked paths), and compare every path to the
allowlist. Include the exact generated story export and inspect its staged and on-disk bytes;
it must not disappear merely because HEAD lacks the new version. A pre-commit read never
substitutes for the clean landing-HEAD comparison. Ignored build outputs are not source changes;
if the exact generated export is ignored or untracked, verify its path and provenance explicitly
and require it tracked at the landing HEAD when the enabled hook owes it.

**Approved remediation 09/10/2026 (grill-with-docs, Q1).** The local build-start owner is
`code/workflows/01-implement-story/STEPS.md` Step 1, its checklist and common build-start
instruction: after all due pre-edit captures and before the first source edit, it records
`Open` -> `In Progress` without requiring ClickUp credentials or a board. Documentation-only
stories reuse that Step 1 with code phases N/A; this is the procedure US007 must repair before
these builds, not a claim that the shared procedure has already changed.
An enabled board adapter publishes that same committed transition and never becomes a second
status authority. After US007 lands, the sprint plan's _Story Plans_ Status cell mirrors this
plan's own Status field on every transition, including `Blocked`, `Open`, `In Progress`,
`In Review` and `Completed`; a genuine no-file row alone reads _no plan to mirror_. Story and
plan carriers retain their own lifecycle and are not reconciled by the index read rule. A plan
transition carries its sprint-plan mirror in the same change; generated exports accompany story
transitions only where that integration is enabled. These are future workflow requirements,
not a build-start transition performed by this documentation correction.

**Approved remediation 09/10/2026 (grill-with-docs, Q4).** Every valid offered configuration
means the 72 named cases in `project-management/src/17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` -> _Every valid offered configuration — approved 09/10/2026_. All applicable generated-tree gates run for each case,
with its answers, source SHA, run ID and gate outcomes recorded separately. A mobile-only run or
reduced `shipped-ai` fixture cannot establish this criterion. US010 owns the workflow expansion;
US011 and US012 consume its exhaustive runs and add no CI implementation. If US012 lands before
that expansion, its red/green detector proof can be recorded but exhaustive generation remains
unmeasured and its full-coverage completion criterion cannot be ticked.

- **Stack:** none — this story runs no container and renders nothing (plan → _Quality Gates,
  Scripts & Local↔Docker Alignment_)
- **Base URL:** none — no rendered surface
- **Seed data:** none — the population under test is this repository's own tracked tree
- **Accounts / roles:** none — no role boundary exists (QA plan Section 2 → _Permission and access_)
- **Where the walk runs:** the story's checkout with every phase of the plan landed and pushed, so
  that CI has run on the landing commit
- **The CI runs:** a generated tree exists only in CI's `[3/4] Template Generation` job (QA plan
  Sections 2 and 6). A row that reads one opens the run recorded under _Recorded during the build_
  — never a local render of this template's tree, and never a raw `copier` call
  (`.claude/CLAUDE.md` Section 6). **One local run renders, and no row reads what it renders:**
  `bash .github/scripts/shipped-ai.sh --self-test` (FAMILY-11, _The update probe_, UPDATE-06,
  UPDATE-07 and UPDATE-08) builds a throwaway fixture template from this template's `copier.yml` and `.copier/`
  seeds with `fixture()` and renders it into a temporary directory (`copy_project()`, under
  `tempfile.TemporaryDirectory` in `.github/scripts/shipped-ai.py`). Those rows read its `PASS` and
  failure lines, never a project tree
- **A scratch copy of this tree:** a separate checkout of the story branch, never this working
  tree, for the rows that plant a mutation. Each such row takes a fresh copy, or restores it before
  the next row. How the copy was made is recorded beside the result
- **The baseline:** captured at the plan's P0, **before the first edit**, and pasted into
  _Recorded during the build_ at capture. A baseline taken after an edit is void — CAPTURE-01
- **The legibility reader:** a fresh Claude session given only the index file it reads, its walk
  reviewed by <%DEVELOPER_NAME%> (settled 03/10/2026, 17-story-plans grilling round 1 Q3). One
  session per file: a session that has read one index is not fresh for the next. The same reader,
  given only the map index, reads its Summaries in MAPINDEX-09 (settled 03/10/2026, 17-story-plans
  grilling round 2 Q6)
- **The tester:** someone other than the author of the story's edits
- **Out of scope:**
  - **ES-03's masking half** — `shipped-artefacts.sh` staying silent on a leaked index. It needs a
    generated tree; the family's half is FAMILY-04
  - **ES-18** — a seed link planted relative to `.copier/`, failing the link check. The plant needs
    a generated tree; the link check's green over the real seeds is CI-05
  - **EC-11's row-order half** — a predecessor reading before its successor in DECISION-INDEX. That
    index carries no rows until US011; the ordering sentence is INDEX-05
  - **EC-20** — an instruction to `11-qa-checks` Step 5, carried out 27/09/2026. Nothing in the
    build walks it
  - **EC-21 and PA-04** — a project generated before this story taking an update, and a recopy
    over a filled project. Both need a generated project and a raw `copier` call; both are
    demonstrations, not pass criteria (QA plan Section 2). The two statements the story writes
    about them are UPDATING-01 and UPDATING-02
  - **PA-01** — a negation leaking on a real copy and update. ES-03 is its control, walked as
    FAMILY-04
  - **Permission and access** — section dropped: no endpoint, screen or protected action (QA plan
    Section 2). PA-02 and PA-03 are walked as REACH-01 to REACH-03
  - **Accessibility** — section dropped: Markdown read in an editor (QA plan Section 3). Its one
    property, the Instance link's label, is INDEX-08
  - **Responsive behaviour** — section dropped: no rendered screen (QA plan Section 4)
  - **The post-merge `Updated` re-check** — every map-index `Updated` read again against the merged
    commit, in case a squash at promotion rewrote the dates. The merge follows the walk, so the
    re-check is `23-pr-and-review`'s (plan → _Risks_); MAPINDEX-06 and MAPINDEX-07 read the branch
    as it landed, where every map's last commit is the map commit or one before it
  - **The register writes** — the four `GAPS.md` openings are written by
    `22-implementation-documentation` and verified at `23-pr-and-review`, not walked here
  - **The automated criteria** — `docs-pairing.sh`, `docs-length.sh`, `lint.sh`, `check.sh` and
    `tests/all.sh` are the automated record's. `shipped-artefacts.sh --self-test` reads a generated
    tree and runs in CI only; it is read once, as CI-03, never run locally
- **Open questions** — none open. The three raised at Step 9 were answered by the developer on
  03/10/2026 (17-story-plans grilling round 2), and each row they held is rewritten from its answer:
  1. **Where the joined-line instruction search runs — SITES-05** — answered (Q4): US010 adds it
     to CI's `[3/4]` job as a step over the generated tree's Markdown, landing in a commit after
     the plan's P3 because it reads the sites P2 and P3 repair. It prints its pattern and its output
     and fails on any hit, and SITES-05 reads it by run ID. QA plan HP-18 and Section 6
     already placed it over a generated tree, and have recorded this host since 03/10/2026.
  2. **ES-08's finding count and ES-02's mechanism — FAMILY-09 and FAMILY-11** — answered (Q5):
     the plan's family table and the threat model's TM-06 reading. A seed and its `mv` line removed
     together fire the seed-exists clause and the wired clause, two findings and never silent; an
     index line moved into an ungated task leaves its seed in `.copier/`, so `rmdir .copier` fails
     with a `TaskError` before `shipped-ai.py`'s presence assertion is reached. QA plan ES-02 and
     ES-08 were corrected in place on 03/10/2026 to match.
  3. **Who reads the map index's Summaries — MAPINDEX-09** — answered (Q6): the same fresh Claude
     session as the legibility reader of round 1 Q3, given only the map index, its walk reviewed by
     the developer.

<!-- CORRECTED 03/10/2026, after 805efbd. The CI-runs precondition read "— never a local
     generation, and never a raw `copier` call" until then, and the out-of-scope list held "**ES-01**
     — an `mv` placed after `rmdir .copier` failing generation loudly. It needs a generation with the
     line misplaced, and no project script generates a tree locally. The ordering the scenario
     protects is read in the diff as CHAIN-02". Both were false: `shipped-ai.sh --self-test` runs
     this template's own seed chain against a fixture rendered into a temporary directory, which is
     what FAMILY-11 and UPDATE-06 already walk, and it produces ES-01's red (reproduced 03/10/2026
     in a scratch copy: `rmdir: failed to remove '.copier'`, then `TaskError`, exit 1). The
     precondition now names that run, and ES-01 is walked as UPDATE-07; CHAIN-02 still reads the
     ordering in the diff. Found by the independent review of US011's story plan. -->

<!-- CORRECTED 03/10/2026, the same change. The out-of-scope list also held "**ES-03's masking
     half and ES-07's generation half** — `shipped-artefacts.sh` staying silent on a leaked index,
     and generation failing at a seed's missing file. Both need a generated tree. The family's halves
     of both are FAMILY-04 and FAMILY-08" until then. ES-07's generation half rested on the same false
     premise: the same self-test runs the seed chain, so a deleted seed with its `mv` line kept fails
     there loudly. It is walked as UPDATE-08; ES-03's masking half still needs a generated tree. -->

**Re-cut 19/11/2026, before the walk.** The story was re-cut against the 7.7.0 boards at the
build's first step (`../../02-STORIES/US010.md` -> _Re-cut — 19/11/2026_; the new ADR
`../../15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md`; the plan's
_Phase plan — re-cut 19/11/2026_), and those three are added to _Authored from_. Every row written
for dropped work is retired in place as a stub, `Retired 19/11/2026 — superseded by the re-cut:
<reason>`, its number never reused; the rows replacing it take the next unused number in their
area, and six areas are new. The out-of-scope items and answered questions below that name a
retired row stand as the record of their date and bind nothing. The captured P0 values under
_Recorded during the build_ are not altered.

---

## Recorded during the build

| Capture                                                                                | Taken                                                                                   | Value |
| -------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ----- |
| Clean landing HEAD, post-rebase base and empty staged/worktree/untracked status output | Before HEAD-only reach or no-change comparisons; record outside checkout until complete |       |

**Approved remediation 09/10/2026 — reach and closeout.** After each rebase, record the actual
post-rebase base SHA (the merge base against the intended target branch), target SHA and branch
HEAD. Reach, unchanged-probe and unchanged-script checks compare that base to HEAD; refresh it
on a later rebase. The original pre-edit SHA and probe/citation captures remain historical
measurements, never the ownership boundary for incoming upstream commits. Record upstream
probe changes separately and compare this story's probe edits against the post-rebase base.

ST05 and assessment 7.5 additionally admit exactly
`project-management/export/clickup/US010-CLIENT.md` as a necessary generated closeout artefact
when the staged story invokes the armed ClickUp export hook. Record the story input SHA, exporter
SHA, hook invocation and generated output hash; independently reproduce the output from that
story. No hand edit, task-map write, credential access, network request or other export is
admitted by this exception. The adapter publishes the same local transition when configured;
export regeneration does not grant authority to change story status.

| Capture                                                                                                | Taken                                 | Value |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------- | ----- |
| Post-rebase base SHA, target SHA and branch HEAD; refresh after every later rebase                     | After each rebase and at reach checks |       |
| Export provenance: story input SHA, exporter SHA, hook invocation, output hash and reproduction result | At generated closeout                 |       |
| The 72 case IDs, all selector answers, source SHA, run ID and applicable generated-tree gate results   | At the landing run                    |       |

The captures the rows below read, and the readings the plan's P0 and P4 keep beside them. The
implementer fills the baseline slots at the plan's P0, before the first edit — never reconstructed
afterwards (`../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`
puts the baseline in this file) — and each build slot at the moment it names; the walker fills the
walk-time slots. Each captured set is a fenced block beneath this table, with its date. Nothing
here carries a `Result`.

| Capture                                                                                                                                                                          | Required by                                                                                                                            | Taken                                   | Value                                                                                                                                                              |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Pre-edit tree — `git rev-parse HEAD` and the `git status --porcelain` count                                                                                                      | The plan's P0; QA plan Section 6                                                                                                       | Before the first edit                   | 19/11/2026 — `b5fcede` on `us010/seeded-register-indexes`, cut from `testing`; porcelain count 0 (block P0-1)                                                      |
| Whole-tree `doc-references.sh` set as `(file, kind, token)`, line dropped, multiplicity kept; the detector's `git hash-object`; HEAD; the index state                            | The ADR above; the story's QA Acceptance Criteria — Automated                                                                          | Before the first edit                   | 19/11/2026 — exit 1, 18 findings, all `dangling path`, none in this story's write set; detector `12e8135`; index empty (0 staged) (block P0-2)                     |
| The same gate, same form, same index state                                                                                                                                       | The same                                                                                                                               | At the walk                             |                                                                                                                                                                    |
| The existing self-test probes — count, labels and expected substrings for `shipped-registers.sh` and `shipped-ai.py`, each run, and for `shipped-artefacts.sh`, read in the file | ST05 (nine, five and two in `shipped-registers.sh`, `shipped-artefacts.sh` and `shipped-ai.py`, as measured 21/09/2026); QA plan PA-03 | Before the first edit                   | 19/11/2026 — 12 / 8 / 2, recounted, not 9 / 5 / 2: 7.7.0 added CUT-PLAN checks 10–12 (block P0-3)                                                                  |
| Whether US012 and US009 had landed on `main`                                                                                                                                     | QA plan EC-18, EC-19; the plan's P0                                                                                                    | Before the first edit                   | 19/11/2026 — neither on `main`. US009 merged to `testing` (PR 37, `b5fcede`), in this base; US012 `Pending` (block P0-4)                                           |
| The length readings — `docs-length.sh --path` over each bound instructional file the change edits, its code-line count                                                           | The plan's P0 and P4; `code/docs/DOCUMENTATION-LENGTH.md` Section 3                                                                    | Before the first edit, and at close     | 19/11/2026 — 19 files, all within 300, none at 270; highest `wayfinder/SKILL.md` at 265 (block P0-5)                                                               |
| ShellCheck probed — `command -v shellcheck`, and its version if present                                                                                                          | The plan's P0                                                                                                                          | Before the first edit                   | 19/11/2026 — present, `/run/current-system/sw/bin/shellcheck`, 0.11.0                                                                                              |
| Each new probe's red — the commit SHA, the probe's failing line or the `[3/4]` run ID, and the SHA of the commit that turned it green                                            | ST05; QA plan PA-03; settled 03/10/2026, 17-story-plans round 1 Q1                                                                     | As each probe and check land (P1)       | R1 `a8a81668` red, `b18f832a` green; R4 red local only (hook), `3d136347` green; R6 `4119d6fa` red, `6e35c080` green; `[3/4]` CI-only at `a8d1b47e` — blocks below |
| The finding and bug registers re-counted                                                                                                                                         | QA plan EC-16                                                                                                                          | At the commit that writes their indexes | 19/11/2026 at `0df03840`: 9 findings, 11 bugs, 32 ADRs                                                                                                             |
| The map population under the instance test — the command, its count, HEAD                                                                                                        | QA plan HP-10, EC-02                                                                                                                   | At the map commit (P3)                  | 19/11/2026 at `761be32b`, before the map commit: 21 maps (archive 0) — block _Map population_ below                                                                |
| The landing commit's workflow run — its ID, the commit SHA, and the `[1/4]`, `[2/4]` and `[3/4]` results on each render path                                                     | QA plan Section 6; HP-01                                                                                                               | When that run completes                 |                                                                                                                                                                    |
| Whether US012 and US009 had landed on `main` when the landing commit was rebased, and which landed first                                                                         | QA plan EC-18, EC-19; the plan's P0 and _Risks_                                                                                        | At the rebase before the landing commit |                                                                                                                                                                    |
| ShellCheck over `.github/scripts/shipped-artefacts.sh` and `.github/scripts/shipped-registers.sh` — run or not run, the version, the output                                      | The story's Verification Checks; SPRINT-06 → Verification Checks                                                                       | At the plan's P4                        | Run 19/11/2026, ShellCheck 0.11.0: info-level notes only (SC2329, SC1091, SC2016) — _Static checks_ block below                                                    |
| A Python lint over `.github/scripts/shipped-ai.py` — run or not run, and the reason                                                                                              | The story's Verification Checks                                                                                                        | At the plan's P4                        | `py_compile` exit 0; `lint.sh` skips the path; lefthook ruff and basedpyright passed — _Static checks_ block below                                                 |
| The enum derivation per map — the counts read, the value given, and why                                                                                                          | The story's QA Acceptance Criteria — Manual; QA Tasks — Manual                                                                         | At the walk                             |                                                                                                                                                                    |
| The legibility reader's readings, verbatim, with the developer's review — and the count of Summaries read beside the count of rows                                               | The story's QA Acceptance Criteria — Manual; QA plan HP-13                                                                             | At the walk                             |                                                                                                                                                                    |

### P0 captures — 19/11/2026

Taken on `us010/seeded-register-indexes` at `b5fcede` before the first edit, every gate run on the
clean tree. The raw outputs were held outside the checkout while being taken.

P0-1 — pre-edit tree:

```text
HEAD      b5fcede961fa397c72a417257061db73ea4701b4  (branch cut from testing, 19/11/2026)
porcelain 0
```

P0-2 — `bash code/src/scripts/audits/doc-references.sh`, exit 1, normalised `(file, kind, token)`,
line dropped, multiplicity kept; detector `git hash-object` `12e81359308e194bcb607eb04b30583b3ab5089b`;
index state: 0 staged paths:

```text
project-management/src/02-STORIES/US014.md  |  dangling path  |  code/src/django/apps/core/observability.py
project-management/src/02-STORIES/US014.md  |  dangling path  |  code/src/django/apps/core/observability.py
project-management/src/02-STORIES/US014.md  |  dangling path  |  code/src/django/apps/core/tests/unit/test_observability.py
project-management/src/02-STORIES/US014.md  |  dangling path  |  code/src/django/apps/core/tests/unit/test_observability.py
project-management/src/03-SPRINTS/SPRINT-03.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md  |  dangling path  |  code/src/django/apps/core/observability.py
project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md  |  dangling path  |  project-management/src/21-BUGS/BUG-INDEX.md
project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md  |  dangling path  |  project-management/src/21-BUGS/BUG-INDEX.md
project-management/src/11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md  |  dangling path  |  code/src/django/apps/core/tests/unit/test_observability.py
project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/16-SPRINT-PLANS/03-SPRINT-PLAN-03.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/16-SPRINT-PLANS/03-SPRINT-PLAN-03.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
project-management/src/17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md  |  dangling path  |  how-to/src/OUTBOUND-TIMEOUTS.md
```

P0-3 — the existing self-test probes, re-counted:

```text
shipped-registers.sh --self-test   exit 0, 12 probes: checks 1-9 (GAPS/DEFERRED) as before,
                                   plus 10-12 (CUT-PLAN _tasks move, legend heading, map section)
shipped-artefacts.sh               8 probe() calls in the file (:310-352); CI-only, not run
shipped-ai.sh --self-test          exit 0; 2 detector probes: rejects dereferenced-aliases,
                                   rejects excluded-skill-alias; plus 4 exercise PASS lines
shipped-registers.sh (plain run)   exit 0
```

P0-4 — landing state: US009 `In Review — PR 37`, merged into `testing` at `b5fcede` and so inside
this base, not on `main`; US012 `Pending`, landed nowhere.

P0-5 — length, `docs-length.sh --path` exit 0 for each; cloc Markdown code lines:

```text
  67  project-management/src/01-FEATURE-MAPS/CONTEXT.md
  40  project-management/src/02-STORIES/CONTEXT.md
  38  project-management/src/03-SPRINTS/CONTEXT.md
  32  project-management/src/15-DECISIONS/CONTEXT.md
  79  project-management/src/17-STORY-PLANS/CONTEXT.md
  55  project-management/src/20-FINDINGS/CONTEXT.md
  38  project-management/src/21-BUGS/CONTEXT.md
  87  project-management/workflows/17-story-plans/CLAUDE.md
 176  project-management/workflows/17-story-plans/STEPS.md
  90  project-management/workflows/17-story-plans/CHECKLIST.md
 114  project-management/workflows/17-story-plans/CONTEXT.md
 188  project-management/workflows/01-feature-map/STEPS.md
  89  project-management/workflows/01-feature-map/CHECKLIST.md
  54  project-management/src/15-DECISIONS/CLAUDE.md
  73  project-management/src/17-STORY-PLANS/CLAUDE.md
  59  project-management/src/01-FEATURE-MAPS/CLAUDE.md
  55  project-management/src/20-FINDINGS/CLAUDE.md
  47  project-management/src/21-BUGS/CLAUDE.md
 265  .claude/skills/wayfinder/SKILL.md
```

### Map population — 19/11/2026

Re-counted immediately before the map commit, on `us010/seeded-register-indexes` at
`761be32b17756a0e12c17875d8ec997139868be0`, under the instance test (tracked `MAP-*.md`, the
template excluded by exact filename, `archive/` excluded):

```text
$ git ls-files 'project-management/src/01-FEATURE-MAPS/MAP-*.md' \
    | grep -v -x 'project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md' \
    | grep -v '/archive/' | wc -l
21
$ git ls-files 'project-management/src/01-FEATURE-MAPS/archive/MAP-*.md' | wc -l
0
```

The map commit edits all 21 and the template: 22 "Index row" boxes removed (one each), 22
`Umbrella ADRs` rows swept, and the two `Index row` Notes rows that still read "awaits
`MAP-INDEX.md`" (`MAP-SCRIPT-GUARDS.md`, `MAP-SENTENCE-RULES.md`) marked superseded.

### Each new probe's red — R1, 19/11/2026

The generator's probes, `code/src/scripts/tests/pm-boards.sh` (a synthetic fixture; run with
`bash code/src/scripts/tests/pm-boards.sh`), committed red in a commit of their own before the
generator change they prove. The check lines are the script's own; nothing here is a `Result`.

```text
red    a8a81668  test(us010): red probes for the decisions, findings and bugs boards and their archive
       exit 1 — "✗ pm-boards.sh: 30 of 37 probes failed"; failing lines include
         ✗ DECISIONS-BOARD.md is written
         ✗ the cross-cutting BUG-<DESCRIPTOR>-DD-MM-YYYY.md fallback is a row
         ✗ the decisions header is ID, Title, Status, File, Supersedes, Superseded by
         ✗ an Accepted ADR is refused          (pm-archive.sh exit 2: an ADR ID was not accepted)
         ✗ a Superseded ADR is archived
         ✗ --check fails on an edit to an archived bug (no archived bug to edit)
         ✗ --boards-for names DECISIONS-BOARD.md for an ADR status edit
       the 7 that passed at red are non-regression guards (templates absent, no Unrecognised
       column, a refusal moves nothing, --check green on the fixture, no tail columns on the
       findings and bugs boards)
green  b18f832a  feat(us010): decisions, findings and bugs boards, their archive, and the
                 supersession columns — exit 0, "✓ pm-boards.sh: 37 probes passed"
note   one expectation was corrected in the green commit, not the code it tests: "the bugs board
       counts four instances" read four where the fixture defines three bug instances; it reads
       "its three instances" from b18f832a
```

### Each new probe's red — R4 to R6, 19/11/2026

The seed gate and the update probe. Same rule as R1: the lines are the scripts' own, and nothing
here is a `Result`.

```text
[3/4]  a8d1b47e  test(us010): the generated-project completeness step expects the decisions,
                 findings and bugs boards
       CI-only: red expected in [3/4] at a8d1b47e, on "INCLUDE_MOBILE=<false|true> —
       project-management/src/{15-DECISIONS/DECISIONS,20-FINDINGS/FINDINGS,21-BUGS/BUGS}-BOARD.md
       missing from the generated project"; CI was not run locally, so no run ID is held
R4     shipped-boards.sh --self-test probes — red taken LOCALLY, not in a commit of its own
       (deviation: the template-integrity pre-commit leg runs every --self-test whenever a
       .github/scripts/*.sh is staged, so a red self-test cannot be committed without
       --no-verify, which this build may not use). The red probe file is held as blob
       842acdc4d4520954b6ec6239e981344ef82c10af (git hash-object -w, on HEAD a8d1b47e)
       exit 1 — 13 of 21 probes failed, each "produced 0 finding(s): (none)":
         ✗ check 2 fires when the {DECISIONS,FINDINGS,BUGS}-BOARD.md move is dropped
         ✗ check 2 fires when a seed move leaves the copy-gated task
         ✗ check 3 fires when {DECISIONS,FINDINGS,BUGS}-BOARD.md is missing
         ✗ check 4 fires when {DECISIONS,FINDINGS,BUGS}-BOARD.md carries a row
         ✗ check 5 fires when SEEDED omits {DECISIONS,FINDINGS,BUGS}-BOARD.md
       the 8 that passed at red: the five original probes, and check 1 on the three new boards
       (check 1 matches any re-included *BOARD path, so it never depended on the list);
       the blob exists only in this checkout's object store — it is not reachable from any ref
green  3d136347  feat(us010): seed the decisions, findings and bugs boards; bind every seed move
                 to the copy-gated task — shipped-boards.sh exit 0; --self-test exit 0,
                 "Self-test passed — 21 probes"; shipped-registers.sh and --self-test exit 0;
                 shipped-memory.sh exit 0; shipped-ai.sh --self-test exit 0
R6     4119d6fa  test(us010): shipped-ai self-test removes the seed task's when: key and runs the
                 update path
       exit 1 — "AssertionError: Detector accepted the broken ungated-seed-task fixture"
green  6e35c080  test(us010): a board edited and committed in a generated project survives
                 copier update byte-identical — shipped-ai.sh --self-test exit 0; "PASS: detector
                 rejects ungated-seed-task — project-management/src/01-FEATURE-MAPS/
                 FEATURE-MAPS-BOARD.md was not byte-identical to the project's own edit after
                 copier update"; both copy/update passes report 8 edited boards byte-identical
```

**R4's red, made durable — 19/11/2026.** The blob above is reachable from no ref, so a `git gc`
would lose it. Its content, as `git diff a8d1b47e:.github/scripts/shipped-boards.sh 842acdc4`
prints it, is pasted here as the record: the probes that ran red, against the check as it stood at
`a8d1b47e`.

```diff
diff --git a/.github/scripts/shipped-boards.sh b/842acdc4
index 9f325d21..842acdc4 100644
--- a/.github/scripts/shipped-boards.sh
+++ b/842acdc4
@@ -174,30 +174,68 @@ self_test() {
   fi
   log "  ✓ the real inputs pass — the baseline is clean"

+  # The three later registers, folder|board — each check kind is proven on each of them too.
+  local later=("15-DECISIONS|DECISIONS-BOARD.md" "20-FINDINGS|FINDINGS-BOARD.md" "21-BUGS|BUGS-BOARD.md")
+  local lb lf lname
+
   # 1. Re-include a board.
   awk '{print} /^_exclude:/{print "  - \"!/project-management/src/02-STORIES/STORIES-BOARD.md\""}' \
     "$real_copier" > "$tmp/reinclude.yml"
   COPIER="$tmp/reinclude.yml"; probe "check 1 fires when a board is re-included" "re-includes a board"
+  for lb in "${later[@]}"; do
+    lf="${lb%%|*}"; lname="${lb##*|}"
+    awk -v l="  - \"!/project-management/src/$lf/$lname\"" '{print} /^_exclude:/{print l}' \
+      "$real_copier" > "$tmp/reinclude.yml"
+    COPIER="$tmp/reinclude.yml"; probe "check 1 fires when $lname is re-included" "re-includes a board (!/project-management/src/$lf/$lname)"
+  done
   COPIER="$real_copier"

   # 2. Drop a _tasks move.
   grep -vF "mv .copier/SPRINTS-BOARD.md" "$real_copier" > "$tmp/no-move.yml"
   COPIER="$tmp/no-move.yml"; probe "check 2 fires when a _tasks move is dropped" "does not move .copier/SPRINTS-BOARD.md"
+  for lb in "${later[@]}"; do
+    lname="${lb##*|}"
+    grep -vF "mv .copier/$lname" "$real_copier" > "$tmp/no-move.yml"
+    COPIER="$tmp/no-move.yml"; probe "check 2 fires when the $lname move is dropped" "does not move .copier/$lname"
+  done
+  # 2b. Move a seed out of the copy-gated task into an ungated one. The move still exists, but
+  #     it would run on every update and overwrite the project's own board — check 2 binds the
+  #     move to the copy-gated task, not to _tasks at large.
+  grep -vF "mv .copier/STORIES-BOARD.md" "$real_copier" \
+    | awk '{print} /^_tasks:/{print "  - command: mv .copier/STORIES-BOARD.md project-management/src/02-STORIES/STORIES-BOARD.md"}' \
+    > "$tmp/ungated.yml"
+  COPIER="$tmp/ungated.yml"; probe "check 2 fires when a seed move leaves the copy-gated task" "does not move .copier/STORIES-BOARD.md"
   COPIER="$real_copier"

-  # 3 and 4 work on a copy of the seed directory.
-  mkdir -p "$tmp/seeds"; cp "$real_seeds"/*-BOARD.md "$tmp/seeds/"
+  # 3 and 4 work on a fresh copy of the seed directory per probe.
+  fresh_seeds() { rm -rf "$tmp/seeds"; mkdir -p "$tmp/seeds"; cp "$real_seeds"/*-BOARD.md "$tmp/seeds/"; }
   SEED_DIR="$tmp/seeds"
-  rm "$tmp/seeds/STORY-PLANS-BOARD.md"
+  fresh_seeds; rm -f "$tmp/seeds/STORY-PLANS-BOARD.md"
   probe "check 3 fires when a seed is missing" "missing .copier/STORY-PLANS-BOARD.md"
-  cp "$real_seeds/STORY-PLANS-BOARD.md" "$tmp/seeds/"
+  for lb in "${later[@]}"; do
+    lname="${lb##*|}"
+    fresh_seeds; rm -f "$tmp/seeds/$lname"
+    probe "check 3 fires when $lname is missing" "missing .copier/$lname"
+  done
+  fresh_seeds
   printf '\n| US001 | A template story | Open | [US001.md](US001.md) |\n' >> "$tmp/seeds/STORIES-BOARD.md"
   probe "check 4 fires when a seed carries a row" ".copier/STORIES-BOARD.md differs"
+  for lb in "${later[@]}"; do
+    lname="${lb##*|}"
+    fresh_seeds
+    printf '\n| X-TEMPLATE-ROW | A template record | Open | [x.md](x.md) |\n' >> "$tmp/seeds/$lname"
+    probe "check 4 fires when $lname carries a row" ".copier/$lname differs"
+  done
   SEED_DIR="$real_seeds"

   # 5. Drop a SEEDED entry.
   sed 's#"16-SPRINT-PLANS/SPRINT-PLANS-BOARD.md"##' "$real_art" > "$tmp/artefacts.sh"
   ARTEFACTS="$tmp/artefacts.sh"; probe "check 5 fires when SEEDED omits a board" "SEEDED does not list 16-SPRINT-PLANS"
+  for lb in "${later[@]}"; do
+    lf="${lb%%|*}"; lname="${lb##*|}"
+    sed "s#\"$lf/$lname\"##" "$real_art" > "$tmp/artefacts.sh"
+    ARTEFACTS="$tmp/artefacts.sh"; probe "check 5 fires when SEEDED omits $lname" "SEEDED does not list $lf/$lname"
+  done
   ARTEFACTS="$real_art"

   rm -rf "$tmp"
```

**TM-15's trigger fired at `3d136347`.** The threat model promotes TM-15 to `MEDIUM` when a probe
lands in the same commit as the check it proves, and R4's probes did: the red was taken locally
and committed only together with its green. The cause was the template-integrity leg, which runs
every `--self-test` when a `.github/scripts/*.sh` is staged and so refused the red commit. The
planned-red allowance added 19/11/2026 (`PLANNED_RED=<detector>` with a matching `Planned-Red:`
trailer, proved by `code/src/scripts/tests/planned-red.sh`) removes that cause: this story's later
self-test probes — `848d5eb5` and `7e724e73` — were each committed red, before their fixes. The
threat-model implementation record of TM-15 is gate 22's, not this capture's.

### Static checks over the gate scripts — 19/11/2026

```text
ShellCheck 0.11.0, run directly (no project wrapper exists), shellcheck -f gcc, at 6e35c080:
  .github/scripts/shipped-boards.sh            exit 1 — SC2329 (info) :100 "This function is
                                               never invoked" on cleanup(), which `trap cleanup
                                               EXIT` invokes; present at b5fcede (:93)
  .github/scripts/shipped-artefacts.sh         exit 0 — no output
  project-management/src/00-ASSETS/scripts/pm-board.sh    exit 1 — SC1091 (info) :124, pm-lib.sh
                                               not followed without -x; present before R1
  project-management/src/00-ASSETS/scripts/pm-archive.sh  exit 1 — SC1091 (info) :90, likewise
  project-management/src/00-ASSETS/scripts/pm-lib.sh      exit 0 — no output
  .github/scripts/shipped-registers.sh         exit 1 — SC2016 (info) :333, single-quoted
                                               expression; not edited by this story
  No warning- or error-level finding on any of the six.
Python, .github/scripts/shipped-ai.py:
  python3 -m py_compile                        exit 0
  code/src/scripts/syntax/lint.sh --file-type python --path <file>
                                               exit 0, but it reads nothing: "outside
                                               code/src/django/ — no Python here for ruff to read"
  lefthook pre-commit legs on the staged file  ruff-lint, ruff-format and basedpyright ran and
                                               passed at 4119d6fa and 6e35c080 (ruff-format
                                               failed the first 4119d6fa attempt on one wrapped
                                               call; reformatted, then passed)
```

---

### The joined-line instruction search, taken locally — 19/11/2026

The `[3/4]` step _No shipped instruction may route a register's index to a CONTEXT.md_, added at
`abad41a6`, was run locally: its `run:` block was extracted verbatim from
`.github/workflows/audit-template.yml` and executed with `RUNNER_TEMP` pointing at two renders,
`INCLUDE_MOBILE=false` and `true`. Each render came from a scratch copy made with
`git archive <ref> | tar -x` into a `mktemp -d` directory, `git init` and committed there, and
rendered by that copy's own `template-render.sh --ref HEAD`. No path in either copy resolves back
into this checkout: all 73 tracked symlinks resolve inside the copy.

**The CI run is still owed.** This is a local reading, not the landing run that SITES-05 reads
by run ID.

Over `deb4a9b5`, the map commit and the tree the step judges, it exits 0:

```text
pattern (Perl, case-insensitive, over paragraphs): index row.{0,80}CONTEXT\.md|CONTEXT\.md.{0,40}(?:map index|register index|is the index|as the index)|row to .{0,40}\d\d-[A-Z-]+/CONTEXT\.md|\bno (?:folder-level |in-tree )?index\b|index (?:is |was )?deferred|register-index work|holds no index|carries no index
INCLUDE_MOBILE=false — 0 hits
INCLUDE_MOBILE=true — 0 hits
```

Over `b5fcede`, the pre-change base, the same step exits 1. This shows the pattern reaches the
sites R7 repaired. It was not planted in history:

```text
pattern (Perl, case-insensitive, over paragraphs): index row.{0,80}CONTEXT\.md|CONTEXT\.md.{0,40}(?:map index|register index|is the index|as the index)|row to .{0,40}\d\d-[A-Z-]+/CONTEXT\.md|\bno (?:folder-level |in-tree )?index\b|index (?:is |was )?deferred|register-index work|holds no index|carries no index
::error::INCLUDE_MOBILE=false — a shipped instruction routes a register's index to a CONTEXT.md
./project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md: ...*Every slice has a flag manifest** — every gate it needs, `N/A` omitted - [ ] [Index row in `CONTEXT.md]
./project-management/src/15-DECISIONS/CLAUDE.md: ...t ADR by **full filename**; note the supersession on both records. - **There is [no index]
./project-management/src/17-STORY-PLANS/CLAUDE.md: ...y Plans — the code master_ table current on every add and every renumber. - **[No index]
./project-management/src/17-STORY-PLANS/CLAUDE.md: ...int plan's _Story Plans — the code master_ table next door. `CONTEXT.md` here [carries no index]
./project-management/src/17-STORY-PLANS/CONTEXT.md: ...d `.html` siblings are gitignored. It is the excluded-and-seeded index file the [register-index work]
./project-management/workflows/17-story-plans/CLAUDE.md: ...t information, it is a stale claim. Rule and derivation: `STEPS.md` Step 2. - **[No index]
::error::INCLUDE_MOBILE=true — a shipped instruction routes a register's index to a CONTEXT.md
./project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md: ...*Every slice has a flag manifest** — every gate it needs, `N/A` omitted - [ ] [Index row in `CONTEXT.md]
./project-management/src/15-DECISIONS/CLAUDE.md: ...t ADR by **full filename**; note the supersession on both records. - **There is [no index]
./project-management/src/17-STORY-PLANS/CLAUDE.md: ...y Plans — the code master_ table current on every add and every renumber. - **[No index]
./project-management/src/17-STORY-PLANS/CLAUDE.md: ...int plan's _Story Plans — the code master_ table next door. `CONTEXT.md` here [carries no index]
./project-management/src/17-STORY-PLANS/CONTEXT.md: ...d `.html` siblings are gitignored. It is the excluded-and-seeded index file the [register-index work]
./project-management/workflows/17-story-plans/CLAUDE.md: ...t information, it is a stale claim. Rule and derivation: `STEPS.md` Step 2. - **[No index]
```

### Close-out readings — 19/11/2026

Taken at `a776b76d` on `us010/seeded-register-indexes`, every run on the clean tree.

**Citation diff against P0 (block P0-2):**

- `bash code/src/scripts/audits/doc-references.sh` exits 1.
- Normalised the P0 way (`(file, kind, token)`, line dropped, multiplicity kept), its 18 findings
  are **identical** to P0's 18. `diff` exits 0.
- The detector's `git hash-object` is `12e81359308e194bcb607eb04b30583b3ab5089b`, unchanged from
  P0, so the diff is not confounded by a change to the detector.
- The first close-out run held three findings that P0 did not, and all three were this story's own:
  - a stale `doc-references-shipping.txt`, which was missing the three new seeds;
  - two `dangling path` tokens in `code/src/scripts/tests/pm-boards.sh`'s ADR fixture.
- Both were fixed at `a776b76d` before this reading was taken.

| Gate                                                                       | Exit | Reading                                                                  |
| -------------------------------------------------------------------------- | ---- | ------------------------------------------------------------------------ |
| `audits/doc-references.sh` (whole tree)                                    | 1    | 18 findings, the P0 set exactly; none in this story's write set          |
| `audits/docs-length.sh`                                                    | 0    | 818 files within 300; 3 approaching, none edited by this story           |
| `audits/docs-pairing.sh`                                                   | 0    | split intact, 238 `CONTEXT.md` / 228 `CLAUDE.md`                         |
| `audits/skill-conformance.sh`                                              | 0    | every skill conforms; `wayfinder/SKILL.md` not edited (265 at P0)        |
| `audits/doctrine-drift.sh`                                                 | 0    | all 4 claims have exactly one home                                       |
| `syntax/check.sh`                                                          | 0    | Python, mobile and Rust checks clean                                     |
| `tests/all.sh`                                                             | 0    | backend 71 + 22 passed; mobile 16 passed                                 |
| `tests/pm-boards.sh`                                                       | 0    | 37 probes passed                                                         |
| `pm-board.sh --check`                                                      | 0    | all 8 boards current, `archive/` untouched                               |
| `shipped-boards`, `-registers`, `-memory`, `-readme` `.sh` + `--self-test` | 0    | each pass and self-test green                                            |
| `shipped-ai.sh --self-test`                                                | 0    | the update probe and its mutations green                                 |
| `shipped-artefacts.sh` and `[3/4]` landing run                             | —    | **not run**, because both need CI's `[3/4]` job; owed at the landing run |

### Fix-round readings — 19/11/2026

Taken at `c25c314b` (the joined-line search over renders of `3551ea8f`, which differ from
`c25c314b` only in the workflow file the step is read from) on `us010/seeded-register-indexes`,
after the review fix round: D1 (finding vocabulary `Open | Resolved`), D4 (the planned-red
allowance), QA-M1 to QA-M5, QA-L1 to QA-L4, Sec-LOW-2, Sec-LOW-3, CR-L2, CR-M1 to CR-M3. Each
probe was committed red before its fix; the two `shipped-boards.sh` self-test reds, `848d5eb5`
and `7e724e73`, were committed under `PLANNED_RED=shipped-boards.sh` with a matching
`Planned-Red:` trailer, and the hook printed
"planned red — shipped-boards.sh --self-test exited 1, as PLANNED_RED declares" each time.

**The joined-line instruction search, re-proved locally (QA-L1).** Its `run:` block was
extracted verbatim from `.github/workflows/audit-template.yml` at `c25c314b` and run with
`RUNNER_TEMP` at two renders made by a scratch copy's own `template-render.sh --ref HEAD`
(`git archive HEAD | tar -x` into a `mktemp -d` directory, `git init`, committed; 73 tracked
symlinks, none resolving outside the copy). Over both renders it exits 0:

```text
pattern (Perl, case-insensitive, over paragraphs): index row.{0,80}CONTEXT\.md|CONTEXT\.md[^;.]{0,80}index row|CONTEXT\.md`?'?s (?:map |register )?index|CONTEXT\.md.{0,40}(?:map index|register index|is the index|as the index)|register'?s index.{0,40}CONTEXT\.md|CONTEXT\.md.{0,40}register'?s index|row to .{0,40}\d\d-[A-Z-]+/CONTEXT\.md|\bno (?:folder-level |in-tree )?index\b|\bno (?:board|generated index)\b|index (?:is |was )?deferred|register-index work|holds no index|carries no index
project-management/ only: row to .{0,40}CONTEXT\.md
INCLUDE_MOBILE=false — 0 hits
INCLUDE_MOBILE=true — 0 hits
```

The same block run over a synthetic tree holding six intended forms (reverse order, the two
possessives, "no board", the bare "row to … CONTEXT.md" under `project-management/`, an unmarked
dated comment), an `UPDATED`-marked dated comment and the two false positives (a script registry's
"add the row to `CONTEXT.md`" under `code/`, and the skills roster's "index row") exits 1,
reporting the six forms and nothing else on each path:

```text
pattern (Perl, case-insensitive, over paragraphs): index row.{0,80}CONTEXT\.md|CONTEXT\.md[^;.]{0,80}index row|CONTEXT\.md`?'?s (?:map |register )?index|CONTEXT\.md.{0,40}(?:map index|register index|is the index|as the index)|register'?s index.{0,40}CONTEXT\.md|CONTEXT\.md.{0,40}register'?s index|row to .{0,40}\d\d-[A-Z-]+/CONTEXT\.md|\bno (?:folder-level |in-tree )?index\b|\bno (?:board|generated index)\b|index (?:is |was )?deferred|register-index work|holds no index|carries no index
project-management/ only: row to .{0,40}CONTEXT\.md
::error::INCLUDE_MOBILE=false — a shipped instruction routes a register's index to a CONTEXT.md
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- Charting a map: add the map to `[CONTEXT.md` as its index row]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- Then the `[CONTEXT.md`'s index]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- The [register's index is this folder's `CONTEXT.md]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- There is [no board]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- Add the map's [row to its `CONTEXT.md]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...<!-- 01/01/2026: the [index was deferred]
::error::INCLUDE_MOBILE=true — a shipped instruction routes a register's index to a CONTEXT.md
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- Charting a map: add the map to `[CONTEXT.md` as its index row]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- Then the `[CONTEXT.md`'s index]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- The [register's index is this folder's `CONTEXT.md]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- There is [no board]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...- Add the map's [row to its `CONTEXT.md]
./project-management/src/01-FEATURE-MAPS/CLAUDE.md: ...<!-- 01/01/2026: the [index was deferred]
```

**A deviation found and fixed in the round:** `56dace9e` wrote the pattern through a shell `echo`
that turned its four `\b` into backspace bytes, so the "no board" and "no index" forms could not
match; `c25c314b` restores them, and the readings above are of the restored step.

**Citation diff against P0 (block P0-2):** `bash code/src/scripts/audits/doc-references.sh`
exits 1 with 18 findings; normalised the P0 way, they are **identical** to P0's 18 (`diff` exits
0). The detector's `git hash-object` is `12e81359308e194bcb607eb04b30583b3ab5089b`, unchanged. A
first run at `87d4938f` held a nineteenth, this round's own — the masked-status fixture in
`pm-boards.sh` wrote its decoy ADR path literally — fixed at `3551ea8f` before this reading.

| Gate                                                                    | Exit | Reading                                                                                                                     |
| ----------------------------------------------------------------------- | ---- | --------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/tests/pm-boards.sh`                                   | 0    | 60 probes passed                                                                                                            |
| `code/src/scripts/tests/planned-red.sh`                                 | 0    | 23 probes passed                                                                                                            |
| `pm-board.sh --check`                                                   | 0    | all 8 boards current, `archive/` untouched                                                                                  |
| `pm-board.sh --warn`                                                    | 0    | 25 readiness warnings, all "ready to archive"; no chain or Unrecognised warning                                             |
| `shipped-boards.sh` / `--self-test`                                     | 0/0  | current, empty boards; 28 probes                                                                                            |
| `shipped-registers.sh` / `--self-test`                                  | 0/0  | correctly seeded; 12 probes                                                                                                 |
| `shipped-memory.sh` / `--self-test`                                     | 0/0  | correctly seeded; 5 probes                                                                                                  |
| `shipped-ai.sh --self-test`                                             | 0    | 8 PASS lines, `duplicate-seed-task` rejected with "found 2"                                                                 |
| `audits/docs-length.sh`                                                 | 0    | all 818 instructional files within 300 lines, 3 approaching                                                                 |
| `audits/docs-pairing.sh`                                                | 0    | split intact                                                                                                                |
| `audits/skill-conformance.sh`                                           | 0    | every skill conforms                                                                                                        |
| `audits/doc-references.sh` (whole tree)                                 | 1    | the P0 set exactly, 18 findings, none in this round's write set                                                             |
| ShellCheck 0.11.0 over every edited shell script (`-x` for the pm trio) | 0    | `pm-boards.sh`, `planned-red.sh`, `template-integrity.sh`, `shipped-boards.sh`, `pm-lib.sh`, `pm-board.sh`, `pm-archive.sh` |
| `[3/4]` landing run                                                     | —    | **not run**: it needs CI; the step above is a local reading, owed at the landing run                                        |

## Journeys

### Approved remediation evidence

| ID        | Action                                                                                                                                                                    | Expected outcome                                                                                                                                                                                                                                                                                                                                 | Flow | QA  | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | --- | ------ | ----- |
| REMEDY-01 | Read the build-start transition and board-adapter event evidence                                                                                                          | Step 1 of code/workflows/01-implement-story/STEPS.md, its checklist and common build-start instruction record the story transition after due pre-edit captures and before the first source edit without a board; documentation-only code phases are N/A; the enabled adapter publishes the same committed event and writes no independent status | —    | —   |        |       |
| REMEDY-02 | Read each plan transition and its sprint-plan Story Plans row                                                                                                             | After US007 lands, the cell mirrors that plan's own status in the same change; no live Not started placeholder survives                                                                                                                                                                                                                          | —    | —   |        |       |
| REMEDY-03 | Retired 19/11/2026 — superseded by the re-cut: the 72-case matrix moves to MAP-GENERATION-COVERAGE S-01, uncut (re-cut grilling round 4 Q1; see the note below the table) | —                                                                                                                                                                                                                                                                                                                                                | —    | —   | —      | —     |
| REMEDY-04 | Retired 19/11/2026 — superseded by the re-cut: the 72-case matrix moves to MAP-GENERATION-COVERAGE S-01, uncut (re-cut grilling round 4 Q1; see the note below the table) | —                                                                                                                                                                                                                                                                                                                                                | —    | —   | —      | —     |

**Repointed 19/11/2026.** REMEDY-03, REMEDY-04 and CI-08 name the matrix's home. 19/11/2026: the
matrix moved from the withdrawn US021 to
`project-management/src/01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md` (Sam: map first; CUT-PLAN P14;
the number was not validly allocated). No row's action or expected outcome changed.

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Baseline capture

| ID         | Action                                                                                                           | Expected outcome                                                                                                                                                                                                                                    | Flow | QA  | Result | Notes |
| ---------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| CAPTURE-01 | Open _Recorded during the build_ → the baseline slots, and read their date against the story branch's first edit | Each was taken before the first edit: the pre-edit tree, the citation set by identity with the detector hash and index state, the existing probe counts and labels, the US012 and US009 landing state, the length readings and the ShellCheck probe | —    | —   |        |       |
| CAPTURE-02 | Read the recorded probe counts                                                                                   | Re-counted from the scripts at capture, never inherited from the story's 9 / 5 / 2                                                                                                                                                                  | —    | —   |        |       |

### Red before green

| ID          | Action                                                                                                   | Expected outcome                                                                                                                                      | Flow | QA    | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| REDFIRST-01 | Read the recorded reds, one per new probe                                                                | Every new self-test probe in `shipped-registers.sh` and `shipped-ai.py` has a red recorded, in a commit before the one that added the check it proves | —    | PA-03 |        |       |
| REDFIRST-02 | For each red, read its recorded commit's change to the script with `git show <recorded SHA> -- <script>` | The probe's commit changes the probe and not the check it proves; the check arrives in a later commit                                                 | —    | PA-03 |        |       |
| REDFIRST-03 | Read each red's failing line                                                                             | It fails for the stated reason — the expected finding absent, or the expected message missing — never a path error or a crash                         | —    | —     |        |       |

### The change's reach

The original pre-edit capture measures history only. REACH-01/02 read the recorded post-rebase
base and HEAD; an intervening upstream change is recorded separately, never attributed to US010.

| ID       | Action                                                                                                       | Expected outcome                                                                             | Flow | QA    | Result | Notes |
| -------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| REACH-04 | Read the exact generated US010 export against its recorded provenance and reproduce it from the staged story | Byte-identical generated output; the exception admits no other export, task map or hand edit | —    | PA-02 |        |       |

| ID       | Action                                                                                                                                                                                                                                         | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| REACH-01 | Require the recorded clean landing-HEAD precondition, then run `git diff --name-only <recorded post-rebase base SHA> HEAD`                                                                                                                     | Every path is inside ST05's twelve permitted entries: under `project-management/src/`, `.copier/`, `project-management/workflows/` or `how-to/src/TEMPLATE-GUIDE/`, or exactly `copier.yml`, `.github/scripts/shipped-artefacts.sh`, `.github/scripts/shipped-registers.sh`, `.github/scripts/shipped-ai.py`, `.github/workflows/audit-template.yml`, `.claude/skills/wayfinder/SKILL.md` or `how-to/src/TEMPLATE-TOKENS.md`, plus exactly `project-management/export/clickup/US010-CLIENT.md` with the provenance required above | —    | PA-02 |        |       |
| REACH-02 | Require the same recorded clean landing HEAD, then diff each existing self-test probe in `shipped-registers.sh`, `shipped-artefacts.sh` and `shipped-ai.py` against the post-rebase base SHA, and compare with the labels re-read at that base | Every existing probe's label and expected substring is byte-identical                                                                                                                                                                                                                                                                                                                                                                                                                                                             | —    | PA-03 |        |       |
| REACH-03 | Read the diff for a new network fetch or credential read                                                                                                                                                                                       | None                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | —    | —     |        |       |

### The three boards

<!-- ADDED 19/11/2026 at the re-cut (US010.md -> Re-cut — 19/11/2026), before the walk: the areas
     BOARD, VOCAB, NORMAL, SUPERSEDE, ARCHIVE and BOARDGATE are new, and the rows they replace are
     retired in place above and below. The build's only other write here is _Recorded during the
     build_; these rows are a re-cut of the guide on the developer's decision of 19/11/2026, not a
     build capture, and every P0 value above is unaltered. -->

| ID       | Action                                                                                                                         | Expected outcome                                                                                                                   | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| BOARD-01 | Run `bash project-management/src/00-ASSETS/scripts/pm-board.sh --check`                                                        | Exit 0; no board stale, no instance `Unrecognised`                                                                                 | —    | —   |        |       |
| BOARD-02 | Open `DECISIONS-BOARD.md`, `FINDINGS-BOARD.md` and `BUGS-BOARD.md`                                                             | Each is generated, carries the 7.7.0 header comment, states its ordering rule in its opening line, and its rows honour it          | —    | —   |        |       |
| BOARD-03 | Read each board's columns                                                                                                      | ID, Title, Status and File; the decisions board adds Supersedes and Superseded by; no Summary and no Updated column                | —    | —   |        |       |
| BOARD-04 | List the instances of each register under its pattern, across the folder and its `archive/`, and compare with the board's rows | One row per instance and none for an absent file; every `BUG-*.md` bar the template has a row, the cross-cutting fallback included | —    | —   |        |       |
| BOARD-05 | Search the tree for `DECISION-INDEX.md`, `FINDING-INDEX.md`, `BUG-INDEX.md` and `MAP-INDEX.md`                                 | No such file exists                                                                                                                | —    | —   |        |       |

### Status vocabularies and normalisation

| ID        | Action                                                                                   | Expected outcome                                                                                                                                          | Flow | QA  | Result | Notes                                                                                                                                                                                                                                                                             |
| --------- | ---------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| VOCAB-01  | Open `.claude/skills/completion/SKILL.md`'s status vocabulary                            | ADR `Proposed \| Accepted \| Superseded \| Deprecated`, finding `Open \| Resolved`, bug `Open \| Fixed \| Verified`, each in its own subsection           | —    | —   |        | Amended 19/11/2026 — was: finding `Open \| Triaged`; why: Sam's decision D1 (`Triaged` leaked in from the findings template and was never the completion skill's); evidence: `.claude/skills/completion/SKILL.md` Findings; finding: owed to the US010 findings record at gate 22 |
| NORMAL-01 | Read every ADR, finding and bug status carrier                                           | A `**Status:**` line holding one vocabulary value only — no bold value, backticks, prose or trailing comment — and any prose on a `**Status note:**` line | —    | —   |        |                                                                                                                                                                                                                                                                                   |
| NORMAL-02 | Read `../../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`'s header | `Accepted`, its former trailing comment's substance in its note                                                                                           | —    | —   |        | Amended 19/11/2026 — was: `Proposed`; why: review CR-M1, Sam accepted the ADR 05/11/2026 and it read `Accepted` at P0, so the authored outcome was stale; evidence: the ADR's Status note; finding: owed to the US010 findings record at gate 22                                  |
| NORMAL-03 | Diff every accepted ADR against the P0 SHA                                               | Only its header lines change; no decision, context, option or consequence is edited                                                                       | —    | —   |        |                                                                                                                                                                                                                                                                                   |

### The supersession chain

| ID           | Action                                                                                                            | Expected outcome                                                                                                       | Flow | QA  | Result | Notes                                                                                                                                                                                                                                                                                                                                       |
| ------------ | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SUPERSEDE-01 | Read every ADR's `**Supersedes:**` and `**Superseded by:**` lines                                                 | Both present on every ADR, each a full filename or `None`                                                              | —    | —   |        |                                                                                                                                                                                                                                                                                                                                             |
| SUPERSEDE-02 | Walk every chain on the decisions board end to end                                                                | Each `Superseded` ADR names its successor and the successor names it back; none dangles                                | —    | —   |        |                                                                                                                                                                                                                                                                                                                                             |
| SUPERSEDE-03 | Read the chain from `ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES` to `ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH` | Shown as it stands, ending on a record that reads `Accepted`, and noted in the implementation record, never reconciled | —    | —   |        | Amended 19/11/2026 — was: ending on a record that is only `Proposed`; why: review CR-M2, the successor read `Accepted` at P0 (measured `Proposed` 21/09/2026); evidence: `git show 63813fa:project-management/src/15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md`; finding: owed to the US010 findings record at gate 22 |
| SUPERSEDE-04 | Read the two US010 records of 21/09/2026 and the record of 19/11/2026                                             | Both read `Superseded`, naming `ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md`, which names both back  | —    | —   |        |                                                                                                                                                                                                                                                                                                                                             |

### Archive

| ID         | Action                                                                                                                           | Expected outcome                                                                                    | Flow | QA  | Result | Notes                                                                                                                                                                                                                   |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ARCHIVE-01 | In a scratch copy, run `pm-archive.sh` on an ADR reading `Superseded`, a finding reading `Resolved` and a bug reading `Verified` | Each moves into its folder's `archive/`, its references rewritten, and `pm-board.sh --check` passes | —    | —   |        | Amended 19/11/2026 — was: a finding reading `Triaged`; why: Sam's decision D1; evidence: `project-management/src/00-ASSETS/scripts/pm-lib.sh` `FINDING_STATUSES`; finding: owed to the US010 findings record at gate 22 |
| ARCHIVE-02 | In the same copy, run it on an ADR reading `Accepted`, a finding reading `Open` and a bug reading `Fixed`                        | Each is refused, nothing moves                                                                      | —    | —   |        |                                                                                                                                                                                                                         |
| ARCHIVE-03 | In the same copy, edit an archived record and run `pm-board.sh --check`                                                          | It fails on the archive edit                                                                        | —    | —   |        |                                                                                                                                                                                                                         |

### The board seed gate

| ID           | Action                                                                                               | Expected outcome                                                                                                                                               | Flow | QA  | Result | Notes |
| ------------ | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| BOARDGATE-01 | Run `bash .github/scripts/shipped-boards.sh`                                                         | Exit 0 at eight boards: no negation, every `mv` in the copy-gated task, every seed present and byte-identical to the seed-only render, every board in `SEEDED` | —    | —   |        |       |
| BOARDGATE-02 | Run `bash .github/scripts/shipped-boards.sh --self-test` and read its lines                          | Every probe passes, the existing ones unchanged against the P0 capture                                                                                         | —    | —   |        |       |
| BOARDGATE-03 | Read the recorded red of the tightened check 2's probe — one board's `mv` moved into an ungated task | Recorded by SHA in a commit before the tightened check landed, firing exactly once                                                                             | —    | —   |        |       |
| BOARDGATE-04 | Read the three new seeds under `.copier/`                                                            | Each carries no row, and names no syntek-base ADR, finding or bug                                                                                              | —    | —   |        |       |

### The seed chain

| ID       | Action                                                                                                                            | Expected outcome                                                                                                                                                                             | Flow | QA  | Result | Notes |
| -------- | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| CHAIN-01 | Retired 19/11/2026 — superseded by the re-cut: seven index `mv` lines become three board lines; rewritten as CHAIN-06 to CHAIN-09 | —                                                                                                                                                                                            | —    | —   | —      | —     |
| CHAIN-02 | Retired 19/11/2026 — superseded by the re-cut: seven index `mv` lines become three board lines; rewritten as CHAIN-06 to CHAIN-09 | —                                                                                                                                                                                            | —    | —   | —      | —     |
| CHAIN-03 | Retired 19/11/2026 — superseded by the re-cut: seven index `mv` lines become three board lines; rewritten as CHAIN-06 to CHAIN-09 | —                                                                                                                                                                                            | —    | —   | —      | —     |
| CHAIN-04 | Retired 19/11/2026 — superseded by the re-cut: seven index `mv` lines become three board lines; rewritten as CHAIN-06 to CHAIN-09 | —                                                                                                                                                                                            | —    | —   | —      | —     |
| CHAIN-05 | Retired 19/11/2026 — superseded by the re-cut: seven index `mv` lines become three board lines; rewritten as CHAIN-06 to CHAIN-09 | —                                                                                                                                                                                            | —    | —   | —      | —     |
| CHAIN-06 | Open `copier.yml` at the copy-gated task and read its three new lines                                                             | Each reads `mv .copier/<KIND>-BOARD.md project-management/src/<REGISTER>/<KIND>-BOARD.md &&` for `DECISIONS`, `FINDINGS` and `BUGS` — no flag, no quoting, no split across the folded scalar | —    | —   |        |       |
| CHAIN-07 | Read where the three sit in that task                                                                                             | Inside the task whose `when:` tests the copy operation and carries the README `mv`, ahead of `rmdir .copier`, which still reads `rmdir`                                                      | —    | —   |        |       |
| CHAIN-08 | Count the `_tasks` entries against the P0 SHA, and read the task's `when:` key                                                    | No new task; the `when:` key unchanged                                                                                                                                                       | —    | —   |        |       |
| CHAIN-09 | Read each of the three lines' end, and search the diff of `copier.yml` for `mkdir` and a new `_exclude` line                      | No `\|\| true` suffix; no `mkdir`; no new negation                                                                                                                                           | —    | —   |        |       |

### The seeds

| ID      | Action                                                                                                                                            | Expected outcome | Flow | QA  | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | ---- | --- | ------ | ----- |
| SEED-01 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index seed; a board seed is proved by `shipped-boards.sh` check 4 (BOARDGATE rows) | —                | —    | —   | —      | —     |
| SEED-02 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index seed; a board seed is proved by `shipped-boards.sh` check 4 (BOARDGATE rows) | —                | —    | —   | —      | —     |
| SEED-03 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index seed; a board seed is proved by `shipped-boards.sh` check 4 (BOARDGATE rows) | —                | —    | —   | —      | —     |
| SEED-04 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index seed; a board seed is proved by `shipped-boards.sh` check 4 (BOARDGATE rows) | —                | —    | —   | —      | —     |

### The seed family

Run `bash .github/scripts/shipped-registers.sh`, then `bash .github/scripts/shipped-registers.sh --self-test`, and read each line.

| ID        | Action                                                                                                                                                                               | Expected outcome | Flow | QA  | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- | ---- | --- | ------ | ----- |
| FAMILY-01 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-02 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-03 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-04 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-05 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-06 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-07 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-08 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-09 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-10 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-11 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-12 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-13 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |
| FAMILY-14 | Retired 19/11/2026 — superseded by the re-cut: no third `shipped-registers.sh` family is built (re-cut grilling round 1 Q1); its controls are `shipped-boards.sh`'s (BOARDGATE rows) | —                | —    | —   | —      | —     |

### The update probe

Run `bash .github/scripts/shipped-ai.sh --self-test` and read each `PASS` line.

| ID        | Action                                                                                                                                    | Expected outcome                                                                                         | Flow | QA  | Result | Notes |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| UPDATE-01 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-02 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-03 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-04 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-05 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-06 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-07 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-08 | Retired 19/11/2026 — superseded by the re-cut: the update probe is re-pointed at boards (round 2 Q5); rewritten as UPDATE-09 to UPDATE-12 | —                                                                                                        | —    | —   | —      | —     |
| UPDATE-09 | Run `bash .github/scripts/shipped-ai.sh --self-test` and read the board update probe's lines                                              | A board edited and committed in a generated project is byte-identical to that edit after `copier update` | —    | —   |        |       |
| UPDATE-10 | Read the ungated-`when:` mutation's line                                                                                                  | Rejected on the byte-identity message                                                                    | —    | —   |        |       |
| UPDATE-11 | Read the mutation's recorded red                                                                                                          | Recorded by SHA in a commit before the byte-identity check landed                                        | —    | —   |        |       |
| UPDATE-12 | Read `fixture()` in `.github/scripts/shipped-ai.py`                                                                                       | It creates every folder the new `mv` lines target, and `copier.yml` gains no `mkdir`                     | —    | —   |        |       |

### The allowlist

| ID        | Action                                                                                                                                        | Expected outcome                                                                                        | Flow | QA  | Result | Notes |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| SEEDED-01 | Retired 19/11/2026 — superseded by the re-cut: `SEEDED` grows by three board entries, not seven indexes; rewritten as SEEDED-04 and SEEDED-05 | —                                                                                                       | —    | —   | —      | —     |
| SEEDED-02 | Retired 19/11/2026 — superseded by the re-cut: `SEEDED` grows by three board entries, not seven indexes; rewritten as SEEDED-04 and SEEDED-05 | —                                                                                                       | —    | —   | —      | —     |
| SEEDED-03 | Retired 19/11/2026 — superseded by the re-cut: `SEEDED` grows by three board entries, not seven indexes; rewritten as SEEDED-04 and SEEDED-05 | —                                                                                                       | —    | —   | —      | —     |
| SEEDED-04 | Open `.github/scripts/shipped-artefacts.sh` at `SEEDED`                                                                                       | It lists the three new boards at their landed paths beside the five 7.7.0 added, and nothing is removed | —    | —   |        |       |
| SEEDED-05 | Read the US012 landing state recorded at the rebase against `SEEDED`'s comment                                                                | Whichever landed second extends the other's wording; neither contradicts it                             | —    | —   |        |       |

### Generation job

Open the landing commit's workflow run, by the ID under _Recorded during the build_.

| ID    | Action                                                                                                                                   | Expected outcome                                                                                                                                                             | Flow | QA    | Result | Notes |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CI-01 | Retired 19/11/2026 — superseded by the re-cut: the completeness step lists three board paths, not seven indexes; rewritten as CI-08      | —                                                                                                                                                                            | —    | —     | —      | —     |
| CI-02 | Retired 19/11/2026 — superseded by the re-cut: the completeness step lists three board paths, not seven indexes; rewritten as CI-08      | —                                                                                                                                                                            | —    | —     | —      | —     |
| CI-03 | Read the `shipped-artefacts.sh` self-test step and the full-check step                                                                   | Both green: the eight `SEEDED` entries are not reported as leaks, and the self-test's existing probes pass                                                                   | —    | HP-09 |        |       |
| CI-04 | Retired 19/11/2026 — superseded by the re-cut: the literal grep and the link check are dropped, byte-identity covering both (round 3 Q4) | —                                                                                                                                                                            | —    | —     | —      | —     |
| CI-05 | Retired 19/11/2026 — superseded by the re-cut: the literal grep and the link check are dropped, byte-identity covering both (round 3 Q4) | —                                                                                                                                                                            | —    | —     | —      | —     |
| CI-06 | Read the `[1/4] Template Tokens` job                                                                                                     | Green — no seed carries a malformed template delimiter                                                                                                                       | —    | ES-16 |        |       |
| CI-07 | Read the US009 landing state recorded at the rebase before the landing commit against the `[3/4]` job                                    | If US009 landed first, its grep step and this story's steps sit side by side in the same job, a rebase rather than a wait                                                    | —    | EC-19 |        |       |
| CI-08 | Open the landing commit's run by its recorded ID and read the `[3/4]` completeness step                                                  | It lists the three new board paths, present in the generated tree; the 72-case matrix is MAP-GENERATION-COVERAGE S-01's, so this row reads the job's own render path(s) only | —    | —     |        |       |

### The seven index files

| ID       | Action                                                                                                                         | Expected outcome | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------- | ---- | --- | ------ | ----- |
| INDEX-01 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-02 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-03 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-04 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-05 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-06 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-07 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-08 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-09 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-10 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-11 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |
| INDEX-12 | Retired 19/11/2026 — superseded by the re-cut: no hand-written index file is built (round 1 Q1); the boards are the BOARD rows | —                | —    | —   | —      | —     |

### The read rule

| ID      | Action                                                                                                                                                | Expected outcome | Flow | QA  | Result | Notes |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | ---- | --- | ------ | ----- |
| READ-01 | Retired 19/11/2026 — superseded by the re-cut: the read rule is superseded by plain status lines (round 1 Q3; the new ADR); the NORMAL rows read them | —                | —    | —   | —      | —     |
| READ-02 | Retired 19/11/2026 — superseded by the re-cut: the read rule is superseded by plain status lines (round 1 Q3; the new ADR); the NORMAL rows read them | —                | —    | —   | —      | —     |
| READ-03 | Retired 19/11/2026 — superseded by the re-cut: the read rule is superseded by plain status lines (round 1 Q3; the new ADR); the NORMAL rows read them | —                | —    | —   | —      | —     |
| READ-04 | Retired 19/11/2026 — superseded by the re-cut: the read rule is superseded by plain status lines (round 1 Q3; the new ADR); the NORMAL rows read them | —                | —    | —   | —      | —     |
| READ-05 | Retired 19/11/2026 — superseded by the re-cut: the read rule is superseded by plain status lines (round 1 Q3; the new ADR); the NORMAL rows read them | —                | —    | —   | —      | —     |

### The map index

| ID          | Action                                                                                                               | Expected outcome | Flow | QA  | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------------------------------- | ---------------- | ---- | --- | ------ | ----- |
| MAPINDEX-01 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-02 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-03 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-04 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-05 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-06 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-07 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-08 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-09 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |
| MAPINDEX-10 | Retired 19/11/2026 — superseded by the re-cut: `MAP-INDEX.md` is dropped as superseded by 7.7.0's feature-maps board | —                | —    | —   | —      | —     |

### Map status headers

| ID      | Action                                                                                                                      | Expected outcome | Flow | QA  | Result | Notes |
| ------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------- | ---- | --- | ------ | ----- |
| ENUM-01 | Retired 19/11/2026 — superseded by the re-cut: the map Status enum and its re-derivation are dropped as superseded by 7.7.0 | —                | —    | —   | —      | —     |
| ENUM-02 | Retired 19/11/2026 — superseded by the re-cut: the map Status enum and its re-derivation are dropped as superseded by 7.7.0 | —                | —    | —   | —      | —     |
| ENUM-03 | Retired 19/11/2026 — superseded by the re-cut: the map Status enum and its re-derivation are dropped as superseded by 7.7.0 | —                | —    | —   | —      | —     |
| ENUM-04 | Retired 19/11/2026 — superseded by the re-cut: the map Status enum and its re-derivation are dropped as superseded by 7.7.0 | —                | —    | —   | —      | —     |
| ENUM-05 | Retired 19/11/2026 — superseded by the re-cut: the map Status enum and its re-derivation are dropped as superseded by 7.7.0 | —                | —    | —   | —      | —     |

### Gate boxes, slices and Umbrella ADRs

| ID          | Action                                                                                                                                                                      | Expected outcome                                                                                                                               | Flow | QA    | Result | Notes |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| MAPBOX-01   | Retired 19/11/2026 — superseded by the re-cut: the index-row box is removed, not ticked (round 1 Q4), and the map index the slices named is dropped; rewritten as MAPBOX-04 | —                                                                                                                                              | —    | —     | —      | —     |
| MAPBOX-02   | Retired 19/11/2026 — superseded by the re-cut: the index-row box is removed, not ticked (round 1 Q4), and the map index the slices named is dropped; rewritten as MAPBOX-04 | —                                                                                                                                              | —    | —     | —      | —     |
| MAPBOX-03   | Retired 19/11/2026 — superseded by the re-cut: the index-row box is removed, not ticked (round 1 Q4), and the map index the slices named is dropped; rewritten as MAPBOX-04 | —                                                                                                                                              | —    | —     | —      | —     |
| UMBRELLA-01 | Re-measure every map's `Umbrella ADRs` header row, then read each                                                                                                           | None asserts that this repository writes no ADRs or that none may be authored from a map; the wording routes to `../../15-DECISIONS/CLAUDE.md` | —    | HP-20 |        |       |
| MAPBOX-04   | Read `../../01-FEATURE-MAPS/MAP-000-TEMPLATE.md` and every map's Gate-to-stories list                                                                                       | No "Index row" checkbox remains in any of them                                                                                                 | —    | —     |        |       |

### Register context files

| ID         | Action                                                                                                                                      | Expected outcome                                                                                                                                                                                         | Flow | QA  | Result | Notes |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| CONTEXT-01 | Retired 19/11/2026 — superseded by the re-cut: no `## The index` section names a hand-written index; rewritten as CONTEXT-06 and CONTEXT-07 | —                                                                                                                                                                                                        | —    | —   | —      | —     |
| CONTEXT-02 | Retired 19/11/2026 — superseded by the re-cut: no `## The index` section names a hand-written index; rewritten as CONTEXT-06 and CONTEXT-07 | —                                                                                                                                                                                                        | —    | —   | —      | —     |
| CONTEXT-03 | Retired 19/11/2026 — superseded by the re-cut: no `## The index` section names a hand-written index; rewritten as CONTEXT-06 and CONTEXT-07 | —                                                                                                                                                                                                        | —    | —   | —      | —     |
| CONTEXT-04 | Retired 19/11/2026 — superseded by the re-cut: no `## The index` section names a hand-written index; rewritten as CONTEXT-06 and CONTEXT-07 | —                                                                                                                                                                                                        | —    | —   | —      | —     |
| CONTEXT-05 | Retired 19/11/2026 — superseded by the re-cut: no `## The index` section names a hand-written index; rewritten as CONTEXT-06 and CONTEXT-07 | —                                                                                                                                                                                                        | —    | —   | —      | —     |
| CONTEXT-06 | Open the `CONTEXT.md` of `15-DECISIONS`, `20-FINDINGS` and `21-BUGS`                                                                        | Each tree lists its board and the gitignored `.json` / `.html` siblings and an `archive/`, and says the board is generated; the shipped date sits in an HTML comment, `**Last Updated**` keeps its token | —    | —   |        |       |
| CONTEXT-07 | Run `bash code/src/scripts/audits/doc-references.sh --path` over each of the three                                                          | No new finding against the P0 baseline                                                                                                                                                                   | —    | —   |        |       |

### Instruction sites

The twenty-four live sites of the story's site scenario, re-read after the change. Each re-read is
recorded in the implementation record, as the story's manual criterion asks.

| ID       | Action                                                                                                                                                                                                                                                                           | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SITES-01 | Retired 19/11/2026 — superseded by the re-cut: the sites name boards, not index files; rewritten as SITES-06                                                                                                                                                                     | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | —    | —     | —      | —     |
| SITES-02 | Retired 19/11/2026 — superseded by the re-cut: the sites name boards, not index files; rewritten as SITES-06                                                                                                                                                                     | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | —    | —     | —      | —     |
| SITES-03 | Retired 19/11/2026 — superseded by the re-cut: the sites name boards, not index files; rewritten as SITES-06                                                                                                                                                                     | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | —    | —     | —      | —     |
| SITES-04 | Retired 19/11/2026 — superseded by the re-cut: the sites name boards, not index files; rewritten as SITES-06                                                                                                                                                                     | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | —    | —     | —      | —     |
| SITES-05 | Open the landing commit's workflow run, by the ID under _Recorded during the build_, and read the joined-line instruction search step on each render path; then read the step's definition in `.github/workflows/audit-template.yml`, and `git log` for the commit that added it | The step ran over the generated tree's Markdown on every render path, reading paragraphs rather than lines, printed its pattern and its output, and passed with the output empty. Its definition matches both halves — an instruction naming `CONTEXT.md` as a register's index, and a statement that a register has no index or that its index is deferred, the phrases QA plan Section 6 names among them — skips dated historical comments and nothing else, and exits non-zero on any hit; the commit that added it comes after the map commit (settled 03/10/2026, 17-story-plans grilling round 2 Q4). The step has no self-test probe, so this reading of its pattern is the check on it. Pattern and output are copied into the implementation record | —    | HP-18 |        |       |
| SITES-06 | Re-read every repaired instruction site, re-measured at implementation, including `../../15-DECISIONS/CLAUDE.md`'s index line and the `20-FINDINGS` and `21-BUGS` pair                                                                                                           | None instructs a row into a `CONTEXT.md` or says the register has no index; each names its board as generated and never hand-edited                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | —    | —     |        |       |

### The programme-plan permission

| ID      | Action                                                                                                                                                                                                  | Expected outcome                                                                           | Flow | QA  | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---- | --- | ------ | ----- |
| PLAN-01 | Re-read the seven sites in the three shipped story-plan files — `CLAUDE.md`'s purpose line, hand-written list and naming rule; `CONTEXT.md`'s tree and naming line; the template's two cross-references | None permits a cross-cutting programme plan; one instance pattern remains for the register | —    | —   |        |       |

### Seed counts and the updating guide

| ID          | Action                                                                                                                                                                                                                | Expected outcome                                                                                                                      | Flow | QA  | Result | Notes |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| COUNT-01    | Retired 19/11/2026 — superseded by the re-cut: the seed-count sites drop the number and name the copy-gated task (round 3 Q5); rewritten as COUNT-04                                                                  | —                                                                                                                                     | —    | —   | —      | —     |
| COUNT-02    | Retired 19/11/2026 — superseded by the re-cut: the seed-count sites drop the number and name the copy-gated task (round 3 Q5); rewritten as COUNT-04                                                                  | —                                                                                                                                     | —    | —   | —      | —     |
| COUNT-03    | Retired 19/11/2026 — superseded by the re-cut: the seed-count sites drop the number and name the copy-gated task (round 3 Q5); rewritten as COUNT-04                                                                  | —                                                                                                                                     | —    | —   | —      | —     |
| COUNT-04    | Re-read every seed-count site in `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md`, `06-GENERATION.md`, `14-UPDATING.md`, `15-TROUBLESHOOTING.md` and `how-to/src/TEMPLATE-TOKENS.md`, the `--trust` disclosure among them | None states a number of seeded files; each names the copy-gated task in `copier.yml` as the list                                      | —    | —   |        |       |
| UPDATING-01 | Retired 19/11/2026 — superseded by the re-cut: the two statements name the new boards, not seven indexes; rewritten as UPDATING-03 and UPDATING-04                                                                    | —                                                                                                                                     | —    | —   | —      | —     |
| UPDATING-02 | Retired 19/11/2026 — superseded by the re-cut: the two statements name the new boards, not seven indexes; rewritten as UPDATING-03 and UPDATING-04                                                                    | —                                                                                                                                     | —    | —   | —      | —     |
| UPDATING-03 | Read `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` for a project generated before this change                                                                                                                            | It states the project receives the routes to the new boards on update but never the board files (TM-14), and promises no fix          | —    | —   |        |       |
| UPDATING-04 | Read the same guide for `copier recopy`, and `copier copy` into an existing project                                                                                                                                   | It states every blank seed is moved over the project's own file and an uncommitted register edit is lost (TM-18), and promises no fix | —    | —   |        |       |

### Wayfinder

| ID           | Action                                                                                                                                              | Expected outcome | Flow | QA  | Result | Notes |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | ---- | --- | ------ | ----- |
| WAYFINDER-01 | Retired 19/11/2026 — superseded by the re-cut: wayfinder's chart-step line is dropped as superseded by 7.7.0, the advance tests being `wayfinder`'s | —                | —    | —   | —      | —     |
| WAYFINDER-02 | Retired 19/11/2026 — superseded by the re-cut: wayfinder's chart-step line is dropped as superseded by 7.7.0, the advance tests being `wayfinder`'s | —                | —    | —   | —      | —     |

### Legibility

| ID         | Action                                                                                                                                                          | Expected outcome                                                                                                                                                   | Flow | QA  | Result | Notes |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | --- | ------ | ----- |
| LEGIBLE-01 | Retired 19/11/2026 — superseded by the re-cut: US011's four indexes are boards with no Summary; the title-legibility read is LEGIBLE-02                         | —                                                                                                                                                                  | —    | —   | —      | —     |
| LEGIBLE-02 | Give each of the decisions, findings and bugs boards, alone, to its own fresh Claude session that has opened none of its records; ask what each record is about | The reader can tell from the titles alone; each title it cannot read, or that restates a filename, is recorded as a finding; the walk is reviewed by the developer | —    | —   |        |       |

### Citation gate

Run `bash code/src/scripts/audits/doc-references.sh` in the recorded index state, normalise it to
`(file, kind, token)` with multiplicity kept, and `diff` it against the baseline.

| ID      | Action                                                                                           | Expected outcome                                                                                                                                                         | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| CITE-01 | Re-take `git hash-object code/src/scripts/audits/doc-references.sh` and compare with the capture | Recorded beside the captured value. Had it moved, the diff is reported **detector-confounded**, never as this story's                                                    | —    | —     |        |       |
| CITE-02 | Run the gate and the identity diff                                                               | No new line in any file this story edits; a line outside the edit set is a concurrent change's, named with its file. Never reported as passing while the baseline stands | —    | ES-19 |        |       |
| CITE-03 | Read whether US004 has landed and the gate gone green                                            | If so, the plain-pass reading applies and is stated; otherwise CITE-02's diff is the result                                                                              | —    | ES-19 |        |       |

### Lint by hand

| ID      | Action                                                           | Expected outcome                                                                                                                             | Flow | QA  | Result | Notes |
| ------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| LINT-01 | Read the ShellCheck capture                                      | Recorded as run, with its version and output, or as not run with the reason — never as a `lint.sh` pass, because no `lint.sh` leg reads bash | —    | —   |        |       |
| LINT-02 | Read the Python lint capture for `.github/scripts/shipped-ai.py` | Recorded as run or not run, with the reason — `lint.sh` reads Python under `code/src/django/` only                                           | —    | —   |        |       |

### Close

| ID       | Action                                            | Expected outcome                                            | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------- | ----------------------------------------------------------- | ---- | --- | ------ | ----- |
| CLOSE-01 | Read _Tester sign-off_ against the story's author | The tester who signs is not the author of the story's edits | —    | —   |        |       |

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

---

## Tester sign-off

Filled at the walk.

| Field        | Value                                    |
| ------------ | ---------------------------------------- |
| **Tester**   |                                          |
| **Date**     |                                          |
| **Browsers** | N/A — Gate surface; no browser is opened |
| **Outcome**  |                                          |
| **Blockers** |                                          |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against the automated record — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US010.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the implementation plan this guide was authored beside
- "../AUTOMATED/US010-TEST-STATUS.md" — the paired automated-test record; it does not exist until `22-implementation-documentation` writes it
- `../../11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the fifteen security constraints the chain, family and update rows read against
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why a scenario this guide cannot walk is named out of scope rather than reported as passed
