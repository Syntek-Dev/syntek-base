---
workflow: 04-worktree-setup
phase: setup
agent: git
skills: [global-workflow]
model: opus
---

# Worktree Setup — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                        |
| ---- | ------------------------------------------------------------------------------ |
| 1–3  | **External — Tools & CLI** → Git worktrees                                     |
| 2    | **Internal → Cross-layer references** → project-management/docs/GIT-GUIDE.md   |
| 4    | **Internal → Reference guides** → how-to/docs/GIT-WORKTREES.md                 |
| 5–6  | **External — IDE & Editor** → Zed documentation, Claude Code CLI documentation |

---

## Steps

### Step 1 — Ensure testing is up to date

```bash
git checkout testing
git pull origin testing
```

> **Model:** opus

### Step 2 — Create the feature branches from testing

```bash
git branch us###/short-description testing
```

Repeat for each story you are working on in parallel. Branch names must follow the
`us###/short-description` format documented in `project-management/docs/GIT-GUIDE.md`.

> **Model:** opus

### Step 3 — Create the worktrees

```bash
git worktree add ../<%PROJECT_SLUG%>-us### us###/short-description
```

This creates a new directory at `../<%PROJECT_SLUG%>-us###` checked out on the new branch.
Repeat for each story:

```bash
git worktree add ../<%PROJECT_SLUG%>-us003 us003/abac-membership-model
git worktree add ../<%PROJECT_SLUG%>-us004 us004/enforce-one-area-admin
```

Verify:

```bash
git worktree list
```

> **Model:** opus

### Step 4 — Add /etc/hosts entries (one-time per developer)

Run the host-setup script once per story number (requires sudo). It idempotently
appends the worktree hostnames — `dev-us<NNN>` and `test-us<NNN>`. Full list and teardown:
`how-to/docs/GIT-WORKTREES.md §One-Time Host Setup`.

```bash
bash code/src/scripts/development/hosts-story-add.sh 003
bash code/src/scripts/development/hosts-story-add.sh 004
```

Tear the entries down when a worktree is removed, using the paired script:

```bash
bash code/src/scripts/development/hosts-story-remove.sh 003
```

> **Model:** opus

### Step 5 — Open each worktree in a new Zed window

```bash
zed ~/Repos/<%PROJECT_SLUG%>/<%PROJECT_SLUG%>-us003
zed ~/Repos/<%PROJECT_SLUG%>/<%PROJECT_SLUG%>-us004
```

Each Zed window is now an independent Claude Code session for its own feature branch.

> **Model:** opus

### Step 6 — Start the dev stack in each worktree

From inside each worktree (in Zed's terminal):

```bash
bash code/src/scripts/development/server.sh up
```

`server.sh` detects the active branch, finds the matching
`docker-compose.us###.dev.yml` override, and starts an isolated Docker stack.
The printed URLs will show the worktree-specific hostname.

> **Model:** opus

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
