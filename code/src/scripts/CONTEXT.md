# code/src/scripts

Shell scripts for all development operations. Organised into functional subdirectories. Scripts
that require Django run inside Docker containers via `docker compose exec` — never
on the host directly.

## Directory Tree

```text
code/src/scripts/
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── _lib/                    ← internal shell library (not invoked directly)
│   └── worktree-detect.sh
├── audits/                  ← codebase health audits (cloc, stub detection)
│   └── reports/             ← generated report output (gitignored)
├── database/                ← database management (migrate, backup, restore, shell)
│   └── reports/             ← backup files and generated reports (gitignored)
├── dependencies/            ← move a dependency forward (uv, pnpm, cargo — one command)
├── deployment/              ← deployment scripts (planned — scripts TBD)
│   └── reports/             ← generated report output (gitignored)
├── development/             ← dev stack lifecycle (server, shell, logs, scaffolding)
│   └── reports/             ← reserved for future report output (gitignored)
├── mobile/                  ← MOBILE-ONLY — Metro, lint, typecheck, test, bundle (host, not Docker)
├── rust/                    ← RUST-ONLY — build, test, lint, supply-chain audit (host, not Docker)
├── desktop/                 ← DESKTOP-ONLY — run the app, package the binary (host, not Docker)
├── reports/                 ← top-level generated reports (gitignored)
├── syntax/                  ← code quality (lint, type-check, format)
│   └── reports/             ← generated report output (gitignored)
└── tests/                   ← test suite runner (pytest, Bruno, playwright-python)
    └── reports/             ← test reports by type (gitignored)
        ├── a11y/
        ├── api/
        ├── backend/
        └── backend-coverage/
```

## Subdirectories

| Directory       | Purpose                                                                                                                                                      |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `_lib/`         | Internal shell helpers sourced by other scripts — not invoked directly                                                                                       |
| `audits/`       | Codebase health: line-count enforcement, stub detection                                                                                                      |
| `database/`     | Django migration management, PostgreSQL backup / restore / reset                                                                                             |
| `dependencies/` | Move a dependency forward across all three ecosystems — the one place a floor changes                                                                        |
| `deployment/`   | Deployment automation scripts (planned)                                                                                                                      |
| `development/`  | Dev stack lifecycle: server up/down, container shell, log tailing, scaffolding                                                                               |
| `mobile/`       | **Mobile-only.** Every mobile-surface operation — and the one group that runs on the **host** rather than in Docker, because Expo Go needs Metro on the LAN  |
| `rust/`         | **Rust-only.** Every Rust operation — the second group running on the **host** rather than in Docker, so the pinned toolchain governs it and the image alike |
| `desktop/`      | **Desktop-only.** Run and package the Slint app. No lint/test/audit here — the crate is a workspace member, so `rust/` already covers it                     |
| `reports/`      | Top-level generated reports (gitignored)                                                                                                                     |
| `syntax/`       | Code quality: ruff, basedpyright, markdownlint, Prettier                                                                                                     |
| `tests/`        | Test suite: pytest (backend), Bruno (API), playwright-python (browser e2e)                                                                                   |

## Host or container

Most scripts that touch Django run inside Docker via `docker compose exec`, because that is where
Django's dependencies are. Three groups run on the **host** instead, each for a reason:

| Group                                 | Why it runs on the host                                                       |
| ------------------------------------- | ----------------------------------------------------------------------------- |
| `audits/`                             | They read files, not a running application — a container buys nothing         |
| `syntax/format.sh` · `syntax/lint.sh` | Prettier and markdownlint span the whole tree, and no dev container mounts it |
| `mobile/` · `rust/` · `desktop/`      | Their toolchains are pinned on the host, so image and developer share one pin |

## Cross-references

- `code/src/scripts/CLAUDE.md` — the operating rules: scripts are the only sanctioned
  interface, and what to do when one does not exist yet
- `how-to/docs/CONTEXT.md` — daily development commands and workflows
- `code/docs/TESTING.md` — testing strategy and coverage requirements
