# Memory and Steering — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** <%TIMEZONE%>

A model is stateless, so continuity and direction have to be engineered around it. These terms cover the two sides of that: persisting what an agent learns and standing instructions that steer it (_Memory system_, _AGENTS.md_), and the discipline of loading detail only when a task needs it rather than paying for it every turn (_Progressive disclosure_, _Context pointer_, _Skill_, _Subagent_).

---

## Memory system

A **memory system** attempts to make a _stateless_ _agent_ appear _stateful_ across _sessions_. It has two halves: a write path that records what the agent learns — a stated preference, a project fact — as files in the _environment_ during a session, and a read path that reloads those files (or an index of them) into the _context window_ at the start of later sessions. The _model_ never remembers; the memory layer fakes continuity.

**Why it matters:** Memories are _secondary sources_ and they drift — a fact recorded in March loads with equal confidence in June, after the project has moved on — so a memory system needs pruning, and most load only a one-line index, leaving the bodies behind _context pointers_.

## AGENTS.md

**AGENTS.md** is a file in the _environment_ that the _harness_ loads into the _context window_ at _session_ start — the project's standing brief to the _agent_ (Claude Code's variant is CLAUDE.md). Suitable content is whatever the agent cannot derive from the code: build and test commands, non-obvious conventions, hard constraints. Short and declarative — a brief, not documentation.

**Why it matters:** Everything in it is always loaded, so it costs _tokens_ every _turn_ and a bloated file dilutes itself — the more instructions in context, the less reliably the model follows any one of them. Keep it to lines that apply everywhere; push anything that should be _progressively disclosed_ behind a _skill_ or a _context pointer_.

## Progressive disclosure

**Progressive disclosure** means loading only the _context_ an agent needs right now, with _context pointers_ to the rest. It is borrowed from UI design, where it means showing only the controls relevant to the current task and hiding the rest behind a click. The always-loaded layer stays small — a sentence per topic and a pointer to where the detail lives — so the agent reads the style guide only when writing a component, the deploy runbook only when deploying.

**Why it matters:** Context is a cost twice over — every _token_ loaded up front is billed as _input tokens_ every _turn_ and spends _attention budget_ whether needed or not. An overstuffed brief makes the agent worse at everything in it; the tell is an agent that ignores rules you know are in context because they are buried.

## Context pointer

A **context pointer** is a mention in one document that points to another, so the agent can pull it into the _context window_ only when the task calls for it. It is the unit that _progressive disclosure_ is built from: one line in context, standing in for a document that might be thousands of _tokens_ but costs nothing until the agent follows it with a _tool call_.

**Why it matters:** A pointer needs a stable path and enough description for the agent to know when following it is worth it — a bare path gets skipped by the session that needed it. A pointer can also tie a _secondary source_ back to its _primary source_ (a summary naming its original transcript), making the summary's lossiness recoverable rather than final.

## Skill

A **skill** is a teachable capability bundled as a unit — instructions and, optionally, scripts and reference material for doing one task well — kept in the _environment_ until a _context pointer_ pulls it into the _context window_ for the task at hand. It is an open standard (agentskills.io): a folder with a `SKILL.md` of metadata plus instructions. Only the name and description sit in _context_ by default; the rest loads when the agent's task matches.

**Why it matters:** Unlike _AGENTS.md_, which loads into every _session_ regardless of task, a skill costs almost nothing until triggered — put the deploy runbook or style guide here and it burns _tokens_ only when that work actually comes up. (Distinct from a _tool_, which the agent _calls_; a skill is instructions it _reads_.)

## Subagent

A **subagent** is an _agent_ spawned by another agent via a _tool call_, running in its own _session_ with its own _context window_ and reporting a single _tool result_ back. It cannot spawn further subagents — the tree is one level deep — and it differs from a _handoff_ in that the parent specifically expects a return.

**Why it matters:** It isolates noisy work — a broad search or long file-reading expedition fills a disposable window instead of the parent's _context_, and only the final report lands back. That report is a _secondary source_, so anything it omits is invisible to the parent; subagents can also fan out concurrently over independent pieces of work.

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
