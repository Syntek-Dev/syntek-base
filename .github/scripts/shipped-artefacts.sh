#!/usr/bin/env bash
#
# shipped-artefacts.sh — Verify a generated project receives EMPTY artefact trees.
#
#                        syntek-base commits its own handoffs, feature maps, research
#                        notes and lessons (17/08/2026) so they sync across devices.
#                        They are meaningless in a generated project — a note answering
#                        a question about the TEMPLATE, a map of the template's own
#                        decision frontier — so every one of them must be excluded at
#                        generation, leaving each tree with nothing but its documentation
#                        pair and its templates.
#
#                        WHY THIS SCRIPT EXISTS. Until 17/08/2026 those artefacts were
#                        untracked, and copier.yml's `_exclude` was a second guard behind
#                        a first: Copier's dirty-HEAD path runs `git add -A`, which
#                        honours .gitignore, so a hole in `_exclude` shipped nothing.
#                        Committing the artefacts removed that backstop. `_exclude` is now
#                        the ONLY guard, and a missing negation silently publishes this
#                        repository's internal notes into every generated project. This is
#                        the test that makes the loss visible.
#
#                        A DIRECTORY EXCLUSION DOES NOT PRUNE ITS CONTENTS, which is the
#                        specific trap. Copier walks with a flat recursive scantree and
#                        `continue`s on one entry at a time, and _render_file runs
#                        `parent.mkdir(parents=True)` — so a file whose parent directory
#                        was excluded still renders. Every pattern in copier.yml must
#                        match files recursively (`/**`). A reviewer reading
#                        `- /research` and calling it done is the regression this catches.
#
#                        Five checks:
#                          1. copier.yml carries the recursive exclusion for each tree.
#                          2. research/, handoffs/, learning/, questionnaires/ ship the
#                             documentation pair and NOTHING else.
#                          3. project-management/src/ ships only pairs, *TEMPLATE* files,
#                             and the named shipped content below.
#                          4. Every named shipped file is PRESENT — an allowlist fails by
#                             not shipping a new template file, and this is the reveal.
#                          5. No artefact-tree .gitignore leaked.
#
#                        4 is not redundant with 3. An allowlist has two failure modes and
#                        they point opposite ways: too loose ships a private note, too
#                        tight silently drops a template file a project needs. 3 catches
#                        the first, 4 the second.
#
#                        What it CANNOT check: whether a shipped template's CONTENT is
#                        right. Only that the file set is.
#
# SELF-TEST. --self-test plants a stray artefact in a copy of the generated tree and
#            deletes a named shipped file, asserting each is caught. A guard nobody has
#            seen fail is a guard nobody knows works. It reuses the caller's generated
#            tree rather than generating again — the generation is the expensive part and
#            [3/4] has already paid for it.
#
# Requirements: bash, find, grep. No network. Does NOT generate — the caller supplies a
#               tree that `copier copy` produced.
#
# Usage: shipped-artefacts.sh [--quiet] [--self-test] [--help] <generated-project-dir>...
#
# Exit codes:  0 = every artefact tree arrived empty
#              1 = an artefact leaked, a template file is missing, or the self-test no
#                  longer separates
#              2 = script error (bad arguments, or a self-test that could not run)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COPIER="$PROJECT_ROOT/copier.yml"

# The trees that ship their documentation pair and nothing else.
PAIR_ONLY_TREES=(research handoffs learning questionnaires)

# The tree that also ships templates and named content.
SRC_TREE="project-management/src"

# Shipped content under $SRC_TREE that carries no TEMPLATE in the name, in the two shapes
# copier.yml's `!` negations use. MIRRORING THE SHAPE IS THE POINT: an enumeration of every
# file drifts the moment a section .tex or an export script is added, and it drifted on
# this script's first run — six scripts were listed as five, and seven section .tex files
# as none. A glob rule cannot rot that way.
SHIPPED_GLOBS=(
  "00-ASSETS/scripts/*.sh"
  "06-BRAND-GUIDE/guide-build/*.py"
  "06-BRAND-GUIDE/guide-build/*.tex"
  "07-COMPONENTS/component-build/*.py"
  "07-COMPONENTS/component-build/*.tex"
)

# The singletons, named in copier.yml one by one and named here the same way.
NAMED_SHIPPED=(
  "08-WIREFRAMES/SHARED/wireframe.css"
  "09-GDPR/BREACH-NOTIFICATION.md"
  "09-GDPR/CONSENT-LAWFUL-BASIS.md"
  "09-GDPR/DATA-INVENTORY.md"
  "09-GDPR/DATA-SUBJECT-RIGHTS.md"
  "09-GDPR/RETENTION-DELETION.md"
  "09-GDPR/THIRD-PARTY-PROCESSORS.md"
  "17-TESTS/US000-MANUAL-TESTING.md"
  "17-TESTS/US000-TEST-STATUS.md"
  "22-INCIDENTS/INCIDENT-INDEX.md"
)

# Seeded into 01-FEATURE-MAPS by a _task, so it is legitimately present in a generated project
# despite not being template content under project-management/src/.
SEEDED=("01-FEATURE-MAPS/MAP-SCALE-PLANNING.md")

QUIET=false
SELF_TEST=false
TARGETS=()

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'shipped-artefacts.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
shipped-artefacts.sh — Verify a generated project receives empty artefact trees

Usage: shipped-artefacts.sh [--quiet] [--self-test] [--help] <generated-project-dir>...

  --quiet      Suppress progress output; print findings only
  --self-test  Prove the checks still fire: plant a stray artefact and delete a named
               template file in a copy of the tree, and assert each is caught
  --help       Show this message

Exit codes: 0 = every artefact tree arrived empty  1 = a leak, a missing template file,
or a self-test that no longer separates  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    -*)          die "unknown argument: $1" ;;
    *)           TARGETS+=("$1"); shift ;;
  esac
done

[[ ${#TARGETS[@]} -gt 0 ]] || die "no generated project directory given — this script asserts on a tree copier produced"
[[ -f "$COPIER" ]] || die "missing $COPIER"

FINDINGS=()
finding() { FINDINGS+=("$1"); }

# ── The checks, as one re-pointable unit ──────────────────────────────────────
#
# GEN is a global so --self-test can repoint it at a mutated copy and re-run the whole
# set, rather than re-implementing the checks against a fixture that would drift.
GEN=""

run_checks() {
  FINDINGS=()

  # ── 1. copier.yml carries the recursive exclusion ───────────────────────────
  #
  # Static, and deliberately independent of the generated tree: a tree that happens to
  # be clean because a file was absent from the template proves nothing about the rule.
  # `/**` and not `/` — see the header on directory pruning.
  local excluded tree
  excluded=$(awk '/^_exclude:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f && /^[[:space:]]*-/' "$COPIER" \
    | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's/^"//;s/"$//' || true)
  for tree in "${PAIR_ONLY_TREES[@]}" "$SRC_TREE"; do
    # questionnaires/ is excluded by its own nested .gitignore, not by a tree rule.
    [[ "$tree" == "questionnaires" ]] && continue
    grep -qxF "/$tree/**" <<< "$excluded" \
      || finding "copier.yml _exclude has no '/$tree/**' rule — a bare directory entry does not prune its contents"
  done

  # ── 2 and 5. The pair-only trees ────────────────────────────────────────────
  local f rel
  for tree in "${PAIR_ONLY_TREES[@]}"; do
    [[ -d "$GEN/$tree" ]] || { finding "$tree/ is missing from the generated project — it must ship documented and ready to use"; continue; }
    while IFS= read -r f; do
      rel="${f#"$GEN/$tree/"}"
      case "$rel" in
        CONTEXT.md|CLAUDE.md) ;;
        .gitignore) finding "$tree/.gitignore leaked into the generated project — it is a syntek-base-only override" ;;
        *)          finding "$tree/$rel leaked into the generated project — this tree ships its documentation pair only" ;;
      esac
    done < <(find "$GEN/$tree" -type f 2>/dev/null | sort)
  done

  # ── 3. project-management/src/ ──────────────────────────────────────────────
  if [[ ! -d "$GEN/$SRC_TREE" ]]; then
    finding "$SRC_TREE/ is missing from the generated project"
  else
    local base allowed n
    while IFS= read -r f; do
      rel="${f#"$GEN/$SRC_TREE/"}"
      base="$(basename "$rel")"
      # The documentation pair every directory ships, and every per-story template.
      [[ "$base" == "CONTEXT.md" || "$base" == "CLAUDE.md" ]] && continue
      case "$base" in *TEMPLATE*) continue ;; esac
      allowed=false
      for n in "${NAMED_SHIPPED[@]}" "${SEEDED[@]}"; do
        [[ "$rel" == "$n" ]] && { allowed=true; break; }
      done
      # shellcheck disable=SC2053  # the right-hand side is a glob on purpose
      if ! $allowed; then
        for n in "${SHIPPED_GLOBS[@]}"; do
          [[ "$rel" == $n ]] && { allowed=true; break; }
        done
      fi
      $allowed || finding "$SRC_TREE/$rel leaked into the generated project — it is a syntek-base artefact, not template content"
    done < <(find "$GEN/$SRC_TREE" -type f 2>/dev/null | sort)

    # ── 4. Every shipped file and glob is present ─────────────────────────────
    #
    # The other half of an allowlist. Too tight is the quieter failure: a project simply
    # never receives a template file, and nobody notices until they look for it. A glob
    # is asserted non-empty rather than enumerated — dropping its `!` negation in
    # copier.yml empties it, which is the regression this catches.
    for n in "${NAMED_SHIPPED[@]}"; do
      [[ -f "$GEN/$SRC_TREE/$n" ]] \
        || finding "$SRC_TREE/$n did NOT ship — the allowlist is too tight; add a '!' negation for it in copier.yml"
    done
    for n in "${SHIPPED_GLOBS[@]}"; do
      # shellcheck disable=SC2086  # word splitting is what makes the glob expand
      set -- $GEN/$SRC_TREE/$n
      [[ -f "$1" ]] \
        || finding "$SRC_TREE/$n matched nothing — the allowlist is too tight; check its '!' negation in copier.yml"
    done
  fi
}

# ── Self-test ─────────────────────────────────────────────────────────────────
ST_FAILS=0
ST_PROBES=0

probe() { # $1 = label, $2 = a substring the single expected finding must contain
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  if [[ ${#FINDINGS[@]} -eq 1 ]] && [[ "${FINDINGS[0]}" == *"$2"* ]]; then
    log "  ✓ $1"
  else
    ST_FAILS=$((ST_FAILS + 1))
    printf '\033[31m  ✗ %s produced %d finding(s): %s\033[0m\n' \
      "$1" "${#FINDINGS[@]}" "$(printf '%s; ' "${FINDINGS[@]:-(none)}")"
  fi
}

self_test() {
  local tmpdir real_gen
  bold "▸ shipped-artefacts.sh --self-test"
  log  ""
  command -v mktemp >/dev/null 2>&1 || die "mktemp unavailable — refusing to report a proof that never ran"

  GEN="${TARGETS[0]}"
  real_gen="$GEN"

  run_checks
  if [[ ${#FINDINGS[@]} -ne 0 ]]; then
    printf '\033[31m  ✗ the real generated tree already fails — a mutation proof on a broken baseline means nothing\033[0m\n' >&2
    printf '    %s\n' "${FINDINGS[@]}" >&2
    exit 2
  fi
  log "  ✓ the real generated tree passes — the baseline is clean"

  tmpdir=$(mktemp -d) || die "could not create a temporary directory"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmpdir'; GEN='$real_gen'" RETURN
  cp -a "$real_gen" "$tmpdir/gen"
  GEN="$tmpdir/gen"

  # ── 2. A research note leaks ────────────────────────────────────────────────
  printf '# A note about the template\n' > "$GEN/research/SOME-NOTE.md"
  probe "check 2 fires when a research note leaks" "research/SOME-NOTE.md leaked"
  rm -f "$GEN/research/SOME-NOTE.md"

  # ── 3. A feature map leaks ──────────────────────────────────────────────────
  printf '# A map of the template\n' > "$GEN/$SRC_TREE/01-FEATURE-MAPS/MAP-SOMETHING.md"
  probe "check 3 fires when a feature map leaks" "01-FEATURE-MAPS/MAP-SOMETHING.md leaked"
  rm -f "$GEN/$SRC_TREE/01-FEATURE-MAPS/MAP-SOMETHING.md"

  # ── 4. A named template file is missing ─────────────────────────────────────
  mv "$GEN/$SRC_TREE/${NAMED_SHIPPED[0]}" "$tmpdir/held"
  probe "check 4 fires when a named template file does not ship" "${NAMED_SHIPPED[0]} did NOT ship"
  mv "$tmpdir/held" "$GEN/$SRC_TREE/${NAMED_SHIPPED[0]}"

  # ── 5. A nested .gitignore leaks ────────────────────────────────────────────
  printf '*\n' > "$GEN/questionnaires/.gitignore"
  probe "check 5 fires when an artefact-tree .gitignore leaks" "questionnaires/.gitignore leaked"
  rm -f "$GEN/questionnaires/.gitignore"

  # ── 1. The recursive exclusion is dropped ───────────────────────────────────
  #
  # Repoints COPIER, not GEN — check 1 is static and reads copier.yml alone.
  local real_copier="$COPIER"
  grep -vxF '  - /research/**' "$real_copier" > "$tmpdir/no-rule.yml"
  COPIER="$tmpdir/no-rule.yml"
  probe "check 1 fires when a tree's recursive exclusion is dropped" "no '/research/**' rule"
  COPIER="$real_copier"

  GEN="$real_gen"
  run_checks

  log ""
  if [[ "$ST_FAILS" -eq 0 ]]; then
    bold "✓ Self-test passed — $ST_PROBES probes: every check fires on its own mutation."
    log ""
    return 0
  fi
  log "  the detector no longer separates a clean generation from a leaking one —"
  log "  fix the check, never the expectation."
  log ""
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

bold "▸ shipped-artefacts.sh"
log  "  checking the artefact trees a generated project receives…"
log  ""

STATUS=0
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || die "not a directory: $target"
  GEN="$target"
  run_checks
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ $target — every artefact tree arrived empty"
  else
    bold "✗ $target — ${#FINDINGS[@]} finding(s):"
    printf '  · %s\n' "${FINDINGS[@]}"
    STATUS=1
  fi
done

log ""
if [[ "$STATUS" -eq 0 ]]; then
  bold "✓ A generated project receives empty artefact trees."
  exit 0
fi

log "  syntek-base commits its own handoffs, maps, notes and lessons so they sync across"
log "  devices; copier.yml's _exclude is the ONLY thing keeping them out of a generated"
log "  project. Fix the allowlist there — and remember a bare directory entry does not"
log "  prune its contents, so every pattern needs '/**'."
exit 1
