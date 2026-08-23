#!/usr/bin/env bash
#
# check.sh — Type-check the codebase: basedpyright (Python), tsc (the mobile surface's
#            TypeScript) and cargo check (the Rust workspace). Dry-run only.
#
# THE WEB SURFACE HAS NO TYPE-CHECK, AND THAT IS NOT AN OMISSION
# Its pages are server-rendered by Django; its only JavaScript is the Alpine and
# progressive-enhancement scripts, which ESLint lints and nothing type-checks. So
# `--file-type javascript` is rejected here rather than silently accepted — the token
# is real, it just has no leg on this script. TypeScript lives on the MOBILE surface
# alone. See code/src/scripts/syntax/CONTEXT.md.
#
# This script AGGREGATES; it never reimplements. `typescript` and `rust` delegate to
# scripts/mobile/typecheck.sh and scripts/rust/build.sh --check, which remain what CI
# invokes.
#
# Usage: check.sh [--fix] [--file-type TYPE] [--output FORMAT]
#                 [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Note: type errors require manual fixes. --fix prints guidance but makes
#       no automated changes (no type checker supports safe auto-fix).
#
# Exit codes:  0 = clean   1 = type errors found   2 = script error
#              3 = every leg that ran was clean, and at least one leg COULD NOT RUN
#
# `3` is non-zero deliberately, so a caller treating any non-zero as failure fails closed.
# Rule: code/docs/GATE-REPORTING.md — "could not look" is never reported as "looked, and it
# was clean".
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/reports"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# ── Defaults ──────────────────────────────────────────────────────────────────
FIX=false
declare -a FILE_TYPES=()
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
OVERALL_EXIT=0
# Legs that could not run. A skipped leg produced NO result, so it must never reach the
# same verdict as a leg that ran and found nothing (code/docs/GATE-REPORTING.md).
declare -a UNRUN=()
# Types the caller did not get, and why. An absent SURFACE is a legitimately empty
# population, so leaving it out is correct and the run stays clean — but a reader cannot tell
# "there is no mobile app here" from "the mobile app was checked" unless the script says which.
# Rule: code/docs/GATE-REPORTING.md.
declare -a SURFACES_ABSENT=()

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'check.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
check.sh — Type-check using basedpyright (Python), tsc (mobile) and cargo check (Rust)

Usage:
  check.sh                         Dry-run all supported file types
  check.sh --file-type python      Restrict to Python only
  check.sh --output html           Write an HTML report

Options:
  --fix                Print fix guidance (no automated type fixes are available)
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | typescript | rust
                         (markdown, css and javascript are not type-checked)
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/reports/check-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict to a specific file or directory
  --help               Show this help

Notes:
  • basedpyright uses project config at code/src/django/pyrightconfig.json.
  • typescript is the MOBILE surface; the web surface has no TypeScript and its
    JavaScript is linted, not type-checked — use lint.sh --file-type javascript.
  • typescript and rust delegate to scripts/mobile/typecheck.sh and
    scripts/rust/build.sh --check, and join a bare run only when their surface is
    present. Naming one on a project that lacks it is an error, not a skip.
  • --path cannot scope typescript or rust — those owners check their workspace whole.
  • --fix is accepted for API consistency but no type checker auto-corrects
    type errors; it prints guidance on how to fix common classes of errors.

Exit codes:  0 = clean   1 = type errors found   2 = script error
             3 = clean, but a leg could not run (see the summary for which)
EOF
}

require_arg() {
  [[ $# -gt 1 ]] || die "$1 requires a value"
}

# Defined here rather than beside the tool sections, because the surface guards in
# argument validation below need it.
wants() {
  local target="$1"
  for ft in "${FILE_TYPES[@]}"; do [[ "$ft" == "$target" ]] && return 0; done
  return 1
}

container_running() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} ps --status running 2>/dev/null | grep -q "^[^ ]*$1"
}

check_any_container() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} ps --status running 2>/dev/null | grep -q "django" \
    || die "No containers are running. Start with: bash code/src/scripts/development/server.sh up"
}

LAST_EXIT=0
run_in() {
  local service="$1"; shift
  set +e
  if $QUIET; then
    docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} exec -T "$service" "$@" \
      >> "$TMPFILE" 2>&1
    LAST_EXIT=$?
  else
    docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} exec -T "$service" "$@" \
      2>&1 | tee -a "$TMPFILE"
    LAST_EXIT=${PIPESTATUS[0]}
  fi
  set -e
}

# Host counterpart of run_in, for the delegated surface owners. Honours --quiet, which the
# previous `| tee -a "$TMPFILE"` form did not: a --quiet run leaked the mobile and Rust output
# to the terminal while promising to suppress it.
run_on_host() {
  set +e
  if $QUIET; then
    "$@" >> "$TMPFILE" 2>&1
    LAST_EXIT=$?
  else
    "$@" 2>&1 | tee -a "$TMPFILE"
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
# Whether the CALLER named the types. An auto-added type is one this script chose, and
# a surface this script chose is one it already checked was there.
EXPLICIT_TYPES=false
[[ ${#FILE_TYPES[@]} -gt 0 ]] && EXPLICIT_TYPES=true

for ft in "${FILE_TYPES[@]+"${FILE_TYPES[@]}"}"; do
  case "$ft" in
    python|typescript|rust) ;;
    javascript) die "--file-type 'javascript' is not type-checked. The web surface has no TypeScript, and its Alpine and enhancement scripts are linted instead: use lint.sh --file-type javascript. For the mobile surface, use --file-type typescript." ;;
    markdown|css) die "--file-type '$ft' is not type-checked. Remove it or use lint.sh instead." ;;
    *) die "Invalid --file-type '$ft'. Choose: python typescript rust" ;;
  esac
done

MOBILE_DIR="$PROJECT_ROOT/code/src/mobile"
RUST_DIR="$PROJECT_ROOT/code/src/rust"

if $EXPLICIT_TYPES; then
  # An explicitly requested surface that is not here is a BAD INVOCATION, not a clean
  # result. This replaces a branch that used to print a warning and exit 0.
  wants typescript && [[ ! -d "$MOBILE_DIR" ]] && \
    die "--file-type typescript needs code/src/mobile/ — this project was generated without the mobile surface."
  wants rust && [[ ! -d "$RUST_DIR" ]] && \
    die "--file-type rust needs code/src/rust/ — this project was generated without the Rust surface."
else
  # "Check everything" stays honest without templated file contents: a web-only project
  # has neither directory, so its default is Python alone, exactly as before.
  FILE_TYPES=(python)
  if [[ -d "$MOBILE_DIR" ]]; then FILE_TYPES+=(typescript); else SURFACES_ABSENT+=("typescript — no code/src/mobile/"); fi
  if [[ -d "$RUST_DIR" ]]; then FILE_TYPES+=(rust); else SURFACES_ABSENT+=("rust — no code/src/rust/"); fi
fi

# --path asks for a subtree; the delegated owners check their workspace as a unit and
# have no --path of their own. Dropping them is how the narrower request is honoured,
# and naming what was dropped is how that stays visible.
if [[ -n "$TARGET_PATH" ]]; then
  declare -a scoped=() dropped=()
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in
      typescript|rust)
        $EXPLICIT_TYPES && die "--path cannot scope --file-type $ft: its owner checks the workspace whole. Drop --path, or drop --file-type $ft."
        dropped+=("$ft") ;;
      *) scoped+=("$ft") ;;
    esac
  done
  FILE_TYPES=("${scoped[@]}")
  [[ ${#dropped[@]} -gt 0 ]] && DROPPED_NOTE="${dropped[*]}"
fi

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/check-report.$OUTPUT_FORMAT"
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"
# Only the Python step needs the stack: basedpyright runs in the django container, while
# the mobile type-check runs on the host, so a mobile-only run works with the stack down.
if [[ " ${FILE_TYPES[*]} " == *" python "* ]]; then
  check_any_container
fi

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ check.sh — $TIMESTAMP"
log "  mode: type-check (read-only)"
log "  types: ${FILE_TYPES[*]}"
[[ -n "${DROPPED_NOTE:-}" ]] && log "  dropped by --path: ${DROPPED_NOTE} (their owners check the whole workspace)"
if [[ ${#SURFACES_ABSENT[@]} -gt 0 ]]; then
  log "  not present in this project: $(IFS='; '; echo "${SURFACES_ABSENT[*]}")"
fi
if $FIX; then
  log ""
  log "  ℹ  --fix is set. Type checkers do not auto-fix errors — see guidance below."
fi
log ""

# ── Python — basedpyright ─────────────────────────────────────────────────────
if wants python; then
  if container_running django; then
    bold "── Python (basedpyright) ──────────────────────────────────────────────────"
    if [[ -n "$TARGET_PATH" ]]; then
      run_in django basedpyright "$TARGET_PATH"
    else
      # Run from backend root so pyrightconfig.json is discovered automatically
      # and its exclude patterns (e.g. **/tests/**) are honoured. Passing an
      # explicit path on the command line bypasses config-level excludes.
      run_in django bash -c "cd /workspace/code/src/django && basedpyright"
    fi
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  django container not running — Python type-check COULD NOT RUN"
    UNRUN+=("Python/basedpyright (django container not running)")
    log ""
  fi
fi

# ── TypeScript — the mobile surface ───────────────────────────────────────────
# Delegated, not reimplemented: the mobile app owns its own tsconfig and TypeScript
# version, so this aggregate only decides WHETHER to run it. Runs on the host, like
# Prettier and markdownlint — no container mounts the mobile tree.
#
# There is no "surface absent" branch here any more. It used to print a warning and
# exit 0, which files "could not look" as "looked, and it was clean". The type is now
# either auto-added because the directory exists, or explicitly named and validated
# against that directory above — so by this line the surface is present.
if wants typescript; then
  bold "── TypeScript (tsc — mobile surface) ──────────────────────────────────────"
  run_on_host bash "$PROJECT_ROOT/code/src/scripts/mobile/typecheck.sh"
  [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
  log ""
fi

# ── Rust — cargo check over the workspace ─────────────────────────────────────
# Delegated to the Rust surface's own owner for the same reason, and `build.sh --check`
# is the type-check half of it: cargo check --workspace --all-targets, no artefact.
# Reached only when code/src/rust/ is present, on the same argument as above.
if wants rust; then
  bold "── Rust (cargo check) ─────────────────────────────────────────────────────"
  run_on_host bash "$PROJECT_ROOT/code/src/scripts/rust/build.sh" --check
  # 1 and 2 are different results here, and cargo spends one exit code on both. A type error
  # in code/src/rust/ IS this leg's finding — `cargo check` is the type gate, so rustc
  # diagnosing our code is the answer that was asked for. A workspace that never reached our
  # crates at all — an absent system library, a build script that panicked — produced no
  # type-check result, and the owner says so with 2. Its `build.sh error:` line names the
  # cause and is the only thing in this run that knows it, so quote it rather than re-derive.
  if [[ $LAST_EXIT -eq 2 ]]; then
    rs_why=$(grep -a 'build.sh error: ' "$TMPFILE" | tail -n 1 | sed 's/.*build\.sh error: //')
    log "  ⚠  ${rs_why:-the Rust owner could not run} — Rust type-check COULD NOT RUN"
    UNRUN+=("Rust/cargo check (${rs_why:-see the Rust section above})")
  elif [[ $LAST_EXIT -ne 0 ]]; then
    OVERALL_EXIT=1
  fi
  log ""
fi

# ── --fix advisory ────────────────────────────────────────────────────────────
if $FIX && [[ $OVERALL_EXIT -ne 0 ]]; then
  {
    printf '\n── Fix guidance ────────────────────────────────────────────────────────────\n'
    printf 'Type errors cannot be fixed automatically. Common approaches:\n\n'
    printf '  Python:\n'
    printf '    • Add missing type annotations identified by basedpyright\n'
    printf '    • Use cast() or TYPE_IGNORE with a comment for third-party stubs\n'
    printf '    • Run: docker compose exec django basedpyright --verifytypes <module>\n\n'
  } | tee -a "$TMPFILE" | $QUIET && cat >> "$TMPFILE" || cat
fi

# ── Verdict ───────────────────────────────────────────────────────────────────
# Decided BEFORE the report is written, so the persisted artefact carries the verdict the
# terminal shows. A leg that could not run produced no result and may not reach the clean
# verdict. Rule: code/docs/GATE-REPORTING.md.
if [[ ${#UNRUN[@]} -gt 0 && $OVERALL_EXIT -eq 0 ]]; then
  OVERALL_EXIT=3
fi
UNRUN_TEXT=""
if [[ ${#UNRUN[@]} -gt 0 ]]; then
  UNRUN_TEXT=$(printf '%s; ' "${UNRUN[@]}")
  UNRUN_TEXT="${UNRUN_TEXT%; }"
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
        printf '  "unrun": [%s],\n' \
          "$(if [[ ${#UNRUN[@]} -gt 0 ]]; then printf '"%s",' "${UNRUN[@]}" | sed 's/,$//'; fi)"
        printf '  "dropped_by_path": "%s",\n' "${DROPPED_NOTE:-}"
        printf '  "surfaces_absent": "%s",\n' "$(IFS='; '; echo "${SURFACES_ABSENT[*]-}")"
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
  <title>Type-Check Report — <%PROJECT_SLUG%></title>
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
  <h1>Type-Check Report — <%PROJECT_SLUG%></h1>
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
elif [[ $OVERALL_EXIT -eq 3 ]]; then
  bold "⚠ INCOMPLETE — every leg that ran was clean, and ${#UNRUN[@]} could not run."
  for leg in "${UNRUN[@]}"; do log "    · $leg"; done
  log "  This is not a clean result."
else
  bold "✗ Type errors found."
  log "  Fix manually — type checkers do not support automatic correction."
  log "  Run with --fix for per-tool guidance."
fi
log ""

exit $OVERALL_EXIT
