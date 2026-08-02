# Updating — Pulling Template Changes into a Live Project

**Last Updated**: 02/08/2026

A project generated with Copier stays connected to the template. When `syntek-base` gains a fix,
you can pull it into a project that has been diverging for months.

This is the main reason the template is Copier-based rather than a `git clone` you then sever.

---

## How it works

`.copier-answers.yml` in your project records the template source, the commit it was generated
from, and every answer you gave. `copier update` uses that to perform a **three-way merge**:

```text
  template @ old commit  ──▶  template @ new commit
           │                           │
           │  (your edits)             │
           ▼                           ▼
     your project        ──merge──▶  updated project
```

Copier re-renders the old template version with your answers, diffs it against the new version,
and applies that diff to your working tree — so your own changes survive, and only genuine
overlaps become conflicts.

## Running an update

```bash
cd my-project
git status                 # must be clean — commit or stash first
copier update
```

Copier re-asks the questions with your previous answers as defaults. Press Enter through them
unless something has genuinely changed.

Useful variants:

```bash
copier update --defaults                 # keep every previous answer, no prompts
copier update --vcs-ref=v0.13.0          # update to a specific tag rather than the latest
copier update --pretend                  # dry run — show what would change
copier update --conflict inline          # write conflicts as inline markers rather than .rej
```

## Resolving conflicts

Conflicts appear as normal git conflict markers in the affected files:

```text
<<<<<<< before updating
your version
=======
the template's new version
>>>>>>> after updating
```

Work through them as you would a rebase:

```bash
git diff --name-only --diff-filter=U     # what conflicted
# edit each file
git add -A
git commit -m "chore(template): update from syntek-base"
```

**Where conflicts usually are:** files you have heavily edited that the template also changed —
most often `.claude/CLAUDE.md`, the layer `CONTEXT.md` files, and `pyproject.toml`. Files you
never touched update silently.

---

## What to do before updating

1. **Commit or stash everything.** Copier refuses to run against a dirty tree, and you want a
   clean point to return to.
2. **Update on a branch.** `git switch -c chore/template-update`. If the merge goes badly, you
   throw the branch away.
3. **Read what changed.** Compare the template's `CHANGELOG.md` between your `_commit` and the
   target ref, so a conflict is not the first you hear of a decision.

## What to do afterwards

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/tests/backend.sh
```

If `pyproject.toml` changed, re-lock and rebuild:

```bash
uv lock
bash code/src/scripts/development/server.sh build
```

---

## How often

There is no schedule. Reasonable triggers:

| Trigger                                | Action                                                  |
| -------------------------------------- | ------------------------------------------------------- |
| A security fix lands in the template   | Update promptly                                         |
| Starting a new sprint                  | A good natural checkpoint                               |
| The template gains a workflow you want | Update, or cherry-pick just that directory by hand      |
| Nothing in particular                  | Do not. Updating has a cost and no schedule requires it |

A project that never updates is a normal project that happens to have been generated well. Nothing
breaks.

---

## Things that will bite

**Do not edit `.copier-answers.yml` casually.** Changing an answer there makes the next update
re-render everything derived from it, which can be a very large diff. It is the right way to
change an answer — just do it deliberately, on a branch.

**Deleted files come back.** If you deleted something the template still ships, `copier update`
restores it. To keep it gone, add it to `_exclude` in a fork, or delete it again after each
update and accept the friction.

**`DATE` is stable on purpose.** It is an answered value, not a computed one, so an update does
not rewrite ~280 `**Last Updated**` headers to today. If you _want_ to re-stamp them, change
`DATE` in `.copier-answers.yml` and update.

**Renames look like delete-plus-add.** If the template moves a file you had edited, the merge
usually keeps your version at the old path and adds the new one. Check for orphans after a large
update.

**Your generation predates `.copier-answers.yml`.** Projects created with the old `setup.sh` flow
have no answers file and cannot be updated. Recreate one by hand — copy the format from a fresh
generation, fill in your values, set `_src_path` to the template URL and `_commit` to the tag you
originally used — then `copier update` will work from there.

---

## Next

- What is safe to change in your project → `10-CUSTOMISING.md`
- Something failed → `14-TROUBLESHOOTING.md`
