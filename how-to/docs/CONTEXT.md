# how-to/docs — Operational Reference Guides

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>

Reference guides for **operating** this project rather than building it: how to bring the stack
up, run the gates, update dependencies, debug, and hand a procedure to a human. They sit apart
from `code/docs/` because their reader is executing steps under time pressure, not deciding a
standard — which is a different document with a different shape.

## Directory Tree

```text
how-to/docs/
├── AI-DICTIONARY.md         ← plain-English glossary of AI-coding terms (index)
│   └── ai-dictionary/       ← 7 themed term sub-documents
├── CELERY-FIRST-RUN.md      ← first-run review before enabling the Celery worker/beat per environment
├── CLI-TOOLING.md           ← CLI reference for all Docker Compose development commands
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── DEVELOPMENT.md           ← first-time setup, Docker Compose commands, env vars, troubleshooting
├── FEATURE-DEPLOY.md        ← feature deploy-coordination: edge CSP, body-size, secrets, beat, cache bust
├── GIT-WORKTREES.md         ← parallel development with git worktrees, Docker isolation, URLs
├── INCIDENT-PRACTICE.md     ← running a live incident: declare, hand over, stand down, write up
├── OPERATOR-DOC-CRAFT.md    ← the standing conventions behind every guide a human executes
├── SKILL-AUTHORING.md       ← how to write predictable skills under .claude/skills/ (index)
│   └── skill-authoring/     ← 4 sub-documents: FORK-DECISION · FRONTMATTER · CRAFT · SHIPPING
└── TOOLING-GUIDE.md          ← internal agents and skills reference (index)
    └── tooling-guide/        ← workflow/ commands/ configuration/
```

| Guide                   | Scope                                                                                                                                    |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `DEVELOPMENT.md`        | First-time setup, Docker Compose commands, environment variables                                                                         |
| `CELERY-FIRST-RUN.md`   | First-run review before enabling the Celery worker/beat per environment                                                                  |
| `FEATURE-DEPLOY.md`     | Feature deploy-coordination: edge CSP, body size, secrets, beat, cache bust                                                              |
| `GIT-WORKTREES.md`      | Parallel feature development with git worktrees and Docker isolation                                                                     |
| `INCIDENT-PRACTICE.md`  | Running a live incident — declare, shift handover, stand down, postmortem                                                                |
| `OPERATOR-DOC-CRAFT.md` | The reader, the two homes and their two length standards, the runbook spine, command discipline, execute-to-verify, the scope boundaries |
| `AI-DICTIONARY.md`      | Plain-English glossary of AI-coding terms (index over ai-dictionary/)                                                                    |
| `SKILL-AUTHORING.md`    | How to write predictable skills under .claude/skills/ (index)                                                                            |
| `TOOLING-GUIDE.md`      | Internal agents and skills reference (index)                                                                                             |
| `CLI-TOOLING.md`        | CLI reference for all Docker Compose development commands                                                                                |
