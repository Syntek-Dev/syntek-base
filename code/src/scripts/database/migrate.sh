#!/usr/bin/env bash
#
# migrate.sh — Django migration management via the django container.
#
# Usage:
#   migrate.sh run          [--database DB] [--app APP]
#   migrate.sh make         [--app APP] [--name NAME] [--empty]
#   migrate.sh show         [--database DB] [--app APP]
#   migrate.sh check        [--database DB]
#   migrate.sh fake         [--database DB] --migration MIGRATION [--app APP]
#   migrate.sh fake-initial [--database DB]
#   migrate.sh --self-test
#   migrate.sh --help
#
# --self-test proves _lib/posture-guard.sh over a throwaway fixture tree. It is dispatched
# at entry, ahead of the command validator and the container check, and invokes no docker:
# the guard exists for the stack-down case, so its proof must run in that case.
#
# Use --database DB only when the project defines more than one DATABASES entry.
# Omit --database to target the default database (the baseline has one).
#
# Exit codes:  0 = success   1 = command failed   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'migrate.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
migrate.sh — Django migration management via the django container

Usage:
  migrate.sh run                   Apply all pending migrations
  migrate.sh make                  Create migrations for all apps
  migrate.sh show                  Show migration status for all apps
  migrate.sh check                 Exit non-zero if any migrations are pending
  migrate.sh fake                  Mark migrations as applied without running SQL
  migrate.sh fake-initial          Fake initial migrations for pre-existing tables
  migrate.sh --self-test           Prove the posture guard over a fixture tree (no docker)

Options (run, show, check, fake, fake-initial):
  --database DB      Target a non-default DATABASES alias.
                     Omit to use the default database (the baseline has one).

Options (run, make, show, fake):
  --app APP          Restrict to a single Django app

Options (make):
  --name NAME        Custom migration name
  --empty            Create an empty migration (for data migrations)

Options (fake):
  --migration NAME   Migration name to fake (e.g. 0003_add_slug)
                     Omit to fake the latest migration for the app.

Examples (<app> is a package under code/src/django/apps/):
  migrate.sh run
  migrate.sh run --app <app>
  migrate.sh make --app <app> --name add_slug_field
  migrate.sh make --empty --app <app> --name backfill_slugs
  migrate.sh show --app <app>
  migrate.sh check
  migrate.sh fake --app <app> --migration 0002_add_slug
  migrate.sh fake-initial

  # Only if the project has added a second database entry to DATABASES:
  migrate.sh run --database <alias>
  migrate.sh check --database <alias>

Exit codes:  0 = success   1 = command failed   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# `ps --services` prints service names only, so `grep -qx` is an exact match — a
# substring grep over the full `ps` table also matches image names and other services.
container_running() {
  cd "$PROJECT_ROOT"
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} ps --services --status running 2>/dev/null \
    | grep -qx "django"
}

manage() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"} exec -T -w /workspace/code/src/django django python manage.py "$@"
}

# ── Self-test ─────────────────────────────────────────────────────────────────
# Proves _lib/posture-guard.sh through the one caller that destroys nothing. Every case gets
# its own fixture root under one mktemp tree, removed by the trap on every exit path; nothing
# is written outside it. stdin is /dev/null, so the no-tty cases run in the state they name.
# A recording `docker` heads PATH and must never be called: the Docker metadata seam is
# replaced by function override after sourcing, never by an environment variable.
ST_TMP=""
ST_D=""
ST_MODE=""
ST_FAILS=0
ST_COMPOSE="st-proj"
ST_DEFAULT_SOCK="unix:///var/run/docker.sock"

# Conflict markers are BUILT from one character: a literal seven-character run in this file
# would redden audits/conflict-markers.sh on its own source.
st_run7() { printf '%.0s'"$1" 1 2 3 4 5 6 7; }

st_carrier() { printf '%s\n' "$@" >"$ST_D/root/.copier-answers.yml"; }
st_ctx()     { printf '%s\n' "$2" >"$ST_D/ctx/$1.endpoint"; }
st_saved()   { printf '{\n  "auths": {},\n  "currentContext": "%s"\n}\n' "$1" >"$ST_D/dockercfg/config.json"; }
st_template() { printf 'project_name:\n  type: str\n' >"$ST_D/root/copier.yml"; }

# Make PATH unreadable to the current user; if this process can read it anyway (root), put a
# directory there instead, and record which form the case used.
st_unreadable() {
  printf 'secret\n' >"$1"
  chmod 000 "$1"
  if cat -- "$1" >/dev/null 2>&1; then
    chmod 600 "$1"; rm -f -- "$1"; mkdir -p -- "$1"
    printf 'directory at the path (process could read a mode-000 file)' >"$ST_D/how"
  else
    printf 'mode-000 file' >"$ST_D/how"
  fi
}

# One guard call with stale outputs preloaded, so every case also proves the outputs are
# cleared at entry. Prints the outputs, then the binding (its refusal kept off stderr so it
# cannot be mistaken for the guard's own verdict).
st_guard() {
  local override="$1" tag="${2:-}" rc=0
  posture_resolved="stale"; posture_endpoint="unix:///stale.sock"; posture_target_valid="1"
  posture_docker=(stale)
  posture_guard "$ST_D/root" "$ST_MODE" "$override" "$ST_COMPOSE" \
    bash code/src/scripts/database/reset.sh --force-posture stale-word --force-posture=stale-eq --yes || rc=$?
  printf '%sresolved=%s\n%sendpoint=%s\n%svalid=%s\n%sdocker=%s\n' \
    "$tag" "$posture_resolved" "$tag" "$posture_endpoint" "$tag" "$posture_target_valid" \
    "$tag" "${posture_docker[*]}"
  st_bound "$tag"
  return "$rc"
}

st_bound() {
  if posture_docker_bind 2>>"$ST_D/bind-err"; then
    printf '%sbound=%s\n' "$1" "${posture_docker[*]}"
  else
    printf '%sbound=REFUSED\n' "$1"
  fi
}

# st_run LABEL WANT MODE FN [+ERE|-ERE ...]
#   Runs FN in a subshell over a fresh fixture. A refusal (WANT 4) passes only on return 4 AND
#   the prefix AND cleared binding outputs together; a permit (WANT 0) only on 0 with no
#   refusal line. +ERE must match a line of stdout+stderr, -ERE must match none.
st_run() {
  local label="$1" want="$2" mode="$3" fn="$4"; shift 4
  local dir="$ST_TMP/cases/$label-$mode" rc=0 ok=1 why="" pat note=""
  mkdir -p "$dir/root" "$dir/dockercfg" "$dir/ctx" "$dir/home"
  ST_D="$dir"; ST_MODE="$mode"
  (
    unset DOCKER_CONTEXT DOCKER_HOST COMPOSE_PROJECT_NAME DEPLOYMENT_POSTURE
    # shellcheck disable=SC2030  # deliberately subshell-local: no case leaks into the next
    export DOCKER_CONFIG="$dir/dockercfg" HOME="$dir/home"
    "$fn"
  ) >"$dir/out" 2>"$dir/err" || rc=$?
  cat "$dir/out" "$dir/err" >"$dir/all"
  [[ "$rc" == "$want" ]] || { ok=0; why="rc $rc, want $want"; }
  if [[ "$want" == 4 ]]; then
    grep -qF 'posture-guard: refused —' "$dir/err" || { ok=0; why+=" no refusal prefix"; }
    grep -qxE '(endpoint|valid|docker)=.+' "$dir/out" && { ok=0; why+=" binding not cleared"; }
  else
    grep -qF 'posture-guard: refused —' "$dir/err" && { ok=0; why+=" unexpected refusal"; }
  fi
  for pat in "$@"; do
    case "$pat" in
      +*) grep -qE -- "${pat#+}" "$dir/all" || { ok=0; why+=" missing /${pat#+}/"; } ;;
      -*) grep -qE -- "${pat#-}" "$dir/all" && { ok=0; why+=" forbidden /${pat#-}/"; } ;;
    esac
  done
  [[ -f "$dir/how" ]] && note=" [$(cat "$dir/how")]"
  if (( ok )); then
    printf '  PASS  case %-24s %-6s rc=%s%s\n' "$label" "$mode" "$rc" "$note"
  else
    printf '  FAIL  case %-24s %-6s rc=%s —%s\n' "$label" "$mode" "$rc" "$why"
    sed 's/^/          | /' "$dir/err"
    ST_FAILS=$((ST_FAILS + 1))
  fi
}

# ── The cases (numbers are US006's proof-case list) ──
st_c01()  { st_carrier 'DEPLOYMENT_POSTURE: development'; st_guard ""; }
st_c01s() { st_carrier "DEPLOYMENT_POSTURE: 'development'"; st_guard ""; }
st_c01d() { st_carrier 'DEPLOYMENT_POSTURE: "development"'; st_guard ""; }
st_c02()  { st_carrier 'DEPLOYMENT_POSTURE: staging'; st_guard ""; }
st_c03()  { st_carrier 'DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c04()  { st_carrier 'DEPLOYMENT_POSTURE: qa-live'; st_guard ""; }
st_c04c() { st_carrier 'DEPLOYMENT_POSTURE: development # set by hand'; st_guard ""; }
st_c05()  { st_carrier 'project_name: demo' 'project_slug: demo'; st_guard ""; }
st_c06()  { st_carrier '# DEPLOYMENT_POSTURE: development' 'project_slug: demo'; st_guard ""; }
st_c07()  { st_carrier 'DEPLOYMENT_POSTURE: development' 'DEPLOYMENT_POSTURE: development'; st_guard ""; }
st_c08() {
  # The other side deleted the key, so exactly one legal line survives: only the conflict
  # scan can refuse this, which is the point (TM-08).
  st_carrier "$(st_run7 '<') HEAD" 'DEPLOYMENT_POSTURE: development' "$(st_run7 '=')" \
    "$(st_run7 '>') upstream" 'project_slug: demo'
  st_guard ""
}
st_c09()  { st_unreadable "$ST_D/root/.copier-answers.yml"; st_guard ""; }
st_c10()  { st_guard ""; }
st_c11()  { st_template; st_carrier '# rendered by Copier' '# do not edit by hand'; st_guard ""; }
st_c12()  { st_template; st_carrier 'DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c13()  { export DEPLOYMENT_POSTURE=development; st_carrier 'DEPLOYMENT_POSTURE: production'; st_guard ""; }
# Key spellings YAML still reads as the carrier's key. PyYAML keeps the LAST duplicate, so a
# second spelling the guard did not count would let a production carrier read as development.
st_c07sp() { st_carrier 'DEPLOYMENT_POSTURE: development' 'DEPLOYMENT_POSTURE : production'; st_guard ""; }
st_c07dq() { st_carrier 'DEPLOYMENT_POSTURE: development' '"DEPLOYMENT_POSTURE": production'; st_guard ""; }
st_c07sq() { st_carrier "'DEPLOYMENT_POSTURE': production" 'DEPLOYMENT_POSTURE: development'; st_guard ""; }
# One key in a non-canonical spelling: refused as unrecognised rather than guessed at. With
# no space after the colon YAML reads no mapping at all, only a plain string.
st_c04ns() { st_carrier 'DEPLOYMENT_POSTURE:development'; st_guard ""; }
st_c04qk() { st_carrier '"DEPLOYMENT_POSTURE": development'; st_guard ""; }
st_c15()  { st_carrier 'DEPLOYMENT_POSTURE: production'; st_guard production; }
st_c16()  { st_carrier 'DEPLOYMENT_POSTURE: production'; st_guard staging; }
st_c17()  { st_carrier 'project_slug: demo'; st_guard development; }
st_c18()  { [[ ! -t 0 ]] || return 99; st_carrier 'DEPLOYMENT_POSTURE: staging'; st_guard ""; }
st_c19()  { [[ ! -t 0 ]] || return 99; st_carrier 'DEPLOYMENT_POSTURE: staging'; st_guard staging; }
st_cov()  { st_guard prod; }   # step 1: an invalid override refuses before the carrier is read

# Case 14 — effective Docker target. A development carrier unless the subcase says otherwise,
# so the only thing that can refuse is the target.
st_dev() { st_carrier 'DEPLOYMENT_POSTURE: development'; }
st_14a_ssh()      { st_dev; export DOCKER_HOST='ssh://ops@db.example.com'; st_guard ""; }
st_14a_ctx()      { st_dev; st_ctx remote 'tcp://10.0.0.5:2376'; export DOCKER_CONTEXT=remote; st_guard ""; }
st_14a_loop()     { st_dev; export DOCKER_HOST='tcp://127.0.0.1:2375'; st_guard ""; }
st_14a_compose()  { st_dev; export COMPOSE_PROJECT_NAME=someone-else; st_guard ""; }
st_14a_override() { st_carrier 'DEPLOYMENT_POSTURE: production'; export DOCKER_HOST='ssh://ops@db'; st_guard production; }
st_14a_template() { st_template; export DOCKER_HOST='ssh://ops@db'; st_guard ""; }
st_14b_saved()    { st_dev; st_ctx remote 'ssh://ops@db.example.com'; st_saved remote; st_guard ""; }
st_14c_named()    { st_dev; st_ctx colima 'unix:///home/ops/.colima/default/docker.sock'; export DOCKER_CONTEXT=colima; export COMPOSE_PROJECT_NAME="$ST_COMPOSE"; st_guard ""; }
st_14c_saved()    { st_dev; st_ctx colima 'unix:///home/ops/.colima/default/docker.sock'; st_saved colima; st_guard ""; }
st_14d_unknown()  { st_dev; export DOCKER_CONTEXT=ghost; st_guard ""; }
st_14d_malformed() { st_dev; printf 'currentContext = remote\n' >"$ST_D/dockercfg/config.json"; st_guard ""; }
# Docker reads config.json keys case-insensitively (Go encoding/json), so a case variant is the
# same selection; an escaped key could spell it invisibly, so any \\u escape fails closed.
st_14b_case()     { st_dev; st_ctx remote 'ssh://ops@db.example.com'; printf '{"CurrentContext": "remote"}\n' >"$ST_D/dockercfg/config.json"; st_guard ""; }
st_14d_casedup()  { st_dev; printf '{"currentContext":"a","CURRENTCONTEXT":"b"}\n' >"$ST_D/dockercfg/config.json"; st_guard ""; }
st_14d_escape()   { st_dev; printf '{"current\\u0043ontext":"remote"}\n' >"$ST_D/dockercfg/config.json"; st_guard ""; }
st_14d_twokeys()  { st_dev; printf '{"currentContext":"a","x":{"currentContext":"b"}}\n' >"$ST_D/dockercfg/config.json"; st_guard ""; }
st_14d_cfgread()  { st_dev; st_unreadable "$ST_D/dockercfg/config.json"; st_guard ""; }
st_14d_noend()    { st_dev; printf '' >"$ST_D/ctx/bare.endpoint"; export DOCKER_CONTEXT=bare; st_guard ""; }
st_14d_inspect()  { st_dev; printf '' >"$ST_D/ctx/broken.fails"; export DOCKER_CONTEXT=broken; st_guard ""; }
st_14d_relative() { st_dev; export DOCKER_HOST='unix://docker.sock'; st_guard ""; }
st_14d_empty()    { st_dev; export DOCKER_HOST='unix://'; st_guard ""; }
st_14d_disagree() { st_dev; st_ctx colima 'unix:///home/ops/.colima/default/docker.sock'; export DOCKER_CONTEXT=colima DOCKER_HOST="$ST_DEFAULT_SOCK"; st_guard ""; }
st_14e() {
  st_dev
  st_guard "" s1.
  # Selection drifts after validation: the binding already handed out must not re-resolve.
  export DOCKER_HOST='ssh://ops@drift' DOCKER_CONTEXT=remote
  st_ctx remote 'tcp://10.9.9.9:2376'
  st_bound s2.
  printf 's2.endpoint=%s\n' "$posture_endpoint"
  # A later failing call clears it: no stale binding survives into the next caller.
  st_guard ""
}
st_bind_unvalidated() { posture_docker=(stale); local rc=0; posture_docker_bind || rc=$?; printf 'docker=%s\n' "${posture_docker[*]}"; return "$rc"; }

self_test() {
  exec </dev/null
  ST_TMP="$(mktemp -d)"
  trap 'rm -rf -- "$ST_TMP"' EXIT
  trap 'exit 1' INT TERM
  mkdir -p "$ST_TMP/bin" "$ST_TMP/cases"
  printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$*" >>"%s/docker-calls"\nexit 97\n' "$ST_TMP" >"$ST_TMP/bin/docker"
  chmod +x "$ST_TMP/bin/docker"
  PATH="$ST_TMP/bin:$PATH"

  # shellcheck source=code/src/scripts/_lib/posture-guard.sh
  source "$SCRIPT_DIR/../_lib/posture-guard.sh"
  # The metadata seam, redefined after sourcing: contexts are fixture files under the case.
  # shellcheck disable=SC2329  # invoked by posture-guard.sh, which shellcheck does not trace
  posture_context_names() {
    local f
    for f in "$ST_D"/ctx/*.endpoint "$ST_D"/ctx/*.fails; do
      [[ -e "$f" ]] || continue
      f="${f##*/}"; printf '%s\n' "${f%.*}"
    done
  }
  # shellcheck disable=SC2329  # as above
  posture_context_endpoint() {
    [[ -e "$ST_D/ctx/$1.fails" ]] && return 1
    cat -- "$ST_D/ctx/$1.endpoint"
  }

  bold "▸ migrate.sh --self-test — _lib/posture-guard.sh"
  local refused='posture-guard: refused —' repair='set DEPLOYMENT_POSTURE in \.copier-answers\.yml to one of development, staging or production'
  local bound_default="^bound=env -u DOCKER_CONTEXT -u DOCKER_HOST docker --host $ST_DEFAULT_SOCK\$"
  local colima='unix:///home/ops/.colima/default/docker.sock'
  log "  stdin is a tty: $([[ -t 0 ]] && echo yes || echo no)   ·   refusal prefix: '$refused'"

  st_run 01 0 refuse st_c01 '+^resolved=development$' "+^endpoint=$ST_DEFAULT_SOCK\$" '+^valid=1$' "+$bound_default"
  st_run 01-single-quoted 0 refuse st_c01s '+^resolved=development$'
  st_run 01-double-quoted 0 refuse st_c01d '+^resolved=development$'
  st_run 02 4 refuse st_c02 "+'staging'" '+--force-posture staging' '+^resolved=staging$'
  st_run 03 4 refuse st_c03 "+'production'" '+--force-posture production'
  st_run 04 4 refuse st_c04 "+$repair" '+unrecognised' '-qa-live' '+^resolved=$'
  st_run 04-inline-comment 4 refuse st_c04c "+$repair" '-set by hand'
  st_run 05 4 refuse st_c05 "+$repair" '+no DEPLOYMENT_POSTURE'
  st_run 06 4 refuse st_c06 "+$repair" '+commented'
  st_run 07 4 refuse st_c07 "+$repair" '+more than once'
  st_run 07-spaced-key 4 refuse st_c07sp "+$repair" '+more than once' '+^resolved=$'
  st_run 07-dquoted-key 4 refuse st_c07dq "+$repair" '+more than once' '+^resolved=$'
  st_run 07-squoted-key 4 refuse st_c07sq "+$repair" '+more than once' '+^resolved=$'
  st_run 04-no-space 4 refuse st_c04ns "+$repair" '+unrecognised' '+^resolved=$'
  st_run 04-quoted-key 4 refuse st_c04qk "+$repair" '+unrecognised' '+^resolved=$'
  st_run 08 4 refuse st_c08 "+$repair" '+conflict'
  st_run 09 4 refuse st_c09 "+$repair" '+exists but cannot be read'
  st_run 10 4 refuse st_c10 "+$repair" '+does not exist'
  st_run 11 0 refuse st_c11 '+^resolved=$' '+^valid=1$'
  st_run 12 4 refuse st_c12 "+'production'" '+--force-posture production'
  st_run 13 4 refuse st_c13 "+'production'" '-is at .development'
  st_run 15 0 refuse st_c15 '+^resolved=production$' '+^valid=1$'
  st_run 16 4 refuse st_c16 '+--force-posture production' '-force-posture[ =](staging|stale-word|stale-eq)'
  st_run 17 4 refuse st_c17 "+$repair" '+not honoured' '-is at '
  st_run 18 4 refuse st_c18 "+'staging'"
  st_run 19 0 refuse st_c19 '+^resolved=staging$'
  st_run override-invalid 4 refuse st_cov '+development, staging or production' '-cannot be read|does not exist'
  st_run bind-unvalidated 4 refuse st_bind_unvalidated '+^docker=$'

  # Warn mode turns every refusal above into a warning and a 0, printing the posture (or
  # "unknown") and the expand-then-contract obligation at every posture.
  local c
  for c in 01 02 03 04 05 06 07 08 09 10 11 12 13 15 16 17 18 19; do
    st_run "$c" 0 warn "st_c$c" '+expand-then-contract' '+posture-guard: '
  done
  st_run 01-posture 0 warn st_c01 '+posture: development' '+^valid=1$'
  st_run 03-posture 0 warn st_c03 '+posture: production' "+^endpoint=$ST_DEFAULT_SOCK\$" "+$bound_default"
  st_run 10-posture 0 warn st_c10 '+posture: unknown' "+$repair"
  st_run 02-posture 0 warn st_c02 '+posture: staging'
  st_run 11-posture 0 warn st_c11 '+posture: unknown \(template repository'
  st_run 13-posture 0 warn st_c13 '+posture: production' '-posture: development'
  st_run 07-spaced-key 0 warn st_c07sp '+posture: unknown' '-posture: development'
  st_run override-invalid 0 warn st_cov '+is not a posture'

  # Case 14 in BOTH modes: denied in refuse means warned in warn, never a stale binding.
  local m want t
  for m in refuse warn; do
    want=4; [[ "$m" == warn ]] && want=0
    t=(); [[ "$m" == warn ]] && t=('+locality is unverified' '+^valid=$' '+^bound=REFUSED$')
    st_run 14a-remote-host    "$want" "$m" st_14a_ssh      '+ssh' "${t[@]}"
    st_run 14a-remote-context "$want" "$m" st_14a_ctx      '+tcp' "${t[@]}"
    st_run 14a-tcp-loopback   "$want" "$m" st_14a_loop     '+tcp' "${t[@]}"
    st_run 14a-compose-name   "$want" "$m" st_14a_compose  '+COMPOSE_PROJECT_NAME' "${t[@]}"
    st_run 14a-override-noop  "$want" "$m" st_14a_override '+ssh' "${t[@]}"
    st_run 14a-template-noop  "$want" "$m" st_14a_template '+ssh' "${t[@]}"
    st_run 14b-saved-remote   "$want" "$m" st_14b_saved    '+saved context' '+ssh' "${t[@]}"
    st_run 14c-named-local    0       "$m" st_14c_named    "+^endpoint=$colima\$" '+^valid=1$' \
      "+^bound=env -u DOCKER_CONTEXT -u DOCKER_HOST docker --host $colima\$"
    st_run 14c-saved-local    0       "$m" st_14c_saved    "+^endpoint=$colima\$" '+^valid=1$' \
      "+^bound=env -u DOCKER_CONTEXT -u DOCKER_HOST docker --host $colima\$"
    st_run 14b-saved-case     "$want" "$m" st_14b_case     '+saved context' '+ssh' "${t[@]}"
    st_run 14d-case-dup-cfg   "$want" "$m" st_14d_casedup  '+malformed' "${t[@]}"
    st_run 14d-escaped-key    "$want" "$m" st_14d_escape   '+malformed' "${t[@]}"
    st_run 14d-unknown-ctx    "$want" "$m" st_14d_unknown  '+unknown Docker context' "${t[@]}"
    st_run 14d-malformed-cfg  "$want" "$m" st_14d_malformed '+malformed' "${t[@]}"
    st_run 14d-ambiguous-cfg  "$want" "$m" st_14d_twokeys  '+malformed' "${t[@]}"
    st_run 14d-unreadable-cfg "$want" "$m" st_14d_cfgread  '+cannot be read' "${t[@]}"
    st_run 14d-no-endpoint    "$want" "$m" st_14d_noend    '+no Docker endpoint' "${t[@]}"
    st_run 14d-inspect-fails  "$want" "$m" st_14d_inspect  '+inspection' "${t[@]}"
    st_run 14d-relative-sock  "$want" "$m" st_14d_relative '+absolute' "${t[@]}"
    st_run 14d-empty-sock     "$want" "$m" st_14d_empty    '+absolute' "${t[@]}"
    st_run 14d-selectors-split "$want" "$m" st_14d_disagree '+disagree' "${t[@]}"
    st_run 14e-drift          "$want" "$m" st_14e \
      "+^s1\.${bound_default#^}" "+^s2\.${bound_default#^}" "+^s2\.endpoint=$ST_DEFAULT_SOCK\$" \
      '+^bound=REFUSED$' '+^endpoint=$' '+^valid=$'
  done

  # Sourced into a strict script, a permit and a fully-degraded warn must both run on: an
  # unguarded non-zero statement inside the helper would abort the caller here.
  local strict rc
  for strict in "permit:refuse::DEPLOYMENT_POSTURE: development" "warn:warn:prod:project_slug: demo"; do
    local label="${strict%%:*}" rest="${strict#*:}"; local smode="${rest%%:*}"; rest="${rest#*:}"
    local sover="${rest%%:*}" scarrier="${rest#*:}" sdir="$ST_TMP/cases/strict-$label"
    mkdir -p "$sdir/root" "$sdir/cfg"; printf '%s\n' "$scarrier" >"$sdir/root/.copier-answers.yml"
    rc=0
    # shellcheck disable=SC2016  # the child shell expands its own positional parameters
    env -u DOCKER_CONTEXT -u COMPOSE_PROJECT_NAME DOCKER_CONFIG="$sdir/cfg" DOCKER_HOST="$([[ $label == warn ]] && echo ssh://x)" \
      bash -euo pipefail -c 'source "$1"; posture_guard "$2" "$3" "$4" st-proj; echo REACHED' \
      _ "$SCRIPT_DIR/../_lib/posture-guard.sh" "$sdir/root" "$smode" "$sover" >"$sdir/out" 2>&1 || rc=$?
    if [[ "$rc" == 0 ]] && grep -qx REACHED "$sdir/out"; then
      printf '  PASS  case %-24s %-6s rc=%s\n' "set-euo-$label" "$smode" "$rc"
    else
      printf '  FAIL  case %-24s %-6s rc=%s — aborted under set -euo pipefail\n' "set-euo-$label" "$smode" "$rc"
      ST_FAILS=$((ST_FAILS + 1))
    fi
  done

  # Sourced by a bare relative name from its own directory, the helper must still find its
  # sibling conflict-marker library rather than abort the strict caller.
  rc=0
  (cd "$SCRIPT_DIR/../_lib" && bash -euo pipefail -c 'source ./posture-guard.sh; source posture-guard.sh; declare -F posture_guard >/dev/null; echo REACHED') \
    >"$ST_TMP/cases/relative-source.out" 2>&1 || rc=$?
  if [[ "$rc" == 0 ]] && grep -qx REACHED "$ST_TMP/cases/relative-source.out"; then
    printf '  PASS  case %-24s %-6s rc=%s\n' "relative-source" "-" "$rc"
  else
    printf '  FAIL  case %-24s %-6s rc=%s — sourcing by a relative name failed\n' "relative-source" "-" "$rc"
    sed 's/^/          | /' "$ST_TMP/cases/relative-source.out"
    ST_FAILS=$((ST_FAILS + 1))
  fi

  if [[ -e "$ST_TMP/docker-calls" ]]; then
    printf '  FAIL  docker was invoked:\n'; sed 's/^/          | /' "$ST_TMP/docker-calls"
    ST_FAILS=$((ST_FAILS + 1))
  else
    log "  PASS  docker never invoked"
  fi

  if (( ST_FAILS == 0 )); then bold "✓ self-test passed"; exit 0; fi
  printf '\033[31m✗ self-test FAILED — %s failing check(s)\033[0m\n' "$ST_FAILS"; exit 1
}

# Dispatched here, ahead of the command validator and container_running: the proof of a guard
# built for the stack-down case must not need a running stack.
if [[ "${1:-}" == "--self-test" ]]; then self_test; fi

# ── Command ───────────────────────────────────────────────────────────────────
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  run|make|show|check|fake|fake-initial) ;;
  --help|-h) usage; exit 0 ;;
  "")        die "No command given. Use --help for usage." ;;
  *)         die "Unknown command '$COMMAND'. Use --help for usage." ;;
esac

# ── Per-command flag parsing ──────────────────────────────────────────────────
APP=""
DATABASE=""
MIGRATION_NAME=""
MAKE_NAME=""
EMPTY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)        require_arg "$@"; APP="$2"; shift 2 ;;
    --database)   require_arg "$@"; DATABASE="$2"; shift 2 ;;
    --name)       require_arg "$@"; MAKE_NAME="$2"; shift 2 ;;
    --migration)  require_arg "$@"; MIGRATION_NAME="$2"; shift 2 ;;
    --empty)      EMPTY=true; shift ;;
    --help|-h)    usage; exit 0 ;;
    *)            die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"
container_running || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"

# ── Commands ──────────────────────────────────────────────────────────────────
case "$COMMAND" in
  run)
    bold "▸ migrate.sh run${DATABASE:+ — db:$DATABASE}${APP:+ — $APP}"
    log ""
    declare -a run_args=(migrate)
    [[ -n "$APP" ]]      && run_args+=("$APP")
    [[ -n "$DATABASE" ]] && run_args+=(--database "$DATABASE")
    manage "${run_args[@]}"
    log ""
    bold "✓ Migrations applied."
    ;;

  make)
    bold "▸ migrate.sh make${APP:+ — $APP}"
    log ""
    declare -a make_args=(makemigrations)
    [[ -n "$APP" ]]       && make_args+=("$APP")
    [[ -n "$MAKE_NAME" ]] && make_args+=(--name "$MAKE_NAME")
    $EMPTY                && make_args+=(--empty)
    manage "${make_args[@]}"
    log ""
    bold "✓ Migration files created."
    ;;

  show)
    bold "▸ migrate.sh show${DATABASE:+ — db:$DATABASE}${APP:+ — $APP}"
    log ""
    declare -a show_args=(showmigrations)
    [[ -n "$APP" ]]      && show_args+=("$APP")
    [[ -n "$DATABASE" ]] && show_args+=(--database "$DATABASE")
    manage "${show_args[@]}"
    ;;

  check)
    bold "▸ migrate.sh check${DATABASE:+ — db:$DATABASE}"
    log ""
    declare -a check_args=(migrate --check)
    [[ -n "$DATABASE" ]] && check_args+=(--database "$DATABASE")
    manage "${check_args[@]}"
    log ""
    bold "✓ No pending migrations."
    ;;

  fake)
    [[ -z "$APP" ]] && die "fake requires --app APP"
    bold "▸ migrate.sh fake${DATABASE:+ — db:$DATABASE} — $APP${MIGRATION_NAME:+ $MIGRATION_NAME}"
    log ""
    declare -a fake_args=(migrate --fake "$APP")
    [[ -n "$MIGRATION_NAME" ]] && fake_args+=("$MIGRATION_NAME")
    [[ -n "$DATABASE" ]]       && fake_args+=(--database "$DATABASE")
    manage "${fake_args[@]}"
    log ""
    bold "✓ Migration(s) marked as applied."
    ;;

  fake-initial)
    bold "▸ migrate.sh fake-initial${DATABASE:+ — db:$DATABASE}"
    log ""
    declare -a fi_args=(migrate --fake-initial)
    [[ -n "$DATABASE" ]] && fi_args+=(--database "$DATABASE")
    manage "${fi_args[@]}"
    log ""
    bold "✓ Initial migrations faked."
    ;;
esac
