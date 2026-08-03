---
workflow: 12-seo-checks
phase: design
agent: seo
skills: [stack-htmx-templates, global-workflow]
model: fable
---

# SEO Checks — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

> **This gate plans; it does not verify.** Everything measured against a built page — rendered
> tags, Lighthouse, the `IMPLEMENTATION/` record — is checked in
> `21-implementation-documentation`, not here.

---

## Entry conditions

- [ ] Story exists in `src/02-STORIES/` with acceptance criteria
- [ ] Wireframes exist in `src/08-WIREFRAMES/USER-STORY-IDEAS/`
- [ ] `docs/SEO-CHECKLIST.md` read
- [ ] Step 1 grilling pass complete and confirmed

## The N/A path

- [ ] If the story ships **no public URL**: header records `SEO: N/A` with a one-line reason, and
      nothing below is required

## Metadata targets

- [ ] Intended `<title>` written — ≤ 60 chars, carries the primary keyword
- [ ] Intended meta description written — ≤ 160 chars, unique to this page
- [ ] `og:title`, `og:description`, and the `og:image` source decided
- [ ] Canonical URL decided; if the page is reachable by more than one route, the winner is stated

## Structured data, robots, sitemap

- [ ] JSON-LD schema type chosen and its fields listed
- [ ] Indexing decision stated **explicitly** — indexed or not, never left to the default
- [ ] Sitemap inclusion decided; Celery regeneration noted if publishing triggers it

## Content and performance targets

- [ ] Slug planned — lowercase, hyphenated, human-readable, keyword-bearing
- [ ] Heading hierarchy planned from the wireframe — exactly one `<h1>`, logical `<h2>`/`<h3>`
- [ ] Alt-text intent stated per image role; decorative images marked `alt=""`
- [ ] Core Web Vitals budgets recorded (LCP < 2.5 s · CLS < 0.1 · INP < 200 ms)
- [ ] Any page-specific performance risk named now — hero video, large table, third-party embed

## Target quality

- [ ] Every dimension has a **concrete** value or a justified `N/A` — no "make it good"
- [ ] No target depends on client-side rendering; SEO-critical content is in the initial HTML

## Gaps

- [ ] Every `SEO-GAP-n` is resolved in this plan or fed back into `src/02-STORIES/US###.md`
- [ ] No `[OPEN]` gap remains — an open gap must not survive into `14-decisions`

## Consistency

- [ ] The story's `### SEO Acceptance Criteria` matches this plan
- [ ] Plan saved as `src/12-SEO/PLANNING/SEO-PLAN-US###-<DESCRIPTOR>.md`, linked to its `US###`

## Close-out

- [ ] Instructional `.md` files ≤ 300 code lines
- [ ] British English throughout; dates DD/MM/YYYY

---

## Definition of Done

- [ ] Every box above ticked, or the whole plan is a justified `SEO: N/A`
- [ ] The story can proceed to `13-api-design/` and `14-decisions/`
