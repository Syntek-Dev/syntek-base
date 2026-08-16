#!/usr/bin/env bash
#
# conflict-markers.sh — Ban unresolved git conflict markers anywhere in the tree.
#
#                       A committed conflict marker passed every gate this repository had for
#                       two releases: a documentation file carried an unresolved stash
#                       conflict, and Prettier had reformatted the markers into *valid
#                       Markdown* — so it linted clean, formatted clean, and an anchored grep
#                       found nothing. It surfaced only because someone happened to edit that
#                       section.
#
#                       Nothing else owns this check. It spans every file type rather than one
#                       language, which is why it is its own audit and not a clause inside a
#                       language-scoped one. The pattern is sourced from the shared shell
#                       library so that the template-update script, which had its own weaker
#                       anchored copy, matches exactly what this audit matches.
#
# Scope scanned:  tracked AND untracked-but-not-ignored files — the file you just wrote is
#                 the one most needing the check, and it is not tracked yet. Binary files
#                 are skipped.
#
# Exempt:         nothing by path. A deliberate example (how a conflict *looks*) carries
#                 `conflict-markers: ignore` on the line, the line above, or the opening fence
#                 of its code block — an HTML comment inside a fence would render to the reader.
#
# Usage: conflict-markers.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                            [--path PATH] [--self-test] [--help]
#
# Exit codes:  0 = clean   1 = marker(s) found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# shellcheck source=code/src/scripts/_lib/conflict-markers.sh
source "$SCRIPT_DIR/../_lib/conflict-markers.sh"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'conflict-markers.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
conflict-markers.sh — Ban unresolved git conflict markers anywhere in the tree

Usage:
  conflict-markers.sh                Scan tracked + untracked-but-not-ignored files
  conflict-markers.sh --output md    Also write a report
  conflict-markers.sh --path DIR     Restrict the scan to a file/dir
  conflict-markers.sh --self-test    Prove the detector fires, then exit

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/conflict-markers-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the scan to a file or directory
  --self-test          Verify the pattern against known-bad and known-good lines
  --help               Show this help

Suppress a deliberate example with `conflict-markers: ignore` on the line, the line
directly above it, or the opening fence of the code block it sits in.

Exit codes:  0 = clean   1 = marker(s) found   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --self-test)    SELF_TEST=true; shift ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Self-test ────────────────────────────────────────────────────────────────
# The whole point of this audit is a form that fooled every other gate, so the detector is
# proven to fire in BOTH directions before it is trusted: a green run that measured nothing
# is believed. Every known-bad line below is a real form, not an invented one.
if $SELF_TEST; then
  bold "▸ conflict-markers.sh --self-test"
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
  fails=0

  # The markers are BUILT, never written literally: a file that greps for conflict markers
  # must not contain any, or it flags itself on the first run. Naming the forms is also
  # clearer than the glyphs.
  #
  # The conversion spec comes FIRST, and that ordering is load-bearing. Copier's
  # variable delimiter is an angle bracket followed by a percent sign, so writing the
  # repeat as bracket-then-spec puts that exact pair in the file: Jinja opens an
  # expression, never finds the closer, and `copier copy` dies with a TemplateSyntaxError
  # before a single file is written. This script once shipped that way and broke generation
  # outright. `%.0s` consumes each `seq` argument and prints nothing, so the literal can sit
  # on either side with identical output — put it on the right.
  OPEN=$(printf '%.0s<' $(seq 7))
  CLOSE=$(printf '%.0s>' $(seq 7))
  MANGLED_CLOSE=$(printf '%.0s> ' $(seq 7)); MANGLED_CLOSE="${MANGLED_CLOSE% }"

  # Known-bad: raw open, mangled (indented) open, raw close, mangled (blockquote) close.
  { printf '%s HEAD\n'                "$OPEN"
    printf '  %s Updated upstream\n'  "$OPEN"
    printf '%s feature/branch\n'      "$CLOSE"
    printf '  %s Stashed changes\n'   "$MANGLED_CLOSE"
  } >"$tmp/bad.txt"
  # Known-good: separators, shell heredocs, Python prompts, nested quotes below the threshold.
  cat >"$tmp/good.txt" <<'GOOD'
============================================================================
cat <<<EOF
>>> python_repl_prompt()
> > > three deep is a real quote
=======
GOOD

  bad_hits=$(conflict_markers_scan "$tmp/bad.txt" | wc -l | tr -d ' ')
  good_hits=$(conflict_markers_scan "$tmp/good.txt" | wc -l | tr -d ' ')

  if [[ "$bad_hits" -eq 4 ]]; then
    log "  ✓ fires on all 4 known-bad forms"
  else
    printf '\033[31m  ✗ known-bad: expected 4 hits, got %s\033[0m\n' "$bad_hits"; fails=1
  fi
  if [[ "$good_hits" -eq 0 ]]; then
    log "  ✓ silent on 5 known-good lines (incl. ======= and a 3-deep quote)"
  else
    printf '\033[31m  ✗ known-good: expected 0 hits, got %s\033[0m\n' "$good_hits"
    conflict_markers_scan "$tmp/good.txt" | sed 's/^/      /'; fails=1
  fi

  # The suppression path must work, or a legitimate example becomes unfixable.
  printf '<!-- %s -->\n%s HEAD\n' 'conflict-markers: ignore' "$OPEN" >"$tmp/ign.txt"
  [[ "$(conflict_markers_scan "$tmp/ign.txt" | wc -l | tr -d ' ')" -eq 0 ]] \
    && log "  ✓ line-above suppression honoured" \
    || { printf '\033[31m  ✗ line-above suppression ignored\033[0m\n'; fails=1; }

  printf '<!-- %s -->\n```text\n%s a\n%s b\n```\n' \
    'conflict-markers: ignore' "$OPEN" "$CLOSE" >"$tmp/fence.md"
  [[ "$(conflict_markers_scan "$tmp/fence.md" | wc -l | tr -d ' ')" -eq 0 ]] \
    && log "  ✓ exempted fence honoured" \
    || { printf '\033[31m  ✗ exempted fence ignored\033[0m\n'; fails=1; }

  # Prettier separates an HTML comment from a fence with a blank line, so the directive must
  # survive one. This is the exact shape a formatted guide in this repository already carries,
  # not a hypothetical.
  printf '<!-- %s -->\n\n```text\n%s a\n```\n' \
    'conflict-markers: ignore' "$OPEN" >"$tmp/blank.md"
  [[ "$(conflict_markers_scan "$tmp/blank.md" | wc -l | tr -d ' ')" -eq 0 ]] \
    && log "  ✓ directive survives a blank line before the fence" \
    || { printf '\033[31m  ✗ blank line broke the directive\033[0m\n'; fails=1; }

  # The blind spot that was rejected outright: an ordinary fence must NOT hide a real conflict.
  printf '```text\n%s a\n```\n' "$OPEN" >"$tmp/plain.md"
  [[ "$(conflict_markers_scan "$tmp/plain.md" | wc -l | tr -d ' ')" -eq 1 ]] \
    && log "  ✓ an UNexempted fence is still scanned" \
    || { printf '\033[31m  ✗ unexempted fence was skipped — blind spot\033[0m\n'; fails=1; }

  [[ "$fails" -eq 0 ]] && { bold "✓ self-test passed"; exit 0; }
  printf '\033[31m✗ self-test FAILED\033[0m\n'; exit 1
fi

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/conflict-markers-report.$OUTPUT_FORMAT"
fi

TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_HITS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ conflict-markers.sh — $TIMESTAMP"

# Tracked plus untracked-but-not-ignored, deduplicated. Ignored files are absent by
# construction, which keeps this repo's own gitignored maps and handoffs out of the scan.
candidates() {
  if [[ -n "$TARGET_PATH" ]]; then
    [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
    if [[ -d "$TARGET_PATH" ]]; then find "$TARGET_PATH" -type f; else printf '%s\n' "$TARGET_PATH"; fi
  else
    { git ls-files; git ls-files --others --exclude-standard; } | sort -u
  fi
}

FILE_COUNT=0
: > "$TMP_HITS"
while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  grep -Iq . "$file" 2>/dev/null || continue   # skip binaries
  FILE_COUNT=$((FILE_COUNT + 1))
  conflict_markers_scan "$file" | sed "s#^#${file}:#" >> "$TMP_HITS"
done < <(candidates)

HIT_COUNT=$(grep -c . < "$TMP_HITS" | tr -d ' ' || true)
BODY="$(cat "$TMP_HITS")"

log "  scanned $FILE_COUNT text file(s) for unresolved conflict markers"
log ""

if [[ "$HIT_COUNT" -gt 0 ]]; then
  if [[ $QUIET == false ]]; then
    printf '\033[31m  ✗ %d unresolved conflict marker%s — resolve, or annotate a deliberate example with `conflict-markers: ignore`\033[0m\n' \
      "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
    printf '%s\n' "$BODY" | sed 's/^/    /'
    printf '\n'
  fi
else
  bold "✓ No unresolved conflict markers in $FILE_COUNT text file(s)."
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md)   { printf '# conflict-markers report\n\n- Generated: %s\n- Files scanned: %s\n- Markers found: %s\n\n' \
              "$TIMESTAMP" "$FILE_COUNT" "$HIT_COUNT"
            [[ "$HIT_COUNT" -gt 0 ]] && printf '```text\n%s\n```\n' "$BODY"; } > "$OUTPUT_FILE" ;;
    txt)  { printf 'conflict-markers report\nGenerated: %s\nFiles scanned: %s\nMarkers found: %s\n\n' \
              "$TIMESTAMP" "$FILE_COUNT" "$HIT_COUNT"
            printf '%s\n' "$BODY"; } > "$OUTPUT_FILE" ;;
    json) printf '%s' "$BODY" | python3 -c "
import sys, json
hits = []
for line in sys.stdin.read().splitlines():
    if not line.strip():
        continue
    path, _, rest = line.partition(':')
    lineno, _, text = rest.partition(':')
    hits.append({'file': path, 'line': int(lineno) if lineno.isdigit() else None, 'text': text})
print(json.dumps({'generated': '$TIMESTAMP', 'files_scanned': $FILE_COUNT,
                  'markers_found': $HIT_COUNT, 'hits': hits}, indent=2))
" > "$OUTPUT_FILE" ;;
  esac
  log "  report: $OUTPUT_FILE"
fi

[[ "$HIT_COUNT" -eq 0 ]] || exit 1
