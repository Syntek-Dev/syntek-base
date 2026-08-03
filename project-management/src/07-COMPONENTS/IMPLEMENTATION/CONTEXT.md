# project-management/src/07-COMPONENTS/IMPLEMENTATION

**Stage 3** — components as shipped. One record per user story, written during
`workflows/21-implementation-documentation/`, confirming that the components the story used
exist in `code/src/django/components/` and match `../CONSOLIDATED-IDEAS/`.

## Directory Tree

```text
project-management/src/07-COMPONENTS/IMPLEMENTATION/
├── CONTEXT.md                                   ← this file
├── CLAUDE.md                                    ← operating rules for this folder
├── COMP-IMPL-US000-TEMPLATE.md                  ← copy this to record a story's components
└── COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md   ← one record per story
```

**Naming:** `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Reuse the stage-1 descriptor.

## What it holds

Per story: each consolidated component the story used, confirmed present in the
django-components library with its variants; every state verified as actually implemented; the
accessibility checks run against the built component; and any deviation from the consolidated
set.

## States and focus are where it slips

A component ships when its default state looks right. The disabled state, the error state, and
the focus indicator are what get skipped — and they are precisely what the consolidated state
matrix pinned down. This record verifies each one against the running build, not against the
template.

## Cross-references

- `COMP-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — the decided set these records verify against
- `../USER-STORY-IDEAS/` — the frozen need, for tracing intent
- `code/src/django/components/` — where the implementations live
- `code/docs/ACCESSIBILITY.md` — the WCAG 2.2 AA obligations verified here
- `../../19-FINDINGS/` — where a divergence worth carrying forward is recorded

**Last Updated**: <%DATE%>
