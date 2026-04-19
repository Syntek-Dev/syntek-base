#!/usr/bin/env bash
#
# check.sh — Type-check the codebase using basedpyright (Python) and
#            tsc --noEmit (TypeScript / React). Dry-run only.
#
# Usage: check.sh [--fix] [--file-type TYPE] [--output FORMAT]
#                 [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Note: type errors require manual fixes. --fix prints guidance but makes
#       no automated changes (no type checker supports safe auto-fix).
#
# Exit codes:  0 = clean   1 = type errors found   2 = script error
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
die()  { printf 'check.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
check.sh — Type-check using basedpyright (Python) and tsc (TypeScript / React)

Usage:
  check.sh                         Dry-run all supported file types
  check.sh --file-type python      Restrict to Python only
  check.sh --output html           Write an HTML report

Options:
  --fix                Print fix guidance (no automated type fixes are available)
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | typescript | javascript | react
                         (markdown and css are not type-checked)
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/reports/check-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict to a specific file or directory
  --help               Show this help

Notes:
  • basedpyright uses project config at code/src/backend/pyrightconfig.json.
  • tsc uses tsconfig.json at code/src/frontend/tsconfig.json (web) and
      code/src/mobile/tsconfig.json (mobile) respectively.
  • --fix is accepted for API consistency but no type checker auto-corrects
    type errors; it prints guidance on how to fix common classes of errors.

Exit codes:  0 = clean   1 = type errors found   2 = script error
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
    python|typescript|javascript|react) ;;
    markdown|css) die "--file-type '$ft' is not type-checked. Remove it or use lint.sh instead." ;;
    *) die "Invalid --file-type '$ft'. Choose: python typescript javascript react" ;;
  esac
done
[[ ${#FILE_TYPES[@]} -eq 0 ]] && FILE_TYPES=(python typescript)

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/check-report.$OUTPUT_FORMAT"
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"
check_any_container

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ check.sh — $TIMESTAMP"
log "  mode: type-check (read-only)"
log "  types: ${FILE_TYPES[*]}"
if $FIX; then
  log ""
  log "  ℹ  --fix is set. Type checkers do not auto-fix errors — see guidance below."
fi
log ""

# ── File-type selector helpers ────────────────────────────────────────────────
wants() {
  local target="$1"
  for ft in "${FILE_TYPES[@]}"; do [[ "$ft" == "$target" ]] && return 0; done
  return 1
}

wants_ts_js() {
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in typescript|javascript|react) return 0 ;; esac
  done
  return 1
}

# ── Python — basedpyright ─────────────────────────────────────────────────────
if wants python; then
  if container_running backend; then
    bold "── Python (basedpyright) ──────────────────────────────────────────────────"
    py_path="${TARGET_PATH:-code/src/backend/}"
    run_in backend basedpyright "$py_path"
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  backend container not running — skipping Python type-check"
    log ""
  fi
fi

# ── TypeScript / JavaScript / React — tsc (frontend) ─────────────────────────
if wants_ts_js; then
  if container_running frontend; then
    bold "── TypeScript / React — frontend (tsc --noEmit) ───────────────────────────"
    declare -a tsc_args=(pnpm tsc --noEmit)
    if [[ -n "$TARGET_PATH" ]]; then
      tsc_args+=(--project "$TARGET_PATH")
    fi
    run_in frontend "${tsc_args[@]}"
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  frontend container not running — skipping frontend TypeScript type-check"
    log ""
  fi
fi

# ── TypeScript / React Native — tsc (mobile) ──────────────────────────────────
if wants_ts_js; then
  if container_running mobile; then
    bold "── TypeScript / React Native — mobile (tsc --noEmit) ─────────────────────"
    declare -a mobile_tsc_args=(pnpm tsc --noEmit)
    if [[ -n "$TARGET_PATH" ]]; then
      mobile_tsc_args+=(--project "$TARGET_PATH")
    fi
    run_in mobile "${mobile_tsc_args[@]}"
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  mobile container not running — skipping mobile TypeScript type-check"
    log ""
  fi
fi

# ── --fix advisory ────────────────────────────────────────────────────────────
if $FIX && [[ $OVERALL_EXIT -ne 0 ]]; then
  {
    printf '\n── Fix guidance ────────────────────────────────────────────────────────────\n'
    printf 'Type errors cannot be fixed automatically. Common approaches:\n\n'
    printf '  Python:\n'
    printf '    • Add missing type annotations identified by basedpyright\n'
    printf '    • Use cast() or TYPE_IGNORE with a comment for third-party stubs\n'
    printf '    • Run: docker compose exec backend basedpyright --verifytypes <module>\n\n'
    printf '  TypeScript:\n'
    printf '    • Address each tsc error in your editor (VS Code shows them inline)\n'
    printf '    • For intentional any: use `// eslint-disable-next-line` with justification\n'
    printf '    • Run: docker compose exec frontend pnpm tsc --noEmit --pretty\n\n'
  } | tee -a "$TMPFILE" | $QUIET && cat >> "$TMPFILE" || cat
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
        printf '# Type-Check Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Types** | %s |\n' "${FILE_TYPES[*]}"
        printf '| **Status** | %s |\n\n' \
          "$([[ $OVERALL_EXIT -eq 0 ]] && echo '✓ Clean' || echo '✗ Type errors found')"
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
        printf '  "script": "check",\n'
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
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
      {
        cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Type-Check Report — project-name</title>
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
  <h1>Type-Check Report — project-name</h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>File types</th><td>${FILE_TYPES[*]}</td></tr>
    <tr><th>Status</th><td class="$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)">
      $([[ $OVERALL_EXIT -eq 0 ]] && echo '&#10003; Clean' || echo '&#10007; Type errors found')
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
  bold "✓ No type errors found."
else
  bold "✗ Type errors found."
  log "  Fix manually — type checkers do not support automatic correction."
  log "  Run with --fix for per-tool guidance."
fi
log ""

exit $OVERALL_EXIT
