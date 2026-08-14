# BRAND-IDEA-US000-[DESCRIPTOR] — Token Needs

**Story**: US### · **Date**: DD/MM/YYYY · **Recorded by**: [name]
**Outcome**: Reused existing only / Proposes new tokens / N/A — no UI

> Copy to `BRAND-IDEA-US###-<DESCRIPTOR>.md`. Keep it short. Most stories reuse existing tokens
> and stop at Section 1. **Do not run `../guide-build/brand_guide.py`** — the generator is re-run once,
> at consolidation.

---

## 1 — Tokens reused

Existing tokens this story's UI depends on. If everything is here, you are done.

| Token                       | Used for                     |
| --------------------------- | ---------------------------- |
| [EXAMPLE] `--color-surface` | [EXAMPLE] card background    |
| [EXAMPLE] `--space-4`       | [EXAMPLE] form field spacing |

---

## 2 — New tokens proposed

Leave empty where the story needs nothing new — that is the expected outcome.

**Every row must name the nearest existing token and why it does not serve.** Without that,
consolidation cannot decide the ask.

| Proposed token | Value | Used for | Nearest existing | Why it does not serve |
| -------------- | ----- | -------- | ---------------- | --------------------- |
|                |       |          |                  |                       |

> This records an **ask**, not a decision. Whether it joins the palette is settled in
> `../CONSOLIDATED-IDEAS/` by `17-consolidate-design-work`, weighed against every other story's
> asks.

---

## 3 — Accessibility note

For any proposed colour, state the contrast pairing it must satisfy.

| Proposed token | Against | Ratio needed | Measured |
| -------------- | ------- | ------------ | -------- |
|                |         | 4.5:1 (AA)   |          |

---

## 4 — Collisions noticed

Where an earlier story's record already asked for something similar, note it — do not resolve it.

- [PLACEHOLDER] — `BRAND-IDEA-US###-*.md` proposed a near-identical value

---

## Sign-off

- [ ] Every token the story's UI depends on is listed in Section 1 or Section 2
- [ ] Every proposed token names its nearest existing neighbour and why it falls short
- [ ] Contrast pairings stated for proposed colours
- [ ] `../guide-build/` untouched

**Recorded by**: [name] · **Date**: DD/MM/YYYY
