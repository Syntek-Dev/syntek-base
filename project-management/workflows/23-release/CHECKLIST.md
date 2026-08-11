---
workflow: 23-release
phase: ship
agent: release
skills: [global-workflow]
model: opus
---

# Release — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (VERSIONING-GUIDE.md, GIT-GUIDE.md) · **External — Version Control & CI** (Semantic Versioning, Conventional Commits) for supporting references.

## Execution Checklist

- [ ] Renew `security.txt` `Expires` date — set to 12 months from today, updating the `/.well-known/security.txt` file served by the Django site
- [ ] Version bumped correctly (patch / minor / major)
- [ ] All version files updated: `VERSION`, `CHANGELOG.md`, `RELEASES.md`, `VERSION-HISTORY.md`
- [ ] `pyproject.toml` version matches
- [ ] **If this release bumped `code/src/mobile/`** (`app.json` `expo.version` moved):
      `how-to/src/STORE-LISTING.md` carries this release's What's New / release-notes text, with
      its **Used** count filled, and the same text is entered in App Store Connect and the Play
      Console. Nothing in this repository can verify the store side — it is a review artefact,
      not an audit artefact (`code/docs/discoverability/APP-STORE.md`)
- [ ] Full test suite passes
- [ ] Deployed to production successfully

---

## Database Security Gates (DB13, DB16)

These must be confirmed before any production release that includes database migrations or infrastructure changes.

- [ ] [DB13] PostgreSQL `log_statement` confirmed as `none` in staging and production — query content (including potential PII) must not be logged
- [ ] [DB16] `ADMIN_DATABASE_URL` (BYPASSRLS role) confirmed as stored in secrets manager only — not present in any `.env` file, CI/CD log, or application config file

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Tag created and pushed
- [ ] Production deployment confirmed healthy
