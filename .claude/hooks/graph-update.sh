#!/usr/bin/env bash
# graph-update.sh — refresh the code-review-graph, start graphify's update beside it, and say so
# when either could not see everything.
#
# Registered as a PostToolUse hook on the Edit, Write and Bash tools.
#
# WHY A WRAPPER RATHER THAN THE BARE COMMAND. `code-review-graph update` is incremental: it
# diffs against a git ref, so a file that is new and **unstaged** is never parsed and the update
# still reports success. The graph therefore looks continuously fresh while systematically
# missing every untracked source file — the false green that the hard commit gate on a fresh
# graph depends on not happening. Measured: a new untracked .py file was absent from the graph
# after an incremental pass, and present after `git add` + the same pass.
#
# So this script runs the refresh and then reports what the refresh could not reach. It reports
# **only when the set changes**, because a notice repeated on every tool call is a notice nobody
# reads — the same reasoning as the once-per-session context-threshold advisory.
#
# WHY GRAPHIFY RUNS DETACHED, AND IS ONLY EVER ADVISORY (US013, 23/11/2026). graphify answers the
# cross-artefact questions (docs, PM artefacts, how a concept crosses code and documentation);
# code-review-graph answers the code relationships, and the commit gate stays its alone. A
# graphify update is slower than one tool call should wait for, so it is started in the
# background with its output closed, under a lock (`flock -n`): a run in flight means nothing new
# starts, and nothing is said about the skip. Its output and exit code land in
# .code-review-graph/graphify.last{,.rc}, and the NEXT call reads them. It is never forced: a
# graphify that refuses to overwrite a graph has found nodes it would lose, and overriding that
# is a person's decision, not a hook's. An absent graphify, a refusal or a failed run is
# reported as UNMEASURED (code/docs/GATE-REPORTING.md), once per change of that state, and never
# blocks. Everything it writes sits under the gitignored .code-review-graph/.
#
# PostToolUse stdout is discarded (written to the debug log, not shown), so the notice is
# emitted as JSON `systemMessage`, which surfaces to <%DEVELOPER_NAME%>. Both notices share ONE
# JSON line when both fire: two lines would not parse as one object, and both would be lost.
#
# ALWAYS EXITS 0. This sits on every Edit, Write and Bash; a failure here must never interrupt
# the session, and a stale graph is not an error worth blocking on.
set -uo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

# The refresh itself. Never let its exit status escape.
code-review-graph update --skip-flows >/dev/null 2>&1 || true

readonly STATE_DIR=".code-review-graph"
mkdir -p "$STATE_DIR" 2>/dev/null || true

# ── graphify: read the last run's outcome, then start the next run ───────────
readonly G_STATE="$STATE_DIR/.graphify-notice"
readonly G_LOCK="$STATE_DIR/graphify.lock"
readonly G_OUT="$STATE_DIR/graphify.last"
readonly G_RC="$STATE_DIR/graphify.last.rc"

gstate=""
if ! command -v graphify >/dev/null 2>&1; then
  gstate="absent"
elif ! command -v flock >/dev/null 2>&1; then
  gstate="nolock"
elif [ -f "$G_RC" ]; then
  grc=$(cat "$G_RC" 2>/dev/null || echo "?")
  if [ "$grc" = "0" ]; then
    gstate="ok"
  elif grep -q 'Refusing to overwrite' "$G_OUT" 2>/dev/null; then
    gstate="refused"
  else
    gstate="failed:$grc"
  fi
fi

if [ "$gstate" != "absent" ] && [ "$gstate" != "nolock" ]; then
  # Detached: every descriptor the hook's caller reads is closed, so the hook never waits. The
  # lock is held on fd 9 for the life of the run; a second caller's `flock -n` fails and exits.
  # Output and exit code are written to temporaries and moved, so a reader never sees half a run.
  (
    trap '' HUP
    flock -n 9 || exit 0
    graphify update . >"$G_OUT.tmp" 2>&1
    printf '%s\n' "$?" >"$G_RC.tmp"
    mv -f "$G_OUT.tmp" "$G_OUT"
    mv -f "$G_RC.tmp" "$G_RC"
  ) 9>"$G_LOCK" </dev/null >/dev/null 2>&1 &
  disown 2>/dev/null || true
fi

gmsg=""
if [ -n "$gstate" ]; then
  gprevious=$(cat "$G_STATE" 2>/dev/null || echo "")
  # Record first, so a failure to emit never re-fires on the next tool call.
  printf '%s' "$gstate" >"$G_STATE" 2>/dev/null || true
  if [ "$gstate" != "$gprevious" ]; then
    case "$gstate" in
      absent) gmsg="graphify unmeasured: it is not on PATH, so its cross-artefact graph was not updated (host-provided and advisory; code/docs/GATE-REPORTING.md)." ;;
      nolock) gmsg="graphify unmeasured: flock is not on PATH, so no graphify update was started (advisory; code/docs/GATE-REPORTING.md)." ;;
      refused) gmsg="graphify unmeasured: its last update stopped at Refusing to overwrite — saved nodes are missing from the rebuild, see .code-review-graph/graphify.last; the hook never overrides it (advisory; code/docs/GATE-REPORTING.md)." ;;
      failed:*) gmsg="graphify unmeasured: its last update failed (exit ${gstate#failed:}), see .code-review-graph/graphify.last (advisory; code/docs/GATE-REPORTING.md)." ;;
    esac
  fi
fi

# ── code-review-graph: what the incremental pass could not reach ──────────────
crg_msg=""
untracked_notice() {
  # Only languages the graph actually parses — anything else is not a gap, it is out of scope.
  # Keep in step with `code-review-graph status` → Languages.
  local PARSED_RE='\.(sh|bash|py|ts|tsx|js|mjs|cjs|rs)$'
  local untracked count signature previous noun
  local STATE="$STATE_DIR/.untracked-notice"

  untracked=$(git ls-files --others --exclude-standard 2>/dev/null \
    | grep -E "$PARSED_RE" \
    | sort) || return 0

  count=$(printf '%s' "$untracked" | grep -c . || true)

  signature=$(printf '%s' "$untracked" | cksum | awk '{print $1}')
  previous=$(cat "$STATE" 2>/dev/null || echo "")

  # Record first, so a failure to emit never re-fires on the next tool call.
  printf '%s' "$signature" >"$STATE" 2>/dev/null || true

  [ "$signature" = "$previous" ] && return 0
  [ "$count" -eq 0 ] && return 0

  noun="files"
  [ "$count" -eq 1 ] && noun="file"

  crg_msg=$(printf 'Graph refreshed, but %s untracked source %s %s outside it — the incremental pass never sees an unstaged new file. Stage them before the pre-commit refresh (.claude/CLAUDE.md Section 6).' \
    "$count" "$noun" "$([ "$count" -eq 1 ] && echo "is" || echo "are")")
}
untracked_notice

# ── one JSON line, or none ────────────────────────────────────────────────────
msg="$crg_msg"
[ -n "$gmsg" ] && msg="${msg:+$msg }$gmsg"
[ -n "$msg" ] && printf '{"systemMessage":"%s"}\n' "$msg"

exit 0
