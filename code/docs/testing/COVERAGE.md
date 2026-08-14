---
type: guide
skills: [test-writer, stack-django, stack-htmx-templates]
model: opus
---

# Testing — Coverage Thresholds, Output & Readability

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Coverage floors, pytest-cov config, readable test output

---

## Coverage Thresholds

Every module must meet the following minimum coverage thresholds. CI enforces these — a PR that
drops any metric below the floor is blocked.

| Metric            | Minimum | Notes                                       |
| ----------------- | ------- | ------------------------------------------- |
| Line coverage     | 75%     | Hard floor — no exceptions                  |
| Branch coverage   | 75%     | Both sides of every `if`/`else` exercised   |
| Auth-related code | 90%     | `apps/users/` and any auth-adjacent service |

There is **one standard, enforced once per runtime** — not one floor per layer. Template,
component, and HTMX-partial tests are pytest tests and count towards the same number as the rest
of the backend (see [`FRONTEND-TESTING.md`](FRONTEND-TESTING.md)); there is no separate frontend
floor.

"Per runtime" is the precise phrasing, and it matters only where a second runtime exists. A
project with the optional **mobile surface** runs Jest, and `coverage.py` and Jest **share no
accumulator** — a single combined percentage across both was never achievable, so the same
numbers are enforced twice, independently:

| Runtime              | Enforced by                     | Configuration                    |
| -------------------- | ------------------------------- | -------------------------------- |
| Python (always)      | `coverage.py` via pytest-cov    | `fail_under` (below)             |
| Mobile (mobile-only) | Jest `coverageThreshold.global` | `code/src/mobile/jest.config.js` |

**Two gates to keep in step.** If a floor moves, it moves in both places or the standard has
silently forked.

> **The 90% auth entry is not inert on the mobile side.** Jest fails a run whose
> `coverageThreshold` glob matches nothing, so the per-glob auth entry ships as a **commented
> template** in `jest.config.js`, to be enabled with the first auth-adjacent mobile code. Adding
> it early breaks every run.

The floors are **minimums**, not targets. Auth-related code must maintain ≥ 90% line and branch
coverage.

### Python — pytest-cov configuration

```toml
# pyproject.toml (repository root)
[tool.coverage.run]
source = ["apps"]
branch = true

[tool.coverage.report]
fail_under = 75
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
    "\\.\\.\\.",
]
omit = ["*/migrations/*", "*/tests/*", "*/__init__.py"]
```

```bash
bash code/src/scripts/tests/backend-coverage.sh
```

### Coverage report locations

| Format        | Location                                                       |
| ------------- | -------------------------------------------------------------- |
| HTML          | `code/src/scripts/tests/reports/backend-coverage/html/`        |
| Cobertura XML | `code/src/scripts/tests/reports/backend-coverage/coverage.xml` |

Open the HTML report with `bash code/src/scripts/tests/open-coverage.sh`.

---

## Test Output & Readability

### Python — pytest output

```toml
[tool.pytest.ini_options]
addopts = "--tb=short --strict-markers -q"
```

| Flag               | Effect                                                          |
| ------------------ | --------------------------------------------------------------- |
| `--tb=short`       | Short tracebacks — the failure line plus immediate context only |
| `--strict-markers` | Unregistered markers are errors, not silent no-ops              |
| `-q`               | Quiet — one summary line per test; full details only on failure |
| `-n auto`          | Parallel execution via pytest-xdist                             |

### Writing readable assertions

```python
# Weak — tells you nothing on failure
assert result == expected

# Strong — tells you exactly what diverged
assert result == expected, f"Got {result!r}, expected {expected!r}"
```

---

## Rules and Principles

1. Every new public function has at least one unit test.
2. Every Django Ninja endpoint has an integration test: happy path, auth failure, invalid input.
3. Tests are deterministic — no real time, random values, or live network calls in unit tests.
4. Tests are independent — each sets up its own state.
5. Follow Arrange–Act–Assert in every test.
6. Test behaviour, not implementation details.
7. Unit tests complete in under 100 ms each.
8. Security-critical paths must have negative tests.
9. Test code is held to the same standard as production code.
10. No N+1 queries — assert query count in any test that fetches a list of objects.
11. Every module that writes audit logs must have a test confirming the correct log entry.
12. Partial failure paths must have tests — verify DB state after a mid-mutation exception.
13. **Every file must contribute to meeting the coverage floor.**
14. **Red phase = stubs, green phase = real code.**
15. **Never mock module-level constants to make tests pass.**
16. **Test real outcomes, not mock call counts.**
17. **Code must compile before tests are run.**
18. **Every new Django Ninja endpoint must have a Bruno `.bru` file.**
19. **Test output must be human-readable.**
20. **Tests must scale.** Any suite taking longer than 3 minutes must be parallelised.
21. **TDD is the starting discipline; tests evolve with the implementation.**
22. **Tests must model real-world scenarios.** Use realistic data.
23. **Write initial tests at the contract level, not the implementation level.**
24. **Structure initial tests for growth.** Use factories, `@pytest.mark.parametrize`, and correct tier markers.

---

## Test Discipline — Seams, Tautology, Public Interface

These rules decide _what_ to test and _how_ to assert; they sit above the numbered list and the
coverage floors (which govern only _how much_).

- **Test only at pre-agreed seams.** Before writing any test, write down the seams you intend to
  cover — the service boundary, Ninja endpoint, or rendered-fragment contract on a critical path — and confirm
  that list with <%DEVELOPER_NAME%>. Effort then lands on the seams that carry risk, not on every reachable edge
  case. Settle the seams in the design pass (grill first — see `.claude/CLAUDE.md` Section 10) so the Red
  phase starts from an agreed target.
- **No tautological tests.** The expected value must come from an independent source of truth — a
  known literal, a worked example, or the spec — never recomputed the way the code under test
  computes it. A test that mirrors the implementation's own arithmetic passes even for a wrong
  implementation and proves nothing.
- **Assert through the public interface.** Drive behaviour via the contract callers use — return
  value, DB state, API response, rendered output — never a private method or internal field. Tests
  written this way survive any refactor that preserves behaviour (extends rule 6).

_Part of the `code/docs/` documentation family. See [`../TESTING.md`](../TESTING.md) for the full index._
