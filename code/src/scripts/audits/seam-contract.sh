#!/usr/bin/env bash
#
# seam-contract.sh — Verify the build/operate seam in the server contract.
#
#                    how-to/src/SERVER-ARCHITECTURE/ is the contract the deploy repo
#                    implements against. Every section that states a requirement names
#                    where that requirement comes from, in a `**Source:**` field.
#
#                    Two mechanical checks:
#                      1. Every repository path named in a **Source:** field resolves.
#                      2. Every numbered section (## N. …) carries a **Source:** field.
#
#                    What it CANNOT check: a **Source:** pointing at a guide that still
#                    exists but no longer says what the contract claims. Only the
#                    same-change rule defends against that.
#
#                    Rule: code/docs/architecture/BUILD-OPERATE-SEAM.md
#
# Scope scanned:  how-to/src/SERVER-ARCHITECTURE/*.md  (excluding CONTEXT.md, CLAUDE.md)
#
# Usage: seam-contract.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                         [--path PATH] [--help]
#
# Exit codes:  0 = contract intact   1 = violation(s) found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

SCOPE_DIR="how-to/src/SERVER-ARCHITECTURE"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'seam-contract.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
seam-contract.sh — Verify the build/operate seam in the server contract

Usage:
  seam-contract.sh               Check how-to/src/SERVER-ARCHITECTURE/*.md
  seam-contract.sh --output md   Also write a report
  seam-contract.sh --path FILE   Restrict the check to one file

Checks:
  1. Every repository path named in a **Source:** field resolves
  2. Every numbered section (## N. ...) carries a **Source:** field

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/seam-contract-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the check to a file or directory
  --help               Show this help

Prose sources ("the project's URL-architecture ADR") are legitimate and are not flagged.
Rule: code/docs/architecture/BUILD-OPERATE-SEAM.md

Exit codes:  0 = clean   1 = violation(s) found   2 = script error
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
  OUTPUT_FILE="$REPORTS_DIR/seam-contract-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_HITS"' EXIT
: > "$TMP_HITS"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ seam-contract.sh — $TIMESTAMP"

# The contract directory is optional: a project may not have run /scale-planning yet.
# Absent surface reports success, so this can run unconditionally in CI.
if [[ -z "$TARGET_PATH" && ! -d "$SCOPE_DIR" ]]; then
  bold "✓ No $SCOPE_DIR/ — nothing to check."
  log ""
  exit 0
fi

collect_files() {
  if [[ -n "$TARGET_PATH" ]]; then
    [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
    if [[ -d "$TARGET_PATH" ]]; then
      find "$TARGET_PATH" -type f -name '*.md' ! -name 'CONTEXT.md' ! -name 'CLAUDE.md' -print0
    else
      printf '%s\0' "$TARGET_PATH"
    fi
  else
    find "$SCOPE_DIR" -type f -name '*.md' ! -name 'CONTEXT.md' ! -name 'CLAUDE.md' -print0
  fi
}

log "  checking Source provenance in $SCOPE_DIR/…"
log ""

# --- Check 1: every documentation path named in a **Source:** block resolves ---
# A Source block runs from the `**Source:**` line until the next blank line.
#
# Only DOCUMENTATION paths are checked, because a **Source:** field states
# PROVENANCE — the guide, ADR or register the requirement comes from — and that is
# what drifts when a guide is renamed or split. Deliberately NOT checked:
#   * code/src/**       implementation detail; legitimately absent at baseline
#   * URL paths         `/control/`, `/health/ready/`, `/api/...`
#   * deploy: prefixes  paths in <%DEPLOY_REPO%>, which is a different repository
#   * bare filenames    `NIXOS-HANDOFF.md` — too ambiguous to resolve safely
# Prose sources ("the project's URL-architecture ADR") are legitimate and skipped.
DOC_ROOTS='^(code/docs|how-to/docs|how-to/src|project-management/docs|project-management/src|\.claude)/'

check_paths() {
  local file="$1"
  awk '
    /\*\*Source:\*\*/ { inblock = 1 }
    inblock && /^[[:space:]]*$/ { inblock = 0 }
    inblock { print FNR "\t" $0 }
  ' "$file" | while IFS=$'\t' read -r lineno text; do
    printf '%s\n' "$text" | grep -o '`[^`]*`' 2>/dev/null | tr -d '`' | while read -r tok; do
      printf '%s' "$tok" | grep -qE "$DOC_ROOTS" || continue
      case "$tok" in
        *' '*|*'*'*|*'<'*|*'...'*) continue ;;   # prose fragments and globs are not paths
      esac
      [[ -e "${tok%/}" ]] || printf '%s:%s: Source path does not resolve — `%s`\n' \
        "$file" "$lineno" "$tok"
    done
  done
}

# --- Check 2: every numbered section carries a **Source:** field ---------------
check_numbered_sections() {
  local file="$1"
  awk -v f="$file" '
    /^## [0-9]+\./ {
      if (heading != "" && !found) print f ":" hline ": numbered section has no **Source:** — " heading
      heading = $0; hline = FNR; found = 0; next
    }
    /^## / { if (heading != "" && !found) print f ":" hline ": numbered section has no **Source:** — " heading
             heading = ""; found = 0; next }
    heading != "" && /\*\*Source:\*\*/ { found = 1 }
    END { if (heading != "" && !found) print f ":" hline ": numbered section has no **Source:** — " heading }
  ' "$file"
}

while IFS= read -r -d '' file; do
  check_paths "$file" >> "$TMP_HITS" || true
  check_numbered_sections "$file" >> "$TMP_HITS" || true
done < <(collect_files)

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d seam-contract violation%s\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$HIT_COUNT" -eq 0 ]] && echo '✓ contract intact' || echo "✗ $HIT_COUNT violation(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'seam-contract audit — %s\n' "$TIMESTAMP"
        printf 'violations=%s\n\n' "$HIT_COUNT"
        printf '%s\n' "${BODY:-No violations.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Build/Operate Seam Contract Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Violations** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_Every Source path resolves; every numbered section is attributed._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "seam-contract",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "violations": %s,\n' "$HIT_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ Seam contract intact — every Source resolves, every numbered section attributed."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT seam-contract violation(s) — see code/docs/architecture/BUILD-OPERATE-SEAM.md."
  log ""
  exit 1
fi
