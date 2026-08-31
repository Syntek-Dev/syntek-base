@./CONTEXT.md

# CLAUDE.md — src/15-DECISIONS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(ADR register + naming, imported above) → this file.

## Purpose (one line)

The Architecture Decision Record store — one immutable
`ADR-US###-<DECISION>-DD-MM-YYYY.md` per significant technical or design decision,
capturing status, context, options considered, decision, and consequences.

## How to work here

- **Routing:** an ADR is authored, not scaffolded — write it directly here. Reach for
  it during architectural work via `planner`; a decision that changes a
  build or deploy path is drafted alongside the relevant `code/workflows/` procedure.
  Ground a contested decision or stack choice with a primary-source-cited note via
  `.claude/skills/research/SKILL.md` (ADR groundwork).
- **Model:** Fable — an ADR is a reasoned trade-off document (context, options,
  consequences); Opus for a mechanical status flip (e.g. `accepted` →
  `superseded`) or a typo fix.
- **Concrete steps:** create `ADR-US###-<DECISION>-DD-MM-YYYY.md` for the driving story
  → fill the five sections (**Status**, **Context**, **Options considered**,
  **Decision**, **Consequences**) → cross-link the `US###` that drove or consumes the
  decision → set Status to `accepted` when signed off.
- **Definition of done:** decision named to convention, five sections complete,
  superseded ADRs cross-referenced both ways, British English throughout.

## Guardrails

- **An ADR argues a trade-off; it does not enforce one.** The doctrine guide, and the
  `CONTEXT.md`/`CLAUDE.md` pair for the directory it governs, are where a rule is **enforced**;
  the ADR is where the reasoning that produced it is **argued**. Neither replaces the other, and
  an ADR that states a rule without arguing for it belongs in the guide instead.
- **An ADR needs a driving `US###`** — the trade-off comes from somewhere real, never invented in
  the abstract. This is what stops a feature map authoring one directly: a map's decision reaches
  an ADR through the slice that becomes a story.
- **Written when the decision is surfaced, not held to the end.** PM steps `04`–`14` each author
  the ADR for the trade-off they raise — a schema shape at `04-database-schema`, an RLS scope
  there too, a session strategy at `10-security-checks`. Workflow `15` then **checks the story's
  ADRs hold true and do not clash**; it is the coherence gate, not the sole author.
- **Accepted ADRs are immutable** — never rewrite the decision in place. To change
  course, raise a new ADR and mark the old one `superseded`, cross-referencing the
  replacement ADR by **full filename**; note the supersession on both records.
- **There is no index.** The monotonic `ADR-###` counter was retired 31/08/2026 with the rename:
  the story number and the date carry the identity, exactly as `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`
  already does in `../21-BUGS/`. Two ADRs for one story on one day are distinguished by
  `<DECISION>`, which must differ.
- **This is a documentation folder** — no source, secrets, or `.env` content; an ADR
  states a security or architecture _decision_, it is enforced in `code/`.
- Instructional `.md` limit does not apply to these root-level `src/` artefacts, but
  keep each ADR focused on a single decision.

## Output & naming

- **Hand-written:** every `ADR-US###-<DECISION>-DD-MM-YYYY.md` in this folder.
- **Generated:** none — nothing here is machine-produced.
- Naming: `ADR-US###-<DECISION>-DD-MM-YYYY.md` — the driving story, the decision it governs in
  `SCREAMING-SNAKE-CASE`, and the date it was made. **Flat, no subdirectories**: the `US###`
  prefix already groups a story's records on any `ls`, and a per-story folder would owe a
  `CONTEXT.md` + `CLAUDE.md` pair under `docs-pairing.sh`, which exempts only
  `code/src/scripts/**/reports`.
