# how-to/docs — Operational Reference Guides

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Quick navigation of setup and development guides
**MCP Servers:** None (pure index documentation)

## Directory Tree

```text
how-to/docs/
├── AI-DICTIONARY.md         ← plain-English glossary of AI-coding terms (index)
│   └── ai-dictionary/       ← 7 themed term sub-documents
├── CELERY-FIRST-RUN.md      ← first-run review before enabling the Celery worker/beat per environment
├── CLI-TOOLING.md           ← CLI reference for all Docker Compose development commands
├── CONTEXT.md               ← this file
├── DEVELOPMENT.md           ← first-time setup, Docker Compose commands, env vars, troubleshooting
├── FEATURE-DEPLOY.md        ← feature deploy-coordination: edge CSP, body-size, secrets, beat, cache bust
├── GIT-WORKTREES.md         ← parallel development with git worktrees, Docker isolation, URLs
├── SKILL-AUTHORING.md       ← how to write predictable skills under .claude/skills/
└── TOOLING-GUIDE.md          ← internal agents and skills reference (index)
    └── tooling-guide/        ← workflow/ commands/ configuration/
```

| Guide                 | Scope                                                                       |
| --------------------- | --------------------------------------------------------------------------- |
| `DEVELOPMENT.md`      | First-time setup, Docker Compose commands, environment variables            |
| `CELERY-FIRST-RUN.md` | First-run review before enabling the Celery worker/beat per environment     |
| `FEATURE-DEPLOY.md`   | Feature deploy-coordination: edge CSP, body size, secrets, beat, cache bust |
| `GIT-WORKTREES.md`    | Parallel feature development with git worktrees and Docker isolation        |
| `AI-DICTIONARY.md`    | Plain-English glossary of AI-coding terms (index over ai-dictionary/)       |
| `SKILL-AUTHORING.md`  | How to write predictable skills under .claude/skills/                       |
| `TOOLING-GUIDE.md`    | Internal agents and skills reference (index)                                |
| `CLI-TOOLING.md`      | CLI reference for all Docker Compose development commands                   |
