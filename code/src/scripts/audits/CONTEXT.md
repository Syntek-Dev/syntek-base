# code/src/scripts/audits

Audit scripts for codebase health. Unlike the scripts in `syntax/`, these run directly on the
host (no Docker required) and cover the full source tree on every invocation.

## Directory Tree

```text
code/src/scripts/audits/
├── cloc.sh                  ← line-count audit (wc -l enforcement + cloc summary)
├── CONTEXT.md               ← this file
├── stubs.sh                 ← stub detection (Django, GraphQL, Next.js, TypeScript)
└── reports/                 ← generated report output (all gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script     | Purpose                                                                                                             |
| ---------- | ------------------------------------------------------------------------------------------------------------------- |
| `stubs.sh` | Detect stub implementations: `raise NotImplementedError`, `throw new Error(*not implemented*)`, `# STUB`, `// STUB` |
| `cloc.sh`  | Count lines per file via `wc -l`; warn at 750, fail at 800. Cloc language summary when installed.                   |

## Markdown exclusion

Both scripts exclude `*.md` files:

- **`stubs.sh`** — only scans `*.py`, `*.ts`, `*.tsx`, `*.js`, `*.jsx` via `--include`. Markdown is never checked for stubs.
- **`cloc.sh`** — per-file enforcement only checks those same source extensions. The cloc language summary uses `--exclude-lang=Markdown` so Markdown lines are not counted.

Markdown files are still linted by `markdownlint-cli2` (via `lefthook` pre-commit and `syntax/lint.sh`) and formatted by Prettier — they are just not subject to the 750/800-line hard limit.

## Common Flags

| Flag                 | Description                                    |
| -------------------- | ---------------------------------------------- |
| `--output FORMAT`    | Write a report file: `md` `txt` `json` `html`  |
| `--output-file PATH` | Override the default report output path        |
| `--quiet`            | Suppress terminal output — requires `--output` |
| `--path PATH`        | Restrict to a specific file or directory       |
| `--help`             | Print usage                                    |

### stubs.sh only

| Flag               | Description                                                               |
| ------------------ | ------------------------------------------------------------------------- |
| `--strict`         | Also list `# TODO`, `# FIXME`, `# HACK` soft markers (does not fail)      |
| `--file-type TYPE` | Restrict to `python`, `typescript`, or `javascript` (repeat for multiple) |

## TDD/BDD Red Phase Bypass (stubs.sh)

During TDD/BDD red phase, stub implementations are intentional. Skip the stub check by
exporting `STUBS_TDD_RED=1` before committing:

```bash
STUBS_TDD_RED=1 git commit -m "red: failing test for X"
```

Lefthook inherits the shell environment, so this works transparently with the pre-commit hook.

## Exit Codes

- `0` — clean / all within limits
- `1` — issues found (hard stubs or files ≥ 800 lines)
- `2` — script error (bad arguments)

## Reports

Generated reports are written to `reports/` and gitignored by default.
Default filenames: `stubs-report.<FORMAT>`, `cloc-report.<FORMAT>`.

## Requirements

| Script     | Dependencies                                                              |
| ---------- | ------------------------------------------------------------------------- |
| `stubs.sh` | `grep` (always available)                                                 |
| `cloc.sh`  | `wc`, `find` (always available) · `cloc` (optional, for language summary) |

Install cloc:

```bash
# Debian / Ubuntu
sudo apt-get install cloc

# macOS
brew install cloc
```
