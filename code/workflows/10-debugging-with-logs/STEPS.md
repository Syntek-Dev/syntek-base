# Workflow 10 — Steps: Debugging with Logs and Observability

Work top-to-bottom. Stop as soon as the root cause is found; do not continue further
down the stack unnecessarily.

---

## Step 1 — Reproduce locally (all environments)

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

Open Grafana → Explore → select the Loki datasource.

### Find errors around the time of the incident

```logql
{container="syntek-backend"}
  | json
  | level=~"ERROR|CRITICAL"
  | __error__=""
```

### Filter by time window (use the Glitchtip first-seen timestamp)

Set the Grafana time picker to ±5 minutes around the incident time.

### Narrow to a specific request path

```logql
{container="syntek-backend"}
  | json
  | message=~".*graphql.*"
  | level="ERROR"
```

### Find all logs for a specific Django logger

```logql
{container="syntek-backend"}
  | json
  | logger=~"apps.users.*"
```

Look for the chain of log lines leading up to the error — the context lines above
the exception often contain the root cause (invalid input, failed external call, etc.).

---

## Step 5 — Check Grafana dashboards for metrics anomalies (staging / prod only)

Open Grafana → Dashboards → Syntek Backend.

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

Once the root cause is identified:

1. Switch to `code/workflows/07-debug/STEPS.md` to write the fix and regression test
2. The regression test must fail before the fix and pass after
3. For staging/prod issues, file a bug report in `project-management/src/BUGS/`
   using the naming convention `BUG-<DESCRIPTOR>-DD-MM-YYYY.md`

---

## Step 7 — Verify the fix in the target environment

```bash
# After deploying the fix to staging:
docker compose -f code/src/docker/docker-compose.staging.yml pull
docker compose -f code/src/docker/docker-compose.staging.yml up -d

# Confirm no new errors in Glitchtip (allow 15 minutes)
# Confirm error rate in Grafana has returned to baseline
# Mark the Glitchtip issue as resolved
```
