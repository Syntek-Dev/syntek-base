#!/usr/bin/env bash
#
# render-slop.sh: the RENDERED half of the AI-slop audit. Enforces the one clause of
#                 code/docs/VISUAL-DESIGN.md Section 4.1 that no static scan can decide,
#                 because deciding it needs a viewport.
#
#                 Clauses owned here (both warn):
#                   repeated-device     Section 4.1, one device repeated DOWN a page —
#                                       a row of >= 3 siblings whose widths and
#                                       heights agree within 4%
#                   repeated-signature  Section 4.1, the same device repeated ACROSS the
#                                       screen set — one row signature recurring on
#                                       >= 3 screens
#
#                 Neither can fail a run. Section 6 says why: a taxonomy index legitimately
#                 stamps a row on every section, so a threshold on composition would
#                 fail correct work. That is not a guess — a synthetic taxonomy page
#                 false-positived on exactly this detector during the N-016 spike.
#
# WHY A BROWSER, when the rest of the family is find + awk. The same .wf-grid markup
# is a one-, two- or three-column device depending on width: wireframe.css turns it to
# three columns at 64rem and nowhere below. CSS TEXT HAS NO VIEWPORT, so no static
# scan can know which one a screen actually renders. At 375px and 768px every screen
# reads clean, including one that is a three-up at desktop. 1280px is where the tell
# exists, and it is the same desktop viewport the browser e2e suite already declares
# (code/src/django/tests/e2e/conftest.py).
#
# Scope scanned (*.html only):
#   project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS
#
# DESIGN-TIME ONLY, and stage 1 is deliberately absent. USER-STORY-IDEAS/ holds one
# screen per story and is frozen once workflow 17 runs; a page-SET clause has nothing
# to say about a single screen, and a gate there would invite edits to an audit trail
# the PM layer says is never rewritten. The consolidated folder is the one place the
# whole set exists at once, and it exists before any code.
#
# NO-OP WHEN ABSENT, twice over. A project with no consolidated wireframes exits 0
# with a note, and so does a host with no Chromium: neither is a finding, and both
# still write the report, so a CI job collecting the artefact always finds it.
#
# STRUCTURAL CHROME IS NEVER READ. A shared header, nav or footer recurs on every
# screen by design, so a signature drawn from one would fire on screen 2 of any
# correct set. Rows inside header/nav/footer, or their ARIA landmark equivalents,
# are excluded before anything is stamped.
#
# ESCAPE HATCH — both clauses are FILE-scoped, never line-scoped, because a rendered
# finding has no line: it is geometry, not text. Put the annotation anywhere in the
# screen, naming the clause and the reason:
#
#   <!-- slop-allow: repeated-device — a directory page; every card is the same object -->
#
# repeated-signature is decided across the SET, so an annotation in ANY ONE member
# screen silences it. That is Section 6's "anywhere in the file" extended one step to
# "anywhere in the set" — the smallest true generalisation, and the honest cost is
# that the silence is invisible to someone reading the other screens.
#
# SELF-TEST. --self-test runs the detector over the fixture pair in fixtures/render-slop/
# and asserts it separates them: the known positive must stamp a row, the known negative
# must not. The fixtures are NOT a scan scope — a deliberately-slop screen inside a real
# scope would make this audit permanently amber. This is what proves the gate in a
# template that ships no consolidated wireframes of its own.
#
# Usage: render-slop.sh [--output FORMAT] [--output-file PATH] [--quiet] [--path PATH]
#                       [--self-test] [--help]
#
# Exit codes:  0 = clean or warnings only (or surface absent, or no browser)
#              1 = the self-test failed — the detector no longer separates the fixtures
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="code/src/scripts/audits/fixtures/render-slop"

# One scope, and it is design-time. The code-time surface is deliberately absent: a
# rendered check over Django pages needs the whole dev stack at
# dev.<%PROJECT_SLUG%>.localhost:81, and it would re-decide at code time what the
# consolidated set already settled before any code was written.
SCOPES=(
  "project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS"
)

DOCTRINE="code/docs/VISUAL-DESIGN.md"

# Thresholds. Every one of these was measured by the N-016 spike against a known
# positive and a known negative, not chosen by taste.
VIEWPORT_W=1280            # the tell exists here and nowhere narrower
VIEWPORT_H=800             # matches the e2e suite's `chromium` viewport project
TOLERANCE_PCT=4            # % width AND height agreement before a row is stamped
MIN_ROW_MEMBERS=3          # siblings needed before a row is a device at all
MIN_SET_SCREENS=3          # screens a signature must recur on to speak across the set
SIGNATURE_ROUND=10         # px the width is rounded to when forming a signature

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false

# Report state. Initialised here because the absent-surface exit writes a report
# before the scan has had a chance to set any of them.
SURFACE_ABSENT=false
SURFACE_NOTE=""
BROWSER_NOTE=""
FILE_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0
FAIL_BODY=""
WARN_BODY=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'render-slop.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
render-slop.sh: the rendered half of the AI-slop audit (code/docs/VISUAL-DESIGN.md)

Usage:
  render-slop.sh                   Scan the consolidated wireframe set at 1280px
  render-slop.sh --output md       Also write a report
  render-slop.sh --path DIR        Restrict the scan to a file or directory
  render-slop.sh --self-test       Prove the detector still separates the fixtures

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/render-slop-report.<FORMAT>)
  --quiet              Suppress terminal output (requires --output)
  --path PATH          Restrict the scan to a file or directory
  --self-test          Run the fixture pair and assert positive fires, negative does not
  --help               Show this help

One tier, both clauses:
  [gate: warn]  repeated-device · repeated-signature

Why a browser: the same markup is a one-, two- or three-column device depending on
width, and CSS text has no viewport. 1280px is where the tell exists.

Annotate a genuine exception anywhere in the screen, naming the clause:

  <!-- slop-allow: repeated-device — a directory page; every card is one object -->

Both clauses are file-scoped, never line-scoped: a rendered finding has no line.
repeated-signature is silenced by an annotation in ANY ONE member screen.

Exit codes:  0 = clean or warnings only (or surface absent, or no browser)
             1 = the self-test failed
             2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
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

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/render-slop-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

declare -a ROOTS=()
if $SELF_TEST; then
  ROOTS=("$FIXTURES_DIR")
elif [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  ROOTS=("$TARGET_PATH")
else
  ROOTS=("${SCOPES[@]}")
fi

TMP_FILES=$(mktemp); TMP_HITS=$(mktemp); TMP_KEEP=$(mktemp); TMP_LIST=$(mktemp)
trap 'rm -f "$TMP_FILES" "$TMP_HITS" "$TMP_KEEP" "$TMP_LIST"' EXIT

: > "$TMP_FILES"
for root in "${ROOTS[@]}"; do
  [[ -e "$root" ]] || continue
  find "$root" -type f -name '*.html' -print0 >> "$TMP_FILES" || true
done

FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

# ── Report output ─────────────────────────────────────────────────────────────
# Defined above the absent-surface exit, because a CI job told to collect
# reports/render-slop-report.<FORMAT> must always find the file. An absent surface
# writes a clean, zero-finding report stating the reason rather than leaving nothing
# on disk, which under `--quiet --output json` is no signal at all.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if $SURFACE_ABSENT; then
    status="✓ nothing to check"
  elif [[ "$FAIL_COUNT" -ne 0 ]]; then
    status="✗ self-test failed"
  else
    status="✓ no blocking clause ($WARN_COUNT warning(s))"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'render-slop audit · %s\n' "$TIMESTAMP"
        printf 'files=%s warn=%s viewport=%sx%s\n' \
          "$FILE_COUNT" "$WARN_COUNT" "$VIEWPORT_W" "$VIEWPORT_H"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        [[ -n "$BROWSER_NOTE" ]] && printf '%s\n' "$BROWSER_NOTE"
        printf '\n[gate: warn]\n%s\n' "${WARN_BODY:-None.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Rendered Slop Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Screens rendered** | %s |\n' "$FILE_COUNT"
        printf '| **Viewport** | %sx%s |\n' "$VIEWPORT_W" "$VIEWPORT_H"
        printf '| **Advisory (gate: warn)** | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        [[ -n "$BROWSER_NOTE" ]] && printf '%s\n\n' "$BROWSER_NOTE"
        printf '## Advisory\n\n'
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$WARN_BODY"
        else printf '_None._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "render-slop",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "files": %s,\n  "warn": %s,\n' "$FILE_COUNT" "$WARN_COUNT"
        printf '  "viewport": "%sx%s",\n' "$VIEWPORT_W" "$VIEWPORT_H"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "browser_note": "%s",\n' "$(json_escape "$BROWSER_NOTE")"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
  return 0
}

# ── No-op when the surface is absent ──────────────────────────────────────────
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SURFACE_ABSENT=true
  SURFACE_NOTE="Surface absent: no consolidated wireframe was found under ${ROOTS[*]}, so no clause could match and this run is clean by definition. The base template ships none — screens arrive from workflow 08 and are consolidated by workflow 17."
  log ""
  bold "▸ render-slop.sh · $TIMESTAMP"
  log "  no *.html under: ${ROOTS[*]}"
  log "  This project has not consolidated any wireframes yet."
  log ""
  write_report
  bold "✓ Nothing to check."
  log ""
  exit 0
fi

log ""
bold "▸ render-slop.sh · $TIMESTAMP"
log "  scope:    ${ROOTS[*]}"
log "  screens:  $FILE_COUNT"
log "  viewport: ${VIEWPORT_W}x${VIEWPORT_H}"
log ""

# ── The detector ──────────────────────────────────────────────────────────────
# Python because Playwright is a Python library here; a heredoc because that is how
# static-analysis.sh already embeds Python. `--no-project --with` rather than a bare
# `uv run`: pyproject.toml names the root package <%PROJECT_SLUG%>, which is not a
# valid package name, so a bare `uv run` fails in the base template itself — and a
# gate that cannot run where it ships is the one failure this fixture pair exists to
# prevent.
tr '\0' '\n' < "$TMP_FILES" > "$TMP_LIST"

set +e
DETECTOR_OUT=$(uv run --no-project --with playwright python - \
  "$TMP_LIST" "$VIEWPORT_W" "$VIEWPORT_H" "$TOLERANCE_PCT" \
  "$MIN_ROW_MEMBERS" "$MIN_SET_SCREENS" "$SIGNATURE_ROUND" <<'PY' 2>/dev/null
import sys, pathlib, collections

list_path, vw, vh, tol, min_members, min_screens, rounding = sys.argv[1:8]
vw, vh, rounding = int(vw), int(vh), int(rounding)
tol, min_members, min_screens = float(tol) / 100.0, int(min_members), int(min_screens)

files = [ln for ln in pathlib.Path(list_path).read_text().splitlines() if ln.strip()]

try:
    from playwright.sync_api import sync_playwright
except Exception:
    sys.exit(3)

# Measure sibling geometry in the page, never a screenshot. The house rule in
# code/src/django/tests/e2e/CLAUDE.md: a screenshot diff fails on any rendering
# difference and tells you nothing about the cause.
SCRIPT = """
(tolerance) => {
  const CHROME = 'header, nav, footer, [role="banner"], [role="navigation"], [role="contentinfo"]';
  const rows = [];
  for (const parent of document.querySelectorAll('body *')) {
    if (parent.closest(CHROME)) continue;
    const kids = Array.from(parent.children).filter(el => {
      const r = el.getBoundingClientRect();
      return r.width > 40 && r.height > 40;
    });
    if (kids.length < 2) continue;
    const byTop = new Map();
    for (const el of kids) {
      const r = el.getBoundingClientRect();
      const key = Math.round(r.top / 8);
      if (!byTop.has(key)) byTop.set(key, []);
      byTop.get(key).push({ w: r.width, h: r.height, top: Math.round(r.top) });
    }
    for (const group of byTop.values()) {
      if (group.length < 2) continue;
      const w0 = group[0].w, h0 = group[0].h;
      const uniform = group.every(g =>
        Math.abs(g.w - w0) <= w0 * tolerance && Math.abs(g.h - h0) <= h0 * tolerance);
      if (uniform) rows.push({ count: group.length, w: Math.round(w0), top: group[0].top });
    }
  }
  return rows;
}
"""

findings = []
signatures = collections.defaultdict(list)

with sync_playwright() as p:
    try:
        browser = p.chromium.launch()
    except Exception:
        sys.exit(3)
    page = browser.new_page(viewport={"width": vw, "height": vh})
    for f in files:
        url = pathlib.Path(f).resolve().as_uri()
        try:
            page.goto(url, wait_until="load")
        except Exception:
            continue
        rows = page.evaluate(SCRIPT, tol)
        stamped = [r for r in rows if r["count"] >= min_members]
        for r in stamped:
            sig = "%dx%d" % (r["count"], round(r["w"] / rounding) * rounding)
            signatures[sig].append(f)
        if len(stamped) >= 1:
            worst = max(stamped, key=lambda r: r["count"])
            findings.append((f, "repeated-device",
                             "%d equal boxes of %dpx on one row at y=%d (%d stamped row(s) on this screen)"
                             % (worst["count"], worst["w"], worst["top"], len(stamped))))
    browser.close()

for sig, hits in sorted(signatures.items()):
    screens = sorted(set(hits))
    if len(screens) >= min_screens:
        findings.append((screens[0], "repeated-signature",
                         "signature %s recurs on %d screens: %s"
                         % (sig, len(screens), ", ".join(pathlib.Path(s).name for s in screens))))

for f, clause, text in findings:
    print("%s\t0\twarn\t%s\t%s" % (f, clause, text))
PY
)
DETECTOR_RC=$?
set -e

# ── No-op when there is no browser ────────────────────────────────────────────
# Exit 3 from the detector means Playwright or its Chromium is not installed. That is
# not a finding — it is an absent tool, and static-analysis.sh sets the precedent:
# report success with a note rather than failing a run that measured nothing.
if [[ "$DETECTOR_RC" -eq 3 ]]; then
  # ...but NOT under --self-test, which exists to prove the detector runs. A self-test
  # that passes without a browser has measured nothing and reported green, which is the
  # failure `docs-length.sh` was written to close in its own domain: it exits 2 without
  # `cloc` rather than claiming a clean run it never performed. Same call here, and it
  # matters more in CI than locally — a runner whose `playwright install` step failed
  # would otherwise turn the one job that proves this gate into a rubber stamp.
  $SELF_TEST && die "--self-test needs Chromium, and it is not installed. Install it with \`uv run --no-project --with playwright playwright install chromium\`. Refusing to report a passing self-test that rendered nothing."
  SURFACE_ABSENT=true
  BROWSER_NOTE="Browser absent: Playwright's Chromium is not installed, so nothing was rendered. Install it with \`uv run --no-project --with playwright playwright install chromium\`. This run reports success rather than failing, the same way static-analysis.sh does without its engine — but it has measured nothing."
  log "  Chromium is not installed — nothing was rendered."
  log "  Install: uv run --no-project --with playwright playwright install chromium"
  log ""
  write_report
  bold "✓ Nothing rendered (no browser)."
  log ""
  exit 0
fi
[[ "$DETECTOR_RC" -eq 0 ]] || die "the detector exited $DETECTOR_RC — rendering failed"

# The trailing newline is load-bearing: `printf '%s'` leaves the last line
# unterminated, and `while read` then discards it — a finding measured, reported by
# the detector, and silently dropped on the way to the tally. The blank line an empty
# result produces is skipped by the loop guard below and uncounted by `grep -c .`.
printf '%s\n' "$DETECTOR_OUT" > "$TMP_HITS"

# ── The escape hatch, file-scoped for both clauses ─────────────────────────────
# A rendered finding has no line, so neither clause takes a line annotation. Section 6's
# ratio rule already says "anywhere in the file, naming the clause"; repeated-signature
# extends that one step to "anywhere in the set", because the finding has no single
# file to annotate in the first place.
has_file_annotation() {
  local clause="$1"; shift
  local f
  for f in "$@"; do
    [[ -f "$f" ]] || continue
    grep -qE "slop-allow:[^-]*[[:space:]]${clause}([[:space:],;]|$)" "$f" && return 0
    grep -qE "slop-allow:[[:space:]]*${clause}([[:space:],;]|$)" "$f" && return 0
  done
  return 1
}

declare -a ALL_FILES=()
while IFS= read -r -d '' f; do ALL_FILES+=("$f"); done < "$TMP_FILES"

: > "$TMP_KEEP"
while IFS=$'\t' read -r hfile hline htier hclause htext; do
  [[ -n "$hfile" ]] || continue
  case "$hclause" in
    repeated-device)
      has_file_annotation "$hclause" "$hfile" && continue ;;
    repeated-signature)
      has_file_annotation "$hclause" "${ALL_FILES[@]}" && continue ;;
  esac
  printf '%s\t%s\t%s\t%s\t%s\n' "$hfile" "$hline" "$htier" "$hclause" "$htext"
done < "$TMP_HITS" > "$TMP_KEEP"
cat "$TMP_KEEP" > "$TMP_HITS"

WARN_COUNT=$(grep -c . "$TMP_HITS" || true)
WARN_COUNT=${WARN_COUNT:-0}

WARN_BODY=$(awk -F'\t' '{ printf "%-52s %-20s %s\n", $1, $4, $5 }' "$TMP_HITS")

# ── Self-test ─────────────────────────────────────────────────────────────────
# The whole point of the fixture pair: watch the detector separate a known positive
# from a known negative. A gate nobody has seen fail on purpose is a gate whose green
# result means nothing (audits/CONTEXT.md → Markdown: two limits, two scripts).
if $SELF_TEST; then
  POSITIVE_HITS=$(awk -F'\t' '$1 ~ /positive/ && $4 == "repeated-device"' "$TMP_HITS" | grep -c . || true)
  NEGATIVE_HITS=$(awk -F'\t' '$1 ~ /negative/' "$TMP_HITS" | grep -c . || true)
  log "  self-test: positive=${POSITIVE_HITS:-0} finding(s), negative=${NEGATIVE_HITS:-0} finding(s)"
  log ""
  if [[ "${POSITIVE_HITS:-0}" -ge 1 && "${NEGATIVE_HITS:-0}" -eq 0 ]]; then
    write_report
    bold "✓ Self-test passed — the detector separates the fixture pair."
    log "  Known positive stamped a row; known negative stayed clean."
    log ""
    exit 0
  fi
  FAIL_COUNT=1
  write_report
  bold "✗ Self-test FAILED — the detector no longer separates the fixture pair."
  log "  Expected: >= 1 finding on the positive, 0 on the negative."
  log "  Fix the detector, never the fixtures — they are the ground truth."
  log ""
  exit 1
fi

if ! $QUIET && [[ "$WARN_COUNT" -gt 0 ]]; then
  printf '\033[33m  ! %d [gate: warn] clause match%s (reported, not blocking)\033[0m\n' \
    "$WARN_COUNT" "$([[ "$WARN_COUNT" -ne 1 ]] && echo es)"
  printf '%s\n' "$WARN_BODY" | sed 's/^/    /'
  printf '\n'
fi

# ── Report output ─────────────────────────────────────────────────────────────
write_report

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$WARN_COUNT" -eq 0 ]]; then
  bold "✓ No repeated device stamped across the consolidated set."
else
  bold "✓ No blocking clause. $WARN_COUNT warning(s) for a reviewer to judge."
  log "  A repeated device is monotony on any direction, and sometimes it is correct:"
  log "  a directory or taxonomy page repeats one card because every entry IS one object."
  log "  Answer each warning, or annotate it naming the clause and the reason."
  log "  The vocabulary that replaces it comes from $DOCTRINE Section 3 and the surface"
  log "  sub-document, never from this script."
fi
log ""
exit 0
