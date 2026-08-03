# Extending — Adding Your Own Pieces

**Last Updated**: 02/08/2026

How to add a Django app, a page, a workflow, an agent, a skill, or a guide — following the
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

`STEPS.md` and `CHECKLIST.md` carry routing frontmatter naming who does the work:

```yaml
---
workflow: 24-your-workflow
phase: implementation
agent: backend
skills: [stack-django, global-workflow]
model: opus
---
```

Then: **take the next free number — append.** Around a hundred files cite these paths, including
agent definitions, so a stale number is a silent routing failure.

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
`copier.yml` → `_migrations`, with the script in `.copier/migrations/`. Verify it with
`code/src/scripts/audits/template-orphans.sh`.

Then register the workflow in its `CONTEXT.md` and the root `REFERENCES.md`, and — if it pairs
with a workflow in another layer — add the row to the cross-layer pairing table in
`REFERENCES.md`.

Or ask the `scaffold` agent, which exists for exactly this.

## An agent

A single Markdown file in `.claude/agents/` with YAML frontmatter:

```yaml
---
name: your-agent
description: >
  One paragraph: what it does and, crucially, when to route to it. This is what
  Claude matches against, so be concrete about the trigger.
tools: Read, Write, Edit, Glob, Grep, Bash
model: opus
---
```

Then the body: remit, the workflow it follows, its guardrails, and its definition of done.

Conventions to keep:

- **Tool-scope it.** Only orchestrators carry all tools. A specialist that only writes docs gets
  `Read, Write, Edit, Glob`.
- **`fable` for planning and design; `opus` for everything else.** Never `sonnet` or `haiku`.
- **No agent reviews its own work** — if yours produces something, a different agent checks it.
- Register it in `.claude/agents/CONTEXT.md`.

## A skill

A directory under `.claude/skills/` containing `SKILL.md` with frontmatter:

```yaml
---
name: your-skill
description: >
  What it covers and exactly when to load it. Claude reads this to decide, so
  "load when X" phrasing works better than a topic summary.
---
```

Read `how-to/docs/SKILL-AUTHORING.md` first — it covers writing skills that behave predictably
rather than vaguely. Register the skill in `.claude/skills/CONTEXT.md` and, if it is broadly
useful, in the table in `.claude/CLAUDE.md` §2.4.

Skills can carry supporting files; reference them by path from `SKILL.md`.

> The four graph playbooks (`explore-codebase`, `debug-issue`, `review-changes`,
> `refactor-safely`) are **generated** by `code-review-graph install`. Never hand-edit them —
> they regenerate.

## A documentation guide

**Which kind matters, because it picks the owner and the length rule:**

| Kind                                                 | Owner              | Length               |
| ---------------------------------------------------- | ------------------ | -------------------- |
| Standards for writing code (`code/docs/`)            | `doc-writer`       | ≤ 300 lines          |
| Operating the system (`how-to/docs/`, `how-to/src/`) | `operator-docs`    | `src/` is **exempt** |
| End-user help for the product                        | `support-articles` | n/a                  |

For an operator guide, follow `how-to/workflows/09-write-operator-guide/` and load the `runbook`
skill. Its one hard rule is the one people skip: **execute the procedure start to finish before
publishing it** — a guide you have not run is a guess, and prose review will not find the
prerequisite you forgot to state.

Guides live in a layer's `docs/` and carry routing frontmatter:

```yaml
---
type: guide
agent: backend
skills: [stack-django]
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

**Python:**

```bash
# edit pyproject.toml, then
bash code/src/scripts/development/install-backend.sh --sync
```

**JavaScript** (repo tooling only — there is no client bundle):

```bash
bash code/src/scripts/development/install-frontend.sh --local
```

Commit the updated lockfile. `[2/8] Lockfile Alignment` in CI fails if the lock and manifest
disagree. Check the licence is compatible with your project's `LICENCE` answer.

## An MCP server you _consume_

Repo-scoped servers go in `.mcp.json` and are available to everyone who clones. Machine-global
servers are your own business. Document any new one in `.claude/CLAUDE.md` §3 so agents know it
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
5. Guard CI at **step** level on the directory existing, so the job reports success on both
   paths rather than skipping. Add the negative case to the generate matrix.
6. Document the tokens in `../TEMPLATE-TOKENS.md` and the choice in `05-ANSWERS.md`.

Verify by generating into `/tmp` **both ways** and diffing the trees. Everything except
`.copier-answers.yml` should be identical on the opted-out path.

## A development build (graduating from Expo Go)

The mobile skeleton ships on Expo Go, which only runs libraries already in the Expo SDK. The
first dependency with custom native code forces the graduation, and it is **your project's
decision, not the template's**:

1. Run `expo prebuild` to generate `ios/` and `android/`.
2. Decide whether they stay gitignored. Keeping them generated preserves the config-driven
   upgrade path; committing them means you now own native maintenance — and, if you still
   generate from this template, an exclusion entry for every binary they contain
   (`11-CUSTOMISING.md` → _Binaries_).
3. Record it as an ADR in `project-management/src/14-DECISIONS/`. It changes your upgrade story.

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
