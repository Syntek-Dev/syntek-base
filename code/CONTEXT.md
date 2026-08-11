# code — Coding Standards, Patterns & Testing

This layer holds everything that is compiled, served, or executed, together with the standards
and procedures that govern it. The three sub-layers are deliberately not interchangeable:
`docs/` decides a rule once, `workflows/` sequences the work that applies it, and `src/` is the
only place a deployable artefact lives. Keeping all four surfaces under one `docs/` tree is what
stops the web, mobile, native and desktop standards drifting into four separate doctrines.

## Directory Tree

```text
code/
├── CONTEXT.md                       ← this file
├── REFERENCES.md                    ← internal and external reference index for the code layer
├── docs/                            ← coding reference guides
│   ├── ACCESSIBILITY.md             (sub-docs: accessibility/)
│   ├── API-DESIGN.md                (sub-docs: api-design/)
│   ├── ARCHITECTURE-PATTERNS.md     (sub-docs: architecture/)
│   ├── BACKEND-CODING-PRINCIPLES.md ← Django/Python/Celery specifics
│   ├── CODE-REVIEW-GRAPH.md         ← code-review-graph MCP playbooks
│   ├── CODING-PRINCIPLES.md         (sub-docs: coding-principles/)
│   ├── CONTEXT.md
│   ├── DATABASE.md                  ← pre-flight data-layer rules (read before any model)
│   ├── DATA-STRUCTURES.md           (sub-docs: data-structures/)
│   ├── DESKTOP.md                   (sub-docs: desktop/) ← DESKTOP-ONLY — the Slint app
│   ├── DESIGN-TOKENS.md             (sub-docs: design-tokens/) ← CSS design token catalogue
│   ├── ENCRYPTION-GUIDE.md          (sub-docs: encryption/)
│   ├── FRONTEND-CODING-PRINCIPLES.md ← Django templates + HTMX + Alpine + CSS
│   ├── LOGGING.md                   (sub-docs: logging/)
│   ├── MANAGEMENT-COMMANDS.md       ← the CLI surface: untrusted arguments, the exit classes
│   ├── MCP-SERVER.md                (sub-docs: mcp-server/) ← FastMCP tools at /mcp/
│   ├── NEGATIVE-SPACE.md            ← invariant classes, one enforcement point, the error taxonomy, the guard clause
│   ├── PERFORMANCE.md               (sub-docs: performance/)
│   ├── RENDERING.md                 (sub-docs: rendering/)
│   ├── RESPONSIVE-DESIGN.md         (sub-docs: responsive/)
│   ├── RLS-GUIDE.md                 (sub-docs: rls/)
│   ├── RUST.md                      (sub-docs: rust/) ← RUST-ONLY — the Cargo workspace
│   ├── SECURITY.md                  (sub-docs: security/)
│   ├── TESTING.md                   (sub-docs: testing/)
│   ├── URL-STRATEGY.md
│   ├── VISUAL-DESIGN.md             ← visual language: the direction + axes, the ban list
│   ├── visual-design/               ← per-surface expression: WEB.md · MOBILE.md · DESKTOP.md
│   └── cloudinary/                  ← vendored Cloudinary SDK reference docs (Python)
├── src/                             ← all deployable source code
│   ├── CONTEXT.md
│   ├── django/                      ← the Django project (backend + server-rendered frontend)
│   │   └── CONTEXT.md
│   ├── mobile/                      ← MOBILE-ONLY — the Expo React Native app
│   │   └── CONTEXT.md
│   ├── rust/                        ← RUST-ONLY — the Cargo workspace (PyO3, binaries, CLI)
│   │   └── CONTEXT.md
│   ├── docker/                      ← Dockerfiles and Compose files
│   │   └── CONTEXT.md
│   ├── logs/                        ← runtime log files (dev/test; all gitignored)
│   │   ├── CONTEXT.md
│   │   ├── .gitignore
│   │   └── .gitkeep
│   ├── improvement-architecture/    ← gitignored HTML architecture-review reports
│   │   └── CONTEXT.md
│   ├── scripts/                     ← shell scripts for all development operations
│   │   ├── CONTEXT.md
│   │   ├── _lib/                    ← internal shell helpers (sourced, never invoked)
│   │   ├── audits/                  ← codebase health audits (cloc, stub detection)
│   │   ├── database/                ← database management (migrate, backup, restore, shell)
│   │   ├── deployment/              ← deployment scripts (planned)
│   │   ├── development/             ← dev stack lifecycle (server, shell, logs, scaffolding)
│   │   ├── mobile/                  ← MOBILE-ONLY — Metro, lint, typecheck, test, bundle
│   │   ├── rust/                    ← RUST-ONLY — build, test, lint, supply-chain audit
│   │   ├── desktop/                 ← DESKTOP-ONLY — run the app, package the release binary
│   │   ├── syntax/                  ← code quality (lint, type-check, format)
│   │   └── tests/                   ← test suite runners (pytest, Bruno)
│   └── tests/                       ← API integration tests (Bruno collection)
│       └── CONTEXT.md
└── workflows/                       ← step-by-step coding workflows, by family below
    ├── CONTEXT.md
    │   ── Build (01–06) ──
    ├── 01-new-feature/              ← full-stack feature development
    ├── 02-tdd-cycle/                ← Red → Green → Refactor
    ├── 03-database-migration/       ← Django model and migration workflow
    ├── 04-api-design/               ← Django Ninja API design (/api/)
    ├── 05-mcp-server/               ← FastMCP tool surface (/mcp/)
    ├── 06-gdpr-enforcement/         ← GDPR code implementation
    │   ── Verify (07–08) ──
    ├── 07-review/                   ← code quality review (principles, coverage)
    ├── 08-security-hardening/       ← OWASP security audit and hardening
    │   ── Diagnose & improve (09–11) ──
    ├── 09-debugging-with-logs/      ← find the cause: logs, Glitchtip, Loki, Grafana
    ├── 10-debug/                    ← fix it: isolate, regression test, patch
    ├── 11-refactor/                 ← improve it: no behaviour change
    │   ── Build, opt-in (12–13) ──
    ├── 12-rust-extension/           ← RUST-ONLY — PyO3 extensions in the Cargo workspace
    └── 13-desktop-app/              ← DESKTOP-ONLY — the native Slint application

Each workflow folder holds CONTEXT.md · STEPS.md · CHECKLIST.md · CLAUDE.md.
```

## When to read this

- Writing any code in `code/src/django/`
- Designing a new page, feature, or Django app
- Writing or debugging tests (TDD)
- Implementing security or permissions logic
- Designing a Django Ninja API endpoint
- Reviewing a PR for code quality

## Contents

- `docs/` — Reference guides for all coding disciplines
- `workflows/` — Step-by-step guides for common coding tasks

## Do not use for

- Sprint planning, story creation, PR lifecycle → `project-management/CONTEXT.md`
- Environment setup, daily dev commands → `how-to/CONTEXT.md`

## Key docs

| Guide                           | When to read                                                                                                                   |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `docs/CODING-PRINCIPLES.md`     | Before writing any code                                                                                                        |
| `docs/TESTING.md`               | Before writing tests                                                                                                           |
| `docs/SECURITY.md`              | Before writing auth, permissions, or any endpoint                                                                              |
| `docs/API-DESIGN.md`            | Before adding Django Ninja endpoints or Schema models                                                                          |
| `docs/MCP-SERVER.md`            | Before exposing anything to an LLM agent (the FastMCP `/mcp/` surface)                                                         |
| `docs/NEGATIVE-SPACE.md`        | Before adding a constraint or a guard — where an invariant is enforced, and how it fails. **`assert` is banned outside tests** |
| `docs/TASK-AUTHORING.md`        | Before moving any work off the request cycle into a background task                                                            |
| `docs/MANAGEMENT-COMMANDS.md`   | Before writing any `manage.py` command — arguments are untrusted, and the exit code is the taxonomy                            |
| `docs/PROCESS-MODEL.md`         | Before choosing sync vs async, or adding any process beyond the web one                                                        |
| `docs/OBJECT-STORAGE.md`        | Before storing a private document or issuing a presigned URL                                                                   |
| `docs/ACCESSIBILITY.md`         | Before building any frontend component                                                                                         |
| `docs/RESPONSIVE-DESIGN.md`     | Before building any frontend component or layout                                                                               |
| `docs/ARCHITECTURE-PATTERNS.md` | Before designing a new Django app or page route                                                                                |
| `docs/DATABASE.md`              | **Before any model, migration, or query** — the pre-flight rules                                                               |
| `docs/DATA-STRUCTURES.md`       | Before adding a model or schema change                                                                                         |
| `docs/LOGGING.md`               | Before adding logging, error tracking, or metrics                                                                              |
| `docs/RENDERING.md`             | Before choosing server vs HTMX vs Alpine for an interaction                                                                    |
| `docs/PERFORMANCE.md`           | Before optimising a query or page                                                                                              |
| `docs/ENCRYPTION-GUIDE.md`      | Before adding any PII field or storage                                                                                         |
| `docs/RLS-GUIDE.md`             | Before adding multi-tenant or row-scoped queries                                                                               |
| `docs/RUST.md`                  | **Rust-only.** Before any native code — starting with whether it should be Rust at all                                         |
| `docs/DESKTOP.md`               | **Desktop-only.** Before any desktop work — the licence obligation comes first                                                 |
| `docs/URL-STRATEGY.md`          | Before adding routes, redirects, or slug patterns                                                                              |
| `docs/DOCUMENTATION-PAIRING.md` | Before writing or restructuring any `CONTEXT.md` / `CLAUDE.md` pair                                                            |

## Surfaces — where source may live

`code/` owns **all deployable source**, and `code/src/` is the only place it lives. A project has
the web surface always, and each of the other two only if it opted in:

| Surface     | Path                       | Standards                                                     |
| ----------- | -------------------------- | ------------------------------------------------------------- |
| **Web**     | `src/django/`              | The `docs/` guides below — the default reading of every rule  |
| **Mobile**  | `src/mobile/`              | The same `docs/` tree, plus the React Native technique guides |
| **Native**  | `src/rust/`                | The same `docs/` tree, plus `docs/RUST.md` and its sub-docs   |
| **Desktop** | `src/rust/crates/desktop/` | The same `docs/` tree, plus `docs/DESKTOP.md`                 |

The mobile app and the Rust workspace are placed **inside `code/src/`, beside the Django
project**, rather than as further root layers. That keeps this layer's definition intact — the
other three root layers (`how-to/`, `project-management/`, `.claude/`) hold documentation and
process, never source — and, more importantly, keeps **one `docs/` tree for every surface** so
their standards cannot drift into separate doctrines. A parallel `mobile/docs/` was rejected for
exactly that reason, and `rust/docs/` for the same one. Definitions and the full rationale:
`code/src/CONTEXT.md` → _Surfaces_.

## Cross-references

- `code/CLAUDE.md` — the operating rules for this layer: file length, coverage floors, the
  non-negotiables, and what never to read
- `code/docs/CODING-PRINCIPLES.md` · `code/docs/TESTING.md` — where those limits are decided
- `project-management/CONTEXT.md` — the layer that specifies and gates what is built here
