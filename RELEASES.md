# Releases — project-name

**Last Updated**: 19/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v1.0.0 — 19/04/2026

**Status:** First stable scaffold release — ready for feature development

### Summary

Completes the full three-layer monorepo scaffold for the Syntek Studio website. This
release adds the Expo React Native mobile layer, a comprehensive contributor guide suite,
complete CI coverage for all three layers (backend, frontend, mobile), and all supporting
documentation. The scaffold is now fully ready for user story implementation.

### What's new since v0.1.0

- **Mobile layer:** Full Expo React Native scaffold with NativeWind, Storybook, Jest unit
  tests, Detox E2E skeleton, GraphQL codegen config, and Expo Router app screens
- **Mobile Docker:** Dedicated `Dockerfile.test` and mobile service in all Docker Compose configs
- **Mobile CI:** `test-mobile.yml` GitHub Actions workflow for Jest and Detox
- **Mobile scripts:** `mobile.sh`, `mobile-coverage.sh`, `new-expo-screen.sh` shell scripts
- **Frontend Storybook:** `.storybook/` config added to the Next.js layer
- **Contributor guides:** Nine new guides in `how-to/src/` covering getting started,
  branching, committing, PRs, code review, issue reporting, environment setup,
  template customisation, and Claude multilayer usage
- **Repository meta:** `CONTRIBUTING.md` and `LICENSE` (MIT) added to project root
- **Documentation updates:** All CONTEXT.md files, PM guides, CI workflows, Docker configs,
  and script files updated to reflect the complete three-layer structure

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
