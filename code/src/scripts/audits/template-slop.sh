#!/usr/bin/env bash
#
# template-slop.sh: the MARKUP half of the AI-slop audit. Checks the three
#                   VISUAL-DESIGN.md Section 4.1 clauses whose input is Django template
#                   markup, at the two tiers Section 6 defines:
#                     [gate: fail]  an unambiguous match. Exit 1, blocks
#                     [gate: warn]  a threshold or a ratio. Reported, exit stays 0
#                   Tier scheme and its rationale: VISUAL-DESIGN.md Section 6.
#
# Clauses, and the tier each is checked at:
#
#   [gate: fail]  emoji-in-chrome
#                 An emoji in a heading or in UI chrome. Icons are to come from the
#                 project's single icon set, to be delivered by the {% icon %} tag (the
#                 rule is VISUAL-DESIGN.md doctrine; neither the tag nor any template
#                 exists at baseline), so an emoji glyph standing in for an icon is an
#                 unambiguous match. Chrome is a NAMED,
#                 CLOSED element set (below) rather than "the whole template": an
#                 emoji in body prose is not what Section 4.1 bans, and flagging it would be
#                 a false positive.
#
#   [gate: warn]  pill-above-heading
#                 A pill/eyebrow above every heading. Pills label taxonomy; a pill on
#                 a plain section is filler. This is a RATIO, so it warns and never
#                 fails: a taxonomy page legitimately pills every section.
#
#   [gate: warn]  undifferentiated-buttons
#                 No primary/secondary hierarchy, or ghost buttons everywhere. Also a
#                 ratio, and warned for the same reason.
#
#   [gate: warn]  bold-whole-sentence
#                 BRAND-VOICE.md Section 4 Structure: bold the term, not the thought. Bolding
#                 whole sentences is one of the most recognisable machine-authored
#                 signatures. It lives HERE and not in copy-slop.sh because its input is
#                 markup — <strong>/<b> — which is the same input-language split that put
#                 the desktop leg in desktop/style-check.sh. It warns because a bolded
#                 lede is a real editorial device, and only a reader knows which this is.
#                 Fires when a bolded run runs to 8+ words, or carries sentence-ending
#                 punctuation across 4+ words.
#
# NOT owned here, deliberately: the inline-gradient tell is css-gradients.sh's, the
# phantom-token check is css-tokens.sh's, and the copy tells (em dash, filler copy)
# are copy-emdash.sh's and the brand-voice guide's. Every [judgement] clause belongs
# to the reviewer and no script decides one. `undifferentiated-buttons` is the one
# clause with two inputs: css-slop.sh judges it from the STYLESHEET (variant rules
# that do not exist), this script from the MARKUP (buttons used without a variant).
# One clause name, two halves, neither able to see the other's evidence.
#
# Scopes scanned (*.html only):
#   code/src/django/templates    (project template directory)
#   code/src/django/components   (co-located django-component templates)
#
# NO-OP WHEN ABSENT. The surface is empty at template baseline (no templates and no
# components exist until the first feature builds them), so the script exits 0 with a
# note rather than failing. That is what lets it run unconditionally in CI, and it
# mirrors mobile-tokens.sh on a web-only project. A --output run still writes a clean,
# zero-finding report on that path, so a consumer that runs the audit and then reads
# the report file never finds it missing.
#
# Chrome element set (deliberately closed and narrow): h1 h2 h3 h4 h5 h6, button,
# label, summary, legend, th, caption, nav, title. An emoji counts only when it sits
# in the RENDERED TEXT inside one of those, so an emoji in an attribute value, in an
# HTML comment, in a {# #} or {% comment %} block, or inside <pre>/<code>/<script>/
# <style>/{% verbatim %} (a code sample) is never flagged. <a> is not chrome on its
# own (a body link is not UI chrome), but a link inside <nav> is covered by nav.
#
# ESCAPE HATCH, scoped by whether the finding has a line — not by tier:
#
#   slop-allow: emoji-in-chrome — the flag is the content, not an icon
#   slop-allow                   — every line clause here (blunt; prefer naming one)
#
# on the offending line or the line above, with a reason. `bold-whole-sentence` is
# annotated on the line the <strong> OPENS, which is where a person would write it.
#
# The two RATIOS are different: silencing one pilled heading would not change the ratio
# that produced the finding, so they take a FILE-scoped annotation instead — put
# `slop-allow: pill-above-heading` (or `undifferentiated-buttons`) anywhere in the file,
# with a reason. A taxonomy page legitimately pills every section, and that is a fact
# about the page, not about a line. A bare marker deliberately does not reach them.
#
# Usage: template-slop.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                         [--path PATH] [--help]
#
# Exit codes:  0 = clean, or warnings only, or surface absent
#              1 = [gate: fail] clause matched
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# The third scope is design-time. See css-slop.sh for why consolidated wireframes join
# this family by input language, and why stage 1 does not.
SCOPES=(
  "code/src/django/templates"
  "code/src/django/components"
  "project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS"
)

# Ratio thresholds. Both are set where a composition choice stops being plausible and
# starts reading as a stamp, and both need a minimum sample so a two-heading component
# is never judged. Neither can fail a run.
MIN_HEADINGS=4      # below this a file has no meaningful pill ratio
PILL_RATIO_PCT=75   # warn when this share of a file's headings carries a pill
MIN_BUTTONS=3       # below this a file has no meaningful hierarchy to show
BOLD_MAX_WORDS=8    # a bolded run this long is a thought, not a term

# UTF-8 byte prefixes for the emoji ranges, matched as raw bytes under LC_ALL=C so no
# locale awareness, PCRE, or awk \x support is assumed:
#   F0 9F          U+1F000–U+1FFFF  the emoji planes
#   E2 98 … E2 9E  U+2600–U+27BF    Misc Symbols + Dingbats
#   E2 AC … E2 AF  U+2B00–U+2BFF    Misc Symbols and Arrows
#   EF B8 8F       U+FE0F           the emoji presentation selector
# Arrows (U+2190–U+21FF), dashes, and curly quotes are deliberately NOT in the set:
# they are typography, not icon substitutes.
EMOJI_BYTES=$'\xf0\x9f,\xe2\x98,\xe2\x99,\xe2\x9a,\xe2\x9b,\xe2\x9c,\xe2\x9d,\xe2\x9e,\xe2\xac,\xe2\xad,\xe2\xae,\xe2\xaf,\xef\xb8\x8f'

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'template-slop.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
template-slop.sh: the markup half of the AI-slop audit (VISUAL-DESIGN.md Section 4.1)

Usage:
  template-slop.sh                 Scan the template and component surfaces
  template-slop.sh --output md     Also write a report
  template-slop.sh --path DIR      Restrict the scan to a file or directory

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/template-slop-report.<FORMAT>)
  --quiet              Suppress terminal output (requires --output)
  --path PATH          Restrict the scan to a file or directory
  --help               Show this help

Clauses:
  [gate: fail]  emoji-in-chrome            emoji in a heading or in UI chrome
  [gate: warn]  pill-above-heading         a pill/eyebrow above (nearly) every heading
  [gate: warn]  undifferentiated-buttons   no primary/secondary hierarchy, or all ghost
  [gate: warn]  bold-whole-sentence        bold the term, not the thought

Warnings never fail the run: a threshold on composition fails correct work (a taxonomy
page legitimately pills every section, and a bolded lede is a real device).

Annotate a deliberate exception with a comment on the same line or the line above:

  slop-allow: emoji-in-chrome — the flag is the content, not an icon
  slop-allow                   — every line clause (blunt; prefer naming one)

The two RATIOS take a FILE-scoped annotation instead, anywhere in the file, because
silencing one line would not change the ratio that produced them:

  slop-allow: pill-above-heading — a taxonomy index; every section is a real category

Exit codes:  0 = clean, warnings only, or surface absent
             1 = [gate: fail] clause matched
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
  OUTPUT_FILE="$REPORTS_DIR/template-slop-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

declare -a ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  ROOTS=("$TARGET_PATH")
else
  ROOTS=("${SCOPES[@]}")
fi

TMP_FILES=$(mktemp); TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_FILES" "$TMP_HITS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

for root in "${ROOTS[@]}"; do
  [[ -e "$root" ]] || continue
  find "$root" -type f -name '*.html' -print0
done > "$TMP_FILES" || true

FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

# ── No-op when the markup surface is absent ───────────────────────────────────
# At template baseline there are no templates and no components yet, so an empty
# surface reports success rather than failing. The first feature that builds a page
# gives this script something to check.
if [[ "$FILE_COUNT" -eq 0 ]]; then
  log ""
  bold "▸ template-slop.sh: $TIMESTAMP"
  log "  no *.html under: ${ROOTS[*]}"
  log "  this project has no template markup yet, so there is nothing to audit."
  log ""

  # The report is written on this path too, and before the exit: a caller that runs the
  # audit and then reads reports/template-slop-report.<FORMAT> must find a well-formed
  # clean result, not a missing file, on a project whose markup surface is still empty.
  if [[ -n "$OUTPUT_FORMAT" ]]; then
    ABSENT_NOTE="surface absent: no *.html under ${ROOTS[*]}"
    case "$OUTPUT_FORMAT" in
      txt)
        { printf 'template-slop audit: %s\n' "$TIMESTAMP"
          printf 'files=0 fail=0 warn=0\n\n'
          printf 'No findings (%s).\n' "$ABSENT_NOTE"; } > "$OUTPUT_FILE" ;;
      md)
        { printf '# Template Slop Audit Report\n\n'
          printf '| | |\n|---|---|\n'
          printf '| **Generated** | %s |\n' "$TIMESTAMP"
          printf '| **Files scanned** | 0 |\n'
          printf '| **Failures (gate: fail)** | 0 |\n'
          printf '| **Warnings (gate: warn)** | 0 |\n'
          printf '| **Status** | ✓ no [gate: fail] clause matched |\n\n'
          printf '_No findings: %s._\n' "$ABSENT_NOTE"; } > "$OUTPUT_FILE" ;;
      json)
        { printf '{\n  "script": "template-slop",\n  "timestamp": "%s",\n' "$TIMESTAMP"
          printf '  "files": 0,\n  "failures": 0,\n  "warnings": 0,\n'
          printf '  "reason": "surface absent",\n'
          printf '  "exit_code": 0\n}\n'; } > "$OUTPUT_FILE" ;;
    esac
    log "  Report written → $OUTPUT_FILE"
    log ""
  fi

  bold "✓ Nothing to check."
  log ""
  exit 0
fi

log ""
bold "▸ template-slop.sh: $TIMESTAMP"
log "  scopes: ${ROOTS[*]}"
log "  files:  $FILE_COUNT"
log ""

# Emit "file<TAB>line<TAB>tier<TAB>clause<TAB>text" per finding. LC_ALL=C keeps awk
# byte-oriented so the emoji needles (partial UTF-8 sequences) match reliably.
: > "$TMP_HITS"
while IFS= read -r -d '' file; do
  LC_ALL=C awk \
    -v FILE="$file" \
    -v NEEDLES="$EMOJI_BYTES" \
    -v MIN_H="$MIN_HEADINGS" \
    -v PILL_PCT="$PILL_RATIO_PCT" \
    -v MIN_B="$MIN_BUTTONS" \
    -v BOLD_MAX="$BOLD_MAX_WORDS" \
    -v Q="'" '
    function has_emoji(t,   i) {
      for (i = 1; i <= NND; i++) if (index(t, ND[i]) > 0) return 1
      return 0
    }

    # Remove every region whose contents are not rendered UI text: comments, verbatim
    # blocks, and code samples. skip_end carries an unterminated region to the next
    # line, so a multi-line comment never leaks markup into the scan.
    function strip_regions(s,   res, i, p, best, bo, bc) {
      res = ""
      while (length(s) > 0) {
        if (skip_end != "") {
          p = index(s, skip_end)
          if (p == 0) return res
          s = substr(s, p + length(skip_end))
          skip_end = ""
          continue
        }
        best = 0; bo = ""; bc = ""
        for (i = 1; i <= NOPEN; i++) {
          p = index(s, OPENER[i])
          if (p > 0 && (best == 0 || p < best)) { best = p; bo = OPENER[i]; bc = CLOSER[i] }
        }
        if (best == 0) return res s
        res = res substr(s, 1, best - 1)
        s = substr(s, best + length(bo))
        skip_end = bc
      }
      return res
    }

    # Adjust the chrome nesting depth for one tag body (the text between < and >).
    function tag_apply(tb,   t, closing, selfc, nm) {
      t = tb
      sub(/^[ \t]+/, "", t)
      closing = 0
      if (substr(t, 1, 1) == "/") { closing = 1; t = substr(t, 2) }
      selfc = (length(tb) > 0 && substr(tb, length(tb), 1) == "/")
      if (!match(t, /^[A-Za-z][A-Za-z0-9]*/)) return
      nm = tolower(substr(t, RSTART, RLENGTH))
      if (!(nm in CHROME)) return
      if (closing) { if (depth > 0) depth-- }
      else if (!selfc) depth++
    }

    # Walk the line, tracking chrome depth, and report whether any RENDERED text
    # (never an attribute value) inside a chrome element carries an emoji.
    function emoji_scan(s,   n, seg, i, p, tb, txt, hit) {
      hit = 0
      if (pending != "") {
        p = index(s, ">")
        if (p == 0) { pending = pending " " s; return 0 }
        tag_apply(pending " " substr(s, 1, p - 1))
        pending = ""
        s = substr(s, p + 1)
      }
      n = split(s, seg, "<")
      if (depth > 0 && has_emoji(seg[1])) hit = 1
      for (i = 2; i <= n; i++) {
        p = index(seg[i], ">")
        if (p == 0) { pending = seg[i]; break }
        tb = substr(seg[i], 1, p - 1)
        txt = substr(seg[i], p + 1)
        tag_apply(tb)
        if (depth > 0 && has_emoji(txt)) hit = 1
      }
      return hit
    }

    function count_headings(s,   c, t) {
      c = 0; t = s
      while (match(t, /<[hH][1-6]([ \t>\/]|$)/)) {
        c++
        t = substr(t, RSTART + RLENGTH)
        if (RLENGTH == 0) break
      }
      return c
    }

    # A pill/eyebrow signal: the component names and class tokens this stack uses for
    # the device. "pill" needs spelt-out word boundaries so "pillar" never matches.
    function is_pill(s,   l) {
      l = tolower(s)
      if (index(l, "eyebrow") > 0) return 1
      if (index(l, "badge") > 0) return 1
      if (l ~ /(^|[^a-z])pill([^a-z]|$)/) return 1
      return 0
    }

    function has_btn_class(tb,   p, rest, q, cls, n, tok, i) {
      p = index(tb, "class=\"")
      if (p == 0) return 0
      rest = substr(tb, p + 7)
      q = index(rest, "\"")
      cls = (q > 0) ? substr(rest, 1, q - 1) : rest
      n = split(tolower(cls), tok, /[ \t]+/)
      for (i = 1; i <= n; i++) {
        if (tok[i] == "btn" || tok[i] == "button") return 1
        if (substr(tok[i], 1, 4) == "btn-" || substr(tok[i], 1, 7) == "button-") {
          if (tok[i] ~ /(group|row|bar|wrap|list|toolbar|container)$/) continue
          return 1
        }
      }
      return 0
    }

    # Only three unambiguous button forms are counted. A <div class="btn-group"> and
    # anything else container-shaped is excluded above, because over-counting buttons
    # is what would turn this warn into noise.
    function count_buttons(s,   c, t, l, p, q, tb) {
      c = 0
      t = s
      while ((p = index(tolower(t), "<button")) > 0) { c++; t = substr(t, p + 7) }
      t = s
      while ((p = index(t, "component \"button\"")) > 0) { c++; t = substr(t, p + 18) }
      t = s
      while ((p = index(tolower(t), "<a ")) > 0) {
        t = substr(t, p + 3)
        q = index(t, ">")
        tb = (q > 0) ? substr(t, 1, q - 1) : t
        if (has_btn_class(tb)) c++
      }
      return c
    }

    function emit(ln, tier, clause, text,   t) {
      t = text
      gsub(/^[ \t]+/, "", t)
      gsub(/[ \t]+$/, "", t)
      gsub(/\t/, " ", t)
      printf "%s\t%d\t%s\t%s\t%s\n", FILE, ln, tier, clause, t
    }

    # ── The escape hatch, scoped per clause ───────────────────────────────────
    # "" no marker · "*" bare marker (every line clause here) · else a space-delimited
    # list of clause names. Any reason after them is for the human reading the diff.
    function allow_spec(s,   p, t) {
      p = index(s, ALLOW)
      if (p == 0) return ""
      t = substr(s, p + length(ALLOW))
      sub(/^[ \t]*/, "", t)
      if (substr(t, 1, 1) != ":") return "*"
      t = substr(t, 2)
      gsub(/[,;\t]/, " ", t)
      return " " t " "
    }

    function silenced_in(a, b, clause) {
      if (a == "*" || b == "*") return 1
      if (a != "" && index(a, " " clause " ") > 0) return 1
      if (b != "" && index(b, " " clause " ") > 0) return 1
      return 0
    }

    # ── [gate: warn] bold-whole-sentence ──────────────────────────────────────
    # Accumulates the text of each <strong>/<b> run, which may span lines, and judges it
    # when the run closes. The annotation is read at the line the run OPENED, because
    # that is where a person writing "this lede is deliberate" would put it.
    function bold_scan(s,   n, seg, i, p, tb, txt, t, nm, closing, selfc) {
      n = split(s, seg, "<")
      if (bdepth > 0) bbuf = bbuf " " seg[1]
      for (i = 2; i <= n; i++) {
        p = index(seg[i], ">")
        if (p == 0) break
        tb = substr(seg[i], 1, p - 1)
        txt = substr(seg[i], p + 1)
        t = tb; sub(/^[ \t]+/, "", t)
        closing = 0
        if (substr(t, 1, 1) == "/") { closing = 1; t = substr(t, 2) }
        selfc = (length(tb) > 0 && substr(tb, length(tb), 1) == "/")
        if (match(t, /^[A-Za-z][A-Za-z0-9]*/)) {
          nm = tolower(substr(t, RSTART, RLENGTH))
          if (nm == "strong" || nm == "b") {
            if (closing) {
              if (bdepth > 0) { bdepth--; if (bdepth == 0) bold_check() }
            } else if (!selfc) {
              if (bdepth == 0) {
                bbuf = ""; bstart = FNR
                bspec_a = allow_spec(raw); bspec_b = allow_spec(prev_raw)
              }
              bdepth++
            }
          }
        }
        if (bdepth > 0) bbuf = bbuf " " txt
      }
    }

    function bold_check(   t, n, w, i, k) {
      t = bbuf
      gsub(/\{\{[^}]*\}\}/, " ", t)      # a variable is not template-authored copy
      gsub(/\{%[^%]*%\}/, " ", t)
      gsub(/[ \t]+/, " ", t)
      sub(/^ /, "", t); sub(/ $/, "", t)
      if (t == "") return
      n = split(t, w, /[ \t]+/)
      k = 0
      for (i = 1; i <= n; i++) if (w[i] != "") k++
      if (k < 4) return                  # a bolded term is short, and that is correct
      if (k >= BOLD_MAX || t ~ /[.!?]/) {
        if (!silenced_in(bspec_a, bspec_b, "bold-whole-sentence"))
          emit(bstart, "warn", "bold-whole-sentence", t)
      }
    }

    BEGIN {
      NND = split(NEEDLES, ND, ",")
      ALLOW = "slop-allow"

      split("h1 h2 h3 h4 h5 h6 button label summary legend th caption nav title", cw, " ")
      for (i in cw) CHROME[cw[i]] = 1

      NOPEN = 0
      OPENER[++NOPEN] = "<!--";              CLOSER[NOPEN] = "-->"
      OPENER[++NOPEN] = "{#";                CLOSER[NOPEN] = "#}"
      OPENER[++NOPEN] = "{% comment %}";     CLOSER[NOPEN] = "{% endcomment %}"
      OPENER[++NOPEN] = "{% verbatim %}";    CLOSER[NOPEN] = "{% endverbatim %}"
      OPENER[++NOPEN] = "<script";           CLOSER[NOPEN] = "</script>"
      OPENER[++NOPEN] = "<style";            CLOSER[NOPEN] = "</style>"
      OPENER[++NOPEN] = "<pre";              CLOSER[NOPEN] = "</pre>"
      OPENER[++NOPEN] = "<code";             CLOSER[NOPEN] = "</code>"

      # A variant token, not the bare word: "primary" in prose must not read as a
      # button hierarchy. Same for the ghost/outline signal.
      PRIM  = "[-_\"" Q "](primary|secondary|tertiary)"
      GHOST = "[-_\"" Q "](ghost|outline)"

      skip_end = ""; pending = ""; depth = 0
      pill_run = 0; nh = 0; np = 0; nb = 0; ghost_hits = 0; prim_hits = 0
      bdepth = 0; bbuf = ""; bstart = 0; bspec_a = ""; bspec_b = ""; FILESPEC = ""
    }

    {
      raw = $0
      s = strip_regions(raw)

      # A qualified marker anywhere in the file reaches the ratio clauses, which have no
      # one line to have been written on. A bare marker stays line-scoped.
      spec = allow_spec(raw)
      if (spec != "" && spec != "*") FILESPEC = FILESPEC spec

      # ── [gate: fail] emoji in a heading or in UI chrome ──
      if (emoji_scan(s)) {
        if (!silenced_in(allow_spec(raw), allow_spec(prev_raw), "emoji-in-chrome"))
          emit(FNR, "fail", "emoji-in-chrome", raw)
      }

      # ── [gate: warn] bold applied to a whole sentence ──
      bold_scan(s)

      # ── [gate: warn] a pill/eyebrow above every heading ──
      pill_here = is_pill(s)
      hcount = count_headings(s)
      if (hcount > 0) {
        for (k = 0; k < hcount; k++) {
          nh++
          hline[nh] = FNR; htext[nh] = raw
          hpill[nh] = (pill_run > 0 || pill_here) ? 1 : 0
          if (hpill[nh]) np++
        }
      }
      # A pill labels ONE heading: the heading below it consumes the window, so a
      # second, genuinely plain heading further down is not counted as pilled too.
      if (hcount > 0) pill_run = 0
      else if (pill_here) pill_run = 3
      else if (s ~ /[^ \t]/ && pill_run > 0) pill_run--

      # ── [gate: warn] undifferentiated buttons ──
      bcount = count_buttons(s)
      if (bcount > 0) {
        for (k = 0; k < bcount; k++) { nb++; bline[nb] = FNR; btext[nb] = raw }
      }
      if (s ~ PRIM)  prim_hits++
      if (s ~ GHOST) ghost_hits++

      prev_raw = raw
    }

    END {
      if (nh >= MIN_H && np * 100 >= nh * PILL_PCT \
          && index(FILESPEC, " pill-above-heading ") == 0) {
        label = sprintf("pill-above-heading [%d/%d]", np, nh)
        for (i = 1; i <= nh; i++)
          if (hpill[i]) emit(hline[i], "warn", label, htext[i])
      }
      if (index(FILESPEC, " undifferentiated-buttons ") == 0 \
          && nb >= MIN_B && (prim_hits == 0 || ghost_hits >= nb)) {
        label = (prim_hits == 0) \
          ? sprintf("undifferentiated-buttons [0 primary/%d]", nb) \
          : sprintf("undifferentiated-buttons [ghost %d/%d]", ghost_hits, nb)
        for (i = 1; i <= nb; i++) emit(bline[i], "warn", label, btext[i])
      }
    }
  ' "$file" >> "$TMP_HITS" || die "awk failed scanning $file"
done < "$TMP_FILES"

FAIL_COUNT=$(awk -F'\t' '$3=="fail"' "$TMP_HITS" | grep -c . || true)
FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(awk -F'\t' '$3=="warn"' "$TMP_HITS" | grep -c . || true)
WARN_COUNT=${WARN_COUNT:-0}

BODY=""
if [[ "$FAIL_COUNT" -gt 0 || "$WARN_COUNT" -gt 0 ]]; then
  BODY=$(awk -F'\t' '{ printf "%-52s %-5s %-38s %s\n", $1 ":" $2, $3, $4, $5 }' "$TMP_HITS")
fi

if ! $QUIET; then
  if [[ "$FAIL_COUNT" -gt 0 ]]; then
    printf '\033[31m  ✗ %d [gate: fail] emoji in a heading or UI chrome. Use an icon, to be delivered by the {%% icon %%} tag\033[0m\n' \
      "$FAIL_COUNT"
    awk -F'\t' '$3=="fail" { printf "    %-52s %-38s %s\n", $1 ":" $2, $4, $5 }' "$TMP_HITS"
    printf '\n'
  fi
  if [[ "$WARN_COUNT" -gt 0 ]]; then
    printf '\033[33m  ⚠ %d [gate: warn] composition ratio(s), reported and not failed\033[0m\n' "$WARN_COUNT"
    awk -F'\t' '$3=="warn" { printf "    %-52s %-38s %s\n", $1 ":" $2, $4, $5 }' "$TMP_HITS"
    printf '\n'
  fi
fi

# ── Report output ─────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$FAIL_COUNT" -eq 0 ]] && echo '✓ no [gate: fail] clause matched' || echo "✗ $FAIL_COUNT [gate: fail] match(es)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'template-slop audit: %s\n' "$TIMESTAMP"
        printf 'files=%s fail=%s warn=%s\n\n' "$FILE_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        printf '%s\n' "${BODY:-No findings.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Template Slop Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files scanned** | %s |\n' "$FILE_COUNT"
        printf '| **Failures (gate: fail)** | %s |\n' "$FAIL_COUNT"
        printf '| **Warnings (gate: warn)** | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ -n "$BODY" ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_No emoji in chrome, no pill stamping, no undifferentiated buttons._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "template-slop",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "files": %s,\n  "failures": %s,\n  "warnings": %s,\n' "$FILE_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$FAIL_COUNT" -gt 0 ]]; then
  bold "✗ $FAIL_COUNT [gate: fail] match(es). Replace the emoji with the project's icon set."
  log "  A deliberate exception may carry a 'slop-allow' comment with a reason."
  log ""
  exit 1
elif [[ "$WARN_COUNT" -gt 0 ]]; then
  bold "⚠ No failures, but $WARN_COUNT composition warning(s) to review."
  log "  Ratios never fail a run: a taxonomy page legitimately pills every section,"
  log "  and only a reviewer can say whether this page is one. See VISUAL-DESIGN.md Section 6."
  log ""
  exit 0
else
  bold "✓ No markup slop: no emoji in chrome, pills and buttons differentiated."
  log ""
  exit 0
fi
