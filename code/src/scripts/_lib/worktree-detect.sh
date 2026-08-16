#!/usr/bin/env bash
#
# worktree-detect.sh — Shared worktree detection helper.
#
# Source this file (after setting PROJECT_ROOT) to get:
#   WORKTREE_US_NUM    e.g. "003"
#   OVERRIDE_DEV_FILE  path to docker-compose.us###.dev.yml (empty if not found)
#   OVERRIDE_TEST_FILE path to docker-compose.us###.test.yml (empty if not found)
#
# Usage in calling scripts:
#   source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
#   DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
#       ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})
#
# CONTRACT: PROJECT_ROOT must be set before sourcing.
# This file is safe to source multiple times — variables are reset on each source.

WORKTREE_US_NUM=""
OVERRIDE_DEV_FILE=""
OVERRIDE_TEST_FILE=""

_wt_branch="$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
if [[ "$_wt_branch" =~ ^us([0-9]{3})/ ]]; then
  WORKTREE_US_NUM="${BASH_REMATCH[1]}"
  _wt_dev="$PROJECT_ROOT/code/src/docker/docker-compose.us${WORKTREE_US_NUM}.dev.yml"
  _wt_test="$PROJECT_ROOT/code/src/docker/docker-compose.us${WORKTREE_US_NUM}.test.yml"
  [[ -f "$_wt_dev"  ]] && OVERRIDE_DEV_FILE="$_wt_dev"
  [[ -f "$_wt_test" ]] && OVERRIDE_TEST_FILE="$_wt_test"
fi
unset _wt_branch _wt_dev _wt_test
