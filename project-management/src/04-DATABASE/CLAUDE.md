@./CONTEXT.md

# CLAUDE.md — src/04-DATABASE/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three stages + naming, imported above) → this file → the target stage folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The database-design store, in three stages — per-story designs (`USER-STORY-IDEAS/`), the
unified schema they are reconciled into (`CONSOLIDATED-IDEAS/`), and the per-story record of
what shipped (`IMPLEMENTATION/`), plus the rendered ERDs in `ERD-DIAGRAMS/`.

## How to work here

- **Routing:** never author here free-hand. Stage 1 comes from
  `workflows/04-database-schema/`, stage 2 from `workflows/17-consolidate-design-work/`,
  stage 3 from `workflows/21-implementation-documentation/`. Use the `database` agent for
  the heavier modelling.
- **Model:** Fable for schema design, consolidation, RLS decisions, and PII classification —
  all substantive judgement; Opus for mechanical touches (a status flip, a rename, re-exporting
  an ERD).
- **Concrete steps:** pick the stage → copy that folder's template using its naming pattern →
  complete every section → export the ERD to `ERD-DIAGRAMS/erd-<domain>.png` on sign-off →
  cross-link the `US###` and, for stages 2 and 3, the stage-1 designs involved.
- **Definition of done:** the artefact is in the right stage folder, named to convention,
  PII flagged and classified, a migration strategy exists for affected data, ERD source and
  rendered diagram agree; British English.

## Guardrails

- **Design, not code** — no migrations, models, secrets, or `.env` content land here; the
  schema is _specified_ in these documents and _enforced_ in `code/`.
- **Never edit a `USER-STORY-IDEAS/` file once `17` has run.** Stage 1 is the frozen record of
  what each story asked for; consolidation is additive and cross-links back to it.
- **Build from the consolidated schema, not a stage-1 design.** A migration written from a
  per-story design reintroduces the drift consolidation removed — this is the single most
  expensive mistake this folder can absorb.
- **PII is flagged at design time** — every personal-data column enters via the PII
  Classification section, and row-scoped tables via the RLS section, before the migration is
  written (`code/docs/encryption/FIELD-ENCRYPTION.md`).
- **Data invariants belong in the database** — FKs with explicit delete behaviour, `NOT NULL`,
  `UNIQUE`, and `CHECK` on every bounded column. Application validation is not a substitute
  (`code/docs/DATABASE.md`).
- Instructional `.md` (`CONTEXT.md`/`CLAUDE.md`) ≤ 300 code lines; the design artefacts and
  templates themselves are exempt.

## Output & naming

- **Hand-written:** every design, consolidation, and record document, from its stage template.
- **Templates:** `DB-IDEA-US000-TEMPLATE.md`, `DB-CONSOLIDATED-000-TEMPLATE.md`,
  `DB-IMPL-US000-TEMPLATE.md` — the copy sources; do not delete or repurpose.
- **Generated (never hand-edit):** the PNGs under `ERD-DIAGRAMS/` — re-export from the Mermaid
  source when the schema changes.
- `DB-IDEA-US###-<DESCRIPTOR>.md` · `DB-CONSOLIDATED-<DOMAIN>.md` ·
  `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; ERD images `erd-<domain>.png`; stories `US###`;
  dates DD/MM/YYYY.
