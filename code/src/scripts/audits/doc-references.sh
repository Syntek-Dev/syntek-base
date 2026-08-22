#!/usr/bin/env bash
#
# doc-references.sh — Every citation in a shipped file must resolve in every project.
#
#                     Two checks, one rule. A file that ships is read in a project that is
#                     not this one, so it may cite only what that project is guaranteed to
#                     have: the LAYERING SYSTEM — CONTEXT.md, CLAUDE.md, docs/, workflows/,
#                     scripts, guides. It may never cite a PER-PROJECT INSTANCE — ADR-###,
#                     US###, SPRINT-##, MAP-*, PLAN-*, BUG-*, QA-* — because a generated
#                     project has different ones at those numbers, or none at all.
#
#                     Check 1 — dangling path.     A backticked repo path that does not exist.
#                     Check 2 — instance citation. A named instance artefact, cited as real.
#
#                     ADDED 20/08/2026: Check 1 peels a trailing LINE ANCHOR before the
#                     existence test. An anchor names a location INSIDE a file rather than
#                     another file -- `foo.py:7` cites `foo.py` -- and both the `:N` and the
#                     `:N:M` column form are peeled. It sits AFTER the path guard, so a port
#                     (`django:8000`) and an OWASP id (`A05:2025`) never reach it: neither
#                     carries a slash, and that guard already drops them. Check 2 tests the
#                     RAW token and is deliberately left alone -- hoisting the peel above it
#                     would move `base` and the is_seeded lookup with it, which is a second
#                     decision nobody has made. Known limit of that scoping, stated rather
#                     than left to be found: a line-anchored INSTANCE citation would still
#                     false-positive at Check 2. None exists today.
#
#                     ADDED 20/08/2026: `doc-references: template-only` suppresses a finding
#                     exactly as `doc-references: ignore` does, on the line or the line
#                     directly above, and records a DIFFERENT judgement -- the check applies
#                     and the citation is deliberate, because the path does not survive
#                     generation. Both markers stay literal and greppable so the two
#                     judgements can still be told apart. Rule and the difference between
#                     them: `code/docs/FORWARD-VOICE.md` Section 4.
#
#                     ADDED 20/08/2026: `code/src/django/` is CHECKED. It used to fall to
#                     the catch-all with the artefact trees, unexamined, because there was
#                     nowhere to record that a path a project builds is genuinely coming.
#                     `how-to/src/PROJECT-PATHS.md` is that place, so such a citation is now
#                     a checked promise: a path with a row there passes, and one without is
#                     a dangling path like any other. TENSE IS IRRELEVANT to this -- "will
#                     build" and "is live" fail alike, because the check reads the path. The
#                     remedy for a finding is `code/docs/FORWARD-VOICE.md` Section 1's
#                     default disposition: correct the citation or drop it. A row is written
#                     when a creator can be NAMED, never to quieten a finding.
#
#                     Naming PATTERNS are not citations and are not flagged: "take the next
#                     free `ADR-###` in `15-DECISIONS/`" names a format, not a document. The
#                     `*-TEMPLATE.md` files are real and citable for the same reason.
#
#                     What it CANNOT check is whether a resolving path is the RIGHT one, or
#                     whether a count stated in words is true. Both stay reviewer judgement.
#
# Scope scanned:  tracked AND untracked-but-not-ignored files — the file you just wrote is
#                 the one most needing the check, and it is not tracked yet.
#
# Exempt:         history (CHANGELOG/RELEASES/VERSION-HISTORY) records what was true then;
#                 handoffs/ and .copier/ are staging.
#
#                 NOT exempt, deliberately: the root GAPS.md and DEFERRED.md. They are
#                 copier-excluded as of 22/08/2026, so this repository's copies hold real
#                 entries — but a generated project receives a SEEDED file at the same path,
#                 and an exemption keyed on the path cannot tell the two apart. Exempting
#                 them here would switch this audit off over every downstream register.
#
#                 HISTORY, kept because it records how the exemption shrank to nothing.
#                 It once read "TEMPLATE-GUIDE/ is copier-excluded AND must be able to name
#                 a broken citation"; the first half was FALSE from f5fef31 (14/08, v3.2.0)
#                 -- that tree ships. It was CORRECTED 18/08 to name one file, NARROWED
#                 21/08 (MAP-BASE-HEALTH N-031) so the guides beside it were scanned like
#                 any other shipped file, and RETIRED 22/08 when that file was folded into
#                 the root GAPS.md. Each step was measured before it was taken: the
#                 narrowing was proven in a `git archive HEAD` scratch clone with the arm
#                 patched out, where the whole tree yielded FOUR findings and NONE was a
#                 broken citation -- two correct past-tense mentions of the deleted
#                 .claude/agents/, one teaching example, and one invented filename a reader
#                 is told to create. All four were repaired rather than suppressed, which is
#                 what made the narrowing safe. Regenerate the population with:
#                   git archive HEAD | tar -x -C "$SCRATCH" && cd "$SCRATCH" && git init -q .
#                   git add -A && git commit -qm base && bash code/src/scripts/audits/doc-references.sh
#
# ADDED 22/08/2026: THE RUN NAMES ITS POPULATION, not only its verdict. Until now the whole
#                 output of a clean run was "Clean — every citation resolves", which is the
#                 same sentence over the whole repository and over none: the unscoped run read
#                 955 files when this was written, `--path .github/workflows` holds no .md or
#                 .sh at all, `--path research` holds only exempt ones, and
#                 `--path does/not/exist` collected nothing whatever — all four printed that
#                 sentence and exited 0. A verdict with no denominator cannot be told apart
#                 from "could not look", so the run now reports the files it read, the files it
#                 skipped by rule, the backticked tokens it examined and the subset of those
#                 tested as repo paths, and a scoped run names its scope. The nonexistent scope
#                 is refused outright at exit 2 (the guard below).
#                 Rule: `code/docs/GATE-REPORTING.md`, Section 1 and Section 5.
#
# Usage: doc-references.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                          [--path PATH] [--self-test] [--help]
#
# Self-test:      --self-test runs the ordinary scan over fixtures/doc-references/{broken,clean}
#                 and asserts it separates them: broken/ must fire on every clause, clean/ on
#                 none. It covers the three clauses above and nothing else, because a green run
#                 that measured nothing is believed. The fixtures hold deliberate dangling
#                 paths, so an ordinary run must not read them -- is_exempt() keeps that tree
#                 out and --self-test is the only way in.
#
# Exit codes:  0 = clean   1 = violation(s), or a self-test the detector no longer passes
#              2 = script error (bad arguments, or --self-test with the fixtures missing)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="code/src/scripts/audits/fixtures/doc-references"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'doc-references.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
doc-references.sh — Every citation in a shipped file must resolve in every project

Usage:
  doc-references.sh                 Check every eligible file
  doc-references.sh --output md     Also write a report to audits/reports/
  doc-references.sh --path DIR      Restrict the check to a directory or file
  doc-references.sh --quiet         Suppress progress output
  doc-references.sh --self-test     Prove the detector still separates the fixtures

Every run names what it read — files scanned, files exempt by rule, backticked tokens
checked and how many of those were tested as repo paths — before its verdict. A scope is
normalised to the repo-relative form first, and one that does not exist, or that resolves
outside the repository, is refused at exit 2.

Suppress a citation with `doc-references: ignore` (neither check applies) or
`doc-references: template-only` (the check applies; the path does not ship), on the
line or the line directly above it. The two are not synonyms — `code/docs/FORWARD-VOICE.md`.

Exit codes: 0 clean · 1 violations found, or a failed self-test · 2 script error
EOF
}

# A flag whose value is missing took `${2:-}` and then `shift 2` on one argument, which under
# `set -e` ended the run at exit 1 with nothing printed — the code that means "citations do not
# resolve", for a mistake in the command line. A bad argument is exit 2 and says which one.
require_arg() { [ $# -gt 1 ] || die "$1 requires a value"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --output)      require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) require_arg "$@"; OUTPUT_FILE="$2";   shift 2 ;;
    --path)        require_arg "$@"; TARGET_PATH="$2";   shift 2 ;;
    --quiet)       QUIET=true;             shift   ;;
    --self-test)   SELF_TEST=true;         shift   ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT" || die "cannot enter $PROJECT_ROOT"

# --path is NORMALISED and validated HERE, at top level, before candidates() runs — never left
# to the filter over the file list, which runs after collection and would simply match nothing.
# Two argument faults share that shape, and neither may reach a success line:
#
#   a scope that does not exist   a typo, or a path since renamed. Exit 2 — a clean exit 0 is
#                                 the answer a directory genuinely holding no citation gets,
#                                 and the two must not read alike.
#   a scope git never writes      `.`, a `./` prefix, an absolute path (what tab-completion
#                                 produces) or an interior `..`. All of them EXIST, so an -e
#                                 guard passes them, and all of them then match zero rows of
#                                 `git ls-files` output, which writes none of those forms.
#                                 Measured 22/08/2026, before this block: `--path .` read 0
#                                 files and printed "Nothing to check" over a repository whose
#                                 unscoped run read 955 at the time. That is the scoping fault of
#                                 GATE-REPORTING.md Section 5 wearing the remedy for the
#                                 reporting one — a stronger claim over the same unread
#                                 population.
#
# So the existence test and the file filter read the SAME normalised, repo-relative value, and
# the repository root normalises to the unscoped run rather than to a scope matching nothing.
# Resolution is textual rather than `realpath`: it adds no dependency, needs no path to exist,
# and refuses a path outside the tree by naming what it resolved to. Symlinks are not followed,
# so a symlinked route into the tree is refused rather than silently accepted.
# Rule: code/docs/GATE-REPORTING.md.
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
if [ -n "$TARGET_PATH" ]; then
  RAW_PATH="$TARGET_PATH"
  ABS_PATH="$(normalise_scope "$RAW_PATH")"
  if [ "$ABS_PATH" = "$PROJECT_ROOT" ]; then
    TARGET_PATH=""                              # the root: the whole repository, unscoped
  elif [[ "$ABS_PATH" == "$PROJECT_ROOT"/* ]]; then
    TARGET_PATH="${ABS_PATH#"$PROJECT_ROOT"/}"
  else
    die "--path '$RAW_PATH' resolves to '${ABS_PATH:-/}', outside $PROJECT_ROOT"
  fi
fi
READ_AS=""
[ "$RAW_PATH" = "$TARGET_PATH" ] || READ_AS=" (read as '$TARGET_PATH')"
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] || die "--path '$RAW_PATH' does not exist$READ_AS"

# ── What we scan ─────────────────────────────────────────────────────────────
# Tracked plus untracked-but-not-ignored, deduplicated. Ignored files are absent by
# construction — but nothing this check cares about relies on that any more: the
# artefact trees are committed as of 17/08/2026 and are named in is_exempt() below.
candidates() {
  { git ls-files -z; git ls-files -z --others --exclude-standard; } \
    | tr '\0' '\n' | sort -u | grep -E '\.(md|sh)$' || true
}

is_exempt() {
  case "$1" in
    CHANGELOG.md|RELEASES.md|VERSION-HISTORY.md)  return 0 ;;
    # RETIRED 22/08/2026. This arm named how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md, which no
    # longer exists — its contents were folded into the root GAPS.md. The arm is NOT re-pointed
    # at GAPS.md, and that was measured rather than assumed: exempting GAPS.md blinds this audit
    # over every generated project's own register, because the seeded downstream file sits at the
    # same path. A planted broken citation in a generated project's GAPS.md went unreported while
    # the identical one in DEFERRED.md was caught. The cost is real and is accepted here: the
    # register can no longer quote a broken citation in order to log one, and must describe it
    # instead of reproducing it.
    handoffs/*|.copier/*)                         return 0 ;;
    # The artefact trees. This rule polices what a SHIPPED file may cite, and none of
    # these ship — copier.yml `_exclude` empties every one of them at generation. A map
    # cites sibling maps and paths that do not exist yet BY DESIGN: charting future work
    # is what it is for, and the citation resolves when the work lands.
    #
    # These were exempt by accident until 17/08/2026, and the candidates() comment above
    # still described that mechanism: the trees were gitignored, so `git ls-files` never
    # saw them. They are committed now — so they sync across devices — which made 160
    # citations visible in one commit. The exemption is stated here instead.
    research/*|learning/*)                        return 0 ;;
    project-management/src/01-FEATURE-MAPS/*)          return 0 ;;
    code/docs/cloudinary/*)                       return 0 ;;  # vendored SDK docs
    .agents/*)                                    return 0 ;;  # vendored third-party skills
    # This audit's own fixtures, exempted as docs-pairing.sh exempts the same tree and for
    # the same reason: the audits run against these files, so a fixture that deliberately
    # carries a dangling path would redden the ordinary run rather than prove anything. They
    # are reached only through --self-test, which points the identical scan at them on
    # purpose -- so the exemption lifts there and nowhere else.
    code/src/scripts/audits/fixtures/*)
      if ! $SELF_TEST; then return 0; fi ;;
  esac
  return 1
}

# Paths copier seeds into place at generation exist in a generated project even
# though they are absent here. Parsed from copier.yml so a new seed needs no edit.
SEEDED="$(grep -oE 'mv \.copier/[^ ]+ ([^ ]+)' copier.yml 2>/dev/null | awk '{print $3}' || true)"

is_seeded() {
  [ -n "$SEEDED" ] && printf '%s\n' "$SEEDED" | grep -qxF "$1"
}

# Direction A — the register. `how-to/src/PROJECT-PATHS.md` names every path a shipped
# document may cite that this repository does not hold, together with what creates it in a
# real project. Read from the `## Registered paths` section alone, so the neighbouring
# "deliberately not registered" table cannot silence anything: a refusal there is a verdict,
# never a permission. Trailing slashes come off, because `$resolved` has already lost its
# own. Rule: `code/docs/FORWARD-VOICE.md` Section 3.
REGISTER_FILE="how-to/src/PROJECT-PATHS.md"
REGISTERED="$(awk '/^## Registered paths/{on=1; next} /^## /{on=0} on' "$REGISTER_FILE" 2>/dev/null \
  | grep -oE '^\| `[^`]+`' | tr -d '|` ' | sed 's:/$::' || true)"

is_registered() {
  [ -n "$REGISTERED" ] && printf '%s\n' "$REGISTERED" | grep -qxF "$1"
}

# Copier renders this file into every generated project, so the two delimiter pairs must
# never appear literally in it — Jinja would try to parse them and generation would die with
# TemplateSyntaxError. They are assembled here instead, which is also why the patterns below
# are variables rather than inline globs.
LT='<'
TOK_OPEN="${LT}%"
BLK_OPEN="${LT}:"

# A token with a template placeholder, a numeric pattern, or a glob is not a citation.
is_pattern() {
  case "$1" in
    *"$TOK_OPEN"*|*"$BLK_OPEN"*)                                     return 0 ;;
    *'{'*|*'###'*|*'##'*|*'<'*'>'*|*'*'*|*'…'*|*'NN'*)               return 0 ;;
    *'–'*|*'—'*)                                                     return 0 ;;  # en/em-dash range
    *-TEMPLATE.md|*-TEMPLATE)                                        return 0 ;;
    # The zero-index artefacts ARE the naming convention, not an instance of it.
    US000*|ADR-000*|MAP-000*|SPRINT-00*|SPRINT-PLAN-00*|*US000*)     return 0 ;;
  esac
  return 1
}

# ── Collect ──────────────────────────────────────────────────────────────────
violations=0
report=""
# The denominator, and the four numbers it takes to make a zero legible. `scanned_files` is
# what was READ; `exempt_files` is what was excluded by rule rather than absent (is_exempt
# above names each class and why); `checked_tokens` is every backticked span that survived the
# pattern filter, which is exactly what Check 2 was run against; `path_tests` is the subset of
# those that reached Check 1's existence test.
#
# CORRECTED 22/08/2026: `checked_tokens` was `checked_citations`, printed as "citation(s)". It
# is incremented ABOVE the `*/*` path guard, so it counts `git`, `--path` and `var(--token)`
# beside the paths — most of what it holds is not a citation, and naming it one overstated
# Check 1's coverage in the same direction the count line was added to correct. Renamed rather
# than moved below the guard: Check 2 reads the RAW token and fires on a slashless `US###`, so
# counting below it would understate that check by as much as the old name overstated the
# other. Two numbers, each true of the check it belongs to.
scanned_files=0
exempt_files=0
checked_tokens=0
path_tests=0

record() { # file line kind detail
  violations=$((violations + 1))
  report+="| \`$1\` | $2 | $3 | \`$4\` |"$'\n'
  log "  $1:$2  [$3]  $4"
}

# The scan itself, taking a newline-separated file list. Factored out so --self-test drives
# the IDENTICAL loop over the fixtures rather than a second implementation of it: a proof of
# a reimplementation proves nothing about the code that ships. `violations` and `report` stay
# global because the report section below reads them once the scan returns.
scan_files() { # $1 = newline-separated file list
  violations=0
  report=""
  scanned_files=0
  exempt_files=0
  checked_tokens=0
  path_tests=0
  local file lineno token line prev is_naming_row stripped resolved sibling base
  local resolved_skip=false

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue
    if is_exempt "$file"; then
      exempt_files=$((exempt_files + 1))
      continue
    fi
    scanned_files=$((scanned_files + 1))

    # Every backticked token in the file, with its line number.
    while IFS=: read -r lineno token; do
      [ -n "$token" ] || continue
      # Counted below the pattern filter, not above it: a token carrying a placeholder, a glob
      # or a `###` is a naming convention being shown rather than a citation, so it is not part
      # of the population either check could have fired on.
      is_pattern "$token" && continue
      checked_tokens=$((checked_tokens + 1))

      # An example marked as an example is not a citation. A naming table shows the pattern
      # in one column and a worked example in the next; prose writes "e.g." or "[EXAMPLE]".
      # In both, the token demonstrates a convention rather than pointing at a document, and
      # the marker is on the same line. Unmarked prose naming a specific story number is NOT
      # covered — that reads as a real story, and in a template that ships none it is exactly
      # the origin-project leakage this audit exists to catch.
      #
      # `doc-references: ignore` suppresses a line outright. It is for the one case neither
      # rule reaches: a document QUOTING a path in order to ban it, or naming a path that
      # belongs to another repository. Accepted on the line OR the line directly above it,
      # the same annotation convention the sibling audits already use.
      #
      # `doc-references: template-only` suppresses the same finding and records the opposite
      # judgement: the check DOES apply, and the citation is deliberate because the path is
      # copier-excluded and will not exist in a generated project. Nothing on this side of
      # that seam can observe the failure, so the declaration is made on the line. The two
      # markers are matched separately and written out in full rather than folded into one
      # pattern, so `grep` still tells the two judgements apart in the tree
      # (`code/docs/FORWARD-VOICE.md` Section 4).
      line="$(sed -n "${lineno}p" "$file" 2>/dev/null || true)"
      prev="$(sed -n "$((lineno > 1 ? lineno - 1 : 1))p" "$file" 2>/dev/null || true)"
      case "$prev" in
        *'doc-references: ignore'*)        line="$line doc-references: ignore" ;;
        *'doc-references: template-only'*) line="$line doc-references: template-only" ;;
      esac
      case "$line" in
        *'doc-references: ignore'*)              is_naming_row=true ;;
        *'doc-references: template-only'*)       is_naming_row=true ;;
        *'###'*|*'-##'*|*'{###}'*)               is_naming_row=true ;;
        *'<DESCRIPTOR>'*|*'<TITLE>'*|*'<NNN>'*)  is_naming_row=true ;;
        *'e.g.'*|*'E.g.'*|*'for example'*)       is_naming_row=true ;;
        *'[EXAMPLE]'*|*'house style'*)           is_naming_row=true ;;
        *)                                       is_naming_row=false ;;
      esac

      # ── Check 2 — instance citation ─────────────────────────────────────────
      if [ "$is_naming_row" = false ] && printf '%s' "$token" \
         | grep -qE '^(ADR-[0-9]{3}|US[0-9]{3}|SPRINT-[0-9]{2}|SPRINT-PLAN-[0-9]{2}|MAP-[A-Z][A-Z0-9-]+|PLAN-US[0-9]{3}|STORY-PLAN-US[0-9]{3}|BUG-[A-Z]|QA-US[0-9]{3}|API-US[0-9]{3})'; then
        base="${token##*/}"
        if ! is_seeded "$token" && [ ! -e "$token" ] && [ ! -e "project-management/src/01-FEATURE-MAPS/$base" ]; then
          record "$file" "$lineno" "instance citation" "$token"
          continue
        fi
      fi

      # ── Check 1 — dangling repo path ────────────────────────────────────────
      case "$token" in
        */*) ;;   # only tokens that look like a path
        *)   continue ;;
      esac
      case "$token" in
        http*|*@*|*' '*) continue ;;
      esac

      # Trailing backslashes survive from shell heredocs in the *.sh files.
      stripped="${token%\\}"
      # A line anchor names a location INSIDE a file, not another file: `foo.py:7` cites
      # `foo.py`. Peeled here, beside the other two peels and never before the path guard
      # above -- a port (`django:8000`) and an OWASP id (`A05:2025`) carry no slash, and that
      # guard is what already drops them. TWO branches, not one: `.+` is greedy, so a single
      # `^(.+):[0-9]+(:[0-9]+)?$` turns `a/b.py:12:34` into `a/b.py:12` rather than `a/b.py`.
      # Scoped to Check 1 deliberately -- Check 2 above reads the raw token, and hoisting this
      # over it would change `base` and the is_seeded lookup as a side effect.
      if [[ "$stripped" =~ ^(.+):[0-9]+:[0-9]+$ ]] || [[ "$stripped" =~ ^(.+):[0-9]+$ ]]; then
        stripped="${BASH_REMATCH[1]}"
      fi
      stripped="${stripped%/}"

      # Resolve relatives against the CITING file's directory, not the repo root —
      # a ../SIBLING-FOLDER/ reference means something different in each file that
      # writes it, and resolving them all from the root invents failures.
      # A `./` prefix is written for the repo root in practice, so accept either
      # reading rather than pick one and generate a false positive from the other.
      case "$stripped" in
        ../*|./*) resolved="$(cd "$(dirname "$file")" 2>/dev/null && printf '%s' "$PWD")/$stripped"
                  resolved="${resolved#"$PROJECT_ROOT"/}"
                  [ -e "${stripped#./}" ] && continue ;;
        *)        resolved="$stripped" ;;
      esac

      # The house shorthand drops the leading directories, naming a script or a guide by
      # its group alone. It is CONTEXT-DEPENDENT: the same rust/ prefix means a sibling
      # folder in code/docs/ and a script group under code/src/scripts/. Try sibling first,
      # then the script root; only then treat it as unresolved. Without this, every
      # shorthand reference is invisible to the anchor below and the check silently passes.
      case "$resolved" in
        */*)
          case "$resolved" in
            # A bare name with no extension is prose (`database/postgres` is a service).
            *.sh|*.md|*.py|*.yml|*/) ;;
            *) resolved_skip=true ;;
          esac
          if [ "${resolved_skip:-false}" = false ] && [ ! -e "$resolved" ]; then
            sibling="$(dirname "$file")/$resolved"
            sibling="${sibling#./}"
            if [ -e "$sibling" ]; then
              resolved="$sibling"
            elif [ -e "code/src/scripts/$resolved" ]; then
              resolved="code/src/scripts/$resolved"
            else
              case "$resolved" in
                audits/*|tests/*|syntax/*|database/*|development/*|deployment/*|desktop/*|mobile/*|rust/*)
                  resolved="code/src/scripts/$resolved" ;;
              esac
            fi
          fi
          resolved_skip=false ;;
      esac

      # Which trees are checkable. A path under `project-management/src/` is where a
      # project's own artefacts land — absent here by design, different at every number
      # downstream — so it falls to the catch-all and is never tested.
      #
      # CHANGED 20/08/2026: `code/src/django/` no longer falls with it. This comment used
      # to argue the opposite, naming `code/src/django/components/` alongside the artefact
      # trees on one shared reason: flagging a path a project builds would hold the gate
      # permanently red, which is the same as having no gate. That reasoning had one
      # premise, and the premise has changed — there was nowhere to write down that such a
      # path is coming. `how-to/src/PROJECT-PATHS.md` is that place now, so a citation of
      # a project-built path is a CHECKED PROMISE rather than an unprovable assertion: it
      # carries a row, and the row names what creates it. Three paths clear that bar today.
      # Everything else under this tree is tested exactly like any other citation, and the
      # remedy for a finding is the default disposition in `code/docs/FORWARD-VOICE.md`
      # Section 1 — correct the citation or drop it, never add a row to quieten it.
      #
      # Tense buys nothing here, and that is the point. "The app a story will build" and
      # "the live app" fail identically, because the gate reads the PATH. Forward voice is
      # still required of the prose (`code/docs/FORWARD-VOICE.md` Section 6) — it is what
      # keeps a registered promise readable as a promise — but it is a rule for the writer
      # and the reviewer, and this check does not enforce it.
      case "$resolved" in
        # Generated output. The folder appears when the script that fills it is run,
        # so its absence is the normal state, not a broken citation.
        */reports/*|*/coverage/*|*/staticfiles/*|.claude/worktrees/*|.claude/worktrees) continue ;;
        # The same class as a FILE rather than a folder, and the reason this arm needed
        # stating twice. `install.sh` writes code/docs/MACHINE-SPEC.md (install.sh:25,:518)
        # and .gitignore:43 ignores it, so it is present on a developer's disk and absent
        # from a fresh checkout -- which made this gate's verdict a property of the disk
        # rather than of the repository: exit 0 here, exit 1 in a clean clone. Measured
        # 18/08/2026, blast radius exactly one citing site over the whole repo
        # (.github/scripts/shipped-readme.sh:141, the comment explaining this very hazard
        # for a different script). MAP-BASE-HEALTH N-042.
        code/docs/MACHINE-SPEC.md) continue ;;
        code/docs/*|code/workflows/*|code/src/scripts/*|code/CONTEXT.md|code/CLAUDE.md|code/REFERENCES.md) ;;
        code/src/django/*) ;;
        how-to/docs/*|how-to/workflows/*|how-to/src/*) ;;
        project-management/docs/*|project-management/workflows/*) ;;
        .claude/*|.github/*) ;;
        *) continue ;;
      esac

      # Counted HERE, at the existence test, and nowhere earlier: everything above this line
      # is Check 1 deciding whether the token is a repo path at all, and a token dropped by
      # the URL, shorthand or checkable-tree arms was never tested. This is the population a
      # dangling-path finding could have come from.
      path_tests=$((path_tests + 1))
      [ -e "$resolved" ] && continue
      is_seeded "$resolved" && continue
      is_registered "$resolved" && continue
      [ "$is_naming_row" = true ] && continue
      record "$file" "$lineno" "dangling path" "$token"
    done < <(grep -noE '`[^`]+`' "$file" 2>/dev/null | sed 's/`//g' || true)
  done <<< "$1"
}

# ── Self-test ────────────────────────────────────────────────────────────────
# Three clauses were added on 20/08/2026 and an ordinary run of this repository proves almost
# nothing about them: no line-anchored citation resolves here, no line carries the
# template-only marker, and the code/src/django/ arm has nothing left to fire on the moment
# the tree is green -- which is exactly when nobody looks at it again. A green run over a
# population of nought is believed exactly as much as a green run over a real one, so the
# clauses are proven in BOTH directions against fixtures instead -- fires on known-bad, silent
# on known-good. Only those three are covered; the checks that shipped before them are
# unchanged and are not re-proven here.
#
# Fix the detector, never the fixtures.
st_fails=0
st_probes=0
st_fail() { st_fails=$((st_fails + 1)); printf '\033[31m  ✗ %s\033[0m\n' "$*" >&2; }

st_probe() { # label file want-violations want-substring
  local label="$1" file="$2" want_v="$3" want_sub="${4:-}"
  st_probes=$((st_probes + 1))
  scan_files "$file"
  if [ "$violations" -ne "$want_v" ]; then
    st_fail "$label: expected $want_v finding(s), got $violations"
    return
  fi
  if [ -n "$want_sub" ] && [ "${report#*"$want_sub"}" = "$report" ]; then
    st_fail "$label: no finding names \`$want_sub\`"
    return
  fi
  log "  ✓ $label"
}

self_test() {
  bold "▸ doc-references.sh --self-test"
  log ""
  [ -d "$FIXTURES_DIR/broken" ] && [ -d "$FIXTURES_DIR/clean" ] \
    || die "fixtures missing at $FIXTURES_DIR — refusing to report a proof that never ran"

  log "  known-bad — every line printed below is expected:"
  # The anchor peel must not make a dangling path resolve, and the finding must still quote
  # the citation as the author wrote it: `record` reports the raw token, never the peeled one.
  st_probe "broken/anchors.md      fires on both anchor forms" \
    "$FIXTURES_DIR/broken/anchors.md" 2 'NO-SUCH-GUIDE.md:7'
  # A marker two lines above is not the documented window, and template-only is per line
  # rather than per file. Both halves fail here, which is what keeps the token narrow.
  st_probe "broken/tokens.md       fires past the marker's window" \
    "$FIXTURES_DIR/broken/tokens.md" 2 'FIXTURE-ONLY-TWO-LINES-ABOVE.md'
  # The arm, in the direction nobody watches: a project-built path with no row must fire,
  # and forward voice must not save it. Both citations below are unbacked; one is written
  # "will write" and fails identically, because the clause reads the path.
  st_probe "broken/django-arm.md   fires on an unregistered project-built path" \
    "$FIXTURES_DIR/broken/django-arm.md" 2 'no_such_app/views.py'

  log ""
  log "  known-good — nothing below should print a finding:"
  # Without the peel every line here is a finding, and the `:N:M` form is the one that a
  # single greedy regex gets wrong: it would leave `…doc-references.sh:12` and report it.
  st_probe "clean/anchors.md       silent on :N, :N:M, a port and an OWASP id" \
    "$FIXTURES_DIR/clean/anchors.md" 0
  st_probe "clean/tokens.md        silent on template-only, on-line and line-above" \
    "$FIXTURES_DIR/clean/tokens.md" 0
  # The other direction, and the one probe here that reads a file outside this folder:
  # the three rows in how-to/src/PROJECT-PATHS.md, plus a path under the same tree that
  # passes on existing alone. Retiring a row reddens this probe, which is the point.
  st_probe "clean/django-arm.md    silent on the registered rows and on what exists" \
    "$FIXTURES_DIR/clean/django-arm.md" 0

  # The fixtures must stay invisible to an ordinary run, or this proof reddens the gate it
  # exists to prove. Asserted directly, with the flag put back the way a normal run sees it.
  st_probes=$((st_probes + 1))
  SELF_TEST=false
  if is_exempt "$FIXTURES_DIR/broken/anchors.md"; then
    log "  ✓ the fixture tree is exempt from an ordinary run"
  else
    st_fail "the fixture tree is NOT exempt — an ordinary run would report its dangling paths"
  fi
  SELF_TEST=true

  log ""
  if [ "$st_fails" -eq 0 ]; then
    bold "✓ Self-test passed — $st_probes probes over the three clauses added 20/08/2026."
    log "  Not covered: the two checks that shipped before them, and Direction B itself —"
    log "  nothing here reads copier.yml's _exclude list (code/docs/FORWARD-VOICE.md Section 5)."
    return 0
  fi
  bold "✗ Self-test FAILED — the detector no longer separates the fixtures."
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

# ── Run ──────────────────────────────────────────────────────────────────────
FILES="$(candidates)"
# Filtered on a LITERAL prefix rather than a regex. `.claude`, `.github` and `.copier` all open
# with a `.`, which a regex reads as "any character" — `^.claude(/|$)` would take a `Xclaude/`
# path too. awk's index() has no metacharacters, so the scope means the path that was typed.
if [ -n "$TARGET_PATH" ]; then
  FILES="$(printf '%s\n' "$FILES" | awk -v p="$TARGET_PATH" 'index($0, p "/") == 1 || $0 == p')"
fi

bold "doc-references.sh — checking citations resolve"
[ -n "$TARGET_PATH" ] && log "  scope: $TARGET_PATH"

scan_files "$FILES"

# ── Report ───────────────────────────────────────────────────────────────────
# The count comes before the verdict, because it is what the verdict is a verdict OVER. An
# exempt file is named separately from an absent one: the first was excluded by a rule this
# script states, the second was never there, and only the second makes a clean run empty.
log "  read    $scanned_files file(s); $exempt_files exempt by rule"
log "  checked $checked_tokens backticked token(s) — $path_tests of them tested as repo paths"

if [ "$scanned_files" -eq 0 ]; then
  # An absent surface, not an absent tool: the population is legitimately empty, so exit 0 is
  # honest — but only while the run says the population was empty. A bare success line here
  # reads as "looked, and it was clean" (code/docs/GATE-REPORTING.md Section 2).
  bold "Nothing to check — nothing eligible to read under ${TARGET_PATH:-the repository}."
elif [ "$violations" -eq 0 ]; then
  bold "Clean — every citation resolves."
else
  bold "$violations citation(s) do not resolve."
  log ""
  log "Rule: a shipped file may cite layering-system artefacts only (CONTEXT.md,"
  log "CLAUDE.md, docs/, workflows/, scripts, guides) and never a per-project"
  log "instance (ADR-###, US###, SPRINT-##, MAP-*, PLAN-*). Drop the citation, or"
  log "point at the guide that carries the rule."
fi

if [ -n "$OUTPUT_FORMAT" ]; then
  mkdir -p "$REPORTS_DIR"
  out="${OUTPUT_FILE:-$REPORTS_DIR/doc-references.md}"
  # The artefact carries the denominator too. A consumer reading only the file — a CI job
  # collecting it, or a --quiet run that printed nothing — otherwise cannot tell a scan of the
  # whole tree from one that read no file at all, which is the same defect on a different
  # surface (code/docs/GATE-REPORTING.md).
  {
    printf '# doc-references\n\n'
    printf 'Scope: %s\n\n' "${TARGET_PATH:-the whole repository}"
    printf 'Files scanned: %s (%s exempt by rule)\n\n' "$scanned_files" "$exempt_files"
    printf 'Backticked tokens checked: %s (%s tested as repo paths)\n\n' "$checked_tokens" "$path_tests"
    printf 'Violations: %s\n\n' "$violations"
    if [ "$scanned_files" -eq 0 ]; then
      printf 'Nothing to check: no eligible file under this scope, so no citation could fail.\n'
    fi
    if [ "$violations" -gt 0 ]; then
      printf '| File | Line | Kind | Citation |\n| --- | --- | --- | --- |\n%s' "$report"
    fi
  } > "$out"
  log "Report: $out"
fi

[ "$violations" -eq 0 ] || exit 1
