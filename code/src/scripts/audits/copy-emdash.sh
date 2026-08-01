#!/usr/bin/env bash
#
# copy-emdash.sh — Ban em dashes (—, U+2014) in public marketing copy.
#
#                  An em dash in user-facing prose is a recognisable machine-authored
#                  tell. {{ORG_NAME}} marketing copy rewords instead — a comma, colon, full
#                  stop, parentheses, or a reworded clause — and NEVER substitutes a
#                  spaced en dash. Voice: BRAND-VOICE.md. Rule: VISUAL-DESIGN.md § 4.
#
#                  Numeric/day en dashes (–, U+2013) in ranges (Mon–Fri, 9–5) are
#                  correct typography and are NOT flagged.
#
# Scopes scanned:
#   code/src/django/apps/marketing/pagedata   (*.py — page copy modules)
#   code/src/django/apps/marketing/templates   (*.html — marketing templates)
#
# Usage: copy-emdash.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                       [--path PATH] [--help]
#
# Exit codes:  0 = no em dashes   1 = em dash(es) found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

EMDASH='—'   # U+2014

# Each entry: "<dir>:<glob>"
SCOPES=(
  "code/src/django/apps/marketing/pagedata:*.py"
  "code/src/django/apps/marketing/templates:*.html"
)

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'copy-emdash.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
copy-emdash.sh — Ban em dashes (—) in public marketing copy

Usage:
  copy-emdash.sh                 Scan marketing pagedata (*.py) + templates (*.html)
  copy-emdash.sh --output md     Also write a report
  copy-emdash.sh --path DIR      Restrict the scan to a file/dir

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/copy-emdash-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the scan to a file or directory (any extension)
  --help               Show this help

Numeric/day en dashes (–, e.g. Mon–Fri) are correct and are NOT flagged.

Exit codes:  0 = clean   1 = em dash(es) found   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

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

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/copy-emdash-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_HITS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ copy-emdash.sh — $TIMESTAMP"

# Collect matching files (NUL-delimited) for either the override path or the scopes.
collect_files() {
  if [[ -n "$TARGET_PATH" ]]; then
    [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
    if [[ -d "$TARGET_PATH" ]]; then
      find "$TARGET_PATH" -type f -print0
    else
      printf '%s\0' "$TARGET_PATH"
    fi
  else
    local entry dir glob
    for entry in "${SCOPES[@]}"; do
      dir="${entry%%:*}"; glob="${entry##*:}"
      [[ -e "$dir" ]] || continue
      find "$dir" -type f -name "$glob" -print0
    done
  fi
}

log "  scanning marketing copy for em dashes…"
log ""

: > "$TMP_HITS"
while IFS= read -r -d '' file; do
  grep -n -- "$EMDASH" "$file" 2>/dev/null | sed "s#^#${file}:#" >> "$TMP_HITS" || true
done < <(collect_files)

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d em dash%s in marketing copy — reword (comma/colon/full stop), never a spaced en dash\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo es)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$HIT_COUNT" -eq 0 ]] && echo '✓ no em dashes' || echo "✗ $HIT_COUNT em dash(es)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'copy-emdash audit — %s\n' "$TIMESTAMP"
        printf 'em_dashes=%s\n\n' "$HIT_COUNT"
        printf '%s\n' "${BODY:-No em dashes.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Marketing-Copy Em-Dash Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Em dashes** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_No em dashes in marketing copy._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "copy-emdash",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "em_dashes": %s,\n' "$HIT_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ No em dashes in marketing copy."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT em dash(es) in marketing copy — reword; never substitute a spaced en dash."
  log ""
  exit 1
fi
