# MAP-SUBDOMAIN-ROUTING — which surface answers on which host

**Seeded**: 16/08/2026 · **Seeded by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Seeded, not charted** — the frontier below is deliberately empty
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 0

> **Seeded, not charted, and deferred on purpose.** This file exists because a recommendation pass
> on 16/08/2026 measured a class it was explicitly told not to settle — Sam's instruction was
> _"report back what you recommend, write nothing"_, and then _"chart this as a stub we can properly
> fill out after the other maps are fully done"_. **Nothing here is a decision.** The frontier is
> empty because charting it is a `/wayfinder` CHART sitting that has not happened — do not read the
> empty table as "no open decisions". Precedent for a seeded map: `MAP-UPSTREAM-TRACKING.md`,
> seeded out of N-022 for the same reason, and `MAP-SCALE-PLANNING.md`, seeded at generation.
>
> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — deliberately: this charts
> **syntek-base's own** doctrine, and a generated project inherits the decided rule rather than
> the argument that produced it. The name matters — a map called `MAP-TEMPLATE-*.md` would match
> the `!*TEMPLATE*` negation and ship.
> **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s map index** for the same reason: that file ships,
> and a row pointing at an unshipped map would dangle in every generated project.

---

## Destination

Every surface a generated project serves has a **decided host** — apex path, dedicated subdomain,
or a service this repo does not serve at all — with the **cookie scope, schema-publication and
edge obligations that follow from it** stated once and enforced by a mechanism that survives a
misconfigured edge.

The deliverable is **doctrine plus one routing mechanism**. Whether any application code beyond a
host→URLconf seam is touched is itself undecided.

---

## Notes

| Field                    | Value                                                                                                                                                         |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | URL and host architecture — the seam between `code/docs/URL-STRATEGY.md` and `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`                            |
| Skills to load           | `backend` · `stack-django` · `security` · `cicd` · `doc-writer` · `seo` · `scale-planning` (the edge contract is one of its two snapshots)                    |
| Standing preferences     | **No ADRs in this repo** (see Out of scope) · this repo **specifies**, the deploy repo **implements** · a rule ships with a gate · no new copier token wanted |
| Umbrella ADRs            | **None, and none is possible** — this template authors no ADRs (`../15-DECISIONS/CLAUDE.md`)                                                                  |
| Register entries triaged | 0 — not charted yet. Root `GAPS.md` and `DEFERRED.md` were both empty at seeding                                                                              |

---

## What is already measured

Gathered on 16/08/2026 against the live tree, and recorded here so a CHART sitting starts from
measurement rather than from scratch. **None of these is a node.**

### Already decided elsewhere — these are not questions

| Fact                                                                                                                                                                                                                                                   | Where                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| **`status.<%PRIMARY_DOMAIN%>` is already the contract.** Gatus on its own tunnel hostname, vhost and agenix token; the app keeps `/health/` and `/health/ready/` as unauthenticated paths. It is a **worked example**, not a proposal                  | `code/docs/logging/HEALTH-CONTRACT.md` → _What the deploy repo must provision_ 1 · `EDGE-REQUIREMENTS.md` 8 |
| **`admin.` and `portal.` are already written as "Phase 2"**, gated on explicit security review, with `build_admin_url()` / `build_portal_url()` named as the migration mechanism                                                                       | `code/docs/URL-STRATEGY.md:72-86`                                                                           |
| **That same section recommends the shared cookie domain** `SESSION_COOKIE_DOMAIN = ".<%PRIMARY_DOMAIN%>"`. The 16/08 recommendation argued the opposite. **A live contradiction with the proposal's client-facing hosts, and probably the first node** | `code/docs/URL-STRATEGY.md:147-153`                                                                         |
| **Each new hostname is a deploy-repo obligation, not a code change** — CF Tunnel ingress + Nginx vhost + agenix token, the pattern `status.` already establishes                                                                                       | `EDGE-REQUIREMENTS.md` 7-8 · `SERVER-ARCHITECTURE/CLAUDE.md` → _Specify, never implement_                   |
| **`<%PRIMARY_DOMAIN%>` is the only domain token**, and `status.` already derives from it. Subdomain names derive; no new copier question is implied                                                                                                    | `how-to/src/TEMPLATE-TOKENS.md:90`, `:326`                                                                  |

### The mechanism does not exist, and nothing is wired

- **Two routes exist in total.** `config/urls.py:20-23` mounts `apps.health.urls` and
  `settings.DJANGO_ADMIN_PATH`. There is **no `/api/`, no `/mcp/`, no `/admin/`, no `/portal/`** —
  so every host in the proposal would be routing traffic to a surface that has not been built.
  This is the cheapest this decision will ever be, and that is the argument for charting it before
  the surfaces land rather than after.
- **Django does no host routing at all.** No `django-hosts`, no `request.urlconf` switch, no
  host-keyed middleware. The in-repo proxies are `server_name _` catch-alls
  (`code/src/docker/nginx/dev.conf:9`), and `docker/nginx/CLAUDE.md` states that as the rule. Host
  separation therefore exists **nowhere** in this repository — not in the app, not in dev, not in
  test — so an edge vhost would be the only thing enforcing it.
- **Path mobility exists; host mobility does not.** `DJANGO_ADMIN_PATH` is environment-overridable
  (`config/settings/base.py:121`, default `control/`), so a deployment can already move the admin
  path without a code change. Nothing equivalent exists for a hostname.
- **`ALLOWED_HOSTS` does not cover `/mcp/`.** The designed composition mounts FastMCP on a Starlette
  router **above** Django, so an `/mcp/` request never enters Django's request cycle: no host
  validation, no session, no CSRF (`code/docs/mcp-server/MOUNTING.md`). Any `mcp.` hostname is
  edge-validated only, and `TokenVerifier` remains the whole of its auth.
- **A public API playground reverses a shipped default.** `API_DOCS_ENABLED=False` is the production
  default and the release checklist carries _"the docs page and raw schema are disabled in
  production"_ (`code/docs/api-design/API-DOCS.md`). The schema is **auto-generated from code**, so
  "nothing sensitive is ever revealed" survives exactly until the next internal endpoint is added
  unless the published surface is explicitly opt-in.
- **HSTS already ships `includeSubDomains` and `preload`** (`config/settings/production.py:26-28`).
  Every host under the apex must be HTTPS from its first request — including any later delegated to
  a client or a vendor — and preload submission is irreversible on any useful timescale.
- **The host allowlist is env-shaped and currently two entries.**
  `code/src/docker/.env.prod.example:12-13` lists apex + `www` for both `ALLOWED_HOSTS` and
  `CSRF_TRUSTED_ORIGINS`.
- **The worktree host scheme is a live constraint.** Per-story stacks answer on `dev-us<NNN>.` hosts
  (`.claude/CLAUDE.md` Section 7), so a host→URLconf map keyed on exact strings breaks every
  worktree the moment it lands.
- **robots and canonical are per-host resources.** `code/docs/discoverability/ROOT-SURFACE.md`
  Section 1 disallows `/admin/` and `/portal/` **by path**; if those surfaces move to hosts, the
  apex rule is naming paths that do not exist there, which is disclosure for nothing.

### The blast radius, measured rather than estimated

**52 files reference `control/`; 34 of those mention both `admin` and `/control/`** — i.e. restate
or depend on the mount rule. The rule itself is **`.claude/CLAUDE.md` Section 6**, a
non-negotiable, echoed verbatim down eight `CLAUDE.md` files and into `config/urls.py`'s module
docstring and `nginx/dev.conf`'s comments. **Changing the shape of that rule from path to host is
the highest-cost documentation change available in this repository**, which is a reason to decide
it once and deliberately, not a reason to avoid it.

---

## The recommendation on the table — put to Sam 16/08/2026, **none confirmed**

Recorded so the CHART sitting starts from a position rather than a blank page. **These are
recommendations, not decisions, and a CHART sitting is free to refuse every one.**

| Host       | Recommended                             | What it hangs on                                                                             |
| ---------- | --------------------------------------- | -------------------------------------------------------------------------------------------- |
| `control.` | Yes — but swap obscurity for **Access** | Whether a hostname gate beats a path-scoped one; `control` is on every subdomain wordlist    |
| `admin.`   | Yes — already Phase 2                   | Its API calls staying **same-host**, or `SameSite` is downgraded to buy nothing              |
| `api.`     | Yes, **but serve the API on it**        | Docs-only means Swagger fires cross-origin and forces a CORS allowlist onto the real API     |
| `mcp.`     | Yes, as the **real endpoint**           | MCP has no playground; a docs-only `mcp.` serves nobody and still needs edge host validation |
| `status.`  | No action — already contracted          | Nothing. It must stay **out** of `ALLOWED_HOSTS`; Gatus is not served by this app            |

The single cross-cutting recommendation, and the one most likely to become node one: **never set
`SESSION_COOKIE_DOMAIN`**, because host-scoped cookies unlock the `__Host-` prefix, keep every
future client subdomain out of the session's blast radius, and make the API playground anonymous
by construction rather than by promise.

---

## Fog of war

In scope, not yet sharp enough to state as a decision. **Leaving something here is honest.**

- **Whether host separation buys anything the edge cannot already give path-scoped.** Cloudflare
  Access binds to hostname **and** path. If the real control is Access either way, the subdomain is
  ergonomics and blast-radius, not access control — and that changes how much the doctrine churn is
  worth. This is the first thing a CHART sitting has to decide rather than assume.
- **Whether the template should ship a host map at all.** A template that hardcodes `admin.` decides
  for every generated project. Shipping the **mechanism** plus an empty host register is the other
  shape, and nobody has argued the two against each other.
- **What a client-delegated subdomain actually is.** `email.`, `chat.`, `video.` were named as the
  motivating future case, but a vendor CNAME, a proxied third-party app and a Django-served surface
  have three different security answers. The proposal treats them as one class; they are not one.
- **Whether admin/portal SSO is even wanted.** Two logins versus a shared cookie is a product
  question about who the admin users are, and the admin surface does not exist yet.
- **Whether dev parity holds.** `*.localhost` resolution is resolver-dependent, and nothing in this
  repository has ever served a second host locally — the claim that it works is untested here.
- **What the published API surface is made of**, if one is published: a filtered second `NinjaAPI`,
  tag-based inclusion, or a hand-maintained document. All three were named; none was compared.

---

## Out of scope

| Ruled out                                    | Why                                                                                                                                                                      |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Provisioning any tunnel, vhost or DNS record | This repo specifies and the deploy repo implements — `SERVER-ARCHITECTURE/CLAUDE.md` → _Specify, never implement_. The output here is a contract row, never a Nix module |
| The `status.` host itself                    | Settled contract since before this map. It enters as a **worked example** of the per-host obligation, not as a question                                                  |
| Tenant-per-subdomain multi-tenancy           | A different feature. `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md:214` names tenant resolution from a subdomain; **this map is about surfaces, not tenants**        |
| Building any client-facing host              | `email.` / `chat.` / `video.` are the motivating case for **not foreclosing** the shape. Building one is its own feature with its own map                                |
| Authoring an ADR for any of it               | This template authors no ADRs (`../15-DECISIONS/CLAUDE.md`). The shipped guide is the decision record                                                                    |

---

## Session log

| Date       | Node settled     | Outcome                                                                                                                                                                                                                                                               | Frontier redrawn |
| ---------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 16/08/2026 | _none — seeding_ | Seeded out of a read-only recommendation pass on Sam's five-subdomain proposal, on his call that it is charted **after the other maps are fully done**. The measured evidence and the unconfirmed recommendation are recorded; the frontier is **deliberately empty** | [ ]              |

---

## Gate to stories

Every box below is unticked because **this map has not been charted**. It is listed in full so the
CHART sitting has its checklist rather than reconstructing one.

- [ ] Destination and out-of-scope bounds confirmed
- [ ] The host inventory enumerated — every hostname the project will answer on, and who serves it
- [ ] The cookie-scope decision settled, because every other node's answer moves with it
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [ ] Every knowable decision is a node or in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] ~~Index row in `CONTEXT.md` current~~ — **deliberately not applicable**, see the header
