# project-management/src/08-GDPR

GDPR compliance documentation. The base repo ships this as a **fillable scaffold**: six
register skeletons every UK project needs, plus per-story planning and implementation
templates. A new project fills the registers in and adds one plan + one record per
PII-handling story.

## Directory Tree

```text
project-management/src/08-GDPR/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules for this folder
├── DATA-INVENTORY.md           ← what personal data is collected, and where
├── CONSENT-LAWFUL-BASIS.md     ← lawful basis for each processing activity
├── RETENTION-DELETION.md       ← retention periods and deletion procedures
├── DATA-SUBJECT-RIGHTS.md      ← how each Art. 15–22 right is serviced
├── BREACH-NOTIFICATION.md      ← breach response procedure (6-phase, ICO 72h)
├── THIRD-PARTY-PROCESSORS.md   ← sub-processor register (Art. 28)
├── PLANNING/                   ← pre-implementation GDPR plans, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── GDPR-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/             ← post-implementation records, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── GDPR-IMPL-US000-TEMPLATE.md
```

## The six live registers

Each is a fillable skeleton: the reusable UK-GDPR structure and boilerplate are kept,
every project-specific value is a `[EXAMPLE]` row or `{PLACEHOLDER}` to replace.

| Register                    | Records                                                             |
| --------------------------- | ------------------------------------------------------------------- |
| `DATA-INVENTORY.md`         | Every personal-data field: table, purpose, subject, encryption      |
| `CONSENT-LAWFUL-BASIS.md`   | The Art. 6/9 lawful basis for each processing activity              |
| `RETENTION-DELETION.md`     | Retention period and deletion path per data category                |
| `DATA-SUBJECT-RIGHTS.md`    | How the eight rights (Art. 15–22, Art. 7(3)) are exercised          |
| `BREACH-NOTIFICATION.md`    | Breach definition, severity, the 6-phase response, ICO 72-hour rule |
| `THIRD-PARTY-PROCESSORS.md` | Sub-processors, data transferred, transfer mechanism, Art. 28 DPA   |

Fill these as the project's data model takes shape; each story's `PLANNING/` plan rolls
its personal data up into them.

## PLANNING/ and IMPLEMENTATION/ — per story

GDPR analysis is tied to user stories at both ends: a **plan** before implementation and
a **record** after, mirroring each other.

- `PLANNING/GDPR-PLAN-US###-*.md` — pre-implementation gap analysis for one story:
  personal data, lawful basis, retention, rights impact, processors, and GDPR tasks.
- `IMPLEMENTATION/GDPR-IMPL-US###-*.md` — post-implementation verification for that
  story, closing each planned task with code evidence.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `project-management/docs/GDPR-GUIDE.md` — the governing GDPR guide
- `project-management/workflows/08-gdpr-compliance/` — the planning workflow
- `code/docs/SECURITY.md` · `code/workflows/06-gdpr-enforcement/` — the code-side
  enforcement these documents specify

**Last Updated**: <%DATE%>
