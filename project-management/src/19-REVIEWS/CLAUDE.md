@./CONTEXT.md

# CLAUDE.md — src/19-REVIEWS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(template-only scaffold, naming, record-tier position, what the record captures —
imported above) → this file.

## Purpose (one line)

The code-review record store — one `REVIEW-US###-<DESCRIPTOR>.md` per story's branch/PR
(or a `REVIEW-<DESCRIPTOR>-DD-MM-YYYY.md` for a cross-cutting audit), capturing findings,
dimension checks, required actions, and the merge verdict.

## How to work here

- **Routing:** reviews are produced during `project-management/workflows/23-pr-and-review/`
  and the code-review workflow `code/workflows/07-review/`, run through the `review` /
  `code-reviewer` skills (security + quality), with findings written here.
- **Model:** Opus — these are implementation-phase records written during the code/PR
  phase; the write-up (findings, severities, verdict) and every mechanical touch (status
  flips, filing, renaming) are Opus work.
- **Concrete steps:** copy `REVIEW-US000-TEMPLATE.md` → name it
  `REVIEW-US###-<DESCRIPTOR>.md` → run the review against the branch → record each finding
  with an `R-0NN` ID, severity, `file:line`, and a resolution → work the dimension
  checklists (Security/GDPR/coverage/quality/performance/accessibility) via the project
  scripts under `code/src/scripts/**/*.sh` → set the verdict and status transition →
  satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** file named to convention, cross-linked to its `US###`, story
  plan, and PR; every finding driven to a resolution; every required action cleared or the
  verdict downgraded; British English; DD/MM/YYYY dates.

## Guardrails

- **Documentation only** — this folder records review outcomes; the fixes land in `code/`.
  Never paste secrets, tokens, credentials, or `.env` content into a finding; redact any
  PII in a quoted snippet.
- Security findings stay consistent with `code/docs/SECURITY.md` and the OWASP/IDOR
  obligations — a review that clears a mutation confirms its permission-check-before-logic
  and caller-ownership (no IDOR).
- **A `Changes-requested` verdict blocks the merge** — an open blocker is not a footnote;
  every Section 4 action must be `Done` and the PR re-reviewed before it merges.
- Every referenced developer command is a project script (`code/src/scripts/**/*.sh`) —
  never raw `pytest` / `pnpm` / `docker` / `python`.
- These artefacts are exempt from the 300-line instructional limit; keep them complete
  rather than truncated. This is not a memory or gaps store — blockers go to `GAPS.md`,
  patterns to `.claude/MEMORY.md`.

## Output & naming

- **Hand-written:** every `REVIEW-*.md`, from `REVIEW-US000-TEMPLATE.md`.
- **Template:** `REVIEW-US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none — nothing here is machine-produced.
- Story reviews `REVIEW-US###-<DESCRIPTOR>.md`; cross-cutting audits
  `REVIEW-<DESCRIPTOR>-DD-MM-YYYY.md`; descriptors SCREAMING-KEBAB-CASE; dates DD/MM/YYYY.
