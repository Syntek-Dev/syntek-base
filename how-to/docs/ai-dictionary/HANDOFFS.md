# Handoffs — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** {{TIMEZONE}}

Because a model is stateless, nothing a session knows survives its ending — so any work larger than a single context window has to be passed on deliberately. This section covers the vocabulary of that transfer: how a session is ended (_clearing_), how state is carried across (_handoff_, via _compaction_ or a _handoff artifact_), the documents that carry it (_spec_, _ticket_), and the distinction between the truth itself (_primary source_) and an account of it (_secondary source_) that governs whether a handoff can be trusted.

---

## Clearing

**Clearing** ends the current _session_ and starts a fresh one: the next message begins with an empty _context window_. It does not erase the saved transcript — most harnesses keep session history on disk — but the model's working state is gone, so the new session knows nothing the old one knew.

**Why it matters:** A long session accumulates noise — failed attempts, stale tool results, abandoned plans — that the model re-reads every turn and that drags quality down. Clearing removes the noise wholesale; if the next session needs decisions or progress, write a _handoff artifact_ first, then point the fresh session at it.

## Handoff

A **handoff** transfers agent _context_ from one _session_ to another with no return path. The carry mechanism varies — a written _handoff artifact_, an in-memory summary (_compaction_), and others — and it is distinct from _clearing_, which transfers nothing at all. Reasons include switching roles (planner to implementer), starting an _AFK_ run, fanning out to parallel sessions, or freeing context-window room.

**Why it matters:** "No return path" is the binding constraint — the receiving session starts with zero context and cannot ask the old one what it meant, so everything it needs must be carried explicitly and stand on its own. A bad handoff shows up as relitigation: the new session re-opens settled decisions because the carry recorded what was decided but not why.

## Primary source

A **primary source** is a source of truth in its original form — the code, the conversation transcript, the raw log, the actual API response. Not an account of the thing; the thing itself. It is the counterpart to a _secondary source_.

**Why it matters:** Primary sources are complete and current but expensive — the full file or transcript is billed as _input tokens_ and competes for _attention budget_. Reach for one when precision matters (the exact signature, the actual error, the line that throws); when an agent asserts something wrong, the fix is usually to send it from a stale account back to the primary source.

## Secondary source

A **secondary source** is an account of a _primary source_, one step removed — documentation describing code, a summary describing a transcript, a report describing search results. It is cheaper to load than the source it describes and lossy by construction: whoever wrote it decided what mattered, and whatever they dropped is invisible to a reader who has only the summary.

**Why it matters:** Much of context engineering is the manufacture of secondary sources — _compaction_ summaries, subagent reports, _handoff artifacts_, memory notes — each trading fidelity for headroom. They fail by being lossy or by drifting out of date, so a well-made one carries a _context pointer_ back to its original; where a claim matters, verify against the primary source.

## Handoff artifact

A **handoff artifact** is a document used as the carry mechanism for a _handoff_ — written to the _environment_ by one session to be read by another. _Specs_, _tickets_, and plan docs are all handoff artifacts.

**Why it matters:** The model is stateless, so decisions and half-finished plans die with the context that held them — but the environment persists, so writing important state to a file lets the next session read it back. Write it for a reader with zero context: concrete file paths, what was decided and why, what is done and what is left. Unlike _compaction_, it lives on disk where you can inspect and correct it, and one artifact can brief many parallel sessions.

## Spec

A **spec** is a _handoff artifact_ describing a multi-session piece of work — what is being built, not how each session does its share. It mutates as work progresses and is made of _tickets_.

**Why it matters:** Sessions are disposable but big work is not, so anything exceeding one _context window_ of effort needs a durable home outside the context — a repo file, a GitHub issue, an issue tracker. The spec is that home: goal, constraints, decisions so far, and the ticket list with status. Its style (PRD, design doc/RFC, or a plain `plan.md`) matters less than its role as the durable statement of intent read at the start of every session.

## Ticket

A **ticket** is a _handoff artifact_ scoping one session of work. It stands alone or hangs off a _spec_ as one of its children, and tickets can block or be blocked by sibling tickets, so the order of work falls out of a dependency graph rather than a linear plan.

**Why it matters:** The defining constraint is size — one session, completable before the work drifts out of the _smart zone_ — and it is testable: if sessions routinely degrade before finishing, the tickets are too big; if each spends most of its context on setup, too small. The dependency graph also unlocks parallelism, since independent leaf tickets can each run in their own session at once.

## Compaction

**Compaction** is a _handoff_ done in-memory: the previous session's history is summarised, and the summary seeds a fresh session. It is lossy by design — the transcript is a _primary source_, the summary a _secondary source_ — and is triggered manually by the user or automatically via _autocompact_.

**Why it matters:** When a _context window_ fills with tool results, file reads, and wrong turns, the _harness_ has the model summarise the session, discards the original history, and seeds a fresh one. The summary is model-written, so it can be prompted ("preserve the schema decisions"), and timing matters — compact at a phase boundary, after the plan settles, not mid-task. Unlike _clearing_, compaction tries to carry the essentials across.

## Autocompact

**Autocompact** is _compaction_ triggered automatically by the _harness_ when the _context window_ approaches full — often around 80%.

**Why it matters:** Autocompact is lossy at a moment you did not choose: it fires mid-task rather than at a phase boundary, letting the summary decide for itself which decisions to keep. The classic symptom is an agent that carries on confidently but has quietly forgotten a constraint set an hour ago. The defence is not to let it fire — watch the context indicator and compact manually at a natural boundary, write decisions to a _handoff artifact_ on disk, or tune the buffer.

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
