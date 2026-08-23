# Generation — What Copier Actually Does

**Last Updated**: 23/08/2026

A precise account of what happens between running `copier copy` and having a project. Read this
when something went wrong, when you are reviewing a change to `copier.yml`, or when you simply <!-- doc-references: template-only -->
want to know what ran on your machine.

---

## The pipeline

```text
1. fetch template        git clone of the template at the requested ref
2. ask questions         33 prompts (+4 conditional), defaults and validators from copier.yml
3. render                every non-excluded file through Jinja2, custom delimiters
4. write                 tree written to the destination
5. record answers        .copier-answers.yml, including _src_path and _commit
6. run _tasks            4 post-generation commands
```

`copier update` runs a different tail: no `_tasks` at all, and instead the `_migrations` at the
bottom of `copier.yml` — see _Migrations_ below. <!-- doc-references: template-only -->

## 1 — Fetch

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
```

Copier resolves `gh:` to GitHub and, by default, generates from the **latest git tag** — not from
`main`. That matters: an untagged template generates from `HEAD`, but once tags exist you get the
last released one.

To pin or override:

```bash
copier copy --vcs-ref=v7.2.3 gh:Syntek-Dev/syntek-base my-project   # a specific tag
copier copy --vcs-ref=HEAD   gh:Syntek-Dev/syntek-base my-project   # tip of the default branch
```

## 2 — Questions

Thirty-eight, defined in `copier.yml` — thirty-four always asked, four conditional on the <!-- doc-references: template-only -->
optional surfaces (`MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` on `INCLUDE_MOBILE`,
`INCLUDE_DESKTOP` on `INCLUDE_RUST`, `DESKTOP_APP_NAME` on `INCLUDE_DESKTOP`). Three behaviours
worth knowing:

- **Derived defaults** — `PROJECT_SLUG` from `PROJECT_NAME`, `ORG_SLUG` from `ORG_NAME`,
  `ENV_PREFIX` from `ORG_SLUG`, `PRIMARY_DOMAIN` and `DEPLOY_REPO` from `PROJECT_SLUG`,
  `MOBILE_BUNDLE_ID` from `PRIMARY_DOMAIN` reversed, and both `MOBILE_APP_NAME` and
  `DESKTOP_APP_NAME` from `PROJECT_NAME`.
- **Validators** — twelve of the thirty-eight carry one: slugs must be kebab-case,
  `PRIMARY_DOMAIN` a bare hostname, `ENV_PREFIX` upper-snake, `LOCALE` five characters around an
  underscore, `TIMEZONE` an IANA `Area/City`, `CURRENCY` three upper letters, `DATE` `DD/MM/YYYY`,
  email must contain `@`, `SPRINT_GRACE_SP` must exceed `SPRINT_CAPACITY_SP`, `MOBILE_BUNDLE_ID`
  must be reverse-domain form, and `PROJECT_DESCRIPTION` must be at least forty characters with no
  double quotes. A bad answer re-prompts.
- **`--defaults`** takes every default without asking; combine with `--data KEY=value` for the
  six questions that have no default — `PROJECT_NAME`, `PROJECT_DESCRIPTION`, `ORG_NAME`,
  `DEVELOPER_NAME`, `DEVELOPER_EMAIL`, `DATE`.

## 3 — Render

**Every file is a template.** `copier.yml` sets `_templates_suffix: ""`, so there is no `.jinja` <!-- doc-references: template-only -->
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

| Already in the tree                     | Count                     | What `{{ }}` would do      |
| --------------------------------------- | ------------------------- | -------------------------- |
| `${{ github.* }}`                       | 123 across workflows      | rendered away, leaving `$` |
| `{% … %}` Django tags                   | 63 files, 42 of them docs | parsed as Jinja, or error  |
| `{{ field.label }}`, `{{ csrf_token }}` | docs examples             | silently blanked           |
| `{{api_url}}` Bruno variables           | `.bru` files              | silently blanked           |

`[[ ]]` was rejected too — it is bash test syntax, and appears over 1,100 times in the project
scripts. The chosen set was verified to appear nowhere in the tree.

Those counts only grow, which is the point: the delimiters were chosen so that **no future file
can collide by being ordinary.** <: raw :>A literal `<%`, `<:` or `<~`<: endraw :> reaching the
tree is a `TemplateSyntaxError` at generation, and the fix is a `raw` block
(`15-TROUBLESHOOTING.md`).

### Excluded from rendering

Files belonging to the template itself never reach your project. There are six groups, and the
reason differs in each:

| Group                       | Entries                                                                                                                                                                                                                                                                                                                                                                                                                             |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The template's own docs** | `copier.yml` · `LICENSE` · `SECURITY.md` · `CONTRIBUTING.md` · `README.md` — **the whole guide tree ships** <!-- doc-references: template-only -->                                                                                                                                                                                                                                                                                  |
| **Template-only CI**        | `.github/CODEOWNERS` · `.github/ISSUE_TEMPLATE` · `.github/PULL_REQUEST_TEMPLATE.md` · `.github/scripts` · `.github/workflows/audit-template.yml` <!-- doc-references: template-only -->                                                                                                                                                                                                                                            |
| **Seeded state**            | `VERSION` · `VERSION-HISTORY.md` · `CHANGELOG.md` · `RELEASES.md` · `.claude/MEMORY.md` · `GAPS.md` · `DEFERRED.md`, each re-supplied blank from `.copier/` (see below) · `uv.lock`, **regenerated** by the `uv lock` task rather than seeded · `.copier/migrations`, excluded but **not** re-supplied — Copier reads it from the template clone <!-- doc-references: template-only -->                                             |
| **The artefact trees**      | everything under `handoffs/`, `research/`, `learning/` and `project-management/src/` bar the `CONTEXT.md`/`CLAUDE.md` pairs, the `*TEMPLATE*` files and **fifteen further named paths** — the six GDPR documents, the asset, brand-guide and component build scripts, the shared wireframe stylesheet, the two `US000` test sheets and the incident index — plus `questionnaires/.gitignore` <!-- doc-references: template-only --> |
| **Opt-out surfaces**        | the mobile, Rust and desktop trees, their scripts, guides, workflows, CI jobs and stack skills — gated by a templated entry (see `11-CUSTOMISING.md`)                                                                                                                                                                                                                                                                               |
| **Never a checkout**        | `.git` · `*.pdf` · `node_modules` · `.code-review-graph` · `.venv` · `__pycache__` · `*.py[co]` · `.DS_Store`                                                                                                                                                                                                                                                                                                                       |

Five notes:

- **The guide tree you are reading ships in full, and that is why the checks below exclude it.**
  Nothing here is held back — every file is rendered like any ordinary file, so the guides that quote token or delimiter syntax wrap it in
  `raw` blocks and the literal text survives into your project. The token sweep under _Verifying a
  generation_ therefore has to skip `TEMPLATE-GUIDE/` and `TEMPLATE-TOKENS.md`: the tokens it
  would find there are documentation, not a failed render. **`copier.yml` is excluded**, so a <!-- doc-references: template-only -->
  sentence in any shipped file that cites it resolves in the template and dangles in your project.

- **Patterns are gitignore-style**, so they are root-anchored with a leading slash where they must
  be. Without it, `README.md` would also match `.copier/README.md` and `CONTRIBUTING.md` would <!-- doc-references: template-only -->
  swallow `how-to/src/CONTRIBUTING.md`, which your project needs.
- **The artefact trees are an allowlist, and a directory pattern is not enough.** `syntek-base`
  commits its own handoffs, feature maps, research notes and lessons so they sync across the
  maintainer's devices, so `_exclude` is the only thing keeping them out of your project. Each
  tree is excluded recursively (`/research/**`) and its keepers re-included with `!`, because a
  bare directory entry does **not** prune what is inside it: Copier walks a flat recursive
  `scantree` and skips one entry at a time, and it re-creates parent directories for any file it
  renders. `.github/scripts/shipped-artefacts.sh` asserts the result on a real generation. <!-- doc-references: template-only -->
- **PDFs are excluded because they are binary.** With `_templates_suffix: ""` Copier attempts to
  render everything, and binary content is not decodable. The excluded PDFs are generated
  artefacts — the brand guide and component sheet — which your project rebuilds from the sources
  beside them.
- **Version state and project memory are excluded and then re-seeded**, rather than shipped
  directly. A project must start at `0.1.0` with an empty changelog and an empty
  `.claude/MEMORY.md`, not inherit the template's release history and internal notes — and
  because the task that seeds them is gated `when: _copier_operation == 'copy'`, a later
  `copier update` cannot hand your project the template's changelog or a blank memory file.
  The gate is the mechanism, not Copier's own behaviour: **`_tasks` run on update too** unless
  a task says otherwise, which is why the manifest-branding task deliberately has no gate.

## 4 — Write

The rendered tree lands in your destination directory, including a staging directory `.copier/`
holding the nine seed files a task then moves into place and removes.

## 5 — Record answers

`.copier-answers.yml` is written with every answer plus `_src_path` and `_commit`.

**Commit this file.** It is what makes `copier update` possible — without it a project is severed
from the template and upstream fixes have to be applied by hand. See `14-UPDATING.md`.

## 6 — Post-generation tasks

Four, all visible at the bottom of `copier.yml`. Copier requires `--trust` (or an interactive <!-- doc-references: template-only -->
confirmation) because these execute on your machine.

| #   | Task                                      | Why                                                                                                                                       |
| --- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | empty `.copier/` into place, then `rmdir` | Seeds the nine files below, since the repo-root originals belong to the template.                                                         |
| 2   | brand `pyproject.toml`'s `[project] name` | `uv` rejects the delimiters in a package name, so the manifest ships the house constant `syntek-base` and is rewritten to your slug here. |
| 3   | `uv lock` (non-fatal)                     | Creates the lockfile every Dockerfile needs. Prints a warning instead of failing if `uv` is absent.                                       |
| 4   | `git init --initial-branch=main`          | Starts history. Skipped on `copier update`.                                                                                               |

Task 1 moves nine files:

```text
.copier/README.md              →  README.md
.copier/VERSION                →  VERSION                     (0.1.0)
.copier/VERSION-HISTORY.md     →  VERSION-HISTORY.md          (empty)
.copier/CHANGELOG.md           →  CHANGELOG.md                (empty)
.copier/RELEASES.md            →  RELEASES.md                 (empty)
.copier/MEMORY.md              →  .claude/MEMORY.md           (headings and rules, no entries)
.copier/GAPS.md                →  GAPS.md                     (format block, no entries)
.copier/DEFERRED.md            →  DEFERRED.md                 (writing rules, no rows)
.copier/MAP-SCALE-PLANNING.md  →  project-management/src/01-FEATURE-MAPS/MAP-SCALE-PLANNING.md
```

The last one exists because six shipped guides cite that map, and a citation resolving to nothing
is the defect `code/src/scripts/audits/doc-references.sh` exists to catch — so the project starts
with the map present and every row reading `TBD`.

**Task 2 must stay ahead of task 3.** The lock is written from the manifest, so branding the
`[project] name` first is what makes the lockfile name your project rather than the template.

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

| Version   | What it does                                                                                                                                                                                                         |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `v7.0.0`  | Renumbers `project-management/src/` again to open `14-LOGGING`, shifting `14-DECISIONS` and everything after it up by one. **Acts**, and never overwrites — a name present on both sides is reported and left alone. |
| `v2.0.0`  | The first such renumber, carrying your stories, ADRs and sprint records with it. **Acts**, on the same terms.                                                                                                        |
| `v3.0.0`  | Reports any agent definition you wrote yourself in the now-deleted agents directory. **Advisory.**                                                                                                                   |
| `v4.0.0`  | Restores `pyproject.toml`'s `[project] name` to your slug after an update rewrote it to the template's. **Acts** — the alternative is a broken build.                                                                |
| `v5.0.0`  | Reports citations you wrote at a section of the old single-file `GIT-GUIDE.md`, now split into `docs/git/`. **Advisory.** Keyed at both `v4.0.0` and `v5.0.0`, deliberately.                                         |
| `v6.0.0`  | Reports work stranded by the `feature` → `implement-story` / `feature-map` renames. **Advisory.**                                                                                                                    |
| _(every)_ | `rm -rf .copier` — the staging directory is not project content, and `_tasks` do not run on an update to clear it.                                                                                                   |

**Order is declaration order, not version order**, which is why `v7.0.0` is declared first: it must <!-- doc-references: template-only -->
not run before the `v2.0.0` pass has settled an older project's tree.

The last entry has no `version:` on purpose: it must hold for every future release that stages a
file that way, and `rm -rf` on a normally-absent directory is a no-op.

**Advisory versus acting is a deliberate split.** A migration acts only where exactly one correct
value exists and a human left to do it would be left behind a success message — `v4.0.0`'s manifest
name is the case. Where the right answer depends on what you meant, it reports and exits 0, because
a machine guessing produces a confident sentence that is wrong.

The rule this implies for anyone changing the template: **any release that moves a directory
holding developer artefacts ships a migration in the same commit, or it silently eats work.**

### Why `uv.lock` is not shipped

**syntek-base does commit its own `uv.lock`** — `pyproject.toml` carries the house constant
`name = "syntek-base"` rather than a token, precisely because `uv` validates `[project] name` as a
package name and rejects the delimiters outright. That lock is what makes the template's own image
build and its Python gates run.

It is excluded from generation for a different reason: it pins **`syntek-base`**, so a project
inheriting it would fail `uv sync --frozen` and hit a merge conflict in a lockfile on every
`copier update`. Yours is written fresh by task 3, after task 2 has branded the manifest.

Every Dockerfile does `COPY pyproject.toml uv.lock ./` and builds with `uv sync --frozen`, so
**the Docker build fails until that lock exists**. If task 3 warned that `uv` was missing, install
uv and generate it at the project root before your first build:

```bash
bash code/src/scripts/development/install-backend.sh
```

---

## Verifying a generation

<: raw :>

```bash
# The two doc paths quote token syntax on purpose — see 04-QUICKSTART.md
grep -rIo '<%[A-Z_]*%>' . \
  --exclude-dir=.git --exclude-dir=TEMPLATE-GUIDE --exclude=TEMPLATE-TOKENS.md \
  | wc -l                                                # 0
test -f README.md && test -f uv.lock && test -f .copier-answers.yml && echo ok
grep -m1 '^name = ' pyproject.toml                        # your slug, not syntek-base
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
