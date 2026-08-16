# The Stack — What Ships and Why

**Last Updated**: 14/08/2026

Every component the template ships, and the reasoning behind it. Written so you can disagree with
a specific choice rather than the whole thing.

---

## The shape

**One deployable.** A single Django ASGI process family serves the JSON API and every rendered
page. There is no separate frontend service, no bundler, no client-side framework, and no build
step between writing a template and seeing it in the browser.

That is the whole stack unless you opt into a surface. `INCLUDE_DESKTOP` adds a **native Slint
desktop app** as a member of that workspace — a real binary, not a webview, carrying a licence
obligation worth reading before you commit to it. `INCLUDE_RUST` adds a **Cargo workspace**
at `code/src/rust/` whose PyO3 extension is compiled **into** the Django process — it is the one
surface with no separate runtime, which is why its supply chain is gated harder than any Python
dependency. And `INCLUDE_MOBILE` adds a **second,
optional deployable** — a React Native app that talks to the same `/api/` a third-party client
would. It is a peer surface, not a layer: it never renders a Django page, and Django never
bundles it. See _Mobile_ below. Everything on this page describes the **web surface** unless it
says otherwise.

```text
                     ┌──────────────────────────────┐
  browser  ──HTML──▶ │  Django 6 (ASGI)             │ ──▶ PostgreSQL 18
           ◀─HTMX──  │   templates + components     │ ──▶ Valkey (cache, broker)
                     │   Django Ninja  →  /api/     │ ──▶ Cloudinary / SeaweedFS
  API client ─JSON─▶ └──────────────────────────────┘
                              ┊
                     Celery worker + beat  (declared, not wired)
```

The dotted leg is the one part of that picture the template does not ship: `celery[redis]` is a
declared dependency, but no Compose file defines a `worker` or `beat` service and no `CELERY_*`
setting exists yet. Wiring it is a deliberate change — `how-to/docs/CELERY-FIRST-RUN.md`.

---

## Server

| Component              | Version | Why this                                                                                                                                                                                                                                           |
| ---------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Python**             | ≥ 3.14  | Current stable; the template pins it in `.python-version` and every Dockerfile.                                                                                                                                                                    |
| **Django**             | ≥ 6.1   | The batteries — ORM, migrations, auth, admin, forms — are the reason this is a monolith at all. Rewriting them is where template time goes to die.                                                                                                 |
| **Django Ninja**       | ≥ 1.3   | Typed request/response Schemas over plain Django views, with automatic OpenAPI. Chosen over DRF for Pydantic types and less ceremony; chosen over GraphQL because a single-client app does not need query flexibility and does pay its complexity. |
| **PostgreSQL**         | 18      | Row-level security, real constraints, `CHECK`, partial and concurrent indexes, full-text search. The template enforces invariants in the database, which needs a database that can hold them.                                                      |
| **Valkey**             | latest  | BSD-licensed Redis fork, reached through `django-valkey`. DB 0 is the Celery broker, pub/sub and rate limiting; DB 1 is the cache.                                                                                                                 |
| **Celery**             | ≥ 5.6   | Worker and beat for background work, scheduled jobs, anything that must not block a request. **Declared, not wired at baseline** — no `worker`/`beat` service ships in any Compose file.                                                           |
| **Gunicorn + Uvicorn** | latest  | Gunicorn process management with Uvicorn ASGI workers.                                                                                                                                                                                             |
| **WhiteNoise**         | ≥ 6.12  | Hashed, pre-compressed static files served from the app process itself, so the backend container is hermetic — no static volume and no separate static server.                                                                                     |
| **Nginx**              | latest  | Reverse proxy in dev and test. In staging and production the edge is Cloudflare and the server deploy repo — security headers are set there, never in this repo.                                                                                   |

A dependency floor is not a pin — it forbids older versions and leaves the resolver to pick. Some
floors are also capped by something else in the graph: `celery[redis]` excludes `redis>=6.5`, so
`redis>=6.0` resolves to 6.4.x however new the registry gets. Raise one deliberately and
re-resolve in the same change (`code/src/scripts/dependencies/update.sh`).

Declared alongside them and wired incrementally: `django-htmx`, `django-components`,
`django-ratelimit`, `django-cors-headers`, `django-prometheus` (the `/metrics/` endpoint),
`sentry-sdk[django]`, `argon2-cffi`, `cryptography`, `boto3` (the S3 API), and the Cloudinary
storage pair.

## Client

| Component             | Why this                                                                                                                                                                                |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Django templates**  | The page is rendered where the data is. No serialisation round-trip for content that was already in the database.                                                                       |
| **django-components** | One server-side component library with co-located template, CSS and Python. (django-cotton was dropped — it conflicts with django-components' global template-compilation monkeypatch.) |
| **HTMX**              | Server operations that swap HTML fragments. Covers the overwhelming majority of interactivity without shipping an application to the browser.                                           |
| **Alpine**            | Local, instant interactions that should not touch the network — disclosure, tabs, menus.                                                                                                |
| **Vanilla CSS**       | Custom properties driven by design tokens. No preprocessor, no utility framework, no build.                                                                                             |

**The three-tier rule** (web surface). Full template for navigation and content; HTMX for server
operations; Alpine for local state. Anything that appears to need a fourth tier is a stack change
and needs an ADR. `code/docs/RENDERING.md` is the arbiter. A mobile app is not a fourth tier — it
renders no Django page, so it does not reopen this rule.

**Consequences accepted:** pages must work with JavaScript disabled, every link is a real
`<a href>`, `hx-boost` is banned, and a page never calls the JSON API — Ninja serves machine
clients only.

## Mobile — optional, off by default

Answering `INCLUDE_MOBILE` with yes adds an **Expo** React Native + TypeScript app at
`code/src/mobile/`. Say no and you get a repository functionally identical to one generated
before mobile existed — no orphaned tooling, CI jobs, scripts or doc rows.

| Component                    | Why this                                                                                                                  |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **Expo** (managed, CNG)      | `ios/` and `android/` are gitignored artefacts regenerated from config, not committed source. Reasoning below.            |
| **TypeScript**               | Self-contained in the mobile workspace — its own `tsconfig`, `typescript-eslint` and typecheck. The web surface has none. |
| **expo-router**              | A file-system routing _convention_, shipped with a single route. Not a navigation shape: no tabs, no drawer, no screens.  |
| **`StyleSheet` over tokens** | No styling library. Design tokens cross as a generated typed module; the CSS values and delivery do not.                  |
| **jest-expo + RNTL**         | Same coverage numbers as the backend, enforced per runtime — Jest and coverage.py share no accumulator.                   |

### Why Expo rather than bare React Native

Three constraints decided this, and none of them is a preference.

1. **Copier renders every file.** `copier.yml` sets `_templates_suffix: ""`, so the entire tree
   passes through Jinja — which is also why `*.pdf` is excluded, since **binaries cannot be
   rendered**. A bare React Native scaffold commits binaries as a matter of course: the Gradle
   wrapper JAR, launcher icon PNGs, iOS asset catalogues. Each would need an explicit exclusion
   entry, maintained in perpetuity against an upstream scaffold this template does not control,
   or generation fails outright. Expo's Continuous Native Generation presents Copier a
   **text-only tree**, and the problem disappears rather than being managed.
2. **The repository is pnpm-only.** Metro historically needs hand-maintained `watchFolders` and
   `nodeModulesPaths` entries under pnpm or module resolution fails on cold start. Expo's
   `metro-config` ships workspace support, so this is handled upstream instead of by hand.
3. **iOS needs macOS.** Expo Go runs the app on an iPhone from a Linux host, which is the only
   way to develop for iOS here without macOS hardware or paid EAS cloud builds — both out of
   scope. Bare React Native leaves iOS undevelopable on Linux.

Constraint 1 is the deciding one. Bare React Native, and the hybrid "Expo tooling with native
directories committed", both buy full native access — at the price of an indefinitely
maintained binary exclusion list — for a skeleton that ships no native code and therefore
cannot use it. The hybrid is strictly worse than either: it reintroduces the binaries _and_
forfeits the regeneration-based upgrade path that is the main reason to adopt Expo at all.

### The four terms, and what they cost you

1. **Native directories stay gitignored.** The template optimises for the generation moment. If
   your project later needs custom native code, run `expo prebuild` and own that maintenance as
   your decision — see `12-EXTENDING.md`.
2. **The Expo SDK is pinned exactly**, matching the frozen posture of every other toolchain here
   (`uv sync --frozen`, `pnpm install --frozen-lockfile`, pinned `.nvmrc` and `.python-version`).
   An SDK bump is a versioned template release you pull through `copier update`.
3. **The day-one loop is Expo Go**, so prerequisites stay Node, pnpm and the Expo Go app. Its
   SDK-only library limit binds you until you graduate to a development build.
4. **expo-router with one route** — a routing convention only.

**The standing cost, stated plainly:** Expo ships roughly three SDK releases a year, each
potentially breaking for projects downstream — SDK 55 required the New Architecture and removed
`newArchEnabled`. You are accepting a framework dependency neither you nor this template controls.
If that is unacceptable, answer no and add React Native yourself; nothing else in the repository
assumes mobile exists.

**Who carries that cost is split, and the rule is not here.** The template follows every SDK
release and cuts a template release for it; your project adopts one when it prepares a store
build. Both halves, and what to check before adopting, are owned by
[`code/src/mobile/CLAUDE.md`](../../../code/src/mobile/CLAUDE.md).

## Data, media and identity

| Component      | Role                                                                                           |
| -------------- | ---------------------------------------------------------------------------------------------- |
| **Cloudinary** | Public media — upload, transformation, delivery. Vendored SDK docs and skills ship with it.    |
| **SeaweedFS**  | Private document storage. The **default answer to `OBJECT_STORE`**, not a fixture — see below. |
| **Fernet**     | Field-level PII encryption with lookup tokens (`code/docs/ENCRYPTION-GUIDE.md`).               |
| **Argon2**     | Password hashing.                                                                              |

**Six of the products named on this page are answers, not fixtures.** `OBJECT_STORE`,
`ERROR_TRACKING`, `LOG_AGGREGATOR`, `OBSERVABILITY_STACK`, `TRACING_BACKEND` and
`ANALYTICS_PROVIDER` each record a **choice behind an interface** — the S3 API consumed via
boto3, the Sentry SDK wire protocol, structured JSON on stdout, the Prometheus exposition format,
OTLP, and this project's own event ingestion API respectively. Answer any of them differently and
you are still on-doctrine. The verdicts and the evidence each demands:
`code/docs/architecture/PROVIDER-NEUTRALITY.md`; the per-project register is
`how-to/src/PLATFORM-PROVIDERS.md`.

**PostgreSQL is deliberately absent from that list.** It is substrate, not a choice — swapping it
is a fork.

## Testing

| Tool                       | Covers                                                                                 |
| -------------------------- | -------------------------------------------------------------------------------------- |
| **pytest + pytest-django** | Services, Ninja endpoints, views, templates, components and HTMX partials — one suite. |
| **Bruno**                  | HTTP-layer API integration tests, committed as `.bru` files.                           |
| **Playwright + axe-core**  | The few things needing a real browser, plus automated accessibility checks.            |
| **mutmut**                 | Mutation testing, for when coverage percentage stops being informative.                |

Coverage floors: **75 % line and branch, 90 % on auth code.** Stubs written to reach the floor are
explicitly not acceptable.

## Tooling

| Tool                  | Role                                                                                                |
| --------------------- | --------------------------------------------------------------------------------------------------- |
| **uv**                | Python dependency resolution and locking. Every Dockerfile `uv sync --frozen`.                      |
| **pnpm**              | Repo tooling, plus the mobile workspace if you included it. The web surface has no bundle to build. |
| **ruff**              | Python lint and format, 100-column lines.                                                           |
| **basedpyright**      | Static type checking in `standard` mode; annotations required.                                      |
| **Prettier**          | CSS, JSON, YAML, Markdown, HTML.                                                                    |
| **markdownlint-cli2** | Markdown, including the fenced-language rule.                                                       |
| **Lefthook**          | Pre-commit hooks, run in parallel.                                                                  |
| **Docker Compose**    | dev, test, staging and prod, plus per-worktree overrides.                                           |

## Deployment target

**You can deploy this anywhere.** The application is an ordinary Docker Compose deployable — a
single Django ASGI container (plus a Celery worker and beat once that is wired), talking to a
Postgres and a Valkey it does not care about the provenance of. Anything that runs Linux and Docker will host it: a
DigitalOcean droplet, an EC2 instance, Fly.io, Railway, a Kubernetes cluster, or a box under your
desk. Managed Postgres and managed Redis-compatible caches drop straight in — they are reached by
URL, not by assumption.

**But the documentation is written against one specific target**, because a contract nobody has
implemented is a contract nobody has tested:

| Layer             | What Syntek uses          | Why it is written that way                                           |
| ----------------- | ------------------------- | -------------------------------------------------------------------- |
| Host              | Hetzner bare metal        | Best price per core for a monolith that scales vertically first      |
| OS / provisioning | NixOS + a deploy repo     | Declarative hosts, reproducible rebuilds, `agenix` for secrets       |
| Edge              | Cloudflare with CF Tunnel | No inbound ports open; TLS, WAF, caching and CSP all set at the edge |
| Reverse proxy     | Nginx                     | In dev and test only — the edge handles it in staging and production |

So: **if you deploy elsewhere, expect to adjust — not to fight.** The split is deliberate. This
repository _specifies_ what the server must provide, in provider-neutral terms, and never
implements it. The specification lives in `how-to/src/SERVER-ARCHITECTURE/`: processes, ports,
volumes, environment variables, health and metrics endpoints, edge requirements, and compute
allocation. Read it as a checklist for whatever platform you actually use.

What travels unchanged to any provider:

- the application, its Dockerfiles and its Compose files
- the `SERVER-ARCHITECTURE/` contract — it names requirements, not products
- the health and metrics endpoints (`code/docs/logging/HEALTH-CONTRACT.md`)
- the promotion chain, CI, and the GHCR image build

What is Hetzner/NixOS/Cloudflare-shaped and will need rework:

- the `DEPLOY_REPO` answer and the NixOS deploy repository it names
- `SERVER-ARCHITECTURE/NIXOS-HANDOFF.md` — the handoff format, and `agenix` secret names
- `how-to/src/NIXOS-SETUP.md` — a pointer stub to provisioning runbooks that assume NixOS
- the CF Tunnel assumption. This one has a real consequence: **because the edge terminates TLS and
  sets the security headers, this repo deliberately ships no CSP middleware and no TLS config.**
  On a platform without an equivalent edge, you must put those somewhere — a reverse proxy you
  control, or middleware you add — or the controls simply do not exist. `SERVER-ARCHITECTURE/`
  flags every such requirement.

None of this is load-bearing for the application. It is load-bearing for the _runbooks_.

See `13-DEPLOYMENT.md` for the path to a server, and `11-CUSTOMISING.md` for what changing it
costs.

---

## Deliberately absent

| Not shipped               | Why                                                                                                                                                                                                             |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **React / Next.js**       | _On the web surface._ A second process family, a build step, and a serialisation boundary — for interactivity HTMX already covers. React on a **device** is a different question, answered by `INCLUDE_MOBILE`. |
| **GraphQL**               | Solves client-driven query flexibility. There is one client, and it is the server.                                                                                                                              |
| **django-csp**            | Security headers are set at the edge in the deploy repo. Setting them in two places means they disagree.                                                                                                        |
| **A CSS framework**       | Design values are DB-canonical tokens; component CSS consumes `var(--token)` only, audited by `code/src/scripts/audits/css-tokens.sh`.                                                                          |
| **Channels / WebSockets** | Real-time changes the process model. It is an ADR conversation, not a dependency addition.                                                                                                                      |

Dependencies deliberately not declared at baseline are listed in `pyproject.toml` with the
feature that should introduce each one:

| Not declared                    | Introduced by                                                      |
| ------------------------------- | ------------------------------------------------------------------ |
| `pyotp` · `qrcode` · `webauthn` | TOTP and passkey ceremonies — the `authentication` skill           |
| `bleach`                        | Sanitising user-authored HTML                                      |
| `python-magic` · `pyclamd`      | Upload MIME sniffing and ClamAV scanning                           |
| `channels` · `channels-redis`   | ASGI WebSockets — a stack change argued in an ADR, not an install  |
| `cairosvg`                      | SVG rasterisation for an asset pipeline                            |
| `maturin`                       | **Rust-only.** Declared in the PyO3 crate's own manifest, not here |
| `fastmcp`                       | The FastMCP tool surface at `/mcp/`                                |

`fastmcp` is the largest of them: it would add a tool surface at `/mcp/` for LLM agent clients,
mounted beside Django in `config/asgi.py` and therefore outside Django's middleware entirely.
Fully specified in `code/docs/MCP-SERVER.md`, built only when an agent genuinely needs to carry
out this project's domain operations — a Ninja endpoint is already callable by anything that
speaks HTTP.

---

## Next

- What you need installed → `03-PREREQUISITES.md`
- Generate a project → `04-QUICKSTART.md`
- Change one of these choices → `11-CUSTOMISING.md`
