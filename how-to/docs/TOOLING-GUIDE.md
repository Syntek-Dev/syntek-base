---
type: guide
agent: setup
skills: [global-workflow, teach]
model: opus
---

# Internal Development Tooling — Agents & Skills

**Version:** 0.1.0 **Tooling:** internal (`.claude/agents/` + `.claude/skills/`) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — index of the internal agents, skills, and development workflow

The project carries its own agents and skills under `.claude/`. The `<%ORG_SLUG%>-dev-suite`
marketplace plugin is **disabled** (`.claude/settings.json` → `enabledPlugins`) and its agents
and skills were internalised, so every contributor gets the tooling without installing a plugin.
The authoritative model is `.claude/CLAUDE.md` §2–§3.

- `.claude/agents/` — 49 agents (8 orchestrators + 28 specialists + 13 document writers).
  Registry: `.claude/agents/CONTEXT.md`.
- `.claude/skills/` — the stack and workflow skills the agents load on demand. Registry:
  `.claude/skills/CONTEXT.md`.
- `.claude/skills/teach/SKILL.md` — a safe `learning/` sandbox to practise a skill without
  touching the codebase.

Claude Code auto-selects an agent when a task matches its description, or you invoke one
explicitly via the Agent tool with the agent name as `subagent_type`.

## Sub-documents

| Document                                                           | Covers                                                                                                                                              |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`tooling-guide/WORKFLOW.md`](tooling-guide/WORKFLOW.md)           | End-to-end development cycle (setup → plan → stories → sprint → branch → TDD → code → QA → docs → PR), workflow summary diagram, and best practices |
| [`tooling-guide/COMMANDS.md`](tooling-guide/COMMANDS.md)           | The internal agents by category (planning, development, quality, refactoring, infrastructure, specialised) and the `version` agent                  |
| [`tooling-guide/CONFIGURATION.md`](tooling-guide/CONFIGURATION.md) | Version management, the skills reference, environment scripts, and browser/E2E configuration                                                        |

## Quick Start

Invoke an agent by name via the Agent tool (`subagent_type: <name>`), or let Claude Code
auto-select one from the task. A typical feature cycle:

| Step     | Agent         | What it does                                       |
| -------- | ------------- | -------------------------------------------------- |
| Plan     | `planner`     | Break a feature into a phased, testable plan       |
| Backend  | `backend`     | Django models, services, Ninja API routers         |
| Frontend | `frontend`    | django-components + HTMX, accessibility, token CSS |
| Tests    | `test-writer` | Failing tests plus minimal stubs (TDD Red)         |
| QA       | `qa-tester`   | Hostile QA — bugs, security flaws, edge cases      |

For an end-to-end run, start from an **orchestrator** (`feature`, `bugfix`, `pr`, `review`,
`security`, `refactor`, `release`, `story`) and let it delegate. Full walkthrough:
[`tooling-guide/WORKFLOW.md`](tooling-guide/WORKFLOW.md).

_Part of the `how-to/docs/` documentation family._
