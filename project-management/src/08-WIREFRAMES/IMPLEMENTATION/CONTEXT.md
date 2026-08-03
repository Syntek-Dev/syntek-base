# project-management/src/08-WIREFRAMES/IMPLEMENTATION

**Stage 3** — the screen as built. One record per user story, written during
`workflows/21-implementation-documentation/`, confirming that the shipped Django templates
follow the consolidated screens in `../CONSOLIDATED-IDEAS/`.

## Directory Tree

```text
project-management/src/08-WIREFRAMES/IMPLEMENTATION/
├── CONTEXT.md                                 ← this file
├── CLAUDE.md                                  ← operating rules for this folder
├── WF-IMPL-US000-TEMPLATE.md                  ← copy this to record a story's screens
└── WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md   ← one record per story
```

**Naming:** `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`.

## What it holds

Per story: each consolidated screen the story built, marked Present / Changed / Missing with the
Django template as evidence; the responsive check at every breakpoint against the running page;
the accessibility pass; and any deviation from the consolidated wireframe.

## The wireframe is not the implementation

A wireframe is a layout and interaction contract, not markup to copy. What ships is a Django
template plus django-components with HTMX and Alpine, and token CSS. This record checks the
shipped page **honours the contract** — layout, hierarchy, states, and interaction — not that it
resembles the HTML.

## Cross-references

- `WF-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — the screens these records verify against
- `../USER-STORY-IDEAS/` — the frozen stage-1 screen, for tracing intent
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA verified against the running page
- `code/docs/responsive/BREAKPOINTS.md` — the breakpoints checked
- `../../19-FINDINGS/` — where a divergence worth carrying forward is recorded

**Last Updated**: <%DATE%>
