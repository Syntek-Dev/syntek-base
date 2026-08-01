# code/src/scripts/tests

**Last Updated**: {{DATE}} (browser e2e moved to playwright-python; runner set trimmed to the
Django baseline)

Shell scripts for running the automated test suites. The backend and API runners invoke Docker
containers; `e2e-py.sh` runs on the host against an already-running stack. Never run `pytest`
directly.

## Two-phase backend execution

`backend.sh` and `backend-coverage.sh` run pytest in two sequential phases:

| Phase | Marker           | DB connections   | Purpose                                                                 |
| ----- | ---------------- | ---------------- | ----------------------------------------------------------------------- |
| 1     | `-m unit`        | None             | Fast service/model logic; fails fast before touching the DB             |
| 2     | `-m integration` | Yes (sequential) | Django Ninja endpoint and DB tests; starts with a clean connection pool |

Markers are auto-assigned in `conftest.py` based on file path:

- `*/tests/unit/*` → `@pytest.mark.unit`
- everything else (including `*/tests/integration/*` and flat `tests/`) → `@pytest.mark.integration`

Explicitly decorating individual tests with `@pytest.mark.unit` or `@pytest.mark.integration`
overrides the auto-assignment.

## Directory tree

```text
code/src/scripts/tests/
├── all.sh                    ← orchestrator: backend + optional suites (--api --all)
├── api.sh                    ← Bruno API integration tests (requires live backend)
├── backend.sh                ← pytest plain run; writes JUnit XML
├── backend-coverage.sh       ← pytest + coverage; writes HTML, Cobertura XML, JUnit XML
├── CLAUDE.md                 ← operating rules
├── CONTEXT.md                ← this file
├── e2e-py.sh                 ← playwright-python browser suite (host; needs a running stack)
├── mutmut.sh                 ← Python mutation testing (local-only; dev stack required)
├── open-coverage.sh          ← opens the backend coverage HTML in a browser
├── server.sh                 ← start or manage the test stack containers
└── reports/                  ← generated reports (all gitignored; sub-dirs below)
    ├── a11y/                 ← axe results from e2e-py.sh (created on demand)
    ├── api/                  ← output from api.sh (created on demand)
    ├── backend/              ← output from backend.sh
    └── backend-coverage/     ← output from backend-coverage.sh
```

## Scripts

| Script                | Tool                | Pattern | Stack required     | Default output dir                                                          |
| --------------------- | ------------------- | ------- | ------------------ | --------------------------------------------------------------------------- |
| `all.sh`              | orchestrator        | both    | Depends on flags   | (delegates to sub-scripts)                                                  |
| `api.sh`              | Bruno CLI           | host    | Test stack up      | `reports/api/`                                                              |
| `backend.sh`          | pytest              | exec    | Full test stack up | `reports/backend/` (2 XML files: results-unit.xml, results-integration.xml) |
| `backend-coverage.sh` | pytest + cov        | exec    | Full test stack up | `reports/backend-coverage/` (HTML, coverage.xml, 2 JUnit XML files)         |
| `e2e-py.sh`           | pytest + playwright | host    | Dev stack up (:81) | `reports/a11y/`                                                             |
| `mutmut.sh`           | mutmut              | exec    | Dev stack up       | N/A (console output)                                                        |
| `open-coverage.sh`    | xdg-open / open     | host    | None               | N/A                                                                         |
| `server.sh`           | docker compose      | host    | N/A                | N/A                                                                         |

`backend.sh`, `backend-coverage.sh`, and `api.sh` fall back to `.env.test.example` when
`.env.test` is absent — every value in it has a working default in
`docker-compose.test.yml`, so a fresh clone runs the suite without copying anything.

`api.sh` exits `0` without starting the stack when the Bruno collection holds no
requests, and skips fixture-user seeding when `seed_api_test_user` is not a registered
management command.

**Exception — `e2e-py.sh` runs on the host.** Playwright drives a real Chromium against an
already-running stack over HTTP, so it needs neither the test container nor the ORM. Browser
engines in Docker require significant dependency setup for no benefit here. Everything else runs
inside a container.

**One browser driver, in Python.** There is no Node test path: HTMX, Alpine, axe, and real-layout
overflow are browser-bound, and Django's test client executes no JavaScript. Anything that does
_not_ need a browser belongs in `apps/<app>/tests/` through that client — faster, in CI on every
push, and counted towards the coverage floor. See `code/src/django/tests/e2e/CONTEXT.md`.

## --output flag

Every script accepts `--output DIR` to write reports to a custom directory (must be within the project root). The directory is created automatically.

```bash
./code/src/scripts/tests/backend.sh --output /abs/path/to/project/my-reports/backend
```

The directory is bind-mounted from the host into the test container — any path under the project root is accessible in both directions.

## open-coverage.sh

Opens the backend coverage HTML report in the default browser (`xdg-open` on Linux, `open` on macOS).

```bash
./code/src/scripts/tests/open-coverage.sh
./code/src/scripts/tests/open-coverage.sh --backend
```

The report must already exist — run `backend-coverage.sh` first. The script exits `1` if no HTML file is found and prints instructions.

## Starting the test stack

```bash
# Start the full test stack (db + cache + django + django-test + nginx)
./code/src/scripts/tests/server.sh up

# Rebuild after changing source (the test image bakes code in — no volume mount)
./code/src/scripts/tests/server.sh up --build
```

`e2e-py.sh` is the exception: it targets the **dev** stack behind nginx on host port 81, because
it drives a browser against a live site rather than a one-shot container.

```bash
bash code/src/scripts/development/server.sh up
bash code/src/scripts/tests/e2e-py.sh
```

## Usage examples

```bash
# Backend — all tests
./code/src/scripts/tests/backend.sh

# Backend — specific marker
./code/src/scripts/tests/backend.sh -m unit

# Backend — specific app
./code/src/scripts/tests/backend.sh code/src/django/apps/<app>/

# Backend — coverage report
./code/src/scripts/tests/backend-coverage.sh

# Backend — coverage to custom dir
./code/src/scripts/tests/backend-coverage.sh --output /abs/path/to/project/ci-reports/backend-coverage

# Core suite — plain
./code/src/scripts/tests/all.sh

# Core suite — with coverage
./code/src/scripts/tests/all.sh --coverage

# Core + API integration tests
./code/src/scripts/tests/all.sh --api

# API tests only
./code/src/scripts/tests/api.sh

# Browser e2e — a11y scan + responsive overflow (dev stack must be up)
./code/src/scripts/tests/e2e-py.sh
./code/src/scripts/tests/e2e-py.sh -k overflow
./code/src/scripts/tests/e2e-py.sh --headed

# Mutation testing (local-only; dev stack required)
./code/src/scripts/tests/mutmut.sh run
```

## Coverage thresholds

| Layer   | Metric | Floor | Enforced by                                                                      |
| ------- | ------ | ----- | -------------------------------------------------------------------------------- |
| Backend | Line   | 75%   | `--cov-fail-under=75`                                                            |
| Backend | Branch | 75%   | `--cov-branch`                                                                   |
| Backend | Auth   | 90%   | `backend-coverage.sh` auth gate — `apps/$AUTH_APP` line rate from `coverage.xml` |

**Baseline exception, and only that.** While `code/src/django/apps/` holds no modules,
`backend-coverage.sh` prints a NOTE and runs with the floor at 0 — a 75% bar on a tree
with nothing to cover fails a correct repo. The auth gate is likewise skipped while
`apps/$AUTH_APP` (default `users`) does not exist. Both arm themselves the moment that
code lands; if the app exists but coverage measures none of it, the gate fails **closed**.
Never relax a floor any other way.

Both phases also treat pytest's exit code `5` (nothing collected) as a pass, so the
template's zero-test baseline is green rather than red. A collected test that fails still
fails the run.

The browser suite is **excluded from coverage**. It exercises a running stack over HTTP, so it
instruments nothing — counting it would inflate the figure without testing a line more.

## Exit codes

- `0` — all tests passed (coverage floor met where applicable)
- `1` — test failures or coverage below threshold
- `2` — script error (bad arguments, container not running, invalid `--output` path)

## CI

These scripts are used by two GitHub Actions workflows:

| Workflow                             | Trigger                                      | Scripts used          |
| ------------------------------------ | -------------------------------------------- | --------------------- |
| `.github/workflows/test-backend.yml` | Push/PR on `.py` changes                     | `backend-coverage.sh` |
| `.github/workflows/test-api.yml`     | Push/PR on `.py` or Bruno collection changes | `api.sh`              |
| `.github/workflows/test-e2e.yml`     | Push/PR on Django or Docker changes          | `e2e-py.sh`           |

Mutation testing (`mutmut.sh`) is intentionally excluded from CI — it is too slow for standard
gates and is run on-demand locally against the dev stack.
