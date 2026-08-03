# Deployment — From Laptop to Server

**Last Updated**: 02/08/2026

How a generated project reaches a server, and the boundary between this repository and the one
that provisions the host.

> **Any hosting provider works.** The application is an ordinary Docker Compose deployable and
> will run on any Linux host with Docker — cloud VM, VPS, managed container platform or bare
> metal. What follows describes **Syntek's** target: Hetzner bare metal running NixOS, fronted by
> Cloudflare with a CF Tunnel. Deploy elsewhere and the contract in
> `how-to/src/SERVER-ARCHITECTURE/` still holds — it names requirements, not products — but the
> provisioning specifics below will need adjusting. `02-STACK.md` sets out exactly what travels
> and what does not.

---

## The separation

**This repository specifies. The deploy repository implements.**

```text
  your project repo                    the NixOS deploy repo
  ─────────────────                    ─────────────────────
  application code            ──────▶  host configuration
  Dockerfiles, Compose                 Nginx, TLS, CF Tunnel
  what the server must provide ──────▶ what the server does provide
  (SERVER-ARCHITECTURE/)               (NixOS modules, secrets)
```

`how-to/src/SERVER-ARCHITECTURE/` is the **contract**: the processes, ports, volumes, environment
variables, edge behaviour and compute allocation the host must supply. The deploy repository —
your `DEPLOY_REPO` answer, conventionally `<project-slug>-nixos-client-deployment` — consumes it.

This is why **security headers, TLS and CSP are never set in this repo**. They belong at the edge.
Setting them in two places means they eventually disagree, and the one that wins is the one you
did not check.

## Sizing first

Before provisioning anything:

```text
/scale-planning
```

The `scale-planner` agent audits readiness and produces a sizing envelope keyed to the scaling
phase-gates, writing two living snapshots:

| Snapshot                          | Answers                                                 |
| --------------------------------- | ------------------------------------------------------- |
| `how-to/src/SCALE-ARCHITECTURE/`  | How the app scales — load profiles, readiness, envelope |
| `how-to/src/SERVER-ARCHITECTURE/` | What the server must provide, with buffer               |

**Both ship as skeletons.** Every project-specific figure carries a
`TBD — regenerate via /scale-planning` marker until you run it. They are not meaningful before
that, and the deploy repository has nothing to consume.

Record the resulting host tier in your `SERVER_TIER` answer.

## Environments

| Environment | Compose file                 | Runs where              | Database and cache |
| ----------- | ---------------------------- | ----------------------- | ------------------ |
| `dev`       | `docker-compose.dev.yml`     | your machine            | in Compose         |
| `test`      | `docker-compose.test.yml`    | CI and your machine     | in Compose         |
| `staging`   | `docker-compose.staging.yml` | GitHub Actions → server | server-managed     |
| `prod`      | `docker-compose.prod.yml`    | GitHub Actions → server | server-managed     |

Postgres and Valkey run **in Compose only for dev and test**. On staging and production they are
managed by the host, because a database in a disposable container is a database you will
eventually dispose of.

## The promotion chain

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

Every branch travels the full order; no stage is skipped. `staging` runs acceptance tests;
`main` is production and takes client-accepted releases only.

## Images

Staging and production images are built by GitHub Actions and pushed to GHCR:

```text
ghcr.io/<org-slug>/<project-slug>/django:<tag>
```

Tags are `staging`, `prod`, or a git SHA. The server pulls by `IMAGE_TAG` from its environment.

Every Dockerfile does `COPY pyproject.toml uv.lock ./` and builds with `uv sync --frozen` — so
**`uv.lock` must be committed** or the build fails. This is the single most common deployment
failure on a freshly generated project.

## Secrets

Never in the repository. Locally they live in gitignored `code/src/docker/.env.*` files generated
by `install.sh`. On the server they are age-encrypted and placed at `/etc/<org-slug>/.env.<env>`
by the deploy repository.

Only `.env.*.example` templates are tracked.

## Releasing

```text
Cut a release.
```

`project-management/workflows/23-release/` via the `release` orchestrator: version bump,
`CHANGELOG.md`, `RELEASES.md`, `VERSION-HISTORY.md`, tag, deploy. Versioning is single-track
semver — rules in `project-management/docs/VERSIONING-GUIDE.md`.

Do not bump versions by hand mid-feature; the `version` agent owns it.

## Observability

Configured for staging and production:

| Tool       | Role                                    |
| ---------- | --------------------------------------- |
| Glitchtip  | Exception tracking (Sentry-compatible)  |
| Alloy      | Ships host logs to Loki                 |
| Loki       | Log aggregation                         |
| Prometheus | Scrapes Django metrics from `/metrics/` |
| Grafana    | Dashboards over Loki and Prometheus     |

Guide: `code/docs/LOGGING.md`.

## First deployment checklist

1. `/scale-planning` run, both snapshots regenerated
2. `SERVER_TIER` recorded and a host provisioned to match
3. Deploy repository forked and pointed at `SERVER-ARCHITECTURE/`
4. DNS at Cloudflare, CF Tunnel configured
5. `uv.lock` committed
6. `.env.staging` and `.env.production` populated on the server, age-encrypted
7. GHCR credentials available to Actions
8. `DEBUG=False` verified outside local
9. `CORS_ALLOWED_ORIGINS` an explicit allowlist
10. Django admin confirmed at `/control/`, not `/admin/`
11. Database backups scheduled — `code/src/scripts/database/backup.sh` is the dev-side reference
12. A migration rollback path rehearsed

## Migrations against a live database

The rules are strict because they are the ones that cause outages:

- never hold a long `ACCESS EXCLUSIVE` lock on a large table
- add-nullable → backfill → constrain, as separate deploys
- build indexes concurrently on populated tables
- **no manual DDL against a deployed database**

`code/docs/DATABASE.md` and `code/workflows/03-database-migration/` are the authority.

---

## Next

- Detailed host provisioning → the deploy repository's own runbooks (`how-to/src/NIXOS-SETUP.md`
  is a pointer stub)
- Something failed → `15-TROUBLESHOOTING.md`
