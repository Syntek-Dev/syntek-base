---
type: guide
agent: setup
skills: [global-workflow]
model: opus
---

# Internal Tooling — Configuration & Environment

**Version:** 0.1.0 **Tooling:** internal (`.claude/agents/` + `.claude/skills/`) **Maintained by:** {{ORG_NAME}} Developers **Language:** British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Version management, skills, environment scripts, and browser/E2E setup

---

## Version Management

The `version` agent manages semantic versioning, changelogs, and markdown metadata headers
across the project. Rules: `project-management/docs/VERSIONING-GUIDE.md`. It can also be
reached through the `release` orchestrator.

### Files the `version` agent maintains

| File                 | Purpose                               | Audience      |
| -------------------- | ------------------------------------- | ------------- |
| `VERSION`            | Canonical semver string               | Build systems |
| `VERSION-HISTORY.md` | Technical change log with code detail | Developers    |
| `CHANGELOG.md`       | Brief developer-focused summary       | Developers    |
| `RELEASES.md`        | User-facing feature highlights        | End users     |

### Markdown metadata headers

Instructional `.md` files carry a metadata header the `version` agent keeps in sync:

```markdown
# Document Title

**Last Updated**: DD/MM/YYYY **Version**: X.Y.Z **Maintained By**: {{ORG_NAME}} **Language**:
British English (en_GB) **Timezone**: {{TIMEZONE}}

---
```

---

## Skills Reference

Skills live in `.claude/skills/` and are loaded on demand by the agents. Full when-to-load
table: `.claude/skills/CONTEXT.md`. The stack targets are named in `.claude/CLAUDE.md`
("Skill Targets").

| Skill                  | Load when                                                     |
| ---------------------- | ------------------------------------------------------------- |
| `stack-django`         | Backend code — models, services, Django Ninja routers, pytest |
| `stack-htmx-templates` | Public frontend — Django templates, HTMX, Alpine, token CSS   |
| `global-workflow`      | Branches, commits, PRs, version bumps, docs, code comments    |
| `teach`                | `/teach` — learn a skill in the `learning/` sandbox           |
| `wayfinder`            | `/wayfinder` — chart a big epic into a decision map           |
| `handoff`              | `/handoff` — compact the conversation for a fresh agent       |
| `prototype`            | `/prototype` — throwaway spike answering one question         |
| `research`             | `/research` — primary-source note that feeds a decision       |
| `legal-documents`      | Privacy Policy, T&C, GDPR notice, DPA, contract, NDA          |
| `msp-scp-documents`    | Security/compliance policy (InfoSec, incident, retention, …)  |

The `cloudinary-*` skills cover Cloudinary upload, delivery, and transformations.

`global-workflow` carries the conventions every agent honours: en_GB localisation,
DD/MM/YYYY dates, the 24-hour clock, {{TIMEZONE}}, {{CURRENCY}}, Git commit standards, and
Markdown formatting rules.

---

## Environment Scripts

All developer operations run through the project scripts in `code/src/scripts/**/*.sh` — never
raw `pnpm`, `uv`, `pytest`, `python`, or `docker`. Full catalogue:
`how-to/docs/CLI-TOOLING.md`.

| Task                  | Script                                                   |
| --------------------- | -------------------------------------------------------- |
| Start the dev stack   | `bash code/src/scripts/development/server.sh up`         |
| Rebuild and start     | `bash code/src/scripts/development/server.sh up --build` |
| Stop the dev stack    | `bash code/src/scripts/development/server.sh down`       |
| Tail logs             | `bash code/src/scripts/development/logs.sh --follow`     |
| Run all tests         | `bash code/src/scripts/tests/all.sh`                     |
| Backend tests         | `bash code/src/scripts/tests/backend.sh`                 |
| API integration tests | `bash code/src/scripts/tests/api.sh`                     |
| Lint / format / types | `bash code/src/scripts/syntax/check.sh`                  |
| Run migrations        | `bash code/src/scripts/database/migrate.sh`              |

Deployment scripts (`deploy.sh`, `rollback.sh`, `health-check.sh`) are planned under
`code/src/scripts/deployment/` as the CI/CD pipeline matures.

---

## Markdown All in One (VS Code)

Documentation authoring is optimised for the **Markdown All in One** VS Code extension
(`yzhang.markdown-all-in-one`): auto-updating tables of contents, smart lists, GFM table
alignment on save, task lists, and math rendering.

| Shortcut            | Action                       |
| ------------------- | ---------------------------- |
| `Ctrl+B` / `Cmd+B`  | Toggle bold                  |
| `Ctrl+I` / `Cmd+I`  | Toggle italic                |
| `Tab` / `Shift+Tab` | Indent / un-indent list item |
| `Alt+C`             | Toggle task checkbox         |

---

## Browser & E2E Configuration

One browser driver, in Python: **playwright-python driven from pytest**, configured in
`code/src/django/tests/e2e/conftest.py` (viewport projects, base URL) and
`a11y_config.py` (page list, axe tags, impact thresholds). The stack must be running:

```bash
bash code/src/scripts/development/server.sh up
bash code/src/scripts/tests/e2e-py.sh
```

Most tests do **not** belong there. Template and HTMX behaviour is cheaper through the Django
test client (`code/docs/testing/FRONTEND-TESTING.md`); reach for the browser only when the check
needs layout, CSS resolution, or JavaScript.

For interactive UI inspection from Claude Code, the `claude-in-chrome` MCP server drives a real
Chrome session (load its schema via ToolSearch — see `.claude/CLAUDE.md` §3).

---

## Getting Help

- **Agents & skills roster:** `.claude/agents/CONTEXT.md` and `.claude/skills/CONTEXT.md`.
- **Operating model & routing:** `.claude/CLAUDE.md` §2–§3.
- **Command reference:** `how-to/docs/CLI-TOOLING.md`.

_Part of the `how-to/docs/` documentation family. See [`../TOOLING-GUIDE.md`](../TOOLING-GUIDE.md) for the full index._
