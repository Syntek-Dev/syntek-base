# Extending — Adding Your Own Pieces

**Last Updated**: 14/08/2026

How to add a Django app, a page, a workflow, a skill, or a guide — following the
conventions so the rest of the system keeps working.

---

## A Django app

```bash
bash code/src/scripts/development/new-django-app.sh <app_name>
```

Never `manage.py startapp` or `django-admin startapp`. The script creates the per-model-file
structure, the tests directory, and the `CONTEXT.md`/`CLAUDE.md` pair the documentation gate
requires — the bare Django command creates none of it.

Afterwards: add it to `INSTALLED_APPS`, and update the tree in `code/src/django/CONTEXT.md`.

## A public page

```bash
bash code/src/scripts/development/new-django-view.sh <route_path>
```

Creates the view, template and URL entry together. Hand-creating page routes is explicitly
disallowed — the script keeps the SEO wiring and URL conventions consistent.

Then work through `project-management/docs/SEO-CHECKLIST.md` before the page ships.

## A workflow

Workflows are numbered directories in a layer's `workflows/`, each containing four files:

```text
project-management/workflows/24-your-workflow/
├── CONTEXT.md      ← when to use it, prerequisites, key concepts
├── CLAUDE.md       ← operating rules
├── STEPS.md        ← the ordered procedure
└── CHECKLIST.md    ← verification before it can be called done
```

`STEPS.md` and `CHECKLIST.md` carry routing frontmatter naming the skills that do the work:

```yaml
---
workflow: 24-your-workflow
phase: implementation
skills: [backend, stack-django, global-workflow]
model: opus
---
```

`skills:` leads with the skill that owns the remit and lists what it loads after; there is no
`agent:` key. Every name must resolve to a `.claude/skills/<name>/` directory —
`code/src/scripts/audits/routing-skills.sh` fails one that does not.

Then: **take the next free number — append.** Around a hundred files cite these paths, including
skill definitions, so a stale number is a silent routing failure.

The three trees do not treat numbers the same way, and the difference matters:

| Tree                            | Numbers are…                           | Inserting mid-sequence                                                  |
| ------------------------------- | -------------------------------------- | ----------------------------------------------------------------------- |
| `code/workflows/`               | stable identifiers, a shelf position   | Never. Append and regroup via the family tables                         |
| `how-to/workflows/`             | stable identifiers, a shelf position   | Never. Append and regroup via the family tables                         |
| `project-management/workflows/` | a **running order** — `02` before `03` | Legitimate, but renumbers everything after it and every reference to it |
| `project-management/src/`       | **frozen — append only**               | **Never, under any circumstances.** See below                           |

For the first two, group by editing the family tables in the layer's `workflows/CONTEXT.md`, which
cost nothing to reorder — `code/workflows/` runs build → verify → diagnose, `how-to/workflows/`
runs set up → run → diagnose → author.

### Never renumber a `src/` folder

`project-management/workflows/` folders are documentation the template owns end to end, so
renumbering one is a reference sweep and the worst case is a broken link.

`project-management/src/NN-…/` folders hold **artefacts a developer wrote**. Renumbering one is a
schema migration, and **Copier cannot perform it**: on `copier update` it moves the scaffolding it
owns to the new path and deletes the old, while every story, ADR and sprint record stays behind in
a folder nothing references. No conflict, no error, update reports success, work silently
orphaned.

So a new artefact folder takes the next free number **at the end**, even where that breaks the
workflow↔`src` mirroring. The mirroring is a convenience; somebody's work is not.

If a release genuinely must move such a directory, it ships a migration in the same commit —
`copier.yml` → `_migrations`, with the script in `.copier/migrations/`. Verify it with <!-- doc-references: template-only -->
`code/src/scripts/audits/template-orphans.sh`.

Then register the workflow in its `CONTEXT.md` and the root `REFERENCES.md`, and — if it pairs
with a workflow in another layer — add the row to the cross-layer pairing table in
`REFERENCES.md`.

Or load the `scaffold` skill, which exists for exactly this.

## A skill

A directory under `.claude/skills/` containing `SKILL.md` with frontmatter:

```yaml
---
name: your-skill
description: >-
  What it covers and exactly when to load it. Claude reads this to decide, so
  "load when X" phrasing works better than a topic summary.
---
```

That is a **reference** skill — it states conventions and runs inline, and needs nothing beyond
`name` and `description`. A **task** skill is an executable procedure, and adds a `model:` plus a
`metadata.skills` list of what it loads. A task skill that **forks** adds three keys on top:

```yaml
context: fork
agent: general-purpose
background: false
```

It forks unless its input is the conversation itself — `implement-story` and `bugfix` run inline and
dispatch each phase, because the request, its scope and its trade-offs only exist in the thread.
Which one yours is, and why the fork target is fixed:
`how-to/docs/skill-authoring/FORK-DECISION.md`.

Conventions to keep:

- **`fable` for planning and design; `opus` for everything else.** Never `sonnet` or `haiku`.
- **No skill reviews its own work.** Where yours produces something that needs an independent
  check, it dispatches `general-purpose` through the Agent tool and names the skill to load in
  the prompt, so each pass runs as its own dispatch. Nothing in the runtime enforces the
  separation — the skill has to ask for it.
- Register it in `.claude/skills/CONTEXT.md` — the one roster; nothing summarises it in
  `.claude/CLAUDE.md`.

> **There is no "add an agent" step.** Every remit is a skill, and `agent:` names a fork target
> from `Explore` / `Plan` / `general-purpose` — `code/src/scripts/audits/skill-conformance.sh`
> fails any other value, so the door is shut in code rather than by convention. It reopens only
> on the named test in `FORK-DECISION.md`: evidence that a named skill needs a durable capability
> no built-in target provides. "It would be tidier as an agent" is not evidence.

Read `how-to/docs/SKILL-AUTHORING.md` first — it covers writing skills that behave predictably
rather than vaguely, and the `## Governing procedures` section the gate expects.

Skills can carry supporting files; reference them by path from `SKILL.md`.

> The four graph playbooks (`explore-codebase`, `debug-issue`, `review-changes`,
> `refactor-safely`) are **generated** by `code-review-graph install`. Never hand-edit them —
> they regenerate.

## A documentation guide

**Which kind matters, because it picks the owner and the length rule:**

| Kind                                                 | Owning skill       | Length               |
| ---------------------------------------------------- | ------------------ | -------------------- |
| Standards for writing code (`code/docs/`)            | `doc-writer`       | ≤ 300 lines          |
| Operating the system (`how-to/docs/`, `how-to/src/`) | `runbook`          | `src/` is **exempt** |
| End-user help for the product                        | `support-articles` | n/a                  |

For an operator guide, follow `how-to/workflows/09-write-operator-guide/`. Its one hard rule is
the one people skip: **execute the procedure start to finish before publishing it** — a guide you
have not run is a guess, and prose review will not find the prerequisite you forgot to state.

Guides live in a layer's `docs/` and carry routing frontmatter:

```yaml
---
type: guide
skills: [backend, stack-django]
model: opus
---
```

Rules:

- **Under 300 lines.** Over that, split into a sub-directory and leave a thin index — the pattern
  `code/docs/SECURITY.md` and `code/docs/security/` already demonstrates.
- Register it in the layer `docs/CONTEXT.md`, the layer `REFERENCES.md`, and the root
  `REFERENCES.md`.
- British English.

## A dependency

`code/src/scripts/dependencies/update.sh` is the **single sanctioned entry point**, and it puts
one command and one exit-code contract over all three ecosystems — Python (uv), JavaScript (pnpm)
and Rust (cargo):

```bash
bash code/src/scripts/dependencies/update.sh                             # what is out of date
bash code/src/scripts/dependencies/update.sh --apply --package <name>    # one package
bash code/src/scripts/dependencies/update.sh --apply --ecosystem python  # one ecosystem
bash code/src/scripts/dependencies/update.sh --apply                     # everything
```

To add rather than upgrade one, edit `pyproject.toml` or the relevant `package.json` and sync:

```bash
bash code/src/scripts/development/install-backend.sh --sync
bash code/src/scripts/development/install-frontend.sh --local   # repo tooling; no client bundle
```

**A floor is not a pin.** Raising `redis>=5.0.0` to `redis>=6.0` does not install redis 6, it
forbids redis 5 — what you actually get is decided by the lockfile, and by what the rest of your
graph tolerates. Raise a floor deliberately and re-resolve in the same change.

Commit the updated lockfile: `[2/8] Lockfile alignment` in the pre-PR gate fails when the lock
and the manifest disagree. Check the licence is compatible with your project's `LICENCE` answer.
Full procedure: `how-to/workflows/07-dependency-updates/`.

## An MCP server you _consume_

Repo-scoped servers go in `.mcp.json` and are available to everyone who clones. Machine-global
servers are your own business. Document any new one in `.claude/CLAUDE.md` Section 3 so Claude knows it
exists.

## An MCP server you _serve_

The opposite direction — letting an LLM agent call **your** domain operations — is a FastMCP tool
surface at `/mcp/`, and it is a different thing entirely. It is designed but deliberately
unwired: `fastmcp` is not a declared dependency and nothing is mounted. Follow
`code/workflows/05-mcp-server/`, which opens by asking whether an agent is genuinely the caller —
a plain Ninja endpoint is already callable by anything that speaks HTTP. Guide:
`code/docs/MCP-SERVER.md`.

## An optional subtree

If a piece should ship only when the user opts in, gate it the way the mobile surface is gated —
**a templated `_exclude` entry, and nothing else** (`11-CUSTOMISING.md` has the full reasoning).

1. Add the boolean question to `copier.yml`, defaulting to **false**, so an existing project
   pulling `copier update` gets no surprise.
2. Add one `_exclude` entry per top-level path the feature owns. Keep the count low — a single
   directory per concern removes cleanly; a `feature-*` glob scattered across four directories
   fails silently the day someone misses one.
3. Give dependent questions a `when:` so they are asked only if the boolean is true.
4. Touch shared files with **inert no-ops only** — never templated contents. An ignore entry, a
   glob, an added file extension. Each must cost a project that opted out exactly nothing.
5. **Gate the governance with the tree.** Any skill scoped to the surface goes in the same
   `_exclude` block — a skill fires on description match, so one with nothing to work on competes
   for work it cannot do. Its row in `.claude/skills/CONTEXT.md` stays, flagged; the index row is
   allowed to dangle, because the alternative is templated file contents.
6. **A CI job travels with the script it runs.** Guard at **step** level where the job is shared,
   and exclude the workflow outright where it is not — a workflow shipped without its script is a
   permanently-red job on every project that opted out, which a generated baseline must never
   carry. Add the negative case to `audit-template.yml`'s generate loop.
7. Document the tokens in `../TEMPLATE-TOKENS.md` and the choice in `05-ANSWERS.md`.

Verify by generating into `/tmp` **both ways** and diffing the trees. Everything except
`.copier-answers.yml` should be identical on the opted-out path. `audit-template.yml` does this
on every pull request — a shell loop over both values rather than a job matrix, because a matrix
needs GitHub expression syntax and that file must not contain any.

## A development build (graduating from Expo Go)

The mobile skeleton ships on Expo Go, which only runs libraries already in the Expo SDK. The
first dependency with custom native code forces the graduation, and it is **your project's
decision, not the template's**:

1. Run `expo prebuild` to generate `ios/` and `android/`.
2. Decide whether they stay gitignored. Keeping them generated preserves the config-driven
   upgrade path; committing them means you now own native maintenance — and, if you still
   generate from this template, an exclusion entry for every binary they contain
   (`11-CUSTOMISING.md` → _Binaries_).
3. Record it as an ADR in `project-management/src/15-DECISIONS/`. It changes your upgrade story.

iOS development builds need macOS or a paid cloud build service; neither is assumed here.

---

## The checklist for anything new

1. Does every new directory have **both** `CONTEXT.md` and `CLAUDE.md`?
2. Is the parent `CONTEXT.md` tree updated?
3. Is it registered in the relevant `REFERENCES.md`?
4. If instructional, is it under 300 lines?
5. Does it carry routing frontmatter, if it is a guide or workflow file?
6. British English?
7. Do all developer commands resolve to `code/src/scripts/**`?
8. Have you refreshed the code-review-graph (`code-review-graph update`)?

Points 1–7 are the documentation hard gate, and it is checked before commit — not optional.

---

## Next

- What not to change → `11-CUSTOMISING.md`
- Contributing it back to the template → the root `CONTRIBUTING.md`
