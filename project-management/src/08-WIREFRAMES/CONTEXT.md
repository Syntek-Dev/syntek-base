# project-management/src/08-WIREFRAMES

Wireframes, in **three stages**. Each story wireframes the screens it introduces
(`USER-STORY-IDEAS/`); once every story is planned, `17-consolidate-design-work` rebuilds them
as one coherent screen set on the consolidated components (`CONSOLIDATED-IDEAS/`); after the
code ships, each story records the screen as built (`IMPLEMENTATION/`).

Screens are self-contained HTML that opens over `file://` — no build step, no CDN, no
JavaScript framework, no external fonts. The only dependency is `SHARED/wireframe.css`, which
stays cumulative across all stages.

## Directory Tree

```text
project-management/src/08-WIREFRAMES/
├── CONTEXT.md               ← this file
├── CLAUDE.md                ← operating rules for this folder
├── USER-STORY-IDEAS/        ← stage 1: per-story screens (workflow 08)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── WF-IDEA-US000-TEMPLATE.html
│   ├── WF-IDEA-US###-<Screen-Name>.html
│   └── WF-IDEA-US###-MOBILE-<Screen-Name>.html
├── CONSOLIDATED-IDEAS/      ← stage 2: the unified screen set (workflow 17)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── WF-CONSOLIDATED-000-TEMPLATE.md   ← the merge record
│   ├── WF-CONSOLIDATED-<AREA>.md
│   ├── WF-###-<Screen-Name>.html         ← the screens that get built
│   └── WF-###-MOBILE-<Screen-Name>.html
├── IMPLEMENTATION/          ← stage 3: the screen as built, per story (workflow 21)
│   ├── CONTEXT.md · CLAUDE.md
│   ├── WF-IMPL-US000-TEMPLATE.md
│   └── WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── SHARED/                  ← the shared stylesheet — cumulative, spans all stages
    ├── CONTEXT.md · CLAUDE.md
    └── wireframe.css
```

## Why three stages

A story wireframes the screens it needs, against the components it knows about. Another story
wireframes an adjacent screen the same way. Neither is wrong, and neither can see that their two
screens will sit next to each other in the product with different card padding, different empty
states, and a navigation that does not agree.

Stage 2 rebuilds the set **on the consolidated components** — so the screens a developer builds
from are consistent by construction, not by luck.

## The three stages

| Stage                 | Written by  | Scope     | Naming                                                               |
| --------------------- | ----------- | --------- | -------------------------------------------------------------------- |
| `USER-STORY-IDEAS/`   | workflow 08 | one story | `WF-IDEA-US###-<Screen-Name>.html`                                   |
| `CONSOLIDATED-IDEAS/` | workflow 17 | the set   | `WF-###-<Screen-Name>.html` + one `WF-CONSOLIDATED-<AREA>.md` record |
| `IMPLEMENTATION/`     | workflow 21 | one story | `WF-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`                           |

**Mobile screens** carry a `MOBILE` marker in the filename and share the number of their web
counterpart where one exists. **Stage 1 is frozen once stage 2 runs.**

## Two of these folders are gated

`CONSOLIDATED-IDEAS/` and `SHARED/` are read by `code/src/scripts/audits/css-slop.sh` and
`template-slop.sh` — the same audits that gate the Django code, because a wireframe is the same
input language. **Stage 1 is not gated**: the clauses that matter here are properties of a page
_set_, and a per-story folder holds one screen at a time. `SHARED/` is in scope despite not
being a stage, because `wireframe.css` is the only stylesheet the screens have.

The rules are not restated anywhere in this tree. `DESIGN.md` → _The design-time gate_ says when
the gate runs and who owns it; `code/docs/VISUAL-DESIGN.md` § 4–§ 6 is what it enforces.

## What NOT to infer from a mobile wireframe

HTML is the medium, not the target. Three affordances exist in the browser and have **no native
equivalent**, so a mobile wireframe must never depend on them:

- **Hover.** There is no hover on touch. Anything a hover would reveal needs another affordance.
- **Scrollbars.** A native scroll view gives no persistent scrollbar, so "the user can see there
  is more below" is not something the platform provides. Show it in the layout.
- **Browser chrome** — no URL bar, no back button, no tab. Navigation must be drawn.

Compose at a phone viewport; 390 × 844 is the reference.

## Cross-references

- `USER-STORY-IDEAS/CONTEXT.md` · `CONSOLIDATED-IDEAS/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md`
- `SHARED/CONTEXT.md` — the shared stylesheet every screen links
- `../05-USER-FLOW/CONSOLIDATED-IDEAS/` — the journeys these screens realise
- `../07-COMPONENTS/CONSOLIDATED-IDEAS/` — the components stage 2 rebuilds on
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA, considered at layout stage
- `project-management/workflows/08-wireframes/` — produces stage 1
- `project-management/workflows/17-consolidate-design-work/` — produces stage 2

**Last Updated**: <%DATE%>
