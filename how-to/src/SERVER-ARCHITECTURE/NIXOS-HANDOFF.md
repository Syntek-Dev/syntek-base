# NixOS Handoff — Feeding {{DEPLOY_REPO}}

**Last Updated**: {{DATE}} | **Maintained By**: {{ORG_NAME}} (via `/scale-planning`)

> **Template skeleton.** Part of the {{PROJECT_NAME}} base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

How this directory lands in the deploy repo ({{DEPLOY_REPO}}). The boundary is
strict: **SERVER-ARCHITECTURE specifies; the deploy repo implements.** This file maps
which artefact feeds which module, and the discipline for changing either side.

---

## The consumer — what the deploy repo actually is

A forked-per-deployment NixOS template ({{SERVER_TIER}}-class host), `flake.nix` +
`Justfile` driven, structured as:

```text
{{DEPLOY_REPO}}/
├── flake.nix / Justfile               ← flake outputs + deploy/ops commands
├── code/src/hosts/<hostname>/         ← per-server configuration.nix (the values land HERE)
├── code/src/modules/                  ← one folder per service, incl.:
│   ├── nginx/        ← vhosts, strict-header baseline + per-app cspDirectives merge
│   ├── cloudflared/  ← per-app CF Tunnel services (outbound-only)
│   ├── gatus/        ← status page engine — header cites HEALTH-CONTRACT.md as its contract
│   ├── prometheus/   ← node+zfs jobs built-in; `extraScrapeConfigs` for the app jobs
│   ├── database/ · valkey/ · objectstore/ (+ proxies) · alloy/ · loki/ · mail/ …
├── code/src/secrets/                  ← agenix (.age) — tunnel tokens, keys
└── client.nix (gitignored)            ← per-deployment values, never committed to the template
```

Two value planes, and this directory feeds both:

| Plane                 | Mechanism                                                                                             | Fed by                                                     |
| --------------------- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| **NixOS host config** | `custom.*` options in `hosts/<hostname>/configuration.nix` (+ agenix secrets — plane detail below)    | `EDGE-REQUIREMENTS.md`                                     |
| **App container env** | `/etc/{{ORG_SLUG}}/.env.<env>` on the server (chmod 640 root:deploy, not agenix — plane detail below) | `COMPUTE-ALLOCATION.md` + the relevant edge-catalogue rows |

## Artefact → module map

_TBD — the exact left-column rows are project-specific; regenerate them via
`/scale-planning` by reconciling against this project's `EDGE-REQUIREMENTS.md` and the
live deploy-repo modules. The row STRUCTURE below (artefact → implementation point) is
the reusable template; the three-surface default (public/marketing · authenticated app
· admin/staff) drives which edge rows exist._

| SERVER-ARCHITECTURE artefact               | Deploy repo implementation point                                                                                                                        |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Edge — headers, CSP, media hosts           | `modules/nginx/default.nix` baseline + host `custom.nginx.apps[].cspDirectives`                                                                         |
| Edge — CSP nonce (dormant)                 | `modules/nginx/` — future `x-csp-nonce` read + `proxy_hide_header`; agenix `CSP_INSTANCE_TOKEN`                                                         |
| Edge — `client_max_body_size`              | `modules/nginx/` vhost/location extraConfig                                                                                                             |
| Edge — URL routing                         | Host nginx location overlay — mirror `code/src/docker/nginx/dev.conf` at each release                                                                   |
| Edge — TLS, trusted proxies                | CF edge TLS + `nginx.ssl`; `TRUSTED_PROXIES` in `/etc/{{ORG_SLUG}}/.env.<env>`                                                                          |
| Edge — CF Tunnel, edge rate rule           | `custom.cloudflared.tunnels` + Cloudflare zone config (edge rate rule per the project's rate-limit plan)                                                |
| Edge — health/metrics                      | `modules/gatus/` + `custom.prometheus.extraScrapeConfigs` (jobs from `code/src/docker/prometheus/prometheus.yml`) + loopback-only `/metrics/` locations |
| Edge — Cloudinary token, object-store host | App `.env` (`CLOUDINARY_AUTH_TOKEN_KEY`) · new tunnel hostname + vhost → SeaweedFS gateway                                                              |
| Edge — deploy steps                        | `deploy.sh` restart-after-migrate; `worker`/`beat` services in the server compose                                                                       |
| Edge — mail relay                          | `modules/mail/` (Postfix + DKIM) + SPF/DKIM/DMARC DNS; `EMAIL_*` in `/etc/{{ORG_SLUG}}/.env.<env>`                                                      |
| `COMPUTE-ALLOCATION.md` assigned compute   | `GUNICORN_*` / `CELERY_*` in `/etc/{{ORG_SLUG}}/.env.<env>`; Postgres/PgBouncer/Valkey sizing in `custom.database` / `custom.valkey`                    |
| `COMPUTE-ALLOCATION.md` tier changes       | Host hardware decision ({{SERVER_TIER}} → RAM upgrade / bigger tier) + the Postgres horizontal-scaling ADR phase modules — only on a gate-trip          |

## The agenix plane — secrets the app stack requires (names only, never contents)

The application stack requires these agenix secrets on the host. Creation and
rotation commands live in the deploy repo (`how-to/src/03-MANAGING-SECRETS.md` +
`how-to/workflows/03-agenix-secrets/`) — never here:

| Secret (`code/src/secrets/*.age`)        | Feeds                                                                                                  |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `cloudflared-{{PROJECT_SLUG}}-token.age` | the CF Tunnel service                                                                                  |
| `{{PROJECT_SLUG}}-env.age`               | Valkey per-app ACLs — exports `VALKEY_{{ENV_PREFIX}}_BROKER_PASS` + `VALKEY_{{ENV_PREFIX}}_CACHE_PASS` |
| `objectstore-s3-credentials.age`         | SeaweedFS S3 access key + secret                                                                       |
| `mail-relay-credentials.age`             | Postfix SASL relay auth                                                                                |
| `mail-dkim-{{PROJECT_SLUG}}.age`         | DKIM signing key — publish the DNS TXT before enabling                                                 |
| `prometheus-remote-write-token.age`      | metrics shipping to the central monitoring server                                                      |
| `alloy-loki-token.age`                   | log shipping (Alloy → Loki)                                                                            |

Host-infrastructure secrets (ZFS unlock key, WireGuard keys/PSKs, Defguard token,
backup keys and passphrases) are the deploy repo's own concern — they exist
regardless of which app stack the box carries; this contract does not enumerate
them.

## The app-env plane — `/etc/{{ORG_SLUG}}/.env.<env>`

The app `.env` is **not** an agenix secret: it is placed at
`/etc/{{ORG_SLUG}}/.env.<env>` (`chmod 640 root:deploy`) and read by the Compose services
via `env_file`. The canonical variable set is this repo's template
`code/src/docker/.env.prod.example` — the deploy side fills it. The
server-topology-coupled values it must supply:

- `DATABASE_URL` / `REDIS_URL` / `CACHE_URL` / `OBJECT_STORE_ENDPOINT_URL` — all
  via `<bridge-gw>:<proxyPort>` (the connection plane, `COMPUTE-ALLOCATION.md`)
- `OBJECT_STORE_PUBLIC_ENDPOINT_URL` — the public presign vhost
- `TRUSTED_PROXIES` — exactly the Nginx hop the backend sees
- `EMAIL_HOST` / `EMAIL_PORT` / `EMAIL_HOST_USER` / `EMAIL_HOST_PASSWORD` — the
  mail relay
- `CLOUDINARY_AUTH_TOKEN_KEY` — token-based media auth
- `GUNICORN_*` / `CELERY_*` — the assigned-compute knobs (`COMPUTE-ALLOCATION.md`)

## Provisioning mechanics — deploy repo only

How the box is stood up is deliberately **not** specified anywhere in this repo. The
build mechanics — forking/renaming the template, disk layout, `nixos-anywhere`,
agenix commands, the deploy script + CI deploy key, `nixos-rebuild` operations,
post-deploy service checks — live in the deploy repo:

- `how-to/src/01-FORK-THE-REPO.md` … `11-HETZNER-CLOUDFLARE-SECURITY.md`
- `how-to/workflows/01-server-setup/` · `02-git-workflow/` · `03-agenix-secrets/`

## Contract discipline

1. **This repo specifies, the deploy repo implements** — the `prometheus.yml` /
   `HEALTH-CONTRACT.md` precedent, now generalised. No Nix in this directory; no
   app-behaviour decisions in the deploy repo.
2. **Change flow, app-driven:** an app change that touches the edge (a new external
   origin, a new upload path, a new endpoint, a routing slice) updates
   `EDGE-REQUIREMENTS.md` _in the same PR_ (docs hard-gate), then the deploy repo
   implements against the updated row and the row's _Current status_ is flipped.
   Interim state is visible, never silent — exactly how the `GAPS.md`
   edge-coordination gaps worked, now with a permanent home.
3. **Change flow, deploy-driven:** a deploy-repo change that alters what the app can
   assume (a header added/removed, a limit changed, a module landing — e.g. a new
   Gatus module) flips the matching row's status here on the next `/scale-planning`
   pass. The catalogue's status column is the reconciliation point between the two
   repos.
4. **Values with two homes must have one owner.** Worker counts, body-size numbers,
   CSP hosts: the _requirement and its rationale_ live here; the _live value_ lives
   in the deploy plane (host config or `.env`). If they disagree, this directory is
   the intent and the deploy repo is drifted — not the other way round.
5. **Secrets never cross.** This directory names agenix secrets and env vars
   (`cloudflared-{{PROJECT_SLUG}}-token.age`, `CLOUDINARY_AUTH_TOKEN_KEY`, …) but
   never their contents. Secret material exists only as `.age` ciphertext in the
   deploy repo or in the server-side `.env` files.

## The boundary, stated once

| Question                                           | Owner                                                                |
| -------------------------------------------------- | -------------------------------------------------------------------- |
| _What_ must the edge/server provide?               | **This directory**                                                   |
| _How_ is it provided (Nix modules, vhosts, units)? | `{{DEPLOY_REPO}}`                                                    |
| What does the app need at current peak?            | `how-to/src/SCALE-ARCHITECTURE/`                                     |
| How much is provisioned (envelope + buffer)?       | `COMPUTE-ALLOCATION.md` here                                         |
| When does the architecture change?                 | the Postgres horizontal-scaling ADR gates (observed, never forecast) |
| How is the server first provisioned?               | deploy repo `how-to/src/01–11` + `how-to/workflows/01-server-setup/` |

Server provisioning lives in the deploy repo; `how-to/src/NIXOS-SETUP.md` in this
repo is only a pointer stub. Where any copy of it disagrees with this contract,
**this directory states the current requirement**.
