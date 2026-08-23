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
# Scope scanned:  how-to/src/SERVER-ARCHITECTURE/*.md  (excluding CONTEXT.md, CLAUDE.md),
#                 or whatever --path names — and every line printed names THAT scope, not
#                 this default. A run that announces one directory and reads another is
#                 unfalsifiable, whichever of the two it happens to be right about.
#
# THE FILE COUNT PRINTS ON EVERY RUN, not only the zero one — a clean sweep of four files
# and a clean sweep of four hundred are otherwise the same headline (`css-tokens.sh` is the
# named pattern). A scope holding no contract file exits 0 on that count and the reason,
# never on the "contract intact" line: zero files checked and zero violations found are the
# same number and opposite results (code/docs/GATE-REPORTING.md Section 5).
#
# --path is NORMALISED to a repo-relative path before it is tested, because the existence
# guard and the scan have to be handed the same string. `.` and `./` are the unscoped run;
# a path outside the repository exits 2 rather than scanning it.
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
  --path PATH          Restrict the check to a file or directory inside this repository.
                       Absolute, './'-prefixed and '..'-bearing forms are all accepted and
                       normalised to a repo-relative path; '.' is the unscoped run; a path
                       outside the repository exits 2
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
TMP_FILES=$(mktemp)
trap 'rm -f "$TMP_HITS" "$TMP_FILES"' EXIT
: > "$TMP_HITS"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# --path arrives from a shell, so it arrives in every shape a shell produces: an absolute
# path from tab-completion, a `./` prefix from a glob, `.` itself, a `..` segment from a
# copied relative path. Every line below has to apply the SAME string — the existence test,
# the collector, and the scope each verdict names — or the guard passes on one value while
# the scan reads another, and the run reports clean over a population nothing opened. That is
# the fault this whole guard exists to close (code/docs/GATE-REPORTING.md Section 5), so the
# value is normalised ONCE, here, and $TARGET_PATH is repo-relative from this point on.
#
# LEXICAL, never realpath: resolving symlinks rewrites the scope into a path the operator did
# not name, and naming a scope other than the one asked for is the defect above with the sign
# flipped. The sibling skill-conformance.sh has a harder version of the same reason.
normalise_scope() {
  local raw="${1%/}" abs seg out=""
  [[ -n "$raw" ]] || return 0
  if [[ "$raw" == /* ]]; then abs="$raw"; else abs="$PROJECT_ROOT/$raw"; fi
  local IFS='/'
  for seg in $abs; do
    case "$seg" in
      ''|.) ;;
      ..)   out="${out%/*}" ;;
      *)    out="$out/$seg" ;;
    esac
  done
  printf '%s' "$out"
}

TARGET_PATH_RAW="$TARGET_PATH"
if [[ -n "$TARGET_PATH" ]]; then
  SCOPE_ABS="$(normalise_scope "$TARGET_PATH")"
  if [[ "$SCOPE_ABS" == "$PROJECT_ROOT" ]]; then
    # `.` and `./` name the whole repository, which IS the unscoped run. Left as a scope they
    # matched the repo root and found nothing of this kind in it, then said so as a verdict.
    TARGET_PATH=""
  elif [[ "$SCOPE_ABS" == "$PROJECT_ROOT"/* ]]; then
    TARGET_PATH="${SCOPE_ABS#"$PROJECT_ROOT"/}"
  else
    # An out-of-tree scope is a bad argument, never an empty surface: this audit answers for
    # THIS repository, and `--path /etc` used to walk /etc and return a verdict over it.
    # A path reaching the tree through a symlinked alias lands here too — give it relative
    # to the repository root, which is the form every line of output then names.
    die "--path '$TARGET_PATH_RAW' resolves to '$SCOPE_ABS', outside $PROJECT_ROOT — pass a path inside the repository, relative to its root"
  fi
fi

# Now, and only now, against the same normalised value the scan will use. Both forms are
# named: the reader typed one and the collector will open the other, and a message giving
# only the second reads as though the script invented a path.
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] ||
  die "--path '$TARGET_PATH_RAW' does not exist (resolved to '$TARGET_PATH' from the repository root)"

# THE SCOPE EVERY LINE BELOW NAMES. The header read "checking Source provenance in
# how-to/src/SERVER-ARCHITECTURE/…" whatever --path said, so a run over one file in another
# tree announced the whole contract directory and then reported it intact. The scope a gate
# names and the scope it opens have to be the same string, or neither the header nor the
# verdict means anything.
EXAMINED_SCOPE="${TARGET_PATH:-$SCOPE_DIR}"
EXAMINED_SCOPE="${EXAMINED_SCOPE%/}"

# A trailing slash is itself a claim — that the scope is a directory — and --path takes a
# single file. Printed unconditionally it turned `--path .../OVERVIEW.md` into a line naming
# `OVERVIEW.md/`, a directory that does not exist.
EXAMINED_LABEL="$EXAMINED_SCOPE"
if [[ -d "$EXAMINED_SCOPE" ]]; then EXAMINED_LABEL="$EXAMINED_SCOPE/"; fi

# Report state. Initialised here because both no-op exits write a report before the scan has
# had a chance to set any of it — a CI job told to collect the artefact must always find it.
FILE_COUNT=0
HIT_COUNT=0
BODY=""
SURFACE_NOTE=""

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if [[ -n "$SURFACE_NOTE" ]]; then
    status="✓ surface absent, nothing to check"
  elif [[ "$HIT_COUNT" -eq 0 ]]; then
    status="✓ contract intact"
  else
    status="✗ $HIT_COUNT violation(s)"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'seam-contract audit — %s\n' "$TIMESTAMP"
        printf 'scope=%s files=%s violations=%s\n' "$EXAMINED_SCOPE" "$FILE_COUNT" "$HIT_COUNT"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        printf '\n%s\n' "${BODY:-No violations.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Build/Operate Seam Contract Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Scope examined** | `%s` |\n' "$EXAMINED_LABEL"
        printf '| **Files checked** | %s |\n' "$FILE_COUNT"
        printf '| **Violations** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        elif [[ -z "$SURFACE_NOTE" ]]; then
          printf '_Every Source path resolves; every numbered section is attributed._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "seam-contract",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "scope": "%s",\n' "$EXAMINED_SCOPE"
        printf '  "files": %s,\n' "$FILE_COUNT"
        printf '  "surface_present": %s,\n' "$([[ -n "$SURFACE_NOTE" ]] && echo false || echo true)"
        printf '  "violations": %s,\n' "$HIT_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
  return 0
}

log ""
bold "▸ seam-contract.sh — $TIMESTAMP"

# The contract directory is optional: a project may not have run /scale-planning yet.
# Absent surface reports success, so this can run unconditionally in CI.
if [[ -z "$TARGET_PATH" && ! -d "$SCOPE_DIR" ]]; then
  SURFACE_NOTE="Surface absent: $EXAMINED_SCOPE/ does not exist, so no server contract could be read and this run is clean by definition."
  log "  files:     $FILE_COUNT contract file(s) — $EXAMINED_SCOPE/ does not exist"
  bold "✓ No $EXAMINED_SCOPE/ — nothing to check."
  log ""
  write_report
  exit 0
fi

collect_files() {
  if [[ -n "$TARGET_PATH" ]]; then
    if [[ -d "$TARGET_PATH" ]]; then
      find "$TARGET_PATH" -type f -name '*.md' ! -name 'CONTEXT.md' ! -name 'CLAUDE.md' -print0
    else
      printf '%s\0' "$TARGET_PATH"
    fi
  else
    find "$SCOPE_DIR" -type f -name '*.md' ! -name 'CONTEXT.md' ! -name 'CLAUDE.md' -print0
  fi
}

collect_files > "$TMP_FILES"
FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

log "  checking Source provenance in $EXAMINED_LABEL…"
# THE DENOMINATOR, ON EVERY RUN — not only on the zero case. A clean sweep of four contract
# files and a clean sweep of four hundred print the same verdict without it, and the reader
# cannot tell how much "intact" is worth. `css-tokens.sh` is the pattern this follows
# (audits/CONTEXT.md → its inventory row): count the population before scanning it, and say
# the count out loud whatever the count turns out to be.
log "  files:     $FILE_COUNT contract file(s) — CONTEXT.md and CLAUDE.md excluded by design"
log ""

# A scope that exists and holds no contract file is a legitimately empty population, and
# exit 0 is the honest verdict for it — but "Seam contract intact" is not, because no Source
# field was read to earn it. The denominator is what tells the two apart, so it is printed
# rather than implied: zero files checked, and the reason named.
# Rule: code/docs/GATE-REPORTING.md Section 5.
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SURFACE_NOTE="Surface absent: no contract file under $EXAMINED_LABEL (CONTEXT.md and CLAUDE.md are excluded by design), so no Source field was read and this run is clean by definition."
  bold "✓ No contract file under $EXAMINED_LABEL — nothing was checked."
  log ""
  write_report
  exit 0
fi

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
done < "$TMP_FILES"

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d seam-contract violation%s\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

write_report

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ Seam contract intact — every Source resolves, every numbered section attributed."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT seam-contract violation(s) — see code/docs/architecture/BUILD-OPERATE-SEAM.md."
  log ""
  exit 1
fi
