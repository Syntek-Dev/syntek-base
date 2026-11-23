@./CONTEXT.md

# CLAUDE.md — workflows/09-debugging-with-logs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, when-to-use, per-environment tool matrix, cross-references — imported
above) → this file.

## Purpose (one line)

The reference deployment runs Grafana Alloy shipping logs to Loki, queried with LogQL in
Grafana, and Prometheus for metrics (`how-to/src/PLATFORM-PROVIDERS.md`). The LogQL
query named below describes that deployment; a project that answered another log
aggregator adapts it to its own.

The procedure for observational, log-led debugging — working from the cheapest signal
(local log files) up to <%ERROR_TRACKING%>, <%LOG_AGGREGATOR%>, and Grafana across dev, test, staging,
and prod.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it.
  Debugging → `bugfix` (`## Root cause` phase only) / `stack-django` (Opus). Read `CONTEXT.md`
  first; enter `STEPS.md` only when triggered. No hard gates — start with whichever
  signal the target environment offers (see the tool matrix). Once a log signal points at a
  suspect area, trace the code path with the code-review-graph **debug playbook**
  (`.claude/skills/debug-issue.md`; guide `code/docs/CODE-REVIEW-GRAPH.md`), with graphify as
  fallback and for cross-artefact questions. First-time use: read
  `code/docs/logging/DJANGO-LOGGING.md` and `code/docs/logging/FRONTEND-LOGGING.md`.
- **Model:** Opus for root-cause analysis and a mechanical touch to the
  workflow files.
- **Concrete steps:** dev/test — tail local logs via the dev scripts under
  `code/src/scripts/development/*.sh` and `docker compose logs` through the tooling;
  staging/prod — query Loki (LogQL) and dashboards in Grafana, and <%ERROR_TRACKING%> for
  exceptions. **Never invoke `docker`, `python`, or `pytest` directly — use the shell
  scripts.**
- **Definition of done:** root cause identified and documented; the fix and its
  regression test handed to `code/workflows/10-debug/`; a staging/prod incident filed as a bug report
  in `project-management/src/21-BUGS/`.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Observational only** — this workflow finds the cause; the fix and its regression
  test go through `code/workflows/10-debug/`.
- **No local log files exist in staging/prod** (see the matrix) — never assume
  `code/src/logs/` is available there; use <%LOG_AGGREGATOR%> or <%ERROR_TRACKING%>
  instead.
- Never paste secrets, tokens, or PII from logs into commits, bug reports, or the
  workflow files.
- Editing these workflow `.md` files: keep each **≤ 300 code lines** (instructional-file limit).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Not produced here:** no code or migrations; the tangible output is a documented
  root cause plus a bug report (`BUG-<DESCRIPTOR>-DD-MM-YYYY.md`) when staging/prod.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`; bug reports
  `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`.
