# US004 — Test Status

_The automated-test record for US004: what each automated test checks and whether it passed. Written at `22-implementation-documentation` Step 4. This story ships one bash script, its fixtures and Markdown, so it has no pytest or Bruno suite; its automated proof is the gate's own `--self-test`, a gate run that no story marker can attribute. The record states that rather than skipping the file (`CLAUDE.md` in this folder → Guardrails)._

**Last Updated**: 09/11/2026 · **Story**: US004 · **Status**: Partial

- **Story:** `../../02-STORIES/US004.md` — the citation gate stops depending on the git index, and the PM tree becomes checkable
- **Story plan:** `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the code master this record closes the loop on
- **Branch:** `us004/citation-gate-git-index`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US004
```

**Read Section 3 before this block.** No test declares US004, and none could, because the story
changes no Python or Bruno path. The coverage figures below come from the **whole-project** report
artefacts already on disk, not from anything this story ran or touched — the defect filed as
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`.

The floors are **one floor, not one per layer** — template, django-component and HTMX-partial
tests are pytest tests and count towards the same number as the rest of the backend. On
`staging` and `main` the pre-PR gate raises every floor to **80%**, so a story green locally can
still block the PR if a module in scope sits between its floor and 80%. **Auth-critical** means
any module in the authentication, session or permission path.

<!-- BEGIN GENERATED: test-record -->

### 1.1 Suite summary

| Suite      | Report artefact | Tests | Result              | Coverage   |
| ---------- | --------------- | ----- | ------------------- | ---------- |
| **Totals** |                 | **0** | **0 Pass / 0 Fail** | **100.0%** |

_Not run, or produced no artefact: E2E and accessibility. An absent suite is not a zero — say why in Section 3._

_No test declares `US004`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

### 1.2 Coverage vs floors

| Scope                       | Floor | This story                                       | Met? |
| --------------------------- | ----- | ------------------------------------------------ | ---- |
| All modules — line + branch | 75%   | 100.0% line / 100.0% branch                      | Yes  |
| Auth-critical modules       | 90%   | _{state the modules in scope and their figures}_ | _{}_ |

_The line floor above is read from `pyproject.toml`; the 90% auth floor is not machine-readable and is stated by `code/docs/testing/COVERAGE.md`, which owns both. The auth-critical row is not derivable either — which modules sit in the authentication, session and permission path is a judgement. Name them and read their figures from the per-module table below._

| Module                                           | Statements | Missed | Branch | Cover  |
| ------------------------------------------------ | ---------- | ------ | ------ | ------ |
| `code/src/django/apps/core/apps.py`              | 4          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/management/base.py`   | 17         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/middleware.py`        | 23         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/schemas.py`           | 8          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/services/errors.py`   | 20         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/templatetags/core.py` | 7          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/apps.py`            | 3          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/checks.py`          | 51         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/urls.py`            | 5          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/views.py`           | 24         | 0      | 100.0% | 100.0% |

### 1.3 Tests by module

_No attributed tests to list for US004._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest or Bruno suite exists for this story, so there is nothing to run before the generator.
Regenerate the block against whatever report artefacts are on disk:

```bash
bash code/src/scripts/tests/test-record.sh US004
```

The story's automated proof is the gate's own self-test, run through its project script:

```bash
bash code/src/scripts/audits/doc-references.sh --self-test
```

**Current run, 09/11/2026, after the F-051 fix and its independent review round 4:** in the live
working tree (uncommitted; nothing staged), re-run by the records pass: exit 0, `Self-test passed
— 208 probes`. Detector sha256 `167c7845…fa8b`, 3424 lines, identical to the fix round's final
checksum. ShellCheck 0.11.0 by hand: exit 0 (evidence
/home/sam-desktop/.claude/tmp/us004-f051/round2/).

**Previous run, 06/11/2026, after the F-021 fix and its review round (second sitting):** in a
`--no-hardlinks` clone holding the uncommitted working tree as one scratch commit on `d035f04`,
porcelain empty: exit 0, `Self-test passed — 182 probes`, and the same under `LC_ALL=C`; no
untracked file left behind. Detector sha256 `8402b0c8…dba49`, 2943 lines. ShellCheck 0.11.0 by
hand: exit 0. `template-render.sh --self-test`: 7 probes, exit 0 (evidence /tmp/us004-w3.jbal/).

**Previous run, 06/11/2026, after workflow 23's fix rounds:** in a `--no-hardlinks` clone holding
the uncommitted working tree as one scratch commit on `3de67ff`, porcelain empty: exit 0,
`Self-test passed — 174 probes`, no untracked file left behind. The detector run was sha256
`f6d081b4…0400033`, byte-identical to the live working tree's, 2881 lines. ShellCheck 0.11.0 by
hand over the same script: exit 0, no output. The first closeout run, 05/11/2026 at `46d5c0f`,
gave 130.

| Probe family                         | Probes | What it proves                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ------------------------------------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pre-US004 fixture pairs and set rows | 14     | The five clauses added 20/08–08/09/2026 still separate `broken/` from `clean/`; the derived excluded-path set's four direct rows                                                                                                                                                                                                                                                                                                                                                                                                               |
| P1 — exemption arm                   | 11     | The top-level research, handoffs and learning pairs, the feature-map pair and a `-TEMPLATE.` file are read; a research note and a feature map stay exempt (HP-01, EC-02)                                                                                                                                                                                                                                                                                                                                                                       |
| P2 — one population                  | 3      | An untracked excluded file is template-only after both set builders re-run; the probe file is gone once its shell exits; a stale probe from a killed run is swept (AC-GAP-8, ES-03)                                                                                                                                                                                                                                                                                                                                                            |
| P3 — the citer test and alternation  | 12     | Eight instance-shaped citers exempt; `US000` and `-TEMPLATE.` citers still reported; `ADR-US###` and `QA-PLAN-US###` fire, the retired spellings are silent (AC-GAP-5, EC-01, EC-02)                                                                                                                                                                                                                                                                                                                                                           |
| P4 — PM tree and class registration  | 16     | A dead PM path fires; the citer is exempt and Check 1 still fires; three-digit bounds; both US000 targets fire despite the class row (HP-03, HP-04, EC-01, EC-03, EC-05, EC-06, AC-GAP-10)                                                                                                                                                                                                                                                                                                                                                     |
| R2 — round 2 decisions               | 20     | The derived citer rule; volume specs; multi-anchor; date placeholders; relative class rows; Check 4 before Check 1                                                                                                                                                                                                                                                                                                                                                                                                                             |
| R4 — seeded citers                   | 4      | A seeded citer is non-shipping for Checks 2 and 3; Check 1 still runs on it                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Phase 9 fixes                        | 48     | Relative paths routed after normalisation; no GNU `realpath`; the citer rule bounded on the left; the exemption arms scoped to copier's re-includes; volume host halves; naming rows; unrouted templates; dated folders                                                                                                                                                                                                                                                                                                                        |
| Workflow 23, first fix round         | 26     | QA-F01 mutant-killers; the story-less dated citers and their guards; every anchor form; date-hidden instances; Direction B without presence; the single-source shipping facts and their drift check; file-relative Markdown links (GAPS-REL)                                                                                                                                                                                                                                                                                                   |
| Workflow 23, second fix round        | 18     | Linked targets judged as tokens are (REV-01, H-01); the line-level mutant-killers (REV-02); one finding per citation (REV-03); the link extractor's code spans, fences, comments and escapes (H-02); path-form dated instances (H-03); the citer date arm's scope (H-04); root-form Direction B (H-05); the `_exclude` parse and template signal (H-06); a hyphen-led token (H-07); the remaining anchors (H-08); remedies by class (H-10)                                                                                                     |
| F-021 and its review round           | 8      | The `NN` placeholder narrowing and the seeded-map Check 2 fix (F-021, F-054); each one-sided capital guard, both anchors and the two-`N` minimum (A-1, A-2); the locale-fixed capital class (QA-A1); `USNNN` pinned (QA-A3)                                                                                                                                                                                                                                                                                                                    |
| F-051 — surface-gated citations      | 16     | Every surface declined passes and counts, every surface taken reports (guard); a declined directory, a `/**` glob, a file-relative link and a bare file-relative token pass; a missing key follows its question's default, false declines and true takes; a missing, non-boolean or not-copier-written answers file fails closed; the template applies no gating; the `gated` and `absent` rows derive and drift is caught; five unreadable templated shapes exit 2; the facts file holds every gated row; end to end in a project-shaped tree |
| Round 4 fixes                        | 10     | The qualified verdict, terminal and report (C-01, Q-01); one count per citation (C-04); an indented, duplicated, space-before-colon or quoted key fails closed (Q-02); a defaultless question, `no` and quoted `"false"` answers (Q-05)                                                                                                                                                                                                                                                                                                        |
| Fixture-tree exemption               | 2      | The fixture tree, `-TEMPLATE.` fixtures included, stays exempt from an ordinary run                                                                                                                                                                                                                                                                                                                                                                                                                                                            |

Totals 208: 130 at the first closeout, 156 after the first fix round, 174 after the second, 182 after the F-021 round, 198 after F-051, 208 after its round 4. Every F-051 and round 4 probe was red before its fix and red again when that fix alone was reverted; mutants M7 to M9 now fail. Round 2 proved each repair by reverting it alone: 33 reverts, every one red. The reference self-test at the branch point `173abff`, re-measured in a clone at the
walk, gave **15**; it is not the before-edit capture, which was never taken (finding F-001 in
`../../20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md`).

**Every new probe was red against the detector it was written for.** The red phases are commits
`e3d5187` (P1 to P4), `9abb477` (round 2), the round-4 red dispatch before `53a8713`, and the phase 9
red dispatch before `5c24c12`, which ran 104 Pass and 26 Fail out of 130 with all 81 earlier probes
green. No expectation was edited to pass: the phase 9 verifier compared 114 expectation lines with
`HEAD`, and the only four that moved are the P2 block, restructured so its guard can fail
(QA-US004-11 in `../../19-REVIEWS/REVIEW-US004-CITATION-GATE-GIT-INDEX.md`).

**In a generated project the self-test exits 2, not 0** — `Self-test NOT RUN in full`: 13 probe
sets need the copier contract, which a generated project never receives, and are named as not
run; the 186 that ran pass (project rendered from the working tree through `code/src/scripts/development/template-render.sh` with its default answers, 09/11/2026; 161 on 06/11/2026, 153 before the F-021 round). It is reported
as not run, never as passed (`code/docs/GATE-REPORTING.md`).

The walk's own runs, the whole-tree figures and the gate results are rows in
`../MANUAL/US004-MANUAL-TESTING.md`: walked 05/11/2026 at `46d5c0f`, **23 Pass, 12 Fail**; after
Sam's rulings of 05/11/2026 and 06/11/2026, and the re-walk of 06/11/2026 against the fix rounds,
**28 Pass, 7 Fail**, unchanged by the second sitting's re-walk against the F-021 round.

---

## 3. Outstanding gaps and flaky tests

| Item                                   | Type                   | Reason / owner                                                                                                                                                                                                                                                                                                                                                                                                                       |
| -------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Every pytest, Bruno, E2E and axe suite | Out of scope           | No code path. The story edits `code/src/scripts/audits/doc-references.sh`, adds fixtures under `code/src/scripts/audits/fixtures/doc-references/`, two register rows and Markdown. Every FLAGS row but `QA` reads `N/A` (`../../02-STORIES/US004.md`)                                                                                                                                                                                |
| `doc-references.sh --self-test`        | Gate, not suite        | 208/208, exit 0 (Section 2). A gate run carries no story marker and cannot reach the generated block                                                                                                                                                                                                                                                                                                                                 |
| ES-03's failure path                   | Not a probe            | No probe forces a failure between the P2 probe creating its file and asserting on it. Proved by hand in phase 9: a forced P2 failure, and SIGTERM at 17 points in the run, each left the tree clean (QA-US004-11). The guide routes ES-03 here                                                                                                                                                                                       |
| SIGKILL during `--self-test`           | Known limitation       | A killed run leaves its probe file under `research/`; the next run sweeps it (P9-F9). Two concurrent self-tests can delete each other's probe (finding F-009)                                                                                                                                                                                                                                                                        |
| `--self-test` in a generated project   | Not run in full        | Exits 2: 13 contract-bound probe sets named as not run, the 186 that ran pass. Closed as a gap 06/11/2026 (finding F-022); its `GAPS.md` entry marked closed                                                                                                                                                                                                                                                                         |
| Whole-tree gate in a generated project | Green since 09/11/2026 | Default answers: exit 0, 121 citations passed unjudged into declined-surface paths (INCLUDE_DESKTOP=18 INCLUDE_MOBILE=60 INCLUDE_RUST=23 INCLUDE_WAGTAIL=20), named in the verdict; 119 findings before the fix, and again with `.copier-answers.yml` removed (fails closed); all four surfaces on: exit 0, `passed 0`. Rendered through `code/src/scripts/development/template-render.sh --check-references` (finding F-051, fixed) |
| ShellCheck over the edited script      | Clean                  | Run by hand, not a project script: ShellCheck 0.11.0, exit 0, no output, on the 2943-line script and on 09/11/2026 the 3424-line one (manual row GATES-05; findings F-003, F-031)                                                                                                                                                                                                                                                    |
| Coverage figures in Section 1.2        | Not attributable       | The 100.0% figures and "Met? Yes" are the whole Django project's, which the no-test block prints regardless. They say nothing about US004 (the filed bug above)                                                                                                                                                                                                                                                                      |
| Auth-critical row                      | N/A                    | No module in the authentication, session or permission path is in scope                                                                                                                                                                                                                                                                                                                                                              |
| Migration check                        | N/A                    | No model and no migration                                                                                                                                                                                                                                                                                                                                                                                                            |
| Manual rows                            | 7 failing              | All seven read the before-edit captures that were never taken (F-001), a deviation Sam accepted 05/11/2026. None is a missing automated test: no suite could have taken a capture the build skipped                                                                                                                                                                                                                                  |

### Whole-tree survivors — every one named with its owner

The story requires each finding that survives it to be named here with the story that owns it.
`bash code/src/scripts/audits/doc-references.sh` over the whole tree, 06/11/2026 (second sitting),
in a fresh clone holding this records pass (manual row AFTER-01): exit 1, the same 28 `[dangling path]` survivors and 0 of every other class, nothing on stderr; 1186 files read, 201 exempt, 69,131 tokens, 14,320 path tests, 1,340 link targets, 356 s. Before that, in the clone
of Section 2: **exit 1, 28 findings, every one `[dangling path]`**, and 0
instance, 0 template-only, 0 plan-prefix, 0 `[dangling link]`, 0 `[shipping facts]`; nothing on
stderr. 1185 files read, 199 exempt, 68,159 tokens, 13,767 path tests, 1,335 Markdown link
targets, 348 s, in a clone holding the records of this closeout too. The same 28 targets from the same citers as at `46d5c0f`, and the same set as the fix
round's own clean-clone run. **No finding of the three classes this story owns remains. This is not the gate
passing** (`code/docs/GATE-REPORTING.md`): it exits 1, and stays red until each owner builds its
path.

| Target, quoted because it does not exist yet  | Findings | Owner | Cited from                                                                                                                              |
| --------------------------------------------- | -------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| "how-to/src/OUTBOUND-TIMEOUTS.md"             | 10       | US005 | US005's QA plan ×3, story plan ×3 and ADR ×1; SPRINT-03 ×1; the SPRINT-03 plan ×2                                                       |
| "code/src/scripts/\_lib/posture-guard.sh"     | 10       | US006 | US006's story ×2, threat model ×1, QA plan ×1 and ADR ×1; SPRINT-03 ×1, SPRINT-04 ×2; the SPRINT-03 plan ×2                             |
| "code/src/django/apps/core/observability.py"  | 3        | US014 | US014's story ×2 and threat model ×1                                                                                                    |
| its unit test under "apps/core/tests/unit/"   | 3        | US014 | US014's story ×2 and QA plan ×1. `US014.md:813` was respelt in full at `74b9892` (QA-US004-02), so it clears when US014 builds the file |
| "project-management/src/21-BUGS/BUG-INDEX.md" | 2        | US010 | US011's QA plan ×2 — newly visible, because the PM tree is now checked                                                                  |

The survivors are forward references to paths their owning stories create. Under the 05/11/2026
_Key Decisions_ row "Forward references to unbuilt code", they stay as named survivors, never
register rows or ignore markers.

**Unmarked tests are invisible here.** `bash code/src/scripts/audits/story-markers.sh` was read on
05/11/2026: 9 test modules and 7 Bruno requests scanned, 0 marked and 72 unmarked, exit 0 as a
warning. None of the 72 is a US004 test, because the story wrote none.

---

## 4. Status line

**Partial**: 0 attributed tests, no coverage attributable (no Python path); the story's automated proof is `doc-references.sh --self-test`, 208/208 at exit 0, and ShellCheck is clean. The whole-tree gate exits 1 on 28 named survivors, and 7 manual rows fail, all on the accepted F-001 deviation; a default-answer project's gate exits 0 since F-051. Verified 09/11/2026.

---

## Cross-references

- `../../02-STORIES/US004.md` — the story under test
- `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the implementation plan this record closes
- `../MANUAL/US004-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; it carries the whole-tree runs and the A/B
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md` — whether the specified scenarios were met
- `../../19-REVIEWS/REVIEW-US004-CITATION-GATE-GIT-INDEX.md` — the phase 9 review, QA pass, verifiers and fix round
- `../../20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md` — the findings this record cites
- `code/src/scripts/audits/CONTEXT.md` — what each `doc-references.sh` clause checks
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
