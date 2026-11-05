# US004 — Test Status

_The automated-test record for US004: what each automated test checks and whether it passed. Written at `22-implementation-documentation` Step 4. This story ships one bash script, its fixtures and Markdown, so it has no pytest or Bruno suite; its automated proof is the gate's own `--self-test`, a gate run that no story marker can attribute. The record states that rather than skipping the file (`CLAUDE.md` in this folder → Guardrails)._

**Last Updated**: 05/11/2026 · **Story**: US004 · **Status**: Partial

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

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US###
```

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

**Closeout run, 05/11/2026, live checkout at `46d5c0f`, `git status --porcelain` showing only the
walked guide:** exit 0, `Self-test passed — 130 probes`, about 6 s, no untracked file left behind.
The detector run was sha256 `5ff7dc94…89c69`. The walk's SELFTEST-01 gave the same 130 on a clean
index (`../MANUAL/US004-MANUAL-TESTING.md`).

| Probe family                         | Probes | What it proves                                                                                                                                                                                                          |
| ------------------------------------ | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pre-US004 fixture pairs and set rows | 14     | The five clauses added 20/08–08/09/2026 still separate `broken/` from `clean/`; the derived excluded-path set's four direct rows                                                                                        |
| P1 — exemption arm                   | 11     | The top-level research, handoffs and learning pairs, the feature-map pair and a `-TEMPLATE.` file are read; a research note and a feature map stay exempt (HP-01, EC-02)                                                |
| P2 — one population                  | 3      | An untracked excluded file is template-only after both set builders re-run; the probe file is gone once its shell exits; a stale probe from a killed run is swept (AC-GAP-8, ES-03)                                     |
| P3 — the citer test and alternation  | 12     | Eight instance-shaped citers exempt; `US000` and `-TEMPLATE.` citers still reported; `ADR-US###` and `QA-PLAN-US###` fire, the retired spellings are silent (AC-GAP-5, EC-01, EC-02)                                    |
| P4 — PM tree and class registration  | 16     | A dead PM path fires; the citer is exempt and Check 1 still fires; three-digit bounds; both US000 targets fire despite the class row (HP-03, HP-04, EC-01, EC-03, EC-05, EC-06, AC-GAP-10)                              |
| R2 — round 2 decisions               | 20     | The derived citer rule; volume specs; multi-anchor; date placeholders; relative class rows; Check 4 before Check 1                                                                                                      |
| R4 — seeded citers                   | 4      | A seeded citer is non-shipping for Checks 2 and 3; Check 1 still runs on it                                                                                                                                             |
| Phase 9 fixes                        | 48     | Relative paths routed after normalisation; no GNU `realpath`; the citer rule bounded on the left; the exemption arms scoped to copier's re-includes; volume host halves; naming rows; unrouted templates; dated folders |
| Fixture-tree exemption               | 2      | The fixture tree, `-TEMPLATE.` fixtures included, stays exempt from an ordinary run                                                                                                                                     |

Totals 130. The reference self-test at the branch point `173abff`, re-measured in a clone at the
walk, gave **15**; it is not the before-edit capture, which was never taken (finding F-001 in
`../../20-FINDINGS/FINDING-US004-CITATION-GATE-GIT-INDEX-05-11-2026.md`).

**Every new probe was red against the detector it was written for.** The red phases are commits
`e3d5187` (P1 to P4), `9abb477` (round 2), the round-4 red dispatch before `53a8713`, and the phase 9
red dispatch before `5c24c12`, which ran 104 Pass and 26 Fail out of 130 with all 81 earlier probes
green. No expectation was edited to pass: the phase 9 verifier compared 114 expectation lines with
`HEAD`, and the only four that moved are the P2 block, restructured so its guard can fail
(QA-US004-11 in `../../19-REVIEWS/REVIEW-US004-CITATION-GATE-GIT-INDEX.md`).

The walk's own runs, the whole-tree figures and the gate results are rows in
`../MANUAL/US004-MANUAL-TESTING.md` (walked 05/11/2026 at `46d5c0f`: **23 Pass, 12 Fail**).

---

## 3. Outstanding gaps and flaky tests

| Item                                   | Type             | Reason / owner                                                                                                                                                                                                                                        |
| -------------------------------------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every pytest, Bruno, E2E and axe suite | Out of scope     | No code path. The story edits `code/src/scripts/audits/doc-references.sh`, adds fixtures under `code/src/scripts/audits/fixtures/doc-references/`, two register rows and Markdown. Every FLAGS row but `QA` reads `N/A` (`../../02-STORIES/US004.md`) |
| `doc-references.sh --self-test`        | Gate, not suite  | 130/130, exit 0 (Section 2). A gate run carries no story marker and cannot reach the generated block                                                                                                                                                  |
| ES-03's failure path                   | Not a probe      | No probe forces a failure between the P2 probe creating its file and asserting on it. Proved by hand in phase 9: a forced P2 failure, and SIGTERM at 17 points in the run, each left the tree clean (QA-US004-11). The guide routes ES-03 here        |
| SIGKILL during `--self-test`           | Known limitation | A killed run leaves its probe file under `research/`; the next run sweeps it (P9-F9). Two concurrent self-tests can delete each other's probe (finding F-009)                                                                                         |
| `--self-test` in a generated project   | Open gap         | Exits 1 without `copier.yml`: four probes fail, two of them US004's. Dated `GAPS.md` entry of 05/11/2026, deferred by Sam (QA-US004-05)                                                                                                               |
| ShellCheck over the edited script      | Not clean        | Run by hand, not a project script: SC2221/SC2222 at `:828`, SC2016 ×2, SC2329 ×2 new in US004 (manual row GATES-05; finding F-003)                                                                                                                    |
| Coverage figures in Section 1.2        | Not attributable | The 100.0% figures and "Met? Yes" are the whole Django project's, which the no-test block prints regardless. They say nothing about US004 (the filed bug above)                                                                                       |
| Auth-critical row                      | N/A              | No module in the authentication, session or permission path is in scope                                                                                                                                                                               |
| Migration check                        | N/A              | No model and no migration                                                                                                                                                                                                                             |
| Manual rows                            | 12 failing       | Ten read the before-edit captures that were never taken (F-001); MEASURE-01 awaits a proposed amendment (F-002); GATES-05 is ShellCheck (F-003). None is a missing automated test: no suite could have taken a capture the build skipped              |

### Whole-tree survivors — every one named with its owner

The story requires each finding that survives it to be named here with the story that owns it.
`bash code/src/scripts/audits/doc-references.sh` over the whole tree at `46d5c0f`, porcelain empty
(manual row AFTER-01): **exit 1, 28 findings, every one `[dangling path]`**, and 0 instance, 0
template-only, 0 plan-prefix. 1181 files read, 173 exempt, 67,364 tokens, 13,592 path tests,
330.27 s. **No finding of the three classes this story owns remains. This is not the gate
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

**Partial**: 0 attributed tests, no coverage attributable (no Python path); the story's automated proof is `doc-references.sh --self-test`, 130/130 at exit 0. The whole-tree gate exits 1 on 28 named survivors, and 12 manual rows fail. Verified 05/11/2026.

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
