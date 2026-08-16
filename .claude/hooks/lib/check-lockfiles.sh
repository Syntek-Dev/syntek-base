# check-lockfiles.sh — lockfile alignment: Docker container vs lockfile + local env drift.
# Sourced by the pre-PR gate runner, never executed directly.
# Uses: PROJECT_ROOT, DEV_COMPOSE, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT

_check_lockfiles() {
  local out="" exit_code=0

  # ── Docker Python (uv) ─────────────────────────────────────────────────────
  out+="── Docker Python (uv) ─────────────────────────────────────────────\n"
  local py_inst py_exp sync_o
  local e1=0 e2=0 e3=0

  py_inst=$(_dc exec -T django \
    uv pip list --format=freeze 2>&1) || e1=$?
  py_exp=$(_dc exec -T django \
    uv export --no-hashes --format=requirements-txt 2>&1) || e2=$?
  sync_o=$(_dc exec -T django \
    uv sync --frozen 2>&1) || e3=$?

  [[ $e1 -ne 0 ]] && { out+="  ERROR listing backend packages: $py_inst\n"; exit_code=1; } \
    || printf '%s' "$py_inst" > /tmp/gate-backend-installed.txt
  [[ $e2 -ne 0 ]] && { out+="  ERROR exporting uv lockfile: $py_exp\n"; exit_code=1; } \
    || printf '%s' "$py_exp" > /tmp/gate-backend-lockfile.txt
  [[ $e3 -ne 0 ]] && { out+="  uv sync --frozen failed:\n$(printf '%s' "$sync_o" | head -10)\n"; exit_code=1; }

  if [[ $e1 -eq 0 && $e2 -eq 0 ]]; then
    local diff_o diff_e=0
    diff_o=$(python3 - <<'PYEOF' 2>&1) || diff_e=$?
import re, sys

# Tools not tracked as project dependencies
_TOOLS = {'pip', 'uv', 'setuptools', 'wheel', 'distribute'}

def parse(path):
    pkgs = {}
    for line in open(path):
        line = line.strip()
        if not line or line.startswith('#') or line.startswith('-'):
            continue
        # Skip platform-specific packages that don't apply here
        if "sys_platform == 'win32'" in line and sys.platform != 'win32':
            continue
        m = re.match(r'^([A-Za-z0-9_.-]+)==([^\s;]+)', line)
        if m:
            name = re.sub(r'[-_.]+', '_', m.group(1).lower())
            if name not in _TOOLS:
                pkgs[name] = m.group(2)
    return pkgs

installed = parse('/tmp/gate-backend-installed.txt')
expected  = parse('/tmp/gate-backend-lockfile.txt')
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

  # ── Local Python (.venv) ───────────────────────────────────────────────────
  out+="\n── Local Python (.venv) ───────────────────────────────────────────\n"
  local venv_dir=""
  [[ -d "$PROJECT_ROOT/code/src/django/.venv" ]] && venv_dir="$PROJECT_ROOT/code/src/django/.venv"
  [[ -z "$venv_dir" && -d "$PROJECT_ROOT/.venv" ]] && venv_dir="$PROJECT_ROOT/.venv"

  if [[ -n "$venv_dir" ]]; then
    local lsync_o lsync_e=0
    lsync_o=$(uv sync --frozen --project "$PROJECT_ROOT/code/src/django" 2>&1) || lsync_e=$?
    if [[ $lsync_e -ne 0 ]]; then
      out+="  Local .venv out of sync with uv.lock:\n$(printf '%s' "$lsync_o" | head -10)\n"
      exit_code=1
    else
      local lvenv_o lvenv_e=0
      lvenv_o=$("$venv_dir/bin/python" -m pip list --format=freeze 2>&1) || lvenv_e=$?
      if [[ $lvenv_e -eq 0 && -f /tmp/gate-backend-installed.txt ]]; then
        printf '%s' "$lvenv_o" > /tmp/gate-local-python.txt
        local ldiff_o ldiff_e=0
        ldiff_o=$(python3 - <<'PYEOF' 2>&1) || ldiff_e=$?
import re, sys

_TOOLS = {'pip', 'uv', 'setuptools', 'wheel', 'distribute'}

def parse(path):
    pkgs = {}
    for line in open(path):
        line = line.strip()
        if not line or line.startswith('#') or line.startswith('-'):
            continue
        if "sys_platform == 'win32'" in line and sys.platform != 'win32':
            continue
        m = re.match(r'^([A-Za-z0-9_.-]+)==([^\s;]+)', line)
        if m:
            name = re.sub(r'[-_.]+', '_', m.group(1).lower())
            if name not in _TOOLS:
                pkgs[name] = m.group(2)
    return pkgs

local_pkgs     = parse('/tmp/gate-local-python.txt')
container_pkgs = parse('/tmp/gate-backend-installed.txt')
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
    out+="  No local .venv found — skipping (run: bash code/src/scripts/development/install-backend.sh --sync)\n"
  fi

  # ── JS tooling (pnpm) — host-only; the django image carries no Node ────────
  out+="\n── JS tooling (pnpm, host) ────────────────────────────────────────\n"
  if [[ -d "$PROJECT_ROOT/node_modules" ]]; then
    local lpnpm_o lpnpm_e=0
    lpnpm_o=$(cd "$PROJECT_ROOT" && pnpm install --frozen-lockfile 2>&1) || lpnpm_e=$?
    if [[ $lpnpm_e -ne 0 ]]; then
      out+="  pnpm install --frozen-lockfile failed:\n$(printf '%s' "$lpnpm_o" | head -20)\n"
      exit_code=1
    else
      out+="  node_modules match pnpm-lock.yaml\n"
    fi
  else
    out+="  No node_modules found — skipping (run: pnpm install)\n"
  fi

  CHECK_OUTPUT["lockfiles"]="$out"
  if [[ $exit_code -eq 0 ]]; then
    CHECK_PASS["lockfiles"]="true"
    CHECK_SUMMARY["lockfiles"]="Python + JS packages match lockfiles (local ✓ container ✓)"
  else
    CHECK_PASS["lockfiles"]="false"
    local msg
    msg=$(printf '%s' "$out" \
      | grep -iE '(mismatch|drift|failed|discrepanc|missing|out of sync)' \
      | head -3 | tr '\n' '; ')
    CHECK_SUMMARY["lockfiles"]="${msg:-Lockfile drift detected}"
  fi
}
