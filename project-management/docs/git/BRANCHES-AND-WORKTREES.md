---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Guide — Branches and Worktrees

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — git worktree naming, branch strategy

Where the work sits and what it is called: the worktree layout for parallel stories, and the
branch chain every change travels. Index: [`../GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## Parallel Development — Git Worktrees

When two or more stories can be worked on simultaneously, use git worktrees to run each
branch in its own directory with an isolated Docker stack. Full guide and naming convention:
`how-to/docs/GIT-WORKTREES.md` · Workflow: `how-to/workflows/02-worktree-setup/`

**Naming rules (summary):**

| Slot                | Pattern                                     | Example                                       |
| ------------------- | ------------------------------------------- | --------------------------------------------- |
| Worktree path       | `../<%PROJECT_SLUG%>-us###`                 | `<%PROJECT_SLUG%>-us003`, beside the checkout |
| Dev Docker project  | `<%PROJECT_SLUG%>-dev-us###`                | `<%PROJECT_SLUG%>-dev-us003`                  |
| Test Docker project | `<%PROJECT_SLUG%>-test-us###`               | `<%PROJECT_SLUG%>-test-us003`                 |
| Dev URL             | `dev-us###.<%PROJECT_SLUG%>.localhost:3080` | `dev-us003.<%PROJECT_SLUG%>.localhost:3080`   |
| Test URL            | `test-us###.<%PROJECT_SLUG%>.localhost`     | `test-us003.<%PROJECT_SLUG%>.localhost`       |
| Nginx loopback IP   | `127.0.0.X` (X = story number)              | `127.0.0.3`                                   |

---

## Branch Strategy

```text
us###/feature  →  dev  →  testing  →  staging  →  main
```

| Branch          | Who checks it        | Purpose                                                                         |
| --------------- | -------------------- | ------------------------------------------------------------------------------- |
| `us###/feature` | The developer        | One user story built (e.g. `us001/homepage-layout`); cut from and PR'd to `dev` |
| `dev`           | A second developer   | Peer code review + CI — the integration branch every finished story lands on    |
| `testing`       | The QA team          | CI + manual QA, before any client sees the change                               |
| `staging`       | The client           | Customer review and acceptance                                                  |
| `main`          | — (the live release) | Client-accepted releases only; merge commit only, enforced by the ruleset       |

**Four catch points after implementation, and peer review comes before QA.** A second developer
reads the change on `dev` first, so the QA team on `testing` only ever tests code that has already
been reviewed; QA still sits before `staging`, so a defect the testers can find never reaches a
customer review. Review on `dev` is a process rule today, not a ruleset: only `main` is protected
(`GAPS.md`).

**How a change moves between them.** The unprotected branches (`dev → testing → staging`) may be
promoted by a fast-forward push — `git push origin origin/<from>:<to>` — so the SHA that passed
the previous gate is the SHA the next gate checks. **No PR exists for a fast-forward, so CI's
base-branch floor never runs before it:** run `.claude/hooks/pre-pr-check.sh` on the source branch
first — on `dev` and above it applies the 80% promotion floor — and promote only a tip whose CI is
green. A red run on the target after the push means reverting the promotion. `main` takes a pull request with a merge
commit. After a release lands on `main`, fast-forward `dev`, `testing` and `staging` onto it so
the next story starts from what shipped.

Branch names follow one of two prefixes:

| Prefix               | When to use                                                  | Example                  |
| -------------------- | ------------------------------------------------------------ | ------------------------ |
| `us###/<short-desc>` | Feature or fix work scoped to a user story                   | `us015/homepage-layout`  |
| `pm/<short-desc>`    | Project management work (stories, sprints, wireframes, docs) | `pm/wireframes-checkout` |
