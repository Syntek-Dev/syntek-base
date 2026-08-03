# project-management/src/09-GDPR/IMPLEMENTATION

Post-implementation GDPR verification records — **one per user story**. Each record
confirms, with evidence, that a story's GDPR requirements were met in the shipped code,
and closes the open tasks from its pre-implementation plan in `../PLANNING/`.

## Directory Tree

```text
project-management/src/09-GDPR/IMPLEMENTATION/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── GDPR-IMPL-US000-TEMPLATE.md       ← copy this to record a story's verification
└── GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one record per PII-handling story
```

## File naming

```text
GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `GDPR-IMPL-US000-CONTACT-FORM-01-01-2026.md`.

## When to create a file here

Write a record during `project-management/workflows/21-implementation-documentation/` for any story
that processes personal data. Copy `GDPR-IMPL-US000-TEMPLATE.md`, open the story's plan
in `../PLANNING/GDPR-PLAN-US###-*.md`, and document how each planned requirement was met.

## What belongs in each record

- Story reference (US###) and date, and a link to the pre-implementation plan
- Data flows implemented and their lawful bases, with code evidence
- Retention periods configured and the deletion mechanism shipped
- Data subject rights verified (access, erasure, portability)
- Third-party processors touched and their Art. 28 DPA status
- Each plan gap closed **with evidence**, and any justified deviation

## Cross-references

- `GDPR-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../PLANNING/` — the pre-implementation plans these records answer
- `../CONTEXT.md` — the GDPR folder overview and the six live registers
- `project-management/workflows/21-implementation-documentation/` — where these records are written

**Last Updated**: <%DATE%>
