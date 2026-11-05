#!/usr/bin/env bash
#
# doc-references.sh — Every citation in a shipped file must resolve in every project.
#
#                     Two checks, one rule. A file that ships is read in a project that is
#                     not this one, so it may cite only what that project is guaranteed to
#                     have: the LAYERING SYSTEM — CONTEXT.md, CLAUDE.md, docs/, workflows/,
#                     scripts, guides. It may never cite a PER-PROJECT INSTANCE — ADR-US###,
#                     US###, SPRINT-##, MAP-*, PLAN-*, BUG-*, QA-* — because a generated
#                     project has different ones at those numbers, or none at all.
#
#                     Check 1 — dangling path.     A backticked repo path that does not exist.
#                     Check 2 — instance citation. A named instance artefact, cited as real.
#                     Check 3 — template-only.     A path this repository holds and copier
#                                                  EXCLUDES, cited by a file that ships,
#                                                  without the marker that declares it.
#                     Check 4 — plan prefix.       A story-plan or sprint-plan FILENAME
#                                                  written without its two-digit
#                                                  exec-order prefix. ADDED 08/09/2026,
#                                                  and the odd one out: a NAMING rule,
#                                                  decided from the string, never from
#                                                  whether anything exists. Its own long
#                                                  comment sits at the clause below.
#
#                     ADDED 20/08/2026: Check 1 peels a trailing LINE ANCHOR before the
#                     existence test. An anchor names a location INSIDE a file rather than
#                     another file -- `foo.py:7` cites `foo.py` -- and the `:N` plain form,
#                     the `:N:M` column form and the `:N-M` RANGE form are peeled. It sits
#                     AFTER the path guard, so a port
#                     (`django:8000`) and an OWASP id (`A05:2025`) never reach it: neither
#                     carries a slash, and that guard already drops them. Check 2 tests the
#                     RAW token and is deliberately left alone -- hoisting the peel above it
#                     would move `base` and the is_seeded lookup with it, which is a second
#                     decision nobody has made. Known limit of that scoping, stated rather
#                     than left to be found: a line-anchored INSTANCE citation would still
#                     false-positive at Check 2. None exists today.
#
#                     CORRECTED 01/09/2026: the RANGE form was missing, and the comment above
#                     said "both" of two forms as though the set were closed. `:N-M` is the
#                     house form wherever a citation names a BLOCK rather than a line, and it
#                     reached the existence test unpeeled, so
#                     `code/src/django/config/settings/dev.py:22-29` was reported as a dangling
#                     path while the file it names sits in the tree.
#
#                     MEASURED, because "common" is the kind of word that turns out to mean
#                     nothing -- 272 occurrences over 18 tracked files:
#                       grep -rhoE '`[^`]*:[0-9]+-[0-9]+`' $(git ls-files) | wc -l
#                     Exactly ONE of them ever reached the existence test, and the other four
#                     arms are why: an exempt tree
#                     (`project-management/src/01-FEATURE-MAPS/`, `research/`), no slash so the
#                     path guard drops it first, a path resolving outside a checkable tree so
#                     the catch-all drops it, or this audit's own fixtures, exempt outside
#                     `--self-test`. A form this widespread stayed invisible for twelve days on
#                     a population of one.
#
#                     Check 3 ran its own copy of the same peel, and BOTH copies were missing
#                     the branch. That is the failure duplication produces, so the peel is now
#                     one `peel_anchor()` helper called from both -- and Check 3's copy had
#                     never been fixtured at all, which is why only Check 1's half of the drift
#                     could ever have been caught. `{broken,clean}/direction-b.md` carry an
#                     anchored excluded path as of this change, so deleting the branch from
#                     either caller now reddens the self-test.
#
# ADDED 23/08/2026: CHECK 3 — Direction B is derived rather than declared. Until now nothing
#                 read `copier.yml`'s `_exclude` list, so a path the template holds and never  # doc-references: template-only
#                 ships was green whenever the writer forgot the marker: the token was applied
#                 by hand and checked by a reviewer, and a green run meant "no path is missing
#                 HERE", never "every citation survives generation". It now means both.
#                 Rule: `code/docs/FORWARD-VOICE.md` Sections 2 and 4.
#
#                 THE SET IS PARSED, NEVER LISTED, so a new exclusion needs no edit here. Three
#                 classes go into `_exclude` and exactly one comes out:
#
#                   ANCHORED   /copier.yml, /research/**   Template content. THIS is the set.
#                   NEGATED    !/research/CONTEXT.md       Re-included at generation; subtracted.
#                   UNANCHORED node_modules, *.pdf         "Never a checkout" — build output, not
#                                                          template content. The LEADING SLASH is
#                                                          what tells the two apart, and every
#                                                          template-content entry carries one.
#                   TEMPLATED  a delimited `if not INCLUDE_RUST`  Absent only where the surface
#                                                          DECLINED, so `template-only` would be
#                                                          false in every project that took it.
#                                                          Out of scope BY DECISION, not by
#                                                          oversight: those citations keep the
#                                                          prose `rust-only` / `mobile-only`
#                                                          convention their index rows carry.
#
#                 Seeded paths are subtracted too — an excluded file re-supplied from `.copier/`
#                 exists downstream — as is `uv.lock`, which is excluded and REGENERATED by the
#                 `uv lock` task rather than seeded. Both are read from `_tasks`, not hardcoded.
#
#                 A CITING FILE THAT DOES NOT SHIP IS SKIPPED for this check alone, because
#                 Direction B is a rule about what a SHIPPED document claims. That predicate is
#                 derived here from `copier.yml`; `is_exempt()` below hardcodes its own tree  # doc-references: template-only
#                 arms. RECONCILED 05/11/2026 (US004 P1): those arms said "none of these ship"
#                 while the pair files and templates copier re-includes out of them did, so a
#                 fall-through arm above them now mirrors copier's re-includes, tree by tree, and
#                 lets those files back into the scan. And both predicates read ONE population
#                 (US004 P2, repo_files() below), so an untracked file's verdict no longer
#                 depends on whether it has been staged.
#
#                 ACCEPTED COST, stated rather than found later: `GAPS.md`, `DEFERRED.md`,
#                 `README.md` and `.claude/MEMORY.md` are excluded AND seeded, so THIS
#                 repository's copies never ship and their markers buy nothing here. They are
#                 marked anyway, because the seeded file downstream sits at the same path and a
#                 project writing into its own register must be policed — the same reasoning
#                 that refused those files an exemption from Check 1 on 22/08.
#
#                 Check 3 keys on the two markers ALONE and never on `is_naming_row`'s example
#                 indicators: "e.g." says a citation is illustrative, not that it survives
#                 generation, and the two judgements must not be spelt the same way.
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
#                 handoffs/ and .copier/ are staging. Never what copier re-includes from an
#                 exempt tree, which ships (US004 P1): the top-level research/, handoffs/ and
#                 learning/ pairs, and every pair and `-TEMPLATE.` file under the PM tree.
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
#                 21/08 so the guides beside it were scanned like any other shipped
#                 file, and RETIRED 22/08 when that file was folded into
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
#                 none. It covers the clauses added since 20/08/2026 and the four US004
#                 repairs (05/11/2026) and nothing else, because a green run
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
checked, how many of those were tested as repo paths, and how many paths copier excludes
unconditionally — before its verdict. A scope is
normalised to the repo-relative form first, and one that does not exist, or that resolves
outside the repository, is refused at exit 2.

Suppress a citation with `doc-references: ignore` (neither check applies) or
`doc-references: template-only` (the check applies; the path does not ship), on the
line or the line directly above it. The two are not synonyms — `code/docs/FORWARD-VOICE.md`.
Check 3 reads both and neither the example markers nor `e.g.`: an illustration is not a
claim that the path survives generation.

A [plan prefix] finding is the naming rule, not a missing file: a story-plan or
sprint-plan filename must carry its two-digit exec-order prefix. Add the prefix the
plan is on disk under; never suppress it. The prefix is renumbered when build order
changes, so a name quoted from before a renumber goes in "double quotes", not backticks.

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
#
# ONE POPULATION, TWO READERS (US004 P2, 05/11/2026). `repo_files` is every file of any type;
# `candidates` narrows it to what this check reads, and `build_template_only` below reads it
# whole. Until US004 that builder read `git ls-files` alone, so an UNTRACKED file under an
# excluded tree was scanned here and missing from the derived set: the same bytes shipped or
# did not depending on whether anyone had run `git add`, and Check 3 fired on every citation
# such a file made to a committed, excluded sibling. Both now read the one function.
repo_files() {
  { git ls-files -z; git ls-files -z --others --exclude-standard; } \
    | tr '\0' '\n' | sort -u || true
}
candidates() {
  repo_files | grep -E '\.(md|sh)$' || true
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
    #
    # MOVED 05/11/2026 (US004 P1): the vendored and fixture arms now sit ABOVE the pair-and-
    # template fall-through below, so each stays exempt for its own reason — a vendored
    # `CONTEXT.md` is upstream's text, and a `-TEMPLATE.` fixture is reached by --self-test alone.
    code/docs/cloudinary/*)                       return 0 ;;  # vendored SDK docs
    .agents/*)                                    return 0 ;;  # vendored third-party skills
    # This audit's own fixtures, exempted as docs-pairing.sh exempts the same tree and for
    # the same reason: the audits run against these files, so a fixture that deliberately
    # carries a dangling path would redden the ordinary run rather than prove anything. They
    # are reached only through --self-test, which points the identical scan at them on
    # purpose -- so the exemption lifts there and nowhere else.
    code/src/scripts/audits/fixtures/*)
      if ! $SELF_TEST; then return 0; fi ;;
    # ADDED 05/11/2026 (US004 P1): the files copier lifts back OUT of the exempt trees below.
    # `copier.yml`'s allowlist block — _The artefact trees: tracked HERE, never shipped_ —  # doc-references: template-only
    # re-includes some CONTEXT.md, CLAUDE.md and `-TEMPLATE.` files from them, so those ship and
    # are policed like any other shipped file. NARROWED 05/11/2026 (US004 phase 9, F5 /
    # QA-US004-01): the arm was global and copier's negations are scoped, so it mirrors them
    # tree by tree — the TOP-LEVEL pair of research/, handoffs/ and learning/ alone, and under
    # project-management/src/ every pair and every `-TEMPLATE.` file at any depth. A nested
    # research/ pair, a template outside the PM tree and anything under .copier/ stay exempt,
    # because copier drops them. A new negation in copier.yml needs a matching arm here.
    # `-TEMPLATE.` and not the bare word: copier re-includes `*-TEMPLATE.*`, and the bare form
    # would read an ADR whose title merely contains the word as shipped.
    research/CONTEXT.md|research/CLAUDE.md|handoffs/CONTEXT.md|handoffs/CLAUDE.md) return 1 ;;
    learning/CONTEXT.md|learning/CLAUDE.md)       return 1 ;;
    project-management/src/*/CONTEXT.md|project-management/src/*/CLAUDE.md) return 1 ;;
    project-management/src/*-TEMPLATE.*)          return 1 ;;
    handoffs/*|.copier/*)                         return 0 ;;
    # The artefact trees. This rule polices what a SHIPPED file may cite, and these FOLDERS
    # do not ship — copier.yml `_exclude` empties every one of them at generation, bar the
    # pair files and templates the arm above has already let through. CORRECTED 05/11/2026:
    # this read "none of these ship" until US004, while eleven files inside them did. A map
    # cites sibling maps and paths that do not exist yet BY DESIGN: charting future work
    # is what it is for, and the citation resolves when the work lands.
    #
    # These were exempt by accident until 17/08/2026, and the candidates() comment above
    # still described that mechanism: the trees were gitignored, so `git ls-files` never
    # saw them. They are committed now — so they sync across devices — which made 160
    # citations visible in one commit. The exemption is stated here instead.
    research/*|learning/*)                        return 0 ;;
    project-management/src/01-FEATURE-MAPS/*)          return 0 ;;
    # A walk-test RUN, on the same argument as the maps above: copier excludes every WALK-* file,
    # so none of them ships. Three of the four are also CAPTURED rather than authored -- the
    # prompt a cold reader was given, its verbatim answer, and the transcript. The report is
    # evidence of what a stranger cited INCLUDING WHAT IT CITED WRONGLY, and the first run's
    # value is precisely that it named a per-project map and a line-suffixed path no shipped file
    # may name. Editing it to satisfy this gate would destroy the record the folder holds. The
    # fourth, the result, is authored here and cites the map whose node it settles -- the same
    # citation 01-FEATURE-MAPS is exempted for, one file further out.
    #
    # Scoped to WALK-* deliberately. The folder's own CONTEXT.md and CLAUDE.md DO ship and stay
    # policed -- the exemption covers the evidence, never the documentation over it.
    project-management/src/00-ASSETS/WALK-TESTS/WALK-*) return 0 ;;
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
  | grep -oE "^\\| \`[^\`]+\`" | tr -d '|` ' | sed 's:/$::' || true)"

# PATTERNED ROWS (US004 P4, 05/11/2026). A row may bind a CLASS of per-story records: `###` in
# it means exactly three digits, everything else is literal, and the whole path must match —
# so one row covers every story's record, while four digits or letters are never members. A
# zero-index or `-TEMPLATE.` target is never registered, by any row: a shipped template is a
# literal presence obligation, checked before this is consulted, and a class row that covered
# it would hide the template's absence (ADR-US004-PATTERNED-REGISTRATION-PRESERVES-SHIPPED-
# TEMPLATES-09-10-2026). Reads `$REGISTERED` at call time, so --self-test can stand a
# fixture-local row in for the real ones.
is_registered() {
  [ -n "$REGISTERED" ] || return 1
  case "${1##*/}" in *US000*|*-TEMPLATE.*) return 1 ;; esac
  local row re
  while IFS= read -r row; do
    [ -n "$row" ] || continue
    case "$row" in
      *'###'*)
        re="$(printf '%s' "$row" | sed -e 's/[].[^$*+?(){}|\\]/\\&/g' -e 's/###/[0-9]{3}/g')"
        [[ "$1" =~ ^${re}$ ]] && return 0 ;;
      *)
        [ "$row" = "$1" ] && return 0 ;;
    esac
  done <<< "$REGISTERED"
  return 1
}

# Copier renders this file into every generated project, so the two delimiter pairs must
# never appear literally in it — Jinja would try to parse them and generation would die with
# TemplateSyntaxError. They are assembled here instead, which is also why the patterns below
# are variables rather than inline globs.
LT='<'
TOK_OPEN="${LT}%"
BLK_OPEN="${LT}:"

# ── Direction B — the paths copier excludes (Check 3) ────────────────────────
# The three classes and why only one survives are in the header. `path_matches` implements
# copier's two glob shapes: `a/**` covers the tree, and `a/**/b` matches `a/b` as well as
# `a/x/b` — the second is why the substitution below exists, and getting it wrong would
# silently ship the two `project-management/src/` pair files into this set.
path_matches() { # path glob
  local p="$1" g="$2" g2
  case "$g" in
    */'**') g="${g%/**}"; [[ "$p" == "$g" || "$p" == "$g"/* ]] && return 0; return 1 ;;
  esac
  g2="${g//\/\*\*\//\/}"
  # shellcheck disable=SC2053  # glob match is the point, not a string comparison
  [[ "$p" == $g ]] && return 0
  # shellcheck disable=SC2053
  [[ "$p" == $g2 ]] && return 0
  [[ "$p" == "$g" || "$p" == "$g"/* ]] && return 0
  return 1
}

declare -A TEMPLATE_ONLY=()
declare -A TEMPLATE_ONLY_DIR=()
template_only_paths=0

build_template_only() {
  local raw entry anchored=() negated=() f d
  raw="$(awk '/^_exclude:/{on=1; next} on && /^[A-Za-z_]+:/{exit} on' copier.yml 2>/dev/null || true)"
  [ -n "$raw" ] || return 0
  while IFS= read -r entry; do
    entry="${entry#"${entry%%[![:space:]]*}"}"
    case "$entry" in -\ *) entry="${entry#- }" ;; *) continue ;; esac
    entry="${entry%%[[:space:]]#*}"
    entry="${entry#\"}"; entry="${entry%\"}"
    entry="${entry%"${entry##*[![:space:]]}"}"
    case "$entry" in
      "$BLK_OPEN"*) continue ;;                 # templated — surface-gated, out of scope
      "!/"*)  negated+=("${entry#!/}") ;;
      /*)     anchored+=("${entry#/}") ;;
      *)      continue ;;                       # unanchored — never part of a checkout
    esac
  done <<< "$raw"
  [ "${#anchored[@]}" -gt 0 ] || return 0

  local -a population
  mapfile -t population < <(repo_files 2>/dev/null)
  local g keep
  for f in "${population[@]}"; do
    keep=false
    for g in "${anchored[@]}"; do path_matches "$f" "$g" && { keep=true; break; }; done
    $keep || continue
    for g in "${negated[@]}"; do path_matches "$f" "$g" && { keep=false; break; }; done
    $keep || continue
    is_seeded "$f" && continue
    # Excluded and REGENERATED by the `uv lock` task rather than seeded from .copier/, so it
    # exists downstream under the project's own slug. Read from _tasks, not asserted.
    if grep -q "uv lock" copier.yml 2>/dev/null && [ "$f" = "uv.lock" ]; then continue; fi
    TEMPLATE_ONLY["$f"]=1
    template_only_paths=$((template_only_paths + 1))
  done

  # A cited DIRECTORY is template-only when every file under it is. `.github/scripts`  # doc-references: template-only
  # qualifies; `handoffs` does not, because its documentation pair is re-included and ships.
  local -A dir_total=() dir_absent=()
  for f in "${population[@]}"; do
    d="$f"
    while [ "${d%/*}" != "$d" ]; do
      d="${d%/*}"
      dir_total["$d"]=$(( ${dir_total["$d"]:-0} + 1 ))
      [ -n "${TEMPLATE_ONLY[$f]:-}" ] && dir_absent["$d"]=$(( ${dir_absent["$d"]:-0} + 1 ))
    done
  done
  for d in "${!dir_total[@]}"; do
    if [ "${dir_absent[$d]:-0}" -eq "${dir_total[$d]}" ]; then TEMPLATE_ONLY_DIR["$d"]=1; fi
  done
  return 0
}

# The BASENAME index is what keeps Check 3 free. Without it every backticked token in the
# repository — 28,705 of them — would pay a `dirname` and a `stat` to find out it is not one
# of forty paths, which measured at 2m14s against 7s for the whole audit. One associative
# lookup on the last path segment rejects all but a few hundred before any of that runs.
declare -A TEMPLATE_ONLY_BASE=()
build_template_only_index() {
  local k
  for k in "${!TEMPLATE_ONLY[@]}";     do TEMPLATE_ONLY_BASE["${k##*/}"]=1; done
  for k in "${!TEMPLATE_ONLY_DIR[@]}"; do TEMPLATE_ONLY_BASE["${k##*/}"]=1; done
  return 0
}

is_template_only() {
  local p="${1%/}"
  p="${p#./}"
  [ -n "${TEMPLATE_ONLY[$p]:-}" ] && return 0
  [ -n "${TEMPLATE_ONLY_DIR[$p]:-}" ] && return 0
  return 1
}

build_template_only
build_template_only_index

# ONE PEEL, TWO CALL SITES. A line anchor names a location INSIDE a file rather than another
# file -- `foo.py:7` cites `foo.py` -- and Check 1 and Check 3 each strip one before their own
# lookup. Written twice until 01/09/2026, which is exactly how the forms drifted: the range
# branch was missing from BOTH copies, and the self-test could only ever have caught it in one
# (nothing fixtured Check 3's). Factored here so a fixture over either check proves the form
# for both.
#
# THREE branches, not one regex: `.+` is greedy, so `^(.+):[0-9]+([:-][0-9]+)?$` turns
# `a/b.py:12:34` into `a/b.py:12` rather than `a/b.py`. Ordered column, range, plain -- `||`
# short-circuits, so BASH_REMATCH carries the FIRST branch to match and the plain form, which
# is a prefix of the other two, must come last.
#
# A FOURTH FORM, peeled first (US004 R2.3, 05/11/2026): a record citing several lines of one
# file comma-joins the anchors -- `foo.py:12,:40`, repeated as often as it likes. Each trailing
# `,:N` is stripped in a loop before the three branches run, so what remains is the ordinary
# `:N` form. A loop rather than one `(,:[0-9]+)+` group because POSIX leftmost-longest gives the
# leading `.+` every repeat but the last. Both Check 1 routes peel here -- the ordinary one
# and the shipped-template presence route -- so the form is proven once for each by fixture.
#
# Sets `peeled` rather than echoing. This runs once per backticked token -- 29k times on an
# unscoped run -- and a command substitution forks a subshell each time, which costs more than
# every other check in this file put together. `scan_files()` declares `peeled` local, so
# bash's dynamic scoping keeps it out of the global namespace.
#
# NEITHER CALL SITE MAY HOIST THIS ABOVE CHECK 2, which reads the RAW token: peeling there
# would move `base` and the is_seeded lookup with it, and that is a decision nobody has made.
peel_anchor() { # $1 = token -> sets `peeled`
  peeled="$1"
  while [[ "$peeled" =~ ^(.+),:[0-9]+$ ]]; do
    peeled="${BASH_REMATCH[1]}"
  done
  if [[ "$peeled" =~ ^(.+):[0-9]+:[0-9]+$ ]] \
     || [[ "$peeled" =~ ^(.+):[0-9]+-[0-9]+$ ]] \
     || [[ "$peeled" =~ ^(.+):[0-9]+$ ]]; then
    peeled="${BASH_REMATCH[1]}"
  fi
}

# ONE NORMALISER FOR A RELATIVE CITATION (US004 phase 9, F1 and F8, 05/11/2026). Takes a path
# relative to the repository root that may carry `.` and `..` segments -- the citing file's
# directory joined to the token -- and collapses them textually, as normalise_scope() does for
# --path. Pure bash: it replaced two `realpath -m --relative-to` calls, which BSD and macOS
# realpath reject, and whose `|| printf` fallback then kept the unnormalised path in silence.
# Returns 1 when the path climbs out of the repository: such a target is not a repository
# path, so neither check may test it as one. Sets `normalised` rather than echoing, for the
# reason peel_anchor() gives; scan_files() declares it local. Symlinks are not followed.
normalise_rel() { # $1 = root-relative path holding . or .. -> sets `normalised`; 1 = outside the repo
  local rest="$1" seg out=""
  while [ -n "$rest" ]; do
    seg="${rest%%/*}"
    if [[ "$rest" == */* ]]; then rest="${rest#*/}"; else rest=""; fi
    case "$seg" in
      ''|.) ;;
      ..)   [ -n "$out" ] || return 1
            if [[ "$out" == */* ]]; then out="${out%/*}"; else out=""; fi ;;
      *)    out="${out:+$out/}$seg" ;;
    esac
  done
  normalised="$out"
}

# A token with a template placeholder, a numeric pattern, or a glob is not a citation.
# The literal house date placeholder `DD-MM-YYYY` in a name is one too (US004 R2.4, 05/11/2026):
# it describes a dated artefact's naming convention, and the same path carrying a real date is
# still a citation and still checked. Only the BASENAME is a placeholder (US004 phase 9,
# QA-US004-12): the folder such a token names is concrete, so scan_files() tests that folder.
# Split out of is_pattern() on 05/11/2026 so the template-presence test below can ask the
# placeholder question alone.
is_placeholder() {
  case "$1" in
    *"$TOK_OPEN"*|*"$BLK_OPEN"*)                                     return 0 ;;
    *'{'*|*'###'*|*'##'*|*'<'*'>'*|*'*'*|*'…'*|*'NN'*)               return 0 ;;
    *'–'*|*'—'*)                                                     return 0 ;;  # en/em-dash range
    *DD-MM-YYYY*)                                                    return 0 ;;  # date placeholder
  esac
  return 1
}

# A SHIPPED TEMPLATE NAMED BY PATH IS A CITATION, NOT A PATTERN (US004, 05/11/2026). The
# zero-index and `-TEMPLATE.` files are the convention, so a BARE name or a placeholder spelling
# of one stays a pattern below. A path-form token naming one points at a file the template
# must ship, and is_pattern() used to drop it before any check ran, so a deleted template went
# unreported wherever it was cited. Such a token skips is_pattern() and reaches Check 1, which
# tests its existence before any seeded, registered or naming-row suppression.
is_template_target() {
  case "$1" in */*) ;; *) return 1 ;; esac
  is_placeholder "$1" && return 1
  # A `.../` elision is the ASCII spelling of the `…` placeholder: a schematic path whose
  # leading folders are left out, which names no one file (US004 phase 9, QA-US004-08).
  case "$1" in *'.../'*) return 1 ;; esac
  case "${1##*/}" in *US000*|*-TEMPLATE.*) return 0 ;; esac
  return 1
}

# ── The instance forms, the cited side and the citing side ──────────────────
# Check 2's alternation: a token matching it names a per-project instance. CORRECTED
# 05/11/2026 (US004 P3): `ADR-US[0-9]{3}` replaces the bare-number decision form retired
# 31/08/2026, and `QA-PLAN-US[0-9]{3}` replaces a QA form no artefact was ever named with.
INSTANCE_CITED_RE='^(ADR-US[0-9]{3}|US[0-9]{3}|SPRINT-[0-9]{2}|([0-9]{2}-)?SPRINT-PLAN-[0-9]{2}|MAP-[A-Z][A-Z0-9-]+|PLAN-US[0-9]{3}|([0-9]{2}-)?STORY-PLAN-US[0-9]{3}|BUG-[A-Z]|QA-PLAN-US[0-9]{3}|API-US[0-9]{3})'
# The citing side (US004 P3): a per-project artefact whose FILE never ships, so what it cites
# is no claim a generated project reads. A DERIVED RULE, not a list of forms (US004 R2.1,
# project-management/src/15-DECISIONS/ADR-US004-INSTANCE-CITER-IS-A-DERIVED-RULE-05-11-2026.md):
# the basename carries a story number (US + exactly three digits) or a sprint number (SPRINT-,
# optionally PLAN-, + exactly two digits), anywhere in the name, or it starts BUG-. Every
# per-story artefact's name carries its number by convention, so the rule tracks the convention
# rather than a copy of it that drifts. The digit runs are BOUNDED -- a further digit after the
# run means it is not a story or sprint number, at the start of the name or mid-name. So is the
# LEFT side (US004 phase 9, F4): the number starts the name or follows a non-letter, so a word
# that merely ends in US -- STATUS200, CORPUS123 -- is not a story number. Not the
# same set as the cited side above: a review record cites and is never cited, a map is cited
# and lives in an exempt tree. The zero-index and `-TEMPLATE.` files match and DO ship, so
# is_instance_citer() excludes them and they stay policed.
INSTANCE_CITER_RE='(^|[^A-Za-z])(US[0-9]{3}|SPRINT-(PLAN-)?[0-9]{2})([^0-9]|$)|^BUG-'

is_instance_citer() { # $1 = citing file path
  local name="${1##*/}"
  case "$name" in *US000*|*-TEMPLATE.*) return 1 ;; esac
  [[ "$name" =~ $INSTANCE_CITER_RE ]]
}

is_pattern() {
  is_placeholder "$1" && return 0
  case "$1" in
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
  local is_marked file_ships file_dir tmpl tmpl_base peeled plan citer_instance template_target
  local citer_seeded normalised check_tok date_dir relative tok_base
  local resolved_skip=false

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue
    if is_exempt "$file"; then
      exempt_files=$((exempt_files + 1))
      continue
    fi
    scanned_files=$((scanned_files + 1))
    # Whether the CITING file ships. A file copier EXCLUDES is non-shipping for Check 3 alone:
    # Direction B is a rule about what a shipped document claims, and a file copier drops takes
    # its citations with it. A file copier SEEDS from .copier/ is non-shipping for Checks 2 AND
    # 3 (ADDED 05/11/2026, US004, the story plan's Key Decisions row "Seeded citers"): the seed
    # replaces its content at generation, so nothing it cites reaches a generated project.
    # CORRECTED 05/11/2026 (US004 phase 9, F2): this read "Checks 1 and 2 are unaffected" above
    # the seeded rule that affects Check 2. Check 1 runs on every citer, whichever applies — a
    # dangling path is a defect wherever it is written.
    citer_seeded=false
    if is_seeded "$file"; then citer_seeded=true; fi
    file_ships=true
    if is_template_only "$file" || [ "$citer_seeded" = true ]; then file_ships=false; fi
    file_dir="${file%/*}"
    [ "$file_dir" = "$file" ] && file_dir="."
    # Check 2 alone asks whether the CITING file is itself a per-project instance, read from its
    # filename (US004 P3). Never from is_template_only(): copier.yml excludes itself, so in a
    # generated project that set is empty and the exemption would silently never apply
    # (ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026).
    citer_instance=false
    if is_instance_citer "$file"; then citer_instance=true; fi

    # Every backticked token in the file, with its line number.
    while IFS=: read -r lineno token; do
      [ -n "$token" ] || continue
      # Counted below the pattern filter, not above it: a token carrying a placeholder, a glob
      # or a `###` is a naming convention being shown rather than a citation, so it is not part
      # of the population either check could have fired on.
      # A path-form shipped template is the one exception: is_template_target() above.
      # A path-form token whose ONE placeholder is the date in its basename is the second
      # exception (US004 phase 9, QA-US004-12): the basename is a convention, the folder is a
      # citation. `date_dir` hands Check 1 that folder and keeps Checks 2 to 4 off the token.
      template_target=false
      date_dir=false
      if is_template_target "$token"; then
        template_target=true
      elif is_pattern "$token"; then
        tok_base="${token##*/}"
        case "$token" in
          */*DD-MM-YYYY*) ;;
          *) continue ;;
        esac
        [[ "$tok_base" == *DD-MM-YYYY* ]] || continue
        is_placeholder "${tok_base//DD-MM-YYYY/}" && continue
        is_placeholder "${token%/*}" && continue
        date_dir=true
      fi
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
      # the same annotation convention the sibling audits already use. ONE EXCEPTION (US004
      # phase 9, F6 / QA-US004-07): a missing path-form shipped template is reported DESPITE
      # the marker. Its presence test runs before the marker is consulted, because the
      # 09/10/2026 ADR lets nothing quieten a required file that is absent.
      #
      # The PLACEHOLDER arms are scoped to the token (US004 phase 9, QA-US004-06, closing
      # EC-04): a `###`, `-##` or `<DESCRIPTOR>` on the line makes a BARE name a worked example,
      # and never a separate token carrying a slash, which is a path citation in its own right and
      # is still tested. The markers and the example words stay line-level.
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
        *'doc-references: ignore'*|*'doc-references: template-only'*) is_marked=true ;;
        *)                                                           is_marked=false ;;
      esac
      case "$line" in
        *'doc-references: ignore'*)              is_naming_row=true ;;
        *'doc-references: template-only'*)       is_naming_row=true ;;
        *'e.g.'*|*'E.g.'*|*'for example'*)       is_naming_row=true ;;
        *'[EXAMPLE]'*|*'house style'*)           is_naming_row=true ;;
        *'###'*|*'-##'*|*'<DESCRIPTOR>'*|*'<TITLE>'*|*'<NNN>'*)
          case "$token" in
            */*) is_naming_row=false ;;
            *)   is_naming_row=true ;;
          esac ;;
        *)                                       is_naming_row=false ;;
      esac

      # ── Check 3 — a citation that does not survive generation ───────────────
      # Placed ABOVE Check 1's `*/*` path guard on purpose: the four most-cited excluded
      # paths — `copier.yml`, `LICENSE`, `SECURITY.md`, `CONTRIBUTING.md` — carry no slash,  # doc-references: template-only
      # and that guard would drop every one of them before the test. This check needs no
      # path heuristic to begin with: it matches against a CLOSED LIST read from copier.yml,
      # so a token either is one of those paths or is not.
      if [ "$file_ships" = true ] && [ "$is_marked" = false ] && [ "$date_dir" = false ]; then
        tmpl="${token%\\}"
        tmpl="${tmpl%/}"
        # An anchored citation of an excluded path is still a citation of that path:
        # `copier.yml:41-42` has to reach the set lookup as `copier.yml`.  # doc-references: template-only
        peel_anchor "$tmpl"; tmpl="$peeled"
        # The whole cost of this check, and it is one array lookup. Everything below runs
        # only for a token whose last segment names one of the forty.
        tmpl_base="${tmpl##*/}"
        if [ -n "$tmpl_base" ] && [ -n "${TEMPLATE_ONLY_BASE[$tmpl_base]:-}" ]; then
          case "$tmpl" in
            http*|*@*|*' '*) tmpl="" ;;
            ../*|./*)
              # Normalised: `../../../copier.yml` has to become the repo-relative path before  # doc-references: ignore
              # a set lookup can see it. normalise_rel() is the same pure-bash normaliser
              # Check 1 uses (US004 phase 9, F8); a path outside the repository is in no set.
              if normalise_rel "$file_dir/$tmpl"; then tmpl="$normalised"; else tmpl=""; fi ;;
            *)
              # Sibling-first, exactly as Check 1 resolves, and it is what keeps the seven
              # SECURITY.md citations under code/docs/ pointing at their own guide rather
              # than at the excluded root file of the same name.
              sibling="${file_dir}/$tmpl"
              sibling="${sibling#./}"
              [ -e "$sibling" ] && tmpl="$sibling" ;;
          esac
          if [ -n "$tmpl" ] && is_template_only "$tmpl"; then
            record "$file" "$lineno" "template-only citation" "$token"
            continue
          fi
        fi
      fi

      # ── Check 4 — a plan filename with no exec-order prefix ─────────────────
      # ADDED 08/09/2026, and it is a DIFFERENT KIND OF RULE from the three above. Those ask
      # whether a citation RESOLVES -- here, downstream, or at all. This one asks whether the
      # NAME is spelt the way the convention spells it, and it answers that from the string
      # alone: no file has to exist on either side of generation for the finding to be true.
      #
      # NOTHING ELSE COULD CARRY IT, and the two reasons are worth stating because both look
      # like bugs and neither is. Check 2 is anchored with `^` against the RAW token, so it
      # sees a bare basename and never a path-form one. Check 1 does see path form, but its
      # checkable-tree case dropped `project-management/src/` to the catch-all until US004 --
      # a project's own artefacts are absent here and different downstream, so their existence
      # is unprovable from this side. Between them a plan cited by its full path was tested by
      # NOTHING, prefix or no prefix. (CHANGED 05/11/2026: Check 1 now tests that tree too, and
      # this clause still runs first, because existence still cannot decide a spelling.) Widening an
      # existence test would have been the wrong repair anyway: the file a CORRECT citation
      # names is absent here and present downstream, and the file an INCORRECT one names is
      # absent in both, so existence cannot separate them. The defect lives in the string, so
      # the string is what is read.
      #
      # THE CONVENTION, settled 08/09/2026 and already applied to the plan tree. A story plan
      # is `<exec-order>-STORY-PLAN-US###-<DESC>.md` and a sprint plan
      # `<exec-order>-SPRINT-PLAN-##.md`, the prefix two digits and zero-padded. The prefix is
      # the artefact's position in the settled build order ACROSS THE WHOLE BACKLOG -- not its
      # sprint, and not a per-sprint counter -- so it is RENUMBERED whenever build order
      # changes. A citation written under a superseded number is therefore a citation to be
      # repointed, never a name to be preserved; and a name quoted from before the convention
      # existed is quoted in "double quotes" rather than backticks, because this script reads
      # backticked tokens inside HTML comments exactly as it reads them in prose.
      #
      # THE TWO FAMILIES ARE NOT THE SAME SHAPE, and the contrast is the whole argument for
      # this check. A sprint plan carries TWO numbers and the PAIR carries the meaning: a
      # prefix disagreeing with the sprint number in the suffix is DELIBERATE and must never be
      # "corrected" (`project-management/src/16-SPRINT-PLANS/CLAUDE.md` says so in as many
      # words). A story plan carries ONE number, so if its prefix does not track build order it
      # says nothing whatever. Hence the rule enforced here is the half the two families share
      # -- the prefix must be PRESENT -- and nothing about what either number's VALUE should
      # be, which no script can decide and which the sprint family forbids guessing at.
      #
      # WHAT IT MUST NOT FIRE ON, and this is why it sits below is_pattern() rather than above
      # it. Prose describing the artefact CLASS writes the placeholder form, and every spelling
      # of it -- the angle-bracket one, the brace one a template uses, a bare `###`, an `NN-`
      # -- is already dropped there as a naming convention being shown rather than a document
      # being cited. That includes the forms in THIS comment: the script ships, and the gate
      # reads its own text. A naming ROW is exempt on the same machinery every other check uses
      # (is_naming_row above), never on a second one invented here.
      #
      # KNOWN LIMIT, stated rather than left to be found, and it follows from that placement.
      # is_pattern() also drops the zero-index artefacts and anything ending -TEMPLATE.md, on
      # the ground that a template IS the convention rather than an instance of it -- true of
      # Checks 1 and 2, and not of this one, which is about the spelling. So the story-plan
      # template cited under its own pre-prefix name is invisible here, and nine such citations
      # sat in six non-exempt files on 08/09/2026, every one of them inside a dated history
      # comment beside correct live text. Reusing the existing filter was chosen over a second,
      # narrower one that only this clause reads: two filters disagreeing about what counts as
      # a pattern is a worse defect than one blind spot that can be named. NARROWED 05/11/2026:
      # a PATH-FORM template now skips is_pattern() (is_template_target(), US004), so the blind
      # spot is the bare name alone; a path-form one written without its prefix is reported here.
      #
      # The anchor is peeled first, on the same argument the other two peels make: an anchored
      # citation names a location inside a file, and the filename it names is what the
      # convention governs. Peeling into a LOCAL copy leaves Check 2's raw token untouched.
      if [ "$is_naming_row" = false ] && [ "$date_dir" = false ]; then
        case "$token" in
          *STORY-PLAN-US*|*SPRINT-PLAN-*)
            peel_anchor "$token"; plan="${peeled##*/}"
            if [[ "$plan" =~ ^STORY-PLAN-US[0-9]{3}-.+\.md$ ]] \
               || [[ "$plan" =~ ^SPRINT-PLAN-[0-9]{2}\.md$ ]]; then
              record "$file" "$lineno" "plan prefix" "$token"
              continue
            fi
            ;;
        esac
      fi

      # ── Check 2 — instance citation ─────────────────────────────────────────
      # CORRECTED 08/09/2026: the two PLAN alternatives accept an optional two-digit
      # `<exec-order>-` prefix. Both artefact families are named for their position in the build
      # order and not only for what they plan -- `NN-SPRINT-PLAN-NN.md` and
      # `NN-STORY-PLAN-US###-<DESC>.md` -- and the alternation is ANCHORED, so a bare basename
      # carrying that prefix matched neither `^SPRINT-PLAN-` nor `^STORY-PLAN-US`. It then fell
      # past Check 1 too, which drops any token with no `/`, and the citation was checked by
      # nothing at all. The sprint half had been open since the prefix was adopted; the story
      # half opened on 08/09/2026 when `17-STORY-PLANS/` took the same convention.
      # Optional rather than required, because the prefix is renumbered whenever build order
      # changes and a plan may still be cited by the unprefixed name it was written under.
      # The two forms above are written as PATTERNS, not as the plans that prompted this: a real
      # basename in a shipped file is the instance citation this very check exists to catch, and
      # naming one here would have made the fix fire on its own explanation.
      #
      # ADDED 05/11/2026 (US004 P3): a citer that is itself a per-project instance is exempt from
      # this check alone — `citer_instance`, decided once per file above. Check 1 still runs on
      # it, so a missing path such a file names is reported as a dangling path.
      # ADDED 05/11/2026 (US004, Key Decisions row "Seeded citers"): so is a citer copier seeds
      # from .copier/ — `citer_seeded`, decided once per file above; its content never ships.
      if [ "$is_naming_row" = false ] && [ "$citer_instance" = false ] \
         && [ "$citer_seeded" = false ] && [ "$date_dir" = false ] \
         && [[ "$token" =~ $INSTANCE_CITED_RE ]]; then
        base="${token##*/}"
        # The archive arm (31/10/2026): a Closed map is moved into 01-FEATURE-MAPS/archive/ by
        # pm-archive.sh, and a bare citation of it is still a citation of a map that exists —
        # every PM reader resolves an ID across the folder AND its archive/, and so does this.
        if ! is_seeded "$token" && [ ! -e "$token" ] && [ ! -e "project-management/src/01-FEATURE-MAPS/$base" ] \
           && [ ! -e "project-management/src/01-FEATURE-MAPS/archive/$base" ]; then
          record "$file" "$lineno" "instance citation" "$token"
          continue
        fi
      fi

      # ── Check 1 — dangling repo path ────────────────────────────────────────
      # `check_tok` is what this check tests; `record` still quotes the raw `token`. For a dated
      # placeholder it is the folder (QA-US004-12 above), kept slash-terminated so the path
      # guard reads it as a path and the trailing-slash strip below takes the slash off again.
      check_tok="$token"
      [ "$date_dir" = true ] && check_tok="${token%/*}/"
      case "$check_tok" in
        */*) ;;   # only tokens that look like a path
        *)   continue ;;
      esac
      case "$check_tok" in
        http*|*@*|*' '*) continue ;;
      esac
      # `*:/*` is a Compose volume spec (US004 R2.2, 05/11/2026): `host:container` names a path
      # on two machines. CHANGED 05/11/2026 (US004 phase 9, QA-US004-03): the CONTAINER half is
      # never a file here and is never tested, but the HOST half of a bind mount is a directory
      # here when it is spelt from the repository root -- a `./` prefix or a bare `a/b` -- so it
      # is tested as that path. A `../` host half is relative to a Compose file the line does
      # not name, a slashless one is a named volume, and an absolute one is another machine's:
      # none of the three is tested. A line anchor never puts a slash after its colon, so the
      # peel below is untouched.
      case "$check_tok" in
        *:/*)
          check_tok="${check_tok%%:*}"
          case "$check_tok" in
            ../*|/*) continue ;;
            ./*)     check_tok="${check_tok#./}" ;;
          esac
          case "$check_tok" in
            */*) ;;
            *)   continue ;;
          esac ;;
      esac

      # Trailing backslashes survive from shell heredocs in the *.sh files.
      stripped="${check_tok%\\}"
      # Peeled here, beside the other two peels and never before the path guard above -- a
      # port (`django:8000`) and an OWASP id (`A05:2025`) carry no slash, and that guard is
      # what already drops them. Forms and ordering: peel_anchor() above.
      peel_anchor "$stripped"; stripped="$peeled"
      stripped="${stripped%/}"

      # Resolve relatives against the CITING file's directory, not the repo root —
      # a ../SIBLING-FOLDER/ reference means something different in each file that
      # writes it, and resolving them all from the root invents failures.
      # A `./` prefix is written for the repo root in practice, so accept either
      # reading rather than pick one and generate a false positive from the other.
      # CHANGED 05/11/2026 (US004 phase 9, F1): the joined path is NORMALISED here, before
      # anything reads it. The checkable-tree case below used to see `dir/../x`, so it sorted
      # the token by the CITER's tree rather than the target's, and the two spellings of one
      # target got two verdicts. A path climbing out of the repository is no repository path
      # and is dropped. The root reading is `./` alone: a `../` read from the root is outside.
      relative=false
      case "$stripped" in
        ../*|./*)
          case "$stripped" in ./*) [ -e "${stripped#./}" ] && continue ;; esac
          normalise_rel "$file_dir/$stripped" || continue
          resolved="$normalised"
          relative=true ;;
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
          # A relative citation is already resolved against its citer: no shorthand reading.
          if [ "${resolved_skip:-false}" = false ] && [ "$relative" = false ] \
             && [ ! -e "$resolved" ]; then
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

      # Which trees are checkable. CHANGED 05/11/2026 (US004 P4): `project-management/src/` is
      # checked. It used to fall to the catch-all, on the argument that a project's own
      # artefacts are absent here by design and different at every number downstream — true
      # of the artefacts, and it hid every dead citation INTO the tree as well, including a
      # shipped template that had gone missing. The artefacts a shipped file may promise are
      # now registered as a CLASS (is_registered() above), so a promised per-story record is a
      # checked promise and anything else under the tree is tested like any other path.
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
        # for a different script).
        code/docs/MACHINE-SPEC.md) continue ;;
        code/docs/*|code/workflows/*|code/src/scripts/*|code/CONTEXT.md|code/CLAUDE.md|code/REFERENCES.md) ;;
        code/src/django/*) ;;
        how-to/docs/*|how-to/workflows/*|how-to/src/*) ;;
        project-management/docs/*|project-management/workflows/*) ;;
        project-management/src/*) ;;
        .claude/*|.github/*) ;;
        # A path-form shipped template is presence-tested WHEREVER it resolves (US004 phase 9,
        # QA-US004-08): beside its citer and from the root, both tried by the shorthand block
        # above, then from each directory between them. The last is the layer-relative house
        # shorthand -- a guide under project-management/ naming a template by its src/ path --
        # and without it 21 shipped citations of templates that exist were reported. Absent
        # everywhere, it is a finding like the one below.
        *)
          if [ "$template_target" = true ]; then
            path_tests=$((path_tests + 1))
            if [ ! -e "$resolved" ] && [ "$relative" = false ]; then
              sibling="$file_dir"
              while [[ "$sibling" == */* ]]; do
                sibling="${sibling%/*}"
                [ -e "$sibling/$resolved" ] && { resolved="$sibling/$resolved"; break; }
              done
            fi
            [ -e "$resolved" ] || record "$file" "$lineno" "dangling path" "$token"
          fi
          continue ;;
      esac

      # Counted HERE, at the existence test, and nowhere earlier: everything above this line
      # is Check 1 deciding whether the token is a repo path at all, and a token dropped by
      # the URL, shorthand or checkable-tree arms was never tested. This is the population a
      # dangling-path finding could have come from.
      path_tests=$((path_tests + 1))
      [ -e "$resolved" ] && continue
      # A shipped template is a literal presence obligation (US004, ADR 09/10/2026): absent is
      # a finding, and nothing below — a seed, a register row, a naming row, the ignore marker
      # folded into it — may quieten it.
      if [ "$template_target" = true ]; then
        record "$file" "$lineno" "dangling path" "$token"
        continue
      fi
      # `$resolved` is already normalised by the relative arm above (US004 phase 9, F1), so a
      # sibling-relative citation of a registered class member (US004 P4) matches its row as
      # the repo-relative spelling does.
      is_seeded "$resolved" && continue
      is_registered "$resolved" && continue
      [ "$is_naming_row" = true ] && continue
      record "$file" "$lineno" "dangling path" "$token"
    done < <(grep -noE "\`[^\`]+\`" "$file" 2>/dev/null | sed 's/`//g' || true)
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
# EXTENDED 05/11/2026 to the four US004 repairs — the exemption fall-through, the shared
# population, the Check 2 citer test and alternation, the checkable artefact tree with its
# patterned register rows — plus the shipped-template presence test. Each probe is tagged RED
# or GUARD at its site below.
#
# EXTENDED 08/09/2026 to Check 4, which needs the fixture pair more than any clause above it. It
# fires on a STRING rather than on a missing file, so its two failure modes are symmetrical and
# neither is visible from an ordinary run: too narrow and the path form goes unreported exactly
# as it did before the clause existed, too wide and every guide describing the naming pattern
# reddens -- this script's own comments first, since it ships and the gate reads its own text.
# One fixture per direction is what tells those apart.
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

# ── US004 phase 9 (05/11/2026) — one probe set per confirmed finding that moves the detector ─
# Story plan → Key Decisions, "Phase 9 findings": every confirmed finding is fixed in this story,
# red first. Findings: the review's F1, F4, F5, F8, F9 and QA-US004-01, -03, -06, -08, -11, -12.
# Each probe is labelled P9-<id> and tagged RED (fails against the detector at 74b9892, and
# must) or GUARD (passes there: it pins the direction the repair could over-reach in). The
# text-only findings (F2, F3, F6) change no behaviour and carry no probe. F9 / QA-US004-11 sit
# with P2 in self_test(), because they prove that block. Fix the detector, never these.
st_has_probe() { # label file wanted-substring
  st_probes=$((st_probes + 1))
  scan_files "$2"
  if [ "${report#*"$3"}" = "$report" ]; then st_fail "$1: no finding names \`$3\`"; return; fi
  log "  ✓ $1"
}
st_absent_probe() { # label file unwanted-substring
  st_probes=$((st_probes + 1))
  scan_files "$2"
  if [ "${report#*"$3"}" != "$report" ]; then st_fail "$1: a finding names \`$3\`"; return; fi
  log "  ✓ $1"
}
st_citer_probe() { # label basename expect(yes|no)
  st_probes=$((st_probes + 1))
  if is_instance_citer "some/dir/$2"; then [ "$3" = yes ] && { log "  ✓ $1"; return; }
  else [ "$3" = no ] && { log "  ✓ $1"; return; }; fi
  st_fail "$1: is_instance_citer $2 answered the wrong way"
}
st_exempt9_probe() { # label path expect(yes|no) — st_exempt_probe lives inside self_test()
  st_probes=$((st_probes + 1))
  if is_exempt "$2"; then [ "$3" = yes ] && { log "  ✓ $1"; return; }
  else [ "$3" = no ] && { log "  ✓ $1"; return; }; fi
  st_fail "$1: is_exempt $2 answered the wrong way"
}
# A fixture under this folder always sits inside a checked tree, so a citer OUTSIDE one is
# staged in a scratch tree outside the repository: the fixture is copied to $2 there, the scan
# runs with the scratch tree as the root, and the subshell removes it on every exit path.
# Prints the finding count on the first line and the report after it.
st_scratch_scan() { # fixture dest
  (
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-p9.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/${2%/*}" "$scratch/project-management/src/02-STORIES" || exit 3
    : > "$scratch/project-management/src/02-STORIES/FIXTURE-ONLY-PRESENT.md"
    cp -- "$1" "$scratch/$2" || exit 3
    cd "$scratch" || exit 3
    PROJECT_ROOT="$scratch"
    QUIET=true
    scan_files "$2"
    printf '%s\n%s' "$violations" "$report"
  )
}

st_phase9_probes() {
  local BT=$'\x60' out v rep
  local st_saved_registered="$REGISTERED"

  # F1 — a relative token is normalised BEFORE the checkable-tree case, so both spellings of one
  # target get one verdict, and a target outside the repository is never tested as a repo path.
  log ""
  log "  US004 P9-F1 — a relative citation is normalised before the checkable-tree decision:"
  # RED — P9-F1(b): the relative spelling of an unchecked-tree target was read as the CITER's
  # tree and reported, while its repo-relative spelling was silent. Two findings, not three.
  st_probe "P9-F1 broken/relative-normalise.md: one verdict per target, either spelling" \
    "$FIXTURES_DIR/broken/relative-normalise.md" 2 \
    "dangling path | ${BT}project-management/src/02-STORIES/NO-SUCH-FIXTURE-ONLY-STORY.md${BT}"
  # GUARD — P9-F1(b): the relative spelling of a dead checked-tree target is still reported.
  st_has_probe "P9-F1 broken/relative-normalise.md still reports the relative dead path (GUARD)" \
    "$FIXTURES_DIR/broken/relative-normalise.md" \
    "dangling path | ${BT}../../../../../../../project-management/src/02-STORIES/NO-SUCH-FIXTURE-ONLY-STORY.md${BT}"
  # RED — P9-F1 escape: a path climbing out of the repository is not a repository path.
  st_probe "P9-F1 broken/relative-escape.md silent on a path outside the repository" \
    "$FIXTURES_DIR/broken/relative-escape.md" 1 \
    "dangling path | ${BT}../../../../../../../code/docs/NO-SUCH-FIXTURE-ONLY-GUIDE.md${BT}"
  # RED — P9-F1(a), the review's reproduction: research/CONTEXT.md, which P1 polices, citing
  # into the artefact tree by a relative path. Both spellings of the dead target are reported.
  local st_f1a_rel="dangling path | ${BT}../project-management/src/02-STORIES/NO-SUCH-FIXTURE-ONLY-STORY.md${BT}"
  local st_f1a_abs="dangling path | ${BT}project-management/src/02-STORIES/NO-SUCH-FIXTURE-ONLY-STORY.md${BT}"
  st_probes=$((st_probes + 1))
  out="$(st_scratch_scan "$FIXTURES_DIR/broken/relative-unchecked.md" research/CONTEXT.md)"
  v="${out%%$'\n'*}"; rep="${out#*$'\n'}"
  if [ "$v" != 2 ]; then
    st_fail "P9-F1 scratch research/CONTEXT.md: expected 2 finding(s), got ${v:-none}"
  elif [ "${rep#*"$st_f1a_rel"}" = "$rep" ]; then
    st_fail "P9-F1 scratch research/CONTEXT.md: the relative spelling into the artefact tree is unreported"
  else
    log "  ✓ P9-F1 a citer outside the checked trees: its relative citation into one is tested"
  fi
  # GUARD — P9-F1(a): the repo-relative spelling is reported, and a present relative target is not.
  st_probes=$((st_probes + 1))
  if [ "${rep#*"$st_f1a_abs"}" = "$rep" ]; then
    st_fail "P9-F1 scratch research/CONTEXT.md: the repo-relative dead path is unreported"
  elif [ "${rep#*FIXTURE-ONLY-PRESENT}" != "$rep" ]; then
    st_fail "P9-F1 scratch research/CONTEXT.md: a present relative target was reported"
  else
    log "  ✓ P9-F1 scratch: repo-relative dead path reported, present relative target silent (GUARD)"
  fi

  # F8 — the normalisation must not depend on GNU `realpath -m --relative-to`. A realpath that
  # rejects those flags, as BSD and macOS do, is stood in by a function that fails.
  log ""
  log "  US004 P9-F8 — normalisation without GNU realpath:"
  st_probes=$((st_probes + 1))
  # RED — P9-F8: R2.5's relative class member still matches its row with realpath unavailable.
  if (
    # shellcheck disable=SC2329  # tripwire: the script never calls realpath; this stub fires
    # only if a regression reintroduces it, so 'never invoked' is the passing state
    realpath() { return 1; }
    QUIET=true
    REGISTERED="$FIXTURES_DIR/clean/AUTOMATED/US###-TEST-STATUS.md"
    scan_files "$FIXTURES_DIR/clean/MANUAL/relative-class.md"
    [ "$violations" -eq 0 ]
  ); then
    log "  ✓ P9-F8 clean/MANUAL/relative-class.md silent with no GNU realpath"
  else
    st_fail "P9-F8 clean/MANUAL/relative-class.md: reported with no GNU realpath — the" \
      "normalisation still depends on realpath -m --relative-to"
  fi
  # GUARD — P9-F8: with realpath unavailable, a dead relative path is still a finding.
  st_probes=$((st_probes + 1))
  if (
    # shellcheck disable=SC2329  # tripwire: the script never calls realpath; this stub fires
    # only if a regression reintroduces it, so 'never invoked' is the passing state
    realpath() { return 1; }
    QUIET=true
    scan_files "$FIXTURES_DIR/broken/volume-spec.md"
    [ "$violations" -eq 1 ]
  ); then
    log "  ✓ P9-F8 broken/volume-spec.md still fires with no GNU realpath (GUARD)"
  else
    st_fail "P9-F8 broken/volume-spec.md: expected 1 finding with no GNU realpath"
  fi

  # F4 — the derived citer rule is bounded on the LEFT as well: a story or sprint number starts
  # the name or follows a non-letter, so a word merely ending in US is not an instance citer.
  log ""
  log "  US004 P9-F4 — the derived citer rule has a left boundary:"
  # RED — P9-F4.
  st_citer_probe "P9-F4 STATUS200.md is NOT an instance citer      " "STATUS200.md" no
  st_citer_probe "P9-F4 BONUS100.md is NOT an instance citer       " "BONUS100.md" no
  st_citer_probe "P9-F4 CORPUS123-NOTES.md is NOT an instance citer" "CORPUS123-NOTES.md" no
  st_citer_probe "P9-F4 XUS123.md is NOT an instance citer         " "XUS123.md" no
  st_citer_probe "P9-F4 XSPRINT-07.md is NOT an instance citer     " "XSPRINT-07.md" no
  # GUARD — P9-F4: every live form stays an instance citer.
  st_citer_probe "P9-F4 US123.md stays an instance citer (GUARD)            " "US123.md" yes
  st_citer_probe "P9-F4 QA-PLAN-US123-X.md stays an instance citer (GUARD)  " "QA-PLAN-US123-X.md" yes
  st_citer_probe "P9-F4 07-SPRINT-PLAN-07.md stays an instance citer (GUARD)" "07-SPRINT-PLAN-07.md" yes
  st_citer_probe "P9-F4 SPRINT-07.md stays an instance citer (GUARD)        " "SPRINT-07.md" yes
  st_citer_probe "P9-F4 SPRINT-PLAN-07.md stays an instance citer (GUARD)   " "SPRINT-PLAN-07.md" yes
  st_citer_probe "P9-F4 07-STORY-PLAN-US123-X.md stays one (GUARD)          " "07-STORY-PLAN-US123-X.md" yes
  st_citer_probe "P9-F4 BUG-X-01-01-2026.md stays an instance citer (GUARD) " "BUG-X-01-01-2026.md" yes

  # F5 / QA-US004-01 — the P1 fall-through arm mirrors copier's re-includes exactly: the
  # top-level research/, handoffs/ and learning/ pairs, every pair under project-management/src/,
  # and -TEMPLATE. only under project-management/src/. Nothing else leaves an exempt tree.
  log ""
  log "  US004 P9-F5 / QA-US004-01 — the fall-through arm is scoped to copier's re-includes:"
  # RED — P9-F5 / P9-QA-US004-01: copier drops each of these, so each stays exempt.
  st_exempt9_probe "P9-F5 research/sub/CONTEXT.md stays exempt      " "research/sub/CONTEXT.md" yes
  st_exempt9_probe "P9-F5 research/sub/CLAUDE.md stays exempt       " "research/sub/CLAUDE.md" yes
  st_exempt9_probe "P9-F5 research/FOO-TEMPLATE.md stays exempt     " "research/FOO-TEMPLATE.md" yes
  st_exempt9_probe "P9-QA-01 handoffs/HANDOFF-QA-TEMPLATE.md exempt " "handoffs/HANDOFF-QA-TEMPLATE.md" yes
  st_exempt9_probe "P9-QA-01 handoffs/sub/CONTEXT.md stays exempt   " "handoffs/sub/CONTEXT.md" yes
  st_exempt9_probe "P9-QA-01 learning/FOO-TEMPLATE.md stays exempt  " "learning/FOO-TEMPLATE.md" yes
  st_exempt9_probe "P9-QA-01 learning/sub/CLAUDE.md stays exempt    " "learning/sub/CLAUDE.md" yes
  st_exempt9_probe "P9-F5 .copier/CONTEXT.md stays exempt           " ".copier/CONTEXT.md" yes
  st_exempt9_probe "P9-F5 .copier/sub/CLAUDE.md stays exempt        " ".copier/sub/CLAUDE.md" yes
  st_exempt9_probe "P9-F5 .copier/FOO-TEMPLATE.md stays exempt      " ".copier/FOO-TEMPLATE.md" yes
  # GUARD — P9-F5: what copier does re-include stays policed, at any depth under PM src.
  st_exempt9_probe "P9-F5 research/CLAUDE.md is NOT exempt (GUARD)  " "research/CLAUDE.md" no
  st_exempt9_probe "P9-F5 handoffs/CONTEXT.md is NOT exempt (GUARD) " "handoffs/CONTEXT.md" no
  st_exempt9_probe "P9-F5 learning/CLAUDE.md is NOT exempt (GUARD)  " "learning/CLAUDE.md" no
  st_exempt9_probe "P9-F5 01-FEATURE-MAPS/archive/CONTEXT.md NOT exempt (GUARD)" \
    "project-management/src/01-FEATURE-MAPS/archive/CONTEXT.md" no
  st_exempt9_probe "P9-F5 WALK-TESTS/WALK-FOO-TEMPLATE.md NOT exempt (GUARD)   " \
    "project-management/src/00-ASSETS/WALK-TESTS/WALK-FOO-TEMPLATE.md" no
  # GUARD — P9-F5: the vendored arms above the fall-through still win.
  st_exempt9_probe "P9-F5 code/docs/cloudinary/CONTEXT.md stays exempt (GUARD)  " \
    "code/docs/cloudinary/CONTEXT.md" yes
  st_exempt9_probe "P9-F5 .agents/skills/x/CLAUDE.md stays exempt (GUARD)       " \
    ".agents/skills/x/CLAUDE.md" yes

  # QA-US004-03 — the HOST half of a host:container volume token is a path here when it is
  # spelt from the repository root; the container half never is. A `../` host half is relative
  # to a Compose file the line does not name, so R2.2's clean fixture pins it silent.
  log ""
  log "  US004 P9-QA-US004-03 — the host half of a volume spec is tested:"
  # RED — P9-QA-US004-03.
  st_probe "P9-QA-03 broken/volume-host.md fires on a dead host half" \
    "$FIXTURES_DIR/broken/volume-host.md" 2 \
    "dangling path | ${BT}./code/docs/NO-SUCH-FIXTURE-ONLY-DIR:/workspace/logs${BT}"
  # GUARD — P9-QA-US004-03: a present host half, a container half and a named volume are silent.
  st_probe "P9-QA-03 clean/volume-host.md silent on a present host half (GUARD)" \
    "$FIXTURES_DIR/clean/volume-host.md" 0

  # QA-US004-06 — is_naming_row's PLACEHOLDER arms no longer suppress a separate concrete path
  # token on the same line. A worked example in a naming row, and an explicit marker, still do.
  log ""
  log "  US004 P9-QA-US004-06 — a placeholder on a line does not hide a separate citation:"
  local st_q6="$FIXTURES_DIR/broken/naming-row-mixed.md"
  # RED — P9-QA-US004-06 (EC-04), the QA reproduction: a `###` in the line's prose.
  st_probe "P9-QA-06 broken/naming-row-mixed.md fires on three separate dead paths" "$st_q6" 3 \
    "dangling path | ${BT}project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-NAMING-ROW-B.md${BT}"
  # RED — P9-QA-US004-06: a placeholder TOKEN beside the dead path, and a `<DESCRIPTOR>` one.
  st_has_probe "P9-QA-06 the dead path beside a ### token is reported" "$st_q6" \
    "dangling path | ${BT}project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-NAMING-ROW-A.md${BT}"
  st_has_probe "P9-QA-06 the dead path beside a <DESCRIPTOR> token is reported" "$st_q6" \
    "dangling path | ${BT}code/docs/NO-SUCH-FIXTURE-ONLY-NAMING-ROW-C.md${BT}"
  # GUARD — P9-QA-US004-06: a naming row's worked example is still not an instance citation.
  st_absent_probe "P9-QA-06 a naming row's bare worked example stays silent (GUARD)" "$st_q6" \
    "${BT}US042.md${BT}"
  st_absent_probe "P9-QA-06 a naming row's worked plan name stays silent (GUARD)" "$st_q6" \
    "STORY-PLAN-US042-FIXTURE-ONLY.md"
  # GUARD — P9-QA-US004-06: an explicit example marker stays a line-level suppression.
  st_absent_probe "P9-QA-06 an e.g. line stays suppressed (GUARD)" "$st_q6" \
    "NO-SUCH-FIXTURE-ONLY-EXAMPLE.md"

  # QA-US004-08 — a path-form template target that resolves into no checkable tree is still
  # presence-tested, beside its citer and then from the root, and reported if absent in both.
  log ""
  log "  US004 P9-QA-US004-08 — a template target outside the checked trees is presence-tested:"
  # RED — P9-QA-US004-08.
  st_probe "P9-QA-08 broken/template-unchecked.md fires on two absent template targets" \
    "$FIXTURES_DIR/broken/template-unchecked.md" 2 \
    "dangling path | ${BT}MANUAL/US000-FIXTURE-ONLY-GONE-MANUAL-TESTING.md${BT}"
  # GUARD — P9-QA-US004-08: a template target present beside its citer is silent.
  st_probe "P9-QA-08 clean/template-sibling.md silent on a present sibling template (GUARD)" \
    "$FIXTURES_DIR/clean/template-sibling.md" 0

  # QA-US004-12 — a DD-MM-YYYY placeholder drops the basename, never the DIRECTORY: the folder
  # a dated artefact is named under is a citation, and is tested for existence.
  log ""
  log "  US004 P9-QA-US004-12 — a dated placeholder's directory is tested:"
  # RED — P9-QA-US004-12.
  st_probe "P9-QA-12 broken/date-folder.md fires on a dead folder under a dated placeholder" \
    "$FIXTURES_DIR/broken/date-folder.md" 1 "99-NO-SUCH-FIXTURE-ONLY-FOLDER"
  # GUARD — P9-QA-US004-12: a present folder, spelt relative, is silent (R2.4 pins the
  # repo-relative spelling).
  st_probe "P9-QA-12 clean/date-folder.md silent on a present folder (GUARD)" \
    "$FIXTURES_DIR/clean/date-folder.md" 0

  REGISTERED="$st_saved_registered"
}

self_test() {
  bold "▸ doc-references.sh --self-test"
  log ""
  [ -d "$FIXTURES_DIR/broken" ] && [ -d "$FIXTURES_DIR/clean" ] \
    || die "fixtures missing at $FIXTURES_DIR — refusing to report a proof that never ran"

  log "  known-bad — every line printed below is expected:"
  # The anchor peel must not make a dangling path resolve, and the finding must still quote
  # the citation as the author wrote it: `record` reports the raw token, never the peeled one.
  st_probe "broken/anchors.md      fires on all three anchor forms" \
    "$FIXTURES_DIR/broken/anchors.md" 3 'NO-SUCH-GUIDE.md:7'
  # A marker two lines above is not the documented window, and template-only is per line
  # rather than per file. Both halves fail here, which is what keeps the token narrow.
  st_probe "broken/tokens.md       fires past the marker's window" \
    "$FIXTURES_DIR/broken/tokens.md" 2 'FIXTURE-ONLY-TWO-LINES-ABOVE.md'
  # The arm, in the direction nobody watches: a project-built path with no row must fire,
  # and forward voice must not save it. Both citations below are unbacked; one is written
  # "will write" and fails identically, because the clause reads the path.
  st_probe "broken/django-arm.md   fires on an unregistered project-built path" \
    "$FIXTURES_DIR/broken/django-arm.md" 2 'no_such_app/views.py'
  # Check 3, isolated: every path in that fixture RESOLVES here, so Check 1 passes on all of
  # them and a finding can only have come from the Direction B clause.
  st_probe "broken/direction-b.md  fires on an undeclared excluded path, bare and anchored" \
    "$FIXTURES_DIR/broken/direction-b.md" 3 'copier.yml:41-42'
  # Check 4, in the direction that had no detector at all until 08/09/2026. Five forms, and the
  # PATH ones are the reason the clause exists: Check 2 is anchored and cannot see them, Check 1
  # drops the artefact tree on purpose, so before this they were checked by nothing. The
  # substring asserted is the path form for exactly that reason -- a probe passing on the bare
  # form alone would be green over the half that was already visible.
  st_probe "broken/plan-prefix.md  fires on an unprefixed plan name, bare and path form" \
    "$FIXTURES_DIR/broken/plan-prefix.md" 5 \
    'project-management/src/17-STORY-PLANS/STORY-PLAN-US042-FIXTURE-ONLY.md'

  log ""
  log "  known-good — nothing below should print a finding:"
  # Without the peel every line here is a finding. The `:N:M` form is the one that a single
  # greedy regex gets wrong -- it would leave `…doc-references.sh:12` and report it -- and
  # `:N-M` is the one the peel did not reach at all until 01/09/2026.
  st_probe "clean/anchors.md       silent on :N, :N:M, :N-M, a port and an OWASP id" \
    "$FIXTURES_DIR/clean/anchors.md" 0
  st_probe "clean/tokens.md        silent on template-only, on-line and line-above" \
    "$FIXTURES_DIR/clean/tokens.md" 0
  # The other direction, and the one probe here that reads a file outside this folder:
  # the three rows in how-to/src/PROJECT-PATHS.md, plus a path under the same tree that
  # passes on existing alone. Retiring a row reddens this probe, which is the point.
  st_probe "clean/django-arm.md    silent on the registered rows and on what exists" \
    "$FIXTURES_DIR/clean/django-arm.md" 0
  # Both markers suppress Check 3, and the three classes that need no marker stay silent:
  # surface-gated, seeded, regenerated, and re-included inside an excluded tree.
  st_probe "clean/direction-b.md   silent on both markers, anchored or bare, and the four classes" \
    "$FIXTURES_DIR/clean/direction-b.md" 0
  # The other half of Check 4, and the half a naming rule gets wrong most easily: the prose that
  # DESCRIBES the pattern must never read as an instance of it. Four spellings of the
  # placeholder, the artefact class used as a bare noun, and the zero-index template -- plus two
  # correctly prefixed filenames, written in path form because a bare prefixed basename is an
  # instance citation on Check 2 whatever its prefix, and this fixture proves one clause.
  st_probe "clean/plan-prefix.md   silent on a prefixed name and on every placeholder spelling" \
    "$FIXTURES_DIR/clean/plan-prefix.md" 0

  # The SET is asserted directly, not only through a fixture. A fixture proves the clause
  # fires; these prove it fires over the right forty paths — and each row is a different way
  # the parse can go wrong: an anchored entry, a templated one read as unconditional, a
  # seeded exclusion not subtracted, and `a/**/b` failing to match `a/b`.
  st_set_probe() { # label path expect(yes|no)
    st_probes=$((st_probes + 1))
    if is_template_only "$2"; then [ "$3" = yes ] && { log "  ✓ $1"; return; }
    else [ "$3" = no ] && { log "  ✓ $1"; return; }; fi
    st_fail "$1: is_template_only $2 answered the wrong way"
  }
  log ""
  log "  the derived set — forty paths, parsed from copier.yml rather than listed:"
  st_set_probe "anchored entry is in the set          " "copier.yml"                          yes
  st_set_probe "surface-gated entry is NOT            " "code/docs/RUST.md"                    no
  st_set_probe "excluded-and-seeded entry is NOT      " "CHANGELOG.md"                         no
  st_set_probe "re-included pair file is NOT          " "project-management/src/CONTEXT.md"    no

  # ── US004 — failing proofs written at the Red phase, one per repair ─────────
  # Story plan: project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md
  # QA plan:    project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md
  # Each probe below is tagged RED (fails against the pre-US004 detector, and must) or GUARD
  # (passes against it by construction: it pins the direction a repair could over-reach in,
  # which no pre-change detector can fail). Fix the detector, never these.

  # P1 — is_exempt() must let the nine shipped files out of the exempt trees. copier.yml's
  # allowlist block re-includes each tree's CONTEXT.md/CLAUDE.md pair and every template, so
  # they ship and must be policed. A predicate is asserted directly: no fixture can reach it.
  st_exempt_probe() { # label path expect(yes|no)
    st_probes=$((st_probes + 1))
    if is_exempt "$2"; then [ "$3" = yes ] && { log "  ✓ $1"; return; }
    else [ "$3" = no ] && { log "  ✓ $1"; return; }; fi
    st_fail "$1: is_exempt $2 answered the wrong way"
  }
  log ""
  log "  US004 P1 — the shipped pair files and templates inside the exempt trees:"
  # RED — P1, QA HP-01, manual EXEMPT-01.
  st_exempt_probe "P1 HP-01 research/CONTEXT.md is NOT exempt          " "research/CONTEXT.md" no
  # RED — P1, QA HP-01 (the remaining eight of the nine shipped files the plan names).
  st_exempt_probe "P1 HP-01 research/CLAUDE.md is NOT exempt           " "research/CLAUDE.md" no
  st_exempt_probe "P1 HP-01 handoffs/CONTEXT.md is NOT exempt          " "handoffs/CONTEXT.md" no
  st_exempt_probe "P1 HP-01 handoffs/CLAUDE.md is NOT exempt           " "handoffs/CLAUDE.md" no
  st_exempt_probe "P1 HP-01 learning/CONTEXT.md is NOT exempt          " "learning/CONTEXT.md" no
  st_exempt_probe "P1 HP-01 learning/CLAUDE.md is NOT exempt           " "learning/CLAUDE.md" no
  st_exempt_probe "P1 HP-01 01-FEATURE-MAPS/CONTEXT.md is NOT exempt   " \
    "project-management/src/01-FEATURE-MAPS/CONTEXT.md" no
  st_exempt_probe "P1 HP-01 01-FEATURE-MAPS/CLAUDE.md is NOT exempt    " \
    "project-management/src/01-FEATURE-MAPS/CLAUDE.md" no
  # RED — P1, QA EC-02, manual EXEMPT-03: a template inside an exempt tree.
  st_exempt_probe "P1 EC-02 MAP-000-TEMPLATE.md is NOT exempt          " \
    "project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md" no
  # GUARD — P1, QA HP-01 second half, manual EXEMPT-02: the tree arms still hold for a file
  # copier does not lift back out.
  st_exempt_probe "P1 HP-01 a research note stays exempt (GUARD)       " "research/HTTP-QUERY-METHOD.md" yes
  st_exempt_probe "P1 HP-01 a feature map stays exempt (GUARD)         " \
    "project-management/src/01-FEATURE-MAPS/MAP-ABSENCE.md" yes

  # P2 — build_template_only() must read the population candidates() reads: tracked PLUS
  # untracked-but-not-ignored. A probe file is created under research/ (excluded by copier,
  # not ignored by git), under an unpredictable mktemp name inside the repository — never in
  # /tmp. BOTH builders are re-run after it exists (QA AC-GAP-8): they ran once at load, so a
  # probe without the re-run asserts against a set built before the file existed. The re-run
  # happens in a subshell, so the set the rest of this self-test reads is left as loaded. The
  # trap removes the file on every exit path, a failed assertion and an interrupt included
  # (QA ES-03, manual SELFTEST-01).
  log ""
  log "  US004 P2 — an untracked file under an excluded tree is in the derived set:"
  # P9-F9 / QA-US004-11 (phase 9, 05/11/2026). A SIGKILL or a crashed shell runs no trap, so a
  # killed earlier run leaves its probe file behind; P2 sweeps the stale ones before it starts.
  # One is planted here exactly as a killed run leaves it, under the same name pattern, and
  # asserted gone once P2 has run. The plant carries its own trap until that assertion.
  local st_p9_stale
  st_p9_stale="$(mktemp "research/us004-p2-probe.XXXXXXXX")" \
    || die "P9-F9 probe: could not plant a stale probe file under research/"
  trap 'rm -f -- "$st_p9_stale"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  # P2 runs in a subshell that creates the probe, holds the trap and exits, and it hands the
  # probe's name back on its first line. CHANGED 05/11/2026 (P9-QA-US004-11): the GUARD below
  # used to follow an unconditional `rm -f` in this same shell, so it could never fail. It now
  # asserts from the parent, after the shell holding the trap has gone, that the trap removed it.
  st_probes=$((st_probes + 1))
  local st_p2_out st_p2_rc st_p2_probe
  st_p2_out="$(
    # P9-F9: sweep what a killed earlier run left, before this run makes its own probe. Only
    # this pattern, only under research/, and only untracked files ever carry it.
    rm -f -- research/us004-p2-probe.*
    ST_P2_PROBE="$(mktemp "research/us004-p2-probe.XXXXXXXX")" || exit 3
    trap 'rm -f -- "$ST_P2_PROBE"' EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
    printf '%s\n' "$ST_P2_PROBE"
    build_template_only; build_template_only_index
    is_template_only "$ST_P2_PROBE" && exit 0
    exit 1
  )"
  st_p2_rc=$?
  st_p2_probe="${st_p2_out%%$'\n'*}"
  # RED — P2, QA AC-GAP-8 / ES-03, story plan P2.
  case "$st_p2_rc" in
    0) log "  ✓ P2 AC-GAP-8 an untracked excluded file is template-only after a rebuild" ;;
    3) st_fail "P2 AC-GAP-8: could not create a temporary file under research/" ;;
    *) st_fail "P2 AC-GAP-8: is_template_only $st_p2_probe answered no after both builders re-ran" \
         "— the derived set still reads the git index alone" ;;
  esac
  # GUARD — P2, QA ES-03, P9-QA-US004-11: the probe leaves nothing behind in the working tree.
  st_probes=$((st_probes + 1))
  if [ -z "$st_p2_probe" ]; then
    st_fail "P2 ES-03: the P2 subshell reported no probe name, so its removal cannot be asserted"
  elif [ -e "$st_p2_probe" ]; then
    st_fail "P2 ES-03: the probe file $st_p2_probe survived the shell whose trap owned it"
    rm -f -- "$st_p2_probe"
  else
    log "  ✓ P2 ES-03 the probe file is gone once its shell has exited (GUARD)"
  fi
  # RED — P9-F9: the stale probe planted above is swept by P2.
  st_probes=$((st_probes + 1))
  if [ -e "$st_p9_stale" ]; then
    st_fail "P9-F9: a stale probe file a killed run left ($st_p9_stale) survived P2 — no sweep"
  else
    log "  ✓ P9-F9 P2 sweeps a stale probe file a killed earlier run left behind"
  fi
  rm -f -- "$st_p9_stale"
  trap - EXIT INT TERM

  # P3 — Check 2 asks whether the CITING FILE is an instance artefact, read from its name, and
  # never consults is_template_only() (ADR-US004-INSTANCE-ARTEFACT-CITER-TEST, AC-GAP-4/5). The
  # clean/ citers are named as each instance form the plan lists, and each cites an instance.
  log ""
  log "  US004 P3 — the Check 2 citer test, and the alternation's spellings:"
  # A finding row reads `| file | line | class | token |`, the token in backticks. The backtick
  # is assembled rather than written, because this script ships and the gate reads its own
  # text: a literal pair around an instance name below would be a finding in an ordinary run.
  local BT=$'\x60'
  # RED — P3, QA AC-GAP-5, one probe per instance form the citer test must recognise.
  st_probe "P3 AC-GAP-5 clean/US123.md citer is exempt from Check 2" \
    "$FIXTURES_DIR/clean/US123.md" 0
  st_probe "P3 AC-GAP-5 clean/SPRINT-07.md citer is exempt" \
    "$FIXTURES_DIR/clean/SPRINT-07.md" 0
  st_probe "P3 AC-GAP-5 clean/ADR-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/ADR-US123-FIXTURE-ONLY-01-01-2026.md" 0
  st_probe "P3 AC-GAP-5 clean/QA-PLAN-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/QA-PLAN-US123-FIXTURE-ONLY.md" 0
  st_probe "P3 AC-GAP-5 clean/07-STORY-PLAN-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/07-STORY-PLAN-US123-FIXTURE-ONLY.md" 0
  st_probe "P3 AC-GAP-5 clean/07-SPRINT-PLAN-07.md citer is exempt" \
    "$FIXTURES_DIR/clean/07-SPRINT-PLAN-07.md" 0
  st_probe "P3 AC-GAP-5 clean/REVIEW-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/REVIEW-US123-FIXTURE-ONLY.md" 0
  st_probe "P3 AC-GAP-5 clean/BUG-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/BUG-US123-FIXTURE-ONLY-01-01-2026.md" 0
  # GUARD — P3, QA AC-GAP-5 / EC-01(a), manual CITER-01: a zero-index file ships, so it is
  # excluded from the citer test and its instance citation is still reported.
  st_probe "P3 EC-01a broken/US000-… citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/US000-FIXTURE-ONLY.md" 1 "instance citation | ${BT}US042.md${BT}"
  # GUARD — P3, QA EC-02, manual CITER-02: a template ships, so it is excluded likewise.
  st_probe "P3 EC-02 broken/…-TEMPLATE.md citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/REVIEW-US123-FIXTURE-ONLY-TEMPLATE.md" 1 "instance citation | ${BT}US042.md${BT}"
  # RED — P3 alternation: ADR-US### and QA-PLAN-US### are the live spellings and must fire.
  st_probe "P3 alternation broken/alternation.md fires on ADR-US### and QA-PLAN-US###" \
    "$FIXTURES_DIR/broken/alternation.md" 2 "instance citation | ${BT}QA-PLAN-US123-FIXTURE-ONLY.md${BT}"
  # RED — P3 alternation: ADR-### (retired 31/08/2026) and QA-US### (never a live name) no
  # longer match.
  st_probe "P3 alternation clean/alternation.md silent on ADR-### and QA-US###" \
    "$FIXTURES_DIR/clean/alternation.md" 0

  # P4 — the artefact tree becomes checkable by Check 1, and is_registered() reads a `###` in a
  # register row as exactly three digits (ADR-US004-PATTERNED-REGISTRATION-PRESERVES-SHIPPED-
  # TEMPLATES). The real register is read for the two rows the plan names; a fixture-local class
  # row stands in where the real template cannot be removed (the missing-template pair below).
  # Contract this relies on: REGISTERED holds the parsed rows, one per line, as loaded above.
  log ""
  log "  US004 P4 — the artefact tree is checkable, and register rows may bind a class:"
  # RED — P4, QA HP-04, manual DEADPATH-01: a dead PM path is reported at all.
  st_probe "P4 HP-04 broken/pm-arm.md fires on a dead project-management/src path" \
    "$FIXTURES_DIR/broken/pm-arm.md" 1 \
    "dangling path | ${BT}project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-DECISION.md${BT}"
  # RED — P3/P4, QA EC-05, manual DEADPATH-01/02: an instance citer is exempt from Check 2 for
  # its bare citation and is NOT exempt from Check 1 for a missing path. Exactly one finding,
  # and it is the dangling path, never an instance citation.
  st_probe "P4 EC-05 broken/US999.md: Check 2 exempts the citer, Check 1 still fires" \
    "$FIXTURES_DIR/broken/US999.md" 1 "dangling path | ${BT}project-management/src/02-STORIES/US997.md${BT}"
  # RED — P4, QA EC-03, manual REGISTER-04: four digits and letters are not members of a class.
  st_probe "P4 EC-03 broken/pm-overmatch.md fires on US1234, USxyz and USabc" \
    "$FIXTURES_DIR/broken/pm-overmatch.md" 4 \
    "dangling path | ${BT}project-management/src/18-TESTS/MANUAL/US1234-MANUAL-TESTING.md${BT}"
  # GUARD — P4, QA HP-03 / AC-GAP-6, manual REGISTER-03: once the tree is checkable, the two
  # class rows make an absent manual guide and an absent automated record pass. Green before
  # the change only because the tree is unchecked; red if the arm lands without the rows.
  st_probe "P4 HP-03 clean/pm-registered.md silent on registered US997 records (GUARD)" \
    "$FIXTURES_DIR/clean/pm-registered.md" 0
  # GUARD — P4, QA EC-01(b)/EC-06 restored, manual TARGET-01/02 restore step: both shipped test
  # templates exist, and the template exception must never report a present one.
  st_probe "P4 EC-01b/EC-06 clean/template-targets.md silent on present templates (GUARD)" \
    "$FIXTURES_DIR/clean/template-targets.md" 0

  st_reg_probe() { # label path expect(yes|no)
    st_probes=$((st_probes + 1))
    if is_registered "$2"; then [ "$3" = yes ] && { log "  ✓ $1"; return; }
    else [ "$3" = no ] && { log "  ✓ $1"; return; }; fi
    st_fail "$1: is_registered $2 answered the wrong way"
  }
  # RED — P4, QA AC-GAP-2 / AC-GAP-6 / HP-03, manual REGISTER-01/03: the real register carries
  # the two class rows, and a concrete three-digit member of each is registered.
  st_reg_probe "P4 HP-03 real register admits MANUAL/US123-MANUAL-TESTING.md" \
    "project-management/src/18-TESTS/MANUAL/US123-MANUAL-TESTING.md" yes
  st_reg_probe "P4 HP-03 real register admits AUTOMATED/US123-TEST-STATUS.md" \
    "project-management/src/18-TESTS/AUTOMATED/US123-TEST-STATUS.md" yes
  # GUARD — P4, ADR 09/10/2026: the real class rows never admit a shipped template target.
  st_reg_probe "P4 EC-01 real register rejects MANUAL/US000 (GUARD)" \
    "project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md" no
  st_reg_probe "P4 EC-06 real register rejects AUTOMATED/US000 (GUARD)" \
    "project-management/src/18-TESTS/AUTOMATED/US000-TEST-STATUS.md" no

  # The class semantics, isolated from the real register's contents: one fixture-local row.
  local st_saved_registered="$REGISTERED"
  local st_class="$FIXTURES_DIR/missing"
  REGISTERED="$st_class/MANUAL/US###-MANUAL-TESTING.md
$st_class/AUTOMATED/US###-TEST-STATUS.md
$st_class/US###-FIXTURE-ONLY-TEMPLATE.md"
  # RED — P4, QA AC-GAP-2: `###` binds three digits, so a concrete member matches the row.
  st_reg_probe "P4 AC-GAP-2 a class row admits US123" \
    "$st_class/MANUAL/US123-MANUAL-TESTING.md" yes
  # GUARD — P4, QA EC-03: exactly three digits, never four, never letters.
  st_reg_probe "P4 EC-03 a class row rejects US1234 (GUARD)" \
    "$st_class/MANUAL/US1234-MANUAL-TESTING.md" no
  st_reg_probe "P4 EC-03 a class row rejects USabc (GUARD)" \
    "$st_class/MANUAL/USabc-MANUAL-TESTING.md" no
  # GUARD — P4, QA AC-GAP-10 / EC-01 / EC-06: `000` is three digits and is still never a member.
  st_reg_probe "P4 AC-GAP-10 a class row rejects US000 (GUARD)" \
    "$st_class/MANUAL/US000-MANUAL-TESTING.md" no
  # GUARD — P4, QA AC-GAP-10: a *TEMPLATE* target is never a member, even of a row that spells it.
  st_reg_probe "P4 AC-GAP-10 a class row rejects a *TEMPLATE* target (GUARD)" \
    "$st_class/US123-FIXTURE-ONLY-TEMPLATE.md" no
  # RED — P4, QA AC-GAP-10 / EC-01, manual TARGET-01: a missing shipped manual template under a
  # present class row is a dangling path. The real template cannot be removed from a working
  # tree, so the fixture cites an absent zero-index path under the fixture-local row above.
  st_probe "P4 EC-01 broken/missing-template-manual.md fires despite the class row" \
    "$FIXTURES_DIR/broken/missing-template-manual.md" 1 \
    "dangling path | ${BT}$st_class/MANUAL/US000-MANUAL-TESTING.md${BT}"
  # RED — P4, QA AC-GAP-10 / EC-06, manual TARGET-02: the same for the automated template.
  st_probe "P4 EC-06 broken/missing-template-automated.md fires despite the class row" \
    "$FIXTURES_DIR/broken/missing-template-automated.md" 1 \
    "dangling path | ${BT}$st_class/AUTOMATED/US000-TEST-STATUS.md${BT}"
  REGISTERED="$st_saved_registered"

  # ── US004 round 2 — failing proofs for the green-round decisions of 05/11/2026 ─
  # Story plan → Key Decisions: "Citer test shape" and "PM-arm false-positive classes". Tags as
  # above, plus POST-HOC: green before it was written, proven red against e3d5187 instead.

  # R2.1 — the derived citer rule replaces the eight-form list: a basename carrying a three-digit
  # story number, a two-digit sprint number, or opening `BUG-` is an instance citer, minus the
  # zero-index and `-TEMPLATE.` names. One clean probe per live form the list missed.
  log ""
  log "  US004 R2.1 — the derived citer rule:"
  # RED — R2.1, six live forms the anchored list does not match.
  st_probe "R2.1 clean/THREAT-MODEL-PLAN-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/THREAT-MODEL-PLAN-US123-FIXTURE-ONLY.md" 0
  st_probe "R2.1 clean/LOGGING-PLAN-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/LOGGING-PLAN-US123-FIXTURE-ONLY.md" 0
  st_probe "R2.1 clean/ASSESSMENT-PLAN-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/ASSESSMENT-PLAN-US123-FIXTURE-ONLY.md" 0
  st_probe "R2.1 clean/QA-IMPL-US123-…-05-11-2026.md citer is exempt" \
    "$FIXTURES_DIR/clean/QA-IMPL-US123-FIXTURE-ONLY-05-11-2026.md" 0
  st_probe "R2.1 clean/FINDING-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/FINDING-US123-FIXTURE-ONLY.md" 0
  st_probe "R2.1 clean/REFACTORING-US123-… citer is exempt" \
    "$FIXTURES_DIR/clean/REFACTORING-US123-FIXTURE-ONLY.md" 0
  # RED — R2.1: four digits are not a story number even at the start of the name, where the
  # anchored list reads the first three and exempts the file. The derived rule must bound it.
  st_probe "R2.1 broken/US1234-… citer is still reported" \
    "$FIXTURES_DIR/broken/US1234-FIXTURE-ONLY.md" 1 "instance citation | ${BT}US042.md${BT}"
  # GUARD — R2.1: an unanchored rule must not over-reach. Four digits or letters mid-name, a
  # zero-index name, a template name and a plain guide all stay reported.
  st_probe "R2.1 broken/NOTES-US1234-… citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/NOTES-US1234-FIXTURE-ONLY.md" 1 "instance citation | ${BT}US042.md${BT}"
  st_probe "R2.1 broken/NOTES-USabc-… citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/NOTES-USabc-FIXTURE-ONLY.md" 1 "instance citation | ${BT}US042.md${BT}"
  st_probe "R2.1 broken/FINDING-US000-… citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/FINDING-US000-FIXTURE-ONLY.md" 1 "instance citation | ${BT}US042.md${BT}"
  st_probe "R2.1 broken/THREAT-MODEL-PLAN-US123-…-TEMPLATE.md citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/THREAT-MODEL-PLAN-US123-FIXTURE-ONLY-TEMPLATE.md" 1 \
    "instance citation | ${BT}US042.md${BT}"
  st_probe "R2.1 broken/GUIDE.md citer is still reported (GUARD)" \
    "$FIXTURES_DIR/broken/GUIDE.md" 1 "instance citation | ${BT}US042.md${BT}"

  # R2.2–R2.4 — the three PM-arm false-positive classes, each fixed in the detector rather than
  # by a marker. Each fixture's token resolves into a checkable tree, as the live sites do.
  log ""
  log "  US004 R2.2–R2.4 — volume specs, comma-joined anchors, the date placeholder:"
  # RED — R2.2: a Compose volume spec names a host and a container path, not a file here.
  st_probe "R2.2 clean/volume-spec.md silent on a host:container volume token" \
    "$FIXTURES_DIR/clean/volume-spec.md" 0
  # GUARD — R2.2: a plain dead relative path on the same kind of line is still a finding.
  st_probe "R2.2 broken/volume-spec.md fires on a dead relative path (GUARD)" \
    "$FIXTURES_DIR/broken/volume-spec.md" 1 \
    "dangling path | ${BT}../logs/NO-SUCH-FIXTURE-ONLY-LOG.md${BT}"
  # RED — R2.3: `<file>:N,:M` cites one existing file at two lines, a script and a template.
  st_probe "R2.3 clean/multi-anchor.md silent on :N,:M of existing files" \
    "$FIXTURES_DIR/clean/multi-anchor.md" 0
  # GUARD — R2.3: the same shape on a file that does not exist still fires, quoted raw.
  st_probe "R2.3 broken/multi-anchor.md fires on :N,:M of a missing file (GUARD)" \
    "$FIXTURES_DIR/broken/multi-anchor.md" 1 \
    "dangling path | ${BT}code/src/scripts/audits/NO-SUCH-FIXTURE-ONLY.sh:345,:351${BT}"
  # RED — R2.4: a basename carrying the literal date placeholder is a placeholder.
  st_probe "R2.4 clean/date-placeholder.md silent on a DD-MM-YYYY basename" \
    "$FIXTURES_DIR/clean/date-placeholder.md" 0
  # GUARD — R2.4: a concrete date in the same position is a citation, and it is dead.
  st_probe "R2.4 broken/date-placeholder.md fires on a concrete-dated dead path (GUARD)" \
    "$FIXTURES_DIR/broken/date-placeholder.md" 1 \
    "dangling path | ${BT}project-management/src/12-SEO/SEO-REPORT-FIXTURE-ONLY-05-11-2026.md${BT}"

  # R2.5 — the green phase normalises `..` before is_registered() and nothing proved it. A
  # fixture-local class row stands in for the real one, as P4 does above.
  # POST-HOC — passes at 022f61a; written after the repair. Proven red by running this probe
  # against e3d5187's script (scratch copy outside the repo, PROJECT_ROOT pinned to the repo).
  log ""
  log "  US004 R2.5 — a relative citation of a registered class member:"
  REGISTERED="$FIXTURES_DIR/clean/AUTOMATED/US###-TEST-STATUS.md"
  st_probe "R2.5 clean/MANUAL/relative-class.md silent on ../AUTOMATED/US123 (POST-HOC)" \
    "$FIXTURES_DIR/clean/MANUAL/relative-class.md" 0
  REGISTERED="$st_saved_registered"

  # R2.6 — Check 4, not the plan stubs, owns the silence of clean/plan-prefix.md. The broken
  # twin cites the same stub paths unprefixed: if Check 1 ran first, both would be dangling
  # paths. Exactly two findings, both plan prefix, and no dangling path among them.
  log ""
  log "  US004 R2.6 — Check 4 decides the plan-prefix stubs before Check 1:"
  # GUARD — R2.6: Check 4 already sits above Check 1; this pins the order.
  st_probes=$((st_probes + 1))
  scan_files "$FIXTURES_DIR/broken/plan-prefix-stubs.md"
  local st_r26_story="$FIXTURES_DIR/clean/plans/17-STORY-PLANS/STORY-PLAN-US042-FIXTURE-ONLY.md"
  if [ "$violations" -ne 2 ]; then
    st_fail "R2.6 broken/plan-prefix-stubs.md: expected 2 finding(s), got $violations"
  elif [ "${report#*"plan prefix | ${BT}${st_r26_story}${BT}"}" = "$report" ]; then
    st_fail "R2.6 broken/plan-prefix-stubs.md: no plan-prefix finding names the story stub"
  elif [ "${report#*dangling path}" != "$report" ]; then
    st_fail "R2.6 broken/plan-prefix-stubs.md: Check 1 reported a dangling path — it ran first"
  else
    log "  ✓ R2.6 broken/plan-prefix-stubs.md reports [plan prefix], never [dangling path] (GUARD)"
  fi

  # ── US004 round 4 — failing proofs for the green-round decision of 05/11/2026 ─
  # Story plan → Key Decisions: "Seeded citers, 05/11/2026". A citer copier seeds from
  # .copier/ is non-shipping for Checks 2 and 3 — the seed replaces its content at generation —
  # and Check 1 still runs on it. SEEDED is read at call time by is_seeded(), so the fixture is
  # made seeded by appending its path, and the parsed set is put back after, as REGISTERED is
  # above. One fixture serves all three probes: the only variable is whether it is seeded.
  log ""
  log "  US004 R4 — a seeded citer is non-shipping for Checks 2 and 3, never for Check 1:"
  local st_saved_seeded="$SEEDED"
  local st_r4="$FIXTURES_DIR/broken/seeded-citer.md"
  local st_r4_inst="instance citation | ${BT}US042.md${BT}"
  local st_r4_tmpl="template-only citation | ${BT}copier.yml${BT}"
  local st_r4_dead="dangling path | ${BT}project-management/src/15-DECISIONS/NO-SUCH-FIXTURE-ONLY-SEEDED-DECISION.md${BT}"
  SEEDED="$SEEDED
$st_r4"
  # RED — R4 Check 2: seeded, the instance citation is silent.
  st_probes=$((st_probes + 1))
  scan_files "$st_r4"
  if [ "${report#*"$st_r4_inst"}" != "$report" ]; then
    st_fail "R4 seeded broken/seeded-citer.md: Check 2 reported the instance citation"
  else
    log "  ✓ R4 seeded broken/seeded-citer.md silent on the instance citation (Check 2)"
  fi
  # RED — R4 Check 3: seeded, the template-only citation is silent, and the dead path is the one
  # finding left.
  st_probes=$((st_probes + 1))
  scan_files "$st_r4"
  if [ "${report#*"$st_r4_tmpl"}" != "$report" ]; then
    st_fail "R4 seeded broken/seeded-citer.md: Check 3 reported the template-only citation"
  elif [ "$violations" -ne 1 ]; then
    st_fail "R4 seeded broken/seeded-citer.md: expected 1 finding(s), got $violations"
  else
    log "  ✓ R4 seeded broken/seeded-citer.md silent on the excluded path (Check 3), one finding left"
  fi
  # GUARD — R4: seeded, Check 1 still runs, so the dead path is still reported.
  st_probes=$((st_probes + 1))
  scan_files "$st_r4"
  if [ "${report#*"$st_r4_dead"}" = "$report" ]; then
    st_fail "R4 seeded broken/seeded-citer.md: Check 1 did not report the dead path"
  else
    log "  ✓ R4 seeded broken/seeded-citer.md still reports [dangling path] (GUARD)"
  fi
  SEEDED="$st_saved_seeded"
  # GUARD — R4: the identical citer NOT seeded still reports all three.
  st_probes=$((st_probes + 1))
  scan_files "$st_r4"
  if [ "$violations" -ne 3 ]; then
    st_fail "R4 unseeded broken/seeded-citer.md: expected 3 finding(s), got $violations"
  elif [ "${report#*"$st_r4_inst"}" = "$report" ]; then
    st_fail "R4 unseeded broken/seeded-citer.md: no instance citation of the US042 sibling"
  elif [ "${report#*"$st_r4_tmpl"}" = "$report" ]; then
    st_fail "R4 unseeded broken/seeded-citer.md: no template-only citation of the contract"
  elif [ "${report#*"$st_r4_dead"}" = "$report" ]; then
    st_fail "R4 unseeded broken/seeded-citer.md: no dangling path for the dead decision"
  else
    log "  ✓ R4 unseeded broken/seeded-citer.md reports instance, template-only and dangling (GUARD)"
  fi

  # ── US004 phase 9 — failing proofs for the confirmed review and QA findings ─
  st_phase9_probes

  log ""
  # The fixtures must stay invisible to an ordinary run, or this proof reddens the gate it
  # exists to prove. Asserted directly, with the flag put back the way a normal run sees it.
  st_probes=$((st_probes + 1))
  SELF_TEST=false
  if is_exempt "$FIXTURES_DIR/broken/anchors.md"; then
    log "  ✓ the fixture tree is exempt from an ordinary run"
  else
    st_fail "the fixture tree is NOT exempt — an ordinary run would report its dangling paths"
  fi
  # GUARD — US004 P1: the fall-through arm admits `*TEMPLATE*`, and this fixture carries the
  # suffix. It must stay exempt from an ordinary run all the same, or P3's own fixture reddens
  # the gate — so the fall-through cannot sit above the fixture arm.
  st_probes=$((st_probes + 1))
  if is_exempt "$FIXTURES_DIR/broken/REVIEW-US123-FIXTURE-ONLY-TEMPLATE.md"; then
    log "  ✓ US004 P1 a *TEMPLATE* fixture is exempt from an ordinary run too (GUARD)"
  else
    st_fail "US004 P1: a *TEMPLATE* fixture is NOT exempt — an ordinary run would read it"
  fi
  SELF_TEST=true

  log ""
  if [ "$st_fails" -eq 0 ]; then
    bold "✓ Self-test passed — $st_probes probes over the five clauses added 20/08–08/09/2026"
    log "  and the US004 repairs of 05/11/2026 (exemption, population, citer, artefact tree)."
    log "  Not covered: Checks 1 and 2 as they shipped before 20/08, and the SURFACE-GATED"
    log "  half of Direction B, which is a prose convention rather than a clause"
    log "  (code/docs/FORWARD-VOICE.md Section 5)."
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
# Check 3's denominator, and it is a different KIND of number from the three above: those
# count what this run read, this counts what it was reading AGAINST. A zero here means the
# `_exclude` parse found nothing and every Direction B citation passed unexamined — which
# would otherwise print as "Clean" (code/docs/GATE-REPORTING.md Section 1).
log "  matched against $template_only_paths path(s) copier excludes unconditionally"

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
  log "instance (ADR-US###, US###, SPRINT-##, MAP-*, PLAN-*). Drop the citation, or"
  log "point at the guide that carries the rule."
  log ""
  log "A [template-only citation] is the other direction: the path resolves here and"
  log "copier excludes it, so the reader of a generated project has no such file. The"
  log "default disposition is still to correct or drop it — reach for the marker only"
  log "when the citation is right and merely unprovable downstream:"
  log "  ... the contract lives in \`copier.yml\`. <!-- doc-references: template-only -->"
  log "Rule and the difference from \`ignore\`: code/docs/FORWARD-VOICE.md Sections 1 and 4."
  log ""
  log "A [plan prefix] finding is neither: it is a NAMING rule, and no file has to be"
  log "missing for it to be true. A story plan is named for its position in the settled"
  log "build order across the whole backlog and a sprint plan likewise, so both carry a"
  log "two-digit prefix and the citation must carry it too. That number is renumbered"
  log "whenever build order changes — so repoint the citation at the name the plan is on"
  log "disk under, and quote a superseded name in \"double quotes\", never in backticks."
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
    printf 'Unconditionally excluded paths matched against: %s\n\n' "$template_only_paths"
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
