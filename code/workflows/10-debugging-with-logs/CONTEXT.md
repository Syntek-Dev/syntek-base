# Workflow 10 — Debugging with Logs and Observability

## Purpose

Systematic debugging using the project's observability stack, working from the fastest/cheapest
signal (local logs) through to the most detailed (Grafana dashboards). Covers all four
environments with different tooling at each tier.

## When to use this workflow

- An exception has been reported and you need to find the root cause
- A feature is behaving differently in staging/prod than locally
- A performance regression appears in Grafana metrics
- You need to confirm that a fix actually resolved an issue in production

## Tool availability per environment

| Tool                                   | dev | test | staging | prod |
| -------------------------------------- | --- | ---- | ------- | ---- |
| Local log files (`code/src/logs/`)     | ✅  | ✅   | ❌      | ❌   |
| Console output (`docker compose logs`) | ✅  | ✅   | ✅      | ✅   |
| Glitchtip exception tracker            | ❌  | ❌   | ✅      | ✅   |
| Loki (LogQL queries in Grafana)        | ❌  | ❌   | ✅      | ✅   |
| Prometheus + Grafana dashboards        | ❌  | ❌   | ✅      | ✅   |

## Prerequisites

- Docker Compose stack is running for the target environment
- For staging/prod: access to the Grafana instance on the server
- For staging/prod: Glitchtip DSN is set and exceptions are flowing
- Read `code/docs/LOGGING.md` before using this workflow for the first time

## Outputs

- Root cause identified and documented
- A regression test added to prevent recurrence (see `code/workflows/07-debug/`)
- If a staging/prod incident: a bug report filed in `project-management/src/13-BUGS/`

## Cross-references

- `code/docs/LOGGING.md` — logging configuration and tool details
- `code/workflows/07-debug/` — code-logic debugging workflow (complements this one)
- `code/src/logs/CONTEXT.md` — local log file location and access commands
