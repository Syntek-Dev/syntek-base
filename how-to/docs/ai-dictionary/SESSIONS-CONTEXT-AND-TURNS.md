# Sessions, Context Windows & Turns — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** {{TIMEZONE}}

These terms describe how a fundamentally forgetful model is wrapped into something that feels continuous. A stateless _model_ is harnessed into a stateful _agent_; a _session_ slowly fills a finite _context window_; and each _turn_ bounds one exchange within it. Getting these distinctions right is the difference between blaming the model for "forgetting" and knowing exactly where to write something down so it persists.

---

## Stateless

**Stateless** means carrying no information forward. The _model_ is stateless across _model provider requests_ — each request resends the full _context window_, because the model has no other way to see anything. An _agent_ is stateless across _sessions_ by default: a new session starts empty, with no trace of prior ones.

**Why it matters:** The model is permanently stateless — its _parameters_ are frozen after _training_, so it never learns from your corrections; the continuity you feel is the _harness_ re-reading the transcript, not memory. If you want something remembered across sessions, you must write it down somewhere the agent reloads it (an _AGENTS.md_ file, a _memory system_, a _handoff artifact_).

## Context

**Context** is the relevant information the _agent_ has access to right now — not the raw tokens the model sees (that is the _context window_), not the running history (that is the _session_), but _what the agent knows that is pertinent to the task_. "Loading something into context" makes it part of that set; "context engineering" is the discipline of curating it.

**Why it matters:** Context is a measure of quality, not quantity — a nearly full window can hold poor context, and a near-empty one can hold excellent context. When the agent invents an API or contradicts a decision, the first question is what was in context when it did; the fix is curation, not more tokens.

## Context window

The **context window** is everything the _model_ sees on each _model provider request_ — a single, finite, model-specific sequence of _tokens_ holding the _system prompt_, the conversation so far, and every _tool result_ fed back in. If something is in that sequence the model can use it; if it is not, the model does not know it exists.

**Why it matters:** Finite means it fills up and everything competes — each token you load is one less for the rest, and unneeded content still drains the model's _attention_. Treat the window as a budget: load what the task needs and leave the rest behind a _tool call_. It is working state, not memory, and does not persist across sessions.

## Stateful

**Stateful** means carrying information forward. A _session_ is stateful across _turns_ — _context_ accumulates as it runs — and an _agent_ can be made stateful across sessions by adding a _memory system_ that persists information into the _environment_ and reloads it later. The _model_ is never stateful; any apparent continuity is the _harness_ re-feeding context. Counterpart to _stateless_.

**Why it matters:** Every layer's statefulness is built by re-reading something stored a layer below — the session feels continuous because the harness re-sends the message history to the stateless model. State is not always wanted, though: a wrong assumption made early is carried forward too, which is why _clearing_ deliberately throws session state away and restarts from what is written down.

## Agent

An **agent** is a _model_ _harnessed_ with _tools_, a _system prompt_, and a _context window_, that takes _turns_ with a user. It is what you actually talk to — the model in motion, configured for a purpose. Claude Code is an agent; Cursor is an agent; claude.ai is an agent.

**Why it matters:** The agent is the unit you address and delegate to — the "it" in "it broke the build again" — and it is the model plus harness treated as one actor. Two agents can share the same model but behave completely differently because their harnesses (and system prompts) differ, so name the agent, not vaguely "the AI".

## System prompt

The **system prompt** is the instructions the _harness_ prepends to every _model provider request_ — the _agent_'s standing brief: who it is, how to behave, which _tools_ it can call, what conventions to follow. It is written by the harness vendor, not by you, and is usually stable across a _session_.

**Why it matters:** In coding harnesses it is large — often tens of thousands of _tokens_ paid as _input tokens_ every _turn_ — and because it is identical each request it forms the start of the _prefix cache_. Models are trained to prioritise it over user messages, so when an agent insists on a convention you never asked for, it is usually obeying its system prompt and your message is losing the argument.

## Session

A **session** is one bounded run of interaction with an _agent_. It starts empty, accumulates messages, _tool results_, and files read, and ends when _cleared_, closed, or _compacted_ into a fresh session. The session is what _fills_ the _context window_: if the window is the box, the session is the stuff slowly filling it.

**Why it matters:** The session's message history is the agent's working memory — the stateless _model_ appears to remember only because that history is re-sent each request — and it ends when the session ends; only the _filesystem_ survives. Because everything in a session colours every later answer, keep one task per session, and hand off or compact once it bloats rather than pushing through.

## Turn

A **turn** is one user message plus everything the _agent_ does in response, up until it yields back to the user. It contains one or more _model provider requests_ — many if the agent chains _tool calls_. The hierarchy is _session_ **> turn > model provider request**; a clarifying question closes the turn and your reply opens the next.

**Why it matters:** A turn's length is the agent's decision, not yours — a turn can be one sentence or twenty minutes of editing and testing. That is what makes _AFK_ work possible and also where unsupervised drift happens; since the gaps between turns are where you steer, the fix for repeatedly-wrong outcomes is to ask for smaller turns (a plan first, one step at a time).

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
