@./CONTEXT.md

# CLAUDE.md — src/05-USER-FLOW/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/05-USER-FLOW/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-3 scope, naming — imported above) → this file.

## Purpose (one line)

Stage-3 per-story records — one `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` confirming the
shipped routes and screens follow `../CONSOLIDATED-IDEAS/`.

## How to work here

- **Routing:** written during `workflows/21-implementation-documentation/` by the `doc-writer`
  agent against the consolidated journey and the shipped views, templates, and routes.
- **Model:** Opus — recording what was built against an approved journey is a documentation
  closeout. Escalate to `planner` (Fable) only when a deviation needs judging.
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
  `../../19-FINDINGS/`, build error → `../../20-BUGS/`.
- **Record, never fix** — the correction lands in `code/` or a later story.
- **Never rename or back-date a filed record** — the date is load-bearing for the audit trail.
- **Documentation only** — never code, secrets, or PII sample data.
- One record per story.

## Output & naming

- **Hand-written:** one `USER-FLOW-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story, from the
  template.
- **Template:** `USER-FLOW-IMPL-US000-TEMPLATE.md` — the copy source; do not delete.
- **Generated:** none.
- Descriptor `SCREAMING-KEBAB-CASE` (reuse the stage-1 one); story `US###`; date `DD-MM-YYYY`.
