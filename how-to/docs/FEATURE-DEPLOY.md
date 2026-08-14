---
type: guide
skills: [cicd, global-workflow]
model: opus
---

# Feature Deploy-Coordination — Edge & Account Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — deploy-coordination checklist for a feature's edge & account steps

> These are the classes of item a feature needs that are **not** configured in this
> repository. They live at the **edge** (the NixOS deploy repo / Cloudflare) or in a
> **provider account** (media CDN, object store, secret store), and must be applied by <%DEVELOPER_NAME%>
> during the staging/prod rollout. The in-repo work (dev/test body-size caps, seeded tokens,
> the beat-schedule entry) ships committed with the feature; this guide covers only what the
> application repo cannot set for itself.
>
> None of these block application-layer work — dev/test run without an enforced CSP or a real
> edge Nginx. They are staging/prod deploy-coordination items. Treat the five sections as
> reusable **classes**: when a feature introduces one of these needs, apply that class.

Cross-references: `GAPS.md` (track each unresolved edge/account item there),
`code/src/docker/nginx/CONTEXT.md` (the server-Nginx action items), and
`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — **the edge contract these classes map
onto**. Every item below corresponds to an entry in that contract; add there first, apply here.

---

## Class 1 — New external delivery hosts → edge CSP

**When:** a feature renders media from a **new external host** — for example a media CDN
(Cloudinary, `res.cloudinary.com`) and the object store's public host
(`OBJECT_STORE_PUBLIC_ENDPOINT_URL`, the private-docs S3 surface).

**Where:** the NixOS deploy repo (edge) / Cloudflare — **not** this repo. Security headers
(including CSP) are set at the edge (`code/src/django/templates/base.html` header comment
notes this).

**Why:** a view renders the media as `<img>` / `<video>` / download `<a>` against those hosts.
On a CSP-enforcing environment they are blocked from rendering until allow-listed. Add them to
`img-src` and `media-src` (and `connect-src` only if a host is fetched via `fetch`/XHR rather
than a plain element load).

**Production directives (paste into the edge CSP):**

```text
img-src   'self' data: https://res.cloudinary.com https://storage.<%PRIMARY_DOMAIN%>;
media-src 'self' https://res.cloudinary.com https://storage.<%PRIMARY_DOMAIN%>;
connect-src 'self' https://res.cloudinary.com https://storage.<%PRIMARY_DOMAIN%>;
```

**Staging directives** (object-store host differs):

```text
img-src   'self' data: https://res.cloudinary.com https://storage.staging.<%PRIMARY_DOMAIN%>;
media-src 'self' https://res.cloudinary.com https://storage.staging.<%PRIMARY_DOMAIN%>;
connect-src 'self' https://res.cloudinary.com https://storage.staging.<%PRIMARY_DOMAIN%>;
```

**Notes:**

- `res.cloudinary.com` is the default Cloudinary delivery host. If the account uses a private
  CNAME / sub-domain for delivery, add that host too.
- The object-store host must match `OBJECT_STORE_PUBLIC_ENDPOINT_URL` exactly
  (`.env.staging` / `.env.prod`). If that value changes, update the directive.
- Merge these hosts into the **existing** `img-src`/`media-src` lists — do not replace them.

---

## Class 2 — Large uploads → edge Nginx `client_max_body_size`

**When:** a feature accepts multipart uploads with a per-request cap larger than the default
edge body limit.

**Where:** the staging/prod server Nginx in the NixOS deploy repo — **not** this repo.

**Why:** Django's multipart parser streams every part to a temp file on disk **before** the
in-app caps (and any MFA gate) run, so the app caps do not bound the **total** request body.
The bounding control is the edge `client_max_body_size`. This mirrors the dev/test change that
ships in `code/src/docker/nginx/{dev,test}.conf`.

**Sizing:** compute the cap from the app's upload settings — `max files × max bytes per file`,
plus margin for the multipart envelope. Keep the edge value in sync with those settings
(`code/src/django/config/settings/base.py`). Example: 10 files × 25 MiB ≈ 250 MiB → set
**256M**.

**Scope it to the upload-accepting upstreams only** — keep the low server-level limit elsewhere
as a DoS control. Add `client_max_body_size` to the proxy locations that receive the upload
(any exact-match streaming/SSE carve is a GET and needs no cap):

```nginx
# Mirror of dev.conf/test.conf. Any exact-match stream block must be
# declared first and win over the prefix location below.
location ~ ^/<upload-upstream>(/|$) {
    client_max_body_size 256M;   # = max files x max bytes per file + margin
    proxy_pass http://127.0.0.1:8000;   # single Django ASGI app process
}
```

An over-cap body is then rejected at the edge with `413` before it reaches Django's parser.
Optionally tune `DATA_UPLOAD_MAX_MEMORY_SIZE` / `FILE_UPLOAD_MAX_MEMORY_SIZE` if the temp-disk
spill threshold needs adjusting.

---

## Class 3 — Provider secrets → secret store

**When:** a feature needs a **provider secret** the repo must never carry — for example a media
auth-token key that upgrades private delivery to short-lived tokens.

**Where:** the provider **account** + the staging/prod secret store — **not** this repo.

**Why (worked example — media token auth):** the media service's signed-delivery helper mints
delivery URLs for private (`type=authenticated`) assets. When `CLOUDINARY_AUTH_TOKEN_KEY` is
set it issues **short-TTL token-authenticated** URLs (`auth_token`, time-limited). When the key
is **absent** it falls back to signature-only (`sign_url=True`) — the URL still works, but it is
not token-gated / short-lived. **No breakage either way**; the key upgrades delivery to expiring
tokens.

**Steps:**

1. In the provider console, enable the feature (for Cloudinary: **Token-based Authentication**,
   Settings → Security; an add-on on some plans).
2. Generate the **key** (a shared secret, distinct from the account `api_secret`).
3. Provision it as the env secret (here `CLOUDINARY_AUTH_TOKEN_KEY`) in the **staging** and
   **production** secret stores. The `.env.*.example` templates carry the empty key name only.
4. Restart the backend so the new value is loaded.

> **Secret handling:** set the real value only in the secret store. **Never** commit it to the
> repo — the `.env.*.example` templates carry the empty key name only.

---

## Class 4 — New periodic task → Celery worker + beat must run

**When:** a feature adds a `CELERY_BEAT_SCHEDULE` entry (a new periodic task).

**Where:** every environment that serves the feature (staging + prod; dev locally).

**Why:** a scheduled task only fires if **beat** is scheduling it **and** a **worker** is
executing it. Without both, the feature degrades to whatever fallback the app provides (often
client-side only), not a hard break — but the periodic behaviour never runs.

**Requirement:** a `celery -A config beat` process **and** a `celery -A config worker` process
must run in each target environment. `beat` schedules; the `worker` executes.

**Mechanism:**

- The shared `entrypoint.*.sh` scripts honour a passed command — after the migrate/collectstatic
  setup and before the default web-server exec they run
  `if [ "$#" -gt 0 ]; then exec "$@"; fi`. So a `worker`/`beat` container (passing
  `command: celery -A config worker|beat …`) execs Celery, while the `django` container (no
  command) still execs the Django ASGI server unchanged.
- The staging/prod Compose files must define `worker` + `beat` services alongside `django`
  (with `CELERY_BROKER_URL`), so the environment can schedule and process. **Neither service
  ships at baseline** — Celery is declared in `pyproject.toml` and wired by the first feature
  that needs it; adding them is part of that work.

A new schedule entry is **inert** until each environment is **redeployed** with the new image
and its `worker`/`beat` services started. Enabling is a **deliberate, per-environment** act.

**Before enabling, run the first-run review → `how-to/docs/CELERY-FIRST-RUN.md`.** It enumerates
every `CELERY_BEAT_SCHEDULE` task and its first-run risk in a long-lived environment —
destructive tasks (run the dry-run count first), the queued-task backlog the worker drains on
first connect, and any blocker to fix before enabling beat.

Until each environment is enabled, the feature stays on its fallback path there.

---

## Class 5 — Seeded token/asset → cache bust on deploy restart

**When:** a migration **seeds new design-token values** (or another cached asset) that a
read-through cache would otherwise keep serving stale.

**Where:** the deployed backend, at rollout.

**Why:** a seed migration deliberately does **not** touch Valkey, so the read-through `css_cache`
keeps serving the pre-migration `/assets/tokens.css` until busted — the new tokens then fail to
apply (e.g. a seeded colour renders as its fallback) until the cache is cleared. Whether this is
cosmetic or functional depends on the token; either way the deploy must bust the cache.

**Action (any one):**

- **Prod/staging:** the deploy **backend restart** clears the cache automatically — no extra
  step, provided the deploy restarts the backend container after `migrate`.
- **Admin action:** run the design-token regeneration admin action — it calls
  `invalidate_tokens_css()`; the next request re-renders the CSS.
- **Dev:** restart the backend —
  `bash code/src/scripts/development/server.sh restart --service backend`.

Confirm afterwards that `/assets/tokens.css` contains the newly seeded token variables.

---

## Rollout checklist

Run in this order for a staging/prod feature deploy:

1. **Secrets** — set any provider secret in the secret store (Class 3).
2. **Edge CSP** — add any new delivery hosts to `img-src`/`media-src` (Class 1).
3. **Edge Nginx** — add `client_max_body_size` to the upload upstreams (Class 2); reload the
   server Nginx.
4. **Celery** — confirm `worker` + `beat` actually run Celery in the target env, and complete
   the first-run review (`how-to/docs/CELERY-FIRST-RUN.md`) before enabling the schedule
   (Class 4).
5. **Deploy** the backend images; the restart applies the migration and busts the token CSS
   cache (Class 5).
6. **Verify:**
   - a max multi-file upload succeeds (no `413` at the edge);
   - a media `<img>`/`<video>` from the new host renders (CSP allows it);
   - `/assets/tokens.css` carries the newly seeded tokens;
   - the new periodic task fires on its schedule (worker log shows execution).

---

## Ownership summary

Track each unresolved item in `GAPS.md` against the owner below, and keep the matching entry in
`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` current.

| Class | Item                     | Owner                            |
| ----- | ------------------------ | -------------------------------- |
| 1     | Edge CSP delivery hosts  | NixOS deploy repo / Cloudflare   |
| 2     | Edge Nginx body-size cap | NixOS deploy repo (server Nginx) |
| 3     | Provider secret          | provider account + secret store  |
| 4     | Celery worker + beat     | `cicd` (per-env enablement)      |
| 5     | Token/asset cache bust   | deploy step (backend restart)    |

Provider-account actions (Class 3) and cache-bust steps (Class 5) carry no code change — track
them on the feature's release checklist.

## Two standing conditions on the pipeline itself

Neither is per-feature, and neither is visible from a diff — they are properties of how the
pipeline is configured, so they are recorded here rather than rediscovered at the first
production deploy:

- **A production deploy requires manual approval**, through a GitHub Environment protection
  rule rather than a convention anyone remembers. Staging deploys on merge; production waits for
  a person. The rule lives on the environment, so a workflow edit cannot remove the gate by
  accident.
- **The container runs as a non-root user and sensitive ports are never published** to the host
  or the internet — the database, the broker and the metrics endpoint reach the application over
  the Compose network only. The `USER` directive that enforces the first is a Dockerfile
  requirement in `code/docs/security/SECRETS-AND-TRANSPORT.md`.
