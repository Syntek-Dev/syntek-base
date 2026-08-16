# project-management/docs/git

The git standard, split into four sub-documents behind
[`../GIT-GUIDE.md`](../GIT-GUIDE.md) — the thin index over this folder.

## Directory Tree

```text
project-management/docs/git/
├── CONTEXT.md                   ← this file
├── CLAUDE.md                    ← operating rules for this folder
├── BRANCHES-AND-WORKTREES.md    ← worktree naming, the branch chain, the two branch prefixes
├── COMMITS.md                   ← the pre-commit and pre-push gates, the message format
├── PR-AND-REQUIRED-CHECKS.md    ← promotion order, path filter vs required check, toolchain pins
└── MIGRATION-GATES.md           ← the review and staging gates a Django migration earns
```

## Which file owns what

| File                        | Owns                                                                                                                          | Read before                             |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `BRANCHES-AND-WORKTREES.md` | Worktree paths, Docker project names and dev/test URLs; the five-branch chain; `us###/` and `pm/`                             | Opening a branch or a parallel worktree |
| `COMMITS.md`                | The lint and test gates; the message template, co-author trailer, type and scope values, breaking-change signalling           | Every commit and every push             |
| `PR-AND-REQUIRED-CHECKS.md` | The merge gate per promotion step; the path-filter-or-required rule and the target required set; the four toolchain pin files | Raising a PR or changing a CI workflow  |
| `MIGRATION-GATES.md`        | HMAC companion completeness, `app_user` grants, and the staging verification procedure and sign-off                           | Reviewing or promoting a migration      |

**One fact, one file.** The branch chain diagram appears in `BRANCHES-AND-WORKTREES.md` as the
naming standard and in `PR-AND-REQUIRED-CHECKS.md` as the gate table — the same five names, but
they answer different questions and were written that way in the guide these came from.

## Why the split

`GIT-GUIDE.md` reached 292 code lines against the 300-line instructional cap once the required
status-check set was written down, and the material had long since stopped being one subject: a
worktree naming table and a staging migration sign-off share a tool, not a reader.

The four files follow the change as it travels — branch, commit, pull request, and the extra
gates a migration earns — so the file you open is decided by the operation in front of you.

Same pattern as `../GDPR-GUIDE.md` over `../gdpr/` and `../PLANNING-GUIDE.md` over
`../planning/`: a thin index, sub-documents by audience.

## Cross-references

- `../GIT-GUIDE.md` — the index
- `how-to/docs/GIT-WORKTREES.md` — the full worktree guide the naming table summarises
- `project-management/workflows/22-pr-and-review/` — the procedure the PR gates are executed by
- `project-management/docs/VERSIONING-GUIDE.md` — what a breaking-change signal means for the number

**Last Updated**: <%DATE%>
