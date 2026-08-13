# how-to/docs/tooling-guide

Detailed sub-documents for the internal skills guide, split out because the index would
otherwise exceed the 300-line instructional limit. Read via `how-to/docs/TOOLING-GUIDE.md`,
which is that index.

None of them carries a roster. Which skill owns what lives once, in
`.claude/skills/CONTEXT.md`; these three cover the surface around it — the cycle the skills run,
how one is reached, and the configuration underneath.

## Directory Tree

```text
how-to/docs/tooling-guide/
├── CLAUDE.md          ← operating rules
├── CONTEXT.md         ← this file
├── COMMANDS.md        ← how a skill is reached, where it runs, how it dispatches
├── CONFIGURATION.md   ← configuration and tooling setup
└── WORKFLOW.md        ← the end-to-end development cycle the skills run
```

## Files

| File               | Purpose                                                                |
| ------------------ | ---------------------------------------------------------------------- |
| `COMMANDS.md`      | Description match, slash commands, inline vs forked, Agent dispatch    |
| `CONFIGURATION.md` | Version management, environment scripts, hooks and MCP, browser/E2E    |
| `WORKFLOW.md`      | Complete development cycle: setup → plan → TDD → code → QA → docs → PR |

Parent guide: `how-to/docs/TOOLING-GUIDE.md`
