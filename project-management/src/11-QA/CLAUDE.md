@./CONTEXT.md

# CLAUDE.md — src/11-QA/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the per-story PLANNING/IMPLEMENTATION split, stage table — imported above) → this file
→ the target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The QA artefact store, per story — a `PLANNING/` pre-development QA plan and an
`IMPLEMENTATION/` post-implementation QA review that gate a story from design into a
merged, verified feature.

## How to work here

- **Routing:** never write here free-hand — `PLANNING/` plans come from
  `workflows/11-qa-checks/` (after security checks and wireframe sign-off);
  `IMPLEMENTATION/` reviews come from `workflows/23-pr-and-review/`. Both are governed by
  `docs/QA-GUIDE.md`; run the heavier passes through the `qa-tester` skill.
- **Model:** Fable for the QA reasoning (scenarios, edge cases, deviation analysis,
  sign-off); Opus only for mechanical touches — filing, renaming, date-stamping.
- **Concrete steps:** pick the phase → copy that folder's `US000-TEMPLATE.md` to
  `QA-<PLAN|IMPL>-US###-<DESCRIPTOR>.md` → complete every section for the story →
  cross-link the `US###` and the paired plan/review → satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** artefact in the correct phase folder, named to convention,
  linked to its `US###`; British English; DD/MM/YYYY dates.

## Guardrails

- **Documentation only** — QA plans _specify_ accessibility, GDPR, and security
  expectations that `code/` enforces; keep them consistent with `docs/QA-GUIDE.md` and
  `code/docs/SECURITY.md`. No source, secrets, or `.env` content lands here.
- **PLANNING/ precedes IMPLEMENTATION/** — pre-development intent goes in the plan,
  verified outcomes in the review; the review answers the plan, never backfills it.
- **Per story** — one plan and one review per story, tied to a `US###`; there is no
  cross-cutting report folder.
- QA here **precedes or accompanies** development; automated results and manual guides
  live downstream in `src/18-TESTS/` — do not duplicate them here. Every new directory
  needs a `CONTEXT.md`; instructional files stay ≤ 300 code lines.

## Output & naming

- **Hand-written:** the per-story QA plans and reviews under the two sub-folders.
- **Generated:** none here — the client-facing `QA.pdf` is regenerated one level up in
  `project-management/export/`, never hand-edited.
- `PLANNING/QA-PLAN-US###-<DESCRIPTOR>.md`; `IMPLEMENTATION/QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`;
  descriptors SCREAMING-KEBAB-CASE; dates DD/MM/YYYY.
