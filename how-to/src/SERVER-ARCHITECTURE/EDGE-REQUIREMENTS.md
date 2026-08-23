# Edge Requirements — Consolidated Catalogue

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

> **Template skeleton.** Part of the <%ORG_NAME%> base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

Every requirement the <%PROJECT_NAME%> application places on the edge and server,
reconciled against this project's live codebase. Each entry carries **Source** (the
file in this repo, or prefixed `deploy:` for <%DEPLOY_REPO%>), **Current status**, and
**Deploy repo must implement** — the obligation on <%DEPLOY_REPO%>. Statuses here track
the sources; when a `GAPS.md` gap closes or a NixOS module lands, update the row.

Traffic path (context for every entry): **Cloudflare Edge → CF Tunnel (outbound-only)
→ bare-metal Nginx `:8081` → the Django app container** (ASGI: Gunicorn + Uvicorn
workers, `:8000`) on the `<%PROJECT_SLUG%>-net` bridge — serving Django-templated pages
(django-components + HTMX + Alpine + token CSS), the Django Ninja JSON API (`/api/...`),
serving every surface as HTML. A Celery worker + Celery beat (singleton) are **designed
to run alongside but are not wired** — `celery[redis]` is declared in `pyproject.toml`
and no Compose file defines a `worker` or `beat` service — as are any optional
project-defined Rust service(s); the container↔service connection plane is in
`COMPUTE-ALLOCATION.md`. There is exactly **one** app process family today — no second
frontend upstream to size or route.

---

## 1. Security headers + CSP — set at the edge, never in this repo

- **Source:** `pyproject.toml` — "Security headers (CSP included) are set at the edge
  in the Nix server repo — NEVER in this repo — so django-csp is deliberately absent."
  Reaffirmed in `code/docs/FRONTEND-CODING-PRINCIPLES.md` — the **CSP-clean** rule under
  _Templates & django-components_: no inline `<script>` or `<style>`, HTMX configured
  through a `<meta>` tag, per-page JS a static file. That guide is where the rule lives;
  the base template a project writes is built to it, and is cited nowhere here because it
  holds no row in `how-to/src/PROJECT-PATHS.md`. Deploy side: `deploy:` the Nginx module (CSP baseline +
  per-app `cspDirectives` merge; `add_header Content-Security-Policy … always`).
- **Current status:** _TBD — reconcile against this project's live code._ Design
  intent: the app ships **no** CSP or security-header middleware; dev/test run without
  an enforced CSP. The deploy repo's Nginx module implements a strict-header baseline
  (`default-src 'self'`, `frame-ancestors 'none'`, …) with per-app overrides
  (`enableStrictHeaders = true` + `cspDirectives` on the host's `custom.nginx.apps`
  entry).
- **Deploy repo must implement:** the full security-header set on the <%PRIMARY_DOMAIN%>
  vhost — CSP (with the host allowances in entries 2–3), `X-Frame-Options`/
  `frame-ancestors`, and the strict-header baseline — via
  `custom.nginx.apps[].enableStrictHeaders` + `cspDirectives`. The app container must
  never set these headers. Any new external origin the app renders (fonts, analytics,
  media hosts) is a `cspDirectives` change in the deploy repo, coordinated through this
  catalogue.

## 2. CSP instance token — per-request nonce mechanism

- **Source:** the project's CSP-instance-token ADR — `CSP_INSTANCE_TOKEN` per
  environment; nonce = `base64url(HMAC-SHA256(token, request_id))`; Nginx reads
  `$upstream_http_x_csp_nonce` into the CSP header and strips it with
  `proxy_hide_header`; no `'unsafe-inline'` for scripts.
- **Current status:** _TBD — reconcile against this project's live code._ Design
  intent: the Django-templated pages render CSP-clean without inline scripts, so the
  nonce mechanism is a **dormant contract** for any surface that later reintroduces
  inline `<script>`/`<style>` (e.g. a third-party embed). If the
  deploy baseline carries `style-src 'self' 'unsafe-inline'`, that is an acceptable
  interim for styles — but `script-src` must never gain `unsafe-inline`.
- **Deploy repo must implement:** when a nonce-requiring surface exists — the
  `$upstream_http_x_csp_nonce` read, CSP header assembly, and
  `proxy_hide_header x-csp-nonce`, parameterised per app; `CSP_INSTANCE_TOKEN`
  provisioned per environment via agenix, rotated atomically with the app env (the
  ADR's token-lifecycle table). Until then: keep `script-src` free of `unsafe-inline`
  and track any `style-src` relaxation for removal.

## 3. Media / attachment CSP hosts

- **Source:** the project's media-rendering surface(s) — `GAPS.md` edge-coordination
  gap. Rendered `<img>`/`<video>`/download `<a>` point at signed, short-TTL URLs on
  **external hosts**: Cloudinary (`res.cloudinary.com`, authenticated public media) and
  the object-store public host (`OBJECT_STORE_PUBLIC_ENDPOINT_URL`, private docs).
  _(TBD — reconcile against this project's media-rendering surfaces.)_
- **Current status:** _TBD — set per deployment._ Design intent: the deploy baseline
  CSP has `img-src 'self' data:` and no `media-src`; the per-app `cspDirectives`
  override (e.g. `img-src 'self' data: https://res.cloudinary.com`) is exactly the
  mechanism this lands through. On a CSP-enforcing environment, media attachments are
  blocked from rendering until this lands. Not a dev/test blocker (no enforced CSP
  there).
- **Deploy repo must implement:** add to the <%PRIMARY_DOMAIN%> vhost `cspDirectives`:
  `img-src` and `media-src` allowing `https://res.cloudinary.com` and the object-store
  public host; `connect-src` too if any attachment is ever fetched via XHR/`fetch`
  rather than a plain element load.

## 4. Request body-size limits — `client_max_body_size`

- **Source:** `GAPS.md` upload edge-coordination gap. Django's multipart parser streams
  every part to temp disk **before** the in-app caps run (`UPLOAD_MAX_FILES` /
  `UPLOAD_MAX_BYTES`-style settings in `code/src/django/config/settings/base.py` —
  TBD, reconcile against this project's upload settings), so only the edge
  `client_max_body_size` bounds the total request. Dev parity:
  `code/src/docker/nginx/dev.conf` sets a large limit on the upload locations and a
  modest general limit.
- **Current status:** _TBD — set per deployment, and broader than any one feature._
  Nginx's 1 MiB default applies until this lands, so **every** upload (avatars
  included) would 413 in staging/prod.
- **Deploy repo must implement:** `client_max_body_size` on the vhost — a modest
  general limit and a larger limit on the upload locations, i.e.
  `MAX_FILES × MAX_BYTES` plus multipart overhead — so an over-cap body is rejected at
  the edge (413) before reaching Django's parser. Keep the values keyed to the two
  Django settings; if those env vars are raised, the edge limit moves with them.

## 5. URL routing — the Django + Ninja path split

- **Source:** the project's URL-architecture ADR (prefix ownership table),
  `code/docs/URL-STRATEGY.md`; the live routing state is `code/src/docker/nginx/dev.conf`
  locations. Non-negotiable: Django admin is **never** at `/admin/` — it is mounted at
  the non-obvious `/control/` (`.claude/CLAUDE.md` Section 6; the URL-architecture ADR).
- **Current status:** _TBD — reconcile against this project's `dev.conf`._ One Django
  ASGI app process serves every route: Django-templated pages (marketing, `/auth/`,
  `/account/`, `/verify-email/`, the authenticated app, staff), the Django Ninja JSON
  API (`/api/...`), static assets (`/static/`, `/assets/`), `/media/`,
  `/control/`, `/health/`, and robots/sitemap/llms.txt. There is **no** second frontend
  upstream and no catch-all — the Django app owns everything.
- **Deploy repo must implement:** the server Nginx location set must mirror the in-repo
  nginx routing at each release — `code/src/docker/nginx/dev.conf` is the canonical
  statement of the split (dev host ports aside). Structural invariants: `/control/` →
  Django only, never linked or indexed; `/admin/` never reaches Django's admin; any
  SSE / streaming endpoints need buffering off and long read timeouts; `/metrics/`
  stays loopback-only (entry 8).

## 6. TLS + trusted-proxy chain

- **Source:** deploy repo `CONTEXT.md` — "TLS at the edge — Cloudflare terminates
  public TLS; Nginx listens on localhost only. App containers must not handle
  certificates." App side: `TRUSTED_PROXIES` (default `[]`, fail-safe) gates all
  `X-Forwarded-For`/`X-Real-IP` trust via the single `apps.core.utils.get_client_ip`
  helper (TBD — reconcile against this project's IP-trust helper); `TRUSTED_PROXIES`
  must always name exactly the proxy chain the backend actually sees
  (`code/src/docker/.env.prod.example` — "never a public IP").
- **Current status:** _TBD — set per deployment._ Design intent: zero inbound ports, CF
  terminates public TLS, the tunnel leg optionally on a Cloudflare origin cert, the
  container is plain HTTP on loopback/bridge.
- **Deploy repo must implement:** TLS termination stays at the CF edge (+ optional
  origin CA on the tunnel leg in `nginx.ssl`); Nginx must set accurate
  `X-Forwarded-For`/`X-Real-IP` on proxy; the app's `.env` `TRUSTED_PROXIES` must name
  exactly the Nginx hop the backend sees (bridge-side address) — an empty or wrong
  value silently degrades per-IP rate-limit keying and audit IP hashing.

## 7. Cloudflare + CF Tunnel

- **Source:** the tunnel topology — **one tunnel** carries all <%PRIMARY_DOMAIN%>
  traffic: `cloudflared-<%PROJECT_SLUG%>`, `listenPort 8081` (matching the Nginx vhost),
  token via the agenix secret `cloudflared-<%PROJECT_SLUG%>-token.age`, Cloudflare
  dashboard ingress `<%PRIMARY_DOMAIN%> → http://localhost:8081`, and `www`→apex handled
  by a Cloudflare Redirect Rule (301) rather than a second tunnel. Deploy side:
  `deploy:README.md` (outbound-only tunnels, zero inbound ports, per-app tokens) and
  `deploy:modules/cloudflared/`.
- **Current status:** _TBD — set per deployment._ Design intent: topology implemented
  in the deploy repo (`modules/cloudflared/`). The **edge rate rule** is a coordination
  item: Django enforces a global request-rate budget in-app (a public rate-limit
  middleware keyed to a `GLOBAL_RATE_LIMIT_MAX` setting); the complementary Cloudflare
  zone rule that sheds a distributed flood before the tunnel lives with the deploy repo
  (this project's distributed-rate-limit plan).
- **Deploy repo must implement:** the `cloudflared-<%PROJECT_SLUG%>` tunnel
  (`tokenSecretPath` via agenix, `listenPort` matching the Nginx vhost), the `www`→apex
  redirect rule, and — when enabled — the CF edge rate rule aligned to
  `GLOBAL_RATE_LIMIT_MAX`, with admin traffic exempted via the trusted secret header and
  `TRUSTED_PROXIES` kept aligned with Cloudflare egress ranges. A second hostname is
  required for the public status page (entry 8) and one for the object-store public
  endpoint (entry 10).

## 8. Health + metrics contract (Gatus, Prometheus, loopback-only endpoints)

- **Source:** `code/docs/logging/HEALTH-CONTRACT.md` — the single source of truth:
  endpoints table (`/health/` liveness · `/health/ready/` dependency-aware readiness,
  `200/503`, overall-status-only · `/metrics/` loopback-only Prometheus exposition);
  "All of the following live in <%DEPLOY_REPO%>, not in this repo". The scrape-target
  contract (job `<%ORG_SLUG%>-backend` → `127.0.0.1:8000` `/metrics/`) is stated here.
  **No Prometheus config file ships in this repo** — there is no
  `code/src/docker/prometheus/prometheus.yml`, so the build-side statement of the job is
  prose. `GAPS.md` carries no entry for the Gatus or metrics deploy — the obligation is
  stated below.
- **Current status:** _TBD — set per deployment._ App side ships the endpoints; deploy
  side supplies the Gatus module, the Prometheus `extraScrapeConfigs` for the single app
  job, and the **host-level wiring** — the actual scrape entries, the
  `status.<%PRIMARY_DOMAIN%>` tunnel hostname + vhost + agenix token, and the Gatus
  endpoint list.
- **Deploy repo must implement:** the Gatus endpoint set from `HEALTH-CONTRACT.md`
  (Website + `/health/` + `/health/ready/` keyed on `[BODY].status == operational`), the
  `status.` hostname (tunnel + vhost + token), the single `<%ORG_SLUG%>-backend`
  `extraScrapeConfigs` app job (→ `127.0.0.1:8000` `/metrics/`), and the `/metrics/`
  `allow 127.0.0.1; deny all` restriction on the vhost. There is exactly **one** scrape
  job — the single Django app process — no second frontend job.
- **Order, because the app does not serve `/metrics/` yet.** `django_prometheus` is a declared
  dependency that is not in `INSTALLED_APPS`, so the path 404s today. The scrape job is
  provisioned **first** and is itself the trigger that wires the app side — recorded at
  `code/docs/logging/OBSERVABILITY.md` → _Deferred, with a trigger_. Provision it expecting a
  404 until that lands; do not defer the job waiting for the endpoint, or each side waits for
  the other.

## 9. Cloudinary token-based auth for signed media URLs

- **Source:** the Cloudinary rollout checklist — Cloudinary **Token-based Auth** add-on
  - `CLOUDINARY_AUTH_TOKEN_KEY` for short-lived authenticated media URLs; without it,
    delivery falls back to signature-only/permanent URLs (no breakage, weaker expiry).
- **Current status:** _TBD — set per deployment._ Account/env configuration, not code.
  The app routes public media → Cloudinary (authenticated) and private documents →
  <%OBJECT_STORE%> S3 (the upload-routing invariant).
- **Deploy repo must implement:** strictly a _deployment-coordination_ item rather than
  a NixOS module: enable the add-on on the Cloudinary account and set
  `CLOUDINARY_AUTH_TOKEN_KEY` in the per-env app `.env` (deployed to
  `/etc/<%ORG_SLUG%>/.env.<env>`, not agenix — see `NIXOS-HANDOFF.md`, the app-env plane).
  Pairs with the CSP allowance in entry 3.

## 10. Object-store public endpoint (<%OBJECT_STORE%> presign host)

- **Source:** the project's object-store-engine ADR (presign reachability —
  `OBJECT_STORE_PUBLIC_ENDPOINT_URL` distinct from the internal endpoint). **No
  build-side counterpart yet:** `code/src/docker/CONTEXT.md` names four services
  (`django`, `db`, `cache`, `nginx`) and no object store — there is no `seaweedfs`
  container, no nginx `server_name` fronting one, and nothing under `code/src/django/`
  that signs a presigned URL. The shape below (staging/prod: object store on the server
  host, the app signing presigned downloads against the public HTTPS host; dev: a
  dedicated nginx `server_name` → `seaweedfs:8333`) is this contract's design intent,
  not a description of the shipped Compose stack.
- **Current status:** _TBD — set per deployment._ Design intent: the deploy repo runs
  <%OBJECT_STORE%> bare-metal, nftables-gated to the Docker bridge + WireGuard — the
  **internal** leg. The browser-reachable **public** presign hostname (the prod analogue
  of dev `s3.<%PROJECT_SLUG%>.localhost`) is per-deployment edge wiring.
- **Deploy repo must implement:** a public HTTPS hostname (CF Tunnel ingress + Nginx
  vhost → the <%OBJECT_STORE%> S3 gateway, via the objectstore-proxy where bucket isolation /
  AV scanning applies) matching the app's `OBJECT_STORE_PUBLIC_ENDPOINT_URL`; the same
  host enters the CSP allowances (entry 3). Presigned URLs are self-authorising — the
  vhost must not add auth, only TLS and routing.

## 11. Deploy-step obligations (release checklist items)

- **Source:** `code/docs/design-tokens/CASCADE.md`, which owns the regeneration and
  cache-invalidation flow the first obligation exists to complete, and this contract
  itself for the second. **`GAPS.md` records neither** — it is empty at baseline, so the
  two bullets below are the standing statement of these obligations, not a pointer to a
  recorded gap.
- **Token-CSS cache bust:** design-token seed migrations do not touch
  Valkey, so `/assets/tokens.css` serves stale until busted. Prod: the deploy restart
  handles it — the deploy flow must restart the Django app after migrations (the
  health-gated `deploy.sh` restart satisfies this). Cosmetic risk only.
- **Celery worker + beat run in every live env:** the deploy repo/server
  must run the `worker` and `beat` (singleton) containers alongside the app container
  (`django` — the only service `docker-compose.prod.yml` declares), plus any optional
  project-defined Rust service(s). Beat drives every periodic task; without it,
  scheduled work (retention purges, reapers, refresh jobs) silently stops. Neither
  container is wired yet (the traffic-path note above) — this row is the obligation, not
  a description of a running service.

## 12. Outbound mail — the SMTP relay the app sends through

- **Source:** Django's own outbound-mail settings — the names this contract fixes for
  the SMTP env contract: `EMAIL_BACKEND` (intended
  `django.core.mail.backends.smtp.EmailBackend`), `EMAIL_HOST`, `EMAIL_PORT` (intended
  587, submission), `EMAIL_HOST_USER`/`EMAIL_HOST_PASSWORD`, `EMAIL_USE_TLS`, and
  `DEFAULT_FROM_EMAIL` (intended `noreply@<%PRIMARY_DOMAIN%>`). Deploy side:
  `deploy:code/src/modules/mail/` (Postfix submission relay + per-app DKIM).
- **Not wired at baseline:** `code/src/docker/.env.prod.example` declares no `EMAIL_*`
  key, and `code/src/django/config/settings/base.py` reads none from the environment —
  so values supplied server-side are inert until a settings module reads them. Only
  `dev.py` (console backend) and `test.py` (locmem backend) set anything at all;
  staging and production inherit Django's defaults. The names above and the env keys
  must land in the same change (`code/docs/architecture/BUILD-OPERATE-SEAM.md`).
- **Current status:** _TBD — set per deployment._ App is relay-agnostic — plain Django
  SMTP; a provider-specific Anymail backend remains an _option_, but nothing in the app
  requires one.
- **Deploy repo must implement:** an authenticated SMTP submission path reachable from
  the app container, with SPF/DKIM/DMARC DNS published for <%PRIMARY_DOMAIN%> **before**
  DKIM signing is enabled (relay credentials + DKIM key are agenix secrets —
  `mail-dkim-<%PROJECT_SLUG%>.age`, see `NIXOS-HANDOFF.md` secret list); the resulting
  host/port/credentials are supplied to the app via the `EMAIL*\*`variables in`/etc/<%ORG_SLUG%>/.env.<env>`.

---

## 13. Request correlation ID — `X-Request-ID` on every request and response

- **Source:** `code/docs/NEGATIVE-SPACE.md` Section _The error taxonomy_ — every response carries
  `X-Request-ID` and the error-tracker event is tagged with it, so a user reporting "I got an
  error" resolves to one event. App side: `code/src/django/apps/core/middleware.py`
  (`RequestIDMiddleware`, registered third in `MIDDLEWARE`, after the security headers).
  Deploy side: `deploy:` the Nginx module — a per-request identifier passed to the upstream.
- **Current status:** the app reads an inbound `X-Request-ID`, validates it against a
  conservative alphabet with a 200-character bound, and mints a UUID4 when it is absent or
  malformed. The guarantee therefore holds with **no** edge support at all; what edge support
  buys is a _single_ identifier shared by the proxy access log and the application's tracker
  events, instead of two that have to be joined on timestamp.
- **Deploy repo must implement:** pass a per-request identifier to the app in the
  `X-Request-ID` request header and record the same value in the access-log format, so both
  sides correlate. Nginx's own `$request_id` is the natural source. **Never strip or rewrite
  the header on the response** — that value is what a user quotes back. Entry 2 derives its
  dormant CSP nonce from a request identifier, so the two entries must use the same one.

---

## 14. The 503 page — the only error page Django cannot serve

- **Source:** `code/docs/NEGATIVE-SPACE.md` Section _The error taxonomy_ — an environment error is a
  `503` with `Retry-After` where the wait is known. App side: `code/src/django/templates/500.html`
  covers the programmer class, and **there is deliberately no `503.html` beside it**.
- **Why this entry exists at all.** Django defines a handler and a template name for 400, 403,
  404 and 500, and **none for 503** — there is nothing to override. More decisively, the 503 that
  matters is returned precisely when the application process is **not answering**: a deploy, a
  crash, a restart, an exhausted worker pool. A Django template cannot be rendered by a Django
  process that is down, so this page can only be a **static file the edge holds**. It is the one
  point in the error taxonomy where the build side genuinely cannot own its own expression.
- **Current status:** unimplemented on both sides, and honestly so. The app raises nothing that
  would produce a rendered 503 today — `DependencyUnavailable` exists in
  `apps/core/services/errors.py` and no outbound adapter raises it yet, because there is no
  outbound adapter. **Trigger:** the first provider integration; that story ships the app-side
  renderer, and this entry is what the edge owes regardless of it.
- **Deploy repo must implement:** a static `503` document served by Nginx for `error_page 502
503 504` and during a maintenance window, from disk rather than by proxying. It must set
  `Retry-After` where the window is known, carry `X-Request-ID` if one was generated at the edge
  (entry 13), and **never** be cached by Cloudflare. Keep it plain HTML with no asset references:
  the static tree is served by the same upstream that is failing.

---

## Post-deploy verification — the contract's acceptance checks

After any deploy, verify the contract end-to-end **through the tunnel** (the public
path — service-level `systemctl`/`docker` checks are the deploy repo's own workflows):

| Check            | Path                                                | Expect                                                   |
| ---------------- | --------------------------------------------------- | -------------------------------------------------------- |
| Liveness         | `https://<%PRIMARY_DOMAIN%>/health/`                | `200`; CSP + `X-Frame-Options` headers present (entry 1) |
| Readiness        | `https://<%PRIMARY_DOMAIN%>/health/ready/`          | `200`, `status: operational` (`HEALTH-CONTRACT.md`)      |
| API              | `GET https://<%PRIMARY_DOMAIN%>/api/…` health route | `200` JSON from the Django Ninja API                     |
| Marketing        | `https://<%PRIMARY_DOMAIN%>/`                       | `200` served by **Django** (entry 5)                     |
| Metrics lockdown | `/metrics/` from a public client                    | denied (`403`) — loopback-only (entry 8)                 |
| Workers          | `worker` + `beat` alongside `django` — once wired   | entry 11 — neither container ships at baseline           |

---

## Status summary

| #   | Requirement                     | App side (by design)              | Deploy side (per deployment — TBD)               |
| --- | ------------------------------- | --------------------------------- | ------------------------------------------------ |
| 1   | Security headers/CSP at edge    | None in-app (edge owns it)        | Baseline + per-app `cspDirectives`               |
| 2   | CSP nonce mechanism             | Dormant contract                  | Implement when a nonce surface exists            |
| 3   | CSP media hosts                 | Media surfaces render signed URLs | Add `img-src`/`media-src` allowances             |
| 4   | `client_max_body_size`          | In-app upload caps                | Set vhost limits (1 MiB default otherwise)       |
| 5   | Routing carve                   | Single Django app + Ninja `/api/` | Mirror `dev.conf` location set                   |
| 6   | TLS + `TRUSTED_PROXIES`         | Fail-safe proxy trust             | CF TLS; env value per deployment                 |
| 7   | CF Tunnel + edge rate rule      | In-app rate budget                | Tunnel + edge rate rule                          |
| 8   | Health/metrics (Gatus + scrape) | Endpoints shipped                 | Gatus + single `<%ORG_SLUG%>-backend` scrape job |
| 9   | Cloudinary token auth           | Ready                             | Account add-on + env var                         |
| 10  | Object-store public host        | boto3/presign                     | Public vhost matching endpoint URL               |
| 11  | Cache bust + worker/beat        | Cache bust only — Celery unwired  | Restart-after-migrate; worker/beat once wired    |
| 12  | Outbound mail relay             | SMTP env contract                 | SMTP path + SPF/DKIM/DMARC DNS + creds           |
| 13  | Request correlation ID          | Reads inbound, mints a fallback   | Set `X-Request-ID`, log it, never strip it       |
| 14  | The 503 page                    | None — Django cannot serve it     | Static `503` doc, `Retry-After`, never cached    |
