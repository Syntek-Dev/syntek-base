#!/usr/bin/env bash
#
# check-lockfiles.sh — Validate Python + JS lockfile alignment across Docker
#                      containers and local environments (including expo doctor).
# Exit 0 = pass | Exit 1 = fail
#
# Requires: PROJECT_ROOT, COMPOSE_DEV exported by orchestrator.

set -uo pipefail

export GATE_BK_PKG="/tmp/gate-bk-pkg-$$.txt"
export GATE_BK_LOCK="/tmp/gate-bk-lock-$$.txt"
export GATE_FE_PKG="/tmp/gate-fe-pkg-$$.json"
export GATE_LOCAL_PY="/tmp/gate-local-py-$$.txt"

cleanup() { rm -f "$GATE_BK_PKG" "$GATE_BK_LOCK" "$GATE_FE_PKG" "$GATE_LOCAL_PY"; }
trap cleanup EXIT

exit_code=0
out=""

out+="── Python (uv) ────────────────────────────────────────────────────\n"
local_e1=0; local_e2=0; local_e3=0
py_inst=$(docker compose -f "$COMPOSE_DEV" exec -T backend \
  uv pip list --format=freeze 2>&1) || local_e1=$?
py_exp=$(docker compose -f "$COMPOSE_DEV" exec -T backend \
  uv export --no-hashes --format=requirements-txt 2>&1) || local_e2=$?
sync_o=$(docker compose -f "$COMPOSE_DEV" exec -T backend \
  uv sync --frozen 2>&1) || local_e3=$?

if [[ $local_e1 -ne 0 ]]; then
  out+="  ERROR listing backend packages: $py_inst\n"; exit_code=1
else
  printf '%s' "$py_inst" > "$GATE_BK_PKG"
fi
if [[ $local_e2 -ne 0 ]]; then
  out+="  ERROR exporting uv lockfile: $py_exp\n"; exit_code=1
else
  printf '%s' "$py_exp" > "$GATE_BK_LOCK"
fi
if [[ $local_e3 -ne 0 ]]; then
  out+="  uv sync --frozen failed:\n$sync_o\n"; exit_code=1
fi

if [[ $local_e1 -eq 0 && $local_e2 -eq 0 ]]; then
  diff_e=0
  diff_o=$(python3 - <<'PYEOF' 2>&1) || diff_e=$?
import re, sys, os

def parse(path):
    pkgs = {}
    for line in open(path):
        line = line.strip()
        if not line or line.startswith('#') or line.startswith('-'):
            continue
        m = re.match(r'^([A-Za-z0-9_.-]+)==([^\s;]+)', line)
        if m:
            pkgs[m.group(1).lower().replace('-', '_')] = m.group(2)
    return pkgs

installed = parse(os.environ['GATE_BK_PKG'])
expected  = parse(os.environ['GATE_BK_LOCK'])
missing   = {k: v for k, v in expected.items()  if k not in installed}
extra     = {k: v for k, v in installed.items() if k not in expected}
mismatch  = {k: (installed[k], expected[k])
             for k in expected if k in installed and installed[k] != expected[k]}

if missing or extra or mismatch:
    for k, v in list(missing.items())[:10]:
        print(f'  Missing in container: {k}=={v}')
    for k, v in list(extra.items())[:10]:
        print(f'  Extra in container:   {k}=={v}')
    for k, (g, w) in list(mismatch.items())[:10]:
        print(f'  Version mismatch:     {k}  container={g}  lockfile={w}')
    print(f'  ({len(missing)+len(extra)+len(mismatch)} total discrepancies)')
    sys.exit(1)
print(f'  Python: {len(installed)} packages — container matches uv.lock')
PYEOF
  out+="$diff_o\n"
  [[ $diff_e -ne 0 ]] && exit_code=1
fi

out+="\n── Python local .venv ─────────────────────────────────────────────\n"
if [[ -d "$PROJECT_ROOT/.venv" ]]; then
  lsync_e=0
  lsync_o=$(uv sync --frozen --project "$PROJECT_ROOT" 2>&1) || lsync_e=$?
  if [[ $lsync_e -ne 0 ]]; then
    out+="  Local .venv out of sync with uv.lock:\n$(printf '%s' "$lsync_o" | head -10)\n"
    exit_code=1
  else
    lvenv_e=0
    lvenv_o=$("$PROJECT_ROOT/.venv/bin/python" -m pip list --format=freeze 2>&1) || lvenv_e=$?
    if [[ $lvenv_e -eq 0 && -f "$GATE_BK_PKG" ]]; then
      printf '%s' "$lvenv_o" > "$GATE_LOCAL_PY"
      ldiff_e=0
      ldiff_o=$(python3 - <<'PYEOF' 2>&1) || ldiff_e=$?
import re, sys, os

def parse(path):
    pkgs = {}
    for line in open(path):
        line = line.strip()
        if not line or line.startswith('#') or line.startswith('-'):
            continue
        m = re.match(r'^([A-Za-z0-9_.-]+)==([^\s;]+)', line)
        if m:
            pkgs[m.group(1).lower().replace('-', '_')] = m.group(2)
    return pkgs

local_pkgs     = parse(os.environ['GATE_LOCAL_PY'])
container_pkgs = parse(os.environ['GATE_BK_PKG'])
mismatch   = {k: (local_pkgs[k], container_pkgs[k])
              for k in local_pkgs if k in container_pkgs and local_pkgs[k] != container_pkgs[k]}
only_local = {k: v for k, v in local_pkgs.items()     if k not in container_pkgs}
only_cont  = {k: v for k, v in container_pkgs.items() if k not in local_pkgs}

if mismatch or only_local or only_cont:
    for k, (lv, cv) in list(mismatch.items())[:10]:
        print(f'  Version drift:  {k}  local={lv}  container={cv}')
    for k, v in list(only_local.items())[:5]:
        print(f'  Local only:     {k}=={v}')
    for k, v in list(only_cont.items())[:5]:
        print(f'  Container only: {k}=={v}')
    sys.exit(1)
print(f'  Local .venv matches container — {len(local_pkgs)} packages in sync')
PYEOF
      out+="$ldiff_o\n"
      [[ $ldiff_e -ne 0 ]] && exit_code=1
    else
      out+="  Local .venv matches uv.lock\n"
    fi
  fi
else
  out+="  No local .venv found — skipping (run: uv sync to create)\n"
fi

out+="\n── JS/TS frontend (pnpm) ──────────────────────────────────────────\n"
pls_e=0; pf_e=0
pls_o=$(docker compose -f "$COMPOSE_DEV" exec -T frontend \
  pnpm ls --json --depth=0 2>&1) || pls_e=$?
[[ $pls_e -eq 0 ]] && printf '%s' "$pls_o" > "$GATE_FE_PKG"

pf_o=$(docker compose -f "$COMPOSE_DEV" exec -T frontend \
  pnpm install --frozen-lockfile 2>&1) || pf_e=$?
if [[ $pf_e -ne 0 ]]; then
  out+="  pnpm install --frozen-lockfile failed (frontend):\n$(printf '%s' "$pf_o" | head -20)\n"
  exit_code=1
else
  pkg_count=0
  [[ -f "$GATE_FE_PKG" ]] && \
    pkg_count=$(python3 -c "
import json, os
raw=json.loads(open(os.environ['GATE_FE_PKG']).read())
items=raw if isinstance(raw,list) else [raw]
print(sum(len(p.get('dependencies',{}))+len(p.get('devDependencies',{})) for p in items))
" 2>/dev/null || echo "?")
  out+="  frontend: ${pkg_count} packages — container matches pnpm-lock.yaml\n"
fi

out+="\n── JS/TS local — all workspaces (pnpm) ────────────────────────────\n"
if [[ -d "$PROJECT_ROOT/node_modules" ]]; then
  lpnpm_e=0
  lpnpm_o=$(cd "$PROJECT_ROOT" && pnpm install --frozen-lockfile 2>&1) || lpnpm_e=$?
  if [[ $lpnpm_e -ne 0 ]]; then
    out+="  pnpm install --frozen-lockfile failed (local):\n$(printf '%s' "$lpnpm_o" | head -20)\n"
    exit_code=1
  else
    out+="  Local node_modules (frontend + mobile + shared) match pnpm-lock.yaml\n"
  fi
else
  out+="  No local node_modules found — skipping (run: pnpm install to create)\n"
fi

out+="\n── Mobile — Expo/Go local setup ───────────────────────────────────\n"
mob_dir="$PROJECT_ROOT/code/src/mobile"
expo_bin=""
if [[ -f "$mob_dir/node_modules/.bin/expo" ]]; then
  expo_bin="$mob_dir/node_modules/.bin/expo"
elif [[ -f "$PROJECT_ROOT/node_modules/.bin/expo" ]]; then
  expo_bin="$PROJECT_ROOT/node_modules/.bin/expo"
fi

if [[ -n "$expo_bin" ]]; then
  expo_e=0
  expo_o=$(cd "$mob_dir" && "$expo_bin" doctor --non-interactive 2>&1) || expo_e=$?
  if [[ $expo_e -ne 0 ]]; then
    out+="  expo doctor issues (fix before shipping):\n$(printf '%s' "$expo_o" | head -15)\n"
    exit_code=1
  else
    out+="  expo doctor: OK\n"
  fi
else
  out+="  expo CLI not found in node_modules — skipping expo doctor\n"
  out+="  (run: pnpm install to populate node_modules)\n"
fi

printf '%b' "$out"

if [[ $exit_code -eq 0 ]]; then
  printf '#SUMMARY:Python + JS packages match lockfiles (local and container)\n'
else
  msg=$(printf '%b' "$out" | grep -E '(Missing|Extra|Mismatch|failed|ERROR|drift)' | head -3 | tr '\n' '; ')
  printf '#SUMMARY:%s\n' "${msg:-Lockfile drift detected}"
  exit 1
fi
