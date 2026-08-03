# COMP-CONSOLIDATED-[FAMILY] — Decided Component Set

**Date**: DD/MM/YYYY · **Consolidated by**: [name] · **Workflow**: `17-consolidate-design-work`
**Stage-1 records merged**: `COMP-IDEA-US###-*.md`, `COMP-IDEA-US###-*.md`, …

> Copy to `COMP-CONSOLIDATED-<FAMILY>.md`. This drives the **single** regeneration of
> `../component-build/` and is what `code/src/django/components/` implements.

---

## 1 — Scope

| Field                | Value                                                               |
| -------------------- | ------------------------------------------------------------------- |
| Family               | [BUTTONS / FORMS / BADGES / ALERTS / CARDS / NAVIGATION / FEEDBACK] |
| Stories contributing | US###, US###, US###                                                 |
| Stage-1 records read | `COMP-IDEA-US###-*.md` … (list every one)                           |
| Section partial      | `../component-build/section-<name>.tex`                             |

---

## 2 — Merge log

Every stage-1 need. **An empty table means the pass was shallow.**

| ID    | Need described         | Asked by | Verdict         | Resolved to              | Reason                                   |
| ----- | ---------------------- | -------- | --------------- | ------------------------ | ---------------------------------------- |
| M-001 | [EXAMPLE] status badge | US004    | Merged          | `Badge` variant `status` | [EXAMPLE] same shape as US011's tag chip |
| M-002 | [EXAMPLE] tag chip     | US011    | Merged          | `Badge` variant `tag`    | [EXAMPLE] one component, two variants    |
| M-003 | [PLACEHOLDER]          | US###    | Served existing | [PLACEHOLDER]            | [PLACEHOLDER]                            |
| M-004 | [PLACEHOLDER]          | US###    | New             | [PLACEHOLDER]            | [PLACEHOLDER]                            |

**Verdicts:** Merged (one component, several variants) · Served existing · New · Rejected

---

## 3 — The decided components

### `[ComponentName]`

| Field    | Value                                |
| -------- | ------------------------------------ |
| Variants | [PLACEHOLDER]                        |
| Absorbs  | US### [need], US### [need]           |
| Tokens   | [PLACEHOLDER — from the brand guide] |

**State matrix** — every cell decided, not "TBD":

| State    | Visual | Behaviour |
| -------- | ------ | --------- |
| Default  |        |           |
| Hover    |        |           |
| Focus    |        |           |
| Disabled |        |           |
| Error    |        |           |
| Success  |        |           |
| Empty    |        |           |

**Accessibility** (`code/docs/ACCESSIBILITY.md`):

| Field                | Value         |
| -------------------- | ------------- |
| Keyboard interaction | [PLACEHOLDER] |
| Focus indicator      | [PLACEHOLDER] |
| Announced role/label | [PLACEHOLDER] |
| Contrast (AA 4.5:1)  | [PLACEHOLDER] |
| Target size          | [PLACEHOLDER] |

_(repeat per component)_

---

## 4 — Generator regeneration

| Step                                                      | Done |
| --------------------------------------------------------- | ---- |
| `../component-build/section-<name>.tex` updated           | [ ]  |
| Palette in `components.py` matches the brand guide        | [ ]  |
| `python3 components.py` run                               | [ ]  |
| `python3 components.py --check` passes                    | [ ]  |
| `.py`, `section-*.tex`, `.tex`, `.pdf` committed together | [ ]  |

---

## 5 — Story plans corrected

| Story plan              | What changed | Corrected |
| ----------------------- | ------------ | --------- |
| `STORY-PLAN-US###-*.md` |              | [ ]       |

---

## Sign-off

- [ ] Every stage-1 record listed in §1 and every need given a verdict
- [ ] Variants preferred over near-duplicate components
- [ ] Every component has a complete state matrix — no "TBD" cells
- [ ] Keyboard, focus, role, contrast, and target size decided per component
- [ ] Generator re-run and `--check` passing; palette matches the brand guide
- [ ] Every affected story plan corrected

**Consolidated by**: [name] · **Date**: DD/MM/YYYY
