---
name: to-questionnaire
description: >-
  Turn a decision <%DEVELOPER_NAME%> cannot settle alone into a questionnaire for someone else to
  fill in — a client, a data controller, a vendor, a stakeholder. Invoke by typing
  /to-questionnaire, or when a grilling pass stalls because the answer lives with a person who is
  not in the session. Writes to `questionnaires/`. Never invoked by the model on its own.
---

# Skill: to-questionnaire (<%PROJECT_SLUG%>)

Grilling assumes <%DEVELOPER_NAME%> can answer. Sometimes he cannot, because the knowledge sits
with someone else — the client who knows the retention policy, the controller who knows the lawful
basis, the stakeholder who knows the launch volume. This skill turns that blocked decision into a
document that person can fill in without you present.

**It is the escape hatch from a stalled grilling pass, not a replacement for one.** Reach for it
when the blocker is _who holds the answer_, never when the question is merely hard.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## The governing rule: grill the send, not the subject

Do **not** interview <%DEVELOPER_NAME%> about the subject — that is exactly what he cannot answer,
and it is why this skill was invoked. Interview him about the **send**, which he can always answer:
who receives it, and what he needs back. The questions in the document then aim at the gap between
what the recipient knows and what he needs.

Getting this backwards produces a questionnaire full of the author's guesses with blanks around
them.

## Steps

### 1. Settle the send

One grilling round — `.claude/skills/grilling/SKILL.md` owns the shape — covering only:

- **Who receives it**: their role, what they know that <%DEVELOPER_NAME%> does not, and the
  relationship. This fixes the register (below) and how much context the document must carry.
- **What must come back**: the specific decisions or facts blocked on them.
- **The deadline**, and whether it is filled in async or worked through together.

_Done when the recipient is known and the return list is concrete — each item something
<%DEVELOPER_NAME%> will be able to decide once answered._

### 2. Write the questionnaire

To `questionnaires/QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md`. Report the path when done.

- **Most important first.** Async means you may get one pass and no follow-up.
- **One idea per question.** A compound question gets a compound answer that resolves neither half.
- **An answer stub under every question** so the recipient types into a shape rather than a blank.
- **Group under `##` headings by theme** once there are more than a handful.
- **A _why this matters_ line only where the question could be misread**, or would otherwise invite
  a throwaway answer. Everywhere else it is noise.
- **Never ask what the repo can answer.** The facts-up rule applies here too — look it up, then
  state it as context so the recipient corrects it rather than researches it.

### 3. Hand it back, and record the block

Tell <%DEVELOPER_NAME%> the path and what stays blocked until it returns. If it gates a story or a
node on a feature map, that is a `GAPS.md` entry — the questionnaire is the evidence, not the
record.

When answers come back, they resolve the original decision through its normal route: the grilling
pass resumes, the wayfinder node is settled, or the artefact is written.

## Register

Read `how-to/src/BRAND-VOICE.md` — a questionnaire goes to someone outside the team and is
user-facing copy:

| Recipient                      | Register                                                         |
| ------------------------------ | ---------------------------------------------------------------- |
| Client or stakeholder          | **Marketing/product** — plain, no internal shorthand, no `US###` |
| Data controller, DPO, or legal | **Product**, precise — mirror the UK GDPR terms they already use |
| A technical peer or contractor | **Product** — the project's own vocabulary is fair game          |

## Document shape

```text
# <Title — the decision it unblocks>

**Purpose:** why this exists and what is riding on it.
**From:** <%DEVELOPER_NAME%> · **To:** <recipient> · **By:** <date>
**How your answers are used:** <where they land>

## Context
One short paragraph for a reader who was not in the room. Enough to answer well, not a briefing.

## How to answer
Rough effort, and the deadline. Partial answers and "I don't know" are useful — flag uncertainty
rather than skipping the question.

## <Theme>
### <One question, one idea>
_Why this matters: <only where it could be misread>._

> <answer stub>

## Anything else?
What did we fail to ask that you would expect us to need?
```

## Boundaries

- **Vendor security assessments are not this.** `.claude/agents/vendor-assessment-writer.md` owns
  that questionnaire, with its own compliance structure. Route there instead.
- **A GDPR register is not this.** The six registers in `project-management/src/09-GDPR/` are
  artefacts of record; a questionnaire may gather what fills one, and never replaces it.
- **This is not a handoff.** `/handoff` addresses a fresh agent with full repo access.
  A questionnaire addresses a human with none.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `project-management/workflows/09-gdpr-compliance/` — where lawful basis and retention answers land
- `project-management/workflows/01-feature/` — when the blocked decision is a node on a feature map
- `project-management/workflows/14-decisions/` — when the answer settles an ADR

## Cross-references

- `.claude/skills/grilling/SKILL.md` — owns the interview shape used in step 1.
- `how-to/src/BRAND-VOICE.md` — the registers a questionnaire is written in.
- `questionnaires/CONTEXT.md` — the output home and its naming.
- `GAPS.md` — where a blocked decision is recorded while the questionnaire is out.
