@./CONTEXT.md

# CLAUDE.md — src/08-WIREFRAMES/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/08-WIREFRAMES/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-3 scope, contract-not-markup — imported above) → this file.

## Purpose (one line)

Stage-3 per-story records — one `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` confirming the
shipped Django templates honour the consolidated screens in `../CONSOLIDATED-IDEAS/`.

## How to work here

- **Routing:** written during `workflows/22-implementation-documentation/` by the `doc-writer`
  skill against the consolidated screens and the shipped templates.
- **Model:** Opus — verifying a page matches an approved layout is a documentation closeout.
  Escalate to `frontend` (Fable) where a deviation needs judging.
- **Concrete steps:** copy `WF-IMPL-US000-TEMPLATE.md` →
  `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → mark each consolidated screen
  Present / Changed / Missing with the Django template as evidence → **open the running page at
  every declared breakpoint** → run the accessibility pass → justify any deviation.
- **Definition of done:** every screen has a status and evidence; breakpoints checked against
  the running page, not the wireframe; accessibility pass recorded; deviations routed.

## Guardrails

- **Check the contract, not the resemblance.** The shipped page is a Django template with
  django-components, HTMX, and token CSS — it will not look like the wireframe markup. What must
  hold is layout, hierarchy, states, and interaction.
- **Open the running page.** A breakpoint confirmed from the wireframe rather than the built
  page has verified nothing about what ships.
- **Accessibility is verified here, not assumed** — heading order, focus order, skip link, and
  contrast against the live page (`code/docs/ACCESSIBILITY.md`).
- **A screen built but absent from the consolidated set is a deviation.** Consolidation gap →
  `../../20-FINDINGS/`; unplanned screen → `../../21-BUGS/` or a new `US###`.
- **Record, never fix** — corrections land in `code/`.
- **Never rename or back-date a filed record.**
- **Documentation only** — no template code, no secrets.
- One record per story.

## Output & naming

- **Hand-written:** one `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story, from the template.
- **Template:** `WF-IMPL-US000-TEMPLATE.md` — the copy source; do not delete.
- **Generated:** none.
- Descriptor `SCREAMING-KEBAB-CASE`; story `US###`; date `DD-MM-YYYY`.
