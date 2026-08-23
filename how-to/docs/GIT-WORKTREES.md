---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Worktrees — Parallel Feature Development

**Last Updated**: <%DATE%>\
**Version**: 0.1.0\
**Language**: British English (en_GB)\
**Timezone**: <%TIMEZONE%>
**Maintained By:** <%ORG_NAME%>
**Claude Model:** opus — Git worktree workflow, naming conventions, Docker isolation setup
**MCP Servers:** None (operational documentation)

---

## Table of Contents

- [Overview](#overview)
- [Naming Convention](#naming-convention)
- [One-Time Host Setup](#one-time-host-setup)
- [Creating a Worktree](#creating-a-worktree)
- [Starting the Dev Stack](#starting-the-dev-stack)
- [Running Tests](#running-tests)
- [Daily Development](#daily-development)
- [Removing a Worktree](#removing-a-worktree)
- [Limitations](#limitations)
- [Troubleshooting](#troubleshooting)

---

## Overview

A git worktree is a separate checkout of the same repository in a different directory, each
on its own branch. Use worktrees when two or more user stories can be implemented in parallel
— each story gets its own Zed window, its own Docker stack, and its own local URL.

Without worktrees, switching between feature branches forces you to stash work, rebuild
images, and reapply database migrations. With worktrees, each story's environment stays warm
and isolated. There is one app process family (Django ASGI) per stack — it serves the
templates, the HTMX/Alpine frontend, and the Django Ninja `/api/`.

The full workflow for creating worktrees: `how-to/workflows/02-worktree-setup/`

---

## Naming Convention

| Slot                 | Main dev                            | Worktree pattern                             |
| -------------------- | ----------------------------------- | -------------------------------------------- |
| Branch               | `us###/desc`                        | `us###/desc`                                 |
| Worktree path        | _(main repo)_                       | `../<%PROJECT_SLUG%>-usXXX`                  |
| Dev Docker project   | `<%PROJECT_SLUG%>-dev`              | `<%PROJECT_SLUG%>-dev-usXXX`                 |
| Test Docker project  | `<%PROJECT_SLUG%>-test`             | `<%PROJECT_SLUG%>-test-usXXX`                |
| Dev container names  | `<%PROJECT_SLUG%>-dev-*-1`          | `<%PROJECT_SLUG%>-dev-usXXX-*-1`             |
| Test container names | `<%PROJECT_SLUG%>-test-*-1`         | `<%PROJECT_SLUG%>-test-usXXX-*-1`            |
| Dev URL              | `dev.<%PROJECT_SLUG%>.localhost:81` | `dev-usXXX.<%PROJECT_SLUG%>.localhost:3080`  |
| Test URL             | `test.<%PROJECT_SLUG%>.localhost`   | `test-usXXX.<%PROJECT_SLUG%>.localhost:3081` |
| Nginx loopback IP    | `127.0.0.1`                         | `127.0.0.X` (X = story number)               |

**Loopback IP rule:** the final octet equals the story number (usXXX → `.XXX`). The entire
`127.0.0.0/8` block routes to the loopback interface on Linux — no additional configuration
is needed beyond the `/etc/hosts` entry.

**Docker override files** for each worktree live at:

```text
code/src/docker/docker-compose.us###.dev.yml   ← dev stack isolation
code/src/docker/docker-compose.us###.test.yml  ← test stack isolation
```

These files are committed to `testing` and carry forward into every worktree automatically.

---

## One-Time Host Setup

Add the following entries to `/etc/hosts` (requires `sudo`). Do this once per developer
machine — you do not need to repeat it for each session.

```bash
sudo tee -a /etc/hosts <<'HOSTS'
# <%PROJECT_SLUG%> main stacks
127.0.0.1  dev.<%PROJECT_SLUG%>.localhost
127.0.0.1  test.<%PROJECT_SLUG%>.localhost
HOSTS
```

For each worktree you create, append one entry following this pattern — the final octet equals
the story number:

```bash
echo "127.0.0.X  dev-usXXX.<%PROJECT_SLUG%>.localhost test-usXXX.<%PROJECT_SLUG%>.localhost" | sudo tee -a /etc/hosts
```

---

## Creating a Worktree

Run from the main workspace, on the `testing` branch:

```bash
# 1. Create the feature branch from testing
git branch usXXX/short-description testing

# 2. Create the worktree in a sibling directory
git worktree add ../<%PROJECT_SLUG%>-usXXX usXXX/short-description

# 3. Verify
git worktree list
```

Open the worktree in a new Zed window:

```bash
zed ~/Repos/<%ORG_SLUG%>/<%PROJECT_SLUG%>-usXXX
```

---

## Starting the Dev Stack

From inside a worktree (Zed terminal):

```bash
bash code/src/scripts/development/server.sh up
```

`server.sh` reads the current git branch. If the branch matches `us###/*` and a matching
`docker-compose.us###.dev.yml` file exists, it automatically applies the override. No extra
flags needed.

The printed output will confirm the worktree-specific URLs:

```text
✓ Stack is up.
  Site:           http://dev-usXXX.<%PROJECT_SLUG%>.localhost:3080/
  Django Admin:   http://dev-usXXX.<%PROJECT_SLUG%>.localhost:3080/control/   (superuser/staff only)
```

The `/api/` surface is the Django Ninja router; the admin surface (`/admin/`) is
Django-templated pages like every other surface; `/control/` is the Django admin.
All other `server.sh` commands (`down`, `restart`, `build`, `status`) also apply the
worktree override automatically.

---

## Running Tests

Test scripts follow the same auto-detection pattern — they bring up the isolated test stack
(auto-detecting the `us###.test.yml` override from the worktree branch) and run against it.
From inside the worktree:

```bash
# Backend tests with coverage — services, endpoints, templates, HTMX partials
bash code/src/scripts/tests/backend-coverage.sh

# API integration tests (Django Ninja routers)
bash code/src/scripts/tests/api.sh

# The whole suite in one go
bash code/src/scripts/tests/all.sh --api
```

Container names for the test stack will be `<%PROJECT_SLUG%>-test-us###-*-1`, keeping them isolated
from other running test stacks.

---

## Daily Development

Inside a worktree, your daily workflow is identical to the standard workflow:

1. `server.sh up` starts the isolated stack
2. Edit code — Django's `--reload` picks up Python changes; templates re-render per request
3. `server.sh status` to inspect containers
4. Commit and push from the worktree directory — pushes to the worktree branch

Each worktree has its own `git status`, own uncommitted changes, and own branch. Commits in
one worktree never appear in another.

---

## Removing a Worktree

When a story is merged and the worktree is no longer needed:

```bash
# From the main workspace (not inside the worktree being removed)
git worktree remove ../<%PROJECT_SLUG%>-us###

# If the worktree has uncommitted changes, force-remove:
git worktree remove --force ../<%PROJECT_SLUG%>-us###

# Clean up stale worktree references:
git worktree prune
```

Stop and remove the Docker stack before removing the worktree:

```bash
# From inside the worktree before removing it
bash code/src/scripts/development/server.sh down --volumes
```

---

## Limitations

- **Same branch cannot be in two worktrees at once.** Git enforces this — you will get an
  error if you try. Use different branches for each worktree.
- **Shared git objects.** All worktrees share the same `.git` directory. A `git gc` in any
  worktree affects all. This is safe but worth knowing.
- **One override file per story number.** If you create a second worktree for the same story
  number, it will share the same Docker project name and cause container conflicts. Always
  use unique story numbers for parallel worktrees.
- **Docker volumes are isolated per worktree** by the project name (`<%PROJECT_SLUG%>-dev-us###`), but
  they persist after `server.sh down`. Use `server.sh down --volumes` to destroy them.

---

## Troubleshooting

### Port conflict on startup

If `server.sh up` fails with "address already in use", another stack is binding the same
loopback IP and port. Check for conflicting stacks:

```bash
bash code/src/scripts/development/server.sh status
```

Stop the conflicting stack, then retry.

### server.sh shows the main dev URL (not the worktree URL)

The branch name does not match `us###/*`, or the override file is missing. Verify:

```bash
git branch --show-current
ls code/src/docker/docker-compose.us*.dev.yml
```

### nginx 502 after stack starts

The app container (Django ASGI) may still be starting. Wait a moment and reload:

```bash
bash code/src/scripts/development/server.sh status
```

### Worktree directory already exists

```bash
git worktree add ../<%PROJECT_SLUG%>-usXXX usXXX/short-description
# error: '../<%PROJECT_SLUG%>-usXXX' already exists
```

Either the directory from a previous worktree was not cleaned up, or the worktree still
exists. Check:

```bash
git worktree list
ls ../<%PROJECT_SLUG%>-usXXX
```

If it was not properly removed, run `git worktree prune` first.
