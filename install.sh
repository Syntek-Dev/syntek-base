#!/usr/bin/env bash
#
# install.sh — Bootstrap the <%PROJECT_SLUG%> development environment.
#
# Installs all Python and JavaScript dependencies, copies missing .env.*
# files from their examples, auto-generates dev secrets, and marks every
# project script executable.
#
# Usage:
#   bash install.sh           Phase 1 only (deps, env files, permissions)
#   bash install.sh --full    Phase 1 + Phase 2 (Docker build, migrate)
#   bash install.sh --spec    Only (re)generate code/docs/MACHINE-SPEC.md, then exit
#   bash install.sh --help    Show this help
#
# Requirements: docker, docker compose v2, git, uv >= 0.11, pnpm >= 11, openssl
#
# Exit codes:  0 = success   1 = requirement missing   2 = install failed
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
COMPOSE_DEV="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_DIR="$PROJECT_ROOT/code/src/docker"
SPEC_FILE="$PROJECT_ROOT/code/docs/MACHINE-SPEC.md"

# ── Helpers ───────────────────────────────────────────────────────────────────
bold()    { printf '\033[1m%s\033[0m\n' "$*"; }
log()     { printf '  %s\n' "$*"; }
ok()      { printf '  \033[32m✓\033[0m  %s\n' "$*"; }
warn()    { printf '  \033[33m⚠\033[0m  %s\n' "$*" >&2; }
err()     { printf '\033[31merror:\033[0m %s\n' "$*" >&2; }
die()     { err "$*"; exit 1; }
section() { printf '\n'; bold "── $* "; printf '\n'; }

usage() {
  cat <<'EOF'
install.sh — Bootstrap the <%PROJECT_SLUG%> development environment

Usage:
  bash install.sh           Phase 1: deps, env files, permissions
  bash install.sh --full    Phase 1 + Phase 2: Docker build, migrations
  bash install.sh --spec    Only (re)generate code/docs/MACHINE-SPEC.md, then exit
  bash install.sh --help    Show this help

Phase 1 (always):
  1. Check prerequisites
  2. Add dev.<%PROJECT_SLUG%>.localhost to /etc/hosts (idempotent, requires sudo)
  3. Install Python dependencies  (install-backend.sh --sync)
  4. Install JavaScript dependencies  (install-frontend.sh --local)
  5. Copy .env.*.example → .env.* for each environment (skips existing)
  6. Auto-generate dev secrets in .env.dev  (SECRET_KEY, ENCRYPTION_KEY, LEGAL_FIELD_HMAC_KEY, MFA_FIELD_KEY, POSTGRES_PASSWORD)
  7. Mark install.sh + all code/src/scripts/**/*.sh executable
  8. Generate a gitignored host profile  (code/docs/MACHINE-SPEC.md)

Phase 2 (--full only):
  7. Build and start Docker dev stack
  8. Apply database migrations

Requirements: docker, docker compose v2, git, uv >= 0.11, pnpm >= 11, openssl

Exit codes:  0 = success   1 = requirement missing   2 = install failed
EOF
}

# ── Machine spec generator (cross-platform: Linux / macOS / Windows) ───────────
# Writes a gitignored hardware profile to code/docs/MACHINE-SPEC.md so each dev
# (and Claude, when sizing worktree/Docker concurrency) can read the host's real
# limits. Best-effort — every probe is guarded; unknown fields render as "unknown".
# Windows is detected via a Git-Bash/MSYS uname and probed through PowerShell;
# macOS via sysctl/system_profiler; Linux via lscpu/free/lspci/df.
generate_machine_spec() {
  local ts uname_s os_name kernel cpu_model cpu_cores cpu_threads
  local mem_total mem_avail mem_gib mem_avail_gib gpu docker_root disk_table ps
  ts="$(date -u '+%Y-%m-%d %H:%M:%SZ' 2>/dev/null || echo unknown)"
  uname_s="$(uname -s 2>/dev/null || echo unknown)"
  mem_gib=""

  case "$uname_s" in
    Linux)
      if [[ -r /etc/os-release ]]; then
        os_name="$(. /etc/os-release && printf '%s' "${PRETTY_NAME:-Linux}")"
      else
        os_name="Linux"
      fi
      grep -qi microsoft /proc/version 2>/dev/null && os_name="$os_name (WSL)"
      kernel="$(uname -r 2>/dev/null)"
      cpu_model="$(lscpu 2>/dev/null | sed -n 's/^Model name:[[:space:]]*//p' | head -1)"
      cpu_cores="$(lscpu 2>/dev/null | sed -n 's/^Core(s) per socket:[[:space:]]*//p' | head -1)"
      cpu_threads="$(nproc 2>/dev/null)"
      mem_total="$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')"
      mem_avail="$(free -h 2>/dev/null | awk '/^Mem:/{print $7}')"
      mem_gib="$(free -g 2>/dev/null | awk '/^Mem:/{print $2}')"
      mem_avail_gib="$(free -g 2>/dev/null | awk '/^Mem:/{print $7}')"
      gpu="$(lspci 2>/dev/null | grep -Ei 'vga|3d|display' | sed 's/^[0-9a-f:.]* [^:]*: //' | paste -sd '; ' -)"
      [[ -z "$gpu" ]] && command -v nvidia-smi >/dev/null 2>&1 \
        && gpu="$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | paste -sd '; ' -)"
      docker_root="$(docker info --format '{{.DockerRootDir}}' 2>/dev/null || true)"
      disk_table="$(df -h 2>/dev/null | grep -vE 'tmpfs|loop|udev|devtmpfs')"
      ;;
    Darwin)
      os_name="macOS $(sw_vers -productVersion 2>/dev/null)"
      kernel="$(uname -r 2>/dev/null)"
      cpu_model="$(sysctl -n machdep.cpu.brand_string 2>/dev/null)"
      cpu_cores="$(sysctl -n hw.physicalcpu 2>/dev/null)"
      cpu_threads="$(sysctl -n hw.logicalcpu 2>/dev/null)"
      local mem_bytes; mem_bytes="$(sysctl -n hw.memsize 2>/dev/null)"
      [[ "$mem_bytes" =~ ^[0-9]+$ ]] && { mem_gib=$(( mem_bytes / 1073741824 )); mem_total="${mem_gib} GiB"; }
      mem_avail="see Activity Monitor"
      gpu="$(system_profiler SPDisplaysDataType 2>/dev/null | awk -F': ' '/Chipset Model/{print $2}' | paste -sd '; ' -)"
      docker_root="$(docker info --format '{{.DockerRootDir}}' 2>/dev/null || true)"
      disk_table="$(df -h 2>/dev/null | grep -vE 'devfs|map ')"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      ps="powershell.exe -NoProfile -NonInteractive -Command"
      os_name="$($ps "(Get-CimInstance Win32_OperatingSystem).Caption" 2>/dev/null | tr -d '\r')"
      kernel="$($ps "(Get-CimInstance Win32_OperatingSystem).Version" 2>/dev/null | tr -d '\r')"
      cpu_model="$($ps "(Get-CimInstance Win32_Processor).Name" 2>/dev/null | tr -d '\r')"
      cpu_cores="$($ps "(Get-CimInstance Win32_Processor | Measure-Object NumberOfCores -Sum).Sum" 2>/dev/null | tr -d '\r')"
      cpu_threads="$($ps "(Get-CimInstance Win32_Processor | Measure-Object NumberOfLogicalProcessors -Sum).Sum" 2>/dev/null | tr -d '\r')"
      mem_gib="$($ps "[math]::Floor((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB)" 2>/dev/null | tr -d '\r')"
      [[ "$mem_gib" =~ ^[0-9]+$ ]] && mem_total="${mem_gib} GiB"
      mem_avail="$($ps "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1MB,1)" 2>/dev/null | tr -d '\r') GiB free"
      mem_avail_gib="$($ps "[math]::Floor((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1MB)" 2>/dev/null | tr -d '\r')"
      gpu="$($ps "(Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name) -join '; '" 2>/dev/null | tr -d '\r')"
      docker_root="$(docker info --format '{{.DockerRootDir}}' 2>/dev/null | tr -d '\r' || true)"
      disk_table="$($ps "Get-CimInstance Win32_LogicalDisk | Format-Table DeviceID,@{n='Size(GB)';e={[math]::Round(\$_.Size/1GB)}},@{n='Free(GB)';e={[math]::Round(\$_.FreeSpace/1GB)}} -AutoSize | Out-String" 2>/dev/null | tr -d '\r')"
      ;;
    *)
      os_name="$uname_s"; kernel="$(uname -r 2>/dev/null || true)"
      cpu_model="unknown"; cpu_threads="$(getconf _NPROCESSORS_ONLN 2>/dev/null || true)"
      ;;
  esac

  : "${os_name:=unknown}";   : "${kernel:=unknown}";   : "${cpu_model:=unknown}"
  : "${cpu_cores:=unknown}"; : "${cpu_threads:=unknown}"; : "${mem_total:=unknown}"
  : "${mem_avail:=unknown}"; : "${gpu:=n/a}";           : "${docker_root:=unknown}"
  : "${disk_table:=unavailable}"

  # Concurrency heuristics (~3 GiB per dev stack):
  #   practical now   = (available_GiB − 2) ÷ 3   — reflects current host load
  #   theoretical max = (total_GiB − 6) ÷ 3        — idle host, reserve 6 for host + IDE
  local practical theoretical
  if [[ "$mem_avail_gib" =~ ^[0-9]+$ ]] && (( mem_avail_gib > 2 )); then
    practical=$(( (mem_avail_gib - 2) / 3 )); (( practical < 1 )) && practical=1
  else
    practical="?"
  fi
  if [[ "$mem_gib" =~ ^[0-9]+$ ]] && (( mem_gib > 0 )); then
    theoretical=$(( (mem_gib - 6) / 3 )); (( theoretical < 1 )) && theoretical=1
  else
    theoretical="?"
  fi

  mkdir -p "$(dirname "$SPEC_FILE")"
  {
    # The slug is an ARGUMENT, never part of the format string. `<%PROJECT_SLUG%>` contains
    # `%P`, which printf reads as a format specifier and rejects — "invalid format character"
    # — killing this generator on every base-template run. `%%` escaping is the other fix and
    # is wrong here, because this file IS rendered by Copier and `<%%…%%>` is not the token.
    printf '# Machine Specification — %s\n\n' '<%PROJECT_SLUG%>'
    printf '> ⚠ Auto-generated by `install.sh` — **gitignored, do not commit**. '
    printf 'Regenerate with `bash install.sh --spec`.\n\n'
    printf '_Generated %s (UTC) · detected platform: `%s`_\n\n' "$ts" "$uname_s"
    printf 'Sizes worktree + Docker concurrency to this host. Pair with the capacity policy in the\n'
    printf 'Wave-3 plan: host **RAM** caps live dev stacks; the **Anthropic API rate limit** caps\n'
    printf 'concurrent Opus authoring agents — the two are independent throttles.\n\n'
    printf '## Hardware\n\n'
    printf '| Component | Value |\n| --------- | ----- |\n'
    printf '| OS | %s |\n' "$os_name"
    printf '| Kernel / version | %s |\n' "$kernel"
    printf '| CPU | %s |\n' "$cpu_model"
    printf '| Cores / threads | %s / %s |\n' "$cpu_cores" "$cpu_threads"
    printf '| RAM total | %s |\n' "$mem_total"
    printf '| RAM available (at generation) | %s |\n' "$mem_avail"
    printf '| GPU | %s |\n' "$gpu"
    printf '| Docker root dir | %s |\n\n' "$docker_root"
    printf '## Disk\n\n```text\n%s\n```\n\n' "$disk_table"
    printf '## Suggested concurrency\n\n'
    printf '%s\n' "- **Practical now (current headroom):** ~${practical} dev stacks  _((avail_GiB − 2) ÷ 3)_"
    printf '%s\n' "- **Theoretical max (idle host):** ~${theoretical} dev stacks  _((total_GiB − 6) ÷ 3)_"
    printf '%s\n' '- Mix **≤ 1 frontend-heavy + rest backend-trim**; bring stacks `down` between validation batches.'
    printf '%s\n' '- Worktrees on disk are cheap; the bottleneck is RAM for *running* stacks, not CPU or disk.'
    printf '%s\n' '- Independently, throttle Opus authoring agents to ~4–6 concurrent to stay under API limits.'
  } > "$SPEC_FILE"
}

# ── Args ──────────────────────────────────────────────────────────────────────
FULL=false
SPEC_ONLY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --full)     FULL=true;  shift ;;
    --spec)     SPEC_ONLY=true; shift ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

# ── --spec short-circuit — regenerate the host profile and exit ────────────────
if [[ "$SPEC_ONLY" == "true" ]]; then
  bold "▸ install.sh --spec — host profile"
  log ""
  generate_machine_spec
  ok "Wrote $SPEC_FILE (gitignored)"
  exit 0
fi

# ── Banner ────────────────────────────────────────────────────────────────────
bold "▸ install.sh — <%PROJECT_SLUG%>"
log ""
if [[ "$FULL" == "true" ]]; then
  log "Mode: full bootstrap (Phase 1 + Phase 2)"
else
  log "Mode: host setup (Phase 1 only)  — use --full to also build Docker"
fi
log ""

# ── Phase 1 · Step 1a — Host platform and container runtime ───────────────────
# The whole stack runs in containers, so the runtime is the one prerequisite worth
# diagnosing properly rather than just reporting "docker not found". Each platform
# has a different sanctioned runtime, and a different failure mode when it is absent.
section "Host platform"
log ""

IS_WSL=0
if [[ -r /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
  IS_WSL=1
fi

case "$(uname -s)" in
  Linux)
    if [[ "$IS_WSL" == "1" ]]; then
      HOST_OS="wsl"
    else
      HOST_OS="linux"
    fi
    ;;
  Darwin)               HOST_OS="macos" ;;
  MINGW* | MSYS* | CYGWIN*) HOST_OS="windows" ;;
  *)                    HOST_OS="unknown" ;;
esac

case "$HOST_OS" in
  linux)   ok "platform    Linux ($(uname -r))" ;;
  wsl)     ok "platform    WSL ($(uname -r))" ;;
  macos)   ok "platform    macOS $(sw_vers -productVersion 2>/dev/null || uname -r) ($(uname -m))" ;;
  windows) ok "platform    Windows (native shell)" ;;
  unknown) warn "platform    unrecognised ($(uname -s)) — proceeding, but you are off the tested path" ;;
esac

# Windows is only supported through WSL 2. A native Git Bash / MSYS shell cannot reach
# a Linux container runtime, and bind mounts across the Windows filesystem boundary are
# too slow to develop against even when it can.
if [[ "$HOST_OS" == "windows" ]]; then
  err "Windows is supported through WSL 2 only — not Git Bash, MSYS or PowerShell."
  err ""
  err "  1. Install WSL 2:        wsl --install"
  err "  2. Install Docker Desktop and enable its WSL 2 backend"
  err "  3. Clone this repository INSIDE the WSL filesystem (~/projects/...), not /mnt/c"
  err "  4. Re-run this script from the WSL shell"
  die "unsupported shell for Windows hosts"
fi

# WSL 1 cannot run the container runtime this stack needs.
if [[ "$HOST_OS" == "wsl" ]] && ! uname -r | grep -qi 'wsl2'; then
  warn "This looks like WSL 1. Docker requires WSL 2."
  warn "  Convert with:  wsl --set-version <distro> 2   (from PowerShell)"
fi

# Working inside /mnt/c is the single most common cause of an unusably slow dev loop.
if [[ "$HOST_OS" == "wsl" && "$PROJECT_ROOT" == /mnt/[a-z]/* ]]; then
  warn "This repository lives on the Windows filesystem ($PROJECT_ROOT)."
  warn "  Bind-mount I/O across that boundary is very slow. Move it into the WSL"
  warn "  filesystem (e.g. ~/projects/) for a usable development loop."
fi

# ── Container runtime ─────────────────────────────────────────────────────────
section "Container runtime"
log ""

RUNTIME="none"
if command -v docker >/dev/null 2>&1; then
  RUNTIME="docker"
fi

# macOS has two sanctioned runtimes: Docker Desktop and Colima. Colima ships the same
# docker CLI, so detect it by the active context rather than by the binary.
COLIMA_PRESENT=0
if command -v colima >/dev/null 2>&1; then
  COLIMA_PRESENT=1
fi

if [[ "$RUNTIME" == "none" ]]; then
  case "$HOST_OS" in
    macos)
      err "No container runtime found. On macOS install either:"
      err "  Docker Desktop   https://docs.docker.com/desktop/install/mac-install/"
      err "  Colima (no GUI)  brew install colima docker docker-compose && colima start"
      ;;
    wsl)
      err "No container runtime found in this WSL distribution."
      err "  Install Docker Desktop on Windows and enable the WSL 2 integration for"
      err "  this distro (Settings → Resources → WSL Integration), or install Docker"
      err "  Engine directly inside WSL: https://docs.docker.com/engine/install/"
      ;;
    *)
      err "No container runtime found."
      err "  Install Docker Engine: https://docs.docker.com/engine/install/"
      ;;
  esac
  die "a container runtime is required — everything in this stack runs in containers"
fi

# The CLI existing does not mean the daemon is reachable. This is the check that
# actually predicts whether the dev stack will start.
if ! docker info >/dev/null 2>&1; then
  err "The docker CLI is installed but the daemon is not reachable."
  case "$HOST_OS" in
    macos)
      if [[ "$COLIMA_PRESENT" == "1" ]]; then
        err "  Colima is installed — start it with:  colima start"
      else
        err "  Start Docker Desktop, or install Colima:  brew install colima && colima start"
      fi
      ;;
    wsl)
      err "  Start Docker Desktop on Windows and enable WSL integration for this distro,"
      err "  or start the in-WSL daemon:  sudo service docker start"
      ;;
    linux)
      err "  Start it:            sudo systemctl start docker"
      err "  Run without sudo:    sudo usermod -aG docker \"\$USER\"   (then log out and back in)"
      ;;
  esac
  die "container runtime not running"
fi

DOCKER_CONTEXT="$(docker context show 2>/dev/null || echo default)"
if [[ "$HOST_OS" == "macos" ]]; then
  if [[ "$DOCKER_CONTEXT" == *colima* ]] || { [[ "$COLIMA_PRESENT" == "1" ]] && colima status >/dev/null 2>&1; }; then
    ok "runtime     Colima (context: $DOCKER_CONTEXT)"
  else
    ok "runtime     Docker Desktop (context: $DOCKER_CONTEXT)"
  fi
elif [[ "$HOST_OS" == "wsl" ]]; then
  ok "runtime     Docker via WSL 2 (context: $DOCKER_CONTEXT)"
else
  ok "runtime     Docker Engine (context: $DOCKER_CONTEXT)"
fi

# On Linux, needing sudo for docker breaks several project scripts.
if [[ "$HOST_OS" == "linux" ]] && ! id -nG "$USER" 2>/dev/null | tr ' ' '\n' | grep -qx docker; then
  warn "$USER is not in the 'docker' group. Several project scripts assume rootless invocation."
  warn "  sudo usermod -aG docker \"\$USER\"    (then log out and back in)"
fi

# ── Phase 1 · Step 1b — Prerequisite checks ───────────────────────────────────
section "Prerequisite checks"
log ""

check_cmd() {
  local cmd="$1" hint="$2"
  command -v "$cmd" >/dev/null 2>&1 \
    || die "'$cmd' not found. $hint"
}

check_cmd git    "Install from https://git-scm.com/"
check_cmd openssl "Install via your system package manager (e.g. sudo apt install openssl)"
check_cmd uv    "Install from https://docs.astral.sh/uv/getting-started/installation/"
check_cmd pnpm  "Install from https://pnpm.io/installation"

docker compose version >/dev/null 2>&1 \
  || die "'docker compose' (v2 plugin) not found. Upgrade Docker to 24+ or install the Compose plugin."

UV_VER=$(uv --version 2>&1 | awk '{print $2}')
PNPM_VER=$(pnpm --version 2>&1)
DOCKER_VER=$(docker --version 2>&1 | awk '{print $3}' | tr -d ',')

ok "git         $(git --version | awk '{print $3}')"
ok "docker      $DOCKER_VER"
ok "docker compose $(docker compose version --short 2>/dev/null || echo 'ok')"
ok "openssl     $(openssl version | awk '{print $2}')"
ok "uv          $UV_VER"
ok "pnpm        $PNPM_VER"

# ── Phase 1 · Step 2 — /etc/hosts entries ────────────────────────────────────
section "/etc/hosts — main worktree hostnames"
log ""

# dev (:81) and test (:83) are the two stacks that publish a host port. No Storybook —
# there is no client-side build in this stack.
HOSTS_ENTRY="127.0.0.1 dev.<%PROJECT_SLUG%>.localhost test.<%PROJECT_SLUG%>.localhost"
if grep -qF "dev.<%PROJECT_SLUG%>.localhost" /etc/hosts; then
  log "skipped  /etc/hosts entry (already exists)"
else
  if echo "$HOSTS_ENTRY" | sudo tee -a /etc/hosts > /dev/null; then
    ok "Added: $HOSTS_ENTRY"
  else
    warn "Could not write to /etc/hosts — add the following line manually:"
    warn "  $HOSTS_ENTRY"
  fi
fi

# ── Phase 1 · Step 3 — Python dependencies ────────────────────────────────────
section "Python dependencies (uv sync)"
log ""

cd "$PROJECT_ROOT"
bash "$PROJECT_ROOT/code/src/scripts/development/install-backend.sh" --sync || { err "uv sync failed"; exit 2; }
log ""
ok "Python dependencies installed (.venv)"

# ── Phase 1 · Step 4 — JavaScript dependencies ────────────────────────────────
section "JavaScript dependencies (pnpm install)"
log ""

bash "$PROJECT_ROOT/code/src/scripts/development/install-frontend.sh" --local || { err "pnpm install failed"; exit 2; }
log ""
ok "JavaScript dependencies installed (node_modules, pnpm-lock.yaml up to date)"

# ── Phase 1 · Step 5 — Environment files ──────────────────────────────────────
section "Environment files"
log ""

COPIED=()
SKIPPED=()

for example in "$ENV_DIR"/.env.*.example; do
  [[ -f "$example" ]] || continue
  target="${example%.example}"
  if [[ ! -f "$target" ]]; then
    cp "$example" "$target"
    COPIED+=("$(basename "$target")")
  else
    SKIPPED+=("$(basename "$target")")
  fi
done

for f in "${COPIED[@]+"${COPIED[@]}"}";   do ok "created  code/src/docker/$f"; done
for f in "${SKIPPED[@]+"${SKIPPED[@]}"}"; do log "skipped  code/src/docker/$f  (already exists)"; done

# ── Phase 1 · Step 6 — Auto-generate dev secrets ──────────────────────────────
section "Dev secrets (.env.dev)"
log ""

ENV_DEV="$ENV_DIR/.env.dev"

if [[ -f "$ENV_DEV" ]]; then
  gen_secret()  { openssl rand -base64 50 | tr -d '\n=' ; }
  gen_fernet()  { openssl rand -base64 32 | tr '+/' '-_'; }
  gen_password(){ openssl rand -base64 24 | tr -d '\n=+/'; }

  changed=0

  replace_if_placeholder() {
    local key="$1" value="$2"
    if grep -qE "^${key}=change_me$" "$ENV_DEV"; then
      sed -i "s|^${key}=change_me$|${key}=${value}|" "$ENV_DEV"
      ok "generated $key"
      changed=1
    else
      log "kept      $key  (already set)"
    fi
  }

  replace_if_placeholder SECRET_KEY        "$(gen_secret)"
  replace_if_placeholder ENCRYPTION_KEY   "$(gen_fernet)"
  replace_if_placeholder LEGAL_FIELD_HMAC_KEY "$(openssl rand -hex 32)"
  replace_if_placeholder MFA_FIELD_KEY    "$(gen_fernet)"
  replace_if_placeholder POSTGRES_PASSWORD "$(gen_password)"

  if [[ "$changed" -eq 0 ]]; then
    log "(all secrets already populated — nothing changed)"
  fi

  # Warn if any other change_me values remain
  remaining=$(grep -c '=change_me$' "$ENV_DEV" || true)
  if [[ "$remaining" -gt 0 ]]; then
    warn "$remaining value(s) in .env.dev still set to 'change_me' — review before starting."
  fi
else
  warn ".env.dev not found — skipping secret generation."
fi

# Warn about prod/staging env files that still contain change_me
for env_file in "$ENV_DIR"/.env.prod "$ENV_DIR"/.env.staging; do
  [[ -f "$env_file" ]] || continue
  count=$(grep -c '=change_me$' "$env_file" || true)
  if [[ "$count" -gt 0 ]]; then
    warn "$(basename "$env_file") has $count value(s) still set to 'change_me' — must be set before deploying."
  fi
done

# ── Phase 1 · Step 7 — Script permissions ─────────────────────────────────────
section "Script permissions (chmod +x)"
log ""

chmod +x "$PROJECT_ROOT/install.sh"

# The underscore prefix is the convention for a SOURCED helper — `_lib/*.sh` and each
# surface's `_common.sh` all say "source it, never call it" in their own headers. An
# executable bit invites exactly the direct call the contract forbids: `_common.sh` run
# rather than sourced sets `-euo pipefail`, cds elsewhere and exits having done nothing
# visible. Marking them +x also dirtied a fresh clone the moment install.sh ran, because
# the mode is tracked — files flipped 100644 -> 100755 before any work had been done.
find "$PROJECT_ROOT/code/src/scripts" -name "*.sh" \
  -not -path "*/_lib/*" -not -name "_*.sh" -exec chmod +x {} \;

SCRIPT_COUNT=$(find "$PROJECT_ROOT/code/src/scripts" -name "*.sh" | wc -l | tr -d ' ')
ok "$SCRIPT_COUNT scripts in code/src/scripts/ marked executable"
ok "install.sh marked executable"

# ── Phase 1 · Step 8 — Machine spec (gitignored) ──────────────────────────────
section "Host profile (code/docs/MACHINE-SPEC.md)"
log ""

generate_machine_spec
ok "Host profile written → code/docs/MACHINE-SPEC.md  (gitignored — refresh with: bash install.sh --spec)"

# ── Phase 2 (--full only) ─────────────────────────────────────────────────────
if [[ "$FULL" == "false" ]]; then
  printf '\n'
  bold "✓ Phase 1 complete."
  log ""
  log "Next steps:"
  log "  1. Review code/src/docker/.env.dev and fill in any remaining secrets"
  log "  2. Start the dev stack:   bash code/src/scripts/development/server.sh up --build"
  log "  3. Apply migrations:      bash code/src/scripts/database/migrate.sh run"
  log "  4. Create a superuser:    bash code/src/scripts/database/manageusers.sh create-superuser"
  log ""
  log "Or run everything at once:  bash install.sh --full"
  log ""
  exit 0
fi

# ── Phase 2 · Step 7 — Build and start Docker dev stack ───────────────────────
section "Docker dev stack (build + up)"
log ""

docker compose --env-file "$ENV_DIR/.env.dev" -f "$COMPOSE_DEV" up -d --build
log ""
ok "Dev stack started"

# Wait for the application and database containers to be running. The stack is
# django + db + cache + nginx — there is no separate frontend container, because the
# site is server-rendered. `ps --services` prints service names only, so the match is
# exact rather than a substring of the whole ps table.
log ""
log "  Waiting for containers to be ready..."
MAX_WAIT=120
elapsed=0

running_services() {
  docker compose --env-file "$ENV_DIR/.env.dev" -f "$COMPOSE_DEV" ps --services --status running 2>/dev/null
}

while true; do
  services=$(running_services)
  if grep -qx 'django' <<< "$services" && grep -qx 'db' <<< "$services"; then
    break
  fi

  if [[ "$elapsed" -ge "$MAX_WAIT" ]]; then
    err "Containers did not become ready within ${MAX_WAIT}s."
    err "Check logs with: docker compose -f code/src/docker/docker-compose.dev.yml logs"
    exit 2
  fi

  sleep 3
  elapsed=$((elapsed + 3))
  printf '.'
done
printf '\n'
ok "All containers running (${elapsed}s)"

# ── Phase 2 · Step 8 — Migrations ─────────────────────────────────────────────
section "Database migrations"
log ""

bash "$PROJECT_ROOT/code/src/scripts/database/migrate.sh" run
log ""
ok "Migrations applied"

# ── Done ──────────────────────────────────────────────────────────────────────
printf '\n'
bold "✓ Full bootstrap complete."
log ""
log "  Site:             http://localhost:81"
log "  Django Admin:     http://localhost:81/control/   (superuser/staff only)"
log ""
log "Create a superuser (first time only):"
log "  bash code/src/scripts/database/manageusers.sh create-superuser"
log ""
