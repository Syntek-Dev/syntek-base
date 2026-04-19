#!/usr/bin/env bash
#
# cloc.sh — Count lines per file (wc -l enforcement) and generate a cloc language
#           breakdown report. Matches the project's file-size limits in CLAUDE.md.
#
#           Per-file thresholds (total file lines):
#             ≥ 750 lines → WARNING  (printed; does not fail)
#             ≥ 800 lines → ERROR    (exit 1 — exceeds project hard limit)
#
# Requirements: cloc must be installed (used for the language breakdown report only).
#               Install: sudo apt-get install cloc  |  brew install cloc
#               wc and find are used for per-file enforcement (always available).
#
# Usage: cloc.sh [--output FORMAT] [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = all files within limits   1 = one or more files ≥ 800 lines   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

WARN_THRESHOLD=750
ERROR_THRESHOLD=800

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
OVERALL_EXIT=0
WARN_COUNT=0
ERROR_COUNT=0

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'cloc.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
cloc.sh — Line-count audit using wc -l (enforcement) and cloc (language summary)

Usage:
  cloc.sh                          Scan default source paths
  cloc.sh --path code/src/backend  Restrict to a specific directory
  cloc.sh --output md              Write a markdown report

Options:
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/cloc-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict scan to a specific file or directory
  --help               Show this help

Thresholds (total file lines, including blank lines and comments):
  ≥ 750 lines → WARNING   (printed; does not fail)
  ≥ 800 lines → ERROR     (exit 1 — project hard limit per CLAUDE.md)

Excluded paths:
  node_modules/  ·  .venv/  ·  __pycache__/  ·  migrations/  ·  .next/
  generated/  ·  dist/  ·  .git/

Excluded file types:
  *.md — Markdown files are linted and formatted separately; they are not subject
  to the 750/800-line enforcement and are excluded from the cloc language summary.

Requirements:
  cloc — language summary (sudo apt-get install cloc | brew install cloc)
  wc, find — per-file enforcement (always available)

Exit codes:  0 = all files within limits   1 = file(s) ≥ 800 lines   2 = script error
EOF
}

require_arg() {
  [[ $# -gt 1 ]] || die "$1 requires a value"
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
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

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/cloc-report.$OUTPUT_FORMAT"
fi

# ── cloc availability ─────────────────────────────────────────────────────────
CLOC_AVAILABLE=false
command -v cloc >/dev/null 2>&1 && CLOC_AVAILABLE=true
if ! $CLOC_AVAILABLE; then
  printf 'cloc.sh warning: cloc is not installed — language summary will be skipped.\n'
  printf '  Install with:  sudo apt-get install cloc   or   brew install cloc\n' >&2
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"

TMPFILE=$(mktemp)
ENFORCE_TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE" "$ENFORCE_TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
SCAN_ROOT="${TARGET_PATH:-$PROJECT_ROOT/code/src}"

log ""
bold "▸ cloc.sh — $TIMESTAMP"
log "  warn at: ≥${WARN_THRESHOLD} lines"
log "  fail at: ≥${ERROR_THRESHOLD} lines"
log "  root:    $SCAN_ROOT"
log ""

# ── Per-file enforcement (wc -l) ──────────────────────────────────────────────
bold "── Per-file line count ────────────────────────────────────────────────────"

EXCL_FIND=(
  -path "*/node_modules/*" -o
  -path "*/.venv/*" -o
  -path "*/__pycache__/*" -o
  -path "*/migrations/*" -o
  -path "*/.next/*" -o
  -path "*/generated/*" -o
  -path "*/dist/*" -o
  -path "*/.git/*"
)

SOURCE_EXTS=( -name "*.py" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" )

while IFS= read -r -d '' f; do
  lines=$(wc -l < "$f" | tr -d ' ')
  rel="${f#$PROJECT_ROOT/}"

  if [[ $lines -ge $ERROR_THRESHOLD ]]; then
    OVERALL_EXIT=1
    ERROR_COUNT=$((ERROR_COUNT + 1))
    $QUIET || printf '\033[31m  ✗ ERROR   [%4d lines] %s\033[0m\n' "$lines" "$rel"
    printf 'ERROR [%4d lines] %s\n' "$lines" "$rel" >> "$ENFORCE_TMPFILE"
  elif [[ $lines -ge $WARN_THRESHOLD ]]; then
    WARN_COUNT=$((WARN_COUNT + 1))
    $QUIET || printf '\033[33m  ⚠ WARNING [%4d lines] %s\033[0m\n' "$lines" "$rel"
    printf 'WARNING [%4d lines] %s\n' "$lines" "$rel" >> "$ENFORCE_TMPFILE"
  fi
done < <(
  find "$SCAN_ROOT" \
    \( "${EXCL_FIND[@]}" \) -prune \
    -o -type f \( "${SOURCE_EXTS[@]}" \) -print0 \
    2>/dev/null
)

if [[ $WARN_COUNT -eq 0 && $ERROR_COUNT -eq 0 ]]; then
  log "  All files within limits."
fi
log ""

# ── cloc language summary ─────────────────────────────────────────────────────
bold "── Language breakdown (cloc) ──────────────────────────────────────────────"

CLOC_OUTPUT=""
if $CLOC_AVAILABLE; then
  CLOC_EXCLUDE_DIRS="node_modules,.venv,__pycache__,migrations,.next,generated,dist"

  CLOC_OUTPUT=$(
    cloc "$SCAN_ROOT" \
      --exclude-dir="$CLOC_EXCLUDE_DIRS" \
      --exclude-lang=Markdown \
      --quiet \
      --hide-rate \
      2>/dev/null || true
  )

  if [[ -n "$CLOC_OUTPUT" ]]; then
    if ! $QUIET; then
      printf '%s\n' "$CLOC_OUTPUT" | sed 's/^/  /'
    fi
    printf '%s\n' "$CLOC_OUTPUT" >> "$TMPFILE"
  else
    log "  (No countable source files found in scan root.)"
  fi
else
  log "  ⚠  cloc not installed — language summary skipped."
fi
log ""

# ── Combine enforcement + summary into TMPFILE ───────────────────────────────
if [[ -s "$ENFORCE_TMPFILE" ]]; then
  {
    printf '=== Per-file violations ===\n'
    cat "$ENFORCE_TMPFILE"
    printf '\n'
    if [[ -n "$CLOC_OUTPUT" ]]; then
      printf '=== Language breakdown ===\n'
      printf '%s\n' "$CLOC_OUTPUT"
    fi
  } > "$TMPFILE"
else
  {
    printf '=== Per-file violations ===\n'
    printf '(none)\n\n'
    if [[ -n "$CLOC_OUTPUT" ]]; then
      printf '=== Language breakdown ===\n'
      printf '%s\n' "$CLOC_OUTPUT"
    fi
  } > "$TMPFILE"
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
        printf '# Line-Count Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Warn threshold** | ≥%d lines |\n' "$WARN_THRESHOLD"
        printf '| **Error threshold** | ≥%d lines |\n' "$ERROR_THRESHOLD"
        printf '| **Warnings** | %d |\n' "$WARN_COUNT"
        printf '| **Errors** | %d |\n' "$ERROR_COUNT"
        printf '| **Status** | %s |\n\n' \
          "$([[ $OVERALL_EXIT -eq 0 ]] && echo '✓ All files within limits' || echo '✗ Files exceed hard limit')"
        printf '```text\n%s\n```\n' "$RAW"
      } > "$OUTPUT_FILE"
      ;;

    json)
      {
        printf '{\n'
        printf '  "script": "cloc",\n'
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "warn_threshold": %d,\n' "$WARN_THRESHOLD"
        printf '  "error_threshold": %d,\n' "$ERROR_THRESHOLD"
        printf '  "warnings": %d,\n' "$WARN_COUNT"
        printf '  "errors": %d,\n' "$ERROR_COUNT"
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
  <title>Line-Count Audit — project-name</title>
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
  <h1>Line-Count Audit — project-name</h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>Warn threshold</th><td>≥${WARN_THRESHOLD} lines</td></tr>
    <tr><th>Error threshold</th><td>≥${ERROR_THRESHOLD} lines</td></tr>
    <tr><th>Warnings</th><td>$WARN_COUNT</td></tr>
    <tr><th>Errors</th><td>$ERROR_COUNT</td></tr>
    <tr><th>Status</th><td class="$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)">
      $([[ $OVERALL_EXIT -eq 0 ]] && echo '&#10003; All files within limits' || echo '&#10007; Files exceed hard limit')
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
  if [[ $WARN_COUNT -gt 0 ]]; then
    sw="$([[ $WARN_COUNT -ne 1 ]] && echo 's' || echo '')"
    bold "⚠ All files under hard limit, but $WARN_COUNT file${sw} approaching it (≥${WARN_THRESHOLD} lines)."
    log "  Consider splitting files that are approaching ${ERROR_THRESHOLD} lines."
  else
    bold "✓ All files within limits."
  fi
else
  se="$([[ $ERROR_COUNT -ne 1 ]] && echo 's' || echo '')"
  bold "✗ $ERROR_COUNT file${se} exceed${se:+s} the hard limit of ${ERROR_THRESHOLD} lines."
  log "  Split oversized files into focused modules before committing. [CLAUDE.md]"
fi
log ""

exit $OVERALL_EXIT
