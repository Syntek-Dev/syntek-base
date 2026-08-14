# BRAND-IMPL-US000-[DESCRIPTOR] — Tokens As Shipped

**Story**: US### · **Date**: DD/MM/YYYY · **Sprint**: ## · **Recorded by**: [name]
**Consolidated set**: `../CONSOLIDATED-IDEAS/BRAND-CONSOLIDATED-<DOMAIN>.md`
**Stage-1 ask**: `../USER-STORY-IDEAS/BRAND-IDEA-US###-<DESCRIPTOR>.md`
**Outcome**: Matches consolidated / Matches with deviations / Blocked

> Copy to `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Section 2 is the section that matters — record
> the audit output, do not assert the rule was followed.

---

## 1 — Tokens consumed

| Token | In `apps.design_tokens` | Resolves in token CSS | Matches consolidated value | Evidence |
| ----- | ----------------------- | --------------------- | -------------------------- | -------- |
|       |                         |                       |                            |          |

---

## 2 — Token-first audit

```bash
bash code/src/scripts/audits/css-tokens.sh
```

| Field          | Value                                        |
| -------------- | -------------------------------------------- |
| Result         | Clean / Failures                             |
| Failures found | [PLACEHOLDER — paste the offending lines]    |
| Routed to      | [PLACEHOLDER — `../../20-BUGS/` if literals] |

- [ ] Audit run and its **actual output** recorded above
- [ ] No raw colour, spacing, or size literal in this story's component CSS
- [ ] Every `var(--token)` name resolves in the token layer

---

## 3 — Deviations from the consolidated set

| ID    | Deviation | Consolidation gap / build invented it | Justification | Routed to |
| ----- | --------- | ------------------------------------- | ------------- | --------- |
| D-001 |           |                                       |               |           |

**Routing:** consolidation missed a needed token → `../../19-FINDINGS/` · build invented one →
`../../20-BUGS/` · accepted trade-off → note here with a reason.

- [ ] No unexplained deviation remains

---

## Sign-off

- [ ] Every consumed token verified present, resolving, and matching the consolidated value
- [ ] `css-tokens.sh` output recorded
- [ ] Every deviation justified and routed

**Recorded by**: [name] · **Date**: DD/MM/YYYY
