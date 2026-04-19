# Releases — project-name

**Last Updated**: 19/04/2026 **Version**: 0.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v0.1.0 — 18/04/2026 (finalised 19/04/2026)

**Status:** Scaffold complete — ready for feature development

### Summary

Full project scaffold for the Syntek Studio website. No public-facing features are
included. The scaffold establishes the complete project structure, tooling, CI pipelines,
Docker environments, agent guidance system, and initial source scaffolds for both
backend and frontend, ready for user story implementation to begin.

### What's included

- Full project directory structure with three-layer context system (`code/`, `how-to/`,
  `project-management/`)
- Docker Compose environments for development, testing, staging, and production
- Automated lint, type-check, and test CI pipelines via GitHub Actions (backend, frontend,
  e2e)
- Pre-commit quality gates (Ruff, basedpyright, ESLint, Prettier, markdownlint)
- Claude Code agent configuration with slash commands and plugin tools
- Reference documentation covering architecture, security, GDPR, testing, and API design
- Development, how-to, and project-management workflow guides
- Django 6 project scaffold: `apps/core`, `apps/users`, environment-split settings,
  ASGI/WSGI/URL entry points
- Next.js 16 (App Router) scaffold: source structure, Apollo client wrapper, Vitest and
  MSW test setup, Playwright e2e, GraphQL Code Generator config
- `@syntek/shared` internal TypeScript package for shared utilities and components
- Shell script suite for running tests, generating coverage, scaffolding apps and routes
- `install.sh` single-command project setup entry point
