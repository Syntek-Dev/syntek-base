# Generation — What Copier Actually Does

**Last Updated**: 14/08/2026

A precise account of what happens between running `copier copy` and having a project. Read this
when something went wrong, when you are reviewing a change to `copier.yml`, or when you simply
want to know what ran on your machine.

---

## The pipeline

```text
1. fetch template        git clone of the template at the requested ref
2. ask questions         34 prompts (+4 conditional), defaults and validators from copier.yml
3. render                every non-excluded file through Jinja2, custom delimiters
4. write                 tree written to the destination
5. record answers        .copier-answers.yml, including _src_path and _commit
6. run _tasks            4 post-generation commands
```

`copier update` runs a different tail: no `_tasks` at all, and instead the `_migrations` at the
bottom of `copier.yml` — see _Migrations_ below.

## 1 — Fetch

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
```

Copier resolves `gh:` to GitHub and, by default, generates from the **latest git tag** — not from
`main`. That matters: an untagged template generates from `HEAD`, but once tags exist you get the
last released one.

To pin or override:

```bash
copier copy --vcs-ref=v3.1.1 gh:Syntek-Dev/syntek-base my-project   # a specific tag
copier copy --vcs-ref=HEAD   gh:Syntek-Dev/syntek-base my-project   # tip of the default branch
```

## 2 — Questions

Thirty-eight, defined in `copier.yml` — thirty-four always asked, four conditional on the
optional surfaces (`MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` on `INCLUDE_MOBILE`,
`INCLUDE_DESKTOP` on `INCLUDE_RUST`, `DESKTOP_APP_NAME` on `INCLUDE_DESKTOP`). Three behaviours
worth knowing:

- **Derived defaults** — `PROJECT_SLUG` from `PROJECT_NAME`, `ORG_SLUG` from `ORG_NAME`,
  `ENV_PREFIX` from `ORG_SLUG`, `PRIMARY_DOMAIN` and `DEPLOY_REPO` from `PROJECT_SLUG`,
  `MOBILE_BUNDLE_ID` from `PRIMARY_DOMAIN` reversed.
- **Validators** — slugs must be kebab-case, `ENV_PREFIX` upper-snake, `CURRENCY` three upper
  letters, `DATE` `DD/MM/YYYY`, email must contain `@`, `SPRINT_GRACE_SP` must exceed
  `SPRINT_CAPACITY_SP`, `MOBILE_BUNDLE_ID` must be reverse-domain form, and
  `PROJECT_DESCRIPTION` must be at least forty characters with no double quotes. A bad answer
  re-prompts.
- **`--defaults`** takes every default without asking; combine with `--data KEY=value` for the
  six questions that have no default — `PROJECT_NAME`, `PROJECT_DESCRIPTION`, `ORG_NAME`,
  `DEVELOPER_NAME`, `DEVELOPER_EMAIL`, `DATE`.

## 3 — Render

**Every file is a template.** `copier.yml` sets `_templates_suffix: ""`, so there is no `.jinja`
suffix convention — the whole tree goes through Jinja2 and files containing no tokens pass through
byte-identical.

### The delimiters

<: raw :>

| Purpose  | Opens | Closes |
| -------- | ----- | ------ |
| Variable | `<%`  | `%>`   |
| Block    | `<:`  | `:>`   |
| Comment  | `<~`  | `~>`   |

<: endraw :>

Not `{{ }}`. The repository already contains four dialects that collide with Jinja's defaults:

| Already in the tree                     | Count                 | What `{{ }}` would do      |
| --------------------------------------- | --------------------- | -------------------------- |
| `${{ github.* }}`                       | ~110 across workflows | rendered away, leaving `$` |
| `{% … %}` Django tags                   | ~45 files             | parsed as Jinja, or error  |
| `{{ field.label }}`, `{{ csrf_token }}` | docs examples         | silently blanked           |
| `{{api_url}}` Bruno variables           | `.bru` files          | silently blanked           |

`[[ ]]` was rejected too — it is bash test syntax, and appears over 700 times in the project
scripts. The chosen set was verified to appear nowhere in the tree.

Those counts only grow, which is the point: the delimiters were chosen so that **no future file
can collide by being ordinary.** <: raw :>A literal `<%`, `<:` or `<~`<: endraw :> reaching the
tree is a `TemplateSyntaxError` at generation, and the fix is a `raw` block
(`15-TROUBLESHOOTING.md`).

### Excluded from rendering

Files belonging to the template itself never reach your project. There are five groups, and the
reason differs in each:

| Group                       | Entries                                                                                                                                                       |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The template's own docs** | `copier.yml` · `LICENSE` · `SECURITY.md` · `CONTRIBUTING.md` · `README.md` · `how-to/src/TEMPLATE-GUIDE/` · `how-to/src/TEMPLATE-TOKENS.md`                   |
| **Template-only CI**        | `.github/CODEOWNERS` · `.github/ISSUE_TEMPLATE` · `.github/PULL_REQUEST_TEMPLATE.md` · `.github/scripts` · `.github/workflows/audit-template.yml`             |
| **Seeded state**            | `VERSION` · `VERSION-HISTORY.md` · `CHANGELOG.md` · `RELEASES.md` · `.claude/MEMORY.md` · `.copier/migrations` — each re-supplied from `.copier/` (see below) |
| **Repo-local overrides**    | the nested `.gitignore` files under `handoffs/`, `project-management/src/`, `research/`, `questionnaires/`, `learning/`                                       |
| **Opt-out surfaces**        | the mobile, Rust and desktop trees, their scripts, guides, workflows, CI jobs and stack skills — gated by a templated entry (see `11-CUSTOMISING.md`)         |
| **Never a checkout**        | `*.pdf` · `node_modules` · `.code-review-graph` · `.venv` · `__pycache__` · `*.py[co]` · `.DS_Store`                                                          |

Three notes:

- **Patterns are gitignore-style**, so they are root-anchored with a leading slash where they must
  be. Without it, `README.md` would also match `.copier/README.md` and `CONTRIBUTING.md` would
  swallow `how-to/src/CONTRIBUTING.md`, which your project needs.
- **PDFs are excluded because they are binary.** With `_templates_suffix: ""` Copier attempts to
  render everything, and binary content is not decodable. The excluded PDFs are generated
  artefacts — the brand guide and component sheet — which your project rebuilds from the sources
  beside them.
- **Version state and project memory are excluded and then re-seeded**, rather than shipped
  directly. A project must start at `0.1.0` with an empty changelog and an empty
  `.claude/MEMORY.md`, not inherit the template's release history and internal notes — and
  because `_tasks` run on `copy` and never on `update`, seeding them this way is what stops a
  later `copier update` handing your project the template's changelog or a blank memory file.

## 4 — Write

The rendered tree lands in your destination directory, including a staging directory `.copier/`
holding the seven seed files a task then moves into place and removes.

## 5 — Record answers

`.copier-answers.yml` is written with every answer plus `_src_path` and `_commit`.

**Commit this file.** It is what makes `copier update` possible — without it a project is severed
from the template and upstream fixes have to be applied by hand. See `14-UPDATING.md`.

## 6 — Post-generation tasks

Four, all visible at the bottom of `copier.yml`. Copier requires `--trust` (or an interactive
confirmation) because these execute on your machine.

| #   | Task                                       | Why                                                                                                 |
| --- | ------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| 1   | empty `.copier/` into place, then `rmdir`  | Seeds the seven files below, since the repo-root originals belong to the template.                  |
| 2   | strip the `uv.lock` rule from `.gitignore` | The template ignores the lock; a generated project **must** commit it.                              |
| 3   | `uv lock` (non-fatal)                      | Creates the lockfile every Dockerfile needs. Prints a warning instead of failing if `uv` is absent. |
| 4   | `git init --initial-branch=main`           | Starts history. Skipped on `copier update`.                                                         |

Task 1 moves seven files:

```text
.copier/README.md              →  README.md
.copier/VERSION                →  VERSION                     (0.1.0)
.copier/VERSION-HISTORY.md     →  VERSION-HISTORY.md          (empty)
.copier/CHANGELOG.md           →  CHANGELOG.md                (empty)
.copier/RELEASES.md            →  RELEASES.md                 (empty)
.copier/MEMORY.md              →  .claude/MEMORY.md           (headings and rules, no entries)
.copier/MAP-SCALE-PLANNING.md  →  project-management/src/01-FEATURE/MAP-SCALE-PLANNING.md
```

The last one exists because six shipped guides cite that map, and a citation resolving to nothing
is the defect `code/src/scripts/audits/doc-references.sh` exists to catch — so the project starts
with the map present and every row reading `TBD`.

Tasks 1, 2 and 4 are guarded by `when: _copier_operation == 'copy'` so they run on first
generation only, never on update. **That guard is the whole point of the `.copier/` staging
directory**: because an update never re-runs them, it can never overwrite your changelog,
your release history or your accumulated project memory with the template's.

## Migrations — what runs on `update` instead

`_migrations` run on `copier update` only, and only when the update crosses the declared version.
They exist for the one thing Copier's merge cannot do on its own: **move files the developer
wrote.** Copier tracks only what it generated, so a renumbered directory takes its scaffolding to
the new path and strands every hand-written artefact, with no conflict and no error
(`14-UPDATING.md`).

| Version   | What it does                                                                                                       |
| --------- | ------------------------------------------------------------------------------------------------------------------ |
| `v2.0.0`  | Renumbers the `project-management/src/` folders, carrying your stories, ADRs and sprint records with them.         |
| `v3.0.0`  | **Advisory only.** Reports any agent definition you wrote yourself in the now-deleted `.claude/agents/`.           |
| _(every)_ | `rm -rf .copier` — the staging directory is not project content, and `_tasks` do not run on an update to clear it. |

The last has no `version:` on purpose: it must hold for every future release that stages a file
that way, and `rm -rf` on a normally-absent directory is a no-op.

The rule this implies for anyone changing the template: **any release that moves a directory
holding developer artefacts ships a migration in the same commit, or it silently eats work.**

### Why `uv.lock` is not shipped

A lockfile pins the root project _by name_, and until Copier renders the tree that name is the
literal <: raw :>`<%PROJECT_SLUG%>`<: endraw :> — not a valid PEP 508 package name. No lock can be generated against
the unrendered template, and a shipped one would carry the previous project's name. Every
Dockerfile does `COPY pyproject.toml uv.lock ./` and builds with `uv sync --frozen`, so **the
Docker build fails until the lock exists**.

If task 3 warned that `uv` was missing, install uv and run `uv lock` at the project root before
your first build.

---

## Verifying a generation

<: raw :>

```bash
grep -rIo '<%[A-Z_]*%>' . --exclude-dir=.git | wc -l    # 0
test -f README.md && test -f uv.lock && test -f .copier-answers.yml && echo ok
grep -c '^uv\.lock$' .gitignore                          # 0 — rule removed
test ! -d .copier && echo 'staging cleared'              # _tasks emptied and removed it
cat VERSION                                              # 0.1.0, not the template's version
```

<: endraw :>

## Generating from a local checkout

Useful when developing the template itself:

```bash
copier copy --trust --vcs-ref=HEAD /path/to/syntek-base /tmp/check
```

Note `--vcs-ref=HEAD` reads **committed** state. To test uncommitted work, copy the tree somewhere
without a `.git` directory and generate from that — Copier then treats it as a plain directory:

```bash
rsync -a --exclude=.git --exclude=node_modules /path/to/syntek-base/ /tmp/tmpl/
copier copy --trust --defaults /tmp/tmpl /tmp/check
```

---

## Next

- Pull later template changes in → `14-UPDATING.md`
- Something failed → `15-TROUBLESHOOTING.md`
