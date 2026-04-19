# Changelog

**Last Updated**: 19/04/2026 **Version**: 0.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

_No unreleased changes._

---

## [0.1.0] - 18/04/2026 (finalised 19/04/2026)

### Added

- Initial project scaffold with three-layer context system (`code/`, `how-to/`,
  `project-management/`)
- Root configuration files: `.editorconfig`, `.gitignore`, `.npmrc`, `.nvmrc`,
  `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, `.dockerignore`,
  `.mcp.json`, `.python-version`
- Root package manager config: `package.json`, `pnpm-workspace.yaml`, `pnpm-lock.yaml`,
  `pyproject.toml`, `uv.lock`
- Git hook runner `lefthook.yml` with Ruff, basedpyright, ESLint, Prettier, and
  markdownlint pre-commit checks
- ESLint configuration `eslint.config.mjs` for TypeScript and React
- GitHub Actions CI workflow suite (lint, type-check, test — backend, frontend, e2e)
- Claude Code agent configuration: `CLAUDE.md`, slash commands, and Python plugin tools
- Project `README.md` with full orientation guide
- Root `CONTEXT.md` router and `GAPS.md` tracking file
- `code/` layer: technical documentation (13 guides), Docker Compose stacks for all four
  environments, backend/frontend Dockerfiles and entrypoints, utility scripts, and ten
  development workflows
- `how-to/` layer: CLI tooling, development, and Syntek guides; three operational workflows
- `project-management/` layer: GDPR, git, SEO, and versioning guides; twelve PM source
  directories; seven PM workflows
- `VERSION`, `CHANGELOG.md`, `VERSION-HISTORY.md`, and `RELEASES.md` version tracking files
- Django project scaffold: `apps/core`, `apps/users`, `config/settings/` (base, dev,
  staging, production, test), `manage.py`, `wsgi.py`, `asgi.py`, `urls.py`
- Next.js 16 frontend scaffold: App Router layout, `src/components/`, `src/graphql/`,
  `src/lib/` (Apollo wrapper), `src/test/` (Vitest + MSW), `e2e/` (Playwright), and
  `codegen.ts` for GraphQL Code Generator
- `@syntek/shared` internal TypeScript package for cross-frontend shared utilities and
  components (`code/src/shared/`)
- Shell scripts for running tests (`backend.sh`, `frontend.sh`, `e2e.sh`,
  `backend-coverage.sh`, `frontend-coverage.sh`, `open-coverage.sh`, `all.sh`),
  scaffolding new Django apps and Next.js routes, and per-reporter report directories
- `install.sh` project setup entry point
