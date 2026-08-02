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

### Guides in code/docs/

- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA, semantic HTML, ARIA patterns
- `code/docs/API-DESIGN.md` — Django Ninja conventions, JSON API patterns
- `code/docs/ARCHITECTURE-PATTERNS.md` — service layer, Django app structure, page routing
- `code/docs/CODE-REVIEW-GRAPH.md` — code-review-graph MCP playbooks (explore, debug, review, refactor)
- `code/docs/CODING-PRINCIPLES.md` — file-length limits, Rob Pike and Linus Torvalds rules
- `code/docs/DATABASE.md` — pre-flight data-layer rules: scope columns, database-level constraints, lock-safe migrations, search, deferred infrastructure with trigger conditions
- `code/docs/DATA-STRUCTURES.md` — domain modelling, PostgreSQL schema design, indexing
- `code/docs/DESIGN-TOKENS.md` — CSS design-token catalogue and `var(--token)`-only usage rules
- `code/docs/ENCRYPTION-GUIDE.md` — field-level encryption patterns for PII storage
- `code/docs/LOGGING.md` — logging config, Glitchtip, Loki, Prometheus, Grafana
- `code/docs/MCP-SERVER.md` — the FastMCP tool surface at `/mcp/`: mounting, tool design, auth and threats, testing and ops (available but unwired)
- `code/docs/PERFORMANCE.md` — N+1 prevention, caching, template/HTMX optimisation
- `code/docs/RENDERING.md` — server-rendered templates, HTMX partials, Alpine, and where each interaction runs
- `code/docs/RESPONSIVE-DESIGN.md` — mobile-first CSS, media queries, breakpoints, CSS custom properties
- `code/docs/RLS-GUIDE.md` — row-level security patterns for multi-tenant scope
- `code/docs/RUST.md` — **rust-only** — the Cargo workspace: the gate question, the PyO3 boundary, memory hygiene for secrets, and the cargo-deny supply-chain policy
- `code/docs/SECURITY.md` — OWASP A01–A10, Django Ninja API security, CORS, IDOR prevention
- `code/docs/TESTING.md` — TDD phases, coverage floors, pytest setup
- `code/docs/URL-STRATEGY.md` — route naming, slug patterns, Django URL conventions
- `code/docs/VISUAL-DESIGN.md` — visual language: anti-generic layout, <%ORG_NAME%> signature, design-artefact routing
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
- **Gunicorn** — <https://docs.gunicorn.org/en/stable/> — WSGI HTTP server
- **Uvicorn** — <https://www.uvicorn.org/> — ASGI server used alongside Gunicorn

### Native (rust-only)

- **Rust** — <https://doc.rust-lang.org/stable/book/> — the language reference
- **PyO3** — <https://pyo3.rs/> — the Rust↔Python bindings the extension module is built on
- **maturin** — <https://www.maturin.rs/> — the build backend that turns the crate into a wheel
- **zeroize** — <https://docs.rs/zeroize/> — volatile, non-elidable wiping of secret material
- **cargo-deny** — <https://embarkstudios.github.io/cargo-deny/> — the advisory, licence and source gate
- **RustSec advisory database** — <https://rustsec.org/> — what `audit.sh` checks against
- **RustCrypto** — <https://github.com/RustCrypto> — audited primitives; never implement your own

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

---

## External — Security & Standards

- **OWASP Top 10 (2021)** — <https://owasp.org/www-project-top-ten/> — security baseline for all Django Ninja endpoints
- **OWASP REST Security Cheat Sheet** — <https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html> — JSON API security guidance
- **NIST SP 800-63B** — <https://pages.nist.gov/800-63-4/sp800-63b.html> — authentication, password policy, and MFA requirements
- **WCAG 2.2 AA** — <https://www.w3.org/TR/WCAG22/> — accessibility compliance standard for all frontend components
- **Django security overview** — <https://docs.djangoproject.com/en/6.0/topics/security/> — CSRF, clickjacking, SQL injection, and XSS guidance
- **UK GDPR (ICO)** — <https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/> — data protection law reference for GDPR compliance work
