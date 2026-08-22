# BRAND-CONSOLIDATED-[DOMAIN] — Decided Token Set

**Date**: DD/MM/YYYY · **Consolidated by**: [name] · **Workflow**: `18-consolidate-design-work`
**Stage-1 records weighed**: `BRAND-IDEA-US###-*.md`, `BRAND-IDEA-US###-*.md`, …

> Copy to `BRAND-CONSOLIDATED-<DOMAIN>.md`. This document drives the **single** regeneration of
> `../guide-build/brand_guide.py` for the cycle, and its values become the DB-canonical token
> set that `code/docs/DESIGN-TOKENS.md` defines.

---

## 1 — Scope

| Field                | Value                                                |
| -------------------- | ---------------------------------------------------- |
| Domain               | [COLOUR / TYPOGRAPHY / SPACING / LOGO / VOICE / ALL] |
| Stories contributing | US###, US###, US###                                  |
| Stage-1 records read | `BRAND-IDEA-US###-*.md` … (list every one)           |

---

## 2 — The decided set

| Token | Value | Role | Replaces (stage-1 asks) |
| ----- | ----- | ---- | ----------------------- |
|       |       |      |                         |

- [ ] No two tokens in this set are functionally interchangeable

---

## 3 — Resolution log

Every ask across the stage-1 records. **An empty table means the pass was shallow.**

| ID    | Ask                          | Asked by     | Verdict  | Resolved to           | Reason                                     |
| ----- | ---------------------------- | ------------ | -------- | --------------------- | ------------------------------------------ |
| R-001 | [EXAMPLE] new grey `#8A8F98` | US004        | Rejected | `--color-neutral-500` | [EXAMPLE] within 2%; one token serves both |
| R-002 | [EXAMPLE] danger red         | US007, US011 | Merged   | `--color-danger`      | [EXAMPLE] two asks, one role               |
| R-003 | [PLACEHOLDER]                | US###        | Accepted | [PLACEHOLDER]         | [PLACEHOLDER]                              |

**Verdicts:** Accepted · Merged · Rejected · Deferred (with a named target story)

Rejections need a reason recorded, or the next cycle re-proposes them.

---

## 4 — Contrast verification

A pairing that fails AA is **changed here**, not annotated.

| Foreground | Background | Ratio | Passes AA (4.5:1) |
| ---------- | ---------- | ----- | ----------------- |
|            |            |       |                   |

- [ ] Every stated pairing passes

---

## 5 — Generator regeneration

| Step                                                | Done |
| --------------------------------------------------- | ---- |
| `INPUTS` in `../guide-build/brand_guide.py` updated | [ ]  |
| `python3 brand_guide.py` run                        | [ ]  |
| `python3 brand_guide.py --check` passes             | [ ]  |
| `.py`, `.tex`, `.pdf` committed together            | [ ]  |
| Palette matches `../../07-COMPONENTS/`              | [ ]  |

---

## 6 — Story plans corrected

| Story plan              | Token that changed | Corrected |
| ----------------------- | ------------------ | --------- |
| `STORY-PLAN-US###-*.md` |                    | [ ]       |

---

## Sign-off

- [ ] Every stage-1 record listed in Section 1 and every ask given a verdict
- [ ] Rejections carry reasons
- [ ] Contrast verified; no failing pairing remains
- [ ] Generator re-run and `--check` passing
- [ ] Component palette in step
- [ ] Every affected story plan corrected

**Consolidated by**: [name] · **Date**: DD/MM/YYYY
