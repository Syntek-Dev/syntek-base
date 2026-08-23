# Workflow 09 — Debugging with Logs and Observability

Finding the cause is a different job from fixing it, which is why this workflow is separate from
`10-debug/`: the signal you need lives in a different place in each environment, and reaching for
the wrong tier wastes the most time on the environments where debugging is already hardest.

## Directory Tree

```text
code/workflows/09-debugging-with-logs/
├── CHECKLIST.md   ← verification checklist before marking complete
├── CLAUDE.md      ← operating rules
├── CONTEXT.md     ← this file (when to use, tool availability per environment)
└── STEPS.md       ← ordered steps to execute
```

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

| Tool                                    | dev | test | staging | prod |
| --------------------------------------- | --- | ---- | ------- | ---- |
| Local log files (`code/src/logs/`)      | ✅  | ✅   | ❌      | ❌   |
| Console output (`docker compose logs`)  | ✅  | ✅   | ✅      | ✅   |
| Glitchtip exception tracker             | ❌  | ❌   | ✅      | ✅   |
| Loki / Alloy (LogQL queries in Grafana) | ❌  | ❌   | ✅      | ✅   |
| Prometheus + Grafana dashboards         | ❌  | ❌   | ✅      | ✅   |

## Outputs

- Root cause identified and documented
- A regression test added to prevent recurrence (see `code/workflows/10-debug/`)
- If a staging/prod incident: a bug report filed in `project-management/src/21-BUGS/`

## Cross-references

### Governing documents

None — log-based debugging is observational; start with whichever signal is available.

### Related reading

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **debug playbook**
  (`.claude/skills/debug-issue.md`): trace the code path structurally once a log signal points
  at a suspect area
- `code/docs/logging/DJANGO-LOGGING.md` — Django logging configuration, log levels, Django Ninja extension
- `code/docs/logging/FRONTEND-LOGGING.md` — browser logging setup, HTMX error forwarding, dev vs prod behaviour
- `code/docs/logging/OBSERVABILITY.md` — GlitchTip, Loki, Prometheus, Grafana tool details
- `code/workflows/10-debug/` — code-logic debugging workflow (complements this one)
- `how-to/workflows/08-debugging/` — operational complement to this observability workflow
- `code/src/logs/CONTEXT.md` — local log file location and access commands
- `project-management/workflows/22-implementation-documentation/` — routes a defect finding to
  `project-management/src/21-BUGS/`, which is what a staging/prod incident report here becomes
