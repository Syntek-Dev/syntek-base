---
workflow: 07-dependency-updates
phase: operate
skills: [cicd, global-workflow]
model: opus
---

# Dependency Updates — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Operator guides** (CONTRIBUTING.md) · **External — Tools & CLI** (uv, pnpm) · **Cross-layer references** (`code/src/docker/CONTEXT.md`, `project-management/docs/VERSIONING-GUIDE.md`).

## Justification

- [ ] Checked the "deliberately NOT declared at baseline" register in `pyproject.toml`; if listed, its trigger has genuinely fired and the register line is removed in this change · _opus_
- [ ] Licence compatible with this project's licence — GPL/AGPL approved in writing where required · _opus_
- [ ] The transitive tree is worth it; a small amount of first-party code was considered instead · _opus_
- [ ] Load-bearing choice recorded as an ADR · _fable_

## Change

- [ ] Manifest edited, then the lockfile refreshed — narrowest upgrade that solves the problem · _opus_
- [ ] Advisory fixes pinned via `overrides` rather than loosening a range · _opus_
- [ ] Reinstalled and **rebuilt the image** — `uv sync --frozen` means a stale lockfile fails the build · _opus_

## Verification

- [ ] `audits/security.sh` clean · _opus_
- [ ] Full suite green with coverage · _opus_
- [ ] `pre-pr-check.sh` green end to end · _opus_
- [ ] Toolchain pins moved as a **matched set** (`.nvmrc`, `.python-version`, `package.json`, workflow `env:` blocks) · _opus_

## Record

- [ ] Manifest + lockfile committed together, in their own commit · _opus_
- [ ] Tracking issue referenced and the advisory genuinely resolved · _opus_
- [ ] Version bumped per `project-management/docs/VERSIONING-GUIDE.md` · _opus_
- [ ] A removed package is back in the register with its trigger condition · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`

---

## Definition of Done

- [ ] `pre-pr-check.sh` green end to end against the rebuilt image, not the stale one · _opus_
- [ ] Manifest and lockfile committed together in their own commit, and the version bumped · _opus_
- [ ] The advisory that prompted this is genuinely resolved, verified by a fresh
      `audits/security.sh` — not merely quieter · _opus_
- [ ] The "deliberately NOT declared" register in `pyproject.toml` still tells the truth after
      this change — a line removed for a dependency added, a line restored for one removed · _opus_
