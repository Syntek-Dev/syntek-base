---
name: wait-what
description: >-
  Stop — that last reply did not land. Re-pitch it in plain language, with the context it
  assumed. Invoke by typing /wait-what, or when <%DEVELOPER_NAME%> says the answer was
  confusing, jargon-heavy, or skipped a step. Never invoked by the model on its own.
---

# Skill: wait-what (<%PROJECT_SLUG%>)

The previous reply failed. Not the work behind it — the **explanation**. Re-pitch it.

## What went wrong (assume one of these)

- **Missing context.** It began three steps in, from a premise never stated.
- **Unshared vocabulary.** It used a term this project has not defined, or used a defined term
  loosely (`how-to/docs/AI-DICTIONARY.md`, and the glossary in the nearest `CONTEXT.md`).
- **Too dense.** Correct, and unreadable — the failure `.claude/CLAUDE.md` §1 exists to prevent.
- **Buried answer.** The reasoning arrived before the conclusion.

## How to re-pitch

1. **Lead with the conclusion**, in one sentence a person could repeat to someone else.
2. **Then the context it assumed** — what was already true before this started, and why it matters.
3. **Simple, direct sentences.** One idea each. Active voice. Short words over precise-but-obscure
   ones. Where a long word is load-bearing, keep it and define it inline, once.
4. **Use this project's own words** — the ubiquitous language in the layered `CONTEXT.md` glossaries
   and the AI-coding dictionary. A synonym invented on the spot is what caused this.
5. **Stay scannable** — `.claude/CLAUDE.md` §1 still applies. Re-pitching is not licence to write
   an essay; it is licence to spend the words differently.

## Rules

- **Do not repeat the original wording.** If it had landed, this skill would not have been invoked.
  Restating it louder is the failure mode.
- **Do not apologise, and do not narrate the correction.** Re-pitch and move on.
- **Do not simplify the substance** — the claim, the trade-off, and the caveats survive intact.
  Only the delivery changes. An explanation that lands by being wrong is worse than one that missed.
- **Name what you are unsure landed.** If a specific step is the likely gap, say which, and expand
  that one hardest.

## Governing procedures (route here — do not restate at length)

**None.** This is a conversational mechanic, not a step in any workflow — it produces no artefact
and gates nothing. It is the counterpart to the grilling skill's rule that a vague answer is
restated precisely and confirmed: here it is <%DEVELOPER_NAME%> telling the agent its answer was
the vague one.

## Cross-references

- `.claude/CLAUDE.md` §1 — the concision standard a re-pitch still obeys.
- `how-to/docs/AI-DICTIONARY.md` — the shared vocabulary to reach for.
- `how-to/src/BRAND-VOICE.md` — the registers, for anything that becomes user-facing copy.
- `.claude/skills/grilling/SKILL.md` — the same problem in the other direction.
