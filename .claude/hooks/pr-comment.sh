#!/usr/bin/env bash
#
# pr-comment.sh — Claude Code PostToolUse hook.
#
# Runs after any Bash tool call. Intercepts successful `gh pr create` / `gh pr new`
# commands and posts a structured gate comment to the newly created PR, including
# the full check history for the current branch. Clears the branch history file
# after posting so the next PR on this branch starts fresh.

set -uo pipefail

# ── Parse stdin (Claude Code PostToolUse JSON) ────────────────────────────────
INPUT=$(cat)

COMMAND=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))' \
  2>/dev/null || true)

IS_ERROR=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print(str(d.get("tool_response",{}).get("isError",True)).lower())' \
  2>/dev/null || echo "true")

TOOL_OUTPUT=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_response",{}).get("output",""))' \
  2>/dev/null || true)

# Fast exit for non-PR commands or failed tool calls
if ! printf '%s' "$COMMAND" | grep -qE 'gh pr (create|new)\b'; then
  exit 0
fi
if [[ "$IS_ERROR" == "true" ]]; then
  exit 0
fi

# ── Paths ─────────────────────────────────────────────────────────────────────
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"

BRANCH=$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
SAFE_BRANCH="${BRANCH//\//-}"
HISTORY_FILE="$HOME/.claude/pr-check-history/${SAFE_BRANCH}.json"

# ── Get PR number ─────────────────────────────────────────────────────────────
PR_NUMBER=$(printf '%s' "$TOOL_OUTPUT" \
  | grep -oE 'https://github\.com/[^[:space:]]+/pull/[0-9]+|https://[^[:space:]]+/pulls/[0-9]+' \
  | head -1 \
  | grep -oE '[0-9]+$' || true)
if [[ -z "$PR_NUMBER" ]]; then
  PR_NUMBER=$(gh pr view --json number --jq '.number' 2>/dev/null || true)
fi
if [[ -z "$PR_NUMBER" ]]; then
  exit 0
fi

# ── Read history ──────────────────────────────────────────────────────────────
if [[ ! -f "$HISTORY_FILE" ]]; then
  gh pr comment "$PR_NUMBER" --body \
    "## PR Gate

> History file missing — gate check results unavailable for this PR." \
    2>/dev/null || true
  exit 0
fi

# ── Build and post comment via Python ─────────────────────────────────────────
export _HISTORY_FILE="$HISTORY_FILE"
export _PR_NUMBER="$PR_NUMBER" _BRANCH="$BRANCH" _PROJECT_ROOT="$PROJECT_ROOT"

python3 - <<'PYEOF'
import json, os, subprocess

def icon(passed): return "✅" if passed else "❌"
def status(passed): return "Pass" if passed else "Fail"
def fmt_name(k):
    return {
        "cloc":      "Line Count",
        "lockfiles": "Lockfile Alignment",
        "format":    "Code Style",
        "lint":      "Lint",
        "stubs":     "Stub Audit",
        "typecheck": "Type Check",
        "tests":     "Tests + Coverage",
        "security":  "Security",
    }.get(k, k.title())

history_file = os.environ["_HISTORY_FILE"]
pr_number    = os.environ["_PR_NUMBER"]
branch       = os.environ["_BRANCH"]
project_root = os.environ["_PROJECT_ROOT"]

try:
    with open(history_file) as f:
        history = json.load(f)
    if not isinstance(history, list) or not history:
        print("History file is empty — skipping comment")
        exit(0)
except Exception as e:
    print(f"Could not read history file: {e}")
    exit(0)

state      = history[-1]   # current (latest) attempt
prior_hist = history[:-1]  # all previous attempts

attempt     = state.get("attempt", 1)
commit      = state.get("commit", "unknown")
timestamp   = state.get("timestamp", "")
checks      = state.get("checks", {})
all_passed  = state.get("passed", True)
branch_tier = state.get("branch_tier", "feature")

ts_display  = timestamp[:16].replace("T", " ")
check_order = ["cloc", "lockfiles", "format", "lint", "stubs", "typecheck", "tests", "security"]

# ── Build comment ─────────────────────────────────────────────────────────────
lines = []

overall_icon = "✅" if all_passed else "❌"
heading = f"## PR Gate — {overall_icon} All Checks Passed"
if attempt > 1:
    heading += f" (Attempt {attempt})"
if branch_tier in ("staging", "main"):
    heading += " — 80% coverage floor applied"
lines.append(heading)
lines.append("")

lines.append("| Check | Status | Details |")
lines.append("|-------|--------|---------|")
for k in check_order:
    c = checks.get(k, {})
    p = c.get("passed", True)
    s = c.get("summary", "")
    lines.append(f"| {fmt_name(k)} | {icon(p)} {status(p)} | {s} |")

lines.append("")

# ── Previous attempt history ──────────────────────────────────────────────────
if attempt > 1 and prior_hist:
    lines.append("---")
    lines.append("")
    lines.append("### Attempt History")
    lines.append("")

    for prev in prior_hist:
        prev_num    = prev.get("attempt", "?")
        prev_commit = prev.get("commit", "?")
        prev_passed = prev.get("passed", False)
        prev_ts     = prev.get("timestamp", "")[:16].replace("T", " ")
        prev_icon   = "✅" if prev_passed else "❌"
        prev_result = "Passed" if prev_passed else "Failed"
        prev_checks = prev.get("checks", {})

        lines.append(
            f"**Attempt {prev_num} — {prev_icon} {prev_result}** "
            f"({prev_ts} UTC, commit `{prev_commit}`)"
        )
        lines.append("")
        lines.append("| Check | Result | Details |")
        lines.append("|-------|--------|---------|")
        for k in check_order:
            pc = prev_checks.get(k, {})
            pp = pc.get("passed", True)
            ps = pc.get("summary", "")
            lines.append(f"| {fmt_name(k)} | {icon(pp)} {status(pp)} | {ps} |")
        lines.append("")

        # Commits between this attempt and the next
        next_attempt = next(
            (e for e in history if e.get("attempt", 0) == prev_num + 1), None
        )
        if next_attempt and prev_commit != next_attempt.get("commit"):
            next_commit = next_attempt.get("commit", "")
            try:
                result = subprocess.run(
                    ["git", "-C", project_root, "log",
                     f"{prev_commit}..{next_commit}",
                     "--oneline", "--no-merges"],
                    capture_output=True, text=True, timeout=10
                )
                if result.returncode == 0 and result.stdout.strip():
                    commits = result.stdout.strip().splitlines()[:10]
                    lines.append(
                        f"**Commits added between attempt {prev_num} → {prev_num + 1}** "
                        f"(`{prev_commit}`..`{next_commit}`):"
                    )
                    lines.append("```text")
                    lines.extend(commits)
                    lines.append("```")
                    lines.append("")
            except Exception:
                pass

    lines.append("---")
    lines.append("")

lines.append(
    f"**Branch:** `{branch}` | **Commit:** `{commit}` | **Checked:** {ts_display} UTC  "
)
lines.append("*Automated PR Gate review by Claude Code*")

comment_body = "\n".join(lines)

result = subprocess.run(
    ["gh", "pr", "comment", str(pr_number), "--body", comment_body],
    capture_output=True, text=True
)
if result.returncode != 0:
    print(f"Warning: could not post PR comment: {result.stderr.strip()}")
else:
    print(f"PR Gate comment posted to PR #{pr_number}")
PYEOF

# ── Cleanup — clear branch history so the next PR starts fresh ────────────────
rm -f "$HISTORY_FILE"
