---
type: guide
skills: [seo, stack-htmx-templates]
model: opus
---

# Content Structure — the page body

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — how the body of a public page is shaped so a reader, a crawler and an
answer engine all find the answer in it

The other three guides in this family own the `<head>`, the JSON-LD block, and the files served
from the root. This one owns the **body** — the fourth output surface, and the only one where
the shape of the content itself is the mechanism.

---

## 1. There is no separate answer-engine discipline

"GEO" and "AEO" are marketing labels for search engine optimisation. Google states it plainly in
[AI features and your website](https://developers.google.com/search/docs/appearance/ai-features):

> There are no additional requirements to appear in AI Overviews or AI Mode, nor other special
> optimizations necessary. […] You don't need to create new machine readable files, AI text
> files, or markup to appear in these features.

The only technical precondition is that the page is **indexed and eligible to be shown with a
snippet**. Everything below therefore serves readers, search engines and answer engines at once.
That is not a compromise — it is the finding.

**Three things you may read elsewhere, and should not do:**

| Claim                                           | Why it is wrong                                                                                                                      |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Chunk content so RAG systems extract it cleanly | No answer engine documents a chunking contract. Writing to an imagined one distorts the page for the reader who is real              |
| Rewrite copy with AI-specific keywords          | The same keyword stuffing that search engines have penalised for two decades, relabelled                                             |
| Ship `llms.txt` to win citations                | It is not a citation lever. It has a genuine use — see [`ROOT-SURFACE.md`](ROOT-SURFACE.md) Section 1 — and that use is not this one |

**This section exists because the myths are load-bearing elsewhere.** A guide that quietly
omitted them would leave them standing in the checklists and skills a developer also reads.

---

## 2. The rules

### Answer first

The opening paragraph of a page answers the question the page is about. No scene-setting, no
throat-clearing, no restating the title as a sentence.

This is a **structural** rule about where the answer sits, not a tonal one. The register the
answer is written in belongs to `how-to/src/BRAND-VOICE.md`; whether the answer comes first
belongs here.

### Headings shaped like questions

`H2`/`H3` headings mirror how a person asks the thing, not how the business files it. "How do I
cancel a booking?" over "Cancellation policy". A heading is a retrieval target for a reader
scanning, a search engine matching a query, and an answer engine locating a passage — all three
want the same shape.

Heading **hierarchy** — one `H1`, no skipped levels — is an accessibility requirement owned by
[`../ACCESSIBILITY.md`](../ACCESSIBILITY.md). This rule is about the **wording**, and does not
relax that one.

### Self-contained answer blocks

The passage under a heading answers that heading **without requiring the paragraph above it**.
A block that begins "As mentioned above…" is not extractable, and is also worse to read.

**No word count.** Sources circulate specific figures; none is traceable to a primary source, and
a number invented for one engine's tuning is false precision that will age badly. The test is
whether the block stands alone, and a person decides that.

### Claims a reader can check

Statistics, figures and dates in the text, not in an image. A claim that only exists inside a
PNG is invisible to a crawler, an answer engine, a screen reader, and anyone on a slow
connection. This is the same rule `BRAND-VOICE.md` Section 4 states as "numbers replace adjectives" —
reached from the other side.

### Freshness and authorship

Where a page makes a claim that decays — pricing, availability, a legal position, a
how-to — it shows when it was last reviewed and, where the credibility of the author matters,
who wrote it.

**Both are already structured data.** Render them for the reader _and_ pass them through
`build_seo()` and the `Article` builder, so the human-readable and machine-readable copies cannot
disagree. The schema half is [`STRUCTURED-DATA.md`](STRUCTURED-DATA.md)'s.

### Nothing critical behind a barrier

Content that matters is in the served HTML. Not behind a client-side render, an interaction, a
login, a paywall, a PDF, or an iframe.

[`../RENDERING.md`](../RENDERING.md) decides where an interaction runs; this is the reason the
answer is never on the client side of that line. A crawler may decline to execute JavaScript, and
an answer engine reading raw HTML certainly will not.

---

## 3. What this guide does not own

| Concern                                               | Owner                                                                           |
| ----------------------------------------------------- | ------------------------------------------------------------------------------- |
| The words themselves — tone, register, banned tells   | `how-to/src/BRAND-VOICE.md`                                                     |
| Every schema type and its markup                      | [`STRUCTURED-DATA.md`](STRUCTURED-DATA.md)                                      |
| The `<head>`, canonical, Open Graph                   | [`WEB-METADATA.md`](WEB-METADATA.md)                                            |
| `robots.txt`, sitemaps, `llms.txt`, `/.well-known/`   | [`ROOT-SURFACE.md`](ROOT-SURFACE.md)                                            |
| Heading hierarchy, alt text, contrast                 | [`../ACCESSIBILITY.md`](../ACCESSIBILITY.md)                                    |
| Which pages exist and what they are for               | `project-management/docs/SEO-CHECKLIST.md`                                      |
| Backlinks, PR, original research, citation monitoring | **Nothing here.** Growth activities — no guide in this repository consumes them |

---

## What is mechanically checkable here

**Almost none of it.** Whether a paragraph answers the question, whether a heading matches how
someone would ask, and whether a block stands alone are all judgements a reader makes.

Three exceptions worth a test rather than a review: a page has exactly one `H1`; a page that
declares `Article` schema also renders a visible last-reviewed date; no public page's primary
content is empty in the served HTML with JavaScript disabled.

The rest belongs to the story's SEO plan in `project-management/src/12-SEO/PLANNING/` and to the
reviewer. **A clean audit run does not mean this guide was honoured** — the same split
`BRAND-VOICE.md` Section 4 draws between its gated and `[judgement]` clauses.

---

## Cross-references

- [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md) — the index and the seam statement
- [`WEB-METADATA.md`](WEB-METADATA.md) — the `<head>` this body sits beneath
- [`STRUCTURED-DATA.md`](STRUCTURED-DATA.md) — the schema half of freshness, authorship and FAQs
- [`../RENDERING.md`](../RENDERING.md) — why the answer is server-rendered
- [`../ACCESSIBILITY.md`](../ACCESSIBILITY.md) — heading hierarchy and alt text as requirements
- `how-to/src/BRAND-VOICE.md` — the register the answer is written in
- [Google — AI features and your website](https://developers.google.com/search/docs/appearance/ai-features)
  — the primary source behind Section 1

_Part of the `code/docs/` documentation family._
