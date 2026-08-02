---
type: guide
agent: planner
skills: [codebase-design, improve-codebase-architecture, stack-django, stack-htmx-templates]
model: fable
---

# Architecture Patterns

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Service layer, Django app structure, template/HTMX routing, scaling decisions

Architecture patterns covering the service layer, middleware, frontend state, project structure,
and core backend decisions. Fills the gap between domain modelling (`DATA-STRUCTURES.md`), API
contracts (`API-DESIGN.md`), and performance (`PERFORMANCE.md`).

## Sub-documents

| Document                                                                           | Covers                                                                                                                                                  |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) | Service layer pattern, middleware order, background job classification, email/notification patterns, file processing pipelines                          |
| [`architecture/FRONTEND-PATTERNS.md`](architecture/FRONTEND-PATTERNS.md)           | Frontend state (Django/HTMX/Alpine), routing conventions, project structure, SEO / JSON-LD / `.well-known` patterns                                     |
| [`architecture/CORE-AND-SCALING.md`](architecture/CORE-AND-SCALING.md)             | The decisions to settle before the first migration (auth model, key shape, PII posture, isolation scope, distribution key), and the scaling phase-gates |
| [`architecture/AUTH-CONTRACT.md`](architecture/AUTH-CONTRACT.md)                   | AdminMember/ModulePermission actor auth contract — mandatory for every state-changing operation on these models                                         |

_Part of the `code/docs/` documentation family._
