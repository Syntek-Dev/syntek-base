#!/usr/bin/env bash
#
# format.sh — Check or apply code formatting using ruff format (Python), Prettier
#             (JavaScript, TypeScript, CSS, Markdown) and rustfmt (Rust).
#             Dry-run by default — no files are modified without --fix.
#
# WHY typescript IS NOT GATED ON THE MOBILE SURFACE, WHERE lint.sh AND check.sh ARE
# ESLint and tsc for TypeScript exist only inside code/src/mobile/, so those two
# aggregates gate on that directory. Prettier has no such dependency, and TypeScript
# ships outside the mobile tree in one place: the four audit self-test specimens under
# audits/fixtures/. They ship to a WEB-ONLY project too, because dict-discipline.sh and
# negative-space.sh both refuse to --self-test without them. Gating this token would
# leave those four formatted by nothing here.
#
# rust delegates to scripts/rust/lint.sh --fmt-only — the narrow half, because that
# script's --fix also runs `clippy --fix`, which rewrites logic rather than layout.
#
# Usage: format.sh [--fix] [--file-type TYPE] [--output FORMAT]
#                  [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = all files formatted   1 = formatting needed   2 = script error
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
DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

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
die()  { printf 'format.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
format.sh — Format using ruff format (Python), Prettier (JS/TS/CSS/Markdown), rustfmt

Usage:
  format.sh                        Dry-run check across all file types
  format.sh --fix                  Reformat all files
  format.sh --file-type python     Restrict to Python only
  format.sh --fix --file-type css  Reformat CSS only

Options:
  --fix                Apply formatting (writes files). Default is dry-run check.
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | javascript | typescript | css | markdown | rust
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/reports/format-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict to a specific file or directory
  --help               Show this help

Notes:
  • Dry-run exit code 1 means files need formatting — run with --fix to correct.
  • Prettier handles JavaScript, TypeScript, CSS, and Markdown.
  • ruff format handles Python (PEP 8 compatible, opinionated like Black).
  • typescript is NOT gated on the mobile surface here, unlike lint.sh and check.sh —
    Prettier also formats the audit self-test specimens, which ship everywhere.
  • rust delegates to scripts/rust/lint.sh --fmt-only and joins a bare run only when
    code/src/rust/ is present. Naming it without that surface is an error, not a skip.
  • --path cannot scope rust — rustfmt formats the workspace whole.
  • --output writes a report regardless of whether --fix was used.

Exit codes:  0 = all formatted / no changes   1 = formatting needed or applied   2 = script error
             3 = clean, but a leg could not run (see the summary for which)
EOF
}

require_arg() {
  [[ $# -gt 1 ]] || die "$1 requires a value"
}

# Defined here rather than beside the tool sections, because the surface guard in
# argument validation below needs it.
wants() {
  local target="$1"
  for ft in "${FILE_TYPES[@]}"; do [[ "$ft" == "$target" ]] && return 0; done
  return 1
}

container_running() {
  "${DC[@]}" ps --status running 2>/dev/null | grep -q "^[^ ]*$1"
}

# Prettier runs on the host (see the Prettier section below), so it needs the
# workspace pnpm rather than a container.
host_has_pnpm() { command -v pnpm >/dev/null 2>&1; }

LAST_EXIT=0
run_in() {
  local service="$1"; shift
  set +e
  if $QUIET; then
    "${DC[@]}" exec -T "$service" "$@" \
      >> "$TMPFILE" 2>&1
    LAST_EXIT=$?
  else
    "${DC[@]}" exec -T "$service" "$@" \
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
# Whether the CALLER named the types — only an explicit request can name a surface
# that is not here.
EXPLICIT_TYPES=false
[[ ${#FILE_TYPES[@]} -gt 0 ]] && EXPLICIT_TYPES=true

for ft in "${FILE_TYPES[@]+"${FILE_TYPES[@]}"}"; do
  case "$ft" in
    python|javascript|typescript|css|markdown|rust) ;;
    *) die "Invalid --file-type '$ft'. Choose: python javascript typescript css markdown rust" ;;
  esac
done

RUST_DIR="$PROJECT_ROOT/code/src/rust"

if $EXPLICIT_TYPES; then
  wants rust && [[ ! -d "$RUST_DIR" ]] && \
    die "--file-type rust needs code/src/rust/ — this project was generated without the Rust surface."
else
  # typescript is unconditional: see the header. rust is not — rustfmt has nothing to
  # read without the workspace.
  FILE_TYPES=(python javascript typescript css markdown)
  if [[ -d "$RUST_DIR" ]]; then FILE_TYPES+=(rust); else SURFACES_ABSENT+=("rust — no code/src/rust/"); fi
fi

# --path asks for a subtree. Prettier and ruff honour it; rustfmt formats the workspace
# whole, so it is dropped and named rather than run against a scope it would ignore.
if [[ -n "$TARGET_PATH" ]]; then
  declare -a scoped=() dropped=()
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in
      rust)
        $EXPLICIT_TYPES && die "--path cannot scope --file-type rust: rustfmt formats the workspace whole. Drop --path, or drop --file-type rust."
        dropped+=("$ft") ;;
      *) scoped+=("$ft") ;;
    esac
  done
  FILE_TYPES=("${scoped[@]}")
  [[ ${#dropped[@]} -gt 0 ]] && DROPPED_NOTE="${dropped[*]}"
fi

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/format-report.$OUTPUT_FORMAT"
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
# Python (ruff) runs in the django container; Prettier runs on the host. Each
# tool guards its own prerequisite below, so no blanket container check here.
cd "$PROJECT_ROOT"

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
MODE=$($FIX && echo "fix (writes files)" || echo "dry-run (check only)")

log ""
bold "▸ format.sh — $TIMESTAMP"
log "  mode: $MODE"
log "  types: ${FILE_TYPES[*]}"
[[ -n "${DROPPED_NOTE:-}" ]] && log "  dropped by --path: ${DROPPED_NOTE} (rustfmt formats the whole workspace)"
if [[ ${#SURFACES_ABSENT[@]} -gt 0 ]]; then
  log "  not present in this project: $(IFS='; '; echo "${SURFACES_ABSENT[*]}")"
fi
log ""

# ── File-type selector helpers ────────────────────────────────────────────────
# Prettier handles js, ts, css and markdown together
wants_prettier() {
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in javascript|typescript|css|markdown) return 0 ;; esac
  done
  return 1
}

# Build the Prettier glob pattern based on requested file types
prettier_pattern() {
  local -a exts=()
  wants javascript && exts+=(js mjs cjs)
  wants typescript && exts+=(ts tsx)
  wants css        && exts+=(css)
  wants markdown   && exts+=(md)

  # Deduplicate, then build the extension glob. A single extension must NOT use a
  # brace ({md} is not expanded by Prettier's glob — only multi-element braces
  # are), so emit a bare `md`; use `{a,b,c}` only for two or more.
  local deduped ext_glob
  deduped=$(printf '%s\n' "${exts[@]}" | sort -u | tr '\n' ',' | sed 's/,$//')
  if [[ "$deduped" == *,* ]]; then
    ext_glob="{$deduped}"
  else
    ext_glob="$deduped"
  fi

  # Emit a bare glob (no embedded quotes — the caller quotes the whole pattern as
  # one arg and lets Prettier expand it). A directory --path is widened to a
  # recursive glob so `--path some/dir` works (Prettier does not recurse dirs).
  if [[ -z "$TARGET_PATH" ]]; then
    printf '**/*.%s' "$ext_glob"
  elif [[ -d "$TARGET_PATH" ]]; then
    printf '%s/**/*.%s' "${TARGET_PATH%/}" "$ext_glob"
  else
    printf '%s' "$TARGET_PATH"
  fi
}

# ── Python — ruff format ──────────────────────────────────────────────────────
if wants python; then
  if container_running django; then
    bold "── Python (ruff format) ───────────────────────────────────────────────────"
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
      if $FIX; then
        run_in django ruff format "$py_path"
      else
        run_in django ruff format --check "$py_path"
      fi
      [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    fi
    log ""
  else
    log "  ⚠  django container not running — Python format COULD NOT RUN"
    UNRUN+=("Python/ruff format (django container not running)")
    log ""
  fi
fi

# ── JavaScript / TypeScript / CSS / Markdown — Prettier ───────────────────────
# Prettier runs on the HOST, not in a container: no dev container mounts the whole
# tree, so a containerised Prettier cannot reach the django app,
# project-management, or root docs. This mirrors the lefthook pre-commit gate,
# which also runs `pnpm exec prettier` on the host.
if wants_prettier; then
  if host_has_pnpm; then
    bold "── JS / TS / CSS / Markdown (Prettier) ────────────────────────────────────"
    pattern="$(prettier_pattern)"
    if $FIX; then
      run_on_host pnpm exec prettier --write "$pattern"
    else
      run_on_host pnpm exec prettier --check "$pattern"
    fi
    [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
    log ""
  else
    log "  ⚠  pnpm not found on host — Prettier COULD NOT RUN (it runs on the host; install pnpm/Node)"
    UNRUN+=("JS/TS/CSS/Markdown/Prettier (pnpm not on host PATH)")
    log ""
  fi
fi

# ── Rust — rustfmt ────────────────────────────────────────────────────────────
# Delegated to the Rust surface's own owner, and to its NARROW half: `lint.sh --fix`
# there also runs `clippy --fix`, which rewrites logic. A format command formats.
if wants rust; then
  bold "── Rust (rustfmt) ─────────────────────────────────────────────────────────"
  declare -a rs_args=(bash "$PROJECT_ROOT/code/src/scripts/rust/lint.sh" --fmt-only)
  $FIX && rs_args+=(--fix)
  run_on_host "${rs_args[@]}"
  [[ $LAST_EXIT -ne 0 ]] && OVERALL_EXIT=1
  log ""
fi

# ── Dry-run summary hint ──────────────────────────────────────────────────────
if ! $FIX && [[ $OVERALL_EXIT -ne 0 ]]; then
  log "  Files above need formatting. Run with --fix to reformat them."
  log ""
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
  <title>Format Report — <%PROJECT_SLUG%></title>
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
  <h1>Format Report — <%PROJECT_SLUG%></h1>
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
elif [[ $OVERALL_EXIT -eq 3 ]]; then
  bold "⚠ INCOMPLETE — every leg that ran was clean, and ${#UNRUN[@]} could not run."
  for leg in "${UNRUN[@]}"; do log "    · $leg"; done
  log "  This is not a clean result, and --fix did not reach those files either."
elif $FIX; then
  bold "⚡ Formatting applied."
else
  bold "✗ Formatting issues found."
  log "  Run with --fix to reformat all files."
fi
log ""

exit $OVERALL_EXIT
