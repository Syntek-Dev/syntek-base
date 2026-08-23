# .claude/hooks

Pre-PR quality gate hooks, two session-continuity hooks, and one write guard. `pre-pr-check.sh`
runs 8 quality gates before a PR is marked ready (9 in this template); results are posted by
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
├── pre-pr-check.sh          ← the eight pre-PR quality gates (nine here), orchestrated
├── post-pr-comment.sh       ← posts a pre-pr-check run to the PR as a comment
├── context-threshold-handoff.sh ← UserPromptSubmit hook — warns at 50% context, insists at 75%
├── pre-compact-handoff.sh   ← PreCompact hook — blocks auto-compaction, steers to `handoff`
├── template-docs-readonly.sh ← PreToolUse hook — template docs are read-only in a generated project
├── graph-update.sh          ← PostToolUse hook — refresh the graph, name what it could not see
└── lib/                     ← one gate per file, sourced by pre-pr-check.sh, never run directly
    ├── check-audits.sh      ← TEMPLATE-ONLY — both script directories, minus a declared exclusion
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

| File                 | Purpose                                                                                                                     |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `check-audits.sh`    | **Template-only** — the audits + `.github/scripts/`, each minus a declared exclusion <!-- doc-references: template-only --> |
| `check-cloc.sh`      | Line count validation                                                                                                       |
| `check-format.sh`    | Code formatting checks                                                                                                      |
| `check-lint.sh`      | Linting and style checks                                                                                                    |
| `check-lockfiles.sh` | Dependency lock file validation                                                                                             |
| `check-security.sh`  | Security scanning                                                                                                           |
| `check-stubs.sh`     | Test stub validation                                                                                                        |
| `check-tests.sh`     | Test coverage and execution                                                                                                 |
| `check-typecheck.sh` | basedpyright type checking                                                                                                  |

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
maintained — the discriminator is `copier.yml`, which is `_exclude`d and so exists only here. The <!-- doc-references: template-only -->
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

## Template mode — nine checks, not eight

`pre-pr-check.sh` detects whether it is running inside **syntek-base itself** or inside a
project generated from it, and the gate is not the same in both. **The difference is an
addition rather than a subtraction** (16/08/2026).

The signal is `copier.yml` at the repository root. `copier.yml` lists itself in its own <!-- doc-references: template-only -->
`_exclude`, so a **generated project never carries it** — its presence is exact, not a
heuristic.

Template mode used to drop lockfiles, typecheck and tests, because each reads its
authoritative half from the django container and that container could not be built here. That
premise died when `uv.lock` was committed. All three now run, and the image builds, so all
eight checks have a subject. `code/src/docker/.env.dev` being gitignored does not reinstate
the exemption: the hook falls back to the committed `.env.dev.example`, every value in which
has a working default, so a fresh clone runs the gate before copying anything.

|        | Template mode                      | Generated project          |
| ------ | ---------------------------------- | -------------------------- |
| Runs   | the eight below, **plus `audits`** | the eight below            |
| Docker | started, and drift-checked         | started, and drift-checked |

The eight, in the order they run: cloc · lockfiles · format · lint · stubs · typecheck ·
tests · security. Template mode appends `audits` as the ninth.

**`audits` is the one genuine asymmetry left**, and has no counterpart in an application: a
template's product is its structure, routing and documentation, which is exactly what
`code/src/scripts/audits/*.sh` and `.github/scripts/*.sh` read. Both are scoped by
**directory**, so a newly added script runs by default — never by an inclusion list, which
drifts silently and in the dangerous direction: a new audit the PR check never runs looks
identical to one that passes.

The second scope was an inclusion list until 16/08/2026, and it drifted exactly as predicted:
it read `shipped-*.sh`, covering two of the four scripts then present and silently omitting the
two that answer whether the template can be generated at all.

**Each scope now names scripts out of its directory, and that is a different mechanism rather
than the same one in disguise.** An exclusion list drifts the safe way round: a script added
tomorrow is not named in it, so it runs, and if it should not have it fails loudly on its first
pass. Three audits are named out — `cloc.sh` and `security.sh` because gates `[1/8]` and `[8/8]`
already own them and running them twice reports one defect as two, `dependency-drift.sh` because
it is a `copier update` helper that requires `--incoming DIR`. One integrity check is named out
too: `shipped-artefacts.sh` asserts on a tree `copier copy` produced and exits `2` bare, so widening
the second scope to the whole directory left the gate unable to pass at all. Everything else in
both directories runs, and **no count of either is written here** — the run prints its own, and
a number copied into a document goes stale the next time a script is added.

That leaves an exclusion list two silent failure modes — an entry matching no script, and an
owner that has been deleted or has stopped invoking it — and `check-audits.sh` checks both
before either loop runs, failing the gate rather than stepping over a scan nobody is running
(`code/docs/GATE-REPORTING.md`). The integrity owner is a CI job rather than a lib check, so the
guard opens `.github/workflows/audit-template.yml` and requires it to still name the script. <!-- doc-references: template-only -->

**A scope that ran nothing is a finding, not a pass.** A glob over a missing directory, or over
one holding only excluded scripts, yields no iterations and no failures — reaching the verdict a
full clean run over the whole template would. Each loop counts what it ran and a zero is
reported, so every count in the summary can be traced to an execution.

This is **not** a softened gate, and the exclusions do not make it one: the two audits named as
owned run as gates `[1/8]` and `[8/8]`, `development/template-update.sh` is what passes the
third an incoming tree, and `shipped-artefacts.sh` runs in `audit-template.yml`'s
`[3/4] Template Generation` job — which fires on a push to any branch and on any pull request
into `main`, `staging`, `dev` or `testing`. A check with a host-side half still blocks on it —
see the negative test in `check-format.sh`'s history.

## Dual-Check Design

The lib check scripts run each tool both locally (on the host) and inside Docker via `_dc exec`.
This detects environment drift between the developer's host tools and the container.

**Local checks** (`ruff`, `pnpm exec`, `basedpyright`, `uv sync`, `pnpm audit`) use raw tool
commands because the project scripts (`syntax/format.sh`, `syntax/lint.sh`, etc.) only run
inside containers — they cannot check the host environment. That is the one place in this
repository where a raw tool call is the correct thing to write, and it is why: a script that
can only run in the container cannot detect that the container and the host disagree.
