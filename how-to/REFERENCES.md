# References — how-to layer

**Last Updated**: {{DATE}}

Internal and external references for setup, daily development, and debugging.

---

## Internal

### Context files

| File                                               | Purpose                                                        |
| -------------------------------------------------- | -------------------------------------------------------------- |
| `how-to/CONTEXT.md`                                | Layer entry point — when to read and what lives here           |
| `how-to/docs/CONTEXT.md`                           | Operational reference guides index                             |
| `how-to/src/CONTEXT.md`                            | Contributing standards, testing, and code-quality              |
| `how-to/src/SCALE-ARCHITECTURE/CONTEXT.md`         | How the app scales — load profiles, readiness, sizing envelope |
| `how-to/src/SERVER-ARCHITECTURE/CONTEXT.md`        | What the server/edge must provide; feeds the NixOS deploy repo |
| `how-to/workflows/CONTEXT.md`                      | Workflow index — all step-by-step guides                       |
| `how-to/workflows/01-first-time-setup/CONTEXT.md`  | First-time setup prerequisites and key concepts                |
| `how-to/workflows/02-daily-development/CONTEXT.md` | Daily development session prerequisites                        |
| `how-to/workflows/03-debugging/CONTEXT.md`         | Debugging prerequisites and key concepts                       |
| `how-to/workflows/04-worktree-setup/CONTEXT.md`    | Worktree setup prerequisites and key concepts                  |

### Steps and checklists

| File                                                 | Purpose                                                |
| ---------------------------------------------------- | ------------------------------------------------------ |
| `how-to/workflows/01-first-time-setup/STEPS.md`      | Ordered steps for first-time project setup             |
| `how-to/workflows/01-first-time-setup/CHECKLIST.md`  | Verification checklist for first-time setup            |
| `how-to/workflows/02-daily-development/STEPS.md`     | Ordered steps for starting a daily development session |
| `how-to/workflows/02-daily-development/CHECKLIST.md` | Verification checklist for daily development           |
| `how-to/workflows/03-debugging/STEPS.md`             | Ordered steps for debugging failures and errors        |
| `how-to/workflows/03-debugging/CHECKLIST.md`         | Verification checklist for debugging workflow          |
| `how-to/workflows/04-worktree-setup/STEPS.md`        | Ordered steps for creating a git worktree              |
| `how-to/workflows/04-worktree-setup/CHECKLIST.md`    | Verification checklist for worktree setup              |

### Reference guides

| File                             | Purpose                                                               |
| -------------------------------- | --------------------------------------------------------------------- |
| `how-to/docs/DEVELOPMENT.md`     | First-time setup, Docker Compose commands, env vars, troubleshooting  |
| `how-to/docs/AI-DICTIONARY.md`   | Plain-English glossary of AI-coding terms (index over ai-dictionary/) |
| `how-to/docs/SKILL-AUTHORING.md` | How to write predictable skills under .claude/skills/                 |
| `how-to/docs/CLI-TOOLING.md`     | CLI reference for all Docker Compose development commands             |
| `how-to/docs/GIT-WORKTREES.md`   | Parallel development with git worktrees, Docker isolation, URLs       |
| `how-to/docs/TOOLING-GUIDE.md`   | Internal agents and skills reference (index)                          |

### Cross-layer references

| File                                          | Purpose                                           |
| --------------------------------------------- | ------------------------------------------------- |
| `code/CONTEXT.md`                             | Code layer entry point — writing and testing code |
| `project-management/CONTEXT.md`               | PM layer — stories, sprints, PRs, releases        |
| `project-management/docs/GIT-GUIDE.md`        | Branch strategy, commit format, PR flow           |
| `project-management/docs/VERSIONING-GUIDE.md` | Semver rules and version bump process             |

---

## External — Tools & CLI

| Reference                                                                        | Description                                                      |
| -------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [Docker Compose v2 reference](https://docs.docker.com/compose/reference/)        | Full CLI reference for `docker compose` commands                 |
| [Docker Compose file reference](https://docs.docker.com/reference/compose-file/) | `docker-compose.yml` schema and all service options              |
| [pnpm 11 documentation](https://pnpm.io/motivation)                              | Package manager used for all frontend JS/TS dependencies         |
| [uv documentation](https://docs.astral.sh/uv/)                                   | Python package and project manager used for backend dependencies |
| [Node.js 24 documentation](https://nodejs.org/docs/latest-v24.x/api/)            | Node.js runtime API reference                                    |
| [Python 3.14 documentation](https://docs.python.org/3.14/)                       | Python language and standard library reference                   |
| [Git worktrees](https://git-scm.com/docs/git-worktree)                           | Official `git worktree` command reference                        |
| [Lefthook documentation](https://github.com/evilmartians/lefthook)               | Git hook manager used for pre-commit checks                      |

---

## External — IDE & Editor

| Reference                                                                                          | Description                                                                  |
| -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| [VS Code documentation](https://code.visualstudio.com/docs)                                        | Editor docs including Dev Containers and settings                            |
| [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)              | Attaching VS Code to a running Docker container                              |
| [Zed documentation](https://zed.dev/docs/)                                                         | Editor used per-worktree — each window is an independent Claude Code session |
| [Claude Code CLI documentation](https://docs.anthropic.com/en/docs/claude-code/overview)           | Claude Code agent CLI reference and skill system                             |
| [Lefthook VS Code integration](https://github.com/evilmartians/lefthook/blob/master/docs/usage.md) | Running Lefthook hooks from within VS Code                                   |

---

## External — Debugging & Observability

| Reference                                                                           | Description                                                               |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [Django debug toolbar](https://django-debug-toolbar.readthedocs.io/)                | In-browser panel for SQL queries, cache hits, and request info            |
| [pytest documentation](https://docs.pytest.org/en/stable/)                          | Full pytest reference including fixtures, marks, and configuration        |
| [pytest-django documentation](https://pytest-django.readthedocs.io/)                | Django-specific pytest plugin — `@pytest.mark.django_db`, client fixtures |
| [Django Ninja error handling](https://django-ninja.dev/guides/errors/)              | Exception handlers and error responses in Django Ninja endpoints          |
| [Chrome DevTools Network panel](https://developer.chrome.com/docs/devtools/network) | Inspecting HTMX requests and the fragments they swap in                   |
| [HTMX debugging guide](https://htmx.org/docs/#debugging)                            | `htmx.logAll()`, the event list, and why a swap silently did nothing      |
| [Alpine.js devtools](https://alpinejs.dev/advanced/extending)                       | Inspecting `x-data` state in the browser                                  |
