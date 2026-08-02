# GAPS.md — Active Gaps, Blockers & Sprint Dependencies

Tracks active architectural gaps, blockers, and sprint dependencies. **Not** a memory store —
feedback, patterns, and observations go in `.claude/MEMORY.md` instead.

Resolved entries are marked `✅ CLOSED <date>` and removed on the next tidy pass. Permanent
architectural decisions are promoted to `code/docs/ARCHITECTURE-PATTERNS.md` or the relevant doc.

**Format:**

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Sprint dependency | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

## 02/08/2026 — No test job is a required status check

**Type:** Infrastructure gap — **action needed after this branch merges**
**Summary:** An earlier entry claimed branch protection still required a `test-backend` check
that would never report. **That was wrong.** `main` has no legacy branch protection at all; it is
a **repository ruleset** (`main — protected`, id `20221742`), and `test-backend` has never been in
its required set. The real gap is wider: the required set is eight lint/audit/template checks —
`[1/8] Line Count`, `[5/8] Stub Audit`, `TruffleHog — Secrets Scan`, `markdownlint-cli2`,
`Prettier`, `ESLint`, `[1/2] Template Tokens`, `[2/2] Template Generation` — and **no test job is
among them**. `pytest + coverage` has never gated a merge. That also means dropping the path
filters from `test.yml` currently buys a Docker build on every PR and delivers no gate.
**Blocked by / Action:** After this branch merges, add all five to ruleset `20221742` via
`gh api` — `pytest + coverage`, `jest-expo + coverage`, `Bundle export`,
`ESLint (mobile surface)`, `TypeScript (mobile surface)`. **Not before:** four of the five do not
exist on `main` yet, so requiring them now would block every PR on checks that cannot report.

## 02/08/2026 — Expo SDK 57, not 55: ADR-era research is one major behind

**Type:** Active gap
**Summary:** The epic's research was done against Expo SDK 55. Current is **57**, and the pinned
set differs materially from what the decision record assumed — Expo pins TypeScript ~6 (not 7),
jest-expo 57 is on the **Jest 29** line (not 30), and expo-router 57's testing library needs
React Native Testing Library **13**, not 14. Each was found only by running the toolchain.
**Blocked by / Action:** None — the pins are correct as shipped. Recorded because the standing
SDK-tracking commitment in ADR-001 term 2 still has **no owner and no trigger**, and this is the
first evidence of how fast that set moves.

## 02/08/2026 — Delimiter-safety guard not implemented

**Type:** Active gap
**Summary:** `.github/scripts/check-template-tokens.sh` checks the unclosed variable-opening
sequence only — one of the six delimiter forms. `copier.yml` claims its delimiter set was chosen
by scanning every tracked file for zero occurrences, but that analysis predates the mobile epic —
and a literal scan missed a sixth site last session because markdown tables write the pipe as an
escaped character.
**Blocked by / Action:** Extend the script to scan all six delimiter sequences **including
markdown-escaped forms**, or it will report a false all-clear.

## 02/08/2026 — Backend tests now run on every PR

**Type:** Active gap
**Summary:** `test.yml` dropped the path filters `test-backend.yml` carried. That is deliberate
and follows the repo's own documented rule — a path-filtered required check never reports and
blocks the merge — and it matters more now, because a filter listing only the Django paths would
silently stop gating mobile. The cost is real: the Docker test stack builds on every pull
request rather than only on Python changes.
**Blocked by / Action:** None; accepted knowingly. Revisit if CI minutes become a constraint —
the fix is a merge queue or a cheaper test image, not a path filter.

## 02/08/2026 — `pnpm audit` is red for unrelated reasons

**Type:** Active gap
**Summary:** The scheduled `audit-deps.yml` sweep runs `pnpm audit --audit-level low` and
currently reports **20 advisories (11 moderate, 9 high)**, almost all `axios` reached through
`@usebruno/cli`, which is dev-only API-test tooling. Separately, `pip-audit` cannot parse the root
`pyproject.toml` in **this** repository, because the project name there is still an unrendered
template token rather than a valid package name — expected in the template and harmless in a
generated project, but it means the Python half of the local `security.sh` never reports usefully
while working on the template itself. Neither is caused by the mobile epic; both predate it.
**Blocked by / Action:** Decide whether to bump or replace `@usebruno/cli`, or add the advisories
to `auditConfig.ignoreGhsas` with a rationale. Consider making `security.sh` skip the Python half
with a clear message when the manifest is an unrendered template.

## 02/08/2026 — The `@/tokens` module does not exist until a project builds it ✅ CLOSED 02/08/2026

**Type:** Active gap
**Summary:** `.claude/agents/mobile.md` and `.claude/skills/stack-react-native/SKILL.md`
referenced three artefacts that did not exist.
**Resolution:** All three now exist or are correctly scoped. `code/docs/accessibility/MOBILE.md`
written (N23); `code/src/scripts/audits/mobile-tokens.sh` written with its
`audit-mobile-tokens.yml` workflow, verified in all three states (clean, catching a violation,
and no-op on a web-only project); the mobile-flagged workflow steps added to
`18-frontend-code` (Step 4M), `code/workflows/01-new-feature` (Step 7M) and `02-tdd-cycle`.
The generated `@/tokens` module is **correctly absent** — it is emitted from the design-token
database, which the template does not ship; `code/docs/design-tokens/MOBILE.md` specifies it.
The five raw literals in `app/index.tsx` (not two, as previously recorded) now carry
`token-allow` annotations naming the reason, so the audit is green and the debt is visible.

## 02/08/2026 — `COVERAGE.md` wording predates the second runtime ✅ CLOSED 02/08/2026

**Type:** Active gap
**Resolution:** Reworded from "one floor, not one per layer" to **one standard, enforced once per
runtime**, with the two-runtime table, the "two gates to keep in step" rule, and a note that the
90% auth glob is **not** inert in Jest. `code/docs/testing/CLAUDE.md` updated to match.
