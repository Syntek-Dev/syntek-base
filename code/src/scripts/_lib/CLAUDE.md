@./CONTEXT.md

# CLAUDE.md — scripts/\_lib/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(helper inventory, imported above) → this file.

## Purpose (one line)

The internal bash helper library — shared utilities (currently
`worktree-detect.sh` for git-worktree detection) that other scripts **source**, never
invoke directly.

## How to work here

- **Model:** Opus to author or change a helper (it is shared control flow that every
  sibling script depends on); Opus for a trivial rename.
- **Concrete steps:** add functions to an existing helper or a new `*.sh` here →
  callers pull it in with `source` → keep helpers side-effect-free at load time (no
  work on source, only on function call) so sourcing stays cheap and safe.
- **Definition of done:** helper is idempotent when sourced twice, exposes functions
  not top-level statements, and the `CONTEXT.md` inventory lists it.

## Guardrails

- **Sourced, never executed** — nothing here is a user-facing entry point; do not add
  a `main`-style script to `_lib/`.
- Changing a helper touches every script that sources it — check callers before
  altering a function signature or return convention.
- Secrets via environment only.

## Output & naming

- **Hand-written:** the `*.sh` helpers only.
- Files `kebab-case.sh`; the `_lib/` name (underscore prefix) deliberately marks the
  folder as internal.
