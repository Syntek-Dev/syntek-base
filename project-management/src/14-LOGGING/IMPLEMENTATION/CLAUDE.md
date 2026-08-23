@./CONTEXT.md

# CLAUDE.md — src/14-LOGGING/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `../CONTEXT.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Where the per-story logging record lands — what shipped, against what was planned, with the
leak evidence attached.

## How to work here

- **Routing:** written by `project-management/workflows/22-implementation-documentation/` during
  PR review, against the matching `../PLANNING/` plan.
- **Model:** Opus — this transcribes measured evidence rather than deciding anything.
- **Concrete steps:** copy `LOGGING-IMPL-US000-TEMPLATE.md` → confirm or diverge on every planned
  event → run the exclusion check and paste the command and its output → cross-link the `US###`.
- **Definition of done:** every planned event has a verdict; every divergence has a reason; the
  exclusion check output is present, not summarised.

## Guardrails

- **Evidence, not assertion.** "No PII in the logs" without the command that proves it is the
  failure `code/docs/GATE-REPORTING.md` names: could-not-look reported as looked-and-clean.
- **A divergence is recorded, not silently accepted.** If the code logs something the plan did
  not, say so and say why — that is how the next plan gets better.
- **Never paste a real log line containing personal data into this record.** Redact, and say what
  was redacted.
- **Documentation only** — no code, secrets, or `.env` content.

## Output & naming

- **Hand-written:** `LOGGING-IMPL-US###-<DESCRIPTOR>.md`.
- **Template:** `LOGGING-IMPL-US000-TEMPLATE.md` — do not delete or repurpose.
- Descriptors `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY.
