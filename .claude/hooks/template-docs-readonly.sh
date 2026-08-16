#!/usr/bin/env bash
# template-docs-readonly.sh — make the shipped template documentation read-only.
#
# PreToolUse hook on Edit|Write. Blocks any write to the guides a project RECEIVES from
# syntek-base and does not own:
#
#   how-to/src/TEMPLATE-GUIDE/    — the sixteen guides
#   how-to/src/TEMPLATE-TOKENS.md — the token contract
#
# WHY THEY ARE READ-ONLY. These files describe the template, not your project. Editing one
# does not change how your project works — it only guarantees a conflict the next time
# `copier update` runs, because upstream owns the same lines. Every other file in the tree is
# yours to change; these are the two that are not.
#
# WHY IT IS A HOOK AND NOT A DENY RULE OR chmod:
#   - A `permissions.deny` entry in the project settings would apply in syntek-base too, where
#     these files are the maintained product and MUST be writable. Those settings ship; a deny
#     rule cannot tell the two repositories apart. This hook can.
#   - `chmod 444` would block `copier update` itself from refreshing them, which is the whole
#     mechanism that keeps them current. Read-only to a human, writable to the updater, is
#     exactly the split a hook expresses and a file mode cannot.
#
# THE DISCRIMINATOR. `copier.yml` is `_exclude`d, so it exists in syntek-base and in NO
# generated project. Its presence means "this IS the template" and the hook stands down. The
# pre-commit half of this guard tells the two repositories apart on the same principle.
#
# Exit 0 allow · exit 2 block (stderr is fed back to the model).

set -uo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
[ -n "$ROOT" ] || exit 0

# In syntek-base itself these files are the product being maintained. Stand down.
[ -f "$ROOT/copier.yml" ] && exit 0

INPUT=$(cat 2>/dev/null) || exit 0

FILE_PATH=$(printf '%s' "$INPUT" | python3 -c '
import json,sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
ti = d.get("tool_input") or {}
print(ti.get("file_path") or ti.get("notebook_path") or "")
' 2>/dev/null) || exit 0

[ -n "$FILE_PATH" ] || exit 0

# Normalise to a repo-relative path so both absolute and relative targets are caught.
case "$FILE_PATH" in
"$ROOT"/*) REL="${FILE_PATH#"$ROOT"/}" ;;
/*) exit 0 ;;
*) REL="$FILE_PATH" ;;
esac

case "$REL" in
how-to/src/TEMPLATE-GUIDE/* | how-to/src/TEMPLATE-TOKENS.md)
  cat >&2 <<EOF
BLOCKED — '$REL' is read-only in a generated project.

This file ships from syntek-base and describes the TEMPLATE, not this project. Editing it
changes nothing about how this project behaves, and guarantees a merge conflict the next time
\`copier update\` runs, because upstream owns these lines.

What you probably want instead:
  - Recording something about THIS project  -> .claude/MEMORY.md
  - A convention this project adds or bends -> a new file under code/docs/ or how-to/docs/
  - An active gap or blocker                -> GAPS.md
  - Work deferred to a named story          -> DEFERRED.md
  - A fix that belongs upstream             -> raise it against syntek-base itself

Read-only set: how-to/src/TEMPLATE-GUIDE/**, how-to/src/TEMPLATE-TOKENS.md
Rationale: how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md — 'Keeping updates cheap'
EOF
  exit 2
  ;;
esac

exit 0
