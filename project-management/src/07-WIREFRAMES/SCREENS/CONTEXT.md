# project-management/src/07-WIREFRAMES/SCREENS

The wireframe screens — one self-contained HTML file per screen. Each opens
directly in a browser over `file://` with no build step, no CDN, and no
JavaScript framework; the only dependency is `../SHARED/wireframe.css`.

## Directory Tree

```text
project-management/src/07-WIREFRAMES/SCREENS/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for this folder
├── WF-000-TEMPLATE.html  ← the screen template — copy this to start a new screen
└── WF-###-<Screen-Name>.html  ← one file per screen (a project's own screens)
```

The base template ships **only** `WF-000-TEMPLATE.html`. A project creating its
own wireframes copies it to `WF-001-<Screen-Name>.html`, `WF-002-…`, and so on.

## What the template shows

`WF-000-TEMPLATE.html` is a representative marketing screen composed entirely
from the shared chrome: a skip link and wireframe banner, a sticky
header/navigation, a hero with a media placeholder, a three-up card row, an
indicative form, a footer, and an **annotation key**. Numbered `wf-note` markers
in the layout map to an ordered `wf-annotations` list — the mechanism a wireframe
uses to carry intent (what each region is for) without finished copy or styling.

Everything is placeholder brand. Rebrand by editing `../SHARED/wireframe.css`
`:root` tokens; the screens reference only `--wf-*` variables and class names.

## Authoring a screen

1. Copy `WF-000-TEMPLATE.html` → `WF-###-<Screen-Name>.html` (zero-padded number).
2. Compose the layout from the `wf-*` classes; add media as `wf-placeholder`
   boxes with the intended aspect ratio noted.
3. Number the key regions with `<span class="wf-note">n</span>` and explain each
   in the `wf-annotations` list.
4. Open the file in a browser to check every declared breakpoint.
5. Cross-link the driving user story.

## Cross-references

- `../SHARED/CONTEXT.md` — the shared stylesheet these screens link
- `../CONTEXT.md` — the wireframes folder overview and workflow
- `../../06-COMPONENTS/` — the component sheet the chrome mirrors

**Last Updated**: <%DATE%>
