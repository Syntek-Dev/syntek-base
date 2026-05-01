# User Story Creation — Checklist

**Last Updated**: 01/05/2026 **Version**: 1.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Template

- [ ] File was created by copying `US000-TEMPLATE.md` — not written from scratch
- [ ] Heading updated: `# US### — [Story Title]` with the correct story number
- [ ] Template placeholder comments removed from the final file

## Flags

- [ ] All 8 flag rows are completed — no row left as a placeholder value
- [ ] DB flag: shortlist of model names or `N/A`
- [ ] User Flow flag: `Yes` or `N/A`
- [ ] Backend flag: `Yes` or `N/A`
- [ ] API flag: shortlist of mutation / query names or `N/A`
- [ ] Frontend flag: `Web`, `Mobile`, `Web + Mobile`, or `N/A` — never just `Yes`
- [ ] GDPR flag: `Yes` or `N/A`
- [ ] Security flag: shortlist of concerns or `N/A`
- [ ] Testing flag: shortlist of test types or `N/A`
- [ ] Every section whose flag is `N/A` has been removed from the file

## Story metadata

- [ ] User Story follows the format: "As a [role], I want [capability], so that [benefit]."
- [ ] MoSCoW priority is set: Must Have / Should Have / Could Have / Won't Have
- [ ] Story Points are estimated (not left as `[N]`)
- [ ] Dependencies list upstream stories and any external services required

## Acceptance Criteria

- [ ] Overview section has at least one Gherkin scenario for the happy path and one for a failure case
- [ ] All domain subsections present for flags that are not N/A
- [ ] DB subsection: model structure scenario and constraint enforcement scenario included
- [ ] User Flow subsection: authenticated happy path, unauthenticated redirect, and access-denied scenarios included
- [ ] Backend subsection: service method success, validation error, and permission error items included
- [ ] API subsection: success path, 401, and 403 items included for every mutation introduced
- [ ] Frontend subsection: scoped correctly to Web / Mobile / Web + Mobile per the Frontend flag
- [ ] GDPR subsection: EncryptedField, HMAC companion, erasure path, and retention items all present (if GDPR: Yes)
- [ ] Security subsection: each item prefixed with `[UF##/ST##]` reference (if Security: not N/A)
- [ ] Testing subsection: coverage floors stated; unit, integration, E2E, and manual items listed as appropriate

## Tasks

- [ ] All domain task subsections present for flags that are not N/A
- [ ] Every task maps to at least one acceptance criterion — no orphan tasks
- [ ] DB Tasks: model creation, migration, and any seed data tasks included
- [ ] User Flow Tasks: wireframe creation and stakeholder review tasks included (if User Flow: Yes)
- [ ] Backend Tasks: service method, signal, Celery task, and audit log tasks included
- [ ] API Tasks: Strawberry query / mutation tasks and `graphql-codegen` task included
- [ ] Frontend Tasks: scoped per platform (Web / Mobile) using comment prefix; user guide task included
- [ ] GDPR Tasks: EncryptedField, HMAC, `gdpr_erase()`, US041 wiring, and retention task tasks included
- [ ] Security Tasks: rate limit, audit log, HTML-escape, and IDOR verification tasks included
- [ ] Testing Tasks: unit, integration, E2E, frontend unit, and manual check tasks listed as appropriate

## Structure

- [ ] Verification Checks section is present and unmodified
- [ ] Definition of Done section is present and unmodified
- [ ] Story number is sequential and not already taken
- [ ] File saved at the correct path: `project-management/src/01-STORIES/US###.md`
- [ ] No placeholder text (`[N]`, `[Story title]`, `[Epic Name]`, etc.) remains in the file

---

## Definition of Done

- [ ] All checklist items above are ticked
- [ ] Story reviewed for clarity, completeness, and testability
- [ ] Committed and pushed
