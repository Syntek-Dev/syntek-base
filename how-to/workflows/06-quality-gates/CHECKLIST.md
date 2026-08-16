---
workflow: 06-quality-gates
phase: verify
skills: [syntax, global-workflow]
model: opus
---

# Quality Gates — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Operator guides** (CONTRIBUTING.md) · **Reference guides** (CLI-TOOLING.md) · **Cross-layer references** (`code/docs/testing/COVERAGE.md`, `project-management/docs/GIT-GUIDE.md`).

## The eight gates

- [ ] **[1/8]** `audits/cloc.sh` — no source file over the limit (≥800 = error) · _opus_
- [ ] **[2/8]** Lockfiles consistent — `uv.lock` and `pnpm-lock.yaml` · _opus_
- [ ] **[3/8]** `syntax/format.sh` — clean · _opus_
- [ ] **[4/8]** `syntax/lint.sh` — clean; any suppression carries a stated reason · _opus_
- [ ] **[5/8]** `audits/stubs.sh` — no hard stubs · _opus_
- [ ] **[6/8]** `syntax/check.sh` — basedpyright clean; no new `Any` or silenced error · _opus_
- [ ] **[7/8]** `tests/all.sh --coverage` — green, floors met · _opus_
- [ ] **[8/8]** `audits/security.sh` — no advisories · _opus_

## The standalone audits

- [ ] `css-tokens.sh` — every `var(--token)` resolves in the token layer · _opus_
- [ ] `css-gradients.sh` — no inline gradients · _opus_
- [ ] `copy-emdash.sh` — marketing copy punctuation · _opus_
- [ ] `mobile-tokens.sh` — mobile-only; exits 0 with a note on a web-only project · _opus_
- [ ] `seam-contract.sh` — every `**Source:**` in the server contract resolves · _opus_
- [ ] `negative-space.sh` — the invariant register and the code agree, both surfaces · _opus_
- [ ] `negative-space.sh --self-test` — the detector still separates its fixtures · _opus_
- [ ] `skill-conformance.sh` — every skill's frontmatter and routing section conform · _opus_
- [ ] `docs-pairing.sh` — no operating rule left in a `CONTEXT.md`, every pair correctly shaped · _opus_
- [ ] `docs-length.sh` — no instructional `.md` over 300 code lines · _opus_
- [ ] `static-analysis.sh` — no template XSS or cross-file taint (skips without opengrep) · _opus_
- [ ] `css-slop.sh` · `template-slop.sh` · `copy-slop.sh` · `render-slop.sh` — the AI-slop family:
      one per input language, plus one that must render its input before the clause exists · _opus_
- [ ] `desktop/style-check.sh` — desktop-only; a Slint style is chosen, not inherited · _opus_
- [ ] Every `[gate: warn]` the slop family reported has been **answered**, not merely seen — those
      exit 0 by design and a green run is not the same as a clean one · _opus_

## Before pushing

- [ ] `bash .claude/hooks/pre-pr-check.sh` run end to end and green · _opus_
- [ ] Targeting a promotion branch? Coverage clears the higher floor (`code/docs/testing/COVERAGE.md`) · _opus_
- [ ] Content review done via `code/workflows/07-review/` — this gate checks form, not judgement · _opus_
- [ ] Any local/CI disagreement treated as a mirroring bug and fixed, not routed around · _opus_
- [ ] Branch and commit conventions match `project-management/docs/GIT-GUIDE.md` · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
