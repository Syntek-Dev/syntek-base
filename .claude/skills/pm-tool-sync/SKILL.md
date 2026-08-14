---
name: pm-tool-sync
description: >-
  Configure and maintain how <%PROJECT_NAME%>'s PM artefacts sync to an external project-management
  tool — the status and field mapping, the credentials as environment variables, the webhook
  secret, and the CI sync workflow. Load when the integration has to be set up, repaired, or
  pointed at a different tool. Integration plumbing only. Not writing the user stories being
  synced (`story`), not planning or balancing the sprints (`sprint`), not marking either complete
  (`completion`), and not the branch or PR mechanics the sync reads (`git`).
model: opus
metadata:
  skills: global-workflow grilling
---

# Sync the PM Tool (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the tool, the workspace and the credentials come from the
person who owns the account, and a fork cannot be handed a token it was not given).

The live tool is **ClickUp** (`.github/workflows/clickup-sync.yml`,
`.claude/plugins/pm-tool.py`); Linear, Jira, GitHub Projects, Monday, Asana, Trello, Notion,
Azure DevOps and Shortcut are supported on request.

---

## Detect first, then grill

```bash
python3 .claude/plugins/pm-tool.py detect    # the existing config, env vars and sync workflows
```

**Run this before asking anything** — half the agenda below is usually already answered on
disk, and asking for a value that is already configured wastes the round.

Then open a grilling pass — the round shape and the question format belong to the `grilling`
skill (`.claude/CLAUDE.md` Section 10). What must be settled:

| Needed                | Because it decides     | Default here                  |
| --------------------- | ---------------------- | ----------------------------- |
| The tool              | The integration target | ClickUp, already wired        |
| API credentials       | Authentication         | Environment variables         |
| Workspace and project | Where artefacts land   | The workspace, space and list |
| Status mapping        | Sync accuracy          | The baseline below            |
| Assignment rules      | Whether to auto-assign | Ask; off by default           |

**Never invent a credential.** Guide the person to mint it and record only its variable name.

## Status and field mapping

Map this repository's story lifecycle to the tool's columns. The baseline:

```json
{
  "status_mapping": {
    "backlog": ["Backlog", "To Do"],
    "ready": ["Ready", "Sprint Backlog"],
    "in_progress": ["In Progress"],
    "review": ["In Review", "QA"],
    "done": ["Done", "Closed"],
    "blocked": ["Blocked", "On Hold"]
  },
  "field_mapping": {
    "story_points": "estimate",
    "priority": "priority",
    "sprint": "cycle",
    "assignee": "assignee"
  }
}
```

MoSCoW labels map to `must-have` / `should-have` / `could-have` / `wont-have`.

## Configuration

The config file carries **no secrets** and sits wherever `pm-tool.py detect` reports as
canonical. The keys go into the relevant `.env.*.example` template by name only:

```bash
# Project management integration
PM_TOOL=clickup                 # clickup|linear|jira|github|monday|asana|trello|notion|azure|shortcut
PM_API_KEY=                     # personal API token
PM_WORKSPACE_ID=                # workspace or organisation ID
PM_PROJECT_ID=                  # project, board or list ID
PM_SYNC_ENABLED=true
PM_WEBHOOK_SECRET=              # signature secret for inbound webhooks
```

## CI sync

A sync workflow drives status transitions off **branch names** (`us###/…`) and **PR events** —
opened moves to In Progress, merged moves to Done. **Reference secrets, never literals.**

## Non-negotiables

- **Every credential is an environment variable** — never in code, never in a committed config
  file, never in a workflow literal.
- **Inbound webhooks are signature-verified** against `PM_WEBHOOK_SECRET`. An unverified webhook
  endpoint lets anyone move a story to Done.
- **No automation that bypasses the security review or the pre-PR gate.**
- **Never modify PM-tool data destructively without explicit confirmation** — the tool holds
  state this repository is not the source of truth for, and a bad mapping deletes someone
  else's work.

## Verify

Run a dry-run sync, confirm **one story round-trips**, and confirm the CI workflow fires on a
test PR. Report the mapping and any step a human still has to do by hand.

## Definition of done

The mapping recorded and round-tripped; credentials present as environment variables with the
`.env.*.example` names in step; the webhook secured; `project-management/CONTEXT.md` updated
where the wiring or conventions changed, and `.claude/plugins/CONTEXT.md` where `pm-tool.py`
behaviour did.

## Handoff

Report the tool, the workspace, the mapping and the sync state. Then name what is owed: `story`
for the artefacts being synced, `sprint` for the cycles, `completion` to record a status
transition on this side, `cicd` for deployment status updates, and `git` for the branch and
ticket-ID naming the sync reads.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/02-story-creation/` — the story artefacts that get synced
- `project-management/workflows/03-sprint-planning/` — the sprint records that get synced

## Cross-references

- `project-management/CONTEXT.md` — the PM layer, and where the artefacts live
- `project-management/docs/PLANNING-GUIDE.md` — the sprint and cycle semantics being mapped
- `project-management/docs/GIT-GUIDE.md` — the branch and ticket-ID conventions the sync reads
- `.claude/plugins/CONTEXT.md` — the plugin catalogue, and `pm-tool.py`'s contract
