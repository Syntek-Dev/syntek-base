@./CONTEXT.md

# CLAUDE.md — src/14-LOGGING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the two stages, what a plan holds — imported above) → this file → the target stage folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The per-story logging specifications — the planned log surface before code, and the record of
what shipped with its leak evidence after.

## How to work here

- **Routing:** never author here free-hand — plans come from
  `project-management/workflows/14-logging-checks/` via the `logging` skill; records come from
  `22-implementation-documentation`.
- **Model:** Fable for the plan — choosing what is worth logging, at which level, and what must
  never appear is judgement. Opus for the implementation record, which transcribes evidence.
- **Concrete steps:** copy the stage template → one row per logged event with its level and its
  exact field list → name every excluded `[enc]` and PII attribute → cross-link the `US###`.
- **Definition of done:** every event has a level and a field list; every exclusion names the
  field and the surface it is excluded from; British English; DD/MM/YYYY.

## Guardrails

- **Log identifiers, never values.** A line carries `<entity>_id` and `action`; it never carries
  a name, an email, a token, or the plaintext of a field marked `[enc]` in the story's schema
  design. This is the rule the whole folder exists to make checkable.
- **A log line is not an audit record.** The audit trail is a database write with its own schema,
  retention and tamper-resistance (`code/docs/security/AUDIT-TRAIL.md`). Planning one as the other
  produces an audit trail that rotates away in fourteen days.
- **No plan for a story that emits nothing.** A story with `Logging: N/A` records the reason in
  its flag row and needs no file here.
- **Documentation only** — no code, secrets, or `.env` content. The obligations are _specified_
  here and _enforced_ in `code/`.
- Instructional `.md` here stays ≤ 300 code lines; the per-story artefacts are exempt.

## Output & naming

- **Hand-written:** every `LOGGING-PLAN-US###-*.md` and `LOGGING-IMPL-US###-*.md`.
- **Templates:** `LOGGING-PLAN-US000-TEMPLATE.md` · `LOGGING-IMPL-US000-TEMPLATE.md` — copy
  sources; do not delete or repurpose.
- **Generated:** none.
- Descriptors `SCREAMING-KEBAB-CASE`; stories `US###`; dates DD/MM/YYYY.
