#!/usr/bin/env bash
# SC2016: the `bash -c '…' _ args` predicates expand their positional parameters in the child, by
# design. SC2329: predicates are invoked indirectly, through check(), which shellcheck cannot see.
# shellcheck disable=SC2016,SC2329
#
# hook-arming.sh — US009's probes: the git hooks arm on purpose, and only on purpose.
#
# Proves code/src/scripts/development/install-hooks.sh (the arming step install.sh calls as the
# last step of Phase 1), its read-only `--notice` mode (the package.json `postinstall`), and the
# manifest and installer edits around them. The probe body lives here, never in a workflow
# (.github/workflows/audit-hook-arming.yml only calls this script), per .claude/CLAUDE.md
# Section 6.
#
# Every fixture is a SNAPSHOT of a checkout of this repository — its own lefthook.yml,
# package.json and an installed node_modules — copied into a scratch directory outside it.
# Never a bare `git init`: lefthook then installs no pre-commit hook, writes a lefthook.yml
# into the tree, and `pnpm exec` cannot resolve the binary (story plan, Architecture Decision).
# The snapshot is the source's tracked files plus untracked-but-not-ignored ones, as on disk,
# so the probe can run before the story's commit exists. No `.env.*` file is ever copied.
#
# "Armed" is ONE predicate that install-hooks.sh and `--notice` must apply; this probe's oracle
# is an independent implementation of the same predicate, never a copy of the script's: the file
# `pre-commit` in the hooks DIRECTORY `git rev-parse --path-format=absolute --git-path hooks`
# names, resolved from the checkout root (never the hook file itself, whose resolution follows a
# symlink), is a readable, executable regular file carrying lefthook's generated marker
# — the line `call_lefthook run "pre-commit"` — and NOT carrying code-review-graph's appended
# block (`>>> code-review-graph pre-commit hook >>>`), which swallows lefthook's exit status
# (settled 17/11/2026, S-M1) — AND carrying the string `LEFTHOOK`, which is lefthook 2.2.2's own
# ownership test (`isLefthookFile`, measured 17/11/2026: case-sensitive; a hook carrying it is
# overwritten with no pre-commit.old; a hook without it is renamed to pre-commit.old, or refused
# when one exists). A marker without the executable bit is unarmed, and a SYMLINKED hook is
# foreign, never armed, whatever it points at (SEC-02). The hooks directory's REAL path must lie
# inside the repository's git common directory (settled 17/11/2026, round 5).
#
# SAFETY: nothing from the source checkout is ever symlinked, bound or shared into a fixture —
# above all not its node_modules. Every fixture gets its own install; the PATH filter skips any
# PATH entry inside the source; and a tripwire compares the source's node_modules before and
# after the run, exiting 2 if a fixture reached it.
#
# Fixtures (--fixture NAME; default `all`):
#   manifest           No fixture. ST01 (each of install-frontend.sh's pnpm install lines,
#                      found by content, carries --ignore-scripts; there are exactly three),
#                      ST02/ST02b (no prepare; no lifecycle script touches .git; postinstall
#                      calls install-hooks.sh --notice), ST03/ST07 and the script's own
#                      Definition of done, the install.sh numbering (P2), the README edits.
#   A                  A committed checkout. HP-02, HP-03, HP-04/EC-06, EC-03, EC-07 (--spec),
#                      EC-01 (a `git worktree add` checkout), ES-04 (binary absent), and S-M2:
#                      a fake lefthook first on PATH with none in node_modules is never run —
#                      the step exits 1 naming the missing project binary (7.4: never PATH).
#   B                  `git init`, no commits — an unborn HEAD. EC-04.
#   C                  No `.git` at all. ES-05.
#   notice             The postinstall through a real `pnpm install`: HP-08, EC-09 to EC-12,
#                      ES-06 (no repository; git absent from PATH). Positive cases `env -u CI`.
#   notice-streams     `--notice` stdout/stderr captured separately; nothing written; no
#                      network call or credential read (strace). Negative control EC-18.
#                      T-n2: --notice exits 0 on an unknown extra option and when the
#                      checkout root cannot be entered.
#   hook-paths         Effective-path states: ordinary, unborn, linked worktree, relative and
#                      absolute core.hooksPath (clone and worktree), stale marked default hook,
#                      raw graph hook, marked non-executable hook. EC-15, EC-16; a throwaway
#                      commit runs its legs. core.hooksPath=/dev/null is a deliberate opt-out:
#                      the step warns hooks are disabled, arms nothing, exits 0, and --notice
#                      prints `git config --unset-all core.hooksPath` (S-m2). Any other
#                      unresolvable hooks path exits 2 with an error:.
#   old-backup         Q2: a `pre-commit.old` already beside a non-lefthook hook is moved to a
#                      timestamped name before lefthook runs, reported, and neither its content
#                      nor the replaced hook's is lost — default path and core.hooksPath
#                      (--force). A merely non-executable lefthook hook claims no `.old`.
#                      R3-S-m1: the move is reported even when lefthook then fails (exit 2).
#                      SEC-02/QA-01: a symlinked pre-commit is foreign — the link itself is
#                      replaced, its target and the target's directory are never touched.
#                      R4-QA-01/03: a foreign hook carrying `LEFTHOOK` keeps its content; a
#                      marker without `LEFTHOOK` is not armed, and a .old beside it survives.
#   repo-shapes        A hooks directory whose real path is outside the git common directory
#                      is refused (exit 2), by every route: global, system, GIT_CONFIG,
#                      GIT_CONFIG_COUNT, a local include.path, a symlinked .git/hooks, a local
#                      absolute path — with a remedy hint per source. A project nested in an
#                      unrelated repository skips (QA-02); GIT_DIR/GIT_WORK_TREE are ignored
#                      (QA-03); a broken or bare-configured repository exits 2 (SEC-03, R4-03,
#                      R4-QA-06); an empty core.hooksPath exits 2 (QA-04). --notice hints.
#   change-filter      No project fixture. The install-failure job's change filter (the
#                      --needs-install-failure mode) against a scratch repository: docs/PM-only
#                      ranges skip, a rename out of code counts both sides, a non-ASCII PM path
#                      is still PM, and every doubtful range runs the job (R4-SEC-03).
#   write-boundary     Full-tree manifests (path, type, mode, link target, SHA-256; ignored and
#                      untracked included) around the arming step alone. Negative control EC-17.
#   graph-reclaim      The real, pinned `code-review-graph install` writes the hook first; the
#                      arming step reclaims and reports it. EC-05. S-M1: run AFTER arming, the
#                      tool appends its block to lefthook's hook, which swallows a failing leg;
#                      that hook is UNARMED, the step removes the block, and a failing leg
#                      blocks the commit again.
#   binary-provenance  lefthook 1.13.0 first on PATH; strace proves the project's locked 2.x
#                      executable did the install. EC-02. Needs registry access and strace.
#   install-failure    `bash install.sh` in a disposable clone whose hooks directory is a
#                      regular file. ES-01 to ES-03. CI-ONLY: install.sh needs a docker daemon,
#                      uv, and `sudo tee -a /etc/hosts`. Refused locally unless
#                      --allow-install-sh is given; reported unmeasured instead.
#
# Usage: hook-arming.sh [--fixture NAME] [--source DIR] [--output DIR] [--keep-scratch]
#                       [--allow-install-sh] [--quiet] [--help]
#        hook-arming.sh --needs-install-failure BASE
#                       CI's change filter: prints `true` or `false` for the range BASE..HEAD of
#                       --source; `true` on any doubt. Prints nothing else on stdout; exit 0.
#
# Exit codes:  0 = every expectation held   1 = an expectation failed   2 = script error
#              3 = unmeasured — a fixture could not look (missing tool, refused host effects,
#                  no registry access) and nothing failed. A 3 is never a pass
#                  (code/docs/GATE-REPORTING.md).
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
UNDER_TEST="code/src/scripts/development/install-hooks.sh"
MARKER='call_lefthook run "pre-commit"'
GRAPH_MARKER='>>> code-review-graph pre-commit hook >>>'
CRG_PIN="2.3.9"
LH_FIXTURE_VERSION="1.13.0"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }
die()  { printf 'hook-arming.sh error: %s\n' "$*" >&2; exit 2; }

usage() {
  cat <<'EOF'
hook-arming.sh — US009's probes for install-hooks.sh, its --notice mode and the manifest

Usage:
  hook-arming.sh [--fixture NAME]   One fixture, or `all` (default)
                 [--source DIR]     Checkout to snapshot (default: this repository's working tree)
                 [--output DIR]     Evidence directory (default: code/src/scripts/tests/reports/hook-arming)
                 [--keep-scratch]   Leave the scratch fixtures in place and print their path
                 [--allow-install-sh]  Let install-failure run root install.sh in its clone
                                    (sudo /etc/hosts, docker, uv). Implied under GitHub Actions
                 [--quiet]          Print failures, unmeasured checks and the summary only
                 [--help]
  hook-arming.sh --needs-install-failure BASE
                                    Print true/false: does BASE..HEAD need the install-failure job?

Fixtures: manifest A B C notice notice-streams hook-paths old-backup repo-shapes
          change-filter write-boundary graph-reclaim binary-provenance install-failure all

Exit codes: 0 all held · 1 an expectation failed · 2 script error · 3 unmeasured (never a pass)
EOF
}

FIXTURE="all"; SOURCE="$PROJECT_ROOT"; OUTPUT="$PROJECT_ROOT/code/src/scripts/tests/reports/hook-arming"
KEEP=false; QUIET=false; ALLOW_INSTALL=false; NIF=false; NIF_BASE=""
[[ "${GITHUB_ACTIONS:-}" == "true" ]] && ALLOW_INSTALL=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fixture)          [[ $# -ge 2 ]] || die "--fixture needs a value"; FIXTURE="$2"; shift 2 ;;
    --source)           [[ $# -ge 2 ]] || die "--source needs a value"; SOURCE="$2"; shift 2 ;;
    --output)           [[ $# -ge 2 ]] || die "--output needs a value"; OUTPUT="$2"; shift 2 ;;
    --keep-scratch)     KEEP=true; shift ;;
    --allow-install-sh) ALLOW_INSTALL=true; shift ;;
    --quiet)            QUIET=true; shift ;;
    --needs-install-failure) [[ $# -ge 2 ]] || die "--needs-install-failure needs a BASE (may be empty)"
                        NIF=true; NIF_BASE="$2"; shift 2 ;;
    --help|-h)          usage; exit 0 ;;
    *)                  die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

ALL_FIXTURES="manifest A B C notice notice-streams hook-paths old-backup repo-shapes change-filter write-boundary graph-reclaim binary-provenance install-failure"
case " $ALL_FIXTURES all " in *" $FIXTURE "*) ;; *) die "Unknown fixture '$FIXTURE'. Use --help." ;; esac

SOURCE="$(cd "$SOURCE" 2>/dev/null && pwd)" || die "--source is not a directory"
git -C "$SOURCE" rev-parse --show-toplevel >/dev/null 2>&1 || die "--source is not a git checkout: $SOURCE"
# The install-failure job's change filter. Skipped ONLY when every file the range touched is
# docs or PM; `true` on any doubt — an empty or all-zero BASE (a manual run, a new branch), a
# BASE that is not a readable commit, a failing diff, an empty diff. --no-renames makes BOTH
# sides of a rename count (R4-SEC-03); core.quotePath=false keeps a non-ASCII path unquoted so
# the patterns still match it.
needs_install_failure() {   # repo base — prints true|false
  local repo="$1" base="$2" changed other
  if [[ -z "$base" || "$base" =~ ^0+$ ]] || ! git -C "$repo" cat-file -e "$base^{commit}" 2>/dev/null; then
    printf 'true\n'; return
  fi
  changed="$(git -C "$repo" -c core.quotePath=false diff --no-renames --name-only "$base" HEAD 2>/dev/null)" ||
    { printf 'true\n'; return; }
  [[ -n "$changed" ]] || { printf 'true\n'; return; }
  other="$(printf '%s\n' "$changed" | grep -vE '\.md$|^project-management/|^research/|^handoffs/' || true)"
  if [[ -n "$other" ]]; then printf 'true\n'; else printf 'false\n'; fi
}
if $NIF; then needs_install_failure "$SOURCE" "$NIF_BASE"; exit 0; fi

for t in git pnpm node tar find sha256sum sort join cmp realpath; do
  command -v "$t" >/dev/null 2>&1 || die "'$t' not found — the probe needs it"
done

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/hook-arming.XXXXXX")" || die "cannot create a scratch directory"
cleanup() {
  if $KEEP; then log "Scratch kept: $SCRATCH"; else chmod -R u+w "$SCRATCH" 2>/dev/null; rm -rf "$SCRATCH"; fi
}
# Every exit path — pass, fail, die, a signal — runs the tripwire, then the cleanup. The trap is
# cleared first so an exit inside the handler cannot re-enter it.
on_exit() {
  local rc=$?; trap - EXIT
  if [[ -n "${NM_BEFORE+x}" ]] && ! tripwire_ok; then rc=2; fi
  cleanup
  exit "$rc"
}
trap on_exit EXIT
# A fixture with no .git must not find one above it.
if git -C "$SCRATCH" rev-parse --git-dir >/dev/null 2>&1; then die "scratch $SCRATCH is inside a git repository"; fi
case "$OUTPUT/" in "$SCRATCH"/*) die "--output must not be inside the scratch tree" ;; esac
mkdir -p "$OUTPUT" || die "cannot create --output $OUTPUT"
OUTPUT="$(cd "$OUTPUT" && pwd)"

# Isolate git from the host's own configuration: a global core.hooksPath would redirect every
# fixture. The child under test inherits this, which is the point.
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$SCRATCH/gitconfig"
printf '[user]\n\tname = Hook Arming Probe\n\temail = probe@example.invalid\n[init]\n\tdefaultBranch = main\n[commit]\n\tgpgsign = false\n' > "$GIT_CONFIG_GLOBAL"

# Tripwire: the source checkout's node_modules must be exactly as it was when the run ends.
nm_state() {   # root — the link status, real path and install record of root/node_modules
  local nm="$1/node_modules"
  [[ -e "$nm" || -L "$nm" ]] || { printf 'absent\n'; return; }
  printf '%s|%s|%s\n' "$([[ -L "$nm" ]] && readlink "$nm" || printf dir)" "$(realpath "$nm")" \
    "$(sha256sum "$nm/.modules.yaml" 2>/dev/null | cut -d' ' -f1)"
}
NM_ROOTS="$(printf '%s\n%s\n' "$SOURCE" "$PROJECT_ROOT" | sort -u)"
NM_BEFORE="$(while IFS= read -r r; do nm_state "$r"; done <<< "$NM_ROOTS")"
tripwire_ok() {
  local now; now="$(while IFS= read -r r; do nm_state "$r"; done <<< "$NM_ROOTS")"
  if [[ "$now" != "$NM_BEFORE" ]]; then
    printf 'hook-arming.sh error: TRIPWIRE — the source checkout'"'"'s node_modules changed during the run\n  before: %s\n  after:  %s\n' \
      "$NM_BEFORE" "$now" >&2
    return 1
  fi
}

PASSES=0; FAILS=0; UNMEASURED=0
pass()  { PASSES=$((PASSES + 1)); $QUIET || printf '  \033[32mPASS\033[0m  [%s] %s\n' "$1" "$2"; }
fail()  { FAILS=$((FAILS + 1)); printf '  \033[31mFAIL\033[0m  [%s] %s\n' "$1" "$2"; }
unmeasured() { UNMEASURED=$((UNMEASURED + 1)); printf '  \033[33mUNMEASURED\033[0m  [%s] %s\n' "$1" "$2"; }
check() { local id="$1" text="$2" reason="$3"; shift 3; if "$@"; then pass "$id" "$text"; else fail "$id" "$text — $reason"; fi; }
strip() { sed -E 's/\x1b\[[0-9;]*[A-Za-z]//g' "$@"; }

# ── Fixture construction ──────────────────────────────────────────────────────
snapshot() {   # dest — tracked + untracked-not-ignored files as on disk; never a .env.* file
  local dest="$1"; mkdir -p "$dest"
  (cd "$SOURCE" && git ls-files -z --cached --others --exclude-standard) |
    (cd "$SOURCE" && while IFS= read -r -d '' f; do
        [[ -e "$f" || -L "$f" ]] || continue
        case "${f##*/}" in *.example) ;; .env|.env.*) continue ;; esac
        printf '%s\0' "$f"
      done) |
    (cd "$SOURCE" && tar --null --no-recursion -T - -cf -) | tar -xf - -C "$dest" ||
    die "snapshot into $dest failed"
}
provision() {  # dir — the house installer, lifecycle scripts suppressed
  (cd "$1" && bash code/src/scripts/development/install-frontend.sh --check) >"$1.provision.log" 2>&1 ||
    die "dependency provisioning failed in $1 (see $1.provision.log)"
}
git_commit_all() {
  if ! { git -C "$1" init -q && git -C "$1" add -A && git -C "$1" commit -q -m fixture; }; then
    die "git fixture setup failed in $1"
  fi
}
new_fixture() {   # var name kind(commit|unborn|nogit) — sets var to the fixture root
  local _nf="$SCRATCH/$2"; snapshot "$_nf"; provision "$_nf"
  case "$3" in commit) git_commit_all "$_nf" ;; unborn) git -C "$_nf" init -q || die "git init failed" ;; nogit) ;; esac
  printf -v "$1" '%s' "$_nf"
}
add_worktree() {  # var fixture name [bare] — sets var to the worktree root (deps provisioned unless bare)
  local _aw="$SCRATCH/$3"
  git -C "$2" worktree add -q -b "wt-$3" "$_aw" >/dev/null 2>&1 || die "git worktree add failed"
  [[ "${4:-}" == "bare" ]] || provision "$_aw"
  printf -v "$1" '%s' "$_aw"
}
filtered_path() {  # dir names… — a PATH directory with every host executable except those named
  local dir="$1" p f n x skip; shift; mkdir -p "$dir"
  local IFS=:
  for p in $PATH; do
    [[ -d "$p" ]] || continue
    case "$(realpath "$p")/" in "$SOURCE"/*|"$PROJECT_ROOT"/*) continue ;; esac   # never link into the source
    for f in "$p"/*; do
      n="${f##*/}"; [[ -x "$f" && ! -d "$f" && ! -e "$dir/$n" ]] || continue
      skip=0; for x in "$@"; do case "$n" in "$x"|"$x"-*) skip=1 ;; esac; done
      [[ $skip == 1 ]] || ln -s "$f" "$dir/$n"
    done
  done
}

# ── The predicate, the runners and the oracles ────────────────────────────────
# The hook DIRECTORY is resolved, then /pre-commit appended: resolving the hook FILE with
# --path-format=absolute follows a symlinked pre-commit to its target (measured 17/11/2026),
# which would make a link "the hook" and its target's directory "the hooks dir" (SEC-02).
eff_hook() {
  local hd; hd="$(cd "$1" && git rev-parse --path-format=absolute --git-path hooks 2>/dev/null)" || return 1
  [[ -n "$hd" ]] || return 1; printf '%s/pre-commit\n' "$hd"
}
is_armed() {
  local p; p="$(eff_hook "$1")" || return 1
  [[ -f "$p" && ! -L "$p" && -r "$p" && -x "$p" ]] && grep -qF "$MARKER" "$p" && grep -qF 'LEFTHOOK' "$p" &&
    ! grep -qF "$GRAPH_MARKER" "$p"
}
unarmed() { ! is_armed "$1"; }
ut_present() { [[ -f "$1/$UNDER_TEST" ]]; }
RC=0
run_ut() {     # dir evidence-prefix [env-prefix…] -- [args…]
  local d="$1" o="$2"; shift 2; local pre=()
  while [[ $# -gt 0 && "$1" != "--" ]]; do pre+=("$1"); shift; done; [[ "${1:-}" == "--" ]] && shift
  (cd "$d" && "${pre[@]}" bash "$UNDER_TEST" "$@") >"$o.out" 2>"$o.err" </dev/null; RC=$?
  printf '%s\n' "$RC" > "$o.rc"
}
rc_is() { [[ "$RC" == "$1" ]]; }
not_() { ! "$@"; }
rc_nonzero() { [[ "$RC" != "0" ]]; }
says() { strip "$1.out" "$1.err" | grep -qiE "$2"; }
reports_path() {   # evidence-prefix dir — names the effective hook, absolutely or root-relative
  local abs rel; abs="$(eff_hook "$2")"; rel="${abs#"$2"/}"
  strip "$1.out" "$1.err" | grep -qF -e "$abs" -e "$rel"
}
ok_line() { strip "$1.out" | grep -q '✓'; }
notice_valid()  { [[ "$(cat "$1.rc")" == 0 ]] && grep -qF 'bash install.sh' "$1.out" && [[ ! -s "$1.err" ]]; }
notice_says()   { [[ "$(cat "$1.rc")" == 0 ]] && grep -qF -- "$2" "$1.out" && [[ ! -s "$1.err" ]]; }   # prefix text
commit_blocked() {   # dir evidence-prefix — a staged markdownlint failure (MD018) must stop the commit
  local h name="hook-arming-probe-$RANDOM.md"; h="$(git -C "$1" rev-parse HEAD)"
  printf '#no space after the hash\n' > "$1/$name"; git -C "$1" add "$name"
  (cd "$1" && git commit -m "hook-arming probe: must be blocked") >"$2.commit" 2>&1 </dev/null; local rc=$?
  printf '%s\n' "$rc" > "$2.commit.rc"
  [[ $rc != 0 && "$(git -C "$1" rev-parse HEAD)" == "$h" ]]
}
notice_silent() { [[ "$(cat "$1.rc")" == 0 && ! -s "$1.out" && ! -s "$1.err" ]]; }
notice() {     # dir evidence-prefix [env-prefix…] — CI is unset unless the prefix sets it
  local d="$1" o="$2"; shift 2
  run_ut "$d" "$o" env -u CI "$@" -- --notice
}
commit_runs_legs() {  # dir evidence-prefix — a throwaway commit; lefthook's summary must appear
  printf '# hook-arming probe %s\n' "$RANDOM" >> "$1/.editorconfig"
  git -C "$1" add .editorconfig && (cd "$1" && git commit -m "hook-arming probe") >"$2.commit" 2>&1 </dev/null
  strip "$2.commit" | grep -q 'summary:'
}
pnpm_fresh() {   # dir evidence-prefix [env-prefix…] — node_modules removed, so lifecycle scripts run
  local d="$1" o="$2"; shift 2
  rm -rf "$d/node_modules" "$d"/code/src/*/node_modules
  (cd "$d" && "$@" pnpm install --frozen-lockfile) >"$o.out" 2>"$o.err" </dev/null; RC=$?
  printf '%s\n' "$RC" > "$o.rc"
}
pnpm_notice() { strip "$1.out" "$1.err" | grep -v 'postinstall\$' | grep -qF 'bash install.sh'; }
pnpm_quiet() { rc_is 0 && ! pnpm_notice "$1"; }
postinstall_wired() {
  (cd "$1" && node -e 'const s=(require("./package.json").scripts||{}).postinstall||"";process.exit(/install-hooks\.sh/.test(s)&&/--notice/.test(s)?0:1)')
}

# Full-tree manifest: path, type, mode, symlink target, SHA-256 of regular files. Symlinks are
# never followed and no content is recorded. Unreadable or unrepresentable paths fail the
# measurement (return 2/3) rather than vanish from it.
manifest() {   # root out
  local root="$1" out="$2"
  [[ -z "$(find "$root" \( -name "$(printf '*\n*')" -o -name "$(printf '*\t*')" -o -name '*\\*' \) -print -quit)" ]] || return 2
  [[ -z "$(find "$root" ! -readable -print -quit 2>/dev/null)" ]] || return 3
  (cd "$root" && find . -printf '%p\t%y\t%m\t%l\n' | LC_ALL=C sort -t $'\t' -k1,1) > "$out.meta"
  (cd "$root" && find . -type f -print0 | xargs -0 -r -P 4 -n 512 sha256sum |
    sed -E 's/^([0-9a-f]+)  (.*)$/\2\t\1/' | LC_ALL=C sort -t $'\t' -k1,1) > "$out.hash"
  LC_ALL=C join -t $'\t' -a 1 -e - -o '1.1,1.2,1.3,1.4,2.2' "$out.meta" "$out.hash" > "$out"
}
changed_paths() { diff "$1" "$2" | sed -nE 's/^[<>] ([^\t]*)\t.*/\1/p' | LC_ALL=C sort -u; }
outside() {    # changed-list allowed-prefix… — prints changes outside every allowed prefix
  local f="$1" p a ok; shift
  while IFS= read -r p; do
    ok=0; for a in "$@"; do [[ -n "$a" ]] && case "$p" in "$a"|"$a"/*) ok=1 ;; esac; done
    [[ $ok == 1 ]] || printf '%s\n' "$p"
  done < "$f"
}

# ── manifest — static assertions, no fixture ──────────────────────────────────
fx_manifest() {
  local s="$SOURCE" fe="$SOURCE/code/src/scripts/development/install-frontend.sh" lines n ln text
  bold "▸ manifest — static assertions over $s"
  lines="$(grep -nE '^[[:space:]]*pnpm install([[:space:]]|$)' "$fe")"
  n="$(printf '%s\n' "$lines" | grep -c .)"
  check ST01 "install-frontend.sh has exactly three pnpm install invocations" "found $n" [ "$n" -eq 3 ]
  while IFS=: read -r ln text; do
    [[ -n "$ln" ]] || continue
    check ST01 "install-frontend.sh:$ln — this line alone carries --ignore-scripts" "flag absent on that line" \
      grep -q -- '--ignore-scripts' <<< "$text"
  done <<< "$lines"

  check ST02 "package.json has no prepare script" "prepare is still present" \
    bash -c 'cd "$1" && node -e "process.exit((require(\"./package.json\").scripts||{}).prepare===undefined?0:1)"' _ "$s"
  check ST02 "no package.json lifecycle script runs lefthook install or touches .git" "a lifecycle script does" \
    bash -c 'cd "$1" && node -e "
      const s=require(\"./package.json\").scripts||{};
      const life=[\"preinstall\",\"install\",\"postinstall\",\"preprepare\",\"prepare\",\"postprepare\",\"prepublish\",\"prepublishOnly\",\"prepack\",\"postpack\",\"dependencies\"];
      process.exit(life.some(k=>s[k]&&/lefthook +install|\.git\b|hooksPath/.test(s[k]))?1:0)"' _ "$s"
  check ST02b "postinstall calls install-hooks.sh --notice" "postinstall absent or does not call it" postinstall_wired "$s"
  local wf="$s/.github/workflows/audit-hook-arming.yml" fx job missing=""
  if [[ -f "$wf" ]]; then
    job="$(awk '/^  probes:/{f=1;print;next} f&&/^  [a-z][a-z-]*:$/{f=0} f' "$wf")"
    for fx in $ALL_FIXTURES; do
      [[ $fx == install-failure ]] && continue
      grep -qE -- "--fixture $fx([^a-zA-Z-]|\$)" <<< "$job" || missing+=" $fx"
    done
    check R4-01 "the probes job has a step for every fixture except install-failure" "missing:$missing" test -z "$missing"
    check R4-SEC-03 "the changes job decides through hook-arming.sh --needs-install-failure (the tested filter)" \
      "the workflow does not call it" grep -qF -- '--needs-install-failure' "$wf"
  else
    unmeasured R4-01 "no .github/workflows/audit-hook-arming.yml in the source"
  fi
  check QA-05 "pnpm-workspace.yaml allowBuilds keeps 'lefthook: false' (its own installer never runs)" "absent" \
    bash -c 'awk "/^allowBuilds:/{f=1;next} f&&/^[^[:space:]#]/{f=0} f" "$1" | grep -qE "^[[:space:]]+lefthook:[[:space:]]*false\b"' _ "$s/pnpm-workspace.yaml"

  local ut="$s/$UNDER_TEST"
  if [[ ! -f "$ut" ]]; then
    fail P1 "$UNDER_TEST exists — absent: the script under test has not been written"
  else
    pass P1 "$UNDER_TEST exists"
    check P1 "$UNDER_TEST is executable on disk" "mode lacks +x" test -x "$ut"
    if git -C "$s" ls-files --error-unmatch "$UNDER_TEST" >/dev/null 2>&1; then
      check P1 "$UNDER_TEST is tracked at mode 100755" "tracked mode is not 100755" \
        bash -c '[[ "$(git -C "$1" ls-files -s "$2" | cut -d" " -f1)" == 100755 ]]' _ "$s" "$UNDER_TEST"
    fi
    check P1 "header comment names the script" "no '# install-hooks.sh —' header" \
      bash -c 'head -5 "$1" | grep -q "^# install-hooks.sh —"' _ "$ut"
    check P1 "header declares exit code 2 (install.sh's 'install failed')" "no exit-code line naming 2" \
      bash -c 'head -40 "$1" | grep -iE "exit code" | grep -q 2' _ "$ut"
    check ST03 "the install invocation is 'args=(install' run as 'pnpm exec lefthook \"\${args'" \
      "the non-comment args=(install / pnpm exec lefthook \"\${args[@]}\" pair is absent" \
      bash -c 'c="$(grep -vE "^[[:space:]]*#" "$1")"; grep -qE "args=\(install" <<< "$c" && grep -qF "pnpm exec lefthook \"\${args" <<< "$c"' _ "$ut"
    check ST07 "guards with 'git rev-parse --git-dir'" "guard absent" grep -qF 'git rev-parse --git-dir' "$ut"
    check ST07 "never tests '[ -d .git ]'" "a directory test on .git is present" \
      bash -c '! grep -vE "^[[:space:]]*#" "$1" | grep -qE "\[\[? +-d +\"?[^ ]*\.git\"? *\]"' _ "$ut"
    check P1 "resolves the effective hook with --git-path hooks/pre-commit" "resolution absent" \
      grep -qF -- '--git-path hooks/pre-commit' "$ut"
    local h="$SCRATCH/manifest-help"; mkdir -p "$h"
    (cd "$s" && bash "$UNDER_TEST" --help) >"$h/help.out" 2>&1; local hr=$?
    check P1 "--help exits 0 and documents --notice" "exit $hr or --notice undocumented" \
      bash -c '[[ $1 == 0 ]] && grep -qF -- --notice "$2"' _ "$hr" "$h/help.out"
    (cd "$s" && bash "$UNDER_TEST" -h) >/dev/null 2>&1; hr=$?
    check P1 "-h exits 0" "exit $hr" [ "$hr" -eq 0 ]
    (cd "$s" && bash "$UNDER_TEST" --no-such-option) >/dev/null 2>&1; hr=$?
    check P1 "an unknown option dies non-zero" "exit $hr" [ "$hr" -ne 0 ]
  fi

  local i="$s/install.sh" l8 l9 l9b lp lspec
  l8="$(grep -n '^# ── Phase 1 · Step 8' "$i" | head -1 | cut -d: -f1)"
  l9="$(grep -n '^# ── Phase 1 · Step 9 — Git hooks' "$i" | head -1 | cut -d: -f1)"
  lp="$(grep -n '^# ── Phase 2 (--full only)' "$i" | head -1 | cut -d: -f1)"
  lspec="$(grep -n 'if \[\[ "\$SPEC_ONLY" == "true" \]\]' "$i" | head -1 | cut -d: -f1)"
  check P2 "install.sh carries '# ── Phase 1 · Step 9 — Git hooks'" "comment absent" [ -n "$l9" ]
  check P2 "Step 9 sits after Step 8 and before the Phase 2 banner" "out of order or missing" \
    bash -c '[[ -n $1 && -n $2 && -n $3 ]] && (( $1 < $2 && $2 < $3 ))' _ "$l8" "$l9" "$lp"
  check EC-07 "the --spec short-circuit precedes Step 9" "out of order or missing" \
    bash -c '[[ -n $1 && -n $2 ]] && (( $1 < $2 ))' _ "$lspec" "$l9"
  l9b="$( [[ -n "$l9" && -n "$lp" ]] && sed -n "${l9},${lp}p" "$i" | grep -cF 'bash "$PROJECT_ROOT/code/src/scripts/development/install-hooks.sh"')"
  check P2 "Step 9 calls bash \"\$PROJECT_ROOT/$UNDER_TEST\"" "call absent from the Step 9 section" [ "${l9b:-0}" -ge 1 ]
  local u; u="$(sed -n '/^usage() {/,/^EOF$/p' "$i")"
  check P2 "usage() Phase 1 lists steps 1 to 9, contiguous" "the Phase 1 list is not 1..9" \
    bash -c '[[ "$(sed -n "/^Phase 1/,/^$/p" <<< "$1" | grep -oE "^  [0-9]+\." | tr -dc "0-9\n" | paste -sd, -)" == "1,2,3,4,5,6,7,8,9" ]]' _ "$u"
  check P2 "usage() Phase 2 lists steps 10 and 11" "the Phase 2 list is not 10,11" \
    bash -c '[[ "$(sed -n "/^Phase 2/,/^$/p" <<< "$1" | grep -oE "^  [0-9]+\." | tr -dc "0-9\n" | paste -sd, -)" == "10,11" ]]' _ "$u"
  check P2 "body headers read 'Phase 2 · Step 10' and 'Step 11', never 7 or 8" "headers not renumbered" \
    bash -c 'grep -q "Phase 2 · Step 10" "$1" && grep -q "Phase 2 · Step 11" "$1" && ! grep -qE "Phase 2 · Step (7|8)\b" "$1"' _ "$i"
  check P2 "install.sh's header comment names the hooks" "header (first 10 lines) silent on hooks" \
    bash -c 'head -10 "$1" | grep -qi hook' _ "$i"

  local r="$s/.copier/README.md"; [[ -f "$r" ]] || r="$s/README.md"
  check HP-06 "the README claim 'runs \`lefthook install\`, which registers the' (line-wrapped) stands" "sentence gone" \
    grep -qF 'runs `lefthook install`, which registers the' "$r"
  check HP-06 "the README no longer instructs 'pnpm prepare'" "a pnpm prepare line remains" \
    bash -c '! grep -qE "^[[:space:]]*pnpm prepare\b" "$1"' _ "$r"
  check HP-06 "the README Development-scripts table has an install-hooks.sh row" "no row" \
    grep -qE '^\|[[:space:]]*`?install-hooks\.sh' "$r"
}

# ── A — a committed checkout ──────────────────────────────────────────────────
fx_A() {
  bold "▸ A — a committed checkout"
  local d e="$OUTPUT/A" p wt
  new_fixture d A commit
  check A-pre "fresh fixture starts unarmed" "a hook is already armed" unarmed "$d"

  (cd "$d" && bash install.sh --spec) >"$e/spec.out" 2>&1 </dev/null; local sr=$?
  check EC-07 "install.sh --spec exits 0 and arms nothing" "exit $sr or the hook armed" \
    bash -c '[[ $1 == 0 ]]' _ "$sr"
  check EC-07 "after --spec the effective hook is still unarmed" "--spec armed the hook" unarmed "$d"

  if ! ut_present "$d"; then fail A "$UNDER_TEST absent in the fixture — nothing to arm with"; return; fi

  run_ut "$d" "$e/arm" --
  check HP-02 "the step exits 0" "exit $RC" rc_is 0
  check HP-02 "the effective pre-commit hook is lefthook's, readable and executable" "unarmed after the step" is_armed "$d"
  check HP-01 "the step prints its own ok line (✓)" "no ✓ line on stdout" ok_line "$e/arm"
  check HP-01 "the step names the hook path it wrote" "path not reported" reports_path "$e/arm" "$d"

  p="$(eff_hook "$d")"; cp "$p" "$e/hook.before" 2>/dev/null
  run_ut "$d" "$e/rerun" --
  check HP-04 "a second run exits 0" "exit $RC" rc_is 0
  check HP-04 "the hook is still lefthook's after a re-run" "unarmed" is_armed "$d"
  check EC-06 "the hook is byte-identical across runs" "it changed" cmp -s "$p" "$e/hook.before"

  check HP-03 "a throwaway commit runs the lefthook pre-commit legs" "no lefthook summary in the commit output" \
    commit_runs_legs "$d" "$e/main"

  printf '#!/bin/sh\necho hand-written hook\n' > "$p"; chmod +x "$p"
  run_ut "$d" "$e/handwritten" --
  check EC-03 "over a hand-written hook the step exits 0" "exit $RC" rc_is 0
  check EC-03 "the hand-written hook is replaced by lefthook's" "not armed" is_armed "$d"
  check EC-03 "the developer is told the existing hook was replaced" "no 'replac…' in the output" says "$e/handwritten" 'replac'

  rm -f "$p"
  add_worktree wt "$d" A-wt
  check EC-01 "the worktree's .git is a file" ".git is not a file" test -f "$wt/.git"
  check EC-01 "the worktree starts unarmed" "already armed" unarmed "$wt"
  run_ut "$wt" "$e/worktree" --
  check EC-01 "in a worktree the step exits 0" "exit $RC" rc_is 0
  check EC-01 "in a worktree the hooks arm rather than skip" "unarmed after the step" is_armed "$wt"
  check EC-01 "the worktree step does not report a skip" "it reported a skip" bash -c '! grep -qi skip "$1.out" "$1.err"' _ "$e/worktree"
  check EC-01 "a throwaway commit in the worktree runs the legs" "no lefthook summary" commit_runs_legs "$wt" "$e/worktree"

  rm -f "$d/node_modules/.bin/lefthook" "$d/node_modules/lefthook"
  filtered_path "$SCRATCH/path-no-lefthook" lefthook
  if PATH="$SCRATCH/path-no-lefthook" command -v lefthook >/dev/null 2>&1; then
    unmeasured ES-04 "could not remove lefthook from PATH"
  else
    run_ut "$d" "$e/no-binary" env PATH="$SCRATCH/path-no-lefthook" --
    check ES-04 "with lefthook absent the step exits 1 (requirement missing)" "exit $RC" rc_is 1
    check ES-04 "the failure is an err line naming the missing lefthook binary" \
      "no 'error: … lefthook … not found/missing/absent' line" \
      says "$e/no-binary" '^error:.*lefthook.*(not found|missing|absent|not installed|cannot find|can.t find)|^error:.*(not found|missing|absent|not installed|cannot find|can.t find).*lefthook'

    # S-M2 (constraint 7.4 — the project's binary, never PATH): a fake lefthook first on PATH and
    # none in node_modules. The fake records every execution to a file outside the fixture.
    local fake="$SCRATCH/fake-lefthook-bin" ran="$SCRATCH/fake-lefthook.ran"
    mkdir -p "$fake"; rm -f "$ran"
    printf '#!/bin/sh\necho "fake lefthook $*" >> "%s"\ncase "$1" in version) echo 2.2.2 ;; *) echo "sync hooks: done" ;; esac\nexit 0\n' "$ran" > "$fake/lefthook"
    chmod +x "$fake/lefthook"
    check S-M2 "the trap is set: plain 'lefthook' on the child PATH is the fake" "it is not" \
      bash -c '[[ "$(PATH="$1" command -v lefthook)" == "$2" ]]' _ "$fake:$SCRATCH/path-no-lefthook" "$fake/lefthook"
    rm -f "$ran"
    run_ut "$d" "$e/path-lefthook" env PATH="$fake:$SCRATCH/path-no-lefthook" --
    check S-M2 "with lefthook only on PATH the step exits 1 (requirement missing)" "exit $RC" rc_is 1
    check S-M2 "an error: line names the missing project binary (node_modules)" "no 'error: … node_modules' line" \
      says "$e/path-lefthook" '^error:.*node_modules'
    check S-M2 "the PATH lefthook was never executed" "it ran: $(head -2 "$ran" 2>/dev/null | paste -sd'; ' -)" test ! -e "$ran"
  fi
}

# ── B — unborn HEAD ───────────────────────────────────────────────────────────
fx_B() {
  bold "▸ B — git init, no commits"
  local d e="$OUTPUT/B"; new_fixture d B unborn
  check EC-04 "the fixture has an unborn HEAD" "HEAD resolves" bash -c '! git -C "$1" rev-parse --verify -q HEAD >/dev/null' _ "$d"
  if ! ut_present "$d"; then fail EC-04 "$UNDER_TEST absent in the fixture — nothing to arm with"; return; fi
  run_ut "$d" "$e/arm" --
  check EC-04 "against an unborn HEAD the step exits 0" "exit $RC" rc_is 0
  check EC-04 "against an unborn HEAD the hooks arm" "unarmed" is_armed "$d"
}

# ── C — no .git ───────────────────────────────────────────────────────────────
fx_C() {
  bold "▸ C — a tree with no .git"
  local d e="$OUTPUT/C"; new_fixture d C nogit
  check ES-05 "the fixture is not a git repository" "git finds a repository" \
    bash -c '! git -C "$1" rev-parse --git-dir >/dev/null 2>&1' _ "$d"
  if ! ut_present "$d"; then fail ES-05 "$UNDER_TEST absent in the fixture — no skip path to observe"; return; fi
  run_ut "$d" "$e/arm" --
  check ES-05 "with no repository the step exits 0" "exit $RC" rc_is 0
  check ES-05 "it reports the skip because there is no git repository" "no 'skip' + 'git repo' wording" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi skip <<< "$o" && grep -qi "git repo" <<< "$o"' _ "$e/arm"
  check ES-05 "it creates no .git" ".git appeared" test ! -e "$d/.git"
}

# ── notice — the postinstall through a real pnpm install ──────────────────────
fx_notice() {
  bold "▸ notice — the postinstall through pnpm install"
  local d e="$OUTPUT/notice" c wt wired=true
  new_fixture d notice commit
  postinstall_wired "$d" || wired=false
  check ST02b "the fixture's postinstall calls install-hooks.sh --notice" "not wired — the silent cases below cannot pass honestly" $wired
  quiet_case() {   # id text evidence-prefix
    if ! $wired; then fail "$1" "$2 — vacuous: no postinstall is wired"; return; fi
    check "$1" "$2" "exit $RC or the notice printed" pnpm_quiet "$3"
  }

  manifest "$d/.git" "$e/git.before" || die "manifest of .git failed"
  pnpm_fresh "$d" "$e/unarmed" env -u CI
  check HP-08 "unarmed, CI unset: pnpm install exits 0" "exit $RC" rc_is 0
  check HP-08 "unarmed, CI unset: the notice names bash install.sh" "no notice in pnpm's output" pnpm_notice "$e/unarmed"
  manifest "$d/.git" "$e/git.after" || die "manifest of .git failed"
  check HP-08 "pnpm install writes nothing under .git/" "changed: $(changed_paths "$e/git.before" "$e/git.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/git.before" "$e/git.after"
  check ST02 "pnpm install leaves the hook unarmed" "a lifecycle script armed it" unarmed "$d"

  pnpm_fresh "$d" "$e/ci" env CI=true
  quiet_case EC-10 "CI set: pnpm install exits 0 and is silent" "$e/ci"

  pnpm_fresh "$d" "$e/no-git-path" env -u CI PATH="$(filtered_path "$SCRATCH/path-no-git" git; printf '%s' "$SCRATCH/path-no-git")"
  check ES-06 "git absent from PATH, in a repository: pnpm install exits 0" "exit $RC" rc_is 0
  quiet_case ES-06 "git absent from PATH, in a repository: pnpm install prints no notice" "$e/no-git-path"
  if ut_present "$d"; then
    run_ut "$d" "$e/no-git-direct" env -u CI PATH="$SCRATCH/path-no-git" -- --notice
    check ES-06 "git absent from PATH: --notice itself is silent (stdout and stderr empty), exit 0" "it spoke or failed" \
      notice_silent "$e/no-git-direct"
  fi

  if ut_present "$d"; then
    run_ut "$d" "$e/arm" --
    pnpm_fresh "$d" "$e/armed" env -u CI
    quiet_case EC-09 "armed: pnpm install exits 0 and is silent" "$e/armed"
  else
    fail EC-09 "armed: pnpm install is silent — $UNDER_TEST absent, nothing to arm with"
  fi

  c="$SCRATCH/notice-nogit"; snapshot "$c"
  pnpm_fresh "$c" "$e/nogit" env -u CI
  quiet_case EC-11 "no repository: pnpm install exits 0 and is silent" "$e/nogit"
  pnpm_fresh "$c" "$e/nogit-nogitbin" env -u CI PATH="$SCRATCH/path-no-git"
  check ES-06 "no repository and git absent from PATH: pnpm install exits 0" "exit $RC" rc_is 0
  quiet_case ES-06 "no repository and git absent from PATH: pnpm install prints no notice" "$e/nogit-nogitbin"

  local f; new_fixture f notice-wt-base commit
  add_worktree wt "$f" notice-wt bare
  pnpm_fresh "$wt" "$e/wt-unarmed" env -u CI
  check EC-12 "worktree, unarmed: pnpm install exits 0" "exit $RC" rc_is 0
  check EC-12 "worktree, unarmed: the notice prints" "no notice" pnpm_notice "$e/wt-unarmed"
  if ut_present "$wt"; then
    run_ut "$wt" "$e/wt-arm" --
    pnpm_fresh "$wt" "$e/wt-armed" env -u CI
    quiet_case EC-12 "worktree, armed: pnpm install is silent" "$e/wt-armed"
  else
    fail EC-12 "worktree, armed: silent — $UNDER_TEST absent, nothing to arm with"
  fi
}

# ── notice-streams — --notice on its own, streams apart ───────────────────────
fx_notice_streams() {
  bold "▸ notice-streams — --notice stdout and stderr captured separately"
  local e="$OUTPUT/notice-streams" d
  # EC-18: the oracle itself. A stderr-only notice must fail it; stdout-only must pass it.
  printf '' > "$e/ctl-stderr.out"; printf 'Run bash install.sh to arm the hooks\n' > "$e/ctl-stderr.err"; printf '0\n' > "$e/ctl-stderr.rc"
  printf 'Run bash install.sh to arm the hooks\n' > "$e/ctl-stdout.out"; printf '' > "$e/ctl-stdout.err"; printf '0\n' > "$e/ctl-stdout.rc"
  if notice_valid "$e/ctl-stderr" || ! notice_valid "$e/ctl-stdout"; then die "the stream oracle failed its own negative control (EC-18)"; fi
  pass EC-18 "negative control: a stderr-only notice fails the stream oracle; stdout-only passes"

  new_fixture d notice-streams commit
  if ! ut_present "$d"; then fail PA-03 "$UNDER_TEST absent in the fixture — no notice to capture"; return; fi
  manifest "$d" "$e/tree.before" || die "manifest failed"
  if command -v strace >/dev/null 2>&1; then
    run_ut "$d" "$e/unarmed" env -u CI strace -f -qq -e trace=execve,connect,open,openat -o "$e/strace.txt" -- --notice
    # strace keeps stderr apart: its own output goes to the -o file, the child's to .err.
  else
    notice "$d" "$e/unarmed"
  fi
  manifest "$d" "$e/tree.after" || die "manifest failed"
  check PA-03 "--notice exits 0 when unarmed" "exit $(cat "$e/unarmed.rc")" bash -c '[[ $(cat "$1") == 0 ]]' _ "$e/unarmed.rc"
  check PA-03 "the notice names bash install.sh on stdout, and stderr is empty" "oracle rejected the streams" notice_valid "$e/unarmed"
  check PA-03 "--notice writes no file anywhere in the checkout" "changed: $(changed_paths "$e/tree.before" "$e/tree.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/tree.before" "$e/tree.after"
  if [[ -f "$e/strace.txt" ]]; then
    check PA-03 "--notice opens no network connection" "an AF_INET/AF_INET6 connect() was traced" \
      bash -c '! grep -qE "connect\([0-9]+, \{sa_family=AF_INET6?" "$1"' _ "$e/strace.txt"
    check PA-03 "--notice opens no credential file" "a credential path was opened" \
      bash -c '! grep -E "open(at)?\(" "$1" | grep -qE "\.env\.(dev|test|testing|staging|prod|production)\"|\.npmrc\"|\.git-credentials\"|\.netrc\""' _ "$e/strace.txt"
  else
    unmeasured PA-03 "network and credential reads not traced — strace absent"
  fi
  run_ut "$d" "$e/ci" env CI=true -- --notice
  check EC-10 "--notice with CI set is silent and exits 0" "it spoke or failed" notice_silent "$e/ci"

  # T-n2: the postinstall must never be what fails an install.
  run_ut "$d" "$e/bogus" env -u CI -- --notice --bogus
  check T-n2 "--notice --bogus exits 0 with stderr empty" "exit $RC or stderr written" \
    bash -c '[[ $1 == 0 && ! -s "$2" ]]' _ "$RC" "$e/bogus.err"
  # A root it cannot enter: the script's own directory is reachable through the working
  # directory, but its checkout root (four levels up) has no search permission.
  local nx="$SCRATCH/notice-noroot"; mkdir -p "$nx/code/src/scripts/development"
  cp "$d/$UNDER_TEST" "$nx/$UNDER_TEST"
  (cd "$nx/code/src/scripts" && chmod 000 "$nx" &&
    if (cd "$nx" 2>/dev/null); then exit 99; fi
    env -u CI bash development/install-hooks.sh --notice) >"$e/noroot.out" 2>"$e/noroot.err" </dev/null; RC=$?
  chmod 755 "$nx"
  if [[ $RC == 99 ]]; then
    unmeasured T-n2 "the checkout root stayed enterable after chmod 000 (running as root?)"
  else
    check T-n2 "--notice exits 0 when the checkout root cannot be entered" "exit $RC" rc_is 0
  fi
}

# ── hook-paths — the effective path, every way it can be redirected ───────────
fx_hook_paths() {
  bold "▸ hook-paths — the effective hook, and only it, decides"
  local e="$OUTPUT/hook-paths" d p ext wt crg
  states_case() {   # id label dir — unarmed → notice prints; arm → exit 0, armed, silent
    local id="$1" label="$2" dir="$3" o="$e/$1-$2"
    notice "$dir" "$o.n1"
    check "$id" "$label: unarmed, --notice prints on stdout only" "oracle rejected it" notice_valid "$o.n1"
    run_ut "$dir" "$o.arm" --
    check "$id" "$label: the step exits 0" "exit $RC" rc_is 0
    check "$id" "$label: the effective hook is armed" "unarmed" is_armed "$dir"
    notice "$dir" "$o.n2"
    check "$id" "$label: armed, --notice is silent" "it spoke or failed" notice_silent "$o.n2"
  }
  new_fixture d hp-ordinary commit
  if ! ut_present "$d"; then fail EC-15 "$UNDER_TEST absent in the fixture — no predicate to exercise"; return; fi
  states_case EC-15 ordinary "$d"
  check EC-15 "ordinary: a throwaway commit runs the legs" "no lefthook summary" commit_runs_legs "$d" "$e/ordinary"

  new_fixture d hp-unborn unborn; states_case EC-15 unborn "$d"

  new_fixture d hp-wt-base commit; add_worktree wt "$d" hp-wt
  states_case EC-15 worktree "$wt"
  check EC-15 "worktree: a throwaway commit runs the legs" "no lefthook summary" commit_runs_legs "$wt" "$e/worktree"

  for mode in relative absolute; do
    new_fixture d "hp-$mode" commit
    (cd "$d" && pnpm exec lefthook install) >"$e/$mode.stale" 2>&1   # a genuine, soon-stale default hook
    check EC-15 "$mode: a lefthook-marked default hook exists before redirection" "staging failed" \
      bash -c 'grep -qF "$2" "$1/.git/hooks/pre-commit"' _ "$d" "$MARKER"
    # Inside the git common directory, so the round-5 rule still arms them; the outside-the-
    # repository cases are repo-shapes' (refused).
    if [[ $mode == relative ]]; then git -C "$d" config core.hooksPath .git/custom-hooks
    else ext="$d/.git/abs-hooks"; git -C "$d" config core.hooksPath "$ext"; fi
    p="$(eff_hook "$d")"
    check EC-15 "$mode: the effective hook ($p) is absent while the stale default exists" "effective path exists" test ! -e "$p"
    states_case EC-15 "$mode" "$d"
    check EC-15 "$mode: a throwaway commit runs the legs through the redirected hook" "no lefthook summary" \
      commit_runs_legs "$d" "$e/$mode"
  done

  # A linked worktree's .git is a file, so a hooks path inside the common directory is absolute.
  new_fixture d hp-wt-rel-base commit; git -C "$d" config core.hooksPath "$d/.git/custom-hooks"
  add_worktree wt "$d" hp-wt-rel
  states_case EC-15 worktree-common-dir "$wt"
  check EC-15 "worktree-common-dir: a throwaway commit runs the legs" "no lefthook summary" commit_runs_legs "$wt" "$e/worktree-common-dir"

  new_fixture d hp-nonexec commit; run_ut "$d" "$e/nonexec.arm" --; p="$(eff_hook "$d")"
  chmod -x "$p"
  notice "$d" "$e/nonexec.n1"
  check EC-16 "a marked, non-executable effective hook is unarmed: --notice prints" "it stayed silent" notice_valid "$e/nonexec.n1"
  run_ut "$d" "$e/nonexec.rearm" --
  check EC-16 "the step restores an executable lefthook hook" "exit $RC or unarmed" bash -c '[[ $1 == 0 ]]' _ "$RC"
  check EC-16 "…and it is armed" "unarmed" is_armed "$d"
  notice "$d" "$e/nonexec.n2"
  check EC-16 "once executable, --notice is silent" "it spoke" notice_silent "$e/nonexec.n2"

  crg="$(graph_tool)"
  if [[ -z "$crg" ]]; then
    unmeasured EC-14 "raw graph hook not staged — code-review-graph $CRG_PIN unavailable"
  else
    new_fixture d hp-graph commit
    $crg install --repo "$d" -y --platform claude >"$e/graph.install" 2>&1 </dev/null
    if grep -qF "$GRAPH_MARKER" "$(eff_hook "$d")" 2>/dev/null; then
      notice "$d" "$e/graph.n1"
      check EC-14 "a raw code-review-graph hook is not lefthook's: --notice prints" "it stayed silent" notice_valid "$e/graph.n1"
    else
      unmeasured EC-14 "code-review-graph install wrote no hook at the effective path"
    fi
  fi

  # core.hooksPath=/dev/null is a deliberate opt-out (plan, Red-phase answers — 17/11/2026): the
  # step warns that hooks are disabled, arms nothing and exits 0; --notice still prints.
  new_fixture d hp-devnull commit; git -C "$d" config core.hooksPath /dev/null
  manifest "$d/.git/hooks" "$e/devnull.hooks.before" || die "manifest of .git/hooks failed"
  notice "$d" "$e/devnull.n"
  check S-m2 "core.hooksPath=/dev/null: --notice prints 'git config --unset-all core.hooksPath' on stdout only, exit 0" \
    "hint absent, stderr written or non-zero exit" notice_says "$e/devnull.n" 'git config --unset-all core.hooksPath'

  run_ut "$d" "$e/devnull.arm" --
  check P3 "core.hooksPath=/dev/null: the step is an opt-out and exits 0" "exit $RC" rc_is 0
  check P3 "core.hooksPath=/dev/null: the step says hooks are disabled by that setting" \
    "no 'disabled' together with 'hooksPath' or '/dev/null' in the output" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi disabled <<< "$o" && grep -qiE "hookspath|/dev/null" <<< "$o"' _ "$e/devnull.arm"
  check P3 "core.hooksPath=/dev/null: the setting is left in place" "it was changed" \
    bash -c '[[ "$(git -C "$1" config --get core.hooksPath)" == /dev/null ]]' _ "$d"
  manifest "$d/.git/hooks" "$e/devnull.hooks.after" || die "manifest of .git/hooks failed"
  check P3 "core.hooksPath=/dev/null: nothing under the default .git/hooks changed" \
    "changed: $(changed_paths "$e/devnull.hooks.before" "$e/devnull.hooks.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/devnull.hooks.before" "$e/devnull.hooks.after"
  check P3 "core.hooksPath=/dev/null: no lefthook hook was written to the default path" "one was" \
    bash -c '! grep -qsF "$2" "$1/.git/hooks/pre-commit"' _ "$d" "$MARKER"

  # Any OTHER unresolvable path stays a failure: a hooks path whose parent is a regular file.
  new_fixture d hp-unresolvable commit; printf 'not a directory\n' > "$d/hooks-blocker"
  git -C "$d" config core.hooksPath "$d/hooks-blocker/hooks"
  check P3 "unresolvable core.hooksPath: git itself cannot resolve the hook path" "git resolved it" \
    bash -c '! (cd "$1" && git rev-parse --path-format=absolute --git-path hooks/pre-commit >/dev/null 2>&1)' _ "$d"
  notice "$d" "$e/unresolvable.n"
  check P3 "unresolvable core.hooksPath: --notice still exits 0" "exit $(cat "$e/unresolvable.n.rc")" \
    bash -c '[[ $(cat "$1") == 0 ]]' _ "$e/unresolvable.n.rc"
  check R3-N3 "unresolvable core.hooksPath: --notice's stdout hint names core.hooksPath, stderr empty" \
    "hint names only bash install.sh, or stderr written" notice_says "$e/unresolvable.n" 'core.hooksPath'
  run_ut "$d" "$e/unresolvable.arm" --
  check P3 "unresolvable core.hooksPath: the step fails with exit 2" "exit $RC" rc_is 2
  check P3 "unresolvable core.hooksPath: the failure is an err-idiom 'error:' line" "no 'error:' line on stderr" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.err" | grep -q "^error:"' _ "$e/unresolvable.arm"
}

# ── old-backup — a pre-commit.old already present is never lost (Q2) ─────────
hook_dir_hashes() { find "$1" -maxdepth 1 -type f -exec sha256sum {} + 2>/dev/null | cut -d' ' -f1 | LC_ALL=C sort; }
fx_old_backup() {
  bold "▸ old-backup — an existing pre-commit.old is moved aside, never overwritten"
  local e="$OUTPUT/old-backup" d variant p hd ho hh moved
  for variant in default hookspath; do
    new_fixture d "ob-$variant" commit
    if ! ut_present "$d"; then fail Q2 "$variant: $UNDER_TEST absent in the fixture — nothing to arm with"; return; fi
    [[ $variant == hookspath ]] && git -C "$d" config core.hooksPath .git/custom-hooks
    p="$(eff_hook "$d")"; hd="${p%/pre-commit}"; mkdir -p "$hd"
    printf '#!/bin/sh\necho hand-written hook %s\n' "$variant" > "$p"; chmod +x "$p"
    printf 'the original pre-commit.old (%s), which must survive\n' "$variant" > "$hd/pre-commit.old"
    ho="$(sha256sum "$hd/pre-commit.old" | cut -d' ' -f1)"; hh="$(sha256sum "$p" | cut -d' ' -f1)"
    run_ut "$d" "$e/$variant" --
    hook_dir_hashes "$hd" > "$e/$variant.hashes"
    moved="$(cd "$hd" && compgen -G 'pre-commit.old.?*' | head -1)"
    check Q2 "$variant: the step exits 0 with a pre-commit.old already present" "exit $RC" rc_is 0
    check Q2 "$variant: the effective hook is armed" "unarmed" is_armed "$d"
    check Q2 "$variant: the existing .old was moved to a timestamped pre-commit.old.<…> in the same dir" "no such file" \
      test -n "$moved"
    check Q2 "$variant: the move is reported" "output names neither ${moved:-the new name} nor 'timestamp'/'moved'" \
      bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; { [[ -n $2 ]] && grep -qF "$2" <<< "$o"; } || grep -qiE "timestamp|moved" <<< "$o"' _ "$e/$variant" "$moved"
    check Q2 "$variant: the original .old content survives in the hook dir" "its hash is gone" grep -qxF "$ho" "$e/$variant.hashes"
    check Q2 "$variant: the replaced hook's content survives in the hook dir" "its hash is gone" grep -qxF "$hh" "$e/$variant.hashes"
  done

  new_fixture d ob-nonexec commit
  run_ut "$d" "$e/nonexec.arm" --; p="$(eff_hook "$d")"; chmod -x "$p"
  run_ut "$d" "$e/nonexec" --
  check Q2 "non-executable lefthook hook: the step exits 0 and re-arms" "exit $RC or unarmed" \
    bash -c '[[ $1 == 0 ]]' _ "$RC"
  check Q2 "non-executable lefthook hook: the output claims no .old was kept" "it mentions a .old" \
    bash -c '! sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF ".old"' _ "$e/nonexec"

  # R4-QA-01/R4-QA-03 — the ownership signal is lefthook's own: the string LEFTHOOK.
  # (1) A FOREIGN hook that merely mentions LEFTHOOK: lefthook would overwrite it with no .old.
  local hfh
  new_fixture d ob-own-mention commit; p="$(eff_hook "$d")"; hd="${p%/*}"
  printf '#!/bin/sh\n# a foreign hook; set LEFTHOOK=0 to skip it\necho foreign hook\n' > "$p"; chmod +x "$p"
  hfh="$(sha256sum "$p" | cut -d' ' -f1)"
  notice "$d" "$e/own-mention.n"
  check R4-QA-01 "a foreign hook mentioning LEFTHOOK is unarmed: --notice prints" "it stayed silent" notice_valid "$e/own-mention.n"
  run_ut "$d" "$e/own-mention" --
  hook_dir_hashes "$hd" > "$e/own-mention.hashes"
  check R4-QA-01 "the step exits 0" "exit $RC" rc_is 0
  check R4-QA-01 "the effective hook is armed" "unarmed" is_armed "$d"
  check R4-QA-01 "the foreign hook's content survives in the hooks dir" "its hash is gone — overwritten in place" \
    grep -qxF "$hfh" "$e/own-mention.hashes"
  check R4-QA-01 "the report is truthful: any pre-commit.old it names holds that content" \
    "it names a pre-commit.old that does not hold the replaced hook" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -q "pre-commit\.old" <<< "$o" || exit 0
             for hf in "$2"/pre-commit.old*; do [[ -f $hf && "$(sha256sum "$hf" | cut -d" " -f1)" == "$3" ]] && exit 0; done; exit 1' \
    _ "$e/own-mention" "$hd" "$hfh"
  # (2) lefthook's marker WITHOUT the LEFTHOOK string, with a pre-commit.old beside it.
  new_fixture d ob-own-marker commit; p="$(eff_hook "$d")"; hd="${p%/*}"
  printf '#!/bin/sh\ncall_lefthook() { :; }\ncall_lefthook run "pre-commit" "$@"\n' > "$p"; chmod +x "$p"
  printf 'the pre-commit.old beside a marker-only hook\n' > "$hd/pre-commit.old"
  ho="$(sha256sum "$hd/pre-commit.old" | cut -d' ' -f1)"
  notice "$d" "$e/own-marker.n"
  check R4-QA-03 "a marker without LEFTHOOK is not armed: --notice prints" "it stayed silent" notice_valid "$e/own-marker.n"
  run_ut "$d" "$e/own-marker" --
  check R4-QA-03 "the step exits 0" "exit $RC" rc_is 0
  check R4-QA-03 "the effective hook is armed" "unarmed" is_armed "$d"
  check R4-QA-03 "the existing pre-commit.old survives" "its hash is gone" \
    bash -c 'find "$2" -maxdepth 1 -type f -exec sha256sum {} + | cut -d" " -f1 | grep -qxF "$1"' _ "$ho" "$hd"

  # R3-S-m1: the move is reported even when lefthook then fails. lefthook.yml is made invalid
  # YAML — `lefthook version` still runs, `lefthook install` fails.
  new_fixture d ob-failure commit; p="$(eff_hook "$d")"; hd="${p%/*}"
  printf '#!/bin/sh\necho hand-written hook\n' > "$p"; chmod +x "$p"
  printf 'the original pre-commit.old, which must survive\n' > "$hd/pre-commit.old"
  ho="$(sha256sum "$hd/pre-commit.old" | cut -d' ' -f1)"
  printf 'pre-commit: [\n' > "$d/lefthook.yml"
  run_ut "$d" "$e/failure" --
  moved="$(cd "$hd" && compgen -G 'pre-commit.old.?*' | head -1)"
  check R3-S-m1 "a lefthook install failure after the move exits 2" "exit $RC" rc_is 2
  check R3-S-m1 "the failure output names the moved .old's new name" "output does not name ${moved:-a pre-commit.old.<…> file}" \
    bash -c '[[ -n $2 ]] && sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF "$2"' _ "$e/failure" "$moved"
  check R3-S-m1 "the original .old content survives the failure" "its hash is gone" \
    bash -c 'hook_dir_hashes() { find "$1" -maxdepth 1 -type f -exec sha256sum {} + | cut -d" " -f1; }; hook_dir_hashes "$2" | grep -qxF "$1"' _ "$ho" "$hd"

  # SEC-02 / QA-01: a symlinked pre-commit is foreign. Three targets outside the hooks dir: a
  # foreign script; the same with a decoy pre-commit.old beside the target and a REAL one in the
  # hooks dir; and a genuine lefthook hook, which a symlink must not make "armed".
  local case tdir tgt
  for case in foreign with-old lefthook-target; do
    new_fixture d "ob-sym-$case" commit; p="$(eff_hook "$d")"; hd="${p%/*}"
    tdir="$SCRATCH/sym-target-$case"; mkdir -p "$tdir"; tgt="$tdir/pre-commit-target"
    if [[ $case == lefthook-target ]]; then
      (cd "$d" && pnpm exec lefthook install) >/dev/null 2>&1; cp "$p" "$tgt"; rm -f "$p"
    else
      printf '#!/bin/sh\necho foreign symlink target\n' > "$tgt"
    fi
    chmod +x "$tgt"; ln -s "$tgt" "$p"
    ho=""
    if [[ $case == with-old ]]; then
      printf 'decoy beside the target — must not move\n' > "$tdir/pre-commit.old"
      printf 'the real pre-commit.old in the hooks dir\n' > "$hd/pre-commit.old"
      ho="$(sha256sum "$hd/pre-commit.old" | cut -d' ' -f1)"
    fi
    manifest "$tdir" "$e/sym-$case.target.before" || die "manifest of the symlink target dir failed"
    notice "$d" "$e/sym-$case.n"
    check SEC-02 "$case: a symlinked hook is unarmed — --notice prints on stdout only" "it stayed silent" notice_valid "$e/sym-$case.n"
    run_ut "$d" "$e/sym-$case" --
    manifest "$tdir" "$e/sym-$case.target.after" || die "manifest of the symlink target dir failed"
    check SEC-02 "$case: the step exits 0" "exit $RC" rc_is 0
    check SEC-02 "$case: the effective hook is armed" "unarmed" is_armed "$d"
    check SEC-02 "$case: the symlink itself was replaced by a regular file" "the hook is still a symlink" \
      bash -c '[[ ! -L "$1" && -f "$1" ]]' _ "$p"
    check SEC-02 "$case: the replacement is reported" "no 'replac…' in the output" says "$e/sym-$case" 'replac'
    check SEC-02 "$case: it is not reported as already armed" "it printed 'already armed'" \
      bash -c '! grep -qi "already armed" "$1.out" "$1.err"' _ "$e/sym-$case"
    check SEC-02 "$case: the target and its directory are untouched (path/type/mode/hash)" \
      "changed: $(changed_paths "$e/sym-$case.target.before" "$e/sym-$case.target.after" | head -3 | paste -sd' ' -)" \
      cmp -s "$e/sym-$case.target.before" "$e/sym-$case.target.after"
    if [[ -n "$ho" ]]; then
      moved="$(cd "$hd" && compgen -G 'pre-commit.old.?*' | head -1)"
      check SEC-02 "$case: the hooks dir's real pre-commit.old was moved to a timestamped name" "no such file" test -n "$moved"
      check SEC-02 "$case: its content survives in the hooks dir" "its hash is gone" \
        bash -c 'find "$2" -maxdepth 1 -type f -exec sha256sum {} + | cut -d" " -f1 | grep -qxF "$1"' _ "$ho" "$hd"
    fi
  done
}

# One route to a hooks directory outside the git common directory. Refused (exit 2) with an
# error: line naming the directory as outside the repository; nothing written there; --notice
# hints; and a remedy hint shaped by where the setting came from.
shared_route() {   # route label
  local route="$1" label="$2" e="$OUTPUT/repo-shapes" d sh cfg run_dir pre=() hint_re hint_desc
  new_fixture d "rs-route-$route" commit
  sh="$SCRATCH/rs-shared-$route"; mkdir -p "$sh"
  printf '#!/bin/sh\necho a shared hook\n' > "$sh/pre-commit"; chmod +x "$sh/pre-commit"
  cfg="$SCRATCH/rs-cfg-$route"; printf '[core]\n\thooksPath = %s\n' "$sh" > "$cfg"
  run_dir="$d"
  case "$route" in
    system)    pre=(env -u GIT_CONFIG_NOSYSTEM GIT_CONFIG_SYSTEM="$cfg")
               hint_re='git config --system --unset core\.hooksPath'; hint_desc="'git config --system --unset core.hooksPath'" ;;
    gitconfig) pre=(env GIT_CONFIG="$cfg")
               hint_re='GIT_CONFIG([^_A-Z]|$)'; hint_desc="GIT_CONFIG" ;;
    count)     pre=(env GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0="$sh")
               hint_re='GIT_CONFIG_COUNT|GIT_CONFIG_PARAMETERS|environment'; hint_desc="GIT_CONFIG_COUNT, GIT_CONFIG_PARAMETERS or 'environment'" ;;
    include)   git -C "$d" config include.path "$cfg"
               hint_re="$cfg"; hint_desc="the included file $cfg" ;;
    symlink)   rm -rf "$d/.git/hooks"; ln -s "$sh" "$d/.git/hooks"
               hint_re='symlink'; hint_desc="'symlink'" ;;
    local)     git -C "$d" config core.hooksPath "$sh"
               hint_re='git config --local'; hint_desc="'git config --local'" ;;
    local-wt)  git -C "$d" config core.hooksPath "$sh"; add_worktree run_dir "$d" "rs-route-local-wt-wt"
               hint_re="git config --local core\.hooksPath \"?$(realpath "$d/.git")/hooks"
               hint_desc="'git config --local core.hooksPath $(realpath "$d/.git")/hooks' (absolute)" ;;
  esac
  manifest "$sh" "$e/route-$route.shared.before" || die "manifest failed"
  run_ut "$run_dir" "$e/route-$route" "${pre[@]}" --
  manifest "$sh" "$e/route-$route.shared.after" || die "manifest failed"
  check R5 "$label: refused, exit 2" "exit $RC" rc_is 2
  check R5 "$label: an error: line names the hooks dir as outside the repository" \
    "no '^error:' line with 'outside' and $(realpath "$sh")" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.err" | grep -i "^error:.*outside" | grep -qF "$2"' _ "$e/route-$route" "$(realpath "$sh")"
  check R5 "$label: nothing in the shared dir changed, and no lefthook hook appeared there" \
    "changed: $(changed_paths "$e/route-$route.shared.before" "$e/route-$route.shared.after" | head -3 | paste -sd' ' -)" \
    bash -c 'cmp -s "$1" "$2" && ! grep -rqF "$4" "$3"' _ "$e/route-$route.shared.before" "$e/route-$route.shared.after" "$sh" "$MARKER"
  check R5-hint "$label: the remedy names $hint_desc" "absent" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qE -- "$2"' _ "$e/route-$route" "$hint_re"
  if [[ $route == local-wt ]]; then
    check R5-hint "$label: the remedy is not the literal relative .git/hooks" "it says core.hooksPath .git/hooks" \
      bash -c '! sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qE "core\.hooksPath \"?\.git/hooks"' _ "$e/route-$route"
  fi
  run_ut "$run_dir" "$e/route-$route.n" env -u CI "${pre[@]:1}" -- --notice
  check R5 "$label: --notice exits 0 with a stdout hint, stderr empty" "silent, failed or stderr written" \
    bash -c '[[ $(cat "$1.rc") == 0 && -s "$1.out" && ! -s "$1.err" ]]' _ "$e/route-$route.n"
}

# ── repo-shapes — the repositories install-hooks.sh must refuse, skip or see through ──
fx_repo_shapes() {
  bold "▸ repo-shapes — global hooksPath, nested project, GIT_DIR, broken repo, empty hooksPath"
  local e="$OUTPUT/repo-shapes" d g gcfg o x gh key
  # 1 — a core.hooksPath from GLOBAL scope is refused, exit 2.
  new_fixture d rs-global commit
  if ! ut_present "$d"; then fail RS "$UNDER_TEST absent in the fixture — nothing to probe"; return; fi
  g="$SCRATCH/rs-global-hooks"; mkdir -p "$g"
  printf '#!/bin/sh\necho a machine-wide hook\n' > "$g/pre-commit"; chmod +x "$g/pre-commit"
  gcfg="$SCRATCH/gitconfig-global-hookspath"; cp "$GIT_CONFIG_GLOBAL" "$gcfg"
  git config --file "$gcfg" core.hooksPath "$g"
  gh="$(sha256sum "$g/pre-commit" | cut -d' ' -f1)"
  manifest "$g" "$e/global.dir.before" || die "manifest failed"
  run_ut "$d" "$e/global" env GIT_CONFIG_GLOBAL="$gcfg" --
  manifest "$g" "$e/global.dir.after" || die "manifest failed"
  check GLOBAL "a global core.hooksPath is refused: exit 2" "exit $RC" rc_is 2
  check GLOBAL "the error: line names the global scope" "no '^error:' line containing 'global'" \
    says "$e/global" '^error:.*global'
  check R4-QA-04 "global: the remedy names 'git config --global --unset core.hooksPath'" "remedy absent" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF "git config --global --unset core.hooksPath"' _ "$e/global"
  check GLOBAL "the global hook's hash is unchanged" "it changed" \
    bash -c '[[ "$(sha256sum "$1" | cut -d" " -f1)" == "$2" ]]' _ "$g/pre-commit" "$gh"
  check GLOBAL "nothing in the global hooks dir changed, and no lefthook hook appeared there" \
    "changed: $(changed_paths "$e/global.dir.before" "$e/global.dir.after" | head -3 | paste -sd' ' -)" \
    bash -c 'cmp -s "$1" "$2" && ! grep -rqF "$4" "$3"' _ "$e/global.dir.before" "$e/global.dir.after" "$g" "$MARKER"
  run_ut "$d" "$e/global.n" env -u CI GIT_CONFIG_GLOBAL="$gcfg" -- --notice
  check GLOBAL "--notice: exit 0, stdout hint names core.hooksPath, stderr empty" "hint absent or stderr written" \
    notice_says "$e/global.n" 'core.hooksPath'

  # 2 — every other route to a hooks directory outside the git common directory: refused.
  shared_route system  "system scope"
  shared_route gitconfig "GIT_CONFIG"
  shared_route count   "GIT_CONFIG_COUNT"
  shared_route include "a local include.path"
  shared_route symlink "a symlinked .git/hooks"
  shared_route local   "a local absolute core.hooksPath"
  shared_route local-wt "a local absolute core.hooksPath, from a linked worktree"
  # R5-AMB: the literal settled rule ("inside the git common directory") also refuses a hooks
  # directory in the working tree outside .git. Flagged for confirmation, not yet settled.
  new_fixture d rs-worktree-hooks commit; git -C "$d" config core.hooksPath .githooks
  run_ut "$d" "$e/worktree-hooks" --
  check R5-AMB "a hooks dir in the working tree but outside .git (.githooks) is refused: exit 2" "exit $RC" rc_is 2

  # 3 — a project nested in an unrelated repository, its own .git removed (QA-02): skip.
  o="$SCRATCH/rs-outer"; mkdir -p "$o"; git -C "$o" init -q; printf 'outer\n' > "$o/OUTER.txt"
  if ! { git -C "$o" add OUTER.txt && git -C "$o" commit -q -m outer; }; then die "outer repo setup failed"; fi
  snapshot "$o/inner"; provision "$o/inner"
  manifest "$o/.git/hooks" "$e/nested.hooks.before" || die "manifest failed"
  run_ut "$o/inner" "$e/nested" --
  manifest "$o/.git/hooks" "$e/nested.hooks.after" || die "manifest failed"
  check QA-02 "nested in an unrelated repository: the step exits 0" "exit $RC" rc_is 0
  check QA-02 "it reports a skip because the project is not the repository's root" "no 'skip' with 'root'/'nested'" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi skip <<< "$o" && grep -qiE "root|nested" <<< "$o"' _ "$e/nested"
  check QA-02 "the outer repository's hooks dir is unchanged" \
    "changed: $(changed_paths "$e/nested.hooks.before" "$e/nested.hooks.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/nested.hooks.before" "$e/nested.hooks.after"
  check QA-02 "no file was written into the outer repository's root (lefthook creates a lefthook.yml there)" \
    "lefthook.yml appeared in the outer repository" test ! -e "$o/lefthook.yml"
  notice "$o/inner" "$e/nested.n"
  check QA-02 "nested: --notice is silent and exits 0" "it spoke or failed" notice_silent "$e/nested.n"

  # 4 — GIT_DIR / GIT_WORK_TREE pointing at another repository (QA-03): ignored.
  new_fixture d rs-gitdir commit
  x="$SCRATCH/rs-other"; mkdir -p "$x"; git -C "$x" init -q
  manifest "$x/.git/hooks" "$e/gitdir.other.before" || die "manifest failed"
  run_ut "$d" "$e/gitdir" env GIT_DIR="$x/.git" GIT_WORK_TREE="$x" --
  manifest "$x/.git/hooks" "$e/gitdir.other.after" || die "manifest failed"
  check QA-03 "GIT_DIR/GIT_WORK_TREE set elsewhere: the step exits 0" "exit $RC" rc_is 0
  check QA-03 "the project's own checkout is armed" "unarmed" is_armed "$d"
  check QA-03 "the other repository's hooks are unchanged" \
    "changed: $(changed_paths "$e/gitdir.other.before" "$e/gitdir.other.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/gitdir.other.before" "$e/gitdir.other.after"
  check QA-03 "no file was written into the other repository's root" "lefthook.yml appeared there" test ! -e "$x/lefthook.yml"

  # 5 — a present but broken repository (SEC-03): exit 2 with git's error; --notice hints.
  local variant
  for variant in corrupt-head unreadable-config; do
    new_fixture d "rs-$variant" commit
    if [[ $variant == corrupt-head ]]; then printf 'not a ref\n' > "$d/.git/HEAD"
    else
      chmod 000 "$d/.git/config"
      if [[ -r "$d/.git/config" ]]; then unmeasured SEC-03 "$variant: config stayed readable after chmod 000 (root?)"; chmod 644 "$d/.git/config"; continue; fi
    fi
    run_ut "$d" "$e/$variant" --
    check SEC-03 "$variant: the step exits 2" "exit $RC" rc_is 2
    check SEC-03 "$variant: an error: line, with git's own error in the output" "no '^error:' line or no git error text" \
      bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -q "^error:" <<< "$o" && grep -qiE "fatal|not a git repository|unable to access|permission denied" <<< "$o"' _ "$e/$variant"
    notice "$d" "$e/$variant.n"
    check SEC-03 "$variant: --notice exits 0 with a stdout hint and stderr empty" "silent, failed or stderr written" \
      bash -c '[[ $(cat "$1.rc") == 0 && -s "$1.out" && ! -s "$1.err" ]]' _ "$e/$variant.n"
    chmod 644 "$d/.git/config" 2>/dev/null
  done

  # 6 — a bare-configured repository at the project root (R4-03): exit 2, never "nested".
  for variant in bare worktree-elsewhere; do
    new_fixture d "rs-$variant" commit
    if [[ $variant == bare ]]; then git -C "$d" config core.bare true; key=core.bare
    else mkdir -p "$SCRATCH/rs-elsewhere"; git -C "$d" config core.worktree "$SCRATCH/rs-elsewhere"; key=core.worktree; fi
    run_ut "$d" "$e/$variant" --
    check R4-03 "$variant: the step exits 2" "exit $RC" rc_is 2
    check R4-03 "$variant: the error: line names $key" "no '^error:' line naming $key" says "$e/$variant" "^error:.*${key/./\\.}"
    check R4-03 "$variant: it is not reported as nested" "it says nested" bash -c '! grep -qi nested "$1.out" "$1.err"' _ "$e/$variant"
    notice "$d" "$e/$variant.n"
    check R4-03 "$variant: --notice exits 0 with a stdout hint, stderr empty" "silent, failed or stderr written" \
      bash -c '[[ $(cat "$1.rc") == 0 && -s "$1.out" && ! -s "$1.err" ]]' _ "$e/$variant.n"
  done

  # 7 — the project's own .git is BROKEN inside a healthy outer repository (R4-QA-06). git
  # climbs past the broken .git to the outer one (measured), so the step must look itself.
  o="$SCRATCH/rs-outer2"; mkdir -p "$o"; git -C "$o" init -q; printf 'outer\n' > "$o/OUTER.txt"
  if ! { git -C "$o" add OUTER.txt && git -C "$o" commit -q -m outer; }; then die "outer repo setup failed"; fi
  snapshot "$o/inner"; provision "$o/inner"; git -C "$o/inner" init -q; printf 'not a ref\n' > "$o/inner/.git/HEAD"
  manifest "$o/.git/hooks" "$e/broken-inner.hooks.before" || die "manifest failed"
  run_ut "$o/inner" "$e/broken-inner" --
  manifest "$o/.git/hooks" "$e/broken-inner.hooks.after" || die "manifest failed"
  check R4-QA-06 "a broken .git inside a healthy outer repo: the step exits 2" "exit $RC" rc_is 2
  check R4-QA-06 "it is classified broken: an error: line with git's error, never 'nested'" "no git error, or it says nested" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -q "^error:" <<< "$o" && grep -qiE "fatal|not a git repository|invalid|broken" <<< "$o" && ! grep -qi nested <<< "$o"' _ "$e/broken-inner"
  check R4-QA-06 "the outer repository's hooks dir is unchanged" \
    "changed: $(changed_paths "$e/broken-inner.hooks.before" "$e/broken-inner.hooks.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/broken-inner.hooks.before" "$e/broken-inner.hooks.after"
  check R4-QA-06 "no lefthook.yml written into the outer repository" "one appeared" test ! -e "$o/lefthook.yml"
  notice "$o/inner" "$e/broken-inner.n"
  check R4-QA-06 "--notice exits 0 with a stdout hint, stderr empty" "silent, failed or stderr written" \
    bash -c '[[ $(cat "$1.rc") == 0 && -s "$1.out" && ! -s "$1.err" ]]' _ "$e/broken-inner.n"

  # 8 — an empty core.hooksPath (QA-04): git resolves it to /pre-commit. Exit 2, named.
  new_fixture d rs-empty commit; git -C "$d" config core.hooksPath ""
  run_ut "$d" "$e/empty" --
  check QA-04 "an empty core.hooksPath: the step exits 2" "exit $RC" rc_is 2
  check QA-04 "the error: line names core.hooksPath" "no '^error:' line naming core.hooksPath" says "$e/empty" '^error:.*core\.hookspath'
  notice "$d" "$e/empty.n"
  check QA-04 "--notice's stdout hint names core.hooksPath, stderr empty" "hint absent or stderr written" \
    notice_says "$e/empty.n" 'core.hooksPath'
}

# ── change-filter — the install-failure job's filter, offline (R4-SEC-03) ─────
fx_change_filter() {
  bold "▸ change-filter — --needs-install-failure against a scratch repository"
  local r="$SCRATCH/cf" c0 got
  mkdir -p "$r/code" "$r/project-management" "$r/research" "$r/handoffs" "$r/docs"
  git -C "$r" init -q
  printf 'echo code\n' > "$r/code/run.sh"; printf 'pm\n' > "$r/project-management/a.txt"
  printf 'r\n' > "$r/research/r.txt"; printf 'h\n' > "$r/handoffs/h.txt"; printf '# A\n' > "$r/docs/A.md"
  if ! { git -C "$r" add -A && git -C "$r" commit -q -m base; }; then die "change-filter setup failed"; fi
  c0="$(git -C "$r" rev-parse HEAD)"
  cf_case() {   # id expected label — commits what the caller staged, classifies parent..HEAD
    local id="$1" want="$2" label="$3" base
    base="$(git -C "$r" rev-parse HEAD)"
    git -C "$r" commit -q -m "$label" --allow-empty || die "change-filter commit failed"
    got="$(bash "$SCRIPT_DIR/hook-arming.sh" --source "$r" --needs-install-failure "$base")"
    check R4-SEC-03 "$label → $want" "got '$got'" test "$got" == "$want"
  }
  printf '# A edited\n' > "$r/docs/A.md"; git -C "$r" add -A; cf_case CF "false" "a markdown file only"
  printf 'pm2\n' >> "$r/project-management/a.txt"; printf 'r2\n' >> "$r/research/r.txt"; printf 'h2\n' >> "$r/handoffs/h.txt"
  git -C "$r" add -A; cf_case CF "false" "project-management/, research/ and handoffs/ only"
  printf 'x\n' > "$r/project-management/ünïcødé dir with spaces.txt"; git -C "$r" add -A
  cf_case CF "false" "a non-ASCII path with spaces under project-management/ (core.quotePath=false)"
  git -C "$r" mv code/run.sh docs/run.md; cf_case CF "true" "a rename from code/ to a .md (--no-renames: the deleted side counts)"
  printf 'echo again\n' > "$r/code/new.sh"; git -C "$r" add -A; cf_case CF "true" "a code file"
  cf_case CF "true" "an empty diff (fail open)"
  got="$(bash "$SCRIPT_DIR/hook-arming.sh" --source "$r" --needs-install-failure "")"
  check R4-SEC-03 "an empty BASE (manual run) → true" "got '$got'" test "$got" == "true"
  got="$(bash "$SCRIPT_DIR/hook-arming.sh" --source "$r" --needs-install-failure 0000000000000000000000000000000000000000)"
  check R4-SEC-03 "an all-zero BASE (new branch) → true" "got '$got'" test "$got" == "true"
  got="$(bash "$SCRIPT_DIR/hook-arming.sh" --source "$r" --needs-install-failure deadbeefdeadbeefdeadbeefdeadbeefdeadbeef)"
  check R4-SEC-03 "a BASE that is not a readable commit → true" "got '$got'" test "$got" == "true"
  got="$(bash "$SCRIPT_DIR/hook-arming.sh" --source "$r" --needs-install-failure "$c0")"
  check R4-SEC-03 "the whole range from the first commit (code touched) → true" "got '$got'" test "$got" == "true"
}

# ── write-boundary — the arming step writes only into the effective hook dir ──
fx_write_boundary() {
  bold "▸ write-boundary — full-tree manifests around the arming step"
  local e="$OUTPUT/write-boundary" d ig igd hookrel ck out
  new_fixture d wb commit
  ig="code/src/logs/hook-arming-probe.log"; igd="node_modules/.hook-arming-probe/sentinel"
  mkdir -p "$d/${igd%/*}"; printf 'synthetic ignored file\n' > "$d/$ig"; printf 'synthetic file in an ignored directory\n' > "$d/$igd"
  if ! { git -C "$d" check-ignore -q "$ig" && git -C "$d" check-ignore -q "$igd"; }; then
    die "the synthetic plants are not ignored — pick other paths"
  fi

  # EC-17: the oracle must catch a content change Git cannot see.
  local gs1 gs2
  manifest "$d" "$e/ctl.before" || die "manifest failed (unreadable or unrepresentable path)"
  gs1="$(git -C "$d" status --porcelain --ignored=no)"
  printf 'mutated\n' > "$d/$ig"; chmod 600 "$d/$igd"
  manifest "$d" "$e/ctl.after" || die "manifest failed"
  gs2="$(git -C "$d" status --porcelain --ignored=no)"
  changed_paths "$e/ctl.before" "$e/ctl.after" > "$e/ctl.changed"
  if [[ "$gs1" != "$gs2" ]] || ! grep -qxF "./$ig" "$e/ctl.changed" || ! grep -qxF "./$igd" "$e/ctl.changed"; then
    die "the manifest oracle failed its own negative control (EC-17)"
  fi
  pass EC-17 "negative control: ignored-file content and mode changes fail the oracle while git status is identical"
  printf 'synthetic ignored file\n' > "$d/$ig"; chmod 644 "$d/$igd"

  if ! ut_present "$d"; then fail ST05 "$UNDER_TEST absent in the fixture — no step to measure"; return; fi
  for variant in default redirected; do
    out="$e/$variant"
    if [[ $variant == redirected ]]; then   # inside the common dir: an outside one is refused (repo-shapes)
      rm -f "$d/.git/hooks/pre-commit"; git -C "$d" config core.hooksPath .git/wb-redirected
    fi
    hookrel="$(eff_hook "$d")"; hookrel="${hookrel%/pre-commit}"
    case "$hookrel" in "$d"/*) hookrel="./${hookrel#"$d"/}" ;; *) hookrel="" ;; esac
    ck="$(cd "$d" && git rev-parse --git-common-dir)/info/lefthook.checksum"; [[ "$ck" == /* ]] || ck="./$ck"
    manifest "$d" "$out.before" || die "manifest failed"
    run_ut "$d" "$out.arm" --
    manifest "$d" "$out.after" || die "manifest failed"
    changed_paths "$out.before" "$out.after" > "$out.changed"
    outside "$out.changed" "$hookrel" "$ck" > "$out.outside"
    check ST05 "$variant: the step exits 0" "exit $RC" rc_is 0
    check ST05 "$variant: nothing outside the effective hook directory changed (path/type/mode/target/hash)" \
      "changed: $(head -3 "$out.outside" | paste -sd' ' -)" test ! -s "$out.outside"
    if grep -qxF "$ck" "$out.changed"; then
      log "        note: lefthook's own state file $ck changed — allowed by this probe (lefthook writes it on every install)"
    fi
    if [[ $variant == redirected ]]; then
      check ST05 "redirected: the hook landed at the redirected path" "unarmed" is_armed "$d"
    fi
  done
}

# ── graph-reclaim — the real graph tool writes first ──────────────────────────
graph_tool() {   # prints an invocation of code-review-graph at $CRG_PIN, or nothing
  if command -v code-review-graph >/dev/null 2>&1 &&
     [[ "$(code-review-graph --version 2>/dev/null | awk '{print $NF}')" == "$CRG_PIN" ]]; then
    printf 'code-review-graph\n'
  elif command -v uvx >/dev/null 2>&1; then
    printf 'uvx --from code-review-graph==%s code-review-graph\n' "$CRG_PIN"
  fi
}
fx_graph_reclaim() {
  bold "▸ graph-reclaim — code-review-graph $CRG_PIN writes the hook, the step reclaims it"
  local e="$OUTPUT/graph-reclaim" d crg p
  crg="$(graph_tool)"
  if [[ -z "$crg" ]]; then unmeasured EC-05 "code-review-graph $CRG_PIN not on PATH and no uvx to fetch it"; return; fi
  new_fixture d graph commit
  { printf 'invocation: %s\n' "$crg"; printf 'version: %s\n' "$($crg --version 2>&1)"
    [[ "$crg" == code-review-graph ]] && printf 'origin: %s\nsha256: %s\n' "$(realpath "$(command -v code-review-graph)")" \
      "$(sha256sum "$(realpath "$(command -v code-review-graph)")" | cut -d' ' -f1)"
  } > "$e/tool.record"
  $crg install --repo "$d" -y --platform claude >"$e/graph.install" 2>&1 </dev/null
  p="$(eff_hook "$d")"
  if ! grep -qF "$GRAPH_MARKER" "$p" 2>/dev/null; then unmeasured EC-05 "the graph tool wrote no hook at $p"; return; fi
  sha256sum "$p" > "$e/hook.before.sha256"
  if ! ut_present "$d"; then fail EC-05 "$UNDER_TEST absent in the fixture — nothing reclaims the graph hook"; return; fi
  run_ut "$d" "$e/arm" --
  sha256sum "$p" > "$e/hook.after.sha256" 2>/dev/null
  check EC-05 "the step exits 0 over the graph hook" "exit $RC" rc_is 0
  check EC-05 "lefthook reclaims the effective hook" "unarmed" is_armed "$d"
  check EC-05 "the graph block is gone from the hook" "graph marker still present" bash -c '! grep -qF "$2" "$1"' _ "$p" "$GRAPH_MARKER"
  check EC-05 "the reclaim is reported" "no 'replac…' in the output" says "$e/arm" 'replac'

  # S-M1 (settled 17/11/2026): the graph tool run AFTER arming appends its block to lefthook's
  # hook. The marker and the executable bit survive, but the block's `|| true` tail swallows
  # lefthook's exit status, so a failing leg no longer blocks. Such a hook is UNARMED.
  $crg install --repo "$d" -y --platform claude >"$e/graph.append" 2>&1 </dev/null
  if ! { grep -qF "$GRAPH_MARKER" "$p" && grep -qF "$MARKER" "$p" && [[ -x "$p" ]]; } 2>/dev/null; then
    unmeasured S-M1 "code-review-graph install did not append its block to lefthook's executable hook"
    return
  fi
  pass S-M1 "precondition: the graph block is appended to lefthook's hook, marker and executable bit intact"
  check S-M1 "precondition: with the block appended, a failing leg does NOT block the commit" \
    "the commit was blocked — the case's premise does not hold here" not_ commit_blocked "$d" "$e/appended"
  notice "$d" "$e/appended.n"
  check S-M1 "appended hook is unarmed: --notice prints on stdout only, exit 0" "oracle rejected it" notice_valid "$e/appended.n"
  run_ut "$d" "$e/appended.arm" --
  check S-M1 "the step exits 0 over the appended hook" "exit $RC" rc_is 0
  check S-M1 "it reports removing the code-review-graph block" "no 'code-review-graph' with 'removed'/'reclaim' in the output" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi code-review-graph <<< "$o" && grep -qiE "removed|reclaim" <<< "$o"' _ "$e/appended.arm"
  check S-M1 "it does not claim the hook was already armed" "it printed 'already armed'" \
    bash -c '! grep -qi "already armed" "$1.out" "$1.err"' _ "$e/appended.arm"
  check S-M1 "afterwards the effective hook is armed (shared predicate)" "unarmed" is_armed "$d"
  check S-M1 "afterwards no graph marker remains" "graph marker still present" bash -c '! grep -qF "$2" "$1"' _ "$p" "$GRAPH_MARKER"
  check S-M1 "afterwards a failing leg blocks the commit again" "the commit went through" commit_blocked "$d" "$e/rearmed"
}

# ── binary-provenance — a different lefthook first on PATH ────────────────────
lh_bin() {   # node_modules root — the platform executable
  local os cpu; os="$(uname -s | tr '[:upper:]' '[:lower:]')"; cpu="$(uname -m | sed 's/aarch64/arm64/;s/x86_64/x64/')"
  compgen -G "$1/node_modules/.pnpm/lefthook-$os-$cpu@*/node_modules/lefthook-$os-$cpu/bin/lefthook" | head -1
}
lock_integrity() { awk -v k="  lefthook@$2:" '$0==k{f=1;next} f&&/integrity:/{sub(/.*integrity: */,"");sub(/}.*/,"");print;exit}' "$1"; }
fx_binary_provenance() {
  bold "▸ binary-provenance — lefthook $LH_FIXTURE_VERSION first on PATH, the project's 2.x must arm"
  local e="$OUTPUT/binary-provenance" d lh1="$SCRATCH/lh1" v2 b1 b2 h1 h2 lock0 host0
  command -v strace >/dev/null 2>&1 || { unmeasured EC-02 "strace absent — invocation tracing impossible"; return; }
  new_fixture d provenance commit
  mkdir -p "$lh1/code/src/scripts/development"
  cp "$d/code/src/scripts/development/install-frontend.sh" "$lh1/code/src/scripts/development/"
  printf '{\n  "name": "hook-arming-lh1",\n  "private": true,\n  "devDependencies": { "lefthook": "%s" }\n}\n' "$LH_FIXTURE_VERSION" > "$lh1/package.json"
  if ! (cd "$lh1" && bash code/src/scripts/development/install-frontend.sh --local) >"$e/lh1.install" 2>&1; then
    unmeasured EC-02 "lefthook $LH_FIXTURE_VERSION could not be provisioned (no registry access?) — see $e/lh1.install"; return
  fi
  v2="$(awk '/^  lefthook@2\./{sub(/^  lefthook@/,"");sub(/:$/,"");print;exit}' "$d/pnpm-lock.yaml")"
  b1="$(lh_bin "$lh1")"; b2="$(lh_bin "$d")"
  [[ -n "$v2" && -n "$b1" && -n "$b2" ]] || die "could not resolve the two lefthook executables or the locked 2.x version"
  h1="$(sha256sum "$b1" | cut -d' ' -f1)"; h2="$(sha256sum "$b2" | cut -d' ' -f1)"
  lock0="$(sha256sum "$d/pnpm-lock.yaml" | cut -d' ' -f1)"; host0="$(command -v lefthook 2>/dev/null || printf none)"
  { printf 'fixture lefthook %s integrity %s\n' "$LH_FIXTURE_VERSION" "$(lock_integrity "$lh1/pnpm-lock.yaml" "$LH_FIXTURE_VERSION")"
    printf 'project lefthook %s integrity %s\n' "$v2" "$(lock_integrity "$d/pnpm-lock.yaml" "$v2")"
    printf 'fixture reports %s · executable %s sha256 %s\n' "$("$b1" version 2>&1)" "$b1" "$h1"
    printf 'project reports %s · executable %s sha256 %s\n' "$("$b2" version 2>&1)" "$b2" "$h2"
    printf 'host lefthook on PATH before: %s\n' "$host0"; } > "$e/provenance.record"
  check EC-02 "the trap is set: plain 'lefthook' on the child PATH is $LH_FIXTURE_VERSION" "it is not" \
    bash -c '[[ "$(PATH="$1/node_modules/.bin:$PATH" lefthook version 2>&1)" == "$2" ]]' _ "$lh1" "$LH_FIXTURE_VERSION"
  if ! ut_present "$d"; then fail EC-02 "$UNDER_TEST absent in the fixture — no invocation to trace"; return; fi
  run_ut "$d" "$e/arm" env PATH="$lh1/node_modules/.bin:$PATH" strace -f -qq -s 512 -e trace=execve -o "$e/execve.txt" --
  check EC-02 "the step exits 0 with $LH_FIXTURE_VERSION first on PATH" "exit $RC" rc_is 0
  local hit2=false hit1=false path args
  while IFS= read -r line; do
    path="$(sed -nE 's/.*execve\("([^"]*)".*/\1/p' <<< "$line")"; args="$(sed -nE 's/.*execve\("[^"]*", \[([^]]*)\].*/\1/p' <<< "$line")"
    [[ -n "$path" && -f "$path" ]] || continue
    case "$(sha256sum "$(realpath "$path")" | cut -d' ' -f1)" in
      "$h2") [[ "$args" == *'"install"'* ]] && hit2=true ;;
      "$h1") hit1=true ;;
    esac
  done < <(grep -E 'execve\(.*= 0$' "$e/execve.txt")
  check EC-02 "the traced install ran the project's locked $v2 executable" "no execve of that executable with 'install'" $hit2
  check EC-02 "the $LH_FIXTURE_VERSION executable was never executed" "it was" bash -c '! $1' _ "$hit1"
  check EC-02 "the story lockfile is unchanged" "pnpm-lock.yaml changed" \
    bash -c '[[ "$(sha256sum "$1" | cut -d" " -f1)" == "$2" ]]' _ "$d/pnpm-lock.yaml" "$lock0"
  check EC-02 "the host's own lefthook resolution is unchanged" "it changed" \
    bash -c '[[ "$(command -v lefthook 2>/dev/null || printf none)" == "$1" ]]' _ "$host0"
}

# ── install-failure — install.sh in a clone whose hooks directory is a file ───
fx_install_failure() {
  bold "▸ install-failure — bash install.sh with an obstructed hooks directory"
  local e="$OUTPUT/install-failure" d sentinel="code/src/scripts/tests/backend.sh" crc
  if ! $ALLOW_INSTALL; then
    unmeasured ES-01 "CI-only: root install.sh needs a docker daemon, uv and 'sudo tee -a /etc/hosts' — pass --allow-install-sh to run it here"
    return
  fi
  new_fixture d install-failure commit
  git -C "$d" config --unset-all core.hooksPath 2>/dev/null
  rm -rf "$d/.git/hooks"; printf 'obstruction: the hooks directory is a regular file\n' > "$d/.git/hooks"
  chmod -x "$d/$sentinel"; rm -f "$d/code/docs/MACHINE-SPEC.md"
  (cd "$d" && bash install.sh) >"$e/install.out" 2>"$e/install.err" </dev/null; crc=$?
  printf '%s\n' "$crc" > "$e/child-exit-code"
  log "        child install.sh exit code: $crc (the runner's own exit is reported separately below)"
  check ES-03 "Step 8 completed before the failure (its ok line printed)" "the run stopped earlier — not this proof" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1" | grep -q "Host profile written"' _ "$e/install.out"
  check ES-01 "the failure is an err line naming lefthook install" "no 'error: … lefthook install' line" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1" | grep -qE "^error:.*lefthook install"' _ "$e/install.err"
  check ES-02 "the child install.sh exits 2" "it exited $crc" [ "$crc" -eq 2 ]
  check ES-03 "Step 5 ran: .env.dev exists" "absent" test -f "$d/code/src/docker/.env.dev"
  check ES-03 "Step 6 ran: .env.dev differs from its example (secrets generated; nothing printed)" "identical" \
    bash -c '! cmp -s "$1/code/src/docker/.env.dev" "$1/code/src/docker/.env.dev.example"' _ "$d"
  check ES-03 "Step 7 ran: the sentinel script is executable again" "still -x" test -x "$d/$sentinel"
  check ES-03 "Step 8 ran: MACHINE-SPEC.md exists" "absent" test -f "$d/code/docs/MACHINE-SPEC.md"
}

# ── Run ───────────────────────────────────────────────────────────────────────
run_one() {
  rm -rf "${OUTPUT:?}/$1"; mkdir -p "$OUTPUT/$1"
  case "$1" in
    manifest) fx_manifest ;; A) fx_A ;; B) fx_B ;; C) fx_C ;; notice) fx_notice ;;
    notice-streams) fx_notice_streams ;; hook-paths) fx_hook_paths ;; old-backup) fx_old_backup ;; repo-shapes) fx_repo_shapes ;; change-filter) fx_change_filter ;;
    write-boundary) fx_write_boundary ;;
    graph-reclaim) fx_graph_reclaim ;; binary-provenance) fx_binary_provenance ;; install-failure) fx_install_failure ;;
  esac
}
bold "▸ hook-arming.sh — source $SOURCE ($(git -C "$SOURCE" rev-parse --short HEAD 2>/dev/null || printf unborn))"
if [[ "$FIXTURE" == all ]]; then for f in $ALL_FIXTURES; do run_one "$f"; done; else run_one "$FIXTURE"; fi

log ""
bold "Summary: $PASSES passed · $FAILS failed · $UNMEASURED unmeasured   (evidence: $OUTPUT)"
if (( FAILS > 0 )); then exit 1; elif (( UNMEASURED > 0 )); then exit 3; fi
exit 0
