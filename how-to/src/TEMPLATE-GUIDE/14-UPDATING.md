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

**Preview it first. Always.**

```bash
cd my-project
git status                 # must be clean — commit or stash first
bash code/src/scripts/development/template-update.sh
```

That clones your project to a scratch directory, runs the update against the copy, and reports
what would change, what would be deleted, what would conflict — and, most importantly, what would
be **orphaned**. Your project is not touched. When you are satisfied:

```bash
bash code/src/scripts/development/template-update.sh --apply
```

Useful variants:

```bash
template-update.sh --ref v2.1.1                 # preview a specific tag
template-update.sh -- --data KEY=value          # answer a new question with no default
template-update.sh --keep-scratch               # leave the copy on disk to poke at
```

Copier re-asks the questions with your previous answers as defaults. Press Enter through them
unless something has genuinely changed.

Underneath, it is ordinary Copier, and you can drive that directly if you prefer:

```bash
copier update --defaults                 # keep every previous answer, no prompts
copier update --vcs-ref=v0.13.0          # update to a specific tag rather than the latest
copier update --pretend                  # dry run — show what would change
copier update --conflict inline          # write conflicts as inline markers rather than .rej
```

`--pretend` tells you what Copier will write. It does **not** tell you what it will strand — read
the next section before relying on it.

---

## The failure that does not announce itself

Conflicts are the loud failure, and they are fine: markers in a file, you resolve them, you move
on. The dangerous one is silent.

**Copier only knows about files it generated.** When a release renames or renumbers a directory,
Copier moves its own scaffolding to the new path and deletes the old one. Every file _you_ wrote
in there — stories, ADRs, sprint records — was never a template file, so it stays exactly where it
was.

No conflict is raised. Nothing fails. The update reports success. What you are left with is:

```text
project-management/src/
├── 01-STORIES/          ← your US001.md, US002.md — and nothing else.
│                          No CONTEXT.md. Nothing references this folder any more.
└── 02-STORIES/          ← CONTEXT.md, CLAUDE.md, US000-TEMPLATE.md.
                           Every workflow and skill now looks here. It is empty.
```

The longer the project has run, the more there is to lose, and nothing in the output hints at it.

Three things guard against this, in order of how much you should rely on them:

1. **The template does not renumber `src/` folders any more.** Those numbers are frozen, append
   only — renumbering a folder that holds your work is a schema migration, not a re-index
   (`project-management/src/CONTEXT.md`).
2. **Releases that must move a directory ship a migration** that moves your files with it. These
   run automatically during `copier update`.
3. **The orphan audit catches whatever slipped through:**

   ```bash
   bash code/src/scripts/audits/template-orphans.sh
   ```

   Every directory the template owns carries a `CONTEXT.md`, so the signature is exact: content
   present, `CONTEXT.md` absent. Run it after every update. `template-update.sh` runs it for you,
   against the copy, before anything is applied.

If it does find orphans, nothing is broken yet — the files are still there. Move each into the
folder that replaced it, check `project-management/src/CONTEXT.md` for the current numbering, and
re-run the audit until it is clean.

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
4. **Preview.** `template-update.sh` — see above. This is the step that catches the silent
   failure, and it costs one command.

## What to do afterwards

```bash
bash code/src/scripts/audits/template-orphans.sh     # did anything get stranded?
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
usually keeps your version at the old path and adds the new one. Run
`code/src/scripts/audits/template-orphans.sh` after any large update — this is the silent failure
described above, and it is the one worth being paranoid about.

**A new question with no default halts an unattended update.** Copier cannot guess it, so
`copier update --defaults` aborts rather than proceeding. Supply it:
`template-update.sh -- --data KEY=value`. This is also why every automated caller of a template —
CI probes included — breaks the day such a question is added.

**Your generation predates `.copier-answers.yml`.** Projects created with the old `setup.sh` flow
have no answers file and cannot be updated. Recreate one by hand — copy the format from a fresh
generation, fill in your values, set `_src_path` to the template URL and `_commit` to the tag you
originally used — then `copier update` will work from there.

---

## Next

- What is safe to change in your project → `11-CUSTOMISING.md`
- Something failed → `15-TROUBLESHOOTING.md`
