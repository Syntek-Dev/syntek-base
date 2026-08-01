@./CONTEXT.md

# CLAUDE.md — .claude/plugins/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(helper registry, imported above) → this file.

## Purpose (one line)

Six Python helper scripts (`project`, `env`, `db`, `git`, `log`, `pm`) that agents call to
**inspect** the local environment for context — not MCP servers, and not a path for running dev
operations.

## How to work here

- **Routing:** these are the only `.py` files in `.claude/` — Opus for any logic change, Opus
  only for a rename or a corrected path. Each helper only **reads/detects** (project layout, env
  files, DB, git state, logs, PM config); it must never build, test, migrate, or run the stack —
  those go through `code/src/scripts/**/*.sh`.
- **Concrete steps:** read the target `*-tool.py` whole → keep it single-purpose, read-only, and
  its inputs validated → return machine-readable output (JSON) the caller can parse → keep the
  file ≤ 750 lines (800 grace).
- **Definition of done:** the tool does exactly what its `CONTEXT.md` row says; inputs validated;
  no secret read from anywhere but the environment; `CONTEXT.md` table updated if a helper is
  added, removed, or renamed.

## Guardrails

- **Read-only:** a helper inspects and reports; it does not mutate the repo or run dev operations.
  Anything that builds, tests, migrates, or starts the stack belongs in `code/src/scripts/**/*.sh`.
- **Secrets via environment only** — never hardcode a token, DSN, or credential; `env-tool.py`
  and `db-tool.py` read config from the environment.
- **Validate every agent-supplied argument** before it reaches a shell or a query — no unescaped
  interpolation into commands, no SQL built from raw input.
- Source-file length ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** each `*-tool.py`. Nothing here is generated.
- **Naming:** `<domain>-tool.py` (`git-tool.py`, `project-tool.py`). Add a new helper only with a
  matching `CONTEXT.md` registry row.
