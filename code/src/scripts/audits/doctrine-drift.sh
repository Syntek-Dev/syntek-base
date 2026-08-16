#!/usr/bin/env bash
#
# doctrine-drift.sh — One rule, one home. Catch the second copy before it disagrees.
#
#                     A rule restated in two guides is not redundancy, it is a fork: both
#                     copies are believed, only one is maintained, and the day they diverge
#                     nothing fails. That is a named defect class in this repository —
#                     "split doctrine" — and it has produced a whole batch of open items.
#
#                     The instance that motivated this script: FOUR guides mandated one JSON
#                     error envelope and a fifth mandated a different one, for months, with
#                     every gate green. No audit could see it, because every individual file
#                     was internally consistent and every citation resolved.
#
#                     Three [gate: fail] clauses:
#                       doctrine-restated   an owned rule is stated outside its owner
#                       doctrine-unowned    an owned rule is stated nowhere, owner included
#                       doctrine-banned     a retired spelling is stated anywhere
#
#                     What it CANNOT decide, and does not pretend to:
#                       * whether two statements MEAN the same thing. It matches shapes. Two
#                         guides can agree in wording and disagree in substance, and that stays
#                         a reviewer's job.
#                       * whether the OWNER is the right home. The claims table asserts that;
#                         nothing here checks it.
#
# ── Why only fenced code ──────────────────────────────────────────────────────
# A rule is STATED in an example and DISCUSSED in prose. "There was a `{ "data": ... }`
# envelope here until it was retired" is history, and a guide that cannot narrate its own
# changes loses the reasoning that makes the current rule legible. So the scanner reads
# fenced blocks only. Prose is free; examples are the contract.
#
# Usage: doctrine-drift.sh [--output FORMAT] [--output-file PATH] [--quiet] [--self-test]
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$SCRIPT_DIR/reports"
FIXTURES_DIR="$SCRIPT_DIR/fixtures/doctrine-drift"

# ── Scopes ────────────────────────────────────────────────────────────────────
# Variables so --self-test can repoint the whole scan at a fixture tree.
#
# DOCS_DIR roots the OWNER path. SCAN_DIRS is where a second home might appear, and it
# is deliberately wider than the owner's tree: a rule does not have to be restated in a
# guide to be forked. A skill body carries the same weight — it is loaded into context and
# believed exactly as readily — and the two skill audits both read a skill's frontmatter,
# neither its prose. Workflow STEPS.md files are here for the same reason: they are
# executed, so a stale example in one is a rule that has drifted.
DOCS_DIR="code/docs"
SCAN_DIRS=(
  "code/docs"
  ".claude/skills"
  "code/workflows"
  "project-management/workflows"
  "how-to/workflows"
)

# ── The claims table ──────────────────────────────────────────────────────────
# One row per rule this repository has decided belongs in exactly one place, or has
# retired outright. Fields are TAB-separated:
#
#   kind   owned  = stated in OWNER and nowhere else
#          banned = stated nowhere at all; OWNER is "-"
#   id     the clause's subject, reported verbatim
#   owner  path relative to DOCS_DIR, or "-" for a banned claim
#   ere    an extended regex matched against fenced-code lines only
#
# Adding a rule to this table is the whole cost of guarding it. Keep the regex anchored
# to something a STATEMENT has and a mention does not — a JSON key, a decorator, a
# setting assignment — never a bare word.
CLAIMS=$(
  cat <<'EOF'
owned	api-error-envelope	api-design/AUTH-AND-ERRORS.md	"error"[[:space:]]*:[[:space:]]*\{
banned	api-detail-envelope	-	"detail"[[:space:]]*:
banned	api-success-data-wrap	-	^[[:space:]]*"data"[[:space:]]*:
EOF
)

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
SELF_TEST=false

FAIL_COUNT=0

log() { $QUIET || printf '%s\n' "$*"; }
die() { printf 'doctrine-drift.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
doctrine-drift.sh — one rule, one home

Usage:
  doctrine-drift.sh                Check every claim against the docs tree
  doctrine-drift.sh --output md    Also write a report
  doctrine-drift.sh --self-test    Prove the clauses still separate the fixtures

Clauses — three [gate: fail]:
  doctrine-restated   an owned rule is stated outside its owner
  doctrine-unowned    an owned rule is stated nowhere, owner included
  doctrine-banned     a retired spelling is stated anywhere

Only fenced code is read. Prose may discuss, quote and narrate a rule freely; an
example is what counts as stating it.

Scope is wider than the owner's tree: code/docs, .claude/skills and the three
workflows/ trees. A skill body is loaded into context and believed like a guide, and
neither skill audit reads its prose.

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/doctrine-drift.<FORMAT>)
  --quiet              Suppress stdout (requires --output)
  --self-test          Run every clause over fixtures/doctrine-drift/{broken,clean}
  --help               Show this help

Rule: code/docs/DOCUMENTATION-PAIRING.md — route, don't restate

Exit codes:  0 = clean   1 = finding(s)   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --self-test)   SELF_TEST=true; shift ;;
    --help | -h)   usage; exit 0 ;;
    *)             die "Unknown option: $1. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md | txt | json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/doctrine-drift.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_FAIL=$(mktemp)
trap 'rm -f "$TMP_FAIL"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

fail() { printf '%s: %s\n' "$1" "$2" >> "$TMP_FAIL"; }

# ── Fenced-code extraction ────────────────────────────────────────────────────
# Emits "path:line:text" for lines inside ``` fences. The toggle is deliberately naive
# about fence LENGTH — a ```` block inside a ``` block does not occur in this tree, and
# guessing at nesting would be a second thing to get wrong.
fenced_lines() {
  local file="$1"
  awk -v path="$file" '
    /^[ \t]*```/ { infence = !infence; next }
    infence { printf "%s:%d:%s\n", path, NR, $0 }
  ' "$file"
}

# Every fenced line in the scan scope, once, so N claims cost one tree walk.
collect_fenced() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  local file
  while IFS= read -r file; do
    fenced_lines "$file"
  done < <(find "$dir" -type f -name '*.md' ! -path '*/node_modules/*' | sort)
}

run_all() {
  local corpus="" dir
  for dir in "${SCAN_DIRS[@]}"; do
    corpus+="$(collect_fenced "$dir")"$'\n'
  done

  local kind id owner ere hits outside inside
  while IFS=$'\t' read -r kind id owner ere; do
    [[ -n "$kind" ]] || continue

    hits=$(printf '%s\n' "$corpus" | grep -E -- "$ere" || true)

    if [[ "$kind" == "banned" ]]; then
      if [[ -n "$hits" ]]; then
        while IFS= read -r hit; do
          [[ -n "$hit" ]] || continue
          fail "doctrine-banned" "$id — retired spelling stated at ${hit%%:*}:$(printf '%s' "$hit" | cut -d: -f2)"
        done <<< "$hits"
      fi
      continue
    fi

    # owned
    if [[ ! -f "$DOCS_DIR/$owner" ]]; then
      fail "doctrine-unowned" "$id — the owner $owner does not exist"
      continue
    fi

    inside=$(printf '%s\n' "$hits" | grep -F -- "$DOCS_DIR/$owner:" || true)
    outside=$(printf '%s\n' "$hits" | grep -v -F -- "$DOCS_DIR/$owner:" | grep -E '\S' || true)

    if [[ -z "$inside" ]]; then
      fail "doctrine-unowned" "$id — no longer stated in its owner, $owner"
    fi
    if [[ -n "$outside" ]]; then
      while IFS= read -r hit; do
        [[ -n "$hit" ]] || continue
        fail "doctrine-restated" "$id — owned by $owner, also stated at ${hit%%:*}:$(printf '%s' "$hit" | cut -d: -f2)"
      done <<< "$outside"
    fi
  done <<< "$CLAIMS"
}

# ── Self-test ─────────────────────────────────────────────────────────────────
if $SELF_TEST; then
  log ""
  bold "▸ doctrine-drift.sh --self-test — $TIMESTAMP"

  [[ -d "$FIXTURES_DIR/broken" && -d "$FIXTURES_DIR/clean" ]] ||
    die "fixtures missing at $FIXTURES_DIR"

  EXPECTED=(doctrine-restated doctrine-banned)
  ST_FAIL=0

  DOCS_DIR="$FIXTURES_DIR/broken"
  SCAN_DIRS=("$FIXTURES_DIR/broken")
  : > "$TMP_FAIL"
  run_all
  BROKEN_BODY="$(cat "$TMP_FAIL")"
  for clause in "${EXPECTED[@]}"; do
    if ! printf '%s\n' "$BROKEN_BODY" | grep -q "^$clause:"; then
      ST_FAIL=1
      log ""
      printf '\033[31m  ✗ broken/ did not trip %s\033[0m\n' "$clause"
    fi
  done

  DOCS_DIR="$FIXTURES_DIR/clean"
  SCAN_DIRS=("$FIXTURES_DIR/clean")
  : > "$TMP_FAIL"
  run_all
  CLEAN_BODY="$(cat "$TMP_FAIL")"
  if [[ -n "$CLEAN_BODY" ]]; then
    ST_FAIL=1
    log ""
    printf '\033[31m  ✗ clean/ produced findings — false positives:\033[0m\n'
    printf '%s\n' "$CLEAN_BODY" | sed 's/^/    /'
  fi

  log ""
  if [[ "$ST_FAIL" -eq 0 ]]; then
    bold "✓ Self-test passed — broken/ trips ${#EXPECTED[@]} clauses, clean/ trips none."
    log ""
    exit 0
  fi
  log "  broken/ findings were:"
  printf '%s\n' "$BROKEN_BODY" | sed 's/^/    /'
  log ""
  bold "✗ Self-test failed."
  exit 1
fi

# ── Ordinary run ──────────────────────────────────────────────────────────────
log ""
bold "▸ doctrine-drift.sh — $TIMESTAMP"

run_all

FAIL_COUNT=$(grep -c . "$TMP_FAIL" || true); FAIL_COUNT=${FAIL_COUNT:-0}
FAIL_BODY="$(cat "$TMP_FAIL")"
CLAIM_COUNT=$(printf '%s\n' "$CLAIMS" | grep -c . || true)

log "  scope: ${#SCAN_DIRS[@]} tree(s), fenced code only · $CLAIM_COUNT claim(s) · 3 fail clauses"
log ""

if [[ "$FAIL_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[31m  ✗ %d finding%s\033[0m\n' "$FAIL_COUNT" "$([[ "$FAIL_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n\n' "$FAIL_BODY" | sed 's/^/    /'
fi

# A report is written on every path, including the no-op one: a CI job told to collect
# the artefact must always find it.
if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$FAIL_COUNT" -eq 0 ]] && echo '✓ every claim has one home' || echo "✗ $FAIL_COUNT finding(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'doctrine-drift audit — %s\n' "$TIMESTAMP"
        printf 'claims=%s findings=%s\n\n' "$CLAIM_COUNT" "$FAIL_COUNT"
        printf '%s\n' "${FAIL_BODY:-No findings.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Doctrine-Drift Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Scope** | %s tree(s), fenced code only |\n' "${#SCAN_DIRS[@]}"
        printf '| **Claims** | %s |\n' "$CLAIM_COUNT"
        printf '| **Findings** `[gate: fail]` | %s |\n' "$FAIL_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$FAIL_COUNT" -gt 0 ]]; then printf '## Findings\n\n```text\n%s\n```\n\n' "$FAIL_BODY"
        else printf '_No findings._\n\n'; fi
        printf '_This matches shapes, never meaning. Two guides can agree in wording and\n'
        printf 'disagree in substance; that stays a reviewer'"'"'s judgement._\n'
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "doctrine-drift",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "claims": %s,\n  "findings": %s,\n' "$CLAIM_COUNT" "$FAIL_COUNT"
        printf '  "clean": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo true || echo false)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  report: $OUTPUT_FILE"
  log ""
fi

if [[ "$FAIL_COUNT" -gt 0 ]]; then
  bold "✗ Doctrine is stated in more than one place, or has lost its home."
  exit 1
fi

bold "✓ All $CLAIM_COUNT claim(s) have exactly one home."
log ""
exit 0
