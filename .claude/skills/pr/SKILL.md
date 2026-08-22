---
name: pr
description: >-
  Raise a pull request for <%PROJECT_NAME%> and take it through the branch chain — the final QA
  and review passes, the PR body with its `US###` reference and test plan, the documentation
  hard gate, and the worktree exit. Load when a finished story branch is ready to propose, or
  when an open PR needs promoting. Not the individual git commands behind it (`git`), not the
  content review it dispatches (`code-reviewer`), and not the version bump and deploy that
  follow a merge (`release`).
model: opus
metadata:
  skills: global-workflow
---

# Raise a Pull Request (<%PROJECT_NAME%>)

**Task skill, inline.** It looks like axis 3 — an executable procedure ending in a `gh` call —
but the PR's summary, the story it closes and the test plan a reviewer will read are all
settled in the conversation, so the rubric's ambiguity rule lands it inline.

**Branch chain:** `us###/short-description` → `testing` → `dev` → `staging` → `main`.

---

## Pre-flight

`git status` — the branch is `us###/short-description` and there is nothing uncommitted. A PR
raised over a dirty tree proposes something nobody has read.

## The sequence

Phases 1 and 2 are separate Agent tool calls to `general-purpose`, naming the skill to load.
**They dispatch separately so that neither checks its own output** — a convention this skill
holds, not something the runtime enforces.

1. **Final QA** — the `qa-tester` skill.
2. **Final content review** — the `code-reviewer` skill. **A separate dispatch from phase 1.**
3. **Open the PR** — no dispatch:

   ```bash
   gh pr create --base testing
   ```

   The body carries a summary, the story reference (`Closes US042`), and a test-plan checklist.

   Two hooks fire on their own and must not be duplicated by hand: `pre-pr-check.sh` runs the
   quality gates on `gh pr create` via the project's `PreToolUse` hook, and
   `post-pr-comment.sh` posts their results to GitHub.

4. **Documentation** — no dispatch, and a **hard gate before the PR is marked ready**. See below.
5. **Exit the worktree** — conditional. Where the story ran in a git worktree, call
   `ExitWorktree` once the PR exists.

## The documentation gate

**`CONTEXT.md` updates** — every one the PR affects: directory trees reflecting new files and
folders, refreshed `**Last Updated**` dates, any new constraint, pattern or decision, and a
`CONTEXT.md` **plus its `CLAUDE.md`** inside every new directory the PR introduces.

**Implementation records** — one for every compliance domain in scope. The formats, templates
and destinations belong to `project-management/workflows/22-implementation-documentation/`,
which is entered rather than restated: GDPR, security assessments, QA, SEO and API design each
have their own `IMPLEMENTATION/` folder under `project-management/src/`.

## Definition of done

QA and review both ran as separate dispatches; the PR body names its story and its test plan;
the documentation gate is satisfied and the code-review-graph refreshed alongside it; the
automated gates are green on the PR rather than asserted locally; the worktree is exited where
one was used.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/23-pr-and-review/` — **the procedure of record** — branch
  promotion, approvals, merge gates
- `project-management/workflows/22-implementation-documentation/` — must be complete **before**
  the PR is raised; owns every record format and destination
- `code/workflows/07-review/` — the content review dispatched at phase 2
- `how-to/workflows/02-worktree-setup/` — when the story runs in a parallel worktree

## Cross-references

- `project-management/docs/GIT-GUIDE.md` — branch naming, commit format, the PR gates
- `project-management/docs/VERSIONING-GUIDE.md` — what a merge does and does not bump
- `.claude/hooks/CONTEXT.md` — the pre-PR gates that fire automatically
