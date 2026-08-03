#!/usr/bin/env bash
#
# template-update.sh — Preview a template update before it touches your project.
#
# `copier update` merges the template's changes into your working tree in place.
# Where it collides with your edits you get conflict markers, which are loud and
# obvious. The dangerous case is the quiet one: when a directory is renumbered or
# moved, Copier relocates the scaffolding it owns and deletes the old path, while
# every file YOU wrote stays behind — no conflict, no error, update reports
# success, and the tooling now points at an empty folder next door.
#
# So this runs the update against a throwaway copy first, and tells you three
# things before you commit to anything:
#
#   1. what changes
#   2. what is deleted
#   3. what would be ORPHANED — your artefacts left in a folder nothing references
#
# Default is preview only. Nothing touches your project until --apply.
#
# Usage: template-update.sh [--apply] [--ref REF] [--keep-scratch] [--help]
#                          [-- <extra copier args>]
#
# Exit codes:  0 = preview clean / applied   1 = orphans predicted   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
ORPHAN_AUDIT="$PROJECT_ROOT/code/src/scripts/audits/template-orphans.sh"

APPLY=false
TARGET_REF=""
KEEP_SCRATCH=false
FORCE_ORPHANS=false
declare -a COPIER_ARGS=()

log()  { printf '%s\n' "$*"; }
die()  { printf 'template-update.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
template-update.sh — Preview a template update before it touches your project

Usage:
  template-update.sh                        Preview against the latest template tag
  template-update.sh --ref v2.1.1           Preview against a specific ref
  template-update.sh --apply                Apply, after the same preview
  template-update.sh -- --data KEY=value    Pass extra arguments to copier

Options:
  --apply           Apply the update to this project after previewing
  --force-orphans   Apply even though orphans are predicted — only with --apply,
                    and only when you have already planned where each file moves
  --ref REF         Template ref to update to (default: copier's own default)
  --keep-scratch    Leave the scratch copy on disk for inspection
  --help            Show this help
  --                Everything after this is passed straight to copier

Why preview:
  A new question with no default will halt an unattended update — pass it through
  with `-- --data KEY=value`. And a renumbered directory strands your artefacts
  silently; this predicts that before it happens, which `copier update` will not.

Exit codes:
  0  preview clean, or applied successfully
  1  orphans predicted — do not apply until they are accounted for
  2  script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)         APPLY=true; shift ;;
    --force-orphans) FORCE_ORPHANS=true; shift ;;
    --ref)           [[ $# -ge 2 ]] || die "--ref needs a value"; TARGET_REF="$2"; shift 2 ;;
    --keep-scratch)  KEEP_SCRATCH=true; shift ;;
    --help|-h)      usage; exit 0 ;;
    --)             shift; COPIER_ARGS=("$@"); break ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

# ── Pre-flight ────────────────────────────────────────────────────────────────
bold "▸ template-update.sh"

[[ -f .copier-answers.yml ]] || die "No .copier-answers.yml — this project was not generated from a template."
command -v uvx >/dev/null 2>&1 || command -v copier >/dev/null 2>&1 || die "Neither uvx nor copier found on PATH."
command -v git  >/dev/null 2>&1 || die "git not found on PATH."

if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
  die "Working tree is dirty. Commit or stash first — an update you cannot 'git checkout .' out of is not recoverable."
fi

CURRENT_REF="$(awk '/^_commit:/ {print $2}' .copier-answers.yml)"
log "  current template ref: ${CURRENT_REF:-unknown}"
log "  target ref:           ${TARGET_REF:-<copier default: latest tag>}"
log ""

COPIER_BIN=(copier)
command -v copier >/dev/null 2>&1 || COPIER_BIN=(uvx copier)

# ── Scratch copy ──────────────────────────────────────────────────────────────
SCRATCH="$(mktemp -d -t template-update-XXXXXX)"
# The log lives OUTSIDE the scratch tree. A redirect creates its file before the
# command runs, so a log inside the clone would be an untracked file at the moment
# copier checks — and copier refuses to update a dirty destination.
UPDATE_LOG="$(mktemp -t template-update-log-XXXXXX)"
cleanup() { $KEEP_SCRATCH || rm -rf "$SCRATCH"; rm -f "$UPDATE_LOG"; }
trap cleanup EXIT

log "  cloning project to a scratch directory…"
# A clone, not `cp -a`. Copying .git carries a stat-cache that no longer matches the
# copied inodes, so git reports the copy as dirty and copier refuses to run on it.
# A clone gives a pristine index — and the committed state is the right thing to
# preview against anyway, which is why a dirty tree was rejected above.
git clone --quiet --no-hardlinks "$PROJECT_ROOT" "$SCRATCH" \
  || die "Could not clone the project into a scratch directory."

# ── Dry run ───────────────────────────────────────────────────────────────────
log "  running the update against the copy (your project is untouched)…"
log ""

# --defaults is forced here and only here: a preview has no terminal, so any question
# copier would prompt on aborts the run. It takes the recorded answer for existing
# questions and the declared default for new ones; anything with no default must come
# through as `-- --data KEY=value`. The apply below deliberately does NOT force it, so
# an interactive apply can still prompt.
set +e
( cd "$SCRATCH" && "${COPIER_BIN[@]}" update --trust --defaults ${TARGET_REF:+--vcs-ref="$TARGET_REF"} \
    --conflict inline "${COPIER_ARGS[@]+"${COPIER_ARGS[@]}"}" ) >"$UPDATE_LOG" 2>&1
UPDATE_RC=$?
set -e

if [[ $UPDATE_RC -ne 0 ]]; then
  bold "✗ The update failed on the copy — so it would have failed on your project."
  log ""
  tail -20 "$UPDATE_LOG"
  log ""
  log "  A question with no default halts an unattended preview. Supply it and retry:"
  log "    bash code/src/scripts/development/template-update.sh -- --data KEY=value"
  log ""
  log "  This is a real finding, not a quirk of the preview: any automated caller of"
  log "  this template hits the same wall until the answer is supplied."
  exit 2
fi

# ── What changed ──────────────────────────────────────────────────────────────
bold "── What this update does ──"
CHANGED=$(cd "$SCRATCH" && git status --porcelain | grep -c '^ M\|^M ' || true)
DELETED=$(cd "$SCRATCH" && git status --porcelain | grep -c '^ D\|^D ' || true)
ADDED=$(cd "$SCRATCH" && git status --porcelain -uall | grep -c '^??' || true)
# `|| true` is load-bearing: grep exits 1 when it matches nothing, and under
# `set -o pipefail` that failure propagates out of the whole pipeline and, with
# `set -e`, kills the script at exactly the moment there is good news to report.
CONFLICTS=$( { grep -rl '^<<<<<<< ' "$SCRATCH" --exclude-dir=.git 2>/dev/null || true; } | wc -l | tr -d ' ')

log "  modified:  $CHANGED"
log "  deleted:   $DELETED"
log "  added:     $ADDED"
log "  conflicts: $CONFLICTS"
log ""

if [[ "$CONFLICTS" -gt 0 ]]; then
  log "  Files that would carry conflict markers:"
  grep -rl '^<<<<<<< ' "$SCRATCH" --exclude-dir=.git 2>/dev/null | sed "s|$SCRATCH/|    |" | head -20
  log ""
  log "  Conflicts are the loud failure and they are fine — you resolve them by hand."
  log ""
fi

# ── The quiet failure ─────────────────────────────────────────────────────────
bold "── Would anything be orphaned? ──"
log ""

ORPHAN_RC=0
if [[ -x "$ORPHAN_AUDIT" ]]; then
  bash "$ORPHAN_AUDIT" --path "$SCRATCH/project-management/src" || ORPHAN_RC=$?
else
  log "  (orphan audit not found at $ORPHAN_AUDIT — skipped)"
fi

log ""
if [[ $ORPHAN_RC -ne 0 ]]; then
  bold "✗ This update would strand your work."
  log ""
  log "  Those files sit in directories the new template no longer defines. Copier"
  log "  will not move them, will not warn you, and the update will report success."
  log ""
  log "  Before applying: note where each belongs under the new numbering, apply,"
  log "  then move them and re-run the orphan audit until it is clean."
  log ""
  if $APPLY && ! $FORCE_ORPHANS; then
    die "Refusing to --apply while orphans are predicted. Plan the moves, then re-run with --apply --force-orphans."
  fi
  if $APPLY && $FORCE_ORPHANS; then
    log "  --force-orphans given: applying anyway. Move the files listed above straight"
    log "  afterwards, and do not commit until the orphan audit is clean."
    log ""
  else
    exit 1
  fi
fi

bold "✓ No orphans predicted."
log ""

# ── Apply ─────────────────────────────────────────────────────────────────────
if ! $APPLY; then
  log "  Preview only — your project is unchanged."
  log "  To apply:  bash code/src/scripts/development/template-update.sh --apply"
  exit 0
fi

bold "── Applying to your project ──"
"${COPIER_BIN[@]}" update --trust ${TARGET_REF:+--vcs-ref="$TARGET_REF"} \
  --conflict inline "${COPIER_ARGS[@]+"${COPIER_ARGS[@]}"}"

log ""
bold "✓ Applied."
log ""
log "  Next:"
log "    git diff                                                  # read it"
log "    bash code/src/scripts/audits/template-orphans.sh          # confirm clean"
log "    git commit -m 'chore(template): update from <template>'"
