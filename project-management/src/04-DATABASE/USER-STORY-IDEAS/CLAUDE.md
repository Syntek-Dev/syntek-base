@./CONTEXT.md

# CLAUDE.md — src/04-DATABASE/USER-STORY-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/04-DATABASE/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-1 scope, the freeze rule — imported above) → this file.

## Purpose (one line)

Stage-1 per-story schema designs — one `DB-IDEA-US###-<DESCRIPTOR>.md` per story, covering only
the tables that story needs, written before the story reaches `14-decisions`.

## How to work here

- **Routing:** produced by `workflows/04-database-schema/` (`STEPS.md` + `CHECKLIST.md`) via the
  `database` skill, during the story's own pass through the specify tier. Read the story in
  `../../02-STORIES/US###.md` and every earlier design in this folder first.
- **Model:** Fable — schema design, RLS scoping, and PII classification are substantive
  judgement; Opus only for a rename or a date-header bump.
- **Concrete steps:** copy `DB-IDEA-US000-TEMPLATE.md` → `DB-IDEA-US###-<DESCRIPTOR>.md` →
  complete every section for **this story's** tables → flag every PII column → note any
  collision with an earlier story's design rather than resolving it → export the ERD to
  `../ERD-DIAGRAMS/erd-<domain>.png`.
- **Definition of done:** every table the story needs is designed; PII flagged and classified;
  RLS scope stated where rows are tenant-scoped; a migration strategy exists for affected data;
  collisions with earlier designs are noted; British English; DD/MM/YYYY.

## Guardrails

- **Design for the story, not the system.** Do not attempt the whole schema here, and do not
  retro-fit an earlier story's design to match this one — that is `17`'s job.
- **Note collisions, do not resolve them.** A conflict with an earlier story's design is
  recorded for consolidation. Resolving it unilaterally here silently rewrites a frozen
  decision another story was planned against.
- **Frozen once `17` runs.** After consolidation these files are never edited again — they are
  the audit trail. Corrections go to `../CONSOLIDATED-IDEAS/`.
- **PII at design time** — every personal-data column is flagged and classified before its
  migration is written (`code/docs/encryption/FIELD-ENCRYPTION.md`).
- **Invariants in the database** — FKs with explicit delete behaviour, `NOT NULL`, `UNIQUE`,
  `CHECK` on bounded columns (`code/docs/DATABASE.md`).
- **Documentation only** — no migrations, models, secrets, or `.env` content.
- One design per story; do not batch stories into one file.

## Output & naming

- **Hand-written:** `DB-IDEA-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Template:** `DB-IDEA-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none here; ERD PNGs are re-exported into `../ERD-DIAGRAMS/`.
- Descriptor `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
