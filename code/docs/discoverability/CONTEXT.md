# code/docs/discoverability

Sub-documents for the discoverability standard — how this stack implements being found by search
engines and answer engines. The build-side counterpart to the per-page requirements in
`project-management/docs/SEO-CHECKLIST.md`.

## Directory Tree

```text
code/docs/discoverability/
├── CLAUDE.md            ← operating rules
├── CONTEXT.md           ← this file
├── WEB-METADATA.md      ← the per-page <head>: build_seo(), canonical, Open Graph, Twitter Cards
├── STRUCTURED-DATA.md   ← JSON-LD builders, the XSS-safe serialiser, server-side rendering
├── ROOT-SURFACE.md      ← robots.txt, sitemaps, llms.txt, feeds, /.well-known/ — and the ownership register
└── CONTENT-STRUCTURE.md ← the page body: answer-first, question-shaped headings, self-contained blocks
```

**One guide per output surface.** The head, the JSON-LD block, the root files, the body — four
artefacts, four documents. A rule belongs to whichever artefact it is written into.

## Why this exists as its own family

This doctrine previously sat inside `architecture/FRONTEND-PATTERNS.md`, a file named for
frontend state and routing. It was correct but unfindable, and the file had no room left for the
crawler surface or for answer engines. Splitting it out gave the subject a name a reader would
search for, and left room for the answer-engine work that follows.

The crawler-view knowledge in `ROOT-SURFACE.md` § 1 had a sharper problem: it existed only inside
the `seo` agent's prompt, reachable only when something routed to that agent. Prompt-only
knowledge is knowledge that goes stale unread.

`CONTENT-STRUCTURE.md` closed the same hole a second time, and found the knowledge had gone
stale exactly as predicted: the answer-engine advice living in that prompt and in the SEO
checklist included three techniques Google's own documentation says are unnecessary. **A guide
nobody can find is a guide nobody can correct.**

## The seam this sits on

`project-management/docs/SEO-CHECKLIST.md` owns **what must be true per page**; these documents
own **how this stack does it**. That is the `project-management/` ↔ `code/docs/` reading of
`code/docs/architecture/BUILD-OPERATE-SEAM.md`, and each side names the other rather than
restating it.

## Cross-references

- `code/docs/DISCOVERABILITY.md` — the index these sub-documents belong to
- `project-management/docs/SEO-CHECKLIST.md` — the requirements side of the seam
- `project-management/workflows/12-seo-checks/` — the gate that verifies a page

**Last Updated**: <%DATE%>
