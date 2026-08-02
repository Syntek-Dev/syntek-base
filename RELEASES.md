# Releases — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.12.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v0.12.0 — 02/08/2026

**Status:** Feature release — the template becomes installable, updatable, and open source

### Summary

Three things change together, and they reinforce each other.

**Scaffolding moves to [Copier](https://copier.readthedocs.io/).** `setup.sh` did literal string
substitution and then severed the connection: a project generated from the template could never
receive a later fix. Copier keeps the link. A generated project carries `.copier-answers.yml`
recording the source, the commit and every answer, and `copier update` three-way-merges upstream
improvements against local edits. That single capability — fix once, propagate everywhere — is the
whole reason for the migration, and it is the one thing that could not have been bolted on later.

The move forced a delimiter change. Copier renders through Jinja2, and its default double-brace
delimiters collide with four things already in this repository: GitHub Actions expressions, Django
template syntax, Bruno variables, and — for the obvious double-square-bracket alternative — bash
test syntax, of which there are over three hundred instances in the project scripts. A bespoke set
of variable, block and comment delimiters replaces them, each verified to appear nowhere in the
tree before being adopted. The set and the full reasoning are in
`how-to/src/TEMPLATE-TOKENS.md`.

**The repository becomes properly open source.** MIT, with a `LICENSE`, a `SECURITY.md`
disclosure policy, a contributor guide, CODEOWNERS, issue and pull-request templates, and branch
protection on `main`. Version 0.10.0 retired the licence on the reasoning that a template should
not choose one for the project generated from it — that reasoning was sound but the conclusion was
wrong. MIT covers the template; `<%LICENCE%>` remains a question, so a generated project still
picks its own, and proprietary is still the default answer.

**The documentation catches up.** `how-to/src/TEMPLATE-GUIDE/` is fourteen numbered guides taking
a reader from "should I use this at all" through generation, orientation, the first story,
customisation, deployment and updating. The root README stops impersonating a shipped product and
describes the template — 1160 lines down to 140.

### What's new since v0.11.0

- **One-command generation** — `uvx copier copy gh:Syntek-Dev/syntek-base my-project`
- **`copier update`** — pull later template fixes into projects already built from it
- **MIT licence, `SECURITY.md`, `CONTRIBUTING.md`, CODEOWNERS, issue and PR templates**
- **Branch protection on `main`** — PR required, conversation resolution required, force-push and deletion blocked, eleven required checks, admin bypass retained
- **Two new CI gates** — token-syntax integrity, and a generation smoke test that builds a real project on every pull request
- **Fourteen template guides** plus a contributing standard split out of `how-to/src/CONTEXT.md`
- **Platform-aware `install.sh`** — Linux, macOS (Docker Desktop or Colima), WSL 2; rejects native Windows shells and warns on WSL 1 and `/mnt/c` checkouts
- **Provider-neutral deployment docs** — any Linux host with Docker works; Hetzner, NixOS and Cloudflare are the documented target, not a requirement
- **Grilling versus wayfinder** explained, with the rule for choosing between them

### Upgrading an existing project

There is no automatic path from a `setup.sh`-generated project. Those projects have no
`.copier-answers.yml` and cannot be updated. Recreate the file by hand from a fresh generation's
format, filling in your values with `_src_path` and `_commit`, and `copier update` will work from
there. `how-to/src/TEMPLATE-GUIDE/13-UPDATING.md` covers it.

### Known requirements

The agent suite routes across two model tiers and uses Fable for planning and design work, so it
assumes **Claude Max 20× or above, or the Anthropic API**. On a smaller plan, or another provider,
retarget the `model:` frontmatter — the documentation system and gates are provider-agnostic.

---

## v0.11.0 — 01/08/2026

**Status:** Patch release — the root orientation file returns

### Summary

Retiring the root `CONTEXT.md` in 0.10.0 went a step too far. `.claude/CLAUDE.md` imports it with
`@../CONTEXT.md` on line 6, so every session since has loaded a file that no longer existed — the
project lost its top-level orientation just as the layered structure grew to justify it. The file is
back, rewritten for what the repository now is: a Django-only monolith distributed as a reusable base
template, not the Django + Next.js + React Native monorepo the old version described.

It carries the current directory tree, the layer map, the starting points for each kind of work, the
conventions that govern the `CONTEXT.md`/`CLAUDE.md` pairing, and the repository state. The one
documented exception to that pairing is recorded in place: the root has no `CLAUDE.md` because
`code-review-graph install` generates one there and the repository gitignores it — `.claude/CLAUDE.md`
is the root's operating-rules counterpart.

### What's new since v0.10.0

- **Root `CONTEXT.md` reinstated** — directory tree, layer map, starting points, conventions, repository state
- **Broken session import repaired** — `@../CONTEXT.md` in `.claude/CLAUDE.md` resolves again
- **Template instantiation signposted from the root** — the overview points at `setup.sh` and the token contract, and the note removes itself once the template is instantiated

---

## v0.10.0 — 01/08/2026

**Status:** Feature release — the templatisation completes and CI covers the new audits

### Summary

The final batch closes the conversion. Every hardcoded project identifier at the repository root
becomes a substitution placeholder — `<%PROJECT_NAME%>`, `<%PROJECT_SLUG%>`, `<%ORG_NAME%>`,
`<%LOCALE%>`, `<%TIMEZONE%>`, `<%CURRENCY%>`, `<%LICENCE%>` — and an `install.sh`/`setup.sh` pair
resolves them when a project is scaffolded. CI gains six audit workflows matching the audit scripts
added in 0.4.0, plus a ClickUp sync pipeline, while the frontend and mobile pipelines are gone. Three
session sandboxes are established — `handoffs/` for the compaction replacement, `learning/` for the
teaching skill, and `research/` for cited primary-source notes. `REFERENCES.md` becomes the root
index, and the root `CONTEXT.md` and `LICENCE` are retired: a template does not pick a licence for
the project generated from it.

### What's new since v0.9.0

- **Placeholders throughout** — every project identifier is a substitution token resolved by `setup.sh` when a project is scaffolded
- **Six audit pipelines** — design tokens, CSS gradients, copy, secrets, and dependencies now fail CI, matching the audit scripts
- **Session sandboxes** — `handoffs/`, `learning/`, and `research/` give the handoff, teach, and research skills a committed home
- **Licence deferred to the consumer** — the template ships `<%LICENCE%>`, not a decision

---

## v0.9.0 — 01/08/2026

**Status:** Documentation release — setup, tooling, and deployment sizing guidance

### Summary

The how-to layer is rewritten for the Django-only stack and extended with the material a developer
needs that is neither code nor project management. Two new sub-folder guides land: an AI dictionary
giving plain-English definitions for the agent-coding vocabulary, and a tooling guide covering the
internal agents, skills, commands, and configuration. A fourth workflow documents git worktree
setup for parallel stories. Two architecture folders — `SCALE-ARCHITECTURE/` and
`SERVER-ARCHITECTURE/` — carry the sizing envelope, load profiles, readiness criteria, and compute
allocation that feed the separate NixOS deployment repository. The narrow contributor guides that
duplicated the PM layer are removed rather than maintained twice.

### What's new since v0.8.0

- **AI dictionary** — the agent-coding vocabulary in plain English, split across seven focused documents
- **Tooling guide** — what each internal agent and skill does, and how the configuration fits together
- **Worktree workflow** — run several stories in parallel with isolated Docker stacks and loopback hosts
- **Deployment sizing** — load profiles, a sizing envelope, and readiness criteria that hand off to the NixOS deployment repository
- **Duplication removed** — narrow contributor guides gave way to the authoritative code and PM guides

---

## v0.8.0 — 01/08/2026

**Status:** Documentation release — the PM layer is restructured into three tiers

### Summary

The project-management layer is restructured around three explicit tiers: specify (`01`–`12`),
decide and plan (`13`–`15`), and record (`16`–`20`). Artefact folders and workflows are renumbered
to match, with new slots for API design, SEO, decisions, sprint plans, and story plans — the story
plan is now the master document a developer codes from. Workflows extend to 21, adding
implementation documentation as a hard gate before the PR, and a release procedure at the end.
Every guide is rewritten for the Django-only stack, `GDPR-GUIDE.md` is split into a sub-folder,
and the domain-specific example artefacts are cleared so the template ships templates, not data.

### What's new since v0.7.0

- **Three tiers, explicitly numbered** — specify (01–12) → decide and plan (13–15) → record (16–20), with the story plan as the code master
- **Workflows to 21** — API design, decisions, sprint and story plans, three implementation phases, implementation documentation, PR and review, and release
- **Documentation is a hard gate** — `19-implementation-documentation` must be complete, with the code-review-graph refreshed, before a commit is allowed
- **No project data** — example artefacts and organisation assets are cleared; what ships is the structure and the templates

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

Opens the `<%PROJECT_SLUG%>-base` template track. The repository stops being a single delivered
project and becomes the scaffold other projects are generated from, so the root version track is
reset from `1.11.0` to `0.1.0` and the release documents are truncated to a clean baseline. The
pre-template 1.x history remains available in git history and is deliberately not back-filled here.
`.gitignore` is widened to cover the artefacts a template must never carry — generated test
reports, the resolved Python lockfile, worktree checkouts, and local tooling overrides.

### What's new

- **Template version track** — root semver restarts at `0.1.0`; sub-packages version independently from their own `0.1.0` baseline, per `project-management/docs/VERSIONING-GUIDE.md`
- **Clean release documents** — `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` now describe the template, not the project it grew out of
- **Wider `.gitignore`** — generated test reports, the Python lockfile, worktree checkouts, and local tooling overrides are excluded so a scaffolded project starts from a clean tree
