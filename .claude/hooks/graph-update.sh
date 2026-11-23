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
# background, in its own session (`setsid`, where the host has it) with its output closed, under
# a lock (`flock -n`): a run in flight means nothing new starts, and nothing is said about the
# skip. `graphify update .` refreshes graphify's CODE layer only; its doc layer is the
# developer's `/graphify --update`. It is never forced: a graphify that refuses to overwrite a
# graph has found nodes it would lose, and overriding that is a person's decision, not a hook's.
# graphify also honours GRAPHIFY_FORCE from the environment as a forced overwrite, so the hook
# unsets it (QA Q1).
#
# NO GIT LOCKS (QA Q3). GIT_OPTIONAL_LOCKS=0 is exported for every git call the hook makes, and
# the fingerprint uses only read-only commands, so the hook never takes .git/index.lock beside
# lefthook's parallel staging steps.
#
# WHEN A RUN STARTS (review M1, QA Q5/Q7). Only when the tree differs from the one the last run
# started from. The fingerprint is CONTENT, never HEAD (a content-free commit re-arms nothing):
# checksums of `git ls-files -s` (the index: staged edits, renames), `git diff` (the worktree
# against the index), and every untracked file's path and content (`git ls-files -o
# --exclude-standard`), plus graphify-out/graph.json's mtime (gitignored, so it must be named; a
# manual `/graphify` rebuild re-arms the hook). It is written to .code-review-graph/graphify.fp
# inside the locked run, before graphify starts, and the mtime half is rewritten once graphify
# finishes, so a run never re-arms itself by rewriting graph.json.
#
# WHAT A RUN LEAVES (review n2). One file, .code-review-graph/graphify.last: graphify's output
# with a final line `exit=<N>` (always on a line of its own, QA Q6), written to a temporary and
# moved into place by a single rename, so a reader never pairs one run's output with another's
# exit code. The exit code is reduced to digits before it is interpolated into JSON (n1). Refused
# versus failed is decided by grepping that file for "Refusing to overwrite".
#
# A KILLED RUN (QA Q4). The run writes .code-review-graph/graphify.running under the lock before
# graphify starts and removes it, still under the lock, after the outcome is in place. A marker
# with the lock HELD is a run in flight (the previous outcome stands, nothing new starts); a
# marker with the lock FREE is a run that died mid-way — reported unmeasured, never as the
# previous run's exit=0, and the same tree is retried. The next run clears stale temporaries.
#
# TWO MODES. Per edit (no argument): an absent graphify, a missing flock, a refusal or a failed
# run is reported as UNMEASURED (code/docs/GATE-REPORTING.md), once per change of that state.
# `--commit` (lefthook's pre-commit `graphify` step, review M2): graphify only — no
# code-review-graph call, no untracked notice — the last outcome reported as plain text on EVERY
# commit when it is not ok (none recorded yet included), then the same detached, fingerprinted
# refresh. Neither mode ever blocks. Everything it writes sits under the gitignored
# .code-review-graph/. Host prerequisites for the refresh: graphify and flock on PATH.
#
# PostToolUse stdout is discarded (written to the debug log, not shown), so the per-edit notice is
# emitted as JSON `systemMessage`, which surfaces to <%DEVELOPER_NAME%>. Both notices share ONE
# JSON line when both fire: two lines would not parse as one object, and both would be lost.
#
# ALWAYS EXITS 0. This sits on every Edit, Write and Bash; a failure here must never interrupt
# the session, and a stale graph is not an error worth blocking on.
set -uo pipefail

# Never the overwrite the hook says it never makes (Q1); never .git/index.lock (Q3).
unset GRAPHIFY_FORCE
export GIT_OPTIONAL_LOCKS=0

MODE="edit"
case "${1:-}" in
  --commit) MODE="commit" ;;
  --graphify-run) MODE="run" ;; # internal: the detached, locked run itself
esac

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)/$(basename "${BASH_SOURCE[0]}")"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$ROOT" || exit 0

readonly STATE_DIR=".code-review-graph"
readonly G_STATE="$STATE_DIR/.graphify-notice"
readonly G_LOCK="$STATE_DIR/graphify.lock"
readonly G_OUT="$STATE_DIR/graphify.last"
readonly G_FP="$STATE_DIR/graphify.fp"
readonly G_RUN="$STATE_DIR/graphify.running"
readonly G_GRAPH="graphify-out/graph.json"

# tree_fp — what graphify would see, minus its own graph, by content alone: the index, the
# worktree's diff against it, and each untracked file's path and content. Read-only git only.
tree_fp() {
  local index diff untracked
  index=$(git --no-optional-locks ls-files -s -z 2>/dev/null | cksum | awk '{print $1}')
  diff=$(git --no-optional-locks diff --no-ext-diff --no-textconv --no-color --binary 2>/dev/null \
    | cksum | awk '{print $1}')
  untracked=$(git --no-optional-locks ls-files -o --exclude-standard -z 2>/dev/null \
    | xargs -0 -r cksum -- 2>/dev/null | cksum | awk '{print $1}')
  printf '%s %s %s' "$index" "$diff" "$untracked"
}
# lock_free — true when no run holds the lock (taken and dropped at once, in a subshell).
lock_free() {
  (exec 8>>"$G_LOCK" && flock -n 8) 2>/dev/null
}
# graph_mtime — whole seconds; GNU stat, then BSD stat, then "none" for no graph yet.
graph_mtime() {
  [ -f "$G_GRAPH" ] || { echo "none"; return 0; }
  stat -c %Y "$G_GRAPH" 2>/dev/null || stat -f %m "$G_GRAPH" 2>/dev/null || echo "unknown"
}

# ── the run itself: locked, fingerprinted, one-file outcome ──────────────────
if [ "$MODE" = "run" ]; then
  trap '' HUP
  tree="${2:-}"
  exec 9>"$G_LOCK" || exit 0
  flock -n 9 || exit 0
  # Under the lock from here on. Any temporary left now is a killed run's, never a live one's.
  rm -f "$G_OUT".tmp.* 2>/dev/null || true
  printf '%s\n' "$tree" >"$G_RUN" 2>/dev/null || true
  printf '%s %s\n' "$tree" "$(graph_mtime)" >"$G_FP" 2>/dev/null || true
  tmp=$(mktemp "$G_OUT.tmp.XXXXXX" 2>/dev/null) || exit 0
  graphify update . >"$tmp" 2>&1
  rc=$?
  # The trailer always starts a line of its own, so output without a final newline keeps it.
  [ -s "$tmp" ] && [ -n "$(tail -c 1 "$tmp" 2>/dev/null)" ] && printf '\n' >>"$tmp"
  printf 'exit=%s\n' "$rc" >>"$tmp"
  mv -f "$tmp" "$G_OUT"
  rm -f "$G_RUN" 2>/dev/null || true
  # Absorb graphify's own rewrite of graph.json, keeping the tree half the run started from, so
  # a change made while it ran still re-arms the next call.
  printf '%s %s\n' "$tree" "$(graph_mtime)" >"$G_FP" 2>/dev/null || true
  exit 0
fi

mkdir -p "$STATE_DIR" 2>/dev/null || true

# The code-review-graph refresh — per edit only; lefthook owns it at commit. Never let its exit
# status escape.
if [ "$MODE" = "edit" ]; then
  code-review-graph update --skip-flows >/dev/null 2>&1 || true
fi

# ── graphify: read the last run's outcome, then start the next run ───────────
gstate=""
if ! command -v graphify >/dev/null 2>&1; then
  gstate="absent"
elif ! command -v flock >/dev/null 2>&1; then
  gstate="nolock"
elif [ -f "$G_RUN" ] && lock_free; then
  # A run marker nobody holds the lock for: that run died mid-way, so its outcome is unknown —
  # never the previous run's exit=0.
  gstate="killed"
elif [ -f "$G_OUT" ]; then
  glast=$(tail -n 1 "$G_OUT" 2>/dev/null || echo "")
  case "$glast" in
    exit=*)
      grc="${glast#exit=}"
      grc="${grc//[!0-9]/}"
      if [ "$grc" = "0" ]; then
        gstate="ok"
      elif grep -q 'Refusing to overwrite' "$G_OUT" 2>/dev/null; then
        gstate="refused"
      else
        gstate="failed:${grc:-unknown}"
      fi
      ;;
  esac
fi

if [ "$gstate" != "absent" ] && [ "$gstate" != "nolock" ]; then
  tree=$(tree_fp)
  stored=$(cat "$G_FP" 2>/dev/null || echo "")
  # A killed run recorded its tree before dying, so the same tree is retried regardless.
  if [ "$gstate" = "killed" ] || [ "$tree $(graph_mtime)" != "$stored" ]; then
    # Detached: every descriptor the caller reads is closed, so the hook never waits; its own
    # session where setsid exists, so a closing terminal or process group cannot reach it.
    if command -v setsid >/dev/null 2>&1; then
      setsid "$BASH" "$SELF" --graphify-run "$tree" </dev/null >/dev/null 2>&1 &
    else
      "$BASH" "$SELF" --graphify-run "$tree" </dev/null >/dev/null 2>&1 &
    fi
    disown 2>/dev/null || true
  fi
fi

readonly G_TAIL="(advisory; code/docs/GATE-REPORTING.md)"
graphify_message() {
  case "$1" in
    absent) echo "graphify unmeasured: it is not on PATH, so its cross-artefact graph was not updated (host-provided; $G_TAIL)." ;;
    nolock) echo "graphify unmeasured: flock is not on PATH, so no graphify update was started (a host prerequisite; $G_TAIL)." ;;
    refused) echo "graphify unmeasured: its last update stopped at Refusing to overwrite — saved nodes are missing from the rebuild, see $G_OUT; the hook never overrides it $G_TAIL." ;;
    killed) echo "graphify unmeasured: its last update did not finish (killed or interrupted), so its outcome is unknown; the same tree is being retried $G_TAIL." ;;
    failed:*) echo "graphify unmeasured: its last update failed (exit ${1#failed:}), see $G_OUT $G_TAIL." ;;
    "") echo "graphify unmeasured: no graphify update recorded yet, so its cross-artefact graph is unknown $G_TAIL." ;;
  esac
}

# ── commit mode: the last outcome, every commit, as plain text ───────────────
if [ "$MODE" = "commit" ]; then
  [ "$gstate" = "ok" ] || graphify_message "$gstate"
  exit 0
fi

gmsg=""
if [ -n "$gstate" ]; then
  gprevious=$(cat "$G_STATE" 2>/dev/null || echo "")
  # Record first, so a failure to emit never re-fires on the next tool call.
  printf '%s' "$gstate" >"$G_STATE" 2>/dev/null || true
  if [ "$gstate" != "$gprevious" ] && [ "$gstate" != "ok" ]; then
    gmsg=$(graphify_message "$gstate")
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
