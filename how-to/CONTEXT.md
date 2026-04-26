# how-to — Setup, Daily Development & Debugging

## Directory Tree

```text
how-to/
├── CONTEXT.md               ← this file
├── docs/                    ← operational reference guides
│   ├── CLI-TOOLING.md       ← CLI reference for all Docker Compose dev commands
│   ├── CONTEXT.md
│   ├── DEVELOPMENT.md       ← first-time setup, Docker Compose commands, env vars
│   └── SYNTEK-GUIDE.md      ← full Syntek Dev Suite agent and skill reference
├── src/                     ← contributing and code-quality guide
│   └── CONTEXT.md
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
    └── 03-debugging/        ← debug failing tests, broken builds, runtime errors
        ├── CHECKLIST.md
        ├── CONTEXT.md
        └── STEPS.md
```

## When to read this

- First-time environment setup (Docker Compose, environment files, database)
- Starting the development servers
- Understanding the available npm and Django management commands
- Debugging a failing test, build, or linter
- Running the full test suite before pushing

## Contents

- `docs/` — Development environment guide and plugin usage reference
- `workflows/` — Step-by-step practical guides

## Do not use for

- Writing code → `code/CONTEXT.md`
- Story creation, PRs, releases → `project-management/CONTEXT.md`

## Key docs

| Guide                  | When to read                                           |
| ---------------------- | ------------------------------------------------------ |
| `docs/API-TESTING.md`  | API tool setup, environment split, promotion flow      |
| `docs/DEVELOPMENT.md`  | Environment setup, commands, troubleshooting           |
| `docs/SYNTEK-GUIDE.md` | Full Claude Code agent and skill reference             |
| `src/API-TESTING.md`   | Developer guide — GraphiQL locally, Hoppscotch staging |
