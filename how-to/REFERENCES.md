# References — how-to layer

**Last Updated**: <%DATE%>

Internal and external references for setup, daily development, and debugging.

---

## Internal

### Context files

| File                                                  | Purpose                                                        |
| ----------------------------------------------------- | -------------------------------------------------------------- |
| `how-to/CONTEXT.md`                                   | Layer entry point — when to read and what lives here           |
| `how-to/docs/CONTEXT.md`                              | Operational reference guides index                             |
| `how-to/src/CONTEXT.md`                               | Operator-guide index — contributing, template, snapshots       |
| `how-to/src/TEMPLATE-GUIDE/CONTEXT.md`                | Using syntek-base as a template — index over 15 guides         |
| `how-to/src/SCALE-ARCHITECTURE/CONTEXT.md`            | How the app scales — load profiles, readiness, sizing envelope |
| `how-to/src/SERVER-ARCHITECTURE/CONTEXT.md`           | What the server/edge must provide; feeds the NixOS deploy repo |
| `how-to/workflows/CONTEXT.md`                         | Workflow index — nine workflows in four families               |
| `how-to/workflows/01-first-time-setup/CONTEXT.md`     | First-time setup prerequisites and key concepts                |
| `how-to/workflows/02-worktree-setup/CONTEXT.md`       | Worktree setup prerequisites and key concepts                  |
| `how-to/workflows/03-daily-development/CONTEXT.md`    | Daily development session prerequisites                        |
| `how-to/workflows/04-database-operations/CONTEXT.md`  | Backup, restore, reset, seed, users — state, never schema      |
| `how-to/workflows/05-testing-and-coverage/CONTEXT.md` | Running the suites and reading coverage against the floors     |
| `how-to/workflows/06-quality-gates/CONTEXT.md`        | The eight pre-PR gates and the standalone audits               |
| `how-to/workflows/07-dependency-updates/CONTEXT.md`   | Adding, upgrading, removing a dependency; clearing advisories  |
| `how-to/workflows/08-debugging/CONTEXT.md`            | Debugging prerequisites and key concepts                       |
| `how-to/workflows/09-write-operator-guide/CONTEXT.md` | Authoring operator documentation — the two homes and the spine |

### Steps and checklists

| File                                                | Purpose                                                |
| --------------------------------------------------- | ------------------------------------------------------ |
| `how-to/workflows/01-first-time-setup/STEPS.md`     | Ordered steps for first-time project setup             |
| `how-to/workflows/02-worktree-setup/STEPS.md`       | Ordered steps for creating a git worktree              |
| `how-to/workflows/03-daily-development/STEPS.md`    | Ordered steps for starting a daily development session |
| `how-to/workflows/04-database-operations/STEPS.md`  | Ordered steps for backup, restore, reset, seed, users  |
| `how-to/workflows/05-testing-and-coverage/STEPS.md` | Ordered steps for running the suites and coverage      |
| `how-to/workflows/06-quality-gates/STEPS.md`        | Ordered steps for the eight pre-PR gates and audits    |
| `how-to/workflows/07-dependency-updates/STEPS.md`   | Ordered steps for a dependency change                  |
| `how-to/workflows/08-debugging/STEPS.md`            | Ordered steps for debugging failures and errors        |
| `how-to/workflows/09-write-operator-guide/STEPS.md` | Ordered steps for authoring an operator guide          |

Each workflow's `CHECKLIST.md` sits beside its `STEPS.md` and carries the verification
points for that procedure.

### Reference guides

| File                                | Purpose                                                                                       |
| ----------------------------------- | --------------------------------------------------------------------------------------------- |
| `how-to/docs/DEVELOPMENT.md`        | First-time setup, Docker Compose commands, env vars, troubleshooting                          |
| `how-to/docs/AI-DICTIONARY.md`      | Plain-English glossary of AI-coding terms (index over ai-dictionary/)                         |
| `how-to/docs/SKILL-AUTHORING.md`    | How to write predictable skills under .claude/skills/ (index)                                 |
| `how-to/docs/CLI-TOOLING.md`        | CLI reference for all Docker Compose development commands                                     |
| `how-to/docs/GIT-WORKTREES.md`      | Parallel development with git worktrees, Docker isolation, URLs                               |
| `how-to/docs/TOOLING-GUIDE.md`      | Internal skills reference (index)                                                             |
| `how-to/docs/CELERY-FIRST-RUN.md`   | Getting the Celery worker and beat running the first time                                     |
| `how-to/docs/FEATURE-DEPLOY.md`     | Deploying a feature branch                                                                    |
| `how-to/docs/HEALTH-PROBES.md`      | Diagnosing a red `/health/ready/` or a restart-looping container — the operator's half        |
| `how-to/docs/INCIDENT-PRACTICE.md`  | Running a live incident: declare, shift handover, stand down, write up                        |
| `how-to/docs/OPERATOR-DOC-CRAFT.md` | The conventions behind an executable guide: reader, homes, spine, commands, execute-to-verify |

### Operator guides (`how-to/src/`)

| File                               | Purpose                                                                                                                                                                                                  |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `how-to/src/BRAND-VOICE.md`        | Brand voice — tone, the four registers, the banned machine tells                                                                                                                                         |
| `how-to/src/CONTRIBUTING.md`       | Contributing, branching, commits, testing, code quality, PR gates                                                                                                                                        |
| `how-to/src/INVARIANTS.md`         | The invariant register — one enforcement point each, and what a breach raises                                                                                                                            |
| `how-to/src/PLATFORM-PROVIDERS.md` | The infrastructure register — seam kind, alternates, substrate verdicts                                                                                                                                  |
| `how-to/src/STORE-LISTING.md`      | **Mobile-only.** The store-listing register — this project's App Store and Play values against their limits (rule: `code/docs/discoverability/APP-STORE.md`, which alone carries the verification dates) |
| `how-to/src/TEMPLATE-TOKENS.md`    | The token contract `copier.yml` implements — ships, and is rendered                                                                                                                                      |
| `how-to/src/TEMPLATE-GUIDE/`       | Fifteen guides on using the template — ships, bar `TEMPLATE-GAPS.md`                                                                                                                                     |
| `how-to/src/NIXOS-SETUP.md`        | Pointer stub → deploy repo runbooks + SERVER-ARCHITECTURE/                                                                                                                                               |

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

| Reference                                                                                          | Description                                                                                                                                                                                                                                                                                                             |
| -------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [VS Code documentation](https://code.visualstudio.com/docs)                                        | Editor docs including Dev Containers and settings                                                                                                                                                                                                                                                                       |
| [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)              | Attaching VS Code to a running Docker container                                                                                                                                                                                                                                                                         |
| [Zed documentation](https://zed.dev/docs/)                                                         | Editor used per-worktree — each window is an independent Claude Code session                                                                                                                                                                                                                                            |
| [Claude Code CLI documentation](https://docs.anthropic.com/en/docs/claude-code/overview)           | Claude Code agent CLI reference and skill system                                                                                                                                                                                                                                                                        |
| [Agent Skills specification](https://agentskills.io/specification)                                 | The published `SKILL.md` format — the six frontmatter fields and their constraints. `how-to/docs/skill-authoring/FRONTMATTER.md` conforms to it, then records which fields this project authors, which runtime keys it admits beyond the six, and what it declines by choice; the gate is `audits/skill-conformance.sh` |
| [Lefthook VS Code integration](https://github.com/evilmartians/lefthook/blob/master/docs/usage.md) | Running Lefthook hooks from within VS Code                                                                                                                                                                                                                                                                              |

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
