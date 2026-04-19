#!/usr/bin/env bash
#
# stubs.sh — Detect stub implementations across Python/Django, GraphQL (Strawberry),
#            and TypeScript/Next.js/React.
#
# Hard stubs (always fail):
#   Python  — raise NotImplementedError  ·  # STUB
#   TS/JS   — throw new Error(*not implemented*)  ·  // STUB
#
# Soft markers (listed when --strict; do not cause failure):
#   Python  — # TODO  ·  # FIXME  ·  # HACK
#   TS/JS   — // TODO  ·  // FIXME  ·  // HACK
#
# TDD/BDD red phase: export STUBS_TDD_RED=1 to skip this check and exit 0.
#   e.g.  STUBS_TDD_RED=1 git commit -m "red: ..."
#
# Usage: stubs.sh [--strict] [--file-type TYPE] [--output FORMAT]
#                 [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = clean (or TDD red phase)   1 = hard stubs found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# ── Defaults ──────────────────────────────────────────────────────────────────
STRICT=false
declare -a FILE_TYPES=()
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
OVERALL_EXIT=0
TOTAL_HITS=0
HARD_HITS=0
SOFT_HITS=0

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'stubs.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
stubs.sh — Detect stub implementations in Python/Django, GraphQL, TypeScript/Next.js

Usage:
  stubs.sh                         Scan all file types (hard stubs only)
  stubs.sh --strict                Also report TODO / FIXME / HACK soft markers
  stubs.sh --file-type python      Restrict to Python only

Options:
  --strict             Show soft markers (# TODO / # FIXME / # HACK / // TODO etc.)
                       Soft markers are listed but do not cause failure.
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | typescript | javascript
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/stubs-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict scan to a specific file or directory
  --help               Show this help

TDD/BDD red phase:
  Export STUBS_TDD_RED=1 to skip this check entirely:
    STUBS_TDD_RED=1 git commit -m "red: ..."

Hard stubs detected (always; cause exit 1):
  Python  │ raise NotImplementedError  ·  # STUB
  TS/JS   │ throw new Error(*not implemented*)  ·  // STUB

Soft markers detected (--strict only; listed but do not fail):
  Python  │ # TODO  ·  # FIXME  ·  # HACK
  TS/JS   │ // TODO  ·  // FIXME  ·  // HACK

Scanned extensions:
  *.py  ·  *.ts  ·  *.tsx  (plus *.js  ·  *.jsx  when --file-type javascript)
  *.md and all other file types are excluded — Markdown is linted/formatted separately.

Excluded paths:
  node_modules/  ·  .venv/  ·  __pycache__/  ·  migrations/  ·  .next/
  generated/  ·  dist/  ·  .git/  ·  audits/

Exit codes:  0 = clean (or TDD red phase)   1 = hard stubs found   2 = script error
EOF
}

require_arg() {
  [[ $# -gt 1 ]] || die "$1 requires a value"
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)       STRICT=true; shift ;;
    --file-type)    require_arg "$@"; FILE_TYPES+=("$2"); shift 2 ;;
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

# Validation
$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json|html) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json html" ;;
  esac
fi
for ft in "${FILE_TYPES[@]+"${FILE_TYPES[@]}"}"; do
  case "$ft" in
    python|typescript|javascript) ;;
    *) die "Invalid --file-type '$ft'. Choose: python typescript javascript" ;;
  esac
done
[[ ${#FILE_TYPES[@]} -eq 0 ]] && FILE_TYPES=(python typescript)

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/stubs-report.$OUTPUT_FORMAT"
fi

# ── TDD/BDD red phase bypass ──────────────────────────────────────────────────
if [[ "${STUBS_TDD_RED:-0}" == "1" ]]; then
  printf '\033[33m⚠  TDD/BDD red phase — stub audit skipped (STUBS_TDD_RED=1).\033[0m\n'
  exit 0
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
MODE=$($STRICT && echo "strict" || echo "hard-stubs")
SCAN_ROOT="${TARGET_PATH:-$PROJECT_ROOT/code/src}"

log ""
bold "▸ stubs.sh — $TIMESTAMP"
log "  mode:  $MODE"
log "  types: ${FILE_TYPES[*]}"
log "  root:  $SCAN_ROOT"
log ""

# ── File-type selectors ───────────────────────────────────────────────────────
wants() {
  local target="$1"
  for ft in "${FILE_TYPES[@]}"; do [[ "$ft" == "$target" ]] && return 0; done
  return 1
}

wants_ts_js() {
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in typescript|javascript) return 0 ;; esac
  done
  return 1
}

# ── Shared grep exclusions ────────────────────────────────────────────────────
EXCL=(
  --exclude-dir=node_modules
  --exclude-dir=.venv
  --exclude-dir=__pycache__
  --exclude-dir=migrations
  --exclude-dir=.next
  --exclude-dir=generated
  --exclude-dir=dist
  --exclude-dir=.git
  --exclude-dir=audits
)

# scan LABEL SEVERITY PATTERN EXT...
# Appends findings to TMPFILE; updates counters and OVERALL_EXIT.
scan() {
  local label="$1" severity="$2" pattern="$3"
  shift 3

  local all_hits="" hits ext
  for ext in "$@"; do
    hits=$(grep -rn "${EXCL[@]}" --include="$ext" -E "$pattern" "$SCAN_ROOT" 2>/dev/null || true)
    if [[ -n "$hits" ]]; then
      [[ -n "$all_hits" ]] && all_hits+=$'\n'
      all_hits+="$hits"
    fi
  done

  [[ -z "$all_hits" ]] && return 0

  local count s
  count=$(printf '%s\n' "$all_hits" | wc -l | tr -d ' ')
  s="$([[ $count -ne 1 ]] && echo 's' || echo '')"
  TOTAL_HITS=$((TOTAL_HITS + count))

  if [[ "$severity" == "hard" ]]; then
    HARD_HITS=$((HARD_HITS + count))
    OVERALL_EXIT=1
    $QUIET || printf '\033[31m  ✗ %s — %d hit%s\033[0m\n' "$label" "$count" "$s"
  else
    SOFT_HITS=$((SOFT_HITS + count))
    $QUIET || printf '\033[33m  ⚠ %s — %d hit%s\033[0m\n' "$label" "$count" "$s"
  fi

  if ! $QUIET; then
    printf '%s\n' "$all_hits" | sed 's/^/    /'
    printf '\n'
  fi

  printf '%s\n' "$all_hits" >> "$TMPFILE"
}

# ── Python / Django / GraphQL (Strawberry) ────────────────────────────────────
if wants python; then
  bold "── Python / Django / GraphQL (Strawberry) ─────────────────────────────────"
  scan "raise NotImplementedError" hard \
    'raise NotImplementedError' \
    "*.py"
  scan "# STUB marker" hard \
    '#[[:space:]]*(STUB)($|[[:space:]:])' \
    "*.py"
  if $STRICT; then
    scan "# TODO marker" soft \
      '#[[:space:]]*(TODO)($|[[:space:]:])' \
      "*.py"
    scan "# FIXME marker" soft \
      '#[[:space:]]*(FIXME)($|[[:space:]:])' \
      "*.py"
    scan "# HACK marker" soft \
      '#[[:space:]]*(HACK)($|[[:space:]:])' \
      "*.py"
  fi
  log ""
fi

# ── TypeScript / JavaScript / Next.js / React / React Native ─────────────────
if wants_ts_js; then
  bold "── TypeScript / JavaScript / Next.js / React / React Native ───────────────"
  declare -a ts_exts=("*.ts" "*.tsx")
  wants javascript && ts_exts+=("*.js" "*.jsx")

  scan "throw new Error (not implemented)" hard \
    'throw new Error\(.*[Nn]ot.{0,3}[Ii]mplemented' \
    "${ts_exts[@]}"
  scan "// STUB marker" hard \
    '//[[:space:]]*(STUB)($|[[:space:]:])' \
    "${ts_exts[@]}"
  if $STRICT; then
    scan "// TODO marker" soft \
      '//[[:space:]]*(TODO)($|[[:space:]:])' \
      "${ts_exts[@]}"
    scan "// FIXME marker" soft \
      '//[[:space:]]*(FIXME)($|[[:space:]:])' \
      "${ts_exts[@]}"
    scan "// HACK marker" soft \
      '//[[:space:]]*(HACK)($|[[:space:]:])' \
      "${ts_exts[@]}"
  fi
  log ""
fi

# ── Report output ─────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  RAW=$(<"$TMPFILE")

  case "$OUTPUT_FORMAT" in
    txt)
      cp "$TMPFILE" "$OUTPUT_FILE"
      ;;

    md)
      {
        printf '# Stub Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Mode** | %s |\n' "$MODE"
        printf '| **Types** | %s |\n' "${FILE_TYPES[*]}"
        printf '| **Hard stubs** | %d |\n' "$HARD_HITS"
        printf '| **Soft markers** | %d |\n' "$SOFT_HITS"
        printf '| **Status** | %s |\n\n' \
          "$([[ $OVERALL_EXIT -eq 0 ]] && echo '✓ No hard stubs' || echo '✗ Hard stubs found')"
        if [[ -n "$RAW" ]]; then
          printf '```text\n%s\n```\n' "$RAW"
        else
          printf '_No stubs or markers found._\n'
        fi
      } > "$OUTPUT_FILE"
      ;;

    json)
      {
        printf '{\n'
        printf '  "script": "stubs",\n'
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "mode": "%s",\n' "$MODE"
        printf '  "file_types": [%s],\n' \
          "$(printf '"%s",' "${FILE_TYPES[@]}" | sed 's/,$//')"
        printf '  "hard_hits": %d,\n' "$HARD_HITS"
        printf '  "soft_hits": %d,\n' "$SOFT_HITS"
        printf '  "total_hits": %d,\n' "$TOTAL_HITS"
        printf '  "exit_code": %d,\n' "$OVERALL_EXIT"
        printf '  "output": %s\n' \
          "$(printf '%s' "$RAW" | python3 -c \
            'import sys,json; print(json.dumps(sys.stdin.read()))' \
            2>/dev/null || printf '""')"
        printf '}\n'
      } > "$OUTPUT_FILE"
      ;;

    html)
      escaped=$(printf '%s' "$RAW" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
      {
        cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Stub Audit — project-name</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; }
    body { font-family: system-ui, -apple-system, sans-serif; max-width: 960px;
           margin: 2rem auto; padding: 0 1.5rem; color: #1a1a2e; }
    h1   { border-bottom: 2px solid #e8e8f0; padding-bottom: .5rem; }
    table { border-collapse: collapse; margin-bottom: 1.5rem; }
    td, th { padding: .35rem .75rem; text-align: left; border: 1px solid #ddd; }
    .ok   { color: #2d6a4f; font-weight: 600; }
    .fail { color: #d62828; font-weight: 600; }
    pre   { background: #f4f4f8; padding: 1.25rem; border-radius: 6px;
            overflow-x: auto; font-size: .82rem; line-height: 1.5; white-space: pre-wrap; }
  </style>
</head>
<body>
  <h1>Stub Audit — project-name</h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>Mode</th><td>$MODE</td></tr>
    <tr><th>File types</th><td>${FILE_TYPES[*]}</td></tr>
    <tr><th>Hard stubs</th><td>$HARD_HITS</td></tr>
    <tr><th>Soft markers</th><td>$SOFT_HITS</td></tr>
    <tr><th>Status</th><td class="$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)">
      $([[ $OVERALL_EXIT -eq 0 ]] && echo '&#10003; No hard stubs' || echo '&#10007; Hard stubs found')
    </td></tr>
  </table>
  <pre>$escaped</pre>
</body>
</html>
HTML
      } > "$OUTPUT_FILE"
      ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ $OVERALL_EXIT -eq 0 ]]; then
  bold "✓ No hard stubs found."
  if $STRICT && [[ $SOFT_HITS -gt 0 ]]; then
    s="$([[ $SOFT_HITS -ne 1 ]] && echo 's' || echo '')"
    log "  ($SOFT_HITS soft marker${s} noted — run with --output to capture in a report)"
  fi
else
  s="$([[ $HARD_HITS -ne 1 ]] && echo 's' || echo '')"
  bold "✗ Hard stubs found ($HARD_HITS occurrence${s})."
  log "  Remove stubs before committing, or run with STUBS_TDD_RED=1 for TDD/BDD red phase."
fi
log ""

exit $OVERALL_EXIT
