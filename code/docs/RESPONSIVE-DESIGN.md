---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Responsive Design

**Project:** <%PROJECT_NAME%> **Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:**
<%ORG_NAME%> **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Mobile-first CSS, breakpoints, media queries, user preference queries

Mobile-first responsive design using vanilla CSS with custom properties and Django-generated design
tokens. The whole site is server-rendered Django templates (django-components + HTMX + Alpine.js).
Covers breakpoints, media queries, user preference queries (dark mode, reduced motion, high
contrast), and container queries.

Roughly 62% of traffic is mobile. Design mobile-first and scale up.

## Sub-documents

| Document                                                             | Covers                                                                                                                       |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| [`responsive/BREAKPOINTS.md`](responsive/BREAKPOINTS.md)             | Device split, web breakpoint token table, viewport reference                                                                 |
| [`responsive/MEDIA-QUERIES.md`](responsive/MEDIA-QUERIES.md)         | Syntax, mobile-first approach, orientation, pointer/hover, resolution, logical operators, HTML integration, print styles     |
| [`responsive/USER-PREFERENCES.md`](responsive/USER-PREFERENCES.md)   | Dark mode (two-level system, semantic tokens, generated cascade), reduced motion, high contrast, forced-colors, reduced data |
| [`responsive/CONTAINER-QUERIES.md`](responsive/CONTAINER-QUERIES.md) | Declaring containers, query syntax, `ch`-based breakpoints, custom sizes, query types, limitations                           |

_Part of the `code/docs/` documentation family._
