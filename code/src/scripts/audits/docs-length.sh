#!/usr/bin/env bash
#
# docs-length.sh — Enforce the 300-line instructional-document limit.
#
#                  An instructional file is one that tells Claude Code how to work: a
#                  guide, a workflow step, an agent, a skill, or a CONTEXT.md/CLAUDE.md
#                  pair. Past about three hundred lines such a file stops being read and
#                  starts being skimmed, which is the same as not being there. The remedy
#                  is always the same shape: split the detail into a kebab-case sub-folder
#                  and leave the entry point a thin index.
#
#                  This limit is measured in cloc CODE lines — blank lines and HTML
#                  comments do not count against it. That is deliberate: it is a budget on
#                  content, not on formatting, so a table that breathes is not penalised.
#
#                  Why this script exists: cloc.sh enforces the 750/800 limit on SOURCE
#                  files via `wc -l` and passes --exclude-lang=Markdown, so it cannot see
#                  this rule at all. Several guides nonetheless routed the 300-line check
#                  to it, which meant the check silently passed on every run. A gate that
#                  cannot fail is worse than no gate, because it is believed.
#
#                  Rule: .claude/CLAUDE.md § 8 — Instructional file length
#
# Scope scanned:  tracked (and untracked-but-not-ignored) Markdown that instructs:
#                   * every CONTEXT.md and CLAUDE.md, wherever it sits
#                   * **/docs/**/*.md   · **/workflows/**/*.md   · .claude/**/*.md
#                 Exempt, per the same rule:
#                   * root-level *.md          — README, CHANGELOG, GAPS, RELEASES, …
#                   * **/src/*.md              — operator guides, written for a human in full
#                   * vendored trees            — .agents/, code/docs/cloudinary/*_SDK*
#                   * generated                 — project-management/export/
#                   * sandbox and session notes — learning/, research/, handoffs/,
#                                                 questionnaires/
#                 The CONTEXT.md/CLAUDE.md pair inside an exempt tree is still checked:
#                 the pair is ours and instructional wherever it lives.
#
# Usage: docs-length.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                       [--path PATH] [--limit N] [--help]
#
# Exit codes:  0 = every file within the limit (warnings do not fail)
#              1 = one or more files over the limit
#              2 = script error (bad arguments, or cloc not installed)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# The limit from .claude/CLAUDE.md § 8. The warn tier is 90% of it — far enough from the
# wall to split deliberately rather than under duress.
LIMIT=300
WARN_RATIO=90

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'docs-length.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
docs-length.sh — Enforce the 300-line instructional-document limit

Usage:
  docs-length.sh                 Check every instructional Markdown file
  docs-length.sh --output md     Also write a report
  docs-length.sh --path DIR      Restrict the check to a directory or file
  docs-length.sh --limit 250     Check against a stricter limit than the rule's

Measured in cloc CODE lines (`cloc --include-lang=Markdown`) — blank lines and comments
do not count. This is a budget on content, not on formatting.

In scope:
  * every CONTEXT.md and CLAUDE.md, wherever it sits
  * **/docs/**/*.md    (guides and their kebab-case sub-docs)
  * **/workflows/**/*.md   (STEPS.md, CHECKLIST.md, CONTEXT.md)
  * .claude/**/*.md    (agents, skills, hooks, plugins)

Exempt, per .claude/CLAUDE.md § 8:
  * root-level *.md          README, CHANGELOG, GAPS, DEFERRED, RELEASES, REFERENCES, …
  * **/src/*.md              operator guides and PM artefacts — written for humans, in full
  * vendored                 .agents/, code/docs/cloudinary/ SDK docs
  * generated                project-management/export/
  * sandbox / session        learning/, research/, handoffs/, questionnaires/

  A CONTEXT.md or CLAUDE.md inside an exempt tree IS still checked — the pair is ours.

Tiers:
  > 300 code lines      FAIL   split it; the entry point becomes a thin index
  >= 270 code lines     WARN   reported, never fails the run

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/docs-length-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the check to a file or directory
  --limit N            Override the line limit (default 300)
  --help               Show this help

Rule: .claude/CLAUDE.md § 8 · pairing standard: code/docs/DOCUMENTATION-PAIRING.md

Exit codes:  0 = within limits   1 = over the limit   2 = script error / cloc missing
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --limit)        require_arg "$@"; LIMIT="$2"; shift 2 ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
# Bounded at both ends: 0 is meaningless, and a value large enough to overflow bash arithmetic
# yields a negative warn threshold that warns on everything.
[[ "$LIMIT" =~ ^[0-9]{1,6}$ && "$LIMIT" -gt 0 ]] || die "--limit must be a positive integer below 1000000"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/docs-length-report.$OUTPUT_FORMAT"
fi

# cloc IS the metric this rule is written in, so there is no honest fallback. Failing
# loudly beats the silent pass that made this gate necessary in the first place.
command -v cloc >/dev/null 2>&1 || die "cloc is not installed — it is the metric this rule is defined in.
  Debian/Ubuntu: sudo apt-get install -y cloc
  macOS:         brew install cloc"

cd "$PROJECT_ROOT"

# An absolute path is what tab-completion and most hook wrappers produce, so accept one and
# reduce it to the repo-relative form the comparison below is written in.
TARGET_PATH="${TARGET_PATH#"$PROJECT_ROOT"/}"
TARGET_PATH="${TARGET_PATH#./}"

WARN_AT=$(( LIMIT * WARN_RATIO / 100 ))
[[ "$WARN_AT" -lt 1 ]] && WARN_AT=1   # a zero threshold would warn on every empty file

TMP_LIST=$(mktemp); TMP_CSV=$(mktemp); TMP_FAIL=$(mktemp); TMP_WARN=$(mktemp)
TMP_SEEN=$(mktemp); TMP_MISSING=$(mktemp)
trap 'rm -f "$TMP_LIST" "$TMP_CSV" "$TMP_FAIL" "$TMP_WARN" "$TMP_SEEN" "$TMP_MISSING"' EXIT
: > "$TMP_FAIL"; : > "$TMP_WARN"; : > "$TMP_SEEN"; : > "$TMP_MISSING"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ docs-length.sh — $TIMESTAMP"

in_scope() {
  [[ -z "$TARGET_PATH" ]] && return 0
  local p="${1#./}" t="$TARGET_PATH"
  [[ "$p" == "$t" || "$p" == "${t%/}/"* ]]
}

# Decide whether one path instructs Claude Code. Order matters: the CONTEXT.md/CLAUDE.md
# pair is ours and is checked wherever it sits, including inside a tree whose other files
# are exempt — a vendored SDK doc is not ours, but the orientation file over it is.
is_instructional() {
  local p="${1#./}" base="${1##*/}"

  case "$base" in CONTEXT.md|CLAUDE.md) return 0 ;; esac

  # Vendored: refreshed from upstream via the skills tool, never authored here
  case "$p" in .agents/*|code/docs/cloudinary/*) return 1 ;; esac
  # Generated: PM export artefacts
  case "$p" in project-management/export/*) return 1 ;; esac
  # Sandbox and session artefacts: notes and throwaway workspaces, not instruction
  case "$p" in learning/*|research/*|handoffs/*|questionnaires/*) return 1 ;; esac
  # Root-level project documentation: README, CHANGELOG, GAPS, RELEASES, REFERENCES, …
  [[ "$p" != */* ]] && return 1

  # A docs/ or workflows/ segment wins even inside a src/ tree, and the order matters: this is
  # a template whose generated projects fill code/src/django/, so a guide filed at
  # code/src/django/apps/billing/docs/GUIDE.md is rule-bound. Exempting src/ first would blind
  # the gate to exactly the tree a real project grows into.
  case "$p" in */docs/*|*/workflows/*|.claude/*) return 0 ;; esac

  # Everything else — every **/src/*.md operator guide and PM artefact among them — is written
  # for a human, in full, and carries no docs/ or workflows/ segment to claim it back.
  return 1
}

# Tracked plus untracked-but-not-ignored, so a guide added in the working tree is in scope
# before it is staged — which is while the author still has it open. Asking git also means
# the Cargo build tree and node_modules need no exclusion rule here.
#
# core.quotePath=false is load-bearing, not tidiness: with git's default the path
# "docs/ÉTUDE.md" arrives as a literal "docs/\303\211TUDE.md" — quotes and backslashes
# included — which is not a path, so the existence test below discards the file and the run
# reports success having never measured it.
mapfile -t ALL_MD < <({ git -c core.quotePath=false ls-files '*.md'
                        git -c core.quotePath=false ls-files --others --exclude-standard '*.md'
                      } | sort -u)

[[ ${#ALL_MD[@]} -gt 0 ]] || die "no Markdown found in the repository — is this the repository root?"

for f in "${ALL_MD[@]}"; do
  in_scope "$f" || continue
  is_instructional "$f" || continue
  # In the index but not on disk: deleted and not yet staged. Legitimate, but recorded
  # rather than dropped — an unexplained disappearance is how a gate goes quiet.
  if [[ ! -f "$f" ]]; then printf '%s\n' "$f" >> "$TMP_MISSING"; continue; fi
  printf '%s\n' "$f"
done > "$TMP_LIST"

TOTAL=$(grep -c . "$TMP_LIST" || true); TOTAL=${TOTAL:-0}

# cloc cannot be trusted with a comma in a path, and it fails silently in both directions:
# given one such file it emits an unquoted row (shifting every column right), and given more
# than one it drops the file from its output altogether with nothing on stderr. Neither is
# detectable from the numbers. Refuse up front and name the convention, rather than measuring
# something that is not what it says it is. (Verified against cloc 1.98.)
COMMA_PATHS="$(grep ',' "$TMP_LIST" || true)"
if [[ -n "$COMMA_PATHS" ]]; then
  printf '%s\n' "$COMMA_PATHS" | sed 's/^/    /' >&2
  die "the above path(s) contain a comma, which cloc mis-parses or silently drops.
  Rename them — documentation files are SCREAMING-SNAKE-CASE.md (.claude/CLAUDE.md § 5)."
fi

if [[ "$TOTAL" -gt 0 ]]; then
  cloc --include-lang=Markdown --by-file --csv --quiet --list-file="$TMP_LIST" > "$TMP_CSV" 2>/dev/null \
    || die "cloc failed to read the file list"

  # cloc --by-file --csv emits: language,filename,blank,comment,code — and it does NOT quote
  # the filename, so a comma in a path adds fields. Reading $5 would then pick up the comment
  # column: a 321-line file called BIG,COMMA.md scores 0 and passes silently. The count is
  # therefore taken from the RIGHT ($NF) and the name rebuilt from everything between, with a
  # positive shape guard so a future cloc format change fails loudly instead of misreading a
  # column. Header row is language=="language"; trailer is language=="SUM".
  awk -F',' -v lim="$LIMIT" -v warn="$WARN_AT" \
      -v failf="$TMP_FAIL" -v warnf="$TMP_WARN" -v seenf="$TMP_SEEN" '
    $1 == "language" || $1 == "SUM" || NF < 5 { next }
    $NF !~ /^[0-9]+$/ { next }
    {
      code = $NF + 0
      name = $2
      for (i = 3; i <= NF - 3; i++) name = name "," $i
      sub(/^\.\//, "", name)
      print name >> seenf
      if (code > lim)        printf "%5d  %s  (%+d over)\n", code, name, code - lim >> failf
      else if (code >= warn) printf "%5d  %s  (%d left)\n",  code, name, lim - code >> warnf
    }
  ' "$TMP_CSV"

  # The reconciliation that makes every "never measured" bug loud instead of green. Without
  # it the header line below is an assertion about the input list, not about what was read —
  # which is how the comma and quoted-path defects above reported success.
  UNMEASURED="$(comm -23 <(sort -u "$TMP_LIST") <(sort -u "$TMP_SEEN") || true)"
  if [[ -n "$UNMEASURED" ]]; then
    printf '%s\n' "$UNMEASURED" | sed 's/^/    /' >&2
    die "the above file(s) were listed but never measured — the count cannot be trusted.
  A tooling or path-encoding fault, not a documentation problem: fix this script rather than
  the files, and never relax the check to make the run green."
  fi
fi

sort -rn -o "$TMP_FAIL" "$TMP_FAIL"
sort -rn -o "$TMP_WARN" "$TMP_WARN"

FAIL_COUNT=$(grep -c . "$TMP_FAIL" || true); FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(grep -c . "$TMP_WARN" || true); WARN_COUNT=${WARN_COUNT:-0}
FAIL_BODY="$(cat "$TMP_FAIL")"
WARN_BODY="$(cat "$TMP_WARN")"

MISSING_COUNT=$(grep -c . "$TMP_MISSING" || true); MISSING_COUNT=${MISSING_COUNT:-0}

if [[ "$TOTAL" -eq 0 ]]; then
  # Nothing instructional in scope is a clean no-op, not an error — the same self-guarding
  # contract every other audit here honours (CLAUDE.md → Guardrails), and it still writes a
  # report so a CI job told to collect the artefact always finds one.
  log "  nothing instructional${TARGET_PATH:+ under $TARGET_PATH} — nothing to check"
else
  log "  checked $TOTAL instructional file(s) against a $LIMIT-line limit (warn at $WARN_AT)"
fi
if [[ "$MISSING_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '  · %d file(s) in the index but not on disk (deleted, unstaged) — not measured:\n' "$MISSING_COUNT"
  sed 's/^/      /' "$TMP_MISSING"
fi
log ""

if [[ "$FAIL_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[31m  ✗ %d file(s) over the limit\033[0m\n' "$FAIL_COUNT"
  printf '%s\n\n' "$FAIL_BODY" | sed 's/^/    /'
fi
if [[ "$WARN_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[33m  ! %d file(s) approaching the limit\033[0m\n' "$WARN_COUNT"
  printf '%s\n\n' "$WARN_BODY" | sed 's/^/    /'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$FAIL_COUNT" -eq 0 ]] && echo '✓ within limits' || echo "✗ $FAIL_COUNT over the limit")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'docs-length audit — %s\n' "$TIMESTAMP"
        printf 'files=%s limit=%s over=%s approaching=%s\n\n' "$TOTAL" "$LIMIT" "$FAIL_COUNT" "$WARN_COUNT"
        printf '%s\n' "${FAIL_BODY:-No files over the limit.}"
        printf '\n%s\n' "${WARN_BODY:-No files approaching the limit.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Instructional Document Length Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files checked** | %s |\n' "$TOTAL"
        printf '| **Limit** | %s code lines (`cloc --include-lang=Markdown`) |\n' "$LIMIT"
        printf '| **Over the limit** | %s |\n' "$FAIL_COUNT"
        printf '| **Approaching (>= %s)** | %s |\n' "$WARN_AT" "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$FAIL_COUNT" -gt 0 ]]; then
          printf '## Over the limit\n\nSplit each into a `kebab-case/` sub-folder and leave the entry point a thin index.\n\n'
          printf '```text\n%s\n```\n\n' "$FAIL_BODY"
        else
          printf '_Every instructional file is within the limit._\n\n'
        fi
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '## Approaching the limit\n\n```text\n%s\n```\n\n' "$WARN_BODY"; fi
        printf 'Rule: `.claude/CLAUDE.md` § 8 — Instructional file length.\n'
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "docs-length",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "files_checked": %s,\n  "limit": %s,\n  "warn_at": %s,\n' "$TOTAL" "$LIMIT" "$WARN_AT"
        printf '  "over_limit": %s,\n  "approaching": %s,\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$FAIL_COUNT" -eq 0 ]]; then
  SUFFIX=""
  [[ "$WARN_COUNT" -gt 0 ]] && SUFFIX=" — $WARN_COUNT approaching it"
  bold "✓ All $TOTAL instructional file(s) within $LIMIT lines${SUFFIX}."
  log ""
  exit 0
else
  bold "✗ $FAIL_COUNT file(s) over $LIMIT lines — split them (.claude/CLAUDE.md § 8)."
  log ""
  exit 1
fi
