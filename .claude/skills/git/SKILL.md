---
name: git
description: >-
  Run <%PROJECT_NAME%>'s git surface to its conventions — create the `us###/` branch, review and
  stage a diff, write the commit, raise and manage the pull request, and tag a release. Load for
  any branch, commit, PR or tag operation. Not writing or reviewing the code being committed,
  not editing the version files (`version`), not the PR's content review (`code-reviewer`), and
  not deciding a release is ready (`release`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow
---

# Run the Git Surface (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable task whose output is a branch, a commit, or a
pull request).

> **The guide wins.** `project-management/docs/GIT-GUIDE.md` is authoritative for branch
> naming, commit format, the PR flow and the merge strategy per stage. Where it and this skill
> disagree, follow the guide and **flag the drift** rather than silently diverging.

---

## The brief arrives settled

A fork cannot ask, so the brief must carry **the operation** (branch, commit, PR, tag), **the
story number** where one applies, and **what the change is** in enough detail to write an
honest subject line. **If the docs hard gate is unmet, return rather than committing** — see
below.

Orient before acting:

```bash
git status
python3 .claude/plugins/git-tool.py status
python3 .claude/plugins/git-tool.py branches --all
```

Confirm the current branch matches the work in hand. Feature and bugfix work belongs on a
`us###/short-description` branch — **never commit directly to `main`.**

## Non-negotiables

- **Never commit a `.env` file** — only `.env.*.example` templates. Check the staged set every
  time.
- **No secrets in a commit** — scan the diff for keys, tokens and passwords before staging.
- **The docs hard gate.** Implementation records and every affected `CONTEXT.md` must be
  complete **before** the commit, with the code-review-graph refreshed alongside them. **If they
  are not, stop and hand back** — do not commit, and do not commit with red tests.
- **Never force-push a protected branch**, and never merge a PR that skips a stage in the
  branch flow.
- **British English** in every commit message, PR title and body.

## Commits

1. **Review the staged diff** — scope, no `.env`, no secrets, docs complete.
2. **Delegate the version bump** where the change warrants one. `version` owns `VERSION`, the
   three logs and the header stamps. **Never edit a version file here.**
3. **Write the message in the guide's format** — Conventional Commits, imperative mood,
   British English, with the co-author trailer the guide specifies. **Read the model name from
   `.claude/CLAUDE.md` Section 4 at the time of writing; never carry a pinned version string.**
4. **A bugfix commit references its root-cause record**, which must already exist at
   `project-management/src/20-BUGS/BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. If there is none,
   hand back to `bugfix` before committing.

## Pull requests

Run the pre-PR gate first and only mark a PR ready once every gate is green:

```bash
bash .claude/hooks/pre-pr-check.sh
```

Create and manage PRs with the `gh` CLI:

```bash
gh pr create --base <target> --title "[US###] type(scope): Subject" --body "$(cat <<'EOF'
## Summary
- <what and why>

## Test plan
- [ ] Backend tests pass — bash code/src/scripts/tests/backend.sh
- [ ] API integration tests pass — bash code/src/scripts/tests/api.sh

Closes #<issue>
EOF
)"

gh pr list                                    # open PRs
gh pr view <n> --web                          # inspect
gh pr checks <n>                              # CI status
gh pr merge <n> --merge --delete-branch
```

**The target branch, the review requirements and the merge strategy per stage are the guide's —
do not invent a flow.**

## Releases

Tagging and the version bump go through `version`; the deploy is `release`'s. This skill runs
the mechanics those two direct: the branch, the tag, the merge.

## Definition of done

The operation completed to the guide's conventions; nothing secret or `.env` staged; the docs
gate satisfied before the commit; the branch, commit or PR reference reported.

## Handoff

Return a one-line status — the branch, the commit or PR reference, and the next expected step.
Then name what is owed: `version` for a bump before a versioned commit, `code-reviewer` before
a PR is raised, `qa-tester` before a merge, `cicd` where a pipeline needs to trigger or pass,
`bugfix` for a missing root-cause record, and `doc-writer` for release notes.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/22-pr-and-review/` — the PR-and-review procedure
- `project-management/workflows/23-release/` — the release procedure
- `project-management/workflows/21-implementation-documentation/` — the hard gate on the commit
- `how-to/workflows/02-worktree-setup/` — creating and starting a parallel-story worktree
- `code/workflows/07-review/` — the content review that precedes the PR

## Cross-references

- `project-management/docs/GIT-GUIDE.md` — **authoritative**: branches, commit format, PR flow
- `project-management/docs/VERSIONING-GUIDE.md` — the semver rules a versioned commit obeys
- `.claude/hooks/pre-pr-check.sh` — the quality gates a PR must pass before it is ready
- `.claude/plugins/git-tool.py` — read-only repository state
- `how-to/docs/GIT-WORKTREES.md` — creating and retiring the parallel-story worktrees
