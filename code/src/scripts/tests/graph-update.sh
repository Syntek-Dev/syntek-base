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
#   lock        a run in flight (a stub that sleeps 3 s): a second call starts no second run,
#               and reports nothing for the skip
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

ALL_PROBES=(absent lock refuse success fail detached regression one-json)
PROBES=()
KEEP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --probe) [[ $# -ge 2 ]] || { echo "graph-update.sh: --probe needs a name" >&2; exit 2; }
             PROBES+=("$2"); shift 2 ;;
    --keep) KEEP=true; shift ;;
    --help|-h) sed -n '4,45p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
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
STUB_DIRS=()
cleanup() {
  local d i
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
  write_crg_stub
}

write_crg_stub() {
  printf '#!%s\nprintf "%%s\\n" "$*" >> %q\nexit 0\n' "$BASH_BIN" "$SB/crg.argv" > "$SB/code-review-graph"
  chmod +x "$SB/code-review-graph"
}

# graphify_stub MODE — install a recording graphify stub. MODE: ok | slow (3 s) | sleep5 | refuse | fail.
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
esac
touch "$D/graphify.done.$id"
exit "$rc"
STUB
  chmod +x "$SB/graphify"
}
no_graphify() { rm -f "$SB/graphify"; }

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

# hook — one PostToolUse call; sets OUT (stdout+stderr), RC and MS (wall time until EOF).
hook() {
  local t0 t1
  t0="$(date +%s%N)"
  RC=0
  OUT="$(cd "$FX" && printf '{"hook_event_name":"PostToolUse","tool_name":"Edit"}' \
    | env -i HOME="$TMP/home" PATH="$SB:$SYSBIN" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
        "$BASH_BIN" "$HOOK_REL" 2>&1)" || RC=$?
  t1="$(date +%s%N)"
  MS=$(((t1 - t0) / 1000000))
}

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
  hook
  check "a second call while that run holds the lock exits 0" rc0
  check "  and reports nothing for the skip" silent_graphify
  wait_done
  check "  and no second graphify run was started (exactly 1)" test "$(started "$SB")" -eq 1
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

for p in "${PROBES[@]}"; do
  echo "$p"
  "probe_${p//-/_}"
done

printf '\n%d passed, %d failed\n' "$PASSES" "$FAILS"
[[ $FAILS -eq 0 ]]
