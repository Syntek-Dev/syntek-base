---
type: guide
skills: [setup, global-workflow]
model: opus
---

# Invoking a Skill

**Version:** 0.1.0 **Tooling:** internal (`.claude/skills/`) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — how a skill is reached, where it runs, and how it dispatches a fresh context

Which skill does what is the roster's job: `.claude/skills/CONTEXT.md` carries every skill and
its when-to-load line. This page is the surface around it — how one gets picked, where its body
runs, and what happens when it needs a context of its own.

---

## Three ways a skill is reached

| Route                 | What triggers it                                                                                      | Notes                                                                                                        |
| --------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Description match** | You describe the work; the runtime selects the skill whose `description` matches it                   | The description **is** the trigger — which is why it is written as a when-to-load sentence, not as a summary |
| **Slash command**     | You type `/name` — `/handoff`, `/incident`, `/research`, `/teach <topic>`, `/grill-me`                | Only the skills that define one; the roster's when-to-load column shows which                                |
| **Named explicitly**  | You name the skill in the request, or another skill names it in its `## Governing procedures` section | The route a procedure uses to reach the conventions it depends on                                            |

Selection is settled by the descriptions, not by the request: where two skills cover one remit,
**one fires**, and nothing reports that the other was ever in contention. That is why one remit
means one skill — `how-to/docs/skill-authoring/FORK-DECISION.md`.

---

## Where it runs — inline or forked

- **Reference skill** — states conventions. Its body is posted into this conversation and stays
  there for the rest of the session. Never forks.
- **Task skill** — an executable procedure. Runs in a fresh context, unless its input is the
  conversation it was invoked from.

The rubric behind that call, the target a fork lands in, and the requirement that the skill
record its own reasoning: `how-to/docs/skill-authoring/FORK-DECISION.md`.

---

## Dispatching a fresh context

A skill that needs work done outside its own context **dispatches through the Agent tool** with
`subagent_type: general-purpose`, naming the skill to load in the prompt. There is no per-skill
subagent to address — the roster is skills, and `general-purpose` is what loads one.

The built-in targets are `Explore`, `Plan`, and `general-purpose`. **`Explore` and `Plan` do not
load `.claude/CLAUDE.md`**, so they are valid only where the dispatched work writes nothing at
all — no file, no report, no gitignored artefact. Anything that writes goes to `general-purpose`,
which is the only target that arrives carrying the non-negotiables.

**No skill reviews its own work.** The build and the review of it are separate dispatches, so the
reader meets the diff without the writer's intent already in context. Nothing in the runtime
enforces this — it holds because each phase is dispatched separately, and it stops holding the
moment one turn does both.

_Part of the `how-to/docs/` documentation family. See [`../TOOLING-GUIDE.md`](../TOOLING-GUIDE.md) for the full index._
