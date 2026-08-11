@./CONTEXT.md

# CLAUDE.md — questionnaires/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, the neighbour boundary — imported above) → this file →
`.claude/skills/to-questionnaire/SKILL.md`.

## Purpose (one line)

The committed home for outbound discovery questionnaires — one per send, kept with its answers as
the evidence behind any decision taken on an outside party's word.

## How to work here

- **Routing:** all writes here run through the `to-questionnaire` skill
  (`.claude/skills/to-questionnaire/SKILL.md`), invoked by <%DEVELOPER_NAME%> as
  `/to-questionnaire`. Model: Opus.
- **Concrete steps:** settle the **send** (recipient, what must come back, deadline) in one
  grilling round → write `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md` → report the path → record what
  stays blocked in `GAPS.md` until it returns.
- **Definition of done:** every item <%DEVELOPER_NAME%> needs back is covered by exactly one
  question; every question has an answer stub; the blocked decision is recorded in `GAPS.md`.

## Guardrails

- **Grill the send, not the subject.** Interviewing <%DEVELOPER_NAME%> about the subject is what
  this skill exists to avoid — he invoked it because he cannot answer.
- **Never ask what the repository can answer.** Look it up and state it as context, so the
  recipient corrects a fact rather than researches one.
- **User-facing copy.** `how-to/src/BRAND-VOICE.md` applies — no internal shorthand, no `US###`,
  no repo paths in a document going to a client.
- **Never put secrets, credentials, live data, or another client's details in a questionnaire.**
  It leaves the building.
- **The answers graduate.** A returned questionnaire is evidence, not a record — the decision it
  unblocks lands in its normal artefact (GDPR register, ADR, story, feature-map node). Leaving
  the answer only here is the same failure as leaving a decision only on a wayfinder map.
- **Keep returned files.** Do not delete a questionnaire once answered, and do not overwrite the
  questions with the answers — fill the stubs.

## Output & naming

- **Hand-written** via `/to-questionnaire`; nothing generated.
- `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md` — `<SLUG>` in `SCREAMING-KEBAB-CASE`, dates DD/MM/YYYY.
- British English (en_GB).
