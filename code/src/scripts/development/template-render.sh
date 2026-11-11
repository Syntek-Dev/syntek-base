#!/usr/bin/env bash
#
# template-render.sh — Render a disposable project from this template, for a downstream check.
#
# TEMPLATE-ONLY. copier.yml excludes this file, so a generated project never receives it: it
# reads the template contract, which a generated project does not hold.
#
# Why it exists. Every check that has to be seen in a GENERATED project — a citation gate's
# whole-tree run, a seeded register, a rendered token — needs a project to run in, and until
# this script the only way to make one was a raw `copier copy`, outside the rule that every dev
# operation runs through a script under `code/src/scripts/`. This is that script.
#
# What it does:
#
#   1. SNAPSHOTS the template into a scratch clone outside the repository. By default the
#      snapshot is the WORKING TREE — tracked files as they are on disk, plus untracked files
#      that are not ignored, with deletions honoured — committed in the scratch clone, so an
#      uncommitted change can be rendered without a commit in this repository. `--ref` renders
#      a committed ref instead and ignores the working tree.
#   2. RENDERS it with `copier copy --defaults --vcs-ref=HEAD`, answering every question that
#      has no default (overridable with --slug / --data), so the run never prompts. The answers
#      are the CI generation job's own, and that job renders through this script, so there is
#      one set of answers rather than two that drift.
#   3. Optionally COMMITS the result in a fresh git repository (--git), because the citation
#      gate reads the tracked tree, and optionally RUNS that gate there (--check-references).
#
# Nothing in this repository is written, staged or committed. The scratch clone is removed on
# exit unless --keep-scratch.
#
# Output contract: progress goes to stderr; stdout carries exactly one line, the target path,
# and only on success — so `dir=$(bash .../template-render.sh --quiet)` works.
#
# Usage: template-render.sh [--target DIR] [--ref REF] [--slug SLUG] [--data KEY=VALUE]...
#                           [--skip-tasks] [--git] [--check-references] [--keep-scratch]
#                           [--quiet] [--self-test] [--help] [-- <extra copier args>]
#
# Exit codes:  0 = rendered (and, with --check-references, the gate exited 0)
#              1 = rendered, and the citation gate reported findings in the generated project
#              2 = script error — bad arguments, a failed render, or a gate that could not run
#
set -euo pipefail

# Every git call against this repository is a read, and `git status` would otherwise refresh the
# stat cache and rewrite .git/index. Optional locks off keeps the live index byte-for-byte
# untouched; the scratch clone's add and commit take their mandatory locks as ever.
export GIT_OPTIONAL_LOCKS=0
# A relative --target means the caller's directory, so it is resolved before any `cd`.
CALLER_PWD="$PWD"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd -P)"
DOCREF_REL="code/src/scripts/audits/doc-references.sh"

# A throwaway identity for the two commits this script makes, both outside the repository.
# `-c` rather than config writes, and hooks and signing off: a global hooksPath or
# commit.gpgsign must not turn a scratch commit into a prompt or a failure.
GIT_SCRATCH=(git -c user.name="template-render" -c user.email="template-render@example.invalid"
             -c commit.gpgsign=false -c core.hooksPath=/dev/null)

TARGET=""
TARGET_CREATED=false
REF=""
SKIP_TASKS=false
DO_GIT=false
CHECK_REFS=false
KEEP_SCRATCH=false
QUIET=false
SUCCESS=false
SCRATCH=""
COPIER_PID=""
declare -a COPIER_ARGS=()
# Answers as two parallel indexed arrays rather than an associative one: macOS ships bash 3.2,
# which has no `declare -A`, and nothing else in this script needs bash 4.
declare -a DATA_KEYS=()
declare -a DATA_VALUES=()

log()  { $QUIET || printf '%s\n' "$*" >&2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*" >&2; }
die()  { printf 'template-render.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
template-render.sh — Render a disposable project from this template (template-only)

Usage:
  template-render.sh                         Render the working tree into a fresh temp dir
  template-render.sh --ref HEAD              Render the last commit, ignoring local changes
  template-render.sh --ref v7.8.0            Render a tag or branch
  template-render.sh --git --check-references
                                             Render, commit it, run doc-references.sh there
  template-render.sh --data INCLUDE_MOBILE=true
                                             Override any copier answer
  dir=$(template-render.sh --quiet)          Capture the target path (stdout is the path only)

Options:
  --target DIR        Render into DIR — outside this repository, absent or empty
                      (default: a fresh mktemp -d, printed on success)
  --ref REF           Render this committed ref (default: the working tree, uncommitted and
                      untracked-but-not-ignored files included, snapshotted in a scratch clone)
  --slug SLUG         PROJECT_SLUG (default: derived by copier from PROJECT_NAME — ci-probe)
  --data KEY=VALUE    Override one answer; repeatable. Later wins
  --skip-tasks        Pass --skip-tasks to copier: no seeding from .copier/, no uv lock, no
                      git init. Faster, but the result is NOT what a real generation produces
  --git               git init (if the tasks did not) and commit the result, so a gate that
                      reads the tracked tree sees every file
  --check-references  Implies --git. Run code/src/scripts/audits/doc-references.sh, whole
                      tree, inside the generated project and exit with its verdict
  --keep-scratch      Keep the scratch clone and the copier log, and print where they are
  --quiet             Progress off; stdout still carries the target path
  --self-test         Prove the --target checks (relative, symlinked, inside the repo); renders nothing
  --help              Show this help
  --                  Everything after this is passed straight to copier copy

Default answers (each overridable with --data) — the CI generation job's, which renders
through this script (.github/workflows/audit-template.yml), and fixed, so a render is
reproducible on any day:
  PROJECT_NAME=CI Probe  ORG_NAME=CI Org  DEVELOPER_NAME=CI Runner
  DEVELOPER_EMAIL=ci@example.com  DATE=01/01/2027
  PROJECT_DESCRIPTION=<a fixed one-sentence brief>
  Every other question takes its copier.yml default (--defaults) — PROJECT_SLUG included,
  which copier derives from PROJECT_NAME (ci-probe).

Nothing in this repository is written, staged or committed.

Exit codes:
  0  rendered (and, with --check-references, the gate exited 0)
  1  rendered; the citation gate reported findings in the generated project
  2  script error — bad arguments, a failed render, or a gate that could not run
EOF
}

set_data() {
  local key="${1%%=*}" value="${1#*=}" i
  [[ "$1" == *=* && -n "$key" ]] || die "--data needs KEY=VALUE, got '$1'"
  for i in "${!DATA_KEYS[@]}"; do
    if [[ "${DATA_KEYS[$i]}" == "$key" ]]; then DATA_VALUES[i]="$value"; return; fi
  done
  DATA_KEYS+=("$key"); DATA_VALUES+=("$value")
}

get_data() {
  local i
  for i in "${!DATA_KEYS[@]}"; do
    [[ "${DATA_KEYS[$i]}" == "$1" ]] && { printf '%s' "${DATA_VALUES[$i]}"; return; }
  done
}

# The physical path a target names, or would name once created. The parent must exist: a typo
# in a parent directory is refused rather than created. No `realpath -m` — GNU-only.
# $2 is the directory a relative path is read against — the caller's, never this repository's.
# A target that exists is resolved whole, so a symlink to a directory inside the repository is
# seen for what it is; a symlink to nothing is refused, because copier would create its
# destination wherever it points.
physical_path() {
  local p="$1" base_dir="$2" parent base
  [[ "$p" == /* ]] || p="$base_dir/$p"
  if [[ -L "$p" && ! -d "$p" ]]; then
    die "--target is a symlink that does not point at a directory: $p"
  fi
  if [[ -d "$p" ]]; then
    (cd "$p" && pwd -P); return
  fi
  parent="$(dirname "$p")"; base="$(basename "$p")"
  [[ -d "$parent" ]] || die "--target's parent directory does not exist: $parent"
  printf '%s/%s\n' "$(cd "$parent" && pwd -P)" "$base"
}

# 0 when the physical path $1 is this repository or anything under it.
inside_repo() {
  case "$1/" in "$PROJECT_ROOT"/*) return 0 ;; esac
  return 1
}

# The --target checks, proved without rendering anything (--self-test). Every case is built in
# a scratch directory outside the repository; the symlink into the repository points at a
# directory that is always there (code/), so nothing in the repository is created.
self_test() {
  local st_dir fails=0 probes=0 got inside="$PROJECT_ROOT/code"
  st_dir="$(cd "$(mktemp -d -t template-render-selftest-XXXXXX)" && pwd -P)"
  mkdir -p "$st_dir/cwd"
  ln -s "$inside" "$st_dir/link-into-repo"
  ln -s "$st_dir/nowhere" "$st_dir/dangling"
  st() { # label expected actual
    probes=$((probes + 1))
    if [[ "$2" == "$3" ]]; then printf '  ✓ %s\n' "$1" >&2
    else printf '  ✗ %s: expected %s, got %s\n' "$1" "$2" "$3" >&2; fails=$((fails + 1)); fi
  }
  got="$(physical_path out "$st_dir/cwd" 2>/dev/null)" || got="refused"
  st "B-1 a relative target is read against the caller's directory" "$st_dir/cwd/out" "$got"
  got="$(physical_path ../rel-out "$st_dir/cwd" 2>/dev/null)" || got="refused"
  st "B-1 a ../ target is read against the caller's directory" "$st_dir/rel-out" "$got"
  got="$(physical_path "$st_dir/link-into-repo" "$st_dir/cwd" 2>/dev/null)" || got="refused"
  st "QA-B2 a symlink into the repository resolves to its target" "$inside" "$got"
  if inside_repo "$got"; then got=inside; else got=outside; fi
  st "QA-B2 ... and is refused as inside the repository" inside "$got"
  got="$( (physical_path "$st_dir/dangling" "$st_dir/cwd") 2>/dev/null)" && got="accepted" || got="refused"
  st "QA-B2 a symlink to nothing is refused" refused "$got"
  if inside_repo "$PROJECT_ROOT"; then got=inside; else got=outside; fi
  st "the repository root itself is inside" inside "$got"
  if inside_repo "$PROJECT_ROOT-sibling"; then got=inside; else got=outside; fi
  st "a sibling sharing the repository's name as a prefix is outside" outside "$got"
  rm -rf "$st_dir"
  if [[ $fails -eq 0 ]]; then
    printf '✓ Self-test passed — %s probes over the --target checks.\n' "$probes" >&2; return 0
  fi
  printf '✗ Self-test FAILED — %s of %s probes.\n' "$fails" "$probes" >&2; return 1
}

# shellcheck disable=SC2329  # invoked by `trap cleanup EXIT`, set once the target is validated
cleanup() {
  local rc=$?
  # A render still running is stopped and reaped BEFORE anything is removed: left alone, copier
  # goes on writing and re-creates the target this function has just deleted.
  # uvx runs copier as its child, so the children are signalled as well as the PID recorded.
  if [[ -n "$COPIER_PID" ]] && kill -0 "$COPIER_PID" 2>/dev/null; then
    pkill -TERM -P "$COPIER_PID" 2>/dev/null || true
    kill -TERM "$COPIER_PID" 2>/dev/null || true
    wait "$COPIER_PID" 2>/dev/null || true
  fi
  if [[ -n "$SCRATCH" && -d "$SCRATCH" ]]; then
    if $KEEP_SCRATCH; then
      log "  scratch kept: $SCRATCH"
    else
      rm -rf "$SCRATCH"
    fi
  fi
  # A temp dir this script made, for a render that never succeeded, is nobody's — remove it.
  # A target the caller named is left exactly as copier left it, and said so.
  if ! $SUCCESS && [[ -n "$TARGET" && -d "$TARGET" ]]; then
    if $TARGET_CREATED && ! $KEEP_SCRATCH; then
      rm -rf "$TARGET"
    else
      log "  partial render left at: $TARGET"
    fi
  fi
  exit "$rc"
}

# ── Defaults ──────────────────────────────────────────────────────────────────
# The questions copier.yml gives no default. These ARE the CI generation job's answers — that
# job renders through this script (.github/workflows/audit-template.yml), so there is one set.
# DATE is fixed, never today's: a render that depends on the day is not reproducible. The slug
# is left to copier, which derives `ci-probe` from the name — the value CI asserts.
set_data "PROJECT_NAME=CI Probe"
set_data "PROJECT_DESCRIPTION=A probe project generated by CI to verify that the template renders end to end."
set_data "ORG_NAME=CI Org"
set_data "DEVELOPER_NAME=CI Runner"
set_data "DEVELOPER_EMAIL=ci@example.com"
set_data "DATE=01/01/2027"
SELF_TEST=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)           [[ $# -ge 2 ]] || die "--target needs a value"; TARGET="$2"; shift 2 ;;
    --ref)              [[ $# -ge 2 ]] || die "--ref needs a value"; REF="$2"; shift 2 ;;
    --slug)             [[ $# -ge 2 ]] || die "--slug needs a value"; set_data "PROJECT_SLUG=$2"; shift 2 ;;
    --data)             [[ $# -ge 2 ]] || die "--data needs KEY=VALUE"; set_data "$2"; shift 2 ;;
    --skip-tasks)       SKIP_TASKS=true; shift ;;
    --git)              DO_GIT=true; shift ;;
    --check-references) CHECK_REFS=true; DO_GIT=true; shift ;;
    --keep-scratch)     KEEP_SCRATCH=true; shift ;;
    --quiet)            QUIET=true; shift ;;
    --self-test)        SELF_TEST=true; shift ;;
    --help|-h)          usage; exit 0 ;;
    --)                 shift; COPIER_ARGS=("$@"); break ;;
    *)                  die "Unknown option: $1. Use --help for usage." ;;
  esac
done

# ── Pre-flight ────────────────────────────────────────────────────────────────
# The target is resolved first, against the caller's directory: after the `cd` below a
# relative path would name somewhere inside, or beside, this repository instead.
if $SELF_TEST; then
  self_test; exit $?
fi
if [[ -n "$TARGET" ]]; then
  TARGET="$(physical_path "$TARGET" "$CALLER_PWD")"
fi
cd "$PROJECT_ROOT"
[[ -f copier.yml && -d .copier ]] \
  || die "No copier.yml and .copier/ here — this is a generated project, not the template. This script is template-only."
command -v git >/dev/null 2>&1 || die "git not found on PATH."
command -v tar >/dev/null 2>&1 || die "tar not found on PATH."
if command -v copier >/dev/null 2>&1; then
  COPIER_BIN=(copier)
elif command -v uvx >/dev/null 2>&1; then
  COPIER_BIN=(uvx copier)
else
  die "Neither copier nor uvx found on PATH."
fi

if [[ -n "$TARGET" ]]; then
  if [[ -e "$TARGET" ]]; then
    [[ -d "$TARGET" ]] || die "--target exists and is not a directory: $TARGET"
    [[ -z "$(ls -A "$TARGET")" ]] || die "--target is not empty: $TARGET — copier would merge into it."
  fi
else
  TARGET="$(cd "$(mktemp -d -t template-render-XXXXXX)" && pwd -P)"
  TARGET_CREATED=true
fi
inside_repo "$TARGET" && die "--target must be outside this repository: $TARGET"

trap cleanup EXIT
# A signal becomes an exit, so cleanup runs on INT, TERM and HUP as it does on EXIT.
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP

bold "▸ template-render.sh"
log "  template: $PROJECT_ROOT"
log "  target:   $TARGET"

# ── Snapshot ──────────────────────────────────────────────────────────────────
# A clone, never `cp -a`: a copied .git carries a stat cache that no longer matches the new
# inodes, and copier refuses a source it believes dirty. --no-hardlinks so nothing done in
# the clone can reach this repository's object store.
SCRATCH="$(mktemp -d -t template-render-scratch-XXXXXX)"
CLONE="$SCRATCH/template"
COPIER_LOG="$SCRATCH/copier.log"
git clone --quiet --no-hardlinks "$PROJECT_ROOT" "$CLONE" \
  || die "Could not clone the template into a scratch directory."

if [[ -n "$REF" ]]; then
  SHA="$(git rev-parse --verify --quiet "$REF^{commit}")" || die "--ref does not name a commit: $REF"
  # A branch, not a detached HEAD, so copier's own clone of the scratch checks out this commit.
  git -C "$CLONE" checkout --quiet -B template-render "$SHA" 2>/dev/null \
    || die "--ref $REF ($SHA) is not reachable from any branch or tag, so the clone does not hold it."
  log "  source:   ref $REF (${SHA:0:12}) — the working tree is ignored"
elif [[ -z "$(git status --porcelain)" ]]; then
  log "  source:   working tree — clean, identical to HEAD ($(git rev-parse --short=12 HEAD))"
else
  # Replace the clone's files with the working tree's: tracked files as they are on disk (a
  # deleted one is simply not copied, and `add -A` records the deletion) plus untracked files
  # that are not ignored. Tracked-but-ignored files stay tracked, because `add -A` updates
  # what the index already holds. tar keeps symlinks as symlinks, which _preserve_symlinks needs.
  find "$CLONE" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
  git ls-files -z --cached --others --exclude-standard --deduplicate \
    | while IFS= read -r -d '' f; do
        [[ -e "$f" || -L "$f" ]] && printf '%s\0' "$f"
      done \
    | tar --null -T - -cf - | tar -xf - -C "$CLONE"
  git -C "$CLONE" add -A
  CHANGED="$(git -C "$CLONE" diff --cached --name-only | grep -c . || true)"
  "${GIT_SCRATCH[@]}" -C "$CLONE" commit --quiet --no-verify \
    -m "template-render: working-tree snapshot of $(git rev-parse --short=12 HEAD)" \
    || die "Could not commit the working-tree snapshot in the scratch clone."
  log "  source:   working tree — $CHANGED path(s) differ from HEAD, committed in the scratch clone only"
fi

# ── Render ────────────────────────────────────────────────────────────────────
declare -a DATA_ARGS=()
for i in "${!DATA_KEYS[@]}"; do DATA_ARGS+=(--data "${DATA_KEYS[$i]}=${DATA_VALUES[$i]}"); done
declare -a COPY_ARGS=(copy --trust --defaults --vcs-ref=HEAD)
$SKIP_TASKS && COPY_ARGS+=(--skip-tasks)

SLUG_ANSWER="$(get_data PROJECT_SLUG || true)"
log "  answers:  PROJECT_NAME=$(get_data PROJECT_NAME)  PROJECT_SLUG=${SLUG_ANSWER:-<derived by copier>}$($SKIP_TASKS && printf '  (tasks skipped)')"
log "  rendering…"
# In the background and waited on, because bash defers a trapped signal until a FOREGROUND
# child exits — and by then copier has finished writing. `wait` returns at once.
# copier's own temporary clone goes under SCRATCH too: a copier stopped by a signal never
# removes it, and SCRATCH is removed on every exit.
mkdir -p "$SCRATCH/tmp"
set +e
TMPDIR="$SCRATCH/tmp" "${COPIER_BIN[@]}" "${COPY_ARGS[@]}" "${DATA_ARGS[@]}" \
  "${COPIER_ARGS[@]+"${COPIER_ARGS[@]}"}" "$CLONE" "$TARGET" >"$COPIER_LOG" 2>&1 &
COPIER_PID=$!
wait "$COPIER_PID"
RENDER_RC=$?
COPIER_PID=""
set -e
if [[ $RENDER_RC -ne 0 ]]; then
  bold "✗ copier exited $RENDER_RC — the template did not render."
  tail -25 "$COPIER_LOG" >&2
  # Only the failure the hint is about earns it: copier's own wording for a question
  # left with no answer under --defaults. Any other failure is shown as copier reported it.
  if grep -Eq 'Question "[A-Za-z_][A-Za-z0-9_]*" is required' "$COPIER_LOG"; then
    log ""
    log "  A question with no default halts a --defaults render. Supply it: --data KEY=value"
  fi
  exit 2
fi
log "  rendered: $(find "$TARGET" -path "$TARGET/.git" -prune -o ! -type d -print | grep -c . || true) files and links"

# ── Commit ────────────────────────────────────────────────────────────────────
if $DO_GIT; then
  [[ -d "$TARGET/.git" ]] || git -C "$TARGET" init --quiet --initial-branch=main
  git -C "$TARGET" add -A
  "${GIT_SCRATCH[@]}" -C "$TARGET" commit --quiet --no-verify --allow-empty \
    -m "chore: initial render from the template" \
    || die "Could not commit the rendered project in $TARGET."
  log "  git:      committed $(git -C "$TARGET" ls-files | grep -c . || true) tracked files on main"
fi

# ── Citation gate ─────────────────────────────────────────────────────────────
REFS_RC=0
if $CHECK_REFS; then
  [[ -f "$TARGET/$DOCREF_REL" ]] || die "The generated project has no $DOCREF_REL — nothing to run."
  bold "── doc-references.sh, whole tree, in the generated project ──"
  declare -a REFS_ARGS=()
  $QUIET && REFS_ARGS+=(--quiet)
  set +e
  ( cd "$TARGET" && bash "$DOCREF_REL" "${REFS_ARGS[@]+"${REFS_ARGS[@]}"}" ) >&2
  REFS_RC=$?
  set -e
  log "  doc-references.sh exited $REFS_RC"
  [[ $REFS_RC -le 1 ]] || { SUCCESS=true; die "doc-references.sh could not run in the generated project (exit $REFS_RC). Project kept at $TARGET"; }
fi

SUCCESS=true
$KEEP_SCRATCH && log "  copier log: $COPIER_LOG"
bold "✓ Rendered."
printf '%s\n' "$TARGET"
exit "$REFS_RC"
