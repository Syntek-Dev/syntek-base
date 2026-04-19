#!/usr/bin/env bash
#
# format.sh — Check or apply code formatting using ruff format (Python) and
#             Prettier (TypeScript, JavaScript, React, CSS, Markdown).
#             Dry-run by default — no files are modified without --fix.
#
# Usage: format.sh [--fix] [--file-type TYPE] [--output FORMAT]
#                  [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = all files formatted   1 = formatting needed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/reports"

# ── Defaults ──────────────────────────────────────────────────────────────────
FIX=false
declare -a FILE_TYPES=()
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
OVERALL_EXIT=0

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'format.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
format.sh — Format using ruff format (Python) and Prettier (TS/JS/React/CSS/Markdown)

Usage:
  format.sh                        Dry-run check across all file types
  format.sh --fix                  Reformat all files
  format.sh --file-type python     Restrict to Python only
  format.sh --fix --file-type css  Reformat CSS only

Options:
  --fix                Apply formatting (writes files). Default is dry-run check.
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | typescript | javascript | react | css | markdown
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/reports/format-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict to a specific file or directory
  --help               Show this help

Notes:
  • Dry-run exit code 1 means files need formatting — run with --fix to correct.
  • Prettier handles TypeScript, JavaScript, React (TSX/JSX), CSS, and Markdown.
  • ruff format handles Python (PEP 8 compatible, opinionated like Black).
  • --output writes a report regardless of whether --fix was used.

Exit codes:  0 = all formatted / no changes   1 = formatting needed or applied   2 = script error
EOF
}

require_arg() {
  [[ $# -gt 1 ]] || die "$1 requires a value"
}

container_running() {
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -q "^[^ ]*$1"
}

check_any_container() {
  docker compose -f "$COMPOSE_FILE" ps --status running 2>/dev/null | grep -qE '(backend|frontend|mobile)' \
    || die "No containers are running. Start with: docker compose -f $COMPOSE_FILE up -d"
}

LAST_EXIT=0
run_in() {
  local service="$1"; shift
  set +e
  if $QUIET; then
    docker compose -f "$COMPOSE_FILE" exec -T "$service" "$@" \
      >> "$TMPFILE" 2>&1
    LAST_EXIT=$?
  else
    docker compose -f "$COMPOSE_FILE" exec -T "$service" "$@" \
      2>&1 | tee -a "$TMPFILE"
    LAST_EXIT=${PIPESTATUS[0]}
  fi
  set -e
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix)          FIX=true; shift ;;
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
    python|typescript|javascript|react|css|markdown) ;;
    *) die "Invalid --file-type '$ft'. Choose: python typescript javascript react css markdown" ;;
  esac
done
[[ ${#FILE_TYPES[@]} -eq 0 ]] && FILE_TYPES=(python typescript javascript react css markdown)

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/format-report.$OUTPUT_FORMAT"
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"
check_any_container

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
MODE=$($FIX && echo "fix (writes files)" || echo "dry-run (check only)")

log ""
bold "▸ format.sh — $TIMESTAMP"
log "  mode: $MODE"
log "  types: ${FILE_TYPES[*]}"
log ""

# ── File-type selector helpers ────────────────────────────────────────────────
wants() {
  local target="$1"
  for ft in "${FILE_TYPES[@]}"; do [[ "$ft" == "$target" ]] && return 0; done
  return 1
}

# Prettier handles ts, js, react (tsx/jsx), css, markdown together
wants_prettier() {
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in typescript|javascript|react|css|markdown) return 0 ;; esac
  done
  return 1
}

# Build the Prettier glob pattern based on requested file types
prettier_pattern() {
  local -a exts=()
  wants typescript && exts+=(ts tsx)
  wants javascript && exts+=(js jsx)
  wants react      && { wants typescript || exts+=(tsx); wants javascript || exts+=(jsx); }
  wants css        && exts+=(css)
  wants markdown   && exts+=(md)

  # Deduplicate
  local deduped
  deduped=$(printf '%s\n' "${exts[@]}" | sort -u | tr '\n' ',' | sed 's/,$//')

  if [[ -n "$TARGET_PATH" ]]; then
    printf '%s' "$TARGET_PATH"
  else
    printf '"**/*.{%s}"' "$deduped"
  fi
}

# ── Python — ruff format ──────────────────────────────────────────────────────
if wants python; then
  if container_running backend; then
    bold "── Python (ruff format) ───────────────────────────────────────────────────"
    py_path="${TARGET_PATH:-code/src/backend/}"
    if $FIX; then
      run_in backend ruff format "$py_path"
    else
      run_in backend ruff format --check "$py_path"
    fi
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  backend container not running — skipping Python format"
    log ""
  fi
fi

# ── TypeScript / JavaScript / React / CSS / Markdown — Prettier (frontend) ────
if wants_prettier; then
  if container_running frontend; then
    bold "── TS / JS / React / React Native / CSS / Markdown (Prettier) ────────────"
    pattern="$(prettier_pattern)"
    if $FIX; then
      # shellcheck disable=SC2086
      run_in frontend pnpm prettier --write $pattern
    else
      # shellcheck disable=SC2086
      run_in frontend pnpm prettier --check $pattern
    fi
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  frontend container not running — skipping Prettier format"
    log ""
  fi
fi

# ── Dry-run summary hint ──────────────────────────────────────────────────────
if ! $FIX && [[ $OVERALL_EXIT -ne 0 ]]; then
  log "  Files above need formatting. Run with --fix to reformat them."
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
        printf '# Format Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Mode** | %s |\n' "$MODE"
        printf '| **Types** | %s |\n' "${FILE_TYPES[*]}"
        printf '| **Status** | %s |\n\n' \
          "$([[ $OVERALL_EXIT -eq 0 ]] \
            && echo '✓ All files formatted' \
            || { $FIX && echo '⚡ Files reformatted' || echo '✗ Formatting needed'; })"
        if [[ -n "$RAW" ]]; then
          printf '```text\n%s\n```\n' "$RAW"
        else
          printf '_No output captured._\n'
        fi
      } > "$OUTPUT_FILE"
      ;;

    json)
      {
        printf '{\n'
        printf '  "script": "format",\n'
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "mode": "%s",\n' "$MODE"
        printf '  "file_types": [%s],\n' \
          "$(printf '"%s",' "${FILE_TYPES[@]}" | sed 's/,$//')"
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
      status_class=$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)
      status_text=$([[ $OVERALL_EXIT -eq 0 ]] \
        && echo '&#10003; All files formatted' \
        || { $FIX && echo '&#9889; Files reformatted' || echo '&#10007; Formatting needed'; })
      {
        cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Format Report — project-name</title>
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
  <h1>Format Report — project-name</h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>Mode</th><td>$MODE</td></tr>
    <tr><th>File types</th><td>${FILE_TYPES[*]}</td></tr>
    <tr><th>Status</th><td class="$status_class">$status_text</td></tr>
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
  bold "✓ All files are correctly formatted."
elif $FIX; then
  bold "⚡ Formatting applied."
else
  bold "✗ Formatting issues found."
  log "  Run with --fix to reformat all files."
fi
log ""

exit $OVERALL_EXIT
