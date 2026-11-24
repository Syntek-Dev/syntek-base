---
workflow: 09-debugging-with-logs
phase: verify
skills: [bugfix, stack-django]
model: opus
---

# Workflow 09 — Steps: Debugging with Logs and Observability

Work top-to-bottom. Stop as soon as the root cause is found, then hand the fix and its
regression test to `code/workflows/10-debug/`; do not continue further down the stack
unnecessarily.

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step      | Section                                                         |
| --------- | --------------------------------------------------------------- |
| All steps | **Guides in code/docs/** → LOGGING.md                           |
| 1–2       | **External — Framework & Language Docs → Backend** → Django 6.x |

---

## Step 1 — Reproduce locally (all environments)

> **Model:** opus · **MCP:** none

Before reaching for remote observability tools, try to reproduce the issue in dev.

```bash
# Bring the dev stack up
bash code/src/scripts/development/server.sh up

# Trigger the failing action (API call, form submission, etc.)
# Watch console output for immediate errors
bash code/src/scripts/development/logs.sh --service django --follow
```

If the issue only occurs in staging/prod, skip to Step 3.

---

## Step 2 — Read the local log file (dev only)

> **Model:** opus · **MCP:** none

Only dev writes `django.log` — test keeps no log file. Each line is one JSON object (wide mode:
every extra and the full traceback); uvicorn's own lines stay on the console in plain text. Open one
shell in the `django` container, then type each read inside it:

```bash
bash code/src/scripts/development/shell.sh
```

```bash
# Inside the shell — tail live
tail -f /workspace/code/src/logs/django.log

# Filter by level
grep -E "ERROR|WARNING|CRITICAL" /workspace/code/src/logs/django.log

# Filter by logger name (e.g. a specific app)
grep "apps.users" /workspace/code/src/logs/django.log

# Show last 100 lines
tail -n 100 /workspace/code/src/logs/django.log
```

If the file is too large to read, clear it as `code/src/logs/CONTEXT.md` → _Log rotation_
describes.

---

## Step 3 — Check <%ERROR_TRACKING%> (staging / prod only)

> **Model:** opus · **MCP:** none

1. Open the <%ERROR_TRACKING%> project for the relevant environment (staging or prod)
2. Filter issues by **first seen** date to find new regressions
3. Open the relevant issue — check:
   - Full stack trace
   - Request URL, method, and status code
   - Django user ID (if available and not PII)
   - Tags: environment, release version
4. Note the **issue ID** and **first occurrence timestamp** — use these to query
   <%LOG_AGGREGATOR%> next

If the exception is new, tag the <%ERROR_TRACKING%> issue as `investigating` before continuing.

---

The reference deployment runs Grafana Alloy shipping logs to Loki, queried with LogQL in
Grafana, and Prometheus for metrics (`how-to/src/PLATFORM-PROVIDERS.md`). The query
steps below, Steps 4 and 5, describe that deployment; a project that answered another
log aggregator or metrics stack adapts them to its own.

## Step 4 — Query Loki in Grafana (staging / prod only)

> **↳ New dispatch:** `general-purpose` · **Skill:** `bugfix` (`## Root cause` phase only) · **Model:** opus · **MCP:** none

Open Grafana → Explore → select the Loki datasource. Every selector reads the Compose service
label as the collector relabels it, `service_name` — never a container name
(`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`, _Log collection_).

### Find errors around the time of the incident

```logql
{service_name="django"}
  | json
  | level=~"ERROR|CRITICAL"
  | __error__=""
```

`| __error__=""` keeps every line Django's `LOGGING` emits, which is JSON. It drops the
process-server stream — see _The process-server stream_ below.

### Filter by time window (use the <%ERROR_TRACKING%> first-seen timestamp)

Set the Grafana time picker to ±5 minutes around the incident time.

### Narrow to a specific request path

```logql
{service_name="django"}
  | json
  | message=~".*api.*"
  | level="ERROR"
```

### Find all logs for a specific Django logger

Applies once a project declares that logger at `INFO`: root is `WARNING` in staging and
production, so nothing below `WARNING` reaches the stream today.

```logql
{service_name="django"}
  | json
  | logger=~"apps.users.*"
```

### Browser errors surface in <%ERROR_TRACKING%>, not <%LOG_AGGREGATOR%>

The template ships Django-only — one ASGI process family, no separate frontend
container — so there is no frontend log stream in <%LOG_AGGREGATOR%>. Server-side logs for pages,
HTMX partials, and Django Ninja endpoints all live in the single
`django` service stream (queried above); scope them to the app serving the
page or endpoint:

```logql
# Narrow to the app that rendered the failing page or partial
{service_name="django"}
  | json
  | logger=~"apps.marketing.*"
  | level=~"ERROR|CRITICAL"
```

Browser-side errors — an unhandled script error, or an HTMX response/network error
forwarded by `observability.js` — are captured by the browser SDK, which forwards them to
<%ERROR_TRACKING%> (Step 3), never to <%LOG_AGGREGATOR%>. A failed HTMX swap usually
appears **twice**: as the Django exception in <%LOG_AGGREGATOR%> and as the forwarded response
error in <%ERROR_TRACKING%>. Start from the Django side; it has the stack trace.

### The process-server stream — worker-level faults

Gunicorn's and Uvicorn's own error lines (`gunicorn.error`, `uvicorn.error`) and the boot output
are plain text on stderr with no `request_id`, outside Django's `LOGGING`. A worker crash, a
boot failure or a mid-stream "Exception in ASGI application" lands here, rarely with the
exception's message. Keep those lines with:

```logql
{service_name="django"} | json | __error__!=""
```

A traceback arrives **one entry per line** unless the collector runs a multiline stage.

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

Correlate the metric anomaly timestamp with the log lines from Step 4.

For a staging or production incident, file a bug report in `project-management/src/21-BUGS/`
using the naming convention `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Step 6 — Verify the fix in the target environment

> **Model:** opus · **MCP:** none

**Precondition: the fix is deployed to the target environment.** The deploy is owned by
`<%DEPLOY_REPO%>`, not this repository, and this step runs nothing to make it happen — see
`how-to/docs/FEATURE-DEPLOY.md`. Once the fix is live:

1. Confirm no new errors in <%ERROR_TRACKING%> — allow 30 minutes
2. Confirm the error rate on the Step 5 dashboards has returned to its pre-incident baseline
3. Mark the <%ERROR_TRACKING%> issue as resolved

---

## Step 7 — Update Context and Documentation

**Hard gate — complete before closing this workflow.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
