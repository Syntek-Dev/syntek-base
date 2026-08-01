# Tools & Environment — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** {{TIMEZONE}}

These terms describe the boundary between the model and the world it acts on. An agent never touches the environment directly — it perceives through tool results and changes through tool calls, and the harness gates every one of those actions through permissions, modes, and sandboxes. Get this layer right and the agent works safely in a repository far larger than its context window.

---

## Environment

The world the _agent_ acts on — everything outside the _harness_ that it perceives through _tool results_ and changes through _tool calls_. A **filesystem** is the most common kind, but a database, remote API, or browser session can each be an environment too. It is also the only layer that is always _stateful_: a session's context is gone when the session ends, but files written to the environment persist for the next session to read.

**Why it matters:** The agent only knows the environment through snapshots taken at read time, so a file that changes after it was read produces confident-but-wrong reasoning until something forces a re-read; and anything the agent must still know tomorrow has to be written back to the environment.

## Filesystem

A tree of files and directories the agent reads from, writes to, and executes within — the default _environment_ for a coding agent. `AGENTS.md`, _skills_, source code, and _tool_ configs all live here, and nothing on disk enters the _context window_ until a _tool call_ loads it.

**Why it matters:** This is what lets an agent work in a repository far larger than its context window — the filesystem holds everything, the context holds only what the current task has read — and it is the shared workspace where you review the agent's edits in git.

## Tool

A function the _harness_ exposes for the agent to call — Read, Write, Bash, Search. Tools are the only way an agent perceives and acts on the _environment_. Each tool is defined by a name, a description, and a parameter schema, all sent to the _model_ on every request.

**Why it matters:** The tool list bounds what the agent can do — but every definition occupies _context_ on every request, and many similarly-described tools make the model worse at picking the right one, so scope the set to the task.

## Tool call

The _model_'s output naming a _tool_ and its arguments — just structured text that does nothing on its own until the _harness_ reads it and executes. One _turn_ of agent work is usually many of these round trips chained together.

**Why it matters:** Because the call is produced by _next-token prediction_ like any output, it can be plausibly wrong — a path that doesn't exist, a flag the command lacks — and the harness runs what was written, not what was meant, so a mistyped path edits the wrong file rather than erroring gracefully.

## Tool result

What the _harness_ sends back after executing a _tool call_ — the file contents, the command output, or the error. It is the agent's only view of the _environment_, and it stays in the _context_ for the rest of the _session_.

**Why it matters:** Results are usually the bulk of a coding session's context and can push it toward the edge of the _context window_ faster than the conversation itself; and because the model sees nothing but the result, a truncated or error result silently corrupts its picture of your system.

## MCP

**Model Context Protocol** — a protocol for plugging external tool servers into a _harness_, giving an agent _tools_ beyond what the harness ships with. Write an integration once as a server (Linear, Slack, a database) and any MCP-compatible harness can use it. The agent never "calls MCP"; it calls a tool the harness happened to get from an MCP server.

**Why it matters:** Every tool a server advertises arrives as a definition that spends _context_ and _attention budget_ up front, so enable only the servers a project actually needs — or rely on tool search, which loads a definition only when the agent reaches for it.

## Permission request

What the _harness_ shows the user before executing a _tool call_ that isn't pre-approved — the mechanism for putting a human in the loop. Approve and it runs; deny and the harness reports the denial back to the model as a _tool result_.

**Why it matters:** A denial is a steering point — attach a message ("use the migration script instead") and it lands exactly when the model is deciding what to do next — but every request is a synchronous wait on you, so an agent that prompts constantly cannot be left to run _AFK_.

## Permission mode

The permission-gating slice of an _agent mode_: which _tool calls_ run automatically and which trigger a _permission request_. Harnesses ship a ladder — read-only/plan, default (reads auto, writes ask), auto-edit, and full-auto ("YOLO").

**Why it matters:** Choosing a rung trades safety against interruption, and both ends bite — too tight and you rubber-stamp approvals until they stop meaning anything; too loose and the agent runs commands you'd have wanted to see first. The loose end is most defensible inside a _sandbox_.

## Agent mode

A preset that bundles a _permission mode_ with behavioural instructions injected into the _system prompt_ — plan mode, accept-edits, bypass permissions (colloquially **YOLO mode**). It can flip mid-_session_ at no cost, continuing exactly where the conversation was with new permissions and new instructions.

**Why it matters:** The bundling is the point — a bare gate produces an agent that wants to edit but can't, whereas the injected steer removes the want, so gate and instruction point the same direction. Change mode as your trust changes over the course of a task.

## Sandbox

An isolated _environment_ the agent runs inside — a container, VM, ephemeral _filesystem_, or restricted-permission shell — that limits the blast radius of its actions. Isolation comes in grades, from an OS-level restricted shell up to a separate cloud machine. It is the safety substrate that makes _AFK_ runs practical.

**Why it matters:** A sandbox and a _permission mode_ solve the same problem from opposite ends — one contains an action, the other asks before it runs — so stronger isolation buys fewer interruptions; but no sandbox contains actions that leave it legitimately, like a push with your git credentials or a call to a production API.

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
