---
type: guide
skills: [setup, global-workflow]
model: opus
---

# Internal Tooling — Configuration & Environment

**Version:** 0.1.0 **Tooling:** internal (`.claude/skills/`) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — version management, environment scripts, hooks and MCP, browser/E2E setup

---

## Version Management

The `version` skill manages semantic versioning, changelogs, and markdown metadata headers
across the project. Rules: `project-management/docs/VERSIONING-GUIDE.md`. It is also sequenced
by `release`.

### Files the `version` skill maintains

| File                 | Purpose                               | Audience      |
| -------------------- | ------------------------------------- | ------------- |
| `VERSION`            | Canonical semver string               | Build systems |
| `VERSION-HISTORY.md` | Technical change log with code detail | Developers    |
| `CHANGELOG.md`       | Brief developer-focused summary       | Developers    |
| `RELEASES.md`        | User-facing feature highlights        | End users     |

### Markdown metadata headers

Instructional `.md` files carry a metadata header the `version` skill keeps in sync:

```markdown
# Document Title

**Last Updated**: DD/MM/YYYY **Version**: X.Y.Z **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>

---
```

---

## Where the skills live

Skills are folders under `.claude/skills/`, each with a `SKILL.md`. The roster and its
when-to-load column are `.claude/skills/CONTEXT.md`; the stack targets are named there too.
Neither list is restated here.

`global-workflow` carries the conventions every other skill honours: en_GB localisation,
DD/MM/YYYY dates, the 24-hour clock, <%TIMEZONE%>, <%CURRENCY%>, Git commit standards, and
Markdown formatting rules.

---

## Hooks and MCP servers

| Surface        | What it does                                                                                                           | Registry                      |
| -------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| Hooks          | Eight pre-PR quality gates, plus the two session-continuity hooks that intercept compaction and warn as context fills  | `.claude/hooks/CONTEXT.md`    |
| MCP servers    | `code-review-graph` (structural context), `context7` (library docs), `mcp-mermaid` (diagrams), `claude-in-chrome` (UI) | `.claude/CLAUDE.md` Section 3 |
| Helper scripts | Read-only inspection helpers a skill calls to gather context — they never run dev operations                           | `.claude/plugins/CONTEXT.md`  |

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
Chrome session (load its schema via ToolSearch — see `.claude/CLAUDE.md` Section 3).

---

## Getting Help

- **Skills roster:** `.claude/skills/CONTEXT.md`.
- **Operating model & routing:** `.claude/CLAUDE.md` Section 2–Section 3.
- **Command reference:** `how-to/docs/CLI-TOOLING.md`.

_Part of the `how-to/docs/` documentation family. See [`../TOOLING-GUIDE.md`](../TOOLING-GUIDE.md) for the full index._
