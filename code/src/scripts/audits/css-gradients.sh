#!/usr/bin/env bash
#
# css-gradients.sh — Ban raw inline gradients in component and page CSS.
#
#                    A raw linear-/radial-/conic-gradient(...) composed inline in
#                    component or page CSS is the generic "AI-look" tell — a universal
#                    one, banned on every visual direction and every surface rather
#                    than only where it clashes. Brand gradients are
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
# Scopes scanned (*.css only):
#   code/src/django/static/css        (cascade + per-page CSS, minus the token layer)
#   code/src/django/components        (cross-app django-component BEM CSS)
#   code/src/django/apps/*/components (component CSS an app owns)
#
# BOTH COMPONENT HOMES ARE SCANNED. django-components searches the top-level
# directory and each app's own by default, so a component legitimately lives in
# either (code/docs/FRONTEND-CODING-PRINCIPLES.md). A scope naming only the first
# would miss half the population the moment an app owns one. The per-app glob is
# expanded at run time and contributes nothing until such a directory exists.
#
# NO-OP WHEN ABSENT, AND IT SAYS SO. A project with no stylesheets has an empty
# population: no declaration could match, so the run is clean by definition and exits
# 0 — but it prints the file count it scanned and names the absent surface as the
# reason, because "could not look" reported as "looked, and it was clean" is the one
# thing a gate may never do (code/docs/GATE-REPORTING.md). With --output it STILL
# writes the report, so a CI job collecting the artefact always finds its file.
#
# Usage: css-gradients.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                         [--path PATH] [--help]
#
# Exit codes:  0 = no inline gradients (or surface absent)
#              1 = inline gradient(s) found
#              2 = script error
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
  css-gradients.sh                 Scan every component/page CSS scope (see the header)
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

Exit codes:  0 = clean, or the surface is absent (the run says which)
             1 = inline gradient(s) found
             2 = script error
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

# Per-app component CSS. django-components searches the top-level components
# directory AND each app's own, so a component legitimately lives in either.
# Expanded here, after the cd, with nullglob so an unmatched pattern contributes
# nothing rather than a literal path the scan would then have to skip.
shopt -s nullglob
SCOPES+=(code/src/django/apps/*/components)
shopt -u nullglob

declare -a ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  ROOTS=("$TARGET_PATH")
else
  ROOTS=("${SCOPES[@]}")
fi

TMP_HITS=$(mktemp); TMP_FILES=$(mktemp)
trap 'rm -f "$TMP_HITS" "$TMP_FILES"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# Report state. Initialised before the scan because the absent-surface exit writes a
# report of its own, ahead of anything else having set them.
SURFACE_ABSENT=false
SURFACE_NOTE=""
HIT_COUNT=0
BODY=""

# ── The population, counted before anything is scanned ────────────────────────
# The count is what makes the verdict legible: a clean run over 40 stylesheets and a
# clean run over none are the same line without it (code/docs/GATE-REPORTING.md).
# The token layer is pruned here rather than filtered later, because it is where a
# gradient is legitimately DEFINED — scanning it would fail the very file the rule
# points every component at.
: > "$TMP_FILES"
for root in "${ROOTS[@]}"; do
  [[ -e "$root" ]] || continue
  find "$root" -type f -name '*.css' \
    -not -path '*/static/css/tokens/*' \
    -print0 >> "$TMP_FILES" || true
done
FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

# ── Report output ─────────────────────────────────────────────────────────────
# Defined ABOVE the absent-surface exit, because a CI job told to collect
# code/src/scripts/audits/reports/css-gradients-report.<FORMAT> must always find the
# file. An absent surface writes a clean, zero-finding report naming the reason
# rather than leaving nothing on disk — under `--quiet --output json` a missing file
# is no signal at all.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if $SURFACE_ABSENT; then
    status="✓ surface absent, nothing to check"
  elif [[ "$HIT_COUNT" -eq 0 ]]; then
    status="✓ no inline gradients"
  else
    status="✗ $HIT_COUNT inline gradient(s)"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'css-gradients audit — %s\n' "$TIMESTAMP"
        printf 'files=%s inline_gradients=%s\n' "$FILE_COUNT" "$HIT_COUNT"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        printf '\n%s\n' "${BODY:-No inline gradients.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Inline-Gradient Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files scanned** | %s |\n' "$FILE_COUNT"
        printf '| **Inline gradients** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        elif ! $SURFACE_ABSENT; then
          printf '_No raw inline gradients across %s file(s) — every gradient is a var(--gradient-*) token._\n' \
            "$FILE_COUNT"
        fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "css-gradients",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "files": %s,\n' "$FILE_COUNT"
        printf '  "inline_gradients": %s,\n' "$HIT_COUNT"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
  return 0
}

log ""
bold "▸ css-gradients.sh — $TIMESTAMP"
log "  scopes: ${ROOTS[*]}"
log "  files:  $FILE_COUNT"
log ""

# ── No-op when the surface is absent ──────────────────────────────────────────
# Zero stylesheets is an empty population, not a clean sweep. Exit 0 — the surface is
# absent, not the tool — but say which, or the reader cannot tell the two apart.
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SURFACE_ABSENT=true
  SURFACE_NOTE="Surface absent: no component or page *.css file exists under ${ROOTS[*]}, so no declaration could match. This run is clean by definition and is not evidence that the gradient rule holds."
  log "  no *.css files under: ${ROOTS[*]}"
  log "  This project has not written any CSS yet."
  log ""
  write_report
  bold "✓ Nothing to check — no stylesheet exists, so no declaration was examined."
  log ""
  exit 0
fi

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
done < "$TMP_FILES"

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d inline gradient%s — compose brand gradients as a var(--gradient-*) token\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

write_report

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ No raw inline gradients across $FILE_COUNT file(s) — every gradient is a var(--gradient-*) token."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT inline gradient(s) — add a --gradient-* token and consume var(--gradient-*)."
  log "  Functional gradients (shimmer/mask) may stay inline with a gradient-allow annotation."
  log ""
  exit 1
fi
