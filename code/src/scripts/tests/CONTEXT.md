# code/src/scripts/tests

Shell scripts for running the automated test suites. All scripts invoke Docker containers — never run `pytest` or `pnpm` directly on the host.

## Directory tree

```text
code/src/scripts/tests/
├── all.sh                    ← backend + frontend in sequence; supports --coverage
├── api.sh                    ← Bruno API tests (explicit only); writes JSON report
├── backend.sh                ← pytest plain run; writes JUnit XML
├── backend-coverage.sh       ← pytest + coverage; writes HTML, Cobertura XML, JUnit XML
├── CONTEXT.md                ← this file
├── e2e.sh                    ← playwright-bdd E2E (explicit only); writes HTML + JUnit XML
├── frontend.sh               ← vitest plain run; writes JUnit XML
├── frontend-coverage.sh      ← vitest + coverage; writes HTML + LCOV
├── open-coverage.sh          ← opens backend and/or frontend coverage HTML in browser
└── reports/                  ← generated reports (all gitignored; sub-dirs below)
    ├── api/                  ← output from api.sh
    ├── backend/              ← output from backend.sh
    ├── backend-coverage/     ← output from backend-coverage.sh
    ├── frontend/             ← output from frontend.sh
    ├── frontend-coverage/    ← output from frontend-coverage.sh
    └── e2e/                  ← output from e2e.sh
```

## Scripts

| Script                 | Tool               | Pattern  | Stack required     | Default output dir           |
| ---------------------- | ------------------ | -------- | ------------------ | ---------------------------- |
| `api.sh`               | Bruno CLI          | run --rm | backend-test up    | `reports/api/`               |
| `backend.sh`           | pytest             | exec     | Full test stack up | `reports/backend/`           |
| `backend-coverage.sh`  | pytest + cov       | exec     | Full test stack up | `reports/backend-coverage/`  |
| `frontend.sh`          | vitest             | run --rm | None (one-shot)    | `reports/frontend/`          |
| `frontend-coverage.sh` | vitest --coverage  | run --rm | None (one-shot)    | `reports/frontend-coverage/` |
| `e2e.sh`               | playwright-bdd     | exec     | Full test stack up | `reports/e2e/`               |
| `all.sh`               | backend + frontend | both     | Full test stack up | (delegates to sub-scripts)   |
| `open-coverage.sh`     | xdg-open / open    | host     | None               | N/A                          |

## --output flag

Every script accepts `--output DIR` to write reports to a custom directory (must be within the project root). The directory is created automatically.

```bash
./code/src/scripts/tests/backend.sh --output /abs/path/to/project/my-reports/backend
```

The directory is bind-mounted from the host into the test container — any path under the project root is accessible in both directions.

## open-coverage.sh

Opens coverage HTML reports in the default browser (`xdg-open` on Linux, `open` on macOS).

```bash
./code/src/scripts/tests/open-coverage.sh            # opens both backend + frontend
./code/src/scripts/tests/open-coverage.sh --backend  # backend only
./code/src/scripts/tests/open-coverage.sh --frontend # frontend only
```

Reports must already exist — run the relevant coverage script first. The script exits `1` if no HTML files are found and prints instructions.

## --coverage flag (all.sh only)

```bash
./code/src/scripts/tests/all.sh            # plain: backend.sh + frontend.sh
./code/src/scripts/tests/all.sh --coverage # coverage: backend-coverage.sh + frontend-coverage.sh
```

## Exec vs run --rm

- **Backend scripts** use `docker compose exec` — the `backend-test` container must be running. The reports bind-mount is declared in `docker-compose.test.yml`.
- **Frontend scripts** use `docker compose run --rm` — each invocation starts a fresh container, runs Vitest, and exits. The reports bind-mount applies here too (declared in compose).
- **E2E** uses `docker compose exec` — requires the full stack including nginx (port 80) so Playwright can reach the app.

## Starting the test stack

```bash
# Start full test stack (backend + frontend + nginx + db + cache)
docker compose -f code/src/docker/docker-compose.test.yml up -d

# Start dependencies only (faster if you only need backend tests)
docker compose -f code/src/docker/docker-compose.test.yml up -d db cache backend-test
```

## Usage examples

```bash
# Backend — all tests
./code/src/scripts/tests/backend.sh

# Backend — specific marker
./code/src/scripts/tests/backend.sh -m unit

# Backend — specific app
./code/src/scripts/tests/backend.sh code/src/backend/apps/users/

# Backend — coverage report
./code/src/scripts/tests/backend-coverage.sh

# Backend — coverage to custom dir
./code/src/scripts/tests/backend-coverage.sh --output /abs/path/to/project/ci-reports/backend-coverage

# Frontend — all tests
./code/src/scripts/tests/frontend.sh

# Frontend — with coverage
./code/src/scripts/tests/frontend-coverage.sh

# E2E — all scenarios (explicit only)
./code/src/scripts/tests/e2e.sh

# E2E — specific feature
./code/src/scripts/tests/e2e.sh --grep "User login"

# Both suites — plain
./code/src/scripts/tests/all.sh

# Both suites — with coverage
./code/src/scripts/tests/all.sh --coverage
```

## Coverage thresholds

| Layer    | Metric | Floor | Enforced by               |
| -------- | ------ | ----- | ------------------------- |
| Backend  | Line   | 75%   | `--cov-fail-under=75`     |
| Backend  | Branch | 75%   | `--cov-branch`            |
| Backend  | Auth   | 90%   | Manual check — apps/users |
| Frontend | Line   | 70%   | `vitest.config.ts`        |
| Frontend | Branch | 70%   | `vitest.config.ts`        |

## Exit codes

- `0` — all tests passed (coverage floor met where applicable)
- `1` — test failures or coverage below threshold
- `2` — script error (bad arguments, container not running, invalid `--output` path)

## CI

These scripts are used by three GitHub Actions workflows:

| Workflow                              | Trigger                                                         | Scripts used                              |
| ------------------------------------- | --------------------------------------------------------------- | ----------------------------------------- |
| `.github/workflows/test-api.yml`      | Push/PR on backend or `tests/api/` changes; `workflow_dispatch` | `api.sh` (runs via `frontend-test` image) |
| `.github/workflows/test-backend.yml`  | Push/PR on `.py` changes                                        | `backend-coverage.sh`                     |
| `.github/workflows/test-frontend.yml` | Push/PR on `.ts/.tsx` changes                                   | `frontend-coverage.sh`                    |
| `.github/workflows/test-e2e.yml`      | `workflow_dispatch` only                                        | `e2e.sh`                                  |
