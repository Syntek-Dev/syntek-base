# SEO Implementation Record — US000 {STORY TITLE}

_Template — copy to `SEO-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`[EXAMPLE]` row and `{PLACEHOLDER}` with this story's own analysis, and delete this
note once populated. This is the **post-implementation** SEO record; it verifies, with
evidence, the plan in `../PLANNING/SEO-PLAN-US000-TEMPLATE.md`._

| Field               | Value                                                |
| ------------------- | ---------------------------------------------------- |
| **Story**           | US### — {short title}                                |
| **Date**            | {DD/MM/YYYY}                                         |
| **Verified by**     | {name / agent}                                       |
| **Plan doc**        | `../PLANNING/SEO-PLAN-US###-<DESCRIPTOR>.md`         |
| **Public route(s)** | {`/route/`} — or **N/A** (no public URL — see below) |
| **Lighthouse SEO**  | {score / 100} — or `not measured` with reason        |
| **Outcome**         | Pass / Pass with follow-ups / Blocked                |

> **N/A path.** If the story ships no public URL, set **Public route(s) = N/A**, record
> the one-line reason in **Outcome** (e.g. "backend-only migration; touches no crawlable
> surface"), and stop — the sections below apply only to stories with a public page.

---

## 1. Per-dimension verification

Each SEO dimension marked **Pass / Fail / Deviation** against the shipped page, with the
rendered tag or measured value as evidence. Targets come from `../PLANNING/` and
`project-management/docs/SEO-CHECKLIST.md`.

| Dimension               | Requirement / target                                     | Result   | Evidence (rendered tag / value)                     |
| ----------------------- | -------------------------------------------------------- | -------- | --------------------------------------------------- |
| [EXAMPLE] Title tag     | ≤ 60 chars; brand + primary keyword                      | Pass     | `<title>` = `"{Page Title} \| {Brand}"` — 54 chars  |
| Meta description        | ≤ 160 chars; describes page purpose                      | {result} | {rendered `<meta name="description">` · char count} |
| Open Graph              | `og:title`, `og:description`, `og:image`, `og:type/url`  | {result} | {which OG tags render, and their values}            |
| Twitter Card            | `twitter:card` + title/description/image                 | {result} | {card type + tags, or "inherits OG"}                |
| JSON-LD structured data | Valid schema.org `@type` for the page (see §2)           | {result} | {`@type` shipped, or "N/A — no mapping"}            |
| Canonical URL           | Absolute, self-referential, trailing slash               | {result} | {rendered `<link rel="canonical">`}                 |
| Robots directives       | `index, follow` (or `noindex`/`nofollow` where intended) | {result} | {rendered `<meta name="robots">` + why}             |
| Sitemap inclusion       | Route present in `sitemap.xml` (or excluded by design)   | {result} | {sitemap entry, or deferral target}                 |
| Image alt + optimise    | Alt on every image; sized/lazy-loaded                    | {result} | {alt coverage + format/loading strategy}            |
| Heading hierarchy       | Exactly one `<h1>`; no skipped levels                    | {result} | {`<h1>` text + rendering component}                 |
| Internal linking        | Meaningful inbound/outbound links present                | {result} | {key internal links on the page}                    |
| AI discoverability      | Listed in `llms.txt` where relevant                      | {result} | {`llms.txt` entry, or "N/A"}                        |

_Keep every dimension row; mark it Pass, Fail, or Deviation. A Deviation must be
justified in §5. Delete a row only if the dimension is genuinely inapplicable, and say so._

## 2. Structured data (JSON-LD) shipped

The schema block rendered server-side on the page, the schema.org `@type`, and the Google
Rich Result it targets. "None — no schema.org type maps to this page" is a valid entry.

```json
{ "@context": "https://schema.org", "@type": "{SchemaType}", "...": "{fields}" }
```

| Schema `@type`      | Required fields present               | Rich Result targeted | Result |
| ------------------- | ------------------------------------- | -------------------- | ------ |
| [EXAMPLE] `Article` | `headline`, `author`, `datePublished` | Article rich result  | Pass   |

_One row per schema block wired on the page. Confirm it round-trips as valid JSON and
exposes no PII._

## 3. Core Web Vitals measured

Measured against the rendered dev/staging build, not the worktree. Record the tool and
where the export lives (`LIGHTHOUSE-<US###>-<ROUTE>-DD-MM-YYYY.json` may accompany this record).

| Metric                          | Target     | Measured   | Result   |
| ------------------------------- | ---------- | ---------- | -------- |
| [EXAMPLE] LCP                   | < 2.5 s    | 1.9 s      | Pass     |
| CLS (Cumulative Layout Shift)   | < 0.1      | {measured} | {result} |
| INP (Interaction to Next Paint) | < 200 ms   | {measured} | {result} |
| Lighthouse SEO score            | ≥ {target} | {score}    | {result} |

_If not measurable in the worktree, record "not measured — needs rendered stack" and
raise a follow-up in §5 rather than leaving it blank._

## 4. Plan criteria & gaps closed

Each SEO acceptance criterion and each `SEO-GAP-n` from the plan's §Gaps, closed **only
with evidence** — never mark done without pointing at the shipped tag, block, or metric.

| Plan criterion / gap                 | Status   | Evidence                        |
| ------------------------------------ | -------- | ------------------------------- |
| [EXAMPLE] SEO-GAP-1 {og:image asset} | Closed   | {rendered `og:image` URL}       |
| [EXAMPLE] {canonical strategy}       | Deferred | tracked in `GAPS.md` — {reason} |

_Every `[OPEN]` gap from the plan must resolve to Closed, Deferred (with a `GAPS.md`
entry and target story), or Deviation here._

## 5. Deviations from plan & follow-ups

Any departure from `../PLANNING/SEO-PLAN-US###-*.md`, with justification. "None." is a
valid entry.

- {Deviation and why it was necessary — or "None."}

| Follow-up item                | Priority | Target                      |
| ----------------------------- | -------- | --------------------------- |
| [EXAMPLE] {Lighthouse export} | Medium   | {pre-merge / staging smoke} |

---

## Cross-references

- `../PLANNING/SEO-PLAN-US###-<DESCRIPTOR>.md` — the pre-development plan verified here
- `../../02-STORIES/US###.md` — the story and its `### SEO Acceptance Criteria`
- `project-management/docs/SEO-CHECKLIST.md` — the governing SEO standard
- `project-management/workflows/21-implementation-documentation/` — where this record is written
- `code/docs/RENDERING.md` — the code-side metadata / JSON-LD / sitemap implementation
