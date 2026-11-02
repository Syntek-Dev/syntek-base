# .ai — Shared AI entry point

This directory connects different coding tools to the project's existing instructions,
skills and memory without maintaining separate copies. It establishes a shared loading
contract while the current manual and skill definitions retain their existing owners.

## Directory Tree

```text
.ai/
├── CONTEXT.md       ← orientation and ownership map
├── CLAUDE.md        ← operating rules for maintaining this directory
├── INSTRUCTIONS.md  ← shared context loading and host compatibility
├── MEMORY.md        ← symlink to the current project's .claude/MEMORY.md
└── skills/          ← symlink to the existing .claude/skills/ tree
```

## Entry points and ownership

| Location             | Purpose                                                        |
| :------------------- | :------------------------------------------------------------- |
| `AGENTS.md`          | Codex entry point into the shared loading contract             |
| `.agents/skills/`    | Codex skill discovery links alongside existing vendored skills |
| `.codex/config.toml` | Codex runtime and MCP configuration                            |
| `.claude/CLAUDE.md`  | Current project manual and Claude-specific runtime guidance    |
| `.claude/skills/`    | Physical first-party skills and existing vendored-skill links  |
| `.claude/MEMORY.md`  | Physical project memory, shared through the link above         |

The shared directory is a project convention. Each coding tool still needs an entry
point that loads it. Runtime configuration and hook enforcement belong to the host;
the presence of a shared skill does not imply identical tool support.

## Cross-references

- `CONTEXT.md` at the repository root — project and layer map.
- `.claude/skills/CONTEXT.md` — existing skill roster and routing.
- `code/docs/DOCUMENTATION-PAIRING.md` — orientation and operating-rule ownership.
