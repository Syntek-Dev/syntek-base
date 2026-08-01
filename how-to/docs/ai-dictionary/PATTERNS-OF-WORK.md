# Patterns of Work — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** {{TIMEZONE}}

These terms name the recurring shapes of working with a coding agent: how you divide
your attention (_Human-in-the-loop_ versus _AFK_), how the work gets verified (_automated
checks_, _automated review_, _human review_ — or none of them, in _vibe coding_), how a
design is sharpened before code exists (_design concept_, _grilling_, _prototyping_), and
how well a codebase serves each audience (_DX_ for humans, _AX_ for agents). Together they
give you a vocabulary for the choices that decide whether an agent's throughput becomes
leverage or liability.

---

## Human-in-the-loop

**Human-in-the-loop** (HITL) is a working pattern where one or more humans pair with the
agent during a _session_ — reviewing, redirecting, or collaborating in real time. The human
is present and engaged, not merely gating individual actions. The contrast is _AFK_ work,
where the agent runs unattended and you judge the result afterwards.

**Why it matters:** Staying in the loop catches problems while they are still cheap — you
redirect the agent in one sentence before twenty minutes of confident work compounds on the
mistake — but it spends your attention, the scarce resource, so reserve it for ambiguous,
irreversible, or hard-to-verify work.

## AFK

**AFK** (away from keyboard) is a working pattern where you kick off a _session_ and leave
the agent to run unattended. It is the throughput multiplier of _AI_ coding: many AFK
sessions can run in parallel while you sleep or work on something else. It usually requires
a permissive _permission mode_ plus _sandboxing_ to be safe.

**Why it matters:** Because you give no input during the run, the agent resolves ambiguity
by guessing — so give input before (a _grilling_ session, a _spec_) and after (a reviewable
PR, not a merge), and lean on _automated checks_ to stand in for the attention you are not
giving. This is also where _AX_ matters most.

## Automated check

An **automated check** is a deterministic verification that runs in the _environment_ —
tests, type checks, lints, build, pre-commit hooks. Pass or fail, no judgement. It is the
signal an agent can self-correct from without involving anyone. A flaky test is a broken
check, not a non-check; checks are deterministic by design.

**Why it matters:** The failure output lands in the agent's _context window_ with enough
detail to fix and re-run, closing a self-correction loop with no human in it — which is a
large part of a codebase's _AX_. But a check only catches what it asserts; the
judgement-shaped gaps are what _automated review_ and _human review_ are for.

## Automated review

**Automated review** is an agent reviewing another agent's work, often with a different
_model_ or _system prompt_. It is non-deterministic: it forms a judgement. It can run
pre-merge on a PR, post-hoc on commit history, or mid-session as a _subagent_.

**Why it matters:** A reviewer with a fresh _context window_ has none of the working
agent's attachment to its own conclusions, so it reads the diff the way a stranger would.
Sitting between deterministic _automated checks_ and expensive _human review_, it catches
judgement-shaped problems at machine cost — treat it as a filter that raises the floor, not
a gate that replaces a human.

## Human review

**Human review** is the user reading the code the agent produced and forming a judgement on
it. Reading the diff or changed files counts; reading the agent's _description_ of what it
did does not — the narration is a _secondary source_ written by the party being reviewed,
whereas the diff is the _primary source_.

**Why it matters:** Agents raise the volume of code, so review becomes the bottleneck;
reserve human review for what only you can judge — whether this is the right change, whether
it fits the codebase, whether it should exist — and place the checkpoint early, since a plan
or small diff costs minutes where a finished _AFK_ branch costs far more.

## Vibe coding

**Vibe coding** is a working pattern where the user accepts the agent's code without _human
review_. The diff is treated as opaque — what matters is whether the program behaves, not
what is inside. _Automated checks_ and _automated review_ may still run; the term is silent
on both, and names the review stance, not the resulting quality. (Coined by Andrej Karpathy
in early 2025.)

**Why it matters:** Dropping the slowest step buys speed, a reasonable trade for
short-lived, low-stakes code — _prototypes_, one-off scripts — but the cost arrives later:
anything behaviour does not surface, like a secret written to logs or quietly wrong data
handling, ships unseen into a codebase nobody has read.

## Design concept

A **design concept** is the shared understanding of what is being built, held in common
between user and agent but separate from any asset. The conversation, the _handoff
artefacts_, and the code are all assets that try to capture it, but none of them are it
(Brooks' term, _The Design of Design_).

**Why it matters:** The familiar frustration — the agent writes exactly what you asked for
and it is still wrong — usually means the design concept was not finished in your own head,
so the agent filled the silences with assumptions. Keep talking (deliberately, via
_grilling_) until it is whole and shared before writing a _spec_, or you just capture the
misalignment in a more durable form.

## Grilling

**Grilling** is a technique for developing a _design concept_ with an agent: the agent
interviews the user Socratically, one decision at a time, proposing a recommended answer for
each. It slows the rush to a finished plan — no _handoff artefact_ is written until the
concept stabilises.

**Why it matters:** Asked to write a _spec_ from a two-line prompt, an agent picks defaults
for the decisions you have not made and writes them in, indistinguishable from real choices;
grilling inverts this by forcing the agent to ask rather than guess. It is a
_human-in-the-loop_ technique — your answers are the input — and when a question cannot be
answered in words, switch to _prototyping_.

## Prototyping

**Prototyping** is having the agent build a quick, rough version of something, for when
conversation is too low-fidelity and you need a real artefact to talk about. Where
_grilling_ resolves decisions in words, some questions — how an interaction feels, whether
an API shape is ergonomic, whether a layout survives real data — can only be answered by
seeing the thing.

**Why it matters:** Agents lower the cost of building, so a mock-up that once took a day now
takes minutes and is worth doing routinely; iterate against the artefact, and build the
pieces you are evaluating to production quality so they can transfer into the real codebase
and feed the _spec_.

## DX

**DX** (developer experience) is how easy a codebase and its toolchain make it for humans to
do good work — fast feedback, clear error messages, documentation that answers the real
question, setup that works first try. The term predates AI coding and sits in this dictionary
mainly as the contrast for _AX_.

**Why it matters:** Humans are _stateful_ — they learn a codebase once and route around poor
DX by batching pushes or asking in Slack — so bad DX is survivable for people in a way it is
not for a _stateless_ agent. DX investment often improves AX for free (strict types, fast
tests), but not always: a beautiful onboarding doc helps a human for a week and an agent not
at all.

## AX

**AX** (agent experience) is how well the _environment_ is set up for an agent to do good
work in a codebase — the agent-facing counterpart to _DX_. When the same agent performs well
in one repo and badly in another, with the same _model_ and _harness_, the difference is
usually AX, and the fix is more often in the repo than in the prompt.

**Why it matters:** Good AX has three dimensions — fast deterministic _automated checks_ the
agent can self-correct from, an architecture it can navigate without reading everything, and
lean _free context_ (`AGENTS.md`, _skills_, _tools_) that keeps the _context window_ open so
the agent stays in the _smart zone_. It overlaps DX but diverges: a repo can have good DX and
poor AX.

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
