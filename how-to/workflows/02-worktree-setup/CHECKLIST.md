---
workflow: 02-worktree-setup
phase: setup
agent: git
skills: [global-workflow]
model: opus
---

# Worktree Setup — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (GIT-WORKTREES.md) · **External — Tools & CLI** (Git worktrees) · **Internal → Cross-layer references** (GIT-GUIDE.md) for supporting references.

## Execution Checklist

- [ ] `testing` branch is up to date before branching · _opus_
- [ ] Feature branches created with correct `us###/short-description` names · _opus_
- [ ] `git worktree list` shows the expected number of worktrees · _opus_
- [ ] Each worktree directory exists at `../<%PROJECT_SLUG%>-us###/` · _opus_
- [ ] `/etc/hosts` entries added for all worktree hostnames · _opus_
- [ ] Each Zed window is open on the correct worktree directory · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] `bash code/src/scripts/development/server.sh up` inside each worktree prints the worktree-specific URL (e.g. `http://dev-us003.<%PROJECT_SLUG%>.localhost`) · _opus_
- [ ] `docker ps` shows isolated container sets — `<%PROJECT_SLUG%>-dev-us###-*-1` — with no name collisions between worktrees · _opus_
- [ ] Both story plan files (`STORY-PLAN-US###-*.md`) are present in `project-management/src/15-STORY-PLANS/` · _opus_
