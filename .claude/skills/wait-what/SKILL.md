---
name: wait-what
description: >-
  Stop — that last reply did not land. Re-pitch it in plain language, with the context it
  assumed. Invoke by typing /wait-what, or when <%DEVELOPER_NAME%> says the answer was
  confusing, jargon-heavy, or skipped a step. Where the miss was a knowledge gap rather than a
  dense delivery, it then offers a handoff into /teach. Never invoked by the model on its own.
---

# Skill: wait-what (<%PROJECT_SLUG%>)

The previous reply failed. Not the work behind it — the **explanation**. Re-pitch it.

## What went wrong (assume one of these)

- **Missing context.** It began three steps in, from a premise never stated.
- **Unshared vocabulary.** It used a term this project has not defined, or used a defined term
  loosely (`how-to/docs/AI-DICTIONARY.md`, and the glossary in the nearest `CONTEXT.md`).
- **Too dense.** Correct, and unreadable — the failure `.claude/CLAUDE.md` Section 1 exists to prevent.
- **Buried answer.** The reasoning arrived before the conclusion.

## How to re-pitch

1. **Lead with the conclusion**, in one sentence a person could repeat to someone else.
2. **Then the context it assumed** — what was already true before this started, and why it matters.
3. **Simple, direct sentences.** One idea each. Active voice. Short words over precise-but-obscure
   ones. Where a long word is load-bearing, keep it and define it inline, once.
4. **Use this project's own words** — the ubiquitous language in the layered `CONTEXT.md` glossaries
   and the AI-coding dictionary. A synonym invented on the spot is what caused this.
5. **Stay scannable** — `.claude/CLAUDE.md` Section 1 still applies. Re-pitching is not licence to write
   an essay; it is licence to spend the words differently.

## Rules

- **Do not repeat the original wording.** If it had landed, this skill would not have been invoked.
  Restating it louder is the failure mode.
- **Do not apologise, and do not narrate the correction.** Re-pitch and move on.
- **Do not simplify the substance** — the claim, the trade-off, and the caveats survive intact.
  Only the delivery changes. An explanation that lands by being wrong is worse than one that missed.
- **Name what you are unsure landed.** If a specific step is the likely gap, say which, and expand
  that one hardest.

## When the gap is knowledge, not delivery

The four failures above split two ways. **Too dense** and **buried answer** are delivery failures
— the re-pitch is the whole fix, and the turn ends there. **Missing context** and **unshared
vocabulary** are knowledge gaps: the re-pitch closes the gap for this one reply and leaves it open
for the next. Only then, offer the durable fix.

**Offer it after the re-pitch, never before it, and in two lines at most.** The explanation has to
land on its own first; an offer to teach that arrives ahead of it reads as a deflection.

1. **Name the topic as a slug** — kebab-case, the `learning/<topic>/` folder `teach` will use.
2. **Check whether that folder already exists.** If it does, offer to **resume** it; if not, say
   the first session scaffolds it.
3. **Name the opening lesson.** The concept that just missed _is_ the lesson at the edge of the
   current level — `teach` step 2's job, already done here. Carrying it across is the point.
4. **Offer the route** — write a handoff, then open a new session, load the handoff, run
   `/teach <topic>`.

Ask **once per topic per session**. If <%DEVELOPER_NAME%> declines, drop it and carry on;
repeating the offer is the same failure as repeating the original wording.

### The handoff that carries the detour

`.claude/skills/handoff/SKILL.md` owns the shape and this does not restate it. Written in full as
that skill defines, plus three things marking it as a teaching detour:

- **Descriptor** — `HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md`, so the file names its own purpose.
- **A `Teaching detour` line** — the topic slug, the concept that missed, and the opening lesson.
- **Next skills** — `teach` first, then the skills that resume the work beneath it.

The work's own state is still recorded in full: the lesson comes first, the work resumes from the
same file afterwards. Handoff's final step prints the path and ends the turn — that is where this
stops too.

## Governing procedures (route here — do not restate at length)

**None.** This is a conversational mechanic, not a step in any workflow — it gates nothing, and
the one artefact it can lead to is written by `handoff`, not here. It is the counterpart to the
grilling skill's rule that a vague answer is restated precisely and confirmed: here it is
<%DEVELOPER_NAME%> telling the agent its answer was the vague one.

## Cross-references

- `.claude/CLAUDE.md` Section 1 — the concision standard a re-pitch still obeys.
- `how-to/docs/AI-DICTIONARY.md` — the shared vocabulary to reach for.
- `how-to/src/BRAND-VOICE.md` — the registers, for anything that becomes user-facing copy.
- `.claude/skills/grilling/SKILL.md` — the same problem in the other direction.
- `.claude/skills/teach/SKILL.md` — where a knowledge gap goes to be closed durably.
- `.claude/skills/handoff/SKILL.md` — the session boundary the teaching detour crosses.
