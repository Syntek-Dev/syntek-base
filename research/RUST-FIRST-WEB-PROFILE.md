# Rust-first web profile — Axum, Leptos, SeaORM, utoipa and rmcp as a syntek-base default

**Last Updated**: 17/11/2026 · **Checked**: 17/11/2026 · **Method**: read-only; nothing built,
installed or run against a database. Versions are crates.io API responses on the date checked.

## Question

Can a Rust stack — Tokio, Axum, Tower, Leptos SSR, SeaORM, utoipa and rmcp — serve as the
**default** web profile for syntek-base today, with Django and other frameworks still selectable,
and what would that cost against the repository's own doctrine?

## Verdict

**Not as the default today; as a second, opt-in profile proved by the N-012 tracer first.** Every
layer has a working stable crate, but the stable set is pre-1.0 almost throughout, carries three
dependency-level skews (auth/session, tower-http, sqlx), regresses migration safety against
Django, and has no counterpart to Django's admin, Wagtail, forms or built-in CSRF — each becomes
template-owned code and a new gate. Leptos's defaults also run against the progressive-enhancement
doctrine. No generated project exists yet (Sam, 17/11/2026), so the default can move later at no
migration cost; the constraint is evidence, not compatibility.

This is a synthesis. The claims below are verified facts; the Verdict and _Assessment_ are
judgement, and the _Unverified_ list says what a spike must still prove.

---

## Claims

### Versions and compatibility (stable releases only)

| #    | Claim                                                                                                                                                              | Source                                                                                                                                     |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| V-1  | Rust stable is 1.100.0; the repo pins toolchain 1.97.1, `rust-version = "1.92"`, `resolver = "3"`, edition 2024                                                    | <https://static.rust-lang.org/dist/channel-rust-stable.toml>; [Cargo.toml](../code/src/rust/Cargo.toml) lines 9-26                         |
| V-2  | tokio 1.54.1 (MSRV 1.85); 1.54.0 is yanked                                                                                                                         | <https://crates.io/api/v1/crates/tokio/versions>                                                                                           |
| V-3  | axum 0.8.9 (14/04/2026, MSRV 1.80) is the latest; no 0.9 is published                                                                                              | <https://crates.io/api/v1/crates/axum>                                                                                                     |
| V-4  | tower 0.5.3; tower-http 0.7.1 (31/08/2026)                                                                                                                         | <https://crates.io/api/v1/crates/tower-http>                                                                                               |
| V-5  | leptos 0.8.23 (31/10/2026, MSRV 1.88) is stable; 0.9.0-rc1 is a release candidate                                                                                  | <https://crates.io/api/v1/crates/leptos/versions>                                                                                          |
| V-6  | leptos_axum 0.8.10 requires axum ^0.8 and **tower-http ^0.6**; its 0.9.0-rc1 requires tower-http ^0.7                                                              | <https://crates.io/api/v1/crates/leptos_axum/0.8.10/dependencies>                                                                          |
| V-7  | cargo-leptos 0.3.12 (09/11/2026) builds the server with the `ssr` feature and the client with `hydrate`                                                            | <https://crates.io/api/v1/crates/cargo-leptos>; cargo-leptos README                                                                        |
| V-8  | sea-orm 2.0.0 shipped 19/07/2026 after 43 release candidates; 2.0.4 (27/09/2026) declares MSRV **1.94.0** and requires sqlx ^0.9 and sea-query ~1.0                | <https://crates.io/api/v1/crates/sea-orm/2.0.4/dependencies>                                                                               |
| V-9  | sea-orm-migration 2.0.4 requires sea-orm ~2.0.4 (minor must match) while declaring MSRV 1.85                                                                       | <https://crates.io/api/v1/crates/sea-orm-migration/2.0.4/dependencies>                                                                     |
| V-10 | sqlx 0.9.0 (21/05/2026) declares MSRV 1.94.0                                                                                                                       | <https://crates.io/api/v1/crates/sqlx>                                                                                                     |
| V-11 | utoipa 6.0.0, utoipa-axum 0.3.0, utoipa-swagger-ui 10.0.2, utoipa-scalar 0.4.0 — all target axum ^0.8.4, MSRV 1.88                                                 | <https://crates.io/api/v1/crates/utoipa-axum/0.3.0/dependencies>                                                                           |
| V-12 | rmcp 3.10.0 (12/11/2026) is the official MCP Rust SDK; axum is only a dev-dependency, so it mounts as a plain Tower service                                        | <https://crates.io/api/v1/crates/rmcp/3.10.0/dependencies>                                                                                 |
| V-13 | tower_governor 0.8.0 last released 14/08/2025; leptosfmt 0.1.33 last released 30/01/2025 — both single-maintainer                                                  | <https://crates.io/api/v1/crates/tower_governor>; <https://crates.io/api/v1/crates/leptosfmt>                                              |
| V-14 | tower-sessions 0.15.0; tower-sessions-sqlx-store 0.16.0 requires tower-sessions-core ^0.15 and sqlx ^0.9                                                           | <https://crates.io/api/v1/crates/tower-sessions-sqlx-store/0.16.0/dependencies>                                                            |
| V-15 | **axum-login 0.18.0 (20/07/2025) requires tower-sessions ^0.14** — no released axum-login accepts the 0.15 line; its `main` branch moves to 0.15 but is unreleased | <https://crates.io/api/v1/crates/axum-login/0.18.0/dependencies>; `axum-login/Cargo.toml` on `main` of github.com/maxcountryman/axum-login |
| V-16 | tower-sessions-redis-store 0.16.0 (01/01/2025) still requires tower-sessions-core ^0.14                                                                            | <https://crates.io/api/v1/crates/tower-sessions-redis-store/0.16.0/dependencies>                                                           |
| V-17 | OpenTelemetry crates are 0.33.1 and tracing-opentelemetry 0.34.0 requires opentelemetry ^0.33 — the set moves in lockstep                                          | <https://crates.io/api/v1/crates/tracing-opentelemetry>                                                                                    |
| V-18 | Cargo's MSRV-aware resolver **prefers** versions within your `rust-version`; it does not override a requirement that has no compatible version                     | <https://doc.rust-lang.org/cargo/reference/resolver.html>, "Rust version"                                                                  |

**Corollary of V-8, V-10 and V-18.** `sea-orm = "2"` still resolves 2.0.4 under a 1.92 floor, so the
declared floor stops being true. An earlier draft of this research said resolution would fall back
to sea-orm 1.x; that is **refuted** — it would only happen if the requirement admitted 1.x.

### Rendering without JavaScript (Leptos 0.8.23)

| #    | Claim                                                                                                                                                                 | Source                                                                                                                                                                        |
| ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-1  | `SsrMode` has five variants; `OutOfOrder` is the default and needs scripting to place streamed `<Suspense/>` fragments, which arrive in an inert `<template>`         | <https://docs.rs/leptos_router/latest/leptos_router/enum.SsrMode.html>; <https://book.leptos.dev/ssr/23_ssr_modes.html>                                                       |
| R-2  | `PartiallyBlocked` server-renders only blocking resources; `InOrder` and `Async` deliver complete HTML with no script; nested routes take the most restrictive mode   | same                                                                                                                                                                          |
| R-3  | Hydration and island scripts are emitted **inline**; the `nonce` feature adds a per-render nonce to every inline streaming script                                     | `leptos/src/hydration/mod.rs` and `leptos/src/nonce.rs` at tag `v0.8.23`, github.com/leptos-rs/leptos                                                                         |
| R-4  | With islands, only `#[island]` code compiles to WASM, but the island loader fetches one site-wide `.js`/`.wasm` on any page carrying the hydration scripts            | <https://book.leptos.dev/islands.html>; `leptos/src/hydration/island_script.js` at `v0.8.23`                                                                                  |
| R-5  | `<ActionForm/>` renders a native `POST` form and supports only URL-encoded server functions                                                                           | `leptos/src/form.rs` at `v0.8.23`; <https://book.leptos.dev/progressive_enhancement/action_form.html>                                                                         |
| R-6  | On a native (non-JS) post the server function redirects to `Referer` (or `/`); on error it appends the serialised error, base64-encoded, to the redirect query string | `server_fn/src/lib.rs` and `server_fn/src/error.rs` at `v0.8.23`                                                                                                              |
| R-7  | The multipart codec decodes with multer behind the `multipart` feature and panics on a missing boundary                                                               | `server_fn/src/codec/multipart.rs` at `v0.8.23`                                                                                                                               |
| R-8  | Leptos server functions carry **no CSRF protection**; the request for it was closed as not planned                                                                    | <https://github.com/leptos-rs/leptos/issues/3786>                                                                                                                             |
| R-9  | Enabling `ssr` and `hydrate` on one build target is unsupported, so `--all-features` is not a usable gate                                                             | <https://docs.rs/leptos/0.8.23/leptos/index.html>                                                                                                                             |
| R-10 | The repository requires full core functionality without JavaScript, no inline script or style, bans `hx-boost`, and caches anonymous public GETs whole-page           | [RENDERING.md](../code/docs/RENDERING.md); [MAP-PROGRESSIVE-ENHANCEMENT](../project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md) N-001, N-002, N-017, N-022 |

### Data layer (SeaORM 2.0.4)

| #    | Claim                                                                                                                                                               | Source                                                                                                                                       |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| D-1  | The 2.0 dense entity format declares `BelongsTo` / `HasMany` (including via a junction) as model fields; required vs optional foreign keys are in the type          | <https://www.sea-ql.org/SeaORM/docs/generate-entity/sea-orm-cli>; SeaORM `CHANGELOG.md`, 2.0.0                                               |
| D-2  | The Entity Loader and `LoaderTrait::load_many` batch related rows with `IN (..)` per level, avoiding N+1                                                            | <https://www.sea-ql.org/SeaORM/docs/relation/entity-loader>; <https://www.sea-ql.org/SeaORM/docs/basic-crud/select>                          |
| D-3  | Transactions commit on `Ok`, roll back on `Err`, and accept an isolation level and access mode                                                                      | <https://www.sea-ql.org/SeaORM/docs/advanced-query/transaction>                                                                              |
| D-4  | `sea-orm-cli migrate generate` writes an **empty** migration skeleton; nothing derives a migration from entity changes                                              | <https://www.sea-ql.org/SeaORM/docs/migration/writing-migration/>                                                                            |
| D-5  | A reverse migration is optional: `MigrationTrait::down` has a default implementation                                                                                | <https://docs.rs/sea-orm-migration/2.0.4/sea_orm_migration/trait.MigrationTrait.html>                                                        |
| D-6  | Since 2.0.0-rc.36 a migration can opt out of its transaction, which allows `CREATE INDEX CONCURRENTLY`                                                              | SeaORM `changelog/2.0.0-rc.36.md`                                                                                                            |
| D-7  | Schema-sync introspects the live database at application start and issues DDL directly, writing no migration file; the API marks it experimental and outside semver | <https://www.sea-ql.org/SeaORM/docs/generate-entity/entity-first/>; <https://docs.rs/sea-orm/2.0.4/sea_orm/schema/struct.SchemaBuilder.html> |
| D-8  | The guide and the API disagree on whether schema-sync alters existing objects                                                                                       | same two pages                                                                                                                               |
| D-9  | The fix for concurrent `Migrator::up`/`down` double-applying on Postgres, and `ignore_missing_migrations`, are **unreleased**                                       | SeaORM `CHANGELOG.md`, Unreleased, on `master`                                                                                               |
| D-10 | SeaQuery 1.0 alter statements have no add-CHECK, `NOT VALID` or `VALIDATE CONSTRAINT`; there is no RLS DDL or `SET LOCAL` helper                                    | <https://docs.rs/sea-query/latest/sea_query/>, `TableAlterStatement`                                                                         |
| D-11 | Since 2.0.3, entity codegen from a live database skips partial indexes                                                                                              | SeaORM `changelog/2.0.3.md`                                                                                                                  |
| D-12 | SeaORM's 2.0 RBAC (`RestrictedConnection`) is application-side and does not cover raw SQL; it is not Postgres row-level security                                    | SeaORM `CHANGELOG.md`, 2.0.0                                                                                                                 |

### API, auth, MCP and limits

| #    | Claim                                                                                                                                                                   | Source                                                                                                                                        |
| ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| S-1  | utoipa schema attributes document constraints only; no request validation is generated                                                                                  | `utoipa-gen/src/lib.rs`, github.com/juhaku/utoipa (partial — read from source)                                                                |
| S-2  | problem_details 0.11.0 requires utoipa ^5.4, so it cannot feed utoipa 6 documents                                                                                       | <https://crates.io/api/v1/crates/problem_details/0.11.0/dependencies>                                                                         |
| S-3  | Native apps must not use embedded user-agents and authorisation servers must support PKCE for them; loopback redirects are permitted                                    | RFC 8252, <https://www.rfc-editor.org/rfc/rfc8252.txt>, Sections 7–8                                                                          |
| S-4  | openidconnect 4.1.0 requires rsa ^0.9.2; RUSTSEC-2023-0071 (Marvin) is patched only in rsa ≥ 0.10.0                                                                     | <https://crates.io/api/v1/crates/openidconnect/4.1.0/dependencies>; advisory-db `crates/rsa/RUSTSEC-2023-0071.md`                             |
| S-5  | oxide-auth last released 02/06/2024                                                                                                                                     | <https://crates.io/api/v1/crates/oxide-auth>                                                                                                  |
| S-6  | tower-http 0.7.1 adds a stateless `Sec-Fetch-Site`/`Origin` `CsrfLayer` that allows a request carrying neither header; it does not exist in 0.6                         | <https://docs.rs/tower-http/0.7.1/tower_http/csrf/index.html>                                                                                 |
| S-7  | rmcp's OAuth support is client-side; its server auth example hand-serves protected-resource metadata and checks tokens against an in-memory map                         | `docs/OAUTH_SUPPORT.md` and `examples/servers/src/complex_auth_streamhttp.rs` at tag `rmcp-v3.10.0`, github.com/modelcontextprotocol/rust-sdk |
| S-8  | MCP authorisation is optional; where used, servers must publish RFC 9728 metadata, validate the audience, and never pass tokens through; it rests on an OAuth 2.1 draft | <https://modelcontextprotocol.io/specification/2026-07-28/basic/authorization>                                                                |
| S-9  | tower_governor's `SmartIpKeyExtractor` takes the first parseable X-Forwarded-For address; its state is in-process                                                       | `src/key_extractor.rs` on `main`, github.com/benwis/tower-governor (partial — `main`, not the 0.8.0 tag)                                      |
| S-10 | axum's `DefaultBodyLimit` and `Multipart` default to 2 MB; multer's own size limit defaults to unbounded                                                                | <https://docs.rs/axum/0.8.9/axum/extract/struct.DefaultBodyLimit.html>; multer `src/size_limit.rs`                                            |
| S-11 | sqlx 0.9 pools default to 10 connections and a 30 s acquire timeout                                                                                                     | `sqlx-core/src/pool/options.rs` at `v0.9.0`, github.com/launchbadge/sqlx                                                                      |

### Advisories (RustSec, front-matter read 17/11/2026)

| ID                | Crate   | Issue                                     | Patched                |
| ----------------- | ------- | ----------------------------------------- | ---------------------- |
| RUSTSEC-2026-0189 | rmcp    | DNS rebinding, Streamable HTTP server     | ≥ 1.4.0                |
| RUSTSEC-2026-0461 | rmcp    | Unbounded tool-schema cache               | ≥ 3.6.0                |
| RUSTSEC-2026-0457 | rmcp    | OAuth client SSRF                         | ≥ 3.7.0                |
| RUSTSEC-2026-0462 | rmcp    | Unbounded client response buffering       | ≥ 3.9.0                |
| RUSTSEC-2026-0533 | ammonia | mXSS via SVG/MathML — one of five in 2026 | ≥ 4.2.5                |
| RUSTSEC-2026-0384 | tokio   | `Interval` race                           | 1.54.0 only; ≥ 1.54.1  |
| RUSTSEC-2026-0386 | tokio   | `AsyncFd` unsound                         | ≥ 1.53.3; 1.51.6–<1.52 |
| RUSTSEC-2026-0258 | h2      | Unbounded empty DATA frames               | ≥ 0.4.16               |
| RUSTSEC-2023-0071 | rsa     | Marvin timing side channel                | ≥ 0.10.0               |

Source: `crates/<crate>/<ID>.md` in <https://github.com/rustsec/advisory-db>. No advisory is filed
for axum, leptos, sea-orm, utoipa-swagger-ui or jsonwebtoken — absence from the database is not an
audit. An earlier draft dated three rmcp advisories 09/11/2026; their front-matter dates are
20/10, 22/10 and 05/11/2026, so that date is **refuted**.

### Testing and tooling

| #   | Claim                                                                                               | Source                                                                                                                      |
| --- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| T-1 | cargo-nextest 0.9.152 does not run doctests; run `cargo test --doc` separately                      | <https://nexte.st/docs/running/>                                                                                            |
| T-2 | `#[sqlx::test]` creates a database per test; SeaORM can wrap the pool via `SqlxPostgresConnector`   | <https://docs.rs/sqlx/0.9.0/sqlx/attr.test.html>; <https://docs.rs/sea-orm/2.0.4/sea_orm/struct.SqlxPostgresConnector.html> |
| T-3 | WASM coverage is experimental and nightly-only (minicov)                                            | <https://wasm-bindgen.github.io/wasm-bindgen/wasm-bindgen-test/coverage.html>                                               |
| T-4 | cargo-fuzz requires nightly                                                                         | <https://rust-fuzz.github.io/book/cargo-fuzz/setup.html>                                                                    |
| T-5 | Playwright `javaScriptEnabled: false` is a documented test option                                   | <https://playwright.dev/docs/api/class-testoptions>                                                                         |
| T-6 | lightningcss parses, transforms and minifies but is not a linter, and its crate line is 1.0.0-alpha | lightningcss README; <https://crates.io/api/v1/crates/lightningcss>                                                         |
| T-7 | cargo-deny 0.21.0 is current; the repo pins 0.20.2                                                  | <https://crates.io/api/v1/crates/cargo-deny>; [.cargo-deny-version](../code/src/rust/.cargo-deny-version)                   |
| T-8 | cargo-mutants describes itself as semi-actively maintained                                          | cargo-mutants README, github.com/sourcefrog/cargo-mutants                                                                   |

### Repository fit

| #   | Claim                                                                                                                                   | Source                                                                                                                                                 |
| --- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| F-1 | By a crude term grep, 164 of 186 `code/docs` files and 52 of 54 `code/workflows` files mention the Django stack; 24 skills mention none | repo grep, 17/11/2026, over `.md/.sh/.yml/.py/.html/.toml`                                                                                             |
| F-2 | `copier.yml` asks no framework question; its opt-in flags are mobile, Rust, desktop, Wagtail and ClickUp                                | [copier.yml](../copier.yml)                                                                                                                            |
| F-3 | Rust is subordinate by doctrine: work stays in Python unless Python cannot make the guarantee or a measured hot path needs it           | [RUST.md](../code/docs/RUST.md), lines 39-56                                                                                                           |
| F-4 | The token layer is DB-canonical by rule but declared, not wired; every emitter is specified as Django-side Python                       | [DESIGN-TOKENS.md](../code/docs/DESIGN-TOKENS.md); [MAP-NATIVE-MOBILE-SURFACE](../project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md) |
| F-5 | The FN map rules out switching all projects away from Django and keeps Django a candidate maintained profile                            | [MAP-FRAMEWORK-NEUTRAL-FOUNDATION](../project-management/src/01-FEATURE-MAPS/MAP-FRAMEWORK-NEUTRAL-FOUNDATION.md), _Out of scope_                      |
| F-6 | The design toolkit is settled as standalone Python needing no Django application                                                        | [MAP-NATIVE-DESIGN-TIER](../project-management/src/01-FEATURE-MAPS/MAP-NATIVE-DESIGN-TIER.md), N-025                                                   |
| F-7 | No Rust leg runs on a schedule: an advisory against an unchanged `Cargo.lock` goes unseen                                               | [GAPS.md](../GAPS.md), 01/09/2026 entry                                                                                                                |
| F-8 | No generated project exists from syntek-base                                                                                            | Sam, this conversation, 17/11/2026                                                                                                                     |

---

## Assessment

Judgement drawn from the claims; not itself verified.

**What works.** Querying the article/author/tag/revision domain fits SeaORM well (D-1 to D-3). Every
layer has a stable crate, all on axum 0.8 (V-3, V-6, V-11, V-12). The no-JS Playwright lane and
the existing `code/src/scripts/rust/` gates (`_common.sh`, `audit.sh`, `deny.toml`) carry over.

**What costs.**

- **Dependency skews** — no released axum-login fits tower-sessions 0.15 (V-15); CSRF needs
  tower-http 0.7 while Leptos 0.8 holds 0.6 (V-6, S-6); no current Redis session store (V-16);
  openidconnect fails the advisory gate (S-4). The MSRV floor must rise to at least 1.94 (V-8, V-10).
- **Safety by assembly, not by default.** Every Django-column "works without JS by default" becomes
  "works if built a specific way" under Leptos: per-route `InOrder`/`Async` (R-1, R-2), plain Axum
  POST handlers for forms whose values must survive (R-6), a CSRF layer that fails open without
  headers (R-8, S-6), a trusted-proxy rate-limit key (S-9), an RLS transaction wrapper (D-10, D-12).
  Nothing fails loudly when one is forgotten, so each needs a gate.
- **Migration safety regresses.** No autodetection or `--check` (D-4), optional reverses (D-5),
  experimental schema-sync that must be banned (D-7, D-8), migrations as a single job until the
  concurrency fix ships (D-9), raw SQL for RLS and staged constraints (D-10). The template would own
  a drift check, an upgrade test and a schema-sync ban.
- **Doctrine collisions.** Inline hydration scripts and per-response nonces fight the no-inline and
  whole-page-cache rules; a hydrated router is the banned `hx-boost` pattern (R-3, R-4, R-10).
- **No CMS-class surface** — admin, page tree and moderation, renditions, i18n, search, mail, jobs.
  Projects needing them keep choosing Django and Wagtail, which weakens Rust as the studio default.
- **Churn** — Leptos 0.9 at RC (V-5), lockstep OpenTelemetry (V-17), weekly rmcp with four 2026
  advisories, stale single-maintainer crates (V-13).

**A variant worth tracing.** Axum with server-only templates and HTMX, no WASM, fits the current
frontend doctrine better than Leptos hydration. Askama and MiniJinja were **not** researched here.

**No-JS baseline policy (proposed).** Public pages and essential CMS workflows (login, draft, preview,
publish, upload, revisions) are server-rendered with no hydration and tested with scripting off;
islands only for rich text, drag-reorder, autosave and live preview, each with a tested fallback.

**On the maps.** A default is an answer to N-006 and N-013, so it belongs on a grilling node after the
N-012 tracer and N-007 evidence, not a scope row. With F-8, N-008's migration risk does not bind it.
N-010's leaning — a committed CSS token file as canonical, the database an optional Django-profile
editor — removes the framework dependency from the token rule (F-4) and makes a Slint emitter a pure
build step. N-025 stands (F-6); Python remains a host prerequisite for Copier and the design toolkit,
and N-015's `design` dependency group needs a manifest that is not the application's.

---

## Unverified — checks a spike must run

1. `cargo generate-lockfile && cargo tree -d` on a scratch workspace — duplicate sqlx and tower-http.
2. `cargo deny check licenses advisories` against [deny.toml](../code/src/rust/deny.toml) on that graph.
3. `cargo build --timings` and `cargo leptos build --release`, cold and warm, on the CI runner class.
4. A native multipart post through a server function with scripting off — redirect and error encoding.
5. Rendering the hydration scripts conditionally per route, asserting no `.wasm` request on that route.
6. Whether `@axe-core/playwright` runs in a JavaScript-disabled context.
7. Whether leptosfmt handles Leptos 0.8 `view!` syntax and coexists with `cargo fmt --check`.
8. rmcp's `StreamableHttpServerConfig` allowed-hosts API behind a reverse proxy.
9. `#[sqlx::test(migrations = false)]` wrapping the pool and running `Migrator::up` per test.
10. Askama or MiniJinja with HTMX on Axum — versions, maintenance and fit with `RENDERING.md`.

---

## Sources

Primary sources were read on 17/11/2026 through the crates.io API, docs.rs, raw GitHub sources at
release tags, the RustSec advisory database, rfc-editor.org, modelcontextprotocol.io, the Leptos
book, the SeaORM documentation and changelogs, the Cargo reference and Playwright's documentation;
each is cited beside its claim. Repository files are linked beside theirs. Blogs and Perplexity
were used only to locate sources and are not cited. No third-party text is quoted verbatim, so no
_Influences_ row or third-party notice is owed.

## Feeds

- **N-012 on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** — the second-framework tracer: candidate variants,
  acceptance evidence and the _Unverified_ checks above.
- **A proposed default-profile node on MAP-FRAMEWORK-NEUTRAL-FOUNDATION** (N-038 if taken; not yet
  charted) — which web profile is the generation default, blocked by N-006, N-012 and N-013.
- **N-010 and N-015 on MAP-NATIVE-DESIGN-TIER** — the canonical token source and the design
  toolkit's dependency manifest.

17/11/2026. No ADR, story or plan cites this note yet; wiring back happens in the `/wayfinder`
session that adds these edges to the maps.
