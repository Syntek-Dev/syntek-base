@./CONTEXT.md

# CLAUDE.md — code/src/logs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is written here, access, rotation — imported above) → this file.

## Purpose (one line)

Runtime log files written by the Django backend in **dev and test only**
(`django.log` + rotations) — all gitignored; nothing here is source.

## How to work here

- **Routing:** debugging with logs → workflow `code/workflows/10-debugging-with-logs/`;
  configuration lives in `code/docs/LOGGING.md`. Read logs with **`logs.sh`**
  (`--service backend --follow`) or tail the files directly — never invoke
  `docker` or `python` directly to run the stack.
- **Model:** Opus — this folder is read-only operational output; there is nothing
  to author here.
- **Concrete steps:** follow a service with `logs.sh --service <name> --follow`, or
  `grep ERROR code/src/logs/django.log`; to reset,
  truncate via the documented `docker compose … exec backend` command in `CONTEXT.md`.
- **Definition of done:** no file in this directory is committed; only `CONTEXT.md`,
  `CLAUDE.md`, `.gitignore`, and `.gitkeep` are tracked.

## Guardrails

- **Dev/test only** — staging and production log to stdout (JSON) for Grafana Alloy →
  Loki; never wire disk logging into a non-local settings module.
- **Everything except the tracked marker files is gitignored** — never commit a log,
  and never add application code here.
- Exception reports go to Glitchtip, metrics to Prometheus, aggregated logs to Loki,
  bug notes to `project-management/src/19-BUGS/` — not here.

## Output & naming

- **Generated (gitignored):** `django.log`, `django.log.1`…`.5` (10 MB × 5 backups)
  — written by the runtime, never hand-edited.
- **Tracked only:** `CONTEXT.md`, `CLAUDE.md`, `.gitignore`, `.gitkeep`.
