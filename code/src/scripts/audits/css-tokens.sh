#!/usr/bin/env bash
#
# css-tokens.sh — Verify every CSS custom property referenced via var(--x) across
#                 the three styling scopes resolves to a token defined somewhere in
#                 those scopes (or to an allowlisted runtime-injected prefix).
#
#                 Catches "phantom" tokens — references to custom properties that
#                 are defined nowhere. Under Lightning CSS a phantom with no var()
#                 fallback is dropped, so the declaration silently fails. This guard
#                 is the regression gate that keeps the design-token layer honest.
#
# Scopes scanned (*.css only):
#   code/src/django/static/css    (token source of truth: tokens/*.css, surfaces.css)
#   code/src/django/static/css   (ADR-019: Django static token cascade + per-page CSS)
#   code/src/django/components   (ADR-019: co-located django-component BEM CSS)
#
# "Defined"   — `--name:` appears as a declaration LHS anywhere in those scopes.
# "Referenced"— `var(--name` appears anywhere in those scopes.
# "Allowlist" — runtime-injected variables set via inline style in .tsx, matched by
#               prefix (default: --blk-). Repeat --allow to add more.
#
# CSS comments are stripped before scanning, so documented examples never count.
#
# Usage: css-tokens.sh [--allow PREFIX] [--output FORMAT] [--output-file PATH]
#                      [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = all references resolve   1 = phantom tokens found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

SCOPES=(
  "code/src/django/static/css"
  "code/src/django/components"
)

# ── Defaults ──────────────────────────────────────────────────────────────────
declare -a ALLOW_PREFIXES=("--blk-")
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'css-tokens.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
css-tokens.sh — Verify every var(--x) reference resolves to a defined CSS token

Usage:
  css-tokens.sh                    Scan all three CSS scopes
  css-tokens.sh --allow --rt-      Add another runtime-injected allowlist prefix
  css-tokens.sh --output md        Also write a report

Options:
  --allow PREFIX       Allowlist a runtime-injected token prefix (repeat to add;
                       default: --blk-). Use for vars set via inline style in .tsx.
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/css-tokens-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the REFERENCE scan to a file/dir (definitions stay
                       full-scope, so a subset is checked against all known tokens)
  --help               Show this help

Exit codes:  0 = all references resolve   1 = phantom tokens found   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --allow)        require_arg "$@"; ALLOW_PREFIXES+=("$2"); shift 2 ;;
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
  OUTPUT_FILE="$REPORTS_DIR/css-tokens-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

declare -a REF_ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  REF_ROOTS=("$TARGET_PATH")
else
  REF_ROOTS=("${SCOPES[@]}")
fi

TMP_DEF=$(mktemp); TMP_REF=$(mktemp); TMP_PHANTOM=$(mktemp); TMP_REFCSS=$(mktemp)
trap 'rm -f "$TMP_DEF" "$TMP_REF" "$TMP_PHANTOM" "$TMP_REFCSS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ css-tokens.sh — $TIMESTAMP"
log "  scopes:    ${SCOPES[*]}"
log "  allowlist: ${ALLOW_PREFIXES[*]}"
[[ -n "$TARGET_PATH" ]] && log "  ref path:  $TARGET_PATH"
log ""

# Emit comment-stripped content of every *.css under the given roots.
# find guarantees *.css only (no reliance on the grep glob); perl strips /* … */.
emit_css() {
  local root
  for root in "$@"; do
    [[ -e "$root" ]] || continue
    find "$root" -type f -name '*.css' -print0
  done | xargs -0 -r perl -0777 -pe 's{/\*.*?\*/}{}gs' 2>/dev/null || true
}

# DEFINED — `--name:` declaration LHS (locally-defined component vars count, so they never false-positive).
emit_css "${SCOPES[@]}" \
  | grep -oE -- '[-][-][a-z0-9-]+[[:space:]]*:' 2>/dev/null \
  | sed -E 's/[[:space:]]*:$//' | sort -u > "$TMP_DEF" || true

# REFERENCED — `var(--name`
emit_css "${REF_ROOTS[@]}" \
  | grep -oE -- 'var\([[:space:]]*[-][-][a-z0-9-]+' 2>/dev/null \
  | sed -E 's/var\([[:space:]]*//' | sort -u > "$TMP_REF" || true

# .css file list for the per-token "where used" report (NUL-delimited).
for root in "${REF_ROOTS[@]}"; do
  [[ -e "$root" ]] || continue
  find "$root" -type f -name '*.css' -print0
done > "$TMP_REFCSS" || true

DEF_COUNT=$(wc -l < "$TMP_DEF" | tr -d ' ')
REF_COUNT=$(wc -l < "$TMP_REF" | tr -d ' ')

allowed() {
  local tok="$1" pre
  for pre in "${ALLOW_PREFIXES[@]}"; do [[ "$tok" == "$pre"* ]] && return 0; done
  return 1
}

: > "$TMP_PHANTOM"
while IFS= read -r tok; do
  [[ -z "$tok" ]] && continue
  grep -qxF -- "$tok" "$TMP_DEF" && continue
  allowed "$tok" && continue
  printf '%s\n' "$tok" >> "$TMP_PHANTOM"
done < "$TMP_REF"

PHANTOM_COUNT=$(wc -l < "$TMP_PHANTOM" | tr -d ' ')

log "  defined:    $DEF_COUNT"
log "  referenced: $REF_COUNT"
log ""

# Per-phantom ref count + owning files (xargs over the NUL-delimited .css list).
build_body() {
  local tok refs files re bound
  bound='([^a-z0-9-]|$)'   # token boundary so --color-text does not match --color-text-muted
  while IFS= read -r tok; do
    [[ -z "$tok" ]] && continue
    re=$(printf '%s' "$tok" | sed 's/-/[-]/g')
    refs=$(xargs -0 -r grep -hoE -- "var\([[:space:]]*${re}${bound}" < "$TMP_REFCSS" 2>/dev/null | wc -l | tr -d ' ')
    files=$(xargs -0 -r grep -lE -- "var\([[:space:]]*${re}${bound}" < "$TMP_REFCSS" 2>/dev/null \
      | sed 's#code/src/django/components/##; s#code/src/django/static/css/##' \
      | tr '\n' ' ' || true)
    printf '%-30s refs:%-3s  %s\n' "$tok" "$refs" "$files"
  done < "$TMP_PHANTOM"
}

BODY=""
if [[ "$PHANTOM_COUNT" -gt 0 ]]; then
  BODY=$(build_body)
  if ! $QUIET; then
    printf '\033[31m  ✗ %d phantom token%s — referenced via var() but defined nowhere\033[0m\n' \
      "$PHANTOM_COUNT" "$([[ "$PHANTOM_COUNT" -ne 1 ]] && echo s)"
    printf '%s\n' "$BODY" | sed 's/^/    /'
    printf '\n'
  fi
fi

# ── Report output ─────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$PHANTOM_COUNT" -eq 0 ]] && echo '✓ all references resolve' || echo "✗ $PHANTOM_COUNT phantom token(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'css-tokens audit — %s\n' "$TIMESTAMP"
        printf 'defined=%s referenced=%s phantom=%s\n\n' "$DEF_COUNT" "$REF_COUNT" "$PHANTOM_COUNT"
        printf '%s\n' "${BODY:-No phantom tokens.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# CSS Token Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Defined** | %s |\n' "$DEF_COUNT"
        printf '| **Referenced** | %s |\n' "$REF_COUNT"
        printf '| **Phantom** | %s |\n' "$PHANTOM_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$PHANTOM_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_All var(--x) references resolve to a defined token._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "css-tokens",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "defined": %s,\n  "referenced": %s,\n  "phantom": %s,\n' "$DEF_COUNT" "$REF_COUNT" "$PHANTOM_COUNT"
        printf '  "phantom_tokens": [%s],\n' "$(sed 's/.*/"&"/' "$TMP_PHANTOM" | paste -sd, - 2>/dev/null)"
        printf '  "exit_code": %s\n}\n' "$([[ "$PHANTOM_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$PHANTOM_COUNT" -eq 0 ]]; then
  bold "✓ All var(--x) references resolve to a defined token."
  log ""
  exit 0
else
  bold "✗ $PHANTOM_COUNT phantom token(s) — every var(--x) must resolve to a defined token."
  log "  Fix the reference (map to the real token) or define/allowlist the variable."
  log ""
  exit 1
fi
