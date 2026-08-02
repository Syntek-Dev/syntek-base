# Workflow: Dependency Updates

## Directory Tree

```text
how-to/workflows/07-dependency-updates/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding, upgrading, or removing a dependency in any ecosystem —
Python (`uv`), JavaScript (`pnpm`), or the toolchain pins themselves — and when the
`Dependency Audit Sweep` opens a tracking issue for a published advisory.

## Prerequisites

- [ ] Working tree clean, on a branch — lockfile churn should not ride on a feature diff
- [ ] The dev stack can be rebuilt (upgrades are not real until the image builds)
- [ ] For a new dependency: you have read the baseline's "deliberately NOT declared" register

## Key concepts

- **Adding a dependency is a decision, not a convenience.** The root `pyproject.toml`
  carries an explicit register of packages _deliberately not declared_ — each with the
  condition that would trigger adding it. Check whether yours is already listed and
  whether its trigger has actually fired.
- **The lockfile is the artefact.** Every Dockerfile builds with `uv sync --frozen`, so an
  un-refreshed lockfile fails the build rather than silently resolving something else.
- **`uv.lock` is absent by design in this template** — it would pin the root project under
  the literal project-slug token. Copier generates it at generation time. In the template
  you can change `pyproject.toml` but cannot meaningfully lock it.
- **Two audit surfaces, both continuous.** `audits/security.sh` mirrors the CI `[8/8]`
  gate; the nightly `Dependency Audit Sweep` opens a tracking issue when an advisory lands
  against unchanged lockfiles. A clean run last week means nothing today.
- **Pins are a matched set.** Toolchain versions are pinned in several files at once
  (`.nvmrc`, `.python-version`, `package.json`, workflow `env:` blocks). Moving one without
  the others produces failures that only appear in CI.

## Cross-references

### Hard gates — read before executing Step 1

- `how-to/src/CONTRIBUTING.md` — the licensing constraint on any new dependency
- `pyproject.toml` — the "deliberately NOT declared at baseline" register and its triggers

### Soft references — consult during execution

- `how-to/docs/CLI-TOOLING.md` — the install and update scripts
- `code/src/docker/CONTEXT.md` — how the images consume the lockfiles
- `how-to/workflows/06-quality-gates/` — the audit gate this feeds
- `project-management/docs/VERSIONING-GUIDE.md` — when a dependency change warrants a bump
