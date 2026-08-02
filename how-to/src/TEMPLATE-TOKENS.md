# Template Tokens — the Contract `copier.yml` Implements

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

This repository is a **reusable base template** — the starting point for every new project,
whether built for an external client or internally. Project-, organisation-, and
deployment-specific values are written as `<%…%>` tokens and rendered by
[Copier](https://copier.readthedocs.io/); the two architecture snapshots
(`SCALE-ARCHITECTURE/`, `SERVER-ARCHITECTURE/`) are **skeletons** regenerated from the new
project's live code.

This file is the single source of token truth: what every token means, what to substitute, and
what deliberately stays fixed. `copier.yml` at the repo root is the executable form of this
contract — if the two ever disagree, `copier.yml` wins and this file is the bug.

> **Reading this to generate a project?** You want `TEMPLATE-GUIDE/04-QUICKSTART.md`. This file is
> the reference behind it.

> **Scope.** The token vocabulary spans the whole repository — all documentation (`.md`), operator
> guides, and configuration (Compose, CI, `pyproject.toml`, `package.json`, Bruno,
> `.env.*.example`). Application **source code** (`.py`, `.html`, `.css`) is not hand-tokenised;
> it receives the rendered values through settings and templates.

---

## Why `<%TOKEN%>` and not `{{TOKEN}}`

Copier renders through Jinja2, and this repository is full of content that already speaks Jinja's
default dialect. Three collisions ruled out `{{ }}`, and a fourth ruled out the obvious
alternative:

| Syntax                          | Where it lives                          | What the delimiters would do         |
| ------------------------------- | --------------------------------------- | ------------------------------------ |
| `${{ github.* }}`               | 9 GitHub Actions workflow files         | blanked, leaving a bare `$`          |
| `{% … %}` / `{{ field.label }}` | Django template examples in 29 docs     | parsed as Jinja, or silently blanked |
| `{{api_url}}`                   | Bruno `.bru` request files              | silently blanked                     |
| `[[ "$x" == "y" ]]`             | bash test syntax throughout the scripts | ruled out `[[ ]]` as the alternative |

The delimiters below were chosen by scanning every tracked file and verifying zero occurrences:

| Purpose  | Opens | Closes |
| -------- | ----- | ------ |
| Variable | `<%`  | `%>`   |
| Block    | `<:`  | `:>`   |
| Comment  | `<~`  | `~>`   |

They are set in `copier.yml` under `_envops`. If you ever add content to the template containing
one of these six sequences literally, wrap it in `<: raw :>` … `<: endraw :>`.

---

## The tokens

Twenty-four tokens carry every project-specific value. Copier prompts for all of them, except the
two mobile tokens, which are asked only when the mobile frontend is included. Example
values are illustrative — replace them.

### Identity

| Token              | Meaning                                                   | Example value | Format       |
| ------------------ | --------------------------------------------------------- | ------------- | ------------ |
| `<%PROJECT_NAME%>` | Human-readable project / product name                     | `Acme Portal` | free text    |
| `<%PROJECT_SLUG%>` | Kebab machine slug — packages, DB, infra resource names   | `acme-portal` | `kebab-case` |
| `<%ORG_NAME%>`     | Organisation / maintainer / brand (doc headers, licence)  | `Acme Ltd`    | free text    |
| `<%ORG_SLUG%>`     | Org machine slug — marketplace, plugins, server namespace | `acme`        | `kebab-case` |

### Infrastructure

| Token                | Meaning                                             | Example value                                  | Format                  |
| -------------------- | --------------------------------------------------- | ---------------------------------------------- | ----------------------- |
| `<%PRIMARY_DOMAIN%>` | The project's apex domain                           | `acme.com`                                     | bare domain (no scheme) |
| `<%DEPLOY_REPO%>`    | The forked NixOS deploy repo for this project       | `acme-nixos-client-deployment`                 | repo name               |
| `<%SERVER_TIER%>`    | The provisioned host tier (+ its CPU/RAM/disk spec) | `Hetzner AX42-U` (8c/16t Zen 4 · 64 GB · NVMe) | free text               |
| `<%ENV_PREFIX%>`     | Uppercase env-var / server namespace prefix         | `ACME`                                         | `UPPER_SNAKE`           |

### Locale, licence, and people

| Token                 | Meaning                                           | Example value                       | Format           |
| --------------------- | ------------------------------------------------- | ----------------------------------- | ---------------- |
| `<%LOCALE%>`          | Default application locale                        | `en_GB`                             | POSIX locale     |
| `<%TIMEZONE%>`        | Default application timezone                      | `Europe/London`                     | IANA tz          |
| `<%CURRENCY%>`        | Default currency                                  | `GBP`                               | ISO 4217         |
| `<%LICENCE%>`         | Source licence **of your project**                | `Proprietary — all rights reserved` | free text / SPDX |
| `<%DEVELOPER_NAME%>`  | Lead developer (identity block, commit co-author) | `Alex Doe`                          | free text        |
| `<%DEVELOPER_EMAIL%>` | Lead developer email                              | `dev@acme.com`                      | email            |

> **`<%LICENCE%>` is your project's licence, not this template's.** syntek-base is MIT, which
> places no obligation on what you generate from it — proprietary is a valid answer, and the
> default.

### Django apps

The apps the documentation refers to by role. Only the **names** are tokenised — the layout
(`code/src/django/apps/<app>/`) is fixed. Defaults are the conventional names; override where a
project calls the app something else. An app a project does not have (e.g. no user-authored
content) keeps its default, and the doc rows that mention it can be deleted afterwards.

| Token                   | Meaning                                          | Example value   | Format       |
| ----------------------- | ------------------------------------------------ | --------------- | ------------ |
| `<%IDENTITY_APP%>`      | App owning users, credentials, sessions, consent | `users`         | `snake_case` |
| `<%AUDIT_APP%>`         | App owning the append-only audit/event log       | `audit`         | `snake_case` |
| `<%CONTENT_APP%>`       | App owning user-authored content                 | `content`       | `snake_case` |
| `<%NOTIFICATIONS_APP%>` | App owning notifications and their delivery      | `notifications` | `snake_case` |
| `<%LEGAL_APP%>`         | App owning cookie consent and legal pages        | `legal`         | `snake_case` |
| `<%CORE_APP%>`          | App owning shared primitives (e.g. encryption)   | `core`          | `snake_case` |

`apps.marketing`, `apps.seo`, and `apps.design_tokens` are **house constants**, not tokens — they
are the same in every project and stay literal.

### Mobile frontend (optional)

The opt-in React Native + TypeScript app at `code/src/mobile/`. `<%INCLUDE_MOBILE%>` gates the
whole feature: when it is false, the mobile tree and `code/src/scripts/mobile/` are excluded by a
templated `_exclude` entry, and the two tokens below are never asked. A web-only generation is
identical to one produced before the mobile option existed.

| Token                  | Meaning                                   | Example value | Format         |
| ---------------------- | ----------------------------------------- | ------------- | -------------- |
| `<%INCLUDE_MOBILE%>`   | Generate the React Native mobile frontend | `false`       | `bool`         |
| `<%MOBILE_APP_NAME%>`  | Display name under the app icon on device | `Acme Portal` | free text      |
| `<%MOBILE_BUNDLE_ID%>` | iOS bundle identifier / Android app ID    | `com.acme`    | reverse-domain |

`<%MOBILE_BUNDLE_ID%>` is **permanent once the app is published** to either store — changing it
later creates a new app rather than updating the existing one.

### Rust surface (optional)

The opt-in Cargo workspace at `code/src/rust/` — PyO3 extension modules, standalone binaries and
CLI tools. `<%INCLUDE_RUST%>` gates the whole feature: when it is false, the workspace, its
scripts, its guides, its workflow, its CI job, and its `rust` agent + `stack-rust` skill are all
excluded by templated `_exclude` entries.

| Token              | Meaning                                     | Example value | Format |
| ------------------ | ------------------------------------------- | ------------- | ------ |
| `<%INCLUDE_RUST%>` | Generate the Rust workspace and its tooling | `false`       | `bool` |

**It gates authoring, not consuming.** A project that merely depends on a prebuilt PyO3 wheel
installs it like any other dependency and needs no Rust toolchain — such a project answers
`false`. Answer `true` only when the repository itself compiles Rust.

Answering `true` makes `rustup` a prerequisite for `uv sync` and adds a Rust stage to the backend
image, because the extension crate is a uv workspace member built by maturin. That cost is why
the default is `false`.

The crate and its Python module are named `nativecore` in every project — a **house constant**
like `apps.marketing`, deliberately not tokenised so `import nativecore` means the same thing
across the estate.

### Desktop surface (optional)

The opt-in native desktop application built with **Slint**, living as a member of the Rust
workspace at `code/src/rust/crates/desktop/`. `<%INCLUDE_DESKTOP%>` gates it, and is only asked
when `<%INCLUDE_RUST%>` is true — Slint is Rust.

| Token                  | Meaning                           | Example value | Format    |
| ---------------------- | --------------------------------- | ------------- | --------- |
| `<%INCLUDE_DESKTOP%>`  | Generate the native desktop app   | `false`       | `bool`    |
| `<%DESKTOP_APP_NAME%>` | Window title and application name | `Acme Portal` | free text |

**Licence obligation.** The app ships under Slint's **Royalty-free** tier: free for proprietary
applications _and commercial sale_, in exchange for **disclosing that you use Slint**. The
generated app does this with the `AboutSlint` widget, and `code/src/scripts/desktop/package.sh`
refuses a release build without it.

Two things that tier does not cover: **embedded systems** (an appliance screen, a POS terminal, a
car dashboard — those need a paid Commercial licence), and **redistributing anything that exposes
Slint's own APIs**, which is why desktop UI is never moved into a shared package layer.

### Meta

| Token      | Meaning                                                   | Example value | Format       |
| ---------- | --------------------------------------------------------- | ------------- | ------------ |
| `<%DATE%>` | The doc's _Last Updated_ / baseline date, set per project | `22/07/2026`  | `DD/MM/YYYY` |

> **`<%DATE%>` is answered, not computed.** It is stored in `.copier-answers.yml` and reused on
> every `copier update`, so an update never churns 280 doc headers to today's date.

---

## Computed defaults

Copier derives these from earlier answers — press Enter to accept:

| Token                  | Derived from                                     |
| ---------------------- | ------------------------------------------------ |
| `<%PROJECT_SLUG%>`     | `<%PROJECT_NAME%>` lowercased, spaces → `-`      |
| `<%ORG_SLUG%>`         | `<%ORG_NAME%>` lowercased, spaces → `-`          |
| `<%ENV_PREFIX%>`       | `<%ORG_SLUG%>` uppercased, `-` → `_`             |
| `<%PRIMARY_DOMAIN%>`   | `<%PROJECT_SLUG%>.com`                           |
| `<%DEPLOY_REPO%>`      | `<%PROJECT_SLUG%>-nixos-client-deployment`       |
| `<%MOBILE_APP_NAME%>`  | `<%PROJECT_NAME%>`                               |
| `<%MOBILE_BUNDLE_ID%>` | `<%PRIMARY_DOMAIN%>` label-reversed, `-` removed |

---

## Derived forms — where a token composes into a larger identifier

When a token is substituted, these compound names resolve automatically — do **not** tokenise
them separately.

**From `<%PROJECT_SLUG%>`:**

- Databases — `<%PROJECT_SLUG%>_dev` · `_test` · `_staging` · `_prod`
- Docker Compose project / bridge network — `<%PROJECT_SLUG%>` · `<%PROJECT_SLUG%>-net`
- Dev hostnames — `dev.<%PROJECT_SLUG%>.localhost` · object-store host `s3.<%PROJECT_SLUG%>.localhost`
- CF Tunnel service / token secret — `cloudflared-<%PROJECT_SLUG%>` · `cloudflared-<%PROJECT_SLUG%>-token.age`
- App-env / Valkey-ACL secret — `<%PROJECT_SLUG%>-env.age` · Mail DKIM — `mail-dkim-<%PROJECT_SLUG%>.age`

**From `<%ORG_SLUG%>` / `<%ENV_PREFIX%>`:**

- Claude Code marketplace + plugins — `<%ORG_SLUG%>-marketplace` · `<%ORG_SLUG%>-dev-suite` · `<%ORG_SLUG%>-doc-writer` · `<%ORG_SLUG%>-infra` · `<%ORG_SLUG%>-rust-security`
- Server namespace / config — `/etc/<%ORG_SLUG%>/.env.<env>` · cache `KEY_PREFIX "<%ORG_SLUG%>"` · Prometheus job `<%ORG_SLUG%>-backend`
- Valkey env-var names — `VALKEY_<%ENV_PREFIX%>_*`

**From `<%PRIMARY_DOMAIN%>`:**

- Default from-address `noreply@<%PRIMARY_DOMAIN%>` · status page `status.<%PRIMARY_DOMAIN%>` · `www` → apex redirect

---

## What stays fixed (do NOT tokenise)

These are house constants — the same for every project — and are intentionally left literal:

- **The standard stack** (below) and the structural monorepo layout (`code/src/django/…`,
  `code/src/django/apps/…`, `config/settings/…`, `code/docs/…`).
- **British-English prose.** All documentation is _written_ in en_GB regardless of the app's
  `<%LOCALE%>`. Tokenise the app's configured locale/timezone/currency, never the prose language.
- **House engineering standards** — coverage floors (backend 75 % / auth 90 %), the 750-line
  source limit, the 300-line instructional-doc limit, the design-token architecture (component
  CSS consumes `var(--token)` only).

### The standard stack (base template)

Django · **Django Ninja** (JSON API — the only API layer; there is **no GraphQL**) · django-components ·
Django templates · HTMX · Alpine · vanilla token CSS · Celery (worker + beat) · **PostgreSQL** ·
**Valkey** (DB 0 broker/pub-sub/rate-limit, DB 1 cache) · **Cloudinary** (public media) ·
**SeaweedFS S3** (private docs) · **Rust** (optional project-defined service/sidecar) ·
**Hetzner** · **NixOS** · **Cloudflare** with CF Tunnel · **Nginx** · **Docker Compose**.

There is **one app process family** (Django ASGI) — no Next.js, no second frontend container, no
strangler. Public interactivity is HTMX over Django views returning HTML fragments; the JSON API
(Django Ninja, `NinjaAPI` at `/api/`, auto OpenAPI at `/api/docs`) serves machine clients only.
Django's built-in admin mounts at a non-obvious path (`/control/`), never `/admin/`.

> **"Fixed" here means "not a token", not "mandatory".** The hosting entries in particular —
> Hetzner, NixOS, Cloudflare — are the target Syntek's runbooks are written against, not a
> requirement of the application. It is a Docker Compose deployable and runs on any Linux host
> with Docker; the provider-neutral contract is `SERVER-ARCHITECTURE/`. See
> `TEMPLATE-GUIDE/02-STACK.md` for what travels to another provider unchanged and what needs
> rework.

---

## The two skeleton snapshots

`SCALE-ARCHITECTURE/` and `SERVER-ARCHITECTURE/` keep their **methodology** verbatim — the
anti-forecast principle, the buffer policy, the reconcile → buffer → provision pipeline, the
specify-vs-implement contract discipline, the glossaries, the phase-gate concept, the
readiness-dimension framework. Everything project-specific (process counts, load figures, TTLs,
rate limits, app names, code citations, ADR numbers) is a **placeholder** carrying a
`TBD — regenerate via /scale-planning` marker. Each such file opens with a **Template skeleton**
banner. On a new project's first `/scale-planning` run, the `scale-planner` agent regenerates the
concrete content from that project's live code. Specific ADRs are referenced by **named pattern**
("the project's Postgres horizontal-scaling ADR", "the cache-stampede ADR"), not by number.

---

## Generating a project

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
```

Copier prompts for each token above, renders the tree, then runs its `_tasks`: move the project
README into place, un-ignore `uv.lock`, generate the lock, and `git init`. Full detail — including
what to do when `uv` is not installed — is in `TEMPLATE-GUIDE/06-GENERATION.md`.

Afterwards, run `/scale-planning` to regenerate the two snapshots against the new project's live
code.

> **No `uv.lock` ships with the template.** A lock pins the root project by name, and that name is
> the literal `<%PROJECT_SLUG%>` until Copier renders it — not a valid PEP 508 name — so no lock
> can be generated against the unrendered template, and a shipped one would only carry the
> previous project's name. Every Dockerfile does `COPY pyproject.toml uv.lock ./`, so **the Docker
> build fails until the project has been generated (or `uv lock` run by hand).** Commit the
> generated lock — `pnpm-lock.yaml`, which records no root package name, ships as normal.
