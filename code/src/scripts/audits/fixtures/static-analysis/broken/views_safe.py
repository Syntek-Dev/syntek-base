"""Fixture views for static-analysis.sh --self-test. Never imported, never routed.

Trips three rules from django-safe-filter.yml and django-template-xss.yml:
`django-mark-safe-non-constant`, `django-mark-safe-interpolated-string`, and
`django-autoescape-disabled-in-python`.
"""

from __future__ import annotations

from django.template import Context, Engine
from django.utils.safestring import mark_safe


def render_bio(bio: str) -> str:
    """django-mark-safe-non-constant: the argument is not a literal."""
    return mark_safe(bio)


def render_greeting(name: str) -> str:
    """django-mark-safe-interpolated-string: the interpolated part is the payload."""
    return mark_safe(f"<p>Hello, {name}</p>")


def render_fragment(template_source: str, bio: str) -> str:
    """django-autoescape-disabled-in-python: escaping switched off from the Python side."""
    engine = Engine(autoescape=False)
    template = engine.from_string(template_source)
    return template.render(Context({"bio": bio}, autoescape=False))
