# Answering the Questions

**Last Updated**: 02/08/2026

Copier asks twenty-three questions — twenty-five if you opt into the mobile surface, which adds
two of its own. Most have a good default. A few are load-bearing and awkward to
change later — this explains which is which.

The formal contract is `../TEMPLATE-TOKENS.md`; `copier.yml` is its executable form. This file is
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

**Changing it later** means a rename across ~260 occurrences plus database renames, Docker volume
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
later (58 occurrences, all in documentation and config).

### `DATE`

`DD/MM/YYYY`. Stamped into ~280 `**Last Updated**` headers as the project's baseline.

It is **answered, not computed**, deliberately: it is stored in `.copier-answers.yml` and reused
on every `copier update`, so updates do not churn every header in the repository to today's date.
Put today's date in and leave it.

---

## Identity

| Question       | Guidance                                                                                 |
| -------------- | ---------------------------------------------------------------------------------------- |
| `PROJECT_NAME` | Human-readable, as it appears in the UI and doc headers. `Acme Portal`.                  |
| `ORG_NAME`     | The maintaining organisation. Appears in doc headers and the licence notice. `Acme Ltd`. |

## Infrastructure

| Question      | Guidance                                                                                                                                                                                  |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DEPLOY_REPO` | The forked NixOS deploy repository for this project. Default `<slug>-nixos-client-deployment` is usually right.                                                                           |
| `SERVER_TIER` | Host tier and spec. `TBD — set on provisioning` is a fine answer until you have provisioned. Free text.                                                                                   |
| `ENV_PREFIX`  | `UPPER_SNAKE`. Prefixes Valkey environment variables and the server namespace. Defaults from `ORG_SLUG` — check it, because "Acme Ltd" produces `ACME_LTD` when you probably want `ACME`. |

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
work. If you are open-sourcing yours, put the SPDX identifier here and add the matching `LICENSE`
file — the template does not create one for you.

## People

| Question          | Guidance                                                                                                                   |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `DEVELOPER_NAME`  | The lead developer. Used in the Claude Code identity block — agents address this person by name — and as commit co-author. |
| `DEVELOPER_EMAIL` | Their email.                                                                                                               |

## Django apps

Six questions naming apps by role. **The defaults are almost always right** — press Enter unless
your project genuinely calls the thing something else.

| Question            | Default         | Owns                                  |
| ------------------- | --------------- | ------------------------------------- |
| `IDENTITY_APP`      | `users`         | Users, credentials, sessions, consent |
| `AUDIT_APP`         | `audit`         | The append-only audit / event log     |
| `CONTENT_APP`       | `content`       | User-authored content                 |
| `NOTIFICATIONS_APP` | `notifications` | Notifications and their delivery      |
| `LEGAL_APP`         | `legal`         | Cookie consent and legal pages        |
| `CORE_APP`          | `core`          | Shared primitives such as encryption  |

Only the **names** are configurable — the layout `code/src/django/apps/<app>/` is fixed. If your
project has no user-authored content, keep the `content` default and delete the documentation rows
that mention it afterwards.

`apps.marketing`, `apps.seo` and `apps.design_tokens` are house constants. They are the same in
every project and are never asked about.

## Optional surfaces

Two questions add a whole toolchain. Both default to `false`, and both are cheap to turn on later
with `copier update` — so answer `false` when unsure.

| Question         | Turn it on when                                                                                         |
| ---------------- | ------------------------------------------------------------------------------------------------------- |
| `INCLUDE_MOBILE` | The project ships a React Native app. Adds Node, pnpm and the Expo toolchain                            |
| `INCLUDE_RUST`   | **This repository compiles Rust.** Adds `rustup` as a prerequisite for `uv sync` and a Rust image stage |

`INCLUDE_RUST` gates **authoring, not consuming** — the distinction that decides the answer. A
project that merely depends on a prebuilt PyO3 wheel installs it like any other dependency and
needs no toolchain: answer `false`. Answer `true` only if source in this repository is compiled
by `cargo`.

Getting that backwards is the common mistake, and it is expensive in the wrong direction: every
contributor to a `true` project needs a Rust toolchain, and every CI run builds one.

---

## Getting it wrong

Everything is recoverable; the cost varies.

| Answer                           | Fixing it later                                                                                                       |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `DATE`, `SERVER_TIER`, licence   | Trivial — edit in place, or edit `.copier-answers.yml` and re-run `copier update`.                                    |
| `INCLUDE_MOBILE`, `INCLUDE_RUST` | Easy to turn **on** — `copier update` adds the tree. Turning one **off** leaves files behind that you delete by hand. |
| `DEVELOPER_*`, app names         | Easy — a scoped find-and-replace.                                                                                     |
| `PRIMARY_DOMAIN`, `ENV_PREFIX`   | Moderate — dozens of occurrences, all in docs and config.                                                             |
| `ORG_SLUG`                       | Moderate — also touches the server namespace and cache prefix.                                                        |
| `PROJECT_SLUG`                   | Painful — databases, volumes, hostnames, secret filenames.                                                            |

If you realise within minutes, the cheapest fix is to delete the directory and generate again.

---

## Next

- What Copier does after the questions → `06-GENERATION.md`
- Get it running → `04-QUICKSTART.md`
