# code/src/scripts/tests/reports/backend-coverage

Coverage reports from `backend-coverage.sh` (pytest + pytest-cov). Enforces 75% line and branch floor.

## Generated files

| Path           | Format        | Source script         |
| -------------- | ------------- | --------------------- |
| `html/`        | HTML          | `backend-coverage.sh` |
| `coverage.xml` | Cobertura XML | `backend-coverage.sh` |
| `results.xml`  | JUnit XML     | `backend-coverage.sh` |

## Usage

- Open `html/index.html` in a browser for line-level coverage detail.
- Import `coverage.xml` into CI coverage dashboards (Codecov, SonarQube).
- Import `results.xml` into JUnit-compatible test viewers.

Generated reports are gitignored. Re-run `backend-coverage.sh` to refresh.
