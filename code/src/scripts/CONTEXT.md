# code/src/scripts

Shell scripts for all development operations. Organised into functional subdirectories. Scripts
that require Django run inside Docker containers via `docker compose exec` — never
on the host directly.

## Directory Tree

```text
code/src/scripts/
├── _lib/                    ← internal shell library (not invoked directly)
│   └── worktree-detect.sh
├── audits/                  ← codebase health audits (cloc, stub detection)
│   └── reports/             ← generated report output (gitignored)
├── database/                ← database management (migrate, backup, restore, shell)
│   └── reports/             ← backup files and generated reports (gitignored)
├── deployment/              ← deployment scripts (planned — scripts TBD)
│   └── reports/             ← generated report output (gitignored)
├── development/             ← dev stack lifecycle (server, shell, logs, scaffolding)
│   └── reports/             ← reserved for future report output (gitignored)
├── mobile/                  ← MOBILE-ONLY — Metro, lint, typecheck, test, bundle (host, not Docker)
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

| Directory      | Purpose                                                                                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `_lib/`        | Internal shell helpers sourced by other scripts — not invoked directly                                                                                      |
| `audits/`      | Codebase health: line-count enforcement, stub detection                                                                                                     |
| `database/`    | Django migration management, PostgreSQL backup / restore / reset                                                                                            |
| `deployment/`  | Deployment automation scripts (planned)                                                                                                                     |
| `development/` | Dev stack lifecycle: server up/down, container shell, log tailing, scaffolding                                                                              |
| `mobile/`      | **Mobile-only.** Every mobile-surface operation — and the one group that runs on the **host** rather than in Docker, because Expo Go needs Metro on the LAN |
| `reports/`     | Top-level generated reports (gitignored)                                                                                                                    |
| `syntax/`      | Code quality: ruff, basedpyright, markdownlint, Prettier                                                                                                    |
| `tests/`       | Test suite: pytest (backend), Bruno (API), playwright-python (browser e2e)                                                                                  |

## Rules

- Always use these scripts rather than invoking `python`, `pnpm`, or `pytest` directly.
- If a script does not exist for a task, ask for it to be created before proceeding.
- Audit scripts (`audits/`) run on the host — no container required.
- Most scripts that interact with Django run inside Docker. Exceptions: the two
  repo-spanning formatters/linters — Prettier (`syntax/format.sh`) and markdownlint
  (`syntax/lint.sh`) — run on the **host** via the workspace `pnpm`, because no dev container
  mounts the whole tree (see `syntax/CONTEXT.md`).

## Cross-references

- `how-to/docs/CONTEXT.md` — daily development commands and workflows
- `code/docs/TESTING.md` — testing strategy and coverage requirements
