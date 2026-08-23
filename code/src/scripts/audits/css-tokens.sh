#!/usr/bin/env bash
#
# css-tokens.sh — Verify every CSS custom property referenced via var(--x) across
#                 the styling scopes resolves to a token defined somewhere in those
#                 scopes (or to an allowlisted runtime-injected prefix).
#
#                 Catches "phantom" tokens — references to custom properties that
#                 are defined nowhere. Under Lightning CSS a phantom with no var()
#                 fallback is dropped, so the declaration silently fails. This guard
#                 is the regression gate that keeps the design-token layer honest.
#
# Scopes scanned (*.css only):
#   code/src/django/static/css        (token layer + cascade + per-page CSS)
#   code/src/django/components        (cross-app django-component BEM CSS)
#   code/src/django/apps/*/components (component CSS an app owns)
#
# BOTH COMPONENT HOMES ARE SCANNED. django-components searches the top-level
# directory and each app's own by default, so a component legitimately lives in
# either (code/docs/FRONTEND-CODING-PRINCIPLES.md). A scope naming only the first
# would miss half the population the moment an app owns one. The per-app glob is
# expanded at run time and contributes nothing until such a directory exists.
#
# "Defined"   — `--name:` appears as a declaration LHS anywhere in those scopes.
# "Referenced"— `var(--name` appears anywhere in those scopes.
# "Allowlist" — runtime-injected variables set via inline style in .tsx, matched by
#               prefix (default: --blk-). Repeat --allow to add more.
#
# CSS comments are stripped before scanning, so documented examples never count.
#
# NO-OP WHEN ABSENT, AND IT SAYS SO. A project with no stylesheets has an empty
# population: no var(--x) could be examined, so the run is clean by definition and
# exits 0 — but it prints the file count it scanned and names the absent surface as
# the reason, because "could not look" reported as "looked, and it was clean" is the
# one thing a gate may never do (code/docs/GATE-REPORTING.md). With --output it STILL
# writes the report, so a CI job collecting the artefact always finds its file.
#
# Usage: css-tokens.sh [--allow PREFIX] [--output FORMAT] [--output-file PATH]
#                      [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = all references resolve (or surface absent)
#              1 = phantom tokens found
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
  css-tokens.sh                    Scan every CSS scope (see the file header)
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

Exit codes:  0 = all references resolve, or the surface is absent (the run says which)
             1 = phantom tokens found
             2 = script error
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

# perl strips CSS comments before either scan. Without it `emit_css` yields nothing and
# the run reports a clean sweep of a population it never read — an absent TOOL, which is
# never a clean result (code/docs/GATE-REPORTING.md Section 2). Exit 2: a prerequisite the
# caller must fix, not a finding.
command -v perl >/dev/null 2>&1 \
  || die "perl is not on PATH, and it strips the CSS comments both scans depend on. Nothing was examined — this is not a clean result."

cd "$PROJECT_ROOT"

# Per-app component CSS. django-components searches the top-level components
# directory AND each app's own, so a component legitimately lives in either.
# Expanded here, after the cd, with nullglob so an unmatched pattern contributes
# nothing rather than a literal path the scan would then have to skip.
shopt -s nullglob
SCOPES+=(code/src/django/apps/*/components)
shopt -u nullglob

declare -a REF_ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  REF_ROOTS=("$TARGET_PATH")
else
  REF_ROOTS=("${SCOPES[@]}")
fi

TMP_DEF=$(mktemp); TMP_REF=$(mktemp); TMP_PHANTOM=$(mktemp)
TMP_REFCSS=$(mktemp); TMP_DEFCSS=$(mktemp)
trap 'rm -f "$TMP_DEF" "$TMP_REF" "$TMP_PHANTOM" "$TMP_REFCSS" "$TMP_DEFCSS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# Report state. Initialised before the scan because the absent-surface exit writes a
# report of its own, ahead of anything else having set them.
SURFACE_ABSENT=false
SURFACE_NOTE=""
DEF_COUNT=0
REF_COUNT=0
PHANTOM_COUNT=0
BODY=""

# ── The population, counted before anything is scanned ────────────────────────
# The count is what makes the verdict legible: a clean run over 40 stylesheets and a
# clean run over none are the same line without it (code/docs/GATE-REPORTING.md).
collect_css() {
  local out="$1"; shift
  local root
  : > "$out"
  for root in "$@"; do
    [[ -e "$root" ]] || continue
    find "$root" -type f -name '*.css' -print0 >> "$out" || true
  done
}
collect_css "$TMP_REFCSS" "${REF_ROOTS[@]}"
collect_css "$TMP_DEFCSS" "${SCOPES[@]}"
REF_FILE_COUNT=$(tr -cd '\0' < "$TMP_REFCSS" | wc -c | tr -d ' ')
DEF_FILE_COUNT=$(tr -cd '\0' < "$TMP_DEFCSS" | wc -c | tr -d ' ')

# ── Report output ─────────────────────────────────────────────────────────────
# Defined ABOVE the absent-surface exit, because a CI job told to collect
# code/src/scripts/audits/reports/css-tokens-report.<FORMAT> must always find the
# file. An absent surface writes a clean, zero-finding report naming the reason
# rather than leaving nothing on disk — under `--quiet --output json` a missing file
# is no signal at all.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if $SURFACE_ABSENT; then
    status="✓ surface absent, nothing to check"
  elif [[ "$PHANTOM_COUNT" -eq 0 ]]; then
    status="✓ all references resolve"
  else
    status="✗ $PHANTOM_COUNT phantom token(s)"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'css-tokens audit — %s\n' "$TIMESTAMP"
        printf 'files=%s defined=%s referenced=%s phantom=%s\n' \
          "$REF_FILE_COUNT" "$DEF_COUNT" "$REF_COUNT" "$PHANTOM_COUNT"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        printf '\n%s\n' "${BODY:-No phantom tokens.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# CSS Token Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files scanned** | %s |\n' "$REF_FILE_COUNT"
        printf '| **Defined** | %s |\n' "$DEF_COUNT"
        printf '| **Referenced** | %s |\n' "$REF_COUNT"
        printf '| **Phantom** | %s |\n' "$PHANTOM_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        if [[ "$PHANTOM_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        elif ! $SURFACE_ABSENT; then
          printf '_All %s var(--x) reference(s) across %s file(s) resolve to a defined token._\n' \
            "$REF_COUNT" "$REF_FILE_COUNT"
        fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "css-tokens",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "files": %s,\n' "$REF_FILE_COUNT"
        printf '  "defined": %s,\n  "referenced": %s,\n  "phantom": %s,\n' "$DEF_COUNT" "$REF_COUNT" "$PHANTOM_COUNT"
        printf '  "phantom_tokens": [%s],\n' "$(sed 's/.*/"&"/' "$TMP_PHANTOM" | paste -sd, - 2>/dev/null)"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "exit_code": %s\n}\n' "$([[ "$PHANTOM_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
  return 0
}

log ""
bold "▸ css-tokens.sh — $TIMESTAMP"
log "  scopes:    ${SCOPES[*]}"
log "  allowlist: ${ALLOW_PREFIXES[*]}"
[[ -n "$TARGET_PATH" ]] && log "  ref path:  $TARGET_PATH"
log "  files:     $REF_FILE_COUNT scanned for references, $DEF_FILE_COUNT for definitions"
log ""

# ── No-op when the surface is absent ──────────────────────────────────────────
# Zero stylesheets is an empty population, not a clean sweep. Exit 0 — the surface is
# absent, not the tool — but say which, or the reader cannot tell the two apart.
if [[ "$REF_FILE_COUNT" -eq 0 ]]; then
  SURFACE_ABSENT=true
  SURFACE_NOTE="Surface absent: no *.css file exists under ${REF_ROOTS[*]}, so no var(--x) reference could be examined. This run is clean by definition and is not evidence that the token layer resolves."
  log "  no *.css files under: ${REF_ROOTS[*]}"
  log "  This project has not written any CSS yet."
  log ""
  write_report
  bold "✓ Nothing to check — no stylesheet exists, so no token was examined."
  log ""
  exit 0
fi

# Emit comment-stripped content of every *.css in a collected NUL-delimited list.
# The list guarantees *.css only (no reliance on the grep glob); perl strips /* … */.
emit_css() {
  xargs -0 -r perl -0777 -pe 's{/\*.*?\*/}{}gs' < "$1" 2>/dev/null || true
}

# DEFINED — `--name:` declaration LHS (locally-defined component vars count, so they never false-positive).
emit_css "$TMP_DEFCSS" \
  | grep -oE -- '[-][-][a-z0-9-]+[[:space:]]*:' 2>/dev/null \
  | sed -E 's/[[:space:]]*:$//' | sort -u > "$TMP_DEF" || true

# REFERENCED — `var(--name`
emit_css "$TMP_REFCSS" \
  | grep -oE -- 'var\([[:space:]]*[-][-][a-z0-9-]+' 2>/dev/null \
  | sed -E 's/var\([[:space:]]*//' | sort -u > "$TMP_REF" || true

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

if [[ "$PHANTOM_COUNT" -gt 0 ]]; then
  BODY=$(build_body)
  if ! $QUIET; then
    printf '\033[31m  ✗ %d phantom token%s — referenced via var() but defined nowhere\033[0m\n' \
      "$PHANTOM_COUNT" "$([[ "$PHANTOM_COUNT" -ne 1 ]] && echo s)"
    printf '%s\n' "$BODY" | sed 's/^/    /'
    printf '\n'
  fi
fi

write_report

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$PHANTOM_COUNT" -eq 0 ]]; then
  bold "✓ All $REF_COUNT var(--x) reference(s) across $REF_FILE_COUNT file(s) resolve to a defined token."
  log ""
  exit 0
else
  bold "✗ $PHANTOM_COUNT phantom token(s) — every var(--x) must resolve to a defined token."
  log "  Fix the reference (map to the real token) or define/allowlist the variable."
  log ""
  exit 1
fi
