---
type: guide
agent: logging
skills: [stack-django]
model: opus
---

# Health Monitoring Contract

**Last Updated:** <%DATE%> **Maintained By:** <%ORG_NAME%> **Language:** British English (en_GB)
**Claude Model:** opus — Contract between the app repo (endpoints) and the NixOS deploy repo (Gatus, scrape)

The app exposes health/metrics endpoints; the deployment server (the NixOS deploy repo,
`<%DEPLOY_REPO%>`) consumes them to drive Gatus (public status page) and Prometheus
(metrics). This is the same app-exposes / server-provisions split used for `/metrics/`. This doc is
the single source of truth for **what the app exposes** and **what the server must provision**.

---

## Endpoints the application exposes

| Endpoint             | Auth     | Body                                       | Codes       | Purpose                                 |
| -------------------- | -------- | ------------------------------------------ | ----------- | --------------------------------------- |
| `GET /health/`       | public   | `ok` (text)                                | `200`       | Liveness — process up, no dep checks    |
| `GET /health/ready/` | public   | `{"status":"operational\|degraded\|down"}` | `200`/`503` | Readiness — aggregate dependency health |
| `GET /metrics/`      | loopback | Prometheus text exposition                 | `200`       | Backend metrics (django-prometheus)     |

`/health/ready/` is dependency-aware (PostgreSQL + Valkey + Django Ninja API + curated pages) and
short-TTL cached (`HEALTH_CACHE_TTL_SECONDS`, default 15s), so external probing cannot stampede the
database/cache. It deliberately exposes **overall status only** — no component breakdown, versions, or
hostnames. `503` is returned only for `down`; `degraded` still returns `200`.

Detailed per-component health (database, cache, API, pages, edge, and the observability tools) is
**admin-only** — surfaced in the `/admin/` Health tab and backed by a session-authed Django Ninja
endpoint that requires the `health.view` permission.

---

## What the deploy repo must provision (Phase B)

All of the following live in `<%DEPLOY_REPO%>`, not in this repo.

### 1. Gatus service + public status page (`status.<%PRIMARY_DOMAIN%>`)

- New module `modules/gatus/default.nix` running `services.gatus` (localhost-only), state
  on a ZFS dataset (e.g. `/tank/data/gatus`).
- Add `status.<%PRIMARY_DOMAIN%>` as a `custom.cloudflared.tunnels.tunnels` entry + a
  `custom.nginx.apps` vhost → the Gatus listen port, following the established hostname pattern.
- Create the tunnel token: `agenix -e secrets/cloudflared-status-token.age`.

Reference Gatus config (config-as-data — adapt hostnames per environment):

```yaml
endpoints:
  - name: Website
    group: { { PROJECT_NAME } }
    url: "https://<%PRIMARY_DOMAIN%>/"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
      - "[RESPONSE_TIME] < 2000"
  - name: API
    group: { { PROJECT_NAME } }
    url: "https://<%PRIMARY_DOMAIN%>/health/"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
  - name: Readiness
    group: { { PROJECT_NAME } }
    url: "https://<%PRIMARY_DOMAIN%>/health/ready/"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
      - "[BODY].status == operational"
```

> The Readiness check keys on both the status code and the JSON `status` field. A `degraded` site
> still returns `200`, so the `[BODY].status == operational` condition is what flags degradation on
> the public status page; `down` additionally fails `[STATUS] == 200` (the app returns `503`).

### 2. Prometheus app scrape jobs

`modules/prometheus/default.nix` scrapes `node` + `zfs`; add the app job (closing the
metrics-deploy gap):

```nix
scrapeConfigs = [
  # … existing node + zfs …
  { job_name = "<%ORG_SLUG%>-web"; metrics_path = "/metrics/"; static_configs = [ { targets = [ "127.0.0.1:8000" ]; labels = { service = "web"; }; } ]; }
];
```

The app is a single Django ASGI process family, so there is no separate frontend scrape target.

---

## Wiring the admin Health tab to the live tools (optional)

The admin Health tab surfaces each observability tool's own health when its status URL is
configured via env var (otherwise it reports `not_configured`, the default in local dev). To light
these up in staging/production, set in `.env.staging` / `.env.production`:

| Env var                 | Points at                                                             |
| ----------------------- | --------------------------------------------------------------------- |
| `PROMETHEUS_STATUS_URL` | Prometheus `/-/healthy`                                               |
| `LOKI_STATUS_URL`       | Loki `/ready`                                                         |
| `ALLOY_STATUS_URL`      | Grafana Alloy `/-/ready`                                              |
| `GATUS_STATUS_URL`      | Gatus `/health`                                                       |
| `GLITCHTIP_BASE_URL`    | GlitchTip instance root (already used by the observability dashboard) |

`HEALTH_SITE_BASE_URL` / `HEALTH_PAGE_PATHS` tune the curated page probes (defaults target the
internal Django app service `web:8000` and `/,/blog,/portal,/admin/login`).

---

## Cross-references

- `code/src/django/apps/health/CONTEXT.md` — the health app
- `code/docs/logging/OBSERVABILITY.md` — the broader observability stack
- `how-to/src/SERVER-ARCHITECTURE/` — the broader edge/compute contract this health/metrics contract is one part of; the endpoints here are themselves a SERVER-ARCHITECTURE edge requirement
- `how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md` — the deploy-repo handoff that consumes these endpoints alongside the edge contract
