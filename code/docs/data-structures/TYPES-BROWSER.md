---
type: guide
skills: [frontend, stack-htmx-templates, code-reviewer]
model: opus
---

# Types Over Dictionaries — Alpine and HTMX

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — component contracts, shared constants, and the HTMX view-model

> **Forward-looking.** The browser surface ships no interactive code at baseline — no `x-data` or
> `hx-` attribute in `code/src/` outside the audit fixtures, one template
> (`code/src/django/templates/500.html`), and one script nothing yet loads
> (`code/src/django/static/js/observability.js`, there being no base template). This guide is the
> standard the first component is built to, not a description of code that exists.

**This guide overrides two shipped examples**, both corrected in the same change, because a
reader who has already met them needs to know which wins.
[`../rendering/TEMPLATES-AND-INTERACTIVITY.md`](../rendering/TEMPLATES-AND-INTERACTIVITY.md)
shows `x-data="{ open: false }"` as the general Alpine shape — it is the carve-out, not the
pattern, per the threshold below. [`../rendering/PITFALLS-AND-EXAMPLES.md`](../rendering/PITFALLS-AND-EXAMPLES.md)
sets `response["HX-Trigger"] = "itemSaved"` with two bare string literals; both become constants.

The core principle is owned by [`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md); the
confinement policy and the `DICT-OK:` escape hatch by
[`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md); shape anti-patterns by
[`ANTI-PATTERNS.md`](ANTI-PATTERNS.md). None is restated here.

---

## An Alpine component is a contract, not a bag of keys

A component with state is **registered by name** in a static `.js` file, and `x-data` names it
and passes arguments. The returned object **is** the contract: every property declared up front
with an initial value, plus the methods that change them.

**Before** — the shape the rendering guide currently teaches, grown one requirement at a time:

```html
<div
  x-data="{ open: false, query: '', results: [], loading: false,
      async search() { this.loading = true;
        this.results = await (await fetch('/s/?q=' + this.query)).json();
        this.loading = false } }"
>
  <input x-model="query" @input.debounce="search()" />
</div>
```

Nobody can review that: state, network call and markup share one attribute, and the only way to
learn the shape is to parse an HTML attribute by eye.

**After** — a new file under `code/src/django/static/js/`, say `search-panel.js`:

```javascript
document.addEventListener("alpine:init", () => {
  Alpine.data("searchPanel", (endpoint) => ({
    open: false,
    query: "",
    results: [],
    loading: false,

    async search() {
      this.loading = true;
      this.results = await (await fetch(`${endpoint}?q=${encodeURIComponent(this.query)}`)).json();
      this.loading = false;
    },
  }));
});
```

```django
<div x-data="searchPanel('{% url 'marketing:search' %}')">
  <input x-model="query" @input.debounce="search()" aria-label="Search" />
</div>
```

**The CSP point is why the registration file is not optional.** This project bans inline
`<script>` and `<style>` ([`../FRONTEND-CODING-PRINCIPLES.md`](../FRONTEND-CODING-PRINCIPLES.md)),
so component behaviour may only live in a static asset loaded with
`<script defer src="{% static %}">`. An `x-data` naming a registered component keeps the markup
CSP-clean; one carrying a function body is a script in an attribute in all but name. Values reach
it through `{% json_script %}` or a quoted argument, never interpolated into an expression — that
is both an XSS vector and a CSP violation.

**The carve-out, stated honestly.** `x-data="{ open: false }"` for a single boolean toggle with no
methods is not worth a registration file, and pretending otherwise makes the rule easy to ignore
everywhere. **The threshold is: more than one property, or any method.**

---

## Declare every property at init

Every property the component will ever hold is declared in the returned object with an initial
value. No `this.somethingNew = …` after init; no key added by a method the first time it runs.

```javascript
// Bad — `error` and `failedAt` exist only after the first failure.
Alpine.data("uploader", () => ({
  file: null,
  fail() {
    this.error = "Upload failed";
    this.failedAt = Date.now();
  },
}));

// Good — the object is the declaration.
Alpine.data("uploader", () => ({ file: null, error: null, failedAt: null, fail() {} }));
```

Two reasons, both concrete:

- **The shape is otherwise invisible.** Reader, reviewer and template author all have to execute
  the failure path in their heads to discover `error` exists — the binding `x-show="error"` reads
  as a typo until you find the assignment.
- **Reactivity is established at init.** Alpine walks the object it is given and makes those
  properties reactive. A property assigned later may not be tracked at all, so the DOM silently
  fails to update — the worst failure mode available, because the code runs and nothing happens.

---

## Shared state goes through Alpine.store

State two components both read is a **store with a declared shape and named mutators**, never one
component reaching into another's internals.

```javascript
document.addEventListener("alpine:init", () => {
  Alpine.store("cart", {
    lines: [],
    isOpen: false,

    add(line) {
      this.lines.push(line);
    },
    remove(sku) {
      this.lines = this.lines.filter((line) => line.sku !== sku);
    },
  });
});

// Bad — the header component writes the drawer component's internals.
Alpine.data("cartButton", () => ({
  add: (line) => document.querySelector("#cart-drawer")._x_dataStack[0].lines.push(line),
}));

// Good — one owner, one mutator.
Alpine.data("cartButton", () => ({ add: (line) => Alpine.store("cart").add(line) }));
```

The store owns its invariants because it owns its writes. Once two components mutate the same
array, "how does a line get removed" has no answer short of reading every component on the page.

---

## Magic strings become frozen constants

There is no `enum` here, so the JavaScript form is a frozen object declared at file scope.

```javascript
const UPLOAD_STATE = Object.freeze({
  IDLE: "idle",
  UPLOADING: "uploading",
  FAILED: "failed",
});

this.state = UPLOAD_STATE.UPLOADING; // in the component — never the bare "uploading"
```

The enum test — closed set, known at design time, behaviour branches on it — is
[`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md)'s and holds unchanged here.

**The repo already has the instinct.** `code/src/django/static/js/observability.js` hoists
`ERROR_REGION_ID`, `FALLBACK_MESSAGE` and `OFFLINE_MESSAGE` to file-level constants rather than
inlining them — this rule, one step short of freezing. It is a **classic script**, so `export` is
a parse error: sharing one set across files means `type="module"` on both, which no page does yet.

**No TypeScript on this surface.** There is no bundler and no build step for the web
([`../../src/CONTEXT.md`](../../src/CONTEXT.md)), so the type discipline available is JSDoc.
**Any component state with more than three properties carries a `@typedef`:**

```javascript
/**
 * @typedef {object} UploaderState
 * @property {File|null} file
 * @property {string} state       One of UPLOAD_STATE.
 * @property {number} progress    0 to 100.
 * @property {string|null} error  Message for the alert region, or null.
 */
```

Be clear what this buys: **nothing type-checks it.** ESLint runs over
`code/src/django/static/js/*.js` (`eslint.config.mjs`) and does not verify JSDoc types. It is
documentation with a machine-readable shape — its value is the reader and the editor, not a gate.
Still required: the alternative is no declared shape at all.

---

## The HTMX exchange is two domain types

Both directions of an HTMX round-trip are typed. A fragment endpoint is the easiest place in the
stack to hand a template a dictionary and never notice.

### The response — a view-model, not an inline dict

```python
# Bad — the fragment's contract exists only inside this call.
return render(
    request,
    "comments/_row.html",
    {
        "comment": comment,
        "can_edit": comment.author_id == request.user.pk,
        "shown_at": timezone.now(),
    },
)


# Good — one context key, one declared type.
@dataclass(frozen=True)
class CommentView:
    body: str
    author_name: str
    can_edit: bool

    @classmethod
    def from_comment(cls, comment: Comment, *, viewer: User) -> "CommentView":
        return cls(
            body=comment.body,
            author_name=comment.author.display_name,
            can_edit=comment.is_editable_by(viewer),  # asks the model; never compares here
        )


view = CommentView.from_comment(comment, viewer=request.user)
return render(request, "comments/_row.html", {"view": view})
```

**The test: the template's required fields must be readable from the view-model definition.** If
answering "what does this fragment need" means grepping the template, the contract is not written
down. And the view-model is bound by the template's own rule — a template may ask a question,
never answer one, [`DOMAIN-MODELLING.md`](DOMAIN-MODELLING.md)'s and not restated here.

### The request — named fields, never an opaque blob

`hx-vals` sends explicit named fields, parsed and validated server-side into a request DTO.
Never a JSON-stringified state object, never base64, never a single `data` parameter the server
has to unpack.

```django
<button hx-get="{% url 'marketing:comments' %}"
        hx-vals='{"page": 2, "sort": "created"}'
        hx-target="#comment-list">Next</button>
```

```python
from apps.core.schemas import QuerySchema  # never `from ninja import ...` — ruff TID251


class CommentPageQuery(QuerySchema):  # or a Django Form, for a page-served POST
    page: int = 1
    sort: Literal["created", "score"] = "created"
```

A parse failure here is a **user error** in the taxonomy
([`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)) — a 4xx, not a 500 — because the input came from
outside. A view-model built wrong internally is a programmer error.

`QuerySchema` deliberately **does not** forbid unknown fields, and must not be changed to:
`ninja.parser.Parser.parse_querydict` hands Pydantic every key in the query string, so
`extra="forbid"` would return 422 for `?utm_source=…` and every other tracking parameter
(`code/src/django/apps/core/schemas.py`, module docstring). Request **bodies** are the strict
case, and use `Schema`. A genuinely opaque third-party payload passed through untouched takes the
escape hatch verbatim — `// DICT-OK: <reason> — confined to <boundary>` in JavaScript, `#` in
Python — under [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)'s three conditions.

---

## Fragment endpoints, swap targets and event names are enumerated

Swap target ids, trigger event names and `HX-*` header values are a shared vocabulary between
server and client. Define them once so a rename is a single edit — and the correction to the
shipped example falls straight out of it.

```python
# apps/<app>/htmx.py
from enum import StrEnum


class HtmxHeader(StrEnum):
    TRIGGER = "HX-Trigger"
    REDIRECT = "HX-Redirect"


class HtmxEvent(StrEnum):
    ITEM_SAVED = "itemSaved"
    CART_CHANGED = "cartChanged"


class SwapTarget(StrEnum):
    COMMENT_LIST = "comment-list"
    CART_DRAWER = "cart-drawer"


# BEFORE
response["HX-Trigger"] = "itemSaved"

# AFTER
response[HtmxHeader.TRIGGER] = HtmxEvent.ITEM_SAVED
```

Templates reach the same values through `{% json_script %}` or a small template tag beside
`apps/core/templatetags/core.py`, and the component's frozen constants mirror them:

```javascript
const HTMX_EVENT = Object.freeze({ ITEM_SAVED: "itemSaved", CART_CHANGED: "cartChanged" });

Alpine.store("toasts").listenFor(HTMX_EVENT.ITEM_SAVED);
```

**Out-of-band swaps and custom events use the same constants** — an `hx-swap-oob="true"` fragment
targets a `SwapTarget` member, a component's dispatched event names an `HTMX_EVENT` member, and
neither side ever carries an inline literal.

This is the section with the **least shipped evidence and the most leverage**. Renaming an event
today has no compiler behind it and no grep-safe home: the string sits in a Python view, an HTML
attribute and a JavaScript listener, and missing one breaks a toast no test asserts on.

---

## The fragment is a rendering of a domain object

Both sides of an HTMX exchange are domain types — a request DTO going in, a view-model coming
back — and the HTML between them is a **rendering of a domain object, never a rendering of a
dict**. When that holds, a fragment endpoint is as reviewable as a JSON endpoint: the contract is
a class either way, and only the serialisation differs. When it does not, the contract lives in a
template nobody type-checks, keyed by a dictionary nobody declared.

---

## Cross-references

- [`../RENDERING.md`](../RENDERING.md) — where an interaction runs: server, HTMX, or Alpine
- [`../rendering/TEMPLATES-AND-INTERACTIVITY.md`](../rendering/TEMPLATES-AND-INTERACTIVITY.md) —
  the surface map; its inline `x-data` example is superseded above
- [`../rendering/PITFALLS-AND-EXAMPLES.md`](../rendering/PITFALLS-AND-EXAMPLES.md) — the worked
  HTMX form; its `HX-Trigger` literals are superseded above
- [`../FRONTEND-CODING-PRINCIPLES.md`](../FRONTEND-CODING-PRINCIPLES.md) — CSP-clean markup and
  the static-file rule for per-page JavaScript
- [`../api-design/NINJA-CONVENTIONS.md`](../api-design/NINJA-CONVENTIONS.md) — the schema bases

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
