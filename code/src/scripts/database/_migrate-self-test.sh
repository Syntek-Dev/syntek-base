#!/usr/bin/env bash
#
# _migrate-self-test.sh — migrate.sh --self-test: the proof of _lib/posture-guard.sh and of
# its six callers' wiring.
#
# Sourced by migrate.sh's --self-test arm, never executed and never sourced elsewhere: it
# reuses that script's SCRIPT_DIR, bold and log. Split out of migrate.sh (US006 P2) so the
# caller stays well inside the 750-line limit once the structural cases joined the helper
# cases, and so the caller-wiring assertions never read their own search literals back out
# of the file they are inspecting.
#
# shellcheck shell=bash
# shellcheck disable=SC2154  # SCRIPT_DIR is the sourcing script's
# ── Self-test ─────────────────────────────────────────────────────────────────
# Proves _lib/posture-guard.sh through the one caller that destroys nothing. Every case gets
# its own fixture root under one mktemp tree, removed by the trap on every exit path; nothing
# is written outside it. stdin is /dev/null, so the no-tty cases run in the state they name.
# A recording `docker` heads PATH and must never be called: the Docker metadata seam is
# replaced by function override after sourcing, never by an environment variable.
ST_TMP=""
ST_D=""
ST_MODE=""
ST_ENVF=""
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
  posture_guard "$ST_D/root" "$ST_MODE" "$override" "$ST_COMPOSE" "$ST_ENVF" \
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
  ST_D="$dir"; ST_MODE="$mode"; ST_ENVF="$dir/env-file"
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

# The prompt path, case 18's H half: an unanswered prompt refuses only above development, and
# whether a run is above development is the helper's to say, not each prompting caller's.
st_c18_prompt() { st_carrier 'DEPLOYMENT_POSTURE: staging'; st_guard staging >/dev/null; posture_unconfirmed; }
st_c18_dev()    { st_dev; st_guard "" >/dev/null; posture_unconfirmed; }
st_c18_tmpl()   { st_template; st_guard "" >/dev/null; posture_unconfirmed; }
st_above() {
  # $1 carrier line ("" = template), $2 override
  if [[ -n "$1" ]]; then st_carrier "$1"; else st_template; fi
  st_guard "$2" >/dev/null || true
  if posture_above_development; then echo above=yes; else echo above=no; fi
}
st_above_prod() { st_above 'DEPLOYMENT_POSTURE: production' production; }
st_above_stg()  { st_above 'DEPLOYMENT_POSTURE: staging' staging; }
st_above_dev()  { st_above 'DEPLOYMENT_POSTURE: development' ""; }
st_above_tmpl() { st_above "" ""; }

# The compose name a caller hands the guard: Compose merges its files in order and a later
# top-level `name:` replaces an earlier one, so the last declaring file in the set wins.
st_yml() { printf '%s\n' "${@:2}" >"$ST_D/$1"; }
st_cn() { local rc=0 n; n="$(posture_compose_name "$@")" || rc=$?; printf 'name=%s\n' "$n"; return "$rc"; }
st_cn_base()     { st_yml b.yml 'name: "proj-dev"' 'services:' '  web:' '    name: inner'; st_cn "$ST_D/b.yml"; }
st_cn_override() { st_cn_base >/dev/null; st_yml o.yml 'name: proj-dev-us006  # per story' 'services: {}'; st_cn "$ST_D/b.yml" "$ST_D/o.yml"; }
st_cn_silent()   { st_cn_base >/dev/null; st_yml o.yml 'services: {}'; st_cn "$ST_D/b.yml" "$ST_D/o.yml"; }
st_cn_squote()   { st_yml b.yml "name: 'proj-sq'"; st_cn "$ST_D/b.yml"; }
st_cn_nested()   { st_yml b.yml 'services:' '  name: inner'; st_cn "$ST_D/b.yml"; }
st_cn_missing()  { st_cn "$ST_D/absent.yml"; }

# F-018: Compose normalises a declared `name:` (lower-cased, every character outside a-z 0-9 _ -
# dropped, leading _ and - trimmed) but rejects an explicit COMPOSE_PROJECT_NAME that is not
# already in that form. The guard must permit exactly the project Compose will act on. The
# unrendered-token name is BUILT from parts so no Copier delimiter pair appears in this file.
st_f018_tok() { local o='<' c='%'; o+='%'; c+='>'; printf '%sPROJECT_SLUG%s-Dev-US006' "$o" "$c"; }
st_f018() { st_dev; ST_COMPOSE="$1"; [[ -n "${2-}" ]] && export COMPOSE_PROJECT_NAME="$2"; st_guard ""; }
st_f018_raw()    { local n; n="$(st_f018_tok)"; st_f018 "$n" "$n"; }
st_f018_norm()   { st_f018 "$(st_f018_tok)" project_slug-dev-us006; }
st_f018_unset()  { st_f018 "$(st_f018_tok)" ""; }
st_f018_other()  { st_f018 "$(st_f018_tok)" project-slug-dev-us006; }
st_f018_lead()   { st_f018 '-_Proj.Dev' projdev; }
st_f018_empty()  { local o='<' c='%'; o+='%'; c+='>'; st_f018 "-_${o}${c}" ""; }
st_f018_emptyc() { local o='<' c='%'; o+='%'; c+='>'; st_f018 "-_${o}${c}" anything; }
# shellcheck disable=SC2016  # the literal ${X} is the fixture under test, never expanded here
st_f018_interp() { st_f018 '${X}-dev' x-dev; }
st_f018_kelvin() { st_f018 $'\u212a-dev' k-dev; }

# Review R-002 (QA-02, SEC-02): YAML spellings of the key the line reader cannot model. Each sits
# beside a canonical development line and makes Copier's loader read production (or a value that
# is not a posture), so each must fail closed as unrecognised rather than read as development.
st_c07qm()   { st_carrier 'DEPLOYMENT_POSTURE: development' '? DEPLOYMENT_POSTURE' ': production'; st_guard ""; }
st_c07tag()  { st_carrier 'DEPLOYMENT_POSTURE: development' '!!str DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c07anc()  { st_carrier 'DEPLOYMENT_POSTURE: development' '&a DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c07esc()  { st_carrier 'DEPLOYMENT_POSTURE: development' '"DEPLOYMENT_POST\u0055RE": production'; st_guard ""; }
st_c04cont() { st_carrier 'DEPLOYMENT_POSTURE: development' '  production'; st_guard ""; }
st_c04contb() { st_carrier 'DEPLOYMENT_POSTURE: development' '' '  production' 'project_slug: demo'; st_guard ""; }
# What Copier really writes around the key still reads: a block scalar elsewhere, a trailing comment.
st_c01ctx()  { st_carrier '_commit: v7.9.0' 'PROJECT_DESCRIPTION: |-' '  a multi-line' '  description' \
                 'DEPLOYMENT_POSTURE: development' '  # an indented comment' 'project_slug: demo'; st_guard ""; }

# Review R-001 (F-020, SEC-01, QA-01): COMPOSE_PROJECT_NAME read from the --env-file every caller
# hands Compose, the shell's value first — Compose's own precedence.
st_envf()       { printf '%s\n' "$@" >"$ST_ENVF"; }
st_ef_other()   { st_dev; st_envf 'POSTGRES_DB=x' 'COMPOSE_PROJECT_NAME=someone-else'; st_guard ""; }
st_ef_export()  { st_dev; st_envf 'export COMPOSE_PROJECT_NAME=someone-else'; st_guard ""; }
st_ef_match()   { st_dev; st_envf "COMPOSE_PROJECT_NAME=$ST_COMPOSE"; st_guard ""; }
st_ef_quoted()  { st_dev; st_envf "COMPOSE_PROJECT_NAME=\"$ST_COMPOSE\""; st_guard ""; }
st_ef_shell()   { st_dev; st_envf 'COMPOSE_PROJECT_NAME=someone-else'; export COMPOSE_PROJECT_NAME="$ST_COMPOSE"; st_guard ""; }
# shellcheck disable=SC2016  # the literal ${X} is the fixture under test
st_ef_interp()  { st_dev; st_envf 'COMPOSE_PROJECT_NAME=${X}-dev'; st_guard ""; }
st_ef_invalid() { st_dev; st_envf 'COMPOSE_PROJECT_NAME=Someone'; st_guard ""; }
st_ef_none()    { st_dev; st_envf 'POSTGRES_DB=x'; st_guard ""; }
# Independent re-check of the fixes: line breaks Copier's loader (PyYAML) honours and a line
# reader does not — a lone CR, NEL, U+2028, U+2029 — each hiding a second key behind the first.
st_c07cr()   { st_carrier 'DEPLOYMENT_POSTURE: development' $'other: x\rDEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c07nel()  { st_carrier 'DEPLOYMENT_POSTURE: development' $'other: x\xc2\x85DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c07ls()   { st_carrier 'DEPLOYMENT_POSTURE: development' $'other: x\xe2\x80\xa8DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c07ps()   { st_carrier 'DEPLOYMENT_POSTURE: development' $'other: x\xe2\x80\xa9DEPLOYMENT_POSTURE: production'; st_guard ""; }
st_c01crlf() { st_carrier $'_commit: v7.9.0\r' $'DEPLOYMENT_POSTURE: development\r'; st_guard ""; }
# Compose's env-file grammar also takes `KEY = value` and `KEY: value`; the guard refuses any
# spelling but the canonical one, and a key set twice, rather than modelling the grammar.
st_ef_spaced()  { st_dev; st_envf 'COMPOSE_PROJECT_NAME = someone-else'; st_guard ""; }
st_ef_colon()   { st_dev; st_envf 'COMPOSE_PROJECT_NAME: someone-else'; st_guard ""; }
st_ef_twice()   { st_dev; st_envf "COMPOSE_PROJECT_NAME=$ST_COMPOSE" 'COMPOSE_PROJECT_NAME: someone-else'; st_guard ""; }
st_ef_crlf()    { st_dev; st_envf $'COMPOSE_PROJECT_NAME="st-proj"\r'; st_guard ""; }
st_ef_comment() { st_dev; st_envf '# COMPOSE_PROJECT_NAME=someone-else'; st_guard ""; }
# What Copier's dumper really writes: NEL / U+2028 / U+2029 raw inside a quoted free-text answer.
st_c01nel() { st_carrier $'PROJECT_DESCRIPTION: \'line one\xc2\x85    line two\'' 'DEPLOYMENT_POSTURE: development'; st_guard ""; }
st_c01ls()  { st_carrier $'PROJECT_DESCRIPTION: \'line one\xe2\x80\xa8    line two\'' 'DEPLOYMENT_POSTURE: development'; st_guard ""; }
st_c04nel() { st_carrier $'DEPLOYMENT_POSTURE: development\xc2\x85  production'; st_guard ""; }
# Compose's env parser is not line-based: a BOM is stripped, any Unicode space skipped, and a
# statement may follow a closing quote. Every mention of the key but one canonical line refuses.
st_ef_bom()   { st_dev; st_envf $'\xef\xbb\xbfCOMPOSE_PROJECT_NAME=someone-else'; st_guard ""; }
st_ef_nbsp()  { st_dev; st_envf $'\xc2\xa0COMPOSE_PROJECT_NAME=someone-else'; st_guard ""; }
st_ef_after() { st_dev; st_envf 'X="a" COMPOSE_PROJECT_NAME=someone-else'; st_guard ""; }
st_ef_nul()   { st_dev; printf 'X=a\000b\nCOMPOSE_PROJECT_NAME=someone-else\n' >"$ST_ENVF"; st_guard ""; }
st_ef_tab()   { st_dev; st_envf $'export\tCOMPOSE_PROJECT_NAME=st-proj'; st_guard ""; }
st_ef_multi() { st_dev; st_envf "X='a" "# ' COMPOSE_PROJECT_NAME=someone-else"; st_guard ""; }

# ── Structural cases: the six callers' wiring ──
# Line-order over each caller's own text (story 7.8). Every probe is a deliberate literal — a
# fixed string, never a pattern — and comment lines never count, so a token parked in a comment
# cannot stand in for the code it names.
#   st_ln FILE lead|any LITERAL [AFTER]
#     the first line number above AFTER that begins with LITERAL after its indentation (lead)
#     or contains it anywhere (any); nothing when no line does
st_ln() {
  awk -v mode="$2" -v s="$3" -v after="${4:-0}" '
    NR <= after { next }
    { t = $0; sub(/^[ \t]+/, "", t) }
    t ~ /^#/ { next }
    (mode == "lead" && index(t, s) == 1) || (mode == "any" && index($0, s) > 0) { print NR; exit }
  ' "$1"
}

st_s() {
  if [[ "$2" == 1 ]]; then printf '  PASS  case %-30s S\n' "$1"
  else printf '  FAIL  case %-30s S — %s\n' "$1" "$3"; ST_FAILS=$((ST_FAILS + 1)); fi
}

# st_order LABEL WHAT LINE... — passes only when every line exists and they strictly ascend.
st_order() {
  local label="$1" what="$2" prev=0 n ok=1 seen=""; shift 2
  for n in "$@"; do
    seen+="${n:-none} "
    if [[ -z "$n" ]] || (( n <= prev )); then ok=0; fi
    [[ -n "$n" ]] && prev="$n"
  done
  st_s "$label" "$ok" "$what (lines: ${seen% })"
}

# st_has LABEL FILE LINE LITERAL — the statement starting at LINE (backslash continuations
# joined) carries LITERAL.
st_has() {
  local ok=0 stmt=""
  [[ -n "$3" ]] && stmt="$(awk -v n="$3" 'NR >= n { printf "%s ", $0; if ($0 !~ /\\$/) exit }' "$2")"
  [[ -n "$stmt" && "$stmt" == *"$4"* ]] && ok=1
  st_s "$1" "$ok" "the statement at line ${3:-none} does not carry: $4"
}

# st_lines FILE ERE [AFTER] — every line below AFTER, outside comments and heredocs, that
# matches ERE, space-separated. The ERE is a regex, so it must avoid awk escape sequences.
st_lines() {
  awk -v re="$2" -v after="${3:-0}" '
    inhd { if ($0 ~ /^EOF$/) inhd = 0; next }
    /<<.?EOF/ { inhd = 1; next }
    NR <= after { next }
    { t = $0; sub(/^[ \t]+/, "", t) }
    t ~ /^#/ { next }
    $0 ~ re { printf "%s ", NR }
  ' "$1"
}

# st_set LABEL WHAT GOT WANT... — GOT (an st_lines result) is exactly the listed lines. An exact
# set, not a first-match, so a second copy parked elsewhere in the file cannot pass unnoticed.
st_set() {
  local label="$1" what="$2" got="$3" want=""; shift 3
  local n; for n in "$@"; do want+="${n:-none} "; done
  st_s "$label" "$([[ "$got" == "$want" && "$want" != *none* ]] && echo 1)" "$what (lines: ${got:-none}; want: ${want:-none})"
}

# st_bare LABEL FILE GUARD — no line outside comments and heredocs runs docker by name, nor
# resets the array to the plain CLI (`docker` followed by `)` included): every Docker and Compose
# call goes through the DOCKER array. The one exception is the unbound default
# `DOCKER=(docker)`, and only above GUARD, where the guarded path has not yet begun.
st_bare() {
  local hits="" n t
  for n in $(st_lines "$2" '(^|[[:space:];&|(!`"])docker([[:space:])]|$)'); do
    t="$(sed -n "${n}p" "$2")"; t="${t#"${t%%[![:space:]]*}"}"
    [[ -n "$3" ]] && (( n < $3 )) && [[ "$t" == 'DOCKER=(docker)' ]] && continue
    hits+="$n "
  done
  st_s "$1" "$([[ -z "$hits" ]] && echo 1)" "docker run by name, not through the binding, at lines: ${hits:-none}"
}

# The two ERE probes for the binding (story 7.12): an assignment to either array, and anything
# that would re-select a daemon after the guard validated one.
ST_REASSIGN='(^|[^_[:alnum:]])(DOCKER|DC)[+]?='
ST_SELECTOR='--context|[[:space:]]--host([[:space:]=]|$)|DOCKER_HOST=|DOCKER_CONTEXT='
ST_GUARDCALL='(^|[^_[:alnum:]])posture_guard([[:space:]]|$)'

# shellcheck disable=SC2016  # every literal below is caller source text, never expanded here
st_structural() {
  local guard_r='posture_guard "$PROJECT_ROOT" refuse ' guard_w='posture_guard "$PROJECT_ROOT" warn '
  local term='|| exit "$?"' bind='posture_docker_bind || exit "$?"' pin='DOCKER=("${posture_docker[@]}")'
  local dcdef='DC=("${DOCKER[@]}" compose' down_if='if [[ "$COMMAND" == down ]] && $VOLUMES; then'
  local envchk='[[ -f "$ENV_FILE" ]] || die' loop='while [[ $# -gt 0 ]]; do'
  local f file name g p d b k dc y r q a fp u e v c up sb ud gs ks vb t h kp

  # reset.sh, restore.sh — first destructive command: the first `DROP DATABASE`.
  for f in reset restore; do
    file="$SCRIPT_DIR/$f.sh"
    g="$(st_ln "$file" lead "$guard_r")"; p="$(st_ln "$file" any '"${DC[@]}" ps')"
    d="$(st_ln "$file" any 'DROP DATABASE')"
    st_order "7.8-presence-$f" "guard, then container preflight, then DROP DATABASE" "$g" "$p" "$d"
    st_has "7.7-terminates-$f" "$file" "$g" "$term"
    b="$(st_ln "$file" lead "$bind" "$g")"; k="$(st_ln "$file" lead "$pin" "${b:-0}")"
    dc="$(st_ln "$file" lead "$dcdef" "${k:-0}")"
    st_order "14-binding-$f" "guard, bind, pin, compose array — all before the preflight" "$g" "$b" "$k" "$dc" "$p"
    st_bare "14-no-bare-docker-$f" "$file" "$g"
    st_set "7.8-one-guard-$f" "exactly one guard call" "$(st_lines "$file" "$ST_GUARDCALL")" "$g"
    st_set "14-no-repin-$f" "after the pin, only the compose array is assigned" "$(st_lines "$file" "$ST_REASSIGN" "${k:-0}")" "$dc"
    st_set "14-no-reselect-$f" "no daemon re-selected after the guard" "$(st_lines "$file" "$ST_SELECTOR" "${g:-0}")"
    y="$(st_ln "$file" lead 'if $YES && posture_above_development; then' "${g:-0}")"
    r="$(st_ln "$file" any 'read -r REPLY' "${g:-0}")"
    q="$(st_ln "$file" lead '[[ -n "$REPLY" ]] || posture_unconfirmed || exit "$?"' "${r:-0}")"
    a="$(st_ln "$file" any 'log "  Aborted."; exit 0' "${r:-0}")"
    st_order "yes-inert-$f" "--yes made inert above development before the prompt" "$g" "$y" "$r"
    st_order "18-empty-read-$f" "the prompt's empty read refuses at 4 ahead of the exit-0 abort" "$r" "$q" "$a"
  done

  # seed-dev.sh — first destructive command: the user upsert, `manage.py shell`.
  file="$SCRIPT_DIR/seed-dev.sh"
  g="$(st_ln "$file" lead "$guard_r")"; p="$(st_ln "$file" any '"${DC[@]}" ps')"
  d="$(st_ln "$file" any 'manage.py shell')"
  st_order "7.8-presence-seed-dev" "guard, then container preflight, then the user upsert" "$g" "$p" "$d"
  st_has "7.7-terminates-seed-dev" "$file" "$g" "$term"
  b="$(st_ln "$file" lead "$bind" "$g")"; k="$(st_ln "$file" lead "$pin" "${b:-0}")"
  dc="$(st_ln "$file" lead "$dcdef" "${k:-0}")"
  st_order "14-binding-seed-dev" "guard, bind, pin, compose array — all before the preflight" "$g" "$b" "$k" "$dc" "$p"
  st_bare "14-no-bare-docker-seed-dev" "$file" "$g"
  st_set "7.8-one-guard-seed-dev" "exactly one guard call" "$(st_lines "$file" "$ST_GUARDCALL")" "$g"
  st_set "14-no-repin-seed-dev" "after the pin, only the compose array is assigned" "$(st_lines "$file" "$ST_REASSIGN" "${k:-0}")" "$dc"
  st_set "14-no-reselect-seed-dev" "no daemon re-selected after the guard" "$(st_lines "$file" "$ST_SELECTOR" "${g:-0}")"
  fp="$(st_ln "$file" lead '--force-posture)')"; u="$(st_ln "$file" any 'die "Unknown option')"
  st_order "20-seed-dev-parses-first" "--force-posture parsed ahead of the unknown-option die, then the guard" "$fp" "$u" "$g"

  # Both server.sh — first destructive command: `args+=(--volumes)`, the volume-removing down.
  for name in development tests; do
    file="$SCRIPT_DIR/../$name/server.sh"
    g="$(st_ln "$file" lead "$guard_r")"; e="$(st_ln "$file" lead "$envchk")"
    v="$(st_ln "$file" any 'args+=(--volumes)')"; c="$(st_ln "$file" lead "$down_if")"
    st_order "7.8-presence-$name-server" "down --volumes guard, then the env-file check, then the volume removal" "$g" "$e" "$v"
    st_s "7.8-down-volumes-only-$name" "$([[ -n "$c" && -n "$g" ]] && (( g == c + 1 )) && echo 1)" \
      "the first guard call (line ${g:-none}) is not the first statement under: $down_if"
    st_has "7.7-terminates-$name-server" "$file" "$g" "$term"
    b="$(st_ln "$file" lead "$bind" "$g")"; k="$(st_ln "$file" lead "$pin" "${b:-0}")"
    dc="$(st_ln "$file" lead "$dcdef" "${k:-0}")"
    st_order "14-binding-$name-server" "guard, bind, pin, then the compose array every subcommand uses" "$g" "$b" "$k" "$dc" "$v"
    st_bare "14-no-bare-docker-$name-srv" "$file" "$g"
    if [[ "$name" == development ]]; then
      # development binds on two paths, so the up --seed pin follows the down --volumes one.
      kp="$(st_ln "$file" lead "$pin" "${k:-0}")"
      st_set "14-no-repin-$name-server" "after the pins, only the compose array is assigned" "$(st_lines "$file" "$ST_REASSIGN" "${k:-0}")" "$kp" "$dc"
    else
      st_set "14-no-repin-$name-server" "after the pin, only the compose array is assigned" "$(st_lines "$file" "$ST_REASSIGN" "${k:-0}")" "$dc"
    fi
    t="$(st_ln "$file" lead "$loop")"; fp="$(st_ln "$file" lead '--force-posture)' "${t:-0}")"
    u="$(st_ln "$file" any 'die "Unknown option' "${t:-0}")"
    st_order "global-flag-$name-server" "--force-posture parsed in the global flag loop, before its die" "$t" "$fp" "$u" "$g"
  done

  # development/server.sh — F-001 and case 21: `up --seed` is guarded and bound in its own
  # top-level block, beside the down --volumes one and ahead of the env-file check, so a
  # refusal comes before any daemon operation and `up -d`, the password sync and the seed
  # shell-out all run on the pinned binding. `up` without --seed never reaches a guard.
  # Case 20: the override and the pinned host cross the shell-out.
  file="$SCRIPT_DIR/../development/server.sh"
  local seed_if='if [[ "$COMMAND" == up ]] && $SEED; then' sg bs sy
  sg="$(st_ln "$file" lead "$seed_if")"; gs="$(st_ln "$file" lead "$guard_r" "${sg:-0}")"
  bs="$(st_ln "$file" lead "$bind" "${gs:-0}")"; kp="$(st_ln "$file" lead "$pin" "${bs:-0}")"
  e="$(st_ln "$file" lead "$envchk")"; dc="$(st_ln "$file" lead "$dcdef")"
  up="$(st_ln "$file" lead 'up)')"; ud="$(st_ln "$file" any ' up -d)' "${up:-0}")"
  sy="$(st_ln "$file" lead '_sync_db_password' "${up:-0}")"
  sb="$(st_ln "$file" lead 'if $SEED; then' "${up:-0}")"
  ks="$(st_ln "$file" any 'database/seed-dev.sh"' "${up:-0}")"
  st_s "21-seed-guard-first-in-block" "$([[ -n "$sg" && -n "$gs" ]] && (( gs == sg + 1 )) && echo 1)" \
    "the --seed guard (line ${gs:-none}) is not the first statement under: $seed_if"
  st_order "F001-seed-bound-before-up" "--seed guard, bind, pin, env-file check, compose array, up head, up -d, password sync, seed branch, shell-out" \
    "$sg" "$gs" "$bs" "$kp" "$e" "$dc" "$up" "$ud" "$sy" "$sb" "$ks"
  st_has "F001-up-d-on-compose-array" "$file" "$ud" 'args=("${DC[@]}" up -d)'
  st_has "7.7-terminates-seed-branch" "$file" "$gs" "$term"
  st_has "20-forwards-override" "$file" "$ks" '${FORCE_POSTURE:+--force-posture "$FORCE_POSTURE"}'
  st_has "20-pins-child-host" "$file" "$ks" 'env -u DOCKER_CONTEXT DOCKER_HOST="$posture_endpoint" bash'
  st_has "7.7-terminates-shell-out" "$file" "$ks" "$term"
  # Cases 7.8 and 21 over the whole file: exactly two guard calls — the first statement under
  # the down --volumes if and the first under the up --seed if. A third, anywhere (inside the
  # up case above all), would bind a subcommand the story leaves unbound: up --build.
  c="$(st_ln "$file" lead "$down_if")"
  st_set "21-dev-two-guards-only" "guard calls: under down --volumes, under up --seed only" \
    "$(st_lines "$file" "$ST_GUARDCALL")" "${c:+$((c + 1))}" "${sg:+$((sg + 1))}"
  # The only re-selection after the first guard is the shell-out handing the child its pinned host.
  g="$(st_ln "$file" lead "$guard_r")"
  st_set "14-dev-no-reselect" "re-selection after the guard: the seed shell-out only" "$(st_lines "$file" "$ST_SELECTOR" "${g:-0}")" "$ks"

  # tests/server.sh — one guard call, under down --volumes, and no re-selection after it.
  file="$SCRIPT_DIR/../tests/server.sh"
  c="$(st_ln "$file" lead "$down_if")"; g="$(st_ln "$file" lead "$guard_r")"
  st_set "7.8-tests-one-guard" "exactly one guard call, under down --volumes" "$(st_lines "$file" "$ST_GUARDCALL")" "${c:+$((c + 1))}"
  st_set "14-tests-no-reselect" "no daemon re-selected after the guard" "$(st_lines "$file" "$ST_SELECTOR" "${g:-0}")"

  # migrate.sh — warn mode at entry: after the --self-test arm, before argument dispatch.
  file="$SCRIPT_DIR/migrate.sh"
  t="$(st_ln "$file" lead 'if [[ "${1:-}" == "--self-test" ]]; then')"; g="$(st_ln "$file" lead "$guard_w")"
  c="$(st_ln "$file" lead 'COMMAND="${1:-}"')"
  st_order "7.8-presence-migrate" "the --self-test arm, then the guard, then argument dispatch" "$t" "$g" "$c"
  st_has "7.7-terminates-migrate" "$file" "$g" "$term"
  vb="$(st_ln "$file" lead 'if [[ "${posture_target_valid-}" == 1 ]]; then' "${g:-0}")"
  b="$(st_ln "$file" lead "$bind" "${vb:-0}")"; k="$(st_ln "$file" lead "$pin" "${b:-0}")"
  st_order "14-binding-migrate" "bound only on a validated target, before argument dispatch" "$g" "$vb" "$b" "$k" "$c"
  st_bare "14-no-bare-docker-migrate" "$file" "$g"
  st_set "7.8-migrate-one-guard" "exactly one guard call" "$(st_lines "$file" "$ST_GUARDCALL")" "$g"
  st_set "14-no-repin-migrate" "nothing reassigns the arrays after the pin" "$(st_lines "$file" "$ST_REASSIGN" "${k:-0}")"
  st_set "14-no-reselect-migrate" "no daemon re-selected after the guard" "$(st_lines "$file" "$ST_SELECTOR" "${g:-0}")"
  # --help answers ahead of the guard, as it does in the other five callers' flag loops.
  h="$(st_ln "$file" lead 'if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then usage; exit 0; fi')"
  st_order "help-before-guard-migrate" "the --self-test arm, then the --help arm, then the guard" "$t" "$h" "$g"
}

# ── Behavioural cases: the six callers, run (review R-005) ──
# The structural cases read the callers' text; these run them. A fixture repository holds copies
# of the four script groups, two one-line compose files and two env files, and a recording
# `docker` heads PATH for these runs only: it logs its arguments and exits 0, and prints `db` for
# a `ps` only when the case asks, so a permitted run stops at the container preflight. Every
# call it records is the stub's — nothing reaches a daemon. The suite-wide exit-97 docker still
# guards everything else.
st_cdir=""

st_cfix() {
  local d
  st_cdir="$ST_TMP/callers"
  mkdir -p "$st_cdir/bin" "$st_cdir/home" "$st_cdir/cfg" "$st_cdir/elsewhere" "$st_cdir/root/code/src/docker"
  for d in _lib database development tests; do
    mkdir -p "$st_cdir/root/code/src/scripts/$d"
    cp -- "$SCRIPT_DIR/../$d"/*.sh "$st_cdir/root/code/src/scripts/$d/"
  done
  printf 'name: st-callers-dev\nservices: {}\n' >"$st_cdir/root/code/src/docker/docker-compose.dev.yml"
  printf 'name: st-callers-test\nservices: {}\n' >"$st_cdir/root/code/src/docker/docker-compose.test.yml"
  printf 'POSTGRES_DB=st\nPOSTGRES_USER=st\n' >"$st_cdir/root/code/src/docker/.env.dev"
  printf 'POSTGRES_DB=st\nPOSTGRES_USER=st\n' >"$st_cdir/root/code/src/docker/.env.test"
  printf 'backup\n' >"$st_cdir/root/backup.dump"
  printf 'backup\n' >"$st_cdir/elsewhere/rel.dump"
  # shellcheck disable=SC2016  # the stub's own text
  printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$*" >>"%s/calls"\n[[ "${ST_PS_DB:-}" == 1 && " $* " == *" ps "* ]] && echo db\n[[ " $* " == *" -d "* && ( " $* " == *" pg_restore "* || " $* " == *" psql "* ) ]] && wc -c >>"%s/stdin"\n[[ -n "${ST_RM_ON_DROP:-}" && " $* " == *"DROP DATABASE"* ]] && rm -f -- "$ST_RM_ON_DROP"\nexit 0\n' \
    "$st_cdir" "$st_cdir" >"$st_cdir/bin/docker"
  chmod +x "$st_cdir/bin/docker"
}

# st_call LABEL WANT POSTURE SCRIPT [ARG...]
#   WANT 4      refused at 4, with the prefix, and the stub never called;
#   WANT permit not refused, the stub called, and every call pinned to the default socket;
#   WANT 0      exit 0 and every call pinned;
#   WANT stop   a non-zero exit other than 4 before the stub was called. ST_CENV adds env-file lines; ST_PS_DB=1 the db.
st_call() {
  local label="$1" want="$2" posture="$3" script="$4" rc=0 ok=1 why="" pinned bad; shift 4
  printf 'DEPLOYMENT_POSTURE: %s\n' "$posture" >"$st_cdir/root/.copier-answers.yml"
  printf 'POSTGRES_DB=st\nPOSTGRES_USER=st\n%s' "${ST_CENV:-}" >"$st_cdir/root/code/src/docker/.env.dev"
  printf 'POSTGRES_DB=st\nPOSTGRES_USER=st\n%s' "${ST_CENV:-}" >"$st_cdir/root/code/src/docker/.env.test"
  rm -f -- "$st_cdir/calls" "$st_cdir/stdin"
  (
    cd "$st_cdir/elsewhere" &&
    env -u DOCKER_CONTEXT -u DOCKER_HOST -u COMPOSE_PROJECT_NAME -u DEPLOYMENT_POSTURE \
      HOME="$st_cdir/home" DOCKER_CONFIG="$st_cdir/cfg" PATH="$st_cdir/bin:$PATH" ST_PS_DB="${ST_PS_DB:-}" \
      ST_RM_ON_DROP="${ST_RM_ON_DROP:-}" \
      timeout 60 bash "$st_cdir/root/code/src/scripts/$script" "$@"
  ) >"$st_cdir/out" 2>&1 || rc=$?
  pinned="--host $ST_DEFAULT_SOCK "
  bad="$( [[ -f "$st_cdir/calls" ]] && grep -vcF -- "$pinned" "$st_cdir/calls" || true)"
  case "$want" in
    4)
      [[ "$rc" == 4 ]] || { ok=0; why+=" rc $rc, want 4"; }
      grep -qF 'posture-guard: refused —' "$st_cdir/out" || { ok=0; why+=" no refusal prefix"; }
      [[ -s "$st_cdir/calls" ]] && { ok=0; why+=" docker called on a refused run"; }
      ;;
    stop)
      [[ "$rc" != 0 && "$rc" != 4 ]] || { ok=0; why+=" rc $rc, want a non-zero stop other than 4"; }
      [[ -s "$st_cdir/calls" ]] && { ok=0; why+=" docker called before the stop"; }
      ;;
    permit|0)
      [[ "$want" == 0 && "$rc" != 0 ]] && { ok=0; why+=" rc $rc, want 0"; }
      [[ "$rc" == 4 ]] && { ok=0; why+=" rc 4"; }
      grep -qF 'posture-guard: refused —' "$st_cdir/out" && { ok=0; why+=" unexpected refusal"; }
      [[ -s "$st_cdir/calls" ]] || { ok=0; why+=" docker never called"; }
      [[ "${bad:-0}" == 0 ]] || { ok=0; why+=" $bad docker call(s) not pinned to $ST_DEFAULT_SOCK"; }
      ;;
  esac
  if (( ok )); then printf '  PASS  case %-30s B rc=%s\n' "$label" "$rc"
  else
    printf '  FAIL  case %-30s B rc=%s —%s\n' "$label" "$rc" "$why"
    sed 's/^/          | /' "$st_cdir/out" | tail -n 8
    ST_FAILS=$((ST_FAILS + 1))
  fi
}

st_behavioural() {
  local s
  st_cfix
  # Refused above development: exit 4 and the daemon never contacted.
  st_call B-staging-reset         4 staging database/reset.sh --yes
  st_call B-staging-restore       4 staging database/restore.sh --yes "$st_cdir/root/backup.dump"
  st_call B-staging-seed-dev      4 staging database/seed-dev.sh
  st_call B-staging-dev-down-vol  4 staging development/server.sh down --volumes
  st_call B-staging-dev-up-seed   4 staging development/server.sh up --seed
  st_call B-staging-test-down-vol 4 staging tests/server.sh down --volumes
  # Permitted at development: every daemon call on the validated socket.
  st_call B-dev-reset             permit development database/reset.sh --yes
  st_call B-dev-restore           permit development database/restore.sh --yes "$st_cdir/root/backup.dump"
  st_call B-dev-seed-dev          permit development database/seed-dev.sh
  st_call B-dev-down-vol          permit development development/server.sh down --volumes
  st_call B-dev-up-seed           permit development development/server.sh up --seed
  st_call B-test-down-vol         permit development tests/server.sh down --volumes
  st_call B-dev-migrate-show      permit development database/migrate.sh show
  # The override crosses each parser, and up --seed hands it to its seed-dev child.
  st_call B-override-seed-dev     permit staging database/seed-dev.sh --force-posture staging
  st_call B-override-up-seed      permit staging development/server.sh up --seed --force-posture staging
  st_call B-override-wrong        4 staging database/seed-dev.sh --force-posture production
  # R-001 end to end: the env file's project name is the one the guard checks.
  ST_CENV=$'COMPOSE_PROJECT_NAME=someone-else\n' st_call B-envfile-name-refused 4 development development/server.sh down --volumes
  ST_CENV=$'COMPOSE_PROJECT_NAME=st-callers-dev\n' st_call B-envfile-name-matches permit development development/server.sh down --volumes
  ST_CENV=$'COMPOSE_PROJECT_NAME=someone-else\n' st_call B-envfile-test-refused 4 development tests/server.sh down --volumes
  # R-004: a relative backup path is resolved where the operator typed it, before the cd, and a
  # missing one stops the run before the daemon is touched.
  # The stub deletes the backup the moment the DROP runs: the restore must still read every byte,
  # which it can only do from the descriptor it opened before the DROP — in both formats.
  ST_PS_DB=1 ST_RM_ON_DROP="$st_cdir/elsewhere/rel.dump" \
    st_call B-restore-relative-path 0 development database/restore.sh --yes rel.dump
  s="$(grep -c 'DROP DATABASE' "$st_cdir/calls" 2>/dev/null || true)"
  st_s "B-restore-relative-dropped-once" "$([[ "$s" == 1 ]] && echo 1)" "DROP DATABASE calls: ${s:-0}"
  # pg_restore is fed the backup itself (7 bytes), from the descriptor opened before the DROP.
  s="$(tr -d '[:space:]' <"$st_cdir/stdin" 2>/dev/null || true)"
  st_s "B-restore-reads-the-backup" "$([[ "$s" == 7 ]] && echo 1)" "bytes pg_restore read: ${s:-none}"
  printf 'backup\n' >"$st_cdir/elsewhere/rel.dump"
  ST_PS_DB=1 ST_RM_ON_DROP="$st_cdir/elsewhere/rel.dump" \
    st_call B-restore-plain-format 0 development database/restore.sh --yes --format plain rel.dump
  s="$(tr -d '[:space:]' <"$st_cdir/stdin" 2>/dev/null || true)"
  st_s "B-restore-plain-reads-the-backup" "$([[ "$s" == 7 ]] && echo 1)" "bytes psql read: ${s:-none}"
  ST_PS_DB=1 st_call B-restore-missing-path stop development database/restore.sh --yes nothere.dump
}

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
  st_run 18-prompt-staging 4 refuse st_c18_prompt '+no confirmation' "+'staging'"
  st_run 18-prompt-development 0 refuse st_c18_dev
  st_run 18-prompt-template 0 refuse st_c18_tmpl
  st_run above-dev-production 0 refuse st_above_prod '+^above=yes$'
  st_run above-dev-staging 0 refuse st_above_stg '+^above=yes$'
  st_run above-dev-development 0 refuse st_above_dev '+^above=no$'
  st_run above-dev-template 0 refuse st_above_tmpl '+^above=no$'
  st_run compose-name-base 0 refuse st_cn_base '+^name=proj-dev$'
  st_run compose-name-override 0 refuse st_cn_override '+^name=proj-dev-us006$'
  st_run compose-name-silent-last 0 refuse st_cn_silent '+^name=proj-dev$'
  st_run compose-name-squoted 0 refuse st_cn_squote '+^name=proj-sq$'
  st_run compose-name-nested-only 0 refuse st_cn_nested '+^name=$'
  st_run compose-name-missing 0 refuse st_cn_missing '+^name=$'

  # F-018 — both sides compared as Compose sees them.
  local f018='COMPOSE_PROJECT_NAME'
  st_run F018-raw-declared-cpn   4 refuse st_f018_raw   "+$f018" '+not a valid Compose project name'
  st_run F018-normalised-cpn     0 refuse st_f018_norm  '+^valid=1$' "+$bound_default"
  st_run F018-cpn-unset          0 refuse st_f018_unset '+^valid=1$'
  st_run F018-different-cpn      4 refuse st_f018_other "+$f018" '+project_slug-dev-us006'
  st_run F018-leading-trimmed    0 refuse st_f018_lead  '+^valid=1$'
  st_run F018-empty-normalised   4 refuse st_f018_empty  '+normalises to an empty'
  st_run F018-empty-norm-cpn     4 refuse st_f018_emptyc '+normalises to an empty'
  st_run F018-interpolated-name  4 refuse st_f018_interp '+interpolation or non-ASCII'
  st_run F018-non-ascii-name     4 refuse st_f018_kelvin '+interpolation or non-ASCII'
  st_run F018-raw-declared-cpn   0 warn   st_f018_raw   '+compose project is unverified' '+not a valid Compose project name' '+^bound=REFUSED$'
  st_run F018-empty-normalised   0 warn   st_f018_empty '+compose project is unverified' '+normalises to an empty' '+^bound=REFUSED$'

  # R-002 — key spellings and continuation lines the line reader cannot model fail closed.
  st_run R002-explicit-key      4 refuse st_c07qm    "+$repair" '+unrecognised' '+^resolved=$'
  st_run R002-tagged-key        4 refuse st_c07tag   "+$repair" '+unrecognised' '+^resolved=$'
  st_run R002-anchored-key      4 refuse st_c07anc   "+$repair" '+unrecognised' '+^resolved=$'
  st_run R002-escaped-key       4 refuse st_c07esc   "+$repair" '+unrecognised' '+^resolved=$'
  st_run R002-continuation      4 refuse st_c04cont  "+$repair" '+unrecognised' '+^resolved=$'
  st_run R002-continuation-gap  4 refuse st_c04contb "+$repair" '+unrecognised' '+^resolved=$'
  st_run R002-copier-shape      0 refuse st_c01ctx   '+^resolved=development$' '+^valid=1$'
  st_run R002-tagged-key        0 warn   st_c07tag   '+posture: unknown' '-posture: development'

  # R-001 — the env-file COMPOSE_PROJECT_NAME is compared like the shell's, the shell's first.
  st_run R001-envfile-other     4 refuse st_ef_other   "+$f018" '-someone-else' '+env-file' '+value not shown'
  st_run R001-envfile-export    4 refuse st_ef_export  '-someone-else' '+value not shown'
  st_run R001-envfile-match     0 refuse st_ef_match   '+^valid=1$' "+$bound_default"
  st_run R001-envfile-quoted    0 refuse st_ef_quoted  '+^valid=1$'
  st_run R001-shell-first       0 refuse st_ef_shell   '+^valid=1$'
  st_run R001-envfile-interp    4 refuse st_ef_interp  '+cannot be read'
  st_run R001-envfile-invalid   4 refuse st_ef_invalid '+not a valid Compose project name' '-Someone'
  st_run R001-envfile-no-key    0 refuse st_ef_none    '+^valid=1$'
  st_run R001-envfile-spaced    4 refuse st_ef_spaced  '+other than on one'
  st_run R001-envfile-colon     4 refuse st_ef_colon   '+other than on one'
  st_run R001-envfile-twice     4 refuse st_ef_twice   '+other than on one'
  st_run R001-envfile-crlf      0 refuse st_ef_crlf    '+^valid=1$'
  st_run R001-envfile-commented 4 refuse st_ef_comment '+other than on one'
  st_run R001-envfile-bom       4 refuse st_ef_bom     '+other than on one'
  st_run R001-envfile-nbsp      4 refuse st_ef_nbsp    '+other than on one'
  st_run R001-envfile-after-quote 4 refuse st_ef_after '+other than on one'
  st_run R001-envfile-in-quote  4 refuse st_ef_multi   '+more than once|other than on one'
  st_run R001-envfile-nul       4 refuse st_ef_nul     '+NUL'
  st_run R001-envfile-tab       0 refuse st_ef_tab     '+^valid=1$'
  st_run R002-copier-nel        0 refuse st_c01nel     '+^resolved=development$'
  st_run R002-copier-ls         0 refuse st_c01ls      '+^resolved=development$'
  st_run R002-nel-continuation  4 refuse st_c04nel     "+$repair" '+unrecognised'
  st_run R002-lone-cr           4 refuse st_c07cr      "+$repair" '+more than once' '+^resolved=$'
  st_run R002-nel               4 refuse st_c07nel     "+$repair" '+more than once' '+^resolved=$'
  st_run R002-line-separator    4 refuse st_c07ls      "+$repair" '+more than once' '+^resolved=$'
  st_run R002-para-separator    4 refuse st_c07ps      "+$repair" '+more than once' '+^resolved=$'
  st_run R002-crlf-carrier      0 refuse st_c01crlf    '+^resolved=development$'
  st_run R001-envfile-other     0 warn   st_ef_other   '+compose project is unverified' '-someone-else' '+^bound=REFUSED$'

  # R-003 — a project-name refusal prints the project repair; a socket refusal the socket one.
  st_run R003-project-repair    4 refuse st_14a_compose '+Unset or correct COMPOSE_PROJECT_NAME' '-Select a local unix-socket'
  st_run R003-envfile-repair    4 refuse st_ef_other    '+Unset or correct COMPOSE_PROJECT_NAME' '-Select a local unix-socket'
  st_run R003-socket-repair     4 refuse st_14a_ssh     '+Select a local unix-socket' '-Unset or correct'

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
    t=(); [[ "$m" == warn ]] && t=('+(locality|compose project) is unverified' '+^valid=$' '+^bound=REFUSED$')
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
      bash -euo pipefail -c 'source "$1"; posture_guard "$2" "$3" "$4" st-proj ""; echo REACHED' \
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

  # The callers' wiring, read as text: no caller is run, so no docker and no stack.
  log "  ── structural cases: the six callers ──"
  st_structural

  # migrate.sh --help, run for real with a Docker context selected: usage only, nothing on
  # stderr, and no Docker metadata read — the recording docker above would log any call.
  rc=0
  env DOCKER_CONTEXT=st-ghost DOCKER_CONFIG="$ST_TMP/cases" bash "$SCRIPT_DIR/migrate.sh" --help \
    >"$ST_TMP/cases/help.out" 2>"$ST_TMP/cases/help.err" || rc=$?
  st_s "help-clean-migrate" "$([[ "$rc" == 0 && ! -s "$ST_TMP/cases/help.err" ]] && echo 1)" \
    "rc $rc, stderr: $(head -c 200 "$ST_TMP/cases/help.err")"

  # The callers run for real against a fixture repository, on a recording docker (R-005).
  log "  ── behavioural cases: the six callers, run ──"
  st_behavioural

  if [[ -e "$ST_TMP/docker-calls" ]]; then
    printf '  FAIL  docker was invoked:\n'; sed 's/^/          | /' "$ST_TMP/docker-calls"
    ST_FAILS=$((ST_FAILS + 1))
  else
    log "  PASS  docker never invoked"
  fi

  if (( ST_FAILS == 0 )); then bold "✓ self-test passed"; exit 0; fi
  printf '\033[31m✗ self-test FAILED — %s failing check(s)\033[0m\n' "$ST_FAILS"; exit 1
}
