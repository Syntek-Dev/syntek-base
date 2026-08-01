# .claude/hooks

Pre-PR quality gate hooks plus a PreCompact hook. `pre-pr-check.sh` runs 8 quality gates before a
PR is marked ready; results are posted to the PR by `post-pr-comment.sh`. `pre-compact-handoff.sh`
is a separate PreCompact hook that intercepts context compaction and steers the session to the
`handoff` skill (see `.claude/CLAUDE.md` §2.6).

## Files

| File                     | Purpose                                                                   |
| ------------------------ | ------------------------------------------------------------------------- |
| `pre-pr-check.sh`        | Main quality gate script — runs all checks before PR                      |
| `post-pr-comment.sh`     | Posts check results as PR comments                                        |
| `pre-compact-handoff.sh` | PreCompact hook — intercepts compaction, steers to the `handoff` skill    |
| `lib/`                   | Individual check scripts sourced by pre-pr-check.sh — not called directly |

## lib/ Contents

| File                 | Purpose                         |
| -------------------- | ------------------------------- |
| `check-cloc.sh`      | Line count validation           |
| `check-format.sh`    | Code formatting checks          |
| `check-lint.sh`      | Linting and style checks        |
| `check-lockfiles.sh` | Dependency lock file validation |
| `check-security.sh`  | Security scanning               |
| `check-stubs.sh`     | Test stub validation            |
| `check-tests.sh`     | Test coverage and execution     |
| `check-typecheck.sh` | basedpyright type checking      |

## PreCompact hook

`pre-compact-handoff.sh` is registered in `.claude/settings.json` under `hooks.PreCompact` with
two matchers: `auto` (blocks auto-compaction, exit 2) and `manual` (warns only on a deliberate
`/compact`). It prints a reminder to run the `handoff` skill; a hook cannot invoke a skill or stop
the session, so writing the handoff and stopping remain the model's job (`.claude/CLAUDE.md` §2.6).

## Dual-Check Design

The lib check scripts run each tool both locally (on the host) and inside Docker via `_dc exec`.
This detects environment drift between the developer's host tools and the container.

**Local checks** (`ruff`, `pnpm exec`, `basedpyright`, `uv sync`, `pnpm audit`) use raw tool
commands because the project scripts (`syntax/format.sh`, `syntax/lint.sh`, etc.) only run
inside containers — they cannot check the host environment. This is intentional and correct.
Do not replace local-side tool calls with project scripts.
