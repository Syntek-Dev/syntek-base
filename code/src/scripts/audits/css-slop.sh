#!/usr/bin/env bash
#
# css-slop.sh: the CSS half of the AI-slop audit. Enforces the machine-checkable
#              visual-design clauses whose input is a stylesheet.
#
#              Two tiers in one run, the same warn-then-fail shape the line-count
#              audit uses:
#                [gate: fail]  an unambiguous match. Exit 1, blocks
#                [gate: warn]  a threshold or a ratio. Reported, exit stays 0
#              A threshold on composition fails correct work, which is why it warns
#              rather than blocks: a script does not overrule a designer.
#
#              Clauses owned here (fail):
#                motion-literal-duration  Section 5, a literal duration in transition/
#                                         animation; durations are motion tokens
#                motion-ease-in           Section 5, `ease-in` is prohibited on UI
#                motion-property          Section 5, only transform and opacity animate
#              Clauses owned here (warn):
#                uniform-radius-shadow    Section 4.1, rounded-everything plus a soft
#                                         drop shadow applied as a blanket
#                undifferentiated-buttons Section 4.1, no primary/secondary hierarchy
#                entry-scale              Section 5, entry scales start at 0.9–0.97
#                press-scale              Section 5, press feedback is scale(0.97)
#                stagger                  Section 5, sibling stagger is 30–80ms
#                centred-everything       Section 4.2, reads the ALIGNMENT axis
#                flat-background          Section 4.2, reads the RHYTHM axis
#
#              NOT owned here, deliberately: the inline-gradient tell has its own
#              audit, and so does the em dash; the markup clauses belong to the
#              markup half of this family; [judgement] clauses belong to the
#              reviewer and no script decides them.
#
# Scopes scanned (*.css only):
#   code/src/django/static/css   (per-page and cascade CSS)
#   code/src/django/components   (co-located django-component BEM CSS)
#
# The TOKEN LAYER is exempt: static/css/tokens/*.css and surfaces.css are where a
# duration, an easing and a shadow are legitimately DEFINED, so scanning them would
# fail the very files the rest of the rule points at.
#
# NO-OP WHEN ABSENT. A project with no stylesheets yet exits 0 with a note rather
# than failing, so this can run unconditionally in CI. With --output it STILL writes
# the report: a clean, zero-finding one naming the absent surface as the reason, so a
# job collecting the artefact always finds the file it was told to collect.
#
# THE Section 4.2 LEG READS Section 3. The direction deviations have no fixed verdict; they read
# the commitment table in VISUAL-DESIGN.md Section 3. While any axis is still TBD the leg
# SKIPS with a warning naming first-time-setup Step 9, because an audit that assumed
# `editorial` would fail every correct page on a project that chose otherwise.
#
# ESCAPE HATCH, scoped by whether the finding has a line — not by tier:
#
#   /* slop-allow: motion-ease-in — matching a third-party widget's own curve */
#   /* slop-allow */                 every line clause here (blunt; prefer naming one)
#
# on the offending line or the line above, with a reason. It applies at BOTH TIERS: a
# deliberate 0.85 entry scale or a 100ms stagger is exactly what an annotation is for.
#
# The four RATIOS are different — silencing one line would not change the ratio that
# produced the finding — so they take a FILE-scoped annotation instead: put
# `slop-allow: centred-everything` (or uniform-radius-shadow / undifferentiated-buttons /
# flat-background) in a comment anywhere in the stylesheet, with a reason. A bare marker
# deliberately does not reach them.
#
# Usage: css-slop.sh [--output FORMAT] [--output-file PATH] [--quiet] [--path PATH]
#                    [--help]
#
# Exit codes:  0 = clean or warnings only (or surface absent)
#              1 = one or more [gate: fail] clauses matched
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# The last two scopes are design-time, not code-time. Wireframes are styled HTML+CSS,
# so they read as the same input language and belong to this leg rather than a fourth
# script. Stage 1 (USER-STORY-IDEAS/) is deliberately absent: it is one screen per story
# and frozen once the design-consolidation workflow runs, while Section 4.1's repetition
# tell and Section 4.2's rhythm clause are properties of a page SET. The consolidated
# folder is the one place the whole set exists at once, before any code.
#
# SHARED/ is listed separately and is NOT a third stage. It holds wireframe.css, the one
# stylesheet every screen links, so a scope covering only CONSOLIDATED-IDEAS would gate
# markup while the styling it depends on went unread. Naming both keeps stage 1's screens
# out without letting the stylesheet out with them.
SCOPES=(
  "code/src/django/static/css"
  "code/src/django/components"
  "project-management/src/08-WIREFRAMES/SHARED"
  "project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS"
)

DOCTRINE="code/docs/VISUAL-DESIGN.md"

# Ratio thresholds. A small file must not trip a blanket-uniformity verdict.
MIN_RULES_FOR_RATIO=8       # rule blocks needed before uniform-radius-shadow speaks
UNIFORM_PERCENT=60          # % of rules carrying BOTH radius and shadow
MIN_BUTTON_RULES=3          # button rules needed before hierarchy speaks
MIN_TEXT_ALIGN=3            # text-align declarations needed before centring speaks
CENTRED_PERCENT=60          # % of those that are centred
MIN_BACKGROUNDS=4           # background declarations needed before rhythm speaks

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

# Report state. Initialised here because the absent-surface exit writes a report
# before the scan has had a chance to set any of them.
SURFACE_ABSENT=false
SURFACE_NOTE=""
DIRECTION_NOTE=""
FILE_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0
FAIL_BODY=""
WARN_BODY=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'css-slop.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
css-slop.sh: the CSS half of the AI-slop audit (code/docs/VISUAL-DESIGN.md)

Usage:
  css-slop.sh                      Scan every component and page stylesheet
  css-slop.sh --output md          Also write a report
  css-slop.sh --path DIR           Restrict the scan to a file or directory

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/css-slop-report.<FORMAT>)
  --quiet              Suppress terminal output (requires --output)
  --path PATH          Restrict the scan to a file or directory
  --help               Show this help

Two tiers in one run:
  [gate: fail]  motion-literal-duration · motion-ease-in · motion-property
  [gate: warn]  uniform-radius-shadow · undifferentiated-buttons · entry-scale
                press-scale · stagger · centred-everything · flat-background

The two Section 4.2 clauses read the direction table in VISUAL-DESIGN.md Section 3 and skip
while any axis is still TBD. Settle it at first-time setup, Step 9.

Annotate a genuine exception on the line or the line above, with a reason:

  /* slop-allow: motion-ease-in — matching a third-party widget's curve */
  /* slop-allow */                 every line clause (blunt; prefer naming one)

It works at both tiers. The four ratios take a file-scoped annotation instead —
`slop-allow: centred-everything` anywhere in the stylesheet — because silencing one
line would not change the ratio that produced them.

Exit codes:  0 = clean or warnings only (or surface absent)
             1 = a [gate: fail] clause matched
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
  OUTPUT_FILE="$REPORTS_DIR/css-slop-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

declare -a ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  ROOTS=("$TARGET_PATH")
else
  ROOTS=("${SCOPES[@]}")
fi

TMP_FILES=$(mktemp); TMP_HITS=$(mktemp); TMP_METRICS=$(mktemp); TMP_KEEP=$(mktemp)
trap 'rm -f "$TMP_FILES" "$TMP_HITS" "$TMP_METRICS" "$TMP_KEEP"' EXIT

# Component and page CSS only. The token layer defines the durations, easings and
# shadows every clause below points at, so it is never scanned.
: > "$TMP_FILES"
for root in "${ROOTS[@]}"; do
  [[ -e "$root" ]] || continue
  find "$root" -type f -name '*.css' \
    -not -path '*/static/css/tokens/*' \
    -not -name 'surfaces.css' \
    -not -path '*/staticfiles/*' \
    -not -path '*/static/vendor/*' \
    -not -path '*/node_modules/*' \
    -print0 >> "$TMP_FILES" || true
done

FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

# ── Report output ─────────────────────────────────────────────────────────────
# Defined here, ABOVE the absent-surface exit, because a CI job told to collect
# code/src/scripts/audits/reports/css-slop-report.<FORMAT> must always find the
# file. An absent surface writes a clean, zero-finding report stating the reason
# rather than exiting 0 with nothing on disk, which under `--quiet --output json`
# would leave the consumer with no output and no signal at all.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if $SURFACE_ABSENT; then
    status="✓ surface absent, nothing to check"
  elif [[ "$FAIL_COUNT" -eq 0 ]]; then
    status="✓ no blocking clause ($WARN_COUNT warning(s))"
  else
    status="✗ $FAIL_COUNT blocking clause match(es)"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'css-slop audit · %s\n' "$TIMESTAMP"
        printf 'files=%s fail=%s warn=%s\n' "$FILE_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        [[ -n "$DIRECTION_NOTE" ]] && printf '%s\n' "$DIRECTION_NOTE"
        printf '\n[gate: fail]\n%s\n\n' "${FAIL_BODY:-None.}"
        printf '[gate: warn]\n%s\n' "${WARN_BODY:-None.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# CSS Slop Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files scanned** | %s |\n' "$FILE_COUNT"
        printf '| **Blocking (gate: fail)** | %s |\n' "$FAIL_COUNT"
        printf '| **Advisory (gate: warn)** | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        [[ -n "$DIRECTION_NOTE" ]] && printf '%s\n\n' "$DIRECTION_NOTE"
        printf '## Blocking\n\n'
        if [[ "$FAIL_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n\n' "$FAIL_BODY"
        else printf '_None._\n\n'; fi
        printf '## Advisory\n\n'
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$WARN_BODY"
        else printf '_None._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "css-slop",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "files": %s,\n  "fail": %s,\n  "warn": %s,\n' "$FILE_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "direction_note": "%s",\n' "$(json_escape "$DIRECTION_NOTE")"
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
  SURFACE_NOTE="Surface absent: no component or page stylesheet was found under ${ROOTS[*]}, so no clause could match and this run is clean by definition."
  log ""
  bold "▸ css-slop.sh · $TIMESTAMP"
  log "  no component or page stylesheets under: ${ROOTS[*]}"
  log "  This project has not written any CSS yet."
  log ""
  write_report
  bold "✓ Nothing to check."
  log ""
  exit 0
fi

log ""
bold "▸ css-slop.sh · $TIMESTAMP"
log "  scopes: ${ROOTS[*]}"
log "  files:  $FILE_COUNT"
log ""

# ── Pass 1: line clauses ──────────────────────────────────────────────────────
# Emits "file TAB line TAB tier TAB clause TAB text". Regexes are POSIX ERE: awk
# supports neither \b nor PCRE escapes, so word boundaries are spelt out as
# (^|[^a-zA-Z0-9_-]). A bad pattern aborts awk mid-file, which would report a
# FALSE CLEAN, so every scan failure is fatal.
: > "$TMP_HITS"
while IFS= read -r -d '' f; do
  awk -v FILE="$f" '
    function trim(s) { gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s); return s }
    function emit(tier, clause, ln, text) {
      if (silenced(clause)) return
      printf "%s\t%d\t%s\t%s\t%s\n", FILE, ln, tier, clause, text
    }

    # ── The escape hatch, scoped per clause ───────────────────────────────────
    # "" no marker · "*" bare marker (every line clause) · else a space-delimited list of
    # clause names. Any reason after them is for the human reading the diff.
    function allow_spec(s,   p, t) {
      p = index(s, "slop-allow")
      if (p == 0) return ""
      t = substr(s, p + 10)
      sub(/^[ \t]*/, "", t)
      if (substr(t, 1, 1) != ":") return "*"
      t = substr(t, 2)
      sub(/\*\/.*$/, "", t)               # stop at the end of the CSS comment
      gsub(/[,;\t]/, " ", t)
      return " " t " "
    }

    function silenced(clause) {
      if (SPEC_A == "*" || SPEC_B == "*") return 1
      if (SPEC_A != "" && index(SPEC_A, " " clause " ") > 0) return 1
      if (SPEC_B != "" && index(SPEC_B, " " clause " ") > 0) return 1
      return 0
    }
    function is_easing(w) {
      return (w == "ease" || w == "ease-in" || w == "ease-out" || w == "ease-in-out" \
              || w == "linear" || w == "step-start" || w == "step-end")
    }
    function is_keyword(w) {
      return (w == "none" || w == "inherit" || w == "initial" || w == "unset" || w == "revert")
    }
    { line[NR] = $0 }
    END {
      B = "(^|[^a-zA-Z0-9_-])"
      TIME = "(^|[^a-zA-Z0-9_.-])[0-9]+(\\.[0-9]+)?(ms|s)([^a-zA-Z]|$)"
      incomment = 0; cursel = ""; seldepth = 0; selstack[0] = ""
      for (i = 1; i <= NR; i++) {
        raw = line[i]
        m = raw
        # Strip comments for MATCHING; the raw line still carries the allow note.
        if (incomment) {
          if (m ~ /\*\//) { sub(/^.*\*\//, "", m); incomment = 0 } else { continue }
        }
        gsub(/\/\*[^*]*\*\//, "", m)
        if (m ~ /\/\*/) { sub(/\/\*.*$/, "", m); incomment = 1 }
        if (trim(m) == "") continue

        # Selector context: a STACK, not a single value. CSS nesting is live in
        # this stack (Lightning CSS), so a `}` must restore the enclosing
        # selector; leaking the inner one across the rest of the outer rule
        # names the wrong clause and sends the reviewer to the wrong paragraph.
        #   A line that OPENS a block is judged under the first selector it
        #   opens, so a whole rule written on one line is judged under its own
        #   selector. A line that only CLOSES is judged under the selector still
        #   in force, and pops afterwards, because what it closes sat above it.
        cursel = (seldepth > 0) ? selstack[seldepth] : ""
        deferpop = (m !~ /\{/)
        if (!deferpop) {
          work = m; firstopen = 1
          while (match(work, /[{}]/)) {
            brace = substr(work, RSTART, 1)
            head = trim(substr(work, 1, RSTART - 1))
            work = substr(work, RSTART + 1)
            if (brace == "{") {
              # A brace with no selector text before it (a continued selector
              # list, or `{` alone on its line) inherits the enclosing context,
              # so the stack still balances.
              if (head == "") head = (seldepth > 0) ? selstack[seldepth] : ""
              selstack[++seldepth] = head
              if (firstopen) { cursel = head; firstopen = 0 }
            } else if (seldepth > 0) {
              seldepth--
            }
          }
        }

        # Read from the RAW line: the annotation lives in a comment, which the matcher
        # above has already stripped by design.
        prevraw = (i > 1) ? line[i-1] : ""
        SPEC_A = allow_spec(raw); SPEC_B = allow_spec(prevraw)
        txt = trim(m)

        # Declaration split. A selector line carries a colon too (.a:hover), so a
        # line containing "{" is never read as a declaration.
        isdecl = 0; prop = ""; val = ""
        if (m !~ /\{/ && m ~ /:/) {
          prop = m; sub(/:.*$/, "", prop); prop = trim(prop)
          if (prop ~ /^-?-?[a-zA-Z][a-zA-Z0-9_-]*$/) {
            isdecl = 1
            val = m; sub(/^[^:]*:/, "", val); sub(/;.*$/, "", val); val = trim(val)
          }
        }

        # ── [gate: fail] motion-literal-duration (Section 5) ────────────────────────
        if (isdecl && (prop == "transition" || prop == "transition-duration" \
                       || prop == "animation" || prop == "animation-duration")) {
          if (val ~ TIME) emit("fail", "motion-literal-duration", i, txt)
        }

        # ── [gate: fail] motion-ease-in (Section 5) ─────────────────────────────────
        # ease-in-out is excluded by the trailing class, which forbids "-".
        if (isdecl && (prop == "transition" || prop == "transition-timing-function" \
                       || prop == "animation" || prop == "animation-timing-function")) {
          if (val ~ (B "ease-in([^a-zA-Z0-9_-]|$)"))
            emit("fail", "motion-ease-in", i, txt)
        }

        # ── [gate: fail] motion-property (Section 5) ────────────────────────────────
        if (isdecl && prop == "transition-property") {
          n = split(val, segs, ",")
          for (k = 1; k <= n; k++) {
            w = trim(segs[k])
            if (w == "" || is_keyword(w) || w ~ /^var\(/) continue
            if (w != "transform" && w != "opacity") {
              emit("fail", "motion-property", i, txt)
              break
            }
          }
        } else if (isdecl && prop == "transition") {
          # Blank out parenthesised groups so commas inside cubic-bezier() and
          # var() do not split a segment.
          v2 = val; gsub(/\([^)]*\)/, "()", v2)
          n = split(v2, segs, ",")
          for (k = 1; k <= n; k++) {
            split(trim(segs[k]), ws, /[ \t]+/)
            w = ws[1]
            if (w !~ /^[a-zA-Z][a-zA-Z-]*$/) continue   # a duration or a function
            if (is_easing(w) || is_keyword(w)) continue
            if (w != "transform" && w != "opacity") {
              emit("fail", "motion-property", i, txt)
              break
            }
          }
        }

        # ── [gate: warn] entry-scale / press-scale (Section 5) ──────────────────────
        v3 = m
        while (match(v3, /scale[ \t]*\([ \t]*[0-9]+(\.[0-9]+)?/)) {
          num = substr(v3, RSTART, RLENGTH)
          sub(/^[^(]*\([ \t]*/, "", num)
          v3 = substr(v3, RSTART + RLENGTH)
          if (cursel ~ /:active/) {
            if (num + 0 != 0.97) emit("warn", "press-scale", i, txt)
          } else if (num + 0 < 0.9) {
            emit("warn", "entry-scale", i, txt)
          }
        }

        # ── [gate: warn] stagger (Section 5) ────────────────────────────────────────
        # Only a per-sibling delay counts: a calc() over an index custom property,
        # or an nth-child selector. A one-off decorative delay is not stagger.
        if (isdecl && (prop == "transition-delay" || prop == "animation-delay")) {
          if (val ~ /calc\(/ || cursel ~ /nth-child/) {
            v4 = val
            while (match(v4, /[0-9]+(\.[0-9]+)?(ms|s)/)) {
              tok = substr(v4, RSTART, RLENGTH)
              v4 = substr(v4, RSTART + RLENGTH)
              ms = tok
              if (tok ~ /ms$/) { sub(/ms$/, "", ms); ms = ms + 0 }
              else { sub(/s$/, "", ms); ms = (ms + 0) * 1000 }
              if (ms == 0) continue
              if (ms < 30 || ms > 80) { emit("warn", "stagger", i, txt); break }
            }
          }
        }

        # Deferred pops: a line that closes without opening was judged above
        # under the selector it closes, so the stack unwinds only now.
        if (deferpop) {
          cl = m; nclose = gsub(/\}/, "", cl)
          for (pc = 0; pc < nclose; pc++) if (seldepth > 0) seldepth--
        }
      }
    }
  ' "$f" >> "$TMP_HITS" || die "awk failed scanning $f"
done < "$TMP_FILES"

# ── Pass 2: structural metrics ────────────────────────────────────────────────
# Per-file rule-block accounting for the uniformity ratio, plus the scope-wide
# tallies the Section 4.1 button clause and the two Section 4.2 clauses read.
: > "$TMP_METRICS"
while IFS= read -r -d '' f; do
  awk -v FILE="$f" '
    function trim(s) { gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s); return s }
    { line[NR] = $0 }
    END {
      incomment = 0; inrule = 0; atdepth = 0
      rules = 0; both = 0; hasr = 0; hass = 0
      btn = 0; btnvar = 0; tac = 0; tao = 0; bgdecl = 0
      for (i = 1; i <= NR; i++) {
        m = line[i]
        if (incomment) {
          if (m ~ /\*\//) { sub(/^.*\*\//, "", m); incomment = 0 } else { continue }
        }
        gsub(/\/\*[^*]*\*\//, "", m)
        if (m ~ /\/\*/) { sub(/\/\*.*$/, "", m); incomment = 1 }
        if (trim(m) == "") continue

        if (m ~ /\{/) {
          s = m; sub(/\{.*$/, "", s); s = trim(s)
          if (s ~ /^@/) { atdepth++ }
          else {
            inrule = 1; hasr = 0; hass = 0
            low = tolower(s)
            if (low ~ /(btn|button)/) {
              btn++
              if (low ~ /(primary|secondary)/) btnvar++
            }
          }
          continue
        }
        if (m ~ /\}/) {
          if (inrule) { rules++; if (hasr && hass) both++; inrule = 0 }
          else if (atdepth > 0) atdepth--
          continue
        }

        if (inrule) {
          if (m ~ /(^|[^a-zA-Z0-9_-])border-radius[ \t]*:/ && m !~ /:[ \t]*0[ \t;]*$/) hasr = 1
          if (m ~ /(^|[^a-zA-Z0-9_-])box-shadow[ \t]*:/ && m !~ /:[ \t]*none/) hass = 1
        }

        if (m ~ /(^|[^a-zA-Z0-9_-])text-align[ \t]*:/) {
          v = m; sub(/^[^:]*:/, "", v); sub(/;.*$/, "", v); v = trim(v)
          if (v == "center" || v == "centre") tac++
          else if (v ~ /^(start|left|right|end|justify)$/) tao++
        }

        if (m ~ /(^|[^a-zA-Z0-9_-])background(-color)?[ \t]*:/) {
          bgdecl++
          v = m; sub(/^[^:]*:/, "", v); sub(/;.*$/, "", v)
          if (match(v, /var\([ \t]*--surface-[a-z0-9-]+/)) {
            t = substr(v, RSTART, RLENGTH); sub(/^var\([ \t]*/, "", t)
            printf "BGTOK\t%s\n", t
          }
        }
      }
      printf "RULES\t%d\nBOTH\t%d\nBTN\t%d\nBTNVAR\t%d\nTAC\t%d\nTAO\t%d\nBGDECL\t%d\n", \
             rules, both, btn, btnvar, tac, tao, bgdecl
      if (rules >= MINR && both * 100 >= rules * PCT)
        printf "UNIFORM\t%s\t%d\t%d\n", FILE, both, rules
    }
  ' MINR="$MIN_RULES_FOR_RATIO" PCT="$UNIFORM_PERCENT" "$f" >> "$TMP_METRICS" \
    || die "awk failed measuring $f"
done < "$TMP_FILES"

sum_metric() {
  awk -F'\t' -v k="$1" '$1 == k { t += $2 } END { print t + 0 }' "$TMP_METRICS"
}

BTN_TOTAL=$(sum_metric BTN)
BTN_VARIANTS=$(sum_metric BTNVAR)
TA_CENTRE=$(sum_metric TAC)
TA_OTHER=$(sum_metric TAO)
BG_DECLS=$(sum_metric BGDECL)
BG_DISTINCT=$(awk -F'\t' '$1 == "BGTOK" { seen[$2] = 1 } END { print length(seen) + 0 }' "$TMP_METRICS")

# uniform-radius-shadow: reported per file, so a finding names a file to fix.
awk -F'\t' -v pct="$UNIFORM_PERCENT" '
  $1 == "UNIFORM" {
    printf "%s\t0\twarn\tuniform-radius-shadow\t%d of %d rule blocks carry both a border-radius and a box-shadow (>= %d%%)\n", \
           $2, $3, $4, pct
  }' "$TMP_METRICS" >> "$TMP_HITS"

# undifferentiated-buttons, scope-wide: button rules exist, none names a
# primary/secondary variant.
if [[ "$BTN_TOTAL" -ge "$MIN_BUTTON_RULES" && "$BTN_VARIANTS" -eq 0 ]]; then
  printf '%s\t0\twarn\tundifferentiated-buttons\t%d button rule(s), none naming a primary or secondary variant\n' \
    "(scope)" "$BTN_TOTAL" >> "$TMP_HITS"
fi

# ── The Section 4.2 leg reads the direction table in VISUAL-DESIGN.md Section 3 ───────────
DIRECTION_NOTE=""
ALIGNMENT=""
RHYTHM=""
AXES_READY=false

if [[ ! -f "$DOCTRINE" ]]; then
  DIRECTION_NOTE="Section 4.2 skipped: $DOCTRINE not found, so no direction can be read."
else
  AXIS_ROWS=$(awk '
    /^### This project.s direction/ { inblk = 1; next }
    inblk && /^#/ { inblk = 0 }
    inblk && /^\|/ {
      n = split($0, c, "|")
      if (n < 3) next
      f = c[2]; v = c[3]
      gsub(/[*_`  \t]/, "", f)
      gsub(/^[ \t]+/, "", v); gsub(/[ \t]+$/, "", v)
      if (f == "" || f == "Field" || f ~ /^-+$/) next
      printf "%s\t%s\n", tolower(f), v
    }' "$DOCTRINE")

  if [[ -z "$AXIS_ROWS" ]]; then
    DIRECTION_NOTE="Section 4.2 skipped: no direction table found under '### This project's direction'."
  elif printf '%s' "$AXIS_ROWS" | grep -q 'TBD'; then
    DIRECTION_NOTE="Section 4.2 skipped: the direction is still TBD. Settle it at first-time setup, Step 9 (how-to/workflows/01-first-time-setup/), then re-run."
  else
    normalise() {
      printf '%s' "$1" | tr -d '`_*' | tr '[:upper:]' '[:lower:]' | awk '{ print $1 }'
    }
    ALIGNMENT=$(normalise "$(printf '%s\n' "$AXIS_ROWS" | awk -F'\t' '$1 == "alignment" { print $2 }')")
    RHYTHM=$(normalise "$(printf '%s\n' "$AXIS_ROWS" | awk -F'\t' '$1 == "rhythm" { print $2 }')")
    AXES_READY=true
    DIRECTION_NOTE="Section 4.2 live: alignment '$ALIGNMENT', rhythm '$RHYTHM'."
  fi
fi

if $AXES_READY; then
  # centred-everything reads the ALIGNMENT axis. Correct where alignment is centred.
  if [[ "$ALIGNMENT" == "start" ]]; then
    TA_TOTAL=$((TA_CENTRE + TA_OTHER))
    if [[ "$TA_TOTAL" -ge "$MIN_TEXT_ALIGN" ]] \
       && [[ $((TA_CENTRE * 100)) -ge $((TA_TOTAL * CENTRED_PERCENT)) ]]; then
      printf '%s\t0\twarn\tcentred-everything\t%d of %d text-align declarations are centred, but the alignment axis is start\n' \
        "(scope)" "$TA_CENTRE" "$TA_TOTAL" >> "$TMP_HITS"
    fi
  fi
  # flat-background reads the RHYTHM axis. Correct where rhythm is continuous.
  if [[ "$RHYTHM" == "banded" ]]; then
    if [[ "$BG_DECLS" -ge "$MIN_BACKGROUNDS" && "$BG_DISTINCT" -le 1 ]]; then
      printf '%s\t0\twarn\tflat-background\t%d background declarations resolve to %d distinct surface token, but the rhythm axis is banded\n' \
        "(scope)" "$BG_DECLS" "$BG_DISTINCT" >> "$TMP_HITS"
    fi
  fi
fi

# ── File-scoped annotations, for the findings that have no line ───────────────
# The four ratios are decided across a whole file or the whole scope, so silencing one
# line would not change the ratio that produced them. They take a file-scoped annotation
# instead — `slop-allow: <clause>` in a comment anywhere in the stylesheet. A bare marker
# stays line-scoped and deliberately does not reach here: "this line is fine" is not the
# same claim as "this page is a taxonomy index".
has_file_annotation() {
  local clause="$1" f
  for f in "${@:2}"; do
    grep -Eq "slop-allow:[^*]*(^|[^a-z-])${clause}([^a-z-]|\$)" "$f" 2>/dev/null && return 0
  done
  return 1
}

declare -a ALL_FILES=()
while IFS= read -r -d '' f; do ALL_FILES+=("$f"); done < "$TMP_FILES"

: > "$TMP_KEEP"
while IFS=$'\t' read -r hfile hline htier hclause htext; do
  case "$hclause" in
    uniform-radius-shadow)
      has_file_annotation "$hclause" "$hfile" && continue ;;
    undifferentiated-buttons|centred-everything|flat-background)
      has_file_annotation "$hclause" "${ALL_FILES[@]}" && continue ;;
  esac
  printf '%s\t%s\t%s\t%s\t%s\n' "$hfile" "$hline" "$htier" "$hclause" "$htext"
done < "$TMP_HITS" > "$TMP_KEEP"
cat "$TMP_KEEP" > "$TMP_HITS"

# ── Tally ─────────────────────────────────────────────────────────────────────
FAIL_COUNT=$(awk -F'\t' '$3 == "fail"' "$TMP_HITS" | grep -c . || true)
FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(awk -F'\t' '$3 == "warn"' "$TMP_HITS" | grep -c . || true)
WARN_COUNT=${WARN_COUNT:-0}

render() {
  awk -F'\t' -v tier="$1" '
    $3 == tier {
      loc = ($2 + 0 > 0) ? $1 ":" $2 : $1
      printf "%-46s %-24s %s\n", loc, $4, $5
    }' "$TMP_HITS"
}
FAIL_BODY=$(render fail)
WARN_BODY=$(render warn)

if ! $QUIET; then
  if [[ "$FAIL_COUNT" -gt 0 ]]; then
    printf '\033[31m  ✗ %d [gate: fail] clause match%s\033[0m\n' \
      "$FAIL_COUNT" "$([[ "$FAIL_COUNT" -ne 1 ]] && echo es)"
    printf '%s\n' "$FAIL_BODY" | sed 's/^/    /'
    printf '\n'
  fi
  if [[ "$WARN_COUNT" -gt 0 ]]; then
    printf '\033[33m  ! %d [gate: warn] clause match%s (reported, not blocking)\033[0m\n' \
      "$WARN_COUNT" "$([[ "$WARN_COUNT" -ne 1 ]] && echo es)"
    printf '%s\n' "$WARN_BODY" | sed 's/^/    /'
    printf '\n'
  fi
  [[ -n "$DIRECTION_NOTE" ]] && log "  $DIRECTION_NOTE" && log ""
fi

# ── Report output ─────────────────────────────────────────────────────────────
write_report

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$FAIL_COUNT" -eq 0 ]]; then
  if [[ "$WARN_COUNT" -eq 0 ]]; then
    bold "✓ No AI-slop clause matched in component or page CSS."
  else
    bold "✓ No blocking clause. $WARN_COUNT warning(s) for a reviewer to judge."
    log "  Warnings are thresholds and ratios; a script does not overrule a designer."
  fi
  log ""
  exit 0
else
  bold "✗ $FAIL_COUNT blocking clause match(es). See code/docs/VISUAL-DESIGN.md Section 5."
  log "  Durations and timing functions come from the --motion-* tokens; ease-in is"
  log "  prohibited on UI; only transform and opacity animate."
  log "  A genuine exception may carry a 'slop-allow' comment with a reason."
  log ""
  exit 1
fi
