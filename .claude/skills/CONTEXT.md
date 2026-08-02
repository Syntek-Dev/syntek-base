# .claude/skills

Skills for Claude Code — auto-selected reference bundles the agents load on demand. Each skill
is a folder with a `SKILL.md` (YAML frontmatter: `name` + `description`) plus optional
sub-documents. Internalised from the `<%ORG_SLUG%>-dev-suite` and `<%ORG_SLUG%>-doc-writer` plugins so the
project carries its own tooling; plugin references were rewritten to internal paths.

## Directory tree

```text
.claude/skills/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
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
├── runbook/                ← operator-doc craft: the runbook spine, execute-to-verify
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
├── grilling/               ← the grilling engine — one-question-at-a-time design interview
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

| Skill                           | Load when                                                                                                                                        |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `stack-django`                  | Writing/reviewing backend code (models, services, Django Ninja endpoints, tests) — and server-rendered templates                                 |
| `stack-htmx-templates`          | Building/reviewing public frontend — Django templates, django-components, HTMX, Alpine, token CSS, page cache                                    |
| `stack-react-native`            | **Mobile-only.** Building/reviewing the mobile surface — Expo, TypeScript, expo-router, StyleSheet over generated tokens                         |
| `stack-fastmcp`                 | Writing/reviewing MCP tools (`apps/**/mcp_tools.py`, `config/mcp.py`) — exposing domain operations to an LLM agent at `/mcp/`                    |
| `stack-rust`                    | **Rust-only.** Writing/reviewing `code/src/rust/` — PyO3 boundary, secret zeroizing, cargo-deny. Also: deciding if work belongs in Rust at all   |
| `stack-slint`                   | **Desktop-only.** Building/reviewing the native Slint app — the AboutSlint licence disclosure, the generated-code lint boundary, threading, a11y |
| `global-workflow`               | Branching, commits, PRs, version bumps, documentation, code comments                                                                             |
| `runbook`                       | Authoring a guide or runbook a human executes — `how-to/docs/`, `how-to/src/`; loaded by `operator-docs`                                         |
| `grilling`                      | Design work (architecture, DB, API, story) — the one-question-at-a-time interview engine                                                         |
| `grill-me`                      | <%DEVELOPER_NAME%> types `/grill-me` — a stateless grilling session that saves nothing                                                           |
| `grill-with-docs`               | <%DEVELOPER_NAME%> types `/grill-with-docs`, or a design agent opens design work — grilling that records decisions                               |
| `teach`                         | <%DEVELOPER_NAME%> types `/teach <topic>` — a safe learning sandbox that writes only to `learning/`                                              |
| `wayfinder`                     | Charting a large epic into a decision map resolved across sessions (`/wayfinder`)                                                                |
| `handoff`                       | <%DEVELOPER_NAME%> types `/handoff`, or context nears full — the auto-compaction replacement; write a committed `handoffs/` doc, then stop       |
| `prototype`                     | <%DEVELOPER_NAME%> types `/prototype` — a throwaway spike answering one design question, then discarded                                          |
| `research`                      | <%DEVELOPER_NAME%> types `/research` — a primary-source-cited note that feeds an ADR/PLAN decision                                               |
| `codebase-design`               | Architecture / refactor / review — the deep-module vocabulary (module, interface, seam, depth, leverage, locality; deletion test)                |
| `domain-modelling`              | Recording a new concept or decision — add the term to the nearest `CONTEXT.md`, or an ADR, as a design crystallises                              |
| `improve-codebase-architecture` | <%DEVELOPER_NAME%> types `/improve-codebase-architecture` — scan for deepening opportunities, present a visual HTML report, then grill the pick  |
| `scale-planning`                | Sizing the stack for a target user count / proving it scales / preparing the server contract the NixOS deploy repo consumes (`/scale-planning`)  |
| `legal-documents`               | Drafting a Privacy Policy, T&C, GDPR notice, DPA, contract, or NDA                                                                               |
| `msp-scp-documents`             | Drafting a security/compliance policy (InfoSec, incident, retention, …)                                                                          |
| `cloudinary-*`                  | Cloudinary uploads, delivery, or transformation work                                                                                             |
| graph cards                     | Explore/debug/review/refactor via the code-review-graph MCP — auto-generated, referenced by path (`code/docs/CODE-REVIEW-GRAPH.md`)              |

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
