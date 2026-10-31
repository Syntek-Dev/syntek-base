#!/usr/bin/env bash
#
# shipped-boards.sh — Verify a generated project receives EMPTY, current PM boards.
#
#                    `pm-board.sh` writes a committed `*-BOARD.md` into each of five register
#                    folders. In syntek-base those boards list syntek-base's own maps,
#                    stories, sprints and plans — the same carrier problem
#                    shipped-registers.sh gates for GAPS.md and DEFERRED.md: a row about this
#                    template read in a generated project as that project's own backlog.
#
#                    So the live boards never travel (`/project-management/src/**` is
#                    excluded and nothing re-includes a board), and a generated project is
#                    seeded from `.copier/<X>-BOARD.md` by the copy-gated `_tasks` entry. A
#                    seed is correct when it is EXACTLY what `pm-board.sh --write` renders for
#                    a project holding nothing but the other seeds — today the one seeded
#                    `MAP-SCALE-PLANNING.md`. That makes the feature-maps board one row and
#                    the other four rowless, and makes the new project's first
#                    `pm-board.sh --check` green rather than stale on day one.
#
#                    Five checks:
#                      1. No copier.yml `_exclude` negation re-includes a `*-BOARD.md`.
#                      2. `_tasks` moves each of the five seeds into its folder.
#                      3. Each seed exists.
#                      4. Each seed is byte-identical to the board `pm-board.sh` renders for
#                         the seed-only tree — which proves it carries none of syntek-base's
#                         rows, and that it is not stale against the generator.
#                      5. .github/scripts/shipped-artefacts.sh lists each landed board in
#                         `SEEDED`, so its leak check admits what this seeds.
#
#                    Numbers are stable identifiers. Append, never renumber.
#
# SELF-TEST. --self-test mutates a copy of each input — re-includes a board, drops a `_tasks`
#            move, removes a seed, adds a row to a seed, drops a `SEEDED` entry — and asserts
#            each check catches its own, exactly once.
#
# --fix      Re-render the five seeds from the generator. Run it after changing how
#            pm-board.sh renders a board, then review the diff — never to silence check 4 on
#            a seed that has picked up rows.
#
# Requirements: python3, awk, grep. No network.
#
# Usage: shipped-boards.sh [--quiet] [--self-test] [--fix] [--help]
#
# Exit codes:  0 = a generated project receives current, empty boards
#              1 = it does not, or the self-test no longer separates
#              2 = script error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

COPIER="$PROJECT_ROOT/copier.yml"
SEED_DIR="$PROJECT_ROOT/.copier"
ARTEFACTS="$PROJECT_ROOT/.github/scripts/shipped-artefacts.sh"
PM_BOARD="$PROJECT_ROOT/project-management/src/00-ASSETS/scripts/pm-board.sh"
MAP_SEED="$PROJECT_ROOT/.copier/MAP-SCALE-PLANNING.md"

# folder|board — the five registers, in board order.
BOARDS=(
  "01-FEATURE-MAPS|FEATURE-MAPS-BOARD.md"
  "02-STORIES|STORIES-BOARD.md"
  "03-SPRINTS|SPRINTS-BOARD.md"
  "16-SPRINT-PLANS|SPRINT-PLANS-BOARD.md"
  "17-STORY-PLANS|STORY-PLANS-BOARD.md"
)

QUIET=false
SELF_TEST=false
FIX=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'shipped-boards.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --fix)       FIX=true; shift ;;
    --help|-h)   sed -n '2,46p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT"
[[ -f "$COPIER" ]] || die "missing $COPIER"
[[ -f "$PM_BOARD" ]] || die "missing $PM_BOARD — the generator the seeds are checked against"
[[ -f "$MAP_SEED" ]] || die "missing $MAP_SEED — the seed-only tree cannot be built"
command -v python3 >/dev/null 2>&1 || die "python3 is required"

RENDER_DIR=""
cleanup() { [[ -n "$RENDER_DIR" ]] && rm -rf "$RENDER_DIR"; }
trap cleanup EXIT

# Render the boards a seed-only project would get, once — the generator is not under test.
render() {
  RENDER_DIR=$(mktemp -d) || die "could not create a temporary directory"
  local f
  for b in "${BOARDS[@]}"; do mkdir -p "$RENDER_DIR/project-management/src/${b%%|*}"; done
  cp "$MAP_SEED" "$RENDER_DIR/project-management/src/01-FEATURE-MAPS/"
  bash "$PM_BOARD" --write --root "$RENDER_DIR" --quiet >/dev/null \
    || die "pm-board.sh could not render the seed-only tree"
  for b in "${BOARDS[@]}"; do
    f="$RENDER_DIR/project-management/src/${b%%|*}/${b##*|}"
    [[ -f "$f" ]] || die "pm-board.sh rendered no ${b##*|}"
  done
}

FINDINGS=()
finding() { FINDINGS+=("$1"); }

run_checks() {
  FINDINGS=()
  local excluded tasks folder board seed

  # ── 1. Nothing re-includes a board ───────────────────────────────────────────
  excluded=$(awk '/^_exclude:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f && /^[[:space:]]*-/' "$COPIER" \
    | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's/^"//;s/"$//' || true)
  while read -r e; do
    [[ -z "$e" ]] && continue
    finding "copier.yml _exclude re-includes a board ($e) — syntek-base's own rows would ship"
  done < <(grep -E '^!.*BOARD' <<< "$excluded" || true)

  tasks=$(awk '/^_tasks:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f' "$COPIER" || true)
  for b in "${BOARDS[@]}"; do
    folder="${b%%|*}"; board="${b##*|}"; seed="$SEED_DIR/$board"

    # ── 2. Wired ──────────────────────────────────────────────────────────────
    grep -qF "mv .copier/$board project-management/src/$folder/$board" <<< "$tasks" \
      || finding "copier.yml _tasks does not move .copier/$board into $folder/ — a generated project gets no board"

    # ── 3. Present ────────────────────────────────────────────────────────────
    if [[ ! -f "$seed" ]]; then
      finding "missing .copier/$board — nothing to seed $folder/$board with"
      continue
    fi

    # ── 4. Exactly the seed-only render ───────────────────────────────────────
    cmp -s "$seed" "$RENDER_DIR/project-management/src/$folder/$board" \
      || finding ".copier/$board differs from what pm-board.sh renders for a seed-only project — it carries rows, or is stale (shipped-boards.sh --fix, then review)"

    # ── 5. Admitted by the artefact leak check ────────────────────────────────
    grep -qF "\"$folder/$board\"" "$ARTEFACTS" \
      || finding "shipped-artefacts.sh SEEDED does not list $folder/$board — its leak check would flag the seeded board"
  done
}

ST_FAILS=0
ST_PROBES=0
probe() {
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
  local tmp real_copier="$COPIER" real_seeds="$SEED_DIR" real_art="$ARTEFACTS"
  bold "▸ shipped-boards.sh --self-test"
  log  ""
  tmp=$(mktemp -d) || die "could not create a temporary directory"

  run_checks
  if [[ ${#FINDINGS[@]} -ne 0 ]]; then
    printf '\033[31m  ✗ the real inputs already fail — a mutation proof on a broken baseline means nothing\033[0m\n' >&2
    printf '    %s\n' "${FINDINGS[@]}" >&2
    rm -rf "$tmp"; exit 2
  fi
  log "  ✓ the real inputs pass — the baseline is clean"

  # 1. Re-include a board.
  awk '{print} /^_exclude:/{print "  - \"!/project-management/src/02-STORIES/STORIES-BOARD.md\""}' \
    "$real_copier" > "$tmp/reinclude.yml"
  COPIER="$tmp/reinclude.yml"; probe "check 1 fires when a board is re-included" "re-includes a board"
  COPIER="$real_copier"

  # 2. Drop a _tasks move.
  grep -vF "mv .copier/SPRINTS-BOARD.md" "$real_copier" > "$tmp/no-move.yml"
  COPIER="$tmp/no-move.yml"; probe "check 2 fires when a _tasks move is dropped" "does not move .copier/SPRINTS-BOARD.md"
  COPIER="$real_copier"

  # 3 and 4 work on a copy of the seed directory.
  mkdir -p "$tmp/seeds"; cp "$real_seeds"/*-BOARD.md "$tmp/seeds/"
  SEED_DIR="$tmp/seeds"
  rm "$tmp/seeds/STORY-PLANS-BOARD.md"
  probe "check 3 fires when a seed is missing" "missing .copier/STORY-PLANS-BOARD.md"
  cp "$real_seeds/STORY-PLANS-BOARD.md" "$tmp/seeds/"
  printf '\n| US001 | A template story | Open | [US001.md](US001.md) |\n' >> "$tmp/seeds/STORIES-BOARD.md"
  probe "check 4 fires when a seed carries a row" ".copier/STORIES-BOARD.md differs"
  SEED_DIR="$real_seeds"

  # 5. Drop a SEEDED entry.
  sed 's#"16-SPRINT-PLANS/SPRINT-PLANS-BOARD.md"##' "$real_art" > "$tmp/artefacts.sh"
  ARTEFACTS="$tmp/artefacts.sh"; probe "check 5 fires when SEEDED omits a board" "SEEDED does not list 16-SPRINT-PLANS"
  ARTEFACTS="$real_art"

  rm -rf "$tmp"
  run_checks
  log ""
  if [[ "$ST_FAILS" -eq 0 ]]; then
    bold "✓ Self-test passed — $ST_PROBES probes: every check fires on its own mutation."
    return 0
  fi
  log "  the detector no longer separates a clean seed from a polluted one —"
  log "  fix the check, never the expectation."
  return 1
}

render

if $FIX; then
  for b in "${BOARDS[@]}"; do
    cp "$RENDER_DIR/project-management/src/${b%%|*}/${b##*|}" "$SEED_DIR/${b##*|}"
    log "  wrote .copier/${b##*|}"
  done
fi

if $SELF_TEST; then
  self_test
  exit $?
fi

bold "▸ shipped-boards.sh"
log  "  checking the PM boards a generated project receives…"
log  ""
run_checks
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  bold "✓ A generated project receives current, empty PM boards."
  exit 0
fi
bold "✗ ${#FINDINGS[@]} finding(s):"
printf '  · %s\n' "${FINDINGS[@]}"
exit 1
