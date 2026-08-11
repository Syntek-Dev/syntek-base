#!/usr/bin/env bash
# pre-compact-handoff.sh — intercept context compaction; steer the session to the handoff skill.
#
# Registered as a PreCompact hook in .claude/settings.json (matchers "auto" and "manual").
# A hook runs a shell command — it CANNOT invoke a skill or stop the session; only the model can.
# So this script's job is narrow: stop silent auto-compaction and surface a loud, actionable
# reminder to hand off instead (the house rule, .claude/CLAUDE.md §2.6).
#
#   $1 = auto    → auto-compaction fired: BLOCK it (exit 2) and remind. Never compact silently.
#   $1 = manual  → the user ran /compact deliberately: WARN only (exit 0); don't block a choice.
set -uo pipefail

mode="${1:-auto}"

remind() {
  cat >&2 <<'MSG'
⛔ Compaction intercepted — do NOT compact this session.

House rule (.claude/CLAUDE.md §2.6): replace compaction with a handoff.
  1. Invoke the `handoff` skill → write handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md
  2. Stop the turn and print the handoff path for <%DEVELOPER_NAME%>.
  3. <%DEVELOPER_NAME%> runs /clear and resumes from the handoff file in a fresh context window.
MSG
}

remind

if [ "$mode" = "manual" ]; then
  printf '\n(Manual /compact allowed — but /handoff gives a cleaner cross-session boundary.)\n' >&2
  exit 0
fi

# Auto-compaction: block so nothing is silently summarised.
exit 2
