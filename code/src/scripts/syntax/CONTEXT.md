# code/src/scripts/syntax

Code quality scripts for linting, type-checking, and formatting. All scripts run inside Docker
containers via `docker compose exec` — never on the host directly.

## Directory Tree

```text
code/src/scripts/syntax/
├── check.sh                 ← type-check Python (basedpyright) and TypeScript (tsc)
├── CONTEXT.md               ← this file
├── format.sh                ← format Python (ruff), TS/JS/CSS/MD (Prettier)
├── lint.sh                  ← lint Python (ruff), TS/JS/React (ESLint), Markdown
└── reports/                 ← generated report output (all gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script      | Tool(s)                               | Purpose                                   |
| ----------- | ------------------------------------- | ----------------------------------------- |
| `lint.sh`   | ruff check, ESLint, markdownlint-cli2 | Lint Python, TS/JS/React, Markdown        |
| `check.sh`  | basedpyright, tsc --noEmit            | Type-check Python and TypeScript          |
| `format.sh` | ruff format, Prettier                 | Format Python, TS/JS/React, CSS, Markdown |

## Common Flags

| Flag                 | Description                                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| `--fix`              | Apply safe automatic fixes (lint/format) or print fix guidance (check)                          |
| `--unsafe-fix`       | Apply safe + unsafe fixes — ruff only (`lint.sh`)                                               |
| `--file-type TYPE`   | Restrict to one or more file types: `python` `typescript` `javascript` `react` `css` `markdown` |
| `--output FORMAT`    | Write a report file: `md` `txt` `json` `html`                                                   |
| `--output-file PATH` | Override the default report output path                                                         |
| `--quiet`            | Suppress terminal output — requires `--output`                                                  |
| `--path PATH`        | Restrict to a specific file or directory                                                        |
| `--help`             | Print usage                                                                                     |

## Exit Codes

- `0` — clean / all formatted / no changes
- `1` — issues found / formatting needed / type errors
- `2` — script error (bad arguments, containers not running)

## Reports

Generated reports are written to `reports/` and gitignored by default.
Default filenames: `lint-report.<FORMAT>`, `check-report.<FORMAT>`, `format-report.<FORMAT>`.

## Requirements

Docker Compose services must be running before invoking any script:

```bash
docker compose up -d
```
