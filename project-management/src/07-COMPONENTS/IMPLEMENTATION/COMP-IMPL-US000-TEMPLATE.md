# COMP-IMPL-US000-[DESCRIPTOR] — Components As Shipped

**Story**: US### · **Date**: DD/MM/YYYY · **Sprint**: ## · **Recorded by**: [name]
**Consolidated set**: `../CONSOLIDATED-IDEAS/COMP-CONSOLIDATED-<FAMILY>.md`
**Stage-1 need**: `../USER-STORY-IDEAS/COMP-IDEA-US###-<DESCRIPTOR>.md`
**Outcome**: Matches consolidated / Matches with deviations / Blocked

> Copy to `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Section 2 must be filled from the **running
> build**, not the template source.

---

## 1 — Components used

| Component | Variant | Present in `code/src/django/components/` | Matches consolidated | Evidence |
| --------- | ------- | ---------------------------------------- | -------------------- | -------- |
|           |         |                                          |                      |          |

---

## 2 — States exercised

Tick only what you actually triggered in a browser. Default is the easy one; the rest are why
this section exists.

| Component | Default | Hover | Focus | Disabled | Error | Success | Empty | How exercised |
| --------- | ------- | ----- | ----- | -------- | ----- | ------- | ----- | ------------- |
|           |         |       |       |          |       |         |       |               |

- [ ] Every state in the consolidated matrix was **triggered in the running build**
- [ ] No state was confirmed by reading the template alone

---

## 3 — Accessibility verified

| Component | Keyboard reachable | Focus visible | Role/label announced | Contrast AA | Target size | Evidence |
| --------- | ------------------ | ------------- | -------------------- | ----------- | ----------- | -------- |
|           |                    |               |                      |             |             |          |

- [ ] Every interactive component is reachable and operable by keyboard alone
- [ ] Every interactive component has a **visible** focus indicator — a blocker if not

---

## 4 — Deviations from the consolidated set

| ID    | Deviation | Consolidation gap / build invented it | Justification | Routed to |
| ----- | --------- | ------------------------------------- | ------------- | --------- |
| D-001 |           |                                       |               |           |

**Routing:** consolidation missed a needed component → `../../19-FINDINGS/` · build invented one
→ `../../20-BUGS/` · accepted trade-off → note here with a reason.

- [ ] No unexplained deviation remains

---

## Sign-off

- [ ] Every component and variant verified present
- [ ] Every state exercised in the running build
- [ ] Accessibility checks run; focus visible on every interactive component
- [ ] Every deviation justified and routed

**Recorded by**: [name] · **Date**: DD/MM/YYYY
