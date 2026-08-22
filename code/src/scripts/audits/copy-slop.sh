#!/usr/bin/env bash
#
# copy-slop.sh: the PROSE half of the AI-slop audit. Checks the machine-checkable
#               brand-voice clauses of Section 4 — the copy tells the visual-design
#               doctrine marks `[gate: prose]` and hands to this leg — at two tiers:
#                 [gate: fail]  an unambiguous match. Exit 1, blocks
#                 [gate: warn]  a threshold, a ratio, or a word that is sometimes
#                               correct English. Reported, exit stays 0
#               A threshold on vocabulary fails correct work, which is why it warns
#               rather than blocks: a script does not overrule a writer.
#
# Clauses, and the tier each is checked at:
#
#   [gate: fail]  ellipsis-triple-dot     Section 4 Punctuation. A dot-dot-dot for drama.
#                                         Only the ASCII form is flagged: U+2026 (…)
#                                         is correct typography, and a loading state
#                                         is the one sanctioned use, so it carries a
#                                         `slop-allow` note.
#                 not-just-but            Section 4 Sentence patterns. "not just X, but Y" —
#                                         the single most recognisable machine cadence
#                                         in English. Both halves are required, inside
#                                         one sentence.
#                 scene-setting-opener    Section 4 Sentence patterns. "in today's fast-paced
#                                         world" and its near neighbours. Start at the
#                                         point.
#                 not-about-its-about     Section 4 Sentence patterns. "It's not about X.
#                                         It's about Y." Both halves are required.
#                 rhetorical-opener       Section 4 Sentence patterns. A NAMED phrase list, in
#                                         opener position only. The category "any
#                                         rhetorical question" stays [judgement], exactly
#                                         as "any scene-setting opener" does — a question
#                                         as a heading is CORRECT in the support register
#                                         ("How do I reset my password?"). "Ready to …?"
#                                         is deliberately absent: it is a legitimate CTA.
#
#   [gate: warn]  exclamation-count       Section 4 Punctuation. At most one per surface, and
#                                         a file is this script's proxy for a surface.
#                                         A COUNT, so it warns: the second one may be
#                                         the genuine celebration.
#                 superlative             Section 4 Vocabulary. The named unearned superlatives.
#                                         WARNS, never fails: "a robust seal" is correct
#                                         English, and only a reader knows whether the
#                                         claim was earned or merely asserted.
#                 corporate-verb          Section 4 Vocabulary. The named corporate verbs. Warns
#                                         for the same reason — an account really can be
#                                         unlocked.
#                 hedging-stack           Section 4 Vocabulary. Two or more hedges inside a
#                                         four-word window ("may potentially be able to").
#                                         The weakest tell of the set — stacked modals are
#                                         a bad-writing signature more than a machine one,
#                                         and cautious copy is sometimes correct — so it
#                                         warns and is freely silenced.
#
# NOT owned here, deliberately:
#   - The em dash belongs to the audit written for it alone, and stays there. This script
#     never looks at one.
#   - Bold applied to a whole sentence, though it is a real tell: its input is MARKUP,
#     so it belongs to the markup half of this family by the input-language split.
#   - Every [judgement] clause in Section 4, because each needs the MEANING of the surrounding
#     copy and no grep has that: the tricolon whose third item is filler, the rhetorical
#     question as a CATEGORY (only the named phrases above are gated), a heading that
#     restates the sentence beneath it, and a summary paragraph that repeats what the
#     reader just read. A clean run here does not mean those were honoured — it means no
#     script was ever going to be the thing that checked them.
#
# SCOPE, AND THE ONE THING THIS MUST NEVER SCAN. The brand voice governs copy a USER
# READS. It does NOT govern instructional documentation, code comments, commit messages or
# decision records, which are engineering prose. Pointing this script at `**/*.md` would
# fight this repository's own guides and fail on them — so the scan is the two marketing
# directories and nothing else:
#   code/src/django/apps/marketing/pagedata   (*.py  — page copy modules)
#   code/src/django/templates/marketing       (*.html — marketing templates)
# The other registers Section 4 names (product UI, notifications, support articles) have no home
# in the tree at baseline. When one gets a home, it is added to SCOPES here, not assumed.
#
# THE TEMPLATE SCOPE IS templates/marketing/, NOT apps/marketing/templates/. Django's APP_DIRS
# loader would find either, so both are plausible and only one is what this project builds:
# `code/src/scripts/development/new-django-view.sh` writes the page template there, and
# `code/src/django/templates/CONTEXT.md` and `code/docs/FRONTEND-CODING-PRINCIPLES.md` name
# that same directory. A fourth source is weaker than it looks and is quoted as what it is:
# `project-management/workflows/21-frontend-code/STEPS.md` puts every template under
# `code/src/django/templates/`, which corroborates the direction — not under the app —
# without naming the marketing subdirectory at all.
#
# The scope directory is written in plain prose everywhere it appears — the block above and
# SCOPES below — and never in backticks. It is a path a project builds, and it holds no row
# in `how-to/src/PROJECT-PATHS.md`, so citing it would be a promise nobody has undertaken
# (`code/docs/FORWARD-VOICE.md`). The scope was `apps/marketing/templates` until
# 20/08/2026 — a directory the file collector skips in silence, so this leg would have
# gone on reporting clean having read nothing even in a fully built project. Rule:
# `code/docs/GATE-REPORTING.md`.
#
# ONLY RENDERED COPY IS READ, never the code around it. In a `.py` module the scan sees
# string literals and nothing else, so `unlock_account` is not a corporate verb and a `#`
# comment is not copy. In a template it sees text nodes plus a closed set of user-visible
# attributes (alt, title, placeholder, aria-label, content), never class names, URLs,
# `{% tags %}`, `{{ variables }}`, `{# comments #}`, or the contents of pre/code/script/
# style/verbatim. That narrowing is the "scope the scan narrowly" rule: a sibling audit in
# this folder flagged 34 issues on its first draft, 33 of them false.
#
# NO-OP WHEN ABSENT, AND IT NAMES WHICH ABSENCE. Neither scope exists at template baseline,
# so the script exits 0 with a note rather than failing, which is what lets it run
# unconditionally in CI. A --output run still writes a clean, zero-finding report on that
# path, so a consumer told to collect the report file always finds it.
#
# A zero file count means TWO different things and only the scope separates them. Unscoped it
# is the absent copy surface, and "this project has not written any user-facing copy yet" is a
# fact the run established. Under --path it is the caller's own path, and all the run
# established is that the path holds no file of a type this audit reads — it never opened the
# copy surface at all. Until 22/08/2026 both printed the project sentence, so `--path` over any
# directory of documentation returned a confident claim about a population that run had never
# looked at: GATE-REPORTING.md Section 1 at the smaller scale, in the script that was the model
# for the same fix in copy-emdash.sh. Both channels branch, the printed lines and SURFACE_NOTE
# alike, because a CI consumer parses the second and never sees the first.
#
# ESCAPE HATCH, and what actually scopes it. Put `slop-allow` in a comment on the offending
# line or the line above, with a reason:
#
#   slop-allow: ellipsis-triple-dot — a loading state, the one Section 4 exception
#   slop-allow: superlative, corporate-verb — quoting the client's own product name
#   slop-allow                                — every clause on this line (blunt; prefer the above)
#
# NAME THE CLAUSE. A bare marker silences everything on the line, including a tell nobody
# looked at; a qualified one silences exactly what was argued for and lets the next one
# through. Both forms work, because the bare form shipped first and annotations already
# written must keep meaning what they meant.
#
# It applies at BOTH TIERS, and the reason is not the tier — it is whether the finding has a
# line to annotate. A warning a writer deliberately earned ("a robust seal") is exactly the
# case an annotation exists for. What cannot be annotated is `exclamation-count`, which is a
# per-file count and names no line; that, not the tier, is the real boundary.
#
# Usage: copy-slop.sh [--output FORMAT] [--output-file PATH] [--quiet] [--path PATH]
#                     [--help]
#
# Exit codes:  0 = clean, or warnings only, or surface absent
#              1 = one or more [gate: fail] clauses matched
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# Each entry: "<dir>:<glob>" — the two marketing copy surfaces, and nothing else.
SCOPES=(
  "code/src/django/apps/marketing/pagedata:*.py"
  "code/src/django/templates/marketing:*.html"
)

# At most one exclamation mark per surface. One file is this script's proxy for a surface.
MAX_EXCLAMATIONS=1

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

# Report state. Initialised here because the absent-surface exit writes a report before
# the scan has had a chance to set any of them.
SURFACE_ABSENT=false
SURFACE_NOTE=""
FILE_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0
FAIL_BODY=""
WARN_BODY=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'copy-slop.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
copy-slop.sh: the prose half of the AI-slop audit (how-to/src/BRAND-VOICE.md Section 4)

Usage:
  copy-slop.sh                     Scan marketing pagedata (*.py) + templates (*.html)
  copy-slop.sh --output md         Also write a report
  copy-slop.sh --path DIR          Restrict the scan to a file or directory

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/copy-slop-report.<FORMAT>)
  --quiet              Suppress terminal output (requires --output)
  --path PATH          Restrict the scan to a file or directory (*.py and *.html only).
                         Normalised to the repo-relative form first, so `.`, a `./`
                         prefix, an absolute path and an interior `..` all name what
                         they look like, and the repository root itself means the
                         unscoped run over the two declared scopes. A path that does
                         not exist, or one outside the repository, is a bad argument
                         and exits 2, never a clean run
  --help               Show this help

Two tiers in one run:
  [gate: fail]  ellipsis-triple-dot · not-just-but · scene-setting-opener
                not-about-its-about · rhetorical-opener
  [gate: warn]  exclamation-count · superlative · corporate-verb · hedging-stack

Only rendered copy is read: string literals in *.py, text nodes plus alt/title/
placeholder/aria-label/content in *.html. Instructional documentation is never
scanned — BRAND-VOICE.md Section 4 governs copy a user reads, not engineering prose.

The em dash belongs to copy-emdash.sh; whole-sentence bold to template-slop.sh (its
input is markup). The [judgement] clauses — filler tricolon, rhetorical questions as a
category, heading restates sentence, summary repeats paragraph — belong to the reviewer.

Annotate a genuine exception with a comment on the line or the line above:

  slop-allow: superlative — the client's registered product name
  slop-allow                — every clause on this line (blunt; prefer naming one)

It works at both tiers. Only `exclamation-count` cannot be annotated: it is a per-file
count and names no line.

Exit codes:  0 = clean, warnings only, or surface absent
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
  OUTPUT_FILE="$REPORTS_DIR/copy-slop-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_FILES=$(mktemp); TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_FILES" "$TMP_HITS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# ── Scope normalisation ───────────────────────────────────────────────────────
# --path is normalised BEFORE it is tested, because the collector below walks the
# filesystem with `find`, which accepts every form of a path as itself — so an -e guard
# that passes is the only thing between the caller and a scope this audit was never written
# over. Measured on 22/08/2026, before this block: `--path .` walked the whole repository,
# reporting "files: 4582" and 1305 [gate: fail] matches, most of them in .venv and none of
# them marketing copy, and `--path /etc` read 3 files out of a system directory and printed
# "No machine-authored prose tell in user-facing copy." Both paths exist; neither is
# user-facing copy. That is the widening the file-type contract closes for extensions,
# arriving instead through the scope. So the repository root resolves to the unscoped run
# over SCOPES rather than to the whole tree, a path resolving outside this repository is a
# bad argument at exit 2, and a `./` prefix, an absolute path (what tab-completion produces)
# and an interior `..` all name what they look like. Resolution is textual rather than
# `realpath`: it adds no dependency and needs no path to exist. It does not follow symlinks,
# so a symlinked route into the tree is refused rather than accepted. The existence test and
# the collector then read the SAME normalised value. Rule: code/docs/GATE-REPORTING.md.
normalise_scope() {   # prints the absolute path with . and .. resolved; empty means /
  local abs seg out=""
  case "$1" in /*) abs="$1" ;; *) abs="$PROJECT_ROOT/$1" ;; esac
  while [[ -n "$abs" ]]; do
    seg="${abs%%/*}"
    if [[ "$abs" == */* ]]; then abs="${abs#*/}"; else abs=""; fi
    case "$seg" in
      ''|.) ;;
      ..)   out="${out%/*}" ;;
      *)    out="$out/$seg" ;;
    esac
  done
  printf '%s' "$out"
}

RAW_PATH=""
if [[ -n "$TARGET_PATH" ]]; then
  RAW_PATH="$TARGET_PATH"
  ABS_PATH="$(normalise_scope "$RAW_PATH")"
  if [[ "$ABS_PATH" == "$PROJECT_ROOT" ]]; then
    TARGET_PATH=""                                   # the root: the declared scopes, unscoped
  elif [[ "$ABS_PATH" == "$PROJECT_ROOT"/* ]]; then
    TARGET_PATH="${ABS_PATH#"$PROJECT_ROOT"/}"
  else
    die "--path '$RAW_PATH' resolves to '${ABS_PATH:-/}', outside $PROJECT_ROOT"
  fi
fi
READ_AS=""
[[ "$RAW_PATH" == "$TARGET_PATH" ]] || READ_AS=" (read as '$TARGET_PATH')"
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] || die "--path '$RAW_PATH' does not exist$READ_AS"

# ── File collection ───────────────────────────────────────────────────────────
# With --path the extension still decides how a file is read, because the two parsers
# are not interchangeable. Anything that is neither *.py nor *.html is skipped rather
# than guessed at.
declare -a ROOTS=()
: > "$TMP_FILES"
if [[ -n "$TARGET_PATH" ]]; then
  ROOTS=("$TARGET_PATH")
  if [[ -d "$TARGET_PATH" ]]; then
    find "$TARGET_PATH" -type f \( -name '*.py' -o -name '*.html' \) -print0 >> "$TMP_FILES" || true
  else
    case "$TARGET_PATH" in
      *.py|*.html) printf '%s\0' "$TARGET_PATH" >> "$TMP_FILES" ;;
    esac
  fi
else
  for entry in "${SCOPES[@]}"; do
    dir="${entry%%:*}"; glob="${entry##*:}"
    ROOTS+=("$dir")
    [[ -d "$dir" ]] || continue
    find "$dir" -type f -name "$glob" -print0 >> "$TMP_FILES" || true
  done
fi

FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

# ── Report output ─────────────────────────────────────────────────────────────
# Defined above the absent-surface exit, because a CI job told to collect
# reports/copy-slop-report.<FORMAT> must always find the file. An absent surface writes
# a clean, zero-finding report naming the reason rather than exiting 0 with nothing on
# disk, which under `--quiet --output json` would leave the consumer no signal at all.
#
# Every format carries the scope, for the reason in the header: a zero file count means two
# different things, and a consumer parsing the report never sees the terminal lines that say
# which of them this run found.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  local status
  if $SURFACE_ABSENT; then
    # The status field is machine-read too, so it separates the two empty populations as the
    # note does. "Surface absent" under --path would be the project-level claim again, in the
    # one field a consumer reads first.
    if [[ -n "$TARGET_PATH" ]]; then
      status="✓ scope empty, no file of a type this audit reads"
    else
      status="✓ surface absent, nothing to check"
    fi
  elif [[ "$FAIL_COUNT" -eq 0 ]]; then
    status="✓ no blocking clause ($WARN_COUNT warning(s))"
  else
    status="✗ $FAIL_COUNT blocking clause match(es)"
  fi

  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'copy-slop audit · %s\n' "$TIMESTAMP"
        printf 'scope=%s\n' "${TARGET_PATH:-(the declared scopes)}"
        printf 'files=%s fail=%s warn=%s\n' "$FILE_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        printf 'status: %s\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        printf '\n[gate: fail]\n%s\n\n' "${FAIL_BODY:-None.}"
        printf '[gate: warn]\n%s\n' "${WARN_BODY:-None.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Copy Slop Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Scope** | %s |\n' "${TARGET_PATH:-the declared scopes}"
        printf '| **Files scanned** | %s |\n' "$FILE_COUNT"
        printf '| **Blocking (gate: fail)** | %s |\n' "$FAIL_COUNT"
        printf '| **Advisory (gate: warn)** | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$status"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        printf '## Blocking\n\n'
        if [[ "$FAIL_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n\n' "$FAIL_BODY"
        else printf '_None._\n\n'; fi
        printf '## Advisory\n\n'
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$WARN_BODY"
        else printf '_None._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "copy-slop",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "scope": "%s",\n' "$(json_escape "${TARGET_PATH:-}")"
        printf '  "surface_present": %s,\n' "$($SURFACE_ABSENT && echo false || echo true)"
        printf '  "files": %s,\n  "fail": %s,\n  "warn": %s,\n' "$FILE_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac

  log "  Report written → $OUTPUT_FILE"
  log ""
  return 0
}

# ── No-op when the copy surface is absent ─────────────────────────────────────
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SURFACE_ABSENT=true
  # Name WHICH empty population this is — see the header. The project sentence is a claim
  # about the copy surface and belongs only to the run that looked at it.
  log ""
  bold "▸ copy-slop.sh · $TIMESTAMP"
  if [[ -n "$TARGET_PATH" ]]; then
    SURFACE_NOTE="Scope empty: --path ${ROOTS[*]} holds no *.py or *.html, so no clause could match and this run is clean by definition rather than by inspection. It says nothing about the project's copy surface, which this run did not look at."
    log "  no *.py or *.html under: ${ROOTS[*]}"
    log "  --path holds no file of a type this audit reads."
  else
    SURFACE_NOTE="Surface absent: no marketing copy module or template was found under ${ROOTS[*]}, so no clause could match and this run is clean by definition."
    log "  no *.py or *.html under: ${ROOTS[*]}"
    log "  This project has not written any user-facing copy yet."
  fi
  log ""
  write_report
  bold "✓ Nothing to check."
  log ""
  exit 0
fi

log ""
bold "▸ copy-slop.sh · $TIMESTAMP"
log "  scopes: ${ROOTS[*]}"
log "  files:  $FILE_COUNT"
log ""

# ── The scan ──────────────────────────────────────────────────────────────────
# Emits "file TAB line TAB tier TAB clause TAB text" per finding. Two stages per file:
# extract the rendered copy (MODE decides which parser), then match the clauses against
# it. Regexes are POSIX ERE — awk has neither \b nor PCRE escapes, so word boundaries
# are spelt out as (^|[^a-z]), and intervals are written as optional groups so the
# patterns hold on any awk. A bad pattern aborts awk mid-file, which would report a
# FALSE CLEAN, so every scan failure is fatal.
: > "$TMP_HITS"
while IFS= read -r -d '' f; do
  case "$f" in
    *.py)   mode=py ;;
    *.html) mode=html ;;
    *)      continue ;;
  esac

  awk -v FILE="$f" -v MODE="$mode" -v MAXEXCL="$MAX_EXCLAMATIONS" -v Q="'" '
    # ── Rendered-copy extraction: Python ──────────────────────────────────────
    # String literals only. Everything else in the file is code, and code is not copy:
    # scanning it would make `unlock_account` a corporate verb. Triple-quoted strings
    # carry across lines via the file-scoped `intriple`.
    function py_text(s,   out, i, n, ch, q) {
      out = ""; n = length(s); i = 1
      while (i <= n) {
        if (intriple != "") {
          if (substr(s, i, 3) == intriple) { intriple = ""; i += 3; gapcode = 0 }
          else { out = out substr(s, i, 1); i++ }
          continue
        }
        ch = substr(s, i, 1)
        if (ch == "#") return out                       # a comment is not copy
        if (substr(s, i, 3) == TQD || substr(s, i, 3) == TQS) {
          out = out (gapcode ? SEP : " "); gapcode = 0
          intriple = substr(s, i, 3); i += 3; continue
        }
        if (ch == "\"" || ch == Q) {
          # WHAT SEPARATES TWO LITERALS DECIDES WHETHER THEY ARE ONE SENTENCE. Only
          # whitespace between them is implicit concatenation — ("Not just fast, "
          # "but correct.") is one sentence a copywriter wrapped. Any code between them
          # (a comma in a list, a colon in a dict) makes them separate fields, and
          # joining those invents a tell nobody wrote.
          out = out (gapcode ? SEP : " "); gapcode = 0
          q = ch; i++
          while (i <= n) {
            ch = substr(s, i, 1)
            if (ch == "\\") { i += 2; continue }        # \" and \\ stay inside
            if (ch == q) { i++; break }
            out = out ch; i++
          }
          continue
        }
        if (ch != " " && ch != "\t") gapcode = 1
        i++
      }
      return out
    }

    # ── Rendered-copy extraction: Django templates ────────────────────────────
    # Drop every region whose contents are not read by a user, then keep text nodes
    # plus the closed set of user-visible attributes. `skip_end` carries an
    # unterminated region to the next line, so a multi-line comment never leaks.
    function strip_regions(s,   res, i, p, best, bo, bc) {
      res = ""
      while (length(s) > 0) {
        if (skip_end != "") {
          p = index(s, skip_end)
          if (p == 0) return res
          s = substr(s, p + length(skip_end)); skip_end = ""
          continue
        }
        best = 0; bo = ""; bc = ""
        for (i = 1; i <= NOPEN; i++) {
          p = index(s, OPENER[i])
          if (p > 0 && (best == 0 || p < best)) { best = p; bo = OPENER[i]; bc = CLOSER[i] }
        }
        if (best == 0) return res s
        res = res substr(s, 1, best - 1)
        s = substr(s, best + length(bo)); skip_end = bc
      }
      return res
    }

    # alt, title, placeholder, aria-label and content are the attributes a user reads.
    # Every other attribute value (class, href, id, data-*) is machinery.
    function attrs_of(tb,   res, t, q, p) {
      res = ""; t = tb
      while (match(t, ATTR_RE)) {
        q = substr(t, RSTART + RLENGTH - 1, 1)
        t = substr(t, RSTART + RLENGTH)
        p = index(t, q)
        if (p == 0) { res = res " " t; break }
        res = res " " substr(t, 1, p - 1)
        t = substr(t, p + 1)
      }
      return res
    }

    function html_text(s,   out, n, seg, i, p, tb) {
      s = strip_regions(s)
      gsub(/\{\{[^}]*\}\}/, " ", s)      # a variable is not template-authored copy
      gsub(/\{%[^%]*%\}/, " ", s)        # nor is a tag
      out = ""
      if (pending != "") {               # a tag left open on a previous line
        p = index(s, ">")
        if (p == 0) { pending = pending " " s; return "" }
        out = out SEP attrs_of(pending " " substr(s, 1, p - 1))
        pending = ""; s = substr(s, p + 1)
      }
      # No separator before seg[1]: the start of a line CONTINUES whatever element was
      # open, so a sentence wrapped inside one <p> must stay one sentence. Real element
      # boundaries are the SEPs emitted per tag below.
      n = split(s, seg, "<")
      out = out seg[1]
      for (i = 2; i <= n; i++) {
        p = index(seg[i], ">")
        if (p == 0) { pending = seg[i]; break }
        tb = substr(seg[i], 1, p - 1)
        out = out SEP attrs_of(tb) SEP substr(seg[i], p + 1)
      }
      return out
    }

    # ── Normalisation ─────────────────────────────────────────────────────────
    # Lower-cased, curly apostrophes and their entities folded to ASCII, whitespace
    # collapsed. Without the fold, "it’s not about" walks straight past a pattern
    # written with a straight quote — which is exactly what a copywriter types.
    function normalise(r) {
      r = tolower(r)
      gsub(/&#39;|&#8217;|&rsquo;|&apos;/, Q, r)
      gsub(/’/, Q, r)
      gsub(/[ \t]+/, " ", r)
      sub(/^ /, "", r); sub(/ $/, "", r)
      return r
    }

    function snippet(s) {
      gsub(/\t/, " ", s); gsub(SEP, " ", s); gsub(/  +/, " ", s)
      sub(/^ /, "", s)
      if (length(s) > 88) s = substr(s, 1, 85) "..."
      return s
    }

    # ── The escape hatch, scoped per clause ───────────────────────────────────
    # Returns "" (no marker), "*" (bare marker: everything on this line) or a
    # space-delimited list of clause names. A reason may follow and is ignored — it is
    # there for the human reading the diff, which is the only reader that needs it.
    function allow_spec(s,   p, t) {
      p = index(s, "slop-allow")
      if (p == 0) return ""
      t = substr(s, p + 10)
      sub(/^[ \t]*/, "", t)
      if (substr(t, 1, 1) != ":") return "*"
      t = substr(t, 2)
      gsub(/[,;\t]/, " ", t)
      return " " t " "
    }

    function silenced(clause) {
      if (SPEC_A == "*" || SPEC_B == "*") return 1
      if (SPEC_A != "" && index(SPEC_A, " " clause " ") > 0) return 1
      if (SPEC_B != "" && index(SPEC_B, " " clause " ") > 0) return 1
      return 0
    }

    function emit(tier, clause, ln, text) {
      if (silenced(clause)) return
      printf "%s\t%d\t%s\t%s\t%s\n", FILE, ln, tier, clause, snippet(text)
    }

    # Report WHICH word tripped a vocabulary clause, not merely that one did — a
    # reviewer fixing copy needs the word, and a line of marketing copy is long.
    function vocab(tier, clause, ln, t, re,   rest, w, seen) {
      rest = t
      while (match(rest, re)) {
        w = substr(rest, RSTART, RLENGTH)
        rest = substr(rest, RSTART + RLENGTH)
        gsub(/^[^a-z]+|[^a-z-]+$/, "", w)
        if (w == "" || (w in seen)) continue
        seen[w] = 1
        emit(tier, clause, ln, "\"" w "\" · " t)
      }
    }

    function is_hedge(w) {
      return (w == "may" || w == "might" || w == "could" || w == "potentially" \
              || w == "possibly" || w == "perhaps" || w == "arguably" \
              || w == "seemingly" || w == "somewhat" || w == "generally" \
              || w == "typically" || w == "probably")
    }

    # Two hedges inside a four-word window. One hedge is a choice; two stacked is the
    # tell, and the window is what separates "may potentially" from a modal in this
    # sentence and another in the next one.
    function hedge_stack(t,   n, w, i, k, toks, last) {
      n = split(t, w, /[^a-z]+/)
      k = 0
      for (i = 1; i <= n; i++) if (w[i] != "") toks[++k] = w[i]
      last = -99
      for (i = 1; i <= k; i++) {
        if (is_hedge(toks[i])) {
          if (i - last <= HEDGE_WINDOW) return 1
          last = i
        }
      }
      return 0
    }

    BEGIN {
      TQD = "\"\"\""; TQS = Q Q Q
      intriple = ""; skip_end = ""; pending = ""

      # A unit separator marks where one string literal, attribute or text node ended and
      # the next began. Without it two unrelated fields — "a": "it is not about speed" and
      # "b": "it is about depth" — read as one sentence and the audit invents a tell that
      # nobody wrote. Sentence patterns treat it as a hard boundary; the reporter strips it.
      SEP = sprintf("%c", 2)
      NB  = "[^.!?" SEP "]"          # "within one sentence, and within one literal"
      NX  = "[^a-z" SEP "]"          # a gap between words that is not a field boundary
      HEDGE_WINDOW = 4

      NOPEN = 0
      OPENER[++NOPEN] = "<!--";              CLOSER[NOPEN] = "-->"
      OPENER[++NOPEN] = "{#";                CLOSER[NOPEN] = "#}"
      OPENER[++NOPEN] = "{% comment %}";     CLOSER[NOPEN] = "{% endcomment %}"
      OPENER[++NOPEN] = "{% verbatim %}";    CLOSER[NOPEN] = "{% endverbatim %}"
      OPENER[++NOPEN] = "<pre";              CLOSER[NOPEN] = "</pre>"
      OPENER[++NOPEN] = "<code";             CLOSER[NOPEN] = "</code>"
      OPENER[++NOPEN] = "<script";           CLOSER[NOPEN] = "</script>"
      OPENER[++NOPEN] = "<style";            CLOSER[NOPEN] = "</style>"

      ATTR_RE = "(^|[^a-zA-Z-])(alt|title|placeholder|aria-label|content)[ \t]*=[ \t]*(\"|" Q ")"

      B = "(^|[^a-z])"; E = "([^a-z]|$)"
      # Both halves required, inside one sentence: [^.!?]* cannot cross a full stop,
      # so "This is not just a demo. But it ships." is correctly left alone.
      NOTJUST_ANCHOR = B "not just" E
      NOTJUST        = B "not just" NB "*" NX "but" E
      # "in today s <up to two words> world". A comma breaks it, so "In today s
      # release, the world map is updated" is not a match.
      SCENE          = B "in today" Q "s ([a-z-]+ )?([a-z-]+ )?world" E
      NOTABOUT_ANCHOR = B "(it" Q "s|it is) not about" E
      NOTABOUT        = B "(it" Q "s|it is) not about" NB "*[.!?]" NX "*(it" Q "s|it is) about" E
      # A NAMED list, in opener position only — the start of the text, or just after a
      # sentence end or a literal boundary. The category "any rhetorical question" is
      # [judgement] and stays there: "How do I reset my password?" is a correct support
      # heading. "Ready to …?" is deliberately absent — it is a legitimate CTA.
      RHETORICAL     = "(^|[.!?" SEP "]) *(ever wondered|have you ever|what if i told you" \
                       "|sound familiar|tired of)" E
      SUPER = B "(seamless(ly)?|effortless(ly)?|powerful(ly)?|robust(ly|ness)?" \
              "|cutting-edge|world-class|revolutionary|game-changing|unparalleled)" E
      CORP  = B "(leverag(e|es|ed|ing)|utilis(e|es|ed|ing|ation)|utiliz(e|es|ed|ing|ation)" \
              "|empower(s|ed|ing|ment)?|unlock(s|ed|ing)?|elevat(e|es|ed|ing|ion)" \
              "|streamlin(e|es|ed|ing)|delv(e|es|ed|ing))" E
    }

    { line[NR] = $0 }

    END {
      for (i = 1; i <= NR; i++)
        norm[i] = normalise((MODE == "py") ? py_text(line[i]) : html_text(line[i]))

      excl = 0
      for (i = 1; i <= NR; i++) {
        t = norm[i]
        if (t !~ /[a-z]/) continue     # separators and punctuation are not copy

        c = t; excl += gsub(/!/, "!", c)

        # The annotation is read from the SOURCE line, not the rendered copy — it lives in
        # a comment, which the extractor has already thrown away by design.
        SPEC_A = allow_spec(line[i])
        SPEC_B = (i > 1) ? allow_spec(line[i-1]) : ""

        # A window of this line plus the next carries a construction that a copywriter
        # split across two source lines. The clause fires on the line holding its FIRST
        # half, so the window never double-reports.
        win = t " " ((i < NR) ? norm[i+1] : "")

        if (t ~ /\.\.\./)
          emit("fail", "ellipsis-triple-dot", i, t)
        if (t ~ NOTJUST_ANCHOR && win ~ NOTJUST)
          emit("fail", "not-just-but", i, t)
        if (t ~ SCENE)
          emit("fail", "scene-setting-opener", i, t)
        if (t ~ NOTABOUT_ANCHOR && win ~ NOTABOUT)
          emit("fail", "not-about-its-about", i, t)
        if (t ~ RHETORICAL)
          emit("fail", "rhetorical-opener", i, t)

        vocab("warn", "superlative", i, t, SUPER)
        vocab("warn", "corporate-verb", i, t, CORP)
        if (hedge_stack(t))
          emit("warn", "hedging-stack", i, t)
      }

      # A count has no line to point at, so it is reported against the file — and takes a
      # FILE-scoped annotation to match: `slop-allow: exclamation-count` anywhere in the
      # file silences it. A bare marker deliberately does not reach it, because bare is
      # line-scoped and this finding has no line to have been written on.
      SPEC_A = ""; SPEC_B = ""
      for (i = 1; i <= NR; i++) {
        sp = allow_spec(line[i])
        if (sp != "" && sp != "*" && index(sp, " exclamation-count ") > 0) SPEC_B = sp
      }
      if (excl > MAXEXCL)
        emit("warn", "exclamation-count", 0,
             excl " exclamation mark(s) in this surface; at most " MAXEXCL " (BRAND-VOICE.md Section 4)")
    }
  ' "$f" >> "$TMP_HITS" || die "awk failed scanning $f"
done < "$TMP_FILES"

# ── Tally ─────────────────────────────────────────────────────────────────────
FAIL_COUNT=$(awk -F'\t' '$3 == "fail"' "$TMP_HITS" | grep -c . || true)
FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(awk -F'\t' '$3 == "warn"' "$TMP_HITS" | grep -c . || true)
WARN_COUNT=${WARN_COUNT:-0}

render() {
  awk -F'\t' -v tier="$1" '
    $3 == tier {
      loc = ($2 + 0 > 0) ? $1 ":" $2 : $1
      printf "%-46s %-22s %s\n", loc, $4, $5
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
fi

# ── Report output ─────────────────────────────────────────────────────────────
write_report

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$FAIL_COUNT" -eq 0 ]]; then
  if [[ "$WARN_COUNT" -eq 0 ]]; then
    bold "✓ No machine-authored prose tell in user-facing copy."
  else
    bold "✓ No blocking clause. $WARN_COUNT warning(s) for a reviewer to judge."
    log "  A superlative or a corporate verb is sometimes the right word; a count is not"
    log "  a verdict. Read them against BRAND-VOICE.md Section 4 and decide."
  fi
  log ""
  exit 0
else
  bold "✗ $FAIL_COUNT blocking clause match(es). See how-to/src/BRAND-VOICE.md Section 4."
  log "  Reword rather than soften: start at the point, drop the cadence, state the fact."
  log "  A genuine exception (a loading state, say) may carry a 'slop-allow' comment"
  log "  with a reason."
  log ""
  exit 1
fi
