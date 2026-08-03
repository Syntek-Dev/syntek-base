# WF-IMPL-US000-[DESCRIPTOR] — Screens As Built

**Story**: US### · **Date**: DD/MM/YYYY · **Sprint**: ## · **Recorded by**: [name]
**Consolidated screens**: `../CONSOLIDATED-IDEAS/WF-CONSOLIDATED-<AREA>.md`
**Stage-1 screens**: `../USER-STORY-IDEAS/WF-IDEA-US###-*.html`
**Outcome**: Honours the wireframes / Honours with deviations / Blocked

> Copy to `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Check the **contract** — layout,
> hierarchy, states, interaction — not resemblance to the wireframe markup. §2 and §3 must be
> filled from the running page.

---

## 1 — Screens built

| Consolidated screen | Django template | Route | Status | Evidence |
| ------------------- | --------------- | ----- | ------ | -------- |
|                     |                 |       |        |          |

**Status:** Present · Changed · Missing · N/A (owned by another story)

---

## 2 — Responsive check

Opened in a browser against the **running page**, not the wireframe.

| Screen | 320 | 430 | 768 | 1024 | 1280 | 1920 | Notes |
| ------ | --- | --- | --- | ---- | ---- | ---- | ----- |
|        |     |     |     |      |      |      |       |

- [ ] Every breakpoint checked on the built page
- [ ] Layout matches the wireframe's intent at each one

---

## 3 — Accessibility verified

| Screen | Heading order | Focus order | Skip link | Contrast AA | Keyboard-only pass | Evidence |
| ------ | ------------- | ----------- | --------- | ----------- | ------------------ | -------- |
|        |               |             |           |             |                    |          |

- [ ] Every page traversable by keyboard alone
- [ ] One `<h1>` per page; heading order logical

---

## 4 — Interaction contract

Where the wireframe specified an interaction, confirm where it now runs
(`code/docs/RENDERING.md`): server template, HTMX partial, or Alpine.

| Interaction | Wireframe intent | Runs as (server / HTMX / Alpine) | Honoured |
| ----------- | ---------------- | -------------------------------- | -------- |
|             |                  |                                  |          |

---

## 5 — Deviations from the consolidated screens

| ID    | Deviation | Consolidation gap / build departed | Justification | Routed to |
| ----- | --------- | ---------------------------------- | ------------- | --------- |
| D-001 |           |                                    |               |           |

**Routing:** consolidation missed a screen → `../../19-FINDINGS/` · build departed from an
agreed layout → `../../20-BUGS/` · accepted trade-off → note here with a reason.

- [ ] No unexplained deviation remains

---

## Sign-off

- [ ] Every consolidated screen for this story has a status and evidence
- [ ] Breakpoints checked on the running page
- [ ] Accessibility verified, keyboard-only pass done
- [ ] Interaction contract honoured
- [ ] Every deviation justified and routed

**Recorded by**: [name] · **Date**: DD/MM/YYYY
