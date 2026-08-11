@./CONTEXT.md

# CLAUDE.md — .claude/hooks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(gate list + dual-check design, imported above) → this file.

## Purpose (one line)

The pre-PR quality-gate hooks — `pre-pr-check.sh` runs the eight gates (cloc, format,
lint, lockfiles, security, stubs, tests, typecheck) sourced from `lib/`, and
`post-pr-comment.sh` posts the results as a GitHub PR comment. Plus two session-continuity
hooks — `context-threshold-handoff.sh` (warns at 50% context, insists at 75%) and
`pre-compact-handoff.sh` (intercepts compaction) — both steering to the `handoff` skill
(`.claude/CLAUDE.md` §2.6).

## How to work here

- **Routing:** shell-script changes — edit `pre-pr-check.sh`, `post-pr-comment.sh`, or
  a `lib/check-*.sh`. `lib/` scripts are sourced by `pre-pr-check.sh`, never called
  directly. Opus for any gate-logic change; Opus for a message tweak or rename.
- **Dual-check design is deliberate:** each `lib/` check runs the tool both on the host
  (raw `ruff`, `pnpm exec`, `basedpyright`, `uv sync`, `pnpm audit`) and inside Docker
  via `_dc exec`, to catch host/container drift. **Do not replace the local-side raw
  tool calls with project scripts** — the `syntax/*.sh` scripts only run inside
  containers and cannot check the host.
- **Concrete steps:** edit the relevant script → run it against a branch to confirm the
  gate passes and fails correctly → keep the failure output actionable → keep each file
  within the 300-line instructional limit where it counts as instructional.
- **Definition of done:** the gate detects the regression it is meant to; local and
  Docker sides stay in sync; `CONTEXT.md` updated if a gate is added or removed.

## Guardrails

- **`lib/` scripts are sourced, not executed** — do not add a `main`/entry that invites
  direct invocation, and do not break the sourcing contract with `pre-pr-check.sh`.
- **Keep the host-side and container-side checks paired** — dropping either half
  defeats the drift detection.
- `check-security.sh` and `check-stubs.sh` are release-blocking — never soften a gate
  to make a PR pass; fix the code instead.
- No secrets in scripts or PR comments — tokens come from the environment only.
- `pre-compact-handoff.sh` **blocks** auto-compaction (exit 2) and only warns on a manual
  `/compact` — do not weaken this; silent compaction is the thing it exists to prevent.
- `context-threshold-handoff.sh` **always exits 0** — it sits on every prompt submission, so
  a miscounted token must never block <%DEVELOPER_NAME%> from typing. Every failure path
  (no `jq`, no transcript, unparseable payload) exits silently rather than guessing.
- **Count the main chain only** — usage records flagged `isSidechain` are subagent windows;
  reading one reports a context that is not the session's.
- **Verify a threshold change by replaying a real transcript** with `CLAUDE_CONTEXT_WINDOW`
  set to force each tier — the tiers are unreachable in a fresh session, so an unverified
  edit ships untested.

## Output & naming

- **Hand-written:** `pre-pr-check.sh`, `post-pr-comment.sh`, `pre-compact-handoff.sh`,
  `context-threshold-handoff.sh`, and every `lib/check-*.sh`. The PR comment is generated
  output, not a file.
- **Naming:** `kebab-case.sh`; each `lib/` gate is `check-<gate>.sh`. Add a new gate as
  `lib/check-<name>.sh`, wire it into `pre-pr-check.sh`, and register it in `CONTEXT.md`.
