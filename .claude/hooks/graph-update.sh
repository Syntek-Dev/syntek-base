#!/usr/bin/env bash
# graph-update.sh — refresh the code-review-graph, and say so when the refresh could not see
# everything.
#
# Registered as a PostToolUse hook in .claude/settings.json (matcher "Edit|Write|Bash").
#
# WHY A WRAPPER RATHER THAN THE BARE COMMAND. `code-review-graph update` is incremental: it
# diffs against a git ref, so a file that is new and **unstaged** is never parsed and the update
# still reports success. The graph therefore looks continuously fresh while systematically
# missing every untracked source file — the false green that `.claude/CLAUDE.md` Section 6's hard
# gate depends on not happening. Measured 15/08/2026: a new untracked .py file was absent from
# the graph after an incremental pass, and present after `git add` + the same pass.
#
# So this script runs the refresh and then reports what the refresh could not reach. It reports
# **only when the set changes**, because a notice repeated on every tool call is a notice nobody
# reads — the same reasoning as context-threshold-handoff.sh's once-per-session 50% tier.
#
# PostToolUse stdout is discarded (written to the debug log, not shown), so the notice is
# emitted as JSON `systemMessage`, which surfaces to <%DEVELOPER_NAME%>.
#
# ALWAYS EXITS 0. This sits on every Edit, Write and Bash; a failure here must never interrupt
# the session, and a stale graph is not an error worth blocking on.
set -uo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

# The refresh itself. Never let its exit status escape.
code-review-graph update --skip-flows >/dev/null 2>&1 || true

# Only languages the graph actually parses — anything else is not a gap, it is out of scope.
# Keep in step with `code-review-graph status` → Languages.
readonly PARSED_RE='\.(sh|bash|py|ts|tsx|js|mjs|cjs|rs)$'

untracked=$(git ls-files --others --exclude-standard 2>/dev/null \
  | grep -E "$PARSED_RE" \
  | sort) || exit 0

count=$(printf '%s' "$untracked" | grep -c . || true)

readonly STATE=".code-review-graph/.untracked-notice"
signature=$(printf '%s' "$untracked" | cksum | awk '{print $1}')
previous=$(cat "$STATE" 2>/dev/null || echo "")

# Record first, so a failure to emit never re-fires on the next tool call.
mkdir -p "$(dirname "$STATE")" 2>/dev/null || true
printf '%s' "$signature" >"$STATE" 2>/dev/null || true

[ "$signature" = "$previous" ] && exit 0
[ "$count" -eq 0 ] && exit 0

noun="files"
[ "$count" -eq 1 ] && noun="file"

printf '{"systemMessage":"Graph refreshed, but %s untracked source %s %s outside it — the incremental pass never sees an unstaged new file. Stage them before the pre-commit refresh (.claude/CLAUDE.md Section 6)."}\n' \
  "$count" "$noun" "$([ "$count" -eq 1 ] && echo "is" || echo "are")"

exit 0
