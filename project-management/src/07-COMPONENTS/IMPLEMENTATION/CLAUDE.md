@./CONTEXT.md

# CLAUDE.md — src/07-COMPONENTS/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/07-COMPONENTS/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-3 scope, states-and-focus — imported above) → this file.

## Purpose (one line)

Stage-3 per-story records — one `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` confirming the
components a story used are implemented and match `../CONSOLIDATED-IDEAS/`.

## How to work here

- **Routing:** written during `workflows/21-implementation-documentation/` by the `doc-writer`
  agent against the consolidated set and the shipped django-components.
- **Model:** Opus — verifying components landed is mechanical. Escalate to `frontend` (Fable)
  where a deviation needs judging.
- **Concrete steps:** copy `COMP-IMPL-US000-TEMPLATE.md` →
  `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → confirm each component present with its
  variants → **exercise every state in the running build**, not the template → run the
  accessibility checks (keyboard traversal, focus visibility, contrast, announced role) →
  justify any deviation.
- **Definition of done:** every component and variant verified present; every state exercised;
  accessibility checks run and recorded; deviations justified and routed; British English.

## Guardrails

- **Exercise the states, do not read them.** A state confirmed by looking at the template rather
  than the running build is unverified — disabled, error, and focus are exactly the ones that
  ship broken.
- **Focus indicator is a hard check.** An interactive component with no visible focus state
  fails WCAG 2.2 AA and is a blocker, not a nit (`code/docs/ACCESSIBILITY.md`).
- **A component used but absent from the consolidated set is a deviation.** Say whether
  consolidation missed it or the build invented it: consolidation gap → `../../19-FINDINGS/`,
  invented component → `../../20-BUGS/`.
- **Record, never fix** — corrections land in `code/`.
- **Never rename or back-date a filed record.**
- **Documentation only** — no component code, no secrets.
- One record per story.

## Output & naming

- **Hand-written:** one `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story, from the template.
- **Template:** `COMP-IMPL-US000-TEMPLATE.md` — the copy source; do not delete.
- **Generated:** none — `../component-build/` is not touched at this stage.
- Descriptor `SCREAMING-KEBAB-CASE` (reuse the stage-1 one); story `US###`; date `DD-MM-YYYY`.
