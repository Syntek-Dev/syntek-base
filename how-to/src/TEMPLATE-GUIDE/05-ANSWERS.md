# Answering the Questions

**Last Updated**: 23/08/2026

Copier asks **thirty-four questions** on a web-only project. The optional surfaces add four more
between them: two for mobile, one to offer the desktop surface once Rust is on, and one for the
desktop app name — thirty-eight if you take all three. Most have a good default. A few are
load-bearing and awkward to change later — this explains which is which.

The formal contract is `../TEMPLATE-TOKENS.md`; `copier.yml` is its executable form. This file is <!-- doc-references: template-only -->
the advice.

---

## The four that matter most

These reach furthest into the tree and are the most painful to change afterwards.

### `PROJECT_SLUG`

**Kebab-case. This is the one to think about.**

It becomes the Python package name, four database names (`<slug>_dev`, `_test`, `_staging`,
`_prod`), the Docker Compose project and network, your development hostnames
(`dev.<slug>.localhost`), the object-store host, and several age-encrypted secret filenames on the
server.

Keep it short, lowercase, hyphenated, and unambiguous. `acme-portal`, not
`acme-portal-web-application-v2`.

**Changing it later** means a rename across ~290 occurrences plus database renames, Docker volume
recreation and new hosts entries. Doable, but a bad afternoon.

### `ORG_SLUG`

Kebab-case. Namespaces your Claude Code marketplace and plugins, the server configuration
directory (`/etc/<org-slug>/`), the cache key prefix, and the Prometheus job name.

Usually one word: `acme`, not `acme-limited`. Defaults to the lowercased `ORG_NAME`, which is
often wrong — if `ORG_NAME` is "Acme Ltd" the default is `acme-ltd`. Override it to `acme`.

### `PRIMARY_DOMAIN`

Bare apex domain, no scheme, no path: `acme.com`. Derives your default from-address
(`noreply@acme.com`), status page, and the `www` → apex redirect. Defaults to
`<project-slug>.com`, which is a guess — correct it.

If you do not know the domain yet, put your best guess in; it is a small, well-contained change
later (61 occurrences, all in documentation and config).

### `DATE`

`DD/MM/YYYY`. Stamped into the `**Last Updated**` header of 338 files as the project's
baseline.

It is **answered, not computed**, deliberately: it is stored in `.copier-answers.yml` and reused
on every `copier update`, so updates do not churn every header in the repository to today's date.
Put today's date in and leave it.

---

## Identity

| Question              | Guidance                                                                                                                   |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `PROJECT_NAME`        | Human-readable, as it appears in the UI and doc headers. `Acme Portal`.                                                    |
| `PROJECT_DESCRIPTION` | **The one to think about.** One or two sentences: what it does, who for, what it replaces. See below — this one has teeth. |
| `ORG_NAME`            | The maintaining organisation. Appears in doc headers and the licence notice. `Acme Ltd`.                                   |

### `PROJECT_DESCRIPTION` — write this one properly

It is the only question about the **product** rather than its labels, and it is the one with the
longest reach. It opens the root `CONTEXT.md`, which `.claude/CLAUDE.md` imports, so it is the
first thing every agent reads in every session — before the stack, before the rules, before the
task. A vague answer is a vague answer echoed through every planning gate downstream.

Three things, in order:

1. **What it does** — the capability, not the technology.
2. **Who it is for** — the actual user, named.
3. **What it replaces** — the spreadsheet, the inbox, the incumbent tool, the manual process.

The third is the one people skip and the one that carries the most information: it says what
"better" means, which is what every scope decision is eventually measured against.

```text
Good  A client portal where Acme's customers track orders, download invoices and raise
      support tickets, replacing an email-and-spreadsheet process.

Poor  A modern, scalable web platform for enterprise workflow management.
```

The second says nothing an agent can act on. Copier enforces a 40-character floor and rejects
double quotes (the value lands in `pyproject.toml` and `package.json`), but it cannot enforce
that you meant it.

**You are not stuck with it.** Edit the paragraph in `CONTEXT.md` whenever the project's shape
changes — the first Claude Code session will ask you to expand it, and re-reading it before each
feature is charted is exactly the point.

## Infrastructure

| Question             | Guidance                                                                                                                                                                                                                         |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DEPLOY_REPO`        | The forked NixOS deploy repository for this project. Default `<slug>-nixos-client-deployment` is usually right.                                                                                                                  |
| `SERVER_TIER`        | Host tier and spec. `TBD — set on provisioning` is a fine answer until you have provisioned. Free text.                                                                                                                          |
| `ENV_PREFIX`         | `UPPER_SNAKE`. Prefixes Valkey environment variables and the server namespace. Defaults from `ORG_SLUG` — check it, because "Acme Ltd" produces `ACME_LTD` when you probably want `ACME`.                                        |
| `DEPLOYMENT_POSTURE` | Is anything live? Answer `development` at generation — it always is. It becomes `staging` or `production` later, and it is an answer rather than a hand-edit so that `copier update` restores it instead of conflicting with it. |

## Platform providers

Seven questions recording **what this project runs on**. Every one has a working default, and
pressing Enter through them is a reasonable first pass — they are recorded so the guides and
Claude knows what you chose, not because anything breaks without them.

They are also the least painful group to change later. Each one names a **choice behind an
interface**, so answering differently does not put you off-doctrine:

| Question              | Guidance                                                                                                                                        |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `HOSTING_PROVIDER`    | Where it runs. The reference deployment is a self-hosted NixOS host driven by `DEPLOY_REPO`; a managed platform is an equally valid answer.     |
| `OBJECT_STORE`        | S3-compatible store for private documents and attachments. The code talks boto3, so any S3 API works — MinIO, Garage, Ceph RGW, AWS S3, R2, B2. |
| `ERROR_TRACKING`      | Wired through the Sentry SDK, so any Sentry-wire-compatible backend works — GlitchTip (default), Sentry, Bugsink.                               |
| `LOG_AGGREGATOR`      | The app writes structured JSON to stdout, so the collector is purely a deployment choice — Loki, Vector, Fluent Bit, Alloy, CloudWatch.         |
| `OBSERVABILITY_STACK` | The app exposes the Prometheus exposition format; anything that scrapes it works — Prometheus, VictoriaMetrics, Alloy, a vendor agent.          |
| `TRACING_BACKEND`     | The seam is OTLP, but nothing is instrumented at baseline — **pressing Enter is the expected answer**. Tempo, Jaeger, SigNoz, Honeycomb.        |
| `ANALYTICS_PROVIDER`  | The one with no wire standard — the seam is the project's own event ingestion API, so this records what sits behind it, or `own store`.         |

**Why free text and not a menu.** The list of viable products is longer than any list shipped
here, and boxing you into ours would defeat the purpose. Answer with whatever you actually run.

**The one that is not on this list is PostgreSQL** — it is the fixed substrate of this template,
not a swappable choice (`code/docs/DATABASE.md`). Changing it is a fork, not an answer.

## Process dependencies

One question, deliberately kept out of the seven above.

| Question           | Guidance                                                                                                                                                                      |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `INCIDENT_TRACKER` | Where the **substance** of an incident lives — log excerpts, identifiers, any postmortem touching personal data. ClickUp, Linear, Jira, a bespoke admin area, or the default. |

It is separate because the interface is **access control**, not a wire protocol: swapping it
changes where a human types rather than what the code does, so it is neither a protocol seam nor
an adapter seam (`code/docs/architecture/PROVIDER-NEUTRALITY.md`).

The in-repo register at `project-management/src/23-INCIDENTS/` is **PII-free by rule** and it
ships, so anything sensitive needs a home with permissions. Leaving the default
(`None — record in 23-INCIDENTS/ only`) is a legitimate answer — it means you undertake to keep
that substance out of the repository entirely.

## Locale and currency

| Question   | Guidance                                                                  |
| ---------- | ------------------------------------------------------------------------- |
| `LOCALE`   | The **application's** locale — `en_GB`, `fr_FR`, whatever the users need. |
| `TIMEZONE` | IANA name: `Europe/London`, `America/New_York`.                           |
| `CURRENCY` | ISO 4217: `GBP`, `EUR`, `USD`.                                            |

> These configure the application. They do **not** change the documentation language, which stays
> British English in every generated project by design.

## Licence

`LICENCE` is **your project's** licence, not the template's.

`syntek-base` is MIT, which places no obligation on what you generate from it. The default is
`Proprietary — all rights reserved` because most projects generated from this template are client
work. If you are open-sourcing yours, put the SPDX identifier here and add the matching `LICENSE` <!-- doc-references: template-only -->
file — the template does not create one for you.

## People

| Question          | Guidance                                                                                                                     |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `DEVELOPER_NAME`  | The lead developer. Used in the Claude Code identity block — Claude addresses this person by name — and as commit co-author. |
| `DEVELOPER_EMAIL` | Their email.                                                                                                                 |

## Django apps

Five questions naming apps by role. **The defaults are almost always right** — press Enter unless
your project genuinely calls the thing something else.

| Question            | Default         | Owns                                  |
| ------------------- | --------------- | ------------------------------------- |
| `IDENTITY_APP`      | `users`         | Users, credentials, sessions, consent |
| `AUDIT_APP`         | `audit`         | The append-only audit / event log     |
| `CONTENT_APP`       | `content`       | User-authored content                 |
| `NOTIFICATIONS_APP` | `notifications` | Notifications and their delivery      |
| `LEGAL_APP`         | `legal`         | Cookie consent and legal pages        |

Only the **names** are configurable — the layout `code/src/django/apps/<app>/` is fixed. If your
project has no user-authored content, keep the `content` default and delete the documentation rows
that mention it afterwards.

Every app above is one **a story has yet to create**, which is what makes the name yours to choose.
`apps/core/` and `apps/health/` are not on the list because they already ship literal — house
constants, and `core` was never really configurable even while a `CORE_APP` question existed to
suggest otherwise.

**None of these directories exists at baseline.** `apps/` ships `core` and `health` only; the five answers
name apps the documentation refers to, and each one is created when a story first needs it — with
`bash code/src/scripts/development/new-django-app.sh <app_name>`, never `manage.py startapp`,
which skips the per-model-file structure and the `CONTEXT.md`/`CLAUDE.md` pair.

`apps.marketing`, `apps.seo` and `apps.design_tokens` are house constants. They are the same in
every project and are never asked about.

## Planning cadence

Two questions setting the story-point ceiling that drives the planning loop. **Press Enter on
both** — the defaults are the house values, and you cannot sensibly pick a number before your
team has a measured velocity.

| Question             | Default | Means                                                    |
| -------------------- | ------- | -------------------------------------------------------- |
| `SPRINT_CAPACITY_SP` | `11`    | Points that fill a sprint and trigger the `16`+`17` pass |
| `SPRINT_GRACE_SP`    | `13`    | Hard ceiling, for when the next story would split badly  |

These drive the cadence in `project-management/docs/PLANNING-GUIDE.md`: you plan one story
at a time through workflows `02`–`14`, and when the open sprint reaches the capacity figure you
run `16-sprint-plans` and `17-story-plans` for that sprint before starting the next story.

Revisit them after two sprints, once you know what you actually deliver. Changing them later is a
one-line edit in `project-management/docs/PLANNING-GUIDE.md` — no regeneration needed.

## Optional surfaces

Three booleans, each adding a whole toolchain. All default to `false`, and all are cheap to turn
on later with `copier update` — so answer `false` when unsure. `INCLUDE_DESKTOP` is only asked at
all when `INCLUDE_RUST` is true, because Slint is Rust; each `true` also unlocks a name question
(`MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID`, `DESKTOP_APP_NAME`).

| Question          | Turn it on when                                                                                         |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| `INCLUDE_MOBILE`  | The project ships a React Native app. Adds Node, pnpm and the Expo toolchain                            |
| `INCLUDE_RUST`    | **This repository compiles Rust.** Adds `rustup` as a prerequisite for `uv sync` and a Rust image stage |
| `INCLUDE_DESKTOP` | The project ships a **native desktop app** (Slint). Only offered when `INCLUDE_RUST` is true            |

The three name questions each `true` unlocks:

| Question           | Default        | Answer it                                                                                                 |
| ------------------ | -------------- | --------------------------------------------------------------------------------------------------------- |
| `MOBILE_APP_NAME`  | `PROJECT_NAME` | The label under the app icon on a device. Keep it short — iOS truncates past about 12 characters          |
| `MOBILE_BUNDLE_ID` | derived        | Reverse-domain, validated. **Immutable once published** to either store — get it right now                |
| `DESKTOP_APP_NAME` | `PROJECT_NAME` | The window title and executable name. The default is right unless the desktop build is branded separately |

`INCLUDE_RUST` gates **authoring, not consuming** — the distinction that decides the answer. A
project that merely depends on a prebuilt PyO3 wheel installs it like any other dependency and
needs no toolchain: answer `false`. Answer `true` only if source in this repository is compiled
by `cargo`.

Getting that backwards is the common mistake, and it is expensive in the wrong direction: every
contributor to a `true` project needs a Rust toolchain, and every CI run builds one.

`INCLUDE_DESKTOP` carries a **licence obligation**. The app ships under Slint's Royalty-free tier,
which is free for proprietary applications _and commercial sale_ — provided you disclose that you
use Slint. The generated app does that with an `AboutSlint` widget, and the packaging script
refuses to build a release without it. The tier does **not** cover embedded systems (an appliance
screen, a POS terminal, a car dashboard), nor redistributing anything that exposes Slint's own
APIs. If either applies to you, budget for a paid Commercial licence before you start.

## The ClickUp sync

| Question          | Default | Answer `false` when                                                                                      |
| ----------------- | ------- | -------------------------------------------------------------------------------------------------------- |
| `INCLUDE_CLICKUP` | `true`  | Your team tracks work anywhere other than ClickUp — Jira, Linear, GitHub Projects, Monday, a spreadsheet |

The one optional question that defaults to **`true`**, because unlike the three surfaces above it
does not add a toolchain — it has shipped in every generation to date, and flipping the default
would delete a working workflow out of every existing project on its next `copier update`.

**This template was built to use ClickUp, and ClickUp is the only board it can write to.** The CI
workflow, the export format and the upsert all speak that one API. Answer `false` and you write
your own sync for whatever your team actually uses — that is the honest trade, not a gap.

You would not be starting from nothing. `.claude/skills/pm-tool-sync/` and
`.claude/plugins/pm-tool.py` — which already detects ClickUp, Linear, Jira, GitHub Projects,
Monday, Asana, Trello, Notion, Azure DevOps and Shortcut — are the tool-agnostic half and ship
**whatever you answer**. Point the skill at your tool and it will grill you through the mapping.

Answering `false` costs you the sync and nothing else. Your stories, sprints, plans and the
workflows that produce them are markdown in the repository, which stays the source of truth
either way — the board is a mirror of it, never the other direction.

---

## Getting it wrong

Everything is recoverable; the cost varies.

| Answer                                | Fixing it later                                                                                                                                     |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DATE`, `SERVER_TIER`, licence        | Trivial — edit in place, or edit `.copier-answers.yml` and re-run `copier update`.                                                                  |
| `DEPLOYMENT_POSTURE`                  | Trivial, and expected — it is designed to be changed. Edit `.copier-answers.yml`, run `copier update`, update the register rows in the same commit. |
| The seven platform providers          | Trivial — each records a choice behind an interface; edit the answer and the register row.                                                          |
| `INCLUDE_MOBILE` · `RUST` · `DESKTOP` | Easy to turn **on** — `copier update` adds the tree. Turning one **off** leaves files behind that you delete by hand.                               |
| `DEVELOPER_*`, app names              | Easy — a scoped find-and-replace.                                                                                                                   |
| `PRIMARY_DOMAIN`, `ENV_PREFIX`        | Moderate — dozens of occurrences, all in docs and config.                                                                                           |
| `ORG_SLUG`                            | Moderate — also touches the server namespace and cache prefix.                                                                                      |
| `MOBILE_BUNDLE_ID`                    | Painful once published — the bundle ID is permanent on both stores.                                                                                 |
| `PROJECT_SLUG`                        | Painful — databases, volumes, hostnames, secret filenames.                                                                                          |

If you realise within minutes, the cheapest fix is to delete the directory and generate again.

---

## Next

- What Copier does after the questions → `06-GENERATION.md`
- Get it running → `04-QUICKSTART.md`
