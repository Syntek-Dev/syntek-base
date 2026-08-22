# Template Tokens — the Contract `copier.yml` Implements

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

<: raw :>

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
one of these six sequences literally, wrap it in a Jinja **`raw` block** — the block delimiters
around the word `raw` before it, and the same around `endraw` after it. Everything between is
emitted verbatim.

**This file is one of them.** It ships to generated projects, so everything below the header is
inside a `raw` block — which is the only reason the token table survives rendering instead of
becoming 40 rows of blanks. `raw` blocks **cannot nest**, which is why the paragraph above
describes the markers rather than showing them.

---

## The tokens

Thirty-seven tokens carry every project-specific value. **Thirty-three are always asked**; the
remaining four are conditional — `MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` only when the mobile
surface is included, `INCLUDE_DESKTOP` only when the Rust surface is, and `DESKTOP_APP_NAME` only
when the desktop surface is. Example values are illustrative — replace them.

Thirty-eight until 15/08/2026, when `CORE_APP` was retired — see the note under _Django apps_.

### Identity

| Token                     | Meaning                                                         | Example value                                            | Format             |
| ------------------------- | --------------------------------------------------------------- | -------------------------------------------------------- | ------------------ |
| `<%PROJECT_NAME%>`        | Human-readable project / product name                           | `Acme Portal`                                            | free text          |
| `<%PROJECT_DESCRIPTION%>` | **The brief** — what the project does, for whom, replacing what | `A client portal where Acme's customers track orders, …` | ≥ 40 chars, no `"` |
| `<%PROJECT_SLUG%>`        | Kebab machine slug — packages, DB, infra resource names         | `acme-portal`                                            | `kebab-case`       |
| `<%ORG_NAME%>`            | Organisation / maintainer / brand (doc headers, licence)        | `Acme Ltd`                                               | free text          |
| `<%ORG_SLUG%>`            | Org machine slug — marketplace, plugins, server namespace       | `acme`                                                   | `kebab-case`       |

`<%PROJECT_DESCRIPTION%>` reaches further than the other identity tokens: it opens the root
`CONTEXT.md`, which `.claude/CLAUDE.md` imports, so it is the **first thing read in every
session**. It is also the `description` field of `pyproject.toml` and `package.json`,
and the blurb under the title in the generated `README.md`. The no-double-quotes rule exists
because of those two manifests; the 40-character floor exists because a tagline is not a brief.

### Infrastructure

| Token                | Meaning                                             | Example value                                  | Format                  |
| -------------------- | --------------------------------------------------- | ---------------------------------------------- | ----------------------- |
| `<%PRIMARY_DOMAIN%>` | The project's apex domain                           | `acme.com`                                     | bare domain (no scheme) |
| `<%DEPLOY_REPO%>`    | The forked NixOS deploy repo for this project       | `acme-nixos-client-deployment`                 | repo name               |
| `<%SERVER_TIER%>`    | The provisioned host tier (+ its CPU/RAM/disk spec) | `Hetzner AX42-U` (8c/16t Zen 4 · 64 GB · NVMe) | free text               |
| `<%ENV_PREFIX%>`     | Uppercase env-var / server namespace prefix         | `ACME`                                         | `UPPER_SNAKE`           |

### Platform providers

Each of these records a **choice**, not a dependency. The guides name the _interface_ and treat
the product as one implementation behind it, so a project that answers differently is still
on-doctrine. All seven are free text rather than a fixed choice list, because the set of viable
products is longer than any list shipped here.

| Token                     | Meaning                                        | Example value                          | Shape                 |
| ------------------------- | ---------------------------------------------- | -------------------------------------- | --------------------- |
| `<%HOSTING_PROVIDER%>`    | Where the project runs                         | `Self-hosted — NixOS on bare metal`    | phrase · **cell**     |
| `<%OBJECT_STORE%>`        | S3-compatible object store (private documents) | `SeaweedFS`                            | bare name · **prose** |
| `<%ERROR_TRACKING%>`      | Error and exception tracking backend           | `GlitchTip`                            | bare name · **prose** |
| `<%LOG_AGGREGATOR%>`      | Where structured logs are shipped and queried  | `Loki`                                 | bare name · **prose** |
| `<%OBSERVABILITY_STACK%>` | Metrics and dashboards                         | `Prometheus + Grafana`                 | phrase · **cell**     |
| `<%TRACING_BACKEND%>`     | Where distributed traces are sent (OTLP)       | `None — deferred; OTLP endpoint unset` | phrase · **cell**     |
| `<%ANALYTICS_PROVIDER%>`  | Product analytics                              | `Plausible`                            | bare name · **prose** |

**Shape decides where a token may be written.** A **bare name** substitutes into a running
sentence; a **phrase** reads correctly in a table cell and breaks mid-sentence — _"the
`Prometheus + Grafana` scrape contract"_. Writing a cell-shaped token into prose is the mistake
this column exists to prevent, and it has happened once already. The rule is exception 2 in
[`code/docs/architecture/PROVIDER-NEUTRALITY.md`](../../code/docs/architecture/PROVIDER-NEUTRALITY.md);
where a product needs qualifying, that detail belongs in the question's `help:` text, never in
its default.

**The interface each one sits behind** — this is what makes a different answer safe:

| Concern        | The seam the code is written against                          |
| -------------- | ------------------------------------------------------------- |
| Object store   | The **S3 API**, consumed via boto3                            |
| Error tracking | The **Sentry SDK wire protocol**                              |
| Metrics        | The **Prometheus exposition format** / OpenMetrics            |
| Logs           | **Structured JSON on stdout**, collected by whatever ships it |
| Traces         | **OTLP** (OpenTelemetry)                                      |
| Product events | This project's **own ingestion API and event schema**         |

Swapping any of these changes **this answer and an environment variable** — never the doctrine,
and for the five wire-protocol rows never a line of application code either. (Product events are
the exception: no wire standard exists, so that seam is an adapter over this project's own event
schema.) The one component deliberately **not** on this list is PostgreSQL: it is the fixed
substrate, not a swappable choice (`code/docs/DATABASE.md`).

**This table is a summary.** The full register — every infrastructure dependency, its seam kind,
its proven alternates, and a stated reason for each substrate verdict — is
`how-to/src/PLATFORM-PROVIDERS.md`, which renders per project. The rule that produces those
verdicts is `code/docs/architecture/PROVIDER-NEUTRALITY.md`.

### Process dependencies

A dependency the **people** operating the project rely on, which no application code touches.
Listed separately from the six above rather than folded in with them, because under the substrate
test it is **neither seam kind** — swapping it changes where a human types, not what the code
does — and filing it as a protocol or adapter seam would cheapen both terms.

| Token                  | Meaning                                    | Example value | Format    |
| ---------------------- | ------------------------------------------ | ------------- | --------- |
| `<%INCIDENT_TRACKER%>` | Where the substance of an incident is held | `ClickUp`     | free text |

**The interface is access control**, and that is the whole point. The in-repo register at
`project-management/src/23-INCIDENTS/` is **PII-free by rule** and ships, so log excerpts,
identifiers and any postmortem touching personal data need a home with permissions. The default is
`None — record in 23-INCIDENTS/ only`, and it is a first-class answer: a project without a tracker
keeps that substance **outside the repository** rather than relaxing the rule to fit a report in.
The practice is `how-to/docs/INCIDENT-PRACTICE.md`.

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

`apps.marketing`, `apps.design_tokens` and **`apps.core`** are **house constants**, not tokens —
they are the same in every project and stay literal.

**`<%CORE_APP%>` was retired on 15/08/2026, and the reason is the general rule.** The five tokens
above name apps **a story has yet to create**: no directory in the template _is_ `apps/users/`, so
answering `IDENTITY_APP=accounts` contradicts no shipped code. `apps/core/` is the opposite case —
it **already ships**, as a literal directory, with `name = "apps.core"` in its `apps.py`,
`apps.core` in `INSTALLED_APPS`, literal imports throughout, and a dozen guides naming it.
Answering `CORE_APP=shared` produced a project whose documentation disagreed with its own code.
**A token whose referent is hardcoded everywhere else is not a choice; it is a claim that a choice
exists.**

**What that argument does not claim is that `users` never appears literally.** It appears around
thirty times across the tree — in worked examples, log-query snippets, a coverage-floor row and
several dated historical notes — and those stay literal on purpose: a `grep "apps.accounts"`
example teaches a reader nothing a `grep "apps.users"` one does not, and rewriting history to name
an app the defect never named would make the record false. **The line the token has to hold is
executable.** Anything that _runs_ against the identity app reads the answer rather than the
default, or the token is decoration:

| Site                                                          | How it reads the answer                                             |
| ------------------------------------------------------------- | ------------------------------------------------------------------- |
| `code/src/scripts/tests/backend-coverage.sh`                  | `AUTH_APP="${AUTH_APP:-users}"`, and skips while that app is absent |
| `.github/workflows/claude.yml` · `.github/workflows/test.yml` | Both call that script rather than a hardcoded `--include` glob      |

Both CI jobs hardcoded `apps/users/*` until 20/08/2026, and both ship — so a project answering
`accounts` was handed a gate enforcing a 90% floor on a directory it does not have, while this
repository, which has no apps at all, saw the same leg measure nothing and report success on every
run. **A prose example naming the default is a reading aid; a gate naming it is a broken gate**, and
keeping the two apart is what keeps this token a real choice rather than the claim `<%CORE_APP%>`
was retired for making.

### Planning cadence

The story-point ceiling that drives the planning loop. Stories are planned one at a time through
workflows `01`–`13`; when the open sprint's accepted points reach `<%SPRINT_CAPACITY_SP%>`,
workflows `15` and `16` run for that sprint before the next story is planned. The grace value is
a hard ceiling for the case where the next story would otherwise split badly — not a routine
target. Full rules: `project-management/docs/PLANNING-GUIDE.md`.

| Token                    | Meaning                                                  | Example value | Format           |
| ------------------------ | -------------------------------------------------------- | ------------- | ---------------- |
| `<%SPRINT_CAPACITY_SP%>` | Points that fill a sprint and trigger the `15`+`16` pass | `11`          | `int`            |
| `<%SPRINT_GRACE_SP%>`    | Hard ceiling a sprint may stretch to                     | `13`          | `int` > capacity |

Both default to the house values (11 / 13). Tune them to your team's **measured** velocity after
two sprints rather than guessing up front — the cadence works at any ceiling, and a number that
does not match reality makes every sprint either starve or overrun.

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
scripts, its guides, its workflow, its CI job, and its `stack-rust` skill are all
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

### Position matters as much as shape — never tokenise a validated identifier

Composition is only half the question. The other half is **what reads the result, and when**. A
token is inert in a comment, a description, a licence field or a string literal; it is a defect in
any position a compiler, parser or schema validates as an **identifier**, because the delimiters
`<`, `%` and `>` are not legal in one.

The consequence is not cosmetic. Such a file cannot be parsed **in the template repository at
all**, so every gate that depends on parsing it — a compiler, a linter, a test run — fails here
while looking perfectly correct in a generated project. The gate then proves nothing until after
generation, which is the one place nobody looks.

| Position                                                 | Validated? | Tokenise?               |
| -------------------------------------------------------- | ---------- | ----------------------- |
| Comment, description, author, licence field              | no         | yes                     |
| String literal (Python, Rust, Slint, JSON, YAML)         | no         | yes                     |
| Hostname, database name, path segment, env-var value     | at runtime | yes                     |
| **Crate / package / module / class / function name**     | at compile | **no — house constant** |
| **A name a schema constrains** (e.g. a k8s `name:`)      | on apply   | **no — house constant** |
| **A shell word** (a Compose `--health-cmd`, any `sh -c`) | at run     | **no — house constant** |

**The last row is a different failure, and it is worth separating.** Everywhere above, the
delimiters are _illegal_ — a parser rejects them. In a shell word they are **legal and active**:
`<` and `>` are redirects, so the command does not fail to parse, it runs and does something else
entirely. That was `70fc963`, where a Compose health probe silently became a redirection. A rule
written only about identifiers would never have caught it.

**Two remedies, and which one applies depends on whether the name is wanted at all.**

- **Never branded — house constant, permanently.** `code/src/rust/crates/desktop/` is the worked
  example: the crate is the constant `desktop`, and `code/src/scripts/desktop/package.sh` copies
  the built artefact to `<%PROJECT_SLUG%>-desktop` afterwards, where the name is a filename rather
  than a grammar. Same deliverable, no token in the compiler's path.
- **Branded late — house constant here, rewritten at generation.** `pyproject.toml`'s
  `[project] name` is the worked example: it carries `syntek-base` so `uv` can parse the manifest
  in this repository, and a `copier.yml` `_task` rewrites it to `<%PROJECT_SLUG%>` **before**
  `uv lock` runs. Use this shape where the generated project genuinely needs its own name; note
  the cost, which is that `copier update` never runs `_tasks`.

**The rule has a gate, and did not until 15/08/2026.** `.github/scripts/check-template-parsers.sh` <!-- doc-references: template-only -->
runs each toolchain's own parser — `uv lock --dry-run`, `cargo metadata`, `pnpm ls`,
`docker compose config` — and requires every manifest to load in the template. It does **not**
check positions, and that is deliberate: `pnpm` accepts `<%PROJECT_SLUG%>` in `package.json`'s
`name` while `uv` rejects the identical token in `pyproject.toml`'s, so the same syntactic position
is fine for one tool and fatal for another. Asking the parser is the only answer that stays true.

This is the same class as `<%LICENCE%>`, which is not a valid SPDX expression either — handled
there by exempting the crate in `code/src/rust/deny.toml` (`private.ignore`) rather than by
renaming, because a licence field is read by a checker rather than a compiler.

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
Django templates · HTMX · Alpine · vanilla token CSS · Celery (worker + beat — declared, not
wired) · **PostgreSQL** ·
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
banner. On a new project's first `/scale-planning` run, the `scale-planning` skill regenerates the
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

<: endraw :>
