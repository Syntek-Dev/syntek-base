@./CONTEXT.md

# CLAUDE.md — workflows/14-logging-checks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(plan-not-verify, why it sits at 14, the key concepts — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The logging **planning** gate — set a story's log surface and its exclusion list before any code
is written, writing `LOGGING-PLAN-US###-<DESCRIPTOR>.md` into `src/14-LOGGING/PLANNING/`.

## How to work here

- **Routing:** run `STEPS.md` in order with the `logging` skill. The hard gate
  `code/docs/LOGGING.md` must be read before Step 1. Inputs: the story (`src/02-STORIES/`), its
  API design (`src/13-API-DESIGN/PLANNING/`), its schema (`src/04-DATABASE/USER-STORY-IDEAS/`)
  and its GDPR plan (`src/09-GDPR/PLANNING/`).
- **Entry condition:** the story's `Logging` flag is not `N/A`. If it is, skip this gate.
- **Grill first:** open with a grilling pass — which failures a human would actually act on, what
  the `ERROR` threshold is, whether an event belongs in the audit trail instead
  (`.claude/CLAUDE.md` Section 10). These are judgement calls with a real cost either way:
  too little and the next incident is blind, too much and the signal drowns.
- **Model:** Fable — deciding what is worth logging, at which level, and what must never appear
  is substantive design, not transcription.
- **Concrete steps:** confirm the flag → copy `LOGGING-PLAN-US000-TEMPLATE.md` → name the loggers
  → one row per event with level and exhaustive field list → build the exclusion table from the
  schema's `[enc]` marks and the GDPR plan → state channels and retention → raise any `LOG-GAP-n`
  → keep the story's `### Logging Acceptance Criteria` in step.
- **Definition of done:** every event has a level and a field list; every `[enc]` field in the
  story's schema appears in the exclusions table; every `[OPEN]` gap is resolved or fed back
  into `US###.md`.

## Guardrails

- **Never audit a running system here.** There is no code yet — no sample lines, no grep output,
  no Sentry issues. The evidence belongs to `22-implementation-documentation`.
- **Identifiers, never values.** The plan may not permit a name, an email, a token, or an `[enc]`
  plaintext in any line. A plan that does is wrong, not a trade-off.
- **The audit trail is not planned here.** An event that must survive, be tamper-resistant, or
  be produced in a legal request is a database write — `code/docs/security/AUDIT-TRAIL.md`.
  Routing it to a rotating log file loses it.
- **Do not invent a retention period.** It is a business and legal decision; if unset, raise it
  in the story's GDPR plan and mark the row `TBD`.
- **A field list of "context" is not a field list.** Name every field, or the leak check in
  `22` has nothing to check against.
- Documentation workflow — no code. Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the plan `LOGGING-PLAN-US###-<DESCRIPTOR>.md`
  under `src/14-LOGGING/PLANNING/`, linked to its `US###`.
- **Not produced here:** the `IMPLEMENTATION/` record and the exclusion-check evidence — those
  are written by `22-implementation-documentation`.
- Documentation `SCREAMING-SNAKE-CASE.md`; descriptors `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY.
