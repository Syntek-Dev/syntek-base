---
type: guide
skills: [doc-writer, global-workflow, runbook]
model: opus
---

# Skill Frontmatter — the fields this project authors

**Version:** 0.1.0 **Standard:** [Agent Skills specification](https://agentskills.io/specification) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the six specification fields, the four runtime keys admitted here, and what is declined

---

## Three claims, kept apart

A reader who cannot tell these apart will not know which rule they are allowed to argue with.

1. **The published specification defines six fields.** That is an external contract, and the
   only thing a conformance claim can be made against.
2. **Claude Code reads documented keys of its own beyond those six.** A key outside the six is
   therefore not automatically rejected — several are read, and change how the skill runs.
3. **This project authors seven keys and declines the rest by choice** — the two required spec
   fields, `metadata` for the one purpose below, and four runtime keys that place the run.
   `license` appears only on vendored skills, which nobody here authors. Every decline below is
   a house decision with a reason attached, not a limit imposed from outside.

The gate reports its findings as `[spec N]` or `[house N]` for exactly this reason: a format
breach and a house breach have different remedies, and only the second is negotiable.

## The six specification fields

| Field           | Spec     | Constraint                                                      | Here                                     |
| --------------- | -------- | --------------------------------------------------------------- | ---------------------------------------- |
| `name`          | required | 1–64 chars · `a-z0-9-` only · no leading/trailing `-` · no `--` | **Authored.** Matches its folder         |
| `description`   | required | 1–1024 chars · the skill's job **and** its trigger conditions   | **Authored.** The whole invocation lever |
| `license`       | optional | A licence name, or a bundled licence file                       | Vendored skills only                     |
| `metadata`      | optional | Arbitrary string→string map                                     | **Authored.** One key only — below       |
| `compatibility` | optional | ≤ 500 chars — environment or product requirements               | **Declined**                             |
| `allowed-tools` | optional | Space-separated pre-approved tools (experimental)               | **Declined**                             |

The `name` and `description` constraints are enforced `[gate: fail]`. `compatibility` and
`allowed-tools` are declined on anything first-party and `license` is vendored-only, so those
three constraints are never reached here — a vendored skill's `license` string is read by
whoever validates upstream, not by this project's gate.

## `metadata.skills` — the dependency register

`metadata` is the specification's own extension point for properties it does not define, and
Claude Code documents that it **does not act on the contents**. One key is authored beneath it:

```yaml
metadata:
  skills: global-workflow grilling stack-django
```

**It is a register, not a loader**, and the distinction decides how it is used. Nothing fires
because a name appears here; the actual load is instructed in the body's
`## Governing procedures`. What the key buys is that the declaration becomes **machine-checkable**
— clause 12 asserts every name resolves to `.claude/skills/<name>/`, so a dependency that cannot
arrive is a failure rather than a silence. Read it as wiring and you ship skills declaring
dependencies nothing loads.

**It names reference skills only** — the ones that cannot arrive any other way. A **task** skill
fires on its own description match, so naming one here is documentation wearing a register's
clothes, which is the thing the gate exists to stop. Name a task skill in the body instead.

**Every other child key is rejected**, and that is the clause worth understanding. `metadata` is
unconstrained by the runtime, so every routing value the gate reads at the **top** level can be
restated one indentation level down where none of its clauses looks:
`metadata: {agent: my-custom-agent, model: haiku}` satisfies clauses 7–11 completely. Inert at
runtime — but an open namespace is a second, unchecked home for every rule, and one place per
rule is the whole standard.

## The other `skills:` key — the one a guide writes, and this skill answers

A **guide** carries its own `skills:` list (`.claude/CLAUDE.md` Section 2.5), and it is a
different key in a different file from the one above. Two clauses read it, in opposite
directions, and keeping them apart is what stops either being mistaken for the other:

| Direction               | Asks                                    | Gate                             |
| ----------------------- | --------------------------------------- | -------------------------------- |
| Outbound — guide's half | does the name **resolve** to a skill?   | `audits/routing-skills.sh`       |
| Inbound — skill's half  | does the skill **cite the guide back**? | `skill-conformance.sh` clause 14 |

**The inbound half exists because the outbound one points down the minority path.** A guide's
list is read by whoever opens the **guide** — but skills fire on description match
(`.claude/CLAUDE.md` Section 2.3), so an agent reaches the skill first far more often, and the
guide only if the skill names it. Left unchecked, a guide could name a skill for a year while
the skill never mentioned the guide, and the doctrine would simply never arrive.

**Cite every top-level guide that names this skill**, in the body — `## Cross-references` is
where they go. Two deliberate limits:

- **Top-level guides only.** A sub-document is reached through its index, and the index is what
  a skill cites. Requiring each sub-document by name would make every skill enumerate a tree
  that churns whenever a guide is split.
- **A directory glob discharges the obligation.** `code/docs/*` already says where to look, and
  is route-don't-restate done correctly; demanding the literal path as well would make the gate
  punish the better pattern. Reach for it where a whole tree genuinely applies — a
  cross-cutting skill named by a dozen guides for its conventions — and for a literal path
  where the guide is this skill's actual subject.

## The four runtime keys admitted here

Each of the four answers **where the skill runs**. None of them answers what it may do, which is
the line that decides admission: run placement is a property of this skill, capability is a
property of whatever runs it.

| Key          | Sets                                                                                   | Authored when                                                                        |
| ------------ | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `context`    | `inline` (the default) or `fork` — this conversation, or a fresh subagent              | The rubric in `FORK-DECISION.md` returns _fork_                                      |
| `agent`      | Which target a fork lands in — `Explore`, `Plan`, or `general-purpose`                 | Always, on any forked skill — stated even when it repeats the default                |
| `background` | Whether that fork runs detached from the session                                       | Always, on any forked skill — it follows the same one-line test as `agent`           |
| `model`      | The tier for the run: turn-scoped when inline, the forked subagent's tier under `fork` | A forked skill needs a tier its caller cannot set — otherwise Section 2.5 carries it |

`disable-model-invocation` and `effort` are documented by the runtime and are **not** adopted
(below).

### A key name is not a surface

`agent:` above names a **fork target**. The routing frontmatter on `**/docs/*.md` and
`**/workflows/**/*.md` (`.claude/CLAUDE.md` Section 2.5) has historically spelled a key the same way
and meant something else entirely. Both are legal, so a sweep that rewrites every match by key
name corrupts one population and still passes every gate.

**Before sweeping a frontmatter key, partition the matches by path and name each partition's
meaning.** A key's semantics belong to the file class that carries it, and two file classes may
legitimately spell one key. `.claude/skills/**/SKILL.md` is a second population by rule, not by
luck — excluding it is a decision the sweep must state, not an accident it gets away with.

## What is declined, and why

**`allowed-tools`, and the reason generalises.** What an agent may _do_ is a property of the
**caller** — the session or agent that loads the skill, and the routing frontmatter on the
governing `docs/`/`workflows/` file — never of the skill. A skill is reference and process; it
carries no capability of its own. Put `allowed-tools` on a skill and the same skill grants
different powers depending on who loaded it, which is precisely the unpredictability the whole
standard exists to remove. That test is what admits the four keys above and excludes this one:
they place a run, this one grants a power.

**`compatibility`**, even though it looks made for the surface-gated skills. `stack-react-native`,
`stack-rust` and `stack-slint` are gated by `copier.yml` `_exclude`, so on a project without that <!-- doc-references: template-only -->
surface the file is **absent**, not present-and-incompatible. The field would restate a decision
the file's own absence already makes.

**`disable-model-invocation`.** _Model_ invocation is already decided by the description's
wording — a rich "Load when…" trigger list for auto-loading, a "type `/name`" phrasing for
human-gated (the trade is set out in `CRAFT.md` Section 1). _User_ invocation is not gated at all:
every skill is typeable as `/name` whatever its description says, so the key could only ever
switch the half the wording already owns. Adding a key that switches the same behaviour puts one
meaning in two places, and the two drift the first time only one of them is edited.

**`effort`**, on the same admission test that admits the four above. They answer **where the run
happens**, which is a property of the skill; `effort` answers **how hard the model thinks**, which
is a property of the caller's session — and `.claude/settings.json` already sets `effortLevel`
project-wide, so a per-skill key either restates that or lowers it against `.claude/CLAUDE.md` Section 4.
It is **declined rather than unknown**: the gate lists it, so authoring one reports `[house 7]`, a
choice worth arguing with, instead of `[spec 6]`'s claim that the runtime documents no such key —
which would have been false in the gate's own output. Reopening test: evidence that a named skill
needs a durable effort level the session cannot set.

## The vendored exception, stated rather than implied

The three `cloudinary-*` skills are symlinks into `.agents/skills/`, refreshed from upstream by
the skills tool and never authored here. They carry `license` and `metadata`, and they carry no
`## Governing procedures` section. That is correct: the house rules bind what **this project
writes**, and hand-editing a vendored skill would be undone by the next refresh
(`skills-lock.json`). The gate holds them to the specification clauses only — and, within those,
to the **published six alone**: none of the four runtime keys is admitted on a vendored skill,
because a routing key arriving in someone else's drop is one nobody here decided.

_Part of the `how-to/docs/` documentation family._
