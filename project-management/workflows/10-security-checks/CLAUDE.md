@./CONTEXT.md

# CLAUDE.md — workflows/10-security-checks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, frameworks — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The design-stage security workflow — threat-model the planned user flows and
wireframes with STRIDE, OWASP Top 10, and NIST CSF 2.0, and record findings in
`src/10-SECURITY/` before a line of code is written.

## How to work here

- **Routing:** run `STEPS.md` in order; drive the heavier analysis with the
  `security` skill (Fable). The hard gate
  `docs/SECURITY-GUIDE.md` must be read before Step 1. Prerequisites: user flows,
  signed-off wireframes, and the GDPR review (`workflows/09-gdpr-compliance`).
- **Model:** Fable for all threat modelling and findings; Opus for mechanical
  touches (status flips, moving a file).
- **Concrete steps:** read `docs/SECURITY-GUIDE.md` → threat-model each flow/wireframe
  → map every finding to STRIDE + OWASP A01–A10 + a NIST CSF function → write to
  `src/10-SECURITY/` under the right sub-dir (`THREAT-MODEL/`, `ASSESSMENTS/`,
  `AUDITS/`, `VULNERABILITIES/`) → satisfy `CHECKLIST.md`.
- **Definition of done:** every finding framework-mapped and severity-rated; any
  blocking finding resolved before sprint planning; checklist satisfied; the
  technical requirements it implies are consistent with `code/docs/SECURITY.md`.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **This is a documentation workflow — no code, no secrets, no `.env` in `src/`.**
  Obligations are _specified_ here and _enforced_ in `code/`.
- **No finding may be left unmapped:** STRIDE category, OWASP A01–A10, and NIST CSF
  function are all required per finding.
- Threat modelling gates sprint planning — proceed to `workflows/15-sprint-plans/`
  only once blocking findings are cleared and QA (`workflows/11-qa-checks`) is next.
- Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; findings under `src/10-SECURITY/`
  (`AUDIT-*.md`, `ASSESSMENT-US###`, threat models) linked to their `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
