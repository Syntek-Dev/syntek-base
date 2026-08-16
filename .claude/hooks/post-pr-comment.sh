#!/usr/bin/env bash
#
# post-pr-comment.sh — Claude Code PostToolUse hook: post check summary to PR.
#
# Fired by Claude Code after every Bash tool call.
# Exits 0 immediately for any command that is not "gh pr create" / "gh pr new",
# or if the tool call itself errored.
#
# When triggered on a successful PR creation:
#   - Extracts the PR number from tool output, falls back to gh pr view
#   - Reads attempt history from ~/.claude/pr-check-history/<branch>.json
#   - Posts a structured markdown comment with check results, version info,
#     prior failed attempts, and resolution commits (resolved by commit range)
#
# This script never blocks (exits 0 even on comment failure).
#
set -uo pipefail

# ── 1  Fast-path guard ────────────────────────────────────────────────────────
# Also skip if the tool call itself returned an error.

INPUT=$(cat)

COMMAND=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))' \
  2>/dev/null || true)

# Don't post if gh pr create/new failed.
# The Bash PostToolUse payload has no guaranteed `isError`/`output` field, so
# default to "not an error" (the hook only fires after the tool ran) and treat
# the call as failed only when an error flag is *explicitly* truthy. The
# command-grep and PR-number guards below remain the real safety net.
IS_ERROR=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys, json
d = json.load(sys.stdin)
tr = d.get("tool_response")
if not isinstance(tr, dict):
    tr = {}
flag = tr.get("isError", tr.get("is_error", False))
print(str(bool(flag)).lower())' \
  2>/dev/null || echo "false")

# Read the command output across the field names different payloads use
# (`output` / `stdout` / `stderr`, or a bare-string tool_response) so the
# PR-URL extraction works regardless of shape.
TOOL_OUTPUT=$(printf '%s' "$INPUT" \
  | python3 -c 'import sys, json
d = json.load(sys.stdin)
tr = d.get("tool_response")
if isinstance(tr, str):
    print(tr)
elif isinstance(tr, dict):
    print(tr.get("output") or tr.get("stdout") or tr.get("stderr") or "")
else:
    print("")' \
  2>/dev/null || true)

printf '%s' "$COMMAND" | grep -qE 'gh pr (create|new)\b' || exit 0
[[ "$IS_ERROR" == "true" ]] && exit 0

# ── 2  Paths ──────────────────────────────────────────────────────────────────

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
BRANCH=$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
BRANCH_SAFE="${BRANCH//\//_}"
HISTORY_FILE="$HOME/.claude/pr-check-history/${BRANCH_SAFE}.json"
PR_FAIL_FILE="$HOME/.claude/pr-check-history/${BRANCH_SAFE}-failure.md"

# ── 3  Extract PR number ──────────────────────────────────────────────────────
# Extract the PR number (not just the URL), falling back to gh pr view.

PR_NUMBER=$(printf '%s' "$TOOL_OUTPUT" \
  | grep -oE '/(pull|pulls)/[0-9]+' | head -1 | grep -oE '[0-9]+' || true)

if [[ -z "$PR_NUMBER" ]]; then
  PR_NUMBER=$(gh pr view --json number --jq '.number' 2>/dev/null || true)
fi

if [[ -z "$PR_NUMBER" ]]; then
  printf '[post-pr] Could not determine PR number — skipping comment.\n' >&2
  exit 0
fi

# ── 4  Load history ───────────────────────────────────────────────────────────

if [[ ! -f "$HISTORY_FILE" ]]; then
  printf '[post-pr] No history file for branch %s — skipping comment.\n' "$BRANCH" >&2
  exit 0
fi

# ── 5  Build and post comment ─────────────────────────────────────────────────

COMMENT_BODY=$(python3 - "$HISTORY_FILE" "$PROJECT_ROOT" "$PR_FAIL_FILE" <<'PYEOF'
import sys, json, subprocess, os

history_file  = sys.argv[1]
project_root  = sys.argv[2]
fail_file     = sys.argv[3]

try:
    history = json.load(open(history_file))
except Exception:
    print("No pre-PR check history available.")
    sys.exit(0)

attempts = history.get("attempts", [])
if not attempts:
    print("No pre-PR check history available.")
    sys.exit(0)

latest         = attempts[-1]
prior_failures = [a for a in attempts[:-1] if a.get("status") == "failed"]

CHECK_ORDER = ["cloc", "lockfiles", "format", "lint", "stubs", "typecheck", "tests", "security"]
CHECK_DISPLAY = {
    "cloc":      "Line Count",
    "lockfiles": "Lockfile Alignment",
    "format":    "Format",
    "lint":      "Lint",
    "stubs":     "Stub Audit",
    "typecheck": "Type-check",
    "tests":     "Tests + Coverage",
    "security":  "Security",
}

def icon(passed): return "✅" if passed else "❌"
def status(passed): return "Pass" if passed else "Fail"

ts          = latest.get("timestamp", "")
commit      = latest.get("commit", "unknown")
all_passed  = latest.get("status", "unknown") == "passed"
failed      = set(latest.get("failed_checks", []))
summaries   = latest.get("check_summaries", {})
branch_tier = "staging_main" if any(
    k == "tests" and "[staging/main" in v.get("summary", "")
    for k, v in summaries.items()
) else "feature"
cov         = latest.get("coverage", {})
vi          = latest.get("version_info", {})
uv_info     = vi.get("uv", {})
pnpm_info   = vi.get("pnpm", {})
warnings    = vi.get("warnings", [])
attempt_num = len(attempts)

ts_display = ts[:16].replace("T", " ") if ts else "unknown"

lines = []

heading = f"## PR Gate — {'✅ All Checks Passed' if all_passed else '❌ Checks Failed'}"
if attempt_num > 1:
    heading += f" (Attempt {attempt_num})"
if cov.get("required"):
    heading += " — 80% coverage floor applied"
lines.append(heading)
lines.append("")

lines.append("| Check | Status | Details |")
lines.append("|-------|--------|---------|")
for k in CHECK_ORDER:
    c     = summaries.get(k, {})
    p     = c.get("passed", k not in failed)
    summ  = c.get("summary", "")
    lines.append(f"| {CHECK_DISPLAY.get(k, k)} | {icon(p)} {status(p)} | {summ} |")

if cov.get("required"):
    lines.append("")
    b_pct = cov.get("backend_pct", 0)
    f_pct = cov.get("frontend_pct", 0)
    thresh = cov.get("threshold", 80)
    lines.append("**Coverage (80% required on this branch)**")
    lines.append("")
    lines.append("| Layer | Coverage |")
    lines.append("|-------|----------|")
    lines.append(f"| Backend  | {b_pct}% {'✅' if b_pct >= thresh else '❌'} |")
    lines.append(f"| Frontend | {f_pct}% {'✅' if f_pct >= thresh else '❌'} |")

lines.append("")
lines.append("### Version Alignment")
lines.append("")
lines.append("| Tool | Local | Docker |")
lines.append("|------|-------|--------|")
lines.append(f"| uv   | {uv_info.get('local','?')} | {uv_info.get('docker','?')} |")
lines.append(f"| pnpm | {pnpm_info.get('local','?')} | {pnpm_info.get('docker','?')} |")
if warnings:
    lines.append("")
    for w in warnings:
        lines.append(f"> ⚠️ {w}")

# ── Prior attempt history ─────────────────────────────────────────────────────

if prior_failures:
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("### Attempt History")
    lines.append("")

    for prev in prior_failures:
        prev_num    = attempts.index(prev) + 1
        prev_commit = prev.get("commit", "?")
        prev_passed = prev.get("status", "failed") == "passed"
        prev_ts     = prev.get("timestamp", "")[:16].replace("T", " ")
        prev_summ   = prev.get("check_summaries", {})
        prev_failed = set(prev.get("failed_checks", []))

        lines.append(
            f"**Attempt {prev_num} — {'✅ Passed' if prev_passed else '❌ Failed'}** "
            f"({prev_ts} UTC, commit `{prev_commit}`)"
        )
        lines.append("")
        lines.append("| Check | Status | Details |")
        lines.append("|-------|--------|---------|")
        for k in CHECK_ORDER:
            c  = prev_summ.get(k, {})
            p  = c.get("passed", k not in prev_failed)
            s  = c.get("summary", "")
            lines.append(f"| {CHECK_DISPLAY.get(k, k)} | {icon(p)} {status(p)} | {s} |")
        lines.append("")

        # Change 9c: commit-range resolution (exact, not timestamp-based)
        # Find the next attempt after this one to use as range endpoint
        prev_idx = attempts.index(prev)
        if prev_idx + 1 < len(attempts):
            next_attempt = attempts[prev_idx + 1]
            next_commit  = next_attempt.get("commit", "")
            if prev_commit and next_commit and prev_commit != next_commit \
                    and prev_commit != "unknown" and next_commit != "unknown":
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
else:
    lines.append("")
    lines.append("_No prior failed attempts on this branch._")

# ── Failure report (from local file written by pre-pr-check) ─────────────────

if os.path.isfile(fail_file):
    try:
        report = open(fail_file).read().strip()
        if report:
            lines.append("")
            lines.append("---")
            lines.append("")
            lines.append("### Failure Report")
            lines.append("")
            lines.append("<details>")
            lines.append("<summary>Full failure report written at gate time</summary>")
            lines.append("")
            lines.append(report)
            lines.append("")
            lines.append("</details>")
    except Exception:
        pass

lines.append(f"**Branch:** `{history.get('branch', '?')}` | **Commit:** `{commit}` | **Checked:** {ts_display} UTC  ")
lines.append("*Automated PR Gate review by Claude Code*")

print("\n".join(lines))
PYEOF
)

if [[ -z "$COMMENT_BODY" ]]; then
  printf '[post-pr] Empty comment body — skipping.\n' >&2
  exit 0
fi

if gh pr comment "$PR_NUMBER" --body "$COMMENT_BODY" 2>/dev/null; then
  printf '[post-pr] PR Gate comment posted to PR #%s\n' "$PR_NUMBER"
  if [[ -f "$PR_FAIL_FILE" ]]; then
    rm -f "$PR_FAIL_FILE"
    printf '[post-pr] Removed resolved failure report.\n'
  fi
else
  printf '[post-pr] Could not post comment (gh auth or network issue).\n' >&2
fi

exit 0
