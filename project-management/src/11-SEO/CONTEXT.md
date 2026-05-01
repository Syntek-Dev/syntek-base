# project-management/src/11-SEO

SEO audit reports, Lighthouse exports, and planning gap analysis for all public-facing pages.

## Directory Tree

```text
project-management/src/11-SEO/
├── CONTEXT.md                                    ← this file
├── PLANNING/                                     ← SEO gap analysis reports (created by planning workflow)
│   └── CONTEXT.md
└── LIGHTHOUSE-<US###>-<ROUTE>-DD-MM-YYYY.json   ← Lighthouse exports per story and route
```

## When to use this

- Save Lighthouse exports here after running `workflows/11-seo-checks/` on a story or sprint
- Read `PLANNING/` before starting SEO work on a new sprint to understand outstanding gaps
- Reference Lighthouse exports during sprint reviews and performance retrospectives

## Naming

| File pattern                             | Created by               |
| ---------------------------------------- | ------------------------ |
| `LIGHTHOUSE-US###-ROUTE-DD-MM-YYYY.json` | `11-seo-checks` workflow |
| `PLANNING/SEO-REPORT-*.md`               | `11-seo-checks` workflow |

**Example:** `LIGHTHOUSE-US007-blog-post-01-05-2026.json`

## Cross-references

- `project-management/workflows/11-seo-checks/` — workflow that produces files in this directory
- `project-management/docs/SEO-CHECKLIST.md` — full SEO standards and checklist
- Story files `### SEO Acceptance Criteria` — per-story SEO criteria that drive checks
