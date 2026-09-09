# US000 — Test Status

_Template — copy to `US###-TEST-STATUS.md`, replace every `{PLACEHOLDER}` outside the generated block, then run the generator. The automated-test record for a single user story (US###): what each test checks, whether it passed, and the coverage the suites achieved against the floors._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {status: Green / Red / Partial}

- **Story:** `../02-STORIES/US###.md` — {short title}
- **Story plan:** `../17-STORY-PLANS/{XX}-STORY-PLAN-US###-{DESCRIPTOR}.md` — the code master this record closes the loop on
- **Branch:** `us###/{short-description}`

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

| Suite                     | Report artefact                                      | Tests   | Result                | Coverage  |
| ------------------------- | ---------------------------------------------------- | ------- | --------------------- | --------- |
| _[EXAMPLE] Unit_          | _`reports/backend-coverage/results-unit.xml`_        | _24_    | _24 Pass / 0 Fail_    | _{NN}%_   |
| _[EXAMPLE] Integration_   | _`reports/backend-coverage/results-integration.xml`_ | _11_    | _11 Pass / 0 Fail_    | _{NN}%_   |
| _[EXAMPLE] API (Bruno)_   | _`reports/api/results.json`_                         | _8_     | _8 Pass / 0 Fail_     | _—_       |
| _[EXAMPLE] E2E_           | _`reports/e2e/results.xml`_                          | _5_     | _5 Pass / 0 Fail_     | _—_       |
| _[EXAMPLE] Accessibility_ | _`reports/a11y/*.json`_                              | _3_     | _3 Pass / 0 Fail_     | _0 viol._ |
| **Totals**                |                                                      | **{N}** | **{N} Pass / 0 Fail** | **{NN}%** |

_A suite this story does not exercise is absent from the table and named in Section 3 with its
reason — a missing row is not the same claim as a zero._

### 1.2 Coverage vs floors

| Scope                       | Floor | This story | Met?  |
| --------------------------- | ----- | ---------- | ----- |
| All modules — line + branch | 75%   | _{NN}%_    | _Yes_ |
| Auth-critical modules       | 90%   | _{NN}%_    | _Yes_ |

| Module                                      | Statements | Missed | Branch | Cover |
| ------------------------------------------- | ---------- | ------ | ------ | ----- |
| _[EXAMPLE] `apps/{app}/services/{name}.py`_ | _84_       | _3_    | _92%_  | _96%_ |

### 1.3 Tests by module

One row per test case. A parametrised test contributes **one row per case**, so a failure names
the exact input that broke. _What it checks_ is derived from the test's own name; _Why_ is its
docstring, where it has one.

#### _[EXAMPLE]_ `apps.core.tests.unit.test_errors`

##### `TestServiceErrorTree`

| What it checks                                            | Why  | Test                                                                            | Result | Notes |
| --------------------------------------------------------- | ---- | ------------------------------------------------------------------------------- | ------ | ----- |
| _Each carries its stable code — `ServiceError`_           | _{}_ | _`test_each_carries_its_stable_code[ServiceError-unknown_error]`_               | _Pass_ | _{}_  |
| _Each carries its stable code — `ServicePermissionError`_ | _{}_ | _`test_each_carries_its_stable_code[ServicePermissionError-permission_denied]`_ | _Pass_ | _{}_  |
| _Every subclass is caught by the root_                    | _{}_ | _`test_every_subclass_is_caught_by_the_root`_                                   | _Pass_ | _{}_  |

##### `TestLivenessEndpoint`

| What it checks           | Why                                                                         | Test                            | Result | Notes |
| ------------------------ | --------------------------------------------------------------------------- | ------------------------------- | ------ | ----- |
| _Is never cached_        | _An intermediary caching liveness would keep a dead process looking alive._ | _`test_is_never_cached`_        | _Pass_ | _{}_  |
| _Rejects a write method_ | _{}_                                                                        | _`test_rejects_a_write_method`_ | _Pass_ | _{}_  |

<!-- END GENERATED -->

---

## 2. How to reproduce

Run the suites through the project scripts only — never invoke `pytest`, `manage.py`, `bru`, or
`playwright` directly.

```bash
# All suites with coverage (the canonical local run)
bash code/src/scripts/tests/all.sh --all --coverage

# Or per suite:
bash code/src/scripts/tests/backend-coverage.sh    # Django + coverage vs the 75% / 90% floors
bash code/src/scripts/tests/api.sh                 # Bruno API integration tests (/api/*)
bash code/src/scripts/tests/e2e-py.sh              # pytest-playwright browser suite (dev stack up)

# Then rewrite this file's generated block:
bash code/src/scripts/tests/test-record.sh US###
```

{Note any story-specific flags, seed data, or the management command that must run first — always
via its `code/src/scripts/**/*.sh` entry point.}

---

## 3. Outstanding gaps and flaky tests

Anything not green, deferred, unstable, or **out of scope** — with a reason and, where relevant,
the owning story. State `None.` if the suite is clean and every suite ran.

| Item                            | Type                    | Reason / owner                                   |
| ------------------------------- | ----------------------- | ------------------------------------------------ |
| _[EXAMPLE] E2E_                 | _Out of scope_          | _No user-facing journey added by this story_     |
| _[EXAMPLE] {scenario}_          | _Deferred_              | _Depends on {feature} — tracked in US###_        |
| _[EXAMPLE] `test_example_case`_ | _Flaky_                 | _Timing-dependent; quarantined, see `GAPS.md`_   |
| _[EXAMPLE] {module} branch_     | _Coverage below target_ | _{NN}% vs the 80% pre-PR gate — {plan to close}_ |

**Unmarked tests are invisible here.** The generator selects on the story marker, so a test
written for this story without `@pytest.mark.story("US###")` — or a `.bru` request without its
`tags: [US###]` — is silently absent rather than failing. `bash code/src/scripts/audits/story-markers.sh`
lists what carries no marker; check it before trusting a short table.

---

## 4. Status line

**{Green / Red / Partial}** — {N} tests, {NN}% coverage, all floors met · verified {DD/MM/YYYY}.

---

## Cross-references

- `../02-STORIES/US###.md` — the story under test
- `../17-STORY-PLANS/{XX}-STORY-PLAN-US###-{DESCRIPTOR}.md` — the implementation plan this record closes
- `US###-MANUAL-TESTING.md` — the paired manual walk-through; a manual `Fail` beside a green suite is a missing test
- `../11-QA/IMPLEMENTATION/QA-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — whether the specified scenarios were met
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator

<!-- UPDATED 09/09/2026. Gained a per-test table and a generated block; it was a suite-level
     rollup only, which answered "did the suites run and what was the coverage" and never "what
     does each test check". Section 1.3 now carries one row per test case, parametrised cases
     included, so a failure names the input that broke it. Everything sourced from a report
     artefact moved inside the BEGIN/END GENERATED markers and is written by
     "code/src/scripts/tests/test-record.sh" — the coverage figures included, which this file
     previously asked a human to transcribe by hand and which therefore went stale between runs.
     Sections 2 to 4 stay hand-written because a reason, a deferral and a judgement are not in the
     XML. The Notes column carries the failure reason on a failing row only. Settled by the
     grilling pass of 09/09/2026; the story-marker mechanism it filters on is argued in this
     folder's CLAUDE.md. -->
