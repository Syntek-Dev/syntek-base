# project-management/docs — PM Reference Guides

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Quick navigation of PM guides and workflows
**MCP Servers:** None (pure index documentation)

## Directory Tree

```text
project-management/docs/
├── CONTEXT.md                 ← this file
├── GDPR-GUIDE.md              ← GDPR compliance — lawful basis, retention, data rights
│   └── gdpr/                  ← data-rights/ compliance/
├── GIT-GUIDE.md               ← branch strategy, commit format, PR flow, PR gates
├── QA-GUIDE.md                ← QA approach — test scenarios, QA-US###.md format, story feedback
├── RESPONSIVE-DESIGN.md       ← redirect stub → see code/docs/RESPONSIVE-DESIGN.md
├── SECURITY-GUIDE.md          ← STRIDE threat modelling, severity levels, security documentation
├── SEO-CHECKLIST.md           ← SEO and AI discoverability checklist for all frontend pages
├── SPRINT-PLANNING-GUIDE.md   ← MoSCoW prioritisation, SPRINT-PLAN-##.md format, phase breakdown
└── VERSIONING-GUIDE.md        ← two-tier semver, per-package tracks, files to update on a bump
```

| Guide                      | Scope                                                                      |
| -------------------------- | -------------------------------------------------------------------------- |
| `GIT-GUIDE.md`             | Branch strategy, commit format, PR flow, PR gates                          |
| `VERSIONING-GUIDE.md`      | Two-tier semver, independent sub-package tracks, files to update on a bump |
| `SEO-CHECKLIST.md`         | SEO and AI discoverability checklist for all frontend pages                |
| `GDPR-GUIDE.md`            | GDPR compliance guide — lawful basis, retention, data rights               |
| `SECURITY-GUIDE.md`        | STRIDE threat modelling — use before `workflows/09-security-checks`        |
| `QA-GUIDE.md`              | QA approach and test scenario format — use before `workflows/10-qa-checks` |
| `SPRINT-PLANNING-GUIDE.md` | Sprint plan structure and MoSCoW — use before `workflows/14-sprint-plans`  |
| `RESPONSIVE-DESIGN.md`     | Redirect stub — authoritative doc is `code/docs/RESPONSIVE-DESIGN.md`      |
