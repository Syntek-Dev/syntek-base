#!/usr/bin/env bash
#
# dict-discipline.sh — Enforce the decidable half of "domain objects over dictionaries":
#                      a dictionary used as a record in DOMAIN code, where a named type
#                      belongs.
#
#                      What a script CAN decide: a bare-dict return, an untyped map
#                      annotation, HashMap<String, Value>, Record<string, any>, and an
#                      escape-hatch marker with no reason after it. What it CANNOT decide:
#                      whether the keys are genuinely dynamic, and whether the dict escapes
#                      the layer that built it. That half is the review checklist's.
#
# Scope scanned — DOMAIN code only, per surface:
#   code/src/django/apps            (*.py, excluding migrations/ and tests/)
#   code/src/mobile                 (*.ts, *.tsx, excluding __tests__/)
#   code/src/rust/crates/*/src      (*.rs, excluding target/)
#
#   Test code is NOT in the fail tier — "test fixtures and throwaway scripts" is a listed
#   exception to the standard. Marker hygiene (clause M) still runs everywhere, because
#   an unexplained annotation is unexplained wherever it sits.
#
# NO-OP WHEN ABSENT — a project without the mobile or Rust surface still exits 0 with a
# note rather than failing, so CI needs no step-level guard.
#
# Escape hatch: `DICT-OK: <reason> — confined to <boundary>` in a comment on the offending
# line or the line above. The reason is MANDATORY — a bare marker is itself a finding
# (clause M), the same rule the sibling audits apply to slop-allow and token-allow.
#
# Usage: dict-discipline.sh [--output FORMAT] [--output-file PATH] [--quiet] [--path PATH]
#                           [--self-test] [--help]
#
# Exit codes:  0 = clean (or surface absent)   1 = findings   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="$SCRIPT_DIR/fixtures/dict-discipline"

PY_SCOPE="code/src/django/apps"
TS_SCOPE="code/src/mobile"
RS_SCOPE="code/src/rust/crates"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'dict-discipline.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
dict-discipline.sh — Domain objects over dictionaries, the machine-checkable half

Usage:
  dict-discipline.sh                 Scan every present surface
  dict-discipline.sh --output md     Also write a report
  dict-discipline.sh --path apps/    Restrict the scan to a file or directory
  dict-discipline.sh --self-test     Prove the detector separates broken/ from clean/

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/dict-discipline-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the scan to a file or directory
  --self-test          Run the detector against its fixtures and assert it separates them
  --help               Show this help

Annotate a legitimate dictionary with `DICT-OK: <reason> — confined to <boundary>` on the
same line or the line above. The reason is mandatory; a bare marker is a finding.

Exit codes:  0 = clean (or surface absent)   1 = findings   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --self-test)    SELF_TEST=true; shift ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "unknown option: $1 (try --help)" ;;
  esac
done

if $QUIET && [[ -z "$OUTPUT_FORMAT" ]]; then
  die "--quiet requires --output, or the run produces no signal at all"
fi

case "${OUTPUT_FORMAT:-md}" in
  md|txt|json) ;;
  *) die "unknown --output format: $OUTPUT_FORMAT (md | txt | json)" ;;
esac

# ── Findings accumulator ──────────────────────────────────────────────────────
# One record per line: <file>|<line>|<clause>|<text>
FINDINGS=""
FINDING_COUNT=0

add_finding() {
  FINDINGS+="${1}|${2}|${3}|${4}"$'\n'
  FINDING_COUNT=$((FINDING_COUNT + 1))
}

# Whether the offending line, or the line above it, carries a DICT-OK marker.
# A marker WITHOUT a reason does not suppress — clause M reports it separately.
is_annotated() {
  local file="$1" lineno="$2" this prev
  this="$(sed -n "${lineno}p" "$file" 2>/dev/null || true)"
  prev=""
  [[ "$lineno" -gt 1 ]] && prev="$(sed -n "$((lineno - 1))p" "$file" 2>/dev/null || true)"
  printf '%s\n%s\n' "$this" "$prev" | grep -qE 'DICT-OK:[[:space:]]*[^[:space:]]'
}

# scan_clause <clause-id> <description> <file-list-file> <extended-regex>
scan_clause() {
  local clause="$1" list="$3" pattern="$4"
  local file lineno text
  [[ -s "$list" ]] || return 0
  while IFS= read -r file; do
    [[ -f "$file" ]] || continue
    while IFS=: read -r lineno text; do
      [[ -n "$lineno" ]] || continue
      is_annotated "$file" "$lineno" && continue
      add_finding "${file#"$PROJECT_ROOT"/}" "$lineno" "$clause" "$(printf '%s' "$text" | sed 's/^[[:space:]]*//' | cut -c1-120)"
    done < <(grep -nE "$pattern" "$file" 2>/dev/null || true)
  done < "$list"
}

# Clause M runs on every scanned file and is never suppressible — it IS the suppression check.
scan_marker_hygiene() {
  local list="$1" file lineno text
  [[ -s "$list" ]] || return 0
  while IFS= read -r file; do
    [[ -f "$file" ]] || continue
    while IFS=: read -r lineno text; do
      [[ -n "$lineno" ]] || continue
      add_finding "${file#"$PROJECT_ROOT"/}" "$lineno" "M" "$(printf '%s' "$text" | sed 's/^[[:space:]]*//' | cut -c1-120)"
    done < <(grep -nE 'DICT-OK:[[:space:]]*$' "$file" 2>/dev/null || true)
  done < "$list"
}

# ── The clause patterns ───────────────────────────────────────────────────────
# P1  a function returning a bare dict — the caller is expected to know the keys
readonly P1='->[[:space:]]*(dict|Dict)[[:space:]]*[:\[]'
# P2  an untyped or half-typed mapping annotation standing in for a record
readonly P2='(dict|Dict)\[[[:space:]]*str[[:space:]]*,[[:space:]]*(Any|object)[[:space:]]*\]'
# P3  typing.Dict — superseded by dict[...] on py3.9+, and always a record smell here
readonly P3='\bDict\[[^]]'
# T1  a JS object used as a typed bag
readonly T1='Record<[[:space:]]*string[[:space:]]*,[[:space:]]*(any|unknown)[[:space:]]*>'
# T2  the `object` type, and `{ [key: string]: ... }` index signatures
readonly T2='(:[[:space:]]*object\b|\{[[:space:]]*\[[[:space:]]*[A-Za-z_]+[[:space:]]*:[[:space:]]*string[[:space:]]*\][[:space:]]*:)'
# R1  the untyped JSON map in Rust domain code
readonly R1='(HashMap|BTreeMap)<[[:space:]]*String[[:space:]]*,[[:space:]]*(serde_json::)?Value[[:space:]]*>'
# R2  serde_json::Value anywhere outside a wire/dto module
readonly R2='serde_json::Value'

# ── File collection ───────────────────────────────────────────────────────────
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

PY_LIST="$TMP_DIR/py.txt"; : > "$PY_LIST"
TS_LIST="$TMP_DIR/ts.txt"; : > "$TS_LIST"
RS_LIST="$TMP_DIR/rs.txt"; : > "$RS_LIST"
ALL_LIST="$TMP_DIR/all.txt"; : > "$ALL_LIST"

collect() {
  local root="$1" list="$2"
  shift 2
  [[ -d "$root" || -f "$root" ]] || return 0
  find "$root" \( -path '*/migrations/*' -o -path '*/tests/*' -o -path '*/__tests__/*' \
       -o -path '*/target/*' -o -path '*/node_modules/*' -o -path '*/__pycache__/*' \) -prune -o \
       -type f \( "$@" \) -print >> "$list" 2>/dev/null || true
}

SCAN_ROOT_PY="$PROJECT_ROOT/$PY_SCOPE"
SCAN_ROOT_TS="$PROJECT_ROOT/$TS_SCOPE"
SCAN_ROOT_RS="$PROJECT_ROOT/$RS_SCOPE"

if $SELF_TEST; then
  [[ -d "$FIXTURES_DIR" ]] || die "--self-test needs $FIXTURES_DIR — the fixtures are missing"
elif [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || [[ -e "$PROJECT_ROOT/$TARGET_PATH" ]] \
    || die "--path not found: $TARGET_PATH"
  [[ -e "$TARGET_PATH" ]] && SCAN_ROOT_PY="$TARGET_PATH" || SCAN_ROOT_PY="$PROJECT_ROOT/$TARGET_PATH"
  SCAN_ROOT_TS="$SCAN_ROOT_PY"
  SCAN_ROOT_RS="$SCAN_ROOT_PY"
fi

run_scan() {
  FINDINGS=""
  FINDING_COUNT=0
  : > "$PY_LIST"; : > "$TS_LIST"; : > "$RS_LIST"; : > "$ALL_LIST"

  collect "$1" "$PY_LIST" -name '*.py'
  collect "$2" "$TS_LIST" -name '*.ts' -o -name '*.tsx'
  collect "$3" "$RS_LIST" -name '*.rs'

  scan_clause "P1" "bare dict return"        "$PY_LIST" "$P1"
  scan_clause "P2" "untyped mapping record"  "$PY_LIST" "$P2"
  scan_clause "P3" "legacy typing.Dict"      "$PY_LIST" "$P3"
  scan_clause "T1" "Record<string, any>"     "$TS_LIST" "$T1"
  scan_clause "T2" "object / index signature" "$TS_LIST" "$T2"
  scan_clause "R1" "HashMap<String, Value>"  "$RS_LIST" "$R1"
  scan_clause "R2" "serde_json::Value"       "$RS_LIST" "$R2"

  cat "$PY_LIST" "$TS_LIST" "$RS_LIST" > "$ALL_LIST"
  scan_marker_hygiene "$ALL_LIST"
}

# ── Self-test ─────────────────────────────────────────────────────────────────
# This repository ships almost no application code, so an ordinary run is green having
# measured nothing. A gate nobody has watched fail is not a gate.
if $SELF_TEST; then
  bold "dict-discipline.sh --self-test"

  run_scan "$FIXTURES_DIR/broken" "$FIXTURES_DIR/broken" "$FIXTURES_DIR/broken"
  broken_count=$FINDING_COUNT
  log "  broken/ fixtures  -> $broken_count finding(s)"

  run_scan "$FIXTURES_DIR/clean" "$FIXTURES_DIR/clean" "$FIXTURES_DIR/clean"
  clean_count=$FINDING_COUNT
  log "  clean/  fixtures  -> $clean_count finding(s)"

  if [[ "$broken_count" -lt 8 ]]; then
    printf 'SELF-TEST FAILED: broken/ produced %s findings, expected at least 8.\n' \
      "$broken_count" >&2
    printf 'Fix the detector, never the fixtures.\n' >&2
    exit 1
  fi
  if [[ "$clean_count" -ne 0 ]]; then
    printf 'SELF-TEST FAILED: clean/ produced %s findings, expected 0.\n' "$clean_count" >&2
    printf '%s\n' "$FINDINGS" >&2
    exit 1
  fi

  bold "Self-test passed — the detector separates the fixtures."
  exit 0
fi

# ── The ordinary run ──────────────────────────────────────────────────────────
run_scan "$SCAN_ROOT_PY" "$SCAN_ROOT_TS" "$SCAN_ROOT_RS"

SCANNED_COUNT="$(wc -l < "$ALL_LIST" | tr -d ' ')"

bold "dict-discipline.sh — domain objects over dictionaries"
log "  scanned $SCANNED_COUNT file(s) across the present surfaces"
[[ -d "$SCAN_ROOT_TS" ]] || log "  note: no mobile surface — code/src/mobile is absent"
[[ -d "$SCAN_ROOT_RS" ]] || log "  note: no Rust surface — code/src/rust/crates is absent"

if [[ "$FINDING_COUNT" -gt 0 ]]; then
  log ""
  bold "  $FINDING_COUNT finding(s):"
  while IFS='|' read -r f l c t; do
    [[ -n "$f" ]] || continue
    log "    [$c] $f:$l"
    log "         $t"
  done <<< "$FINDINGS"
  log ""
  log "  Model the record as a named type, or annotate the line:"
  log "    DICT-OK: <reason> — confined to <boundary>"
  log "  Standard: code/docs/data-structures/TYPES-OVER-DICTIONARIES.md"
  log "  Exceptions: code/docs/data-structures/TYPES-EXCEPTIONS.md"
else
  log "  clean — no unannotated dictionary-as-record in domain code"
fi

# ── Report — written on every path, including the no-op one ───────────────────
write_report() {
  local fmt="${OUTPUT_FORMAT:-md}" path="$OUTPUT_FILE"
  [[ -n "$path" ]] || path="$REPORTS_DIR/dict-discipline-report.$fmt"
  mkdir -p "$(dirname "$path")"

  case "$fmt" in
    json)
      {
        printf '{\n  "scannedFiles": %s,\n  "findingCount": %s,\n  "findings": [\n' \
          "$SCANNED_COUNT" "$FINDING_COUNT"
        local first=true
        while IFS='|' read -r f l c t; do
          [[ -n "$f" ]] || continue
          $first || printf ',\n'
          first=false
          printf '    {"file": "%s", "line": %s, "clause": "%s"}' "$f" "$l" "$c"
        done <<< "$FINDINGS"
        printf '\n  ]\n}\n'
      } > "$path"
      ;;
    *)
      {
        printf '# dict-discipline report\n\n'
        printf -- '- Files scanned: %s\n- Findings: %s\n\n' "$SCANNED_COUNT" "$FINDING_COUNT"
        if [[ "$FINDING_COUNT" -gt 0 ]]; then
          printf '| Clause | File | Line |\n| --- | --- | --- |\n'
          while IFS='|' read -r f l c t; do
            [[ -n "$f" ]] || continue
            printf '| %s | `%s` | %s |\n' "$c" "$f" "$l"
          done <<< "$FINDINGS"
        else
          printf 'Clean — no unannotated dictionary-as-record in domain code.\n'
        fi
        printf '\nStandard: `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md`\n'
      } > "$path"
      ;;
  esac
  log ""
  log "  report: ${path#"$PROJECT_ROOT"/}"
}

[[ -n "$OUTPUT_FORMAT" ]] && write_report

[[ "$FINDING_COUNT" -eq 0 ]] || exit 1
exit 0
