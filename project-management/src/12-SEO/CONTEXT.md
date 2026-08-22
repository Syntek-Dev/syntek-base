# project-management/src/12-SEO

SEO artefacts, per user story. The base repo ships this as a **per-story scaffold**: a
pre-development `PLANNING/` SEO plan and a post-implementation `IMPLEMENTATION/` SEO
record, tied to a story at both ends, mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/12-SEO/
├── CONTEXT.md · CLAUDE.md
├── PLANNING/                      ← pre-development SEO plan, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── SEO-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/                ← post-implementation SEO record, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── SEO-IMPL-US000-TEMPLATE.md
```

Each folder ships one `US000-TEMPLATE.md`; a project copies it per story that adds a
public page. SEO is **per story** — there is no cross-cutting by-scope report folder
(that role is served by the per-story plans, as in 09-GDPR). A story with no public URL
records `SEO: N/A` with a reason and needs nothing further.

## SEO dimensions

Every plan and record covers the same dimensions (guide: `docs/SEO-CHECKLIST.md`):
metadata (title ≤ 60, description ≤ 160), Open Graph + Twitter Card, JSON-LD structured
data, canonical URL, robots directives, sitemap inclusion, image alt + optimisation,
heading hierarchy (single H1), Core Web Vitals (LCP < 2.5s, CLS < 0.1, INP < 200ms), and
AI discoverability (`llms.txt`) where relevant.

## PLANNING ↔ IMPLEMENTATION — per story

- `PLANNING/SEO-PLAN-US###-<DESCRIPTOR>.md` — the pre-development SEO acceptance criteria
  for a story's public route(s): the per-dimension targets and any identified gaps.
- `IMPLEMENTATION/SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` — the post-implementation
  record verifying each dimension against the shipped page, with the measured Lighthouse
  SEO score and Core Web Vitals. A Lighthouse `.json` export may accompany the record.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `project-management/workflows/12-seo-checks/` — produces the `PLANNING/` plan and audits
- `project-management/workflows/23-pr-and-review/` — where the `IMPLEMENTATION/` record lands
- `project-management/docs/SEO-CHECKLIST.md` — full SEO standards and checklist
- `project-management/src/02-STORIES/` — a story's `### SEO Acceptance Criteria` section
- `code/docs/RENDERING.md` — the code-side metadata/JSON-LD/sitemap implementation

**Last Updated**: <%DATE%>
