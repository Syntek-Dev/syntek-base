---
name: support-articles
description: >-
  Write end-user help content for <%PROJECT_NAME%> — getting-started tutorials, how-to guides,
  feature overviews, troubleshooting, FAQs and user-facing release notes, in plain language a
  non-technical reader can follow to finish a task. Load when a shipped capability needs public
  help content. Not developer documentation or `CONTEXT.md` files (`doc-writer`), not the guides
  an operator runs the system by (`runbook`), not building the help-centre pages (`frontend`),
  and not their metadata (`seo`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling
---

# Write the Help Article (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable authoring task whose output is a published help
article).

**Locale:** <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%> — British spelling, DD/MM/YYYY dates, and
<%CURRENCY%> in every example.

---

## The brief arrives settled

A fork cannot ask, so the brief must carry **the topic**, **the audience**, **the article
type**, and **the actual user-facing steps** — what a person clicks, in order, and what they
should see when it worked. **If the steps are missing, return rather than inventing them**: a
help article that describes a flow the product does not have is worse than no article, because
the reader trusts it and then blames themselves.

Where the topic or shape is open, that is a `grilling` pass run inline first.

## Before drafting

Read the feature's own `CONTEXT.md` **and the existing articles in the same area**. Adopt their
structure and their terminology — **never invent a second term for a concept the help centre
already names.** Two words for one thing is the defect a reader cannot diagnose.

## The types, and the shape each takes

| Type             | Purpose                     | Shape                        |
| ---------------- | --------------------------- | ---------------------------- |
| Getting started  | Onboard a new user          | Short numbered tutorial      |
| How-to guide     | Complete one specific task  | Numbered steps, verification |
| Feature overview | Explain what a feature does | Description plus use cases   |
| Troubleshooting  | Fix a known problem         | Symptom → cause → solution   |
| FAQ              | Answer recurring questions  | Q&A, grouped by theme        |
| Release notes    | Communicate a change        | What changed, plus migration |

## Front matter

```yaml
---
title: <clear, descriptive title>
description: <one sentence, 150 characters or fewer>
category: getting-started | how-to | troubleshooting | faq | overview | release-notes
difficulty: beginner | intermediate | advanced # optional
last_updated: DD/MM/YYYY
related_articles: # optional
  - ./RELATED-ARTICLE.md
---
```

## Writing rules

- **Second person, active voice.** Sentences under about 25 words; short paragraphs.
- **Bold** for UI elements — buttons, menu names; `code` for a literal input or value.
- Numbered lists for ordered steps, bullets for everything else.
- **Descriptive link text, never "click here."** One H1, then H2 → H3 in order.
- **Every image needs alt text. Flag the screenshots you need rather than inventing them.**
- **Be definitive and reassuring.** No "you might try" hedging — a hedge in help content reads
  as the product not knowing its own behaviour. Define any jargon on first use.
- The register is `how-to/src/BRAND-VOICE.md`'s functional and microcopy register: plain, calm,
  action-first, no hype.

## Definition of done

The article saved with valid front matter; British English throughout; WCAG-compliant markup
(heading order, alt text, descriptive links); terminology consistent with the existing content;
the screenshots still needed and the cross-links worth adding both named for the handoff.

## Output and naming

`SCREAMING-SNAKE-CASE.md` grouped by category folder —
`help/GETTING-STARTED/QUICK-START-GUIDE.md`, `help/TROUBLESHOOTING/LOGIN-ISSUES.md`,
`help/FAQ.md`. **Match the destination the help centre already expects** — check
`code/docs/URL-STRATEGY.md` and the existing tree before creating a new folder.

## Handoff

Report the article written, the screenshots still required, and any existing article that
should now link to this one. Then name what is owed: `frontend` to build or wire the
help-centre pages, `seo` for their metadata and structured data, `doc-writer` where the same
change also needs developer documentation, and `completion` to record the documentation task.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** Help content is not a gated product artefact — it is written when a
shipped capability needs explaining, usually by the `implement-story` or `release` sequence. Do not
route it into `code/workflows/`, `project-management/workflows/`, or `how-to/workflows/`; those
sequence the building of the thing, not the explaining of it.

## Cross-references

- `how-to/src/BRAND-VOICE.md` — the voice, and the microcopy register help content uses
- `code/docs/ACCESSIBILITY.md` — heading hierarchy, alt text, descriptive links
- `code/docs/URL-STRATEGY.md` — where a help route sits among the three prefixes
