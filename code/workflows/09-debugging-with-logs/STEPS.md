---
workflow: 09-debugging-with-logs
phase: verify
agent: debugger
skills: [stack-django]
model: opus
---

# Workflow 10 — Steps: Debugging with Logs and Observability

Work top-to-bottom. Stop as soon as the root cause is found; do not continue further
down the stack unnecessarily.

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step      | Section                                                         |
| --------- | --------------------------------------------------------------- |
| All steps | **Guides in code/docs/** → LOGGING.md                           |
| 1–2       | **External — Framework & Language Docs → Backend** → Django 6.x |
| 6         | **External — Testing** → pytest, pytest-django                  |

---

## Step 1 — Reproduce locally (all environments)

> **Model:** opus · **MCP:** none

Before reaching for remote observability tools, try to reproduce the issue in dev.

```bash
# Bring the dev stack up
docker compose -f code/src/docker/docker-compose.dev.yml up

# Trigger the failing action (API call, form submission, etc.)
# Watch console output for immediate errors
docker compose -f code/src/docker/docker-compose.dev.yml logs -f backend
```

If the issue only occurs in staging/prod, skip to Step 3.

---

## Step 2 — Read local log files (dev / test)

> **Model:** opus · **MCP:** none

```bash
# Tail live
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    tail -f /workspace/src/logs/django.log

# Filter by level
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    grep -E "ERROR|WARNING|CRITICAL" /workspace/src/logs/django.log

# Filter by logger name (e.g. a specific app)
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    grep "apps.users" /workspace/src/logs/django.log

# Show last 100 lines
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    tail -n 100 /workspace/src/logs/django.log
```

Rotate / clear if the file is too large:

```bash
docker compose -f code/src/docker/docker-compose.dev.yml exec backend \
    sh -c "truncate -s 0 /workspace/src/logs/django.log"
```

---

## Step 3 — Check Glitchtip (staging / prod only)

> **Model:** opus · **MCP:** none

1. Open the Glitchtip project for the relevant environment (staging or prod)
2. Filter issues by **first seen** date to find new regressions
3. Open the relevant issue — check:
   - Full stack trace
   - Request URL, method, and status code
   - Django user ID (if available and not PII)
   - Tags: environment, release version
4. Note the **issue ID** and **first occurrence timestamp** — use these to query Loki next

If the exception is new, tag the Glitchtip issue as `investigating` before continuing.

---

## Step 4 — Query Loki in Grafana (staging / prod only)

> **↳ New agent:** `debugger` · **Model:** opus · **MCP:** none

Open Grafana → Explore → select the Loki datasource.

### Find errors around the time of the incident

```logql
{container="<%PROJECT_SLUG%>-backend"}
  | json
  | level=~"ERROR|CRITICAL"
  | __error__=""
```

### Filter by time window (use the Glitchtip first-seen timestamp)

Set the Grafana time picker to ±5 minutes around the incident time.

### Narrow to a specific request path

```logql
{container="<%PROJECT_SLUG%>-backend"}
  | json
  | message=~".*api.*"
  | level="ERROR"
```

### Find all logs for a specific Django logger

```logql
{container="<%PROJECT_SLUG%>-backend"}
  | json
  | logger=~"apps.users.*"
```

### Browser errors surface in Glitchtip, not Loki

The template ships Django-only — one ASGI process family, no separate frontend
container — so there is no frontend log stream in Loki. Server-side logs for pages,
HTMX partials, and Django Ninja endpoints all live in the single
`<%PROJECT_SLUG%>-backend` stream (queried above); scope them to the app serving the
page or endpoint:

```logql
# Narrow to the app that rendered the failing page or partial
{container="<%PROJECT_SLUG%>-backend"}
  | json
  | logger=~"apps.marketing.*"
  | level=~"ERROR|CRITICAL"
```

Browser-side errors — an unhandled script error, or an HTMX response/network error
forwarded by `observability.js` — are captured by Glitchtip's browser SDK (Step 3),
never Loki. A failed HTMX swap usually appears **twice**: as the Django exception in
Loki and as the forwarded response error in Glitchtip. Start from the Django side; it
has the stack trace.

Look for the chain of log lines leading up to the error — the context lines above
the exception often contain the root cause (invalid input, failed external call, etc.).

---

## Step 5 — Check Grafana dashboards for metrics anomalies (staging / prod only)

> **Model:** opus · **MCP:** none

Open Grafana → Dashboards → <%PROJECT_NAME%> Backend.

Check in this order:

1. **Error rate panel** — `rate(django_http_requests_total{status=~"5.."}[5m])`
   — Did error rate spike at the incident time?

2. **Request latency panel** — P95 latency histogram
   — Is latency elevated? Points to slow queries or external calls.

3. **Database query rate** — `rate(django_db_execute_total[5m])`
   — A sudden spike often indicates an N+1 query or missing index.

4. **Cache hit/miss rate** — if cache miss rate jumped, a cold cache may have caused load.

Correlate the metric anomaly timestamp with the Loki log lines from Step 4.

---

## Step 6 — Write a regression test

> **↳ New agent:** `test-writer` · **Model:** opus · **MCP:** none

Once the root cause is identified:

1. Switch to `code/workflows/10-debug/STEPS.md` to write the fix and regression test
2. The regression test must fail before the fix and pass after
3. For staging/prod issues, file a bug report in `project-management/src/20-BUGS/`
   using the naming convention `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`

---

## Step 7 — Verify the fix in the target environment

> **Model:** opus · **MCP:** none

```bash
# After deploying the fix to staging:
docker compose -f code/src/docker/docker-compose.staging.yml pull
docker compose -f code/src/docker/docker-compose.staging.yml up -d

# Confirm no new errors in Glitchtip (allow 15 minutes)
# Confirm error rate in Grafana has returned to baseline
# Mark the Glitchtip issue as resolved
```

---

## Step 8 — Update Context and Documentation

**Hard gate — complete before closing this workflow.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
