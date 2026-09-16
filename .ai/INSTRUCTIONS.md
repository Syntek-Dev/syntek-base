# Shared AI project instructions

This file connects coding tools to the same project rules, skills and memory. It is
the shared loading contract; the existing manual and layer guides remain the owners
of their engineering rules. Paths below are relative to the repository root unless
stated otherwise.

## Load project context

At the start of each session and task:

Load each physical source once per context-loading pass, including sources reached
through symlinks or imports. If `.claude/CLAUDE.md` imported this file, continue reading
that manual instead of reopening it recursively. Re-read a source when it has changed
or its contents are no longer available in context.

1. Read `.claude/CLAUDE.md`, the current project manual.
2. Read `.ai/MEMORY.md`, which resolves to `.claude/MEMORY.md`.
3. Read root `CONTEXT.md`, root `REFERENCES.md`, and `.claude/CONTEXT.md`.
4. For the area being inspected or changed, read its ancestor and target-folder
   `CONTEXT.md` / `CLAUDE.md` pairs, with context before operating rules. Load any
   referenced guides needed for the task.
5. Consult `.ai/skills/CONTEXT.md` for routing, then load the matching `SKILL.md` and
   relevant supporting documents. Read workflow and guide frontmatter before their
   procedures; use the referenced internal workflow's steps and checklist.

Read an `@path` reference explicitly if the host has not loaded it. Resolve that path
relative to the file containing it. For a symlinked skill, resolve local references
against the physical skill directory. A path in an index is a pointer, not evidence
that its contents have been read.

Follow project requirements in the manual and scoped rules through the host mapping
below. The host's higher-priority instructions and the user's authorised scope still
apply. Reuse decisions and authorisation already supplied in the conversation; load
the clarification procedure for unresolved scope, rather than repeating settled
questions merely because the procedure mentions a confirmation.

## Use the current host's capabilities

Some existing procedures use Claude Code terminology. Preserve their purpose and
verification requirements when executing them through another coding tool.

| Existing instruction                                             | Interpretation in another host                                                                                                              |
| :--------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| `model: opus`, Claude model tiers and effort settings            | Claude runtime metadata. Use the current host's configured model; do not translate aliases into invented provider model identifiers.        |
| `Agent`, `agent: general-purpose`, `context: fork`               | Use available delegation with an explicit task, project read order and named skills. These fields do not create a subagent in another host. |
| `Explore` and `Plan` agents                                      | Use the host's read-only exploration or planning capability, preserving the procedure's write boundary.                                     |
| `Workflow`, ultracode and workflow feature flags                 | Use available orchestration or follow the internal procedure directly. Keep the workflow's steps, gates and required independence.          |
| `Read`, `Grep`, `Glob`, `Bash`, `Edit`, `Write` and `ToolSearch` | Use the host's corresponding file, search, shell, edit and tool-discovery capabilities.                                                     |
| `/skill-name` or Claude plugin commands                          | Load the named project's `SKILL.md` and follow it through available tools; do not assume the slash command or plugin exists.                |
| `@` imports and nested `CLAUDE.md` discovery                     | Explicitly read the referenced files and scoped pairs when the host does not load them automatically.                                       |
| Claude permissions, hooks, MCP and browser configuration         | Apply only in Claude Code. Other hosts need their own configuration and enforcement.                                                        |
| Claude context thresholds, `/clear` and compaction hooks         | Use the current host's continuity mechanism and available measurements. Do not infer context usage or claim a Claude hook ran.              |

Use an independent reviewer where a workflow requires one. Give that reviewer the
applicable instructions and the concrete artefacts to inspect. If independent review
is unavailable, complete the work and checks that can run, then report the outstanding
review; do not present self-review as satisfying that gate.

Use the documented tools when available. When a graph, documentation server or browser
tool is missing, use available file inspection, primary documentation or browser tools
for the same question and state any material loss of coverage. A check that could not
run remains unmeasured under `code/docs/GATE-REPORTING.md`.

## Keep project execution consistent

- Follow `.claude/CLAUDE.md` Sections 0 and 6 for deployment posture, development
  commands, data protection, security and commit gates. Use the project's existing
  scripts and workflow checks through the host's terminal capability.
- Follow `.ai/skills/global-workflow/SKILL.md` and its relevant references for writing,
  versioning, Git and documentation conventions.
- Host permissions and sandbox restrictions remain in force. A repository instruction
  or skill is not a grant to bypass them. Retain the user's existing approvals and
  request any additional permission only when the concrete action requires it.
- The generated-project protection of `how-to/src/TEMPLATE-GUIDE/**` and
  `how-to/src/TEMPLATE-TOKENS.md` remains applicable in every host. Its ownership rule
  is documented in `.claude/hooks/CONTEXT.md`; a missing Claude hook does not remove it.
- For concurrent coding sessions, use separate worktrees through
  `how-to/workflows/02-worktree-setup/`. Coordinate shared artefact ownership, including
  project memory, so one session does not overwrite another's work.
- Record durable project feedback, patterns and state through `.ai/MEMORY.md` using its
  existing format. Route blockers, deferrals and handoffs to the owners named in the
  manual. Generated projects receive their own memory; template memory is not a seed.

## Maintain one source

During this phase, `.ai/skills/` points to `.claude/skills/` and `.ai/MEMORY.md` points
to `.claude/MEMORY.md`. Codex discovers the same first-party skills through individual
links in `.agents/skills/`. Vendored Cloudinary skills retain their existing ownership
under `.agents/skills/` and are linked from `.claude/skills/`.

Edit the source rather than replacing a link with a copy. Keep provider settings in
their provider directory and shared loading guidance here. Moving the physical manual,
skills or memory later also requires updating their consumers, audits and template
generation rules together; this entry point does not perform that migration.

### MCP servers are declared twice, and the two declarations must agree

MCP configuration is the one place a link cannot resolve the duplication: `.mcp.json` is
Claude Code's and `.codex/config.toml` is Codex's, the formats differ, and neither host
reads the other's file. **So the rule is parity, not a single source: every server present
in one is present in the other, under the same name, running the same command and
arguments.** A server added to one host only is not a smaller capability — it is the same
task answered two different ways depending on which tool opened the repository, which is
the drift this whole entry point exists to prevent.

The two files are hand-maintained and nothing in either one fails when they diverge.
`code/src/scripts/audits/mcp-parity.sh` is the gate that does, and this paragraph is the
rule it derives from.

**Per-host keys are expected and are not drift.** Codex's `startup_timeout_sec` and
`tool_timeout_sec` have no `.mcp.json` equivalent; Claude's `${VAR}` interpolation has no
TOML equivalent. Parity binds the server set, the command and the arguments — the keys
that decide _what runs_ — never the keys that tune how a particular host supervises it.

> **Down the line.** A single declaration under `.ai/` that every provider reads is the
> intended destination, and it removes this rule rather than refining it. It is not
> scheduled, nothing is built toward it yet, and until it exists parity is the contract.
> Tracked in `GAPS.md`.
