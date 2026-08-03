---
name: handoff
description: >-
  Compact the current conversation into a handoff document so a fresh agent resumes the work
  cleanly after a session boundary. Invoke by typing /handoff, or when a session must end before
  the work does. Most importantly, this is the project's replacement for auto-compaction: when the
  context window nears full, run this instead of compacting, then stop so <%DEVELOPER_NAME%> can /clear and resume
  from the file. Also for a day ending or a different specialist taking over.
---

# Skill: Handoff (<%PROJECT_SLUG%>)

Handoff **compacts the current conversation** into a single document so a **fresh agent** can
resume the work cleanly across a session boundary — a context window filling up, a day ending, a
different specialist taking over. It captures the live thread of _this_ session only: where the
work sits, what is half-done, and the next move. Durable project knowledge has other homes
(below); a handoff is a transient bridge, not a memory store.

The default posture in `.claude/CLAUDE.md` §2 is that context flows through the agents and the
layered docs. A handoff is the exception: when a conversation must end before the work does, this
skill serialises just enough continuity for the next agent to start without re-deriving it.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## The auto-compaction replacement

This skill is the project's designated alternative to auto-compaction (`.claude/CLAUDE.md` §2.6).
Auto-compaction is disabled (`settings.json` → `autoCompactEnabled: false`) and intercepted (the
`PreCompact` hook). So when the context window nears full, **do not let the session compact** —
run this skill, write the handoff, **stop**, and let <%DEVELOPER_NAME%> `/clear` and resume from the file. A hook
cannot do this for you: writing the handoff and stopping is the model's job.

## Where the handoff lives

A handoff is a **portable bridge to the work's next session**, committed so it syncs across <%DEVELOPER_NAME%>'s
devices. It lives in the repo at `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`. It stays a transient
bridge, not a memory store — prune a handoff once its work has resumed.

## How to write a handoff

1. **State the goal.** Open with one or two sentences naming what the work is trying to achieve,
   so the fresh agent orients before any detail. Look facts up (`code-review-graph` → Read/Grep/
   Glob → `.claude/plugins/*.py`) rather than guessing them. _Complete when:_ the goal sits in
   one or two sentences at the top.

2. **Record what is DONE.** List the work already landed this session — files changed, decisions
   settled, checks passed — each named by its repo path. _Complete when:_ every finished item is
   a one-liner with its path.

3. **Pin what is IN-FLIGHT.** For each open thread, give the exact `path:line` anchor and its
   mid-change state. This is the load-bearing section — the fresh agent resumes here.
   _Complete when:_ every in-flight item carries a `path:line` anchor and a one-line status.

4. **Name the immediate NEXT action.** State the single next step, concrete enough to start
   without re-deriving it. _Complete when:_ the next action is one imperative sentence.

5. **Suggest the next agent and its skills.** Name the specialist or orchestrator best suited to
   continue and the skills it should load — e.g. `backend` + `stack-django`, `frontend` +
   `stack-htmx-templates`, `database` + `grilling` (roster: `.claude/agents/CONTEXT.md`; skills:
   `.claude/skills/CONTEXT.md`). _Complete when:_ the doc names one next agent and its skills.

6. **Reference artefacts by path, never paste them.** Point at plans (`STORY-PLAN-US###`), ADRs
   (`ADR-###`), stories (`US###.md`), commits, and diffs by their repo path — the fresh agent
   opens them itself. Reference any secret or PII by name and location only. _Complete when:_
   every artefact is a path and no secret value or PII appears in the doc.

7. **Write the file, print the path, then stop.** Write the assembled handoff to
   `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`, print that path for <%DEVELOPER_NAME%>, and **end the turn** —
   do not carry on working, so <%DEVELOPER_NAME%> can `/clear` and resume from the file in a fresh context window.
   **Complete when:** the file exists under `handoffs/`, its path is printed, and the turn has stopped.

## What the handoff carries

A complete handoff names all six, top to bottom — treat this as the final checklist:

- **Goal** — what the work achieves, in one or two sentences.
- **Done** — landed work, each by path.
- **In-flight** — open threads with `path:line` anchors and status.
- **Next** — the single immediate action.
- **Next agent + skills** — who continues and what they load.
- **Artefacts** — specs, plans, ADRs, stories, commits, diffs, all by path.

Add an **Open Questions** line only when the session left a decision genuinely unresolved — name
it for the fresh agent rather than pre-empting it.

## What stays out

Durable project knowledge does not belong in a transient handoff — route it to its home instead:

- Patterns, feedback, and project-state facts → `.claude/MEMORY.md`.
- Active blockers and sprint dependencies → `GAPS.md`.
- Work deferred to a named future story → `DEFERRED.md`.

The handoff carries only live conversational continuity — the thread of this session, not the
project's memory or backlog.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** This skill is a session or sandbox mechanic, not a step in the
delivery chain. It is invoked directly and does not route into `code/workflows/`,
`project-management/workflows/`, or `how-to/workflows/`.

## Cross-references

- `.claude/skills/grilling/SKILL.md` · `.claude/skills/grill-me/SKILL.md` ·
  `.claude/skills/grill-with-docs/SKILL.md` — the design-time interview family; handoff is the
  session-boundary complement.
- `.claude/CLAUDE.md` §2.3, §2.6 · `.claude/agents/CONTEXT.md` — the agent roster the next agent is drawn from.
- `.claude/skills/CONTEXT.md` — the skills table the suggested skills are drawn from.
- `.claude/plugins/` · `code/docs/CODE-REVIEW-GRAPH.md` — read-only lookup for session facts before Grep/Glob.
- `.claude/MEMORY.md` · `GAPS.md` · `DEFERRED.md` — the homes for durable knowledge kept out of the handoff.
- `project-management/src/16-STORY-PLANS/` · `project-management/src/14-DECISIONS/`
  (`ADR-###`) · `project-management/src/02-STORIES/US###.md` — artefacts referenced by path.
- `handoffs/` — the committed, synced home for handoff documents (`HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`).
- `how-to/docs/GIT-WORKTREES.md` · `.claude/worktrees/` — worktree context a handoff often spans.
