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
# into the tree, and the project's lefthook binary is absent (story plan, Architecture Decision).
# The snapshot is the source's tracked files plus untracked-but-not-ignored ones, as on disk,
# so the probe can run before the story's commit exists. No `.env.*` file is ever copied.
#
# "Armed" is ONE predicate that install-hooks.sh and `--notice` must apply; this probe's oracle
# is an independent implementation of the same predicate, never a copy of the script's: the file
# `pre-commit` in the hooks DIRECTORY `git rev-parse --path-format=absolute --git-path hooks`
# names, resolved from the checkout root (never the hook file itself, whose resolution follows a
# symlink), is a readable, executable regular file in lefthook's GENERATED LAYOUT (settled
# 17/11/2026, round 6), measured against lefthook 2.2.2's own template: its first line is
# `#!/bin/sh`; it defines `call_lefthook()` outside a comment; it uses `LEFTHOOK` outside a comment
# (the template reads $LEFTHOOK / $LEFTHOOK_VERBOSE / $LEFTHOOK_BIN — lefthook's own ownership test,
# `isLefthookFile`, is that case-sensitive string); and its last non-blank line is exactly
# `call_lefthook run "pre-commit" "$@"`, with NOTHING after it. Any appended tail — code-review-
# graph's block or an arbitrary `|| true` — swallows lefthook's exit status, so it is unarmed. A
# hook without the executable bit is unarmed, and a SYMLINKED hook is foreign, never armed,
# whatever it points at (SEC-02). The hooks directory's REAL path must lie inside the
# repository's git common directory (settled 17/11/2026, round 5). Beside it, `commit-msg` must be
# lefthook's too, in the same layout ending `call_lefthook run "commit-msg" "$@"` (19/11/2026).
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
#                      prints `git config --<scope> --unset-all core.hooksPath` in the scope the
#                      value came from (S-m2, CR-04: local and global); a value from
#                      GIT_CONFIG_COUNT or a GIT_CONFIG file is named in words, never
#                      --local (CR-04). Any other
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
#                      R5-QA-01/02: an arbitrary tail after lefthook's last line, and a marker
#                      or `LEFTHOOK` only in comments, are unarmed; each is copied aside.
#                      QA-02: a symlinked hook moved aside is put back when lefthook then fails.
#                      QA-02b: the same when lefthook install exits 0 but arms nothing — put
#                      back, or, where lefthook wrote a file there, the `mv -f` restore printed.
#   repo-shapes        A hooks directory whose real path is outside the git common directory
#                      is refused (exit 2), by every route: global, system, GIT_CONFIG,
#                      GIT_CONFIG_COUNT, a local include.path, a symlinked .git/hooks, a local
#                      absolute path — with a remedy hint per source. A project nested in an
#                      unrelated repository skips (QA-02); GIT_DIR/GIT_WORK_TREE are ignored
#                      (QA-03); a broken or bare-configured repository exits 2 (SEC-03, R4-03,
#                      R4-QA-06); an empty core.hooksPath exits 2 (QA-04). --notice hints.
#                      Round 6: core.bare/core.worktree only in an unrelated scope arm; remedies
#                      for worktree scope, an unrelated GIT_CONFIG_PARAMETERS and a multi-valued
#                      core.hooksPath; core.hooksPath = the common dir is "a subdirectory";
#                      a CR-terminated gitfile arms.
#   change-filter      No project fixture. The install-failure job's change filter (the
#                      --needs-install-failure mode) against a scratch repository: docs/PM-only
#                      ranges skip, a rename out of code counts both sides, a non-ASCII PM path
#                      is still PM, and every doubtful range runs the job (R4-SEC-03).
#   machine-spec       install.sh's generate_machine_spec is best-effort: `bash install.sh --spec`
#                      exits 0, writes the spec and arms nothing when any of its Linux probes
#                      fails or is absent. Every probe gets a healthy fake first on PATH and each
#                      case breaks one: df (with and without a table), lscpu, nproc, free,
#                      lspci (failing, and matching no display), uname -r, nvidia-smi, docker;
#                      lscpu, lspci and nvidia-smi absent. An all-healthy baseline is the
#                      control. Bug found in US009 (a stale FUSE mount made the host's df exit 1).
#   write-boundary     Full-tree manifests (path, type, mode, link target, SHA-256; ignored and
#                      untracked included) around the arming step alone. Negative control EC-17.
#                      QA-01: over a stale node_modules no install runs and nothing outside the
#                      hooks dir changes; a control shows `pnpm exec` would have installed.
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
          change-filter machine-spec write-boundary graph-reclaim binary-provenance install-failure all

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

ALL_FIXTURES="manifest A B C notice notice-streams hook-paths old-backup repo-shapes change-filter machine-spec write-boundary graph-reclaim binary-provenance install-failure"
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
lefthook_layout() {   # file — lefthook's generated layout, nothing after its final line
  local f="$1" code
  [[ "$(head -n 1 "$f" 2>/dev/null)" == '#!/bin/sh' ]] || return 1
  [[ "$(grep -v '^[[:space:]]*$' "$f" | tail -n 1)" == 'call_lefthook run "pre-commit" "$@"' ]] || return 1
  code="$(grep -vE '^[[:space:]]*#' "$f")"
  grep -qF 'LEFTHOOK' <<< "$code" && grep -qE '^[[:space:]]*call_lefthook\(\)' <<< "$code"
}
is_armed() {
  local p; p="$(eff_hook "$1")" || return 1
  [[ -f "$p" && ! -L "$p" && -r "$p" && -x "$p" ]] && lefthook_layout "$p" && ! grep -qF "$GRAPH_MARKER" "$p"
}
unarmed() { ! is_armed "$1"; }
# The commit-msg hook lefthook.yml's commit-msg leg needs: the same layout, its own last line.
msg_hook() { local p; p="$(eff_hook "$1")" || return 1; printf '%s\n' "${p%/pre-commit}/commit-msg"; }
rearmed_msg() { [[ $1 == 0 ]] && msg_armed "$2"; }
msg_armed() {
  local p code; p="$(msg_hook "$1")" || return 1
  [[ -f "$p" && ! -L "$p" && -r "$p" && -x "$p" ]] || return 1
  [[ "$(head -n 1 "$p")" == '#!/bin/sh' ]] || return 1
  [[ "$(grep -v '^[[:space:]]*$' "$p" | tail -n 1)" == 'call_lefthook run "commit-msg" "$@"' ]] || return 1
  code="$(grep -vE '^[[:space:]]*#' "$p")"
  grep -qF 'LEFTHOOK' <<< "$code" && grep -qE '^[[:space:]]*call_lefthook\(\)' <<< "$code"
}
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
says() { strip "$1.out" "$1.err" | grep -qiE -- "$2"; }
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
    check CR-03 "the workflow names no story, QA-plan row or excluded file" "a US###, AC-GAP or audit-template.yml mention remains" \
      bash -c '! grep -qE "US[0-9]{3}|AC-GAP|audit-template\.yml" "$1"' _ "$wf"
    check CR-05 "the install-failure comment sits directly above 'install-failure:', not above 'changes:'" \
      "the 'docker daemon' comment is not in the block above install-failure:" \
      bash -c 'awk "/^  [a-z-]+:\$/{if(\$1==\"install-failure:\"&&blk~/docker daemon/)ok=1; blk=\"\"; next} /^  #/{blk=blk \$0; next} {blk=\"\"} END{exit ok?0:1}" "$1"' _ "$wf"
    check R4-SEC-03 "the changes job decides through hook-arming.sh --needs-install-failure (the tested filter)" \
      "the workflow does not call it" grep -qF -- '--needs-install-failure' "$wf"
  else
    unmeasured R4-01 "no .github/workflows/audit-hook-arming.yml in the source"
  fi
  check CR-01 "pnpm-workspace.yaml cites no decision record (project-management/ is excluded from a generated project)" \
    "it names an ADR-... identifier" bash -c '! grep -qE "ADR-[A-Z0-9]" "$1"' _ "$s/pnpm-workspace.yaml"
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
    # QA-01: the binary checked is the binary executed. `pnpm exec` runs pnpm's
    # verify-deps-before-run first, which over a stale node_modules silently runs a full
    # install, lifecycle scripts included — so lefthook is executed directly, never via pnpm.
    check ST03 "the install invocation is 'args=(install' run as '\"\$lh_bin\" \"\${args[@]}\"' (the checked binary, directly)" \
      "the non-comment args=(install / \"\$lh_bin\" \"\${args[@]}\" pair is absent" \
      bash -c 'c="$(grep -vE "^[[:space:]]*#" "$1")"; grep -qE "args=\(install" <<< "$c" && grep -qF "\"\$lh_bin\" \"\${args[@]}\"" <<< "$c"' _ "$ut"
    check QA-01 "no non-comment line runs lefthook through 'pnpm exec' (it can trigger an implicit install)" \
      "a non-comment 'pnpm exec' remains" \
      bash -c '! grep -vE "^[[:space:]]*#" "$1" | grep -qF "pnpm exec"' _ "$ut"
    check CR-03 "install-hooks.sh carries no review-round or plan-constraint labels" "a 'round N' or 'constraint 7.4' label remains" \
      bash -c '! grep -qE "round [0-9]|constraint [0-9]+\.[0-9]+" "$1"' _ "$ut"
    check ST07 "guards with 'git rev-parse --git-dir'" "guard absent" grep -qF 'git rev-parse --git-dir' "$ut"
    check ST07 "never tests '[ -d .git ]'" "a directory test on .git is present" \
      bash -c '! grep -vE "^[[:space:]]*#" "$1" | grep -qE "\[\[? +-d +\"?[^ ]*\.git\"? *\]"' _ "$ut"
    check P1 "resolves the effective hook with --git-path hooks/pre-commit" "resolution absent" \
      grep -qF -- '--git-path hooks/pre-commit' "$ut"
    local h="$SCRATCH/manifest-help"; mkdir -p "$h"
    (cd "$s" && bash "$UNDER_TEST" --help) >"$h/help.out" 2>&1; local hr=$?
    check P1 "--help exits 0 and documents --notice" "exit $hr or --notice undocumented" \
      bash -c '[[ $1 == 0 ]] && grep -qF -- --notice "$2"' _ "$hr" "$h/help.out"
    check R5-REV-02 "--help describes the location rule (the git directory / outside), with no 'scope' refusal wording" \
      "it mentions neither 'git directory' nor 'outside', or it still speaks of scope" \
      bash -c 'grep -qiE "git (common )?directory|outside" "$1" && ! grep -qi scope "$1"' _ "$h/help.out"
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

  # HP-06 pins the TEMPLATE's README seed wording, so it runs only where that seed exists. In a
  # generated project .copier/ is gone and README.md is the project's own prose: an absent
  # surface, noted and never failed, and never a fallback to the project's README (CR-02).
  local r="$s/.copier/README.md"
  if [[ ! -f "$r" ]]; then
    log "  n/a   [HP-06] not applicable — no .copier/README.md (a generated project); the project's own README is not pinned"
    return 0
  fi
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

  # The commit-msg leg is armed by the same step and counted by the same predicate (19/11/2026):
  # a checkout armed before lefthook.yml grew that leg has no commit-msg hook, and --notice must
  # say so rather than report it armed.
  check R3-01 "the effective commit-msg hook is lefthook's too" "commit-msg unarmed after the step" msg_armed "$d"
  rm -f "$(msg_hook "$d")"
  notice "$d" "$e/no-commit-msg"
  check R3-01 "with the commit-msg hook missing, --notice names bash install.sh" "it was silent" \
    notice_valid "$e/no-commit-msg"
  run_ut "$d" "$e/rearm-commit-msg" --
  check R3-01 "the step re-arms a missing commit-msg hook" "exit $RC or commit-msg still unarmed" \
    rearmed_msg "$RC" "$d"

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
  check S-m2 "core.hooksPath=/dev/null: --notice prints 'git config --local --unset-all core.hooksPath' on stdout only, exit 0" \
    "hint absent, unscoped, stderr written or non-zero exit" notice_says "$e/devnull.n" 'git config --local --unset-all core.hooksPath'

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
  check CR-04 "core.hooksPath=/dev/null (local): the step's re-enable command is scoped --local" \
    "no 'git config --local --unset-all core.hooksPath' in the output" says "$e/devnull.arm" 'git config --local --unset-all core\.hooksPath'

  # CR-04: a GLOBAL /dev/null opt-out. An unscoped --unset-all touches only the local scope and
  # would leave the hooks disabled, so both modes must print the --global command.
  local gcfg="$SCRATCH/gitconfig-devnull"
  cp "$GIT_CONFIG_GLOBAL" "$gcfg"; printf '[core]\n\thooksPath = /dev/null\n' >> "$gcfg"
  new_fixture d hp-devnull-global commit
  notice "$d" "$e/devnull-global.n" GIT_CONFIG_GLOBAL="$gcfg"
  check CR-04 "global core.hooksPath=/dev/null: --notice prints 'git config --global --unset-all core.hooksPath'" \
    "hint absent, not --global, stderr written or non-zero exit" notice_says "$e/devnull-global.n" 'git config --global --unset-all core.hooksPath'
  run_ut "$d" "$e/devnull-global.arm" env GIT_CONFIG_GLOBAL="$gcfg" --
  check CR-04 "global core.hooksPath=/dev/null: the step is an opt-out and exits 0" "exit $RC" rc_is 0
  check CR-04 "global core.hooksPath=/dev/null: the step prints 'git config --global --unset-all core.hooksPath'" \
    "no --global command in the output" says "$e/devnull-global.arm" 'git config --global --unset-all core\.hooksPath'
  check CR-04 "global core.hooksPath=/dev/null: nothing armed" "a hook was armed" unarmed "$d"

  # CR-04 residual: a /dev/null from the COMMAND scope (git --show-scope says `command`) has no
  # `git config --<scope>` that removes it, and `--local` would do nothing. Both modes must name
  # the source in words: the environment variables, or the GIT_CONFIG file. Same fixture: the
  # value lives only in the environment of each run.
  local fcfg="$SCRATCH/gitconfig-devnull-file" src pre_c re_c desc_c
  printf '[core]\n\thooksPath = /dev/null\n' > "$fcfg"
  for src in count file; do
    if [[ $src == count ]]; then
      pre_c=(GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null)
      re_c='environment.*GIT_CONFIG_COUNT.*unset those variables'; desc_c="the environment variables and 'unset those variables'"
    else
      pre_c=(GIT_CONFIG="$fcfg")
      re_c="GIT_CONFIG file $fcfg.*unset GIT_CONFIG or remove core\.hooksPath from that file"; desc_c="the GIT_CONFIG file $fcfg and 'unset GIT_CONFIG or remove core.hooksPath from that file'"
    fi
    notice "$d" "$e/devnull-$src.n" "${pre_c[@]}"
    check CR-04 "command-scope core.hooksPath=/dev/null ($src): --notice names $desc_c, exit 0, stderr empty" \
      "wording absent, stderr written or non-zero exit" \
      bash -c '[[ $(cat "$1.rc") == 0 && ! -s "$1.err" ]] && grep -qE -- "$2" "$1.out"' _ "$e/devnull-$src.n" "$re_c"
    check CR-04 "command-scope core.hooksPath=/dev/null ($src): --notice offers no '--local' command" "it does" \
      bash -c '! grep -qF -- "--local" "$1.out"' _ "$e/devnull-$src.n"
    run_ut "$d" "$e/devnull-$src.arm" env "${pre_c[@]}" --
    check CR-04 "command-scope core.hooksPath=/dev/null ($src): the step is an opt-out and exits 0" "exit $RC" rc_is 0
    check CR-04 "command-scope core.hooksPath=/dev/null ($src): the step names $desc_c" "wording absent" \
      says "$e/devnull-$src.arm" "$re_c"
    check CR-04 "command-scope core.hooksPath=/dev/null ($src): the step offers no '--local' command" "it does" \
      not_ says "$e/devnull-$src.arm" '--local'
    check CR-04 "command-scope core.hooksPath=/dev/null ($src): nothing armed" "a hook was armed" unarmed "$d"
  done

  # CR-04 include: git reports an INCLUDED value (include.path / includeIf) under the scope of the
  # file that includes it, so `git config --<scope> --unset-all` exits 5 and leaves it in force.
  # Both modes must name the included file in words and offer no --unset-all. Same fixture, no
  # local value of its own: global include first, then a local include.path.
  local icfg="$SCRATCH/gitconfig-devnull-include" isc want_i pre_i
  cp "$GIT_CONFIG_GLOBAL" "$icfg"; printf '[include]\n\tpath = %s\n' "$fcfg" >> "$icfg"
  for isc in global local; do
    pre_i=(); [[ $isc == global ]] && pre_i=(GIT_CONFIG_GLOBAL="$icfg")
    [[ $isc == local ]] && git -C "$d" config include.path "$fcfg"
    want_i="it comes from $fcfg, included from your $isc config — remove core.hooksPath from that file"
    notice "$d" "$e/devnull-inc-$isc.n" "${pre_i[@]}"
    check CR-04 "$isc include of core.hooksPath=/dev/null: --notice names the included file in words, exit 0, stderr empty" \
      "wording absent, stderr written or non-zero exit" notice_says "$e/devnull-inc-$isc.n" "$want_i"
    check CR-04 "$isc include of core.hooksPath=/dev/null: --notice offers no '--unset-all' command" "it does" \
      bash -c '! grep -qF -- "--unset-all" "$1.out"' _ "$e/devnull-inc-$isc.n"
    run_ut "$d" "$e/devnull-inc-$isc.arm" env "${pre_i[@]}" --
    check CR-04 "$isc include of core.hooksPath=/dev/null: the step is an opt-out and exits 0" "exit $RC" rc_is 0
    check CR-04 "$isc include of core.hooksPath=/dev/null: the step names the included file in words" "wording absent" \
      bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF -- "$2"' _ "$e/devnull-inc-$isc.arm" "$want_i"
    check CR-04 "$isc include of core.hooksPath=/dev/null: the step offers no '--unset-all' command" "it does" \
      not_ says "$e/devnull-inc-$isc.arm" '--unset-all'
    check CR-04 "$isc include of core.hooksPath=/dev/null: nothing armed" "a hook was armed" unarmed "$d"
  done
  git -C "$d" config --unset include.path

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

  # R5-QA-01 — an armed lefthook hook with an ARBITRARY appended tail (not code-review-graph's).
  new_fixture d ob-tail commit; run_ut "$d" "$e/tail.arm0" --; p="$(eff_hook "$d")"; hd="${p%/*}"
  printf 'echo "an appended tail" || true\n' >> "$p"
  hfh="$(sha256sum "$p" | cut -d' ' -f1)"
  check R5-QA-01 "precondition: with the tail appended, a failing leg does NOT block the commit" \
    "the commit was blocked — the case's premise does not hold here" not_ commit_blocked "$d" "$e/tail.pre"
  notice "$d" "$e/tail.n"
  check R5-QA-01 "a lefthook hook with an appended tail is unarmed: --notice reminds" "it stayed silent" notice_valid "$e/tail.n"
  run_ut "$d" "$e/tail" --
  check R5-QA-01 "the step exits 0" "exit $RC" rc_is 0
  check R5-QA-01 "it reports the appended tail removed — and not as code-review-graph's" \
    "no 'appended' + 'removed', or it blames code-review-graph" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi appended <<< "$o" && grep -qi removed <<< "$o" && ! grep -qi code-review-graph <<< "$o"' _ "$e/tail"
  check R5-QA-01 "it does not claim the hook was already armed" "it printed 'already armed'" \
    bash -c '! grep -qi "already armed" "$1.out" "$1.err"' _ "$e/tail"
  check R5-QA-01 "the original hook, tail included, survives as a copy in the hooks dir" "its hash is gone" \
    bash -c 'find "$2" -maxdepth 1 -type f -exec sha256sum {} + | cut -d" " -f1 | grep -qxF "$1"' _ "$hfh" "$hd"
  check R5-QA-01 "afterwards the effective hook is armed" "unarmed" is_armed "$d"
  check R5-QA-01 "afterwards a failing leg blocks the commit again" "the commit went through" commit_blocked "$d" "$e/tail.post"

  # R5-QA-02 — a hand-written hook whose marker and LEFTHOOK appear only in comments.
  new_fixture d ob-comments commit; p="$(eff_hook "$d")"; hd="${p%/*}"
  printf '#!/bin/sh\n# Modelled on lefthook'"'"'s: call_lefthook run "pre-commit" "$@"\n# Set LEFTHOOK=0 to skip it.\necho hand-written hook\n' > "$p"
  chmod +x "$p"; hfh="$(sha256sum "$p" | cut -d' ' -f1)"
  notice "$d" "$e/comments.n"
  check R5-QA-02 "marker and LEFTHOOK only in comments: unarmed, --notice prints" "it stayed silent" notice_valid "$e/comments.n"
  run_ut "$d" "$e/comments" --
  check R5-QA-02 "the step exits 0" "exit $RC" rc_is 0
  check R5-QA-02 "the hand-written hook's content survives in the hooks dir" "its hash is gone — overwritten in place" \
    bash -c 'find "$2" -maxdepth 1 -type f -exec sha256sum {} + | cut -d" " -f1 | grep -qxF "$1"' _ "$hfh" "$hd"
  check R5-QA-02 "afterwards the effective hook is armed" "unarmed" is_armed "$d"
  check R5-QA-02 "the report is truthful: not 'already armed', and any pre-commit.old it names holds the hook" \
    "it says 'already armed', or names a pre-commit.old that does not hold the hook" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; ! grep -qi "already armed" <<< "$o" || exit 1
             grep -q "pre-commit\.old" <<< "$o" || exit 0
             for hf in "$2"/pre-commit.old*; do [[ -f $hf && "$(sha256sum "$hf" | cut -d" " -f1)" == "$3" ]] && exit 0; done; exit 1' \
    _ "$e/comments" "$hd" "$hfh"

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

  # QA-02: the symlinked hook is moved aside BEFORE lefthook runs. When lefthook then fails, the
  # developer's link must be put back — or, if it cannot be, the exact restore command printed.
  # lefthook.yml is made invalid YAML, so `lefthook install` fails after the move.
  new_fixture d ob-sym-failure commit; p="$(eff_hook "$d")"; hd="${p%/*}"
  tdir="$SCRATCH/sym-target-failure"; mkdir -p "$tdir"; tgt="$tdir/pre-commit-target"
  printf '#!/bin/sh\necho the developer'"'"'s own hook\n' > "$tgt"; chmod +x "$tgt"; ln -s "$tgt" "$p"
  printf 'pre-commit: [\n' > "$d/lefthook.yml"
  manifest "$tdir" "$e/sym-failure.target.before" || die "manifest of the symlink target dir failed"
  run_ut "$d" "$e/sym-failure" --
  manifest "$tdir" "$e/sym-failure.target.after" || die "manifest of the symlink target dir failed"
  check QA-02 "symlinked hook + failing lefthook install: the step exits 2" "exit $RC" rc_is 2
  check QA-02 "the developer's symlink is back at the hook path, pointing at its target" \
    "the hook path is not the original link$(  [[ -e "$hd/pre-commit.old" || -L "$hd/pre-commit.old" ]] && printf ' (pre-commit.old is still there)')" \
    bash -c '[[ -L "$1" && "$(readlink "$1")" == "$2" ]]' _ "$p" "$tgt"
  check QA-02 "no stray pre-commit.old is left in the hooks dir" "a pre-commit.old remains" \
    bash -c '[[ ! -e "$1/pre-commit.old" && ! -L "$1/pre-commit.old" ]]' _ "$hd"
  check QA-02 "the restore is reported" "no 'restored' in the output" says "$e/sym-failure" 'restored'
  check QA-02 "the link's target and its directory are untouched" \
    "changed: $(changed_paths "$e/sym-failure.target.before" "$e/sym-failure.target.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/sym-failure.target.before" "$e/sym-failure.target.after"

  # QA-02b: lefthook install EXITS 0 but leaves the hook unarmed, after the symlinked hook was
  # moved aside. The fixture's own node_modules/.bin/lefthook (never the source's) is replaced by
  # a fake that answers `version` and exits 0 on `install`. Leg 1 writes nothing, so the link is
  # put back; leg 2 writes a non-armed regular file at the hook path, so the link cannot go back
  # without overwriting it and the exact `mv -f` restore is printed instead.
  local fake leg
  new_fixture d ob-sym-unarmed commit; p="$(eff_hook "$d")"; hd="${p%/*}"
  fake="$d/node_modules/.bin/lefthook"
  case "$(realpath -m "$fake")" in "$SCRATCH"/*) ;; *) die "the fixture's lefthook resolves outside the scratch tree" ;; esac
  tdir="$SCRATCH/sym-target-unarmed"; mkdir -p "$tdir"; tgt="$tdir/pre-commit-target"
  printf '#!/bin/sh\necho the developer'"'"'s own hook\n' > "$tgt"; chmod +x "$tgt"; ln -s "$tgt" "$p"
  manifest "$tdir" "$e/sym-unarmed.target.before" || die "manifest of the symlink target dir failed"
  for leg in nothing-written foreign-written; do
    rm -f "$fake"
    { printf '#!/bin/sh\n[ "$1" = version ] && { echo 2.2.2-fake; exit 0; }\n'
      [[ $leg == foreign-written ]] &&
        printf 'h="$(git rev-parse --path-format=absolute --git-path hooks)/pre-commit"\nprintf "#!/bin/sh\\necho not lefthook\\n" > "$h"\n'
      printf 'exit 0\n'; } > "$fake"
    chmod +x "$fake"
    run_ut "$d" "$e/sym-unarmed-$leg" --
    check QA-02b "$leg: lefthook install exits 0 but arms nothing — the step exits 2" "exit $RC" rc_is 2
    check QA-02b "$leg: the failure says the effective hook was not armed" "no 'did not arm'" says "$e/sym-unarmed-$leg" 'did not arm'
    check QA-02b "$leg: the effective hook is unarmed" "it is armed" unarmed "$d"
  done
  # Leg 1's restore is what leg 2 starts from, so leg 1 is judged from its own transcript.
  check QA-02b "nothing-written: the restore is reported" "no 'restored' in the output" says "$e/sym-unarmed-nothing-written" 'restored'
  local want_mv; want_mv="mv -f -- $(printf '%q' "$hd/pre-commit.old") $(printf '%q' "$p")"
  check QA-02b "foreign-written: the link cannot go back, so the exact restore command is printed" \
    "no \"$want_mv\" in the output" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF -- "$2"' _ "$e/sym-unarmed-foreign-written" "$want_mv"
  check QA-02b "foreign-written: the link is kept as pre-commit.old, still pointing at its target" "it is not" \
    bash -c '[[ -L "$1" && "$(readlink "$1")" == "$2" ]]' _ "$hd/pre-commit.old" "$tgt"
  check QA-02b "foreign-written: the file the fake wrote is not overwritten by the link" "the hook path is a link" \
    bash -c '[[ -f "$1" && ! -L "$1" ]]' _ "$p"
  manifest "$tdir" "$e/sym-unarmed.target.after" || die "manifest of the symlink target dir failed"
  check QA-02b "the link's target and its directory are untouched" \
    "changed: $(changed_paths "$e/sym-unarmed.target.before" "$e/sym-unarmed.target.after" | head -3 | paste -sd' ' -)" \
    cmp -s "$e/sym-unarmed.target.before" "$e/sym-unarmed.target.after"

  # QA-02b quote: the same foreign-written leg with a single quote and a space in the hooks
  # path (a core.hooksPath inside the git common dir, so it is armed with --force). The printed
  # restore must be shell-quoted, and running it as printed must put the link back.
  local qhd="$d/.git/it's hooks" mvline
  mkdir -p "$qhd"; ln -s "$tgt" "$qhd/pre-commit"; git -C "$d" config core.hooksPath "$qhd"
  run_ut "$d" "$e/sym-unarmed-quote" --
  check QA-02b "quoted path: lefthook install exits 0 but arms nothing — the step exits 2" "exit $RC" rc_is 2
  want_mv="mv -f -- $(printf '%q' "$qhd/pre-commit.old") $(printf '%q' "$qhd/pre-commit")"
  check QA-02b "quoted path: the restore command is printed shell-quoted" "no \"$want_mv\" in the output" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF -- "$2"' _ "$e/sym-unarmed-quote" "$want_mv"
  mvline="$(strip "$e/sym-unarmed-quote.out" "$e/sym-unarmed-quote.err" | sed -n 's/^.*\(mv -f -- .*\)$/\1/p' | head -1)"
  check QA-02b "quoted path: the printed command, run as printed, puts the link back" "it did not" \
    bash -c '[[ -n $1 ]] && bash -c "$1" && [[ -L "$2" && "$(readlink "$2")" == "$3" && ! -e "$4" && ! -L "$4" ]]' \
    _ "$mvline" "$qhd/pre-commit" "$tgt" "$qhd/pre-commit.old"
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
               hint_re='git config --system --unset-all core\.hooksPath'; hint_desc="'git config --system --unset-all core.hooksPath'" ;;
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
  if [[ $route == symlink ]]; then
    check R5-QA-06 "$label, no core.hooksPath set: the refusal names the symlink and claims no core.hooksPath source" \
      "no 'symlink', or it claims a core.hooksPath source" \
      bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi symlink <<< "$o" && ! grep -qiE "core\.hooksPath is set|core\.hooksPath (comes )?from|(local|global|system|command|worktree) config" <<< "$o"' _ "$e/route-$route"
  fi
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
  local e="$OUTPUT/repo-shapes" d g gcfg o x gh key wt
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
  check R4-QA-04 "global: the remedy names 'git config --global --unset-all core.hooksPath'" "remedy absent" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF "git config --global --unset-all core.hooksPath"' _ "$e/global"
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

  # 8 — R5-QA-03: core.bare / core.worktree set only in an UNRELATED scope (global) on a healthy
  # repository. git's effective answer (rev-parse --is-bare-repository / --show-toplevel) is
  # healthy — the repository's own core.bare=false wins and a global core.worktree is ignored
  # (measured) — so the step arms normally.
  local gc2 variant2
  for variant2 in bare worktree; do
    new_fixture d "rs-global-$variant2" commit
    gc2="$SCRATCH/gitconfig-global-$variant2"; cp "$GIT_CONFIG_GLOBAL" "$gc2"
    if [[ $variant2 == bare ]]; then git config --file "$gc2" core.bare true
    else mkdir -p "$SCRATCH/rs-global-elsewhere"; git config --file "$gc2" core.worktree "$SCRATCH/rs-global-elsewhere"; fi
    run_ut "$d" "$e/global-$variant2" env GIT_CONFIG_GLOBAL="$gc2" --
    check R5-QA-03 "core.$variant2 only in global scope, repository healthy: the step exits 0" "exit $RC" rc_is 0
    check R5-QA-03 "core.$variant2 only in global scope: the hook is armed" "unarmed" is_armed "$d"
  done

  # 9 — R5-QA-04: core.bare=true at WORKTREE scope (extensions.worktreeConfig): the remedy names
  # --worktree, the scope it came from.
  new_fixture d rs-wtbare commit; add_worktree wt "$d" rs-wtbare-wt
  git -C "$d" config extensions.worktreeConfig true; git -C "$wt" config --worktree core.bare true
  run_ut "$wt" "$e/wtbare" --
  check R5-QA-04 "worktree-scope core.bare: the step exits 2" "exit $RC" rc_is 2
  check R5-QA-04 "worktree-scope core.bare: the remedy names 'git config --worktree'" "no 'git config --worktree' in the output" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF "git config --worktree"' _ "$e/wtbare"

  # 10 — R5-QA-05: an unrelated GIT_CONFIG_PARAMETERS while core.hooksPath comes from GLOBAL.
  new_fixture d rs-params commit
  g="$SCRATCH/rs-params-hooks"; mkdir -p "$g"; printf '#!/bin/sh\necho shared\n' > "$g/pre-commit"; chmod +x "$g/pre-commit"
  gcfg="$SCRATCH/gitconfig-global-params"; cp "$GIT_CONFIG_GLOBAL" "$gcfg"; git config --file "$gcfg" core.hooksPath "$g"
  run_ut "$d" "$e/params" env GIT_CONFIG_GLOBAL="$gcfg" GIT_CONFIG_PARAMETERS="'user.name'='Unrelated Override'" --
  check R5-QA-05 "global core.hooksPath + an unrelated GIT_CONFIG_PARAMETERS: exit 2" "exit $RC" rc_is 2
  check R5-QA-05 "the remedy is the global one ('git config --global --unset-all core.hooksPath')" "absent" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qF "git config --global --unset-all core.hooksPath"' _ "$e/params"
  check R5-QA-05 "the remedy does not blame the environment" "it names GIT_CONFIG_PARAMETERS/GIT_CONFIG_COUNT/environment" \
    bash -c '! sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qiE "GIT_CONFIG_PARAMETERS|GIT_CONFIG_COUNT|environment"' _ "$e/params"

  # 11 — R5-REV-04: a MULTI-VALUED local core.hooksPath (the last value, outside, wins).
  new_fixture d rs-multi commit
  g="$SCRATCH/rs-multi-hooks"; mkdir -p "$g"
  git -C "$d" config --add core.hooksPath .git/custom-hooks; git -C "$d" config --add core.hooksPath "$g"
  run_ut "$d" "$e/multi" --
  check R5-REV-04 "multi-valued local core.hooksPath, last outside: exit 2" "exit $RC" rc_is 2
  check R5-REV-04 "the remedy uses --unset-all or --replace-all" "neither in the output" \
    bash -c 'sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err" | grep -qE -- "--unset-all|--replace-all"' _ "$e/multi"

  # 12 — R5-REV-03: core.hooksPath equal to the git common directory itself.
  new_fixture d rs-commondir commit; git -C "$d" config core.hooksPath .git
  run_ut "$d" "$e/commondir" --
  check R5-REV-03 "core.hooksPath = the git common dir itself: exit 2" "exit $RC" rc_is 2
  check R5-REV-03 "the message says it must be a subdirectory, not 'outside'" "no 'subdirectory', or it says 'outside'" \
    bash -c 'o="$(sed -E "s/\x1b\[[0-9;]*[A-Za-z]//g" "$1.out" "$1.err")"; grep -qi subdirectory <<< "$o" && ! grep -qi outside <<< "$o"' _ "$e/commondir"

  # 13 — R5-QA-07: a linked worktree's .git gitfile ending in CR, which git reads (measured;
  # a trailing SPACE git itself rejects, so it is not this case).
  new_fixture d rs-gitfile commit; add_worktree wt "$d" rs-gitfile-wt
  printf 'gitdir: %s\r\n' "$(sed -n 's/^gitdir: //p' "$wt/.git" | tr -d '\r')" > "$wt/.git.cr" && mv "$wt/.git.cr" "$wt/.git"
  check R5-QA-07 "precondition: git reads the CR-terminated gitfile" "git rejects it here" \
    bash -c 'cd "$1" && git rev-parse --git-dir >/dev/null 2>&1' _ "$wt"
  run_ut "$wt" "$e/gitfile-cr" --
  check R5-QA-07 "CR-terminated gitfile: the step arms, exit 0 (not 'broken')" "exit $RC" rc_is 0
  check R5-QA-07 "CR-terminated gitfile: the hook is armed" "unarmed" is_armed "$wt"

  # 14 — an empty core.hooksPath (QA-04): git resolves it to /pre-commit. Exit 2, named.
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

# ── machine-spec — install.sh --spec survives every failing host probe ─────────
fx_machine_spec() {
  bold "▸ machine-spec — install.sh --spec is best-effort whatever its host probes return"
  local e="$OUTPUT/machine-spec" d spec real_uname fb
  if [[ "$(uname -s)" != Linux ]]; then
    unmeasured MS "generate_machine_spec's Linux branch only; this host is $(uname -s)"; return
  fi
  new_fixture d ms commit
  spec="$d/code/docs/MACHINE-SPEC.md"; real_uname="$(command -v uname)"
  # Host-independent: every probe the function runs gets a HEALTHY fake first on PATH, and each
  # case breaks exactly one of them. Without this, one failing host probe (this host's df, a
  # runner without lspci) would turn every case red for the same reason.
  local base="$SCRATCH/ms-baseline"; mkdir -p "$base"
  ms_put() { printf '#!/bin/sh\n%s\n' "$3" > "$1/$2"; chmod +x "$1/$2"; }   # dir name body
  ms_put "$base" df 'printf "Filesystem  Size  Used Avail Use%% Mounted on\n/dev/sda1   100G   50G   50G  50%% /\n"'
  ms_put "$base" lscpu 'printf "Model name:          Example CPU\nCore(s) per socket:  4\n"'
  ms_put "$base" nproc 'echo 8'
  ms_put "$base" free 'if [ "$1" = -g ]; then echo "Mem: 16 8 4 1 4 8"; else echo "Mem: 16Gi 8Gi 4Gi 1Gi 4Gi 8Gi"; fi'
  ms_put "$base" lspci 'echo "01:00.0 VGA compatible controller: Example GPU"'
  ms_put "$base" nvidia-smi 'echo "Example GPU"'
  ms_put "$base" docker 'echo /var/lib/docker'
  ms_variant() {   # case [name body] — a copy of the baseline with at most one probe replaced
    fb="$SCRATCH/ms-fake-$1"; rm -rf "$fb"; cp -a "$base" "$fb"
    [[ $# -ge 3 ]] && ms_put "$fb" "$2" "$3"
    return 0
  }
  ms_case() {   # case label env-prefix… — run --spec and assert the three outcomes
    local c="$1" label="$2"; shift 2
    rm -f "$spec"
    (cd "$d" && "$@" bash install.sh --spec) >"$e/$c.out" 2>"$e/$c.err" </dev/null; RC=$?
    check "MS-$c" "$label: install.sh --spec exits 0" "exit $RC" rc_is 0
    check "MS-$c" "$label: MACHINE-SPEC.md is written" "absent, empty or without its heading" \
      bash -c '[[ -s "$1" ]] && grep -q "^# Machine Specification" "$1"' _ "$spec"
    check "MS-$c" "$label: no hook is armed" "a hook was armed" unarmed "$d"
  }
  ms_variant baseline;  ms_case baseline "control: every probe healthy" env PATH="$fb:$PATH"
  ms_variant df-table df 'printf "Filesystem  Size  Used Avail Use%% Mounted on\n/dev/sda1   100G   50G   50G  50%% /\n"
echo "df: /run/user/1000/gvfs: Transport endpoint is not connected" >&2; exit 1'
  ms_case df-table "df prints a table and exits 1 (the stale-mount case)" env PATH="$fb:$PATH"
  ms_variant df-empty df 'exit 1';        ms_case df-empty "df prints nothing and exits 1" env PATH="$fb:$PATH"
  ms_variant lscpu lscpu 'exit 1';        ms_case lscpu "lscpu exits 1" env PATH="$fb:$PATH"
  ms_variant nproc nproc 'exit 1';        ms_case nproc "nproc exits 1" env PATH="$fb:$PATH"
  ms_variant free free 'exit 1';          ms_case free "free exits 1" env PATH="$fb:$PATH"
  ms_variant lspci lspci 'exit 1';        ms_case lspci "lspci exits 1" env PATH="$fb:$PATH"
  ms_variant lspci-nodisplay lspci 'echo "00:00.0 Host bridge: Example Corp Host Bridge"'
  ms_case lspci-nodisplay "lspci lists no display device (grep matches nothing; nvidia-smi healthy)" env PATH="$fb:$PATH"
  ms_variant uname-r uname "case \"\$1\" in -r) exit 1 ;; esac; exec $real_uname \"\$@\""
  ms_case uname-r "uname -r exits 1" env PATH="$fb:$PATH"
  ms_variant nvidia nvidia-smi 'exit 1'; ms_put "$fb" lspci 'echo "00:00.0 Host bridge: Example Corp"'
  ms_case nvidia "no display from lspci and nvidia-smi exits 1" env PATH="$fb:$PATH"
  ms_variant docker docker 'exit 1';      ms_case docker "docker info exits 1 (already guarded — a control)" env PATH="$fb:$PATH"
  local absent
  for absent in lscpu lspci nvidia-smi; do
    ms_variant "no-$absent"; rm -f "$fb/$absent"
    [[ $absent == nvidia-smi ]] && ms_put "$fb" lspci 'echo "00:00.0 Host bridge: Example Corp"'
    filtered_path "$SCRATCH/ms-path-no-$absent" "$absent"
    if PATH="$fb:$SCRATCH/ms-path-no-$absent" command -v "$absent" >/dev/null 2>&1; then
      unmeasured "MS-no-$absent" "could not remove $absent from PATH"; continue
    fi
    ms_case "no-$absent" "$absent absent from PATH" env PATH="$fb:$SCRATCH/ms-path-no-$absent"
  done
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

  # QA-01: a STALE node_modules — the committed manifest no longer matches the install, as after
  # a `git pull`. `pnpm exec` would run pnpm's verify-deps-before-run, silently re-installing
  # (lifecycle scripts included) and rewriting the lockfile. The step must run the installed
  # binary as it is: exit 0, armed, no install, nothing outside the hooks dir. The postinstall
  # is rewired to record every run to a file outside the fixture, so "no install" is observed.
  local ran="$SCRATCH/wb-stale-postinstall.ran"; rm -f "$ran"
  new_fixture d wb-stale commit
  (cd "$d" && RAN="$ran" node -e '
    const fs=require("fs"); const p=JSON.parse(fs.readFileSync("package.json","utf8"));
    p.scripts.postinstall=`echo postinstall >> ${JSON.stringify(process.env.RAN)}; `+p.scripts.postinstall;
    p.devDependencies.globals=p.devDependencies.globals.replace(/^\^/,">=");
    fs.writeFileSync("package.json", JSON.stringify(p,null,2)+"\n")') || die "cannot make the wb-stale manifest stale"
  git -C "$d" commit -qam "a manifest change node_modules has not seen" || die "commit of the stale manifest failed"
  rm -f "$ran"
  ck="$(cd "$d" && git rev-parse --git-common-dir)/info/lefthook.checksum"; [[ "$ck" == /* ]] || ck="./$ck"
  manifest "$d" "$e/stale.before" || die "manifest failed"
  run_ut "$d" "$e/stale.arm" --
  manifest "$d" "$e/stale.after" || die "manifest failed"
  changed_paths "$e/stale.before" "$e/stale.after" > "$e/stale.changed"
  outside "$e/stale.changed" "./.git/hooks" "$ck" > "$e/stale.outside"
  check QA-01 "stale node_modules: the step exits 0 with the installed lefthook" "exit $RC" rc_is 0
  check QA-01 "stale node_modules: the effective hook is armed" "unarmed" is_armed "$d"
  check QA-01 "stale node_modules: no install ran (the postinstall never fired)" \
    "it fired $(grep -c . "$ran" 2>/dev/null) time(s)" test ! -e "$ran"
  check QA-01 "stale node_modules: nothing outside the hooks dir changed (node_modules, lockfile included)" \
    "changed: $(head -3 "$e/stale.outside" | paste -sd' ' -)" test ! -s "$e/stale.outside"
  # The premise, measured last because it mutates the fixture: here `pnpm exec` DOES attempt an
  # install. Two signals, because pnpm's verify-deps install honours CI: with CI set it runs
  # frozen, refuses the stale manifest before any postinstall, and says so; without CI it
  # installs and the postinstall fires. Either one proves the step would have triggered it.
  (cd "$d" && pnpm exec lefthook version) >"$e/stale.control" 2>&1 </dev/null
  if [[ -s "$ran" ]]; then
    pass QA-01 "control: in the same stale fixture 'pnpm exec lefthook version' runs an install (the postinstall fired)"
  elif grep -qF 'The install that runs before scripts failed' "$e/stale.control"; then
    pass QA-01 "control: in the same stale fixture 'pnpm exec lefthook version' attempts an install (frozen under CI, refused)"
  else
    unmeasured QA-01 "control: 'pnpm exec' did not install here, so the stale premise was not demonstrated"
  fi
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
    notice-streams) fx_notice_streams ;; hook-paths) fx_hook_paths ;; old-backup) fx_old_backup ;; repo-shapes) fx_repo_shapes ;; change-filter) fx_change_filter ;; machine-spec) fx_machine_spec ;;
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
