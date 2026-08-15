"""The correlation identifier, readable from a template that has no context at all.

Django renders ``500.html`` with an **empty** ``Context`` and no request — its own
documentation states that the default 500 view "passes no variables to the ``500.html``
template and is rendered with an empty ``Context`` to lessen the chance of additional
errors". So no context processor reaches an error page, and the requirement that a user can
read back an identifier when reporting a failure cannot be satisfied by one.

A simple tag can, because it takes its value from the ``ContextVar`` in
``apps.core.middleware`` rather than from the context it is rendered with. That makes this
the single reader for every rendering path: the 500 page, an HTMX error partial, and any
ordinary view.
"""

from __future__ import annotations

from django import template

from apps.core.middleware import current_request_id

register = template.Library()


@register.simple_tag
def request_id() -> str:
    """The identifier for the request being served, or an empty string outside one.

    Empty is a real answer rather than a failure: a management command, a task, and an
    exception raised *above* ``RequestIDMiddleware`` in the stack all render without one.
    A template showing nothing is correct there — a stale identifier from an unrelated
    request would be worse than none, because it resolves to the wrong tracker event.

    Autoescaping is not relied on for safety: the middleware bounds an inbound value to
    ``[A-Za-z0-9._-]`` and 200 characters before it ever reaches here.
    """
    return current_request_id()
