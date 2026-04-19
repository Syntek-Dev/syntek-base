# code/src/scripts/tests/reports/frontend-coverage

Coverage reports from `frontend-coverage.sh` (Vitest + @vitest/coverage-v8). Enforces 70% line and branch floor.

## Generated files

| Path            | Format | Source script          |
| --------------- | ------ | ---------------------- |
| `html/`         | HTML   | `frontend-coverage.sh` |
| `lcov.info`     | LCOV   | `frontend-coverage.sh` |
| `coverage.json` | JSON   | `frontend-coverage.sh` |

## Usage

- Open `html/index.html` in a browser for line-level coverage detail.
- Import `lcov.info` into CI coverage dashboards (Codecov, SonarQube).

Generated reports are gitignored. Re-run `frontend-coverage.sh` to refresh.
