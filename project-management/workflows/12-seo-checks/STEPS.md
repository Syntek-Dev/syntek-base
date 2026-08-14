---
workflow: 12-seo-checks
phase: design
skills: [seo, stack-htmx-templates, global-workflow]
model: fable
---

# SEO Checks — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

> **This workflow plans; it does not verify.** It runs inside the per-story specify loop, before
> any page exists. Auditing the built page, Lighthouse, and the `IMPLEMENTATION/` record belong
> to `21-implementation-documentation`.

---

## Key references

| Step   | Reference                                                                    |
| ------ | ---------------------------------------------------------------------------- |
| All    | `project-management/docs/SEO-CHECKLIST.md` — the canonical checklist         |
| Step 2 | `src/08-WIREFRAMES/USER-STORY-IDEAS/` — the page structure being planned for |
| Step 3 | `code/docs/URL-STRATEGY.md` — slug conventions                               |
| Step 5 | `code/docs/performance/FRONTEND-PERFORMANCE.md` — Core Web Vitals budgets    |

---

## Prerequisites

- [ ] The story exists in `src/02-STORIES/` with acceptance criteria
- [ ] Its wireframes exist in `src/08-WIREFRAMES/USER-STORY-IDEAS/`
- [ ] `docs/SEO-CHECKLIST.md` read

---

## Steps

### Step 1 — Grill, then confirm the page exists at all

> **Model:** fable

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and interview
<%DEVELOPER_NAME%>:

- Does this story ship a public URL? If not, record `SEO: N/A` with a reason and stop.
- What is the page's primary keyword or search intent?
- Should it be indexed at all — or is it a portal/admin surface that must not be?
- Which schema type genuinely fits the content?

_Done when the SEO flag is set and the intent is confirmed._

### Step 2 — Copy the template and set the header

> **Model:** fable

Copy `src/12-SEO/PLANNING/SEO-PLAN-US000-TEMPLATE.md` → `SEO-PLAN-US###-<DESCRIPTOR>.md`.
Record the story, the public route(s), and the SEO flag.

### Step 3 — Set the metadata and URL targets

> **Model:** fable

Concrete planned values — not "a good title":

- **Title** — the intended text, ≤ 60 chars, keyword-bearing
- **Meta description** — the intended text, ≤ 160 chars
- **Open Graph** — `og:title`, `og:description`, `og:image` source
- **Canonical** — the canonical URL and, if the page is reachable by more than one route, which
  one wins
- **Slug** — lowercase, hyphenated, human-readable (`code/docs/URL-STRATEGY.md`)

### Step 4 — Decide structured data, robots, and sitemap

> **Model:** fable

- **JSON-LD schema type** and the fields it will carry
- **robots** — indexed or not, stated explicitly rather than left to the default
- **sitemap** — included or not; note if a Celery regeneration is triggered on publish

### Step 5 — Set the content and performance targets

> **Model:** fable

From the wireframe:

- **Heading hierarchy** — one `<h1>`, the planned `<h2>`/`<h3>` order
- **Image alt text** — the intent per image role; decorative images marked `alt=""`
- **Core Web Vitals budgets** — LCP < 2.5 s · CLS < 0.1 · INP < 200 ms, plus any page-specific
  risk (a hero video, a large table) noted now rather than discovered at audit

### Step 6 — Raise the gaps

> **Model:** fable

Where SEO intent is declared but unspecified, raise it as `SEO-GAP-n` marked `[OPEN]`. Resolve
each in this plan, or feed it back into `src/02-STORIES/US###.md` — an open gap must not survive
into `14-decisions`.

### Step 7 — Close out

> **Model:** opus

- Keep the story's `### SEO Acceptance Criteria` consistent with this plan
- Satisfy `CHECKLIST.md`

Next in the per-story loop: `13-api-design/`, then `14-decisions/`.
Verification of the built page happens later, in `21-implementation-documentation/`.
