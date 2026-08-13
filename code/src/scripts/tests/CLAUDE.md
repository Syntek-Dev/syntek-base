@./CONTEXT.md

# CLAUDE.md — scripts/tests/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script table, two-phase execution, thresholds, CI map — imported above) → this
file → `reports/`.

## Purpose (one line)

The test-suite entry point — `backend.sh`, `backend-coverage.sh`, `api.sh`, `e2e-py.sh`,
`mutmut.sh`, `open-coverage.sh`, `server.sh`, and the `all.sh` orchestrator.

## How to work here

- **Routing:** all test runs route through these scripts (the `test-writer` skill
  targets them). **Never run `pytest` or `playwright` directly.** Backend scripts use
  `compose exec` (test stack must be up); `api.sh` uses `run --rm` (one-shot);
  `e2e-py.sh` runs on the host against the **dev** stack.
- **Model:** Opus to author or change a runner (markers, phases, flags, thresholds)
  and to run a suite.
- **Concrete steps:** start the test stack (`server.sh up`) → `backend-coverage.sh`
  locally, or `all.sh --coverage` → narrow with `-m unit` or a path arg → reports
  land under `reports/<suite>/`; `open-coverage.sh` opens the HTML. For the browser
  suite, bring the **dev** stack up first, then `e2e-py.sh`.
- **Definition of done:** target suite exits `0` with the coverage floor met (backend
  75% line+branch / auth 90%); the two-phase backend run passes unit then integration.

## Guardrails

- **Coverage floors are enforced, not advisory** — `--cov-fail-under=75` (backend);
  auth code (`apps/users`) holds a 90% manual floor. Never lower a floor to make a
  run pass.
- **Exit-code contract:** `0` pass, `1` failures/coverage below floor, `2` script
  error — CI's three test workflows depend on it; never mask a failure.
- **Mutation testing (`mutmut.sh`) is local-only** — deliberately out of CI; do not
  wire it into a gate.
- **The browser suite is the exception, not the default.** `e2e-py.sh` is only for what
  needs layout, CSS resolution, or JavaScript. Everything else goes through the Django
  test client in `apps/<app>/tests/` — faster, in CI on every push, and counted towards
  the coverage floor. See `code/src/django/tests/e2e/CLAUDE.md`.
- **`e2e-py.sh` needs a running stack and says so.** It exits `2` with instructions
  rather than failing obscurely; keep that pre-flight check when editing it.
- `--output DIR` must stay within the project root (it is bind-mounted into the
  container).

## Output & naming

- **Hand-written:** the `*.sh` runners here, this file, `CONTEXT.md`.
- **Generated (gitignored):** everything under `reports/<suite>/` — JUnit XML,
  coverage HTML/XML, and the per-page axe JSON in `reports/a11y/`.
- Script files `kebab-case.sh`; documentation `SCREAMING-SNAKE-CASE.md`.
