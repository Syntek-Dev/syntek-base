# .claude/hooks

Pre-PR quality gate hooks plus two session-continuity hooks. `pre-pr-check.sh` runs 8 quality
gates before a PR is marked ready; results are posted to the PR by `post-pr-comment.sh`.
`context-threshold-handoff.sh` (UserPromptSubmit) warns as the context window fills, and
`pre-compact-handoff.sh` (PreCompact) intercepts compaction — both steer the session to the
`handoff` skill (see `.claude/CLAUDE.md` §2.6).

## Directory Tree

```text
.claude/hooks/
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── pre-pr-check.sh          ← the eight pre-PR quality gates, orchestrated
├── post-pr-comment.sh       ← posts a pre-pr-check run to the PR as a comment
├── context-threshold-handoff.sh ← UserPromptSubmit hook — warns at 50% context, insists at 75%
├── pre-compact-handoff.sh   ← PreCompact hook — blocks auto-compaction, steers to `handoff`
└── lib/                     ← one gate per file, sourced by pre-pr-check.sh, never run directly
    ├── check-cloc.sh        ← line-count validation
    ├── check-format.sh      ← code formatting
    ├── check-lint.sh        ← linting and style
    ├── check-lockfiles.sh   ← dependency lockfile integrity
    ├── check-security.sh    ← dependency CVE scan
    ├── check-stubs.sh       ← stub detection
    ├── check-tests.sh       ← test execution and coverage
    └── check-typecheck.sh   ← basedpyright type checking
```

## Files

| File                           | Purpose                                                                    |
| ------------------------------ | -------------------------------------------------------------------------- |
| `pre-pr-check.sh`              | Main quality gate script — runs all checks before PR                       |
| `post-pr-comment.sh`           | Posts check results as PR comments                                         |
| `context-threshold-handoff.sh` | UserPromptSubmit hook — measures context use, warns at 50%, insists at 75% |
| `pre-compact-handoff.sh`       | PreCompact hook — intercepts compaction, steers to the `handoff` skill     |
| `lib/`                         | Individual check scripts sourced by pre-pr-check.sh — not called directly  |

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

## Session-continuity hooks

Two hooks guard the same rule (`.claude/CLAUDE.md` §2.6) at two moments. Neither can invoke a
skill or stop a turn — only the model can — so both measure and remind, and the rule carries the
behaviour.

`context-threshold-handoff.sh` is registered under `hooks.UserPromptSubmit`. It reads the live
token count from the session transcript and injects a notice on two tiers: **50% advise** (once
per session — a notice repeated every prompt spends the context it protects) and **75% insist**
(every prompt — there, being ignored costs more than the tokens do). It is the early warning;
without it the first signal arrives only when the window is already spent.

`pre-compact-handoff.sh` is registered under `hooks.PreCompact` with two matchers: `auto` (blocks
auto-compaction, exit 2) and `manual` (warns only on a deliberate `/compact`). It is the backstop
for a session that reached compaction anyway.

**Window size is a constant, not a reading** — nothing in the transcript reports it.
`context-threshold-handoff.sh` defaults to 1M (this project's observed window; sessions reach
~840k) and takes `CLAUDE_CONTEXT_WINDOW`, `CLAUDE_CONTEXT_ADVISE_PCT`, and
`CLAUDE_CONTEXT_INSIST_PCT` as overrides. A project on a 200k plan **must** set the first, or the
hook fires from the opening prompt.

## Dual-Check Design

The lib check scripts run each tool both locally (on the host) and inside Docker via `_dc exec`.
This detects environment drift between the developer's host tools and the container.

**Local checks** (`ruff`, `pnpm exec`, `basedpyright`, `uv sync`, `pnpm audit`) use raw tool
commands because the project scripts (`syntax/format.sh`, `syntax/lint.sh`, etc.) only run
inside containers — they cannot check the host environment. That is the one place in this
repository where a raw tool call is the correct thing to write, and it is why: a script that
can only run in the container cannot detect that the container and the host disagree.
