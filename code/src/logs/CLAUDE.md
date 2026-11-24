@./CONTEXT.md

# CLAUDE.md — code/src/logs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is written here, access, rotation — imported above) → this file.

## Purpose (one line)

Runtime log files written by the Django backend in **dev only**, host-mounted
(`django.log` + rotations, Django's lines as JSON) — all gitignored; nothing here is source.

## How to work here

- **Routing:** debugging with logs → workflow `code/workflows/09-debugging-with-logs/`;
  configuration lives in `code/docs/LOGGING.md`. Read logs with **`logs.sh`**
  (`--service django --follow`) or tail the files directly — never invoke
  `docker` or `python` directly to run the stack.
- **Model:** Opus — this folder is read-only operational output; there is nothing
  to author here.
- **Concrete steps:** follow a service with `logs.sh --service <name> --follow`, or
  `grep '"level": "ERROR"' code/src/logs/django.log`; to reset,
  truncate the file inside a `shell.sh` session, as `CONTEXT.md` → _Log rotation_ shows.
- **Definition of done:** no file in this directory is committed; only `CONTEXT.md`,
  `CLAUDE.md`, `.gitignore`, and `.gitkeep` are tracked.

## Guardrails

The reference deployment runs Grafana Alloy shipping logs to Loki, queried with LogQL in
Grafana, and Prometheus for metrics (`how-to/src/PLATFORM-PROVIDERS.md`).

- **Dev only** — test logs to the console only; staging and production write every line Django's
  `LOGGING` emits as JSON to stdout for Grafana Alloy → <%LOG_AGGREGATOR%>; never wire disk
  logging into a non-dev settings module.
- **Not every line is JSON** — uvicorn's dev access log and the process-server stream
  (`gunicorn.error`, `uvicorn.error`, stderr) stay plain text, outside Django's `LOGGING`.
- **Everything except the tracked marker files is gitignored** — never commit a log,
  and never add application code here.
- Exception reports go to <%ERROR_TRACKING%>, metrics to Prometheus, aggregated logs to
  <%LOG_AGGREGATOR%>, bug notes to `project-management/src/21-BUGS/` — not here.

## Output & naming

- **Generated (gitignored):** `django.log`, `django.log.1`…`.5` (10 MB × 5 backups)
  — written by the runtime, never hand-edited.
- **Tracked only:** `CONTEXT.md`, `CLAUDE.md`, `.gitignore`, `.gitkeep`.
