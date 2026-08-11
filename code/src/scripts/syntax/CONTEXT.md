# code/src/scripts/syntax

Code quality scripts for linting, type-checking, and formatting.

**Execution context.** The Python tools — ruff and basedpyright — run in the `django` container,
which mounts the Django source. The two **repo-spanning** tools, Prettier (`format.sh`) and
markdownlint-cli2 (`lint.sh`), run on the **host** via `pnpm exec`, because no dev container mounts
the whole tree (the `django` container only mounts `code/src/django`, so it cannot see
`project-management/`, `how-to/`, or the root docs). This mirrors the lefthook pre-commit gate,
which also runs Prettier and markdownlint on the host. The host therefore needs the workspace
`pnpm`/Node (already required to commit).

## Directory Tree

```text
code/src/scripts/syntax/
├── check.sh                 ← type-check Python (basedpyright)
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── format.sh                ← format Python (ruff), CSS/Markdown/JSON (Prettier)
├── lint.sh                  ← lint Python (ruff), Markdown (markdownlint-cli2)
└── reports/                 ← generated report output (all gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script      | Tool(s)                       | Purpose                                |
| ----------- | ----------------------------- | -------------------------------------- |
| `lint.sh`   | ruff check, markdownlint-cli2 | Lint Python and Markdown               |
| `check.sh`  | basedpyright                  | Type-check Python                      |
| `format.sh` | ruff format, Prettier         | Format Python, CSS, Markdown, and JSON |

## Common Flags

| Flag                 | Description                                                            |
| -------------------- | ---------------------------------------------------------------------- |
| `--fix`              | Apply safe automatic fixes (lint/format) or print fix guidance (check) |
| `--unsafe-fix`       | Apply safe + unsafe fixes — ruff only (`lint.sh`)                      |
| `--file-type TYPE`   | Restrict to one or more file types: `python` `markdown` `css`          |
| `--output FORMAT`    | Write a report file: `md` `txt` `json` `html`                          |
| `--output-file PATH` | Override the default report output path                                |
| `--quiet`            | Suppress terminal output — requires `--output`                         |
| `--path PATH`        | Restrict to a specific file or directory                               |
| `--help`             | Print usage                                                            |

CSS has no lint tool configured — `lint.sh` accepts `--file-type css` but only `format.sh`
acts on CSS.

## Exit Codes

- `0` — clean / all formatted / no changes
- `1` — issues found / formatting needed / type errors
- `2` — script error (bad arguments, containers not running)

## Reports

Generated reports are written to `reports/` and gitignored by default.
Default filenames: `lint-report.<FORMAT>`, `check-report.<FORMAT>`, `format-report.<FORMAT>`.

## Dependencies

The Python steps run inside the `django` container and skip with a warning when it is down, so a
run with the stack stopped is partial rather than broken. Starting the stack:

```bash
bash code/src/scripts/development/server.sh up
```

Prettier and markdownlint run on the host, so a markdown-only `format.sh` / `lint.sh` works even
with the stack down — it only needs the workspace `pnpm`. `--path` accepts a file, a glob, or a
directory (directories are widened to a recursive glob for Prettier/markdownlint).
