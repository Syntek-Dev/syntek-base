---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Guide — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Git workflow, branch strategy, commit conventions, PR process, git worktree naming
**MCP Servers:** None (process/workflow documentation)

---

A thin index. The git standard is split across four sub-documents that follow a change as it
travels — branch, commit, pull request, and the extra gates a migration earns — so the file you
open is decided by the operation in front of you.

| Sub-document                                                     | Governs                                                          | Read before                           |
| ---------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------- |
| [`git/BRANCHES-AND-WORKTREES.md`](git/BRANCHES-AND-WORKTREES.md) | Worktree naming, the five-branch chain, the two branch prefixes  | Opening a branch or a worktree        |
| [`git/COMMITS.md`](git/COMMITS.md)                               | The pre-commit and pre-push gates, and the message format        | Every commit and every push           |
| [`git/PR-AND-REQUIRED-CHECKS.md`](git/PR-AND-REQUIRED-CHECKS.md) | Promotion order, required checks vs path filters, toolchain pins | Raising a PR or editing a CI workflow |
| [`git/MIGRATION-GATES.md`](git/MIGRATION-GATES.md)               | The review gates and the staging verification a migration earns  | Reviewing or promoting a migration    |

---

## Which one do I need?

- **"What do I call this branch, and where does the worktree go?"** → `BRANCHES-AND-WORKTREES.md`.
- **"What must be green, and what does the message look like?"** → `COMMITS.md`.
- **"Where does this PR go next, and why is a check pending forever?"** → `PR-AND-REQUIRED-CHECKS.md`.
- **"This PR touches a migration."** → `MIGRATION-GATES.md`, on top of the other three.

## The one-paragraph version

Work happens on a `us###/` or `pm/` branch, in its own worktree where two stories run at once.
Every commit is preceded by the lint gates and every push by the test suite, and the message
follows Conventional Commits with a co-author trailer naming the model that wrote it. The branch
then travels `testing → dev → staging → main` in order, never skipping a stage, gated at each
step by CI and a sign-off. A PR carrying a Django migration earns two more gates at review, and a
risky one is verified on staging before it may be promoted to `main`.

---

## Related

- `how-to/docs/GIT-WORKTREES.md` — the full worktree guide the naming table summarises
- `how-to/workflows/02-worktree-setup/` — the procedure that creates one
- `project-management/workflows/22-pr-and-review/` — the procedure the PR gates are executed by
- `project-management/docs/VERSIONING-GUIDE.md` — what a breaking-change signal means for the number
