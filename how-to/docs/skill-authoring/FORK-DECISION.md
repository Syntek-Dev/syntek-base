---
type: guide
skills: [doc-writer, global-workflow, runbook]
model: opus
---

# Reference or Task, Inline or Forked

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — whether the remit is free, what a skill is, and which target a fork lands in

---

## Before the split — is the remit already owned?

The first question is not what the skill is but **whether it should exist at all**. Everything
the runtime selects from by description is one roster, and two entries covering one remit do not
divide the request between them — the runtime fires **one**, and nothing tells the author which,
or that a second entry was ever in contention.

So name the remit in a sentence, then check the roster (`.claude/skills/CONTEXT.md`) for an entry
that already owns it. Where one exists, the work is an **edit to that entry**, not a new folder.

**One remit, one skill.** Where two entries would share a remit, they are one skill — the
conventions and the procedure live together rather than in two entries competing for the same
request. The shape this bans is the deliberate pair: one entry stating a craft, a second
executing it, both answering to the same subject. The 11/08/2026 selection sweep
(`CRAFT.md` § 1 carries the figures and the method) caught precisely that, twice —
`runbook`/`operator-docs` and `scale-planning`/`scale-planner` — and in each the selection went
to one half while the request had been written for the other. Both are named so a later reader
can re-run the pick rather than take the count on trust.

**A shared engine with thin typed entry points is an instance of this rule, not an exception**,
on one condition: **the entry points carry no craft of their own**. `grilling` states the whole
process; `grill-me` and `grill-with-docs` load it and differ only in what they leave behind. One
remit, one place it is written, plus two doors — where a banned pair would state the craft twice.
The condition is what makes it decidable: the moment an entry point starts explaining _how_ to do
the thing, it has become the second half of a pair and folds back into the engine. Entry points
still have to discriminate **from each other** (`CRAFT.md` § 1), and this pair currently does not.

**A `code/docs/` guide is not a second entry.** It carries no description and never competes for
selection, which is why the hybrid rule below can move standing conventions into a guide without
breaching this. Two _skills_ over one remit is the banned split; a skill and the guide that owns
its subject is the routine one.

## The one split

Everything under `.claude/skills/` is a **skill**. One distinction runs underneath, and it is
the distinction the fork call falls out of:

- **Reference skill** — states conventions. Runs inline. Never forks.
- **Task skill** — an executable procedure. Forks, unless its input is the conversation.

Name the split in the skill itself, so the next reader inherits the call instead of
reconstructing it.

## The rubric — three axes, first match wins

| #   | Test                                              | Verdict     | Why                                                                                       |
| --- | ------------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------- |
| 1   | Does it **state conventions** rather than a task? | **no fork** | A forked conventions skill has nothing to hand back — the subagent gets rules and no task |
| 2   | Is its **input the conversation**?                | **no fork** | A fork starts clean: the conversation it would need to read is not there                  |
| 3   | Otherwise — an **executable task**                | **fork**    | The case `context: fork` exists for; target it by the write test below                    |

Two rules govern the edges.

**A hybrid is split, not classified.** A skill that is a procedure _and_ carries standing
conventions has its conventions migrated to a `code/docs/` guide, leaving a forkable procedure
behind. That makes the call decidable rather than a judgement, and the migration is one the
project wants anyway — a rule that states how the stack does something belongs in the guide that
owns it, where it can be found and corrected without routing to the thing that holds it.

**Ambiguity defaults to no fork**, because the failure modes are asymmetric. A wrong fork returns
nothing useful and does so silently; a wrong no-fork only spends session context.

**Size never forces a fork.** A conventions skill cannot fork usefully at any length, so length
cannot be the trigger. Where a body is genuinely too large to sit in a session, the remedy is
pruning and progressive disclosure (`CRAFT.md` § 2 and § 4), not a fork the rubric refuses.

**What an inline body actually costs.** Invoking a skill posts its rendered body into the session
as one message, and that message is still sitting there many turns later — the bill is the whole
session, not the turn that loaded it. This project disables auto-compaction
(`.claude/CLAUDE.md` § 2.6), so the runtime's own relief valve never opens and invoked bodies
accumulate until `/handoff` and `/clear`. That is an argument for a short reference skill, and
for forking a genuinely large **task**; it is never an argument for forking axis 1.

## Where a fork lands

> **Every forked skill carries `agent: general-purpose` and `background: false`.**

One line, and it is a finding rather than a preference. A read-only target was offered as the
other half of a write test, on the reasoning that a skill which writes nothing cannot breach
`.claude/CLAUDE.md` § 6. Measured across the whole roster, **that row had no occupant** — every
forked entry writes something, down to a report file. A rubric row with nothing in it invites
re-litigation, so it is stated as a reopening test instead of kept as a table:

> A different target may be adopted **only** on evidence that a named skill writes nothing at
> all — no file, no report, no gitignored artefact — **and** that no caller sequences on its
> return. "It only reads, mostly" is not evidence: the one candidate ever proposed was a QA pass
> that writes to `code/src/scripts/tests/reports/backend/`.

Three properties of the runtime the rule rests on, each worth stating because none is a matter
of taste:

- **`Explore` and `Plan` do not load CLAUDE.md.** Any other target does. A skill that writes
  therefore has exactly one safe target — and a skill that also deletes its § 6 checklist as
  "auto-loaded" would receive § 6 by neither route.
- **A backgrounded fork is handed fewer tools** than the same fork run in the foreground.
- **Nothing a backgrounded fork writes is checkpointed.** `/rewind` reaches session state, and
  those edits are not in it, so the only route back is the git history.

**`Explore` is retired as a fork target, not retired.** It stays correct and in use as a
**dispatch** target — a caller naming `subagent_type=Explore` on an Agent tool call is
choosing a target per call, which is a different decision from a skill fixing one in its own
frontmatter for every caller.

**Both keys are stated explicitly** `[gate: fail]`, even though both now repeat the documented
default. The default is version-dependent behaviour and `context: fork` is young; an explicit
value is version-proof, and it is what lets the gate assert that every fork names a target inside
`Explore` / `Plan` / `general-purpose` and says whether it detaches.

## The custom-agent door

The runtime would accept one — `agent:` on a forked skill may name any subagent defined under
`.claude/agents/`, a folder this project no longer carries — so this is a choice, and the gate is
what holds it. No skill here targets a custom agent, and the rule cannot be quietly reversed by
adding a convenient one. The **reopening test** is recorded here, because closing a question
permanently on zero current need is deciding it without evidence:

> A custom agent may be introduced **only** as a fork target, and only on evidence that a named
> skill needs a durable capability no built-in target provides — a persistent tool scope, a
> preloaded skill set, or a `maxTurns` / `permissionMode` the built-ins cannot express. "It would
> be tidier as an agent" is not evidence.

## Record the call

The fork decision and the axis that produced it belong **in the skill**, in one line, next to the
frontmatter that implements it. A later reader can then argue with the reason rather than guess
at it — and a skill whose reason no longer holds is one grep away.

_Part of the `how-to/docs/` documentation family._
