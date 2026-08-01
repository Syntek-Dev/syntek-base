# project-management/src/09-SECURITY/THREAT-MODEL/IMPLEMENTATION

Post-implementation threat-model reviews — **one per user story**. Each review
re-assesses, against the shipped code, the threats identified in a story's
pre-implementation model in `../PLANNING/`, marking every threat
Mitigated / Residual / New and signing the model off.

## Directory Tree

```text
project-management/src/09-SECURITY/THREAT-MODEL/IMPLEMENTATION/
├── CONTEXT.md                            ← this file
├── CLAUDE.md                             ← operating rules for this folder
├── THREAT-MODEL-IMPL-US000-TEMPLATE.md   ← copy this to record a story's review
└── THREAT-MODEL-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one review per story
```

## File naming

```text
THREAT-MODEL-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `THREAT-MODEL-IMPL-US000-CONTACT-FORM-01-01-2026.md`. Reuse the same
`<DESCRIPTOR>` as the story's planning model.

## When to create a file here

Write a review during `project-management/workflows/09-security-checks/` once a story's
implementation is complete. Copy `THREAT-MODEL-IMPL-US000-TEMPLATE.md`, open the story's
plan in `../PLANNING/THREAT-MODEL-PLAN-US###-*.md`, and re-assess each threat.

## What belongs in each review

- Story reference (US###) and date, and a link to the pre-implementation model
- Scope confirmation — the files re-assessed and any surface that changed
- The STRIDE re-assessment table — each threat marked Mitigated / Residual / New, a
  `Mitigated` row citing the shipped code that mitigates it
- New threats found during implementation, any escalated to
  `../../VULNERABILITIES/IMPLEMENTATION/`
- Residual and deferred items, each a known, tracked residual
- A sign-off block with the overall verdict

## Cross-references

- `THREAT-MODEL-IMPL-US000-TEMPLATE.md` — the per-story review template
- `../PLANNING/` — the pre-implementation models these reviews close
- `../CONTEXT.md` — the threat-model overview and the three frameworks
- `../../ASSESSMENTS/IMPLEMENTATION/` — the assessments that consume these reviews
- `../../VULNERABILITIES/IMPLEMENTATION/` — newly found CRITICAL/HIGH findings
- `project-management/workflows/09-security-checks/` — where these reviews are written

**Last Updated**: {{DATE}}
