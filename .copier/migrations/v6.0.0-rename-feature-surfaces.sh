#!/usr/bin/env bash
#
# v6.0.0-rename-feature-surfaces.sh — rescue and repoint the four renamed "feature" surfaces.
#
# WHAT CHANGED IN THE TEMPLATE. "Feature" meant two different sizes in this repository — an
# epic charted on a map, and a single buildable story — so v6.0.0 renamed four surfaces to
# say which one they mean:
#
#     .claude/skills/feature/                  -> .claude/skills/implement-story/
#     code/workflows/01-new-feature/           -> code/workflows/01-implement-story/
#     project-management/workflows/01-feature/ -> project-management/workflows/01-feature-map/
#     project-management/src/01-FEATURE/       -> project-management/src/01-FEATURE-MAPS/
#
# WHY THIS IS KEYED v6.0.0, AND WHY THAT IS WORTH SAYING. A migration must be keyed to the
# release that MOVED the directory, not to the release in which somebody noticed the damage.
# Key it late and every project that updated in between crosses the break without ever
# crossing the cure. MAP-BASE-HEALTH N-047 records that this repository has mis-keyed a
# migration before, by tagging a batch of them retroactively. The break here lands in
# v6.0.0 — the four `git mv`s and this script are in the same commit — so v6.0.0 is the
# correct key, and it is correct for that reason rather than by coincidence. Read the
# v5.0.0 entry with more suspicion than this one.
#
# WHY IT ACTS ON DIRECTORIES. Copier moves the scaffolding it owns to the new path and
# deletes the old one. Anything a DEVELOPER wrote in those folders was never a template
# file, so `copier update` leaves it behind in a directory nothing routes to — no conflict,
# no error, update reports success. That is `audits/template-orphans.sh`'s exact orphan
# signature: a directory holding files but no CONTEXT.md.
#
# WHAT WAS ACTUALLY MEASURED, AND WHAT WAS NOT. Distinguish these before trusting the
# paragraph above (code/docs/GATE-REPORTING.md):
#
#   MEASURED, on a live v5.5.0 -> v6.0.0 `copier copy` then `copier update`:
#     project-management/src/01-FEATURE/ strands MAP-SCALE-PLANNING.md. That file is put
#     there by a copier `_task`, and `_tasks` run on copy and NEVER on update, so copier
#     deleted the three files it owned and left the map alone in the husk.
#     `template-orphans.sh` found it and exited 1. This orphan is guaranteed in 100% of
#     projects, not hypothetical — it does not depend on the developer having written
#     anything.
#
#   UNMEASURED, and honestly so: the other three trees. A freshly generated project has
#     authored nothing in them, so a live proof cannot exercise those arms at all. That is
#     absence of a specimen, not evidence of safety — a project that HAS written a map, a
#     workflow note or a local skill there strands it by the same mechanism. `--self-test`
#     below is the only cover for those three, so it plants a stranded file in each.
#
# WHY IT ACTS ON CITATIONS TOO. The rename changes paths that projects cite by hand, and a
# citation is not repaired by a merge. The four rules are anchored with negative lookahead
# (01-FEATURE(?!-MAPS)) so a second run is a no-op by construction rather than by a guard
# somebody has to remember to keep true. Order matters and is fixed below.
#
# WHY IT ONLY REPORTS ON PROSE. A backticked `feature` in a sentence is sometimes the skill
# and sometimes the English word, and only the author of the sentence knows which. A script
# guessing rewrites a proportion of them wrongly, and a wrong word that reads as deliberate
# is worse than one a person was asked to look at. Reported, never touched, and it can
# never affect the exit code.
#
# Runs automatically as a copier `_migrations` entry when an update crosses v6.0.0. Safe to
# run by hand afterwards; both acting halves are idempotent.
#
# Working directory is the project being updated.
#
# Usage:  v6.0.0-rename-feature-surfaces.sh [--self-test] [--help]
#
# Exit codes:  0 = nothing to do, or applied cleanly. Advisory findings NEVER fail the run:
#                  a migration that fails an update leaves the project half-upgraded, which
#                  is worse than a list of sentences to read.
#              1 = collisions left for a human. Nothing was overwritten.
#              2 = script error
#
set -euo pipefail

SELF_TEST=false

die() { printf 'v6.0.0-rename-feature-surfaces.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
v6.0.0-rename-feature-surfaces.sh — rescue and repoint the four renamed "feature" surfaces

Usage:
  v6.0.0-rename-feature-surfaces.sh              Migrate the project in the working directory
  v6.0.0-rename-feature-surfaces.sh --self-test  Prove the rescue, the rewrite and its
                                                 idempotence against a scratch tree, then exit

Exit codes:  0 = clean   1 = collisions left for a human   2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "Unknown option: $1. Use --help for usage." ;;
  esac
done

# ── The rename map ────────────────────────────────────────────────────────────
#
# old:new:marker. The MARKER is the file the template still owns in that directory —
# CONTEXT.md for the src/ tree and both workflow trees, SKILL.md for the skills tree, which
# has no pair. If the OLD directory still holds its marker, copier has not renamed anything
# here yet and this is not the orphan signature: leave it alone rather than guess.
#
# Order does not matter: every old path is distinct from every new one, so no move cascades.
RENAMES="
.claude/skills/feature:.claude/skills/implement-story:SKILL.md
code/workflows/01-new-feature:code/workflows/01-implement-story:CONTEXT.md
project-management/workflows/01-feature:project-management/workflows/01-feature-map:CONTEXT.md
project-management/src/01-FEATURE:project-management/src/01-FEATURE-MAPS:CONTEXT.md
"

# ── The citation rules ────────────────────────────────────────────────────────
#
# ORDER IS LOAD-BEARING and is: 01-new-feature, then 01-feature(?!-map), then
# 01-FEATURE(?!-MAPS), then skills/feature. `01-new-feature` is narrowed first so the
# broader lowercase rule can never see a fragment of it.
#
# Each rule is idempotent BY CONSTRUCTION, not by a flag: rules 1 and 4 produce text that
# no longer contains their own pattern, and rules 2 and 3 produce text their own lookahead
# rejects. Running this twice changes nothing on the second pass.
#
# The fifth rule is the `skills:` frontmatter array, in BOTH shapes the repo uses — inline
# `skills: [a, b]` and the Prettier-wrapped multi-line form. It matches the bracketed value
# as a whole rather than a line, and `(?![-\w])` stops it eating a longer skill name that
# merely starts with the word.
read -r -d '' PERL_RULES <<'PERL' || true
s{01-new-feature}{01-implement-story}g;
s{01-feature(?!-map)}{01-feature-map}g;
s{01-FEATURE(?!-MAPS)}{01-FEATURE-MAPS}g;
s{skills/feature\b}{skills/implement-story}g;
s{(skills:\s*\[[^\]]*\])}{ my $b = $1; $b =~ s/\bfeature(?![-\w])/implement-story/g; $b }ge;
PERL

# Files whose whole purpose is to record what the project used to be. Rewriting a path
# inside a historical entry does not repair a citation, it falsifies the record.
HISTORY_FILES=("CHANGELOG.md" "VERSION-HISTORY.md" "RELEASES.md" ".copier/RELEASES.md")

is_history() {
  local f="${1#./}" h
  for h in "${HISTORY_FILES[@]}"; do [[ "$f" == "$h" ]] && return 0; done
  return 1
}

# ── 1. Rescue stranded directories ───────────────────────────────────────────
MOVED=0
COLLIDED=0
declare -a COLLISIONS=()
# Where each rescued file landed. The citation sweep below reads `git ls-files`, which is
# the INDEX — it still names the old path, so a file this step has just moved is invisible
# to it and would keep its stale citations until somebody ran the script a second time.
# Caught by the live proof: MAP-SCALE-PLANNING.md, the one file stranded in every project,
# cites `01-feature` in its own header.
declare -a RESCUED=()

rescue_stranded() {
  local old new marker rel dest f
  while IFS=: read -r old new marker; do
    [[ -n "$old" ]] || continue
    [[ -d "$old" ]] || continue

    # The template still owns this directory — the rename has not reached it.
    [[ -f "$old/$marker" ]] && continue

    mkdir -p "$new"

    # Preserve the sub-path, so a file in PLANNING/ lands in PLANNING/ rather than at the
    # folder root.
    while IFS= read -r f; do
      rel="${f#"$old"/}"
      dest="$new/$rel"

      if [[ -e "$dest" ]]; then
        # Never overwrite. A name present on both sides needs a human.
        COLLISIONS+=("$old/$rel -> $dest")
        COLLIDED=$((COLLIDED + 1))
        continue
      fi

      mkdir -p "$(dirname "$dest")"
      mv "$f" "$dest"
      RESCUED+=("$dest")
      printf '  moved   %s -> %s\n' "$old/$rel" "$dest"
      MOVED=$((MOVED + 1))
    done < <(find "$old" -type f 2>/dev/null | sort)

    # Drop the husk if nothing is left in it.
    find "$old" -type d -empty -delete 2>/dev/null || true
  done <<< "$RENAMES"
}

# ── 2. Repoint path and `skills:` citations ──────────────────────────────────
REWROTE=0

# Every tracked text file, because a path citation is not a markdown-only defect — it turns
# up in shell scripts, YAML and JSON too. `git ls-files` is the definition of "the project's
# own files"; outside a git repo, fall back to walking the tree without .git.
#
# The rescued files are appended because the index has not caught up with the moves this
# run just made — without them the sweep skips exactly the files the rescue was for.
candidate_files() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git ls-files -z
  else
    find . -type f -not -path './.git/*' -print0
  fi
  [[ ${#RESCUED[@]} -gt 0 ]] && printf '%s\0' "${RESCUED[@]}"
  return 0
}

rewrite_citations() {
  local f
  local -a targets=()

  while IFS= read -r -d '' f; do
    is_history "$f" && continue
    [[ -f "$f" ]] || continue
    # -I skips binaries. Every one of the five rules needs the literal `feature` or
    # `FEATURE` somewhere in the file, so this prefilter is exact rather than merely cheap:
    # a file without it cannot match any rule, and is never opened or rewritten.
    grep -Iq -e 'feature' -e 'FEATURE' "$f" 2>/dev/null || continue
    targets+=("$f")
  done < <(candidate_files)

  [[ ${#targets[@]} -gt 0 ]] || return 0

  for f in "${targets[@]}"; do
    local before after
    before=$(cksum < "$f")
    perl -0777 -i -pe "$PERL_RULES" "$f"
    after=$(cksum < "$f")
    if [[ "$before" != "$after" ]]; then
      printf '  repointed  %s\n' "${f#./}"
      REWROTE=$((REWROTE + 1))
    fi
  done
}

# ── 3. Report prose, without ever touching it ────────────────────────────────
report_prose() {
  local hits count
  hits=$(grep -rIn --exclude-dir=.git \
    --exclude=CHANGELOG.md --exclude=VERSION-HISTORY.md --exclude=RELEASES.md \
    -e '`feature`' . 2>/dev/null || true)

  [[ -n "$hits" ]] || return 0

  count=$(printf '%s\n' "$hits" | wc -l | tr -d ' ')

  printf '\n  ADVISORY — %s backticked `feature` mention(s) in your own files.\n\n' "$count"
  printf '  Nothing below was changed and none of it affects this exit code. `feature` was a\n'
  printf '  skill name until v6.0.0 and is now the English word only, so each of these is\n'
  printf '  either a live citation that needs the new name or a sentence that is already fine\n'
  printf '  — and only the author of the sentence can tell which.\n\n'

  printf '%s\n' "$hits" | sed 's/^/      /'

  printf '\n  Which name replaced it:\n\n'
  printf '      Building ONE US### story end to end\n'
  printf '          -> `implement-story`   (.claude/skills/implement-story/)\n'
  printf '      Charting an EPIC across several stories before any are cut\n'
  printf '          -> `wayfinder`, whose procedure is project-management/workflows/01-feature-map/\n\n'
}

# ── Self-test ────────────────────────────────────────────────────────────────
#
# The live proof can only ever exercise one of the four trees, because a freshly generated
# project has authored nothing in the other three. This plants a stranded file in each,
# plus one file of every citation shape, and asserts three things: the rescue moves what is
# stranded, the marker guard leaves an un-renamed tree alone, and a second run of the whole
# script changes nothing at all.
if $SELF_TEST; then
  printf '\n▸ v6.0.0-rename-feature-surfaces.sh --self-test\n\n'
  script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
  fails=0

  check() {
    if [[ "$2" == "$3" ]]; then
      printf '  ok    %s\n' "$1"
    else
      printf '  FAIL  %s\n          expected: %s\n          actual:   %s\n' "$1" "$3" "$2"
      fails=$((fails + 1))
    fi
  }

  # Four stranded trees: no marker file, so each is the orphan signature.
  mkdir -p "$tmp/.claude/skills/feature" \
           "$tmp/code/workflows/01-new-feature" \
           "$tmp/project-management/workflows/01-feature" \
           "$tmp/project-management/src/01-FEATURE/PLANNING"
  echo 'local skill'      > "$tmp/.claude/skills/feature/LOCAL-NOTE.md"
  echo 'workflow note'    > "$tmp/code/workflows/01-new-feature/NOTES.md"
  echo 'pm note'          > "$tmp/project-management/workflows/01-feature/NOTES.md"
  echo 'nested'           > "$tmp/project-management/src/01-FEATURE/PLANNING/DRAFT.md"
  # A stranded file that cites an old path in its OWN text — it has to be moved AND
  # repointed in a single run. This is the real MAP-SCALE-PLANNING.md's header, near enough:
  # the file stranded in every project happens to name its own workflow.
  printf 'seeded map\n**Workflow**: `01-feature`\n' \
    > "$tmp/project-management/src/01-FEATURE/MAP-SCALE-PLANNING.md"

  # The marker guard needs its own project root and is tested further down — the guard only
  # fires on the mapped path itself, so a copy of it nested inside this tree would prove
  # nothing (the rescue loop would never look there in the first place).

  # Every citation shape, plus the two that must NOT move.
  cat > "$tmp/CITATIONS.md" <<'FIXTURE'
---
type: guide
skills: [feature, backend]
---
See code/workflows/01-new-feature/STEPS.md and
project-management/workflows/01-feature/CHECKLIST.md and
project-management/src/01-FEATURE/MAP-000-TEMPLATE.md and
.claude/skills/feature/SKILL.md.
Already correct: project-management/workflows/01-feature-map/STEPS.md,
project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md.
The word `feature` in prose must survive untouched.
FIXTURE
  cat > "$tmp/WRAPPED.md" <<'FIXTURE'
---
skills:
  [
    feature,
    planner,
  ]
---
FIXTURE
  echo 'v2.0.0 moved project-management/src/01-FEATURE/ — history, do not rewrite.' \
    > "$tmp/CHANGELOG.md"

  # A REAL git repository, because that is how copier runs this and the two branches of
  # candidate_files behave differently: `git ls-files` reports the index, which still names
  # a file at the path the rescue has just moved it off. A scratch tree without .git takes
  # the find fallback and cannot reproduce that at all — the reason it went unnoticed until
  # a live update was watched.
  ( cd "$tmp" && git init -q . \
      && git add -A \
      && git -c user.name=selftest -c user.email=selftest@local commit -qm fixtures ) \
    >/dev/null 2>&1 || die 'self-test could not create its scratch git repository'

  rc=0
  ( cd "$tmp" && bash "$script_path" >/dev/null 2>&1 ) || rc=$?
  check 'first run exits 0' "$rc" '0'

  check 'a rescued file is repointed in the SAME run' \
    "$(grep -c '`01-feature-map`' "$tmp/project-management/src/01-FEATURE-MAPS/MAP-SCALE-PLANNING.md" 2>/dev/null || true)" '1'

  check 'skills/ stranded file rescued' \
    "$(cat "$tmp/.claude/skills/implement-story/LOCAL-NOTE.md" 2>/dev/null)" 'local skill'
  check 'code workflow stranded file rescued' \
    "$(cat "$tmp/code/workflows/01-implement-story/NOTES.md" 2>/dev/null)" 'workflow note'
  check 'pm workflow stranded file rescued' \
    "$(cat "$tmp/project-management/workflows/01-feature-map/NOTES.md" 2>/dev/null)" 'pm note'
  check 'src/ seeded map rescued' \
    "$(head -1 "$tmp/project-management/src/01-FEATURE-MAPS/MAP-SCALE-PLANNING.md" 2>/dev/null)" 'seeded map'
  check 'nested sub-path preserved' \
    "$(cat "$tmp/project-management/src/01-FEATURE-MAPS/PLANNING/DRAFT.md" 2>/dev/null)" 'nested'
  check 'husk removed' \
    "$([[ -d "$tmp/project-management/src/01-FEATURE" ]] && echo present || echo gone)" 'gone'

  # The four path rules, each asserted positively as well as by the sweep below — a rule
  # that silently stopped matching would still pass "no old token survives" if the token
  # were deleted rather than rewritten.
  check 'rule 1 — 01-new-feature -> 01-implement-story' \
    "$(grep -c 'code/workflows/01-implement-story/STEPS.md' "$tmp/CITATIONS.md")" '1'
  check 'rule 2 — 01-feature -> 01-feature-map' \
    "$(grep -c 'project-management/workflows/01-feature-map/CHECKLIST.md' "$tmp/CITATIONS.md")" '1'
  check 'rule 3 — 01-FEATURE -> 01-FEATURE-MAPS' \
    "$(grep -c 'project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md' "$tmp/CITATIONS.md")" '2'
  check 'rule 4 — skills/feature -> skills/implement-story' \
    "$(grep -c '.claude/skills/implement-story/SKILL.md' "$tmp/CITATIONS.md")" '1'
  check 'inline skills: frontmatter repointed' \
    "$(grep -c 'skills: \[implement-story, backend\]' "$tmp/CITATIONS.md")" '1'
  check 'wrapped skills: frontmatter repointed' \
    "$(grep -c '^    implement-story,$' "$tmp/WRAPPED.md")" '1'
  check 'no old path token survives' \
    "$(grep -cE '01-new-feature|01-feature[^-]|01-FEATURE[^-]|skills/feature' "$tmp/CITATIONS.md" || true)" '0'
  check 'already-correct paths not doubled' \
    "$(grep -c '01-FEATURE-MAPS-MAPS\|01-feature-map-map' "$tmp/CITATIONS.md" || true)" '0'
  check 'prose `feature` left alone' \
    "$(grep -c 'The word `feature` in prose' "$tmp/CITATIONS.md")" '1'
  check 'history file not rewritten' \
    "$(grep -c 'src/01-FEATURE/' "$tmp/CHANGELOG.md")" '1'

  # The marker guard, in its own project root. A project copier has NOT yet renamed still
  # holds the template's own SKILL.md at the old path — that is not the orphan signature,
  # and nothing may move. Tested from a second root because the guard is only reachable at
  # the mapped path itself.
  guard=$(mktemp -d); trap 'rm -rf "$tmp" "$guard"' EXIT
  mkdir -p "$guard/.claude/skills/feature"
  echo 'still owned' > "$guard/.claude/skills/feature/SKILL.md"
  echo 'untouched'   > "$guard/.claude/skills/feature/EXTRA.md"
  guard_rc=0
  ( cd "$guard" && bash "$script_path" >/dev/null 2>&1 ) || guard_rc=$?
  check 'marker guard — run over an un-renamed tree exits 0' "$guard_rc" '0'
  check 'marker guard — the developer file stays put' \
    "$(cat "$guard/.claude/skills/feature/EXTRA.md" 2>/dev/null)" 'untouched'
  check 'marker guard — no destination directory invented' \
    "$([[ -d "$guard/.claude/skills/implement-story" ]] && echo created || echo absent)" 'absent'

  # The template guard, in a third root: copier.yml beside .copier/migrations/ can only be
  # syntek-base, where the surviving old paths are deliberate prose about the rename and
  # rewriting them would produce a sentence claiming a directory was renamed to itself.
  tmpl=$(mktemp -d); trap 'rm -rf "$tmp" "$guard" "$tmpl"' EXIT
  mkdir -p "$tmpl/.copier/migrations"
  : > "$tmpl/copier.yml"
  echo 'renames code/workflows/01-new-feature/ -> code/workflows/01-implement-story/' \
    > "$tmpl/copier.yml"
  tmpl_rc=0
  ( cd "$tmpl" && bash "$script_path" >/dev/null 2>&1 ) || tmpl_rc=$?
  check 'template guard — run inside the template exits 0' "$tmpl_rc" '0'
  check 'template guard — deliberate old paths left intact' \
    "$(grep -c '01-new-feature' "$tmpl/copier.yml")" '1'

  # Idempotence, proven rather than asserted: the whole tree hashed before and after a
  # second full run.
  # .git is pruned: git rewrites its own index and log files as a side-effect of being
  # read, and a hash that drifts for that reason would report a false failure.
  before=$(cd "$tmp" && find . -path ./.git -prune -o -type f -exec cksum {} + | sort)
  ( cd "$tmp" && bash "$script_path" >/dev/null 2>&1 ) || true
  after=$(cd "$tmp" && find . -path ./.git -prune -o -type f -exec cksum {} + | sort)
  check 'second run changes nothing' "$([[ "$before" == "$after" ]] && echo same || echo differs)" 'same'

  if [[ $fails -gt 0 ]]; then
    printf '\n  %d check(s) failed.\n\n' "$fails"
    exit 1
  fi
  printf '\n  All checks passed.\n\n'
  exit 0
fi

# ── Refuse to run inside the template itself ─────────────────────────────────
#
# Found by running the proof rather than predicted. `copier update` always invokes this
# with the PROJECT as the working directory, but run by hand inside syntek-base it would
# rewrite the two files that carry the old paths deliberately — copier.yml's own comment
# describing the rename, and the handoff recording it — into sentences claiming a
# directory was renamed to itself. Silent, and plausible enough to survive review.
#
# The tell is unambiguous and needs no answers file: `.copier/migrations/` is excluded
# from what a generated project receives (copier.yml `_exclude`), so a directory holding
# both it and copier.yml can only be the template.
#
# Exit 0, not an error: a migration that fails an update leaves the project half-upgraded.
if [[ -d ".copier/migrations" && -f "copier.yml" ]]; then
  printf '\n▸ v6.0.0 migration — this is the syntek-base template, not a generated project.\n\n'
  printf '  Nothing done. This script migrates a project that `copier update` is upgrading;\n'
  printf '  the template is where the rename already happened. To exercise it here, run\n'
  printf '  --self-test, which works against a scratch tree.\n\n'
  exit 0
fi

# ── Run ───────────────────────────────────────────────────────────────────────

printf '\n▸ v6.0.0 migration — the four "feature" surfaces were renamed\n'

rescue_stranded
rewrite_citations

if [[ $MOVED -eq 0 && $COLLIDED -eq 0 && $REWROTE -eq 0 ]]; then
  printf '  nothing stranded and no citation needed repointing\n'
else
  [[ $MOVED -gt 0 ]]   && printf '\n  %d file(s) moved into the v6.0.0 names.\n' "$MOVED"
  [[ $REWROTE -gt 0 ]] && printf '  %d file(s) had a path or `skills:` citation repointed.\n' "$REWROTE"
fi

# One consequence worth naming, because the folder's own documentation contradicts what the
# reader is about to see. 01-FEATURE-MAPS/CONTEXT.md says MAP-SCALE-PLANNING.md "is seeded
# into this folder at generation" — true on a `copier copy`, and false after this update,
# where the map was placed by a copy-time _task that an update never re-runs and so arrived
# here in the rescue above rather than from the template.
if [[ -f "project-management/src/01-FEATURE-MAPS/MAP-SCALE-PLANNING.md" && $MOVED -gt 0 ]]; then
  printf '\n  MAP-SCALE-PLANNING.md was moved, not re-seeded. `copier update` never re-runs the\n'
  printf '  copy-time task that first placed it, so your filled-in map is the one that survived\n'
  printf '  — the folder CONTEXT.md still describes it as seeded at generation.\n'
fi

report_prose

if [[ $COLLIDED -gt 0 ]]; then
  printf '\n  %d file(s) could NOT be moved — a file of the same name already exists:\n\n' "$COLLIDED"
  for c in "${COLLISIONS[@]}"; do printf '    %s\n' "$c"; done
  printf '\n  Nothing was overwritten. Reconcile these by hand, then re-run:\n'
  printf '    bash code/src/scripts/audits/template-orphans.sh\n\n'
  exit 1
fi

if [[ $MOVED -gt 0 || $REWROTE -gt 0 ]]; then
  printf '  Review with `git status`, then commit.\n\n'
else
  printf '\n'
fi

exit 0
