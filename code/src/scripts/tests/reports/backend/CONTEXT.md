# code/src/scripts/tests/reports/backend

JUnit XML reports from plain `backend.sh` test runs (no coverage instrumentation).

## Directory Tree

```text
code/src/scripts/tests/reports/backend/
├── CONTEXT.md    ← this file (a generated-output directory carries no CLAUDE.md)
├── .gitignore    ← ignores every report written here
└── .gitkeep      ← keeps the directory in git while the reports stay out
```

## Generated files

| File          | Format    | Source script |
| ------------- | --------- | ------------- |
| `results.xml` | JUnit XML | `backend.sh`  |

## Usage

Open `results.xml` in any JUnit-compatible viewer (IntelliJ, VS Code Test Explorer, CI dashboards).

Generated reports are gitignored. Re-run `backend.sh` to refresh.
