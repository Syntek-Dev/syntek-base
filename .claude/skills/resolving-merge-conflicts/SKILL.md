---
name: resolving-merge-conflicts
description: >-
  Resolve an in-progress git merge or rebase conflict in <%PROJECT_SLUG%> — recover the intent
  behind both sides, resolve every hunk, and prove the result with the project gates. Load when a
  merge, rebase, or `copier update` has left conflict markers, when promoting a branch up the
  chain, or when <%DEVELOPER_NAME%> types /resolving-merge-conflicts. Knows the file classes that
  must never be hand-merged — migrations, lockfiles, version state, and frozen PM artefacts.
---

# Skill: resolving-merge-conflicts (<%PROJECT_NAME%>)

A conflict is two intents meeting, not two texts. Resolving it by picking lines produces code that
compiles and means nothing. Recover **why** each side changed, then write the resolution that
serves both.

**Never `--abort`.** Aborting throws away the merge and the understanding gained reaching it. If
the resolution is genuinely wrong, resolve it, then fix it in a follow-up commit where the
reasoning is visible. The one exception: <%DEVELOPER_NAME%> explicitly asks to abort.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## Steps

### 1. Establish the state

Which operation is in flight (`git status`), which commits are being combined, and which files
conflict. A rebase replays **your** commits onto theirs, so `ours` and `theirs` are inverted
relative to a merge — read the labels, never assume.

_Done when the operation, both endpoints, and the full conflicted-file list are known._

### 2. Recover both intents

For each conflicting file, find why each side changed it — the commit message, the PR, the
`US###` it belongs to, and the story plan or ADR behind that. This repository makes it cheap:
`project-management/src/16-STORY-PLANS/` holds what the branch set out to do, and
`src/14-DECISIONS/` holds the decisions it must not re-litigate.

Use the `code-review-graph` MCP for structural impact before Grep/Read.

_Done when each side's change has a stated purpose, not a guess._

### 3. Resolve by file class

Most hunks are prose or code and resolve by preserving both intents. **These classes do not**, and
getting one wrong is silent damage rather than a failed build:

| File class                                                        | Rule                                                                                                                                                                                       |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Migrations** (`apps/*/migrations/`)                             | Never merge two migration files. Both survive; the later one is renumbered and its `dependencies` repointed so the graph stays linear. A merged migration file is a corrupted history.     |
| **`uv.lock` · `pnpm-lock.yaml`**                                  | Never hand-merge. Take either side whole, then regenerate through the project scripts and commit the regenerated file.                                                                     |
| **`VERSION` · `CHANGELOG.md` · `VERSION-HISTORY.md`**             | Resolution is a version decision, not a text one — `project-management/docs/VERSIONING-GUIDE.md` and the `version` skill own it. Never split the difference.                               |
| **`project-management/src/NN-…/`**                                | Numbering is frozen and `USER-STORY-IDEAS/` is frozen once workflow `17` has run. A conflict there is an audit trail, not a draft — keep both records; reconcile in `CONSOLIDATED-IDEAS/`. |
| **Design-token CSS** (`static/css/tokens/`)                       | Values are DB-canonical (`apps/design_tokens`). Resolve to what the token layer says, never to a literal from either branch (`code/docs/DESIGN-TOKENS.md`).                                |
| **`.env*`**                                                       | Never resolve secrets from a diff. Reconcile the `.env.*.example` template and let <%DEVELOPER_NAME%> re-enter real values.                                                                |
| **Generated files** — `reports/`, the four graph cards, `export/` | Do not resolve. Take either side and regenerate.                                                                                                                                           |

Where two intents are genuinely incompatible, pick the one matching the **stated goal of the
merge** and record the trade-off — in the commit body, or in `GAPS.md` if it leaves real debt.
**Never invent behaviour neither side had** to make a conflict go away.

_Done when no conflict markers remain and every non-obvious choice is explained._

### 4. Prove it

A resolved merge is a new state neither branch tested. Run the gates through the project scripts —
syntax, then tests, then the audits (`how-to/workflows/06-quality-gates/`). A merge that resolves
cleanly and fails the gates has found a real semantic conflict the text did not show.

_Done when the gates pass, or every failure is traced to the merge and fixed._

### 5. Finish

Stage and complete the merge or continue the rebase to the last commit. Follow the commit
convention in `.claude/skills/global-workflow/GIT-AND-PR.md`; state in the body what was
reconciled and any trade-off taken.

_Done when the working tree is clean and no operation is in flight._

## `copier update` conflicts are a different animal

A template update conflicts against files a project has legitimately customised. The resolution
rule inverts: **the project's content usually wins, the template's structure usually wins.** Take
the template's side for scaffolding it owns (workflow `STEPS.md`, guides, audits) and the
project's side for anything carrying real work. See
`how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` — it is the authority; this skill does not restate it.

## Anti-patterns

- `--abort` as a reflex. It discards understanding, not just changes.
- Resolving to whichever side is longer, newer, or `HEAD`.
- Hand-merging a lockfile or a migration.
- Declaring victory on "no markers left" without running the gates.
- Silently dropping a hunk because both sides looked wrong.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `project-management/workflows/22-pr-and-review/` — branch promotion and merge gates
- `how-to/workflows/06-quality-gates/` — the gates a resolution must pass
- `how-to/workflows/02-worktree-setup/` — parallel branches, where these conflicts originate
- `code/workflows/03-database-migration/` — when the conflict is a migration graph

## Cross-references

- `project-management/docs/GIT-GUIDE.md` — the branch chain and commit format.
- `project-management/docs/VERSIONING-GUIDE.md` — owns any version-state conflict.
- `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md` — owns `copier update` conflicts.
- `code/docs/CODE-REVIEW-GRAPH.md` — structural impact before reading files.
- `.claude/skills/git/SKILL.md` — the skill this runs alongside.
