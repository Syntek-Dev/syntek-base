# .claude

Claude Code configuration for the <%PROJECT_NAME%> project.

## Directory Tree

```text
.claude/
├── CLAUDE.md          ← global rules, context loading, routing, model selection, non-negotiables
├── CONTEXT.md         ← this file
├── MEMORY.md          ← project memory store (feedback, patterns, project state)
├── settings.json      ← Claude Code permission settings (project-level)
├── settings.local.json ← local permission overrides (gitignored)
├── agents/            ← agent definitions (50: 8 orchestrators + specialists + doc-writers)
├── skills/            ← internalised skills (stack, global-workflow, document standards)
├── hooks/             ← pre-PR quality gate hooks
├── plugins/           ← agent helper scripts (6 read-only inspection scripts)
└── worktrees/         ← active git worktree checkouts (gitignored)
```

## Key file

`CLAUDE.md` is the authoritative config — read it first for all rules, routing, and non-negotiables.

## Sub-directories

| Directory    | CONTEXT.md                  | Purpose                                                |
| ------------ | --------------------------- | ------------------------------------------------------ |
| `agents/`    | `agents/CONTEXT.md`         | Orchestrators, specialists, and document-writer agents |
| `skills/`    | `skills/CONTEXT.md`         | Internalised stack, workflow, and document skills      |
| `hooks/`     | `hooks/CONTEXT.md`          | Pre-PR quality gates (8 automated checks)              |
| `plugins/`   | `plugins/CONTEXT.md`        | Read-only helper scripts agents call for context       |
| `worktrees/` | _(gitignored — no content)_ | Git worktree checkouts for parallel stories            |
