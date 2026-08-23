# WF-CONSOLIDATED-[AREA] — Rebuilt Screen Set

**Date**: DD/MM/YYYY · **Consolidated by**: [name] · **Workflow**: `18-consolidate-design-work`
**Stage-1 screens read**: `WF-IDEA-US###-*.html`, `WF-IDEA-US###-*.html`, …

> Copy to `WF-CONSOLIDATED-<AREA>.md`. Run this **after** components and flows are consolidated.
> Screens are **rebuilt** on the consolidated component set, not patched.

---

## 1 — Scope

| Field                   | Value                                                                    |
| ----------------------- | ------------------------------------------------------------------------ |
| Area                    | [e.g. SIGN-UP]                                                           |
| Stories contributing    | US###, US###                                                             |
| Stage-1 screens read    | `WF-IDEA-US###-*.html` … (list every one)                                |
| Consolidated components | `../../07-COMPONENTS/CONSOLIDATED-IDEAS/COMP-CONSOLIDATED-*.md`          |
| Consolidated journey    | `../../05-USER-FLOW/CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-<AREA>.md` |

---

## 2 — Merge log

| ID    | Stage-1 screen(s)                                                   | Verdict   | Rebuilt as            | Reason                           |
| ----- | ------------------------------------------------------------------- | --------- | --------------------- | -------------------------------- |
| W-001 | [EXAMPLE] `WF-IDEA-US004-Sign-In.html`, `WF-IDEA-US009-Log-In.html` | Duplicate | `WF-004-Sign-In.html` | [EXAMPLE] same screen, two names |
| W-002 | [PLACEHOLDER]                                                       | Rebuilt   | [PLACEHOLDER]         | [PLACEHOLDER]                    |
| W-003 | [PLACEHOLDER]                                                       | Dropped   | —                     | [PLACEHOLDER]                    |

**Verdicts:** Rebuilt · Duplicate (merged) · Dropped · New (raised as a `US###`)

---

## 3 — Bespoke elements replaced

Every one-off element a story drew must now resolve to a consolidated component.

| Stage-1 screen | Bespoke element | Replaced by | Component doc |
| -------------- | --------------- | ----------- | ------------- |
|                |                 |             |               |

- [ ] No rebuilt screen carries a bespoke element the component set covers

---

## 4 — The rebuilt set

| Screen file | Realises journey step(s) | Mobile counterpart |
| ----------- | ------------------------ | ------------------ |
|             |                          |                    |

- [ ] Every step of the consolidated journey has a screen
- [ ] Every screen maps to a journey step — no orphans

---

## 5 — Breakpoint check

Opened in a browser over `file://` at each declared breakpoint.

| Screen | 320 | 430 | 768 | 1024 | 1280 | 1920 | Notes |
| ------ | --- | --- | --- | ---- | ---- | ---- | ----- |
|        |     |     |     |      |      |      |       |

Mobile screens composed at 390 × 844.

- [ ] No screen rests intent on hover, scrollbars, or browser chrome

---

## 6 — Accessibility pass

| Screen | Heading order | Focus order | Skip link | Contrast | Notes |
| ------ | ------------- | ----------- | --------- | -------- | ----- |
|        |               |             |           |          |       |

---

## 7 — Story plans corrected

| Story plan              | What changed | Corrected |
| ----------------------- | ------------ | --------- |
| `STORY-PLAN-US###-*.md` |              | [ ]       |

---

## Sign-off

- [ ] Components and flows were consolidated **before** this pass
- [ ] Every stage-1 screen rebuilt, merged, or dropped with a reason
- [ ] No bespoke elements remain
- [ ] Journey coverage complete, no orphan screens
- [ ] Every screen checked at every breakpoint
- [ ] Accessibility pass complete
- [ ] Every affected story plan corrected

**Consolidated by**: [name] · **Date**: DD/MM/YYYY
