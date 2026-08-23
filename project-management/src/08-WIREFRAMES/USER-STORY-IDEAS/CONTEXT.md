# project-management/src/08-WIREFRAMES/USER-STORY-IDEAS

**Stage 1** — per-story screens. Self-contained HTML wireframes for the screens **one story**
introduces, written during that story's pass through `workflows/08-wireframes/`.

## Directory Tree

```text
project-management/src/08-WIREFRAMES/USER-STORY-IDEAS/
├── CONTEXT.md                              ← this file
├── CLAUDE.md                               ← operating rules for this folder
├── WF-IDEA-US000-TEMPLATE.html             ← copy this to start a screen
├── WF-IDEA-US###-<Screen-Name>.html        ← one file per web screen
└── WF-IDEA-US###-MOBILE-<Screen-Name>.html ← one file per mobile screen
```

**Naming:** `WF-IDEA-US###-<Screen-Name>.html`. Mobile screens carry the `MOBILE` marker and
share the number of their web counterpart where one exists.

## What the template shows

`WF-IDEA-US000-TEMPLATE.html` is a representative screen composed entirely from the shared
chrome: a skip link and wireframe banner, sticky header/navigation, a hero with a media
placeholder, a card block, an indicative form, a footer, and an **annotation key**. Numbered
`wf-note` markers map to an ordered `wf-annotations` list — how a wireframe carries intent
without finished copy.

**The card block is asymmetric on purpose.** It is a lead card plus two supporting ones in a
two-column grid, so the third wraps and the block reads 2 + 1. A row of three equal cards is the
most recognisable tell of machine-authored UI (`code/docs/VISUAL-DESIGN.md` Section 1), and because
this file is copied to start every screen, whatever shape it ships becomes the project's default.
The `wf-grid--3` modifier is still there for the case where a uniform row is genuinely right —
annotation 3 in the template says when that is, and asks for the reason to be stated.

## Wireframe the story's screens, not the product

Compose from `../SHARED/wireframe.css` and whatever components the consolidated set already
has. Where the story needs something the component set does not cover, use the nearest thing and
**note it in the annotations** — the need itself belongs in
`../../07-COMPONENTS/USER-STORY-IDEAS/`, not invented here.

Screens from different stories will not agree with each other. That is expected;
`18-consolidate-design-work` rebuilds the whole set on the consolidated components.

## Authoring a screen

1. Copy `WF-IDEA-US000-TEMPLATE.html` → `WF-IDEA-US###-<Screen-Name>.html`.
2. Compose from the `wf-*` classes; media goes in `wf-placeholder` boxes with the intended
   aspect ratio noted.
3. Number key regions with `<span class="wf-note">n</span>` and explain each in `wf-annotations`.
4. Open the file in a browser and check every declared breakpoint.
5. Cross-link the driving user story.

**Mobile screens** follow the same five steps at a phone viewport (390 × 844 reference), and
must not rest intent on hover, scrollbars, or browser chrome — none exists natively.

## Frozen at consolidation

Once `18-consolidate-design-work` runs, every file here is frozen. The screens that get built
live in `../CONSOLIDATED-IDEAS/`.

## Cross-references

- `../SHARED/CONTEXT.md` — the stylesheet these screens link
- `../CONSOLIDATED-IDEAS/` — where the set is rebuilt coherently
- `../../05-USER-FLOW/USER-STORY-IDEAS/` — the flow fragment a screen visualises
- `../../07-COMPONENTS/USER-STORY-IDEAS/` — where a missing component is recorded as a need

**Last Updated**: <%DATE%>
