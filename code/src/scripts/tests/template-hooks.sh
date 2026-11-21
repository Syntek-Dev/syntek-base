#!/usr/bin/env bash
# SC2016: the hook bodies and stub scripts are written single-quoted on purpose — they expand in
# the fixture, never here.
# shellcheck disable=SC2016
#
# template-hooks.sh — Probes for the template's own hook shape: where the template-integrity legs
#                     run, and what each one judges. Template-only and copier-excluded, as the
#                     scripts it proves are.
#
# Proves .github/scripts/template-integrity.sh and the two lefthook.yml legs that call it:
#   shape      lefthook.yml declares the pre-commit leg (`--pre-commit`) and a pre-push leg
#              (`--pre-push`, `use_stdin: true`), and no commit-msg leg; neither the leg nor the
#              script carries any opt-in that lets a red self-test through; (round 6) every
#              SELF_TESTS entry is a step of audit-template.yml, unfiltered and on every branch;
#              (round 7) each sits in a job named as a required [n/4] context with no `if:` or
#              `continue-on-error` on it or its job, as does pm-board.sh --check, whose job checks
#              out with full history, and the `**` branches line is on.push's own.
#   commit     a commit runs only the plain checks: a red self-test commits (none runs), and a red
#              plain check blocks the commit.
#   push       a push runs every self-test against the commit being pushed — the tip of each
#              pushed ref, in a copy of that commit's tree, never the working tree — and refuses
#              the push when any is red or crashes (exit 2 read as a script error, never a pass);
#              a deletion pushes nothing to judge; two refs are judged one by one; (round 6) a
#              self-test absent from the commit is skipped with a notice, never a pass, while one
#              present that exits 127 refuses; no ref lines at all is said, never silent; (round 7)
#              only a tip whose history never held the script is skipped — one that deletes it is
#              refused, "deleted at <sha>".
#   hostile    a local attribute that drops a file from the copy, a caller's `-c`, or a repository
#              configuration that reshapes git's output, never makes a red commit read green.
#   replay     `template-integrity.sh --self-tests <commit>` is the reviewer's replay of one
#              commit: exit 1 at a red probe's commit, 0 at its fix.
#
# The fixture is SYNTHETIC: a `git init` in a `mktemp -d` holding a COPY of the real
# template-integrity.sh and lefthook.yml, a copier.yml stand-in, and stub detectors and self-tests
# whose results are files committed beside them, so a commit carries its own red or green. The
# hooks are plain .git/hooks files whose bodies are the two legs' `run:` blocks, read out of the
# real lefthook.yml — so the legs run as written. A bare remote takes the pushes. Nothing in it
# is a path back into this checkout, git runs with no system or global configuration, and no
# `.env.*` file is read. That lefthook itself arms the pre-push hook is hook-arming.sh's proof.
#
# Usage: template-hooks.sh [--keep] [--help]
#   --keep   Leave the fixture directory in place and print its path.
#
# Requires: bash, git, tar, python3 (the workflow's line parse). No network, no Docker.
# Exit codes: 0 = every probe passed  1 = a probe failed  2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

KEEP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep) KEEP=true; shift ;;
    --help|-h) sed -n '6,45p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'template-hooks.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done
for tool in git tar python3; do
  command -v "$tool" >/dev/null 2>&1 || { echo "template-hooks.sh: $tool not found" >&2; exit 2; }
done

TMP="$(mktemp -d)"
cleanup() { if $KEEP; then echo "fixture kept: $TMP"; else rm -rf "$TMP"; fi; }
trap cleanup EXIT
FX="$TMP/work"
REMOTE="$TMP/remote.git"
LOG="$TMP/ran.log"
OUT="$TMP/out"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 STUB_LOG="$LOG"
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT

FAILS=0
PASSES=0
pass() { PASSES=$((PASSES + 1)); printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILS=$((FAILS + 1)); printf '  \033[31m✗\033[0m %s\n' "$1"; }
check() { local label="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$label"; else fail "$label"; fi; }
refused() { ! "$@"; }
rc_is() { local want="$1" rc=0; shift; "$@" || rc=$?; [[ $rc -eq $want ]]; }
fgit() { git -C "$FX" -c user.name=probe -c user.email=probe@example.invalid "$@"; }

LEFTHOOK="$PROJECT_ROOT/lefthook.yml"
INTEGRITY="$PROJECT_ROOT/.github/scripts/template-integrity.sh"
[[ -f "$LEFTHOOK" && -f "$INTEGRITY" ]] || { echo "template-hooks.sh: lefthook.yml or template-integrity.sh missing" >&2; exit 2; }

# leg_block HOOK LEG — the `run: |` block of LEG under the top-level HOOK in lefthook.yml, dedented.
leg_block() {
  awk -v hook="$1:" -v leg="    $2:" '
    /^[A-Za-z-]+:/ { inhook = ($0 == hook); inleg = 0; inrun = 0; next }
    inhook && /^    [A-Za-z0-9_-]+:[[:space:]]*$/ { inleg = ($0 == leg); inrun = 0; next }
    inhook && inleg && /^      run: \|/ { inrun = 1; next }
    inhook && inleg && inrun { if ($0 !~ /^        / && $0 !~ /^[[:space:]]*$/) { inrun = 0; next } sub(/^        /, ""); print }
  ' "$LEFTHOOK"
}
# leg_has HOOK LEG KEY-LINE — LEG under HOOK carries KEY-LINE (e.g. `use_stdin: true`).
leg_has() {
  awk -v hook="$1:" -v leg="    $2:" -v key="      $3" '
    /^[A-Za-z-]+:/ { inhook = ($0 == hook); inleg = 0; next }
    inhook && /^    [A-Za-z0-9_-]+:[[:space:]]*$/ { inleg = ($0 == leg); next }
    inhook && inleg && $0 == key { found = 1 }
    END { exit !found }' "$LEFTHOOK"
}

# ── shape ─────────────────────────────────────────────────────────────────────
echo "shape"
PRE_COMMIT="$(leg_block pre-commit template-integrity)"
PRE_PUSH="$(leg_block pre-push template-integrity)"
check "the pre-commit leg calls template-integrity.sh --pre-commit" grep -qF 'template-integrity.sh --pre-commit' <<< "$PRE_COMMIT"
check "the pre-commit leg runs no self-test" bash -c '! grep -qE -- "--self-test|--pre-push|pm-boards\.sh" <<< "$1"' _ "$PRE_COMMIT"
check "a pre-push leg calls template-integrity.sh --pre-push" grep -qF 'template-integrity.sh --pre-push' <<< "$PRE_PUSH"
check "the pre-push leg reads git's ref lines (use_stdin: true)" leg_has pre-push template-integrity 'use_stdin: true'
check "lefthook.yml declares no commit-msg leg" bash -c '! grep -qE "^commit-msg:" "$1"' _ "$LEFTHOOK"
OPT_IN='PLANNED''_RED'
TRAILER='Planned''-Red'
check "neither the legs nor the script carries a red-probe opt-in" \
  bash -c '! grep -qE -- "$1|$2" "$3" "$4"' _ "$OPT_IN" "$TRAILER" "$LEFTHOOK" "$INTEGRITY"
# (round 6) CI is the check of record only if it runs every self-test the push leg runs, in a
# workflow with no path filter that runs on a push to any branch: audit-template.yml, whose four
# jobs are required checks on main.
AUDIT="$PROJECT_ROOT/.github/workflows/audit-template.yml"
mapfile -t LISTED < <(sed -n '/^SELF_TESTS=(/,/^)/p' "$INTEGRITY" | grep -oE '"[^"]+"' | tr -d '"')
check "template-integrity.sh lists its self-tests (SELF_TESTS read)" test "${#LISTED[@]}" -ge 9
in_ci() { local t; for t in "${LISTED[@]}"; do grep -qxE "[[:space:]]*run: bash ${t//./\\.}" "$AUDIT" || return 1; done; }
check "audit-template.yml runs every self-test the push leg runs" in_ci
check "  on a push to any branch, with no path filter" \
  bash -c 'grep -qF "branches: [\"**\"]" "$1" && ! grep -qE "^[[:space:]]+paths(-ignore)?:" "$1"' _ "$AUDIT"
# (round 7) Presence is not enough: each of those steps, and pm-board.sh --check (the archive
# freeze on this repository's own history), must sit in a job named as one of the four required
# [n/4] contexts, with no `if:` and no `continue-on-error` on the step or its job; the freeze's job
# must check out with full history; and the `branches: ["**"]` line must be on.push's own. A line
# parse of the workflow's fixed indentation (python3 -I, no YAML library) — it reads the shape this
# file is written in, and the names, not the live ruleset, stand for "required".
REQUIRED_JOBS=("[1/4] Template Tokens" "[2/4] Shipped Documentation" "[3/4] Template Generation" "[4/4] Parser Probes")
ci_shape() {
  python3 -I - "$AUDIT" <<'PY'
import sys
sect = on_sub = None
job = step = None
push_all = False
jobs = []
for line in open(sys.argv[1], encoding="utf-8").read().split("\n"):
    t = line.strip()
    if not t or t.startswith("#"):
        continue
    i = len(line) - len(line.lstrip(" "))
    key = t.split(":", 1)[0]
    if i == 0:
        sect, job, step = key, None, None
    elif sect == "on":
        if i == 2:
            on_sub = key
        elif i == 4 and on_sub == "push" and t == 'branches: ["**"]':
            push_all = True
    elif sect == "jobs":
        if i == 2:
            job = {"name": "", "if": 0, "coe": 0, "depth0": 0, "steps": []}
            jobs.append(job)
            step = None
        elif job is None:
            continue
        elif i == 4:
            if key == "name":
                job["name"] = t.split(":", 1)[1].strip().strip('"')
            elif key == "if":
                job["if"] = 1
            elif key == "continue-on-error":
                job["coe"] = 1
        elif i == 6 and t.startswith("- "):
            step = {"run": "", "if": 0, "coe": 0}
            job["steps"].append(step)
            t, key = t[2:], t[2:].split(":", 1)[0]
            i = 8
        if step is not None and sect == "jobs" and i == 8:
            if key == "run":
                step["run"] = t.split(":", 1)[1].strip()
            elif key == "if":
                step["if"] = 1
            elif key == "continue-on-error":
                step["coe"] = 1
        if job is not None and i == 10 and t.split("#", 1)[0].strip() == "fetch-depth: 0":
            job["depth0"] = 1
print("PUSH_ALL\t%d" % push_all)
for j in jobs:
    for s in j["steps"]:
        print("STEP\t%s\t%d\t%d\t%d\t%d\t%d\t%s" % (j["name"], j["if"], j["coe"], s["if"], s["coe"], j["depth0"], s["run"]))
PY
}
SHAPE="$(ci_shape)" || { echo "template-hooks.sh: could not read audit-template.yml's shape" >&2; exit 2; }
# required_step CMD [full] — CMD is `run: bash CMD` in a required job, unconditioned (and, with
# `full`, that job checks out with full history).
required_step() {
  local tag jname jif jcoe sif scoe depth run r
  while IFS=$'\t' read -r tag jname jif jcoe sif scoe depth run; do
    [[ "$tag" == STEP && "$run" == "bash $1" ]] || continue
    [[ "$jif$jcoe$sif$scoe" == 0000 ]] || continue
    [[ "${2:-}" != full || "$depth" == 1 ]] || continue
    for r in "${REQUIRED_JOBS[@]}"; do [[ "$jname" == "$r" ]] && return 0; done
  done <<< "$SHAPE"
  return 1
}
all_required() { local t; for t in "${LISTED[@]}"; do required_step "$t" || return 1; done; }
check "every listed self-test is a step of a required [n/4] job, with no if: or continue-on-error" all_required
check "pm-board.sh --check is a step of a required [n/4] job, unconditioned, with full history" \
  required_step "project-management/src/00-ASSETS/scripts/pm-board.sh --check" full
check "the branches: [\"**\"] line is on.push's own" grep -qx $'PUSH_ALL\t1' <<< "$SHAPE"
[[ -n "$PRE_COMMIT" && -n "$PRE_PUSH" ]] || { printf '\n%d passed, %d failed — the legs are missing, so no hook can be driven\n' "$PASSES" "$FAILS"; exit 1; }

# ── The fixture ───────────────────────────────────────────────────────────────
# A stub reads its result from stub/<name>.<mode> in the tree it runs in (default 0), logs that it
# ran, and exits with it. Every script the leg names is one, at its real path.
stub() {  # stub PATH — a stub detector or self-test at PATH
  mkdir -p "$FX/$(dirname "$1")"
  printf '%s\n' '#!/usr/bin/env bash' \
    'n="$(basename "$0" .sh)"; m=plain; [[ "${1:-}" == --self-test || "$n" == pm-boards || "$n" == template-hooks ]] && m=self-test' \
    'printf "%s %s %s\n" "$n" "$m" "$PWD" >> "$STUB_LOG"' \
    'f="stub/$n.$m"; rc=0; [[ -f "$f" ]] && rc="$(cat "$f")"; exit "$rc"' > "$FX/$1"
  chmod +x "$FX/$1"
}
build_fixture() {
  local s
  mkdir -p "$FX/.github/scripts" "$FX/stub"
  git init -q --bare "$REMOTE"
  git init -q -b main "$FX"
  cp "$INTEGRITY" "$FX/.github/scripts/template-integrity.sh"
  cp "$LEFTHOOK" "$FX/lefthook.yml"
  printf '_min_copier_version: "9"\n' > "$FX/copier.yml"
  for s in check-template-tokens shipped-readme shipped-memory shipped-registers shipped-boards \
           register-index-routes shipped-ai; do
    stub ".github/scripts/$s.sh"
  done
  stub code/src/scripts/tests/pm-boards.sh
  touch "$FX/stub/.keep"
  # (round 7) A commit from before template-hooks.sh existed, so a tip can be genuinely older.
  fgit add -A && fgit commit -q -m "before template-hooks.sh"
  PRE_HOOKS_SHA="$(fgit rev-parse HEAD)"
  stub code/src/scripts/tests/template-hooks.sh
  fgit add -A && fgit commit -q -m base
  fgit remote add origin "$REMOTE"
  fgit push -q origin main
  printf '#!/usr/bin/env bash\nset -e\ncd "$(git rev-parse --show-toplevel)"\n%s\n' "$PRE_COMMIT" > "$FX/.git/hooks/pre-commit"
  printf '#!/usr/bin/env bash\nset -e\ncd "$(git rev-parse --show-toplevel)"\n%s\n' "$PRE_PUSH" > "$FX/.git/hooks/pre-push"
  chmod +x "$FX/.git/hooks/pre-commit" "$FX/.git/hooks/pre-push"
}
build_fixture

# set_stub NAME MODE RC — the committed result of one stub, staged.
set_stub() { printf '%s\n' "$3" > "$FX/stub/$1.$2"; fgit add "stub/$1.$2"; }
ran() { [[ -s "$LOG" ]] && grep -q " $1 " "$LOG"; }
ran_none() { [[ ! -s "$LOG" ]] || ! grep -q ' self-test ' "$LOG"; }
remote_tip() { git -C "$REMOTE" rev-parse -q --verify "refs/heads/$1" 2>/dev/null || echo none; }
push() { : > "$LOG"; fgit push origin "$@" > "$OUT" 2>&1; }
commit() { : > "$LOG"; fgit commit -q -m "$1" > "$OUT" 2>&1; }
says() { grep -qiE -- "$1" "$OUT"; }

# ── commit ────────────────────────────────────────────────────────────────────
echo "commit"
# A red probe as it is really committed: in a detector's self-test, so the detector is staged.
set_stub shipped-boards self-test 1
printf '# a new probe\n' >> "$FX/.github/scripts/shipped-boards.sh"
fgit add -A
check "a commit holding a red self-test is accepted" commit "a red probe"
check "no self-test ran at pre-commit" ran_none
check "the plain checks did run at pre-commit" ran 'plain'
RED_SHA="$(fgit rev-parse HEAD)"
set_stub shipped-memory plain 1
check "a red plain check blocks the commit" refused commit "a red plain check"
check "the blocked commit left HEAD where it was" test "$(fgit rev-parse HEAD)" = "$RED_SHA"
set_stub shipped-memory plain 0
fgit reset -q -- stub/shipped-memory.plain; rm -f "$FX/stub/shipped-memory.plain"

# ── push ──────────────────────────────────────────────────────────────────────
echo "push"
check "a push whose tip holds a red self-test is refused" refused push main
check "the refusal names the red self-test" says 'shipped-boards'
check "the remote did not move" test "$(remote_tip main)" != "$RED_SHA"
check "every self-test ran at pre-push" bash -c 'for n in check-template-tokens shipped-readme shipped-memory shipped-registers shipped-boards register-index-routes shipped-ai pm-boards template-hooks; do grep -q "^$n self-test " "$1" || exit 1; done' _ "$LOG"
check "the self-tests ran in a copy, never the working tree" bash -c '! grep -q " $1\$" "$2"' _ "$FX" "$LOG"
set_stub shipped-boards self-test 0
commit "the fix"
GREEN_SHA="$(fgit rev-parse HEAD)"
check "a push whose tip is green is accepted" push main
check "the remote took the green tip" test "$(remote_tip main)" = "$GREEN_SHA"

# The commit pushed is judged, not the working tree.
printf '1\n' > "$FX/stub/shipped-readme.self-test"
fgit checkout -q -b side
fgit commit -q --allow-empty -m "side tip"
check "an unstaged red in the working tree does not refuse a green tip" push side
rm -f "$FX/stub/shipped-readme.self-test"
set_stub shipped-readme self-test 1
commit "a red tip"
RED2="$(fgit rev-parse HEAD)"
printf '0\n' > "$FX/stub/shipped-readme.self-test"
check "a green working tree does not pass a red tip" refused push side
fgit checkout -q -- stub/shipped-readme.self-test

# A crash is a script error, never a pass.
fgit checkout -q -b crash main
set_stub shipped-registers self-test 2
commit "a crash"
check "a self-test that crashes (exit 2) refuses the push" refused push crash
check "the refusal reads the crash as a script error" says 'exit 2|script error'

# Two refs, one red: judged one by one.
fgit checkout -q main
check "two refs pushed together, one red, are refused" refused push main side
check "the refusal names the red ref's commit" says "${RED2:0:12}"

# (round 6) A self-test absent from the commit judged — a tip older than the script — is skipped
# with a notice naming the commit: never a red, never counted as a pass. One present that exits
# 127, or crashes, is still a failure. (round 7) The older tip is genuinely older — a branch from
# before the script was added, so no commit in its history ever held it — and a tip that deletes
# a script its history held is refused, never skipped.
fgit checkout -q -b older "$PRE_HOOKS_SHA"
fgit commit -q --allow-empty -m "a tip older than one self-test"
OLDER="$(fgit rev-parse HEAD)"
check "a tip without one listed self-test pushes" push older
check "  and names it absent at that commit, skipped" says "template-hooks\.sh.*absent at ${OLDER:0:12} — skipped"
check "  and never counts it as a pass" bash -c '! grep -qE "✓.*template-hooks" "$1"' _ "$OUT"
check "  and the others still ran" ran 'self-test'
fgit checkout -q -b deleted main
fgit rm -q code/src/scripts/tests/template-hooks.sh
commit "a tip that deletes one self-test"
DELETED="$(fgit rev-parse HEAD)"
check "a tip that deletes a listed self-test its history held is refused" refused push deleted
check "  and the refusal names it deleted at that commit" says "template-hooks\.sh.*deleted at ${DELETED:0:12}"
check "  and never reads it as absent and skipped" bash -c '! grep -q "absent at" "$1"' _ "$OUT"
fgit checkout -q -b exit127 main
set_stub register-index-routes self-test 127
commit "a self-test that exits 127"
check "a present self-test that exits 127 refuses the push" refused push exit127
check "  and the refusal reads exit 127" says 'register-index-routes\.sh --self-test — exit 127'
fgit checkout -q main

# A deletion has nothing to judge.
git -C "$REMOTE" update-ref refs/heads/gone "$GREEN_SHA"
deleted_unjudged() { push :gone && ! grep -q self-test "$LOG"; }
check "a ref deletion pushes with no self-test run" deleted_unjudged
check "  and says it judged no commit" says 'no pushed commit to judge'
# (round 6) No ref lines at all — lefthook not forwarding stdin — is said, never silent.
empty_push() { (cd "$FX" && bash .github/scripts/template-integrity.sh --pre-push < /dev/null) > "$OUT" 2>&1; }
check "--pre-push with no ref lines exits 0" empty_push
check "  and says there was no pushed commit to judge" says 'no pushed commit to judge'

# ── hostile ───────────────────────────────────────────────────────────────────
echo "hostile"
fgit checkout -q side
mkdir -p "$FX/.git/info"
printf 'stub/** export-ignore\n' > "$FX/.git/info/attributes"
check "an export-ignore attribute dropping the red result does not pass the red tip" refused push side
check "the refusal says the copy is not the commit's tree" says 'not the tree|differs'
rm -f "$FX/.git/info/attributes"
fgit config core.autocrlf true
fgit config color.ui always
check "a repository's autocrlf and colour settings leave the red tip red" refused push side
fgit config --unset core.autocrlf; fgit config --unset color.ui
# A caller's `-c` reaches the hook as GIT_CONFIG_PARAMETERS. `tar.umask` is pinned nowhere, so
# only stripping that variable keeps it out of `git archive`: let through, it drops the stubs'
# execute bits, the copy's tree check refuses before any self-test runs, and the probes below see
# a refusal for the wrong reason (round 6: the probe ran `-c` as a command and could not fail).
caller_c_push() {
  : > "$LOG"
  fgit -c core.autocrlf=true -c color.ui=always -c tar.umask=0111 push origin side > "$OUT" 2>&1
}
check "a caller's -c options leave the red tip red" refused caller_c_push
check "  and the self-tests still ran, in a copy of the commit" ran 'self-test'
check "  and the refusal names the red self-test" says 'shipped-readme\.sh --self-test — exit 1'
# The staged read at pre-commit: a staged detector with an unstaged change beside it is refused,
# whatever colour, external diff or relative setting the repository carries.
fgit checkout -q main
printf '# staged\n' >> "$FX/.github/scripts/shipped-boards.sh"; fgit add .github/scripts/shipped-boards.sh
printf '# unstaged\n' >> "$FX/.github/scripts/shipped-boards.sh"
fgit config color.ui always; fgit config diff.external /bin/true; fgit config diff.relative true
check "a staged detector with an unstaged change is refused under a hostile diff configuration" refused commit "partly staged"
check "the refusal names the unstaged change" says 'unstaged'
fgit config --unset color.ui; fgit config --unset diff.external; fgit config --unset diff.relative
fgit checkout -q -- .github/scripts/shipped-boards.sh; fgit reset -q --hard

# ── replay ────────────────────────────────────────────────────────────────────
echo "replay"
replay() { (cd "$FX" && bash .github/scripts/template-integrity.sh --self-tests "$1") > "$OUT" 2>&1; }
check "--self-tests replays a red probe's commit as exit 1" rc_is 1 replay "$RED_SHA"
check "--self-tests replays its fix as exit 0" replay "$GREEN_SHA"
check "--self-tests replays a commit deleting a self-test as exit 1" rc_is 1 replay "$DELETED"
check "--self-tests replays a genuinely older commit as exit 0" replay "$OLDER"

printf '\n%d passed, %d failed\n' "$PASSES" "$FAILS"
[[ $FAILS -eq 0 ]]
