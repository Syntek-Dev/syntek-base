---
type: guide
agent: database
skills: [stack-django]
model: opus
---

# Row Level Security Guide

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Row-level security policies, user isolation, migration and endpoint integration

Row Level Security (RLS) enforces data isolation at the PostgreSQL engine level, independent of
application-layer filtering. This guide covers the full RLS implementation for <%PROJECT_NAME%>: when
to enable it, how to configure it in migrations, middleware and Django Ninja endpoint integration,
background task patterns, policy templates, and testing requirements.

## Sub-documents

| Document                                                     | Covers                                                                                                                     |
| ------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| [`rls/FUNDAMENTALS.md`](rls/FUNDAMENTALS.md)                 | Overview, when to use RLS, enabling in migrations, session variable pattern, BYPASSRLS role, table auditing                |
| [`rls/MIDDLEWARE-AND-NINJA.md`](rls/MIDDLEWARE-AND-NINJA.md) | `RLSMiddleware` implementation, middleware order, Django Ninja endpoint integration, Celery task patterns, ORM interaction |
| [`rls/POLICY-TEMPLATES.md`](rls/POLICY-TEMPLATES.md)         | Owner-only, tenant-scoped, role-based, shared-row policy templates, OAuth session exception, performance and indexing      |
| [`rls/TESTING-AND-AUDIT.md`](rls/TESTING-AND-AUDIT.md)       | Test structure with real PostgreSQL, coverage requirements, pre-merge security checklist                                   |

_Part of the `code/docs/` documentation family._
