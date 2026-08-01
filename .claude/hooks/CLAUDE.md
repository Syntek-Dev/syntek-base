@./CONTEXT.md

# CLAUDE.md — .claude/hooks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(gate list + dual-check design, imported above) → this file.

## Purpose (one line)

The pre-PR quality-gate hooks — `pre-pr-check.sh` runs the eight gates (cloc, format,
lint, lockfiles, security, stubs, tests, typecheck) sourced from `lib/`, and
`post-pr-comment.sh` posts the results as a GitHub PR comment. Plus `pre-compact-handoff.sh`
— a PreCompact hook that intercepts context compaction and steers the session to the `handoff`
skill instead (`.claude/CLAUDE.md` §2.6).

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

## Output & naming

- **Hand-written:** `pre-pr-check.sh`, `post-pr-comment.sh`, `pre-compact-handoff.sh`, and
  every `lib/check-*.sh`. The PR comment is generated output, not a file.
- **Naming:** `kebab-case.sh`; each `lib/` gate is `check-<gate>.sh`. Add a new gate as
  `lib/check-<name>.sh`, wire it into `pre-pr-check.sh`, and register it in `CONTEXT.md`.
