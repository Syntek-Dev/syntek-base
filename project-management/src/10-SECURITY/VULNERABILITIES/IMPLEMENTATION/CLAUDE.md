@./CONTEXT.md

# CLAUDE.md — 10-SECURITY/VULNERABILITIES/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each closure — imported above) → this file.

## Purpose (one line)

Post-implementation vulnerability closures — one per Critical/High vulnerability,
proving with code evidence that a `../PLANNING/` finding is fixed and closing it Resolved.

## How to work here

- **Routing:** written during `project-management/workflows/21-implementation-documentation/` once the
  remediation story ships, using the `security` skill (Fable), against the finding in
  `../PLANNING/VULN-PLAN-US###-*.md`. Standards:
  `project-management/docs/SECURITY-GUIDE.md`.
- **Model:** Fable — confirming the fix, mapping each control to shipped code, and
  judging residual risk is substantive; Opus only for a status flip or a date touch-up.
- **Concrete steps:** copy `VULN-IMPL-US000-TEMPLATE.md` →
  `VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the finding → restate it → close
  each control with a code reference and named tests → record residual risk and any
  justified deviation → cite the Resolved-in PR/SHA → flip the planning record to
  Resolved and reference this closure from `../../ASSESSMENTS/IMPLEMENTATION/` and
  `../../AUDITS/IMPLEMENTATION/`.
- **Definition of done:** every control from the plan is answered; verification is named;
  residual risk and deviations stated; the `US###`, plan-doc link, PR/SHA, and date are
  present; British English; DD/MM/YYYY.

## Guardrails

- **Never close without evidence** — a closure asserts the fix was confirmed; state the
  test names or manual steps and point at the shipped code (or a `GAPS.md` / story owner)
  for every control. Do not mark a control done with a bare tick.
- **Documentation only** — the actual fix lives in `code/`, verified against
  `code/docs/SECURITY.md`; this file evidences closure, it does not patch.
- Reuse the **exact `<DESCRIPTOR>`** of the planning finding; one closure per
  vulnerability, per story.
- **Only safe-to-document detail** — no live secrets, tokens, or exploit payloads.

## Output & naming

- **Hand-written:** `VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, one per resolved
  finding, from the template.
- **Generated:** none.
- `<DESCRIPTOR>` `SCREAMING-KEBAB-CASE` (matching the plan); story `US###`; date
  `DD-MM-YYYY`.
