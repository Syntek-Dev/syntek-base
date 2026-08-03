# project-management/src/09-GDPR/PLANNING

Pre-implementation GDPR analysis — **one plan per user story**. Each plan analyses a
single story against `project-management/docs/GDPR-GUIDE.md` before any code is written:
what personal data it introduces, the lawful basis, retention, data-subject-rights
impact, processors touched, and the GDPR tasks to satisfy during implementation.

## Directory Tree

```text
project-management/src/09-GDPR/PLANNING/
├── CONTEXT.md                    ← this file
├── CLAUDE.md                     ← operating rules for this folder
├── GDPR-PLAN-US000-TEMPLATE.md   ← copy this to start a story's GDPR plan
└── GDPR-PLAN-US###-<DESCRIPTOR>.md  ← one plan per PII-handling story
```

## How it works

A plan is tied to a story, mirroring its post-implementation counterpart in
`../IMPLEMENTATION/`. Copy `GDPR-PLAN-US000-TEMPLATE.md` to
`GDPR-PLAN-US###-<DESCRIPTOR>.md` and complete it: the personal data the story touches,
the Art. 6 (and Art. 9) lawful basis per activity, retention periods and deletion paths,
the data-subject-rights impact, third-party processors engaged, consent/PECR
considerations, and a checklist of GDPR tasks. Those tasks are then closed — with
evidence — in the matching `../IMPLEMENTATION/GDPR-IMPL-US###-*.md` record.

The plan feeds the live registers one level up (`../DATA-INVENTORY.md`,
`../CONSENT-LAWFUL-BASIS.md`, `../RETENTION-DELETION.md`, `../THIRD-PARTY-PROCESSORS.md`):
what a story introduces here is rolled into those registers.

## When to write one

- Before implementing any story that processes personal data
- When running `project-management/workflows/09-gdpr-compliance/`
- When assessing the GDPR scope of a new story

A story with no personal data records that fact in the first two rows of the template
and needs nothing further.

## Cross-references

- `GDPR-PLAN-US000-TEMPLATE.md` — the per-story plan template
- `../IMPLEMENTATION/` — the post-implementation records that close these plans
- `../CONTEXT.md` — the GDPR folder overview and the six live registers
- `project-management/docs/GDPR-GUIDE.md` — the governing GDPR guide

**Last Updated**: <%DATE%>
