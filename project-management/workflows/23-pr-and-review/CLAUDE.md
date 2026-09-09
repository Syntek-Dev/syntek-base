@./CONTEXT.md

# CLAUDE.md — workflows/23-pr-and-review/

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
  `code/docs/CODING-PRINCIPLES.md`, `code/docs/SECURITY.md`, and
  `security/OWASP-AND-CHECKLIST.md` → verify coverage floors
  (`testing/COVERAGE.md`: 75% line and branch / 90% auth — one floor) → verify the GDPR,
  security, QA, SEO and API **implementation** records **and** the two test records in
  `src/18-TESTS/` (all written in `workflows/22-implementation-documentation`) are complete,
  and write the code-review record → merge through the promotion chain → satisfy
  `CHECKLIST.md`. What "complete" means for the test records is `STEPS.md` Step 6 — it is a
  read, not a presence check.
- **Definition of done:** PR reviewed and merged per the branch chain; the implementation
  and test records (from `22`) verified complete and the code-review record written; version
  bumped via `docs/VERSIONING-GUIDE.md` if the PR completes a release.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **A PR is not mergeable until this workflow is signed off** — the branch promotion
  chain gates are blocking.
- **Documentation hard gate:** the implementation records, both `src/18-TESTS/` test
  records, and the `CONTEXT.md`/`CLAUDE.md` closeout (all authored in
  `workflows/22-implementation-documentation`) must be complete before merge — this
  workflow **verifies** them, it does not write them.
- Review verifies the non-negotiables actually hold in the diff: every mutation
  permission-checked, no IDOR, token-first CSS, coverage floors met.
- Version bumps only via `docs/VERSIONING-GUIDE.md` / `version`. Instructional `.md`
  files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; and the one PR-stage record this workflow
  produces — the review record `REVIEW-US###-*.md` in `src/19-REVIEWS/`. The
  GDPR/security/QA/SEO/API implementation records and both `src/18-TESTS/` test records are
  authored in `workflows/22-implementation-documentation` and only verified here.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.

<!-- UPDATED 09/09/2026. The two "src/18-TESTS/" test records moved out of this workflow's
     Write table and into its Verify table, settled by the grilling pass of 09/09/2026 and
     argued here rather than in an ADR because "src/15-DECISIONS/" keys every record to a
     driving story and this change ships as template maintenance under no US###.

     Three files disagreed about who wrote them, so nobody did. This STEPS.md listed both
     files under "Write (PR-stage records)";
     "../22-implementation-documentation/CLAUDE.md" declared itself the author of every
     implementation record while its own Step 3 table omitted 18-TESTS; and
     "../../src/18-TESTS/CLAUDE.md" said the code workflows wrote them and this workflow
     finalised them. Zero records were ever written. 22 writes, 23 verifies — the same rule
     the GDPR, security, QA, SEO and API records already followed here.

     The verification is deliberately substantive rather than a presence tick. A record that
     exists proves nothing: the generated block can predate the last suite run, a manual row
     can sit with an empty Result, and a green automated half can sit beside a failing manual
     row. That last case is a MISSING TEST, not a passing story, which is why Step 6 sends it
     back to 22 rather than letting the suites speak for the walk. -->
