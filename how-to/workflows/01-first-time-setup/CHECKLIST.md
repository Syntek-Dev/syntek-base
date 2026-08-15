---
workflow: 01-first-time-setup
phase: setup
skills: [setup, global-workflow]
model: opus
---

# First-Time Setup — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Internal → Reference guides** (DEVELOPMENT.md) · **External — Tools & CLI** for supporting references.

## Execution Checklist

- [ ] Repository cloned · _opus_
- [ ] `.env.dev` populated with required values · _opus_
- [ ] All containers start and report healthy · _opus_
- [ ] Migrations applied successfully · _opus_
- [ ] Public site accessible at http://dev.<%PROJECT_SLUG%>.localhost:81/ · _opus · claude-in-chrome_
- [ ] API docs (OpenAPI) accessible at http://dev.<%PROJECT_SLUG%>.localhost:81/api/docs · _opus · claude-in-chrome_

---

## Before any feature work

These four run once, before the first feature is charted — they are what the planning gates
downstream are measured against, and each depends on the one before it.

- [ ] `CONTEXT.md` → _What this project is_ expanded beyond the raw Copier answer and confirmed:
      what it does, who for, what it replaces, what it deliberately is not · _fable_
- [ ] `how-to/src/BRAND-VOICE.md` Section 3 carries this project's tone, person, formality, reader,
      signature and vocabulary — not `TBD` placeholders · _fable_
- [ ] `code/docs/VISUAL-DESIGN.md` Section 3 names a visual direction, and every axis — alignment,
      rhythm, contrast, ornament, density, motion — carries a setting rather than `TBD` · _fable_
- [ ] If the direction is not `editorial`, Section 3's colour, typography and layout clauses have been
      restated against the chosen axes · _fable_
- [ ] `BRAND-VOICE.md` Section 3 and `code/docs/VISUAL-DESIGN.md` Section 3 do not contradict each other · _fable_
- [ ] `/scale-planning` run against live code · _fable_
- [ ] `how-to/src/SCALE-ARCHITECTURE/` carries real figures, not `TBD — regenerate` markers · _fable_
- [ ] `how-to/src/SERVER-ARCHITECTURE/` carries the server/edge contract the deploy repo consumes · _fable_
- [ ] The scaling phase-gate this project is designing under is named, and so is what it therefore
      does **not** need · _fable_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] All services running without errors · _opus_
- [ ] Can log in to Django Admin · _opus · claude-in-chrome_
