---
workflow: 23-pr-and-review
phase: ship
skills: [pr, global-workflow]
model: opus
---

# PR and Code Review — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Guides** (GIT-GUIDE.md) · **External — Version Control & CI** · **Internal — Live Artefacts** (src/09–13 IMPLEMENTATION/ directories, src/18-TESTS/) for supporting references.

## Execution Checklist

- [ ] All tests pass locally before opening PR
- [ ] Linters clean (backend + frontend)
- [ ] `qa-tester` pass completed
- [ ] `code-reviewer` pass completed
- [ ] PR targets `testing` branch (not `dev`, `staging`, or `main`)
- [ ] PR description includes story reference, summary, and test plan
- [ ] CI passes on `testing`
- [ ] QA sign-off received

---

## Implementation records

### Verify — authored in `22-implementation-documentation` (do not write here)

If any applicable record below is missing or incomplete, return to
`22-implementation-documentation` before proceeding — do not write it here.

- [ ] GDPR implementation record complete (`src/09-GDPR/IMPLEMENTATION/`)
- [ ] Security assessment / audit / threat-model reviews complete (`src/10-SECURITY/<CATEGORY>/IMPLEMENTATION/`)
- [ ] Vulnerability closure present if this story resolved a known vulnerability (`src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION/`)
- [ ] QA implementation review complete (`src/11-QA/IMPLEMENTATION/`)
- [ ] SEO implementation review complete if story adds public-facing pages (`src/12-SEO/IMPLEMENTATION/`)
- [ ] API design verification complete if story adds or changes the Django Ninja API (`src/13-API-DESIGN/IMPLEMENTATION/`)
- [ ] Automated test record complete (`US###-TEST-STATUS.md` → `src/18-TESTS/`) — its generated block regenerated against the **last** suite run, not an earlier green one
- [ ] A short per-test table checked against `bash code/src/scripts/audits/story-markers.sh` before it is read as coverage — an unmarked test is silently absent from the record, never reported as missing
- [ ] Manual journey guide complete (`US###-MANUAL-TESTING.md` → `src/18-TESTS/`) — every row's `Result` marked `Pass` or `Fail`, none left empty (an empty `Result` means the step was not run)
- [ ] Every `Fail` carries its reason in `Notes` and a row in the manual guide's _Failures_ table, routed before merge exactly as `src/20-FINDINGS/` routes a finding
- [ ] No green `TEST-STATUS` sitting beside a failing manual row — that is a missing test, not a passing story

### Write — PR-stage record (output of Steps 1–2)

- [ ] Code review record written (`REVIEW-US###-<descriptor>[-DD-MM-YYYY].md` → `src/19-REVIEWS/`)

### Record quality

- [ ] Findings record present for the story (`src/20-FINDINGS/`) — written even when nothing was found
- [ ] Every applicable IMPLEMENTATION record (from `22-implementation-documentation`) verified present and complete before merge
- [ ] Any newly discovered Critical or High findings escalated to `src/10-SECURITY/VULNERABILITIES/IMPLEMENTATION/` and fed back to `22-implementation-documentation`

### Knowledge files

- [ ] Open issues from implementation docs logged in `/GAPS.md` (security, architectural, infrastructure gaps)
- [ ] Cross-story deferred items logged in `/DEFERRED.md`

---

## Context

- [ ] Documentation closeout from `22-implementation-documentation` (CONTEXT/CLAUDE updates + code-review-graph refresh) confirmed complete
- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] Feature merged to `testing`
- [ ] Promoted through chain per `project-management/docs/GIT-GUIDE.md` gate rules
