#!/usr/bin/env bash
#
# wizard.sh — Shared helpers for interactive setup wizards.
#
# A *wizard* walks a human through a manual procedure the agent cannot perform itself:
# clicking through a third-party dashboard, minting credentials, running a one-off cutover.
# It opens each URL, says what to click, captures the value, and writes it where it belongs.
#
# Source this file (after setting PROJECT_ROOT) to get:
#   stage <title>          start a numbered stage — clears the screen, prints progress
#   say <text>             a line of guidance
#   step <text>            a numbered instruction within the current stage
#   warn <text>            a caution the human must read
#   open_url <url>         open in the default browser (Linux/macOS/WSL); prints it on failure
#   ask <var> <prompt> [default]        read a visible value into <var>
#   ask_secret <var> <prompt>           read a hidden value into <var>
#   confirm <prompt>       yes/no gate — returns non-zero on "no"
#   pause [text]           wait for Enter
#   write_env <file> <key> <value>      idempotent upsert into a .env file (0600)
#   finish                 closing summary
#
# CONTRACT:
#   - PROJECT_ROOT must be set before sourcing.
#   - TOTAL_STAGES must be set by the wizard before its first `stage` call.
#   - The wizard sets `set -euo pipefail` itself; this library does not.
#
# Never write a real secret to stdout, a log, or a tracked file. `write_env` targets
# .env files, which are gitignored; `.env.*.example` templates take placeholders only.
#
# Authored for this project. See .claude/skills/wizard/SKILL.md for how to build one.

if [[ -t 1 ]] && [[ -z "${NO_COLOUR:-}" ]]; then
  _W_BOLD=$'\033[1m'; _W_DIM=$'\033[2m'; _W_RED=$'\033[31m'
  _W_GREEN=$'\033[32m'; _W_YELLOW=$'\033[33m'; _W_RESET=$'\033[0m'
else
  _W_BOLD=""; _W_DIM=""; _W_RED=""; _W_GREEN=""; _W_YELLOW=""; _W_RESET=""
fi

WIZARD_STAGE=0
TOTAL_STAGES="${TOTAL_STAGES:-0}"
_WIZARD_WROTE=()

stage() {
  WIZARD_STAGE=$((WIZARD_STAGE + 1))
  [[ -t 1 ]] && printf '\033[2J\033[H'
  printf '%s\n' "${_W_DIM}── stage ${WIZARD_STAGE} of ${TOTAL_STAGES} ─────────────────────────${_W_RESET}"
  printf '%s\n\n' "${_W_BOLD}$1${_W_RESET}"
}

say()  { printf '%s\n' "$1"; }
step() { printf '  %s %s\n' "${_W_GREEN}▸${_W_RESET}" "$1"; }
warn() { printf '  %s %s\n' "${_W_YELLOW}!${_W_RESET}" "$1"; }
fail() { printf '  %s %s\n' "${_W_RED}✗${_W_RESET}" "$1" >&2; return 1; }

open_url() {
  local url="$1" opener=""
  if   command -v xdg-open >/dev/null 2>&1;    then opener="xdg-open"
  elif command -v open     >/dev/null 2>&1;    then opener="open"
  elif command -v wslview  >/dev/null 2>&1;    then opener="wslview"
  fi
  printf '  %s %s\n' "${_W_DIM}open:${_W_RESET}" "$url"
  if [[ -n "$opener" ]]; then
    "$opener" "$url" >/dev/null 2>&1 || warn "Could not open a browser — use the URL above."
  else
    warn "No browser opener found — use the URL above."
  fi
}

ask() {
  local __var="$1" __prompt="$2" __default="${3:-}" __reply=""
  while :; do
    if [[ -n "$__default" ]]; then
      read -r -p "  ${__prompt} [${__default}]: " __reply || true
      __reply="${__reply:-$__default}"
    else
      read -r -p "  ${__prompt}: " __reply || true
    fi
    [[ -n "$__reply" ]] && break
    warn "A value is required."
  done
  printf -v "$__var" '%s' "$__reply"
}

ask_secret() {
  local __var="$1" __prompt="$2" __reply=""
  while :; do
    read -r -s -p "  ${__prompt}: " __reply || true
    printf '\n'
    [[ -n "$__reply" ]] && break
    warn "A value is required."
  done
  printf -v "$__var" '%s' "$__reply"
}

confirm() {
  local reply=""
  read -r -p "  $1 [y/N]: " reply || true
  [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]
}

pause() { read -r -p "  ${1:-Press Enter to continue} " _ || true; }

# write_env <file> <key> <value> — idempotent upsert, never duplicating a key.
write_env() {
  local file="$1" key="$2" value="$3" tmp
  [[ -f "$file" ]] || { install -m 600 /dev/null "$file"; }
  tmp="$(mktemp)"
  if grep -qE "^${key}=" "$file" 2>/dev/null; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      if [[ "$line" == "${key}="* ]]; then printf '%s=%s\n' "$key" "$value"
      else printf '%s\n' "$line"; fi
    done < "$file" > "$tmp"
  else
    cat "$file" > "$tmp" 2>/dev/null || true
    printf '%s=%s\n' "$key" "$value" >> "$tmp"
  fi
  cat "$tmp" > "$file"
  rm -f "$tmp"
  chmod 600 "$file"
  _WIZARD_WROTE+=("${key} → ${file##*/}")
  step "saved ${_W_BOLD}${key}${_W_RESET}"
}

finish() {
  printf '\n%s\n' "${_W_GREEN}${_W_BOLD}✓ Wizard complete.${_W_RESET}"
  if [[ ${#_WIZARD_WROTE[@]} -gt 0 ]]; then
    printf '\n%s\n' "${_W_BOLD}Written:${_W_RESET}"
    printf '  · %s\n' "${_WIZARD_WROTE[@]}"
  fi
  [[ -n "${1:-}" ]] && printf '\n%s\n' "$1"
  printf '\n'
}
