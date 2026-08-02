# Generation — What Copier Actually Does

**Last Updated**: 02/08/2026

A precise account of what happens between running `copier copy` and having a project. Read this
when something went wrong, when you are reviewing a change to `copier.yml`, or when you simply
want to know what ran on your machine.

---

## The pipeline

```text
1. fetch template        git clone of the template at the requested ref
2. ask questions         21 prompts, defaults and validators from copier.yml
3. render                every non-excluded file through Jinja2, custom delimiters
4. write                 tree written to the destination
5. record answers        .copier-answers.yml, including _src_path and _commit
6. run _tasks            4 post-generation commands
```

## 1 — Fetch

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
```

Copier resolves `gh:` to GitHub and, by default, generates from the **latest git tag** — not from
`main`. That matters: an untagged template generates from `HEAD`, but once tags exist you get the
last released one.

To pin or override:

```bash
copier copy --vcs-ref=v0.12.0 gh:Syntek-Dev/syntek-base my-project   # a specific tag
copier copy --vcs-ref=HEAD    gh:Syntek-Dev/syntek-base my-project   # tip of the default branch
```

## 2 — Questions

Twenty-one, defined in `copier.yml`. Three behaviours worth knowing:

- **Derived defaults** — `PROJECT_SLUG` from `PROJECT_NAME`, `ENV_PREFIX` from `ORG_SLUG`,
  `PRIMARY_DOMAIN` and `DEPLOY_REPO` from `PROJECT_SLUG`.
- **Validators** — slugs must be kebab-case, `ENV_PREFIX` upper-snake, `CURRENCY` three upper
  letters, `DATE` `DD/MM/YYYY`, email must contain `@`. A bad answer re-prompts.
- **`--defaults`** takes every default without asking; combine with `--data KEY=value` for the
  five questions that have no default.

## 3 — Render

**Every file is a template.** `copier.yml` sets `_templates_suffix: ""`, so there is no `.jinja`
suffix convention — the whole tree goes through Jinja2 and files containing no tokens pass through
byte-identical.

### The delimiters

| Purpose  | Opens | Closes |
| -------- | ----- | ------ |
| Variable | `<%`  | `%>`   |
| Block    | `<:`  | `:>`   |
| Comment  | `<\|` | `\|>`  |

Not `{{ }}`. The repository already contains four dialects that collide with Jinja's defaults:

| Already in the tree                     | Count                | What `{{ }}` would do      |
| --------------------------------------- | -------------------- | -------------------------- |
| `${{ github.* }}`                       | ~91 across workflows | rendered away, leaving `$` |
| `{% … %}` Django tags                   | 29 files             | parsed as Jinja, or error  |
| `{{ field.label }}`, `{{ csrf_token }}` | docs examples        | silently blanked           |
| `{{api_url}}` Bruno variables           | `.bru` files         | silently blanked           |

`[[ ]]` was rejected too — it is bash test syntax, and appears ~309 times in the project scripts.
The chosen set was verified to appear nowhere in the tree.

### Excluded from rendering

Files belonging to the template itself never reach your project:

```text
copier.yml · LICENSE · SECURITY.md · CONTRIBUTING.md · README.md
.github/CODEOWNERS · .github/ISSUE_TEMPLATE · .github/PULL_REQUEST_TEMPLATE.md
how-to/src/TEMPLATE-GUIDE/ · how-to/src/TEMPLATE-TOKENS.md
*.pdf · node_modules · .code-review-graph · .venv · __pycache__
```

Two notes:

- **Patterns are gitignore-style**, so they are root-anchored with a leading slash where they must
  be. Without it, `README.md` would also match `.copier/README.md` and `CONTRIBUTING.md` would
  swallow `how-to/src/CONTRIBUTING.md`, which your project needs.
- **PDFs are excluded because they are binary.** With `_templates_suffix: ""` Copier attempts to
  render everything, and binary content is not decodable. The two excluded PDFs are generated
  artefacts — the brand guide and component sheet — which your project rebuilds from the sources
  beside them.

## 4 — Write

The rendered tree lands in your destination directory. The template's own `README.md` is excluded;
your project's README ships from `.copier/README.md` and is moved into place by a task.

## 5 — Record answers

`.copier-answers.yml` is written with every answer plus `_src_path` and `_commit`.

**Commit this file.** It is what makes `copier update` possible — without it a project is severed
from the template and upstream fixes have to be applied by hand. See `13-UPDATING.md`.

## 6 — Post-generation tasks

Four, all visible at the bottom of `copier.yml`. Copier requires `--trust` (or an interactive
confirmation) because these execute on your machine.

| #   | Task                                              | Why                                                                                                 |
| --- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| 1   | `mv .copier/README.md README.md && rmdir .copier` | Installs the project README, since the repo-root README belongs to the template.                    |
| 2   | strip the `uv.lock` rule from `.gitignore`        | The template ignores the lock; a generated project **must** commit it.                              |
| 3   | `uv lock` (non-fatal)                             | Creates the lockfile every Dockerfile needs. Prints a warning instead of failing if `uv` is absent. |
| 4   | `git init --initial-branch=main`                  | Starts history. Skipped on `copier update`.                                                         |

Tasks 1, 2 and 4 are guarded by `when: _copier_operation == 'copy'` so they run on first
generation only, never on update.

### Why `uv.lock` is not shipped

A lockfile pins the root project _by name_, and until Copier renders the tree that name is the
literal `<%PROJECT_SLUG%>` — not a valid PEP 508 package name. No lock can be generated against
the unrendered template, and a shipped one would carry the previous project's name. Every
Dockerfile does `COPY pyproject.toml uv.lock ./` and builds with `uv sync --frozen`, so **the
Docker build fails until the lock exists**.

If task 3 warned that `uv` was missing, install uv and run `uv lock` at the project root before
your first build.

---

## Verifying a generation

```bash
grep -rIo '<%[A-Z_]*%>' . --exclude-dir=.git | wc -l    # 0
test -f README.md && test -f uv.lock && test -f .copier-answers.yml && echo ok
grep -c '^uv\.lock$' .gitignore                          # 0 — rule removed
```

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

- Pull later template changes in → `13-UPDATING.md`
- Something failed → `14-TROUBLESHOOTING.md`
