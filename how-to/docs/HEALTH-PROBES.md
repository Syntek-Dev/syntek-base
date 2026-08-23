---
type: guide
skills: [runbook, logging]
model: opus
---

# Health Probes — Diagnosing a Red Probe

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the operator's side of `code/docs/logging/HEALTH-CONTRACT.md`

## Purpose

Work out why `/health/ready/` has gone red, or why a container is restart-looping on its
`HEALTHCHECK`, and get it back. Reach for this when the status page turns, when an orchestrator
takes the app out of service, or when a container will not stay up.

**This is the operator's half.** What the endpoints publish and what the deploy repository must
provision are decided in `code/docs/logging/HEALTH-CONTRACT.md`, not here.

## Prerequisites

- The dev stack running, or shell access to the environment that is red
- The URL the stack actually answers on — **never quote it from memory**;
  `bash code/src/scripts/development/server.sh status` prints the live port binding
- For anything beyond dev: access to the deploy repository's probe output

Everything below runs through `code/src/scripts/development/health.sh`, which reads both probes
and reports what the answer means. It never restarts anything — diagnosis only.

## Read the two probes correctly before you diagnose

They answer different questions, and confusing them is the most common wasted hour.

| Probe                | Answers            | Touches            | Healthy response                    |
| -------------------- | ------------------ | ------------------ | ----------------------------------- |
| `GET /health/`       | Is the process up? | **Nothing**        | `200` · body `ok`                   |
| `GET /health/ready/` | Can it serve?      | PostgreSQL, Valkey | `200` · `{"status": "operational"}` |

`/health/ready/` publishes exactly three words, and **only `down` is a `503`**:

| Word          | Code  | Means                                                    |
| ------------- | ----- | -------------------------------------------------------- |
| `operational` | `200` | Every dependency answered                                |
| `degraded`    | `200` | Valkey failed; the site is still serving correctly       |
| `down`        | `503` | PostgreSQL failed; no request reaching app code can work |

**A `degraded` reading is a `200` on purpose.** Valkey runs with `IGNORE_EXCEPTIONS`, so a cache
outage costs latency rather than correctness — failing the whole endpoint for it would take the
public status page red for something no user can see.

## Steps

### 1 — Establish which probe is actually red

```bash
bash code/src/scripts/development/health.sh
```

Expected on a healthy stack:

```text
▸ health.sh — http://localhost:81

  ✓ liveness   200  — process up
  ✓ readiness  200  — operational
```

Exit code `0` means operational; `1` means degraded or down. **If you have just been alerted,
use `--watch` instead** — a single probe can be reporting a memoised verdict from before the
fault, and watching across one cache TTL is the only honest reading:

```bash
bash code/src/scripts/development/health.sh --watch
```

Branch on what you see:

| Observation                                 | Go to  |
| ------------------------------------------- | ------ |
| Liveness fails, or does not answer at all   | Step 2 |
| Liveness `200`, readiness `down`/`degraded` | Step 3 |
| Both fine, but the status page is red       | Step 4 |

### 2 — Liveness is red: the process, not a dependency

`/health/` touches no dependency, so a failure here is never a database or cache problem. It is
the process, the URLconf, or the route in front of it.

```bash
bash code/src/scripts/development/server.sh status
bash code/src/scripts/development/logs.sh --service django
```

Success looks like all four containers `Up` and `(healthy)`. A `django` container cycling
between `Up` and `Restarting` is the restart loop this step exists for — read the log for the
exception raised at startup, which is almost always a settings or import error.

> **Never add a dependency check to `/health/`.** A container restarted because PostgreSQL
> blinked turns one outage into a rolling one. Taking a pod out of service is readiness's job,
> and it does that without killing anything.

### 3 — Readiness is red: find which dependency

**The body will not tell you which one.** It carries the overall word and nothing else, because
the endpoint is unauthenticated and a component breakdown is reconnaissance. Read the word, then
infer the dependency from the table above and confirm it directly:

```bash
bash code/src/scripts/development/server.sh status
bash code/src/scripts/database/migrate.sh check
```

- `down` → PostgreSQL. `server.sh status` shows `db` unhealthy or absent; `migrate.sh check`
  cannot connect. Recovery is Step 5.
- `degraded` → Valkey. `server.sh status` shows `cache` unhealthy or absent. The site is serving;
  this is not an emergency, and it must not be treated as one.

### 4 — Both probes fine, status page still red

The app is answering, so the fault is between the probe and the app: the edge, DNS, TLS, or the
probe's own configuration. That is the deploy repository's half of the contract — see
`code/docs/logging/HEALTH-CONTRACT.md` → _What the deploy repo must provision_ and
`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`.

Before escalating, confirm you probed the same URL the monitor does. A probe pointed at a stale
hostname reports an outage that does not exist.

### 5 — Recover the dependency

```bash
bash code/src/scripts/development/server.sh restart --service db
bash code/src/scripts/development/server.sh restart --service cache
```

Then re-run Step 1. **Allow up to `HEALTH_CACHE_TTL_SECONDS` (default 15) for a `down` reading to
clear** — see Failure modes.

## Failure modes

**Readiness can miss a dependency outage entirely, and this is the failure mode to internalise.**
The verdict is memoised for `HEALTH_CACHE_TTL_SECONDS` (default 15, set in
`code/src/django/config/settings/base.py`)
so external probing cannot stampede the database. An outage that starts and ends inside one TTL
is therefore never observed.

Measured on the dev stack, not inferred. Stopping PostgreSQL with
`server.sh stop --service db` and polling readiness every four seconds:

```text
t+ 4s  {"status": "operational"} [200]
t+ 8s  {"status": "operational"} [200]
t+12s  {"status": "operational"} [200]
t+16s  {"status": "operational"} [200]
t+20s  {"status": "down"}        [503]
```

**The database was down for the whole of that window.** Readiness reported `operational` for
the first sixteen seconds of a real outage. Liveness stayed `200` throughout, which is correct —
a database fault must never restart the container.

A `restart --service db` returns the service faster than that, so the outage is never observed
at all: the same poll across a full restart returned `operational` on every single sample while
`server.sh status` afterwards showed the container had genuinely gone (`Up 38 seconds`).

The operational consequences, both directions:

- A `200` taken immediately after an alert is **not** proof the alert was wrong — the memo may
  predate the failure.
- A `down` reading can persist for up to one TTL **after** PostgreSQL is back. Wait 15 seconds
  before concluding the recovery failed.
- **Absence of a red reading is not evidence the dependency stayed up.** Check the container's
  own uptime in `server.sh status`; a low value means it restarted regardless of what the probe
  said.

**The masking is weaker for a cache outage, and the asymmetry is deliberate.** The memo lives in
Valkey, so when Valkey is down the read is a miss and readiness re-probes on every request
(`apps/health/views.py:62-67`). A sustained cache fault surfaces immediately; a sustained
database fault can lag by one TTL. Neither survives an outage shorter than the probe interval.

**To rehearse a red probe, stop one service — do not restart it.** `server.sh stop --service`
leaves the container and network in place and holds the dependency away until you give it back,
which is the only way through this script to see either red state:

```bash
bash code/src/scripts/development/server.sh stop --service cache   # → degraded, 200
bash code/src/scripts/development/server.sh stop --service db      # → down, 503
bash code/src/scripts/development/server.sh up --service cache     # give it back
```

Observed exactly that way: `degraded` appears **immediately and on every poll** when Valkey is
stopped (the memo is in Valkey, so it cannot mask its own absence), while `down` lags one TTL
as above. The same three words are asserted over the wire in
`apps/health/tests/test_endpoints.py:85-102`, so a change to them fails a test rather than only
a probe.

**`405` from either endpoint** means a write method was used. Both are `@require_safe`; only
`GET` and `HEAD` are accepted.

## Rollback

Nothing in this guide changes state except `server.sh restart --service …`, which is not
destructive — it stops and starts one container and touches no volume or data. There is nothing
to roll back.

If you reached Step 5 and the dependency will not come up, do **not** escalate to
`server.sh down --volumes`: that wipes the database. Route the failure through
`how-to/workflows/08-debugging/` instead.

## Verification

Prove recovery independently of the probes you were just reading:

```bash
bash code/src/scripts/development/server.sh status
bash code/src/scripts/database/migrate.sh check
bash code/src/scripts/tests/backend.sh
```

All four containers `(healthy)`, no pending migrations, and a green backend suite together mean
the dependencies are genuinely answering — not merely that a memoised verdict has not yet
expired.

## Cross-references

- `code/docs/logging/HEALTH-CONTRACT.md` — the contract: endpoint shapes, status codes, and what
  the deploy repository provisions against them
- `code/src/django/apps/health/CONTEXT.md` — the app implementing it, and what each module is for
- `how-to/docs/INCIDENT-PRACTICE.md` — when a red probe becomes a declared incident
- `how-to/workflows/08-debugging/` — when the fault is environmental rather than a dependency

_Part of the `how-to/docs/` documentation family._
