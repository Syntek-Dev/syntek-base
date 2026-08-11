---
workflow: 06-quality-gates
phase: verify
agent: syntax
skills: [global-workflow]
model: opus
---

# Quality Gates — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                             |
| ---- | ------------------------------------------------------------------- |
| 1    | **Operator guides** → `how-to/src/CONTRIBUTING.md`                  |
| 2–3  | **Reference guides** → CLI-TOOLING.md (syntax and audit runners)    |
| 4    | **Cross-layer references** → `code/docs/testing/COVERAGE.md`        |
| 5    | **Cross-layer references** → `project-management/docs/GIT-GUIDE.md` |

---

## Step 1 — Format and lint first

> **↳ New agent:** `syntax` · **Model:** opus

Cheapest gates first — a formatting failure is worth catching before a ten-minute suite.

```bash
bash code/src/scripts/syntax/format.sh
bash code/src/scripts/syntax/lint.sh
```

`format.sh` rewrites; `lint.sh` reports. Fix lint findings properly rather than suppressing
them — a `noqa` needs a reason beside it, and a reviewer will ask.

---

## Step 2 — Type-check

> **Model:** opus

```bash
bash code/src/scripts/syntax/check.sh
```

basedpyright runs in strict mode. A new `Any`, a silenced error, or a widened type to make
the checker quiet is a change to the codebase's guarantees, not a fix — treat it as a
reviewable decision.

---

## Step 3 — Run the audits

> **Model:** opus

```bash
bash code/src/scripts/audits/cloc.sh          # source file length (≥800 = error)
bash code/src/scripts/audits/docs-length.sh   # instructional .md length (>300 = error)
bash code/src/scripts/audits/stubs.sh         # hard stubs left behind
bash code/src/scripts/audits/security.sh      # pnpm audit + pip-audit (mirrors CI [8/8])
bash code/src/scripts/audits/css-tokens.sh    # every var(--token) resolves
bash code/src/scripts/audits/css-gradients.sh # no inline gradients
bash code/src/scripts/audits/copy-emdash.sh   # marketing copy punctuation
bash code/src/scripts/audits/mobile-tokens.sh # mobile-only; exits 0 with a note otherwise
bash code/src/scripts/audits/seam-contract.sh # server-contract Source provenance resolves
bash code/src/scripts/audits/negative-space.sh # the invariant register agrees with the code
bash code/src/scripts/audits/negative-space.sh --self-test # ...and the detector still works
bash code/src/scripts/audits/docs-pairing.sh  # CONTEXT.md orients, CLAUDE.md instructs
bash code/src/scripts/audits/skill-conformance.sh # skill frontmatter + routing section
bash code/src/scripts/audits/static-analysis.sh # template XSS + cross-file taint (needs opengrep)
bash code/src/scripts/audits/css-slop.sh      # AI-slop, CSS half
bash code/src/scripts/audits/template-slop.sh # AI-slop, markup half
bash code/src/scripts/audits/copy-slop.sh     # AI-slop, prose half
bash code/src/scripts/audits/render-slop.sh   # AI-slop, rendered half (needs Chromium)
bash code/src/scripts/desktop/style-check.sh  # desktop-only; a Slint style is chosen
```

`security.sh` mirrors the CI `[8/8]` gate exactly, so a hit here is what the next PR would
see. Advisories are published continuously — a clean run last week means nothing today.

**Read the slop family's warnings; do not just count its exit code.** Those four report two tiers
in one run, and a `[gate: warn]` finding leaves the exit code at 0 by design — a threshold on
composition or vocabulary fails correct work, so the script reports and a human decides
(`code/docs/VISUAL-DESIGN.md` § 6). An audit that exits 0 with five warnings has told you
something; treat each as a question to answer.

---

## Step 4 — Tests and coverage

> **Model:** opus

```bash
bash code/src/scripts/tests/all.sh --coverage
```

Floors: 75% line and branch, 90% auth. Depth and failure routing are workflow
`05-testing-and-coverage`.

**Check the branch you are targeting.** CI applies an **80%** floor on `staging` and
`main` — above what the runner enforces — so a change that is green locally can still fail
promotion. If you are heading for either, confirm you clear 80% before pushing.

---

## Step 5 — Run the full gate, then push

> **Model:** opus

```bash
bash .claude/hooks/pre-pr-check.sh
```

This is the same eight-gate sequence CI runs, in the same order. Green here should mean
green there — and when it does not, the mirroring itself is the bug: fix the script or the
workflow so they agree, rather than pushing repeatedly to discover what CI wants.

In **this template repository** several gates report success with nothing to run, because
`uv.lock` is absent by design. That is expected here and not a sign of a broken gate; in a
generated project every gate executes.

Only then raise the PR — `project-management/workflows/22-pr-and-review/`.
