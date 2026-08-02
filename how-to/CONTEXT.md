# how-to — Setup, Daily Development & Debugging

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/
├── CONTEXT.md                   ← this file
├── CLAUDE.md                    ← operating rules for this layer
├── REFERENCES.md                ← internal and external reference links
├── docs/                        ← operational reference guides
│   ├── CONTEXT.md · CLAUDE.md
│   ├── AI-DICTIONARY.md         ← plain-English glossary of AI-coding terms (index)
│   │   └── ai-dictionary/       ← 7 themed sub-documents + CONTEXT.md · CLAUDE.md
│   ├── CELERY-FIRST-RUN.md      ← getting the worker and beat running the first time
│   ├── CLI-TOOLING.md           ← CLI reference for every dev command
│   ├── DEVELOPMENT.md           ← first-time setup, Compose commands, env vars
│   ├── FEATURE-DEPLOY.md        ← deploying a feature branch
│   ├── GIT-WORKTREES.md         ← parallel development with worktrees and Docker isolation
│   ├── SKILL-AUTHORING.md       ← how to write predictable skills under .claude/skills/
│   └── TOOLING-GUIDE.md         ← internal agents and skills reference (index)
│       └── tooling-guide/       ← COMMANDS · CONFIGURATION · WORKFLOW + CONTEXT.md · CLAUDE.md
├── src/                         ← human-facing operator guides (300-line limit exempt)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── CONTRIBUTING.md          ← contributing, testing, and code-quality standards
│   ├── TEMPLATE-TOKENS.md       ← the token contract copier.yml implements (template-only)
│   ├── TEMPLATE-GUIDE/          ← using syntek-base as a template — 14 guides (template-only)
│   ├── NIXOS-SETUP.md           ← pointer stub → deploy repo runbooks + SERVER-ARCHITECTURE/
│   ├── SCALE-ARCHITECTURE/      ← OVERVIEW · LOAD-PROFILES · READINESS · SIZING-ENVELOPE · TOPOLOGY
│   └── SERVER-ARCHITECTURE/     ← OVERVIEW · COMPUTE-ALLOCATION · EDGE-REQUIREMENTS · NIXOS-HANDOFF
└── workflows/                   ← step-by-step operational workflows
    ├── CONTEXT.md · CLAUDE.md
    ├── 01-first-time-setup/     ← clone, configure, and start the project
    ├── 02-daily-development/    ← start a development session, work on a story
    ├── 03-debugging/            ← debug failing tests, broken builds, runtime errors
    └── 04-worktree-setup/       ← create and start a git worktree
```

Each `workflows/NN-…/` directory carries `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and `CHECKLIST.md`.
Every directory with a `CONTEXT.md` also has a `CLAUDE.md`.

## When to read this

- First-time environment setup (Docker Compose, environment files, database)
- Starting the development servers
- Understanding the available scripts and management commands
- Debugging a failing test, build, or linter
- Running the full test suite before pushing
- Generating a project from the template, or updating one

## Contents

- `docs/` — operational reference guides and the internal agents/skills reference
- `src/` — contributing standards, the template guide set, and the architecture snapshots
- `workflows/` — step-by-step practical procedures

## Do not use for

- Writing code → `code/CONTEXT.md`
- Story creation, PRs, releases → `project-management/CONTEXT.md`

## Key docs

| Guide                      | When to read                                                                                     |
| -------------------------- | ------------------------------------------------------------------------------------------------ |
| `docs/DEVELOPMENT.md`      | Environment setup, commands, troubleshooting                                                     |
| `docs/CLI-TOOLING.md`      | Looking for the command that does a thing                                                        |
| `docs/GIT-WORKTREES.md`    | Parallel feature development with isolated stacks                                                |
| `docs/CELERY-FIRST-RUN.md` | The worker or beat is not processing tasks                                                       |
| `docs/FEATURE-DEPLOY.md`   | Deploying a feature branch                                                                       |
| `docs/TOOLING-GUIDE.md`    | Internal agents and skills reference                                                             |
| `docs/AI-DICTIONARY.md`    | Looking up an AI-coding term                                                                     |
| `docs/SKILL-AUTHORING.md`  | Before writing or editing a skill in `.claude/skills/`                                           |
| `src/CONTRIBUTING.md`      | Branching, commits, testing, code quality, the pre-PR gates                                      |
| `src/TEMPLATE-GUIDE/`      | Generating a project from the template, or updating one                                          |
| `src/SCALE-ARCHITECTURE/`  | Sizing the deployment and proving it scales (`/scale-planning`)                                  |
| `src/NIXOS-SETUP.md`       | Pointer stub — provisioning lives in the deploy repo; the contract in `src/SERVER-ARCHITECTURE/` |
