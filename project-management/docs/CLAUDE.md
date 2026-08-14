@./CONTEXT.md

# CLAUDE.md — project-management/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(guide index, imported above) → this file → the target sub-folder's `CONTEXT.md`.

## Purpose (one line)

The PM reference guides — Git, versioning, SEO, GDPR, security, QA, planning
and responsive-design standards that the numbered `workflows/` cite when producing
artefacts under `src/`.

## How to work here

- **Routing:** these are _reference_ guides, not artefacts. Read the relevant guide
  before its workflow — `SECURITY-GUIDE.md` before `workflows/10-security-checks`,
  `QA-GUIDE.md` before `workflows/11-qa-checks`, `PLANNING-GUIDE.md` (and its
  `planning/` sub-documents) before any planning workflow. Substantive guide edits load the matching
  skill (`security`, `qa-tester`, `seo`, `gdpr-mechanics`, `git`, `version`).
- **Model:** Fable to rewrite a planning/spec guide (GDPR, security, QA, planning,
  responsive-design); Opus for the process guides (git, versioning, SEO); Opus for
  mechanical touches — version-header bumps, a redirect stub, a doc-index lookup.
- **Concrete steps:** edit the guide → keep it under the 300-code-line instructional
  cap, splitting overflow into a sub-folder (e.g. `gdpr/`) with this file as a thin
  index → cross-check any cited workflow still matches → update `CONTEXT.md` if you
  add or remove a guide. Version bumps go through `VERSIONING-GUIDE.md`.
- **Definition of done:** guide accurate and cross-linked to its workflow; ≤ 300 code
  lines; British English; `CONTEXT.md` guide table current.
- **Routing frontmatter:** every guide here carries `type`/`skills`/`model` frontmatter — read it first and route to the named skills and model (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Instructional `.md` files ≤ 300 code lines** (`cloc --include-lang=Markdown`).
  Oversized guides split into a sub-folder; the entry point becomes an index.
- **Guides specify, code enforces.** GDPR, security, and IDOR obligations described
  here must stay consistent with `code/docs/SECURITY.md` and the GDPR sub-docs — never
  contradict the enforcing layer.
- **`RESPONSIVE-DESIGN.md` is a redirect stub** — the authoritative doc is
  `code/docs/RESPONSIVE-DESIGN.md`; do not fork content back into it.
- **No secrets, `.env` content, or source** ever lands in a guide.
- Single-track semver: bump only via `VERSIONING-GUIDE.md`.

## Output & naming

- **Hand-written:** every `*.md` guide here and its sub-folder sub-documents.
- **Generated:** none — the PDFs under `../export/` are rendered from these sources,
  never hand-edited here.
- Guide files `SCREAMING-SNAKE-CASE.md`; sub-folders `kebab-case/`; stories and
  sprints cited as `US###` / `SPRINT-##`; dates DD/MM/YYYY.
