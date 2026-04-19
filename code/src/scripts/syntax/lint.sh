#!/usr/bin/env bash
#
# lint.sh — Lint the codebase using ruff (Python), ESLint (TS/JS/React),
#           and markdownlint-cli2 (Markdown). Dry-run by default.
#
# Usage: lint.sh [--fix] [--unsafe-fix] [--file-type TYPE] [--output FORMAT]
#                [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = clean   1 = lint issues found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/reports"

# ── Defaults ──────────────────────────────────────────────────────────────────
FIX=false
UNSAFE_FIX=false
declare -a FILE_TYPES=()
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
OVERALL_EXIT=0

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'lint.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
lint.sh — Lint using ruff (Python), ESLint (TS/JS/React), markdownlint (Markdown)

Usage:
  lint.sh                          Dry-run all supported file types
  lint.sh --fix                    Apply safe fixes
  lint.sh --unsafe-fix             Apply safe + unsafe fixes (ruff only)
  lint.sh --file-type python       Restrict to one file type
  lint.sh --output json            Write a report file

Options:
  --fix                Apply safe automatic fixes
  --unsafe-fix         Apply safe and unsafe automatic fixes (ruff only)
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | typescript | javascript | react | markdown | css
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/reports/lint-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict to a specific file or directory
  --help               Show this help

Notes:
  • Runs inside Docker containers via docker compose exec.
  • CSS has no lint tool configured — use format.sh for CSS formatting.
  • HTML output uses ESLint's native HTML formatter for JS/TS sections.
  • JSON output captures each tool's text output in a structured envelope.

Exit codes:  0 = clean   1 = lint issues found   2 = script error
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

# Run a command in a service container, appending stdout+stderr to TMPFILE.
# Sets LAST_EXIT to the command's exit code.
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
    --unsafe-fix)   UNSAFE_FIX=true; FIX=true; shift ;;
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
    python|typescript|javascript|react|markdown|css) ;;
    *) die "Invalid --file-type '$ft'. Choose: python typescript javascript react markdown css" ;;
  esac
done
[[ ${#FILE_TYPES[@]} -eq 0 ]] && FILE_TYPES=(python typescript markdown)

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/lint-report.$OUTPUT_FORMAT"
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"
check_any_container

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
MODE=$($FIX && { $UNSAFE_FIX && echo "unsafe-fix" || echo "fix"; } || echo "dry-run")

log ""
bold "▸ lint.sh — $TIMESTAMP"
log "  mode: $MODE"
log "  types: ${FILE_TYPES[*]}"
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

# ── Python — ruff check ───────────────────────────────────────────────────────
if wants python; then
  if container_running backend; then
    bold "── Python (ruff check) ────────────────────────────────────────────────────"
    py_path="${TARGET_PATH:-code/src/backend/}"
    declare -a ruff_args=(ruff check "$py_path")
    $FIX && ruff_args+=(--fix)
    $UNSAFE_FIX && ruff_args+=(--unsafe-fixes)
    run_in backend "${ruff_args[@]}"
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  backend container not running — skipping Python lint"
    log ""
  fi
fi

# ── TypeScript / JavaScript / React / React Native — ESLint (root config) ────
if wants_ts_js; then
  if container_running frontend; then
    bold "── TypeScript / JS / React / React Native (ESLint — root config) ──────────"
    # Root eslint.config.mjs scopes React Native rules to code/src/mobile/** automatically.
    if [[ -n "$TARGET_PATH" ]]; then
      declare -a eslint_targets=("$TARGET_PATH")
    else
      declare -a eslint_targets=("code/src/frontend/src/" "code/src/mobile/src/")
    fi
    declare -a eslint_args=(pnpm eslint "${eslint_targets[@]}")
    $FIX && eslint_args+=(--fix)
    [[ "$OUTPUT_FORMAT" == "html" ]] && eslint_args+=(--format html)
    run_in frontend "${eslint_args[@]}"
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  frontend container not running — skipping TS/JS/React Native lint"
    log ""
  fi
fi

# ── Markdown — markdownlint-cli2 ──────────────────────────────────────────────
if wants markdown; then
  if container_running frontend; then
    bold "── Markdown (markdownlint-cli2) ───────────────────────────────────────────"
    md_pattern="${TARGET_PATH:-**/*.md}"
    declare -a md_args=(pnpm markdownlint-cli2 "$md_pattern")
    $FIX && md_args+=(--fix)
    run_in frontend "${md_args[@]}"
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  frontend container not running — skipping Markdown lint"
    log ""
  fi
fi

# ── CSS — no linter configured ────────────────────────────────────────────────
if wants css; then
  log "  ℹ  CSS linting is not configured. Use format.sh for CSS formatting."
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
        printf '# Lint Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Mode** | %s |\n' "$MODE"
        printf '| **Types** | %s |\n' "${FILE_TYPES[*]}"
        printf '| **Status** | %s |\n\n' \
          "$([[ $OVERALL_EXIT -eq 0 ]] && echo '✓ Clean' || echo '✗ Issues found')"
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
        printf '  "script": "lint",\n'
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
      {
        cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Lint Report — project-name</title>
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
  <h1>Lint Report — project-name</h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>Mode</th><td>$MODE</td></tr>
    <tr><th>File types</th><td>${FILE_TYPES[*]}</td></tr>
    <tr><th>Status</th><td class="$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)">
      $([[ $OVERALL_EXIT -eq 0 ]] && echo '&#10003; Clean' || echo '&#10007; Issues found')
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
  bold "✓ No lint issues found."
else
  bold "✗ Lint issues found."
  $FIX || log "  Run with --fix to apply safe automatic fixes."
fi
log ""

exit $OVERALL_EXIT
