@./CONTEXT.md

# CLAUDE.md — src/07-COMPONENTS/CONSOLIDATED-IDEAS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/07-COMPONENTS/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-2 scope, the merge log — imported above) → this file.

## Purpose (one line)

Stage-2 decided component set — one `COMP-CONSOLIDATED-<FAMILY>.md` per family, merging the
per-story needs into components with variants and driving the single regeneration of
`../component-build/`.

## How to work here

- **Routing:** produced only by `workflows/17-consolidate-design-work/`, after every story has
  cleared `16-story-plans`. Consolidate alongside `../../06-BRAND-GUIDE/CONSOLIDATED-IDEAS/`.
- **Model:** Fable throughout — recognising that two needs are one component with two variants
  is design judgement. Opus only for running the generator and committing its outputs.
- **Concrete steps:** inventory every `../USER-STORY-IDEAS/` need → group the ones that are one
  component → decide the component, its variants, and its full state matrix → record the merge
  log with reasons → verify accessibility per component → edit the palette in
  `../component-build/components.py` or the relevant `section-<name>.tex` → run
  `python3 components.py` → confirm `--check` passes → commit `.py`, `section-*.tex`, `.tex`,
  `.pdf` together.
- **Definition of done:** every stage-1 need is merged, served by an existing component, or
  accepted as new — each with a reason; every consolidated component has its full state matrix
  and accessibility decided; the PDF reflects the set; British English.

## Guardrails

- **Never edit `../USER-STORY-IDEAS/`.** Stage 1 is the frozen record of what each story needed.
- **Prefer variants over new components.** Two similar needs are usually one component with two
  variants — one implementation, one state matrix, one place to fix a bug.
- **Record the merge reasoning.** A component list with no note of which needs it absorbed is
  un-reviewable, and the next cycle re-proposes the same duplicates.
- **A component without a decided focus state is not consolidated.** Full state matrix,
  keyboard interaction, and announced role are part of the decision (`code/docs/ACCESSIBILITY.md`).
- **Keep the palette identical to the brand guide** — consolidate the two together.
- **Regenerate exactly once per cycle**, here and nowhere else.
- **Section macros only** — add a macro to the preamble rather than scattering raw `tcolorbox`
  options through sections.
- **Consolidation never adds scope.** A component nobody needed is not consolidation.
- **A component change must correct any story plan that assumed the old shape.**

## Output & naming

- **Hand-written:** `COMP-CONSOLIDATED-<FAMILY>.md` from the template; the palette edit and
  `section-<name>.tex` partials in `../component-build/`.
- **Template:** `COMP-CONSOLIDATED-000-TEMPLATE.md` — the copy source; do not delete.
- **Generated (never hand-edit):** `../component-build/components.tex` and `components.pdf`.
- `<FAMILY>` in `SCREAMING-KEBAB-CASE`; contributing stories cited as `US###`; dates DD/MM/YYYY.
