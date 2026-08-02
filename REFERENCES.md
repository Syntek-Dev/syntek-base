# References — <%PROJECT_SLUG%>

A curated index of internal documentation and external resources Claude should
consult when working in this repository.

---

## Internal — Layer Entry Points

| Document                                                       | Purpose                                                          |
| -------------------------------------------------------------- | ---------------------------------------------------------------- |
| [CONTEXT.md](CONTEXT.md)                                       | Project overview, directory tree, layer map                      |
| [DESIGN.md](DESIGN.md)                                         | Design entry point: standards, constraints, Figma workflows      |
| [GAPS.md](GAPS.md)                                             | Active architectural gaps, blockers, and sprint dependencies     |
| [.claude/CLAUDE.md](.claude/CLAUDE.md)                         | Global rules, model selection, routing, security non-negotiables |
| [code/CONTEXT.md](code/CONTEXT.md)                             | Code layer entry point                                           |
| [how-to/CONTEXT.md](how-to/CONTEXT.md)                         | Setup and daily development entry point                          |
| [project-management/CONTEXT.md](project-management/CONTEXT.md) | PM layer entry point                                             |

---

## Internal — Standards & Guides

### Skills & SDK docs

| Document                                                                         | Purpose                                                           |
| -------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| [skills-lock.json](skills-lock.json)                                             | Installed Claude Code skills — versions and hashes                |
| [code/docs/cloudinary/CONTEXT.md](code/docs/cloudinary/CONTEXT.md)               | Cloudinary SDK docs index — the Python SDK and cross-SDK syntax   |
| [code/docs/cloudinary/PYTHON_SDK.md](code/docs/cloudinary/PYTHON_SDK.md)         | Cloudinary Python SDK — upload, admin API, exceptions             |
| [code/docs/cloudinary/CROSS_SDK_INFO.md](code/docs/cloudinary/CROSS_SDK_INFO.md) | Cross-SDK: config params, transformation syntax, input validation |

### Code guides (`code/docs/`)

| Document                                                                                 | Purpose                                                                                                                                                                |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [code/docs/ACCESSIBILITY.md](code/docs/ACCESSIBILITY.md)                                 | WCAG 2.2 AA compliance rules for all interactive components                                                                                                            |
| [code/docs/API-DESIGN.md](code/docs/API-DESIGN.md)                                       | Django Ninja API design conventions and patterns                                                                                                                       |
| [code/docs/ARCHITECTURE-PATTERNS.md](code/docs/ARCHITECTURE-PATTERNS.md)                 | Layered architecture decisions and module boundaries                                                                                                                   |
| [code/docs/architecture/CORE-AND-SCALING.md](code/docs/architecture/CORE-AND-SCALING.md) | Core/deep module split + Postgres scaling phase-gates — the gates scale-planning sizes under (ADR-016/ADR-023; sizing + readiness in `how-to/src/SCALE-ARCHITECTURE/`) |
| [code/docs/CODE-REVIEW-GRAPH.md](code/docs/CODE-REVIEW-GRAPH.md)                         | code-review-graph MCP playbooks: explore, debug, review, refactor                                                                                                      |
| [code/docs/CODING-PRINCIPLES.md](code/docs/CODING-PRINCIPLES.md)                         | Style rules, function length limits, error handling                                                                                                                    |
| [code/docs/DATA-STRUCTURES.md](code/docs/DATA-STRUCTURES.md)                             | Shared data models and type conventions                                                                                                                                |
| [code/docs/ENCRYPTION-GUIDE.md](code/docs/ENCRYPTION-GUIDE.md)                           | Fernet PII encryption pipeline                                                                                                                                         |
| [code/docs/LOGGING.md](code/docs/LOGGING.md)                                             | Structured logging with Sentry and file-based logs                                                                                                                     |
| [code/docs/MCP-SERVER.md](code/docs/MCP-SERVER.md)                                       | The FastMCP tool surface at `/mcp/` — mounting, tool design, auth and threats, testing and ops (available but unwired)                                                 |
| [code/docs/PERFORMANCE.md](code/docs/PERFORMANCE.md)                                     | Caching, query optimisation, and response-time targets                                                                                                                 |
| [code/docs/RENDERING.md](code/docs/RENDERING.md)                                         | Rendering strategies — where each interaction runs: server template, HTMX, or Alpine                                                                                   |
| [code/docs/RESPONSIVE-DESIGN.md](code/docs/RESPONSIVE-DESIGN.md)                         | Breakpoints, fluid layouts, mobile-first rules                                                                                                                         |
| [code/docs/RLS-GUIDE.md](code/docs/RLS-GUIDE.md)                                         | PostgreSQL row-level security policy conventions                                                                                                                       |
| [code/docs/RUST.md](code/docs/RUST.md)                                                   | **Rust-only.** The Cargo workspace: the gate question, the PyO3 boundary, secret memory hygiene, and the cargo-deny supply-chain policy                                |
| [code/docs/SECURITY.md](code/docs/SECURITY.md)                                           | OWASP controls, permission checks, IDOR prevention                                                                                                                     |
| [code/docs/TESTING.md](code/docs/TESTING.md)                                             | Coverage floors, test structure, mocking strategy                                                                                                                      |
| [code/docs/URL-STRATEGY.md](code/docs/URL-STRATEGY.md)                                   | URL naming, slug patterns, API endpoint conventions                                                                                                                    |

### How-to guides (`how-to/docs/`)

| Document                                                         | Purpose                                           |
| ---------------------------------------------------------------- | ------------------------------------------------- |
| [how-to/docs/CLI-TOOLING.md](how-to/docs/CLI-TOOLING.md)         | CLI tools reference: scripts, commands, shortcuts |
| [how-to/docs/DEVELOPMENT.md](how-to/docs/DEVELOPMENT.md)         | Day-to-day development setup and workflow         |
| [how-to/docs/GIT-WORKTREES.md](how-to/docs/GIT-WORKTREES.md)     | Git worktree creation and management              |
| [how-to/docs/TOOLING-GUIDE.md](how-to/docs/TOOLING-GUIDE.md)     | Internal agents and skills reference (index)      |
| [how-to/docs/AI-DICTIONARY.md](how-to/docs/AI-DICTIONARY.md)     | Plain-English glossary of AI-coding terms (index) |
| [how-to/docs/SKILL-AUTHORING.md](how-to/docs/SKILL-AUTHORING.md) | How to write predictable Claude Code skills       |

### Project-management guides (`project-management/docs/`)

| Document                                                                                             | Purpose                                        |
| ---------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| [project-management/docs/GDPR-GUIDE.md](project-management/docs/GDPR-GUIDE.md)                       | UK GDPR compliance workflow for new features   |
| [project-management/docs/GIT-GUIDE.md](project-management/docs/GIT-GUIDE.md)                         | Branch naming, commit conventions, PR process  |
| [project-management/docs/QA-GUIDE.md](project-management/docs/QA-GUIDE.md)                           | Manual and automated QA checklists             |
| [project-management/docs/RESPONSIVE-DESIGN.md](project-management/docs/RESPONSIVE-DESIGN.md)         | PM-level responsive design requirements        |
| [project-management/docs/SECURITY-GUIDE.md](project-management/docs/SECURITY-GUIDE.md)               | Security audit process and sign-off criteria   |
| [project-management/docs/SEO-CHECKLIST.md](project-management/docs/SEO-CHECKLIST.md)                 | Per-page SEO checklist for Django routes       |
| [project-management/docs/SPRINT-PLANNING-GUIDE.md](project-management/docs/SPRINT-PLANNING-GUIDE.md) | Sprint sizing, velocity, and capacity rules    |
| [project-management/docs/VERSIONING-GUIDE.md](project-management/docs/VERSIONING-GUIDE.md)           | Semantic versioning rules and changelog format |

---

## Internal — Workflows

### Code workflows (`code/workflows/`)

| Workflow                 | CONTEXT.md                                                                                           |
| ------------------------ | ---------------------------------------------------------------------------------------------------- |
| Index                    | [code/workflows/CONTEXT.md](code/workflows/CONTEXT.md)                                               |
| 01 — New feature         | [code/workflows/01-new-feature/CONTEXT.md](code/workflows/01-new-feature/CONTEXT.md)                 |
| 02 — TDD cycle           | [code/workflows/02-tdd-cycle/CONTEXT.md](code/workflows/02-tdd-cycle/CONTEXT.md)                     |
| 03 — Database migration  | [code/workflows/03-database-migration/CONTEXT.md](code/workflows/03-database-migration/CONTEXT.md)   |
| 04 — API design          | [code/workflows/04-api-design/CONTEXT.md](code/workflows/04-api-design/CONTEXT.md)                   |
| 05 — MCP server          | [code/workflows/05-mcp-server/CONTEXT.md](code/workflows/05-mcp-server/CONTEXT.md)                   |
| 06 — GDPR enforcement    | [code/workflows/06-gdpr-enforcement/CONTEXT.md](code/workflows/06-gdpr-enforcement/CONTEXT.md)       |
| 07 — Review              | [code/workflows/07-review/CONTEXT.md](code/workflows/07-review/CONTEXT.md)                           |
| 08 — Security hardening  | [code/workflows/08-security-hardening/CONTEXT.md](code/workflows/08-security-hardening/CONTEXT.md)   |
| 09 — Debugging with logs | [code/workflows/09-debugging-with-logs/CONTEXT.md](code/workflows/09-debugging-with-logs/CONTEXT.md) |
| 10 — Debug               | [code/workflows/10-debug/CONTEXT.md](code/workflows/10-debug/CONTEXT.md)                             |
| 11 — Refactor            | [code/workflows/11-refactor/CONTEXT.md](code/workflows/11-refactor/CONTEXT.md)                       |
| 12 — Rust extension      | [code/workflows/12-rust-extension/CONTEXT.md](code/workflows/12-rust-extension/CONTEXT.md)           |

> Grouped in four families: **build** (01–06), **verify** (07–08), **diagnose & improve**
> (09–11), and **build, opt-in** (12 — rust-only, absent unless the project opted in). The
> numbers are stable identifiers, not a sequence — append, never renumber.

### How-to workflows (`how-to/workflows/`)

| Workflow                  | CONTEXT.md                                                                                                 |
| ------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Index                     | [how-to/workflows/CONTEXT.md](how-to/workflows/CONTEXT.md)                                                 |
| 01 — First-time setup     | [how-to/workflows/01-first-time-setup/CONTEXT.md](how-to/workflows/01-first-time-setup/CONTEXT.md)         |
| 02 — Worktree setup       | [how-to/workflows/02-worktree-setup/CONTEXT.md](how-to/workflows/02-worktree-setup/CONTEXT.md)             |
| 03 — Daily development    | [how-to/workflows/03-daily-development/CONTEXT.md](how-to/workflows/03-daily-development/CONTEXT.md)       |
| 04 — Database operations  | [how-to/workflows/04-database-operations/CONTEXT.md](how-to/workflows/04-database-operations/CONTEXT.md)   |
| 05 — Testing & coverage   | [how-to/workflows/05-testing-and-coverage/CONTEXT.md](how-to/workflows/05-testing-and-coverage/CONTEXT.md) |
| 06 — Quality gates        | [how-to/workflows/06-quality-gates/CONTEXT.md](how-to/workflows/06-quality-gates/CONTEXT.md)               |
| 07 — Dependency updates   | [how-to/workflows/07-dependency-updates/CONTEXT.md](how-to/workflows/07-dependency-updates/CONTEXT.md)     |
| 08 — Debugging            | [how-to/workflows/08-debugging/CONTEXT.md](how-to/workflows/08-debugging/CONTEXT.md)                       |
| 09 — Write operator guide | [how-to/workflows/09-write-operator-guide/CONTEXT.md](how-to/workflows/09-write-operator-guide/CONTEXT.md) |

> Grouped in four families: **set up** (01–02), **run** (03–07), **diagnose** (08),
> **author** (09). Numbers are stable identifiers, not a sequence.

### Project-management workflows (`project-management/workflows/`)

| Workflow                          | CONTEXT.md                                                                                                                                         |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Index                             | [project-management/workflows/CONTEXT.md](project-management/workflows/CONTEXT.md)                                                                 |
| 01 — Story creation               | [project-management/workflows/01-story-creation/CONTEXT.md](project-management/workflows/01-story-creation/CONTEXT.md)                             |
| 02 — Sprint planning              | [project-management/workflows/02-sprint-planning/CONTEXT.md](project-management/workflows/02-sprint-planning/CONTEXT.md)                           |
| 03 — Database schema              | [project-management/workflows/03-database-schema/CONTEXT.md](project-management/workflows/03-database-schema/CONTEXT.md)                           |
| 04 — User flow design             | [project-management/workflows/04-user-flow-design/CONTEXT.md](project-management/workflows/04-user-flow-design/CONTEXT.md)                         |
| 05 — Brand guides                 | [project-management/workflows/05-brand-guides/CONTEXT.md](project-management/workflows/05-brand-guides/CONTEXT.md)                                 |
| 06 — Component designs            | [project-management/workflows/06-component-designs/CONTEXT.md](project-management/workflows/06-component-designs/CONTEXT.md)                       |
| 07 — Wireframes                   | [project-management/workflows/07-wireframes/CONTEXT.md](project-management/workflows/07-wireframes/CONTEXT.md)                                     |
| 08 — GDPR compliance              | [project-management/workflows/08-gdpr-compliance/CONTEXT.md](project-management/workflows/08-gdpr-compliance/CONTEXT.md)                           |
| 09 — Security checks              | [project-management/workflows/09-security-checks/CONTEXT.md](project-management/workflows/09-security-checks/CONTEXT.md)                           |
| 10 — QA checks                    | [project-management/workflows/10-qa-checks/CONTEXT.md](project-management/workflows/10-qa-checks/CONTEXT.md)                                       |
| 11 — SEO checks                   | [project-management/workflows/11-seo-checks/CONTEXT.md](project-management/workflows/11-seo-checks/CONTEXT.md)                                     |
| 12 — API design                   | [project-management/workflows/12-api-design/CONTEXT.md](project-management/workflows/12-api-design/CONTEXT.md)                                     |
| 13 — Decisions                    | [project-management/workflows/13-decisions/CONTEXT.md](project-management/workflows/13-decisions/CONTEXT.md)                                       |
| 14 — Sprint plans                 | [project-management/workflows/14-sprint-plans/CONTEXT.md](project-management/workflows/14-sprint-plans/CONTEXT.md)                                 |
| 15 — Story plans                  | [project-management/workflows/15-story-plans/CONTEXT.md](project-management/workflows/15-story-plans/CONTEXT.md)                                   |
| 16 — Backend code                 | [project-management/workflows/16-backend-code/CONTEXT.md](project-management/workflows/16-backend-code/CONTEXT.md)                                 |
| 17 — API code                     | [project-management/workflows/17-api-code/CONTEXT.md](project-management/workflows/17-api-code/CONTEXT.md)                                         |
| 18 — Frontend code                | [project-management/workflows/18-frontend-code/CONTEXT.md](project-management/workflows/18-frontend-code/CONTEXT.md)                               |
| 19 — Implementation documentation | [project-management/workflows/19-implementation-documentation/CONTEXT.md](project-management/workflows/19-implementation-documentation/CONTEXT.md) |
| 20 — PR and review                | [project-management/workflows/20-pr-and-review/CONTEXT.md](project-management/workflows/20-pr-and-review/CONTEXT.md)                               |
| 21 — Release                      | [project-management/workflows/21-release/CONTEXT.md](project-management/workflows/21-release/CONTEXT.md)                                           |

---

### Cross-layer workflow pairing — the canonical map

The PM layer **specifies and gates**; the code layer **builds and verifies**. This table is the
single source of truth for how the two sets interlock — neither layer's `CONTEXT.md` restates it.

**Rule: a code workflow is never entered directly from a design gate.** Implementation is reached
only through the PM build phases (`16`–`18`), which are themselves gated on `01`–`15` being
complete.

| PM workflow                       | Paired code workflow                                                         | Relationship                                                                     |
| --------------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `03-database-schema`              | `03-database-migration`                                                      | Schema designed (Fable) → migration written (Opus), **entered via `16`**         |
| `08-gdpr-compliance`              | `06-gdpr-enforcement`                                                        | Obligations specified → enforced in code; review is a hard prerequisite          |
| `09-security-checks`              | `08-security-hardening`                                                      | Design threat model → built-code audit, **entered via `17`** or `21`             |
| `12-api-design`                   | `04-api-design`                                                              | Ninja contract decided → expressed as routers/Schemas, **entered via `17`**      |
| `16-backend-code`                 | `02-tdd-cycle` · `03-database-migration` · `12-rust-extension`               | PM phase drives all three; `12` is **rust-only** and absent without that surface |
| `17-api-code`                     | `04-api-design` · `02-tdd-cycle` · `08-security-hardening` · `05-mcp-server` | PM phase drives all four; `05` only when the story needs an agent-facing surface |
| `18-frontend-code`                | `01-new-feature` · `02-tdd-cycle`                                            | PM phase drives both                                                             |
| `19-implementation-documentation` | _(receives from `01`, `02`)_                                                 | **Owns** all records, findings, docs, and the graph refresh                      |
| `20-pr-and-review`                | `07-review`                                                                  | Content review (code layer) → process, merge, verification (PM layer)            |
| _no PM workflow_                  | `09-debugging-with-logs` · `10-debug`                                        | Entered from `19` findings routed to `src/19-BUGS/`                              |
| _no PM workflow_                  | `11-refactor`                                                                | Entered from `19` findings routed to `src/20-REFACTORING/`                       |

**PM-only, no code counterpart:** `01-story-creation`, `02-sprint-planning`, `04-user-flow-design`,
`05-brand-guides`, `06-component-designs`, `07-wireframes`, `10-qa-checks`, `11-seo-checks`,
`13-decisions`, `14-sprint-plans`, `15-story-plans`, `21-release`.

**Ownership boundaries — do not duplicate across the seam:**

| Fact                                                   | Sole owner                           |
| ------------------------------------------------------ | ------------------------------------ |
| Implementation record formats, templates, destinations | PM `19-implementation-documentation` |
| Findings, `GAPS.md` / `DEFERRED.md` routing            | PM `19-implementation-documentation` |
| `CONTEXT.md`/`CLAUDE.md` closeout + graph refresh      | PM `19-implementation-documentation` |
| Branch promotion, approvals, merge gates               | PM `20-pr-and-review`                |
| Code content review (OWASP, coverage, principles)      | code `07-review`                     |
| Coverage floors (one floor: 75% line+branch, 90% auth) | `code/docs/testing/COVERAGE.md`      |
| Bruno `.bru` API tests                                 | code layer (`code/src/tests/api/`)   |

---

## External — Stack Documentation

| Technology             | Version | Documentation URL                                       |
| ---------------------- | ------- | ------------------------------------------------------- |
| Django                 | 6.x     | https://docs.djangoproject.com/en/6.0/                  |
| Rust (rust-only)       | 1.85+   | https://doc.rust-lang.org/stable/book/                  |
| PyO3 (rust-only)       | 0.23    | https://pyo3.rs/                                        |
| maturin (rust-only)    | 1.x     | https://www.maturin.rs/                                 |
| Django Ninja           | 1.x     | https://django-ninja.dev/                               |
| FastMCP                | 3.x     | https://gofastmcp.com/                                  |
| Model Context Protocol | latest  | https://modelcontextprotocol.io/                        |
| HTMX                   | latest  | https://htmx.org/docs/                                  |
| Alpine.js              | latest  | https://alpinejs.dev/start-here                         |
| PostgreSQL             | 18      | https://www.postgresql.org/docs/18/                     |
| Valkey                 | latest  | https://valkey.io/docs/                                 |
| django-htmx            | latest  | https://django-htmx.readthedocs.io/                     |
| pytest                 | latest  | https://docs.pytest.org/en/stable/                      |
| pytest-django          | latest  | https://pytest-django.readthedocs.io/en/latest/         |
| Playwright (Python)    | latest  | https://playwright.dev/python/docs/intro                |
| pnpm                   | 11.x    | https://pnpm.io/motivation                              |
| uv                     | 0.11.x  | https://docs.astral.sh/uv/                              |
| Docker / Compose       | latest  | https://docs.docker.com/compose/                        |
| Nginx                  | latest  | https://nginx.org/en/docs/                              |
| Gunicorn               | latest  | https://docs.gunicorn.org/en/stable/                    |
| Cloudinary Python SDK  | latest  | https://cloudinary.com/documentation/django_integration |

---

## External — Standards & Compliance

| Standard                  | URL                                                                                                            |
| ------------------------- | -------------------------------------------------------------------------------------------------------------- |
| OWASP Top 10 (2025)       | https://owasp.org/www-project-top-ten/                                                                         |
| UK GDPR — ICO Guide       | https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/                                           |
| PECR — ICO Guide          | https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guide-to-pecr/ |
| WCAG 2.2                  | https://www.w3.org/TR/WCAG22/                                                                                  |
| NIST CSF 2.0              | https://www.nist.gov/cyberframework                                                                            |
| ISO/IEC 27001:2022        | https://www.iso.org/standard/27001                                                                             |
| Semantic Versioning 2.0.0 | https://semver.org/                                                                                            |

---

## External — Tools & Services

| Tool / Service       | URL                                                          |
| -------------------- | ------------------------------------------------------------ |
| GitHub Actions       | https://docs.github.com/en/actions                           |
| Lefthook             | https://evilmartians.github.io/lefthook/                     |
| Ruff (Python linter) | https://docs.astral.sh/ruff/                                 |
| Prettier             | https://prettier.io/docs/en/                                 |
| markdownlint-cli2    | https://github.com/DavidAnson/markdownlint-cli2              |
| Bruno (API testing)  | https://docs.usebruno.com/                                   |
| Sentry               | https://docs.sentry.io/platforms/python/integrations/django/ |
