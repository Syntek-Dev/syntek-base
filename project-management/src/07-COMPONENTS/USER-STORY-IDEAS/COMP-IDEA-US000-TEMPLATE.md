# COMP-IDEA-US000-[DESCRIPTOR] — Component Needs

**Story**: US### · **Date**: DD/MM/YYYY · **Recorded by**: [name]
**Outcome**: Reused existing only / Proposes new components / N/A — no UI

> Copy to `COMP-IDEA-US###-<DESCRIPTOR>.md`. Keep it short. Check
> `code/src/django/components/` and `../CONSOLIDATED-IDEAS/` before proposing anything.
> **Do not run `../component-build/components.py`** — the generator runs once, at consolidation.

---

## 1 — Components reused

| Component | Variant / token override | Used for |
| --------- | ------------------------ | -------- |
|           |                          |          |

If everything the story needs is here, you are done.

---

## 2 — New components needed

Describe **what it must do**, not what it looks like finished. A finished design makes two
stories' near-identical needs look deliberate at consolidation, and the merge gets missed.

### [Working name]

| Field                   | Value                                                |
| ----------------------- | ---------------------------------------------------- |
| What it must do         | [PLACEHOLDER]                                        |
| Content it holds        | [PLACEHOLDER]                                        |
| Where it appears        | [PLACEHOLDER — screens / surfaces]                   |
| Nearest existing        | [PLACEHOLDER — from the library or consolidated set] |
| Why that does not serve | [PLACEHOLDER]                                        |

**States required** — every one, not just the resting state:

| State    | Needed | Behaviour |
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
| Target size          | [PLACEHOLDER] |

_(repeat per new component)_

---

## 3 — Similarities noticed

Where an earlier story described something close, note it — **do not merge them here**.

- [PLACEHOLDER] — `COMP-IDEA-US###-*.md` describes a similar need

---

## Sign-off

- [ ] Library and consolidated set checked before proposing anything
- [ ] Every component the story needs is listed as reused or described as new
- [ ] Every new component names its nearest existing neighbour and why it falls short
- [ ] All required states enumerated, not just the resting state
- [ ] Keyboard and focus behaviour stated
- [ ] `../component-build/` untouched

**Recorded by**: [name] · **Date**: DD/MM/YYYY
