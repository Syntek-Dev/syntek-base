---
name: setup
description: >-
  Stand up new structure and wire configuration in <%PROJECT_NAME%> — a new Django app, a new
  public marketing route, the environment templates, and the root config files — always through
  the project scripts rather than by hand. Load when a story needs its scaffolding to exist
  before any logic is written. Not the application logic that then fills it (`backend`,
  `frontend`), not the documentation-and-workflow layer (`scaffold`), not the CI pipeline
  (`cicd`), and not the tests (`test-writer`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django stack-htmx-templates
---

# Stand Up the Structure (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable scaffolding task whose output is directories,
config and wiring).

> **The project is already initialised.** This extends an existing monorepo. **Detect before you
> create:** read the target directory's `CONTEXT.md` and its neighbours, reuse the pattern that
> is there, and never re-scaffold what already exists.

---

## The brief arrives settled

A fork cannot ask, so the brief must name **what to create** — a Django app, a marketing route,
environment templates, a config file — and **its exact scope and location**. Where that is
open, the pass is `grilling`, run inline first.

## Scaffolding runs through the scripts, never by hand

| Task               | Command                                                             |
| ------------------ | ------------------------------------------------------------------- |
| New Django app     | `bash code/src/scripts/development/new-django-app.sh <app_name>`    |
| New marketing page | `bash code/src/scripts/development/new-django-view.sh <route_path>` |

**Never `manage.py startapp`, never `django-admin startapp`, and never a hand-created view,
template and URL entry.** The scripts wire the settings, the registration and the conventions —
and the hand-made version misses exactly the ones nothing checks for.

Pre-flight:

```bash
git status                                           # the branch is us###/short-description
bash code/src/scripts/development/server.sh status   # the dev stack's state
```

## Environment files

- **Only templates are committed** — `.env.dev.example`, `.env.staging.example`,
  `.env.production.example`, `.env.test.example` — with a separate database per environment.
- Copy to a real `.env.*` for local work only. **Never commit a real `.env`.**
- Every secret via an environment variable; `DEBUG=False` outside local;
  `CORS_ALLOWED_ORIGINS` an explicit allowlist, never `*`, in staging and production.

## Config files

The root config already exists — `pyproject.toml`, `eslint.config.mjs`, `.prettierrc`,
`lefthook.yml`, `pnpm-workspace.yaml`, `.nvmrc`, `.python-version` and the rest. **Edit in
place.** Add a new config file only when a genuinely new tool arrives, and record it in the root
`CONTEXT.md` tree. Docker and Compose live in `code/src/docker/`.

## Every new directory ships with its pair

A directory holding instructional documentation carries **both** a `CONTEXT.md` (orientation —
the tree and what is here) and a `CLAUDE.md` (operating rules — the import, the `Read order:`
line, then the four H2s). **Never a bare `@./CONTEXT.md` stub.** Update the parent
`CONTEXT.md`'s tree and its `Last Updated` date. The owning guide is
`code/docs/DOCUMENTATION-PAIRING.md`; where the work is the documentation layer itself rather
than a side-effect of standing up code, that is `scaffold`.

## Guardrails

- **Instructional `.md` files stay within 300 code lines**; source files within 750 (800 with
  grace). Split rather than sprawl.
- **Django's own admin is never mounted at `/admin/`** — that prefix is this project's admin
  area (`code/docs/URL-STRATEGY.md`).
- **Token-first CSS** — a new stylesheet consumes `var(--token)` only; new design values enter
  through the token layer or a migration, never as a raw literal.
- **Every command in documentation resolves to a script under `code/src/scripts/`** — never a
  raw package manager, `docker`, or `manage.py` invocation.
- Documentation and `CONTEXT.md` updates are complete **before any commit**. British English.

## Definition of done

The structure exists and matches its siblings; it was created by the script where one exists;
every new directory carries its documentation pair and appears in its parent's tree; no real
`.env` is committed and no secret is hardcoded; the length limits hold.

## Handoff

Report what was created, which script created it, and every new environment variable **by name
only**. Then name what is owed: `backend` for the models, services and endpoints, `frontend`
for the templates and components, `database` for the schema and migrations, `test-writer` for
the tests, `cicd` for the pipeline, `doc-writer` for documentation beyond the directory pair,
and `git` to commit.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/01-first-time-setup/` — clone, configure and first start
- `how-to/workflows/03-daily-development/` — the session loop this structure must support
- `how-to/workflows/02-worktree-setup/` — parallel-story worktrees

## Cross-references

- `code/docs/ARCHITECTURE-PATTERNS.md` — the module boundaries, and where new code belongs
- `code/docs/URL-STRATEGY.md` — the route, slug and admin-path conventions
- `code/docs/DOCUMENTATION-PAIRING.md` — the pair every new directory carries
- `code/docs/DESIGN-TOKENS.md` — the token layer a new stylesheet consumes
- `how-to/docs/DEVELOPMENT.md` — the dev environment the scripts drive
- `code/src/scripts/CONTEXT.md` — the scripts, and the conventions they share
- `how-to/docs/CLI-TOOLING.md` — the command surface a new script joins
- `how-to/docs/TOOLING-GUIDE.md` — the human index of what to type, and which skill answers it
