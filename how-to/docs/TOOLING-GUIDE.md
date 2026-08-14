---
type: guide
skills: [setup, global-workflow, teach]
model: opus
---

# Internal Development Tooling — Skills

**Version:** 0.1.0 **Tooling:** internal (`.claude/skills/`) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — index of the internal skills, how they are reached, and the cycle they run

The project carries its own skills under `.claude/skills/`. The `<%ORG_SLUG%>-dev-suite`
marketplace plugin is **disabled** (`.claude/settings.json` → `enabledPlugins`) and its contents
were internalised, so every contributor gets the tooling without installing a plugin. The
authoritative operating model is `.claude/CLAUDE.md` Section 2–Section 3.

There is **one** category — a **skill** — and one split underneath it, which decides where the
work runs:

- **Reference skill** — states conventions. Runs inline, in this conversation. Never forks.
- **Task skill** — an executable procedure. Forks, unless its input is the conversation.

**The roster is `.claude/skills/CONTEXT.md`** — every skill, and the line saying when to load it.
Nothing here or in the sub-documents below restates it: a second copy is stale within a week, and
believed as readily as the original. How to write or edit one: `how-to/docs/SKILL-AUTHORING.md`.

## Sub-documents

| Document                                                           | Covers                                                                                                                                     |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| [`tooling-guide/WORKFLOW.md`](tooling-guide/WORKFLOW.md)           | End-to-end development cycle (setup → plan → stories → sprint → branch → TDD → code → QA → docs → PR), the summary diagram, best practices |
| [`tooling-guide/COMMANDS.md`](tooling-guide/COMMANDS.md)           | How a skill is reached — description match, slash command, named explicitly — where it runs, and how it dispatches a fresh context         |
| [`tooling-guide/CONFIGURATION.md`](tooling-guide/CONFIGURATION.md) | Version management, environment scripts, the hooks and MCP surface, and browser/E2E configuration                                          |

## Quick Start

Describe the work and the runtime selects the skill whose description matches it; type `/name`
for the skills that define a slash command; or name the skill in the request. For an end-to-end
run, reach for the skill whose remit is the **whole arc** — `feature` covers plan → red tests →
build → review → ship, and sequences the scoped skills itself — rather than driving each scoped
skill by hand.

Full walkthrough: [`tooling-guide/WORKFLOW.md`](tooling-guide/WORKFLOW.md). Which skill owns
what: `.claude/skills/CONTEXT.md`.

_Part of the `how-to/docs/` documentation family._
