#!/usr/bin/env bash
# SC2016: the self-test writes copier.yml task lines holding shell text ($PWD) that copier, not
# this shell, would expand, so they are single-quoted on purpose.
# shellcheck disable=SC2016
#
# shipped-boards.sh — Verify a generated project receives EMPTY, current PM boards.
#
#                    `pm-board.sh` writes a committed `*-BOARD.md` into each of eight register
#                    folders. In syntek-base those boards list syntek-base's own maps,
#                    stories, sprints, plans, decisions, findings and bugs — the same carrier problem
#                    shipped-registers.sh gates for GAPS.md and DEFERRED.md: a row about this
#                    template read in a generated project as that project's own backlog.
#
#                    So the live boards never travel (`/project-management/src/**` is
#                    excluded and nothing re-includes a board), and a generated project is
#                    seeded from `.copier/<X>-BOARD.md` by the copy-gated `_tasks` entry. A
#                    seed is correct when it is EXACTLY what `pm-board.sh --write` renders for
#                    a project holding nothing but the other seeds — today the one seeded
#                    `MAP-SCALE-PLANNING.md`. That makes the feature-maps board one row and
#                    the other seven rowless, and makes the new project's first
#                    `pm-board.sh --check` green rather than stale on day one.
#
#                    Five checks:
#                      1. No copier.yml `_exclude` negation re-includes a `*-BOARD.md`: each
#                         negation, unquoted, comment and block tags stripped, is matched as a
#                         glob against the eight landed board paths, not searched for a name —
#                         under gitignore's rules: a slash-less pattern matches a component at
#                         any depth, and a trailing slash re-includes the folder below it.
#                      2. The copy-gated `_tasks` entry — the one whose `when:` tests the copy
#                         operation and which carries the README move — moves each of the
#                         eight seeds into its folder, as a step of its DECODED command split at
#                         `&&` that is exactly the mv, and holds no step but seed moves and the
#                         closing `rmdir` (an echoed, commented-out or folded-into move is not
#                         one; round 9, 21/11/2026); and
#                         no other `_tasks` or `_migrations` entry names a board seed at all —
#                         by any command, quoted or not, behind a path prefix (`./`, `$PWD/`) or
#                         an `=`, `,` or `:` (`F=…`, `if=…`, `--dir=…`, a list), by a glob
#                         matching it, or by the bare .copier directory holding it (the one
#                         exemption: the migration whose whole command is `rm -rf .copier`).
#                         Both lists are read through copier-commands.py first, which reads
#                         copier.yml as one document of plain top-level keys — anything else is
#                         refused, as one finding: a quoted or escaped key, a `?` key, a `---`
#                         or `...` marker, a `%` directive, a `!` tag (`!include`), a `<<:`
#                         merge, a repeated key (round 9, 21/11/2026; check 1's `_exclude`
#                         reading rests on the same refusal) — DECODES every YAML scalar as
#                         copier does (a double-quoted `\x2e`, `''`, line folding, block
#                         chomping) and refuses — as a finding — an entry it cannot read: a key
#                         repeated in one entry (two `when:`), a flow collection, an anchor,
#                         alias or tag, an unknown escape. Each word is
#                         then read with `$'…'` quoting, quotes and backslashes removed, whole,
#                         as the spans an `=`, `,` or `:` bounds, and (a word opening with one
#                         `-`) from each later `.`, for a short option's glued value
#                         (`-C.copier`) — each as a path: `//` and `/./` collapse, a `..` cancels
#                         the component before it, a component opening with `.` names .copier
#                         when it matches it as a glob (`.cop?er`, `.c*r`, `.[c]opier`), and a
#                         `{A,B}` brace expansion is either alternative. One in any other entry
#                         would run on every update and overwrite the project's own board.
#                         WHAT IT DOES NOT READ (round 8, 21/11/2026): check 2 reads the literal
#                         words left after YAML decoding and shell quote removal, and nothing
#                         more. Jinja in a command (`<% … %>`, copier's render layer, run before
#                         the shell sees the text; round 9) and any shell construct that builds
#                         the name at run time — parameter expansion (defaults such as
#                         `${S:-…}` and `${S:=…}` included), command substitution (backticks included), the escapes
#                         inside `$'…'`, `eval`, a variable, a short option glued on inside a
#                         span, a script the task runs — is review's alone. The [3/4] job is
#                         NO backstop for it: its render is a copy, and shipped-ai.py's update
#                         keeps only the seed task and the `rm -rf .copier` and
#                         shared-ai-symlinks migrations, so no other entry runs on an update.
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
#            move, moves a seed into an ungated task, removes a seed, adds a row to a seed,
#            drops a `SEEDED` entry — and asserts each check catches its own, exactly once; and
#            (round 8) a YAML-escaped or `_migrations` move, a repeated `when:`, and a long word
#            read in bounded time; (round 9) each top-level shape that is no plain key.
#            Each kind runs on one of the first five boards and on each of the later three.
#
# --fix      Re-render the eight seeds from the generator. Run it after changing how
#            pm-board.sh renders a board, then review the diff — never to silence check 4 on
#            a seed that has picked up rows.
#
# Requirements: python3 (standard library only; copier-commands.py beside this file), awk, grep.
# No network.
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

# folder|board — the eight registers, in board order.
BOARDS=(
  "01-FEATURE-MAPS|FEATURE-MAPS-BOARD.md"
  "02-STORIES|STORIES-BOARD.md"
  "03-SPRINTS|SPRINTS-BOARD.md"
  "15-DECISIONS|DECISIONS-BOARD.md"
  "16-SPRINT-PLANS|SPRINT-PLANS-BOARD.md"
  "17-STORY-PLANS|STORY-PLANS-BOARD.md"
  "20-FINDINGS|FINDINGS-BOARD.md"
  "21-BUGS|BUGS-BOARD.md"
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
    --help|-h)   sed -n '2,96p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)           die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT"
[[ -f "$COPIER" ]] || die "missing $COPIER"
[[ -f "$PM_BOARD" ]] || die "missing $PM_BOARD — the generator the seeds are checked against"
[[ -f "$MAP_SEED" ]] || die "missing $MAP_SEED — the seed-only tree cannot be built"
command -v python3 >/dev/null 2>&1 || die "python3 is required"

# The self-test crash guard (exit 2, never a red or a pass) and the optional probe ledger.
# shellcheck source=self-test-ledger.sh
. "$SCRIPT_DIR/self-test-ledger.sh"
# Check 1's glob reading (glob_matches, negation_matches; moved round 10) and check 2's word
# reading (seed_word, seed_any, BRACE_CAP; split out round 9, 21/11/2026).
# shellcheck source=shipped-boards-words.sh
. "$SCRIPT_DIR/shipped-boards-words.sh"

RENDER_DIR=""
# shellcheck disable=SC2329  # invoked by the EXIT trap below
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

# The `_exclude` negations, one per line, unquoted and stripped: the value after `- `, its
# trailing ` # comment` dropped when unquoted, its quotes removed, every block tag (the copier
# block delimiters, assembled from LT so no literal opener sits in this file) removed.
negations() {
  LT='<' python3 -I - "$1" <<'PYEOF'
import os, re, sys
lt = os.environ["LT"]
block = re.compile(re.escape(lt + ":") + r".*?" + re.escape(":>"))
on = False
for line in open(sys.argv[1], encoding="utf-8"):
    if re.match(r"^_exclude:", line):
        on = True
        continue
    if on and re.match(r"^[A-Za-z_]+:", line):
        break
    m = re.match(r"^\s*-\s+(.*?)\s*$", line) if on else None
    if not m:
        continue
    v = m.group(1)
    if v[:1] in ("'", '"'):
        q = v[0]
        end = v.find(q, 1)
        v = v[1:end] if end > 0 else v[1:]
    else:
        v = re.sub(r"\s+#.*$", "", v)
    v = block.sub("", v).strip()
    if v.startswith("!"):
        print(v)
PYEOF
}

run_checks() {
  FINDINGS=()
  local tasks others folder board seed c

  # ── 1. Nothing re-includes a board ───────────────────────────────────────────
  # Every `_exclude` negation, read as copier reads it — either quote style or none, a trailing
  # comment dropped, a block-tag conditional around it stripped — then tested as a GLOB against
  # each of the eight landed board paths. A name test (`BOARD` in the entry) misses a glob that
  # matches a board without naming one. One finding per negating entry.
  local e g hit
  while IFS= read -r e; do
    [[ -z "$e" ]] && continue
    g="${e#!}"; hit=""
    for b in "${BOARDS[@]}"; do
      if negation_matches "project-management/src/${b%%|*}/${b##*|}" "$g"; then hit=1; break; fi
    done
    [[ -n "$hit" ]] \
      && finding "copier.yml _exclude re-includes a board ($e) — syntek-base's own rows would ship"
  done < <(negations "$COPIER")

  # _tasks and _migrations, read through copier-commands.py — every scalar DECODED as YAML decodes
  # it, a key repeated in one entry refused (round 8, 21/11/2026). `S` lines are the copy-gated
  # task's raw lines (its `when:` decodes to the copy test and it carries the README move); `O`
  # lines the decoded commands of every other task and migration; `E` an entry the reader refuses,
  # a finding of its own, since check 2 cannot say what it runs.
  local read_out
  read_out=$(python3 -I "$SCRIPT_DIR/copier-commands.py" "$COPIER") \
    || die "copier-commands.py could not read $COPIER"
  tasks=$(sed -n 's/^S\t//p' <<< "$read_out")
  local unwired=() step last named ub
  others=$(sed -n 's/^O\t//p' <<< "$read_out")
  while IFS= read -r e; do
    [[ -n "$e" ]] && finding "$e"
  done < <(sed -n 's/^E\t//p' <<< "$read_out")
  # Every word of every decoded task and migration line, as the shell will hand it over (below).
  local words word capped=""
  words=$(sed -e "s/\\\$'/'/g" -e 's/\$"/"/g' <<< "$others" \
            | tr -d "\"'\\\\" | tr -s ' \t;&|<>()' '\n' | grep -v '^$' || true)
  # A word with more brace spans than BRACE_CAP is not read for a seed (seed_any skips it, so the
  # reading ends in bounded time) and is a finding of its own, since check 2 cannot say what it
  # names (round 9, 21/11/2026).
  while IFS= read -r word; do
    [[ "$word" == *\{* ]] || continue
    c="${word//[^\{]/}"
    if [[ ${#c} -gt $BRACE_CAP ]]; then capped="$word"; break; fi
  done <<< "$words"
  [[ -z "$capped" ]] \
    || finding "copier.yml has a task or migration word with more than $BRACE_CAP brace expansions (${capped:0:40}…) — check 2 caps its reading so it ends in bounded time, so it cannot say the word names no seed"
  for b in "${BOARDS[@]}"; do
    folder="${b%%|*}"; board="${b##*|}"; seed="$SEED_DIR/$board"

    # ── 2. Wired ──────────────────────────────────────────────────────────────
    # A real move: a step of the gated task's DECODED command, split at `&&`, that is exactly the
    # mv (round 9, 21/11/2026) — so an echoed or commented-out move, or a line folded into it
    # (`echo`, `true #`), is not read as one.
    if ! grep -qxF "mv .copier/$board project-management/src/$folder/$board" <<< "$tasks"; then
      finding "copier.yml's copy-gated _tasks entry does not move .copier/$board into $folder/ — a generated project gets no board, or an update re-seeds it"
      unwired+=("$board")
    fi
    # Any reference to the seed outside the gated task — whatever the command (mv, cp, ln, a cat
    # redirect…), quoted or not, behind any prefix ($PWD/, ./) — or to a glob matching it, or to
    # the bare .copier directory that holds it, reads it on every update and can overwrite the
    # project's own board. Every word of every decoded task and migration line counts — a shell
    # comment too, which errs towards a finding (YAML comments are gone with the decoding).
    # The line is read as the shell will hand it to the command: `$'…'` / `$"…"` quoting and the
    # quotes and backslashes inside a word are removed first (`.cop""ier`, `.co'p'ier`, `.cop\ier`,
    # `.cop$'i'er` all name .copier), then each word is read as a path by seed_word below
    # (round 5, 20/11/2026; the path reading round 6, 21/11/2026; the spans between `=`, `,` and
    # `:` round 7, 21/11/2026).
    local word hit=false
    while IFS= read -r word; do
      if seed_any "$word" "$board"; then hit=true; break; fi
    done <<< "$words"
    if $hit; then
      finding "copier.yml moves .copier/$board outside the copy-gated task — it names the seed, a glob matching it or the .copier directory in a task or migration that runs on every update and overwrites the project's own board"
    fi

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

  # ── 2, the seed task's own steps ──────────────────────────────────────────────
  # Every step of the decoded seed command is a plain seed move or, last, the closing rmdir: any
  # other step runs in the shell, and a `#` in it comments out every step after it (round 9). A
  # step naming a board already found unwired above is that finding, not a second one.
  local seed_step='^mv \.copier/[A-Za-z0-9][A-Za-z0-9._-]* [A-Za-z0-9._][A-Za-z0-9._/-]*$'
  last=$(tail -n 1 <<< "$tasks")
  while IFS= read -r step; do
    [[ -z "$step" ]] && continue
    [[ "$step" =~ $seed_step && "$step" != *..* ]] && continue
    [[ "$step" == "rmdir .copier" && "$step" == "$last" ]] && continue
    named=false
    for ub in "${unwired[@]}"; do [[ "$step" == *".copier/$ub"* ]] && named=true; done
    $named || finding "copier.yml's copy-gated _tasks entry holds a step that is not a seed move or the closing rmdir (\`${step:0:70}\`) — the shell runs it, and a # in it skips every step after it"
  done <<< "$tasks"
}

ST_FAILS=0
ST_PROBES=0
probe() {
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  if [[ ${#FINDINGS[@]} -eq 1 ]] && [[ "${FINDINGS[0]}" == *"$2"* ]]; then
    log "  ✓ $1"
    st_record pass "$1"
  else
    ST_FAILS=$((ST_FAILS + 1))
    st_record fail "$1"
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

  # The three later registers, folder|board — each check kind is proven on each of them too.
  local later=("15-DECISIONS|DECISIONS-BOARD.md" "20-FINDINGS|FINDINGS-BOARD.md" "21-BUGS|BUGS-BOARD.md")
  local lb lf lname

  # 1. Re-include a board.
  awk '{print} /^_exclude:/{print "  - \"!/project-management/src/02-STORIES/STORIES-BOARD.md\""}' \
    "$real_copier" > "$tmp/reinclude.yml"
  COPIER="$tmp/reinclude.yml"; probe "check 1 fires when a board is re-included" "re-includes a board"
  for lb in "${later[@]}"; do
    lf="${lb%%|*}"; lname="${lb##*|}"
    awk -v l="  - \"!/project-management/src/$lf/$lname\"" '{print} /^_exclude:/{print l}' \
      "$real_copier" > "$tmp/reinclude.yml"
    COPIER="$tmp/reinclude.yml"; probe "check 1 fires when $lname is re-included" "re-includes a board (!/project-management/src/$lf/$lname)"
  done
  # 1b. Negations a literal `^!.*BOARD` match never sees: other quote styles, a trailing
  #     comment, a block-tag conditional around the entry, and globs that name no board by its
  #     name yet match one under copier's glob semantics. One finding each.
  local LT='<' neg
  local negations=(
    "  - '!/project-management/src/03-SPRINTS/SPRINTS-BOARD.md'"
    "  - !/project-management/src/16-SPRINT-PLANS/SPRINT-PLANS-BOARD.md  # re-included on purpose"
    "  - \"${LT}: if INCLUDE_X :>!/project-management/src/17-STORY-PLANS/STORY-PLANS-BOARD.md${LT}: endif :>\""
    "  - \"!/project-management/src/21-BUGS/BUGS-*.md\""
    "  - \"!/project-management/src/**/*-B?ARD.md\""
  )
  for neg in "${negations[@]}"; do
    awk -v l="$neg" '{print} /^_exclude:/{print l}' "$real_copier" > "$tmp/reinclude.yml"
    COPIER="$tmp/reinclude.yml"; probe "check 1 fires on the negation $neg" "re-includes a board"
  done
  # 1c. Two gitignore shapes copier honours that a path glob misses: a pattern with no slash
  #     matches the basename at any depth, and a trailing slash names a folder, re-including it.
  awk '{print} /^_exclude:/{print "  - \"!SPRINTS-BOARD.md\""}' "$real_copier" > "$tmp/reinclude.yml"
  COPIER="$tmp/reinclude.yml"; probe "check 1 fires on a slash-less basename negation" "re-includes a board"
  awk '{print} /^_exclude:/{print "  - \"!/project-management/src/03-SPRINTS/\""}' "$real_copier" > "$tmp/reinclude.yml"
  COPIER="$tmp/reinclude.yml"; probe "check 1 fires on a trailing-slash folder negation" "re-includes a board"
  COPIER="$real_copier"

  # 2. Drop a _tasks move.
  grep -vF "mv .copier/SPRINTS-BOARD.md" "$real_copier" > "$tmp/no-move.yml"
  COPIER="$tmp/no-move.yml"; probe "check 2 fires when a _tasks move is dropped" "does not move .copier/SPRINTS-BOARD.md"
  for lb in "${later[@]}"; do
    lname="${lb##*|}"
    grep -vF "mv .copier/$lname" "$real_copier" > "$tmp/no-move.yml"
    COPIER="$tmp/no-move.yml"; probe "check 2 fires when the $lname move is dropped" "does not move .copier/$lname"
  done
  # 2b. Move a seed out of the copy-gated task into an ungated one. The move still exists, but
  #     it would run on every update and overwrite the project's own board — check 2 binds the
  #     move to the copy-gated task, not to _tasks at large. Leaving the gated move in place
  #     isolates the second half: any board move outside the gated task is a finding of its own.
  awk '{print} /^_tasks:/{print "  - command: mv .copier/STORIES-BOARD.md project-management/src/02-STORIES/STORIES-BOARD.md"}' \
    "$real_copier" > "$tmp/ungated.yml"
  COPIER="$tmp/ungated.yml"; probe "check 2 fires when a board move also sits in an ungated task" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  # 2d. The same ungated write in the shapes a literal `mv .copier/<board>` misses: a flag, a
  #     copy rather than a move, and a ./ before the seed path.
  local ung
  for ung in "mv -f .copier/STORIES-BOARD.md|an ungated mv -f of a seed" \
             "cp .copier/STORIES-BOARD.md|an ungated cp of a seed" \
             "mv ./.copier/STORIES-BOARD.md|an ungated mv of a ./.copier/ seed"; do
    awk -v l="  - command: ${ung%%|*} project-management/src/02-STORIES/STORIES-BOARD.md" '{print} /^_tasks:/{print l}' \
      "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; probe "check 2 fires on ${ung#*|}" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  done
  # 2e. Round 4: the shapes a command-and-flag match still missed — a quoted seed path, a glob
  #     matching one board, a $PWD prefix, a link and a redirect — and the bare .copier/
  #     directory, which holds every board and so is a finding for each.
  for ung in 'mv ".copier/STORIES-BOARD.md" x|a quoted seed path' \
             'mv .copier/STORIES-*.md x|a glob matching one board' \
             'mv "$PWD/.copier/STORIES-BOARD.md" x|a $PWD-prefixed seed path' \
             'ln -f .copier/STORIES-BOARD.md x|a link to a seed' \
             'cat .copier/STORIES-BOARD.md > x|a redirect of a seed'; do
    printf '%s\n' "  - command: ${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; probe "check 2 fires on ${ung#*|}" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  done
  # 2f. Round 5: what the shell un-splits before mv sees it — quotes splitting the name and a
  #     backslash inside it, and brace expansion naming a board among alternatives.
  for ung in 'mv .cop""ier/STORIES-BOARD.md x|a seed path split by empty quotes' \
             "mv .co'p'ier/STORIES-BOARD.md x|a seed path split by single quotes" \
             'mv .cop\ier/STORIES-BOARD.md x|a seed path split by a backslash' \
             'mv .copier/{STORIES,X}-BOARD.md x|a brace expansion naming a board'; do
    printf '%s\n' "  - command: ${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; probe "check 2 fires on ${ung#*|}" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  done
  # 2g. Round 6: the .copier directory named by a glob, spelt with `//`, `/./` or a `..` that
  #     resolves back to it, or ANSI-C quoted — each a literal path the shell resolves to the seed.
  for ung in 'mv .cop?er/STORIES-BOARD.md x|a ? glob in the directory name' \
             'mv .c*r/STORIES-BOARD.md x|a * glob in the directory name' \
             'mv .[c]opier/STORIES-BOARD.md x|a bracket glob opening the directory name' \
             'mv .copie[r]/STORIES-BOARD.md x|a bracket glob closing the directory name' \
             'mv .copier//STORIES-BOARD.md x|a doubled slash after the directory' \
             'mv .copier/./STORIES-BOARD.md x|a /./ after the directory' \
             'mv ./.copier/../.copier/STORIES-BOARD.md x|a .. resolving back to the directory' \
             "mv .cop\$'i'er/STORIES-BOARD.md x|an ANSI-C quoted directory name"; do
    printf '%s\n' "  - command: ${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; probe "check 2 fires on ${ung#*|}" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  done
  printf '%s\n' '  - command: cp -r .copier/ project-management/src/' > "$tmp/line"
  awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
  COPIER="$tmp/ungated.yml"; run_checks; ST_PROBES=$((ST_PROBES + 1))
  if [[ ${#FINDINGS[@]} -eq ${#BOARDS[@]} && "$(printf '%s\n' "${FINDINGS[@]}" | grep -c 'outside the copy-gated task' || true)" -eq ${#BOARDS[@]} ]]; then
    log "  ✓ check 2 fires for every board on the bare .copier/ directory"
    st_record pass "check 2 fires for every board on the bare .copier/ directory"
  else
    ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 fires for every board on the bare .copier/ directory"
    printf '\033[31m  ✗ the bare .copier/ directory produced %d finding(s)\033[0m\n' "${#FINDINGS[@]}"
  fi
  COPIER="$real_copier"
  # 2h. Round 7: a seed path behind `=`, `,` or `:` inside one word — a shell assignment, an
  #     operand or option `=value`, a comma or colon list — which round 6's path reading skipped
  #     (a regression from round 5, whose substring search caught it).
  for ung in 'F=.copier/STORIES-BOARD.md; mv "$F" x|a seed path in a shell assignment' \
             'dd if=.copier/STORIES-BOARD.md of=x|an operand=value seed path' \
             'cp --no-target-directory=.copier/STORIES-BOARD.md x|a --option=value seed path' \
             'cp --files=a,.copier/STORIES-BOARD.md x|a seed path in a comma list' \
             'X=a:.copier/STORIES-BOARD.md; cp "$X" x|a seed path in a colon list'; do
    printf '%s\n' "  - command: ${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; probe "check 2 fires on ${ung#*|}" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  done
  # The bare .copier directory behind `=`: every board is a finding.
  for ung in 'tar --directory=.copier -cf x .|the directory as --option=value' \
             'rsync -a src=.copier/ x|the directory as name=value'; do
    printf '%s\n' "  - command: ${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; run_checks; ST_PROBES=$((ST_PROBES + 1))
    if [[ ${#FINDINGS[@]} -eq ${#BOARDS[@]} && "$(printf '%s\n' "${FINDINGS[@]}" | grep -c 'outside the copy-gated task' || true)" -eq ${#BOARDS[@]} ]]; then
      log "  ✓ check 2 fires for every board on ${ung#*|}"
      st_record pass "check 2 fires for every board on ${ung#*|}"
    else
      ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 fires for every board on ${ung#*|}"
      printf '\033[31m  ✗ %s produced %d finding(s)\033[0m\n' "${ung#*|}" "${#FINDINGS[@]}"
    fi
  done
  # 2i. Round 7: the .copier directory glued to a short option, alone or after other flags.
  for ung in 'tar -C.copier -cf x .|the directory glued to a short option' \
             'tar -xC.copier -f x|the directory glued after combined short options'; do
    printf '%s\n' "  - command: ${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    COPIER="$tmp/ungated.yml"; run_checks; ST_PROBES=$((ST_PROBES + 1))
    if [[ ${#FINDINGS[@]} -eq ${#BOARDS[@]} && "$(printf '%s\n' "${FINDINGS[@]}" | grep -c 'outside the copy-gated task' || true)" -eq ${#BOARDS[@]} ]]; then
      log "  ✓ check 2 fires for every board on ${ung#*|}"
      st_record pass "check 2 fires for every board on ${ung#*|}"
    else
      ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 fires for every board on ${ung#*|}"
      printf '\033[31m  ✗ %s produced %d finding(s)\033[0m\n' "${ung#*|}" "${#FINDINGS[@]}"
    fi
  done
  # 2j. Round 8: the YAML layer and the second list. A double-quoted scalar's escape decodes to
  #     the dot before the shell sees it, and a `_migrations` entry runs on update as an ungated
  #     task does — each is a board move outside the copy-gated task.
  printf '%s\n' '  - command: "mv \x2ecopier/STORIES-BOARD.md x"' > "$tmp/line"
  awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
  COPIER="$tmp/ungated.yml"; probe "check 2 fires on a seed path spelt with a YAML \\x2e escape" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  printf '%s\n' '  - command: mv .copier/STORIES-BOARD.md project-management/src/02-STORIES/STORIES-BOARD.md' \
    "    when: \"<% _stage == 'after' %>\"" > "$tmp/line"
  awk -v f="$tmp/line" '{print} /^_migrations:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
  COPIER="$tmp/ungated.yml"; probe "check 2 fires on a _migrations entry moving a seed" "moves .copier/STORIES-BOARD.md outside the copy-gated task"
  #     A key repeated inside one entry: YAML keeps the last, so the entry does not run as it
  #     first reads. Once on an ungated task (that finding alone), once on the seed task itself,
  #     where a copy `when:` followed by an update one made the move read as gated.
  printf '%s\n' '  - command: echo a task' "    when: \"<% _copier_operation == 'copy' %>\"" \
    "    when: \"<% _copier_operation == 'update' %>\"" > "$tmp/line"
  awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
  COPIER="$tmp/ungated.yml"; probe "check 2 fires on a duplicate when: in a task" "repeats the key when:"
  awk '{print} prev ~ /rmdir \.copier$/ && /^    when: / {print "    when: \"<% _copier_operation == '"'"'update'"'"' %>\""} {prev = $0}' \
    "$real_copier" > "$tmp/dupseed.yml"
  COPIER="$tmp/dupseed.yml"; run_checks; ST_PROBES=$((ST_PROBES + 1))
  if [[ ${#FINDINGS[@]} -gt 0 ]] && printf '%s\n' "${FINDINGS[@]}" | grep -qF 'repeats the key when:'; then
    log "  ✓ check 2 fires on a duplicate when: in the seed task"
    st_record pass "check 2 fires on a duplicate when: in the seed task"
  else
    ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 fires on a duplicate when: in the seed task"
    printf '\033[31m  ✗ a duplicate when: in the seed task produced %d finding(s), none naming the repeat\033[0m\n' "${#FINDINGS[@]}"
  fi
  COPIER="$real_copier"
  # 2k. Round 8: three spans per separator, not every pair (round 9: "linear" was not true — a
  #     span is read along its length; see seed_any) — a 500-separator word reads
  #     inside 2 s (round 7's every-pair reading took 13 s at 150).
  local long="" k pid t=0
  for ((k = 0; k < 500; k++)); do long+=".,"; done
  ( seed_any "$long" STORIES-BOARD.md || true ) & pid=$!
  while kill -0 "$pid" 2>/dev/null && [[ $t -lt 20 ]]; do sleep 0.1; t=$((t + 1)); done
  ST_PROBES=$((ST_PROBES + 1))
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
    ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 reads a 500-separator word inside 2 s"
    printf '\033[31m  ✗ a 500-separator word was still being read after 2 s\033[0m\n'
  else
    wait "$pid" || true
    log "  ✓ check 2 reads a 500-separator word inside 2 s"
    st_record pass "check 2 reads a 500-separator word inside 2 s"
  fi
  # 2o. Round 9: brace spans are capped, so the worst case is bounded — 300 × `.{a,b}=` (45 s
  #     at round 8) is read, whole check, inside 2 s, and the cap is itself the one finding.
  long=""; t=0
  for ((k = 0; k < 300; k++)); do long+=".{a,b}="; done
  printf '  - command: echo %s\n' "$long" > "$tmp/line"
  awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/braces.yml"
  ( COPIER="$tmp/braces.yml"; run_checks; printf '%s\n' "${FINDINGS[@]}" > "$tmp/braces.out" ) & pid=$!
  while kill -0 "$pid" 2>/dev/null && [[ $t -lt 20 ]]; do sleep 0.1; t=$((t + 1)); done
  ST_PROBES=$((ST_PROBES + 1))
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
    ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 reads 300 brace spans inside 2 s and reports the cap"
    printf '\033[31m  ✗ 300 brace spans were still being read after 2 s\033[0m\n'
  elif wait "$pid" && [[ "$(wc -l < "$tmp/braces.out")" -eq 1 ]] && grep -q 'brace expansions' "$tmp/braces.out"; then
    log "  ✓ check 2 reads 300 brace spans inside 2 s and reports the cap"
    st_record pass "check 2 reads 300 brace spans inside 2 s and reports the cap"
  else
    ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 reads 300 brace spans inside 2 s and reports the cap"
    printf '\033[31m  ✗ 300 brace spans: %s\033[0m\n' "$(tr '\n' ';' < "$tmp/braces.out")"
  fi
  # 2l. Round 9: copier.yml is read as one document of plain top-level keys, and anything else at
  #     column 0 is refused — a quoted or escaped key, a `?` key, a document marker, a tag, a merge
  #     key — since copier (PyYAML, its `!include` and its multi-document merge) may read a
  #     `_tasks`, `_migrations` or `_exclude` there that checks 1 and 2 never see. One finding each.
  local shape tail
  for shape in '"_tasks":|  - command: mv .copier/STORIES-BOARD.md x|a quoted _tasks key' \
               '"_migrations":|  - command: mv .copier/STORIES-BOARD.md x|a quoted _migrations key' \
               '"\x5fmigrations":|  - command: mv .copier/STORIES-BOARD.md x|an escaped _migrations key' \
               '? _migrations|:   [mv .copier/STORIES-BOARD.md x]|an explicit ? key' \
               '---|!include extra.yml|a document marker and an !include' \
               '...|_zz: true|a document end marker' \
               '<<: *base|_zz: true|a merge key' \
               '"_exclude":|  - "!/project-management/src/02-STORIES/STORIES-BOARD.md"|a quoted _exclude key'; do
    tail="${shape#*|}"
    { cat "$real_copier"; printf '%s\n%s\n' "${shape%%|*}" "${tail%|*}"; } > "$tmp/toplevel.yml"
    COPIER="$tmp/toplevel.yml"; probe "copier.yml refuses ${shape##*|} at the top level" "not one document of plain top-level keys"
  done
  { cat "$real_copier"; printf '_templates_suffix: ""\n'; } > "$tmp/toplevel.yml"
  COPIER="$tmp/toplevel.yml"; probe "copier.yml refuses a repeated plain top-level key" "repeats the top-level key _templates_suffix:"
  sed 's/^_exclude:.*$/_exclude: !include extra.yml/' "$real_copier" > "$tmp/toplevel.yml"
  COPIER="$tmp/toplevel.yml"; probe "copier.yml refuses a tag on a top-level value" "not one document of plain top-level keys"
  COPIER="$real_copier"
  # 2m. Round 9: a `command:` whose value is on the next line, or a bare `-` with its keys below,
  #     is one finding — never a reader traceback, which stopped the check at exit 2.
  local rc
  for ung in '  - command:\n      mv .copier/STORIES-BOARD.md x|a command: with its value on the next line' \
             '  -\n    command: mv .copier/STORIES-BOARD.md x|a bare - with its keys on the lines below'; do
    printf '%b\n' "${ung%%|*}" > "$tmp/line"
    awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
    rc=0; python3 -I "$SCRIPT_DIR/copier-commands.py" "$tmp/ungated.yml" > "$tmp/read.out" 2>&1 || rc=$?
    if [[ $rc -eq 0 ]] && ! grep -q Traceback "$tmp/read.out"; then
      COPIER="$tmp/ungated.yml"; probe "check 2 reads ${ung#*|} as a finding" "on the lines after"
    else
      ST_PROBES=$((ST_PROBES + 1)); ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 reads ${ung#*|} as a finding"
      printf '\033[31m  ✗ %s: the reader exited %d (%s)\033[0m\n' "${ung#*|}" "$rc" "$(tail -n 1 "$tmp/read.out")"
    fi
  done
  # 2q. Round 10: a line break PyYAML honours and a "\n" split does not — NEL, U+2028, U+2029,
  #     a lone CR — puts a top-level key after it that copier reads and the reader never sees.
  #     Refused anywhere in copier.yml, as one finding.
  local brk inj
  for brk in '\xc2\x85|NEL (U+0085)' '\xe2\x80\xa8|U+2028' '\xe2\x80\xa9|U+2029' '\r|a lone CR'; do
    for inj in '_migrations:\n  - mv .copier/STORIES-BOARD.md project-management/src/02-STORIES/STORIES-BOARD.md|_migrations' \
               '_exclude: ["INJECT"]|_exclude'; do
      { cat "$real_copier"; printf '_zz_note: hi%b%b\n' "${brk%%|*}" "${inj%%|*}"; } > "$tmp/break.yml"
      COPIER="$tmp/break.yml"; probe "copier.yml refuses ${brk#*|} hiding a top-level ${inj#*|}" "a YAML line break"
    done
  done
  COPIER="$real_copier"
  # A guard, kept as round 6 left it: a different directory whose name only starts .copier is
  # no seed, so it is no finding.
  printf '%s\n' '  - command: mv .copierx/STORIES-BOARD.md x' > "$tmp/line"
  awk -v f="$tmp/line" '{print} /^_tasks:/{while ((getline l < f) > 0) print l; close(f)}' "$real_copier" > "$tmp/ungated.yml"
  COPIER="$tmp/ungated.yml"; run_checks; ST_PROBES=$((ST_PROBES + 1))
  if [[ ${#FINDINGS[@]} -eq 0 ]]; then
    log "  ✓ check 2 does not fire on .copierx, a different directory"
    st_record pass "check 2 does not fire on .copierx, a different directory"
  else
    ST_FAILS=$((ST_FAILS + 1)); st_record fail "check 2 does not fire on .copierx, a different directory"
    printf '\033[31m  ✗ .copierx produced %d finding(s)\033[0m\n' "${#FINDINGS[@]}"
  fi
  COPIER="$real_copier"
  # 2c. A move line that names the board but is not a move: echoed, or commented out inside the
  #     folded command. A substring search reads both as wired; one finding each.
  sed 's#^      mv \.copier/SPRINTS-BOARD\.md #      echo mv .copier/SPRINTS-BOARD.md #' "$real_copier" > "$tmp/echoed.yml"
  COPIER="$tmp/echoed.yml"; probe "check 2 fires when the move is only echoed" "does not move .copier/SPRINTS-BOARD.md"
  sed 's#^      mv \.copier/BUGS-BOARD\.md #      \# mv .copier/BUGS-BOARD.md #' "$real_copier" > "$tmp/commented.yml"
  COPIER="$tmp/commented.yml"; probe "check 2 fires when the move is commented out" "does not move .copier/BUGS-BOARD.md"
  # 2n. Round 9: the wired test reads the DECODED folded command, split at `&&`. A line of its own
  #     folds into the next step — `echo` turns the move into an echo, `true #` comments it and
  #     every later step out — so a raw line that still begins with the mv is not a move.
  for ung in '      echo|^      mv \.copier/STORIES-BOARD\.md |does not move .copier/STORIES-BOARD.md|an echo line folded into the move' \
             '      true #|^      mv \.copier/STORIES-BOARD\.md |does not move .copier/STORIES-BOARD.md|a true # line folded into the move' \
             '      true #|^      mv \.copier/README\.md |not a seed move or the closing rmdir|a true # line folded into the first step'; do
    IFS='|' read -r lf lb lname _ <<< "$ung"
    awk -v l="$lf" -v re="$lb" '$0 ~ re {print l} {print}' "$real_copier" > "$tmp/folded.yml"
    COPIER="$tmp/folded.yml"; probe "check 2 fires on ${ung##*|}" "$lname"
  done
  COPIER="$real_copier"

  # 3 and 4 work on a fresh copy of the seed directory per probe.
  fresh_seeds() { rm -rf "$tmp/seeds"; mkdir -p "$tmp/seeds"; cp "$real_seeds"/*-BOARD.md "$tmp/seeds/"; }
  SEED_DIR="$tmp/seeds"
  fresh_seeds; rm -f "$tmp/seeds/STORY-PLANS-BOARD.md"
  probe "check 3 fires when a seed is missing" "missing .copier/STORY-PLANS-BOARD.md"
  for lb in "${later[@]}"; do
    lname="${lb##*|}"
    fresh_seeds; rm -f "$tmp/seeds/$lname"
    probe "check 3 fires when $lname is missing" "missing .copier/$lname"
  done
  fresh_seeds
  printf '\n| US001 | A template story | Open | [US001.md](US001.md) |\n' >> "$tmp/seeds/STORIES-BOARD.md"
  probe "check 4 fires when a seed carries a row" ".copier/STORIES-BOARD.md differs"
  for lb in "${later[@]}"; do
    lname="${lb##*|}"
    fresh_seeds
    printf '\n| X-TEMPLATE-ROW | A template record | Open | [x.md](x.md) |\n' >> "$tmp/seeds/$lname"
    probe "check 4 fires when $lname carries a row" ".copier/$lname differs"
  done
  SEED_DIR="$real_seeds"

  # 5. Drop a SEEDED entry.
  sed 's#"16-SPRINT-PLANS/SPRINT-PLANS-BOARD.md"##' "$real_art" > "$tmp/artefacts.sh"
  ARTEFACTS="$tmp/artefacts.sh"; probe "check 5 fires when SEEDED omits a board" "SEEDED does not list 16-SPRINT-PLANS"
  for lb in "${later[@]}"; do
    lf="${lb%%|*}"; lname="${lb##*|}"
    sed "s#\"$lf/$lname\"##" "$real_art" > "$tmp/artefacts.sh"
    ARTEFACTS="$tmp/artefacts.sh"; probe "check 5 fires when SEEDED omits $lname" "SEEDED does not list $lf/$lname"
  done
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
  return 0
}

# Armed ahead of the render: a self-test run that stops anywhere before its end exits 2.
if $SELF_TEST; then st_arm cleanup; fi
render

if $FIX; then
  for b in "${BOARDS[@]}"; do
    cp "$RENDER_DIR/project-management/src/${b%%|*}/${b##*|}" "$SEED_DIR/${b##*|}"
    log "  wrote .copier/${b##*|}"
  done
fi

if $SELF_TEST; then
  self_test
  st_finish "$ST_FAILS"
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
