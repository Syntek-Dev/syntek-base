@./CONTEXT.md

# CLAUDE.md — src/04-DATABASE/CONSOLIDATED-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/04-DATABASE/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-2 scope, the resolution log — imported above) → this file.

## Purpose (one line)

Stage-2 unified schema — one `DB-CONSOLIDATED-<DOMAIN>.md` per domain, reconciling the frozen
per-story designs into the canonical schema that `19-backend-code` builds from.

## How to work here

- **Routing:** produced only by `workflows/18-consolidate-design-work/` via the `database` skill,
  after every story has cleared `17-story-plans`. The hard gate `code/docs/DATABASE.md` is read
  before Step 1.
- **Model:** Fable throughout — reconciling two stories' competing models of the same entity is
  design judgement, not a mechanical merge. Opus only for re-exporting an ERD or a rename.
- **Concrete steps:** inventory every `../USER-STORY-IDEAS/` design → mark duplicates,
  divergences, orphans, and contradictions → resolve each to one canonical form → record the
  chosen and rejected forms with reasons in the resolution log → escalate anything hard to
  reverse to `../../15-DECISIONS/` → write the canonical tables, FKs, PII, RLS, indexes, and the
  lock-safe migration order → re-export `../ERD-DIAGRAMS/erd-<domain>.png`.
- **Definition of done:** no unresolved duplicate remains; every resolution names the stories on
  both sides; every hard-to-reverse choice cites an ADR; every affected
  `<exec-order>-STORY-PLAN-US###-*.md` has been corrected; British English; DD/MM/YYYY.

## Guardrails

- **Never edit `../USER-STORY-IDEAS/`.** Stage 1 is frozen; consolidation is additive and
  cross-links back to what it supersedes.
- **This folder is what gets built.** Any migration traced back to a stage-1 design instead of
  here is a defect, not a shortcut.
- **Record the resolution, not just the result.** A canonical table with no note of what it
  replaced and why is un-reviewable, and the next consolidation re-litigates it.
- **A consolidation that changes a planned shape must correct the plan** — a
  `<exec-order>-STORY-PLAN-US###-*.md` left asserting a superseded schema silently undoes this
  work, because the developer codes from the plan. Correct its **contents**, never its prefix:
  that number is the story's position in the settled build order across the whole backlog, and
  only a re-plan moves it (`../../17-STORY-PLANS/CLAUDE.md`).
- **Invariants in the database** — FKs with explicit delete behaviour, `NOT NULL`, `UNIQUE`,
  `CHECK` on every bounded column; a scope column ships with its policy, its index, and the
  middleware that sets its session variable (`code/docs/DATABASE.md`).
- **Lock-safe migrations** — add-nullable → backfill → constrain; build indexes concurrently on
  populated tables.
- **Consolidation never adds scope.** A capability gap found here becomes a new `US###` through
  `02-story-creation/`, not a quiet extra table.
- **Documentation only** — no migrations, models, secrets, or `.env` content.

## Output & naming

- **Hand-written:** `DB-CONSOLIDATED-<DOMAIN>.md`, one per domain, from the template.
- **Template:** `DB-CONSOLIDATED-000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated (never hand-edit):** the PNGs in `../ERD-DIAGRAMS/`.
- `<DOMAIN>` in `SCREAMING-KEBAB-CASE`; superseded stories cited as `US###`; dates DD/MM/YYYY.

<!-- UPDATED 08/09/2026. Both story-plan patterns gained the `<exec-order>-` build-order prefix,
     and the guardrail gained the sentence separating correcting a plan's contents from moving its
     number; they read "STORY-PLAN-US###-*.md" before. `code/src/scripts/audits/doc-references.sh`
     reads backticked tokens even inside a comment, so the superseded name is quoted in double
     quotes and never in backticks. The prefix is renumbered only when build order changes — the
     opposite of the sprint-plan rule next door, where a prefix/suffix mismatch is deliberate and
     must not be "corrected". -->
