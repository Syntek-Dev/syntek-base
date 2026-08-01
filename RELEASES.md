# Releases — {{PROJECT_NAME}}

**Last Updated**: {{DATE}} **Version**: 0.7.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v0.7.0 — 01/08/2026

**Status:** Documentation release — the code layer is re-documented and re-indexed

### Summary

Every guide under `code/docs/` is rewritten for the server-rendered Django stack, and the
instructional file-length rule is applied throughout: any guide over 300 code lines becomes a thin
index over a sub-folder of focused documents. Fourteen top-level guides now front sub-folders for
accessibility, API design, architecture, coding principles, data structures, design tokens,
encryption, logging, performance, rendering, responsive design, row-level security, security, and
testing. New guides cover the areas the stack change created — `DATABASE.md`, `DESIGN-TOKENS.md`,
`RENDERING.md`, `VISUAL-DESIGN.md`, the split backend and frontend coding principles, and the
code-review-graph playbooks. All ten code workflows gain `CLAUDE.md` operating rules.

### What's new since v0.6.0

- **Guides split, not truncated** — oversized guides become thin indexes over focused sub-documents, keeping every instructional file inside the 300-code-line limit
- **New stack guides** — database invariants and lock-safe migrations, the token-first design system, and the rendering decision boundary between template, HTMX, and Alpine
- **Code-review-graph playbooks** — explore, debug, review, and refactor procedures wired into the matching agents and workflows
- **Workflow operating rules** — every numbered code workflow carries a `CLAUDE.md` beside its `CONTEXT.md`

---

## v0.6.0 — 01/08/2026

**Status:** Feature release — the agent and skill surface moves from marketplace plugins into the repository

### Summary

The agent and skill surface previously came from two installed marketplace plugins. Those are now
disabled and their content lives in the repository, so a scaffolded project inherits a complete,
version-controlled Claude Code configuration with no external installation step. Fifty agents land
in two tiers — eight orchestrators that act as entry points, and the specialists and document
writers they delegate to. The skill library covers the stack, workflow, design, learning, and
document-standard skills. Hooks are consolidated into a single eight-gate pre-PR check plus a
pre-compact handoff interceptor, and the plugin directory is reduced to read-only inspection
helpers — dev operations belong to the shell scripts, not to plugins.

### What's new since v0.5.0

- **50 agents, two tiers** — orchestrators are the entry points and delegate scoped work to tool-scoped specialists and document writers
- **Skill library in-repo** — stack, workflow, design, learning, and document-standard skills load on demand with no marketplace dependency
- **Eight-gate pre-PR check** — lockfiles, lint, format, typecheck, stubs, tests and coverage, `cloc` limits, and a security audit
- **Handoff instead of compaction** — auto-compaction is disabled and intercepted; sessions write a committed handoff document and stop
- **Read-only plugins** — six inspection helpers gather context; they never run dev operations

---

## v0.5.0 — 01/08/2026

**Status:** Feature release — the API test suite becomes a template, not a fixture set

### Summary

A base template must ship the shape of a test suite without shipping anybody's domain. The Bruno
collections for authentication, orders, users, and performance are removed and replaced with one
annotated request template that new suites are copied from. Bruno environments are re-expressed as
native `.bru` files covering local, host, docker, staging, and production. Two runtime directories
gain their tracked scaffolding: `logs/` and a new `improvement-architecture/` scratch area whose
contents are git-ignored but whose orientation files are not.

### What's new since v0.4.0

- **One request template** — copy `template-test.bru` to start a suite; no invented domain endpoints to delete first
- **Five Bruno environments** — local, host, docker, staging, and production, in Bruno's native format
- **Runtime scaffolding** — `logs/` and `improvement-architecture/` carry tracked orientation files and ignored contents

---

## v0.4.0 — 01/08/2026

**Status:** Feature release — the script surface is the only supported way to run dev operations

### Summary

Every developer operation in this template runs through `code/src/scripts/**/*.sh` — never a raw
`pnpm`, `pytest`, `python`, or `docker` invocation. This release rewrites that surface for the
single-stack monolith. Existing runners are re-pointed from `code/src/backend/` to
`code/src/django/`; the frontend and mobile runners are deleted; and a new audit family, project
scaffolding scripts, and worktree helpers are added. Generated test reports stop being tracked.

### What's new since v0.3.0

- **Audit family** — a design-token audit that fails any component CSS carrying a raw literal, plus gradient, copy, and security audits, each wired to a CI workflow in 0.10.0
- **Page scaffolding** — `new-django-view.sh` creates view, template, and URL entry together so page routes are never hand-assembled
- **Worktree support** — `worktree-detect.sh` and the hosts helpers let several stories run side by side with isolated Docker stacks
- **Reports untracked** — test output is generated, never committed

---

## v0.3.0 — 01/08/2026

**Status:** Breaking change to the stack — the Django project bundle becomes the single application root

### Summary

Second half of the stack replacement. `code/src/backend/` becomes `code/src/django/`: with no
JavaScript client left, the Django project is no longer a _backend_ — it is the whole application,
serving its own templates, components, and HTMX partials. The rename runs through the Docker
images, Compose files, Nginx configuration, and the four environment templates. The django bundle
is registered as the repository's only versioned sub-package, starting at its own `0.1.0` baseline
with the three version files the versioning guide requires alongside every package manifest.

### What's new since v0.2.0

- **`code/src/django/`** — one application root: settings split four ways (dev, test, staging, production), ASGI and WSGI entry points, an `apps/` namespace, and template and static roots
- **django sub-package versioning** — the bundle carries its own `CHANGELOG.md`, `VERSION-HISTORY.md`, and `RELEASES.md` at `0.1.0`, moving independently of the root track
- **Docker re-pointed** — `docker/django/` images for all four environments, PostgreSQL dev tuning, and example Compose overlays for per-story worktrees
- **TypeScript shared package removed** — nothing consumes it once both JavaScript clients are gone

---

## v0.2.0 — 01/08/2026

**Status:** Breaking change to the stack — the JavaScript client layers are removed

### Summary

First half of the stack replacement. The template drops both JavaScript client layers: the
Next.js/React web frontend and the Expo React Native mobile application, together with their
Docker images and CI pipelines. Nothing replaces them in this release — the server-rendered
Django presentation layer arrives with the `django` package in 0.3.0. Removing the client layers
first keeps the change reviewable: this release is purely subtractive.

### What's new since v0.1.0

- **No JavaScript client layers** — the React/Next frontend and React Native mobile app are gone; the template targets a single Django monolith
- **Docker surface reduced** — frontend and mobile images are removed from the Compose stack
- **CI trimmed** — the two front-end test pipelines are deleted; the remaining workflows are re-pointed in 0.10.0

---

## v0.1.0 — 01/08/2026

**Status:** Baseline release — the repository becomes a reusable base template

### Summary

Opens the `{{PROJECT_SLUG}}-base` template track. The repository stops being a single delivered
project and becomes the scaffold other projects are generated from, so the root version track is
reset from `1.11.0` to `0.1.0` and the release documents are truncated to a clean baseline. The
pre-template 1.x history remains available in git history and is deliberately not back-filled here.
`.gitignore` is widened to cover the artefacts a template must never carry — generated test
reports, the resolved Python lockfile, worktree checkouts, and local tooling overrides.

### What's new

- **Template version track** — root semver restarts at `0.1.0`; sub-packages version independently from their own `0.1.0` baseline, per `project-management/docs/VERSIONING-GUIDE.md`
- **Clean release documents** — `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` now describe the template, not the project it grew out of
- **Wider `.gitignore`** — generated test reports, the Python lockfile, worktree checkouts, and local tooling overrides are excluded so a scaffolded project starts from a clean tree
