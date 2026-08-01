# The Model — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** {{TIMEZONE}}

This section covers the model itself — the frozen bundle of numbers that does one thing, next-token prediction, and nothing else. The terms move outward from what a model _is_ (parameters set by training, run at inference) to what surrounds a single request to a provider, and end on the token economics that decide what an AI-coding session actually costs. Get these straight and most "the model got worse" conversations resolve into precise, diagnosable claims.

---

## AI

**AI** is a moving label, not a technology. It doesn't name a fixed thing the way _model_ or _token_ does — it points at whatever computers can newly, impressively do, which today means large language models. By a known mechanism (the "AI effect"), once a technique works reliably it gets renamed "just statistics" or "just search" and the label slides forward to the next unsolved problem.

**Why it matters:** Any technical claim about "AI" carries a hidden timestamp and hides which part you mean — swap the word for the precise term (the _model_, the _harness_, the _agent_, the _context_) before scoping or debugging, or the discussion talks past itself.

## Model

The **model** is the _parameters_ — nothing more. It is _stateless_, does _next-token prediction_ and nothing else, and on its own cannot read files, run commands, or remember yesterday; everything agentic is the _harness_ orchestrating many predictions in a row. "Claude Opus 4.x" and "GPT-5.x" are models, shipped by _model providers_ in tiers (heavyweight for planning, lightweight for mechanical work).

**Why it matters:** "The model is bad at this" is a specific claim you should test last — the same model with a different harness or context often behaves completely differently, so check what it was given before blaming the parameters.

## Parameters

The **parameters** (also called _weights_) are the numbers inside a model — often billions — tuned during _training_. Everything the model "knows" lives in them as _parametric knowledge_; there is no database or lookup table, just numbers arranged so the calculation tends to produce useful output. They are frozen after training and used unchanged at _inference_.

**Why it matters:** Nothing you do in a _session_ changes the parameters — no correction, no codebase you show it — which is why the model is stateless and why anything project-specific must arrive via _context_, not retraining.

## Training

**Training** is the one-time, expensive process that sets a model's _parameters_ by exposing it to vast amounts of text and adjusting to improve _next-token prediction_. It is done by the _model provider_ and covers both pre-training (the bulk run) and post-training (instruction-following, safety); nothing is stored as facts, only compressed into the parameters as prediction skill.

**Why it matters:** Training ends at a point in time, giving the model a _knowledge cutoff_, and it is not a lever you have — when the model doesn't know your codebase or internal APIs, the fix is never "teach the model" but load the material into _context_.

## Inference

**Inference** is running a trained model to generate output — what happens on every _model provider request_. The _parameters_ stay fixed; the model simply does _next-token prediction_ over the _context_ it is given. It is cheap relative to _training_ but billed per _token_, and it is the dominant cost of using a model.

**Why it matters:** Nothing at inference time writes back to the parameters, so a correction made today doesn't stick tomorrow — the model is _stateless_, and cost scales with _input_ and _output tokens_ on every round trip an _agent_ makes.

## Effort

**Effort** (also "reasoning effort" or "thinking effort") is a dial, set per _model provider request_, for how much reasoning the model does before it answers. That thinking is generated at _inference_ time like everything else, emitted as _tokens_ and billed as _output tokens_ even when the _harness_ hides them. Most harnesses expose a small ladder — low (mechanical edits), medium (everyday coding), high (tricky bugs and design), max (the hardest, costly-to-unwind problems).

**Why it matters:** Match effort to the task, not the _session_ — too low on a hard problem yields a confident, shallow, wrong answer; max on a one-line rename just wastes time and money.

## Token

A **token** is the atomic unit a model reads and writes — roughly word-sized but not exactly, since common words are one token and rare or long ones split into several. Text becomes tokens via a fixed-vocabulary tokeniser learned before _training_; the model never sees characters. A rule of thumb: a token is about three-quarters of an English word, so a thousand tokens is roughly 750 words.

**Why it matters:** Tokens are the unit everything is measured in — _context window_ size, cost (_input_ and _output tokens_ billed separately), and speed (tokens per second) — and unusual strings like hashes or base64 split into many tokens, so a small-looking file can eat a surprising share of the window.

## Next-token prediction

**Next-token prediction** is what the model actually does: given a _context_, it runs the tokens through the _parameters_ to get a probability for every token in the vocabulary, samples one, appends it, and runs again. Every output — a sentence, a _tool call_, a thousand-line file — is built one token at a time. The model has no other mode of operation.

**Why it matters:** The mechanism explains the strange behaviour — the model checks only whether a token is _likely_, never _true_ (the root of _hallucination_), the sampling step makes output _non-deterministic_, and one-token-at-a-time generation puts a floor on how fast any _agent_ can work.

## Non-determinism

**Non-determinism** means the same input can produce different output. Run a model twice with identical _context_ and you may get two different answers, because _inference_ samples from a probability distribution (usually with deliberate randomness), and one differently-sampled token early changes everything after it. Provider-side batching on shared hardware adds tiny floating-point variation on top; there is no setting that removes it.

**Why it matters:** Expect a spread of quality on the same task — retrying is a legitimate strategy (a fresh draw may land better) and _automated checks_ matter more, since you can't test an agent once and trust it to repeat; resist reading a string of bad runs as "the model got worse this week".

## Model provider

The **model provider** is whatever serves a model for _inference_ — usually a remote service (Anthropic, OpenAI, Google), but can be local (Ollama, LM Studio, llama.cpp) on your own machine. The _harness_ doesn't run the model; it asks a provider to. The provider owns the hardware where the _parameters_ live and sets commercial terms — per-token pricing, _prefix cache_ discounts, model availability. Note the provider and the model's maker can differ (Bedrock, Vertex, OpenRouter serve others' models).

**Why it matters:** A whole class of problems misattributed to the model or harness — rate limits, degraded capacity, outages — lives with the provider, so check its status page first when an _agent_ stalls or errors every _turn_; a local provider trades frontier capability for offline control.

## Harness

The **harness** is everything around the model that turns it into an _agent_: _tools_, _system prompt_, _context-window_ management, permissions, and hooks. The model only takes text in and produces text out; the harness assembles the _context_ for each _model provider request_, executes _tool calls_, feeds _tool results_ back, stores _session_ history, asks permission, and decides when to _compact_. Claude Code, Cursor, and Codex CLI are harnesses — as is Claude.ai, a chat harness rather than a coding one.

**Why it matters:** When behaviour differs between two products or between yesterday and today, the harness is often the variable, not the model — and it is where most configuration lives (_AGENTS.md_ files, permissions, hooks are all instructions to the harness).

## Model provider request

A **model provider request** is one round-trip from the _harness_ to the _model provider_: the harness sends the current _context_, the provider returns one response (a _tool call_ or a final answer). Because the _model_ is _stateless_, each request re-sends everything — _system prompt_, full conversation, every _tool result_ — so the provider keeps nothing between requests. A single _turn_ ("fix the failing test") can fan out into many requests, one per tool result.

**Why it matters:** The request is the unit of billing, so cost is proportional to the number of requests times the context each carries, not to the size of your message — when tokens vanish, count the requests, not the turns, and lean on the _prefix cache_ to make the repetition affordable.

## Input tokens

**Input tokens** are the _tokens_ the _harness_ sends on each _model provider request_ — the _system prompt_, conversation history, _tool results_, everything the model reads before it writes. They are billed at a lower rate than _output tokens_ because they cost less compute to process. Because the model is _stateless_, each _turn_ re-sends the entire _session_ as input, so turn fifty's request carries the previous forty-nine.

**Why it matters:** In AI coding, input tokens make up most of the bill — a request may produce a few hundred output tokens while re-sending a hundred thousand tokens of history — so the levers are the _prefix cache_ and shrinking what gets re-sent by _clearing_ or _compacting_ between tasks.

## Output tokens

**Output tokens** are the tokens the _model_ generates back, billed at a higher rate than _input tokens_ — commonly around five times — since they cost more compute to produce. Everything the model writes counts: prose, code, _tool calls_, and any extended thinking it does before answering (reasoning tokens are billed as output even when the _harness_ doesn't show them, and raising _effort_ spends more of them).

**Why it matters:** Output sets the pace — the model reads input quickly but writes one token at a time, so a slow _turn_ almost always means a long answer is coming, and an agent that rewrites whole files instead of patching burns credit fast at roughly five times the input rate.

## Prefix cache

The **prefix cache** is the _provider_-side store that lets consecutive _model provider requests_ skip re-processing a shared prefix. When the start of a request matches a recent one — same _system prompt_, same history up to some point — the provider reuses its prior work and bills those _tokens_ as _cache tokens_ at a much lower rate. It pays off because sessions grow append-only: the long beginning is processed once, and the request picks up where the prefix ends.

**Why it matters:** The cache breaks at the first changed token, so anything that mutates the prefix — a harness injecting the current time, reordering files — makes every following request bill at full rate; caches also expire after minutes of inactivity, so requests after a long pause cost more.

## Cache tokens

**Cache tokens** are _input tokens_ the _provider_ has already processed in an identical prefix via its _prefix cache_, billed at a much lower rate — often a tenth of the input rate or less. They are the lever that makes long _sessions_ affordable: without them, a stateless _model_ re-sending fifty turns of history would pay full rate on all of it, every request. The cache matches _exact_ prefixes, so an edit earlier in the conversation breaks the match from that point onward.

**Why it matters:** When a session's cost jumps without an obvious cause, compare cache tokens to input tokens in the usage report — a broken cache (a reordered system prompt, a shifting timestamp, an expired entry) shows up there first, with everything after the break re-paid at full input rate.

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
