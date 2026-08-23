#!/usr/bin/env bash
#
# stubs.sh — Detect stub implementations across Python/Django,
#            JavaScript, and Rust.
#
# Hard stubs (always fail):
#   Python  — raise NotImplementedError  ·  # STUB
#   TS/JS   — throw new Error(*not implemented*)  ·  // STUB
#   Rust    — // STUB
#
# Soft markers (listed when --strict; do not cause failure):
#   Python  — # TODO  ·  # FIXME  ·  # HACK
#   TS/JS   — // TODO  ·  // FIXME  ·  // HACK
#   Rust    — // TODO  ·  // FIXME  ·  // HACK
#
# Rust's `todo!()`, `unimplemented!()` and `unreachable!()` are NOT grepped here. All
# three are denied at the lint level in every crate's [lints.clippy] — clippy parses
# Rust, so it cannot be fooled by a macro name in a string or a doc example, and it
# offers a per-site `#[allow]` carrying a reason, which is also the escape hatch.
# A `// STUB` comment is what clippy cannot see.
#
# The Cargo build tree (`target/`) is excluded: it holds thousands of generated .rs
# files carrying upstream crates' markers, none of them anyone's to fix here.
#
# TDD/BDD red phase: export STUBS_TDD_RED=1 to skip this check and exit 0.
#   e.g.  STUBS_TDD_RED=1 git commit -m "red: ..."
#
# Usage: stubs.sh [--strict] [--file-type TYPE] [--output FORMAT]
#                 [--output-file PATH] [--quiet] [--path PATH] [--help]
#
# Exit codes:  0 = clean (or TDD red phase)   1 = hard stubs found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# ── Defaults ──────────────────────────────────────────────────────────────────
STRICT=false
declare -a FILE_TYPES=()
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
OVERALL_EXIT=0
TOTAL_HITS=0
HARD_HITS=0
SOFT_HITS=0

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'stubs.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
stubs.sh — Detect stub implementations in Python/Django, JavaScript and Rust

Usage:
  stubs.sh                         Scan all file types (hard stubs only)
  stubs.sh --strict                Also report TODO / FIXME / HACK soft markers
  stubs.sh --file-type python      Restrict to Python only
  stubs.sh --file-type typescript  Restrict to the mobile surface's TypeScript
  stubs.sh --file-type rust        Restrict to the Rust workspace only

Options:
  --strict             Show soft markers (# TODO / # FIXME / # HACK / // TODO etc.)
                       Soft markers are listed but do not cause failure.
  --file-type TYPE     Restrict to file type (repeat for multiple):
                         python | javascript | typescript | rust
  --output FORMAT      Write a report: md | txt | json | html
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/stubs-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict scan to a specific file or directory
                         A path that does not exist is a bad argument, not an empty
                         scope: exit 2, never a green run over a scope never honoured.
                         So is an empty one, and so is a path outside the repository.
                         Absolute, ./-prefixed and ..-containing forms are all accepted
                         and resolved; `.` scans the whole repository, which is WIDER
                         than the unscoped default of code/src.
  --help               Show this help

TDD/BDD red phase:
  Export STUBS_TDD_RED=1 to skip this check entirely:
    STUBS_TDD_RED=1 git commit -m "red: ..."

Hard stubs detected (always; cause exit 1):
  Python  │ raise NotImplementedError  ·  # STUB
  TS/JS   │ throw new Error(*not implemented*)  ·  // STUB
  Rust    │ // STUB

  todo!(), unimplemented!() and unreachable!() are denied by clippy instead, per crate
  in [lints.clippy] — see code/docs/rust/PYO3-BOUNDARY.md. `cargo clippy` runs via
  code/src/scripts/rust/lint.sh, so a clean stubs.sh run does not by itself mean the
  Rust surface is stub-free.

Soft markers detected (--strict only; listed but do not fail):
  Python  │ # TODO  ·  # FIXME  ·  # HACK
  TS/JS   │ // TODO  ·  // FIXME  ·  // HACK
  Rust    │ // TODO  ·  // FIXME  ·  // HACK

Scanned extensions — one token per language, matching syntax/lint.sh's vocabulary:
  python      *.py
  javascript  *.js  ·  *.jsx      the WEB surface's Alpine and enhancement scripts
  typescript  *.ts  ·  *.tsx      the MOBILE surface
  rust        *.rs
  *.md and all other file types are excluded — Markdown is linted/formatted separately.

Excluded paths:
  node_modules/  ·  .venv/  ·  __pycache__/  ·  migrations/  ·  .next/
  generated/  ·  dist/  ·  .git/  ·  audits/  ·  target/ (the Cargo build tree)

Exit codes:  0 = clean (or TDD red phase)   1 = hard stubs found   2 = script error
EOF
}

# A value is a value, not merely a token in the position where one goes. `--path ""` counted
# as an argument and then scanned the default root, so a caller whose computed scope came back
# empty was handed a full run reading as though the scope had been honoured. cloc.sh,
# docs-length.sh, routing-skills.sh and stubs.sh all refuse an empty value at exit 2 as of
# 22/08/2026; the folder's other --path takers were left as they were, so check by running
# one rather than by reading this line.
require_arg() {
  [[ $# -gt 1 && -n "$2" ]] || die "$1 requires a non-empty value"
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)       STRICT=true; shift ;;
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
    python|javascript|typescript|rust) ;;
    *) die "Invalid --file-type '$ft'. Choose: python javascript typescript rust" ;;
  esac
done
# Every type is in the default set so the CI gate covers each without a flag. This
# script only greps, so unlike the syntax scripts it needs no surface guard: on a
# project without the mobile or Rust surface the scan matches nothing and costs one
# grep per extension.
[[ ${#FILE_TYPES[@]} -eq 0 ]] && FILE_TYPES=(python javascript typescript rust)

if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/stubs-report.$OUTPUT_FORMAT"
fi

# ── TDD/BDD red phase bypass ──────────────────────────────────────────────────
if [[ "${STUBS_TDD_RED:-0}" == "1" ]]; then
  printf '\033[33m⚠  TDD/BDD red phase — stub audit skipped (STUBS_TDD_RED=1).\033[0m\n'
  exit 0
fi

# ── Setup ─────────────────────────────────────────────────────────────────────
cd "$PROJECT_ROOT"

# Normalise --path before anything reads it. `find` and `grep -r` take an absolute or
# ./-prefixed root happily, so this script never had the blindness its git-listing siblings
# did — but it also took `--path /etc` and scanned it, reporting hard stubs in files outside
# the repository as this project's findings. A scope is a narrowing of THIS tree; anything
# else is a bad argument. `.` and `..` are resolved lexically so the existence test and the
# scan agree on one string. Rule: code/docs/GATE-REPORTING.md.
scope_abs() { # $1 = --path value → the absolute path it names, . and .. resolved lexically
  local raw="$1" seg norm=""
  local -a parts
  case "$raw" in /*) ;; *) raw="$PROJECT_ROOT/$raw" ;; esac
  IFS='/' read -r -a parts <<< "$raw"
  for seg in "${parts[@]}"; do
    case "$seg" in
      ''|.) ;;
      ..)   if [[ "$norm" == */* ]]; then norm="${norm%/*}"; else norm=""; fi ;;
      *)    norm="${norm:+$norm/}$seg" ;;
    esac
  done
  printf '/%s\n' "$norm"
}

SCOPE_AS=""   # names the typed form in the error below, when normalising changed it
if [[ -n "$TARGET_PATH" ]]; then
  SCOPE_RAW="$TARGET_PATH"
  SCOPE_ABS="$(scope_abs "$TARGET_PATH")"
  if [[ "$SCOPE_ABS" == "$PROJECT_ROOT" ]]; then
    # `.` — the repository root, kept as an explicit scan root rather than folded into the
    # unscoped run: unscoped here means `code/src`, so treating `.` as "no scope" would
    # QUIETLY NARROW what the caller asked for, which is the same defect from the other side.
    TARGET_PATH="$PROJECT_ROOT"
  elif [[ "$SCOPE_ABS" == "$PROJECT_ROOT"/* ]]; then
    TARGET_PATH="${SCOPE_ABS#"$PROJECT_ROOT"/}"
  else
    die "--path '$TARGET_PATH' resolves to $SCOPE_ABS, outside $PROJECT_ROOT"
  fi
  [[ "$TARGET_PATH" == "$SCOPE_RAW" ]] || SCOPE_AS=" — '$SCOPE_RAW' resolves to it"
fi

# --path is validated HERE, at top level, and not left to the greps below — each of them
# already swallows its own stderr and is followed by `|| true`, so a root that does not
# exist produces the identical output to a root full of clean code: nothing. The run then
# reaches "✓ No hard stubs found." at exit 0 having read no file at all. Rule:
# code/docs/GATE-REPORTING.md.
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist$SCOPE_AS"

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
MODE=$($STRICT && echo "strict" || echo "hard-stubs")
SCAN_ROOT="${TARGET_PATH:-$PROJECT_ROOT/code/src}"
# "under stubs.sh" is not a place. One word, so a single-file scope reads as one.
SCOPE_WORD=at; [[ -d "$SCAN_ROOT" ]] && SCOPE_WORD=under

# ── File-type selectors ───────────────────────────────────────────────────────
wants() {
  local target="$1"
  for ft in "${FILE_TYPES[@]}"; do [[ "$ft" == "$target" ]] && return 0; done
  return 1
}

# The two curly-brace languages share one scan section and one comment syntax, so the
# section runs when EITHER is wanted; which extensions it reads is decided inside.
wants_ts_js() {
  for ft in "${FILE_TYPES[@]}"; do
    case "$ft" in javascript|typescript) return 0 ;; esac
  done
  return 1
}

# ── Shared grep exclusions ────────────────────────────────────────────────────
EXCL=(
  --exclude-dir=node_modules
  --exclude-dir=.venv
  --exclude-dir=__pycache__
  --exclude-dir=migrations
  --exclude-dir=.next
  --exclude-dir=generated
  --exclude-dir=dist
  --exclude-dir=.git
  --exclude-dir=audits
  # The Cargo build tree — generated .rs files carry the upstream crates' own markers,
  # none of which anyone here can act on.
  --exclude-dir=target
)

# ── The population ────────────────────────────────────────────────────────────
# A grep that matches nothing and a grep that read nothing print the same thing, so the
# denominator is counted separately and printed in the header. Both the pruned directories
# and the extensions are DERIVED from what the scan itself uses — a second copy of either
# list is a denominator that drifts away from the numerator without anyone noticing.
declare -a PRUNE_EXPR=()
for excl in "${EXCL[@]}"; do
  PRUNE_EXPR+=(-o -name "${excl#--exclude-dir=}")
done

declare -a POP_EXTS=()
wants python     && POP_EXTS+=(-o -name "*.py")
wants typescript && POP_EXTS+=(-o -name "*.ts" -o -name "*.tsx")
wants javascript && POP_EXTS+=(-o -name "*.js" -o -name "*.jsx")
wants rust       && POP_EXTS+=(-o -name "*.rs")

# `${arr[@]:1}` drops the leading -o each list was built with, which is cheaper to read
# than tracking a separator flag through two loops.
# `-H` follows a symlink given ON THE COMMAND LINE and no other, which is what makes this
# count agree with the scan below. Without it `find` refuses to descend a symlinked
# --path root and reports 0, while the scan's `grep -r` follows that same symlink and
# would have read the tree — so the empty-population branch fired and printed a clean
# verdict over files nothing had looked at. The counter and the scanner must walk the
# same tree or the denominator is about a different population than the findings.
FILE_COUNT=$(
  find -H "$SCAN_ROOT" \
    \( -type d \( "${PRUNE_EXPR[@]:1}" \) -prune \) \
    -o -type f \( "${POP_EXTS[@]:1}" \) -print 2>/dev/null | wc -l | tr -d ' '
)

log ""
bold "▸ stubs.sh — $TIMESTAMP"
log "  mode:  $MODE"
log "  types: ${FILE_TYPES[*]}"
log "  root:  $SCAN_ROOT"
log "  files: $FILE_COUNT"
log ""

# ── No-op when no file of a scanned type is present ───────────────────────────
# An absent surface is a legitimately empty population, not an unexamined one, so exit 0
# is the honest verdict — but "✓ No hard stubs found." over zero files reads as "nothing
# is wrong here" when what happened is "nothing of this kind is here". Only the wording
# separates them, and a report is still written so a CI job collecting the artefact always
# finds one. Rule: code/docs/GATE-REPORTING.md; idiom: audits/CLAUDE.md.
SURFACE_ABSENT=false
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SURFACE_ABSENT=true
  # "in scope", not "here": the excluded directories are pruned from the count and from
  # every grep alike, and `find` prunes a ROOT whose own name is on the list — point --path
  # at code/src/rust/target, which holds 68 generated .rs files, and this is zero by POLICY
  # rather than by absence. The numerator agrees (GNU grep skips a command-line root the
  # same way), so the verdict is sound; it is the sentence that has to stop saying "here".
  log "  No ${FILE_TYPES[*]} file in scope $SCOPE_WORD this root — none present, or all excluded."
  log ""
fi

# scan LABEL SEVERITY PATTERN EXT...
# Appends findings to TMPFILE; updates counters and OVERALL_EXIT.
scan() {
  local label="$1" severity="$2" pattern="$3"
  shift 3

  local all_hits="" hits ext
  for ext in "$@"; do
    hits=$(grep -rn "${EXCL[@]}" --include="$ext" -E "$pattern" "$SCAN_ROOT" 2>/dev/null || true)
    if [[ -n "$hits" ]]; then
      [[ -n "$all_hits" ]] && all_hits+=$'\n'
      all_hits+="$hits"
    fi
  done

  [[ -z "$all_hits" ]] && return 0

  local count s
  count=$(printf '%s\n' "$all_hits" | wc -l | tr -d ' ')
  s="$([[ $count -ne 1 ]] && echo 's' || echo '')"
  TOTAL_HITS=$((TOTAL_HITS + count))

  if [[ "$severity" == "hard" ]]; then
    HARD_HITS=$((HARD_HITS + count))
    OVERALL_EXIT=1
    $QUIET || printf '\033[31m  ✗ %s — %d hit%s\033[0m\n' "$label" "$count" "$s"
  else
    SOFT_HITS=$((SOFT_HITS + count))
    $QUIET || printf '\033[33m  ⚠ %s — %d hit%s\033[0m\n' "$label" "$count" "$s"
  fi

  if ! $QUIET; then
    printf '%s\n' "$all_hits" | sed 's/^/    /'
    printf '\n'
  fi

  printf '%s\n' "$all_hits" >> "$TMPFILE"
}

# ── Python / Django ───────────────────────────────────────────────────────────
# Each section is skipped outright when the population is empty. Printing a section header
# over a root holding no file of that language is the visual form of the claim this whole
# change removes: it looks like a leg that ran.
if ! $SURFACE_ABSENT && wants python; then
  bold "── Python / Django ────────────────────────────────────────────────────────"
  scan "raise NotImplementedError" hard \
    'raise NotImplementedError' \
    "*.py"
  scan "# STUB marker" hard \
    '#[[:space:]]*(STUB)($|[[:space:]:])' \
    "*.py"
  if $STRICT; then
    scan "# TODO marker" soft \
      '#[[:space:]]*(TODO)($|[[:space:]:])' \
      "*.py"
    scan "# FIXME marker" soft \
      '#[[:space:]]*(FIXME)($|[[:space:]:])' \
      "*.py"
    scan "# HACK marker" soft \
      '#[[:space:]]*(HACK)($|[[:space:]:])' \
      "*.py"
  fi
  log ""
fi

# ── TypeScript / JavaScript ───────────────────────────────────────────────────
if ! $SURFACE_ABSENT && wants_ts_js; then
  bold "── TypeScript / JavaScript ────────────────────────────────────────────────"
  declare -a ts_exts=()
  wants typescript && ts_exts+=("*.ts" "*.tsx")
  wants javascript && ts_exts+=("*.js" "*.jsx")

  scan "throw new Error (not implemented)" hard \
    'throw new Error\(.*[Nn]ot.{0,3}[Ii]mplemented' \
    "${ts_exts[@]}"
  scan "// STUB marker" hard \
    '//[[:space:]]*(STUB)($|[[:space:]:])' \
    "${ts_exts[@]}"
  if $STRICT; then
    scan "// TODO marker" soft \
      '//[[:space:]]*(TODO)($|[[:space:]:])' \
      "${ts_exts[@]}"
    scan "// FIXME marker" soft \
      '//[[:space:]]*(FIXME)($|[[:space:]:])' \
      "${ts_exts[@]}"
    scan "// HACK marker" soft \
      '//[[:space:]]*(HACK)($|[[:space:]:])' \
      "${ts_exts[@]}"
  fi
  log ""
fi

# ── Rust ──────────────────────────────────────────────────────────────────────
# Comment markers only. `todo!()`, `unimplemented!()` and `unreachable!()` are denied at
# the lint level in every crate's [lints.clippy] instead — clippy parses Rust, so it
# cannot be fooled by a macro name inside a string, a comment or a doc example, and it
# offers a per-site `#[allow]` that carries a reason where a grep offers nothing. The rule
# they enforce is that nothing panics across the Python boundary.
#
# A `// STUB` comment is the one marker clippy genuinely cannot see, so it stays here.
#
# RUST-ONLY in practice: on a web-only project this grep matches nothing and the section
# prints a clean header, which is cheaper than a directory guard.
if ! $SURFACE_ABSENT && wants rust; then
  bold "── Rust ───────────────────────────────────────────────────────────────────"

  scan "// STUB marker" hard \
    '//[[:space:]]*(STUB)($|[[:space:]:])' \
    "*.rs"
  if $STRICT; then
    scan "// TODO marker" soft \
      '//[[:space:]]*(TODO)($|[[:space:]:])' \
      "*.rs"
    scan "// FIXME marker" soft \
      '//[[:space:]]*(FIXME)($|[[:space:]:])' \
      "*.rs"
    scan "// HACK marker" soft \
      '//[[:space:]]*(HACK)($|[[:space:]:])' \
      "*.rs"
  fi
  log ""
fi

# ── Report output ─────────────────────────────────────────────────────────────
# One verdict, computed once and read by the markdown, the JSON and the HTML alike — a
# report saying "no hard stubs" beside a terminal saying "nothing to check" is two answers
# to one question, and the reader believes whichever they opened.
if $SURFACE_ABSENT; then
  STATUS_TEXT="✓ No file of a scanned type in scope — none present, or all excluded"
elif [[ $OVERALL_EXIT -eq 0 ]]; then
  STATUS_TEXT="✓ No hard stubs in $FILE_COUNT file(s)"
else
  STATUS_TEXT="✗ Hard stubs found"
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  RAW=$(<"$TMPFILE")

  case "$OUTPUT_FORMAT" in
    txt)
      # A header, not a bare copy of the hits file. `cp` alone wrote a ZERO-BYTE report on
      # every clean run — and a zero-byte file is the written form of saying nothing: it
      # cannot distinguish "read 62 files, found no stub" from "read none". The counts and
      # the status line go in first, then the findings.
      { printf 'stubs audit — %s\n' "$TIMESTAMP"
        printf 'mode=%s types=%s files=%s hard=%s soft=%s\n' \
          "$MODE" "${FILE_TYPES[*]}" "$FILE_COUNT" "$HARD_HITS" "$SOFT_HITS"
        printf 'status: %s\n\n' "$STATUS_TEXT"
        printf '%s\n' "${RAW:-No stubs or markers found.}"; } > "$OUTPUT_FILE"
      ;;

    md)
      {
        printf '# Stub Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Mode** | %s |\n' "$MODE"
        printf '| **Types** | %s |\n' "${FILE_TYPES[*]}"
        printf '| **Files scanned** | %d |\n' "$FILE_COUNT"
        printf '| **Hard stubs** | %d |\n' "$HARD_HITS"
        printf '| **Soft markers** | %d |\n' "$SOFT_HITS"
        printf '| **Status** | %s |\n\n' "$STATUS_TEXT"
        if [[ -n "$RAW" ]]; then
          printf '```text\n%s\n```\n' "$RAW"
        else
          printf '_No stubs or markers found._\n'
        fi
      } > "$OUTPUT_FILE"
      ;;

    json)
      {
        printf '{\n'
        printf '  "script": "stubs",\n'
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "mode": "%s",\n' "$MODE"
        printf '  "file_types": [%s],\n' \
          "$(printf '"%s",' "${FILE_TYPES[@]}" | sed 's/,$//')"
        printf '  "files_scanned": %d,\n' "$FILE_COUNT"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "hard_hits": %d,\n' "$HARD_HITS"
        printf '  "soft_hits": %d,\n' "$SOFT_HITS"
        printf '  "total_hits": %d,\n' "$TOTAL_HITS"
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
  <title>Stub Audit — <%PROJECT_NAME%></title>
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
  <h1>Stub Audit — <%PROJECT_NAME%></h1>
  <table>
    <tr><th>Generated</th><td>$TIMESTAMP</td></tr>
    <tr><th>Mode</th><td>$MODE</td></tr>
    <tr><th>File types</th><td>${FILE_TYPES[*]}</td></tr>
    <tr><th>Files scanned</th><td>$FILE_COUNT</td></tr>
    <tr><th>Hard stubs</th><td>$HARD_HITS</td></tr>
    <tr><th>Soft markers</th><td>$SOFT_HITS</td></tr>
    <tr><th>Status</th><td class="$([[ $OVERALL_EXIT -eq 0 ]] && echo ok || echo fail)">
      $STATUS_TEXT
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
if $SURFACE_ABSENT; then
  bold "✓ Nothing to check: no ${FILE_TYPES[*]} file in scope $SCOPE_WORD $SCAN_ROOT."
  log "  No file was read, so no stub could be found. Excluded wherever they sit:"
  log "  node_modules .venv __pycache__ migrations .next generated dist .git audits"
  log "  target — a root that is itself one of those is pruned, and counts zero."
  log ""
  exit 0
fi

if [[ $OVERALL_EXIT -eq 0 ]]; then
  bold "✓ No hard stubs in $FILE_COUNT file(s)."
  if $STRICT && [[ $SOFT_HITS -gt 0 ]]; then
    s="$([[ $SOFT_HITS -ne 1 ]] && echo 's' || echo '')"
    log "  ($SOFT_HITS soft marker${s} noted — run with --output to capture in a report)"
  fi
else
  s="$([[ $HARD_HITS -ne 1 ]] && echo 's' || echo '')"
  bold "✗ Hard stubs found ($HARD_HITS occurrence${s})."
  log "  Remove stubs before committing, or run with STUBS_TDD_RED=1 for TDD/BDD red phase."
fi
log ""

exit $OVERALL_EXIT
