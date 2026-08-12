# References — code layer

Internal and external references for all coding work in this repository.

---

## Internal

### Layer CONTEXT files

- `code/CONTEXT.md` — top-level coding standards, patterns, and testing guide
- `code/docs/CONTEXT.md` — index of all coding reference guides
- `code/workflows/CONTEXT.md` — index of all step-by-step coding workflows
- `code/src/CONTEXT.md` — source root: sub-layer map and contributing rules
- `code/src/logs/CONTEXT.md` — local log files: location, access, and rotation

### Workflow CONTEXT files

- `code/workflows/01-new-feature/CONTEXT.md` — add a new full-stack feature
- `code/workflows/02-tdd-cycle/CONTEXT.md` — Red → Green → Refactor TDD cycle
- `code/workflows/03-database-migration/CONTEXT.md` — Django model and migration workflow
- `code/workflows/04-api-design/CONTEXT.md` — Django Ninja API design
- `code/workflows/05-mcp-server/CONTEXT.md` — add a FastMCP tool to the `/mcp/` surface
- `code/workflows/06-gdpr-enforcement/CONTEXT.md` — GDPR code implementation
- `code/workflows/07-review/CONTEXT.md` — code quality review before raising a PR
- `code/workflows/08-security-hardening/CONTEXT.md` — OWASP security audit and hardening
- `code/workflows/09-debugging-with-logs/CONTEXT.md` — debug using logs and observability tools
- `code/workflows/10-debug/CONTEXT.md` — code-logic debugging and regression tests
- `code/workflows/11-refactor/CONTEXT.md` — systematic refactoring without behaviour change
- `code/workflows/12-rust-extension/CONTEXT.md` — **rust-only** — PyO3 extensions in the Cargo workspace
- `code/workflows/13-desktop-app/CONTEXT.md` — **desktop-only** — the native Slint application

### Guides in code/docs/

- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA, semantic HTML, ARIA patterns
- `code/docs/API-DESIGN.md` — Django Ninja conventions, JSON API patterns
- `code/docs/ARCHITECTURE-PATTERNS.md` — service layer, Django app structure, page routing
- `code/docs/BACKEND-CODING-PRINCIPLES.md` — Django/Python/Celery specifics: class vs function, error handling, caching (read with `CODING-PRINCIPLES.md`)
- `code/docs/CODE-REVIEW-GRAPH.md` — code-review-graph MCP playbooks (explore, debug, review, refactor)
- `code/docs/CODING-PRINCIPLES.md` — file-length limits, Rob Pike and Linus Torvalds rules
- `code/docs/DATABASE.md` — pre-flight data-layer rules: scope columns, database-level constraints, lock-safe migrations, search, deferred infrastructure with trigger conditions
- `code/docs/DATA-STRUCTURES.md` — domain modelling, PostgreSQL schema design, indexing
- `code/docs/DESIGN-TOKENS.md` — CSS design-token catalogue and `var(--token)`-only usage rules
- `code/docs/DISCOVERABILITY.md` — how this stack implements being found: the `build_seo()` head pipeline and canonical rules (`discoverability/WEB-METADATA.md`), the typed JSON-LD builders and their XSS-safe serialiser (`STRUCTURED-DATA.md`), every root and `/.well-known/` file with the register naming who owns each (`ROOT-SURFACE.md`), and the shape of the page body (`CONTENT-STRUCTURE.md`, whose § 1 disposes of the chunking, fan-out and per-engine GEO myths against Google's own documentation). The **method** side of the seam whose **requirements** side is `project-management/docs/SEO-CHECKLIST.md`
- `code/docs/discoverability/APP-STORE.md` — **mobile-only** — the fifth output surface and the only one belonging to a different deployable: the App Store and Play listing text fields, their character limits with a dated `**Source:**` per vendor, and the unit error nearly every third-party ASO source repeats — Apple's keyword budget is **100 bytes**, not 100 characters, which only diverge once a listing is localised
- `code/docs/DESKTOP.md` — **desktop-only** — the native Slint application: the Royalty-free licence obligation and its AboutSlint disclosure, the generated-code lint boundary, threading, and AccessKit accessibility
- `code/docs/DOCUMENTATION-PAIRING.md` — the `CONTEXT.md` / `CLAUDE.md` split: the decision test that separates orientation from operating rules, the headings banned from an orientation file and where each moves, route-don't-restate, and the two pairing exceptions
- `code/docs/ENCRYPTION-GUIDE.md` — field-level encryption patterns for PII storage
- `code/docs/NOTIFICATIONS.md` — the notification channel layer: why an endpoint enqueues and a background task sends, the single branded email template foundation and its SMS signature prefix, and the per-channel PII rules — the subject line above all, because it is the part that appears on a lock screen (declared, not wired)
- `code/docs/EXPORTS.md` — downloadable file exports: the library chosen per format (stdlib `csv` streamed, `openpyxl`, `weasyprint`, stdlib `json`) and why the PDF choice makes an invoice a template rather than a second set of brand literals, the formatter contract, PII gating and the audit record every export writes, locale as part of the file (declared, not wired)
- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — Django templates + django-components + HTMX + Alpine + CSS specifics (read with `CODING-PRINCIPLES.md`)
- `code/docs/MOBILE-CODING-PRINCIPLES.md` — **mobile-only** — the third peer of the two coding-principles guides above: the four TypeScript flags beyond `strict` (each bans a state) and the two deliberately declined because ESLint already owns them, exhaustiveness through `unreachable()` and why it is not called `assertNever`, branded IDs declined until there is a parse boundary to mint them at, and how this surface expresses the error taxonomy — one `ErrorBoundary` at the root, a tracker declared but not wired, and the inversion that makes an environment error the ordinary case on a phone
- `code/docs/LOGGING.md` — logging config, error tracking, log aggregation, metrics and dashboards, distributed tracing
- `code/docs/MCP-SERVER.md` — the FastMCP tool surface at `/mcp/`: mounting, tool design, auth and threats, testing and ops (available but unwired)
- `code/docs/TASK-AUTHORING.md` — background-task authoring: the enqueue boundary (never enqueue inside an uncommitted transaction, and the committed-but-unpublished window the on-commit hook leaves open), the delivery guarantee as a configured choice rather than an inherited one, idempotency, retries and backoff, time and rate limits, queue routing, testing without a broker (declared, not wired)
- `code/docs/MANAGEMENT-COMMANDS.md` — the sibling of `TASK-AUTHORING.md`, and the surface whose runtime already exists: when work belongs to a person choosing the moment rather than to a queue, why argparse parsing is not validation and a command-line identifier is as unverified as one from a URL, blast radius as the argument nobody passes (`--dry-run`, declared bounds, and why the confirmation prompt is not the safety), and the taxonomy as exit codes — type distinguishes the classes, only `EX_TEMPFAIL` (75) carries meaning, and a traceback is the correct output for a programmer error. Shipped as `apps.core.management.base.ManagementCommand`, made a rule by the ruff `TID251` ban on both `BaseCommand` import paths
- `code/docs/PROCESS-MODEL.md` — worker class, event loop, the ORM's sync boundary, and where a task worker sits relative to the web process family
- `code/docs/OBJECT-STORAGE.md` — private-document storage over the S3 API: the adapter contract, presigned URLs, upload validation (declared, not wired)
- `code/docs/security/AUDIT-TRAIL.md` — the audit record's owner: schema, write path and its transaction rule, what must be recorded, the PII rule, retention, immutability, tamper-resistance (OWASP A09)
- `code/docs/architecture/PROVIDER-NEUTRALITY.md` — seam vs substrate: the two evidence bars, the substrate test, and how a guide names an interface rather than a product
- `code/docs/architecture/BUILD-OPERATE-SEAM.md` — where a fact lives across `code/docs` (the why), `SERVER-ARCHITECTURE` (the contract) and the deploy repo; the ownership sentence, the `**Source:**` field, and the same-change rule
- `code/docs/NEGATIVE-SPACE.md` — what the code must never allow: what counts as an invariant, the invariant-class catalogue with one named enforcement point each, the soft-delete partial-unique trap, the three-class error taxonomy (`InvariantViolation` outside the `ServiceError` tree), and the guard clause — `raise` never `assert`, gated by ruff `S101`, inline at the one named method, and what a guard must never do. The per-project answer sheet is `how-to/src/INVARIANTS.md`
- `code/docs/PERFORMANCE.md` — N+1 prevention, caching, template/HTMX optimisation
- `code/docs/RENDERING.md` — server-rendered templates, HTMX partials, Alpine, and where each interaction runs
- `code/docs/RESPONSIVE-DESIGN.md` — mobile-first CSS, media queries, breakpoints, CSS custom properties
- `code/docs/RLS-GUIDE.md` — row-level security patterns for multi-tenant scope
- `code/docs/RUST.md` — **rust-only** — the Cargo workspace: the gate question, the PyO3 boundary, memory hygiene for secrets, and the cargo-deny supply-chain policy
- `code/docs/SECURITY.md` — OWASP A01–A10, Django Ninja API security, CORS, IDOR prevention
- `code/docs/TESTING.md` — TDD phases, coverage floors, pytest setup
- `code/docs/URL-STRATEGY.md` — route naming, slug patterns, Django URL conventions
- `code/docs/VISUAL-DESIGN.md` — visual language, the cross-surface core: the per-project **direction** and its six axes (§3, settled at first-time setup), the universal tells (§4.1) and the direction deviations that read off those axes (§4.2), the motion numeric standard and the standards-floor/axes-shape precedence rule (§5), design-artefact routing
- `code/docs/visual-design/WEB.md` — the web expression of that direction: the signature in CSS and django-components, the component vocabulary, and the web pre-ship checklist
- `code/docs/visual-design/MOBILE.md` — **mobile-only** — the mobile expression: platform conformance and adaptivity, the two dimensions no other guide owns. Mobile slop is a different taxonomy, not a translation of the web's
- `code/docs/visual-design/DESKTOP.md` — **desktop-only** — the desktop expression: the stock-Fluent tell (Slint 1.16+ defaults to Fluent on every platform) and the deliberate compile-time style choice
- `code/docs/cloudinary/CONTEXT.md` — Cloudinary SDK docs index (Python SDK)
- `code/docs/cloudinary/PYTHON_SDK.md` — Cloudinary Python SDK: upload, admin API, exceptions
- `code/docs/cloudinary/CROSS_SDK_INFO.md` — Cross-SDK: config params, action syntax, browser support, input validation

---

## External — Framework & Language Docs

### Backend

- **Django 6.x** — <https://docs.djangoproject.com/en/6.0/> — official Django reference
- **Python 3.14** — <https://docs.python.org/3.14/> — language reference and standard library
- **Django Ninja** — <https://django-ninja.dev/> — Python JSON API framework used for all API endpoints and Schema (Pydantic) models
- **FastMCP** — <https://gofastmcp.com/> — the Python MCP server framework behind the `/mcp/` tool surface (not installed at baseline)
- **Model Context Protocol** — <https://modelcontextprotocol.io/> — the protocol specification FastMCP implements; read for transport and session semantics
- **Starlette** — <https://www.starlette.io/> — the ASGI toolkit that composes the `/mcp/` and Django mounts in `config/asgi.py` (arrives with FastMCP)
- **Celery — configuration reference** — <https://docs.celeryq.dev/en/stable/userguide/configuration.html> — the acknowledgement settings that decide the delivery guarantee. `task_acks_late` is **disabled by default**, so a message is acked before the task body runs and a killed worker loses its task rather than repeating it; `task_reject_on_worker_lost` is what re-queues it, at the risk of a loop. Read before wiring the task surface (`code/docs/TASK-AUTHORING.md` → _Idempotency_)
- **Django — writing management commands** — <https://docs.djangoproject.com/en/6.0/howto/custom-management-commands/> — `BaseCommand`, `add_arguments`, and the `CommandError` contract `ManagementCommand` builds on. Note that `run_from_argv` catches `CommandError` and closes connections, while `call_command()` does neither — the asymmetry `code/docs/MANAGEMENT-COMMANDS.md` exists partly to close
- **`sysexits.h` (BSD)** — <https://man.freebsd.org/cgi/man.cgi?sysexits(3)> — the source of `EX_TEMPFAIL` (75), the one exit code this project spends on meaning. Cited as a platform convention rather than credited in `README.md` § _Influences_: it supplies a number and a name, not doctrine
- **Gunicorn** — <https://docs.gunicorn.org/en/stable/> — WSGI HTTP server
- **Uvicorn** — <https://www.uvicorn.org/> — ASGI server used alongside Gunicorn
- **OpenTelemetry Python** — <https://opentelemetry.io/docs/languages/python/> — the API, SDK and OTLP exporter behind the tracing seam. **Not a declared dependency**: the seam is adopted in doctrine and nothing is instrumented at baseline, so read this only when the trigger in `code/docs/logging/OBSERVABILITY.md` § _Distributed tracing_ has fired

### Native (rust-only)

- **Rust** — <https://doc.rust-lang.org/stable/book/> — the language reference
- **PyO3** — <https://pyo3.rs/> — the Rust↔Python bindings the extension module is built on
- **maturin** — <https://www.maturin.rs/> — the build backend that turns the crate into a wheel
- **zeroize** — <https://docs.rs/zeroize/> — volatile, non-elidable wiping of secret material
- **cargo-deny** — <https://embarkstudios.github.io/cargo-deny/> — the advisory, licence and source gate
- **RustSec advisory database** — <https://rustsec.org/> — what `audit.sh` checks against
- **RustCrypto** — <https://github.com/RustCrypto> — audited primitives; never implement your own
- **Slint** — <https://slint.dev/docs> — the desktop UI toolkit (desktop-only)
- **Slint licensing** — <https://github.com/slint-ui/slint/blob/master/FAQ.md> — the three tiers, and what triggers the paid one
- **AccessKit** — <https://accesskit.dev/> — the accessibility layer Slint ships; keep it enabled

### Frontend

- **HTMX** — <https://htmx.org/docs/> — HTML-over-the-wire interactions for public pages
- **Alpine.js** — <https://alpinejs.dev/> — lightweight client-side reactivity for public pages
- **django-components** — <https://django-components.github.io/django-components/> — server-side component library for Django templates
- **django-htmx** — <https://django-htmx.readthedocs.io/> — Django helpers for HTMX requests and response headers

### Styling

- **CSS custom properties (MDN)** — <https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties> — design token foundations
- **CSS media queries (MDN)** — <https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_media_queries> — responsive breakpoints

---

## External — Testing

- **pytest** — <https://docs.pytest.org/en/stable/> — backend test runner
- **pytest-django** — <https://pytest-django.readthedocs.io/en/latest/> — Django integration for pytest
- **factory_boy** — <https://factoryboy.readthedocs.io/> — model fixtures for tests
- **Hypothesis** — <https://hypothesis.readthedocs.io/> — property-based testing
- **Bruno** — <https://docs.usebruno.com/> — HTTP-layer API integration tests
- **pytest-playwright** — <https://playwright.dev/python/docs/test-runners> — the browser e2e suite
- **axe-core-python** — <https://github.com/mdn/axe-core-python> — the WCAG 2.2 AA scan, no Node required. **Web surface only** — there is no React Native equivalent, so mobile accessibility verification is manual (React Native Testing Library queries, then VoiceOver and TalkBack on device). Mobile a11y is never "scanned clean"; see `code/docs/accessibility/MOBILE.md`

---

## External — Code Quality

- **Ruff** — <https://docs.astral.sh/ruff/> — Python linter and formatter
- **Prettier** — <https://prettier.io/docs/en/> — opinionated code formatter for CSS, Markdown, and JSON
- **basedpyright** — <https://docs.basedpyright.com/latest/> — strict Python type checker (basedpyright fork of pyright)
- **markdownlint-cli2** — <https://github.com/DavidAnson/markdownlint-cli2#readme> — Markdown linting (enforces MD040 language fences)
- **Opengrep** — <https://github.com/opengrep/opengrep> — the LGPL-2.1 static-analysis engine behind `audits/static-analysis.sh`. Optional: the script degrades gracefully when it is absent. Its **rules are written in-house** — neither `opengrep-rules` (LGPL-2.1 **plus a Commons Clause**) nor `semgrep-rules` (Semgrep Rules License v1.0, non-sublicensable, internal use only) may be vendored, because this template redistributes into generated projects

---

## External — Security & Standards

- **OWASP Top 10 (2021)** — <https://owasp.org/www-project-top-ten/> — security baseline for all Django Ninja endpoints
- **OWASP REST Security Cheat Sheet** — <https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html> — JSON API security guidance
- **NIST SP 800-63B** — <https://pages.nist.gov/800-63-4/sp800-63b.html> — authentication, password policy, and MFA requirements
- **WCAG 2.2 AA** — <https://www.w3.org/TR/WCAG22/> — accessibility compliance standard for all frontend components
- **Django security overview** — <https://docs.djangoproject.com/en/6.0/topics/security/> — CSRF, clickjacking, SQL injection, and XSS guidance
- **UK GDPR (ICO)** — <https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/> — data protection law reference for GDPR compliance work
