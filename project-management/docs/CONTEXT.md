# project-management/docs — PM Reference Guides

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>

The reference guides the PM workflows are judged against — git and versioning conventions,
sprint sizing, and the GDPR, security, QA and SEO standards a story has to satisfy before it is
considered specified. The workflows sequence the work; these decide what "done" means for it.

## Directory Tree

```text
project-management/docs/
├── CLAUDE.md                  ← operating rules
├── CONTEXT.md                 ← this file
├── GDPR-GUIDE.md              ← GDPR compliance — lawful basis, retention, data rights
│   └── gdpr/                  ← data-rights/ compliance/
├── GIT-GUIDE.md               ← branch strategy, commit format, PR flow, PR gates
├── QA-GUIDE.md                ← QA approach — test scenarios, QA-US###.md format, story feedback
├── RESPONSIVE-DESIGN.md       ← redirect stub → see code/docs/RESPONSIVE-DESIGN.md
├── SECURITY-GUIDE.md          ← STRIDE threat modelling, severity levels, security documentation
├── SEO-CHECKLIST.md           ← per-page SEO requirements (method: code/docs/DISCOVERABILITY.md)
├── PLANNING-GUIDE.md          ← thin index over planning/ (cadence, stories, sprints)
│   └── planning/              ← CADENCE.md · STORIES.md · SPRINTS.md
└── VERSIONING-GUIDE.md        ← two-tier semver, per-package tracks, files to update on a bump
```

| Guide                  | Scope                                                                         |
| ---------------------- | ----------------------------------------------------------------------------- |
| `GIT-GUIDE.md`         | Branch strategy, commit format, PR flow, PR gates                             |
| `VERSIONING-GUIDE.md`  | Two-tier semver, independent sub-package tracks, files to update on a bump    |
| `SEO-CHECKLIST.md`     | **What must be true per page** — the method is `code/docs/DISCOVERABILITY.md` |
| `GDPR-GUIDE.md`        | GDPR compliance guide — lawful basis, retention, data rights                  |
| `SECURITY-GUIDE.md`    | STRIDE threat modelling — use before `workflows/10-security-checks`           |
| `QA-GUIDE.md`          | QA approach and test scenario format — use before `workflows/11-qa-checks`    |
| `PLANNING-GUIDE.md`    | Planning cadence, stories, sprints (index over `planning/`)                   |
| `RESPONSIVE-DESIGN.md` | Redirect stub — authoritative doc is `code/docs/RESPONSIVE-DESIGN.md`         |
