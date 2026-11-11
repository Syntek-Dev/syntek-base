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
#                                                          Out of Check 3 BY DECISION: those
#                                                          citations keep the prose `rust-only`
#                                                          / `mobile-only` convention their
#                                                          index rows carry, and no marker.
#                                                          CHANGED 09/11/2026 (US004 F-051):
#                                                          parsed, never listed, into `gated
#                                                          FLAG path` rows of the facts file,
#                                                          with `absent FLAG declined|taken`
#                                                          read from each question's default.
#                                                          Any other templated shape stops the
#                                                          run at exit 2. In a GENERATED project
#                                                          the root .copier-answers.yml is read,
#                                                          and an ABSENT target under a gated
#                                                          path whose flag is false -- or absent
#                                                          with a false default -- is passed by
#                                                          Check 1, not reported, and COUNTED per
#                                                          flag on the run's output. A missing or
#                                                          unreadable answers file, or a
#                                                          non-boolean answer, exempts nothing
#                                                          (fail closed, and the run says so). A
#                                                          taken surface's missing file is an
#                                                          ordinary finding. The template reads
#                                                          no answers: it holds every gated path.
#                                                          CANNOT TELL, downstream, whether a
#                                                          path under a declined gate is spelt
#                                                          right: a misspelt file under the rust
#                                                          docs passes where Rust was declined.
#                                                          Such a citation is judged only in the
#                                                          template, where every gated path is
#                                                          present (US004 round 2, C-02).
#
#                 Seeded paths are subtracted too — an excluded file re-supplied from `.copier/`
#                 exists downstream — as is `uv.lock`, which is excluded and REGENERATED by the
#                 `uv lock` task rather than seeded. Both are read from `_tasks`, not hardcoded.
#
#                 A CITING FILE THAT DOES NOT SHIP IS SKIPPED for this check alone, because
#                 Direction B is a rule about what a SHIPPED document claims. That predicate is
#                 derived here from `copier.yml`; `is_exempt()` below states its own tree arms  # doc-references: template-only
#                 as policy. RECONCILED 05/11/2026 (US004 P1): those arms said "none of these
#                 ship" while the pair files and templates copier re-includes out of them did.
#                 READ, NOT MIRRORED, as of 06/11/2026 (US004 QA-F05 / DR-001): what copier lifts
#                 back out, and what it seeds, come from ONE source -- the contract here, and the
#                 committed derivation of it, doc-references-shipping.txt, in a generated project
#                 that receives no contract (load_shipping() below). And both predicates read ONE
#                 population (US004 P2, repo_files() below), so an untracked file's verdict no
#                 longer depends on whether it has been staged.
#
#                 ADDED 06/11/2026 (US004 QA-F08): Direction B no longer depends on the target
#                 being present. An absent path the contract excludes is the same finding as a
#                 present one, so deleting or gitignoring a cited note no longer "fixes" it.
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
#                 exempt tree, which ships (US004 P1), read from the one shipping source (QA-F05).
#                 A tracked symlink is read once, as its in-repository target (QA-F04).
#
# ADDED 06/11/2026 (US004 GAPS-REL): Check 1 reads a second population, the Markdown link
#                 targets of every .md file, file-relative as Markdown defines them, and reports
#                 a dead one as [dangling link]. A bare backticked token whose leading folder sits
#                 beside its citer is tested in that folder rather than dropped.
# CHANGED 06/11/2026 (US004 review round): a link is judged as a token is -- Direction B present
#                 or absent, Check 2 on its basename, the register and the seeds -- and a target
#                 the token loop already reported on that line is reported once. The template is
#                 the tree holding copier.yml AND .copier/ (has_contract); anywhere else the
#                 shipped facts file is read, and the contract-bound self-test probes exit 2.
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
#                          [--path PATH] [--self-test] [--write-shipping] [--help]
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
#              2 = script error (bad arguments, --self-test with the fixtures missing, or a
#                  copier.yml _exclude line the parse cannot classify), or a self-test that
#                  could not run every probe because the copier contract is absent
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="code/src/scripts/audits/fixtures/doc-references"
SHIPPING_FILE="code/src/scripts/audits/doc-references-shipping.txt"
SHIPPING_CONTRACT="copier.yml"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false
WRITE_SHIPPING=false

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
  doc-references.sh --write-shipping
                                    Regenerate doc-references-shipping.txt from the copier
                                    contract (template only; the file is never hand-edited)

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
    --write-shipping) WRITE_SHIPPING=true; shift   ;;
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
    # MOVED 05/11/2026 (US004 P1): the vendored and fixture arms sit ABOVE the artefact-tree arm
    # below, so each stays exempt for its own reason — a vendored `CONTEXT.md` is upstream's
    # text, and a `-TEMPLATE.` fixture is reached by --self-test alone.
    code/docs/cloudinary/*)                       return 0 ;;  # vendored SDK docs
    .agents/*)                                    return 0 ;;  # vendored third-party skills
    # This audit's own fixtures, exempted as docs-pairing.sh exempts the same tree and for
    # the same reason: the audits run against these files, so a fixture that deliberately
    # carries a dangling path would redden the ordinary run rather than prove anything. They
    # are reached only through --self-test, which points the identical scan at them on
    # purpose -- so the exemption lifts there and nowhere else.
    code/src/scripts/audits/fixtures/*)
      if ! $SELF_TEST; then return 0; fi ;;
    .copier/*)                                    return 0 ;;  # seed staging, moved at generation
    # The artefact trees. This rule polices what a SHIPPED file may cite, and these FOLDERS
    # do not ship — the copier contract empties every one of them at generation. A map cites
    # sibling maps and paths that do not exist yet BY DESIGN: charting future work is what it
    # is for, and the citation resolves when the work lands. A walk-test RUN is CAPTURED rather
    # than authored -- the prompt a cold reader was given, its verbatim answer, the transcript --
    # and is evidence of what a stranger cited INCLUDING WHAT IT CITED WRONGLY, so editing it to
    # satisfy this gate would destroy the record. Scoped to WALK-* deliberately: the folder's
    # own pair ships and stays policed.
    #
    # These were exempt by accident until 17/08/2026: the trees were gitignored, so `git
    # ls-files` never saw them. They are committed now — so they sync across devices — which
    # made 160 citations visible in one commit. The exemption is stated here instead.
    #
    # WHAT COPIER LIFTS BACK OUT SHIPS, and is policed (US004 P1, 05/11/2026). Until 06/11/2026
    # (QA-F05 / DR-001) that was a second, hand-kept copy of the contract's negations, arm by
    # arm, which had already drifted once (phase 9, F5) and which a generated project could
    # never check, because it receives no contract. It is now read: is_reincluded() asks the
    # one list load_shipping() takes from the contract here and from the shipped facts file
    # downstream (the block below this function).
    research/*|learning/*|handoffs/*|project-management/src/01-FEATURE-MAPS/*|project-management/src/00-ASSETS/WALK-TESTS/WALK-*)
      is_reincluded "$1" && return 1
      return 0 ;;
  esac
  return 1
}

# ── What ships: ONE source, read in both trees (US004 QA-F05 / DR-001, 06/11/2026) ──────────────
# Two facts about generation decide which citers ship: what copier SEEDS from .copier/ (is_seeded,
# below) and what its exclusion list LIFTS BACK OUT of an excluded tree (is_reincluded, read by
# is_exempt above). Both used to be read from the copier contract alone -- and the contract is
# excluded from every generated project, so downstream both sets were empty: a project's own
# GAPS.md and .claude/MEMORY.md were policed as shipped files, citing their own stories.
#
# THE CONTRACT IS THE ONE PLACE A HUMAN EDITS. Where it exists -- the template -- it is read, and
# shipping_derive() renders the two facts from it. That rendering is committed beside this script
# as $SHIPPING_FILE, which ships; a generated project, holding no contract, reads the file. The
# file is never hand-edited: `--write-shipping` writes it, and the ordinary run reports a
# [shipping facts] finding whenever it differs from the derivation, so the copy a generated
# project receives cannot lag the contract it was cut from. Rule: code/docs/FORWARD-VOICE.md
# Section 7. Check 3's excluded-path set is NOT read from the file, deliberately: downstream it is
# empty by decision (story plan, Key Decisions, "Whether Check 3's citer test changes too").
SEEDED=""
SHIPS=()
SHIPPING_SOURCE="none"

# WHICH TREE IS THE TEMPLATE (US004 H-06, 06/11/2026). A contract file alone does not say so: a
# generated project may write its own -- to become a template in turn, or for any other reason --
# and reading that one as THE contract replaced the shipped facts with whatever it excluded, so the
# project's own GAPS.md lost its seeded exemption. The template is the tree holding the contract
# AND the `.copier/` staging directory the seed tasks move out of, which generation removes.
has_contract() { [ -f "$SHIPPING_CONTRACT" ] && [ -d .copier ]; }

# The contract's `_exclude` entries, one per line, classified: `A <path>` anchored, `N <path>`
# negated, `G <FLAG> <path>` surface-gated (US004 F-051). Unanchored entries are dropped -- the
# header says why -- and a templated entry of any other shape is exclude_fault()'s to name.
# The single parse both build_template_only() and shipping_derive() read.
#
# EVERY SPELLING YAML ALLOWS, OR A LOUD STOP (US004 H-06, 06/11/2026). Only double quotes came off,
# so a single-quoted negation -- valid YAML, honoured by copier -- fell to the unanchored arm and
# vanished: its file was then treated as excluded, and --write-shipping would have baked the loss
# into the facts file. Both quote styles come off now, and exclude_fault() below names any entry
# this parse still cannot classify, so the top level stops at exit 2 rather than read a smaller set.
exclude_entries() {
  local raw entry
  has_contract || return 0
  raw="$(awk '/^_exclude:/{on=1; next} on && /^[A-Za-z_]+:/{exit} on' "$SHIPPING_CONTRACT" 2>/dev/null || true)"
  [ -n "$raw" ] || return 0
  while IFS= read -r entry; do
    entry="${entry#"${entry%%[![:space:]]*}"}"
    case "$entry" in -\ *) entry="${entry#- }" ;; *) continue ;; esac
    entry="${entry%%[[:space:]]#*}"
    entry="${entry%"${entry##*[![:space:]]}"}"
    case "$entry" in
      \"*\") entry="${entry#\"}"; entry="${entry%\"}" ;;
      \'*\') entry="${entry#\'}"; entry="${entry%\'}" ;;
    esac
    case "$entry" in
      "$BLK_OPEN"*)                             # templated — surface-gated (US004 F-051)
        [[ "$entry" =~ $GATED_ENTRY_RE ]] && printf 'G %s %s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        continue ;;
      "!/"*)  printf 'N %s\n' "${entry#!/}" ;;
      /*)     printf 'A %s\n' "${entry#/}" ;;
      *)      continue ;;                       # unanchored — never part of a checkout
    esac
  done <<< "$raw"
}

# The first `_exclude` line the parse above cannot classify, or nothing: a flow-style list on the
# key's own line, an entry still quoted after one matching pair came off, an unanchored negation
# (it would lift a path back out ANYWHERE, which no set here models), or a line that is neither a
# list entry, a comment nor blank -- or, as of US004 F-051, a templated entry that is not exactly
# `if not FLAG` around one anchored path: an `if FLAG`, an `or`, an unanchored or negated path. Such
# an entry used to be dropped unread, and the gated rows would then be derived short without a
# sound. Called at top level, where `die` ends the run.
exclude_fault() {
  local line entry
  has_contract || return 0
  line="$(grep -m1 -E '^_exclude:' "$SHIPPING_CONTRACT" 2>/dev/null || true)"
  entry="${line#_exclude:}"; entry="${entry%%#*}"
  case "$entry" in *[![:space:]]*) printf '%s\n' "$line"; return 0 ;; esac
  while IFS= read -r line; do
    entry="${line#"${line%%[![:space:]]*}"}"
    case "$entry" in ''|'#'*) continue ;; -\ *) entry="${entry#- }" ;; *) printf '%s\n' "$line"; return 0 ;; esac
    entry="${entry%%[[:space:]]#*}"
    entry="${entry%"${entry##*[![:space:]]}"}"
    case "$entry" in
      \"*\") entry="${entry#\"}"; entry="${entry%\"}" ;;
      \'*\') entry="${entry#\'}"; entry="${entry%\'}" ;;
    esac
    case "$entry" in
      "$BLK_OPEN"*) [[ "$entry" =~ $GATED_ENTRY_RE ]] || { printf '%s\n' "$line"; return 0; } ;;
      *[\"\']*|'!'[!/]*) printf '%s\n' "$line"; return 0 ;;
    esac
  done < <(awk '/^_exclude:/{on=1; next} on && /^[A-Za-z_]+:/{exit} on' "$SHIPPING_CONTRACT" 2>/dev/null || true)
}

# Renders the facts file from the contract: a fixed header, then `seeded <path>` per seed task,
# `ships <glob>` per negation, `gated <FLAG> <path>` per surface-gated entry, in contract order, and
# `absent <FLAG> declined|taken` once per gating flag (US004 F-051). The last is what an ABSENT key
# in .copier-answers.yml means, read from the question's own default: copier omits a question its
# `when` skipped, so INCLUDE_DESKTOP is absent wherever INCLUDE_RUST was declined, and only a
# default of `false` makes absence a decline -- INCLUDE_CLICKUP defaults true, and a question
# whose default this cannot read is `taken`, so absence never exempts by guesswork.
# 1 when there is no contract to read.
shipping_derive() {
  has_contract || return 1
  printf '%s\n' \
    "# doc-references-shipping.txt -- what copier seeds and lifts back out, for doc-references.sh." \
    "#" \
    "# GENERATED from the copier contract by: bash code/src/scripts/audits/doc-references.sh --write-shipping" \
    "# Never hand-edit it. The contract is the one place a human edits; the template's ordinary run" \
    "# fails while this file and the contract disagree. It ships so a generated project, which" \
    "# receives no contract, reads the same facts. Rule: code/docs/FORWARD-VOICE.md Section 7." \
    "#"
  grep -oE 'mv \.copier/[^ ]+ ([^ ]+)' "$SHIPPING_CONTRACT" 2>/dev/null | awk '{print "seeded " $3}' || true
  local entries flag def
  entries="$(exclude_entries)"
  printf '%s\n' "$entries" | awk '$1=="N"{print "ships " $2}'
  printf '%s\n' "$entries" | awk '$1=="G"{print "gated " $2 " " $3}'
  while IFS= read -r flag; do
    [ -n "$flag" ] || continue
    def="$(awk -v f="$flag" '
      index($0, f ":") == 1 && length($0) == length(f) + 1 { on = 1; next }
      on && /^[^[:space:]#]/ { exit }
      on && /^[[:space:]]+default:/ {
        sub(/^[[:space:]]+default:[[:space:]]*/, ""); sub(/[[:space:]]*#.*$/, ""); print; exit
      }' "$SHIPPING_CONTRACT" 2>/dev/null || true)"
    if [ "$def" = false ]; then printf 'absent %s declined\n' "$flag"
    else printf 'absent %s taken\n' "$flag"; fi
  done < <(printf '%s\n' "$entries" | awk '$1=="G" && !seen[$2]++ {print $2}')
}

# 0 when $1 differs from what the contract derives -- missing counts as different.
shipping_stale() { # $1 = facts file
  [ "$(shipping_derive)" != "$(cat -- "$1" 2>/dev/null)" ]
}

load_shipping() {
  local facts=""
  if has_contract; then
    facts="$(shipping_derive)"; SHIPPING_SOURCE="contract"
  elif [ -f "$SHIPPING_FILE" ]; then
    facts="$(cat -- "$SHIPPING_FILE")"; SHIPPING_SOURCE="facts file"
  fi
  SEEDED="$(printf '%s\n' "$facts" | awk '$1=="seeded"{print $2}')"
  mapfile -t SHIPS < <(printf '%s\n' "$facts" | awk '$1=="ships"{print $2}')
  parse_gated_facts "$facts"
}

# ── Declined surfaces (US004 F-051, 09/11/2026) ──────────────────────────────────────────────────
# A path behind a templated `_exclude` entry ships only where its surface was TAKEN. In a project
# that declined it the file is absent by design, and every shipped citation of it -- each carrying
# the prose `rust-only` / `mobile-only` flag (code/docs/FORWARD-VOICE.md Section 5) -- was reported
# as a dangling path: 119 findings in a default render. So in a GENERATED project, and only there,
# the root .copier-answers.yml is read, and an absent target under a gated path whose flag was
# declined is passed rather than reported. It is COUNTED per flag and printed, because a green run
# must not read as "every cited file exists" (code/docs/GATE-REPORTING.md). It FAILS CLOSED: no
# answers file, one copier did not write, or a surface answer that is not a boolean exempts nothing
# and the run says why. A taken surface with a missing file is an ordinary finding. The template
# holds every gated path, so it reads no answers and passes nothing.
# The limit: a misspelt path under a declined gate passes downstream too, since nothing there can
# tell it from a correct one. The template run is the only place such a citation is judged.
GATED_FLAG=()
GATED_PATH=()
declare -A GATED_ABSENT=()
declare -A DECLINED=()
declare -A DECLINED_HITS=()
declare -A DECLINED_SEEN=()
declined_total=0
ANSWERS_FILE=".copier-answers.yml"
GATE_STATE="none"      # template | answers | no-answers | unparseable | none
GATE_REASON=""

parse_gated_facts() { # $1 = facts text
  local kind a b
  GATED_FLAG=(); GATED_PATH=(); GATED_ABSENT=()
  while read -r kind a b; do
    case "$kind" in
      gated)  GATED_FLAG+=("$a"); GATED_PATH+=("$b") ;;
      absent) GATED_ABSENT["$a"]="$b" ;;
    esac
  done <<< "$1"
  return 0
}

load_surface_answers() { # $1 = true in the template
  local flag line val
  DECLINED=(); GATE_REASON=""
  if [ "$1" = true ]; then GATE_STATE="template"; return 0; fi
  if [ "${#GATED_FLAG[@]}" -eq 0 ]; then GATE_STATE="none"; return 0; fi
  if [ ! -f "$ANSWERS_FILE" ]; then
    GATE_STATE="no-answers"; GATE_REASON="$ANSWERS_FILE is missing"; return 0
  fi
  if ! grep -qE '^_(src_path|commit):' "$ANSWERS_FILE" 2>/dev/null; then
    GATE_STATE="unparseable"; GATE_REASON="$ANSWERS_FILE holds no _src_path or _commit, so copier did not write it"
    return 0
  fi
  local -A seen=()
  for flag in "${GATED_FLAG[@]}"; do
    [ -z "${seen[$flag]:-}" ] || continue
    seen["$flag"]=1
    # Every line that could be this key to a YAML reader -- indented, quoted, or spaced before
    # its colon -- not only the one form copier writes. More than one, or one in any other form,
    # is a file this line reader cannot answer for, so it fails closed (US004 round 2, Q-02):
    # read as absent, an indented key became a false-default decline, and grep's first match
    # disagreed with a loader's last on a duplicated key.
    line="$(grep -E "^[[:space:]]*[\"']?${flag}[\"']?[[:space:]]*:" "$ANSWERS_FILE" 2>/dev/null || true)"
    if [ -n "$line" ] && { [[ "$line" == *$'\n'* ]] || [[ "$line" != "${flag}:"* ]]; }; then
      DECLINED=(); GATE_STATE="unparseable"
      GATE_REASON="$flag is not written once as a top-level key"; return 0
    fi
    if [ -z "$line" ]; then
      [ "${GATED_ABSENT[$flag]:-taken}" = declined ] && DECLINED["$flag"]=1
      continue
    fi
    val="${line#*:}"; val="${val%%#*}"
    val="${val#"${val%%[![:space:]]*}"}"; val="${val%"${val##*[![:space:]]}"}"
    case "$val" in
      false|False|FALSE) DECLINED["$flag"]=1 ;;
      true|True|TRUE) ;;
      *) DECLINED=(); GATE_STATE="unparseable"
         GATE_REASON="$flag is answered '$val', which is not a boolean"; return 0 ;;
    esac
  done
  GATE_STATE="answers"
  return 0
}

# 0 when $1 (repo-relative, absent) sits under a gated path whose surface was declined; counted
# once per CITATION -- citing file, line, resolved target -- as a finding is reported once (US004
# round 2, C-04): a link and a token naming one target on one line were counted twice. Reads the
# scan loop's `file` and `lineno`.
is_declined_gated() {
  [ "$GATE_STATE" = answers ] || return 1
  local i key
  for i in "${!GATED_PATH[@]}"; do
    [ -n "${DECLINED[${GATED_FLAG[$i]}]:-}" ] || continue
    if path_matches "$1" "${GATED_PATH[$i]}"; then
      key="${file:-}|${lineno:-}|$1"
      [ -n "${DECLINED_SEEN[$key]:-}" ] && return 0
      DECLINED_SEEN["$key"]=1
      DECLINED_HITS["${GATED_FLAG[$i]}"]=$(( ${DECLINED_HITS[${GATED_FLAG[$i]}]:-0} + 1 ))
      declined_total=$((declined_total + 1))
      return 0
    fi
  done
  return 1
}

is_reincluded() { # $1 = repo-relative path; 0 when a negation lifts it back out of an excluded tree
  local g
  for g in "${SHIPS[@]}"; do path_matches "$1" "$g" && return 0; done
  return 1
}

# `--` before the pattern (US004 H-07): a CSS-token citation such as `--text-primary/-muted` reaches
# here through is_excluded_by_rule(), and grep read it as an option and printed an error per token.
is_seeded() {
  [ -n "$SEEDED" ] && printf '%s\n' "$SEEDED" | grep -qxF -- "$1"
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
BLK_CLOSE=":"">"
# One surface-gated `_exclude` entry, exactly: `if not FLAG` around one anchored path (US004 F-051).
GATED_ENTRY_RE="^${BLK_OPEN} if not ([A-Z][A-Z0-9_]*) ${BLK_CLOSE}/([^[:space:]${LT}!][^[:space:]${LT}]*)${BLK_OPEN} endif ${BLK_CLOSE}\$"

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

# The parsed globs are kept (US004 QA-F08) so a path can be judged by the RULE as well as by the
# set: an absent path is in no set, and Check 1's catch-all asks the rule about it instead.
EXCL_ANCHORED=()
EXCL_NEGATED=()
# The anchored entries naming a ROOT file (no slash), kept apart (US004 H-05) so a slashless token
# can ask the rule in one lookup: literal names in an index, the rare glob in a short list.
declare -A EXCL_ROOT_LIT=()
EXCL_ROOT_GLOB=()
build_template_only() {
  local kind entry anchored=() negated=() f d g
  while read -r kind entry; do
    case "$kind" in
      A) anchored+=("$entry") ;;
      N) negated+=("$entry") ;;
    esac
  done < <(exclude_entries)
  [ "${#anchored[@]}" -gt 0 ] || return 0
  EXCL_ANCHORED=("${anchored[@]}")
  EXCL_NEGATED=("${negated[@]}")
  for g in "${anchored[@]}"; do
    case "$g" in
      */*) ;;
      *[*?[]*) EXCL_ROOT_GLOB+=("$g") ;;
      *) EXCL_ROOT_LIT["$g"]=1 ;;
    esac
  done

  local -a population
  mapfile -t population < <(repo_files 2>/dev/null)
  local keep
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

# THE SAME VERDICT FOR AN ABSENT PATH (US004 QA-F08, 06/11/2026). TEMPLATE_ONLY is built over the
# files that exist, so a citation into an excluded tree was a [template-only citation] while its
# target was on disk and clean once it was deleted or gitignored: removing the target "fixed" the
# finding. This asks the parsed RULE rather than the set -- an anchored entry matches, no negation
# re-includes it, and it is neither seeded nor the regenerated lock -- so presence decides nothing.
# Downstream the contract is absent, both arrays are empty, and this answers no, as the set does.
is_excluded_by_rule() { # $1 = repo-relative path
  local p="${1%/}" g
  p="${p#./}"
  [ "${#EXCL_ANCHORED[@]}" -gt 0 ] || return 1
  is_seeded "$p" && return 1
  [ "$p" = "uv.lock" ] && return 1
  for g in "${EXCL_NEGATED[@]}"; do path_matches "$p" "$g" && return 1; done
  for g in "${EXCL_ANCHORED[@]}"; do path_matches "$p" "$g" && return 0; done
  return 1
}

# A slashless ROOT path the rule excludes (US004 H-05). One index lookup before the full rule, so
# the 28k slashless tokens of an unscoped run -- `git`, `--path`, ports -- cost one array read each.
is_root_excluded() { # $1 = slashless path
  local g hit=false
  if [ -n "${EXCL_ROOT_LIT[$1]:-}" ]; then
    hit=true
  else
    for g in "${EXCL_ROOT_GLOB[@]}"; do path_matches "$1" "$g" && { hit=true; break; }; done
  fi
  [ "$hit" = true ] && is_excluded_by_rule "$1"
}

exclude_fault_line="$(exclude_fault)"
[ -z "$exclude_fault_line" ] \
  || die "cannot classify this copier.yml _exclude line, so the excluded and shipped sets would be read short: $exclude_fault_line"
load_shipping
if has_contract; then load_surface_answers true; else load_surface_answers false; fi
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
#
# EVERY FORM, NOT ONE MORE EACH TIME (US004 QA-F03, 06/11/2026). The loop above took `,:N` alone,
# so `:12,40`, a trailing range after the comma and a `#heading` fragment reached the existence
# test whole -- and a shipped template cited with a fragment was a [dangling path] no marker could
# answer, because presence is tested before the marker is read. The fragment comes off first, from
# the first `#` with no slash after it; then each trailing `,N`, `,:N`, `,N-M` or `,N:M` in a loop;
# then the three branches. A marker reaches exactly what it reached before: it is read after this.
#
# AND THE REST OF WHAT A LINK CARRIES (US004 H-08, 06/11/2026): a `?query` (GitHub's `?plain=1`)
# after the fragment comes off, then a trailing comma prose leaves behind, and `:L12` / `:L12-L20`
# beside `:12`. A fragment holding a slash is still left alone, deliberately: it may be a path.
peel_anchor() { # $1 = token -> sets `peeled`
  peeled="$1"
  if [[ "$peeled" =~ ^([^#]+)#[^/]*$ ]]; then
    peeled="${BASH_REMATCH[1]}"
  fi
  if [[ "$peeled" =~ ^([^?]+)\?[^/]*$ ]]; then
    peeled="${BASH_REMATCH[1]}"
  fi
  peeled="${peeled%,}"
  while [[ "$peeled" =~ ^(.+),:?L?[0-9]+([-:]L?[0-9]+)?$ ]]; do
    peeled="${BASH_REMATCH[1]}"
  done
  if [[ "$peeled" =~ ^(.+):[0-9]+:[0-9]+$ ]] \
     || [[ "$peeled" =~ ^(.+):L?[0-9]+-L?[0-9]+$ ]] \
     || [[ "$peeled" =~ ^(.+):L?[0-9]+$ ]]; then
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

# A symlink's in-repository target, followed textually as normalise_rel() does: an absolute
# target inside PROJECT_ROOT is made relative, anything else is outside. Sets `normalised`;
# returns 1 for a target outside the repository or a chain deeper than eight (US004 QA-F04).
resolve_link() { # $1 = repo-relative link path
  local p="$1" t d n=0
  while [ -L "$p" ]; do
    n=$((n + 1)); [ "$n" -le 8 ] || return 1
    t="$(readlink -- "$p")" || return 1
    case "$t" in
      "$PROJECT_ROOT"/*) p="${t#"$PROJECT_ROOT"/}" ;;
      /*)                return 1 ;;
      *)                 d="${p%/*}"; [ "$d" = "$p" ] && d="."
                         normalise_rel "$d/$t" || return 1
                         p="$normalised" ;;
    esac
  done
  normalised="$p"
}

# A token with a template placeholder, a numeric pattern, or a glob is not a citation.
# The literal house date placeholder `DD-MM-YYYY` in a name is one too (US004 R2.4, 05/11/2026):
# it describes a dated artefact's naming convention, and the same path carrying a real date is
# still a citation and still checked. Only the BASENAME is a placeholder (US004 phase 9,
# QA-US004-12): the folder such a token names is concrete, so scan_files() tests that folder.
# Split out of is_pattern() on 05/11/2026 so the template-presence test below can ask the
# placeholder question alone.
# CORRECTED 06/11/2026 (US004 F-021): `NN` is a placeholder only as a RUN of its own -- two or
# more `N` with no capital letter on either side, as the conventions write it: `NN-name/`,
# `NN-SPRINT-PLAN-NN.md`, `US0NN`, `F-0NN`, `-NN-NN-NNNN`, `dev-usNNN`. The arm used to match the
# letters anywhere, so every `PLANNING/` path and `MAP-SCALE-PLANNING.md` went untested.
# A capital is an ASCII capital, spelt out letter by letter (CORRECTED 06/11/2026, US004 QA-A1):
# `[:upper:]` follows LC_CTYPE, so `ÉNNÉ` was a placeholder under C and a citation under UTF-8,
# and `A-Z` is a range, whose members follow the locale's collation. A literal list is neither.
# A run against a non-ASCII letter is therefore a placeholder in every locale.
NN_UPPER_ASCII='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
NN_PLACEHOLDER_RE="(^|[^${NN_UPPER_ASCII}])NN+([^${NN_UPPER_ASCII}]|\$)"
is_placeholder() {
  case "$1" in
    *"$TOK_OPEN"*|*"$BLK_OPEN"*)                                     return 0 ;;
    *'{'*|*'###'*|*'##'*|*'<'*'>'*|*'*'*|*'…'*)                      return 0 ;;
    *'–'*|*'—'*)                                                     return 0 ;;  # en/em-dash range
    *DD-MM-YYYY*)                                                    return 0 ;;  # date placeholder
  esac
  [[ "$1" =~ $NN_PLACEHOLDER_RE ]] && return 0
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
#
# A CONCRETE DATE BINDS AN INSTANCE TOO (US004 QA-F02, 06/11/2026). Four record families have a
# story-less form -- FINDING-, REVIEW-, REFACTORING- and INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md, each
# folder's CLAUDE.md -- and what binds that name to one project's history is the date it ends in,
# exactly as a story number binds the primary form. So the same derivation the ADR prescribes
# reads that property too: a basename ending `-NN-NN-NNNN.<ext>` in digits. The placeholder date
# is letters, so the naming convention itself never matches; a `-TEMPLATE.` name is excluded below.
# SCOPED TO THOSE FOUR FAMILIES (US004 H-04, 06/11/2026): the date arm first matched any dated
# basename, so a dated shipped guide anywhere silently lost Check 2. Only the record families whose
# convention binds the date are instance citers by it.
INSTANCE_CITER_RE='(^|[^A-Za-z])(US[0-9]{3}|SPRINT-(PLAN-)?[0-9]{2})([^0-9]|$)|^BUG-|^(FINDING|REVIEW|REFACTORING|INCIDENT)-.*-[0-9]{2}-[0-9]{2}-[0-9]{4}\.[A-Za-z0-9]+$'

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
link_tests=0

# Which classes fired, so the report prints the remedy for those alone (US004 H-10).
declare -A class_hits=()
declare -A scan_hit=()   # scan_files() shadows it per run; global so record() may always write it
record() { # file line kind detail
  violations=$((violations + 1))
  class_hits["$3"]=1
  scan_hit["$2|tok:$4"]=1   # the citation as written, so a link spelling it the same way is one finding
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
  link_tests=0
  declined_total=0
  DECLINED_HITS=()
  DECLINED_SEEN=()
  local file lineno token line prev is_naming_row stripped resolved sibling base
  local is_marked file_ships file_dir tmpl tmpl_base peeled plan citer_instance template_target
  local citer_seeded normalised check_tok date_dir relative tok_base root_tok
  local resolved_skip=false
  local -A scan_seen=()
  # What the token loop reported, keyed `line|repo-relative target`, so the link loop does not
  # report the same target on the same line a second time (US004 REV-03): the house style writes
  # [`x`](x), and one dead citation is one finding.
  local -A scan_hit=()

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue
    # A TRACKED SYMLINK IS READ AS ITS TARGET, ONCE (US004 QA-F04, 06/11/2026). `.ai/MEMORY.md`
    # points at `.claude/MEMORY.md`, and every predicate below keys on the PATH: read under the
    # link's name the same bytes lost the seeded-citer exemption their target holds, and were read
    # twice in an unscoped run. The link is resolved to its in-repository target first, so the
    # target's exemptions apply and its findings are reported once, under the target's path. A
    # link leaving the repository is not repository content and is skipped as exempt.
    if [ -L "$file" ]; then
      if ! resolve_link "$file"; then exempt_files=$((exempt_files + 1)); continue; fi
      file="$normalised"
    fi
    if [ -n "${scan_seen[$file]:-}" ]; then exempt_files=$((exempt_files + 1)); continue; fi
    scan_seen["$file"]=1
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
    scan_hit=()

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
      tok_base=""
      if is_template_target "$token"; then
        template_target=true
      elif is_pattern "$token"; then
        tok_base="${token##*/}"
        # A DATE PLACEHOLDER DOES NOT LAUNDER AN INSTANCE (US004 QA-F07, 06/11/2026). A bare name
        # whose ONLY placeholder is the date, and whose remainder is itself a concrete instance --
        # a story number appended `-DD-MM-YYYY`, an ADR-US### with the date left generic -- still
        # names that instance, and Check 2 sees it as it did before the date became a placeholder.
        # Bare only, because Check 2 is anchored and has never read a path-form token. The date
        # alone stays a pattern: a zero-index or placeholder remainder is still not an instance.
        case "$token" in
          */*DD-MM-YYYY*) ;;
          *DD-MM-YYYY*)
            is_pattern "${token//DD-MM-YYYY/}" && continue
            [[ "$token" =~ $INSTANCE_CITED_RE ]] || continue
            tok_base="" ;;   # a bare dated instance: Check 2 reads it, the folder route below does not
          *) continue ;;
        esac
      fi
      if [ -n "${tok_base:-}" ]; then
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
        root_tok=""
        case "$tmpl" in
          http*|*@*|*' '*|'') ;;
          ./*) root_tok="${tmpl#./}" ;;
          */*) ;;
          *)   root_tok="$tmpl" ;;
        esac
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
            scan_hit["$lineno|$tmpl"]=1
            continue
          fi
        fi
        # A ROOT SPELLING, ABSENT OR PRESENT (US004 H-05, 06/11/2026). A slashless token never
        # reaches Check 1's catch-all, where the rule is asked about an absent path, and a `./`
        # token was resolved file-relative above, so its present root file read as not
        # template-only and Check 1 then cleared it on the root reading. Both now ask the set for
        # a present root file and the rule for an absent one -- unless the file-relative reading
        # exists, which is what the sibling-first lookups above already prefer.
        # Cheapest test first: an unscoped run carries ~28k slashless tokens, and only an index hit
        # may cost a stat.
        if [ -n "$root_tok" ]; then
          tmpl=""
          if is_template_only "$root_tok"; then
            tmpl="$root_tok"
          else
            case "$root_tok" in
              */*) [ ! -e "$root_tok" ] && is_excluded_by_rule "$root_tok" && tmpl="$root_tok" ;;
              *)   is_root_excluded "$root_tok" && [ ! -e "$root_tok" ] && tmpl="$root_tok" ;;
            esac
          fi
          if [ -n "$tmpl" ] && [ ! -e "$file_dir/$root_tok" ]; then
            record "$file" "$lineno" "template-only citation" "$token"
            scan_hit["$lineno|$root_tok"]=1
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
      # THE PATH FORM TOO (US004 H-03, 06/11/2026). QA-F07 above kept a bare dated instance on
      # Check 2, and the path form went to the folder route, which passes because the folder
      # exists -- so ".../ADR-US987-FOO-DD-MM-YYYY.md" was silent while the same path with a real
      # date was a finding. The basename's remainder is read here as the bare token is above.
      if [ "$date_dir" = true ] && [ "$is_naming_row" = false ] && [ "$citer_instance" = false ] \
         && [ "$citer_seeded" = false ]; then
        base="${tok_base//DD-MM-YYYY/}"
        if [[ "$base" =~ $INSTANCE_CITED_RE ]] && ! is_pattern "$base"; then
          record "$file" "$lineno" "instance citation" "$token"
          continue
        fi
      fi
      if [ "$is_naming_row" = false ] && [ "$citer_instance" = false ] \
         && [ "$citer_seeded" = false ] && [ "$date_dir" = false ] \
         && [[ "$token" =~ $INSTANCE_CITED_RE ]]; then
        base="${token##*/}"
        # The archive arm (31/10/2026): a Closed map is moved into 01-FEATURE-MAPS/archive/ by
        # pm-archive.sh, and a bare citation of it is still a citation of a map that exists —
        # every PM reader resolves an ID across the folder AND its archive/, and so does this.
        # The seeded arm reads the same folder (US004 F-021, 06/11/2026): a map seeded there is in
        # every generated project, and a bare `MAP-SCALE-PLANNING.md` is a citation of that file.
        if ! is_seeded "$token" && ! is_seeded "project-management/src/01-FEATURE-MAPS/$base" \
           && [ ! -e "$token" ] && [ ! -e "project-management/src/01-FEATURE-MAPS/$base" ] \
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
                # A BARE FILE-RELATIVE TOKEN (US004 GAPS-REL, 06/11/2026). Neither reading exists,
                # but the token's leading folder sits beside its citer -- `data-structures/X.md`
                # written in code/docs/ -- so it names a file in that folder, and it is tested
                # there rather than dropped as an unresolvable shorthand. A folder that is not
                # beside the citer leaves the token as it was.
                /*) ;;   # a root-anchored spelling, `/GAPS.md`: no leading folder to find
                *)
                  [ -d "$(dirname "$file")/${resolved%%/*}" ] && resolved="$sibling" ;;
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
            [ -e "$resolved" ] || is_declined_gated "$resolved" \
              || { record "$file" "$lineno" "dangling path" "$token"; scan_hit["$lineno|$resolved"]=1; }
          # US004 QA-F08: an ABSENT target the copier contract excludes is Check 3's finding,
          # exactly as the present one was above. A present one never reaches here: Check 3
          # reported it and moved on. Same three gates as Check 3 -- a shipping citer, no marker.
          elif [ "$file_ships" = true ] && [ "$is_marked" = false ] && [ "$date_dir" = false ] \
               && [ ! -e "$resolved" ] && is_excluded_by_rule "$resolved"; then
            record "$file" "$lineno" "template-only citation" "$token"
            scan_hit["$lineno|$resolved"]=1
          fi
          continue ;;
      esac

      # Counted HERE, at the existence test, and nowhere earlier: everything above this line
      # is Check 1 deciding whether the token is a repo path at all, and a token dropped by
      # the URL, shorthand or checkable-tree arms was never tested. This is the population a
      # dangling-path finding could have come from.
      path_tests=$((path_tests + 1))
      [ -e "$resolved" ] && continue
      # US004 F-051: absent by design where its surface was declined -- passed, and counted.
      is_declined_gated "$resolved" && continue
      # A shipped template is a literal presence obligation (US004, ADR 09/10/2026): absent is
      # a finding, and nothing below — a seed, a register row, a naming row, the ignore marker
      # folded into it — may quieten it.
      if [ "$template_target" = true ]; then
        record "$file" "$lineno" "dangling path" "$token"
        scan_hit["$lineno|$resolved"]=1
        continue
      fi
      # `$resolved` is already normalised by the relative arm above (US004 phase 9, F1), so a
      # sibling-relative citation of a registered class member (US004 P4) matches its row as
      # the repo-relative spelling does.
      is_seeded "$resolved" && continue
      is_registered "$resolved" && continue
      [ "$is_naming_row" = true ] && continue
      record "$file" "$lineno" "dangling path" "$token"
      scan_hit["$lineno|$resolved"]=1
    done < <(grep -noE "\`[^\`]+\`" "$file" 2>/dev/null | sed 's/`//g' || true)

    # ── Check 1, second population — a Markdown link target (US004 GAPS-REL, 06/11/2026) ────────
    # The loop above reads backticked spans only, so `[text](target)` was never read: the house
    # habit of backticking the TEXT kept the repo-rooted spelling checked while the target -- the
    # half a reader actually follows -- went untested, and a file written in file-relative links
    # had nothing checked at all. A link target is file-relative by definition, so it is resolved
    # against its citer with no shorthand reading. Not a target: a URL or any `scheme:`, an
    # in-page `#fragment`, an absolute or `<angle>` target, a placeholder, or one climbing out of
    # the repository.
    #
    # THE SAME JUDGEMENTS AS A BACKTICKED CITATION (US004 REV-01 / H-01 / REV-03, 06/11/2026). A
    # link is a citation, so Direction B applies to it as it does to a token: from a shipping citer
    # with no marker, a present target copier excludes, or an absent one its rule excludes, is a
    # [template-only citation] -- otherwise a shipped guide could link into research/ and pass the
    # template while the link died in every generated project. An absent target whose basename
    # names a per-project instance is an [instance citation], on Check 2's own citer gates. The
    # register and the seeds are read first, as the token loop reads them first in the PM tree, and
    # a target the token loop already reported on the same line -- resolved to the same path, or
    # spelt the same way -- is not reported again.
    #
    # WHAT IS READ AS A LINK (US004 H-02, 06/11/2026), in the extractor below: never inside a fence
    # (a fence closes only on the same character, at least as long), an indented code block (four
    # columns after a blank line, outside a list), an HTML comment, or a code span of any width;
    # never from an escaped bracket; and a target keeps one balanced level of parentheses.
    [[ "$file" == *.md ]] || continue
    while IFS=: read -r lineno token; do
      [ -n "$token" ] || continue
      case "$token" in
        '#'*|/*|'<'*|*://*|*%*|mailto:*|tel:*|data:*) continue ;;
      esac
      [[ "$token" =~ ^[A-Za-z][A-Za-z0-9+.-]*: ]] && continue
      is_placeholder "$token" && continue
      check_tok="${token%%#*}"; check_tok="${check_tok%%\?*}"; check_tok="${check_tok%/}"
      [ -n "$check_tok" ] || continue
      normalise_rel "$file_dir/$check_tok" || continue
      resolved="$normalised"
      case "$resolved" in
        */reports/*|*/coverage/*|*/staticfiles/*|.claude/worktrees/*|code/docs/MACHINE-SPEC.md) continue ;;
      esac
      link_tests=$((link_tests + 1))
      [ -n "${scan_hit[$lineno|$resolved]:-}${scan_hit[$lineno|tok:$check_tok]:-}" ] && continue
      line="$(sed -n "${lineno}p" "$file" 2>/dev/null || true)"
      prev="$(sed -n "$((lineno > 1 ? lineno - 1 : 1))p" "$file" 2>/dev/null || true)"
      case "$line$prev" in
        *'doc-references: ignore'*|*'doc-references: template-only'*) is_marked=true ;;
        *)                                                           is_marked=false ;;
      esac
      if [ -e "$resolved" ]; then
        if [ "$file_ships" = true ] && [ "$is_marked" = false ] && is_template_only "$resolved"; then
          record "$file" "$lineno" "template-only citation" "$token"
        fi
        continue
      fi
      is_declined_gated "$resolved" && continue   # US004 F-051, as the token loop
      if ! is_template_target "$resolved"; then
        is_registered "$resolved" && continue
        if [ "$file_ships" = true ] && [ "$is_marked" = false ] && is_excluded_by_rule "$resolved"; then
          record "$file" "$lineno" "template-only citation" "$token"
          continue
        fi
        is_seeded "$resolved" && continue
        [ "$is_marked" = true ] && continue
        base="${resolved##*/}"
        if [ "$citer_instance" = false ] && [ "$citer_seeded" = false ] \
           && [[ "$base" =~ $INSTANCE_CITED_RE ]] && ! is_pattern "$base"; then
          record "$file" "$lineno" "instance citation" "$token"
          continue
        fi
      fi
      record "$file" "$lineno" "dangling link" "$token"
    done < <(awk '
      # Fences: the opening run sets the character and the length; only a run of the same
      # character, at least as long, with nothing after it, closes it.
      {
        raw = $0
        if (fence) {
          if (match(raw, /^[ \t]*(`+|~+)[ \t]*$/)) {
            run = substr(raw, RSTART, RLENGTH); gsub(/[ \t]/, "", run)
            if (substr(run, 1, 1) == fch && length(run) >= flen) fence = 0
          }
          prevblank = 0; next
        }
        if (match(raw, /^[ \t]*(```+|~~~+)/)) {
          run = substr(raw, RSTART, RLENGTH); gsub(/[ \t]/, "", run)
          fence = 1; fch = substr(run, 1, 1); flen = length(run); prevblank = 0; next
        }
      }
      # An indented code block: four columns in, after a blank line or more code, outside a list.
      /^[ \t]*$/ { prevblank = 1; next }
      {
        if (raw ~ /^ {0,3}([-*+]|[0-9]+[.)])[ \t]/) inlist = 1
        else if (raw !~ /^[ \t]/) inlist = 0
        if ((raw ~ /^(    |\t)/) && (prevblank || incode) && !inlist) { incode = 1; prevblank = 0; next }
        incode = 0; prevblank = 0
      }
      {
        line = raw
        # HTML comments, on one line or across several.
        if (incomment) {
          if ((i = index(line, "-->")) == 0) next
          line = substr(line, i + 3); incomment = 0
        }
        while ((i = index(line, "<!--")) > 0) {
          rest = substr(line, i + 4)
          if ((j = index(rest, "-->")) == 0) { line = substr(line, 1, i - 1); incomment = 1; break }
          line = substr(line, 1, i - 1) substr(rest, j + 3)
        }
        gsub(/``([^`]|`[^`])*``/, "", line)
        gsub(/`[^`]*`/, "", line)
        gsub(/\\[][]/, "", line)
        while ((i = index(line, "](")) > 0) {
          line = substr(line, i + 2); t = ""; depth = 0
          for (k = 1; k <= length(line); k++) {
            c = substr(line, k, 1)
            if (c ~ /[ \t]/) break
            if (c == "(") depth++
            else if (c == ")") { if (depth == 0) break; depth-- }
            t = t c
          }
          if (t != "") print NR ":" t
          line = substr(line, k)
        }
      }' "$file" 2>/dev/null || true)
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
  # CHANGED 06/11/2026 (US004 QA-F08): the research/ target is excluded by copier, and an absent
  # excluded target is now a [template-only citation] rather than silent -- so four findings, the
  # same verdict for both spellings of each target, which is the property this probe pins.
  # Downstream the excluded set is empty by decision, so the research/ pair is silent under both
  # spellings and two findings remain: the same property, read without the contract (REV-04).
  local st_f1_want=2
  if has_contract; then st_f1_want=4; fi
  st_probe "P9-F1 broken/relative-normalise.md: one verdict per target, either spelling" \
    "$FIXTURES_DIR/broken/relative-normalise.md" "$st_f1_want" \
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

# ── US004 QA round (06/11/2026) — one probe set per item the QA pass and the review raised ─────
# Every item is fixed in US004 by <%DEVELOPER_NAME%>'s ruling, none deferred. Labels carry the item
# id (QA-F01..F08, GAPS-REL); tags as above. QA-F01's probes are GUARDs by construction -- they pass
# on the detector as it stood -- and their red is a MUTANT that survived the self-test before them
# and is killed after; the four mutants are named at the probes. Fix the detector, never these.
st_qa_round_probes() {
  local BT=$'\x60' out

  # QA-F01 — four phase 9 behaviours had no probe, so deleting the line left the self-test green.
  log ""
  log "  US004 QA-F01 — the four phase 9 lines a mutation run deleted without a red:"
  # GUARD — kills mutant M9 (is_template_target's `.../` elision arm deleted).
  st_probe "QA-F01 clean/template-elision.md silent on a .../-elided template (M9)" \
    "$FIXTURES_DIR/clean/template-elision.md" 0
  # GUARD — kills mutant M10 (the dated placeholder's own folder-placeholder test deleted).
  st_probe "QA-F01 clean/date-folder-placeholder.md silent when the folder is a placeholder (M10)" \
    "$FIXTURES_DIR/clean/date-folder-placeholder.md" 0
  # GUARD — kills mutant M11 (the template record ahead of the marker deleted).
  st_probe "QA-F01 broken/template-ignore.md fires on a missing template under ignore (M11)" \
    "$FIXTURES_DIR/broken/template-ignore.md" 2 \
    "dangling path | ${BT}project-management/src/18-TESTS/MANUAL/US000-NO-SUCH-FIXTURE-ONLY-IGNORED-ABOVE.md${BT}"
  # GUARD — kills mutant M13 (the ancestor presence walk deleted).
  st_probe "QA-F01 clean/template-layer-relative.md silent on an ancestor-relative template (M13)" \
    "$FIXTURES_DIR/clean/template-layer-relative.md" 0

  # QA-F02 — the story-less dated records are instance citers by the same derived rule.
  log ""
  log "  US004 QA-F02 — a story-less dated record is an instance citer:"
  local k
  for k in FINDING REVIEW REFACTORING INCIDENT; do
    # RED — QA-F02, one per record family whose convention has a story-less form.
    st_probe "QA-F02 clean/$k-FIXTURE-ONLY-05-11-2026.md citer is exempt" \
      "$FIXTURES_DIR/clean/$k-FIXTURE-ONLY-05-11-2026.md" 0
  done
  # GUARD — QA-F02: a template, a placeholder name, an undated register and a bare year are not.
  st_citer_probe "QA-F02 INCIDENT-000-TEMPLATE.md is NOT an instance citer        " "INCIDENT-000-TEMPLATE.md" no
  st_citer_probe "QA-F02 FINDING-X-05-11-2026-TEMPLATE.md is NOT one            " "FINDING-X-05-11-2026-TEMPLATE.md" no
  st_citer_probe "QA-F02 FINDING-<DESCRIPTOR>-DD-MM-YYYY.md is NOT one          " "FINDING-<DESCRIPTOR>-DD-MM-YYYY.md" no
  st_citer_probe "QA-F02 INCIDENT-INDEX.md is NOT an instance citer             " "INCIDENT-INDEX.md" no
  st_citer_probe "QA-F02 NOTES-2026.md is NOT an instance citer                 " "NOTES-2026.md" no

  # QA-F03 — every anchor form is peeled, and the markers keep their reach.
  log ""
  log "  US004 QA-F03 — every anchor form is peeled before the existence test:"
  # RED — QA-F03: `:N,M`, `:N,M-K`, `:N,:M-K`, `#heading` and `#L12` on files that exist.
  st_probe "QA-F03 clean/anchor-forms.md silent on every anchor form of a present file" \
    "$FIXTURES_DIR/clean/anchor-forms.md" 0
  # GUARD — QA-F03: the same forms on absent files fire, quoted raw; presence beats the marker.
  st_probe "QA-F03 broken/anchor-forms.md fires on each dead anchored path (GUARD)" \
    "$FIXTURES_DIR/broken/anchor-forms.md" 3 \
    "dangling path | ${BT}project-management/src/18-TESTS/MANUAL/US000-NO-SUCH-FIXTURE-ONLY-ANCHORED-TESTING.md#how-to-use${BT}"

  # QA-F04 — a tracked symlink is read as its in-repo target, once.
  log ""
  log "  US004 QA-F04 — a symlinked citer takes its target's exemptions, and is read once:"
  st_probes=$((st_probes + 1))
  out="$(
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-qaf04.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/.claude" "$scratch/.ai" || exit 3
    printf 'Cites %sUS042.md%s and %scode/docs/NO-SUCH-FIXTURE-ONLY-LINKED.md%s.\n' \
      "$BT" "$BT" "$BT" "$BT" > "$scratch/.claude/MEMORY.md"
    ln -s ../.claude/MEMORY.md "$scratch/.ai/MEMORY.md" || exit 3
    cd "$scratch" || exit 3
    PROJECT_ROOT="$scratch"; QUIET=true
    SEEDED=".claude/MEMORY.md" scan_files $'.ai/MEMORY.md\n.claude/MEMORY.md'
    printf '%s\n%s' "$violations" "$report"
  )"
  # RED — QA-F04: the link is seeded through its target, and its one dangling path is reported once.
  case "$out" in
    1$'\n'*'dangling path'*) log "  ✓ QA-F04 .ai/MEMORY.md -> .claude/MEMORY.md: seeded, one finding, not two" ;;
    *) st_fail "QA-F04 symlinked citer: expected exactly the one dangling path, got: ${out%%$'\n'*}" ;;
  esac

  # QA-F05 / DR-001 — one human-edited source for what ships, read here and downstream alike.
  log ""
  log "  US004 QA-F05 / DR-001 — the shipping facts hold in a tree with no copier contract:"
  # RED — QA-F05: a generated project (no contract file) still knows GAPS.md is seeded, and still
  # polices research/CONTEXT.md while exempting a research note.
  st_probes=$((st_probes + 1))
  out="$(
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-qaf05.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/code/src/scripts/audits" "$scratch/research" "$scratch/code/docs" || exit 3
    cp -- "$SCRIPT_DIR/doc-references.sh" "$scratch/code/src/scripts/audits/" || exit 3
    cp -- "$SCRIPT_DIR/doc-references-shipping.txt" "$scratch/code/src/scripts/audits/" 2>/dev/null || true
    printf 'Cites %sUS042.md%s.\n' "$BT" "$BT" > "$scratch/GAPS.md"
    printf 'Cites %scode/docs/NO-SUCH-FIXTURE-ONLY-SHIPPED.md%s.\n' "$BT" "$BT" > "$scratch/research/CONTEXT.md"
    printf 'Cites %scode/docs/NO-SUCH-FIXTURE-ONLY-NOTE.md%s.\n' "$BT" "$BT" > "$scratch/research/NOTE.md"
    : > "$scratch/code/docs/CONTEXT.md"
    cd "$scratch" && git init -q . || exit 3
    bash code/src/scripts/audits/doc-references.sh --path GAPS.md 2>&1
    bash code/src/scripts/audits/doc-references.sh --path research 2>&1
    true                                     # the scans exit 1 by design; the text is the result
  )"
  if [ "${out#*"GAPS.md:1  [instance citation]"}" != "$out" ]; then
    st_fail "QA-F05 downstream: GAPS.md is not known to be seeded without the contract file"
  elif [ "${out#*"research/CONTEXT.md:1  [dangling path]"}" = "$out" ]; then
    st_fail "QA-F05 downstream: research/CONTEXT.md is exempt — the re-include is lost downstream"
  elif [ "${out#*research/NOTE.md}" != "$out" ]; then
    st_fail "QA-F05 downstream: a research note was scanned — the tree exemption is lost downstream"
  else
    log "  ✓ QA-F05 downstream: GAPS.md seeded, research/CONTEXT.md policed, the note exempt"
  fi
  # RED — QA-F05: the shipped facts are DERIVED, and a stale copy is detected rather than trusted.
  if ! st_needs_contract "QA-F05 the shipping facts are derived"; then
    :
  elif st_probes=$((st_probes + 1)); (
    tmp="$(mktemp "${TMPDIR:-/tmp}/doc-references-qaf05s.XXXXXXXX")" || exit 3
    trap 'rm -f -- "$tmp"' EXIT
    shipping_derive > "$tmp" || exit 1
    shipping_stale "$tmp" && exit 1          # an exact derivation is not stale
    sed -i.bak '$d' "$tmp" && rm -f -- "$tmp.bak"
    shipping_stale "$tmp" || exit 1          # one row short is stale
    exit 0
  ); then
    log "  ✓ QA-F05 the shipping facts are derived, and one row of drift is caught"
  else
    st_fail "QA-F05: shipping_derive / shipping_stale missing, or drift went undetected"
  fi
  # GUARD — QA-F05: the committed facts file is the derivation of the contract it ships beside.
  if ! st_needs_contract "QA-F05 the committed shipping facts match the contract"; then
    :
  elif st_probes=$((st_probes + 1)); shipping_stale "$SHIPPING_FILE" 2>/dev/null; then
    st_fail "QA-F05: $SHIPPING_FILE is stale against the contract — run --write-shipping"
  else
    log "  ✓ QA-F05 the committed shipping facts match the contract (GUARD)"
  fi

  # QA-F06 is a citation repair, not a detector change: proven by the downstream run, not here.

  # QA-F07 — the date placeholder no longer hides a concrete instance before it.
  log ""
  log "  US004 QA-F07 — a concrete instance name carrying the date placeholder still fires:"
  # RED — QA-F07.
  # CHANGED 06/11/2026 (US004 H-03): 2 -> 4, the fixture now carries the two path forms too.
  st_probe "QA-F07 broken/date-instance.md fires on US042 and ADR-US042 under a placeholder date" \
    "$FIXTURES_DIR/broken/date-instance.md" 4 "instance citation | ${BT}US042-DD-MM-YYYY${BT}"
  # GUARD — QA-F07: the zero-index and placeholder-throughout names stay patterns.
  st_probe "QA-F07 clean/date-instance.md silent on zero-index and placeholder names (GUARD)" \
    "$FIXTURES_DIR/clean/date-instance.md" 0

  # QA-F08 — a citation into an excluded tree is a finding whether or not its target exists.
  log ""
  log "  US004 QA-F08 — Direction B does not depend on the target being present:"
  # RED — QA-F08.
  st_needs_contract "QA-F08 broken/direction-b-absent.md" \
    && st_probe "QA-F08 broken/direction-b-absent.md fires on two absent excluded-tree targets" \
    "$FIXTURES_DIR/broken/direction-b-absent.md" 2 \
    "template-only citation | ${BT}research/NO-SUCH-FIXTURE-ONLY-NOTE.md${BT}"
  # GUARD — QA-F08: both markers still answer it.
  st_probe "QA-F08 clean/direction-b-absent.md silent under template-only and ignore (GUARD)" \
    "$FIXTURES_DIR/clean/direction-b-absent.md" 0

  # GAPS-REL — a file-relative Markdown link target is a citation, and so is a bare token whose
  # leading folder sits beside its citer.
  log ""
  log "  US004 GAPS-REL — file-relative link targets and bare file-relative tokens are tested:"
  # RED — GAPS-REL: three dead link targets and one bare token.
  # CHANGED 06/11/2026 (US004 H-02 / REV-03): 4 -> 9. The fixture gained a parenthesised target,
  # a link after a nested fence closes, a list continuation, and two targets written both ways.
  st_probe "GAPS-REL broken/link-relative.md fires on every dead link and the bare token, once each" \
    "$FIXTURES_DIR/broken/link-relative.md" 9 \
    "dangling link | ${BT}rel/NO-SUCH-FIXTURE-ONLY-LINK.md${BT}"
  st_has_probe "GAPS-REL the bare file-relative token is reported" \
    "$FIXTURES_DIR/broken/link-relative.md" "dangling path | ${BT}rel/NO-SUCH-FIXTURE-ONLY-BARE.md${BT}"
  # GUARD — GAPS-REL: live links, URLs, mail, fragments, patterns and the marker stay silent.
  st_probe "GAPS-REL clean/link-relative.md silent on live and non-file link targets (GUARD)" \
    "$FIXTURES_DIR/clean/link-relative.md" 0
}

# ── US004 review round (06/11/2026) — REV-01..04 and H-01..10 ───────────────────────────────
# One probe set per reproduced finding, tagged RED (fails against the detector before this round,
# and must) or GUARD. The probes needing the copier contract go through st_needs_contract().
st_review_round_probes() {
  local BT=$'\x60' out err

  log ""
  log "  US004 REV-01 / H-01 — a Markdown link answers Direction B and Check 2 as a token does:"
  if st_needs_contract "REV-01 broken/link-direction-b.md"; then
    # RED — REV-01 / H-01: present and absent excluded targets, a linked instance, one duplicate.
    st_probe "REV-01 broken/link-direction-b.md fires on five linked citations, once each" \
      "$FIXTURES_DIR/broken/link-direction-b.md" 5 \
      "template-only citation | ${BT}../../../../../../../research/AI-HOST-CONFIG-CONVENTIONS.md${BT}"
    st_has_probe "H-01 a linked story instance is an instance citation" \
      "$FIXTURES_DIR/broken/link-direction-b.md" "instance citation | ${BT}US042.md${BT}"
    st_has_probe "H-01 an absent linked note in an excluded tree is template-only" \
      "$FIXTURES_DIR/broken/link-direction-b.md" \
      "template-only citation | ${BT}../../../../../../../research/NO-SUCH-FIXTURE-ONLY-LINKED-NOTE.md${BT}"
    # GUARD — both markers answer it; the re-included pair and the regenerated lock are no finding.
    st_probe "REV-01 clean/link-direction-b.md silent under the markers and on what ships (GUARD)" \
      "$FIXTURES_DIR/clean/link-direction-b.md" 0
  fi

  log ""
  log "  US004 REV-02 — the guards a mutation run deleted without a red:"
  # GUARD — REV-02: is_excluded_by_rule() leaves a seeded path and the regenerated lock out.
  if st_needs_contract "REV-02 is_excluded_by_rule seeded and uv.lock guards"; then
    st_probes=$((st_probes + 1))
    if is_excluded_by_rule "project-management/src/01-FEATURE-MAPS/NO-SUCH-FIXTURE-ONLY-MAP.md" \
       && ! SEEDED="project-management/src/01-FEATURE-MAPS/NO-SUCH-FIXTURE-ONLY-MAP.md" \
            is_excluded_by_rule "project-management/src/01-FEATURE-MAPS/NO-SUCH-FIXTURE-ONLY-MAP.md" \
       && ! is_excluded_by_rule "uv.lock"; then
      log "  ✓ REV-02 a seeded path and uv.lock are not excluded by rule; a plain map is"
    else
      st_fail "REV-02: is_excluded_by_rule answered a seeded path, uv.lock or a plain map the wrong way"
    fi
  fi
  # RED — REV-02: the ordinary run reports a stale facts file as exactly one [shipping facts].
  st_probes=$((st_probes + 1))
  out="$(
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-rev02.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/code/src/scripts/audits" "$scratch/.copier" "$scratch/docs" || exit 3
    cp -- "$SCRIPT_DIR/doc-references.sh" "$scratch/code/src/scripts/audits/" || exit 3
    printf '# stale\n' > "$scratch/code/src/scripts/audits/doc-references-shipping.txt"
    printf '_exclude:\n  - /copier.yml\n  - /research/**\n  - "!/research/CONTEXT.md"\n' > "$scratch/copier.yml"
    printf 'code/\n' > "$scratch/.gitignore"
    printf '# docs\n' > "$scratch/docs/GUIDE.md"
    cd "$scratch" && git init -q . || exit 3
    bash code/src/scripts/audits/doc-references.sh 2>&1
    true
  )"
  case "$out" in
    *"1 citation(s) do not resolve."*"[shipping facts]"*|*"[shipping facts]"*"1 citation(s) do not resolve."*)
      log "  ✓ REV-02 a stale facts file is one [shipping facts] finding in an ordinary run" ;;
    *) st_fail "REV-02: the ordinary run did not report the stale facts file as one [shipping facts]" ;;
  esac

  # GUARD — REV-02: a seeded link target is no dead link; unseeded, the same file reports it.
  local st_saved_seeded_rev="$SEEDED"
  SEEDED="$SEEDED
code/docs/NO-SUCH-FIXTURE-ONLY-SEEDED-LINK.md"
  st_probe "REV-02 clean/link-seeded.md silent on a seeded link target (GUARD)" \
    "$FIXTURES_DIR/clean/link-seeded.md" 0
  SEEDED="$st_saved_seeded_rev"
  st_probe "REV-02 clean/link-seeded.md unseeded reports the dead link (GUARD)" \
    "$FIXTURES_DIR/clean/link-seeded.md" 1 "dangling link"
  # GUARD — H-02: a dead link in an indented code block is an example.
  st_probe "H-02 clean/link-indented.md silent on an indented code block (GUARD)" \
    "$FIXTURES_DIR/clean/link-indented.md" 0

  log ""
  log "  US004 H-03 / H-04 — the dated forms:"
  # RED — H-03: the path form of a dated instance is read as the bare form is.
  st_probe "H-03 broken/date-instance.md fires on the bare and the path form" \
    "$FIXTURES_DIR/broken/date-instance.md" 4 \
    "instance citation | ${BT}project-management/src/15-DECISIONS/ADR-US042-FIXTURE-ONLY-DD-MM-YYYY.md${BT}"
  # RED — H-04: a dated guide outside the four record families keeps Check 2.
  st_probe "H-04 broken/GUIDE-FIXTURE-ONLY-05-11-2026.md still fires on its story" \
    "$FIXTURES_DIR/broken/GUIDE-FIXTURE-ONLY-05-11-2026.md" 1 "instance citation | ${BT}US042${BT}"
  st_citer_probe "H-04 MIGRATION-GUIDE-01-01-2026.md is NOT an instance citer      " \
    "MIGRATION-GUIDE-01-01-2026.md" no

  log ""
  log "  US004 H-05 — a root file copier excludes, slashless or ./, present or absent:"
  if st_needs_contract "H-05 broken/direction-b-root.md"; then
    # RED — H-05: the contract's dot-slash spelling (present) fires. With no rule naming the root note, its `./`
    # spelling is an ordinary dead path and its slashless one no path at all.
    st_probe "H-05 broken/direction-b-root.md fires on ./copier.yml with no root rule added" \
      "$FIXTURES_DIR/broken/direction-b-root.md" 2 "template-only citation | ${BT}./copier.yml${BT}"
    # RED — H-05: once a rule names the absent root note, both its spellings are template-only.
    EXCL_ANCHORED+=("NO-SUCH-FIXTURE-ONLY-ROOT-NOTE.md")
    EXCL_ROOT_LIT["NO-SUCH-FIXTURE-ONLY-ROOT-NOTE.md"]=1
    st_probe "H-05 broken/direction-b-root.md fires on both spellings of an absent excluded root file" \
      "$FIXTURES_DIR/broken/direction-b-root.md" 3 \
      "template-only citation | ${BT}NO-SUCH-FIXTURE-ONLY-ROOT-NOTE.md${BT}"
    unset 'EXCL_ANCHORED[${#EXCL_ANCHORED[@]}-1]'
    unset 'EXCL_ROOT_LIT[NO-SUCH-FIXTURE-ONLY-ROOT-NOTE.md]'
  fi

  log ""
  log "  US004 H-06 — the _exclude parse, and which tree is the template:"
  # RED — H-06(a): a single-quoted negation is read, and an unclassifiable entry is named.
  if ! st_needs_contract "H-06(a) the _exclude parse"; then
    :
  elif st_probes=$((st_probes + 1)); (
    tmp="$(mktemp "${TMPDIR:-/tmp}/doc-references-h06.XXXXXXXX")" || exit 3
    trap 'rm -f -- "$tmp"' EXIT
    SHIPPING_CONTRACT="$tmp"
    printf "_exclude:\n  - /research/**\n  - '!/research/CLAUDE.md'\n" > "$tmp"
    [ "$(exclude_entries | grep -c '^N research/CLAUDE.md$')" = 1 ] || exit 1
    [ -z "$(exclude_fault)" ] || exit 1
    printf "_exclude:\n  - /research/**\n  - '!research/CLAUDE.md'\n" > "$tmp"
    [ -n "$(exclude_fault)" ] || exit 1
    printf "_exclude: [/research]\n" > "$tmp"
    [ -n "$(exclude_fault)" ] || exit 1
    exit 0
  ); then
    log "  ✓ H-06 a single-quoted negation is parsed, and an unclassifiable entry is named"
  else
    st_fail "H-06: a single-quoted negation was dropped, or an unclassifiable entry went unnamed"
  fi
  # RED — H-06(b): a generated project's own copier.yml is not the template's contract, and the
  # remedy text there never points at --write-shipping (H-10).
  st_probes=$((st_probes + 1))
  out="$(
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-h06b.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/code/src/scripts/audits" || exit 3
    cp -- "$SCRIPT_DIR/doc-references.sh" "$scratch/code/src/scripts/audits/" || exit 3
    cp -- "$SCRIPT_DIR/doc-references-shipping.txt" "$scratch/code/src/scripts/audits/" 2>/dev/null || true
    printf '_exclude:\n  - /node_modules\n' > "$scratch/copier.yml"
    printf 'Cites %sUS042.md%s and %sdocs/NO-SUCH-FIXTURE-ONLY.md%s.\n' "$BT" "$BT" "$BT" "$BT" > "$scratch/GAPS.md"
    printf 'Cites %sUS042%s.\n' "$BT" "$BT" > "$scratch/GUIDE.md"
    cd "$scratch" && git init -q . || exit 3
    bash code/src/scripts/audits/doc-references.sh --path GAPS.md 2>&1
    bash code/src/scripts/audits/doc-references.sh --path GUIDE.md 2>&1
    true
  )"
  if [ "${out#*"GAPS.md:1  [instance citation]"}" != "$out" ]; then
    st_fail "H-06(b): a downstream copier.yml displaced the shipped facts -- GAPS.md lost its seed"
  elif [ "${out#*"read from the facts file"}" = "$out" ]; then
    st_fail "H-06(b): the facts file was not the source in a tree with no .copier/"
  elif [ "${out#*"--write-shipping"}" != "$out" ]; then
    st_fail "H-10: a downstream run printed the --write-shipping remedy"
  elif [ "${out#*"GUIDE.md:1  [instance citation]"}" = "$out" ] || [ "${out#*"Rule: a shipped file"}" = "$out" ]; then
    st_fail "H-10: the instance citation, or its own remedy, was not printed"
  else
    log "  ✓ H-06(b) / H-10 a project's own copier.yml is not the contract, and only its remedies print"
  fi

  log ""
  log "  US004 H-07 / H-08 — a hyphen-led token, and the remaining anchor forms:"
  # RED — H-07: a citation opening with `-` reaches grep as a pattern, never as an option.
  st_probes=$((st_probes + 1))
  err="$( { scan_files "$FIXTURES_DIR/clean/css-token.md" >/dev/null; } 2>&1 )"
  if [ -n "$err" ]; then
    st_fail "H-07 clean/css-token.md wrote to stderr: ${err%%$'\n'*}"
  else
    log "  ✓ H-07 clean/css-token.md writes nothing to stderr"
  fi
  st_probe "H-07 clean/css-token.md is silent (GUARD)" "$FIXTURES_DIR/clean/css-token.md" 0
  # RED — H-08 rides on clean/anchor-forms.md (QA-F03 above): `:L12`, a trailing comma, `?query`.
}

# ── US004 F-021 (06/11/2026) — `NN` is a placeholder only as a run of its own ─────────────────
# Sam's ruling of 06/11/2026: fixed in US004. is_placeholder() read any token holding the letters
# `NN` as a placeholder, so every `PLANNING/` path and `MAP-SCALE-PLANNING.md` went untested.
# RED fails against d035f04's detector, and must; GUARD pins the real placeholder spellings.
st_f021_probes() {
  local BT=$'\x60'
  log ""
  log "  US004 F-021 — the letters NN inside a word are not a placeholder:"
  # RED — F-021: a dead PLANNING/ path and an absent copy of the seeded map's name both fire.
  # GUARD (its third finding) — a bare map name nothing seeds is still an instance citation.
  # RED by mutation (round 3, A-1 / A-2 / QA-A3): one dead path per guard of the expression, so
  # dropping the left guard, the right guard or the two-N minimum each turns this probe red.
  st_probe "F-021 broken/nn-letters.md fires on a dead PLANNING/ path, an absent MAP-SCALE-PLANNING.md, an unseeded map and four one-sided runs" \
    "$FIXTURES_DIR/broken/nn-letters.md" 7 \
    "dangling path | ${BT}project-management/src/11-QA/PLANNING/NO-SUCH-FIXTURE-ONLY.md${BT}"
  st_has_probe "F-021 the absent MAP-SCALE-PLANNING.md is reported" \
    "$FIXTURES_DIR/broken/nn-letters.md" "dangling path | ${BT}code/docs/MAP-SCALE-PLANNING.md${BT}"
  local tok
  for tok in code/docs/PLANN-NO-SUCH-FIXTURE-ONLY.md code/docs/no-such-NNA-FIXTURE-ONLY.md \
             code/docs/N-NO-SUCH-FIXTURE-ONLY.md code/docs/USNNN-NO-SUCH-FIXTURE-ONLY.md; do
    st_has_probe "F-021 ${BT}$tok${BT} is letters, not a placeholder, and is reported" \
      "$FIXTURES_DIR/broken/nn-letters.md" "dangling path | ${BT}$tok${BT}"
  done
  # RED — QA-A1 (round 3): the class used to be [:upper:], so a run against a non-ASCII capital
  # was a placeholder under C and a citation under a UTF-8 locale. Asked under three locales,
  # the answer must be the same, and must be "placeholder" -- a capital is an ASCII capital.
  st_probes=$((st_probes + 1))
  local loc verdicts="" want_tok="code/docs/ÉNNÉ-NO-SUCH-FIXTURE-ONLY.md"
  for loc in C C.UTF-8 "${LC_ALL:-${LC_CTYPE:-${LANG:-C}}}"; do
    if ( LC_ALL="$loc"; is_placeholder "$want_tok" ) 2>/dev/null; then verdicts+="$loc=yes "
    else verdicts+="$loc=no "; fi
  done
  if [[ "$verdicts" == *"=no"* ]]; then
    st_fail "QA-A1 is_placeholder ${BT}$want_tok${BT} depends on the locale: $verdicts"
  else
    log "  ✓ QA-A1 is_placeholder reads a run against a non-ASCII letter the same in every locale"
  fi
  # GUARD — F-021: NN-FOO/, US0NN, NN-SPRINT-PLAN-NN.md, usNNN stay patterns; live paths resolve.
  # RED by mutation (round 3, A-2): a run at the token's very start and very end pins `^` and `$`.
  # RED (its last line) — the seeded map named bare was a Check 2 finding once F-021 unmasked it:
  # the clause tested the seeded set for the bare token, never for the feature-maps path it names.
  st_probe "F-021 clean/nn-letters.md silent on real NN placeholders, live PLANNING paths and the seeded map" \
    "$FIXTURES_DIR/clean/nn-letters.md" 0
}

# ── US004 F-051 (09/11/2026) — a citation into a DECLINED surface is not a dangling path ──────
# Sam's ruling: fixed in US004. A generated project with default answers reported 119 findings,
# every one a shipped file citing an optional-surface file copier left out because its flag was
# declined. The templated `_exclude` entries are now parsed into `gated` rows of the facts file,
# and downstream the root .copier-answers.yml says which surfaces were declined. RED fails against
# 661613e's detector, and must; GUARD pins the direction the repair could over-reach in. Every
# probe here builds its own rows, answers and contract, so all but one run downstream too.
ST_GATE_FX="$FIXTURES_DIR/broken/gated-surface.md"
ST_GATE_ROWS="gated INCLUDE_FIXTURE_FILE code/docs/NO-SUCH-FIXTURE-ONLY-GATED.md
gated INCLUDE_FIXTURE_DIR code/docs/no-such-fixture-only-gated-dir
gated INCLUDE_FIXTURE_GLOB how-to/src/no-such-fixture-only-gated-glob/**
gated INCLUDE_FIXTURE_LINK code/docs/no-such-fixture-only-gated-link
gated INCLUDE_FIXTURE_REL $FIXTURES_DIR/broken/rel/NO-SUCH-FIXTURE-ONLY-GATED-BARE.md
absent INCLUDE_FIXTURE_FILE declined
absent INCLUDE_FIXTURE_DIR declined
absent INCLUDE_FIXTURE_GLOB declined
absent INCLUDE_FIXTURE_LINK declined
absent INCLUDE_FIXTURE_REL declined"
ST_TWICE_ROWS="gated INCLUDE_FIXTURE_DIR code/docs/no-such-fixture-only-gated-dir
absent INCLUDE_FIXTURE_DIR declined"
st_gate_answers() { # KEY=VALUE... -> an answers file body; a key not named is absent
  local kv
  printf '_src_path: fixture\n_commit: fixture\n'
  for kv in "$@"; do printf 'INCLUDE_FIXTURE_%s: %s\n' "${kv%%=*}" "${kv#*=}"; done
}
# Scans the fixture under the given rows and answers in a subshell, so no global leaks into the
# probes after it. Prints the finding count, the declined-surface count, then the report.
st_gate_scan() { # rows answers(MISSING = no file) in-template(true|false)
  (
    QUIET=true
    tmp="$(mktemp "${TMPDIR:-/tmp}/doc-references-f051.XXXXXXXX")" || exit 3
    trap 'rm -f -- "$tmp"' EXIT
    if [ "$2" = MISSING ]; then rm -f -- "$tmp"; else printf '%s\n' "$2" > "$tmp"; fi
    ANSWERS_FILE="$tmp"
    parse_gated_facts "$1" 2>/dev/null || true
    load_surface_answers "$3" 2>/dev/null || true
    scan_files "$ST_GATE_FX"
    printf '%s\n%s\n%s' "$violations" "${declined_total:-unset}" "$report"
  )
}
st_gate_probe() { # label rows answers in-template want-findings want-declined unwanted-substring
  local out v d rep
  st_probes=$((st_probes + 1))
  out="$(st_gate_scan "$2" "$3" "$4")"
  v="${out%%$'\n'*}"; rep="${out#*$'\n'}"; d="${rep%%$'\n'*}"; rep="${rep#*$'\n'}"
  if [ "$v" != "$5" ]; then st_fail "$1: expected $5 finding(s), got $v"; return; fi
  if [ "$6" != "-" ] && [ "$d" != "$6" ]; then st_fail "$1: expected $6 declined-surface pass(es), got $d"; return; fi
  if [ -n "${7:-}" ] && [ "${rep#*"$7"}" != "$rep" ]; then st_fail "$1: a finding names \`$7\`"; return; fi
  log "  ✓ $1"
}

st_f051_probes() {
  local BT=$'\x60' all_false all_true out rc
  all_false="$(st_gate_answers FILE=false DIR=false GLOB=false LINK=false REL=false)"
  all_true="$(st_gate_answers FILE=true DIR=true GLOB=true LINK=true REL=true)"
  log ""
  log "  US004 F-051 — a citation into a declined surface's gated path is not a dangling path:"
  # RED — every citation sits under a declined gate: none is a finding, and all five are counted.
  st_gate_probe "F-051 broken/gated-surface.md silent with every surface declined, five passes counted" \
    "$ST_GATE_ROWS" "$all_false" false 0 5
  # GUARD — a TAKEN surface whose file is absent is still a finding, every one of the five.
  st_gate_probe "F-051 broken/gated-surface.md fires five times with every surface taken (GUARD)" \
    "$ST_GATE_ROWS" "$all_true" false 5 0
  # RED — each form on its own: only the one declined gate is passed, the other four still fire.
  st_gate_probe "F-051 a file nested under a declined DIRECTORY entry passes" "$ST_GATE_ROWS" \
    "$(st_gate_answers FILE=true DIR=false GLOB=true LINK=true REL=true)" false 4 1 \
    "${BT}code/docs/no-such-fixture-only-gated-dir/deep/NESTED.md${BT}"
  st_gate_probe "F-051 a file nested under a declined /** GLOB entry passes" "$ST_GATE_ROWS" \
    "$(st_gate_answers FILE=true DIR=true GLOB=false LINK=true REL=true)" false 4 1 \
    "${BT}how-to/src/no-such-fixture-only-gated-glob/a/b/GLOB.md${BT}"
  st_gate_probe "F-051 a file-relative MARKDOWN LINK into a declined gate passes" "$ST_GATE_ROWS" \
    "$(st_gate_answers FILE=true DIR=true GLOB=true LINK=false REL=true)" false 4 1 \
    "no-such-fixture-only-gated-link/LINK.md${BT}"
  st_gate_probe "F-051 a bare FILE-RELATIVE token into a declined gate passes" "$ST_GATE_ROWS" \
    "$(st_gate_answers FILE=true DIR=true GLOB=true LINK=true REL=false)" false 4 1 \
    "${BT}rel/NO-SUCH-FIXTURE-ONLY-GATED-BARE.md${BT}"
  # RED — an ABSENT key is declined where the contract's default is false: copier omits a question
  # its `when` skipped (INCLUDE_DESKTOP, when INCLUDE_RUST is false).
  st_gate_probe "F-051 an absent key whose default is false counts as declined" "$ST_GATE_ROWS" \
    "$(st_gate_answers DIR=true GLOB=true LINK=true REL=true)" false 4 1 \
    "${BT}code/docs/NO-SUCH-FIXTURE-ONLY-GATED.md${BT}"
  # GUARD — and taken where the default is true (INCLUDE_CLICKUP): absence never exempts by itself.
  st_gate_probe "F-051 an absent key whose default is true counts as taken (GUARD)" \
    "${ST_GATE_ROWS/absent INCLUDE_FIXTURE_FILE declined/absent INCLUDE_FIXTURE_FILE taken}" \
    "$(st_gate_answers DIR=true GLOB=true LINK=true REL=true)" false 5 0
  # GUARD — fail closed: no answers file, or one that cannot be read, exempts nothing.
  st_gate_probe "F-051 a missing .copier-answers.yml exempts nothing (GUARD)" \
    "$ST_GATE_ROWS" MISSING false 5 0
  st_gate_probe "F-051 a non-boolean surface answer exempts nothing (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers FILE=maybe DIR=false GLOB=false LINK=false REL=false)" false 5 0
  st_gate_probe "F-051 an answers file copier did not write exempts nothing (GUARD)" \
    "$ST_GATE_ROWS" "INCLUDE_FIXTURE_FILE: false" false 5 0
  # GUARD — the template holds every gated path, so it never reads answers to exempt one.
  st_gate_probe "F-051 the template applies no surface gating (GUARD)" \
    "$ST_GATE_ROWS" "$all_false" true 5 0

  # RED (round 2, C-04) — a link and a token naming one target on one line are ONE citation: one
  # pass when declined, as the taken run reports one finding. Counted per check, it was two.
  ST_GATE_FX="$FIXTURES_DIR/broken/gated-twice.md" st_gate_probe \
    "F-051 a link and a token to one declined target on one line count as one pass" \
    "$ST_TWICE_ROWS" "$(st_gate_answers DIR=false)" false 0 1
  ST_GATE_FX="$FIXTURES_DIR/broken/gated-twice.md" st_gate_probe \
    "F-051 the same line with its surface taken is one finding (GUARD)" \
    "$ST_TWICE_ROWS" "$(st_gate_answers DIR=true)" false 1 0
  # RED (round 2, Q-02) — a gated key the line reader cannot place exactly fails closed: an
  # indented key (invalid YAML, and read as absent it was a false-default decline), a duplicated
  # key (a YAML loader keeps the last, grep took the first), a space before the colon, a quoted key.
  st_gate_probe "F-051 an indented gated key fails closed, never read as absent (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers DIR=false GLOB=false LINK=false REL=false)
  INCLUDE_FIXTURE_FILE: true" false 5 0
  st_gate_probe "F-051 a duplicated gated key fails closed, never first-wins (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers FILE=false DIR=false GLOB=false LINK=false REL=false FILE=true)" \
    false 5 0
  st_gate_probe "F-051 a gated key spaced before its colon fails closed (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers DIR=false GLOB=false LINK=false REL=false)
INCLUDE_FIXTURE_FILE : true" false 5 0
  st_gate_probe "F-051 a quoted gated key fails closed (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers DIR=false GLOB=false LINK=false REL=false)
\"INCLUDE_FIXTURE_FILE\": true" false 5 0
  # GUARD (round 2, Q-05 M8) — only a YAML boolean declines: \`no\` and a quoted "false" (a string,
  # truthy to copier's Jinja) are not booleans here, and fail closed.
  st_gate_probe "F-051 an answer of no is not a boolean, and fails closed (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers FILE=no DIR=false GLOB=false LINK=false REL=false)" false 5 0
  st_gate_probe "F-051 a quoted \"false\" answer is not a boolean, and fails closed (GUARD)" \
    "$ST_GATE_ROWS" "$(st_gate_answers FILE='"false"' DIR=false GLOB=false LINK=false REL=false)" false 5 0

  # GUARD (round 2, Q-05 M7) — a gating question with no default: its block ends at the next
  # top-level key, so it never borrows the NEXT question's default. Absent, it is taken.
  st_probes=$((st_probes + 1))
  if (
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-f051m.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    cd "$scratch" && mkdir .copier || exit 3
    SHIPPING_CONTRACT="copier.yml"
    BC=":"">"
    {
      printf '_exclude:\n'
      printf '  - "%s if not INCLUDE_FX_C %s/code/docs/fx-c%s endif %s"\n' "$BLK_OPEN" "$BC" "$BLK_OPEN" "$BC"
      printf '  - "%s if not INCLUDE_FX_D %s/code/docs/fx-d%s endif %s"\n' "$BLK_OPEN" "$BC" "$BLK_OPEN" "$BC"
      printf '\nINCLUDE_FX_C:\n  type: bool\n'
      printf '\nINCLUDE_FX_D:\n  type: bool\n  default: false\n'
    } > copier.yml
    d="$(shipping_derive)" || exit 1
    printf '%s\n' "$d" | grep -qxF 'absent INCLUDE_FX_C taken' || exit 1
    printf '%s\n' "$d" | grep -qxF 'absent INCLUDE_FX_D declined' || exit 1
    exit 0
  ); then
    log "  ✓ F-051 a gating question with no default is taken when absent, never the next one's (GUARD)"
  else
    st_fail "F-051: a gating question with no default borrowed another question's default"
  fi

  # RED — the gated rows are DERIVED from the templated entries, with the absent-key verdict read
  # from each question's default, and one row of drift is caught. A scratch contract, so this runs
  # downstream as well.
  st_probes=$((st_probes + 1))
  if (
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-f051d.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    cd "$scratch" && mkdir .copier || exit 3
    SHIPPING_CONTRACT="copier.yml"
    BC=":"">"
    {
      printf '_exclude:\n  - /research/**\n'
      printf '  - "%s if not INCLUDE_FX_A %s/code/docs/fx-a%s endif %s"\n' "$BLK_OPEN" "$BC" "$BLK_OPEN" "$BC"
      printf "  - '%s if not INCLUDE_FX_B %s/how-to/src/fx-b/**%s endif %s'\n" "$BLK_OPEN" "$BC" "$BLK_OPEN" "$BC"
      printf '\nINCLUDE_FX_A:\n  type: bool\n  default: false\n'
      printf '\nINCLUDE_FX_B:\n  type: bool\n  default: true\n'
    } > copier.yml
    d="$(shipping_derive)" || exit 1
    for want in "gated INCLUDE_FX_A code/docs/fx-a" "gated INCLUDE_FX_B how-to/src/fx-b/**" \
                "absent INCLUDE_FX_A declined" "absent INCLUDE_FX_B taken"; do
      printf '%s\n' "$d" | grep -qxF -- "$want" || exit 1
    done
    printf '%s\n' "$d" | grep -vxF 'gated INCLUDE_FX_A code/docs/fx-a' > facts.txt
    shipping_stale facts.txt || exit 1
    exit 0
  ); then
    log "  ✓ F-051 gated rows and absent-key verdicts are derived from the contract, and drift is caught"
  else
    st_fail "F-051: the gated rows or absent-key verdicts were not derived, or a dropped row went unnoticed"
  fi

  # RED — a templated entry of any other shape is refused, never silently dropped.
  st_probes=$((st_probes + 1))
  if (
    tmp="$(mktemp "${TMPDIR:-/tmp}/doc-references-f051f.XXXXXXXX")" || exit 3
    trap 'rm -f -- "$tmp"' EXIT
    cd "$(dirname "$tmp")" || exit 3
    # shellcheck disable=SC2030  # deliberately local to this probe's subshell
    SHIPPING_CONTRACT="$tmp"
    has_contract() { return 0; }
    BC=":"">"
    printf '_exclude:\n  - "%s if not INCLUDE_FX %s/code/docs/fx%s endif %s"\n' "$BLK_OPEN" "$BC" "$BLK_OPEN" "$BC" > "$tmp"
    [ -z "$(exclude_fault)" ] || exit 1
    for bad in "$BLK_OPEN if INCLUDE_FX $BC/code/docs/fx$BLK_OPEN endif $BC" \
               "$BLK_OPEN if not INCLUDE_FX or INCLUDE_FY $BC/code/docs/fx$BLK_OPEN endif $BC" \
               "$BLK_OPEN if not INCLUDE_FX $BC""code/docs/fx$BLK_OPEN endif $BC" \
               "$BLK_OPEN if not INCLUDE_FX $BC!/code/docs/fx$BLK_OPEN endif $BC" \
               "$BLK_OPEN if not INCLUDE_FX $BC/code/docs/fx"; do
      printf '_exclude:\n  - "%s"\n' "$bad" > "$tmp"
      [ -n "$(exclude_fault)" ] || exit 1
    done
    exit 0
  ); then
    log "  ✓ F-051 a templated _exclude entry the parse does not understand is named, not dropped"
  else
    st_fail "F-051: an unparseable templated _exclude entry was accepted"
  fi

  # RED — the committed facts file carries one gated row per templated entry of the real contract.
  if st_needs_contract "F-051 the committed facts file holds every gated row"; then
    st_probes=$((st_probes + 1))
    local want_g have_g
    # shellcheck disable=SC2031  # the subshells above set their own copy; this reads the real one
    # Counted by the parse the gate runs, never a second grep of one quote style (round 2, C-05).
    want_g="$(exclude_entries | awk '$1=="G"' | wc -l | tr -d ' ')"
    have_g="$(grep -c '^gated ' "$SHIPPING_FILE" || true)"
    if [ "${want_g:-0}" -gt 0 ] && [ "$want_g" = "$have_g" ]; then
      log "  ✓ F-051 the committed facts file holds all $have_g gated row(s)"
    else
      st_fail "F-051: $SHIPPING_FILE holds ${have_g:-0} gated row(s), the contract ${want_g:-0}"
    fi
  fi

  # RED — end to end in a generated-project shape (no .copier/): a declined citation passes and the
  # run says how many it passed, unjudged; with the answers file gone it fails closed and says so.
  st_probes=$((st_probes + 1))
  out="$(
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-f051e.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/code/src/scripts/audits" "$scratch/code/docs" || exit 3
    cp -- "$SCRIPT_DIR/doc-references.sh" "$scratch/code/src/scripts/audits/" || exit 3
    printf 'gated INCLUDE_FX code/docs/fx-gated\nabsent INCLUDE_FX declined\n' \
      > "$scratch/code/src/scripts/audits/doc-references-shipping.txt"
    printf '_src_path: fixture\nINCLUDE_FX: false\n' > "$scratch/.copier-answers.yml"
    printf 'Cites %scode/docs/fx-gated/deep/X.md%s.\n' "$BT" "$BT" > "$scratch/code/docs/GUIDE.md"
    cd "$scratch" && git init -q . || exit 3
    bash code/src/scripts/audits/doc-references.sh --path code/docs 2>&1; printf 'RC=%s\n' "$?"
    rm -f .copier-answers.yml
    bash code/src/scripts/audits/doc-references.sh --path code/docs 2>&1; printf 'RC=%s\n' "$?"
    true
  )"
  rc="${out#*RC=}"; rc="${rc%%$'\n'*}"
  if [ "$rc" != 0 ]; then
    st_fail "F-051 end to end: a declined-surface citation failed the downstream run (exit $rc)"
  elif [ "${out#*"1 citation(s) into declined-surface paths"}" = "$out" ] || [ "${out#*"INCLUDE_FX=1"}" = "$out" ]; then
    st_fail "F-051 end to end: the run did not name the declined-surface passes per flag"
  elif [ "${out##*RC=}" != 1 ] || [ "${out#*"surface answers NOT read (.copier-answers.yml is missing)"}" = "$out" ]; then
    st_fail "F-051 end to end: a missing answers file did not fail closed, or did not say so"
  else
    log "  ✓ F-051 end to end: declined passes are counted per flag, and a missing answers file fails closed"
  fi

  # RED (round 2, C-01 / Q-01) — a run that passed citations unjudged never prints the bare
  # "every citation resolves": the verdict names the unjudged count, on the terminal and in the
  # --output report alike (code/docs/GATE-REPORTING.md Section 1).
  st_probes=$((st_probes + 1))
  out="$(
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/doc-references-f051v.XXXXXXXX")" || exit 3
    trap 'rm -rf -- "$scratch"' EXIT
    mkdir -p "$scratch/code/src/scripts/audits" "$scratch/code/docs" || exit 3
    cp -- "$SCRIPT_DIR/doc-references.sh" "$scratch/code/src/scripts/audits/" || exit 3
    printf 'gated INCLUDE_FX code/docs/fx-gated\nabsent INCLUDE_FX declined\n' \
      > "$scratch/code/src/scripts/audits/doc-references-shipping.txt"
    printf '_src_path: fixture\nINCLUDE_FX: false\n' > "$scratch/.copier-answers.yml"
    printf 'Cites %scode/docs/fx-gated/deep/X.md%s.\n' "$BT" "$BT" > "$scratch/code/docs/GUIDE.md"
    cd "$scratch" && git init -q . || exit 3
    bash code/src/scripts/audits/doc-references.sh --path code/docs --output md \
      --output-file "$scratch/report.md" 2>&1; printf 'RC=%s\n' "$?"
    printf 'REPORT>>\n'; cat -- "$scratch/report.md" 2>/dev/null
    true
  )"
  rc="${out#*RC=}"; rc="${rc%%$'\n'*}"
  if [ "$rc" != 0 ]; then
    st_fail "F-051 verdict: the declined-surface run failed (exit $rc)"
  elif [ "${out#*"every citation resolves"}" != "$out" ]; then
    st_fail "F-051 verdict: a run that passed citations unjudged still says every citation resolves"
  elif [[ "${out%%REPORT>>*}" != *"1 passed unjudged into declined-surface paths"* ]] \
       || [[ "${out#*REPORT>>}" != *"Verdict: Clean"*"1 passed unjudged into declined-surface paths"* ]]; then
    st_fail "F-051 verdict: the qualified verdict is missing from the terminal or the --output report"
  else
    log "  ✓ F-051 a run that passed citations unjudged names them in its verdict, terminal and report"
  fi
}

# A probe that reads the copier contract cannot run in a generated project, which receives none
# (US004 REV-04 / F-012). It is named and counted as not run, and a self-test that skipped any
# exits 2 rather than reporting a proof it did not make (code/docs/GATE-REPORTING.md).
st_skipped=0
st_needs_contract() { # label
  has_contract && return 0
  st_skipped=$((st_skipped + 1))
  log "  - not run: $1 (needs the copier contract, absent here)"
  return 1
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
  st_needs_contract "broken/direction-b.md" \
    && st_probe "broken/direction-b.md  fires on an undeclared excluded path, bare and anchored" \
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
  st_needs_contract "clean/direction-b.md" \
    && st_probe "clean/direction-b.md   silent on both markers, anchored or bare, and the four classes" \
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
  if st_needs_contract "the derived set, four rows"; then
    st_set_probe "anchored entry is in the set          " "copier.yml"                          yes
    st_set_probe "surface-gated entry is NOT            " "code/docs/RUST.md"                    no
    st_set_probe "excluded-and-seeded entry is NOT      " "CHANGELOG.md"                         no
    st_set_probe "re-included pair file is NOT          " "project-management/src/CONTEXT.md"    no
  fi

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
  # The derived set needs the copier contract (US004 REV-04): downstream this block is not run.
  if st_needs_contract "P2 / P9-F9 the untracked-population probes"; then
    # P9-F9 / QA-US004-11 (phase 9, 05/11/2026). A SIGKILL or a crashed shell runs no trap, so a
    # killed earlier run leaves its probe file behind; P2 sweeps the stale ones before it starts.
    # One is planted here exactly as a killed run leaves it, under the same name pattern, and
    # asserted gone once P2 has run. The plant carries its own trap until that assertion.
    # Global, not local (US004 REV-04): the EXIT trap below outlives this function when the run
    # ends early, and under `set -u` a local gone out of scope aborted it on an unbound variable.
    st_p9_stale="$(mktemp "research/us004-p2-probe.XXXXXXXX")" \
      || die "P9-F9 probe: could not plant a stale probe file under research/"
    trap 'rm -f -- "${st_p9_stale:-}"' EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
    # P2 runs in a subshell that creates the probe, holds the trap and exits, and it hands the
    # probe's name back on its first line. CHANGED 05/11/2026 (P9-QA-US004-11): the GUARD below
    # used to follow an unconditional `rm -f` in this same shell, so it could never fail. It now
    # asserts from the parent, after the shell holding the trap has gone, that the trap removed it.
    st_probes=$((st_probes + 1))
    local st_p2_out st_p2_rc st_p2_probe
    st_p2_rc=0
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
    )" || st_p2_rc=$?
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
  fi

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
  if ! st_needs_contract "R4 unseeded broken/seeded-citer.md"; then
    :
  elif st_probes=$((st_probes + 1)); scan_files "$st_r4"; [ "$violations" -ne 3 ]; then
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

  # ── US004 QA round — failing proofs for the QA and review items of 06/11/2026 ─
  st_qa_round_probes

  # ── US004 review round — failing proofs for REV-01..04 and H-01..10 of 06/11/2026 ─
  st_review_round_probes

  # ── US004 F-021 — the NN placeholder arm reads a run, never letters in a word ─
  st_f021_probes

  # ── US004 F-051 — a declined surface's gated paths are passed, counted, and fail closed ─
  st_f051_probes

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
  if [ "$st_fails" -eq 0 ] && [ "$st_skipped" -gt 0 ]; then
    bold "? Self-test NOT RUN in full — $st_skipped probe set(s) need the copier contract, absent here."
    log "  The $st_probes that ran passed. A generated project receives no copier.yml, so the"
    log "  Direction B set and the contract parse are proven in the template, never here."
    return 2
  fi
  if [ "$st_fails" -eq 0 ]; then
    bold "✓ Self-test passed — $st_probes probes over the five clauses added 20/08–08/09/2026"
    log "  and the US004 repairs of 05/11/2026 (exemption, population, citer, artefact tree)."
    log "  Not covered: Checks 1 and 2 as they shipped before 20/08, and whether a surface-gated"
    log "  citation carries its prose rust-only / mobile-only flag, which is a convention rather"
    log "  than a clause (code/docs/FORWARD-VOICE.md Section 5). Its declined-surface pass is"
    log "  covered (US004 F-051)."
    return 0
  fi
  bold "✗ Self-test FAILED — the detector no longer separates the fixtures."
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

# The one writer of the shipped facts file (US004 QA-F05). It needs the contract to derive from,
# so a generated project -- which reads the file and has nothing to regenerate it from -- is
# refused at exit 2 rather than handed an empty file.
if $WRITE_SHIPPING; then
  has_contract || die "--write-shipping needs the copier contract, absent here: the facts file is regenerated in the template, never downstream"
  shipping_derive > "$SHIPPING_FILE"
  log "Wrote $SHIPPING_FILE from the copier contract."
  exit 0
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

# The shipped facts must be the contract's derivation (US004 QA-F05). Checked where the contract
# exists and the scope covers the file -- unscoped, or a --path that contains it -- and reported
# as a finding, because a stale copy is what every generated project would then be cut from.
if has_contract \
   && { [ -z "$TARGET_PATH" ] || [[ "$SHIPPING_FILE" == "$TARGET_PATH" || "$SHIPPING_FILE" == "$TARGET_PATH"/* ]]; } \
   && shipping_stale "$SHIPPING_FILE"; then
  record "$SHIPPING_FILE" 1 "shipping facts" "stale: run doc-references.sh --write-shipping"
fi

# ── Report ───────────────────────────────────────────────────────────────────
# The count comes before the verdict, because it is what the verdict is a verdict OVER. An
# exempt file is named separately from an absent one: the first was excluded by a rule this
# script states, the second was never there, and only the second makes a clean run empty.
log "  read    $scanned_files file(s); $exempt_files exempt by rule"
log "  checked $checked_tokens backticked token(s) — $path_tests of them tested as repo paths"
log "  tested  $link_tests Markdown link target(s) against their citing file"
# Check 3's denominator, and it is a different KIND of number from the three above: those
# count what this run read, this counts what it was reading AGAINST. A zero here means the
# `_exclude` parse found nothing and every Direction B citation passed unexamined — which
# would otherwise print as "Clean" (code/docs/GATE-REPORTING.md Section 1).
log "  matched against $template_only_paths path(s) copier excludes unconditionally"
log "  shipping facts read from the $SHIPPING_SOURCE"
# What this run passed WITHOUT judging (US004 F-051): a green run here is "every citation resolves,
# or names a file its surface's answer left out" -- never "every cited file exists".
gate_summary=""
case "$GATE_STATE" in
  template)    gate_line="surface gating not applied: the template holds all ${#GATED_PATH[@]} gated path(s)" ;;
  none)        gate_line="surface gating not applied: the shipping facts name no gated path" ;;
  no-answers|unparseable)
               gate_line="surface answers NOT read ($GATE_REASON): a citation into a gated path is judged like any other" ;;
  answers)
    for f in "${!DECLINED[@]}"; do gate_summary+=" $f=${DECLINED_HITS[$f]:-0}"; done
    # shellcheck disable=SC2086  # word splitting is the point: one flag=count per line, then sorted
    gate_summary="$(printf '%s\n' $gate_summary | sort | paste -sd' ' -)"
    gate_line="passed  $declined_total citation(s) into declined-surface paths, unjudged (${gate_summary:-no surface declined})" ;;
esac
log "  $gate_line"
# The one verdict sentence, shared by the terminal and the --output report. A run that passed
# citations into declined surfaces says so IN the verdict, never only on the count line above it,
# because "every citation resolves" would then be false (code/docs/GATE-REPORTING.md Section 1).
if [ "$violations" -gt 0 ]; then
  verdict="$violations citation(s) do not resolve."
elif [ "$declined_total" -gt 0 ]; then
  verdict="Clean — every judged citation resolves; $declined_total passed unjudged into declined-surface paths."
else
  verdict="Clean — every citation resolves."
fi

if [ "$scanned_files" -eq 0 ]; then
  # An absent surface, not an absent tool: the population is legitimately empty, so exit 0 is
  # honest — but only while the run says the population was empty. A bare success line here
  # reads as "looked, and it was clean" (code/docs/GATE-REPORTING.md Section 2).
  bold "Nothing to check — nothing eligible to read under ${TARGET_PATH:-the repository}."
elif [ "$violations" -eq 0 ]; then
  bold "$verdict"   # qualified when citations passed unjudged (US004 round 2, C-01 / Q-01)
else
  bold "$verdict"
  # Each remedy is printed for the class that fired and no other (US004 H-10, 06/11/2026): a run
  # holding one class read as if it held all four, and downstream it told the reader to run a
  # --write-shipping that exits 2 there.
  if [ -n "${class_hits[instance citation]:-}" ]; then
    log ""
    log "Rule: a shipped file may cite layering-system artefacts only (CONTEXT.md,"
    log "CLAUDE.md, docs/, workflows/, scripts, guides) and never a per-project"
    log "instance (ADR-US###, US###, SPRINT-##, MAP-*, PLAN-*). Drop the citation, or"
    log "point at the guide that carries the rule."
  fi
  if [ -n "${class_hits[template-only citation]:-}" ]; then
    log ""
    log "A [template-only citation] is the other direction: the path resolves here and"
    log "copier excludes it, so the reader of a generated project has no such file. The"
    log "default disposition is still to correct or drop it — reach for the marker only"
    log "when the citation is right and merely unprovable downstream:"
    log "  ... the contract lives in \`copier.yml\`. <!-- doc-references: template-only -->"
    log "Rule and the difference from \`ignore\`: code/docs/FORWARD-VOICE.md Sections 1 and 4."
  fi
  if [ -n "${class_hits[dangling path]:-}${class_hits[dangling link]:-}" ]; then
    log ""
    log "A [dangling path] or [dangling link] names a file in neither tree: correct the"
    log "citation or drop it. A path a generated project CREATES is promised by a row in"
    log "how-to/src/PROJECT-PATHS.md naming its creator, and a row carrying ### binds"
    log "every story's copy of a per-story record -- but a row is written only when that"
    log "creator exists, never to quieten a finding, and no row covers a shipped template."
  fi
  if [ -n "${class_hits[shipping facts]:-}" ]; then
    log ""
    log "A [shipping facts] finding means the shipped copy lags the copier contract: run"
    log "doc-references.sh --write-shipping, never edit the file."
  fi
  if [ -n "${class_hits[plan prefix]:-}" ]; then
    log ""
    log "A [plan prefix] finding is a NAMING rule, and no file has to be"
    log "missing for it to be true. A story plan is named for its position in the settled"
    log "build order across the whole backlog and a sprint plan likewise, so both carry a"
    log "two-digit prefix and the citation must carry it too. That number is renumbered"
    log "whenever build order changes — so repoint the citation at the name the plan is on"
    log "disk under, and quote a superseded name in \"double quotes\", never in backticks."
  fi
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
    printf 'Markdown link targets tested: %s\n\n' "$link_tests"
    printf 'Unconditionally excluded paths matched against: %s\n\n' "$template_only_paths"
    printf 'Surface gating: %s\n\n' "$gate_line"
    printf 'Violations: %s\n\n' "$violations"
    [ "$scanned_files" -eq 0 ] || printf 'Verdict: %s\n\n' "$verdict"
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
