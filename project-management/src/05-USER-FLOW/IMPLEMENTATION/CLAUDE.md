@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/05-USER-FLOW/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-3 scope, naming — imported above) → this file.

## Purpose (one line)

Stage-3 per-story records — one `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` confirming the
shipped routes and screens follow `../CONSOLIDATED-IDEAS/`.

## How to work here

- **Routing:** written during `workflows/22-implementation-documentation/` by the `doc-writer`
  skill against the consolidated journey and the shipped views, templates, and routes.
- **Model:** Opus — recording what was built against an approved journey is a documentation
  closeout. Escalate to `planner` only when a deviation needs judging.
- **Concrete steps:** copy `USER-FLOW-IMPL-US000-TEMPLATE.md` →
  `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → mark each consolidated step
  Present / Changed / Missing with the view or template as evidence → **walk every failure path
  and confirm it is reachable and handled** → cross-check data touchpoints against
  `../../09-GDPR/` → justify every deviation.
- **Definition of done:** every step of the story's slice has a status and evidence; every
  failure path verified, not assumed; deviations justified and routed; British English.

## Guardrails

- **Verify the failure paths explicitly.** A record that only walks the happy path has not
  verified the thing the consolidated journey exists to pin down.
- **Mark a step Present only with evidence** — a view, template, or route, never a bare tick.
- **An unexplained deviation from the consolidated journey is a defect.** Say whether the
  consolidation was wrong or the build was, and route it: consolidation error →
  `../../20-FINDINGS/`, build error → `../../21-BUGS/`.
- **Record, never fix** — the correction lands in `code/` or a later story.
- **Never rename or back-date a filed record** — the date is load-bearing for the audit trail.
- **Documentation only** — never code, secrets, or PII sample data.
- One record per story.
- **Section 1's step numbers are cited by a third file.** They originate in
  `../CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-<AREA>.md`, this record carries them in
  _1 — Steps implemented_, and `../../18-TESTS/MANUAL/US###-MANUAL-TESTING.md` cites them in its
  `Flow` column as `<AREA> <step>`. Renumbering a step is a three-file change, and nothing raises
  an error if one is missed. The guide's own `{AREA}-{NN}` row IDs are permanent and never follow
  a step (`../../18-TESTS/MANUAL/CLAUDE.md` → _Row IDs_).

<!-- UPDATED 09/09/2026. The 18-TESTS records were redesigned: the manual guide is now a journey
walk-through whose row IDs reuse the consolidated flow's step numbers as {AREA}-{NN} rather than
carrying a parallel set of their own, so one number identifies a flow step, this record's Section 1
line, its diagram node and the walked row. The dependency runs one way — the consolidated flow
owns the number, this record and the manual guide both cite it. Written here rather than as an ADR
because 15-DECISIONS keys every ADR to a driving story, and this was template maintenance with
none. -->

<!-- UPDATED 30/09/2026. The reuse described in the 09/09/2026 comment above is REVERSED. The
manual guide moved to "../../18-TESTS/MANUAL/" and is now authored at 17-story-plans, before
consolidation at 18 has produced the step number the old rule keyed on, so each row owns a
permanent {AREA}-{NN} ID and cites the flow step in a Flow column instead. The dependency still
runs one way — the consolidated flow owns the number, this record and the guide both cite it —
but a renumbered step now moves a Flow cell, never a row ID. The argument is recorded where the
rule now lives: "../../18-TESTS/MANUAL/CLAUDE.md". -->

## Output & naming

- **Hand-written:** one `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story, from the
  template.
- **Template:** `USER-FLOW-IMPL-US000-TEMPLATE.md` — the copy source; do not delete.
- **Generated:** none.
- Descriptor `SCREAMING-KEBAB-CASE` (reuse the stage-1 one); story `US###`; date `DD-MM-YYYY`.
