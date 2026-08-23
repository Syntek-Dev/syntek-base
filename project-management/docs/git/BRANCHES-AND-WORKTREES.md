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

| Slot                | Pattern                                     | Example                                     |
| ------------------- | ------------------------------------------- | ------------------------------------------- |
| Worktree path       | `../<%PROJECT_SLUG%>-us###`                 | `../<%PROJECT_SLUG%>-us003`                 |
| Dev Docker project  | `<%PROJECT_SLUG%>-dev-us###`                | `<%PROJECT_SLUG%>-dev-us003`                |
| Test Docker project | `<%PROJECT_SLUG%>-test-us###`               | `<%PROJECT_SLUG%>-test-us003`               |
| Dev URL             | `dev-us###.<%PROJECT_SLUG%>.localhost:3080` | `dev-us003.<%PROJECT_SLUG%>.localhost:3080` |
| Test URL            | `test-us###.<%PROJECT_SLUG%>.localhost`     | `test-us003.<%PROJECT_SLUG%>.localhost`     |
| Nginx loopback IP   | `127.0.0.X` (X = story number)              | `127.0.0.3`                                 |

---

## Branch Strategy

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Branch          | Purpose                                                                   |
| --------------- | ------------------------------------------------------------------------- |
| `us###/feature` | Feature work scoped to a single user story (e.g. `us001/homepage-layout`) |
| `testing`       | Dev team QA — CI + manual testing before merging to dev                   |
| `dev`           | Integration branch — all in-progress features merged here                 |
| `staging`       | Pre-production — acceptance tests run here                                |
| `main`          | Production-ready code — client-accepted releases only                     |

Branch names follow one of two prefixes:

| Prefix               | When to use                                                  | Example                  |
| -------------------- | ------------------------------------------------------------ | ------------------------ |
| `us###/<short-desc>` | Feature or fix work scoped to a user story                   | `us015/homepage-layout`  |
| `pm/<short-desc>`    | Project management work (stories, sprints, wireframes, docs) | `pm/wireframes-checkout` |
