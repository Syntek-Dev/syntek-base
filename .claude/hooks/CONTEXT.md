# .claude/hooks

Pre-PR quality gate hooks, two session-continuity hooks, and one write guard. `pre-pr-check.sh`
runs 8 quality gates before a PR is marked ready; results are posted to the PR by
`post-pr-comment.sh`. `context-threshold-handoff.sh` (UserPromptSubmit) warns as the context
window fills, and `pre-compact-handoff.sh` (PreCompact) intercepts compaction — both steer the
session to the `handoff` skill (see `.claude/CLAUDE.md` Section 2.6).
`template-docs-readonly.sh` (PreToolUse) blocks writes to the template documentation a generated
project receives and does not own. `graph-update.sh` (PostToolUse) refreshes the
code-review-graph and reports what the refresh could not reach.

## Directory Tree

```text
.claude/hooks/
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── pre-pr-check.sh          ← the eight pre-PR quality gates, orchestrated
├── post-pr-comment.sh       ← posts a pre-pr-check run to the PR as a comment
├── context-threshold-handoff.sh ← UserPromptSubmit hook — warns at 50% context, insists at 75%
├── pre-compact-handoff.sh   ← PreCompact hook — blocks auto-compaction, steers to `handoff`
├── template-docs-readonly.sh ← PreToolUse hook — template docs are read-only in a generated project
├── graph-update.sh          ← PostToolUse hook — refresh the graph, name what it could not see
└── lib/                     ← one gate per file, sourced by pre-pr-check.sh, never run directly
    ├── check-audits.sh      ← TEMPLATE-ONLY — every audit + the shipped-file checks
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

| File                           | Purpose                                                                     |
| ------------------------------ | --------------------------------------------------------------------------- |
| `pre-pr-check.sh`              | Main quality gate script — runs all checks before PR                        |
| `post-pr-comment.sh`           | Posts check results as PR comments                                          |
| `context-threshold-handoff.sh` | UserPromptSubmit hook — measures context use, warns at 50%, insists at 75%  |
| `pre-compact-handoff.sh`       | PreCompact hook — intercepts compaction, steers to the `handoff` skill      |
| `template-docs-readonly.sh`    | PreToolUse hook — blocks writes to the shipped template documentation       |
| `graph-update.sh`              | PostToolUse hook — refreshes the graph, names the untracked files it missed |
| `lib/`                         | Individual check scripts sourced by pre-pr-check.sh — not called directly   |

## lib/ Contents

| File                 | Purpose                                               |
| -------------------- | ----------------------------------------------------- |
| `check-audits.sh`    | **Template-only** — every audit + shipped-file checks |
| `check-cloc.sh`      | Line count validation                                 |
| `check-format.sh`    | Code formatting checks                                |
| `check-lint.sh`      | Linting and style checks                              |
| `check-lockfiles.sh` | Dependency lock file validation                       |
| `check-security.sh`  | Security scanning                                     |
| `check-stubs.sh`     | Test stub validation                                  |
| `check-tests.sh`     | Test coverage and execution                           |
| `check-typecheck.sh` | basedpyright type checking                            |

## Session-continuity hooks

Two hooks guard the same rule (`.claude/CLAUDE.md` Section 2.6) at two moments. Neither can invoke a
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

## The template-documentation guard

`template-docs-readonly.sh` is registered under `hooks.PreToolUse` on `Edit|Write|NotebookEdit`.
It blocks writes to `how-to/src/TEMPLATE-GUIDE/**` and `how-to/src/TEMPLATE-TOKENS.md` — the two
things a generated project **receives** from syntek-base rather than owns. Editing one changes no
behaviour and guarantees a conflict the next `copier update`, because upstream owns those lines.

It is the Claude half of a pair; the human half is the `template-docs-readonly` pre-commit job in
`lefthook.yml`. Both stand down in syntek-base itself, where those files are the product being
maintained — the discriminator is `copier.yml`, which is `_exclude`d and so exists only here. The
hook's own header carries the rest of the reasoning, including why a `permissions.deny` entry or
`chmod 444` could not express the same split.

## The graph refresh, and what it cannot see

`graph-update.sh` is registered under `hooks.PostToolUse` on `Edit|Write|Bash`. It runs the
incremental `code-review-graph update --skip-flows`, then reports how many **untracked** files in
a parsed language sit outside the graph.

The report exists because the refresh is honest about the wrong thing: it diffs against a git
ref, so a new and unstaged file is never parsed and the update still reports success. The graph
looks continuously fresh while systematically missing exactly the files a session has just
created — and `.claude/CLAUDE.md` Section 6 makes that graph a **commit gate**. Measured
15/08/2026: an untracked `.py` file was absent after an incremental pass and present after
`git add` plus the same pass.

It reports **only when the set changes**, on the same reasoning as the 50% context tier above — a
notice repeated on every tool call is a notice nobody reads. `PostToolUse` stdout is discarded
rather than shown, so the notice is emitted as JSON `systemMessage`. The same count appears as a
non-blocking warning in `pre-pr-check.sh`, which is where missing it costs the most.

## Template mode — six checks, not eight

`pre-pr-check.sh` detects whether it is running inside **syntek-base itself** or inside a
project generated from it, and the gate is not the same in both.

The signal is `copier.yml` at the repository root. `copier.yml` lists itself in its own
`_exclude`, so a **generated project never carries it** — its presence is exact, not a
heuristic.

In the template there is no application: `uv.lock` is absent by design, `pyproject.toml`'s
`name` is an unrendered token, and `code/src/docker/.env.dev` is gitignored, so the django
image cannot be built at all. Six of the eight checks read their authoritative half from that
container. Those halves are **inapplicable — neither passing nor failing** — and reporting them
as failures is the false signal this repository audits for elsewhere.

|         | Template mode                                              | Generated project          |
| ------- | ---------------------------------------------------------- | -------------------------- |
| Runs    | cloc · format · lint · stubs · security · **audits**       | the eight below            |
| Dropped | lockfiles · typecheck · tests — container-only, no subject | —                          |
| Docker  | never started                                              | started, and drift-checked |

**`audits` is the substantive gate here**, and has no counterpart in an application: a
template's product is its structure, routing and documentation, which is exactly what
`code/src/scripts/audits/*.sh` and `.github/scripts/shipped-*.sh` read. It is scoped by
directory rather than by a list, because a list drifts silently — a new audit the PR check
never runs looks identical to one that passes.

This is **not** a softened gate. Nothing runnable is skipped, and a check with a host-side half
still blocks on it — see the negative test in `check-format.sh`'s history.

## Dual-Check Design

The lib check scripts run each tool both locally (on the host) and inside Docker via `_dc exec`.
This detects environment drift between the developer's host tools and the container.

**Local checks** (`ruff`, `pnpm exec`, `basedpyright`, `uv sync`, `pnpm audit`) use raw tool
commands because the project scripts (`syntax/format.sh`, `syntax/lint.sh`, etc.) only run
inside containers — they cannot check the host environment. That is the one place in this
repository where a raw tool call is the correct thing to write, and it is why: a script that
can only run in the container cannot detect that the container and the host disagree.
