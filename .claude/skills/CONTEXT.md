# .claude/skills

Skills for Claude Code — auto-selected reference bundles the agents load on demand. Each skill
is a folder with a `SKILL.md` plus optional sub-documents, in the published
[Agent Skills format](https://agentskills.io/specification). Which of that format's fields this
project authors, which runtime keys it admits beyond them, what it declines and why, and the
vendored exception are all in `how-to/docs/SKILL-AUTHORING.md`. Internalised from the
`<%ORG_SLUG%>-dev-suite` and `<%ORG_SLUG%>-doc-writer` plugins so the project carries its own
tooling; plugin references were rewritten to internal paths.

## Directory tree

```text
.claude/skills/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── feature/                ← build a new capability end to end: plan → red → build → review → ship
├── bugfix/                 ← reproduce, root-cause, regression-test, fix minimally (scoped: `## Root cause`)
├── refactor/               ← restructure working code with behaviour held identical
├── review/                 ← sequence the content review, the hostile QA pass, the conditional security pass
├── security/               ← audit and harden: OWASP, NIST, Cyber Essentials, IDOR, PII enforcement
├── pr/                     ← raise the pull request and take it through the branch chain
├── release/                ← version bump, full suite, version commit, handover
├── story/                  ← write or refine one testable US### user story
├── sprint/                 ← slice written stories into balanced, dependency-ordered sprints
├── planner/                ← architect a feature into a phased, independently-testable plan
├── syntax/                 ← make it parse, lint, format and type-check — behaviour-preserving only
├── completion/             ← record a verified story or sprint as complete in the PM artefacts
├── backend/                ← build the server side: models, migration, services, /api/ and /mcp/
├── frontend/               ← build the web pages: templates, components, HTMX, Alpine, token CSS
├── database/               ← the data layer: models, lock-safe migration, RLS policies, PII columns
├── authentication/         ← the credential and session layer: passwords, MFA, lockout, reset
├── notifications/          ← the delivery layer: email, SMS, push, in-app, on one branded foundation
├── reporting/              ← role-scoped report queries and aggregates, PII kept out of the summary
├── logging/                ← structured logging and observability; nothing sensitive reaches a channel
├── seo/                    ← the head, JSON-LD, canonical URLs, robots/sitemap/llms.txt views
├── test-writer/            ← the TDD Red phase: failing tests plus the skeleton that runs them
├── qa-tester/              ← the hostile pass: find it, prove it, rank it — never fix, never approve
├── code-reviewer/          ← read-only review on two axes, Standards and Spec, never merged
├── stack-django/           ← Django 6 + Django Ninja + PostgreSQL backend idioms (also server-rendered templates)
│   └── SKILL.md
├── stack-htmx-templates/   ← Django templates + django-components + HTMX + Alpine + token CSS
│   └── SKILL.md
├── stack-react-native/     ← MOBILE-ONLY — Expo + React Native + TypeScript + expo-router
│   └── SKILL.md
├── stack-fastmcp/          ← the FastMCP tool surface at /mcp/ (available but unwired)
│   └── SKILL.md
├── stack-rust/             ← RUST-ONLY — the Cargo workspace, PyO3 boundary, supply-chain gate
│   └── SKILL.md
├── stack-slint/            ← DESKTOP-ONLY — the native Slint app and its licence obligation
│   └── SKILL.md
├── global-workflow/        ← cross-cutting standards (split index + sub-docs)
│   ├── SKILL.md
│   ├── GIT-AND-PR.md
│   └── VERSIONING-AND-DOCS.md
├── runbook/                ← write an operator guide: the brief, execute-to-verify, indexing (task, forked)
│   └── SKILL.md
├── legal-documents/        ← shared drafting standard for legal/GDPR doc agents
│   └── SKILL.md
├── msp-scp-documents/      ← shared standard for security/compliance policy agents
│   ├── SKILL.md
│   ├── SECURITY-POLICIES.md
│   ├── DATA-GOVERNANCE.md
│   ├── INCIDENT-CONTINUITY.md
│   ├── VENDOR-AND-SLA.md
│   ├── USE-AND-CHANGE.md
│   └── STANDARDS.md
├── grilling/               ← the grilling engine — frontier-round design interview
│   └── SKILL.md
├── grill-me/               ← `/grill-me` — stateless grilling (interview only, saves nothing)
│   └── SKILL.md
├── grill-with-docs/        ← `/grill-with-docs` — grilling that records decisions to the repo
│   └── SKILL.md
├── teach/                  ← `/teach` — safe learning sandbox (writes only to learning/)
│   └── SKILL.md
├── wayfinder/              ← `/wayfinder` — chart a big epic into a decision map, resolve over sessions
│   └── SKILL.md
├── handoff/                ← `/handoff` — compact the conversation into a temp doc for a fresh agent
│   └── SKILL.md
├── prototype/              ← `/prototype` — throwaway spike answering one design question
│   └── SKILL.md
├── research/               ← `/research` — primary-source-cited note that feeds a decision
│   └── SKILL.md
├── to-questionnaire/       ← `/to-questionnaire` — ask an outside party what only they know
│   └── SKILL.md
├── wait-what/              ← `/wait-what` — that reply did not land; re-pitch it
│   └── SKILL.md
├── resolving-merge-conflicts/ ← resolve an in-flight merge/rebase; knows the never-hand-merge classes
│   └── SKILL.md
├── wizard/                 ← author an interactive bash wizard for human-only steps
│   └── SKILL.md
├── incident/               ← `/incident` — run a live incident: notes, clock, handover, postmortem
│   └── SKILL.md
├── codebase-design/        ← the deep-module vocabulary (module/interface/seam/depth/leverage; deletion test; design it twice)
│   └── SKILL.md
├── domain-modelling/       ← keep the domain model current — add a term to the nearest CONTEXT.md / an ADR
│   └── SKILL.md
├── improve-codebase-architecture/ ← `/improve-codebase-architecture` — scan for deepening opportunities → HTML report → grill
│   ├── SKILL.md
│   └── HTML-REPORT.md
├── scale-planning/         ← `/scale-planning` — size the deployment for a target user count + prove scalability; feeds the NixOS deploy repo
│   └── SKILL.md
├── debug-issue.md          → code-review-graph card: debug playbook (auto-generated; do not hand-edit)
├── explore-codebase.md     → code-review-graph card: explore playbook (auto-generated; do not hand-edit)
├── refactor-safely.md      → code-review-graph card: refactor playbook (auto-generated; do not hand-edit)
├── review-changes.md       → code-review-graph card: review playbook (auto-generated; do not hand-edit)
├── cloudinary-docs         → symlink (Cloudinary SDK docs skill)
├── cloudinary-react        → symlink (Cloudinary React SDK skill)
└── cloudinary-transformations → symlink (Cloudinary transformation URLs skill)
```

## Which skill, when

| Skill                           | Load when                                                                                                                                             |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `feature`                       | A new capability has to be built end to end — plan, red tests, backend, API, frontend, review, QA, docs, commit                                       |
| `bugfix`                        | Something is broken. Diagnosis alone enters its `## Root cause` phase; the full sequence fixes, QAs, documents and commits                            |
| `refactor`                      | The code is correct but its shape is wrong — split, extract, deepen, rename, with behaviour held identical                                            |
| `review`                        | A change needs checking before it is proposed — sequences `code-reviewer`, `qa-tester`, and `security` where it applies                               |
| `security`                      | A security audit, a threat model, or hardening after a finding — OWASP, NIST, Cyber Essentials, IDOR, PII enforcement                                 |
| `pr`                            | A finished story branch is ready to propose, or an open PR needs promoting through the chain                                                          |
| `release`                       | A tested branch is ready to ship — the bump, the suite, the version commit, the handover                                                              |
| `story`                         | A requirement has to become one testable `US###` — role, MoSCoW, Gherkin criteria, tasks, estimate                                                    |
| `sprint`                        | Written stories have to be sliced into the next sprint — capacity, MoSCoW mix, dependency order                                                       |
| `planner`                       | A design has to be settled before code — scope, system impact, phases, interfaces, risks                                                              |
| `syntax`                        | The tree is mechanically broken or a syntax gate is red — lint, format, types, strictly behaviour-preserving                                          |
| `completion`                    | Verified work needs recording — a story or sprint status transition in the PM artefacts                                                               |
| `backend`                       | The server half of a story — models, migration, service layer, Django Ninja endpoints, MCP tools                                                      |
| `frontend`                      | The web half of a story — templates, django-components, HTMX, Alpine, token CSS, WCAG                                                                 |
| `database`                      | The data layer itself — an approved schema as models and a lock-safe migration, RLS policies, PII columns                                             |
| `authentication`                | Login, registration, MFA, sessions, lockout or password reset — the credential layer itself                                                           |
| `notifications`                 | Something has to be sent — email, SMS, push or in-app — or the shared branded template layer needs building                                           |
| `reporting`                     | A report or dashboard needs its data — role-scoped aggregates, a result shape, an index recommendation                                                |
| `logging`                       | Log instrumentation to add, a channel to configure, or sensitive data to stop reaching one                                                            |
| `seo`                           | A public page needs its head, structured data and crawler wiring — or the marketing pages need a pass                                                 |
| `test-writer`                   | The failing tests must exist before implementation — one story's scope, its seams, red first                                                          |
| `qa-tester`                     | A change needs an independent breaker pass before it ships — proven findings, ranked                                                                  |
| `code-reviewer`                 | A diff, file, branch or module needs assessing rather than fixing — Standards and Spec, separately                                                    |
| `stack-django`                  | Writing/reviewing backend code (models, services, Django Ninja endpoints, tests) — and server-rendered templates                                      |
| `stack-htmx-templates`          | Building/reviewing public frontend — Django templates, django-components, HTMX, Alpine, token CSS, page cache                                         |
| `stack-react-native`            | **Mobile-only.** Building/reviewing the mobile surface — Expo, TypeScript, expo-router, StyleSheet over generated tokens                              |
| `stack-fastmcp`                 | Writing/reviewing MCP tools (`apps/**/mcp_tools.py`, `config/mcp.py`) — exposing domain operations to an LLM agent at `/mcp/`                         |
| `stack-rust`                    | **Rust-only.** Writing/reviewing `code/src/rust/` — PyO3 boundary, secret zeroizing, cargo-deny. Also: deciding if work belongs in Rust at all        |
| `stack-slint`                   | **Desktop-only.** Building/reviewing the native Slint app — the AboutSlint licence disclosure, the generated-code lint boundary, threading, a11y      |
| `global-workflow`               | Branching, commits, PRs, version bumps, documentation, code comments                                                                                  |
| `runbook`                       | Authoring a guide or runbook a human executes — `how-to/docs/`, `how-to/src/`; the conventions are `how-to/docs/OPERATOR-DOC-CRAFT.md`                |
| `grilling`                      | Design work (architecture, DB, API, story) — the frontier-round interview engine                                                                      |
| `grill-me`                      | <%DEVELOPER_NAME%> types `/grill-me` — a stateless grilling session that saves nothing                                                                |
| `grill-with-docs`               | <%DEVELOPER_NAME%> types `/grill-with-docs`, or a design agent opens design work — grilling that records decisions                                    |
| `teach`                         | <%DEVELOPER_NAME%> types `/teach <topic>` — a safe learning sandbox that writes only to `learning/`                                                   |
| `wayfinder`                     | Charting a large epic into a decision map resolved across sessions (`/wayfinder`)                                                                     |
| `handoff`                       | <%DEVELOPER_NAME%> types `/handoff`, or context nears full — the auto-compaction replacement; write a committed `handoffs/` doc, then stop            |
| `prototype`                     | <%DEVELOPER_NAME%> types `/prototype` — a throwaway spike answering one design question, then discarded                                               |
| `research`                      | <%DEVELOPER_NAME%> types `/research` — a primary-source-cited note that feeds an ADR/PLAN decision                                                    |
| `to-questionnaire`              | A decision is blocked on a person outside the session — client, controller, vendor, stakeholder (`/to-questionnaire`)                                 |
| `wait-what`                     | <%DEVELOPER_NAME%> types `/wait-what` — the last reply did not land; re-pitch it in plain language                                                    |
| `resolving-merge-conflicts`     | A merge, rebase, or `copier update` has left conflict markers                                                                                         |
| `wizard`                        | Authoring an interactive bash wizard for steps only a human can perform (dashboards, credentials, cutovers)                                           |
| `incident`                      | Something is broken in staging or production (`/incident`) — Claude keeps the notes and the clock; the practice is `how-to/docs/INCIDENT-PRACTICE.md` |
| `codebase-design`               | Architecture / refactor / review — the deep-module vocabulary (module, interface, seam, depth, leverage, locality; deletion test)                     |
| `domain-modelling`              | Recording a new concept or decision — add the term to the nearest `CONTEXT.md`, or an ADR, as a design crystallises                                   |
| `improve-codebase-architecture` | <%DEVELOPER_NAME%> types `/improve-codebase-architecture` — scan for deepening opportunities, present a visual HTML report, then grill the pick       |
| `scale-planning`                | Sizing the stack for a target user count / proving it scales / preparing the server contract the NixOS deploy repo consumes (`/scale-planning`)       |
| `legal-documents`               | Drafting a Privacy Policy, T&C, GDPR notice, DPA, contract, or NDA                                                                                    |
| `msp-scp-documents`             | Drafting a security/compliance policy (InfoSec, incident, retention, …)                                                                               |
| `cloudinary-*`                  | Cloudinary uploads, delivery, or transformation work                                                                                                  |
| graph cards                     | Explore/debug/review/refactor via the code-review-graph MCP — auto-generated, referenced by path (`code/docs/CODE-REVIEW-GRAPH.md`)                   |

> **Full-Django direction — on the web surface.** Every page is React-free and server-rendered:
> Django templates + HTMX + Alpine + vanilla CSS (tokens) + django-components + django-ninja,
> with no client build step. Backend is `stack-django`; the web frontend is
> `stack-htmx-templates`.
>
> **Rust-only skills gate authoring, not consuming.** `stack-rust` and the `rust` agent exist
> only where the repository **compiles** Rust. A project that merely depends on a prebuilt PyO3
> wheel installs it like any other dependency and has neither. Listed unconditionally and
> flagged, on the same principle as the mobile rows.
>
> **Mobile-only skills exist but never apply to the web.** `stack-react-native` governs a
> **separate deployable** that consumes the JSON API — it is not a client framework for these
> pages, and it neither weakens nor extends the rule above. It is listed here unconditionally and
> flagged, rather than templated in or out, so this index carries no conditional contents.
> Load it only when working under `code/src/mobile/`.

## Cross-references

- `.claude/agents/CONTEXT.md` — the agents that load these skills.
- `.claude/CLAUDE.md` — Skill Targets (backend `stack-django`, frontend
  `stack-htmx-templates`, global `global-workflow`).
