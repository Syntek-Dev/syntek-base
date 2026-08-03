@./CONTEXT.md

# CLAUDE.md — src/04-DATABASE/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/04-DATABASE/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-3 scope, naming — imported above) → this file.

## Purpose (one line)

Stage-3 per-story records — one `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` confirming, with
migration evidence, that a story's shipped schema matches `../CONSOLIDATED-IDEAS/`.

## How to work here

- **Routing:** written during `workflows/21-implementation-documentation/` by the `doc-writer`
  agent, consulting `database` where a deviation needs judging, against the consolidated
  schema and the story's shipped migrations.
- **Model:** Opus — this records what was built against an already-approved schema; it is a
  documentation closeout, not a design pass. Escalate to `database` (Fable) only when a
  deviation needs assessing.
- **Concrete steps:** copy `DB-IMPL-US000-TEMPLATE.md` →
  `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → list the migrations that shipped → mark each
  consolidated table and column Present / Changed / Missing with the migration file as evidence
  → confirm constraints, indexes, PII encryption, and RLS policy present → justify every
  deviation → route anything worth carrying forward to `../../19-FINDINGS/`.
- **Definition of done:** every consolidated element for this story has a status and evidence;
  deviations justified; the `US###`, consolidated-doc link, and date present; British English;
  DD/MM/YYYY.

## Guardrails

- **Mark an element Present only with evidence** — a migration file and symbol, never a bare
  tick. An unevidenced tick is worse than an open box, because it stops anyone looking.
- **An unexplained deviation from the consolidated schema is a defect.** State whether the
  consolidation was wrong or the build was, and route it: a consolidation error is a finding, a
  build error is a bug.
- **Record, never fix.** The correction lands in `code/`, a `../../20-BUGS/` report, or the next
  story — not in this document.
- **Never rename or back-date a filed record** — the date is load-bearing for the audit trail;
  supersede with a new record if needed.
- **Documentation only** — no migrations, models, secrets, or `.env` content.
- One record per story; do not batch stories into a single file.

## Output & naming

- **Hand-written:** one `DB-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story that shipped schema,
  from the template.
- **Template:** `DB-IMPL-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none.
- Descriptor `SCREAMING-KEBAB-CASE` (reuse the stage-1 one); story `US###`; date `DD-MM-YYYY`.
