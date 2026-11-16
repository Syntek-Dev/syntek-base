#!/usr/bin/env bash
#
# cookie-preview-fixture.sh — Build US008's disposable generated project and prove the preview.
#
# TEST-ONLY. It exists for the preview rows of US008 (manual guide PREVIEW-01 to PREVIEW-04) and
# the story plan's P4 and P5 proofs. It ships no feature, and it reads a TEMPLATE repository's
# history, so it has nothing to do in a project that is not proving that story.
#
# Why it exists. `development/template-update.sh` refuses to run in the template itself — the
# template's .copier-answers.yml is the Jinja source of the file rendered into projects, so it
# holds no `_commit:` — and a preview proof therefore needs a GENERATED project, old enough to
# cross the migrations under test, committed so the wrapper's clean-tree guard passes. Nothing
# in the repository made one from an old ref, so a tester would have had to run Copier by hand.
# This script owns those Copier invocations instead.
#
# What it does, for every case:
#
#   1. CLONES --template-source into a scratch directory and works only on that clone. Every
#      disposable ref a case needs (a story snapshot, a fixture release tag) is made in the clone;
#      the source repository is read, never written, tagged or fetched into.
#   2. Puts the story's code on a scratch branch: --story-ref <commit> checks that commit out;
#      --story-ref WORKTREE snapshots the source's working tree (tracked files as on disk plus
#      untracked-but-not-ignored ones) and commits it in the clone only — for a proof taken
#      before the story's own commit exists. The record says which.
#   3. GENERATES a project from a ref below v3.0.0 (--from-ref, default v2.3.1) with fixed,
#      non-secret answers, then copies the story's `template-update.sh` and the one library it
#      sources into it, plants the case's triggers, and commits.
#   4. CHECKS the wrapper's prerequisites — `_commit:` in .copier-answers.yml, a clean tree —
#      and prints the fixture record: source SHA, Copier version, answers, from/target refs.
#   5. RUNS the actual `template-update.sh` from the generated root, with `copier` on PATH as a
#      recording shim over the real binary (so "Copier ran" is observed, not inferred) and with
#      TMPDIR pointed at a directory this script owns (so the wrapper's cleanup is checked by
#      looking, not assumed). Then asserts the case's expectations.
#
# Cases (the P5 ones need P5's `_migrations:` entries at --story-ref and report UNMEASURED,
# exit 3, when those are absent — never a pass):
#
#   shipped-advisories  P4 · PREVIEW-01. Plants the triggers of the three print-only advisories
#                       shipped before US008 and previews to the newest release tag. Expects
#                       exit 0, the update's output replayed once before the preview-only line,
#                       and four banners from three advisories: v3.0.0, v5.0.0 twice (keyed at
#                       v4.0.0 and v5.0.0), and v6.0.0's report-only `feature` advisory.
#   missing-ref         P4/P5 · PREVIEW-04 (ES-08). Confirms the clone lacks the ref, previews
#                       to it, and expects Copier to have run and failed, the failure tail once,
#                       no success block, exit 2, and the wrapper's scratch removed.
#   domain-report       P5 · PREVIEW-02/03. Plants a cookie Domain setting in staging.py and
#                       previews to the story snapshot. Expects the state advisory to name the
#                       file and setting and never print the planted value.
#   pending-key         P5. Previews to the story snapshot, whose cutover entry is `when: false`.
#                       Expects no cutover notice.
#   release-crossing    P5. Activates the cutover entry in a scratch commit (a fixture version
#                       key and the after-stage predicate, in one commit), tags that commit in
#                       the clone, previews across it. Expects the cutover notice exactly once.
#   subsequent-update   P5. Generates at that fixture release and previews to a later fixture
#                       tag. Expects no cutover notice — the crossing is behind it.
#
# Usage: cookie-preview-fixture.sh --case CASE --template-source ABS_PATH --story-ref REF
#                                  [--from-ref REF] [--keep-scratch] [--help]
#
# Exit codes:  0 = every expectation of the case held
#              1 = the case ran and an expectation failed — the output says which
#              2 = script error (bad arguments, a ref that does not resolve, a broken fixture)
#              3 = UNMEASURED — a prerequisite was missing (Copier, network for generation,
#                  P5 entries at --story-ref); nothing was proved either way
#
set -euo pipefail

SCRIPT_NAME="cookie-preview-fixture.sh"
WRAPPER_REL="code/src/scripts/development/template-update.sh"
WRAPPER_LIB_REL="code/src/scripts/_lib/conflict-markers.sh"
MISSING_REF="us008-does-not-exist-09-10-2026"
# Below v3.0.0, so an update crosses every shipped print-only advisory; and at or above v2.0.0,
# so it does not also cross the v2.0.0 renumbering, which proves nothing here. v2.3.1 because it
# is the NEWEST tag in that window that still generates: v2.4.0 to v2.21.0 shipped a bare block
# delimiter in sync-trees.sh (fixed in e16b499, first tagged v3.0.0), so `copier copy` at any of
# them dies with TemplateSyntaxError — measured 16/11/2026 with Copier 9.19.1.
DEFAULT_FROM_REF="v2.3.1"
# How a cutover notice is recognised in the replayed output. P5 sets this to text only the
# cutover advisory prints; until P5 lands, the cases that read it report UNMEASURED.
CUTOVER_MARK="${US008_CUTOVER_MARK:-__Host- cookie names}"
DOMAIN_PLANT_VALUE="us008-fixture-domain.example.invalid"

# Scratch commits are made with a throwaway identity, and with hooks and signing off, so a global
# hooksPath or commit.gpgsign cannot turn a fixture commit into a prompt or a failure.
GIT_SCRATCH=(git -c user.name="cookie-preview-fixture" -c user.email="fixture@example.invalid"
             -c commit.gpgsign=false -c tag.gpgsign=false -c core.hooksPath=/dev/null)

CASE=""
SOURCE=""
STORY_REF=""
FROM_REF="$DEFAULT_FROM_REF"
KEEP_SCRATCH=false
SCRATCH=""
FAILS=0

log()  { printf '%s\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
die()  { printf '%s error: %s\n' "$SCRIPT_NAME" "$*" >&2; exit 2; }
unmeasured() { bold "UNMEASURED — $*"; log "  Nothing was proved either way."; exit 3; }
# check LABEL COMMAND... — runs the command as a condition, so a failed expectation is counted
# and reported rather than tripping `set -e`.
check() {
  local label="$1"; shift
  if "$@"; then log "  ✓ $label"; else log "  ✗ $label"; FAILS=$((FAILS + 1)); fi
}

usage() {
  cat <<'EOF'
cookie-preview-fixture.sh — US008's disposable generated project and preview proof (test-only)

Usage:
  cookie-preview-fixture.sh --case CASE --template-source ABS_PATH --story-ref REF

  Run through Bash from the story root, e.g.
    bash code/src/scripts/tests/cookie-preview-fixture.sh --case shipped-advisories \
      --template-source "$PWD" --story-ref HEAD

Options:
  --case CASE             shipped-advisories | missing-ref                          (P4)
                          domain-report | pending-key | release-crossing |
                          subsequent-update                                         (P5)
  --template-source PATH  Absolute path to the local template repository. Cloned, never written
  --story-ref REF         The commit whose template-update.sh is under test, or WORKTREE to
                          snapshot the source's uncommitted working tree in the clone only
  --from-ref REF          The ref the project is generated at (default v2.3.1; must be below
                          v3.0.0). subsequent-update generates at its fixture release instead
  --keep-scratch          Keep the clone and the generated project, and print where they are
  --help                  Show this help

Exit codes:
  0  every expectation held          1  an expectation failed
  2  script error                    3  UNMEASURED — a prerequisite was missing
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --case)            [[ $# -ge 2 ]] || die "--case needs a value"; CASE="$2"; shift 2 ;;
    --template-source) [[ $# -ge 2 ]] || die "--template-source needs a value"; SOURCE="$2"; shift 2 ;;
    --story-ref)       [[ $# -ge 2 ]] || die "--story-ref needs a value"; STORY_REF="$2"; shift 2 ;;
    --from-ref)        [[ $# -ge 2 ]] || die "--from-ref needs a value"; FROM_REF="$2"; shift 2 ;;
    --keep-scratch)    KEEP_SCRATCH=true; shift ;;
    --help|-h)         usage; exit 0 ;;
    *)                 die "Unknown option: $1. Use --help for usage." ;;
  esac
done

case "$CASE" in
  shipped-advisories|missing-ref|domain-report|pending-key|release-crossing|subsequent-update) ;;
  "") die "--case is required. Use --help for the list." ;;
  *)  die "Unknown --case: $CASE. Use --help for the list." ;;
esac
[[ -n "$SOURCE" ]] || die "--template-source is required."
[[ "$SOURCE" == /* ]] || die "--template-source must be an absolute path, got: $SOURCE"
[[ -n "$STORY_REF" ]] || die "--story-ref is required (a commit, or WORKTREE)."
[[ -d "$SOURCE/.git" || -f "$SOURCE/.git" ]] || die "--template-source is not a git repository: $SOURCE"
[[ -f "$SOURCE/copier.yml" && -d "$SOURCE/.copier" ]] \
  || die "--template-source has no copier.yml and .copier/ — it is not the template: $SOURCE"

command -v git >/dev/null 2>&1 || die "git not found on PATH."
command -v tar >/dev/null 2>&1 || die "tar not found on PATH."
if command -v copier >/dev/null 2>&1; then
  REAL_COPIER=("$(command -v copier)")
elif command -v uvx >/dev/null 2>&1; then
  REAL_COPIER=("$(command -v uvx)" copier)
else
  unmeasured "neither copier nor uvx is on PATH, so no project can be generated."
fi
COPIER_VERSION="$("${REAL_COPIER[@]}" --version 2>/dev/null | head -1)" \
  || unmeasured "Copier is on PATH but \`--version\` failed: ${REAL_COPIER[*]}"

# Reads of the source must not rewrite its index (a `git status` refreshes the stat cache).
export GIT_OPTIONAL_LOCKS=0

# ── Scratch ──────────────────────────────────────────────────────────────────
SCRATCH="$(cd "$(mktemp -d -t cookie-preview-fixture-XXXXXX)" && pwd -P)"
# shellcheck disable=SC2329  # invoked by the EXIT trap
cleanup() {
  local rc=$?
  if [[ -n "$SCRATCH" && -d "$SCRATCH" ]]; then
    if $KEEP_SCRATCH; then log "  scratch kept: $SCRATCH"; else rm -rf "$SCRATCH"; fi
  fi
  exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP

CLONE="$SCRATCH/template"
PROJECT="$SCRATCH/project"
SHIM_DIR="$SCRATCH/bin"
WRAP_TMP="$SCRATCH/wrapper-tmp"
COPIER_TMP="$SCRATCH/copier-tmp"
COPIER_MARK="$SCRATCH/copier-invocations.log"
RUN_OUT="$SCRATCH/preview-output.log"
mkdir -p "$SHIM_DIR" "$WRAP_TMP" "$COPIER_TMP"

bold "▸ $SCRIPT_NAME --case $CASE"

git clone --quiet --no-hardlinks "$SOURCE" "$CLONE" || die "Could not clone $SOURCE into the scratch directory."
SOURCE_HEAD="$(git -C "$SOURCE" rev-parse HEAD)"

# ── Story ref → a scratch branch in the clone ────────────────────────────────
if [[ "$STORY_REF" == "WORKTREE" ]]; then
  find "$CLONE" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
  (cd "$SOURCE" && git ls-files -z --cached --others --exclude-standard --deduplicate) \
    | while IFS= read -r -d '' f; do
        [[ -e "$SOURCE/$f" || -L "$SOURCE/$f" ]] && printf '%s\0' "$f"
      done \
    | tar --null -C "$SOURCE" -T - -cf - | tar -xf - -C "$CLONE"
  git -C "$CLONE" checkout --quiet -B us008-fixture-story
  git -C "$CLONE" add -A
  "${GIT_SCRATCH[@]}" -C "$CLONE" commit --quiet --no-verify --allow-empty \
    -m "fixture: working-tree snapshot of $SOURCE_HEAD" || die "Could not commit the working-tree snapshot."
  STORY_DESC="WORKTREE — uncommitted snapshot over $SOURCE_HEAD, committed in the clone only"
else
  STORY_SHA="$(git -C "$SOURCE" rev-parse --verify --quiet "$STORY_REF^{commit}")" \
    || die "--story-ref does not name a commit in the source: $STORY_REF"
  git -C "$CLONE" checkout --quiet -B us008-fixture-story "$STORY_SHA" 2>/dev/null \
    || die "--story-ref $STORY_REF ($STORY_SHA) is not reachable from a branch or tag of the source."
  STORY_DESC="$STORY_REF ($STORY_SHA)"
fi
STORY_COMMIT="$(git -C "$CLONE" rev-parse HEAD)"
git -C "$CLONE" cat-file -e "$STORY_COMMIT:$WRAPPER_REL" 2>/dev/null \
  || die "The story ref has no $WRAPPER_REL."
git -C "$CLONE" cat-file -e "$STORY_COMMIT:$WRAPPER_LIB_REL" 2>/dev/null \
  || die "The story ref has no $WRAPPER_LIB_REL, which the wrapper sources."
# Copier resolves the default update target from the clone's own HEAD branch, so leave the
# clone's checkout where the source's default branch was; the story is read by ref.
git -C "$CLONE" checkout --quiet - 2>/dev/null || true

STORY_COPIER_YML="$(git -C "$CLONE" show "$STORY_COMMIT:copier.yml")"
need_p5_entry() { # pattern  description
  grep -q -- "$1" <<<"$STORY_COPIER_YML" \
    || unmeasured "--story-ref has no $2 in copier.yml (pattern '$1') — this case is proved at P5."
}

# ── Recording shim over the real Copier ──────────────────────────────────────
{
  printf '#!/usr/bin/env bash\n'
  printf 'printf '"'"'%%s\\n'"'"' "copier $*" >> %q\n' "$COPIER_MARK"
  printf 'exec'; printf ' %q' "${REAL_COPIER[@]}"; printf ' "$@"\n'
} > "$SHIM_DIR/copier"
chmod +x "$SHIM_DIR/copier"

latest_release_tag() { git -C "$CLONE" tag --list 'v[0-9]*' --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -1; }
version_lt() { [[ "$1" != "$2" && "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" == "$1" ]]; }

# Make a fixture release in the clone: the story snapshot with the pending cutover entry
# activated — a version key and the after-stage predicate, in one commit — tagged $1. The
# predicate is copied from an existing entry, so this script never spells a template delimiter.
make_fixture_release() {
  local tag="$1" predicate
  predicate="$(grep -m1 -E '^    when: ".*_stage == .after.' <<<"$STORY_COPIER_YML")" \
    || die "No after-stage predicate found in the story's copier.yml to copy."
  git -C "$CLONE" checkout --quiet -B us008-fixture-release "$STORY_COMMIT"
  awk -v ver="$tag" -v pred="$predicate" '
    /^  - / { inentry = 0 }
    /^  - command:.*host-only-cookies/ { inentry = 1; sub(/^  - command:/, "  - version: " ver "\n    command:") }
    inentry && /^    when: false[[:space:]]*$/ { print pred; done = 1; next }
    { print }
    END { if (!done) exit 3 }
  ' "$CLONE/copier.yml" > "$SCRATCH/copier.yml.new" || die "Could not activate the cutover entry (no 'when: false' in it)."
  mv "$SCRATCH/copier.yml.new" "$CLONE/copier.yml"
  git -C "$CLONE" add copier.yml
  "${GIT_SCRATCH[@]}" -C "$CLONE" commit --quiet --no-verify -m "fixture: activate the cutover entry at $tag"
  "${GIT_SCRATCH[@]}" -C "$CLONE" tag "$tag"
  git -C "$CLONE" checkout --quiet -
}

next_minor() { local v="${1#v}"; IFS=. read -r ma mi _ <<<"$v"; printf 'v%s.%s.0' "$ma" "$((mi + 1))"; }
next_patch() { local v="${1#v}"; IFS=. read -r ma mi pa <<<"$v"; printf 'v%s.%s.%s' "$ma" "$mi" "$((pa + 1))"; }

# ── Per-case refs ────────────────────────────────────────────────────────────
TARGET_REF=""
case "$CASE" in
  shipped-advisories) TARGET_REF="$(latest_release_tag)" ;;
  missing-ref)        TARGET_REF="$MISSING_REF" ;;
  domain-report)      need_p5_entry 'cookie-domain-conflict\.sh' "state-gated Domain advisory"
                      git -C "$CLONE" branch -f us008-fixture-target "$STORY_COMMIT"
                      TARGET_REF="us008-fixture-target" ;;
  pending-key)        need_p5_entry 'host-only-cookies\.sh' "pending cutover entry"
                      git -C "$CLONE" branch -f us008-fixture-target "$STORY_COMMIT"
                      TARGET_REF="us008-fixture-target" ;;
  release-crossing)   need_p5_entry 'host-only-cookies\.sh' "pending cutover entry"
                      TARGET_REF="$(next_minor "$(latest_release_tag)")"
                      make_fixture_release "$TARGET_REF" ;;
  subsequent-update)  need_p5_entry 'host-only-cookies\.sh' "pending cutover entry"
                      FROM_REF="$(next_minor "$(latest_release_tag)")"
                      make_fixture_release "$FROM_REF"
                      TARGET_REF="$(next_patch "$FROM_REF")"
                      git -C "$CLONE" checkout --quiet -B us008-fixture-later "$FROM_REF"
                      printf 'fixture: a later release with nothing to migrate\n' > "$CLONE/.us008-fixture-later"
                      git -C "$CLONE" add .us008-fixture-later
                      "${GIT_SCRATCH[@]}" -C "$CLONE" commit --quiet --no-verify -m "fixture: $TARGET_REF"
                      "${GIT_SCRATCH[@]}" -C "$CLONE" tag "$TARGET_REF"
                      git -C "$CLONE" checkout --quiet - ;;
esac

FROM_SHA="$(git -C "$CLONE" rev-parse --verify --quiet "$FROM_REF^{commit}")" \
  || unmeasured "the from-ref $FROM_REF does not exist in the template source."
if [[ "$CASE" != "subsequent-update" ]] && ! version_lt "${FROM_REF#v}" "3.0.0"; then
  die "--from-ref must be below v3.0.0, got $FROM_REF."
fi
if [[ "$CASE" == "missing-ref" ]]; then
  if git -C "$CLONE" rev-parse --verify --quiet "$MISSING_REF^{commit}" >/dev/null; then
    die "The template source HAS a ref named $MISSING_REF — this case needs it absent."
  fi
  TARGET_SHA="absent — verified: no ref of that name in the clone"
else
  [[ -n "$TARGET_REF" ]] || die "No target ref could be resolved for $CASE."
  TARGET_SHA="$(git -C "$CLONE" rev-parse --verify "$TARGET_REF^{commit}")"
fi

# ── Generate ─────────────────────────────────────────────────────────────────
log "  generating at $FROM_REF from the scratch clone…"
GEN_LOG="$SCRATCH/generate.log"
set +e
TMPDIR="$COPIER_TMP" "${REAL_COPIER[@]}" copy --trust --defaults --vcs-ref="$FROM_REF" \
  --data "PROJECT_NAME=US008 Preview Fixture" \
  --data "PROJECT_DESCRIPTION=A disposable project generated to prove the US008 template-update preview end to end." \
  --data "ORG_NAME=Fixture Org" \
  --data "DEVELOPER_NAME=Fixture Runner" \
  --data "DEVELOPER_EMAIL=fixture@example.invalid" \
  --data "DATE=01/01/2027" \
  "$CLONE" "$PROJECT" >"$GEN_LOG" 2>&1
GEN_RC=$?
set -e
if [[ $GEN_RC -ne 0 ]]; then
  tail -25 "$GEN_LOG"
  unmeasured "generating the fixture project at $FROM_REF failed (copier exit $GEN_RC)."
fi
[[ -d "$PROJECT/.git" ]] || git -C "$PROJECT" init --quiet --initial-branch=main
"${GIT_SCRATCH[@]}" -C "$PROJECT" add -A
"${GIT_SCRATCH[@]}" -C "$PROJECT" commit --quiet --no-verify --allow-empty -m "chore: generated at $FROM_REF"

# ── The story's wrapper, and the plants ──────────────────────────────────────
mkdir -p "$PROJECT/$(dirname "$WRAPPER_LIB_REL")"
git -C "$CLONE" show "$STORY_COMMIT:$WRAPPER_REL" > "$PROJECT/$WRAPPER_REL"
git -C "$CLONE" show "$STORY_COMMIT:$WRAPPER_LIB_REL" > "$PROJECT/$WRAPPER_LIB_REL"
chmod +x "$PROJECT/$WRAPPER_REL"

PLANTS=()
if [[ "$CASE" == "shipped-advisories" ]]; then
  # v3.0.0 reports an agent definition the template never owned.
  mkdir -p "$PROJECT/.claude/agents"
  printf -- '---\nname: house-reviewer\n---\n\nA self-authored agent the template never shipped.\n' \
    > "$PROJECT/.claude/agents/house-reviewer.md"
  # v5.0.0 reports a citation at a SECTION of the pre-split git guide; v6.0.0's report-only
  # third reports backticked `feature` prose. One project-owned file carries both.
  # shellcheck disable=SC2016  # the backticks are literal file content, not an expansion
  printf '%s\n' '# US008 preview fixture notes' '' \
    'Branch naming is in [the guide](project-management/docs/GIT-GUIDE.md#branch-naming).' '' \
    'Build each story with the `feature` skill.' > "$PROJECT/US008-FIXTURE-NOTES.md"
  PLANTS=(".claude/agents/house-reviewer.md" "US008-FIXTURE-NOTES.md")
fi
if [[ "$CASE" == "domain-report" ]]; then
  STAGING="code/src/django/config/settings/staging.py"
  [[ -f "$PROJECT/$STAGING" ]] || die "The generated project has no $STAGING to plant in."
  printf '\nSESSION_COOKIE_DOMAIN = "%s"\n' "$DOMAIN_PLANT_VALUE" >> "$PROJECT/$STAGING"
  PLANTS=("$STAGING")
fi
"${GIT_SCRATCH[@]}" -C "$PROJECT" add -A
"${GIT_SCRATCH[@]}" -C "$PROJECT" commit --quiet --no-verify -m "fixture: the story's wrapper and the case's plants"

# ── Prerequisites ────────────────────────────────────────────────────────────
grep -q '^_commit:' "$PROJECT/.copier-answers.yml" 2>/dev/null \
  || die "The generated project's .copier-answers.yml has no _commit: — the wrapper would refuse it."
[[ -z "$(git -C "$PROJECT" status --porcelain)" ]] \
  || die "The generated project is not clean after the fixture commit — the wrapper would refuse it."

# ── Record ───────────────────────────────────────────────────────────────────
bold "── Fixture record ──"
log "  template source:  $SOURCE"
log "  source HEAD:      $SOURCE_HEAD"
log "  story ref:        $STORY_DESC"
log "  copier:           $COPIER_VERSION (${REAL_COPIER[*]})"
log "  from ref:         $FROM_REF ($FROM_SHA)"
log "  target ref:       $TARGET_REF ${TARGET_SHA:+($TARGET_SHA)}"
log "  plants:           ${PLANTS[*]:-none}"
log "  prerequisites:    _commit: present · working tree clean"
log "  answers (.copier-answers.yml):"
sed 's/^/    /' "$PROJECT/.copier-answers.yml"
log ""

# ── Run the actual wrapper ───────────────────────────────────────────────────
bold "── bash $WRAPPER_REL --ref $TARGET_REF (from the generated root) ──"
set +e
(cd "$PROJECT" && PATH="$SHIM_DIR:$PATH" TMPDIR="$WRAP_TMP" \
  bash "$WRAPPER_REL" --ref "$TARGET_REF") >"$RUN_OUT" 2>&1
RUN_RC=$?
set -e
cat "$RUN_OUT"
log ""
bold "── Assertions ($CASE) — wrapper exit $RUN_RC ──"

count() { grep -cE -- "$1" "$RUN_OUT" || true; }
first_line() { { grep -nE -- "$1" "$RUN_OUT" || true; } | head -1 | cut -d: -f1; }
# shellcheck disable=SC2329  # invoked through check()
last_line() { { grep -nE -- "$1" "$RUN_OUT" || true; } | tail -1 | cut -d: -f1; }

REPORT_START='── What the update printed'
REPORT_END="── End of the update's output ──"
PREVIEW_ONLY='Preview only — your project is unchanged'
FAILED_BANNER='✗ The update failed on the copy'

# shellcheck disable=SC2329  # invoked through check()
nonempty_file() { [[ -s "$1" ]]; }
# shellcheck disable=SC2329  # invoked through check()
no_match() { ! grep -qE -- "$1" "$RUN_OUT"; }
check "the wrapper invoked Copier (shim recorded: $(head -1 "$COPIER_MARK" 2>/dev/null || printf 'nothing'))" \
  nonempty_file "$COPIER_MARK"
leftover="$(find "$WRAP_TMP" -mindepth 1 -maxdepth 1 -name 'template-update-*' | grep -c . || true)"
check "the wrapper's cleanup removed its scratch clone and log ($leftover left)" test "$leftover" -eq 0

REPORT_START_LINE=0
REPORT_END_LINE=0
# shellcheck disable=SC2329  # invoked through check()
in_order() { [[ -n "$1" && -n "$2" && -n "$3" && "$1" -lt "$2" && "$2" -lt "$3" ]]; }
assert_success_report() {
  local start end notice
  check "exit 0" test "$RUN_RC" -eq 0
  check "the report block printed exactly once" test "$(count "$REPORT_START")" -eq 1
  check "no failure tail" test "$(count "$FAILED_BANNER")" -eq 0
  start="$(first_line "$REPORT_START")"; end="$(first_line "$REPORT_END")"; notice="$(first_line "$PREVIEW_ONLY")"
  check "the report block ends before the preview-only notice (block ${start:-?}-${end:-?}, notice line ${notice:-absent})" \
    in_order "$start" "$end" "$notice"
  REPORT_START_LINE="${start:-0}"; REPORT_END_LINE="${end:-0}"
}
# A pattern's count, and whether every occurrence sits inside the report block.
# shellcheck disable=SC2329  # invoked through check()
count_in_block() { # pattern expected-count
  local n first last
  n="$(count "$1")"; first="$(first_line "$1")"; last="$(last_line "$1")"
  [[ "$n" -eq "$2" ]] || return 1
  [[ "$2" -eq 0 ]] && return 0
  [[ "${first:-0}" -gt "$REPORT_START_LINE" && "${last:-0}" -lt "$REPORT_END_LINE" ]]
}
in_report() { # label pattern expected-count
  check "$1 — expected $3 inside the report block, found $(count "$2")" count_in_block "$2" "$3"
}

case "$CASE" in
  shipped-advisories)
    assert_success_report
    in_report "v3.0.0 banner"                          '▸ v3\.0\.0 migration — agent definitions' 1
    in_report "v5.0.0 banner (keyed v4.0.0 and v5.0.0)" '▸ v5\.0\.0 migration — .*GIT-GUIDE' 2
    # shellcheck disable=SC2016  # the backticks are literal output, not an expansion
    in_report "v6.0.0 report-only advisory banner"     'ADVISORY — [0-9]+ backticked `feature`' 1
    in_report "v3.0.0 body names the planted agent"    '\.claude/agents/house-reviewer\.md +->' 1
    in_report "v3.0.0 guidance replayed in full"       'skill-conformance\.sh' 1
    in_report "v5.0.0 guidance replayed in full, twice" 'MIGRATION-GATES\.md' 2
    check "every advisory body names the planted notes file" test "$(count 'US008-FIXTURE-NOTES\.md:')" -ge 3
    ;;
  missing-ref)
    check "exit 2" test "$RUN_RC" -eq 2
    check "the failure tail printed exactly once" test "$(count "$FAILED_BANNER")" -eq 1
    check "no success report block" test "$(count "$REPORT_START")" -eq 0
    check "no preview-only notice" test "$(count "$PREVIEW_ONLY")" -eq 0
    check "not a pre-flight rejection" no_match 'Working tree is dirty|No \.copier-answers\.yml|Neither uvx nor copier'
    check "the tail names the missing ref (Copier's own diagnosis)" grep -q -- "$MISSING_REF" "$RUN_OUT"
    ;;
  domain-report)
    assert_success_report
    in_report "the state advisory names the settings file" 'staging\.py' 1
    check "the state advisory names the setting" test "$(count 'SESSION_COOKIE_DOMAIN')" -ge 1
    check "the planted value is never printed" test "$(count "$DOMAIN_PLANT_VALUE")" -eq 0
    ;;
  pending-key)
    assert_success_report
    in_report "no cutover notice while the entry is pending" "$CUTOVER_MARK" 0
    ;;
  release-crossing)
    assert_success_report
    in_report "the cutover notice, once, across the activated release" "$CUTOVER_MARK" 1
    ;;
  subsequent-update)
    assert_success_report
    in_report "no cutover notice on an update from at or above the release" "$CUTOVER_MARK" 0
    ;;
esac

log ""
if [[ $FAILS -eq 0 ]]; then
  bold "✓ $CASE — every expectation held."
  exit 0
fi
bold "✗ $CASE — $FAILS expectation(s) failed."
exit 1
