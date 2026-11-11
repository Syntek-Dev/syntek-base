#!/usr/bin/env bash
#
# audit.sh — One verdict over every ecosystem's dependency audit, and every lockfile against its manifest.
#
# Three ecosystems, three advisory tools and three lockfile formats, each with its own exit
# code and its own idea of "clean". This puts ONE command and ONE exit code over all of them,
# so "are the dependencies safe and locked" has an answer a gate can read — it is the
# reporting twin of update.sh, which moves them.
#
# THE SIX LEGS, each delegated to the tool or script that already owns it — the three lockfile
# legs first, then the three advisory legs, because an advisory tool re-locks (see "Two passes"):
#   python-advisories      audits/security.sh --py-only   (pip-audit over every uv group)
#   javascript-advisories  audits/security.sh --js-only   (pnpm audit — the root AND every
#                                                          workspace member, one lockfile)
#   rust-advisories        rust/audit.sh                  (cargo-deny: advisories, licences,
#                                                          bans, sources — yanked crates too)
#   python-lockfile        uv lock --check                (update.sh's own --check test)
#   javascript-lockfile    pnpm install --frozen-lockfile --lockfile-only  (writes nothing)
#   rust-lockfile          cargo metadata --locked        (fails if Cargo.lock would move)
#
# The advisory legs read the tools' own allowlists — pnpm's audit.ignore, deny.toml — so an
# accepted advisory is the owning tool's decision, never one made here.
#
# EACH LEG ENDS IN ONE OF FOUR STATES (code/docs/GATE-REPORTING.md, Section 2):
#   clean        it ran, over a population it names, and found nothing
#   finding      it ran and found something — an advisory, a ban, a lockfile out of step
#   not present  the SURFACE is absent: no pyproject.toml, no package.json, no code/src/rust.
#                Nothing of that kind is here, so this is correctly not a failure
#   NOT RUN      the surface is present and the TOOL is missing, or it ran and failed for a
#                reason that is not a finding (a network error, an unparseable manifest). The
#                population was never examined, so this is never clean
#
# A non-zero exit from a tool is not a finding by itself: each leg's output is matched against
# the shape that tool prints for a real result, and anything else is NOT RUN. That
# classification is what --self-test proves, against captured transcripts in
# audits/fixtures/dependencies-audit/ — "<leg>.<state>.<exit>.txt" — and its run probes then
# drive this script end to end over a scratch tree, with run/stubs/ standing in for the tools.
#
# THE VERDICT, AND WHY UNMEASURED IS EXIT 2:
#   0  every present leg ran clean
#   1  at least one finding — whatever else is true; a finding is a fact about the
#      dependency set and the fix is to the dependency set
#   2  no finding, and at least one leg NOT RUN ("unmeasured"); or a script error.
# Unmeasured is never 0, because that would print "clean" over a population nobody opened.
# It is 2 rather than 1 because the fix is to the ENVIRONMENT — install the tool, restore the
# network — not to the dependencies, which is exactly what this project's 2 means elsewhere:
# "a prerequisite the caller must fix". A finding outranks it: it is known-true and actionable,
# and the summary still names every leg that did not run.
#
# Usage: audit.sh [--ecosystem NAME]... [--output FORMAT] [--output-file PATH] [--quiet]
#                 [--self-test] [--help]
#
# Exit codes:  0 = clean   1 = findings   2 = unmeasured, or script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
SCRIPTS_DIR="$PROJECT_ROOT/code/src/scripts"
REPORTS_DIR="$SCRIPTS_DIR/reports"
RUST_DIR="$PROJECT_ROOT/code/src/rust"
FIXTURES_DIR="$SCRIPTS_DIR/audits/fixtures/dependencies-audit"

LEGS=(python-advisories javascript-advisories rust-advisories
      python-lockfile javascript-lockfile rust-lockfile)

ECOSYSTEMS=()
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
SELF_TEST=false
ROWS=()   # "leg|state|population|detail"

log()  { $QUIET || printf '%s\n' "$*"; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }
die()  { printf 'audit.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
audit.sh — one verdict over every dependency audit and every lockfile (Python, JavaScript, Rust)

Usage:
  audit.sh                       Run every leg whose surface is present
  audit.sh --ecosystem rust      Restrict to one ecosystem (repeatable)
  audit.sh --self-test           Prove the classifier against captured tool output

Options:
  --ecosystem NAME    python | javascript | rust (repeat for several; default: all)
  --output FORMAT     Write a report: md | txt | json
  --output-file PATH  Override the report path
                        (default: code/src/scripts/reports/dependency-audit.<FORMAT>)
  --quiet             Suppress terminal output — requires --output
  --self-test         Classify fixtures/dependencies-audit/*, the verdict table, and run the
                        script over a scratch tree with stub tools; needs no tools
  --help              Show this help

Legs:   advisories — audits/security.sh (pip-audit, pnpm audit) and rust/audit.sh (cargo-deny)
        lockfiles  — uv lock --check · pnpm --frozen-lockfile --lockfile-only · cargo --locked

States: clean · finding · not present (no such surface) · NOT RUN (tool missing or failed)

Exit codes:
  0  every present leg clean
  1  at least one finding
  2  nothing found but at least one leg NOT RUN (unmeasured) — or a script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ecosystem)   [[ $# -ge 2 ]] || die "--ecosystem needs a value"; ECOSYSTEMS+=("$2"); shift 2 ;;
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --self-test)   SELF_TEST=true; shift ;;
    --help|-h)     usage; exit 0 ;;
    --path)        die "--path is not accepted; the manifests and lockfiles are at fixed paths" ;;
    *)             die "unknown option: $1 (try --help)" ;;
  esac
done
[[ ${#ECOSYSTEMS[@]} -gt 0 ]] || ECOSYSTEMS=(python javascript rust)
for e in "${ECOSYSTEMS[@]}"; do
  case "$e" in python|javascript|rust) ;; *) die "unknown --ecosystem: $e (python | javascript | rust)" ;; esac
done
[[ -n "$OUTPUT_FORMAT" ]] || ! $QUIET || die "--quiet requires --output"
case "${OUTPUT_FORMAT:-md}" in md|txt|json) ;; *) die "unknown format: $OUTPUT_FORMAT (md | txt | json)" ;; esac

wants() { local e; for e in "${ECOSYSTEMS[@]}"; do [[ "$e" == "$1" ]] && return 0; done; return 1; }

# ── The classifier — the one piece of judgement here, and what --self-test proves ──
# classify LEG EXIT FILE -> prints clean | finding | unmeasured
classify() {
  local leg="$1" rc="$2" file="$3" pattern
  [[ "$rc" -eq 0 ]] && { echo clean; return 0; }
  case "$leg" in
    python-advisories)     pattern='Found [0-9]+ known vulnerabilit' ;;
    javascript-advisories) pattern='[0-9]+ vulnerabilit(y|ies) found' ;;
    rust-advisories)       pattern='(advisories|bans|licenses|sources) FAILED' ;;
    python-lockfile)       pattern='needs to be updated' ;;
    javascript-lockfile)   pattern='ERR_PNPM_OUTDATED_LOCKFILE|is not up to date with' ;;
    rust-lockfile)         pattern='cannot update the lock file|lock file needs to be updated' ;;
    *) die "classify: unknown leg $leg" ;;
  esac
  if grep -qE "$pattern" "$file"; then echo finding; else echo unmeasured; fi
}

# verdict STATE... -> prints the exit code the states earn
verdict() {
  local s finding=false unmeasured=false
  for s in "$@"; do
    case "$s" in finding) finding=true ;; unmeasured) unmeasured=true ;; esac
  done
  if $finding; then echo 1; elif $unmeasured; then echo 2; else echo 0; fi
}

# ── Run probes — the script itself, end to end, over a scratch tree ────────────
# The transcripts prove the classifier; they never drive run_leg, the leg order or the
# delegated scripts, and all three have shipped a defect the transcripts could not see. So
# each probe copies this script, audits/security.sh and rust/audit.sh into a scratch project
# whose lockfiles are STALE (their manifests have moved on), puts the stand-ins in
# fixtures/dependencies-audit/run/stubs/ first on PATH, runs it, and asserts on what came out.
# The stubs re-lock exactly where the real tools do, so a probe catches an audit that edits the
# tree it is auditing. They need nothing installed — the self-test stays tool-free.
PROBE_STUBS="$FIXTURES_DIR/run/stubs"
PROBES_RUN=0

probe_tree() {   # probe_tree ROOT — build the scratch project
  local root="$1" s
  s="$root/code/src/scripts"
  mkdir -p "$s/dependencies" "$s/audits" "$s/_lib" "$s/rust" \
           "$root/code/src/django" "$root/code/src/rust" "$root/bin"
  cp "$SCRIPT_DIR/audit.sh" "$s/dependencies/"
  cp "$SCRIPTS_DIR/audits/security.sh" "$s/audits/"
  cp "$SCRIPTS_DIR/_lib/worktree-detect.sh" "$s/_lib/"
  cp "$SCRIPTS_DIR/rust/audit.sh" "$SCRIPTS_DIR/rust/_common.sh" "$s/rust/"
  cp "$PROBE_STUBS"/* "$root/bin/"
  chmod +x "$root/bin/"*
  printf '[project]\nname = "probe"\ndependencies = ["six>=1.16"]\n' >"$root/pyproject.toml"
  printf '[[package]]\nname = "probe"\n# STALE - the manifest moved and the lock did not\n' >"$root/uv.lock"
  printf '{"name": "probe"}\n' >"$root/package.json"
  printf "lockfileVersion: '9.0'\n\nimporters:\n\n  .: {}\n" >"$root/pnpm-lock.yaml"
  printf '[[package]]\nname = "nativecore"\n# STALE\n' >"$root/code/src/rust/Cargo.lock"
}

# probe NAME PNPM_STATE WANT_RC SCRIPT ARGS... — runs SCRIPT (relative to the scratch root)
# and leaves its output in $PROBE_OUT, its root in $PROBE_ROOT. Returns 1 on a wrong exit.
probe() {
  local name="$1" pnpm_state="$2" want="$3" script="$4" rc=0
  shift 4
  PROBE_ROOT="$(mktemp -d)"; PROBE_OUT="$PROBE_ROOT/out.txt"
  probe_tree "$PROBE_ROOT"
  cp "$PROBE_ROOT/uv.lock" "$PROBE_ROOT/uv.lock.before"
  cp "$PROBE_ROOT/code/src/rust/Cargo.lock" "$PROBE_ROOT/Cargo.lock.before"
  STUB_ROOT="$PROBE_ROOT" STUB_FIXTURES="$FIXTURES_DIR" STUB_PNPM_AUDIT="$pnpm_state" \
    PATH="$PROBE_ROOT/bin:$PATH" bash "$PROBE_ROOT/$script" "$@" >"$PROBE_OUT" 2>&1 || rc=$?
  PROBES_RUN=$((PROBES_RUN + 1))
  [[ "$rc" -eq "$want" ]] && return 0
  log "  ✗ probe $name: exited $rc, expected $want — last lines:"
  tail -8 "$PROBE_OUT" | sed 's/^/       /'
  return 1
}

# expect NAME 'ERE' [absent] — the probe's output must (or must not) match
expect() {
  if [[ "${3:-}" == absent ]]; then
    grep -qE "$2" "$PROBE_OUT" || return 0
    log "  ✗ probe $1: output matches /$2/, and must not"
  else
    grep -qE "$2" "$PROBE_OUT" && return 0
    log "  ✗ probe $1: output does not match /$2/"
  fi
  return 1
}

run_probes() {
  local bad=0 a=code/src/scripts/dependencies/audit.sh s=code/src/scripts/audits/security.sh

  # 1. A lockfile behind its manifest is a FINDING, and auditing it changes nothing. The
  #    advisory tools re-lock as a side effect, so run first — or run unfrozen — they repair
  #    the drift before the lockfile leg looks, and the audit reports clean over its own edit.
  probe relock-is-a-finding clean 1 "$a" --ecosystem python --ecosystem rust || bad=1
  expect relock-is-a-finding '^  python-lockfile +FINDING' || bad=1
  expect relock-is-a-finding '^  rust-lockfile +FINDING' || bad=1
  cmp -s "$PROBE_ROOT/uv.lock" "$PROBE_ROOT/uv.lock.before" \
    || { bad=1; log "  ✗ probe relock-is-a-finding: the audit rewrote uv.lock"; }
  cmp -s "$PROBE_ROOT/code/src/rust/Cargo.lock" "$PROBE_ROOT/Cargo.lock.before" \
    || { bad=1; log "  ✗ probe relock-is-a-finding: the audit rewrote Cargo.lock"; }
  rm -rf "$PROBE_ROOT"

  # 2. A finding from a tool that prints no `error[` line (pnpm here; pip-audit and the
  #    lockfile legs alike) still reaches the summary and the report.
  probe plain-finding-is-reported finding 1 "$a" --ecosystem javascript \
    --output json --output-file report.json || bad=1
  expect plain-finding-is-reported '^  javascript-advisories +FINDING +2 vulnerabilities found' || bad=1
  expect plain-finding-is-reported 'Findings in the dependency set' || bad=1
  grep -q '"state": "finding"' "$PROBE_ROOT/report.json" 2>/dev/null \
    || { bad=1; log "  ✗ probe plain-finding-is-reported: no report, or no finding in it"; }
  rm -rf "$PROBE_ROOT"

  # 3. A tool that failed (the registry answered 503) is NOT RUN — exit 2 from security.sh,
  #    and a summary row quoting the tool's error, never a claim that something was found.
  probe tool-failure-is-not-run unmeasured 2 "$s" --js-only || bad=1
  expect tool-failure-is-not-run '[Vv]ulnerabilities found|VULNERABLE' absent || bad=1
  rm -rf "$PROBE_ROOT"
  probe tool-failure-is-not-a-finding unmeasured 2 "$a" --ecosystem javascript || bad=1
  expect tool-failure-is-not-a-finding '^  javascript-advisories +NOT RUN +exit 2, not a finding: +ERR_PNPM_AUDIT_BAD_RESPONSE' || bad=1
  expect tool-failure-is-not-a-finding 'NOT RUN .*([Vv]ulnerabilities found|VULNERABLE)' absent || bad=1
  rm -rf "$PROBE_ROOT"

  return "$bad"
}

# ── Self-test ─────────────────────────────────────────────────────────────────
run_self_test() {
  local f base leg want rc got failed=0 n=0 l s
  [[ -d "$FIXTURES_DIR" ]] || die "self-test fixtures missing: audits/fixtures/dependencies-audit"
  bold "▸ dependencies/audit.sh --self-test"
  for f in "$FIXTURES_DIR"/*.txt; do
    base="$(basename "$f" .txt)"; leg="${base%%.*}"; rc="${base##*.}"
    want="${base#*.}"; want="${want%.*}"
    got="$(classify "$leg" "$rc" "$f")"; n=$((n + 1))
    [[ "$got" == "$want" ]] || { failed=1; log "  ✗ $base: classified $got"; }
  done
  # Every leg must be proved in all three states, or a leg added tomorrow arrives untested.
  for l in "${LEGS[@]}"; do
    for s in clean finding unmeasured; do
      ls "$FIXTURES_DIR/$l.$s".*.txt >/dev/null 2>&1 || { failed=1; log "  ✗ no fixture for $l in state $s"; }
    done
  done
  local probes=("0|clean clean absent" "1|clean finding" "2|clean unmeasured absent"
                "1|finding unmeasured" "0|absent absent absent")
  for l in "${probes[@]}"; do
    # shellcheck disable=SC2086  # word-split the states
    got="$(verdict ${l#*|})"
    [[ "$got" == "${l%%|*}" ]] || { failed=1; log "  ✗ verdict(${l#*|}) = $got, expected ${l%%|*}"; }
  done
  run_probes || failed=1
  log "  transcripts: $n classified · legs: ${#LEGS[@]} × 3 states · verdict probes: ${#probes[@]} · run probes: $PROBES_RUN"
  if [[ $failed -eq 0 ]]; then
    bold "✓ Self-test passed — findings, clean runs and failed runs are told apart."
    exit 0
  fi
  bold "✗ Self-test FAILED — fix the classifier, never the transcripts."
  exit 1
}

# ── Running a leg ─────────────────────────────────────────────────────────────
# run_leg LEG POPULATION DIR CMD... — runs CMD in DIR, classifies it, records a row.
#
# Every detail pipeline ends `|| true`: under `set -o pipefail` a grep that matches nothing
# fails the assignment, and `set -e` then kills the script before the summary or the report
# exists. Only cargo-deny prints `error[` lines, so that once made every other finding fatal.
run_leg() {
  local leg="$1" pop="$2" dir="$3" out rc=0 state detail
  shift 3
  in_phase "$leg" || return 0
  out="$(mktemp)"
  (cd "$dir" && "$@") >"$out" 2>&1 || rc=$?
  state="$(classify "$leg" "$rc" "$out")"
  case "$state" in
    clean)      detail="ran clean" ;;
    finding)
      # cargo-deny names each failure on an `error[kind]:` line; the others on their summary.
      detail="$(grep -E '^error\[' "$out" | tr -d '\r' | cut -c1-110 | paste -sd ';' - | cut -c1-240 || true)"
      [[ -n "$detail" ]] || detail="$(grep -E -m1 '(FAILED|vulnerabilit|needs to be updated|OUTDATED|cannot update)' "$out" | tr -d '\r' | cut -c1-140 || true)" ;;
    unmeasured)
      # The tool's own error, not the last line: a wrapper's closing summary is the last line,
      # and it is the wrapper's verdict rather than the reason the tool did not run.
      detail="$(grep -E -m1 '(ERR_|^[[:space:]]*(error|Error|ERROR)|[Ff]ailed|[Uu]nable to|not found|refused|timed out|unreachable)' "$out" | tr -d '\r' | sed 's/^[[:space:]]*//' | cut -c1-120 || true)"
      [[ -n "$detail" ]] || detail="$(grep -v '^[[:space:]]*$' "$out" | tail -1 | tr -d '\r' | cut -c1-120 || true)"
      detail="exit $rc, not a finding: ${detail:-the tool printed nothing}" ;;
  esac
  ROWS+=("$leg|$state|$pop|$detail")
  if [[ "$state" != clean ]] && ! $QUIET; then
    log "  ── $leg ($state) — last lines:"
    tail -6 "$out" | sed 's/^/     /'
  fi
  rm -f "$out"
}

skip_leg() { in_phase "$1" || return 0; ROWS+=("$1|$2|$3|$4"); }   # leg state population detail

# ── Two passes: every lockfile leg, THEN every advisory leg ────────────────────
# The order is the guarantee, not a preference. An advisory tool resolves the graph before it
# audits it, and a resolve re-locks: `uv run` rewrites uv.lock, cargo-deny rewrites Cargo.lock.
# Run first, it would repair a stale lockfile before the lockfile leg looked, and the audit
# would report clean over its own edit. So the lockfile legs look at the tree as committed,
# and the advisory legs are read-only besides (`uv run --frozen` in audits/security.sh,
# `cargo deny --locked` in rust/audit.sh) — this script changes nothing either way.
PHASE=""
in_phase() { [[ "${1##*-}" == "$PHASE" ]]; }

$SELF_TEST && run_self_test

cd "$PROJECT_ROOT"
log ""
bold "▸ dependencies/audit.sh — $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
log ""

all_legs() {
# ── Python ────────────────────────────────────────────────────────────────────
if wants python; then
  if [[ ! -f pyproject.toml ]]; then
    skip_leg python-advisories absent "-" "no pyproject.toml"
    skip_leg python-lockfile absent "-" "no pyproject.toml"
  elif ! command -v uv >/dev/null 2>&1; then
    skip_leg python-advisories unmeasured "pyproject.toml" "uv not on PATH — install it: install.sh"
    skip_leg python-lockfile unmeasured "pyproject.toml" "uv not on PATH — install it: install.sh"
  elif [[ ! -f uv.lock ]]; then
    skip_leg python-advisories unmeasured "pyproject.toml" "no uv.lock — there is no locked graph to audit"
    skip_leg python-lockfile finding "pyproject.toml" "pyproject.toml has no uv.lock beside it"
  else
    pop="uv.lock, $(grep -c '^\[\[package\]\]' uv.lock) packages, every group"
    run_leg python-advisories "$pop" "$PROJECT_ROOT" bash "$SCRIPTS_DIR/audits/security.sh" --py-only
    run_leg python-lockfile "$pop" "$PROJECT_ROOT" uv lock --check
  fi
fi

# ── JavaScript — the root and every workspace member share one lockfile ───────
if wants javascript; then
  if [[ ! -f package.json ]]; then
    skip_leg javascript-advisories absent "-" "no package.json"
    skip_leg javascript-lockfile absent "-" "no package.json"
  elif ! command -v pnpm >/dev/null 2>&1; then
    skip_leg javascript-advisories unmeasured "package.json" "pnpm not on PATH — install it: install.sh"
    skip_leg javascript-lockfile unmeasured "package.json" "pnpm not on PATH — install it: install.sh"
  elif [[ ! -f pnpm-lock.yaml ]]; then
    skip_leg javascript-advisories unmeasured "package.json" "no pnpm-lock.yaml — there is no locked graph to audit"
    skip_leg javascript-lockfile finding "package.json" "package.json has no pnpm-lock.yaml beside it"
  else
    importers="$(awk '/^importers:/ { i = 1; next } i && /^[^ ]/ { exit } i && /^  [^ ]/ { k = $1; sub(/:$/, "", k); gsub(/\047/, "", k); printf "%s%s", (n++ ? " " : ""), k }' pnpm-lock.yaml)"
    pop="pnpm-lock.yaml, importers: ${importers:-none}"
    run_leg javascript-advisories "$pop" "$PROJECT_ROOT" bash "$SCRIPTS_DIR/audits/security.sh" --js-only
    run_leg javascript-lockfile "$pop" "$PROJECT_ROOT" pnpm install --frozen-lockfile --lockfile-only --ignore-scripts
  fi
fi

# ── Rust ──────────────────────────────────────────────────────────────────────
if wants rust; then
  if [[ ! -d "$RUST_DIR" ]]; then
    skip_leg rust-advisories absent "-" "no code/src/rust — generated without the Rust surface"
    skip_leg rust-lockfile absent "-" "no code/src/rust — generated without the Rust surface"
  elif ! command -v cargo >/dev/null 2>&1; then
    skip_leg rust-advisories unmeasured "code/src/rust" "cargo not on PATH — install rustup: install.sh"
    skip_leg rust-lockfile unmeasured "code/src/rust" "cargo not on PATH — install rustup: install.sh"
  elif [[ ! -f "$RUST_DIR/Cargo.lock" ]]; then
    skip_leg rust-advisories unmeasured "code/src/rust" "no Cargo.lock — there is no locked graph to audit"
    skip_leg rust-lockfile finding "code/src/rust" "code/src/rust has no Cargo.lock"
  else
    pop="Cargo.lock, $(grep -c '^\[\[package\]\]' "$RUST_DIR/Cargo.lock") packages"
    if command -v cargo-deny >/dev/null 2>&1; then
      run_leg rust-advisories "$pop" "$PROJECT_ROOT" bash "$SCRIPTS_DIR/rust/audit.sh"
    else
      skip_leg rust-advisories unmeasured "$pop" "cargo-deny not on PATH — version in code/src/rust/.cargo-deny-version"
    fi
    run_leg rust-lockfile "$pop" "$RUST_DIR" cargo metadata --locked --format-version 1
  fi
fi

}
PHASE=lockfile;   all_legs
PHASE=advisories; all_legs

# ── Summary ───────────────────────────────────────────────────────────────────
STATES=()
for r in "${ROWS[@]}"; do s="${r#*|}"; STATES+=("${s%%|*}"); done
STATUS="$(verdict "${STATES[@]}")"

label() {
  case "$1" in
    clean) echo "clean" ;; finding) echo "FINDING" ;; absent) echo "not present" ;; unmeasured) echo "NOT RUN" ;;
  esac
}
bold "── Dependency audit ──"
for r in "${ROWS[@]}"; do
  IFS='|' read -r leg state pop detail <<<"$r"
  log "  $(printf '%-22s %-12s' "$leg" "$(label "$state")") $detail"
  [[ "$pop" == "-" ]] || log "  $(printf '%-35s' '') over $pop"
done

if [[ -n "$OUTPUT_FORMAT" ]]; then
  REPORT="${OUTPUT_FILE:-$REPORTS_DIR/dependency-audit.$OUTPUT_FORMAT}"
  mkdir -p "$(dirname "$REPORT")"
  case "$OUTPUT_FORMAT" in
    json)
      {
        printf '{\n  "exit": %s,\n  "legs": [\n' "$STATUS"
        i=0
        for r in "${ROWS[@]}"; do
          IFS='|' read -r leg state pop detail <<<"$r"
          i=$((i + 1)); sep=","; [[ $i -eq ${#ROWS[@]} ]] && sep=""
          printf '    {"leg": "%s", "state": "%s", "population": "%s", "detail": "%s"}%s\n' \
            "$leg" "$state" "${pop//\"/\\\"}" "${detail//\"/\\\"}" "$sep"
        done
        printf '  ]\n}\n'
      } >"$REPORT" ;;
    md)
      {
        printf '# Dependency audit\n\nExit: %s (0 clean, 1 findings, 2 unmeasured)\n\n' "$STATUS"
        printf '| Leg | State | Population | Detail |\n| --- | ----- | ---------- | ------ |\n'
        for r in "${ROWS[@]}"; do
          IFS='|' read -r leg state pop detail <<<"$r"
          printf '| %s | %s | %s | %s |\n' "$leg" "$(label "$state")" "$pop" "${detail//|/-}"
        done
      } >"$REPORT" ;;
    txt)
      {
        printf 'Dependency audit - exit %s\n\n' "$STATUS"
        for r in "${ROWS[@]}"; do
          IFS='|' read -r leg state pop detail <<<"$r"
          printf '%-22s %-12s %s (%s)\n' "$leg" "$(label "$state")" "$detail" "$pop"
        done
      } >"$REPORT" ;;
  esac
  log ""
  log "  report: ${REPORT#"$PROJECT_ROOT"/}"
fi

log ""
case "$STATUS" in
  0) bold "✓ Every present leg ran, and found nothing." ;;
  1) bold "✗ Findings in the dependency set — see FINDING above. Fix with update.sh, narrowest first." ;;
  2) bold "? Unmeasured — nothing found, but a leg marked NOT RUN never examined its population." ;;
esac
exit "$STATUS"
