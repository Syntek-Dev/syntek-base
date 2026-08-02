#!/usr/bin/env bash
#
# hosts-story-add.sh — Add /etc/hosts entries for a story worktree.
#
# Usage:
#   hosts-story-add.sh <story-number>   e.g. hosts-story-add.sh 3   or   hosts-story-add.sh 003
#
# Adds:
#   127.0.0.<N> dev-us<NNN>.<%PROJECT_SLUG%>.localhost test-us<NNN>.<%PROJECT_SLUG%>.localhost
#
# Idempotent — does nothing if the entry already exists.
# Pair with hosts-story-remove.sh when the worktree is torn down.
#
# Exit codes:  0 = success / already exists   1 = bad input   2 = write failed
#
set -euo pipefail

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m  %s\n' "$*"; }
warn() { printf '  \033[33m⚠\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $# -eq 1 ]] || die "Usage: hosts-story-add.sh <story-number>  (e.g. 3 or 003)"

INPUT="$1"
[[ "$INPUT" =~ ^[0-9]+$ ]] || die "Story number must be numeric (got: $INPUT)"

N=$(( 10#$INPUT ))
(( N >= 1 && N <= 253 )) || die "Story number must be 1–253 (got: $N)"

PAD=$(printf '%03d' "$N")
# One hostname per stack the worktree publishes — dev and test. Add another only
# when the compose override actually publishes a service behind it.
ENTRY="127.0.0.${N} dev-us${PAD}.<%PROJECT_SLUG%>.localhost test-us${PAD}.<%PROJECT_SLUG%>.localhost"

if grep -qF "dev-us${PAD}.<%PROJECT_SLUG%>.localhost" /etc/hosts; then
  ok "already present — dev-us${PAD}.<%PROJECT_SLUG%>.localhost"
  exit 0
fi

if echo "$ENTRY" | sudo tee -a /etc/hosts > /dev/null; then
  ok "Added: $ENTRY"
else
  warn "Could not write to /etc/hosts — add the following line manually:"
  warn "  $ENTRY"
  exit 2
fi
