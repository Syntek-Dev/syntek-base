@./CONTEXT.md

# CLAUDE.md — workflows/22-pr-and-review/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, governing documents — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The PR lifecycle workflow — raise, review, and merge a completed feature branch
through the branch promotion chain once tests pass, linters are clean, and a QA pass
has been run.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `git`
  skill for the branch/PR mechanics and `review` for the code review
  (both Opus). The hard gate `docs/GIT-GUIDE.md` (branch promotion chain) must be read
  before raising any PR.
- **Model:** Opus for the security/quality review and mechanical touches
  (version-header bumps, status flips).
- **Concrete steps:** confirm tests green and linters clean → review against
  `code/docs/CODING-PRINCIPLES.md`, `SECURITY.md`, and
  `security/OWASP-AND-CHECKLIST.md` → verify coverage floors
  (`testing/COVERAGE.md`: 75% line and branch / 90% auth — one floor) → verify the GDPR,
  security, QA, SEO, and API **implementation** records (written in
  `workflows/21-implementation-documentation`) are complete, and write the code-review
  and test records → merge through the promotion chain → satisfy `CHECKLIST.md`.
- **Definition of done:** PR reviewed and merged per the branch chain; the implementation
  records (from `21`) verified complete and the review/test records written; version
  bumped via `docs/VERSIONING-GUIDE.md` if the PR completes a release.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **A PR is not mergeable until this workflow is signed off** — the branch promotion
  chain gates are blocking.
- **Documentation hard gate:** the implementation records and `CONTEXT.md`/`CLAUDE.md`
  closeout (authored in `workflows/21-implementation-documentation`) must be complete
  before merge — this workflow **verifies** them, it does not write them.
- Review verifies the non-negotiables actually hold in the diff: every mutation
  permission-checked, no IDOR, token-first CSS, coverage floors met.
- Version bumps only via `docs/VERSIONING-GUIDE.md` / `version`. Instructional `.md`
  files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the PR-stage review record
  `REVIEW-US###-*.md` in `src/18-REVIEWS/` and the test records in `src/17-TESTS/`. The
  GDPR/security/QA/SEO/API implementation records are authored in
  `workflows/21-implementation-documentation`, not here.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
