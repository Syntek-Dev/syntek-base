# code/src/django/static — Static Asset Source

The source tree for static files (`STATICFILES_DIRS`). At baseline it holds **one** script:
the global HTMX error handler, which is here rather than in a template because the rule it
carries is "one listener, never per element" — and a listener in a template is a listener
per page.

**Last Updated**: <%DATE%>

## Directory Tree

```text
static/
├── js/                    ← hand-written per-page and site-wide scripts (no build step)
│   └── observability.js   ← the global htmx:beforeSwap / htmx:sendError handler
├── CONTEXT.md             ← this file
└── CLAUDE.md              ← operating rules
```

## Why a script ships before any page does

HTMX swaps on 2xx only, so a 500 or 503 replaces nothing: the indicator stops and the page is
unchanged. That failure is invisible in review because the happy path looks perfect, and it
is the reason `audits/negative-space.sh` carries the `htmx-handler-absent` clause — any
template using `hx-` implies a `document.body` `htmx:beforeSwap` listener somewhere under
this tree. The clause keys on the **listener**, not on this file's path, so reorganising the
tree is not a failure.

**Nothing loads it yet.** There is no base template to put the `<script>` tag in, so the
first page to ship is what wires it. That is recorded in
`code/docs/FRONTEND-CODING-PRINCIPLES.md` § _What is not built yet_, not left to be
rediscovered.

## What is not here yet

No `css/` tree, and therefore no token layer — `code/docs/DESIGN-TOKENS.md` describes
`css/tokens/*.css` and `surfaces.css` as the canonical home for design values, and
`audits/css-tokens.sh` checks component CSS against it. No vendored HTMX or Alpine either:
those are versioned files a page has to load, and no page exists.

## Cross-references

- `code/docs/rendering/PITFALLS-AND-EXAMPLES.md` § An error the user never sees — the rule
  `observability.js` implements, and the two corrections building it produced
- `code/docs/DESIGN-TOKENS.md` — where the CSS tree will go, and the `var(--token)`-only rule
- `code/src/scripts/audits/negative-space.sh` — the `htmx-handler-absent` clause
- `code/src/django/templates/CONTEXT.md` — the template root, and the error region's absence
