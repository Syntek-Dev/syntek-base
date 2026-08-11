# Compute Allocation — Assigned Compute + Buffer

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

> **Template skeleton.** Part of the <%PROJECT_NAME%> base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

The mapping from the sizing envelope (owned by the sibling
`how-to/src/SCALE-ARCHITECTURE/`) to the **assigned compute** the deploy repo
provisions, with the headroom buffer applied. This file owns the buffer policy's
expression; the phase-gate mechanics stay in the project's Postgres
horizontal-scaling ADR and `code/docs/architecture/CORE-AND-SCALING.md` —
referenced, never duplicated.

---

## The buffer policy (locked)

> **Assigned compute ≈ current-tier peak load × (1 + headroom), sized so that
> normal peak stays UNDER the project's Postgres horizontal-scaling ADR gate
> triggers (CPU/IO 70% sustained). A gate-trip is the signal to move up a tier —
> not a provisioning failure.**

What this means in practice:

- The envelope in `SCALE-ARCHITECTURE/` measures what the app needs at _current_
  peak. This file never provisions the bare measurement — always measurement plus
  margin, so ordinary variance (a traffic spike, a deploy warm-up, a Celery
  backlog drain) does not brush the gate thresholds.
- The buffer is calibrated against the gates, not against growth guesses: if
  measured peak runs the primary well under the 70% Phase 2 gate — its baseline is
  **TBD — regenerate via `/scale-planning` against this project's live code** —
  normal operation cannot sustain-trip that gate, so when the gate _does_ trip it
  is a genuine tier signal (the project's Postgres horizontal-scaling ADR phase
  table).
- **Anti-forecast** (the project's Postgres horizontal-scaling ADR: "do not
  pre-emptively add infrastructure"; `code/docs/PERFORMANCE.md` rules 1–2): no
  compute is allocated for a hypothesised future tier. The next tier's
  provisioning happens when its gate trips, via `/scale-planning`.
- The deploy repo may rely on this rule: values it reads from this file already
  include the buffer. It must not add its own second margin on top.

## Phase-gate keying (reference — the Postgres horizontal-scaling ADR)

- **Source:** the project's Postgres horizontal-scaling ADR and
  `code/docs/architecture/CORE-AND-SCALING.md`, which own the gate mechanics. This
  table is a reference copy of the triggers, never their definition — a divergence
  here is a defect in this file.

| Phase | Trigger (observed, sustained)              | Architecture change                                  |
| ----- | ------------------------------------------ | ---------------------------------------------------- |
| **0** | Baseline (current)                         | Single Postgres primary + PgBouncer                  |
| **1** | Read latency p95 > 50 ms                   | Streaming replica + `using('readonly')` router       |
| **2** | Primary CPU/IO > 70%; Phase 1 insufficient | Citus coordinator + ≥ 2 workers, hash on `tenant_id` |

Full mechanics, migration discipline, and trade-offs: the project's Postgres
horizontal-scaling ADR + `code/docs/architecture/CORE-AND-SCALING.md`. The gates
are _measured_ via the Prometheus scrape contract (`EDGE-REQUIREMENTS.md`) — the
observability wiring is therefore a precondition of the whole gating model.

## Current tier — the host

The current tier is **<%SERVER_TIER%>** — the bare-metal host. It runs the shared
bare-metal services (Nginx, PostgreSQL, Valkey, <%OBJECT_STORE%>) alongside the Docker app
containers. The concrete host spec (CPU cores/threads, RAM, NVMe layout, network)
is a placeholder — **TBD — regenerate via `/scale-planning` against this project's
live code and the deploy repo's host definition**. Size the deployment so a single
<%PROJECT_NAME%> stack retains host-level headroom by construction; the deploy
repo's own sizing table records how many medium stacks the tier carries (TBD).

## The connection plane — how containers reach the bare-metal services

- **Source:** this repo's Compose files and the connection strings they set
  (`code/src/docker/`); the provider-side interfaces each proxy fronts are recorded in
  `how-to/src/PLATFORM-PROVIDERS.md`. **Of the app env vars in the table below, only
  `DATABASE_URL` and `REDIS_URL` are set by the shipped Compose files and
  `.env.*.example` templates today** — `CACHE_URL`, `CELERY_BROKER_URL` and
  `OBJECT_STORE_ENDPOINT_URL` are this contract's design intent, named here so that the
  build-side change introducing them and the deploy side agree on one spelling.

The app containers sit on the `<%PROJECT_SLUG%>-net` Docker bridge and cannot reach
the host's loopback, so every stateful bare-metal service is consumed through a
bare-metal proxy the bridge can reach. The app's connection strings therefore
always point at `<bridge-gw>:<proxyPort>` — never at a service port directly:

| App connects to      | Via proxy (port convention)                           | Backing service (loopback) | App env var                       |
| -------------------- | ----------------------------------------------------- | -------------------------- | --------------------------------- |
| PostgreSQL 18        | `postgres-proxy` **:5501**                            | `postgresql :5432`         | `DATABASE_URL`                    |
| Valkey broker (DB 0) | `valkey-proxy` **:6501**                              | `valkey :6379`, DB 0       | `REDIS_URL` / `CELERY_BROKER_URL` |
| Valkey cache (DB 1)  | `valkey-proxy` **:6502**                              | `valkey :6379`, DB 1       | `CACHE_URL`                       |
| <%OBJECT_STORE%> S3  | `objectstore-proxy` **:9501** (bucket isolation + AV) | S3 gateway `:8333`         | `OBJECT_STORE_ENDPOINT_URL`       |

- `<bridge-gw>` is discovered post-boot via
  `docker network inspect <%PROJECT_SLUG%>-net` (typically `172.16.x.1`) and baked
  into the app-env plane (`NIXOS-HANDOFF.md`).
- **Engine-neutral object store.** The S3 gateway is consumed via boto3 — the app knows
  only the `OBJECT_STORE_*` variables, never a specific vendor, so swapping the backing
  engine changes nothing app-side. **Not wired at baseline:**
  `code/src/docker/.env.prod.example` declares no `OBJECT_STORE_*` key (its only
  infrastructure keys are `DATABASE_URL` and `REDIS_URL`), and no S3 client is
  configured under `code/src/django/config/settings/`.
- The Valkey DB split is a locked convention: **DB 0 = Celery broker + pub/sub +
  rate-limit store; DB 1 = Django cache**. **Not wired at baseline either:**
  `.env.prod.example` carries a single `REDIS_URL` on DB 0 and no `CACHE_URL`, and
  `config/settings/base.py` points `CACHES` at that same `REDIS_URL` — so cache and
  broker share DB 0 until the second variable is introduced. Per-app ACL passwords
  come from the `<%PROJECT_SLUG%>-env.age` secret (`NIXOS-HANDOFF.md`).
- An optional `security-proxy` layer (header stripping, per-app rate limits) can be
  interposed between Nginx and the containers (the deploy repo's `security-proxy`
  module); enabling it moves the Nginx upstream ports but changes nothing in this
  contract.

## Assigned compute per process (Phase 0 baseline)

- **Source:** this repo's Compose files and container entrypoints
  (`code/src/docker/`), tuned per environment through the app-env plane. The Gunicorn
  worker class is not a preference here — `code/docs/mcp-server/MOUNTING.md` fixes it.

The provisioning defaults below are the **current assigned compute** — they live in
this repo's compose files/entrypoints and are tuned per environment via env vars in
`/etc/<%ORG_SLUG%>/.env.<env>` (never by editing images). Every concrete figure is a
placeholder: **TBD — regenerate via `/scale-planning` against this project's live
code** (the compose files and entrypoints below are where the real values live):

| Process                        | Assigned (prod default)                                                                                                                                          | Tunable via                                                       | Source                                                                    |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Gunicorn (ASGI, UvicornWorker) | **TBD** workers, timeout/max-requests TBD                                                                                                                        | `GUNICORN_WORKERS` / `GUNICORN_TIMEOUT` / `GUNICORN_MAX_REQUESTS` | `code/src/docker/django/entrypoint.prod.sh`; `docker-compose.prod.yml`    |
| Gunicorn (staging)             | **TBD** workers (same knobs)                                                                                                                                     | as above                                                          | `entrypoint.staging.sh`                                                   |
| Celery worker                  | concurrency **TBD**, max-memory-per-child **TBD**                                                                                                                | `CELERY_CONCURRENCY` / `CELERY_MAX_MEMORY`                        | none yet — no `worker` service ships (see the note below)                 |
| Celery beat                    | 1 process (scheduler only)                                                                                                                                       | —                                                                 | none yet — no `beat` service ships (see the note below)                   |
| Optional Rust service(s)       | project-defined (e.g. a performance-critical worker/sidecar) — **TBD** if this project defines one                                                               | project-defined env                                               | project compose (only if present)                                         |
| PostgreSQL 18                  | Bare-metal; the Postgres horizontal-scaling ADR Phase 0 names **PgBouncer** as the pooler — reconcile the actual pooler module against the deploy repo (**TBD**) | deploy repo `custom.database.postgres`                            | deploy repo `database/postgres` module (one DB/role per app, `enableRls`) |
| Valkey                         | Bare-metal; DB 0 broker / DB 1 cache, per-app ACL                                                                                                                | deploy repo `custom.valkey`                                       | deploy repo `valkey` module; connection plane above                       |
| <%OBJECT_STORE%>               | Bare-metal, nftables-gated (the project's object-store ADR)                                                                                                      | deploy repo `custom.objectStore`                                  | deploy repo README + object-store module                                  |
| cloudflared + Nginx            | Bare-metal (~**TBD** MB/tunnel)                                                                                                                                  | deploy repo modules                                               | deploy repo README                                                        |

**Celery is not in the shipped Compose stack.** `docker-compose.prod.yml` declares one
service — `django` — and there is no `worker` container, no `beat` container, and no
`CELERY_*` variable in any `.env.*.example`. The two Celery rows above state what this
contract requires **once background work exists**; they are not descriptions of a
running service. The same-change rule applies when it lands: the service, its env keys
and these rows move together (`code/docs/architecture/BUILD-OPERATE-SEAM.md`).

**Long-lived-connection note:** any Server-Sent Events / streaming endpoints this
project defines (e.g. an authenticated-app live feed or an admin/staff stream) hold
long-lived connections on the Uvicorn workers. Concurrent-stream capacity is a
function of worker count × per-worker async connection handling (not 1:1) — this is
the most likely first pressure point on `GUNICORN_WORKERS` and the envelope input to
watch in `SCALE-ARCHITECTURE/`. Reconcile the actual streaming endpoints against
this project's surfaces (public/marketing · authenticated app · admin/staff) —
**TBD — regenerate via `/scale-planning` against this project's live code**.

## Headroom worked expression

With the buffer rule, the tuning loop the deploy repo follows is:

1. Read current peak utilisation from the Prometheus jobs (backend metrics, node
   exporter) — never provision on intuition (`PERFORMANCE.md` rule 1).
2. If normal peak pushes any process past ~⅔ of the point where the host would
   sustain 70% CPU/IO, raise that process's env-var allocation (more Gunicorn
   workers, higher Celery concurrency) _within the current tier_ — the current
   tier has host headroom for this by design.
3. If raising in-tier allocation cannot keep normal peak under the gate thresholds,
   that _is_ the gate evidence — trigger the project's Postgres horizontal-scaling
   ADR phase move via `/scale-planning`, do not keep inflating the buffer.

## Targets

**No target-user figure is ratified** — set it via `/scale-planning` grilling; do
not fabricate one.

| Quantity                          | Value                                                                                             |
| --------------------------------- | ------------------------------------------------------------------------------------------------- |
| Target concurrent users / tenants | **TBD — set via `/scale-planning` grilling**                                                      |
| Peak RPS envelope (per surface)   | **TBD** — measured input from `SCALE-ARCHITECTURE/`                                               |
| Headroom multiplier (numeric)     | **TBD** — derived from the first measured envelope; the _rule_ above is locked, the number is not |

When a target is settled it is recorded here and in `SCALE-ARCHITECTURE/`, and the
assigned-compute table gains a per-value "envelope × buffer = assigned" column.

## Change control

- Assigned-compute changes are env-var changes on the server (`/etc/<%ORG_SLUG%>/.env.*`)
  plus a container restart — no image rebuild (`docker-compose.prod.yml`).
- A _tier_ change (Phase 1 replica, Phase 2 Citus, or a host upgrade to a larger
  tier) is a decision gated by the project's Postgres horizontal-scaling ADR,
  opened with `/scale-planning` grilling and recorded in `SCALE-ARCHITECTURE/`
  first, then expressed here, then implemented in the deploy repo.
