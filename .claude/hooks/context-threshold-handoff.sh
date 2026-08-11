#!/usr/bin/env bash
# context-threshold-handoff.sh — warn the session before the context window runs out.
#
# Registered as a UserPromptSubmit hook in .claude/settings.json.
#
# Same split as pre-compact-handoff.sh, moved earlier: a hook cannot invoke a skill or stop
# a turn, so this script measures and reminds while .claude/CLAUDE.md §2.6 carries the
# behaviour. PreCompact alone is too late — by the time compaction fires the window is
# already spent, and a handoff written under that pressure is the worst one of the session.
#
#   ≥50%  advise  — once per session; steer toward a stopping point.
#   ≥75%  insist  — every prompt; write the handoff now.
#
# stdin  = the UserPromptSubmit JSON payload.
# stdout = injected into the model's context (on exit 0).
# Always exits 0: a miscounted token must never block <%DEVELOPER_NAME%>'s prompt.
set -uo pipefail

# Nothing in the transcript reports the window size, so it is a constant here. 1M is this
# project's observed window — real sessions reach ~840k. Override for a 200k plan.
WINDOW="${CLAUDE_CONTEXT_WINDOW:-1000000}"
ADVISE_PCT="${CLAUDE_CONTEXT_ADVISE_PCT:-50}"
INSIST_PCT="${CLAUDE_CONTEXT_INSIST_PCT:-75}"

command -v jq >/dev/null 2>&1 || exit 0

payload=$(cat)
transcript=$(printf '%s' "$payload" | jq -r '.transcript_path // empty' 2>/dev/null)
session=$(printf '%s' "$payload" | jq -r '.session_id // "unknown"' 2>/dev/null)
session="${session//[^A-Za-z0-9-]/}"
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

# The last main-chain assistant turn's usage IS the context size: the three input fields
# already cover the whole conversation, and its output becomes the next prompt's tail.
# Sidechain records are subagent windows — counting one reads a context that is not ours.
# fromjson? rather than a plain parse, so one half-written line cannot abort the scan.
used=$(jq -Rr '
  fromjson?
  | select(.type == "assistant")
  | select(.isSidechain != true)
  | .message?.usage? // empty
  | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0)
     + (.cache_read_input_tokens // 0) + (.output_tokens // 0))
' "$transcript" 2>/dev/null | tail -1)

[[ "$used" =~ ^[0-9]+$ ]] || exit 0
[ "$WINDOW" -gt 0 ] || exit 0
pct=$(( used * 100 / WINDOW ))

if [ "$pct" -ge "$INSIST_PCT" ]; then
  cat <<MSG
⛔ Context at ~${pct}% (${used} / ${WINDOW} tokens) — past the insist threshold.

House rule (.claude/CLAUDE.md §2.6): hand off NOW, before the window forces it.
  1. Invoke the \`handoff\` skill → handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md
  2. Stop the turn and print the path.
  3. <%DEVELOPER_NAME%> runs /clear and resumes in a fresh context window.

Start no new scoped work. Finish only what cannot be safely left mid-flight.
MSG
  exit 0
fi

[ "$pct" -ge "$ADVISE_PCT" ] || exit 0

# Advisory fires once per session: a notice repeated every prompt spends the very context
# it exists to protect. The insist tier above repeats deliberately — there, being ignored
# costs more than the tokens do.
state="${TMPDIR:-/tmp}/claude-context-advise-${session}"
[ -f "$state" ] && exit 0
: >"$state" 2>/dev/null || true

cat <<MSG
⚠️  Context at ~${pct}% (${used} / ${WINDOW} tokens) — half the window is gone.

House rule (.claude/CLAUDE.md §2.6): steer toward a handoff.
  • Finish the step in flight; open no new scoped work that will not fit.
  • Name the natural stopping point to <%DEVELOPER_NAME%> and offer \`/handoff\`.
  • At 75% this becomes an instruction, not a suggestion.
MSG
exit 0
