#!/usr/bin/env bash
#
# hosts-story-remove.sh — Remove /etc/hosts entries for a story worktree.
#
# Usage:
#   hosts-story-remove.sh <story-number>   e.g. hosts-story-remove.sh 3   or   hosts-story-remove.sh 003
#
# Removes the line containing dev-us<NNN>.<%PROJECT_SLUG%>.localhost from /etc/hosts.
# Does nothing if the entry is not present.
#
# Exit codes:  0 = success / not present   1 = bad input   2 = write failed
#
set -euo pipefail

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m  %s\n' "$*"; }
warn() { printf '  \033[33m⚠\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $# -eq 1 ]] || die "Usage: hosts-story-remove.sh <story-number>  (e.g. 3 or 003)"

INPUT="$1"
[[ "$INPUT" =~ ^[0-9]+$ ]] || die "Story number must be numeric (got: $INPUT)"

N=$(( 10#$INPUT ))
(( N >= 1 && N <= 253 )) || die "Story number must be 1–253 (got: $N)"

PAD=$(printf '%03d' "$N")

if ! grep -qF "dev-us${PAD}.<%PROJECT_SLUG%>.localhost" /etc/hosts; then
  ok "not present — nothing to remove for us${PAD}"
  exit 0
fi

TMPFILE=$(mktemp)
if grep -vF "dev-us${PAD}.<%PROJECT_SLUG%>.localhost" /etc/hosts > "$TMPFILE" && sudo cp "$TMPFILE" /etc/hosts; then
  rm -f "$TMPFILE"
  ok "Removed us${PAD} entries from /etc/hosts"
else
  rm -f "$TMPFILE"
  warn "Could not update /etc/hosts — remove the line manually:"
  warn "  127.0.0.${N} dev-us${PAD}.<%PROJECT_SLUG%>.localhost ..."
  exit 2
fi
