# code/src/scripts/tests/reports/api

Reports from `api.sh` (Bruno API integration tests).

## Generated files

| Path           | Format     | Source script |
| -------------- | ---------- | ------------- |
| `results.json` | Bruno JSON | `api.sh`      |

## Usage

- Inspect `results.json` for pass/fail counts, response times, and assertion details.
- Import into CI artefacts via the `test-api.yml` workflow upload step.

Generated reports are gitignored. Re-run `api.sh` to refresh.
