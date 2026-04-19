# code/src/scripts/tests/reports/e2e

Reports from `e2e.sh` (Playwright + playwright-bdd). E2E tests are run explicitly only — never part of the default suite.

## Generated files

| Path          | Format    | Source script |
| ------------- | --------- | ------------- |
| `html/`       | HTML      | `e2e.sh`      |
| `results.xml` | JUnit XML | `e2e.sh`      |

## Usage

- Open `html/index.html` in a browser for a full scenario trace with screenshots and video on failure.
- Import `results.xml` into CI JUnit dashboards.

Generated reports are gitignored. Re-run `e2e.sh` to refresh.
