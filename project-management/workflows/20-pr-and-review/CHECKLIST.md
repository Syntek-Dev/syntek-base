---
workflow: 20-pr-and-review
phase: ship
agent: pr
skills: [global-workflow]
model: opus
---

# PR and Code Review — Checklist

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (GIT-GUIDE.md) · **External — Version Control & CI** · **Internal — Live Artefacts** (src/08–12 IMPLEMENTATION/ directories) for supporting references.

## Execution Checklist

- [ ] All tests pass locally before opening PR
- [ ] Linters clean (backend + frontend)
- [ ] QA agent pass completed
- [ ] Code review agent pass completed
- [ ] PR targets `testing` branch (not `dev`, `staging`, or `main`)
- [ ] PR description includes story reference, summary, and test plan
- [ ] CI passes on `testing`
- [ ] QA sign-off received

---

## Implementation records

### Verify — authored in `19-implementation-documentation` (do not write here)

If any applicable record below is missing or incomplete, return to
`19-implementation-documentation` before proceeding — do not write it here.

- [ ] GDPR implementation record complete (`src/08-GDPR/IMPLEMENTATION/`)
- [ ] Security assessment / audit / threat-model reviews complete (`src/09-SECURITY/<CATEGORY>/IMPLEMENTATION/`)
- [ ] Vulnerability closure present if this story resolved a known vulnerability (`src/09-SECURITY/VULNERABILITIES/IMPLEMENTATION/`)
- [ ] QA implementation review complete (`src/10-QA/IMPLEMENTATION/`)
- [ ] SEO implementation review complete if story adds public-facing pages (`src/11-SEO/IMPLEMENTATION/`)
- [ ] API design verification complete if story adds or changes the Django Ninja API (`src/12-API-DESIGN/IMPLEMENTATION/`)

### Write — PR-stage records (outputs of Steps 1–2)

- [ ] Code review record written (`REVIEW-US###-<descriptor>[-DD-MM-YYYY].md` → `src/17-REVIEWS/`)
- [ ] Test status record written (`US###-TEST-STATUS.md` → `src/16-TESTS/`)
- [ ] Manual testing guide written (`US###-MANUAL-TESTING.md` → `src/16-TESTS/`)

### Record quality

- [ ] Findings record present for the story (`src/18-FINDINGS/`) — written even when nothing was found
- [ ] Every applicable IMPLEMENTATION record (from `19`) verified present and complete before merge
- [ ] Any newly discovered Critical or High findings escalated to `src/09-SECURITY/VULNERABILITIES/IMPLEMENTATION/` and fed back to `19`

### Knowledge files

- [ ] Open issues from implementation docs logged in `/GAPS.md` (security, architectural, infrastructure gaps)
- [ ] Cross-story deferred items logged in `/DEFERRED.md`

---

## Context

- [ ] Documentation closeout from `19-implementation-documentation` (CONTEXT/CLAUDE updates + code-review-graph refresh) confirmed complete
- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Feature merged to `testing`
- [ ] Promoted through chain per `project-management/docs/GIT-GUIDE.md` gate rules
