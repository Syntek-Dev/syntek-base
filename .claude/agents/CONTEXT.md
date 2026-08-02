# .claude/agents

Agent definitions for Claude Code. Each file is a named agent invoked via the Agent tool
with `subagent_type` (the value equals the frontmatter `name`, which equals the filename).

Internalised from the `<%ORG_SLUG%>-dev-suite` and `<%ORG_SLUG%>-doc-writer` marketplace plugins so the
project carries its own tooling — every contributor gets the agents without installing plugins.
Plugin/command references were rewritten to internal paths, and models were remapped to the
project policy (`sonnet` → `opus`, `haiku` → `opus`; never `sonnet` or `haiku`). Planning agents
(`story`, `sprint`, `planner`, `user-story`) now route to `fable` — the planning/spec tier
the implementation agents build on (see `.claude/CLAUDE.md` §4).

## Two tiers

- **Orchestrators** run a whole workflow end-to-end and delegate scoped work to specialists.
  They carry **all tools** (no `tools:` line) because they spawn sub-agents. Names are bare.
- **Specialists** and **document writers** are delegated to; each has a **scoped `tools:`** line
  and a distinct, non-overlapping remit. Every file has `name`/`description`/`model`/`tools`
  frontmatter and stays within the 300-line instructional limit.

## Orchestrators (workflow entry points)

| Agent      | Routes                                                                      |
| ---------- | --------------------------------------------------------------------------- |
| `bugfix`   | Fix a bug, debug a regression, or resolve a broken behaviour                |
| `feature`  | Implement a new full-stack feature end-to-end                               |
| `pr`       | Create a pull request or merge a completed feature branch to testing        |
| `refactor` | Behaviour-preserving restructuring (blend: orchestrator + specialist depth) |
| `release`  | Cut a release, bump the version, deploy to production                       |
| `review`   | Review code quality mid-development / QA pass before a PR                   |
| `security` | Security audit — OWASP, NIST, UK Cyber Essentials/Plus — and hardening      |
| `story`    | Write a user story (US###) or plan a sprint                                 |

## Specialists (delegated implementation & analysis)

Rows flagged **mobile-only**, **rust-only** or **desktop-only** exist only in a project generated
with that surface. They are
listed unconditionally and flagged, rather than templated in or out: that keeps this index free
of conditional contents, which is the rule the whole opt-in rests on. On a project without that
surface, read the flagged row as "not present here".

| Agent              | Purpose                                                           |
| ------------------ | ----------------------------------------------------------------- |
| `authentication`   | Secure auth: passwords, MFA/TOTP, sessions, lockout, reset        |
| `backend`          | Django models, service layer, Ninja endpoints + MCP tools         |
| `cicd`             | CI/CD pipelines, Docker environments, deploy automation           |
| `code-reviewer`    | Read-only review: security, PII, DRY, performance, style          |
| `completion`       | Mark user stories and sprints complete once verified              |
| `database`         | Schema design, Django migrations, RLS, PostgreSQL tuning          |
| `desktop`          | **Desktop-only.** Native Slint app; UI, threading, accessibility  |
| `data-scientist`   | Python/SQL data analysis and insight from project data            |
| `debugger`         | Root-cause debugging: reproduce, trace, document — no fix         |
| `doc-writer`       | Developer docs, docstrings, CONTEXT/CLAUDE pairs                  |
| `export`           | PDF/Excel/CSV/JSON export services with PII gating                |
| `frontend`         | Django templates + HTMX + Alpine UI; a11y, token CSS              |
| `gdpr`             | UK GDPR mechanics: PII encryption, consent, DSAR, erasure         |
| `git`              | Branch, commit, PR, and versioning git operations                 |
| `logging`          | Structured logging and observability instrumentation              |
| `mobile`           | **Mobile-only.** Expo/React Native screens; a11y, token styling   |
| `notifications`    | Multi-channel branded, PII-safe notification delivery             |
| `operator-docs`    | Operator guides + runbooks in `how-to/docs/` and `how-to/src/`    |
| `planner`          | Architect a feature into a phased, testable plan                  |
| `pm`               | Set up and maintain PM-tool integration and sync                  |
| `qa-tester`        | Hostile QA — bugs, security flaws, edge cases                     |
| `reporting`        | Role-based backend report data queries and aggregations           |
| `rust`             | **Rust-only.** PyO3 extensions, native crypto primitives, crates  |
| `scaffold`         | Scaffold CONTEXT/CLAUDE docs, workflow folders, routing           |
| `scale-planner`    | Deployment sizing + scalability; the app↔server/deploy contract   |
| `seo`              | Technical SEO / AI discoverability for the Django marketing pages |
| `setup`            | Scaffold project structure, config, directory docs                |
| `sprint`           | Slice written stories into balanced, dependency-ordered sprints   |
| `support-articles` | End-user help articles: how-tos, FAQs, troubleshooting            |
| `syntax`           | Fix syntax, lint, format, type errors — no logic changes          |
| `test-writer`      | Write failing tests and stubs (TDD Red phase)                     |
| `user-story`       | Write structured, testable US### user stories                     |
| `version`          | Bump semver and sync version files, logs, and headers             |

## Document writers (legal / security / compliance drafting)

Draft document text for the site's legal and compliance needs — they do **not** implement
routes, migrations, or source (that is `feature`/`frontend`/`backend`). They load the
`legal-documents` and `msp-scp-documents` skills.

| Agent                                | Drafts                                                 |
| ------------------------------------ | ------------------------------------------------------ |
| `privacy-policy-writer`              | UK GDPR-compliant Privacy Policy                       |
| `terms-conditions-writer`            | English-law Terms & Conditions                         |
| `gdpr-policy-writer`                 | GDPR Article 13/14 data subject rights notices         |
| `dpa-writer`                         | GDPR Article 28 Data Processing Agreements             |
| `sub-processor-register-writer`      | GDPR Article 28 sub-processor registers                |
| `data-retention-policy-writer`       | Data Retention & Disposal Policies                     |
| `data-classification-policy-writer`  | Data Classification Policies (ISO 27001)               |
| `information-security-policy-writer` | Information Security Policy (ISO 27001 / NIST)         |
| `acceptable-use-policy-writer`       | Acceptable Use Policies with UK GDPR monitoring notice |
| `password-auth-policy-writer`        | Password & Authentication Policy (NIST/NCSC/ISO)       |
| `network-security-policy-writer`     | Network Security Policy (ISO 27001)                    |
| `incident-response-plan-writer`      | Incident Response Plan (ISO 27001 / NIST / GDPR)       |
| `vendor-assessment-writer`           | Third-party vendor security assessment questionnaires  |

**Note:** Agents are hard-blocked from self-editing — changes require explicit user instruction.
