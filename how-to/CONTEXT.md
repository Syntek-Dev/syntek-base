# how-to — Setup, Daily Development & Debugging

**Last Updated**: {{DATE}}

## Directory Tree

```text
how-to/
├── CONTEXT.md               ← this file
├── REFERENCES.md            ← internal and external reference links for this layer
├── docs/                    ← operational reference guides
│   ├── AI-DICTIONARY.md     ← plain-English glossary of AI-coding terms (index)
│   ├── ai-dictionary/       ← 7 themed term sub-documents
│   ├── CLI-TOOLING.md       ← CLI reference for all Docker Compose dev commands
│   ├── CONTEXT.md
│   ├── DEVELOPMENT.md       ← first-time setup, Docker Compose commands, env vars
│   ├── GIT-WORKTREES.md     ← parallel development with git worktrees and Docker isolation
│   ├── SKILL-AUTHORING.md   ← how to write predictable skills under .claude/skills/
│   ├── TOOLING-GUIDE.md         ← internal agents and skills reference (index)
│   └── tooling-guide/           ← detailed sub-documents
│       ├── COMMANDS.md
│       ├── CONFIGURATION.md
│       └── WORKFLOW.md
├── src/                     ← contributing & code-quality guide + architecture snapshots (scale-planner)
│   ├── CONTEXT.md
│   ├── NIXOS-SETUP.md       ← pointer stub (consumed 18/07/2026) → deploy repo runbooks + SERVER-ARCHITECTURE/
│   ├── SCALE-ARCHITECTURE/  ← how the app scales: load profiles, readiness audit, sizing envelope (feeds SERVER-ARCHITECTURE)
│   └── SERVER-ARCHITECTURE/ ← what the server/edge must provide + assigned compute with buffer; feeds the NixOS deploy repo
└── workflows/               ← step-by-step operational workflows
    ├── CONTEXT.md
    ├── 01-first-time-setup/ ← clone, configure, and start the project
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 02-daily-development/ ← start a development session, work on a story
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    ├── 03-debugging/        ← debug failing tests, broken builds, runtime errors
    │   ├── CHECKLIST.md
    │   ├── CONTEXT.md
    │   └── STEPS.md
    └── 04-worktree-setup/   ← create and start a git worktree for parallel development
        ├── CHECKLIST.md
        ├── CONTEXT.md
        └── STEPS.md
```

## When to read this

- First-time environment setup (Docker Compose, environment files, database)
- Starting the development servers
- Understanding the available pnpm and Django management commands
- Debugging a failing test, build, or linter
- Running the full test suite before pushing

## Contents

- `docs/` — Development environment guide and internal agents and skills reference
- `workflows/` — Step-by-step practical guides

## Do not use for

- Writing code → `code/CONTEXT.md`
- Story creation, PRs, releases → `project-management/CONTEXT.md`

## Key docs

| Guide                     | When to read                                                                                                      |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `docs/DEVELOPMENT.md`     | Environment setup, commands, troubleshooting                                                                      |
| `docs/GIT-WORKTREES.md`   | Parallel feature development with isolated stacks                                                                 |
| `docs/TOOLING-GUIDE.md`   | Internal agents and skills reference                                                                              |
| `src/NIXOS-SETUP.md`      | Pointer stub — provisioning lives in the NixOS deploy repo; the app→server contract in `src/SERVER-ARCHITECTURE/` |
| `src/SCALE-ARCHITECTURE/` | How the app scales + the server/edge contract feeding the NixOS deploy repo (`/scale-planning`)                   |
| `docs/AI-DICTIONARY.md`   | Looking up an AI-coding term (plain-English glossary)                                                             |
| `docs/SKILL-AUTHORING.md` | Before writing or editing a skill in `.claude/skills/`                                                            |
