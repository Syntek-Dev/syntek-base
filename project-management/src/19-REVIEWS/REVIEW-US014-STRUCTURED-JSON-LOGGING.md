# Code Review — US014 Structured JSON logging with a `request_id` on every entry, queried by Compose service label

**Last Updated**: 24/11/2026 · **Story**: US014 · **Status**: In Review

| Field        | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US014 — every line Django's `LOGGING` emits is one JSON object carrying a `request_id`; queried by Compose service label                                                                                                                                                                                                                                                                                                                                       |
| **Branch**   | `us014/structured-json-logging` (base `b1705408`; head `f190e2e7`) — **already merged** to `dev` via PR #44 at `94db8f02`. This record is written on `dev` after the merge, from the reports of the review and QA passes that ran on the branch before the PR                                                                                                                                                                                                  |
| **PR**       | #44 · target `dev` · merged 24/11/2026 by Sam (`Syntek-Studio`). CI: **53 checks passed, 1 skipped** (`Claude AI`), merge state CLEAN. `git diff f190e2e7 94db8f02` is empty, so the merge tree is the reviewed head                                                                                                                                                                                                                                           |
| **Reviewer** | Two independent Claude (Opus) passes inside the build workflow, 23/11/2026, against the uncommitted build: _Code review_ (`code-reviewer`, Standards and Spec axes) and _QA + security_ (`qa-tester` and `security` read inline, `08-security-hardening` checks). Their findings were verified and applied by a third pass, _Apply verified findings_. This record is written by a fourth agent, which wrote none of the code and none of the records it reads |
| **Date**     | 24/11/2026                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **Verdict**  | **Approve-with-nits.** No Critical or High. Two Medium (R-001, R-002) fixed test-first in the build commit; every Low fixed or ruled; two Nits left open as cosmetic or out of scope                                                                                                                                                                                                                                                                           |

**Codes from:** `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the
implementation master this review closes the loop on.
**Story:** `../02-STORIES/US014.md` — the acceptance criteria the code must satisfy.

---

## 0. How the review was run

Both passes read the working tree while it was uncommitted, with `dev` and `HEAD` both at
`b1705408` (52 modified files, 6 untracked under `apps/core`). Every fix the third pass applied
landed in the build commit `e2dfde22`; F-001 (the story-map writer) landed separately in
`1d35ae29`. So no finding below has a commit of its own. The findings record F-001 to F-012
(`../20-FINDINGS/archive/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`) and the manual walk came
**after** these passes. This record cites them and does not repeat them.

Where the two passes found the same defect, it is one row here, and the row names both IDs:
review `M`/`L` and QA `F`.

---

## 1. Scope & files reviewed

The story diff is `git diff b1705408...f190e2e7` — 89 files, +5580 / -751. It covers the backend
lane only (`19-backend-code`; `20` and `21` N/A): a hand-written formatter and filter, the stored
id in the middleware, each environment's own `LOGGING`, the three entrypoints, the dev logs mount
and the documentation set. Out of scope: the collector and edge half (contract text, realised in
the deploy repository) and the dev-stack manual rows (the walk's).

| File                                                                                                                                           | Change                                                                                                                                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `code/src/django/apps/core/observability.py`                                                                                                   | Created — `JSONFormatter`, `RequestIDFilter`, the never-raise fallback, the 16 KiB cap; 560 lines, standard library only                   |
| `code/src/django/apps/core/middleware.py`                                                                                                      | `RequestIDMiddleware` stores the validated or minted id on `request.request_id`                                                            |
| `code/src/django/config/settings/{dev,test,staging,production}.py` · `base.py`                                                                 | One `LOGGING` per environment, filter on every handler, `ext://sys.stdout` off dev, `django` at `WARNING` with no handlers; `base.py` none |
| `code/src/docker/django/entrypoint.{staging,prod,test}.sh`                                                                                     | `--access-logfile -` removed; staging at `--log-level warning`                                                                             |
| `code/src/django/apps/core/tests/unit/test_observability{,_limits,_requests,_settings}.py` · `observability_support.py` · `test_middleware.py` | Created/extended — 156 US014 cases                                                                                                         |
| `code/src/django/conftest.py` · `code/src/django/tests/unit/test_story_map.py`                                                                 | Story map merges across sessions (F-001), 4 regression tests                                                                               |
| `code/docs/logging/DJANGO-LOGGING.md` · `OBSERVABILITY.md` · 09 `STEPS.md` · `EDGE-REQUIREMENTS.md` 13, 15                                     | Narrowed claims, path rule, selectors, process-server stream, log-collection contract                                                      |

---

## 2. Findings

Most severe first. `R-0NN` are this record's. The **Axis** column is the review's own two axes:
**Standards** (the repo's rules and the code-smell baseline) and **Spec** (does it do what the
story asked). Line numbers are those the passes read in the uncommitted build.

| ID    | Severity | Axis      | Source                   | File:line                                                                     | Issue                                                                                                                                                                                                                                                                  | Resolution/Status                                                                                                                                                                                                                                              |
| ----- | -------- | --------- | ------------------------ | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-001 | Medium   | Standards | review M1 · QA F1 (Low)  | `observability.py`:204 `_serialise`, :444 wide fallback, :494 `_json_value`   | `json.dumps` defaults to `allow_nan=True`. An allowlisted `duration_ms=float("nan")` writes a bare `NaN` / `Infinity`. That is not JSON, so LogQL `\| json` sets `__error__` and the documented query drops the line. This breaks the ADR's "one JSON object per line" | **Fixed — `e2dfde22`**, test first. `allow_nan=False` at all three sites, so a non-finite value goes to the fallback and is written as text (`"nan"`). The test helper `parse_line` now rejects `NaN`/`Infinity`, so every test checks for strict JSON (EC-24) |
| R-002 | Medium   | Spec      | review M2                | `code/src/django/apps/core/tests/unit/test_observability_requests.py`:165-213 | The returned-error criterion asks for 4xx and 5xx × minted and well-formed inbound id × `Client` and `AsyncClient`. Only a returned 400 with a minted id was tested                                                                                                    | **Fixed — `e2dfde22`**. A `/returned-500/` view and the full 400/500 × id-source × client matrix (EC-25). There was no code bug. The async inbound case first failed because of the test (`AsyncClient` needs `headers=`)                                      |
| R-003 | Low      | Standards | review L3                | `observability.py`:178-180, EC-18                                             | A `__context__` cycle's back-edge was written `null`. Under the contract, `null` means "no cause", but this context exists and was already visited                                                                                                                     | **Fixed — `e2dfde22`** (the back-edge is now omitted, with no `truncated` flag). **Ruled 24/11/2026 by Sam, option 1, omit** — plan Key Decision 20, findings F-003. `DJANGO-LOGGING.md` states it. No key changed, so no superseding ADR                      |
| R-004 | Low      | Standards | review L4 · QA F3        | `observability.py`:75-83                                                      | The last-resort line was a constant: a 1970 timestamp, `ERROR`, and a null `request_id`. A collector that reads the timestamp would reject it as too old, and the line that says "a record was lost" would itself be lost                                              | **Fixed — `e2dfde22`**, test first. `_last_resort(record)` is built live and guarded; the constant is kept only for the innermost `except` (EC-26)                                                                                                             |
| R-005 | Low      | Standards | review L5 · QA F2        | `observability.py`:194-200, :426                                              | The fallback called `_recorded_exception` outside any `try`. A malformed truthy `exc_info` (`True`, a bare instance) dropped the record to the last-resort line. This is unreachable through the `Logger` API                                                          | **Fixed — `e2dfde22`**, test first. Only a tuple of 2 or more items is accepted (EC-27)                                                                                                                                                                        |
| R-006 | Low      | Spec      | review L1                | `test_observability.py`, EC-12                                                | The criterion names a self-referencing dict extra, which was untested. The code already handled it                                                                                                                                                                     | **Fixed — `e2dfde22`**. Tests for both modes; the value comes out as `"{'self': {...}}"`                                                                                                                                                                       |
| R-007 | Low      | Spec      | review L2                | QA plan Section 2; the test modules                                           | The QA plan put every automated row bar EC-16 in one `test_observability.py`. It shipped as four modules plus a support module, to stay under 750 lines                                                                                                                | **Fixed — recorded** in the QA record Section 4 and the test record Section 3 (`86823ad6`). The planning lesson is findings F-005, fixed in both plan templates (`f190e2e7`)                                                                                   |
| R-008 | Low      | Standards | review L6 · QA F4 (Info) | `observability.py`:467-472                                                    | The formatter trusts `record.request_id`, so a project-added handler without the filter writes a caller's `extra={"request_id": ...}` as the join key. All shipped handlers carry the filter, and a test enforces this                                                 | **Fixed — `e2dfde22`**, as documentation. `DJANGO-LOGGING.md` says that a handler without the filter trusts `extra=`. Accepted design (assessment F-007)                                                                                                       |
| R-009 | Info     | Standards | QA F5                    | settings, `disable_existing_loggers: False`                                   | Django's `django.server` logger keeps its plain-text handler in every environment. Only `runserver` writes to it, and neither dev (uvicorn) nor staging/prod (gunicorn) runs it                                                                                        | **Fixed — `e2dfde22`**, the claim narrowed: "every handler in every environment's `LOGGING`", with `django.server` named (assessment F-008)                                                                                                                    |
| R-010 | Info     | Standards | QA F6                    | `SecurityMiddleware` → `get_host()`                                           | A `DisallowedHost` raised before `RequestIDMiddleware` is logged with a null id                                                                                                                                                                                        | No action — null by design, pinned by `test_a_request_extra_with_no_stored_id_is_null[django.security.DisallowedHost]`                                                                                                                                         |
| R-011 | Info     | Standards | QA F7                    | `observability.py`:522-525                                                    | The filter does not re-check `request.request_id`. Only the middleware sets it, from the validated or minted value                                                                                                                                                     | No action — no attacker-controlled input reaches it                                                                                                                                                                                                            |
| R-012 | Nit      | Standards | review nit               | `observability.py`:56-58                                                      | The `_MAX_LINKS` comment said "at least 40 bytes", but the code divides by 32                                                                                                                                                                                          | **Fixed — `e2dfde22`** (comment corrected)                                                                                                                                                                                                                     |
| R-013 | Nit      | Standards | review nit               | `observability_support.py`:58, `test_observability_requests.py`               | `# noqa: BLE001` names a rule family that ruff does not select, so the comment is dead                                                                                                                                                                                 | **Fixed — `e2dfde22`** (removed from the US014 files; the two in `apps/health/checks.py` are out of scope)                                                                                                                                                     |
| R-014 | Nit      | Spec      | review nit               | `observability.py` · `JSONFormatter._format`, wide branch                     | Wide (dev) mode drops `stack_info`, so `logger.warning(..., stack_info=True)` loses the stack the developer asked for. The contract says nothing about dev                                                                                                             | **Won't-fix — ruled 24/11/2026 by Sam, option 1, no change**: plan Key Decision 21, findings F-004. It is out of US014's scope and breaches nothing                                                                                                            |
| R-015 | Nit      | Standards | review nit               | `code/src/django/apps/core/CONTEXT.md`:68                                     | One unwrapped prose line, 177 characters at HEAD. Prose wrap is "preserve", so no gate fails                                                                                                                                                                           | Won't-fix — cosmetic, no gate; not applied by the fix pass                                                                                                                                                                                                     |

**Rejected:** none. The fix pass verified every finding against the code and rejected none for
contradicting the ADR.

**No Critical or High** on either pass, so nothing is escalated to
`../10-SECURITY/VULNERABILITIES/IMPLEMENTATION/`. The two Medium items were defects in the
build. They were fixed before it was committed, so neither shipped.

---

## 3. Dimension checklists

### 3.0 The two axes

- **Standards — Pass with minor changes**, at review. After the fix pass, R-015 is the only open
  item, and it is cosmetic. Standard library only; `pyproject.toml` and `uv.lock` unchanged; every
  file under 750 lines; type hints throughout; one `DICT-OK:` marker at the serialisation
  boundary (Key Decision 11).
- **Spec — gaps found**, at review (R-002, R-006, R-007). All three are closed. The review traced
  every Backend criterion to code (the filter overwrites unconditionally and maps `""` to `None`;
  the `django.request` fallback reads the stored id and never `META`; `ext://sys.stdout`; the
  `django` logger; the entrypoints; the middleware position "second"). It traced every GDPR,
  Security and Logging criterion to the documentation. The breaker pass passed all fourteen
  security constraints, with caveats on 5 and 6 (R-004, R-005, R-008, R-009), and all are now
  addressed.

### 3.1 Security (OWASP)

- [x] **A01 — permission check before logic.** N/A in substance: no endpoint, view or role
      boundary (QA plan Section 2). The `/returned-*` fixture views are test-only and mounted
      nowhere.
- [x] **IDOR.** N/A — no user-supplied ID reaches a lookup. A hostile `X-Request-ID` is
      `fullmatch`ed against `[A-Za-z0-9._-]{1,200}`. Only the validated or minted id is stored, and
      the filter never reads `META` (EC-05, EC-16).
- [x] **Secrets & DEBUG.** No secret, key or `.env` read. The A09:2025 surface is covered by the
      assessment's fourteen constraints, all closed with evidence.

### 3.2 GDPR / PII

- [x] **Encrypted at rest.** N/A — no PII field is added to any model.
- [x] **Erase & export coverage.** N/A for the store. The Art. 11 position is carried unchanged
      and flagged for legal sign-off (GDPR record Section 3).
- [x] **No PII in logs** — within the decided scope. Off dev, the allowlist runs before coercion and
      `exc_info` is type and frames only (HP-04, HP-05). **`message` is unscrubbed by decision**, and
      the docs say so (EC-11). The controller's LIA, retention and Art. 11 sign-off stay open by
      design.

### 3.3 Test coverage vs floors

- [x] Backend coverage meets the floor — `tests/all.sh --coverage`, 24/11/2026: total 94.50%;
      `observability.py` 93.4% line / 87.8% branch; `middleware.py` 100%.
- [x] Template and HTMX-partial tests — N/A, no template.
- [x] Full suite green — the fix pass ran `all.sh --coverage` (unit 227, integration 22, exit 0).
      The recorded run read by `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` was unit 231,
      integration 22, exit 0. CI `pytest + coverage` and `[7/8] Tests` passed on PR #44.
- [x] Every acceptance criterion has a test, or is a static or gate row. HP-01 to HP-12 (with
      HP-07b, HP-11b), EC-01 to EC-23 (with EC-21b) and EC-24 to EC-28 have tests, and both passes
      saw them green. ES-10's runtime half is **unmeasured** by design.

### 3.4 Quality, DRY & file length

- [x] No duplication found by either pass.
- [x] No new `TODO` / `FIXME` / `HACK` (story Definition of Done, ticked 24/11/2026).
- [x] Every source file ≤ 750 lines — `observability.py` 560; test modules 198 to 569.
- [x] Lint clean — `syntax/check.sh` and `syntax/lint.sh` exit 0 in the fix pass; CI green.

### 3.5 Performance

- [x] No query path — the module opens no database connection.
- [x] The cap's binary search costs about 2-3× the message size per oversized record, so it is not
      a DoS (breaker pass). Wide mode is never capped (dev only).

### 3.6 Accessibility (WCAG 2.2 AA)

- [x] N/A — no user-facing UI in this story.

### 3.7 Step 6 verification (records from `22`)

| Record                                                                                                     | Verdict                                                                                                                                                                                                                                                       |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../09-GDPR/IMPLEMENTATION/GDPR-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`                          | Complete — every plan task closed or **Open by design** (the controller's); countersigned. Section 6 still reads "awaiting ruling" on L3; the ruling stands in the findings and the plan                                                                      |
| `../10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` | Complete — 15 Mitigated, 5 Residual, each tracked; countersigned, and the dated note records the L3 ruling                                                                                                                                                    |
| `../10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md`    | Complete — fourteen of fourteen constraints closed with evidence; countersigned with the L3 ruling noted. Its F-009 (`stack_info`) still reads Open; ruled by Key Decision 21                                                                                 |
| `../10-SECURITY/AUDITS/IMPLEMENTATION/AUDIT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md`              | Complete — Pass with notes; countersigned. A-01 still reads Open, but findings F-006 says the two cites are fixed and only the `.py` gate-scope question is carried                                                                                           |
| `../11-QA/IMPLEMENTATION/QA-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`                              | Complete — Pass with deviations; the L3 ruling recorded; the reviewer box ticked at this step (Section 6)                                                                                                                                                     |
| `../14-LOGGING/IMPLEMENTATION/LOGGING-IMPL-US014-STRUCTURED-JSON-REQUEST-ID.md`                            | Complete — Verified, exclusion check pasted. The F-003 and F-004 follow-up rows still read "ruling before merge" and "call"; both were ruled 24/11/2026                                                                                                       |
| `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md`                                                               | Complete — the generated block matches a regeneration against the last suite run (`results-unit.xml` 24/11/2026 09:12:21 UTC; no Python changed after it), identical once formatted; `story-markers.sh` exit 0, "93 carry; 72 do not", no US014 test unmarked |
| `../18-TESTS/MANUAL/US014-MANUAL-TESTING.md`                                                               | Complete — 42 rows: 41 Pass, CLOSE-04 a retired stub. Slots A to F filled (E "None — no upstream merge"); CLOSE-03's amendment carries its trail and F-012; _Failures_ both resolved and re-walked                                                            |
| `../20-FINDINGS/archive/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`                               | Complete — Resolved, F-001 to F-012 each dispositioned; F-006's question carried to the next `17-story-plans` plan                                                                                                                                            |

The stale "awaiting ruling" phrases are text that was not updated after the rulings. They are not
missing evidence: both rulings stand in the plan (Key Decisions 20, 21) and the findings record
(F-003, F-004). They are reported here and not fixed, because `23` only verifies `22`'s records.

---

## 4. Required actions before merge

None — approved as-is. Every Medium and Low is `Fixed` or ruled. R-015 is cosmetic and needs no
re-review. The PR has already merged; there is nothing to block.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-nits.
- **Reasoning:** Every acceptance criterion traces to the merged tree. The two build defects
  (R-001, R-002) were fixed test-first before the build was committed, and both contract questions
  were ruled by Sam. CI was green on PR #44 (53 passed, 1 skipped), and Sam countersigned all US014
  work on 24/11/2026 (`../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` → _Countersignature —
  24/11/2026_). What remains is one cosmetic Nit.
- **Status transition:** none from this step. US014 stays `In Review`. `In Review` → `Accepted`
  is recorded by `completion` through `23-pr-and-review` Step 5.

---

## 6. Notes

- **Not run here:** the suites, the gates and the code-review-graph review playbook. This record
  relies on the passes' own runs, the test record's run of 24/11/2026 and CI on PR #44. The
  graph was confirmed current at `94db8f02` (built on `dev`, head matches build).
- **The QA record's reviewer box** was ticked at this step on Sam's countersignature. By its own
  terms it covers the workflow-22 records at `86823ad6`, and the QA record is one of them. Sam then
  merged PR #44. This is the same developer approval of the QA record that US013's box rested on
  (`6bece79f`).
- **The passes' sequence:** the review and breaker passes ran in parallel, and neither ran the
  other's checks. The review did not run the suites (it avoided colliding with the builder on the
  shared test stack), and the breaker did not run the doc gates. The fix pass then ran both sets,
  every one exit 0.

---

## Cross-references

- `../02-STORIES/US014.md` — the story under review
- `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the plan; Key Decisions 20 and 21 are the two rulings
- `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` · `../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` — the
  test records this review reads against
- `../11-QA/IMPLEMENTATION/QA-IMPL-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — the paired QA review from the same PR
- `../20-FINDINGS/archive/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` — F-001 to F-012
- `../15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` — the line contract
- `../21-BUGS/` — the three records US014 fixed, flipped to `Fixed` at this step
- `code/docs/SECURITY.md` — the OWASP / IDOR obligations Section 3.1 checks against
- `project-management/workflows/23-pr-and-review/` · `code/workflows/07-review/`
