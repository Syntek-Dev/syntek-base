# apps/core/templatetags — Template Tags

One module, holding one tag. It exists because Django renders an error page with an **empty
context**, so the correlation identifier the error taxonomy requires on screen cannot arrive
through a context processor — and a tag is the only mechanism that reaches every rendering
path without one.

**Last Updated**: <%DATE%>

## Directory Tree

```text
apps/core/templatetags/
├── __init__.py   ← package marker
├── core.py       ← {% request_id %}
├── CONTEXT.md    ← this file
└── CLAUDE.md     ← operating rules
```

## What `core.py` decides

| Rendering path        | Has a request context? | `{% request_id %}` returns |
| --------------------- | ---------------------- | -------------------------- |
| An ordinary view      | yes                    | the identifier             |
| `500.html`            | **no**                 | the identifier             |
| An HTMX error partial | yes                    | the identifier             |
| Outside a request     | n/a                    | an empty string            |

The middle row is the whole reason the module exists. A context processor covers the first
and third and **cannot** cover the second, which is the one that matters most — a user only
quotes an identifier from a page that has already broken.

The last row is a real answer, not a gap: a task, a management command, and an exception
raised above `RequestIDMiddleware` in the stack all render without one, and showing nothing
is better than showing a stale value that resolves to the wrong tracker event.

## Cross-references

- `code/docs/NEGATIVE-SPACE.md` § The error taxonomy — why an identifier must reach the user
- `code/docs/rendering/PITFALLS-AND-EXAMPLES.md` § An error the user never sees — the empty
  `Context` finding, and the corrected HTMX handler beside it
- `code/src/django/apps/core/middleware.py` — where the identifier is minted and stored
