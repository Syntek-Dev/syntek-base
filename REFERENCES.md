# References — <%PROJECT_SLUG%>

A curated index of internal documentation and external resources Claude should
consult when working in this repository.

**In what order to consult them — the internal `**/docs/` first, `context7` second, web search
last — is `.claude/CLAUDE.md` Section 3.2, _How to look something up_.** This index is what that
rule navigates; it does not restate it.

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

| Document                                                                                                     | Purpose                                                                                                                                                                                           |
| ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [code/docs/ACCESSIBILITY.md](code/docs/ACCESSIBILITY.md)                                                     | WCAG 2.2 AA compliance rules for all interactive components                                                                                                                                       |
| [code/docs/API-DESIGN.md](code/docs/API-DESIGN.md)                                                           | Django Ninja API design conventions and patterns                                                                                                                                                  |
| [code/docs/ARCHITECTURE-PATTERNS.md](code/docs/ARCHITECTURE-PATTERNS.md)                                     | Layered architecture decisions and module boundaries                                                                                                                                              |
| [code/docs/architecture/CORE-AND-SCALING.md](code/docs/architecture/CORE-AND-SCALING.md)                     | Core/deep module split + Postgres scaling phase-gates — the gates scale-planning sizes under (sizing + readiness in `how-to/src/SCALE-ARCHITECTURE/`)                                             |
| [code/docs/architecture/PROVIDER-NEUTRALITY.md](code/docs/architecture/PROVIDER-NEUTRALITY.md)               | Protocol seam vs adapter seam vs substrate — the evidence a neutrality claim needs (register: `how-to/src/PLATFORM-PROVIDERS.md`)                                                                 |
| [code/docs/architecture/BUILD-OPERATE-SEAM.md](code/docs/architecture/BUILD-OPERATE-SEAM.md)                 | Build / operate / deploy ownership — the two bridge shapes and the same-change rule (audit: `audits/seam-contract.sh`)                                                                            |
| [code/docs/CODE-REVIEW-GRAPH.md](code/docs/CODE-REVIEW-GRAPH.md)                                             | code-review-graph MCP playbooks: explore, debug, review, refactor                                                                                                                                 |
| [code/docs/CODING-PRINCIPLES.md](code/docs/CODING-PRINCIPLES.md)                                             | Style rules, function length limits, error handling                                                                                                                                               |
| [code/docs/BACKEND-CODING-PRINCIPLES.md](code/docs/BACKEND-CODING-PRINCIPLES.md)                             | Django/Python/Celery specifics — read alongside `CODING-PRINCIPLES.md`                                                                                                                            |
| [code/docs/FRONTEND-CODING-PRINCIPLES.md](code/docs/FRONTEND-CODING-PRINCIPLES.md)                           | Django templates + django-components + HTMX + Alpine + CSS specifics — read alongside `CODING-PRINCIPLES.md`                                                                                      |
| [code/docs/DATABASE.md](code/docs/DATABASE.md)                                                               | Pre-flight data-layer rules — scope columns, database-level constraints, lock-safe migrations, search, deferred infrastructure                                                                    |
| [code/docs/DATA-STRUCTURES.md](code/docs/DATA-STRUCTURES.md)                                                 | Shared data models and type conventions                                                                                                                                                           |
| [code/docs/data-structures/TYPES-OVER-DICTIONARIES.md](code/docs/data-structures/TYPES-OVER-DICTIONARIES.md) | **Domain objects over dictionaries** — the mandatory cross-surface standard: parse at the boundary, the enum test, the migration backlog, the PR checklist (gate: `audits/dict-discipline.sh`)    |
| [code/docs/data-structures/TYPES-EXCEPTIONS.md](code/docs/data-structures/TYPES-EXCEPTIONS.md)               | The seven cases where a dictionary is right, the confinement policy, and the `DICT-OK:` escape hatch                                                                                              |
| [code/docs/DESIGN-TOKENS.md](code/docs/DESIGN-TOKENS.md)                                                     | CSS design-token catalogue and the `var(--token)`-only usage rule                                                                                                                                 |
| [code/docs/DISCOVERABILITY.md](code/docs/DISCOVERABILITY.md)                                                 | Being found — the `build_seo()` head pipeline, JSON-LD structured data, the root/`.well-known` surface register, and the body's shape (method side of `project-management/docs/SEO-CHECKLIST.md`) |
| [code/docs/DOCUMENTATION-LENGTH.md](code/docs/DOCUMENTATION-LENGTH.md)                                       | Instructional file length — the 300-line limit, what is bound and exempt, the 270 ratchet and its dated allowance (gate: `audits/docs-length.sh`)                                                 |
| [code/docs/DOCUMENTATION-PAIRING.md](code/docs/DOCUMENTATION-PAIRING.md)                                     | The `CONTEXT.md` / `CLAUDE.md` split — the decision test, the headings banned from an orientation file, route-don't-restate (audit: `audits/docs-pairing.sh`)                                     |
| [code/docs/ENCRYPTION-GUIDE.md](code/docs/ENCRYPTION-GUIDE.md)                                               | Fernet PII encryption pipeline                                                                                                                                                                    |
| [code/docs/NOTIFICATIONS.md](code/docs/NOTIFICATIONS.md)                                                     | Notifications — the send boundary, the shared branded template foundation, PII per channel (declared, not wired)                                                                                  |
| [code/docs/EXPORTS.md](code/docs/EXPORTS.md)                                                                 | Downloadable file exports — the library per format, the formatter contract, PII gating and audit (declared, not wired)                                                                            |
| [code/docs/LOGGING.md](code/docs/LOGGING.md)                                                                 | Structured logging with Sentry and file-based logs                                                                                                                                                |
| [code/docs/TASK-AUTHORING.md](code/docs/TASK-AUTHORING.md)                                                   | Background-task authoring: the enqueue boundary, idempotency, retries, limits, queue routing, broker-free testing (declared, not wired)                                                           |
| [code/docs/MANAGEMENT-COMMANDS.md](code/docs/MANAGEMENT-COMMANDS.md)                                         | The CLI surface: arguments as untrusted input, blast radius, and the error taxonomy as exit codes (`ManagementCommand` + the ruff `TID251` ban)                                                   |
| [code/docs/PROCESS-MODEL.md](code/docs/PROCESS-MODEL.md)                                                     | Worker class, event loop, the ORM's sync boundary, and where a task worker sits                                                                                                                   |
| [code/docs/OBJECT-STORAGE.md](code/docs/OBJECT-STORAGE.md)                                                   | Private-document storage over the S3 API: adapter contract, presigned URLs, upload validation (declared, not wired)                                                                               |
| [code/docs/security/AUDIT-TRAIL.md](code/docs/security/AUDIT-TRAIL.md)                                       | The audit record's owning guide: schema, write path, contents, PII, retention, tamper-resistance (OWASP A09)                                                                                      |
| [code/docs/MCP-SERVER.md](code/docs/MCP-SERVER.md)                                                           | The FastMCP tool surface at `/mcp/` — mounting, tool design, auth and threats, testing and ops (available but unwired)                                                                            |
| [code/docs/MOBILE-CODING-PRINCIPLES.md](code/docs/MOBILE-CODING-PRINCIPLES.md)                               | **Mobile-only.** TypeScript flags beyond `strict`, exhaustiveness, and how the mobile surface expresses the error taxonomy                                                                        |
| [code/docs/NEGATIVE-SPACE.md](code/docs/NEGATIVE-SPACE.md)                                                   | What the code must never allow — invariant classes, one named enforcement point each, the error taxonomy, the guard clause (`raise` never `assert`) (register: `how-to/src/INVARIANTS.md`)        |
| [code/docs/PERFORMANCE.md](code/docs/PERFORMANCE.md)                                                         | Caching, query optimisation, and response-time targets                                                                                                                                            |
| [code/docs/RENDERING.md](code/docs/RENDERING.md)                                                             | Rendering strategies — where each interaction runs: server template, HTMX, or Alpine                                                                                                              |
| [code/docs/RESPONSIVE-DESIGN.md](code/docs/RESPONSIVE-DESIGN.md)                                             | Breakpoints, fluid layouts, mobile-first rules                                                                                                                                                    |
| [code/docs/RLS-GUIDE.md](code/docs/RLS-GUIDE.md)                                                             | PostgreSQL row-level security policy conventions                                                                                                                                                  |
| [code/docs/DESKTOP.md](code/docs/DESKTOP.md)                                                                 | **Desktop-only.** The native Slint app: the Royalty-free licence obligation, the generated-code lint boundary, threading, AccessKit accessibility                                                 |
| [code/docs/RUST.md](code/docs/RUST.md)                                                                       | **Rust-only.** The Cargo workspace: the gate question, the PyO3 boundary, secret memory hygiene, and the cargo-deny supply-chain policy                                                           |
| [code/docs/SECURITY.md](code/docs/SECURITY.md)                                                               | OWASP controls, permission checks, IDOR prevention                                                                                                                                                |
| [code/docs/TESTING.md](code/docs/TESTING.md)                                                                 | Coverage floors, test structure, mocking strategy                                                                                                                                                 |
| [code/docs/URL-STRATEGY.md](code/docs/URL-STRATEGY.md)                                                       | URL naming, slug patterns, API endpoint conventions                                                                                                                                               |
| [code/docs/VISUAL-DESIGN.md](code/docs/VISUAL-DESIGN.md)                                                     | Visual language — the per-project direction and its six axes, the universal tells, the motion standard (per-surface: `code/docs/visual-design/`)                                                  |

### How-to guides (`how-to/docs/`)

| Document                                                               | Purpose                                                                                                                               |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| [how-to/src/BRAND-VOICE.md](how-to/src/BRAND-VOICE.md)                 | Brand voice — tone, the four registers, banned machine-authored tells (settled at first-time setup)                                   |
| [how-to/src/INVARIANTS.md](how-to/src/INVARIANTS.md)                   | This project's invariant register — one named enforcement point each (rule: `code/docs/NEGATIVE-SPACE.md`)                            |
| [how-to/src/STORE-LISTING.md](how-to/src/STORE-LISTING.md)             | **Mobile-only.** This project's App Store / Play listing values against their limits (rule: `code/docs/discoverability/APP-STORE.md`) |
| [how-to/docs/CELERY-FIRST-RUN.md](how-to/docs/CELERY-FIRST-RUN.md)     | Getting the Celery worker and beat running the first time                                                                             |
| [how-to/docs/CLI-TOOLING.md](how-to/docs/CLI-TOOLING.md)               | CLI tools reference: scripts, commands, shortcuts                                                                                     |
| [how-to/docs/DEVELOPMENT.md](how-to/docs/DEVELOPMENT.md)               | Day-to-day development setup and workflow                                                                                             |
| [how-to/docs/FEATURE-DEPLOY.md](how-to/docs/FEATURE-DEPLOY.md)         | Deploying a feature branch                                                                                                            |
| [how-to/docs/INCIDENT-PRACTICE.md](how-to/docs/INCIDENT-PRACTICE.md)   | Running a live incident — declare, shift handover, stand down, blameless postmortem                                                   |
| [how-to/docs/OPERATOR-DOC-CRAFT.md](how-to/docs/OPERATOR-DOC-CRAFT.md) | The conventions behind a guide a human executes — the reader, the two homes and their length standards, the spine, execute-to-verify  |
| [how-to/docs/GIT-WORKTREES.md](how-to/docs/GIT-WORKTREES.md)           | Git worktree creation and management                                                                                                  |
| [how-to/docs/TOOLING-GUIDE.md](how-to/docs/TOOLING-GUIDE.md)           | Internal skills reference (index)                                                                                                     |
| [how-to/docs/AI-DICTIONARY.md](how-to/docs/AI-DICTIONARY.md)           | Plain-English glossary of AI-coding terms (index)                                                                                     |
| [how-to/docs/SKILL-AUTHORING.md](how-to/docs/SKILL-AUTHORING.md)       | How to write predictable Claude Code skills (index over `how-to/docs/skill-authoring/`)                                               |

### Project-management guides (`project-management/docs/`)

| Document                                                                                     | Purpose                                        |
| -------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| [project-management/docs/GDPR-GUIDE.md](project-management/docs/GDPR-GUIDE.md)               | UK GDPR compliance workflow for new features   |
| [project-management/docs/GIT-GUIDE.md](project-management/docs/GIT-GUIDE.md)                 | Branch naming, commit conventions, PR process  |
| [project-management/docs/QA-GUIDE.md](project-management/docs/QA-GUIDE.md)                   | Manual and automated QA checklists             |
| [project-management/docs/RESPONSIVE-DESIGN.md](project-management/docs/RESPONSIVE-DESIGN.md) | PM-level responsive design requirements        |
| [project-management/docs/SECURITY-GUIDE.md](project-management/docs/SECURITY-GUIDE.md)       | Security audit process and sign-off criteria   |
| [project-management/docs/SEO-CHECKLIST.md](project-management/docs/SEO-CHECKLIST.md)         | Per-page SEO checklist for Django routes       |
| [project-management/docs/PLANNING-GUIDE.md](project-management/docs/PLANNING-GUIDE.md)       | Sprint sizing, velocity, and capacity rules    |
| [project-management/docs/VERSIONING-GUIDE.md](project-management/docs/VERSIONING-GUIDE.md)   | Semantic versioning rules and changelog format |

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
| 13 — Desktop app         | [code/workflows/13-desktop-app/CONTEXT.md](code/workflows/13-desktop-app/CONTEXT.md)                 |

> Grouped in four families: **build** (01–06), **verify** (07–08), **diagnose & improve**
> (09–11), and **build, opt-in** (12 rust-only, 13 desktop-only — each absent unless the project
> opted into that surface). The numbers are stable identifiers, not a sequence — append, never
> renumber.

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
| 01 — Feature                      | [project-management/workflows/01-feature/CONTEXT.md](project-management/workflows/01-feature/CONTEXT.md)                                           |
| 02 — Story creation               | [project-management/workflows/02-story-creation/CONTEXT.md](project-management/workflows/02-story-creation/CONTEXT.md)                             |
| 03 — Sprint planning              | [project-management/workflows/03-sprint-planning/CONTEXT.md](project-management/workflows/03-sprint-planning/CONTEXT.md)                           |
| 04 — Database schema              | [project-management/workflows/04-database-schema/CONTEXT.md](project-management/workflows/04-database-schema/CONTEXT.md)                           |
| 05 — User flow design             | [project-management/workflows/05-user-flow-design/CONTEXT.md](project-management/workflows/05-user-flow-design/CONTEXT.md)                         |
| 06 — Brand guides                 | [project-management/workflows/06-brand-guides/CONTEXT.md](project-management/workflows/06-brand-guides/CONTEXT.md)                                 |
| 07 — Component designs            | [project-management/workflows/07-component-designs/CONTEXT.md](project-management/workflows/07-component-designs/CONTEXT.md)                       |
| 08 — Wireframes                   | [project-management/workflows/08-wireframes/CONTEXT.md](project-management/workflows/08-wireframes/CONTEXT.md)                                     |
| 09 — GDPR compliance              | [project-management/workflows/09-gdpr-compliance/CONTEXT.md](project-management/workflows/09-gdpr-compliance/CONTEXT.md)                           |
| 10 — Security checks              | [project-management/workflows/10-security-checks/CONTEXT.md](project-management/workflows/10-security-checks/CONTEXT.md)                           |
| 11 — QA checks                    | [project-management/workflows/11-qa-checks/CONTEXT.md](project-management/workflows/11-qa-checks/CONTEXT.md)                                       |
| 12 — SEO checks                   | [project-management/workflows/12-seo-checks/CONTEXT.md](project-management/workflows/12-seo-checks/CONTEXT.md)                                     |
| 13 — API design                   | [project-management/workflows/13-api-design/CONTEXT.md](project-management/workflows/13-api-design/CONTEXT.md)                                     |
| 14 — Decisions                    | [project-management/workflows/14-decisions/CONTEXT.md](project-management/workflows/14-decisions/CONTEXT.md)                                       |
| 15 — Sprint plans                 | [project-management/workflows/15-sprint-plans/CONTEXT.md](project-management/workflows/15-sprint-plans/CONTEXT.md)                                 |
| 16 — Story plans                  | [project-management/workflows/16-story-plans/CONTEXT.md](project-management/workflows/16-story-plans/CONTEXT.md)                                   |
| 17 — Consolidate design work      | [project-management/workflows/17-consolidate-design-work/CONTEXT.md](project-management/workflows/17-consolidate-design-work/CONTEXT.md)           |
| 18 — Backend code                 | [project-management/workflows/18-backend-code/CONTEXT.md](project-management/workflows/18-backend-code/CONTEXT.md)                                 |
| 19 — API code                     | [project-management/workflows/19-api-code/CONTEXT.md](project-management/workflows/19-api-code/CONTEXT.md)                                         |
| 20 — Frontend code                | [project-management/workflows/20-frontend-code/CONTEXT.md](project-management/workflows/20-frontend-code/CONTEXT.md)                               |
| 21 — Implementation documentation | [project-management/workflows/21-implementation-documentation/CONTEXT.md](project-management/workflows/21-implementation-documentation/CONTEXT.md) |
| 22 — PR and review                | [project-management/workflows/22-pr-and-review/CONTEXT.md](project-management/workflows/22-pr-and-review/CONTEXT.md)                               |
| 23 — Release                      | [project-management/workflows/23-release/CONTEXT.md](project-management/workflows/23-release/CONTEXT.md)                                           |

---

### Cross-layer workflow pairing — the canonical map

The PM layer **specifies and gates**; the code layer **builds and verifies**. This table is the
single source of truth for how the two sets interlock — neither layer's `CONTEXT.md` restates it.

**Rule: a code workflow is never entered directly from a design gate.** Implementation is reached
only through the PM build phases (`18`–`20`), which are themselves gated on `02`–`17` being
complete.

| PM workflow                       | Paired code workflow                                                         | Relationship                                                                     |
| --------------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `04-database-schema`              | `03-database-migration`                                                      | Schema designed (Fable) → migration written (Opus), **entered via `18`**         |
| `09-gdpr-compliance`              | `06-gdpr-enforcement`                                                        | Obligations specified → enforced in code; review is a hard prerequisite          |
| `10-security-checks`              | `08-security-hardening`                                                      | Design threat model → built-code audit, **entered via `19`** or `23`             |
| `13-api-design`                   | `04-api-design`                                                              | Ninja contract decided → expressed as routers/Schemas, **entered via `19`**      |
| `18-backend-code`                 | `02-tdd-cycle` · `03-database-migration` · `12-rust-extension`               | PM phase drives all three; `12` is **rust-only** and absent without that surface |
| `19-api-code`                     | `04-api-design` · `02-tdd-cycle` · `08-security-hardening` · `05-mcp-server` | PM phase drives all four; `05` only when the story needs an agent-facing surface |
| `20-frontend-code`                | `01-new-feature` · `02-tdd-cycle` · `13-desktop-app`                         | PM phase drives all three; `13` is **desktop-only** and absent without it        |
| `21-implementation-documentation` | _(receives from `01`, `02`)_                                                 | **Owns** all records, findings, docs, and the graph refresh                      |
| `22-pr-and-review`                | `07-review`                                                                  | Content review (code layer) → process, merge, verification (PM layer)            |
| _no PM workflow_                  | `09-debugging-with-logs` · `10-debug`                                        | Entered from `21` findings routed to `src/20-BUGS/`                              |
| _no PM workflow_                  | `11-refactor`                                                                | Entered from `21` findings routed to `src/21-REFACTORING/`                       |

**PM-only, no code counterpart:** `02-story-creation`, `03-sprint-planning`, `05-user-flow-design`,
`06-brand-guides`, `07-component-designs`, `08-wireframes`, `11-qa-checks`, `12-seo-checks`,
`14-decisions`, `15-sprint-plans`, `16-story-plans`, `23-release`.

**Ownership boundaries — do not duplicate across the seam:**

| Fact                                                   | Sole owner                             |
| ------------------------------------------------------ | -------------------------------------- |
| Implementation record formats, templates, destinations | PM `21-implementation-documentation`   |
| Findings, `GAPS.md` / `DEFERRED.md` writes and closes  | PM `21-implementation-documentation`   |
| `GAPS.md` / `DEFERRED.md` reads — suggest and triage   | PM `01-feature` (claims, never closes) |
| `CONTEXT.md`/`CLAUDE.md` closeout + graph refresh      | PM `21-implementation-documentation`   |
| Branch promotion, approvals, merge gates               | PM `22-pr-and-review`                  |
| Code content review (OWASP, coverage, principles)      | code `07-review`                       |
| Coverage floors (one floor: 75% line+branch, 90% auth) | `code/docs/testing/COVERAGE.md`        |
| Bruno `.bru` API tests                                 | code layer (`code/src/tests/api/`)     |

---

## External — Stack Documentation

| Technology             | Version | Documentation URL                                       |
| ---------------------- | ------- | ------------------------------------------------------- |
| Django                 | 6.x     | https://docs.djangoproject.com/en/6.0/                  |
| Rust (rust-only)       | 1.85+   | https://doc.rust-lang.org/stable/book/                  |
| PyO3 (rust-only)       | 0.29    | https://pyo3.rs/                                        |
| maturin (rust-only)    | 1.x     | https://www.maturin.rs/                                 |
| Slint (desktop-only)   | 1.17    | https://slint.dev/docs                                  |
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
| uv                     | 0.12.x  | https://docs.astral.sh/uv/                              |
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

| Tool / Service             | URL                                                          |
| -------------------------- | ------------------------------------------------------------ |
| GitHub Actions             | https://docs.github.com/en/actions                           |
| Lefthook                   | https://evilmartians.github.io/lefthook/                     |
| Ruff (Python linter)       | https://docs.astral.sh/ruff/                                 |
| Prettier                   | https://prettier.io/docs/en/                                 |
| markdownlint-cli2          | https://github.com/DavidAnson/markdownlint-cli2              |
| Opengrep (static analysis) | https://github.com/opengrep/opengrep                         |
| Bruno (API testing)        | https://docs.usebruno.com/                                   |
| Sentry                     | https://docs.sentry.io/platforms/python/integrations/django/ |
