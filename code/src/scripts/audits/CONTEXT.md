# code/src/scripts/audits

Audit scripts for codebase health. `cloc.sh`, `stubs.sh`, and `css-tokens.sh` run directly on the
host (no Docker required) and cover the full source tree on every invocation. `security.sh` runs
on the host by default but also accepts `--docker` to audit inside the running dev containers.

## Directory Tree

```text
code/src/scripts/audits/
├── cloc.sh                  ← line-count audit (wc -l enforcement + cloc summary)
├── CONTEXT.md               ← this file
├── css-tokens.sh            ← phantom-token guard (var(--x) must resolve to a defined token)
├── css-gradients.sh         ← inline-gradient guard (brand gradients must be var(--gradient-*) tokens)
├── copy-emdash.sh           ← marketing-copy em-dash guard (no em dash in pagedata / templates)
├── mobile-tokens.sh         ← MOBILE-ONLY guard — no raw design values in StyleSheet code
├── security.sh              ← dependency CVE audit (pip-audit for runtime deps + pnpm audit for repo tooling)
├── stubs.sh                 ← stub detection (Python; also TS/JS if any is ever added)
└── reports/                 ← generated report output (all gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script             | Purpose                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `stubs.sh`         | Detect stub implementations: `raise NotImplementedError`, `throw new Error(*not implemented*)`, `# STUB`, `// STUB`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `cloc.sh`          | Count lines per file via `wc -l`; warn at 750, fail at 800. Covers `*.py` `*.html` `*.css` `*.js` `*.jsx` `*.ts` `*.tsx` — templates and CSS are source in this stack. Cloc language summary when installed.                                                                                                                                                                                                                                                                                                                                                                                                    |
| `css-tokens.sh`    | Verify every `var(--x)` reference across the three CSS scopes resolves to a defined token (or an allowlisted `--blk-` runtime prefix). Fails on "phantom" tokens that silently drop under Lightning CSS.                                                                                                                                                                                                                                                                                                                                                                                                        |
| `css-gradients.sh` | Ban raw inline gradients in component/page CSS — brand gradients must be `var(--gradient-*)` / `var(--sector-tone-*)` tokens (`code/docs/VISUAL-DESIGN.md` § 4). The token layer is exempt; a functional gradient (shimmer/mask) is allowed with a `gradient-allow` annotation.                                                                                                                                                                                                                                                                                                                                 |
| `copy-emdash.sh`   | Ban em dashes (—) in public marketing copy — `apps/marketing/pagedata/*.py` + `templates/*.html`. Enforces the "no em dash, no spaced-en-dash substitute" copy rule (`BRAND-VOICE.md`). Numeric en dashes (`Mon–Fri`) are not flagged.                                                                                                                                                                                                                                                                                                                                                                          |
| `mobile-tokens.sh` | The mobile half of the token-first law: no raw colour or design-numeric literals in `code/src/mobile/**/*.{ts,tsx}`. **Self-guarding — exits 0 with a note when there is no mobile surface**, so a web-only project reports success rather than failing. Only the no-raw-literals clause is checked: the emitted token module is typed, so an unresolved import fails `typecheck.sh` already. Escape hatch: a `token-allow` comment on the line or the line above, with a reason. Layout properties (`flex`, `opacity`, `zIndex`, `width`, `height`, insets) are deliberately NOT flagged — they have no token. |
| `security.sh`      | Dependency CVE audit mirroring the CI `[8/8] Security` gate: `pnpm audit` (JS/TS) + `pip-audit` (Python).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |

## security.sh

Mirrors the CI `[8/8] Security` gate (`.github/workflows/claude.yml`) so a clean local run
predicts a clean CI run. `pnpm audit` reads `auditConfig.ignoreGhsas` from `pnpm-workspace.yaml`
natively, so accepted advisories do not fail the run.

| Flag                | Description                                                               |
| ------------------- | ------------------------------------------------------------------------- |
| `--local`           | Run on the host (default)                                                 |
| `--docker`          | Run inside the running dev containers (needs `development/server.sh up`)  |
| `--js-only`         | Only `pnpm audit` (frontend workspace)                                    |
| `--py-only`         | Only the Python CVE scan (backend)                                        |
| `--py-tool TOOL`    | Python auditor: `pip-audit` (default, CI parity) \| `uv` (`uv audit`)     |
| `--audit-level LVL` | pnpm threshold: `info` `low` `moderate` `high` `critical` (default `low`) |
| `--quiet`           | Suppress per-tool output; print only the summary                          |

> `pip-audit` (the scanner the CI gate uses) and `uv audit` (uv's built-in, experimental) are
> different tools — `security.sh` defaults to `pip-audit` for CI parity.

## Markdown exclusion

Both scripts exclude `*.md` files:

- **`stubs.sh`** — only scans `*.py`, `*.ts`, `*.tsx`, `*.js`, `*.jsx` via `--include`. Markdown is never checked for stubs.
- **`cloc.sh`** — per-file enforcement checks `*.py`, `*.html`, `*.css`, `*.js`, `*.jsx`, `*.ts`, `*.tsx`. The cloc language summary uses `--exclude-lang=Markdown` so Markdown lines are not counted.

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

| Script             | Dependencies                                                                           |
| ------------------ | -------------------------------------------------------------------------------------- |
| `stubs.sh`         | `grep` (always available)                                                              |
| `cloc.sh`          | `wc`, `find` (always available) · `cloc` (optional, for language summary)              |
| `css-tokens.sh`    | `grep`, `find`, `xargs`, `perl` (always available)                                     |
| `css-gradients.sh` | `grep`, `find`, `awk` (always available)                                               |
| `copy-emdash.sh`   | `grep`, `find` (always available)                                                      |
| `mobile-tokens.sh` | `grep`, `find`, `awk` (always available)                                               |
| `security.sh`      | `pnpm` (JS audit) · `uv` + `pip-audit` (Python audit) · `docker` (for `--docker` mode) |

Install cloc:

```bash
# Debian / Ubuntu
sudo apt-get install cloc

# macOS
brew install cloc
```
