@./CONTEXT.md

# CLAUDE.md — how-to/workflows/04-worktree-setup/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

The workflow for running two or more user stories in parallel — each gets its own git
worktree, namespaced Docker stack, and local URL, so stacks never share data.

## How to work here

- **Routing:** parallel-story setup → `global-workflow` skill via `STEPS.md`;
  `CHECKLIST.md` to verify. Full naming, `/etc/hosts`, and removal detail live in
  `how-to/docs/GIT-WORKTREES.md`. For a single story, use `02-daily-development/`
  instead.
- **Model:** Opus to revise the procedure and command/link fixes.
- **Concrete steps:** create the worktree off up-to-date `testing` → let `server.sh`
  auto-detect the branch and apply the correct
  `code/src/docker/docker-compose.us###.{dev,test}.yml` override → verify per-worktree
  container and volume namespacing. Amend by editing `STEPS.md` + `CHECKLIST.md`.
- **Definition of done:** each worktree runs an isolated stack on its own URL;
  `CHECKLIST.md` passes; British English.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Hard gate:** `project-management/docs/GIT-GUIDE.md` — the `us###/…` branch name
  must be correct **before** the worktree is created.
- **Prerequisites bite:** the per-story Compose override files and one-time
  `/etc/hosts` entries must exist first, or stacks collide.
- **Script-first:** stack lifecycle via `server.sh` and the other
  `code/src/scripts/**/*.sh` — never raw `docker compose`.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; nothing generated.
- Branches `us###/short-description`; override files
  `docker-compose.us###.{dev,test}.yml`; documentation `SCREAMING-SNAKE-CASE.md`.
