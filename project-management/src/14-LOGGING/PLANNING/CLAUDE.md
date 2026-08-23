@./CONTEXT.md

# CLAUDE.md — src/14-LOGGING/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `../CONTEXT.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Where the per-story logging plan lands — the log surface set before the code exists.

## How to work here

- **Routing:** written by `project-management/workflows/14-logging-checks/` with the `logging`
  skill. Inputs are the story, its API design (`../../13-API-DESIGN/PLANNING/`), and the
  schema's `[enc]` marks (`../../04-DATABASE/USER-STORY-IDEAS/`).
- **Model:** Fable — what is worth logging and what must never appear is judgement.
- **Concrete steps:** copy `LOGGING-PLAN-US000-TEMPLATE.md` → one row per event → name every
  exclusion → cross-link the `US###`.
- **Definition of done:** every event carries a level and a field list; every `[enc]` field in
  the story's schema appears in the exclusions table.

## Guardrails

- **Plan, never verify.** There is no running code at this gate — no sample log lines, no grep
  evidence. That is `../IMPLEMENTATION/`.
- **Every field is named.** "Log the request context" is not a plan; the field list is.
- **Documentation only** — no code, secrets, or `.env` content.

## Output & naming

- **Hand-written:** `LOGGING-PLAN-US###-<DESCRIPTOR>.md`.
- **Template:** `LOGGING-PLAN-US000-TEMPLATE.md` — do not delete or repurpose.
- Descriptors `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY.
