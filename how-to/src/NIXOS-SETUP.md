# NixOS Server Setup — Pointer

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

A contract split keeps this repo and the deploy repo cleanly separated: this repo
**specifies** what the server and edge must provide; the deploy repo **implements** it.

## Provisioning the server (how the box is stood up)

Lives in the deploy repo, `<%DEPLOY_REPO%>`:

- `<%DEPLOY_REPO%>/how-to/src/01-FORK-THE-REPO.md` … `11-HETZNER-CLOUDFLARE-SECURITY.md` —
  fork/rename, secrets, server setup, flake deploys, WireGuard, CLI, Docker, Hetzner/Cloudflare
- `<%DEPLOY_REPO%>/how-to/workflows/01-server-setup/` · `02-git-workflow/` · `03-agenix-secrets/`

## What the app requires ON the server (the app→server contract)

Lives here, in `how-to/src/SERVER-ARCHITECTURE/`:

- `EDGE-REQUIREMENTS.md` — headers/CSP, routing carve, body-size, TLS, CF Tunnel,
  health/metrics, mail relay, post-deploy verification
- `COMPUTE-ALLOCATION.md` — assigned compute + buffer; the loopback/proxy connection plane
- `NIXOS-HANDOFF.md` — agenix + app-`.env` planes, artefact→module map, the deploy boundary
