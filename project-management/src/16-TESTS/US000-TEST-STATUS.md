# US000 — Test Status

_Template — copy to `US###-TEST-STATUS.md`, replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. The automated-test record for a single user story (US###): which suites ran, how many passed, and the coverage they achieved against the floors._

**Last Updated**: {DD/MM/YYYY} · **Story**: US### · **Status**: {status: Green / Red / Partial}

- **Story:** `../01-STORIES/US###.md` — {short title}
- **Story plan:** `../15-STORY-PLANS/STORY-PLAN-US###-{DESCRIPTOR}.md` — the code master this record closes the loop on
- **Branch:** `us###/{short-description}`

---

## 1. Suite summary

One row per suite the story touches. `Count` is the number of tests; `Result` is pass/fail;
`Coverage` is the percentage the suite reports for the modules in scope (`—` where a suite
produces no coverage figure). Delete rows for suites this story does not exercise, and state
why below (e.g. "E2E — none this story: no user-facing journey added").

| Suite                        | Test file(s)                                            | Count   | Result            | Coverage  |
| ---------------------------- | ------------------------------------------------------- | ------- | ----------------- | --------- |
| _[EXAMPLE] Unit_             | _`apps/{app}/tests/test_login.py`_                      | _24_    | _24 ✅ / 0 ❌_    | _{NN}%_   |
| _[EXAMPLE] Integration_      | _`apps/{app}/tests/integration/test_signup_flow.py`_    | _11_    | _11 ✅ / 0 ❌_    | _{NN}%_   |
| _[EXAMPLE] Templates/HTMX_   | _`apps/{app}/tests/test_views.py` (Django test client)_ | _9_     | _9 ✅ / 0 ❌_     | _{NN}%_   |
| _[EXAMPLE] API / contract_   | _`code/src/tests/api/{collection}.bru` (Bruno)_         | _8_     | _8 ✅ / 0 ❌_     | _—_       |
| _[EXAMPLE] E2E (Playwright)_ | _`code/src/django/tests/e2e/test_e2e_journey.py`_       | _5_     | _5 ✅ / 0 ❌_     | _—_       |
| _[EXAMPLE] Accessibility_    | _`code/src/django/tests/e2e/test_e2e_a11y.py` (axe)_    | _3_     | _3 ✅ / 0 ❌_     | _0 viol._ |
| **Totals**                   |                                                         | **{N}** | **{N} ✅ / 0 ❌** | **{NN}%** |

{Where a suite is out of scope for this story, state it explicitly, e.g. "Integration — none:
no database or API surface added. E2E — deferred to US### (harness dependency)."}

---

## 2. Coverage vs floors

Floors are enforced by the test scripts; the pre-PR gate raises the bar on protected branches.

| Scope                       | Floor | This story | Met? |
| --------------------------- | ----- | ---------- | ---- |
| All modules — line + branch | 75%   | _{NN}%_    | _✅_ |
| Auth-critical modules       | 90%   | _{NN}%_    | _✅_ |

- **One floor, not one per layer** — template, django-component, and HTMX-partial tests are
  pytest tests, so they count towards the same number as the rest of the backend.
- **Pre-PR gate:** on `staging`/`main` the merge gate raises every floor to **80%** — a story
  green locally can still block the PR if a module in scope sits between its floor and 80%.
- **Auth-critical** = any module in the authentication / session / permission path (higher 90%
  floor); name the modules in scope here and confirm each clears it.
- {Per-module breakdown, if the story warrants one — statements / missed / branch / cover.}

---

## 3. How to reproduce

Run the suites through the project scripts only — never invoke `pytest`, `manage.py`, or
`playwright` directly.

```bash
# All suites with coverage (the canonical local run)
bash code/src/scripts/tests/all.sh --coverage

# Or per suite:
bash code/src/scripts/tests/backend-coverage.sh    # Django + coverage vs the 75% / 90% floors
bash code/src/scripts/tests/api.sh                 # Bruno API integration tests (/api/*)
bash code/src/scripts/tests/e2e-py.sh              # pytest-playwright browser suite (dev stack up)
```

{Note any story-specific flags, seed data, or the management command that must run first — e.g.
the test-user seeding command — using its `code/src/scripts/**/*.sh` entry point.}

---

## 4. Outstanding gaps & flaky tests

Anything not green, deferred, or unstable — with a reason and, where relevant, the owning story.
State "None." if the suite is clean.

| Item                            | Type                    | Reason / owner                                 |
| ------------------------------- | ----------------------- | ---------------------------------------------- |
| _[EXAMPLE] {scenario}_          | _Deferred_              | _Depends on {feature} — tracked in US###_      |
| _[EXAMPLE] `test_example_case`_ | _Flaky_                 | _Timing-dependent; quarantined, see `GAPS.md`_ |
| _[EXAMPLE] {module} branch_     | _Coverage below target_ | _{NN}% vs 80% gate — {plan to close}_          |

---

## 5. Status line

**{Green / Red / Partial}** — {N} tests, {NN}% coverage, all floors met · verified {DD/MM/YYYY}.

---

## Cross-references

- `../01-STORIES/US###.md` — the story under test
- `../15-STORY-PLANS/STORY-PLAN-US###-{DESCRIPTOR}.md` — the implementation plan this record closes
- `US###-MANUAL-TESTING.md` — the paired manual-testing guide for this story
- `../10-QA/IMPLEMENTATION/QA-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md` — the QA review that signs the story off
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
