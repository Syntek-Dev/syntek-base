---
workflow: 23-release
phase: ship
agent: release
skills: [global-workflow]
model: opus
---

# Release — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                                                   |
| --------- | --------------------------------------------------------------------------------------------------------- |
| All steps | **Internal — Guides** → project-management/docs/VERSIONING-GUIDE.md, project-management/docs/GIT-GUIDE.md |
| All steps | **External — Version Control & CI** → Semantic Versioning 2.0, Conventional Commits 1.0, GitHub Actions   |

---

## Steps

### Step 1 — Version Bump

```text
version bump [patch | minor | major]
```

> **↳ New agent:** `version` · **Model:** opus · **MCP:** none

This updates: `VERSION`, `VERSION-HISTORY.md`, `RELEASES.md`, `CHANGELOG.md`,
`pyproject.toml`.

### Step 2 — Run Full Test Suite

```bash
bash code/src/scripts/tests/backend.sh
```

### Step 3 — Commit Version Files

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

### Step 4 — Deploy to Production

```bash
bash code/src/scripts/deployment/deploy.sh
```

> The `deployment/` scripts (`deploy.sh`, `rollback.sh`, `health-check.sh`) are **planned** —
> the directory is currently a scaffold; the sanctioned deploy entry point lands there.

Once live, set each released story's `**Status:**` to `Closed` in `src/02-STORIES/US###.md` and
commit — the `clickup-sync` workflow moves the ClickUp tasks. Status values:
`project-management/docs/PLANNING-GUIDE.md` → Story Statuses.

---

### Step 5 — Update Context and Documentation

**Hard gate — complete before closing the release.** If this release introduced new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this release created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
