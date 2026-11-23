#!/usr/bin/env bash
# SC2016: the stub bodies are written single-quoted on purpose — they expand in the fixture.
# shellcheck disable=SC2016
#
# graph-update.sh — US013's probes for the per-edit graph hook, .claude/hooks/graph-update.sh.
#
# The hook refreshes code-review-graph and reports what that refresh could not see. US013 adds
# graphify beside it: after the code-review-graph pass the hook starts `graphify update .`
# DETACHED (it never waits) UNDER A LOCK (a run in flight means nothing new starts), NEVER with
# `--force`, and reports an absent graphify, a refusal to overwrite, or a failed run as
# UNMEASURED through its one `{"systemMessage": ...}` JSON line — once per change of that state.
# It always exits 0, and code-review-graph's refresh and untracked-file notice are unchanged.
#
# Probes — each in its own fresh scratch copy (QA plan HP-16, ES-10 to ES-13):
#   absent      no graphify on PATH: exit 0, graphify reported unmeasured and absent, once;
#               the second call with the same state says nothing about graphify
#   lock        a run in flight (a stub that sleeps 3 s): a second call, on a tree CHANGED while
#               that run holds the lock (so the fingerprint asks for a run), starts no second run
#               and reports nothing for the skip — only the lock can stop it (QA Q2)
#   refuse      graphify refuses to overwrite (its fail-closed lines, exit 1): the next call
#               reports the refusal as unmeasured with its reason, once; no recorded invocation
#               and no line of the hook carries `--force`
#   success     graphify succeeds: it is started as `graphify update .` at the repository root,
#               no graphify message, and the next call is silent too
#   fail        graphify fails (a traceback, exit 2): reported unmeasured and failed, once
#   detached    a stub that sleeps 5 s: the hook returns, stdout and stderr closed, inside 2 s,
#               and the stub was nevertheless started
#   regression  code-review-graph runs `update --skip-flows` on every call, and the untracked
#               notice fires on a change of the untracked set exactly as before (may pass today)
#   one-json    an untracked file and an absent graphify in one call: stdout is still ONE JSON
#               object, carrying both notices (two JSON lines would lose both)
#   fp          (review M1) a finished run on an unchanged tree is not restarted: two further
#               calls start nothing; an untracked file, a second edit to the same tracked file,
#               and a touched graphify-out/graph.json each re-arm exactly one run. The run's
#               fingerprint lives in .code-review-graph/graphify.fp
#   commit      (review M2) `graph-update.sh --commit`, the lefthook pre-commit mode: graphify
#               only (no code-review-graph call); reports the last recorded outcome as unmeasured
#               on EVERY commit when it is not ok (none recorded yet, refused, failed, absent),
#               silent when ok; starts the same detached, locked, fingerprinted run; exit 0,
#               never --force
#   nolock      (review m5) no flock on PATH: unmeasured, naming flock, once; no run started
#   rc          (review n1) a non-numeric exit code in the recorded outcome still yields ONE
#               valid JSON line (the code is sanitised to digits before interpolation)
#   atomic      (review n2) outcome and exit code are ONE file, .code-review-graph/graphify.last,
#               whose last line is `exit=<digits>`, moved into place by a single rename; no
#               graphify.last.rc is written, and a stale one is never paired with the output
#   env-force   (QA Q1) GRAPHIFY_FORCE=1 exported into the hook: graphify still runs with the
#               variable UNSET, in the per-edit and the --commit mode (graphify honours it as
#               --force, the overwrite the hook never makes)
#   git-locks   (QA Q3) a recording git on PATH: every `git status` and `git diff` the hook makes
#               carries --no-optional-locks (or runs under GIT_OPTIONAL_LOCKS=0), and every
#               index-writing git command it makes names a GIT_INDEX_FILE other than .git/index,
#               so the hook never takes .git/index.lock beside lefthook's parallel staging
#   killed      (QA Q4) a run killed mid-way (SIGKILL to the run and its graphify): while it was
#               in flight a call is silent; afterwards --commit and the next per-edit call each
#               report graphify unmeasured (never ok from the previous run's exit=0), each
#               retries the SAME tree, and no stale graphify.last.tmp.* survives the retry
#   content     (QA Q5, Q7, Q12) the fingerprint is content, not HEAD: a content-free commit
#               (--allow-empty) re-arms nothing; a staged-only change, a staged rename, a nested
#               untracked file, a second untracked file in the same nested directory, and an
#               edit to an untracked file's content each re-arm exactly one run
#   newline     (QA Q6) graphify output with no final newline: the trailer is still its own last
#               line, exit=<N>, and the failure is reported with its code
#   setsid      (QA Q12) setsid on PATH (a recording stand-in): the detached run is started
#               through it; with no setsid on PATH the run still starts, detached, inside 2 s
#   timeout     (bugfix) GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1, a 5 s graphify: graphify.last ends
#               timeout=1 then exit=124, reported timed out once per edit, every --commit
#   notimeout   (bugfix) no timeout on PATH: unmeasured, naming timeout; no run started
#   mktemp      (bugfix) mktemp fails in the run: a failed outcome, no marker left, never killed, no restart loop
#   lockwait    (bugfix) a lock held 0.7 s as the run starts does not stop it; one held 2.5 s still starts none
#   timeout-kill   (bugfix 2, M1) a graphify ignoring TERM under bound 1 is SIGKILLed after the
#               kill grace: graphify.last ends timeout=1 then exit=137, reported timed out after 1 s
#               (slow: the hook's 10 s kill grace is real, ~12 s)
#   timeout-reader (bugfix 2, M2) timed out under bound 1, then read with no
#               GRAPH_UPDATE_GRAPHIFY_TIMEOUT, per edit and by --commit: still "after 1 s"
#   rc124       (bugfix 2, L1) graphify itself exiting 124 at once: no timeout= line, reported
#               failed (exit 124), never timed out
#   timeout-env (bugfix 2) GRAPH_UPDATE_GRAPHIFY_TIMEOUT 1.5, 10m, 010, 0, empty, " 5" each run
#               under the 600 s bound, observed through a recording timeout (7 runs under 7)
#
# The fixture: `git archive HEAD` extracted into a `mktemp -d`, with the WORKING-TREE hook copied
# over its committed one (so the suite judges the hook as edited, before and after the build),
# then `git init` + one commit inside it. Nothing in it is a path back into this checkout; the
# suite trips (exit 2) if any symlink in a scratch copy resolves outside it. git runs with no
# global or system configuration. `graphify` and `code-review-graph` are STUBS that record their
# argv and behave per probe; the real tools are hidden from PATH (a shadow bin of every other
# executable on PATH), and are never invoked. No `.env.*` file is read.
#
# Usage: graph-update.sh [--probe NAME] [--keep] [--help]
#   --probe NAME  Run one probe (repeatable); default is all.
#   --keep        Leave the scratch directory in place and print its path.
#
# Requires: bash, git, tar, date (nanoseconds). jq is used when present for the JSON check.
# Exit codes: 0 = every probe passed  1 = a probe failed  2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
HOOK_REL=".claude/hooks/graph-update.sh"

ALL_PROBES=(absent lock refuse success fail detached regression one-json fp commit nolock rc atomic
  env-force git-locks killed content newline setsid timeout notimeout mktemp lockwait
  timeout-kill timeout-reader rc124 timeout-env)
PROBES=()
KEEP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --probe) [[ $# -ge 2 ]] || { echo "graph-update.sh: --probe needs a name" >&2; exit 2; }
             PROBES+=("$2"); shift 2 ;;
    --keep) KEEP=true; shift ;;
    --help|-h) sed -n '4,/^set -euo pipefail$/{/^#/p}' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'graph-update.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done
[[ ${#PROBES[@]} -gt 0 ]] || PROBES=("${ALL_PROBES[@]}")
for p in "${PROBES[@]}"; do
  [[ " ${ALL_PROBES[*]} " == *" $p "* ]] || { echo "graph-update.sh: unknown probe $p" >&2; exit 2; }
done
for tool in git tar date; do
  command -v "$tool" >/dev/null 2>&1 || { echo "graph-update.sh: $tool not found" >&2; exit 2; }
done
[[ -f "$PROJECT_ROOT/$HOOK_REL" ]] || { echo "graph-update.sh: $HOOK_REL missing" >&2; exit 2; }
[[ "$(date +%s%N)" =~ ^[0-9]+$ ]] || { echo "graph-update.sh: date lacks %N" >&2; exit 2; }
BASH_BIN="$(command -v bash)"
JQ="$(command -v jq 2>/dev/null || true)"

TMP="$(mktemp -d)"
STUB_DIRS=() HOLDERS=()
cleanup() {
  local d i
  for d in "${HOLDERS[@]}"; do kill "$d" 2>/dev/null || true; done # lockwait's lock holders
  # Let every stub a detached run started finish before its directory goes (bounded: 12 s).
  for d in "${STUB_DIRS[@]}"; do
    for ((i = 0; i < 120; i++)); do [[ "$(started "$d")" -le "$(finished "$d")" ]] && break; sleep 0.1; done
  done
  if $KEEP; then echo "scratch kept: $TMP"; else rm -rf "$TMP"; fi
}
trap cleanup EXIT
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT

FAILS=0
PASSES=0
pass() { PASSES=$((PASSES + 1)); printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILS=$((FAILS + 1)); printf '  \033[31m✗\033[0m %s\n' "$1"; }
check() { local label="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$label"; else fail "$label"; fi; }

# ── shared fixture parts ──────────────────────────────────────────────────────
ARCHIVE="$TMP/head.tar"
git -C "$PROJECT_ROOT" archive --format=tar HEAD > "$ARCHIVE" \
  || { echo "graph-update.sh: git archive HEAD failed" >&2; exit 2; }

# A shadow of every executable on PATH except the two graph tools, so "absent" is real absence
# and the real tools cannot be reached by accident. Links point at system binaries, never here.
SYSBIN="$TMP/sysbin"
mkdir -p "$SYSBIN"
declare -A SEEN=()
IFS=: read -r -a PATH_DIRS <<< "$PATH"
for dir in "${PATH_DIRS[@]}"; do
  [[ -d "$dir" && "$dir" != "$PROJECT_ROOT"* ]] || continue
  for f in "$dir"/*; do
    name="${f##*/}"
    [[ -n "${SEEN[$name]:-}" || ! -x "$f" || -d "$f" ]] && continue
    case "$name" in graphify|graphify-mcp|code-review-graph) continue ;; esac
    SEEN[$name]=1
    ln -s "$f" "$SYSBIN/$name"
  done
done
unset SEEN
[[ -e "$SYSBIN/git" && -e "$SYSBIN/bash" ]] || { echo "graph-update.sh: shadow PATH lacks git or bash" >&2; exit 2; }

# make_fixture NAME — a fresh scratch repository; sets FX (the repo) and SB (its stub bin).
make_fixture() {
  FX="$TMP/$1/repo"
  SB="$TMP/$1/stubs"
  mkdir -p "$FX" "$SB" "$TMP/$1/home"
  tar -x -C "$FX" -f "$ARCHIVE"
  cp "$PROJECT_ROOT/$HOOK_REL" "$FX/$HOOK_REL"
  local link target
  while IFS= read -r -d '' link; do
    target="$(cd "$(dirname "$link")" && realpath -m "$(readlink "$link")")"
    [[ "$target" == "$FX"* ]] || { echo "graph-update.sh: $link leaves the scratch copy" >&2; exit 2; }
  done < <(find "$FX" -type l -print0)
  git -C "$FX" init -q -b main
  git -C "$FX" add -A
  git -C "$FX" -c user.name=probe -c user.email=probe@example.invalid commit -q -m fixture
  STUB_DIRS+=("$SB")
  HOOK_PATH=""
  HOOK_ENV=()
  write_crg_stub
}

write_crg_stub() {
  printf '#!%s\nprintf "%%s\\n" "$*" >> %q\nexit 0\n' "$BASH_BIN" "$SB/crg.argv" > "$SB/code-review-graph"
  chmod +x "$SB/code-review-graph"
}

# graphify_stub MODE — install a recording graphify stub. MODE: ok | slow (3 s) | sleep5 | refuse |
# fail | nonl (output with no final newline, exit 3) | hang (records the --graphify-run processes
# above it and its own pid, then becomes a 30 s sleep, for kill_run) | termignore (ignores TERM,
# sleeps 30 s) | rc124 (graphify's own exit 124, at once). Every mode records
# GRAPHIFY_FORCE as it saw it ("<unset>" when unset) in graphify.env.
graphify_stub() {
  printf '%s\n' "$1" > "$SB/graphify.mode"
  cat > "$SB/graphify" <<STUB
#!$BASH_BIN
D=$(printf '%q' "$SB")
STUB
  cat >> "$SB/graphify" <<'STUB'
id="$(date +%s%N)-$$"
{ printf '%q ' "$@"; printf '\n'; } >> "$D/graphify.argv"
printf '%s\n' "$PWD" >> "$D/graphify.cwd"
printf '%s\n' "${GRAPHIFY_FORCE-<unset>}" >> "$D/graphify.env"
rc=0
case "$(cat "$D/graphify.mode")" in
  ok) echo "[graphify] graph updated" ;;
  slow) sleep 3 ;;
  sleep5) sleep 5 ;;
  refuse)
    echo "[graphify] WARNING: Refusing to overwrite — saved semantic node(s) are missing from the new graph: probe::node." >&2
    echo "Nothing to update or rebuild failed — check output above." >&2
    rc=1 ;;
  fail) echo "Traceback (most recent call last): probe failure" >&2; rc=2 ;;
  nonl) printf 'partial output, no newline'; rc=3 ;;
  termignore) trap '' TERM; sleep 30 ;; # ignored TERM is inherited by sleep: only KILL ends it
  rc124) echo "graphify: its own failure, exit 124" >&2; rc=124 ;;
  hang)
    p=$PPID
    while [ -n "$p" ] && [ "$p" -gt 1 ]; do
      case "$(ps -o args= -p "$p" 2>/dev/null)" in *--graphify-run*) echo "$p" >> "$D/graphify.runpid" ;; esac
      p=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ')
    done
    echo "$$" >> "$D/graphify.stubpid"
    exec sleep 30 ;;
esac
touch "$D/graphify.done.$id"
exit "$rc"
STUB
  chmod +x "$SB/graphify"
}
no_graphify() { rm -f "$SB/graphify"; }

# kill_run — SIGKILL every process a hang-mode run recorded (the hook's --graphify-run wrapper
# and graphify itself), count it finished for the waits, and give the lock a moment to drop.
kill_run() {
  local pids i
  # The hang stub records its argv before its pids, so wait (up to 3 s) for the pids it writes
  # last — killing on the argv alone races the stub (US013 QA round, 23/11/2026).
  for ((i = 0; i < 30; i++)); do [[ -s "$SB/graphify.stubpid" ]] && break; sleep 0.1; done
  pids="$(cat "$SB/graphify.runpid" "$SB/graphify.stubpid" 2>/dev/null || true)"
  [[ -n "$pids" ]] || return 1
  # shellcheck disable=SC2086 # one pid per word
  kill -KILL $pids 2>/dev/null || true
  rm -f "$SB/graphify.runpid" "$SB/graphify.stubpid"
  touch "$SB/graphify.done.killed-$(date +%s%N)"
  sleep 0.5
}

# shadow_without NAME — a copy of the shadow PATH lacking NAME; prints its directory.
shadow_without() {
  local dir f
  dir="$TMP/$(basename "$(dirname "$SB")")/sysbin-no-$1"
  mkdir -p "$dir"
  for f in "$SYSBIN"/*; do [[ "${f##*/}" == "$1" ]] || ln -s "$(readlink "$f")" "$dir/${f##*/}"; done
  printf '%s' "$dir"
}

started() { if [[ -f "$1/graphify.argv" ]]; then grep -c . "$1/graphify.argv" || true; else echo 0; fi; }
finished() { find "$1" -maxdepth 1 -name 'graphify.done.*' | grep -c . || true; }
# wait_started N — up to 3 s for N graphify starts. wait_done — every start finished, plus 1 s for
# the hook's own wrapper to record the outcome after the stub exits.
wait_started() { local i; for ((i = 0; i < 30; i++)); do [[ "$(started "$SB")" -ge "$1" ]] && return 0; sleep 0.1; done; return 1; }
wait_done() {
  local i
  for ((i = 0; i < 100; i++)); do [[ "$(started "$SB")" -le "$(finished "$SB")" ]] && break; sleep 0.1; done
  sleep 1
}

# hook [ARGS] — one PostToolUse call (or, with --commit, one pre-commit call); sets OUT
# (stdout+stderr), RC and MS (wall time until EOF). HOOK_PATH, when set, replaces the PATH;
# HOOK_ENV adds NAME=VALUE pairs to the hook's otherwise empty environment.
HOOK_PATH=""
HOOK_ENV=()
hook() {
  local t0 t1 path="${HOOK_PATH:-$SB:$SYSBIN}"
  t0="$(date +%s%N)"
  RC=0
  OUT="$(cd "$FX" && printf '{"hook_event_name":"PostToolUse","tool_name":"Edit"}' \
    | env -i HOME="$TMP/home" PATH="$path" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
        "${HOOK_ENV[@]}" "$BASH_BIN" "$HOOK_REL" "$@" 2>&1)" || RC=$?
  t1="$(date +%s%N)"
  MS=$(((t1 - t0) / 1000000))
}

# still_started N — give a wrongly started run 1.5 s to show, then require exactly N starts.
still_started() { sleep 1.5; [[ "$(started "$SB")" -eq "$1" ]]; }
crg_calls() { if [[ -f "$SB/crg.argv" ]]; then grep -c . "$SB/crg.argv" || true; else echo 0; fi; }
one_valid_json() {
  [[ "$(grep -c . <<< "$OUT")" -eq 1 ]] || return 1
  if [[ -n "$JQ" ]]; then
    printf '%s' "$OUT" | "$JQ" -e '.systemMessage | type == "string"' >/dev/null
  else
    [[ $OUT =~ ^\{\"systemMessage\":\"([^\"\\]|\\.)*\"\}$ ]]
  fi
}
G_LAST() { printf '%s' "$FX/.code-review-graph/graphify.last"; }
last_exit_is() { [[ -f "$(G_LAST)" ]] && [[ "$(tail -n 1 "$(G_LAST)")" == "exit=$1" ]]; }

says_graphify() { grep -qi 'systemMessage' <<< "$OUT" && grep -qi 'graphify' <<< "$OUT"; }
silent_graphify() { ! grep -qi 'graphify' <<< "$OUT"; }
says() { grep -qiE -- "$1" <<< "$OUT"; }
rc0() { [[ $RC -eq 0 ]]; }
no_force_recorded() { [[ ! -f "$SB/graphify.argv" ]] || ! grep -q -- '--force' "$SB/graphify.argv"; }
started_as_update_dot() { [[ -f "$SB/graphify.argv" ]] && grep -qxE "update \. ?" "$SB/graphify.argv"; }
started_at_root() { [[ -f "$SB/graphify.cwd" ]] && ! grep -vqxF "$FX" "$SB/graphify.cwd"; }
# Nothing the hook wrote may surface in `git status`: its state and lock live under an ignored dir.
clean_tree() { [[ -z "$(git -C "$FX" status --porcelain --untracked-files=all -- . ':!probe-*')" ]]; }

# ── probes ────────────────────────────────────────────────────────────────────
probe_absent() {
  make_fixture absent; no_graphify
  hook
  check "exits 0 with no graphify on PATH" rc0
  check "  and reports graphify by name in a systemMessage" says_graphify
  check "  as unmeasured" says 'unmeasured'
  check "  saying it is absent" says 'absent|not found|not on PATH|not installed'
  check "  and never claims the graph fresh" bash -c '! grep -qiE "graphify[^\"]*(fresh|up to date)" <<< "$1"' _ "$OUT"
  hook
  check "a second call, same state, exits 0" rc0
  check "  and says nothing about graphify" silent_graphify
  check "nothing the hook wrote shows in git status" clean_tree
}

probe_lock() {
  make_fixture lock; graphify_stub slow
  hook
  check "first call exits 0" rc0
  check "  and starts one graphify run" wait_started 1
  # Change the tree while the run is in flight, so the fingerprint asks for a run and only the
  # lock can refuse it (QA Q2: on an unchanged tree the fingerprint alone hid a missing flock).
  printf 'probe\n' > "$FX/probe-lock.txt"
  hook
  check "a second call, tree changed, while that run holds the lock exits 0" rc0
  check "  and reports nothing for the skip" silent_graphify
  wait_done
  check "  and no second graphify run was started (exactly 1)" test "$(started "$SB")" -eq 1
  check "  and the one run's outcome stands: exit=0" last_exit_is 0
}

probe_refuse() {
  make_fixture refuse; graphify_stub refuse
  hook
  check "first call exits 0" rc0
  check "  and starts graphify" wait_started 1
  wait_done
  hook
  check "the next call exits 0" rc0
  check "  and reports graphify in a systemMessage" says_graphify
  check "  as unmeasured" says 'unmeasured'
  check "  with its reason (Refusing to overwrite)" says 'Refusing to overwrite'
  wait_done
  hook
  check "a third call, the same refusal, says nothing more" silent_graphify
  check "no recorded graphify invocation carries --force" no_force_recorded
  check "no line of the hook carries --force" bash -c '! grep -q -- "--force" "$1"' _ "$FX/$HOOK_REL"
}

probe_success() {
  make_fixture success; graphify_stub ok
  hook
  check "exits 0" rc0
  check "  and starts graphify" wait_started 1
  check "  as exactly: graphify update ." started_as_update_dot
  check "  at the repository root" started_at_root
  check "  with no graphify message" silent_graphify
  wait_done
  hook
  check "the next call, after a successful run, is silent about graphify" silent_graphify
  check "nothing the hook wrote shows in git status" clean_tree
}

probe_fail() {
  make_fixture fail; graphify_stub fail
  hook
  check "first call exits 0" rc0
  check "  and starts graphify" wait_started 1
  wait_done
  hook
  check "the next call exits 0" rc0
  check "  and reports graphify in a systemMessage" says_graphify
  check "  as unmeasured" says 'unmeasured'
  check "  saying the run failed" says 'fail'
  wait_done
  hook
  check "a third call, the same failure, says nothing more" silent_graphify
}

probe_detached() {
  make_fixture detached; graphify_stub sleep5
  hook
  check "exits 0" rc0
  check "  and returns, output closed, inside 2 s with a 5 s graphify run (took ${MS} ms)" test "$MS" -lt 2000
  check "  and the graphify run was started all the same" wait_started 1
}

probe_regression() {
  make_fixture regression; graphify_stub ok
  hook
  check "a clean tree: exit 0, no untracked notice" bash -c '[[ $1 -eq 0 ]] && ! grep -q "untracked" <<< "$2"' _ "$RC" "$OUT"
  printf 'x = 1\n' > "$FX/probe-new.py"
  printf '# notes\n' > "$FX/probe-notes.md"
  hook
  check "one untracked .py: the notice fires, singular" says '"systemMessage":"Graph refreshed, but 1 untracked source file is outside it'
  check "  and the .md beside it is not counted" bash -c '! grep -q "2 untracked" <<< "$1"' _ "$OUT"
  hook
  check "the same set again: no untracked notice" bash -c '! grep -q "untracked" <<< "$1"' _ "$OUT"
  printf 'echo hi\n' > "$FX/probe-new.sh"
  hook
  check "a second untracked .sh: the notice fires again, plural" says 'but 2 untracked source files are outside it'
  git -C "$FX" add probe-new.py probe-new.sh
  hook
  check "both staged: no untracked notice" bash -c '! grep -q "untracked" <<< "$1"' _ "$OUT"
  check "code-review-graph ran update --skip-flows on every call (5)" \
    bash -c '[[ $(grep -cx "update --skip-flows" "$1") -eq 5 ]]' _ "$SB/crg.argv"
}

probe_one_json() {
  make_fixture one-json; no_graphify
  printf 'x = 1\n' > "$FX/probe-new.py"
  hook
  check "exits 0" rc0
  check "  stdout is a single line" test "$(grep -c . <<< "$OUT")" -eq 1
  if [[ -n "$JQ" ]]; then
    check "  which parses as one JSON object with a systemMessage" \
      bash -c 'printf "%s" "$1" | "$2" -e ".systemMessage | type == \"string\"" >/dev/null' _ "$OUT" "$JQ"
  else
    check "  which is one {\"systemMessage\": ...} object" bash -c '[[ $1 == "{\"systemMessage\":"*"}" ]]' _ "$OUT"
  fi
  check "  carrying the untracked notice" says 'untracked source file'
  check "  and graphify reported unmeasured" bash -c 'grep -qi graphify <<< "$1" && grep -qi unmeasured <<< "$1"' _ "$OUT"
}

# ── review-fix probes (M1, M2, m5, n1, n2) ────────────────────────────────────
probe_fp() {
  make_fixture fp; graphify_stub ok
  mkdir -p "$FX/graphify-out"
  printf '{}\n' > "$FX/graphify-out/graph.json"
  touch -d '2026-01-01 00:00:00' "$FX/graphify-out/graph.json"
  hook
  check "first call starts one run" wait_started 1
  wait_done
  hook
  check "a second call on the unchanged tree starts nothing (still 1)" still_started 1
  hook
  check "  nor does a third (still 1)" still_started 1
  check "  and the fingerprint is recorded in .code-review-graph/graphify.fp" \
    test -s "$FX/.code-review-graph/graphify.fp"
  printf 'probe\n' > "$FX/probe-change.txt"
  hook
  check "an untracked file re-arms it: one more run (2)" wait_started 2
  wait_done
  hook
  check "  and the call after that run starts nothing (still 2)" still_started 2
  printf 'edit one\n' >> "$FX/README.md"
  hook
  check "an edit to a tracked file re-arms it (3)" wait_started 3
  wait_done
  printf 'edit two\n' >> "$FX/README.md"
  hook
  check "a second edit to the same file (same status, new diff) re-arms it (4)" wait_started 4
  wait_done
  touch -d '2026-06-01 00:00:00' "$FX/graphify-out/graph.json"
  hook
  check "a rebuilt graphify-out/graph.json (new mtime) re-arms it (5)" wait_started 5
  wait_done
  hook
  check "  and the next call starts nothing (still 5)" still_started 5
}

probe_commit() {
  make_fixture commit; graphify_stub sleep5
  hook --commit
  check "--commit with no run recorded exits 0" rc0
  check "  returns inside 2 s with a 5 s graphify run (took ${MS} ms)" test "$MS" -lt 2000
  check "  reports graphify unmeasured" bash -c 'grep -qi graphify <<< "$1" && grep -qi unmeasured <<< "$1"' _ "$OUT"
  check "  saying no outcome is recorded yet" says 'no (graphify )?(run|outcome|update)[a-z ]* recorded|none recorded|not yet recorded'
  check "  and starts the detached refresh" wait_started 1
  check "  as exactly: graphify update ." started_as_update_dot
  check "  without calling code-review-graph (lefthook owns that step)" test "$(crg_calls)" -eq 0
  wait_done
  hook --commit
  check "--commit after a successful run exits 0" rc0
  check "  and says nothing unmeasured about graphify" bash -c '! grep -qi unmeasured <<< "$1"' _ "$OUT"
  check "  and, the tree unchanged, starts nothing (still 1)" still_started 1
  graphify_stub refuse
  printf 'probe\n' > "$FX/probe-commit-a.txt"
  hook
  check "a per-edit call on a changed tree starts the refusing run (2)" wait_started 2
  wait_done
  hook --commit
  check "--commit after a refusal exits 0" rc0
  check "  reports it unmeasured" says 'unmeasured'
  check "  with its reason (Refusing to overwrite)" says 'Refusing to overwrite'
  hook --commit
  check "  and reports it again at the next commit (every commit, not once)" says 'Refusing to overwrite'
  graphify_stub fail
  printf 'probe\n' > "$FX/probe-commit-b.txt"
  hook --commit
  check "--commit on a changed tree starts the refresh itself (3)" wait_started 3
  wait_done
  hook --commit
  check "--commit after a failed run reports it unmeasured" says 'unmeasured'
  check "  saying the run failed" says 'fail'
  check "only the one per-edit call ran code-review-graph (1)" test "$(crg_calls)" -eq 1
  check "no recorded graphify invocation carries --force" no_force_recorded
  no_graphify
  hook --commit
  check "--commit with no graphify on PATH exits 0" rc0
  check "  reporting it unmeasured and absent" bash -c 'grep -qi unmeasured <<< "$1" && grep -qiE "absent|not on PATH" <<< "$1"' _ "$OUT"
}

probe_nolock() {
  make_fixture nolock; graphify_stub ok
  local nolock="$TMP/nolock/sysbin"
  mkdir -p "$nolock"
  local f
  for f in "$SYSBIN"/*; do [[ "${f##*/}" == flock ]] || ln -s "$(readlink "$f")" "$nolock/${f##*/}"; done
  HOOK_PATH="$SB:$nolock"
  hook
  check "exits 0 with no flock on PATH" rc0
  check "  reports graphify unmeasured" bash -c 'grep -qi graphify <<< "$1" && grep -qi unmeasured <<< "$1"' _ "$OUT"
  check "  naming flock" says 'flock'
  check "  and starts no run" still_started 0
  hook
  check "a second call, same state, says nothing about graphify" silent_graphify
}

probe_rc() {
  make_fixture rc; graphify_stub ok
  mkdir -p "$FX/.code-review-graph"
  # The same hostile code under both contracts: the legacy .rc file and the single-file trailer.
  printf 'Traceback (most recent call last): probe\nexit=7"}\\x\n' > "$(G_LAST)"
  printf '7"}\\x\n' > "$FX/.code-review-graph/graphify.last.rc"
  hook
  check "exits 0 with a non-numeric recorded exit code" rc0
  check "  stdout is ONE valid JSON line with a systemMessage" one_valid_json
  check "  reporting the run failed" says 'fail'
  check "  with the code sanitised to digits (no raw quote or backslash from it)" \
    bash -c '! grep -qF "7\"}" <<< "$1" && ! grep -qF "\\x" <<< "$1"' _ "$OUT"
}

probe_atomic() {
  make_fixture atomic; graphify_stub refuse
  hook
  check "a refusing run starts" wait_started 1
  wait_done
  check "  its outcome is one file whose last line is exit=1" last_exit_is 1
  check "  carrying the output too (Refusing to overwrite)" grep -q 'Refusing to overwrite' "$(G_LAST)"
  check "  and no separate graphify.last.rc is written" test ! -e "$FX/.code-review-graph/graphify.last.rc"
  graphify_stub fail
  printf 'probe\n' > "$FX/probe-atomic-a.txt"
  hook
  check "a failing run starts" wait_started 2
  wait_done
  check "  its outcome's last line is exit=2" last_exit_is 2
  graphify_stub ok
  printf 'probe\n' > "$FX/probe-atomic-b.txt"
  hook
  check "a successful run starts" wait_started 3
  wait_done
  check "  its outcome's last line is exit=0" last_exit_is 0
  check "no temporary is left beside it" bash -c '! ls "$1"/graphify.last*.tmp* >/dev/null 2>&1' _ "$FX/.code-review-graph"
  # A torn pair: the new refusal in graphify.last, a stale success in graphify.last.rc.
  printf '%s\n' '[graphify] WARNING: Refusing to overwrite — probe' 'exit=1' > "$(G_LAST)"
  printf '0\n' > "$FX/.code-review-graph/graphify.last.rc"
  rm -f "$FX/.code-review-graph/.graphify-notice"
  hook
  check "a stale graphify.last.rc is never paired with the output: the refusal is reported" \
    says 'Refusing to overwrite'
}

# ── QA-fix probes (Q1 to Q7, Q12) ─────────────────────────────────────────────
# rearms LABEL / no_rearm LABEL — one per-edit call, then exactly one more start / none, counted
# from the starts before it, so one step's verdict never shifts the next step's count.
rearms() {
  local before
  before="$(started "$SB")"
  hook
  check "$1 ($((before + 1)))" wait_started "$((before + 1))"
  wait_done
}
no_rearm() {
  local before
  before="$(started "$SB")"
  hook
  check "$1 (still $before)" still_started "$before"
}
force_never_seen() { [[ -s "$SB/graphify.env" ]] && ! grep -vqxF '<unset>' "$SB/graphify.env"; }

probe_env_force() {
  make_fixture env-force; graphify_stub ok
  HOOK_ENV=(GRAPHIFY_FORCE=1)
  hook
  check "per edit, GRAPHIFY_FORCE=1 exported: exits 0 and starts a run" wait_started 1
  wait_done
  check "  and graphify ran with GRAPHIFY_FORCE unset" force_never_seen
  printf 'probe\n' > "$FX/probe-force.txt"
  hook --commit
  check "--commit, GRAPHIFY_FORCE=1 exported: starts a run" wait_started 2
  wait_done
  check "  and graphify ran with GRAPHIFY_FORCE unset in that mode too (2 of 2)" \
    bash -c '[[ $(grep -cxF "<unset>" "$1") -eq 2 ]]' _ "$SB/graphify.env"
  check "no recorded graphify invocation carries --force" no_force_recorded
}

# git_wrapper — a recording git ahead of the shadow one: GIT_OPTIONAL_LOCKS|GIT_INDEX_FILE|argv.
git_wrapper() {
  cat > "$SB/git" <<STUB
#!$BASH_BIN
{ printf '%s|%s|' "\${GIT_OPTIONAL_LOCKS-<unset>}" "\${GIT_INDEX_FILE-<unset>}"; printf '%q ' "\$@"; printf '\n'; } >> $(printf '%q' "$SB/git.argv")
exec $(printf '%q' "$SYSBIN/git") "\$@"
STUB
  chmod +x "$SB/git"
}
# git_lock_free — the hook's recorded git calls never take .git/index.lock: status and diff carry
# --no-optional-locks (or GIT_OPTIONAL_LOCKS=0); index writers name another GIT_INDEX_FILE.
git_lock_free() {
  local line locks rest idx nol sub i
  local -a a
  [[ -s "$SB/git.argv" ]] || return 1
  while IFS= read -r line; do
    locks="${line%%|*}"; rest="${line#*|}"; idx="${rest%%|*}"
    read -r -a a <<< "${rest#*|}"
    nol=false; [[ "$locks" == 0 ]] && nol=true
    i=0
    while [[ "${a[i]:-}" == -* ]]; do
      [[ "${a[i]}" == --no-optional-locks ]] && nol=true
      case "${a[i]}" in -C|-c) i=$((i + 2)) ;; *) i=$((i + 1)) ;; esac
    done
    sub="${a[i]:-}"
    case "$sub" in
      status|diff) $nol || { echo "takes optional locks: $line"; return 1; } ;;
      write-tree|add|update-index|read-tree|reset|rm|mv|stash|checkout|commit)
        [[ "$idx" != "<unset>" && "$idx" != *.git/index ]] || { echo "writes .git/index: $line"; return 1; } ;;
    esac
  done < "$SB/git.argv"
}

probe_git_locks() {
  make_fixture git-locks; graphify_stub ok; git_wrapper
  printf 'edit\n' >> "$FX/README.md"
  printf 'probe\n' > "$FX/probe-locks.txt"
  hook
  check "per edit: exits 0 and starts a run" wait_started 1
  wait_done
  printf 'edit two\n' >> "$FX/README.md"
  hook --commit
  check "--commit: starts a run" wait_started 2
  wait_done
  check "the hook's git calls were recorded" test -s "$SB/git.argv"
  check "  and none of them takes .git/index.lock (status/diff with --no-optional-locks)" git_lock_free
  check "  and no .git/index.lock is left" test ! -e "$FX/.git/index.lock"
}

probe_killed() {
  make_fixture killed; graphify_stub ok
  hook
  check "a first run completes with exit=0" bash -c 'for ((i=0;i<50;i++)); do [[ -f "$1" ]] && [[ "$(tail -n 1 "$1")" == exit=0 ]] && exit 0; sleep 0.1; done; exit 1' _ "$(G_LAST)"
  wait_done
  graphify_stub hang
  printf 'probe\n' > "$FX/probe-killed.txt"
  hook
  check "a changed tree starts a second run, which hangs (2)" wait_started 2
  hook
  check "  while it is in flight a call is silent about graphify" silent_graphify
  check "  and starts nothing more (still 2)" still_started 2
  check "  the run is killed mid-way (SIGKILL)" kill_run
  hook --commit
  check "--commit after the killed run reports graphify unmeasured (not the old exit=0)" \
    bash -c 'grep -qi graphify <<< "$1" && grep -qi unmeasured <<< "$1"' _ "$OUT"
  check "  and retries the same tree (3)" wait_started 3
  check "  that retry is killed too" kill_run
  graphify_stub ok
  hook
  check "the next per-edit call reports graphify unmeasured" \
    bash -c 'grep -qi graphify <<< "$1" && grep -qi unmeasured <<< "$1"' _ "$OUT"
  check "  as one valid JSON line" one_valid_json
  check "  and retries the same tree once more (4)" wait_started 4
  wait_done
  check "  which records exit=0" last_exit_is 0
  check "  and leaves no stale graphify.last.tmp.* behind" \
    bash -c '! ls "$1"/graphify.last.tmp.* >/dev/null 2>&1' _ "$FX/.code-review-graph"
  hook
  check "the call after that is silent about graphify" silent_graphify
  check "  and starts nothing (still 4)" still_started 4
}

probe_content() {
  make_fixture content; graphify_stub ok
  hook
  check "first call starts one run" wait_started 1
  wait_done
  git -C "$FX" -c user.name=probe -c user.email=probe@example.invalid commit -q --allow-empty -m empty
  no_rearm "a content-free commit (--allow-empty) re-arms nothing"
  printf 'staged\n' >> "$FX/README.md"
  git -C "$FX" add README.md
  rearms "a staged-only change re-arms it"
  git -C "$FX" mv VERSION probe-VERSION
  rearms "a staged rename, content unchanged, re-arms it"
  mkdir -p "$FX/probe-dir/sub"
  printf 'a\n' > "$FX/probe-dir/sub/a.txt"
  rearms "a nested untracked file re-arms it"
  printf 'b\n' > "$FX/probe-dir/sub/b.txt"
  rearms "a second untracked file in the same nested directory re-arms it"
  printf 'more\n' >> "$FX/probe-dir/sub/a.txt"
  rearms "an edit to an untracked file's content re-arms it"
  no_rearm "  and the call after that starts nothing"
}

probe_newline() {
  make_fixture newline; graphify_stub nonl
  hook
  check "a run whose output has no final newline starts" wait_started 1
  wait_done
  check "  its outcome's last line is still exit=3" last_exit_is 3
  check "  with the output kept on its own line" grep -qxF 'partial output, no newline' "$(G_LAST)"
  hook
  check "the next call reports graphify unmeasured" says 'unmeasured'
  check "  saying the run failed, exit 3" bash -c 'grep -qi fail <<< "$1" && grep -q "exit 3" <<< "$1"' _ "$OUT"
}

probe_setsid() {
  make_fixture setsid; graphify_stub ok
  cat > "$SB/setsid" <<STUB
#!$BASH_BIN
printf '%s\n' "\$*" >> $(printf '%q' "$SB/setsid.argv")
exec $(printf '%q' "$SYSBIN/setsid") "\$@"
STUB
  chmod +x "$SB/setsid"
  hook
  check "setsid on PATH: a run starts" wait_started 1
  wait_done
  check "  through setsid (its own session)" grep -q -- '--graphify-run' "$SB/setsid.argv"
  rm -f "$SB/setsid"
  graphify_stub sleep5
  HOOK_PATH="$SB:$(shadow_without setsid)"
  printf 'probe\n' > "$FX/probe-setsid.txt"
  hook
  check "no setsid on PATH: exits 0" rc0
  check "  returns inside 2 s with a 5 s graphify run (took ${MS} ms)" test "$MS" -lt 2000
  check "  and the run starts all the same (2)" wait_started 2
}

# ── bugfix probes: an unbounded run, a stranded marker, the lock_free window ──
# await_last RE [TENTHS] — up to TENTHS/10 s (default 4 s) for graphify.last's last line to match RE.
await_last() {
  local i
  for ((i = 0; i < ${2:-40}; i++)); do
    [[ -f "$(G_LAST)" && "$(tail -n 1 "$(G_LAST)")" =~ $1 ]] && return 0; sleep 0.1
  done
  return 1
}
# last_two_are A B — graphify.last ends with line A then line B (the timeout marker, then the trailer).
last_two_are() { [[ -f "$(G_LAST)" ]] && [[ "$(tail -n 2 "$(G_LAST)")" == "$1"$'\n'"$2" ]]; }
no_timeout_marker() { [[ -f "$(G_LAST)" ]] && ! grep -q '^timeout=' "$(G_LAST)"; }
never_says() { ! grep -qiE -- "$1" <<< "$OUT"; }

# The run's graphify call (the `timeout -k … graphify update .` line in the --graphify-run block)
# must be bounded: unbounded, a hung run would keep the lock and the marker for good. The bound
# that fired is written as `timeout=<N>` just before the `exit=<rc>` trailer.
probe_timeout() {
  make_fixture timeout; graphify_stub sleep5
  HOOK_ENV=(GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1)
  hook
  check "a 5 s graphify under GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1 starts" wait_started 1
  check "  and is stopped: graphify.last ends exit=124 inside 4 s" await_last '^exit=124$'
  check "  preceded by the run's bound: timeout=1 then exit=124" last_two_are 'timeout=1' 'exit=124'
  hook
  check "the next call reports it timed out after 1 s" says 'graphify unmeasured: its last update timed out after 1 s'
  check "  naming graphify.last" says 'graphify\.last'
  hook
  check "a third call, the same timeout, says nothing more" silent_graphify
  hook --commit
  check "--commit reports the timeout" says 'timed out after 1 s'
  hook --commit
  check "  and again at the next commit (every commit)" says 'timed out after 1 s'
  touch "$SB/graphify.done.timeout-$(date +%s%N)" # a stopped stub never records its own end
}

# The fix bounds the run with `timeout`; with none on PATH nothing may start unbounded.
probe_notimeout() {
  make_fixture notimeout; graphify_stub ok
  HOOK_PATH="$SB:$(shadow_without timeout)"
  hook
  check "exits 0 with no timeout on PATH" rc0
  check "  reports graphify unmeasured: timeout is not on PATH" says 'graphify unmeasured: timeout is not on PATH'
  check "  and starts no run" still_started 0
  hook --commit
  check "--commit reports it too" says 'timeout is not on PATH'
}

# The run marker (graphify.running) is written before the run's mktemp: a failed mktemp that
# simply exited would release the lock and leave the marker, so every later call would read
# `killed` and restart the same tree. The run must record a failed outcome and clear the marker.
probe_mktemp() {
  make_fixture mktemp; graphify_stub ok
  printf '#!%s\nprintf "%%s\\n" "$*" >> %q\nexit 1\n' "$BASH_BIN" "$SB/mktemp.argv" > "$SB/mktemp"
  chmod +x "$SB/mktemp"
  hook
  check "a run whose mktemp fails records a failed outcome (exit=<non-zero>)" await_last '^exit=[1-9][0-9]*$'
  check "  and leaves no graphify.running" test ! -e "$FX/.code-review-graph/graphify.running"
  local runs; runs="$(grep -c . "$SB/mktemp.argv" 2>/dev/null || echo 0)"
  hook
  check "the next call reports the failure" says 'graphify unmeasured: its last update failed'
  check "  never as killed or unfinished" bash -c '! grep -qiE "killed|did not finish" <<< "$1"' _ "$OUT"
  hook
  check "  and neither call restarts the same tree (mktemp still $runs)" \
    bash -c 'sleep 1.5; [[ $(grep -c . "$1") -eq $2 ]]' _ "$SB/mktemp.argv" "$runs"
}

# lock_free() takes the lock for an instant; the run's `flock -w 1 9` must ride that instant out
# (a non-blocking flock landing in it would exit unrun) yet still give way to a run in flight.
# hold_lock SECS holds graphify.lock from the probe, returning once it is held.
hold_lock() {
  local ready="$FX/../held.$1" i
  mkdir -p "$FX/.code-review-graph"
  flock "$FX/.code-review-graph/graphify.lock" -c "touch '$ready'; sleep $1" & HOLDERS+=("$!")
  for ((i = 0; i < 30; i++)); do [[ -e "$ready" ]] && return 0; sleep 0.1; done; return 1
}
probe_lockwait() {
  make_fixture lockwait; graphify_stub ok
  hold_lock 0.7
  hook
  check "a lock held 0.7 s (a lock_free instant, stretched) as the run starts does not stop it" wait_started 1
  wait_done
  local n; n="$(started "$SB")"
  printf 'probe\n' > "$FX/probe-lockwait.txt"
  hold_lock 2.5
  hook
  check "a lock held 2.5 s (a run in flight) starts no second graphify (still $n)" still_started "$n"
  wait "${HOLDERS[-1]}" 2>/dev/null || true
  check "  nor once it is released (still $n)" still_started "$n"
}

# ── bugfix 2 probes: timed out is the run's marker, never an exit code (M1, M2, L1) ──
# A graphify ignoring TERM outlives the bound; `timeout -k` SIGKILLs it after the kill grace, so
# the run ends exit=137 — still the bound firing, so still a timeout, and still marked as one.
probe_timeout_kill() {
  make_fixture timeout-kill; graphify_stub termignore
  HOOK_ENV=(GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1)
  hook
  check "a TERM-ignoring graphify under GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1 starts" wait_started 1
  # 1 s bound + the hook's 10 s kill grace + margin: polled, up to 16 s.
  check "  and is killed: graphify.last ends exit=137 inside 16 s" await_last '^exit=137$' 160
  check "  preceded by the run's bound: timeout=1 then exit=137" last_two_are 'timeout=1' 'exit=137'
  hook
  check "the next call reports it timed out after 1 s" says 'graphify unmeasured: its last update timed out after 1 s'
  check "  never as a failure (exit 137)" never_says 'failed|exit 137'
  touch "$SB/graphify.done.timeout-kill-$(date +%s%N)" # a killed stub never records its own end
}

# The reader must print the bound the run had, read from the run's own marker, never its own env.
probe_timeout_reader() {
  make_fixture timeout-reader; graphify_stub sleep5
  HOOK_ENV=(GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1)
  hook
  check "a 5 s graphify under GRAPH_UPDATE_GRAPHIFY_TIMEOUT=1 starts" wait_started 1
  check "  and is stopped: graphify.last ends exit=124 inside 4 s" await_last '^exit=124$'
  touch "$SB/graphify.done.timeout-reader-$(date +%s%N)" # a stopped stub never records its own end
  HOOK_ENV=()
  hook
  check "the next per-edit call, no GRAPH_UPDATE_GRAPHIFY_TIMEOUT, says after 1 s" says 'timed out after 1 s'
  check "  never the reader's own 600 s" never_says 'after 600 s'
  hook --commit
  check "--commit, no GRAPH_UPDATE_GRAPHIFY_TIMEOUT, says after 1 s" says 'timed out after 1 s'
  check "  never the reader's own 600 s" never_says 'after 600 s'
  check "  and the unchanged tree started no second run (still 1)" still_started 1
}

# graphify's own exit 124, at once and far inside the bound: no bound fired, so no marker, and it
# is an ordinary failure.
probe_rc124() {
  make_fixture rc124; graphify_stub rc124
  hook
  check "a graphify exiting 124 at once starts" wait_started 1
  wait_done
  check "  graphify.last ends exit=124" last_exit_is 124
  check "  with no timeout= marker (the bound never fired)" no_timeout_marker
  hook
  check "the next call reports it failed (exit 124)" says 'graphify unmeasured: its last update failed \(exit 124\)'
  check "  never as timed out" never_says 'timed out'
  hook --commit
  check "--commit reports it failed (exit 124) too" says 'failed \(exit 124\)'
  check "  never as timed out" never_says 'timed out'
}

# timeout_recorder — a timeout ahead of the shadow one that records its argv, then execs the real one.
timeout_recorder() {
  cat > "$SB/timeout" <<STUB
#!$BASH_BIN
printf '%s\n' "\$*" >> $(printf '%q' "$SB/timeout.argv")
exec $(printf '%q' "$SYSBIN/timeout") "\$@"
STUB
  chmod +x "$SB/timeout"
}
# bound_was N — the most recent recorded timeout call bounded `graphify update .` at N seconds.
bound_was() {
  [[ -s "$SB/timeout.argv" ]] && [[ "$(tail -n 1 "$SB/timeout.argv")" =~ (^|\ )$1\ graphify\ update\ \.$ ]]
}
probe_timeout_env() {
  make_fixture timeout-env; graphify_stub ok; timeout_recorder
  local v n=0 i=0
  # The control first: a valid value is passed through, so the recorder sees the bound at all.
  HOOK_ENV=(GRAPH_UPDATE_GRAPHIFY_TIMEOUT=7)
  printf 'probe\n' > "$FX/probe-env-control.txt"
  hook; n=$((n + 1))
  check "GRAPH_UPDATE_GRAPHIFY_TIMEOUT=7 starts a run (control)" wait_started "$n"
  wait_done
  check "  bounded at 7 s" bound_was 7
  for v in 1.5 10m 010 0 '' ' 5'; do
    i=$((i + 1))
    HOOK_ENV=("GRAPH_UPDATE_GRAPHIFY_TIMEOUT=$v")
    printf 'probe\n' > "$FX/probe-env-$i.txt"
    hook; n=$((n + 1))
    check "GRAPH_UPDATE_GRAPHIFY_TIMEOUT='$v' starts a run ($n)" wait_started "$n"
    wait_done
    check "  bounded at the 600 s fallback" bound_was 600
  done
}

for p in "${PROBES[@]}"; do
  echo "$p"
  "probe_${p//-/_}"
done

printf '\n%d passed, %d failed\n' "$PASSES" "$FAILS"
[[ $FAILS -eq 0 ]]
