#!/usr/bin/env bash
#
# css-gradients.sh — Ban raw inline gradients in component and page CSS.
#
#                    A raw linear-/radial-/conic-gradient(...) composed inline in
#                    component or page CSS is the generic "AI-look" tell
#                    (code/docs/VISUAL-DESIGN.md Section 4.1 — a universal tell, banned on
#                    every direction and every surface). Brand gradients are
#                    DB-canonical --gradient-* tokens (static/css/tokens/
#                    gradients.css) and must be consumed via var(--gradient-*).
#
#                    The token layer itself (static/css/tokens/*) is where
#                    gradients are legitimately DEFINED, so it is NOT scanned.
#
#                    Functional gradients (a loading shimmer, an image/scrim mask)
#                    are exempt when the declaration — or the line directly above
#                    it — carries a `gradient-allow` annotation.
#
# Scopes scanned (*.css only) — the live CSS surfaces:
#   code/src/django/static/css   (Django static token cascade + per-page CSS)
#   code/src/django/components    (co-located django-component BEM CSS)
#
# Usage: css-gradients.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                         [--path PATH] [--help]
#
# Exit codes:  0 = no inline gradients   1 = inline gradient(s) found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

SCOPES=(
  "code/src/django/static/css"
  "code/src/django/components"
)

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'css-gradients.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
css-gradients.sh — Ban raw inline gradients in component/page CSS

Usage:
  css-gradients.sh                 Scan all component/page CSS scopes
  css-gradients.sh --output md     Also write a report
  css-gradients.sh --path DIR      Restrict the scan to a file/dir

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/css-gradients-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the scan to a file or directory
  --help               Show this help

A gradient is allowed only in the token layer (static/css/tokens/*) or when the
declaration — or the line directly above it — carries a `gradient-allow` annotation.

Exit codes:  0 = clean   1 = inline gradient(s) found   2 = script error
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
  OUTPUT_FILE="$REPORTS_DIR/css-gradients-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

declare -a ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  ROOTS=("$TARGET_PATH")
else
  ROOTS=("${SCOPES[@]}")
fi

TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_HITS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ css-gradients.sh — $TIMESTAMP"
log "  scopes: ${ROOTS[*]}"
log ""

# For each *.css file, flag any *-gradient( that is a declaration (not a comment
# line) and is not allowlisted on its own line or the line directly above it.
: > "$TMP_HITS"
while IFS= read -r -d '' file; do
  awk -v f="$file" '
    {
      is_grad = ($0 ~ /(linear|radial|conic|repeating-linear|repeating-radial|repeating-conic)-gradient[ \t]*\(/)
      is_comment = ($0 ~ /^[ \t]*(\/\*|\*)/)
      has_allow = ($0 ~ /gradient-allow/) || (prev ~ /gradient-allow/)
      if (is_grad && !is_comment && !has_allow) {
        s=$0; sub(/^[ \t]+/, "", s)
        printf "%s:%d:%s\n", f, FNR, s
      }
      prev=$0
    }
  ' "$file" >> "$TMP_HITS" || true
done < <(
  for root in "${ROOTS[@]}"; do
    [[ -e "$root" ]] || continue
    find "$root" -type f -name '*.css' -print0
  done
)

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d inline gradient%s — compose brand gradients as a var(--gradient-*) token\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$HIT_COUNT" -eq 0 ]] && echo '✓ no inline gradients' || echo "✗ $HIT_COUNT inline gradient(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'css-gradients audit — %s\n' "$TIMESTAMP"
        printf 'inline_gradients=%s\n\n' "$HIT_COUNT"
        printf '%s\n' "${BODY:-No inline gradients.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Inline-Gradient Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Inline gradients** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_No raw inline gradients — every gradient is a var(--gradient-*) token._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "css-gradients",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "inline_gradients": %s,\n' "$HIT_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ No raw inline gradients — every gradient is a var(--gradient-*) token."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT inline gradient(s) — add a --gradient-* token and consume var(--gradient-*)."
  log "  Functional gradients (shimmer/mask) may stay inline with a gradient-allow annotation."
  log ""
  exit 1
fi
