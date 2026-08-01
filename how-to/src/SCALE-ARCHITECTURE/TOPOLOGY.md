# Topology — What Runs, and Where State Lives

**Last Updated**: {{DATE}} | **Maintained By**: {{ORG_NAME}} (via `/scale-planning`)

> **Template skeleton.** Part of the {{PROJECT_NAME}} base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

The deployment/runtime topology as it bears on scaling: every process, whether it is
stateless (scales by adding copies) or stateful (scales by policy), and what holds
connections or state. Provisioning detail lives in the `{{DEPLOY_REPO}}` repo (handoff:
`how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md`) — this document only records what matters
for scale.

## Request flow

```text
Internet
  └─ Cloudflare Edge (TLS, CSP/headers, edge rate rule — all set at the edge, NOT this repo)
       └─ Cloudflare Tunnel (outbound-only; no inbound ports)
            └─ Nginx, bare-metal NixOS, :8081
                 └─ Django app container (ASGI: Gunicorn + Uvicorn workers, :8000)
                      ├─ Django-templated pages (django-components + HTMX + Alpine + token CSS)
                      ├─ Django Ninja JSON API (/api/...) — machine clients only;
                      │                                     DeviceToken Bearer (mobile/API)
                    Alongside: Celery worker · Celery beat (singleton) · optional Rust service(s)

Django app container (ASGI)
  ├─ postgres-proxy    (:5501) → PostgreSQL (loopback :5432)
  ├─ valkey-proxy      (:6501) → Valkey DB 0 (Celery broker + pub/sub + rate-limit store)
  ├─ valkey-proxy      (:6502) → Valkey DB 1 (Django cache)
  └─ objectstore-proxy (:9501) → SeaweedFS S3 (:8333) (private documents)
       (public media → Cloudinary, external)
```

Source: `code/src/docker/docker-compose.prod.yml`; dev-parity routing in
`code/src/docker/nginx/dev.conf`; connection plane in
`how-to/src/SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`. There is **one app process family**
(Django ASGI) — never a second frontend container to size or retire. Django admin is mounted
at a non-obvious path (`/control/`), never `/admin/`.

## Process inventory

> Every count, default, and memory figure below is a placeholder — **TBD — regenerate via
> `/scale-planning` against this project's live code**.

| Process                  | Where                                                           | Stateless?                         | Scale mechanism                                                                       | Holds                                                                                         |
| ------------------------ | --------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Cloudflare Edge + Tunnel | Cloudflare / bare-metal `cloudflared`                           | Yes                                | Cloudflare's problem                                                                  | TLS termination, edge rate rule                                                               |
| Nginx                    | Bare-metal NixOS, :8081                                         | Yes                                | Config only (worker_connections)                                                      | Client keep-alive conns; proxy buffers; `/static/` cache headers                              |
| Django app               | Docker; Gunicorn + Uvicorn workers (ASGI)                       | Yes — by design                    | `GUNICORN_WORKERS` env (default **TBD — regenerate via `/scale-planning`**)           | **Live SSE connections** (see below); per-request state only                                  |
| Celery worker            | Docker; same image                                              | Yes                                | `CELERY_CONCURRENCY` env + `--max-memory-per-child` (**TBD — regenerate**)            | In-flight tasks (broker holds the queue)                                                      |
| Celery beat              | Docker; same image                                              | **Singleton**                      | Exactly one instance — the schedule ticker must not be duplicated                     | Schedule file (ephemeral, safe to lose)                                                       |
| Rust service(s)          | Docker/sidecar (optional, project-defined)                      | Project-defined                    | Project-defined — e.g. a performance-critical worker/sidecar (**TBD — regenerate**)   | **TBD — regenerate via `/scale-planning`**                                                    |
| PostgreSQL               | Bare-metal NixOS, loopback; via postgres-proxy :5501            | **Stateful**                       | The project's Postgres horizontal-scaling ADR phases only (primary → replica → shard) | All durable data; RLS; connections (see pooling)                                              |
| Valkey                   | Bare-metal NixOS, loopback; proxies :6501 (DB 0) / :6502 (DB 1) | **Stateful** (but reconstructible) | Single instance; multi-node is later territory in the project's cache-posture ADR     | Broker queue, pub/sub channels, cache, session cache tier, presence keys, rate-limit counters |
| SeaweedFS S3             | Server-side S3 object store                                     | **Stateful**                       | Engine-neutral boto3 seam; a geo-scale engine is the named future trigger (**TBD**)   | Private documents, attachments (non-media)                                                    |
| Cloudinary               | External (public media)                                         | Yes (external)                     | n/a — provider-managed                                                                | Public media                                                                                  |
| Mail relay + API         | Bare-metal relay + transactional API                            | Yes                                | n/a                                                                                   | Outbound mail only (`noreply@{{PRIMARY_DOMAIN}}`)                                             |

## Where connections and state actually live

**SSE streams — the one place the "stateless backend" holds long-lived connections.**
An authenticated real-time surface implements delivery as an async per-user SSE view,
Channels-free: each connected user holds an open HTTP response on a Uvicorn worker,
subscribed via `redis.asyncio` to their own Valkey pub/sub channel (DB 0). Because fan-out
goes through Valkey — not process memory — **any worker can hold any user's stream**, so
adding workers adds SSE capacity linearly. Presence state (per-user sorted sets on a short
TTL — **TBD — regenerate via `/scale-planning`**) also lives in Valkey, reaped by a Celery-beat
job. The exact surfaces (channel names, key prefixes, TTLs, reaper cadence) are placeholders —
**reconcile against this project's live code**.

**Sessions.** `SESSION_ENGINE = cached_db` — durable rows in Postgres, read-through Valkey.
All web surfaces are unified onto session cookies (per the project's session-strategy ADR);
mobile/API uses DeviceToken Bearer via Django Ninja. No session affinity is needed anywhere.

**Database connections.** Django holds persistent connections (`conn_max_age`,
`conn_health_checks=True`), so worst-case direct connections ≈ (Gunicorn workers + Celery
concurrency + beat) per container — all placeholder figures, **TBD — regenerate via
`/scale-planning`**. The project's Postgres horizontal-scaling ADR names a connection pooler
(e.g. PgBouncer) as the Phase-0 baseline in front of the single primary; whether it is
deployed is a readiness item (see `READINESS.md`).

**Caches.** Django cache = django-valkey on DB 1, `KEY_PREFIX "{{ORG_SLUG}}"`, default TTL
**TBD — regenerate**, `IGNORE_EXCEPTIONS=True` so a Valkey outage degrades to misses rather
than errors. Any full-page cache is version-keyed in the same store. `maxmemory` / eviction
policy are Valkey NixOS config — deploy-repo knobs, owned by the project's cache-posture ADR.

**Static and media.** WhiteNoise serves hashed, pre-compressed static from the app container
(nginx adds immutable cache headers); public media is Cloudinary (external); private files are
SeaweedFS via short-TTL presigned URLs. None of these contend with the request path at current
scale.

## What is deliberately not here

TLS, CSP and security headers (edge), the Cloudflare edge rate rule, backup topology, mail,
observability shipping (metrics/logs remote-write), and VPN/edge access control — all real,
all server-side, all owned by `SERVER-ARCHITECTURE/` and the deploy repo.
