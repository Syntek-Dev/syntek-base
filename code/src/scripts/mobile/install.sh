#!/usr/bin/env bash
#
# install.sh — Install the mobile workspace's dependencies.
#
# Usage:
#   install.sh            Install into node_modules (workspace-aware)
#   install.sh --check    Verify the lockfile is up to date without installing
#   install.sh --help
#
# The mobile app is a pnpm workspace member joined by the code/src/* glob in
# pnpm-workspace.yaml, so the lockfile it writes is the ROOT pnpm-lock.yaml. Commit it.
#
# Exit codes:  0 = success   1 = install failed   2 = script error
#
SCRIPT_NAME="install.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

CHECK=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) CHECK=true; shift ;;
    --help | -h)
      sed -n '3,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

if $CHECK; then
  bold "▸ install.sh --check (mobile)"
  log ""
  pnpm install --frozen-lockfile --ignore-scripts
  log ""
  bold "✓ Lockfile is up to date."
  exit 0
fi

bold "▸ install.sh (mobile)"
log ""
pnpm install --ignore-scripts
log ""
bold "✓ Mobile dependencies installed. Commit pnpm-lock.yaml if it changed."
