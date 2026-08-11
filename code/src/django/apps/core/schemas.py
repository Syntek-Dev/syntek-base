"""The project's Ninja schema bases — import from here, never from ``ninja`` directly.

Three bases, one per API surface, because ``extra="forbid"`` is correct on exactly one of
them:

* ``Schema`` — **request bodies**. Rejects unknown fields. Django Ninja's documented
  default is to *silently ignore* them, so without this every endpoint accepts arbitrary
  keys and discards them without a trace.
* ``OutSchema`` — **responses**. Deliberately permissive: forbidding extras changes
  nothing at runtime (a response is validated from attributes, not from a payload) while
  publishing ``additionalProperties: false``, which makes adding a field later a contract
  break for a strict client.
* ``QuerySchema`` — **query-parameter containers** behind ``Query(...)``. Permissive, and
  it must stay that way. ``ninja.parser.Parser.parse_querydict`` iterates ``request.GET``
  and hands Pydantic *every* key in the query string, so forbidding extras here returns
  422 for ``?utm_source=…``, ``?gclid=…`` and every other tracking parameter.

``from ninja import Schema`` is banned project-wide (ruff ``TID251``); this module is the
one exemption. A response schema derived from a model still uses ``ninja.ModelSchema`` —
a request body never does, because the API is a contract, not a mirror of the ORM.

See ``code/docs/api-design/NINJA-CONVENTIONS.md`` § Schema strictness and
``code/docs/NEGATIVE-SPACE.md``.
"""

from __future__ import annotations

from ninja import Schema as _NinjaSchema
from pydantic import ConfigDict

__all__ = ["OutSchema", "QuerySchema", "Schema"]


class Schema(_NinjaSchema):
    """Base for request-body schemas. An unknown field is a 422, never a silent discard."""

    model_config = ConfigDict(extra="forbid")


class OutSchema(_NinjaSchema):
    """Base for response schemas. Permissive on purpose — see the module docstring."""


class QuerySchema(_NinjaSchema):
    """Base for ``Query(...)`` containers. Never forbid extras here — see the module docstring."""
