@./CONTEXT.md

# CLAUDE.md — src/10-SECURITY/THREAT-MODEL/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the per-story PLANNING/IMPLEMENTATION split, the three frameworks — imported above) →
this file → the target sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

Scoped per-story **STRIDE threat models** — a pre-implementation plan and a
post-implementation review per story — mapping every threat to OWASP Top 10 and NIST
CSF 2.0, consumed by the posture assessments under `../ASSESSMENTS/`.

## How to work here

- **Routing:** threat models run through `project-management/workflows/10-security-checks/`
  (`STEPS.md` + `CHECKLIST.md`) against `project-management/docs/SECURITY-GUIDE.md`, using
  the `security` agent (Fable) — after wireframes are signed off and the GDPR review is
  complete, before sprint planning. Write a story's `PLANNING/` model before implementing
  it; the code-side enforcement lives in `code/docs/SECURITY.md`.
- **Model:** Fable for every threat model and review — STRIDE analysis and re-assessment
  is substantive judgement; Opus only for a status flip, a date-header bump, or a rename.
- **Concrete steps:** copy the `PLANNING/` template →
  `THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` → complete scope, the `TB1..TBn` table, and
  the STRIDE threat table → escalate blocking CRITICAL/HIGH findings to
  `../VULNERABILITIES/PLANNING/` → after the PR, copy the `IMPLEMENTATION/` template and
  re-assess each threat with code evidence.
- **Definition of done:** every threat carries STRIDE + OWASP + NIST columns, a severity,
  a status, and a mitigation; blocking findings escalated; the plan and review paired by
  `US###`; British English; DD/MM/YYYY; every new sub-directory carries a `CONTEXT.md`.

## Guardrails

- **Documentation only — never code, secrets, credentials, or live exploit payloads land
  here.** Threats are _specified_ here and _enforced_ in `code/`; keep them consistent
  with `code/docs/SECURITY.md`. Templates ship with `[EXAMPLE]` rows only — no findings.
- **PLANNING/ precedes IMPLEMENTATION/** — a story's plan must exist before its review;
  do not skip straight to a review. The review re-assesses each planned threat as
  Mitigated / Residual / New with evidence.
- **One model per story** — do not batch multiple stories into one file. STRIDE is the
  primary categorisation on every threat; never omit the OWASP or NIST CSF column.
- `CONTEXT.md`/`CLAUDE.md` files stay ≤ 300 code lines; the artefacts and templates are exempt.

## Output & naming

- **Hand-written:** the per-story `PLANNING/THREAT-MODEL-PLAN-US###-*.md` and
  `IMPLEMENTATION/THREAT-MODEL-IMPL-US###-*.md`, from the two templates.
- **Generated:** none here — `SECURITY.pdf` under `project-management/export/` is
  regenerated from these sources, never hand-edited.
- Sub-folders `PLANNING/` and `IMPLEMENTATION/`; descriptor `SCREAMING-KEBAB-CASE`;
  story `US###`; implementation dates `DD-MM-YYYY`.
