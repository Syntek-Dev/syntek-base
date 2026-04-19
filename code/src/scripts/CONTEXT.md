# code/src/scripts

Shell scripts for all development operations. Organised into functional subdirectories. Scripts
that require Django or Next.js run inside Docker containers via `docker compose exec` — never
on the host directly.

## Directory Tree

```text
code/src/scripts/
├── audits/                  ← codebase health audits (cloc, stub detection)
│   └── reports/             ← generated report output (gitignored)
├── database/                ← database management (migrate, backup, restore, shell)
│   └── reports/             ← backup files and generated reports (gitignored)
├── deployment/              ← deployment scripts (planned — scripts TBD)
│   └── reports/             ← generated report output (gitignored)
├── development/             ← dev stack lifecycle (server, shell, logs)
│   └── reports/             ← reserved for future report output (gitignored)
├── syntax/                  ← code quality (lint, type-check, format)
│   └── reports/             ← generated report output (gitignored)
└── tests/                   ← test suite runner (pytest, Vitest, Playwright)
    └── reports/             ← test reports by type (gitignored)
        ├── backend/
        ├── backend-coverage/
        ├── frontend/
        ├── frontend-coverage/
        └── e2e/
```

## Subdirectories

| Directory      | Purpose                                                           |
| -------------- | ----------------------------------------------------------------- |
| `audits/`      | Codebase health: line-count enforcement, stub detection           |
| `database/`    | Django migration management, PostgreSQL backup / restore / reset  |
| `deployment/`  | Deployment automation scripts (planned)                           |
| `development/` | Dev stack lifecycle: server up/down, container shell, log tailing |
| `syntax/`      | Code quality: ruff, ESLint, markdownlint, basedpyright, tsc       |
| `tests/`       | Test suite: pytest (backend), Vitest (frontend), Playwright (e2e) |

## Rules

- Always use these scripts rather than invoking `python`, `pnpm`, `pytest`, or `next` directly.
- If a script does not exist for a task, ask for it to be created before proceeding.
- Audit scripts (`audits/`) run on the host — no container required.
- All other scripts that interact with Django or Next.js run inside Docker.

## Cross-references

- `how-to/docs/CONTEXT.md` — daily development commands and workflows
- `code/docs/TESTING.md` — testing strategy and coverage requirements
