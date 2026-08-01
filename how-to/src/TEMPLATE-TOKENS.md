# Template Tokens — Filling in the Base Template

**Last Updated**: {{DATE}} | **Maintained By**: {{ORG_NAME}}

This repository is a **reusable base template** — the starting point for every new project, whether
built for an external client or internally. Project-, organisation-, and deployment-specific values
are written as `{{DOUBLE_BRACE}}` tokens; the two architecture snapshots (`SCALE-ARCHITECTURE/`,
`SERVER-ARCHITECTURE/`) are **skeletons** regenerated from the new project's live code. This file is
the single source of token truth: what every token means, what to substitute, and what deliberately
stays fixed. The `setup.sh` script at the repo root reads this contract, prompts for each token, and
performs the substitution.

> **Scope.** The token vocabulary spans the whole repository — all documentation (`.md`), operator
> guides, and configuration (Compose, CI, `pyproject.toml`, `package.json`, Bruno, `.env.*.example`).
> Application **source code** (`.py`, `.html`, `.tsx`, `.css`, `.ts`) is not hand-tokenised; `setup.sh`
> rewrites its residual bare `projectname`/`ProjectName` literals at instantiation time (see below).

---

## The tokens

Twenty-one tokens carry every project-specific value. Fill all of them before treating a fresh clone
as a real project. Example values are illustrative — replace them.

### Identity

| Token              | Meaning                                                   | Example value | Format       |
| ------------------ | --------------------------------------------------------- | ------------- | ------------ |
| `{{PROJECT_NAME}}` | Human-readable project / product name                     | `Acme Portal` | free text    |
| `{{PROJECT_SLUG}}` | Kebab machine slug — packages, DB, infra resource names   | `acme-portal` | `kebab-case` |
| `{{ORG_NAME}}`     | Organisation / maintainer / brand (doc headers, licence)  | `Acme Ltd`    | free text    |
| `{{ORG_SLUG}}`     | Org machine slug — marketplace, plugins, server namespace | `acme`        | `kebab-case` |

### Infrastructure

| Token                | Meaning                                             | Example value                                  | Format                  |
| -------------------- | --------------------------------------------------- | ---------------------------------------------- | ----------------------- |
| `{{PRIMARY_DOMAIN}}` | The project's apex domain                           | `acme.com`                                     | bare domain (no scheme) |
| `{{DEPLOY_REPO}}`    | The forked NixOS deploy repo for this project       | `acme-nixos-client-deployment`                 | repo name               |
| `{{SERVER_TIER}}`    | The provisioned host tier (+ its CPU/RAM/disk spec) | `Hetzner AX42-U` (8c/16t Zen 4 · 64 GB · NVMe) | free text               |
| `{{ENV_PREFIX}}`     | Uppercase env-var / server namespace prefix         | `ACME`                                         | `UPPER_SNAKE`           |

### Locale, licence, and people

| Token                 | Meaning                                           | Example value                       | Format           |
| --------------------- | ------------------------------------------------- | ----------------------------------- | ---------------- |
| `{{LOCALE}}`          | Default application locale                        | `en_GB`                             | POSIX locale     |
| `{{TIMEZONE}}`        | Default application timezone                      | `Europe/London`                     | IANA tz          |
| `{{CURRENCY}}`        | Default currency                                  | `GBP`                               | ISO 4217         |
| `{{LICENCE}}`         | Source licence                                    | `Proprietary — all rights reserved` | free text / SPDX |
| `{{DEVELOPER_NAME}}`  | Lead developer (identity block, commit co-author) | `Alex Doe`                          | free text        |
| `{{DEVELOPER_EMAIL}}` | Lead developer email                              | `dev@acme.com`                      | email            |

### Django apps

The apps the documentation refers to by role. Only the **names** are tokenised — the layout
(`code/src/django/apps/<app>/`) is fixed. Defaults are the conventional names; override where a
project calls the app something else. An app a project does not have (e.g. no user-authored
content) keeps its default and the doc rows that mention it can be deleted after instantiation.

| Token                   | Meaning                                          | Example value   | Format       |
| ----------------------- | ------------------------------------------------ | --------------- | ------------ |
| `{{IDENTITY_APP}}`      | App owning users, credentials, sessions, consent | `users`         | `snake_case` |
| `{{AUDIT_APP}}`         | App owning the append-only audit/event log       | `audit`         | `snake_case` |
| `{{CONTENT_APP}}`       | App owning user-authored content                 | `content`       | `snake_case` |
| `{{NOTIFICATIONS_APP}}` | App owning notifications and their delivery      | `notifications` | `snake_case` |
| `{{LEGAL_APP}}`         | App owning cookie consent and legal pages        | `legal`         | `snake_case` |
| `{{CORE_APP}}`          | App owning shared primitives (e.g. encryption)   | `core`          | `snake_case` |

`apps.marketing`, `apps.seo`, and `apps.design_tokens` are **house constants**, not tokens — they
are the same in every project and stay literal.

### Meta

| Token      | Meaning                                                   | Example value | Format       |
| ---------- | --------------------------------------------------------- | ------------- | ------------ |
| `{{DATE}}` | The doc's _Last Updated_ / baseline date, set per project | `22/07/2026`  | `DD/MM/YYYY` |

> **`{{ENV_PREFIX}}` default.** If left blank, `setup.sh` derives it as the upper-snake form of
> `{{ORG_SLUG}}` (`acme` → `ACME`). Override only when the server namespace differs from the org slug.

---

## Derived forms — where a token composes into a larger identifier

When you substitute a token, these compound names resolve automatically — do **not** tokenise them
separately.

**From `{{PROJECT_SLUG}}`:**

- Databases — `{{PROJECT_SLUG}}_dev` · `{{PROJECT_SLUG}}_test` · `{{PROJECT_SLUG}}_staging` · `{{PROJECT_SLUG}}_prod`
- Docker Compose project / bridge network — `{{PROJECT_SLUG}}` · `{{PROJECT_SLUG}}-net`
- Dev hostnames — `dev.{{PROJECT_SLUG}}.localhost` · object-store host `s3.{{PROJECT_SLUG}}.localhost`
- CF Tunnel service / token secret — `cloudflared-{{PROJECT_SLUG}}` · `cloudflared-{{PROJECT_SLUG}}-token.age`
- App-env / Valkey-ACL secret — `{{PROJECT_SLUG}}-env.age` · Mail DKIM — `mail-dkim-{{PROJECT_SLUG}}.age`

**From `{{ORG_SLUG}}` / `{{ENV_PREFIX}}`:**

- Claude Code marketplace + plugins — `{{ORG_SLUG}}-marketplace` · `{{ORG_SLUG}}-dev-suite` · `{{ORG_SLUG}}-doc-writer` · `{{ORG_SLUG}}-infra` · `{{ORG_SLUG}}-rust-security`
- Server namespace / config — `/etc/{{ORG_SLUG}}/.env.<env>` · cache `KEY_PREFIX "{{ORG_SLUG}}"` · Prometheus job `{{ORG_SLUG}}-backend`
- Valkey env-var names — `VALKEY_{{ENV_PREFIX}}_*`

**From `{{PRIMARY_DOMAIN}}`:**

- Default from-address `noreply@{{PRIMARY_DOMAIN}}` · status page `status.{{PRIMARY_DOMAIN}}` · `www` → apex redirect

---

## What stays fixed (do NOT tokenise)

These are house constants — the same for every project — and are intentionally left literal:

- **The standard stack** (below) and the structural monorepo layout (`code/src/django/…`,
  `code/src/django/apps/…`, `config/settings/…`, `code/docs/…`).
- **British-English prose.** All documentation is _written_ in en_GB regardless of the app's
  `{{LOCALE}}`. Tokenise the app's configured locale/timezone/currency, never the prose language.
- **House engineering standards** — coverage floors (backend 75 % / auth 90 % / frontend 70 %),
  the 750-line source limit, the 300-line instructional-doc limit, the design-token architecture
  (component CSS consumes `var(--token)` only).

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

---

## The two skeleton snapshots

`SCALE-ARCHITECTURE/` and `SERVER-ARCHITECTURE/` keep their **methodology** verbatim — the
anti-forecast principle, the buffer policy, the reconcile → buffer → provision pipeline, the
specify-vs-implement contract discipline, the glossaries, the phase-gate concept, the
readiness-dimension framework. Everything project-specific (process counts, load figures, TTLs, rate
limits, app names, code citations, ADR numbers) is a **placeholder** carrying a
`TBD — regenerate via /scale-planning` marker. Each such file opens with a **Template skeleton**
banner. On a new project's first `/scale-planning` run, the `scale-planner` agent regenerates the
concrete content from that project's live code. Specific ADRs are referenced by **named pattern**
("the project's Postgres horizontal-scaling ADR", "the cache-stampede ADR"), not by number.

---

## Instantiating a new project

```bash
bash setup.sh
```

`setup.sh` will:

1. Prompt for each token above (showing defaults; deriving `{{ENV_PREFIX}}` and `{{DATE}}`).
2. Substitute every `{{TOKEN}}` across all docs and configuration.
3. Rewrite residual bare `projectname` → `{{PROJECT_SLUG}}` and `ProjectName` → `{{PROJECT_NAME}}`
   in application source (`.py`/`.html`/`.tsx`/`.css`/`.ts`), warning on any ambiguous hit where the
   org and project slugs differ.
4. Stamp each doc's `{{DATE}}`.
5. Verify none survive — fail if any `{{TOKEN}}` remains: `grep -rn '{{' .` (excluding this manifest).
6. Generate `uv.lock` from the rendered `pyproject.toml`.

> **No `uv.lock` ships with the template.** A lock pins the root project by name, and that name is
> the literal `{{PROJECT_SLUG}}` until `setup.sh` runs — not a valid PEP 508 name — so no lock can
> be generated against the unrendered template, and a shipped one would only carry the previous
> project's name. Every Dockerfile does `COPY pyproject.toml uv.lock ./`, so **the Docker build
> fails until `setup.sh` (or `uv lock`) has run.** Commit the generated lock with the
> instantiation — `pnpm-lock.yaml`, which records no root package name, ships as normal.

Then run `/scale-planning` to regenerate the two snapshots against the new project's live code.
