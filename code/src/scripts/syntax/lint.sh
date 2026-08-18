#!/usr/bin/env bash
#
# lint.sh — Lint the codebase: ruff (Python), markdownlint-cli2 (Markdown), ESLint
#           (the web surface's JavaScript), and the mobile and Rust owners for their
#           own surfaces. Dry-run by default.
#
# ONE TOKEN PER LANGUAGE, AND THE TOKEN NAMES THE LANGUAGE
#   javascript  the WEB surface — Alpine and the progressive-enhancement scripts under
#               code/src/django/static/js/, linted by the ROOT eslint config
#   typescript  the MOBILE surface — code/src/mobile/, which carries its own eslint,
#               typescript-eslint and tsconfig. The root config ignores that tree, so
#               `javascript` genuinely cannot reach it
#   rust        the Cargo workspace, including the desktop crate
#
# This script AGGREGATES; it never reimplements. `typescript` and `rust` delegate to
# scripts/mobile/lint.sh and scripts/rust/lint.sh, which remain what CI and lefthook
# invoke. See code/src/scripts/syntax/CONTEXT.md.
#
# Usage: lint.sh [--fix] [--unsafe-fix] [--file-type TYPE] [--output FORMAT]
#                [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = clean   1 = lint issues found   2 = script error
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
UNSAFE_FIX=false
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
die()  { printf 'lint.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
lint.sh — Lint using ruff (Python) and markdownlint (Markdown)

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
                         python | markdown | javascript | typescript | rust
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/reports/lint-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict to a specific file or directory
  --help               Show this help

Notes:
  • ruff runs in the django container; every other tool runs on the host.
  • There is no `css` type here — no CSS linter is configured. format.sh owns CSS.
  • javascript is the WEB surface (root eslint config); typescript is the MOBILE
    surface (code/src/mobile/, its own config). They do not overlap.
  • typescript and rust delegate to scripts/mobile/lint.sh and scripts/rust/lint.sh,
    and are added to a bare run only when their surface is present. Naming one
    explicitly on a project that lacks it is an error, not a skip.
  • --path cannot scope typescript or rust — those owners lint their workspace whole.
  • JSON output captures each tool's text output in a structured envelope.

Exit codes:  0 = clean   1 = lint issues found   2 = script error
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

# markdownlint runs on the host (see the Markdown section below), so it needs the
# workspace pnpm rather than a container.
host_has_pnpm() { command -v pnpm >/dev/null 2>&1; }

# Run a command in a service container, appending stdout+stderr to TMPFILE.
# Sets LAST_EXIT to the command's exit code.
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

# Run a command on the host, appending stdout+stderr to TMPFILE and setting
# LAST_EXIT — the host counterpart of run_in for tools that span the whole repo.
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
# Whether the CALLER named the types. An auto-added type is one this script chose, and
# a surface this script chose is one it already checked was there — so the two cases
# below are genuinely different and only the explicit one can be wrong.
EXPLICIT_TYPES=false
[[ ${#FILE_TYPES[@]} -gt 0 ]] && EXPLICIT_TYPES=true

for ft in "${FILE_TYPES[@]+"${FILE_TYPES[@]}"}"; do
  case "$ft" in
    python|markdown|javascript|typescript|rust) ;;
    css) die "--file-type 'css' is not linted — no CSS linter is configured. Use format.sh --file-type css for formatting." ;;
    *) die "Invalid --file-type '$ft'. Choose: python markdown javascript typescript rust" ;;
  esac
done

MOBILE_DIR="$PROJECT_ROOT/code/src/mobile"
RUST_DIR="$PROJECT_ROOT/code/src/rust"

if $EXPLICIT_TYPES; then
  # An explicitly requested surface that is not here is a BAD INVOCATION, not a clean
  # result. Never warn-and-exit-0: "could not look" must not be filed as "looked, and
  # it was clean".
  wants typescript && [[ ! -d "$MOBILE_DIR" ]] && \
    die "--file-type typescript needs code/src/mobile/ — this project was generated without the mobile surface."
  wants rust && [[ ! -d "$RUST_DIR" ]] && \
    die "--file-type rust needs code/src/rust/ — this project was generated without the Rust surface."
else
  # A bare run lints every surface that is actually present.
  FILE_TYPES=(python markdown javascript)
  if [[ -d "$MOBILE_DIR" ]]; then FILE_TYPES+=(typescript); else SURFACES_ABSENT+=("typescript — no code/src/mobile/"); fi
  if [[ -d "$RUST_DIR" ]]; then FILE_TYPES+=(rust); else SURFACES_ABSENT+=("rust — no code/src/rust/"); fi
fi

# --path asks for a subtree. The delegated owners lint their workspace as a unit and
# have no --path of their own, so honouring the narrower request means leaving them
# out — and SAYING which, because a silently dropped type reads as a type that passed.
if [[ -n "$TARGET_PATH" ]]; then
  declare -a scoped=() dropped=()
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in
      typescript|rust)
        $EXPLICIT_TYPES && die "--path cannot scope --file-type $ft: scripts/$( [[ $ft == rust ]] && echo rust || echo mobile )/lint.sh lints its workspace whole. Drop --path, or drop --file-type $ft."
        dropped+=("$ft") ;;
      *) scoped+=("$ft") ;;
    esac
  done
  FILE_TYPES=("${scoped[@]}")
  [[ ${#dropped[@]} -gt 0 ]] && DROPPED_NOTE="${dropped[*]}"
fi

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/lint-report.$OUTPUT_FORMAT"
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
# Python (ruff) runs in its container; markdownlint runs on the host. Each
# tool guards its own prerequisite below, so no blanket check here.
cd "$PROJECT_ROOT"

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
MODE=$($FIX && { $UNSAFE_FIX && echo "unsafe-fix" || echo "fix"; } || echo "dry-run")

log ""
bold "▸ lint.sh — $TIMESTAMP"
log "  mode: $MODE"
log "  types: ${FILE_TYPES[*]}"
[[ -n "${DROPPED_NOTE:-}" ]] && log "  dropped by --path: ${DROPPED_NOTE} (their owners lint the whole workspace)"
if [[ ${#SURFACES_ABSENT[@]} -gt 0 ]]; then
  log "  not present in this project: $(IFS='; '; echo "${SURFACES_ABSENT[*]}")"
fi
log ""

# ── Python — ruff check ───────────────────────────────────────────────────────
if wants python; then
  if container_running django; then
    bold "── Python (ruff check) ────────────────────────────────────────────────────"
    # The django container mounts code/src/django ALONE, so a --path outside it does not
    # exist in there: ruff answers "No such file or directory" and the leg is reported as
    # issues found. That is a false RED — the inverse of a false green and just as untrue.
    # Outside that tree the population is legitimately empty, so it is clean and said.
    # Rule: code/docs/GATE-REPORTING.md.
    py_path="${TARGET_PATH:-code/src/django/}"
    if [[ -n "$TARGET_PATH" && "${TARGET_PATH#code/src/django}" == "$TARGET_PATH" ]]; then
      log "  ℹ  '$TARGET_PATH' is outside code/src/django/ — no Python here for ruff to read"
      py_path=""
    fi
    if [[ -n "$py_path" ]]; then
      declare -a ruff_args=(ruff check "$py_path")
      $FIX && ruff_args+=(--fix)
      $UNSAFE_FIX && ruff_args+=(--unsafe-fixes)
      run_in django "${ruff_args[@]}"
      [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    fi
    log ""
  else
    log "  ⚠  django container not running — Python lint COULD NOT RUN"
    UNRUN+=("Python/ruff (django container not running)")
    log ""
  fi
fi

# ── Markdown — markdownlint-cli2 ──────────────────────────────────────────────
# markdownlint runs on the HOST, not in a container: the django container only
# mounts code/src/django, so it cannot reach project-management or root docs.
# This mirrors the lefthook pre-commit gate, which also runs
# `pnpm exec markdownlint-cli2` on the host.
if wants markdown; then
  if host_has_pnpm; then
    bold "── Markdown (markdownlint-cli2) ───────────────────────────────────────────"
    # SCOPING. markdownlint-cli2 APPENDS the config's `globs` array to whatever the CLI
    # gives it, so passing a path WIDENS rather than narrows — measured at 794 files for a
    # one-file request, which is why a scoped run reported findings in files it was never
    # given. `--no-globs` stops the append. The `:` prefix then marks each argument a
    # literal path, and literal paths are STILL filtered through the config's NEGATED globs
    # — so all 16 exclusions survive a scoped run. Proven both ways: a file excluded only by
    # `globs` (not by `ignores`) lints under a bare path and is skipped under `:`.
    # `--no-globs` alone would have kept only the 4 exclusions `ignores` repeats.
    declare -a md_args=(pnpm exec markdownlint-cli2)
    declare -a md_targets=()
    if [[ -z "$TARGET_PATH" ]]; then
      md_args+=("**/*.md")
    else
      md_args+=(--no-globs)
      if [[ -d "$TARGET_PATH" ]]; then
        while IFS= read -r md_file; do md_targets+=(":$md_file"); done \
          < <(find "${TARGET_PATH%/}" -type f -name '*.md' | sort)
      elif [[ -e "$TARGET_PATH" ]]; then
        md_targets+=(":$TARGET_PATH")
      else
        die "--path '$TARGET_PATH' does not exist."
      fi
      md_args+=("${md_targets[@]+"${md_targets[@]}"}")
    fi
    $FIX && md_args+=(--fix)
    # An empty scope is a population of zero the search COULD have filled, so clean is the
    # honest verdict — said out loud rather than left to look like a pass.
    if [[ -n "$TARGET_PATH" && ${#md_targets[@]} -eq 0 ]]; then
      log "  ℹ  no .md files under '$TARGET_PATH' — nothing to lint"
    else
      run_on_host "${md_args[@]}"
      [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    fi
    log ""
  else
    log "  ⚠  pnpm not found on host — Markdown lint COULD NOT RUN (it runs on the host; install pnpm/Node)"
    UNRUN+=("Markdown/markdownlint (pnpm not on host PATH)")
    log ""
  fi
fi

# ── JavaScript — ESLint, the WEB surface ──────────────────────────────────────
# Runs on the HOST against the ROOT config, which is what keeps this byte-identical to
# CI's eslint job, lefthook's eslint leg and `pnpm lint:js`. The root config ignores
# code/src/mobile/, so this cannot reach the mobile tree — that is typescript's job.
if wants javascript; then
  if host_has_pnpm; then
    bold "── JavaScript (ESLint — web surface) ──────────────────────────────────────"
    # ESLint ERRORS when every file under a path is ignored ("all of the files matching the
    # glob pattern are ignored"), which turns an empty population into a red gate — the
    # inverse of a false green and just as untrue. A scope with no lintable JavaScript is a
    # population of zero the search could have filled, so it is clean and SAID.
    # Rule: code/docs/GATE-REPORTING.md.
    js_scope="${TARGET_PATH:-.}"
    js_count=$(find "$js_scope" -type f \( -name '*.js' -o -name '*.mjs' -o -name '*.cjs' \) \
      -not -path '*/node_modules/*' -not -path '*/.venv/*' 2>/dev/null | head -1 | wc -l)
    if [[ "$js_count" -eq 0 ]]; then
      log "  ℹ  no .js/.mjs/.cjs files under '$js_scope' — nothing to lint"
    else
      declare -a js_args=(pnpm exec eslint "$js_scope")
      $FIX && js_args+=(--fix)
      run_on_host "${js_args[@]}"
      [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    fi
    log ""
  else
    log "  ⚠  pnpm not found on host — JavaScript lint COULD NOT RUN (it runs on the host; install pnpm/Node)"
    UNRUN+=("JavaScript/ESLint (pnpm not on host PATH)")
    log ""
  fi
fi

# ── TypeScript — the MOBILE surface ───────────────────────────────────────────
# Delegated, not reimplemented: the mobile app owns its eslint, typescript-eslint and
# config, so this aggregate only decides WHETHER to run it. Unreachable unless the
# surface exists — an explicit request without it died in validation above.
if wants typescript; then
  bold "── TypeScript (ESLint — mobile surface) ───────────────────────────────────"
  declare -a ts_args=(bash "$PROJECT_ROOT/code/src/scripts/mobile/lint.sh")
  $FIX && ts_args+=(--fix)
  run_on_host "${ts_args[@]}"
  [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
  log ""
fi

# ── Rust — the Cargo workspace ────────────────────────────────────────────────
# Delegated for the same reason. The owner runs `cargo fmt --check` alongside clippy, so
# a formatting breach fails the LINT gate here exactly as it does in CI — which is why
# format.sh asks that script for its narrow --fmt-only half rather than duplicating it.
if wants rust; then
  bold "── Rust (rustfmt + clippy) ────────────────────────────────────────────────"
  declare -a rs_args=(bash "$PROJECT_ROOT/code/src/scripts/rust/lint.sh")
  $FIX && rs_args+=(--fix)
  run_on_host "${rs_args[@]}"
  [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
  log ""
fi

# ── Verdict ───────────────────────────────────────────────────────────────────
# Decided BEFORE the report is written, so the persisted artefact carries the verdict the
# terminal shows. A leg that could not run produced no result and may not reach the clean
# verdict: 3 means "what ran was clean, and this did not run".
# Rule: code/docs/GATE-REPORTING.md.
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
        printf '# Lint Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Mode** | %s |\n' "$MODE"
        printf '| **Types** | %s |\n' "${FILE_TYPES[*]}"
        printf '| **Status** | %s |\n' \
          "$([[ $OVERALL_EXIT -eq 0 ]] && echo '✓ Clean' || { [[ $OVERALL_EXIT -eq 3 ]] && echo '⚠ Incomplete — a leg could not run' || echo '✗ Issues found'; })"
        printf '| **Could not run** | %s |\n\n' "${UNRUN_TEXT:-none}"
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
        printf '  "dropped_by_path": "%s",\n' "${DROPPED_NOTE:-}"
        printf '  "surfaces_absent": "%s",\n' "$(IFS='; '; echo "${SURFACES_ABSENT[*]-}")"
        printf '  "unrun": [%s],\n' \
          "$(if [[ ${#UNRUN[@]} -gt 0 ]]; then printf '"%s",' "${UNRUN[@]}" | sed 's/,$//'; fi)"
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
  <title>Lint Report — <%PROJECT_SLUG%></title>
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
  <h1>Lint Report — <%PROJECT_SLUG%></h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>Mode</th><td>$MODE</td></tr>
    <tr><th>File types</th><td>${FILE_TYPES[*]}</td></tr>
    <tr><th>Status</th><td class="$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)">
      $([[ $OVERALL_EXIT -eq 0 ]] && echo '&#10003; Clean' || { [[ $OVERALL_EXIT -eq 3 ]] && echo '&#9888; Incomplete &mdash; a leg could not run' || echo '&#10007; Issues found'; })
    </td></tr>
    <tr><th>Could not run</th><td>${UNRUN_TEXT:-none}</td></tr>
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
elif [[ $OVERALL_EXIT -eq 3 ]]; then
  bold "⚠ INCOMPLETE — every leg that ran was clean, and ${#UNRUN[@]} could not run."
  for leg in "${UNRUN[@]}"; do log "    · $leg"; done
  log "  This is not a clean result. Install what is missing, or scope with --file-type."
else
  bold "✗ Lint issues found."
  $FIX || log "  Run with --fix to apply safe automatic fixes."
  if [[ ${#UNRUN[@]} -gt 0 ]]; then
    log "  Additionally, ${#UNRUN[@]} leg(s) could not run:"
    for leg in "${UNRUN[@]}"; do log "    · $leg"; done
  fi
fi
log ""

exit $OVERALL_EXIT
