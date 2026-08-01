#!/usr/bin/env bash
#
# install.sh — Forwards to install-frontend.sh (pnpm) for backwards compatibility.
#
# Prefer calling the specific scripts directly:
#   install-frontend.sh   pnpm lockfile + node_modules
#   install-backend.sh    uv lockfile + .venv
#
exec "$(dirname "${BASH_SOURCE[0]}")/install-frontend.sh" "$@"
