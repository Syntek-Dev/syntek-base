# how-to/src/SERVER-ARCHITECTURE — Deploy-Facing Server/Edge Contract

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

The deploy-facing specification of **what the server and edge must provide** for the
<%PROJECT_NAME%> application. This directory is the contract the NixOS deploy repo
(`<%DEPLOY_REPO%>`) implements — the consolidation point for edge requirements that
were previously scattered across `GAPS.md`, the ADRs, and `NIXOS-SETUP.md`, plus the
application's sizing envelope expressed as **assigned compute with a headroom buffer**.

## Directory Tree

```text
how-to/src/SERVER-ARCHITECTURE/
├── CONTEXT.md              ← this file (orientation + glossary)
├── CLAUDE.md               ← operating rules for this directory
├── OVERVIEW.md             ← what this directory is, the pipeline, the framing rules
├── EDGE-REQUIREMENTS.md    ← consolidated catalogue: every requirement the app places
│                             on the edge/server (CSP, routing, body-size, TLS, CF
│                             Tunnel, health/metrics), each with source, status, and
│                             what the deploy repo must implement
├── COMPUTE-ALLOCATION.md   ← sizing envelope → assigned compute + buffer, keyed to
│                             the Postgres horizontal-scaling ADR phase-gates
└── NIXOS-HANDOFF.md        ← how this directory feeds <%DEPLOY_REPO%>
```

## What is here

| File                    | Read when                                                              |
| ----------------------- | ---------------------------------------------------------------------- |
| `OVERVIEW.md`           | First visit — the pipeline, the anti-forecast rule, the contract shape |
| `EDGE-REQUIREMENTS.md`  | Configuring the edge (Nginx/Cloudflare/CF Tunnel) for any environment  |
| `COMPUTE-ALLOCATION.md` | Provisioning or resizing compute for the app's containers/processes    |
| `NIXOS-HANDOFF.md`      | Working in the deploy repo — what it consumes from here and how        |

## When to read this

- Deploying or reconfiguring the staging/production server (with the deploy repo's
  `how-to/` runbooks — this directory is the contract they implement)
- Closing an edge-coordination gap from `GAPS.md` (CSP hosts, body-size limits, …)
- Running `/scale-planning` — this directory is one of its two living snapshots
- Answering "what does the server need to provide for feature X to work in prod?"

## Do not use for

- Provisioning walkthrough (disks, agenix, nixos-anywhere) → the deploy repo:
  `<%DEPLOY_REPO%>/how-to/src/01–11` + `<%DEPLOY_REPO%>/how-to/workflows/01-server-setup/`
- The readiness audit and raw sizing envelope → `how-to/src/SCALE-ARCHITECTURE/`
- Application-side health endpoint shapes → `code/docs/logging/HEALTH-CONTRACT.md`
- The scaling decision itself → the project's Postgres horizontal-scaling ADR +
  `code/docs/architecture/CORE-AND-SCALING.md`

## Glossary

**Edge requirement** — a control or configuration the application _needs_ but
deliberately does _not_ implement, because it belongs at the edge (Cloudflare, CF
Tunnel, bare-metal Nginx) or on the server host. Example: the CSP header — the app
repo ships no CSP middleware at all, so the edge _must_ set it or the control simply
does not exist.
_Avoid:_ treating an edge requirement as optional hardening. If it is in
`EDGE-REQUIREMENTS.md`, the app is designed on the assumption it exists; skipping it
is a functional or security regression, not a missing nicety.

**Assigned compute** — the concrete per-process resources a tier runs with (Gunicorn
workers, Celery concurrency, connection pool sizes, memory ceilings) as provisioned
by the deploy repo — distinct from the _measured envelope_ (what the app needs at
current peak), which lives in `SCALE-ARCHITECTURE/`.
_Avoid:_ copying the envelope 1:1 into provisioning. Assigned compute is always the
envelope **plus** the headroom buffer (below), never the bare measurement.

**Buffer / headroom** — the multiplier between the current-tier peak load and the
assigned compute: `assigned ≈ peak × (1 + headroom)`, sized so that _normal_ peak
stays **under** the Postgres horizontal-scaling ADR gate triggers (CPU/IO 70%). A
gate-trip is then a genuine signal to move up a tier — not noise from
under-provisioning.
_Avoid:_ sizing the buffer as a growth forecast. It is margin on the _current_ tier,
keyed to observable gates (the ADR's rule: "do not pre-emptively add infrastructure") —
the next tier is provisioned when a gate trips, not in anticipation.

**Deploy contract** — a file in _this_ repo that specifies behaviour a _different_
repo must implement, kept deliberately implementation-neutral. The established
precedent is `code/docs/logging/HEALTH-CONTRACT.md` — its endpoint table plus the Section 2
scrape-target contract the NixOS `scrapeConfigs` implement. (A
`code/src/docker/prometheus/prometheus.yml` was cited as a second precedent; no such
file ships. One stale citation survives in `.claude/skills/scale-planning/SKILL.md`.)
Every file here follows that shape: this repo specifies, the deploy repo implements.
_Avoid:_ writing Nix here. The moment a doc in this directory contains a working
module, ownership has leaked — describe _what_ must hold and cite where the deploy
repo implements it.

## Cross-references

- `how-to/src/NIXOS-SETUP.md` — pointer stub → deploy repo runbooks + this directory
- `how-to/src/SCALE-ARCHITECTURE/` — the sibling snapshot this directory consumes
- `code/docs/logging/HEALTH-CONTRACT.md` — the app ↔ deploy health/metrics contract
- `code/docs/architecture/CORE-AND-SCALING.md` — the scaling phase-gates
- `<%DEPLOY_REPO%>` — the consumer repo
