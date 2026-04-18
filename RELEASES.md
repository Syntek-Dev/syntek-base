# Releases — syntek-website

**Last Updated**: 18/04/2026 **Version**: 0.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v0.1.0 — 18/04/2026

**Status:** Scaffold — pre-implementation

### Summary

Initial project scaffold for the Syntek Studio website. No public-facing features
are included in this release. The scaffold establishes the full project structure,
tooling, CI pipeline, Docker environments, and agent guidance system ready for
feature development to begin.

### What's included

- Full project directory structure with three-layer context system
- Docker Compose environments for development, testing, staging, and production
- Automated lint, type-check, and test CI pipeline via GitHub Actions
- Pre-commit quality gates (Ruff, basedpyright, ESLint, Prettier, markdownlint)
- Claude Code agent configuration with slash commands and plugin tools
- Reference documentation covering architecture, security, GDPR, testing, and API design
- Development, how-to, and project-management workflow guides

### Known limitations

- Backend and frontend source code not yet implemented
- No deployable application in this release
