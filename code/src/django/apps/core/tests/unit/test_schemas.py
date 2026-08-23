"""The three Ninja bases, and the ``extra`` policy that differs across them on purpose.

Each test here corresponds to a failure that has a cost in production, not to a line of
code: a silently discarded request field, a response contract that cannot gain a field, and
a 422 on ``?utm_source=…``.
"""

from __future__ import annotations

import pytest
from pydantic import ValidationError

from apps.core.schemas import OutSchema, QuerySchema, Schema

pytestmark = pytest.mark.unit


class TestRequestSchema:
    """``extra="forbid"``. Ninja's own default silently discards, which hides typos forever."""

    def test_rejects_an_unknown_field(self) -> None:
        class Body(Schema):
            name: str

        with pytest.raises(ValidationError):
            Body(name="Sam", nmae="Sam")  # type: ignore[call-arg]

    def test_accepts_the_declared_fields(self) -> None:
        class Body(Schema):
            name: str

        assert Body(name="Sam").name == "Sam"

    def test_forbid_is_the_configured_policy(self) -> None:
        assert Schema.model_config.get("extra") == "forbid"


class TestOutSchema:
    """Permissive, so adding a response field later is not a contract break for a strict client."""

    def test_does_not_forbid_extras(self) -> None:
        assert OutSchema.model_config.get("extra") != "forbid"

    def test_publishes_no_additional_properties_false(self) -> None:
        class Out(OutSchema):
            name: str

        assert Out.model_json_schema().get("additionalProperties") is not False


class TestQuerySchema:
    """Must never forbid extras: Ninja hands Pydantic every key in the query string."""

    def test_does_not_forbid_extras(self) -> None:
        assert QuerySchema.model_config.get("extra") != "forbid"

    def test_tolerates_a_tracking_parameter(self) -> None:
        """The regression this policy exists for — a 422 on ``?utm_source=newsletter``."""

        class Filters(QuerySchema):
            page: int = 1

        assert Filters(page=2, utm_source="newsletter").page == 2  # type: ignore[call-arg]
