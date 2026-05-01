# Sprint Planning — Checklist

**Last Updated**: 01/05/2026 **Version**: 1.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Template

- [ ] File was created by copying `SPRINT-00-TEMPLATE.md` — not written from scratch
- [ ] Heading updated: `# SPRINT-##` with the correct sprint number
- [ ] Template placeholder comments removed from the final file

## Flags

- [ ] All 8 flag rows are completed — no row left as a placeholder value
- [ ] Flags are rolled up from every story in the Story Summary table
- [ ] DB flag: shortlist of model names or `N/A`
- [ ] User Flow flag: `Yes` or `N/A`
- [ ] Backend flag: `Yes` or `N/A`
- [ ] API flag: shortlist of mutation / query names or `N/A`
- [ ] Frontend flag: `Web`, `Mobile`, `Web + Mobile`, or `N/A` — never just `Yes`
- [ ] GDPR flag: `Yes` or `N/A`
- [ ] Security flag: shortlist of concerns or `N/A`
- [ ] Testing flag: shortlist of test types or `N/A`
- [ ] Every section whose flag is `N/A` has been removed from the file

## Story Summary

- [ ] All selected stories appear in the Story Summary table
- [ ] Each row has: ID, Title, MoSCoW classification, and SP
- [ ] Must Have stories are listed before Should Have and Could Have
- [ ] Stories split across sprints are marked `(Part A)` or `(Part B)` in the Title column
- [ ] Total SP is calculated and at or below team capacity
- [ ] Sprint number and goal are set (not left as placeholders)
- [ ] Timeline and capacity line is filled in

## Dependencies

- [ ] Stories that require prior sprint deliverables are identified
- [ ] Stories with no upstream dependencies are noted
- [ ] Future sprints unblocked by this sprint are listed

## Acceptance Criteria

- [ ] Overview section has a clear statement of what the sprint must deliver
- [ ] All domain subsections present for flags that are not N/A
- [ ] DB subsection: checklist items covering all models and migrations in the sprint
- [ ] User Flow subsection: checklist items covering all new journeys and wireframe approvals
- [ ] Backend subsection: checklist items covering service layer standards across all sprint stories
- [ ] API subsection: checklist items for every mutation and query introduced in the sprint
- [ ] Frontend subsection: scoped correctly to Web / Mobile / Web + Mobile per the Frontend flag
- [ ] GDPR subsection: checklist items covering PII encryption, erasure, retention, and consent gates for all GDPR stories
- [ ] Security subsection: checklist items covering all security concerns from sprint stories
- [ ] Testing subsection: coverage floors stated; test scope summary reflects all stories

## Tasks

- [ ] All domain task subsections present for flags that are not N/A
- [ ] Each task row includes the Story column (e.g. `US###`) linking it to its source story
- [ ] DB Tasks table: all model creation, migration, and seed tasks listed
- [ ] User Flow Tasks table: wireframe creation and approval tasks listed
- [ ] Backend Tasks table: service method, signal, Celery task, and audit log tasks listed
- [ ] API Tasks table: query, mutation, and `graphql-codegen` tasks listed
- [ ] Frontend Tasks table: Platform column set to `Web`, `Mobile`, or `Both` for every row
- [ ] GDPR Tasks table: EncryptedField, HMAC, `gdpr_erase()`, US041 wiring, and retention tasks listed
- [ ] Security Tasks table: rate limit, audit log, HTML-escape, and IDOR verification tasks listed
- [ ] Testing Tasks: test scope table covers every story; manual checks listed

## Structure

- [ ] Verification Checks section is present and unmodified
- [ ] Definition of Done section is present and unmodified
- [ ] Sprint number is sequential and not already taken
- [ ] File saved at the correct path: `project-management/src/02-SPRINTS/SPRINT-##.md`
- [ ] No placeholder text (`[N]`, `[Story title]`, `[Team / Studio Name]`, etc.) remains in the file

---

## Definition of Done

- [ ] All checklist items above are ticked
- [ ] Sprint scope reviewed and agreed
- [ ] Committed and pushed
