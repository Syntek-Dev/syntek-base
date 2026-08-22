#!/usr/bin/env bash
#
# copy-emdash.sh — Ban em dashes (—, U+2014) in public marketing copy.
#
#                  An em dash in user-facing prose is a recognisable machine-authored
#                  tell. <%ORG_NAME%> marketing copy rewords instead — a comma, colon, full
#                  stop, parentheses, or a reworded clause — and NEVER substitutes a
#                  spaced en dash.
#
#                  Numeric/day en dashes (–, U+2013) in ranges (Mon–Fri, 9–5) are
#                  correct typography and are NOT flagged.
#
# Scopes scanned:
#   code/src/django/apps/marketing/pagedata   (*.py — page copy modules)
#   code/src/django/templates/marketing       (*.html — marketing templates)
#
# THE TEMPLATE SCOPE IS templates/marketing/, NOT apps/marketing/templates/. Django's
# APP_DIRS loader would find either, so both are plausible and only one is what this
# project builds: `code/src/scripts/development/new-django-view.sh` writes the page
# template there, and `code/src/django/templates/CONTEXT.md` and
# `code/docs/FRONTEND-CODING-PRINCIPLES.md` name that same directory. A fourth source is weaker than it looks and is quoted as
# what it is: `project-management/workflows/21-frontend-code/STEPS.md` puts every
# template under `code/src/django/templates/`, which corroborates the direction — not
# under the app — without naming the marketing subdirectory at all.
#
# The scope directory is written in plain prose everywhere it appears — the block above,
# SCOPES below, the usage text — and never in backticks. It is a path a project builds,
# and it holds no row in `how-to/src/PROJECT-PATHS.md`, so citing it would be a promise
# nobody has undertaken (`code/docs/FORWARD-VOICE.md`). The scope was
# `apps/marketing/templates` until 20/08/2026, which `collect_files` skipped in silence —
# so this leg reported clean having read nothing, and would have gone on doing so in a
# fully built project. Rule: `code/docs/GATE-REPORTING.md`.
#
# NO-OP WHEN ABSENT, AND IT SAYS SO. Neither scope exists at template baseline, so the
# script prints the roots it looked under and the file count it found, then exits 0 —
# the second row of GATE-REPORTING.md Section 2, an absent surface rather than an absent
# tool. A zero that names its population is legible as "nothing of this kind here"; a
# bare success line is not. A --output run still writes a clean report on that path, so
# a consumer told to collect the report file always finds it.
#
# Usage: copy-emdash.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                       [--path PATH] [--help]
#
# Exit codes:  0 = no em dashes (or surface absent)   1 = em dash(es) found
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

EMDASH='—'   # U+2014

# Each entry: "<dir>:<glob>"
SCOPES=(
  "code/src/django/apps/marketing/pagedata:*.py"
  "code/src/django/templates/marketing:*.html"
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
                                   apps/marketing/pagedata/ and templates/marketing/
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

Exit codes:  0 = clean, or the copy surface is absent
             1 = em dash(es) found
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
  OUTPUT_FILE="$REPORTS_DIR/copy-emdash-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_FILES=$(mktemp)
TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_FILES" "$TMP_HITS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# Report state. Initialised here because the absent-surface exit writes a report before
# the scan has had a chance to set any of them.
SURFACE_ABSENT=false
SURFACE_NOTE=""

# --path is validated HERE, at top level, and not inside a collector in a process
# substitution — `die`'s `exit 2` would kill only the subshell, the error would go to
# stderr, and the script would carry on to print its success line at exit 0 over a scope
# it never honoured. Rule: code/docs/GATE-REPORTING.md.
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"

# ── File collection ───────────────────────────────────────────────────────────
# ROOTS records what was looked under, present or not, so the run can name its
# population rather than merely its findings.
declare -a ROOTS=()
: > "$TMP_FILES"
if [[ -n "$TARGET_PATH" ]]; then
  ROOTS=("$TARGET_PATH")
  if [[ -d "$TARGET_PATH" ]]; then
    find "$TARGET_PATH" -type f -print0 >> "$TMP_FILES" || true
  else
    printf '%s\0' "$TARGET_PATH" >> "$TMP_FILES"
  fi
else
  for entry in "${SCOPES[@]}"; do
    dir="${entry%%:*}"; glob="${entry##*:}"
    ROOTS+=("$dir")
    [[ -d "$dir" ]] || continue
    find "$dir" -type f -name "$glob" -print0 >> "$TMP_FILES" || true
  done
fi

FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

# ── Report output ─────────────────────────────────────────────────────────────
# Defined above the absent-surface exit, because a CI job told to collect
# reports/copy-emdash-report.<FORMAT> must always find the file.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if $SURFACE_ABSENT; then
    status="✓ surface absent, nothing to check"
  elif [[ "$HIT_COUNT" -eq 0 ]]; then
    status="✓ no em dashes"
  else
    status="✗ $HIT_COUNT em dash(es)"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'copy-emdash audit — %s\n' "$TIMESTAMP"
        printf 'files=%s em_dashes=%s\n' "$FILE_COUNT" "$HIT_COUNT"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        printf '\n%s\n' "${BODY:-No em dashes.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Marketing-Copy Em-Dash Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files scanned** | %s |\n' "$FILE_COUNT"
        printf '| **Em dashes** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_No em dashes in marketing copy._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "copy-emdash",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "files": %s,\n' "$FILE_COUNT"
        printf '  "em_dashes": %s,\n' "$HIT_COUNT"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
  return 0
}

# ── No-op when the copy surface is absent ─────────────────────────────────────
# An absent surface is a legitimately empty population, not an unexamined one, so exit 0
# is the honest verdict — provided the run says which roots were empty. See the header.
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SURFACE_ABSENT=true
  HIT_COUNT=0
  BODY=""
  SURFACE_NOTE="Surface absent: no marketing copy module or template was found under ${ROOTS[*]}, so no em dash could be found and this run is clean by definition."
  log ""
  bold "▸ copy-emdash.sh — $TIMESTAMP"
  log "  no matching files under: ${ROOTS[*]}"
  log "  This project has not written any user-facing copy yet."
  log ""
  write_report
  bold "✓ Nothing to check."
  log ""
  exit 0
fi

log ""
bold "▸ copy-emdash.sh — $TIMESTAMP"
log "  scopes: ${ROOTS[*]}"
log "  files:  $FILE_COUNT"
log ""

: > "$TMP_HITS"
while IFS= read -r -d '' file; do
  grep -n -- "$EMDASH" "$file" 2>/dev/null | sed "s#^#${file}:#" >> "$TMP_HITS" || true
done < "$TMP_FILES"

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d em dash%s in marketing copy — reword (comma/colon/full stop), never a spaced en dash\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo es)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

write_report

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ No em dashes in $FILE_COUNT file(s) of marketing copy."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT em dash(es) in marketing copy — reword; never substitute a spaced en dash."
  log ""
  exit 1
fi
