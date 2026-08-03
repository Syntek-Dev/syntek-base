#!/usr/bin/env bash
#
# template-orphans.sh — Detect artefacts stranded by a template update.
#
# A `copier update` that renumbers or moves a directory relocates the scaffolding
# the template owns and deletes the old path — but files a developer created were
# never template files, so they stay behind. Copier raises no conflict, git shows
# no error, and the update reports success. The work is simply orphaned, and the
# tooling now points at an empty folder next door.
#
# The signature is exact. Every directory the template owns under
# project-management/src/ ships a CONTEXT.md. So:
#
#   ORPHAN = a directory holding regular files but NO CONTEXT.md
#
# That is scaffolding-gone-content-left, and nothing else produces it.
#
# Usage: template-orphans.sh [--output FORMAT] [--output-file PATH]
#                           [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = no orphans   1 = orphans found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
ORPHAN_DIRS=0
ORPHAN_FILES=0
declare -a FINDINGS=()

# The trees that hold developer-authored artefacts under template-owned scaffolding.
declare -a SCAN_ROOTS=("project-management/src")

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'template-orphans.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
template-orphans.sh — Detect artefacts stranded by a template update

A renumbered or moved directory takes its template scaffolding with it and leaves
developer-authored files behind, silently. This finds them.

Usage:
  template-orphans.sh                     Scan project-management/src/
  template-orphans.sh --path DIR          Scan one directory instead
  template-orphans.sh --output md         Write a report

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                       (default: code/src/scripts/audits/reports/template-orphans.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Scan a specific directory instead of the defaults
  --help               Show this help

Exit codes:
  0  no orphans
  1  orphans found
  2  script error

Fixing an orphan:
  Move the files into the directory that replaced the old one, then commit. The
  replacement is normally the same name under a different number — 01-STORIES
  became 02-STORIES in template v2.0.0, for instance. Confirm against
  project-management/src/CONTEXT.md before moving anything.

Preventing one:
  project-management/src/ numbers are frozen, append only. Renumbering a folder
  that holds developer artefacts is a schema migration Copier cannot perform.
  See project-management/src/CONTEXT.md - The numbers here are frozen.
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --path)        [[ $# -ge 2 ]] || die "--path needs a directory"; TARGET_PATH="$2"; shift 2 ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option: $1. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"

case "$OUTPUT_FORMAT" in
  ""|md|txt|json) ;;
  *) die "Unknown output format: $OUTPUT_FORMAT (use md, txt or json)" ;;
esac

if [[ -n "$TARGET_PATH" ]]; then
  [[ -d "$PROJECT_ROOT/$TARGET_PATH" || -d "$TARGET_PATH" ]] || die "No such directory: $TARGET_PATH"
  SCAN_ROOTS=("$TARGET_PATH")
fi

# ── Scan ──────────────────────────────────────────────────────────────────────
bold "▸ template-orphans.sh"
log "  looking for artefacts left behind by a template update…"
log ""

for root in "${SCAN_ROOTS[@]}"; do
  abs="$PROJECT_ROOT/$root"
  [[ -d "$abs" ]] || abs="$root"
  [[ -d "$abs" ]] || { log "  skipped (absent): $root"; continue; }

  while IFS= read -r dir; do
    # A directory the template owns always carries a CONTEXT.md.
    [[ -f "$dir/CONTEXT.md" ]] && continue

    # Count regular files sitting directly in it. An empty directory is not an
    # orphan — it is just empty, and git would not track it anyway.
    count=$(find "$dir" -maxdepth 1 -type f ! -name '.gitkeep' ! -name '.gitignore' 2>/dev/null | wc -l)
    [[ "$count" -eq 0 ]] && continue

    rel="${dir#"$PROJECT_ROOT"/}"
    ORPHAN_DIRS=$((ORPHAN_DIRS + 1))
    ORPHAN_FILES=$((ORPHAN_FILES + count))
    FINDINGS+=("$rel|$count")

    log "  ✗ $rel"
    while IFS= read -r f; do
      log "      $(basename "$f")"
    done < <(find "$dir" -maxdepth 1 -type f ! -name '.gitkeep' ! -name '.gitignore' 2>/dev/null | sort)
  done < <(find "$abs" -mindepth 1 -type d ! -path '*/.git/*' 2>/dev/null | sort)
done

# ── Report ────────────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  mkdir -p "$REPORTS_DIR"
  target="${OUTPUT_FILE:-$REPORTS_DIR/template-orphans.$OUTPUT_FORMAT}"
  case "$OUTPUT_FORMAT" in
    json)
      {
        printf '{\n  "orphan_directories": %d,\n  "orphan_files": %d,\n  "findings": [\n' \
          "$ORPHAN_DIRS" "$ORPHAN_FILES"
        for i in "${!FINDINGS[@]}"; do
          d="${FINDINGS[$i]%%|*}"; c="${FINDINGS[$i]##*|}"
          sep=","; [[ $i -eq $((${#FINDINGS[@]} - 1)) ]] && sep=""
          printf '    {"directory": "%s", "files": %s}%s\n' "$d" "$c" "$sep"
        done
        printf '  ]\n}\n'
      } > "$target"
      ;;
    md)
      {
        printf '# Template orphan audit\n\n'
        printf 'Directories holding developer artefacts but no `CONTEXT.md` — the signature of a\n'
        printf 'template update that moved the scaffolding and left the content behind.\n\n'
        if [[ $ORPHAN_DIRS -eq 0 ]]; then
          printf 'No orphans found.\n'
        else
          printf '| Directory | Files stranded |\n| --------- | -------------- |\n'
          for f in "${FINDINGS[@]}"; do printf '| `%s` | %s |\n' "${f%%|*}" "${f##*|}"; done
        fi
      } > "$target"
      ;;
    txt)
      {
        printf 'Template orphan audit\n\n'
        if [[ $ORPHAN_DIRS -eq 0 ]]; then
          printf 'No orphans found.\n'
        else
          for f in "${FINDINGS[@]}"; do printf '%s (%s files)\n' "${f%%|*}" "${f##*|}"; done
        fi
      } > "$target"
      ;;
  esac
  log ""
  log "  report: ${target#"$PROJECT_ROOT"/}"
fi

log ""
if [[ $ORPHAN_DIRS -eq 0 ]]; then
  bold "✓ No orphaned artefacts."
  exit 0
fi

bold "✗ $ORPHAN_FILES file(s) stranded across $ORPHAN_DIRS director(ies)."
log ""
log "  These sit in directories the template no longer defines, so no workflow or"
log "  agent will find them. They are almost certainly yours, not the template's."
log ""
log "  Move each into the directory that replaced it, then commit. Check"
log "  project-management/src/CONTEXT.md for the current numbering before moving."
exit 1
