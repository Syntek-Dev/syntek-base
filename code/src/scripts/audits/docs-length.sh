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
#                  Why this script exists: the line-count audit enforces the 750/800 limit
#                  on SOURCE files via `wc -l` and passes --exclude-lang=Markdown, so it
#                  cannot see this rule at all. Several guides nonetheless routed the
#                  300-line check to it, which meant the check silently passed on every
#                  run. A gate that cannot fail is worse than no gate, because it is
#                  believed.
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
# The ratchet (--since):  the warn tier used to print and oblige nobody. A file crossed 270
#                  and sat there until somebody's unrelated edit was refused at 300, so the
#                  pressure landed on whoever happened to be writing rather than on whoever
#                  owned the guide. Measured: two warn-tier files rose in a single day, by
#                  edits from two different sessions, neither obliged to notice.
#
#                  So: below the warn tier, nothing changes. At or above it, a change that
#                  makes the file LONGER fails unless it carries a DATED reason. That is what
#                  the 90% tier was always for — "far enough from the wall to split
#                  deliberately rather than under duress" — and nothing previously made the
#                  deliberate split happen. A file created at or above the tier is held to the
#                  same bar, because a new file is the cheapest moment to split it.
#
#                  The date is what separates a deferral from an amnesty. An undated
#                  annotation is a permanent opt-out granted to exactly the files that earned
#                  scrutiny; a dated one comes back. It is mandatory by format, which is what
#                  makes this register different from the two that preceded it — the entries
#                  that rotted in those were the ones nobody dated.
#
#                  Baselines differ by venue and the flag is the only difference: lefthook
#                  passes --since HEAD for immediate local feedback, CI passes the merge-base
#                  so cumulative branch growth cannot creep past one commit at a time.
#
# Usage: docs-length.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                       [--path PATH] [--limit N] [--since REF] [--self-test] [--help]
#
# Exit codes:  0 = every file within the limit (warnings do not fail)
#              1 = one or more files over the limit, or a ratchet finding
#              2 = script error (bad arguments, cloc not installed, or a baseline that
#                  could not be measured — never a silent pass)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# The instructional-document limit. The warn tier is 90% of it — far enough from the
# wall to split deliberately rather than under duress.
LIMIT=300
WARN_RATIO=90

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SINCE_REF=""
SELF_TEST=false

# The annotation that defers a ratchet finding. Both halves are mandatory and the script
# refuses a marker missing either: a bare one is indistinguishable from someone silencing an
# audit they did not read, and an undated one is an amnesty rather than a deferral.
ALLOW_RE='docs-length-allow:[[:space:]]*(.+)\(expires[[:space:]]+([0-9]{2})/([0-9]{2})/([0-9]{4})\)'

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

Exempt, per .claude/CLAUDE.md Section 8:
  * root-level *.md          README, CHANGELOG, GAPS, DEFERRED, RELEASES, REFERENCES, …
  * **/src/*.md              operator guides and PM artefacts — written for humans, in full
  * vendored                 .agents/, code/docs/cloudinary/ SDK docs
  * generated                project-management/export/
  * sandbox / session        learning/, research/, handoffs/, questionnaires/

  A CONTEXT.md or CLAUDE.md inside an exempt tree IS still checked — the pair is ours.

Tiers:
  > 300 code lines      FAIL   split it; the entry point becomes a thin index
  >= 270 code lines     WARN   reported, never fails the run
  >= 270 and GREW       FAIL   only with --since; the ratchet (below)

The ratchet (--since REF):
  Below 270 nothing changes. At or above it, a file that is LONGER than it was at REF
  fails, as does a file created at or above it. Answer with a dated annotation on a line
  of its own, anywhere in the file:

    <!-- docs-length-allow: the audit inventory grows a row per script (expires 01/11/2026) -->

  Both halves are mandatory. The reason survives review; the date makes it a deferral
  rather than an amnesty, and the audit fails again once it passes. HTML comments are not
  cloc CODE lines, so the annotation never counts against the file it sits in.

  It must be the WHOLE line. That is what lets a guide document this syntax inline without
  failing the rule it defines.

  It silences the RATCHET only. Nothing silences the 300-line limit — a file over it is
  split, never annotated.

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/docs-length-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the check to a file or directory
                         A path that does not exist is a bad argument, not an empty
                         scope: exit 2, never a green run over a scope never honoured.
  --limit N            Override the line limit (default 300)
  --since REF          Enable the ratchet, measuring against this git ref.
                         lefthook passes HEAD; CI passes the merge-base with the target
                         branch, so growth cannot creep past one commit at a time.
                         An empty REF is refused at exit 2, exactly as an unresolvable
                         one is: omit the flag to run without the ratchet.
  --self-test          Prove the ratchet fires in both directions, then exit
  --help               Show this help

Rule: .claude/CLAUDE.md Section 8 · pairing standard: code/docs/DOCUMENTATION-PAIRING.md

Exit codes:  0 = within limits   1 = over the limit   2 = script error / cloc missing
EOF
}

# A value is a value, not merely a token in the position where one goes. Counting arguments
# alone let `--since ""` through: the ratchet is entered on `[[ -n "$SINCE_REF" ]]` further
# down, so an empty ref skipped the whole ratchet in silence and the run exited 0, while
# `--since deadbeef` exited 2 by the same reasoning stated out loud. Two spellings of "the ref
# you gave me is not usable", one loud and one green — and the green one is the reporting
# defect this script was written to close, reappearing in its own argument handling.
#
# The CI job can produce the empty form, so this is not merely latent. It passes
# `--since "$(git merge-base HEAD "$BASE_SHA")"` (.github/workflows/audit-docs-length.yml
# lines 66-67) from a `run: |` block, which GitHub runs under `bash -e` — and a command
# substitution that fails inside an ARGUMENT does not abort the step the way a failed
# assignment would, so an unresolvable merge-base reaches this script as `--since ""`.
# `fetch-depth: 0` (line 51) is what makes that rare, not impossible. lefthook passes HEAD
# or omits the flag (lefthook.yml lines 101 and 103), and neither is empty.
#
# --path takes the same refusal, and so does it in cloc.sh, routing-skills.sh and stubs.sh
# as of 22/08/2026: an empty scope is a caller's computed variable come back empty, and
# sweeping the whole tree answers a scope nobody asked for while the output still reads as
# though one had been honoured. The folder's other --path takers were left as they were.
require_arg() { [[ $# -gt 1 && -n "$2" ]] || die "$1 requires a non-empty value"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --limit)        require_arg "$@"; LIMIT="$2"; shift 2 ;;
    --since)        require_arg "$@"; SINCE_REF="$2"; shift 2 ;;
    --self-test)    SELF_TEST=true; shift ;;
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

# ── --self-test ───────────────────────────────────────────────────────────────
# The ratchet cannot be proved against a static fixture directory the way the other audits
# here are, because what it reads is git HISTORY. So it builds a throwaway repository, drops
# a copy of this script at the same relative path — PROJECT_ROOT is derived from SCRIPT_DIR,
# so the copy resolves the temp repo as its own root — and drives it through every branch.
#
# Six cases, and the three negatives matter as much as the three positives: a ratchet that
# fires on a file that shrank would be reverted within a day.
self_test() {
  command -v git >/dev/null 2>&1 || die "--self-test needs git"

  local root me pass=0 fail=0
  root=$(mktemp -d)
  me="$root/code/src/scripts/audits/docs-length.sh"
  mkdir -p "$root/code/src/scripts/audits" "$root/code/docs"
  cp "${BASH_SOURCE[0]}" "$me"

  git -C "$root" init -q
  git -C "$root" config user.email 'self-test@invalid'
  git -C "$root" config user.name 'docs-length self-test'

  # Body lines are cloc CODE lines; blanks and HTML comments are not. n lines in, n counted.
  gen() { local n=$1 f=$2 i; { printf '# Fixture\n'; for ((i = 1; i < n; i++)); do
    printf 'Line %d.\n' "$i"; done; } > "$root/$f"; }

  check() {
    local name=$1 want=$2 got=0
    ( cd "$root" && bash "$me" --since HEAD --quiet --output json \
        --output-file "$root/r.json" ) >/dev/null 2>&1 || got=$?
    if [[ "$got" == "$want" ]]; then
      printf '    \033[32m✓\033[0m %s\n' "$name"; pass=$((pass + 1))
    else
      printf '    \033[31m✗\033[0m %s — expected exit %s, got %s\n' "$name" "$want" "$got"
      fail=$((fail + 1))
    fi
  }

  gen 280 code/docs/GUIDE.md
  git -C "$root" add -A && git -C "$root" commit -qm baseline

  check 'unchanged file in the warn band is clean'          0
  gen 285 code/docs/GUIDE.md
  check 'growth inside the warn band fires'                 1
  printf '\n<!-- docs-length-allow: proving the deferral (expires 01/01/2999) -->\n' >> "$root/code/docs/GUIDE.md"
  check 'a dated reason defers it'                          0
  sed -i 's|expires 01/01/2999|expires 01/01/2000|' "$root/code/docs/GUIDE.md"
  check 'an expired deferral fires again'                   1
  sed -i 's|docs-length-allow:.*|docs-length-allow: undated -->|' "$root/code/docs/GUIDE.md"
  check 'an undated annotation is refused'                  1
  gen 275 code/docs/GUIDE.md
  check 'a file that shrank does not fire'                  0
  gen 280 code/docs/NEW.md
  check 'a new file born in the warn band fires'            1

  rm -rf "$root"
  log ""
  if [[ "$fail" -eq 0 ]]; then
    bold "✓ self-test: $pass/$pass ratchet cases separated."; log ""; exit 0
  fi
  bold "✗ self-test: $fail of $((pass + fail)) cases wrong — fix the detector, never the cases."
  log ""; exit 2
}

if $SELF_TEST; then
  log ""; bold "▸ docs-length.sh --self-test"; log ""
  self_test
fi

cd "$PROJECT_ROOT"

# An absolute path is what tab-completion and most hook wrappers produce, and a ./-prefixed
# one is what a shell loop produces, so accept both and reduce them to the repo-relative form
# in_scope() is written in. Stripping two prefixes was not enough: `.`, `..` inside a path and
# a path outside the repository all survived it, passed the existence test below against the
# filesystem, and then matched no row in a comparison that only knows repo-relative strings.
# The normalisation therefore runs BEFORE the test, so both judge the same string.
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
    # `.` — the whole repository, which is the unscoped run over the identical population,
    # not a prefix no repo-relative path can start with.
    TARGET_PATH=""
  elif [[ "$SCOPE_ABS" == "$PROJECT_ROOT"/* ]]; then
    TARGET_PATH="${SCOPE_ABS#"$PROJECT_ROOT"/}"
  else
    die "--path '$TARGET_PATH' resolves to $SCOPE_ABS, outside $PROJECT_ROOT"
  fi
  [[ "$TARGET_PATH" == "$SCOPE_RAW" ]] || SCOPE_AS=" — '$SCOPE_RAW' resolves to it"
fi

# --path is validated HERE, at top level, and against the FILESYSTEM — not left to in_scope(),
# which is a string comparison against `git ls-files` output and cannot tell a renamed
# directory from an empty one. A path that does not exist matched no row, the file list came
# back empty, and the run reached its success line at exit 0 having measured nothing. That is
# the scoping fault of code/docs/GATE-REPORTING.md Section 5: a zero population for a reason
# never checked. It must be a bad argument instead — exit 2, like every other audit here.
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist$SCOPE_AS"

WARN_AT=$(( LIMIT * WARN_RATIO / 100 ))
[[ "$WARN_AT" -lt 1 ]] && WARN_AT=1   # a zero threshold would warn on every empty file

TMP_LIST=$(mktemp); TMP_CSV=$(mktemp); TMP_FAIL=$(mktemp); TMP_WARN=$(mktemp)
TMP_SEEN=$(mktemp); TMP_MISSING=$(mktemp); TMP_COUNTS=$(mktemp); TMP_RATCHET=$(mktemp)
BASE_DIR=$(mktemp -d)
trap 'rm -f "$TMP_LIST" "$TMP_CSV" "$TMP_FAIL" "$TMP_WARN" "$TMP_SEEN" "$TMP_MISSING" \
             "$TMP_COUNTS" "$TMP_RATCHET"; rm -rf "$BASE_DIR"' EXIT
: > "$TMP_FAIL"; : > "$TMP_WARN"; : > "$TMP_SEEN"; : > "$TMP_MISSING"
: > "$TMP_COUNTS"; : > "$TMP_RATCHET"

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
  Rename them — documentation files are SCREAMING-SNAKE-CASE.md (.claude/CLAUDE.md Section 5)."
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
      -v failf="$TMP_FAIL" -v warnf="$TMP_WARN" -v seenf="$TMP_SEEN" -v countf="$TMP_COUNTS" '
    $1 == "language" || $1 == "SUM" || NF < 5 { next }
    $NF !~ /^[0-9]+$/ { next }
    {
      code = $NF + 0
      name = $2
      for (i = 3; i <= NF - 3; i++) name = name "," $i
      sub(/^\.\//, "", name)
      print name >> seenf
      # The ratchet needs a per-file count, not just the name. Written for every file so the
      # pass below can decide membership itself rather than re-deriving it from the tiers.
      printf "%s\t%d\n", name, code >> countf
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

# ── The ratchet ───────────────────────────────────────────────────────────────
# Only with --since, so an unflagged run behaves exactly as it always did. Below the warn
# tier nothing changes; at or above it a file may not get LONGER without a dated reason.
if [[ -n "$SINCE_REF" ]]; then
  git rev-parse --verify --quiet "${SINCE_REF}^{commit}" >/dev/null || die \
"--since ref '$SINCE_REF' does not resolve to a commit.
  In CI this is nearly always a shallow checkout: actions/checkout defaults to fetch-depth 1,
  so neither HEAD~ nor a merge-base exists there. Set fetch-depth: 0 rather than dropping the
  flag — a ratchet that silently stops ratcheting is the defect this script exists to close."

  TODAY=$(date -u '+%Y%m%d')

  while IFS=$'\t' read -r name code; do
    [[ -n "$name" ]] || continue
    [[ "$code" -ge "$WARN_AT" ]] || continue

    # The annotation is read before the baseline. A growth already accounted for need not be
    # measured again, and an expired deferral has to speak up even if the file has shrunk.
    #
    # An annotation is a line that is NOTHING BUT the comment. The copy audits keep a guide
    # from failing the rule it defines by never reading instructional Markdown; this one reads
    # nothing else, so the distinction has to live in the shape instead of the scope. A syntax
    # quoted inline in a sentence — the guide stating this rule quotes it, in backticks
    # mid-bullet — is never a whole line on its own, and a real annotation always is.
    marker="$(grep -oE '^[[:space:]]*<!--[[:space:]]*docs-length-allow:.*-->[[:space:]]*$' \
      "$name" | head -1 || true)"
    if [[ -n "$marker" ]]; then
      if [[ "$marker" =~ $ALLOW_RE ]]; then
        reason="${BASH_REMATCH[1]}"; dd="${BASH_REMATCH[2]}"
        mm="${BASH_REMATCH[3]}"; yyyy="${BASH_REMATCH[4]}"
        if [[ -z "${reason//[[:space:]]/}" ]]; then
          printf '%s: the annotation is dated but gives no reason — say what earned it\n' \
            "$name" >> "$TMP_RATCHET"
        elif (( 10#${yyyy}${mm}${dd} < 10#$TODAY )); then
          printf '%s: deferral expired %s/%s/%s — split it, or re-date it with a fresh reason\n' \
            "$name" "$dd" "$mm" "$yyyy" >> "$TMP_RATCHET"
        fi
      else
        printf '%s: malformed annotation — needs a reason AND (expires DD/MM/YYYY)\n' \
          "$name" >> "$TMP_RATCHET"
      fi
      continue
    fi

    if git cat-file -e "${SINCE_REF}:${name}" 2>/dev/null; then
      mkdir -p "$BASE_DIR/$(dirname "$name")"
      # The .md suffix is load-bearing, not tidiness: cloc infers language from the extension
      # and emits NOTHING AT ALL for an extensionless file, with nothing on stderr. A baseline
      # written to a bare mktemp path therefore measures zero, compares clean, and reports no
      # growth — this script's own founding defect reproduced one layer down. Rebuilding the
      # path under $BASE_DIR preserves the suffix, which is the whole reason it is a directory.
      git show "${SINCE_REF}:${name}" > "$BASE_DIR/$name"
      base=$(cloc --include-lang=Markdown --by-file --csv --quiet "$BASE_DIR/$name" 2>/dev/null \
        | awk -F',' '$1 != "language" && $1 != "SUM" && NF >= 5 && $NF ~ /^[0-9]+$/ { print $NF; exit }')
      [[ "$base" =~ ^[0-9]+$ ]] || die \
"could not measure '$name' at $SINCE_REF — the baseline is unknown, so growth cannot be
  decided. Refusing to report a clean run having measured nothing."
      if [[ "$code" -gt "$base" ]]; then
        printf '%s: %d → %d code lines, at or above the %d tier\n' \
          "$name" "$base" "$code" "$WARN_AT" >> "$TMP_RATCHET"
      fi
    else
      # No baseline: the file is new. Held to the same bar deliberately — a file that may be
      # born at 299 is a door the ratchet never sees through.
      printf '%s: created at %d code lines, at or above the %d tier\n' \
        "$name" "$code" "$WARN_AT" >> "$TMP_RATCHET"
    fi
  done < "$TMP_COUNTS"
fi

sort -rn -o "$TMP_FAIL" "$TMP_FAIL"
sort -rn -o "$TMP_WARN" "$TMP_WARN"
sort -o "$TMP_RATCHET" "$TMP_RATCHET"

FAIL_COUNT=$(grep -c . "$TMP_FAIL" || true); FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(grep -c . "$TMP_WARN" || true); WARN_COUNT=${WARN_COUNT:-0}
RATCHET_COUNT=$(grep -c . "$TMP_RATCHET" || true); RATCHET_COUNT=${RATCHET_COUNT:-0}
FAIL_BODY="$(cat "$TMP_FAIL")"
WARN_BODY="$(cat "$TMP_WARN")"
RATCHET_BODY="$(cat "$TMP_RATCHET")"

MISSING_COUNT=$(grep -c . "$TMP_MISSING" || true); MISSING_COUNT=${MISSING_COUNT:-0}

# TOTAL counts what was MEASURED: a file in scope but not on disk was diverted into
# TMP_MISSING above and never reached the list. So TOTAL == 0 has two causes that must not
# share a sentence — an empty scope, and a scope whose every file went unread.
if [[ "$TOTAL" -eq 0 && "$MISSING_COUNT" -gt 0 ]]; then
  log "  nothing measured${TARGET_PATH:+ under $TARGET_PATH} — every file in scope is listed below"
elif [[ "$TOTAL" -eq 0 ]]; then
  # Nothing instructional in scope is a clean no-op, not an error — the same self-guarding
  # contract every other audit here honours, and it still writes a report so a CI job told
  # to collect the artefact always finds one.
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
if [[ "$RATCHET_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[31m  ✗ %d ratchet finding(s) against %s\033[0m\n' "$RATCHET_COUNT" "$SINCE_REF"
  printf '%s\n\n' "$RATCHET_BODY" | sed 's/^/    /'
  printf '    A file at or above %d may not get longer without saying why. Split it, or add\n' "$WARN_AT"
  printf '    anywhere in the file:\n\n'
  printf '      <!-- docs-length-allow: <why this one earns the length> (expires DD/MM/YYYY) -->\n\n'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  # The unmeasured files are part of the verdict, not a footnote to it: a status claiming an
  # empty scope beside a `missing` count above zero is the terminal's contradiction written
  # into the artefact, where no one is reading the two lines together.
  UNMEASURED=""
  [[ "$MISSING_COUNT" -gt 0 ]] && UNMEASURED=" — $MISSING_COUNT in the index but not on disk, unmeasured"
  if [[ "$FAIL_COUNT" -gt 0 ]]; then STATUS="✗ $FAIL_COUNT over the limit$UNMEASURED"
  elif [[ "$RATCHET_COUNT" -gt 0 ]]; then STATUS="✗ $RATCHET_COUNT ratchet finding(s)$UNMEASURED"
  elif [[ "$TOTAL" -eq 0 && "$MISSING_COUNT" -gt 0 ]]; then
    STATUS="⚠ nothing measured — $MISSING_COUNT file(s) in scope, all in the index but not on disk"
  elif [[ "$TOTAL" -eq 0 ]]; then STATUS='✓ no instructional file in scope — nothing of this kind here'
  else STATUS="✓ within limits ($TOTAL file(s) measured)$UNMEASURED"; fi
  MISSING_BODY="$(cat "$TMP_MISSING")"
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'docs-length audit — %s\n' "$TIMESTAMP"
        printf 'files=%s limit=%s over=%s approaching=%s unmeasured=%s\n' \
          "$TOTAL" "$LIMIT" "$FAIL_COUNT" "$WARN_COUNT" "$MISSING_COUNT"
        printf 'status=%s\n\n' "$STATUS"
        printf '%s\n' "${FAIL_BODY:-No files over the limit.}"
        printf '\n%s\n' "${WARN_BODY:-No files approaching the limit.}"
        printf '\n%s\n' "${RATCHET_BODY:-No ratchet findings.}"
        printf '\n%s\n' "${MISSING_BODY:-No files in the index but missing from disk.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Instructional Document Length Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files checked** | %s |\n' "$TOTAL"
        printf '| **Limit** | %s code lines (`cloc --include-lang=Markdown`) |\n' "$LIMIT"
        printf '| **Over the limit** | %s |\n' "$FAIL_COUNT"
        printf '| **Approaching (>= %s)** | %s |\n' "$WARN_AT" "$WARN_COUNT"
        printf '| **In the index, not on disk** | %s |\n' "$MISSING_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$FAIL_COUNT" -gt 0 ]]; then
          printf '## Over the limit\n\nSplit each into a `kebab-case/` sub-folder and leave the entry point a thin index.\n\n'
          printf '```text\n%s\n```\n\n' "$FAIL_BODY"
        else
          printf '_Every instructional file is within the limit._\n\n'
        fi
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '## Approaching the limit\n\n```text\n%s\n```\n\n' "$WARN_BODY"; fi
        if [[ "$RATCHET_COUNT" -gt 0 ]]; then
          printf '## Ratchet findings (against `%s`)\n\n' "$SINCE_REF"
          printf 'A file at or above %s may not get longer without a dated reason.\n\n' "$WARN_AT"
          printf '```text\n%s\n```\n\n' "$RATCHET_BODY"
        fi
        if [[ "$MISSING_COUNT" -gt 0 ]]; then
          printf '## Not measured\n\n'
          printf 'In the index but not on disk (deleted, unstaged). The limit ruled on none of these.\n\n'
          printf '```text\n%s\n```\n\n' "$MISSING_BODY"
        fi
        printf 'Rule: `.claude/CLAUDE.md` Section 8 — Instructional file length.\n'
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "docs-length",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "files_checked": %s,\n  "limit": %s,\n  "warn_at": %s,\n' "$TOTAL" "$LIMIT" "$WARN_AT"
        printf '  "over_limit": %s,\n  "approaching": %s,\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "ratchet_findings": %s,\n  "ratchet_since": "%s",\n' "$RATCHET_COUNT" "$SINCE_REF"
        # files_checked is what was READ, so it needs its companion: a file in scope and not
        # on disk is counted here and nowhere else. Without it, "files_checked": 0 and a
        # status of "nothing of this kind here" are indistinguishable from a scope whose
        # every file went unread — which is this guide's whole subject.
        printf '  "missing": %s,\n' "$MISSING_COUNT"
        # The same status string the markdown carries. A zero in files_checked is the
        # denominator; this is the sentence that says what the zero means.
        printf '  "status": "%s",\n' "$STATUS"
        printf '  "exit_code": %s\n}\n' \
          "$([[ "$FAIL_COUNT" -eq 0 && "$RATCHET_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$TOTAL" -eq 0 && "$MISSING_COUNT" -gt 0 ]]; then
  # The empty-population headline must not fire here. Every file in scope WAS instructional;
  # none could be read, so "no instructional file" is false and "nothing of this kind here"
  # is the reading code/docs/GATE-REPORTING.md Section 1 forbids — "could not look" reported
  # as "looked, and it was clean", printed two lines from the list of what went unread.
  # Exit 0 is unchanged: a deletion staged one command later is ordinary work, and failing
  # here would block the commit that tidies it.
  bold "⚠ Nothing measured${TARGET_PATH:+ under $TARGET_PATH}: all $MISSING_COUNT file(s) in scope are unread."
  log "  Each is in the index but not on disk, listed above, so the $LIMIT-line limit ruled"
  log "  on nothing. Stage the deletion or restore the file, then re-run to get a verdict."
  log ""
  exit 0
elif [[ "$TOTAL" -eq 0 ]]; then
  # Exit 0 stays right — no instructional file in scope is a legitimately empty population,
  # not an unexamined one — but "✓ All 0 instructional file(s) within 300 lines" reads as a
  # verdict on the files rather than an admission there were none. Only the wording separates
  # "nothing of this kind here" from "nothing wrong here" (code/docs/GATE-REPORTING.md).
  bold "✓ Nothing to check: no instructional file${TARGET_PATH:+ under $TARGET_PATH}."
  log "  No file was measured, so the $LIMIT-line limit ruled on nothing. In scope would be"
  log "  any CONTEXT.md or CLAUDE.md, or any .md under docs/, workflows/ or .claude/."
  log ""
  exit 0
elif [[ "$FAIL_COUNT" -eq 0 && "$RATCHET_COUNT" -eq 0 ]]; then
  SUFFIX=""
  [[ "$WARN_COUNT" -gt 0 ]] && SUFFIX=" — $WARN_COUNT approaching it"
  bold "✓ All $TOTAL instructional file(s) within $LIMIT lines${SUFFIX}."
  log ""
  exit 0
elif [[ "$FAIL_COUNT" -eq 0 ]]; then
  bold "✗ $RATCHET_COUNT ratchet finding(s) — a file already at $WARN_AT+ grew without a reason."
  log ""
  exit 1
else
  bold "✗ $FAIL_COUNT file(s) over $LIMIT lines — split them (.claude/CLAUDE.md Section 8)."
  log ""
  exit 1
fi
