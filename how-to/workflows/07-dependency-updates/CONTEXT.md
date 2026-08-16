# Workflow: Dependency Updates

A dependency change is a supply-chain decision wearing the clothes of a version bump. This
workflow keeps the lockfile, the advisory check and the toolchain pins moving together instead
of separately.

## Directory Tree

```text
how-to/workflows/07-dependency-updates/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding, upgrading, or removing a dependency in any ecosystem —
Python (`uv`), JavaScript (`pnpm`), or the toolchain pins themselves — and when the
`Dependency Audit Sweep` opens a tracking issue for a published advisory.

## Key concepts

- **Adding a dependency is a decision, not a convenience.** The root `pyproject.toml`
  carries an explicit register of packages _deliberately not declared_ — each with the
  condition that would trigger adding it. Check whether yours is already listed and
  whether its trigger has actually fired.
- **The lockfile is the artefact.** Every Dockerfile builds with `uv sync --frozen`, so an
  un-refreshed lockfile fails the build rather than silently resolving something else.
- **`uv.lock` is committed in this template** (16/08/2026), so a dependency change is locked
  and verified here exactly as in a generated project. It pins `syntek-base`, so `copier.yml`
  excludes it and a generated project locks its own at generation.
- **Two audit surfaces, both continuous.** `audits/security.sh` mirrors the CI `[8/8]`
  gate; the nightly `Dependency Audit Sweep` opens a tracking issue when an advisory lands
  against unchanged lockfiles. A clean run last week means nothing today.
- **Pins are a matched set.** Toolchain versions are pinned in several files at once
  (`.nvmrc`, `.python-version`, `package.json`, workflow `env:` blocks). Moving one without
  the others produces failures that only appear in CI.

## Cross-references

### Governing documents

- `how-to/src/CONTRIBUTING.md` — the licensing constraint on any new dependency
- `pyproject.toml` — the "deliberately NOT declared at baseline" register and its triggers

### Related reading

- `how-to/docs/CLI-TOOLING.md` — the install and update scripts
- `code/src/docker/CONTEXT.md` — how the images consume the lockfiles
- `how-to/workflows/06-quality-gates/` — the audit gate this feeds
- `project-management/docs/VERSIONING-GUIDE.md` — when a dependency change warrants a bump
