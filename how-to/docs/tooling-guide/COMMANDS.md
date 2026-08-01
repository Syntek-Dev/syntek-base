---
type: guide
agent: setup
skills: [global-workflow]
model: opus
---

# Internal Agents — Reference

**Version:** 0.1.0 **Tooling:** internal (`.claude/agents/`) **Maintained by:** {{ORG_NAME}} Developers **Language:** British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — the internal agents by category, with model allocation

The agents below are internalised under `.claude/agents/` (the `{{ORG_SLUG}}-dev-suite` plugin is
disabled — see `.claude/CLAUDE.md` §3). Claude Code selects an agent automatically when a task
matches its description, or you invoke one explicitly via the Agent tool with the agent name as
`subagent_type`. Full roster (including the 13 document-writer agents) and models:
`.claude/agents/CONTEXT.md`.

---

## Orchestrators (workflow entry points)

Start here for end-to-end work; each delegates scoped work to the specialists below.

| Agent      | Model | Routes                                                       |
| ---------- | ----- | ------------------------------------------------------------ |
| `feature`  | Opus  | Implement a new full-stack feature end-to-end                |
| `bugfix`   | Opus  | Fix a bug, debug a regression, or resolve a broken behaviour |
| `refactor` | Opus  | Behaviour-preserving restructuring                           |
| `review`   | Opus  | Code-quality / QA pass before a PR                           |
| `security` | Opus  | Security audit (OWASP, NIST, Cyber Essentials) and hardening |
| `pr`       | Opus  | Create a pull request or merge a branch to testing           |
| `release`  | Opus  | Cut a release, bump the version, deploy to production        |
| `story`    | Fable | Write a user story (US###) or plan a sprint                  |

---

## Specialist Agents

### Planning & Architecture

| Agent        | Model | Description                                     |
| ------------ | ----- | ----------------------------------------------- |
| `planner`    | Fable | Create architectural plans, break down features |
| `user-story` | Fable | Generate user stories from requirements         |
| `sprint`     | Fable | Organise stories into balanced sprints          |
| `completion` | Opus  | Track story and sprint completion               |

### Development

| Agent            | Model | Description                               |
| ---------------- | ----- | ----------------------------------------- |
| `setup`          | Opus  | Project initialisation and configuration  |
| `backend`        | Opus  | Backend development, APIs, database       |
| `frontend`       | Opus  | UI/UX, components, accessibility          |
| `database`       | Opus  | Database design, migrations, optimisation |
| `authentication` | Opus  | Authentication, MFA, session management   |

### Quality & Testing

| Agent         | Model | Description                      |
| ------------- | ----- | -------------------------------- |
| `test-writer` | Opus  | TDD test suites and stubs        |
| `qa-tester`   | Opus  | Hostile QA, security, edge cases |
| `review`      | Opus  | Code review, SOLID, security     |
| `debugger`    | Opus  | Root cause analysis, debugging   |

### Refactoring & Maintenance

| Agent        | Model | Description                         |
| ------------ | ----- | ----------------------------------- |
| `refactor`   | Opus  | Code cleanup without changing logic |
| `syntax`     | Opus  | Fix syntax and linting errors       |
| `doc-writer` | Opus  | Technical documentation             |

### Infrastructure

| Agent      | Model | Description                            |
| ---------- | ----- | -------------------------------------- |
| `cicd`     | Opus  | CI/CD pipelines, deployments           |
| `security` | Opus  | Access control, headers, rate limiting |
| `logging`  | Opus  | Logging, Sentry, audit trails          |
| `git`      | Opus  | Branch management, versioning          |

### Specialised

| Agent              | Model | Description                      |
| ------------------ | ----- | -------------------------------- |
| `gdpr`             | Opus  | GDPR compliance, data protection |
| `seo`              | Opus  | SEO, meta tags, structured data  |
| `notifications`    | Opus  | Email, SMS, push notifications   |
| `export`           | Opus  | PDF, Excel, CSV, JSON exports    |
| `reporting`        | Opus  | Data queries, report services    |
| `data-scientist`   | Opus  | Data analysis, Python, SQL       |
| `support-articles` | Opus  | Help documentation               |

---

## Version operations (the `version` agent)

The `version` agent handles all version management — bump (major/minor/patch), syncing
`VERSION`/`VERSION-HISTORY.md`/`CHANGELOG.md`/`RELEASES.md`, and refreshing markdown metadata
headers. Rules: `project-management/docs/VERSIONING-GUIDE.md`.

_Part of the `how-to/docs/` documentation family. See [`../TOOLING-GUIDE.md`](../TOOLING-GUIDE.md) for the full index._
