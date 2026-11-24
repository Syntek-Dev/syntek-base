"""US014 — the JSON line contract, driven through ``JSONFormatter.format`` and ``RequestIDFilter``.

Scenario IDs are ``QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md`` Section 2's (U-fmt). The settings
dicts are ``test_observability_settings.py``'s and the request paths
``test_observability_requests.py``'s. Expected values are contract literals
(``ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md``), never recomputed as the formatter would.

The rename tripwire: HP-02, HP-05, EC-08 to EC-10, EC-12 and EC-19 here, with EC-17 and EC-23 in
``test_observability_limits.py``, pin the field set, so a renamed or added key fails a test
before it breaks a published query.
"""

from __future__ import annotations

import logging
import re
import sys
import time

from django.http import HttpRequest, HttpResponse, HttpResponseBadRequest
from django.test import RequestFactory

import pytest

from apps.core.middleware import RequestIDMiddleware
from apps.core.observability import JSONFormatter, RequestIDFilter
from apps.core.tests.unit.observability_support import (
    EXC_KEYS,
    FIXED_KEYS,
    FRAME_KEYS,
    LINE_CAP,
    ExcInfo,
    exc_info_of,
    innermost_frame,
    line_bytes,
    make_record,
    parse_line,
)

pytestmark = pytest.mark.story("US014")

TIMESTAMP = re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\+00:00$")


@pytest.fixture
def minimal() -> JSONFormatter:
    return JSONFormatter(mode="minimal")


@pytest.fixture
def wide() -> JSONFormatter:
    return JSONFormatter(mode="wide")


def _raise_value_error() -> None:
    raise ValueError("user a@example.com not found")


def _value_error_info() -> ExcInfo:
    try:
        _raise_value_error()
    except ValueError as error:
        return (ValueError, error, error.__traceback__)
    pytest.fail("unreachable: the helper always raises")


class TestEveryLineIsOneJsonObject:
    """HP-01 to HP-03 — the fixed field set, in both modes where the contract says so."""

    @pytest.mark.parametrize("mode", ["minimal", "wide"])
    def test_quote_backslash_and_newline_round_trip_on_one_line(self, mode: str) -> None:
        """HP-01."""
        message = 'say "hi" \\ then\nleave'

        line = JSONFormatter(mode=mode).format(make_record(message))  # type: ignore[arg-type]

        assert parse_line(line).get("message") == message

    def test_the_key_set_is_exactly_the_fixed_five(self, minimal: JSONFormatter) -> None:
        """HP-02."""
        payload = parse_line(minimal.format(make_record("x", name="us014.named")))

        assert set(payload) == FIXED_KEYS
        assert payload["level"] == "WARNING"
        assert payload["logger"] == "us014.named"

    @pytest.mark.parametrize("tz", ["UTC", "America/New_York", "Asia/Kolkata"])
    def test_timestamp_is_utc_to_the_millisecond_whatever_tz(
        self, minimal: JSONFormatter, monkeypatch: pytest.MonkeyPatch, tz: str
    ) -> None:
        """HP-03 — 1 700 000 000.5 is 14/11/2023 22:13:20.500 UTC."""
        record = make_record("x")
        record.created = 1_700_000_000.5
        record.msecs = 500.0
        monkeypatch.setenv("TZ", tz)
        time.tzset()
        try:
            payload = parse_line(minimal.format(record))
        finally:
            monkeypatch.undo()
            time.tzset()

        assert TIMESTAMP.match(str(payload.get("timestamp"))), payload.get("timestamp")
        assert payload["timestamp"] == "2023-11-14T22:13:20.500+00:00"

    @pytest.mark.parametrize("mode", ["minimal", "wide"])
    def test_an_empty_exc_info_triple_writes_no_exc_info_key(self, mode: str) -> None:
        """EC-20 — ``logger.exception()`` outside an ``except`` block."""
        record = make_record("x", exc_info=(None, None, None))

        payload = parse_line(JSONFormatter(mode=mode).format(record))  # type: ignore[arg-type]

        assert set(payload) == FIXED_KEYS


class TestMinimalExtras:
    """HP-04, EC-12 — off dev only the allowlist survives, and dropped means absent."""

    def test_keeps_the_allowlist_and_drops_everything_else(self, minimal: JSONFormatter) -> None:
        """HP-04."""
        extra = {"duration_ms": 12, "status_code": 200, "method": "GET", "email": "a@example.com"}

        line = minimal.format(make_record("x", extra=extra))
        payload = parse_line(line)

        assert set(payload) == FIXED_KEYS | {"duration_ms", "status_code", "method"}
        assert (payload["duration_ms"], payload["status_code"], payload["method"]) == (
            12,
            200,
            "GET",
        )
        assert "a@example.com" not in line

    def test_an_unserialisable_allowlisted_value_takes_the_fallback(
        self, minimal: JSONFormatter
    ) -> None:
        """EC-12 — a tuple key defeats ``default=str``; the allowlist still runs first."""
        record = make_record("x", extra={"status_code": {(1, 2): 3}, "email": "a@example.com"})

        line = minimal.format(record)
        payload = parse_line(line)

        assert set(payload) == FIXED_KEYS | {"status_code"}
        assert isinstance(payload["status_code"], str)
        assert "(1, 2)" in payload["status_code"]
        assert "a@example.com" not in line
        assert payload["message"] == "x"

    def test_a_self_referencing_allowlisted_value_takes_the_fallback(
        self, minimal: JSONFormatter
    ) -> None:
        """EC-12 — a circular reference defeats ``json.dumps``; the value is its guarded text."""
        looped: dict[str, object] = {}  # DICT-OK: the hostile extra under test
        looped["self"] = looped

        payload = parse_line(minimal.format(make_record("x", extra={"status_code": looped})))

        assert set(payload) == FIXED_KEYS | {"status_code"}
        assert payload["status_code"] == "{'self': {...}}"
        assert payload["message"] == "x"

    @pytest.mark.parametrize("value", [float("nan"), float("inf"), float("-inf")])
    def test_a_non_finite_float_is_text_so_the_line_stays_json(
        self, minimal: JSONFormatter, value: float
    ) -> None:
        """EC-12 — ``NaN``/``Infinity`` are not JSON; LogQL's ``| json`` would mark the line."""
        payload = parse_line(minimal.format(make_record("x", extra={"duration_ms": value})))

        assert set(payload) == FIXED_KEYS | {"duration_ms"}
        assert payload["duration_ms"] == str(value)


class TestMinimalExceptionShape:
    """HP-05, EC-08 to EC-10 — type and frames, type-only links, never a message or a note."""

    def test_type_and_frames_with_no_message(self, minimal: JSONFormatter) -> None:
        """HP-05."""
        info = _value_error_info()

        line = minimal.format(make_record("failed", exc_info=info))
        exc = parse_line(line).get("exc_info")

        assert isinstance(exc, dict), line
        assert set(exc) == EXC_KEYS
        assert exc["type"] == "ValueError"
        assert exc["cause"] is None
        assert exc["context"] is None
        assert exc["frames"], "at least the raising frame"
        assert all(set(frame) == FRAME_KEYS for frame in exc["frames"])
        assert innermost_frame(info[1]) in exc["frames"]
        assert "a@example.com" not in line
        assert "not found" not in line

    def test_an_explicit_cause_with_a_note_is_a_type_only_link(
        self, minimal: JSONFormatter
    ) -> None:
        """Gherkin: ValueError raised from KeyError("a@example.com"), noted "user a@example.com"."""
        error = ValueError("user a@example.com not found")
        error.__cause__ = KeyError("a@example.com")
        error.add_note("user a@example.com")

        line = minimal.format(make_record("x", exc_info=exc_info_of(error)))
        exc = parse_line(line).get("exc_info")

        assert isinstance(exc, dict), line
        assert exc["cause"] == {"type": "KeyError", "cause": None, "context": None}
        assert "a@example.com" not in line

    def test_an_explicit_cause_is_a_type_only_link(self, minimal: JSONFormatter) -> None:
        """EC-08 — ``raise KeyError("k") from ValueError("user a@example.com")``."""
        try:
            raise KeyError("k") from ValueError("user a@example.com")
        except KeyError:
            info = sys.exc_info()

        line = minimal.format(make_record("x", exc_info=info))
        exc = parse_line(line).get("exc_info")

        assert isinstance(exc, dict), line
        assert exc["type"] == "KeyError"
        assert exc["cause"] == {"type": "ValueError", "cause": None, "context": None}
        assert "a@example.com" not in line

    def test_never_delegates_to_the_stdlib_formatter(
        self, minimal: JSONFormatter, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """Threat-model constraint 4 — neither ``Formatter.format`` nor ``formatException``."""
        calls: list[str] = []

        def record_call(name: str) -> object:
            def called(*args: object, **kwargs: object) -> str:
                calls.append(name)
                return "delegated"

            return called

        monkeypatch.setattr(logging.Formatter, "format", record_call("format"))
        monkeypatch.setattr(logging.Formatter, "formatException", record_call("formatException"))

        exc = parse_line(minimal.format(make_record("x", exc_info=_value_error_info())))

        assert calls == []
        assert exc["exc_info"]["type"] == "ValueError"

    def test_an_implicit_context_is_a_type_only_link(self, minimal: JSONFormatter) -> None:
        """EC-08, the ``__context__`` half."""
        try:
            try:
                raise ValueError("user a@example.com")
            except ValueError:
                raise KeyError("k")  # noqa: B904 — the implicit context is the case under test
        except KeyError:
            info = sys.exc_info()

        line = minimal.format(make_record("x", exc_info=info))
        exc = parse_line(line).get("exc_info")

        assert isinstance(exc, dict), line
        assert exc["cause"] is None
        assert exc["context"] == {"type": "ValueError", "cause": None, "context": None}
        assert "a@example.com" not in line

    def test_a_note_is_dropped(self, minimal: JSONFormatter) -> None:
        """EC-09."""
        error = RuntimeError("boom")
        error.add_note("token=abc123")

        line = minimal.format(make_record("x", exc_info=exc_info_of(error)))

        assert parse_line(line).get("exc_info", {}).get("type") == "RuntimeError"
        assert "abc123" not in line

    def test_a_group_lists_member_types_only(self, minimal: JSONFormatter) -> None:
        """EC-10."""
        group = ExceptionGroup("grp-secret-7f3", [ValueError("a@example.com")])

        line = minimal.format(make_record("x", exc_info=exc_info_of(group)))
        exc = parse_line(line).get("exc_info")

        assert isinstance(exc, dict), line
        assert exc["type"] == "ExceptionGroup"
        assert exc["members"] == ["ValueError"]
        assert "grp-secret-7f3" not in line
        assert "a@example.com" not in line

    def test_stack_info_and_a_cached_exc_text_never_reach_the_line(
        self, minimal: JSONFormatter
    ) -> None:
        """AC — no ``record.stack_info``, no cached ``record.exc_text``, no source text."""
        record = make_record(
            "x",
            exc_info=exc_info_of(RuntimeError("boom")),
            sinfo="Stack (most recent call last):\n  secret-stack-marker",
        )
        record.exc_text = "cached-secret-text"

        line = minimal.format(record)
        payload = parse_line(line)

        assert "stack_info" not in payload
        assert "secret-stack-marker" not in line
        assert "cached-secret-text" not in line
        assert "raise exc" not in line, "no source-line text in a frame"

    def test_a_context_cycle_terminates_with_each_exception_once(
        self, minimal: JSONFormatter
    ) -> None:
        """EC-18."""

        class CycleOneError(Exception):
            pass

        class CycleTwoError(Exception):
            pass

        info = exc_info_of(CycleOneError())
        two = CycleTwoError()
        info[1].__context__ = two
        two.__context__ = info[1]

        exc = parse_line(minimal.format(make_record("x", exc_info=info))).get("exc_info")

        assert isinstance(exc, dict)
        seen = [exc["type"]]
        link = exc.get("context")
        while isinstance(link, dict):
            seen.append(link["type"])
            link = link.get("context")
        assert seen == ["CycleOneError", "CycleTwoError"]
        # The back-edge exists, so it is omitted rather than written ``null`` ("no context").
        back = exc["context"]
        assert "context" not in back
        assert back["cause"] is None
        assert "truncated" not in parse_line(minimal.format(make_record("x", exc_info=info)))

    def test_a_2000_link_cause_chain_is_walked_without_recursion_and_capped(
        self, minimal: JSONFormatter
    ) -> None:
        """EC-19 — about 100 KB uncapped; a cut link is omitted, never written ``null``."""
        error: BaseException = ValueError("root")
        for depth in range(2000):
            outer = KeyError(depth)
            outer.__cause__ = error
            error = outer
        info = exc_info_of(error)

        line = minimal.format(make_record("x", exc_info=info))
        payload = parse_line(line)

        assert line_bytes(line) <= LINE_CAP
        assert payload.get("truncated") is True
        assert payload["exc_info"]["type"] == "KeyError"
        assert innermost_frame(info[1]) in payload["exc_info"]["frames"]
        link = payload["exc_info"]
        while isinstance(link.get("cause"), dict):
            link = link["cause"]
        assert "cause" not in link, "the cut link must be omitted, not claim 'no cause'"


class TestWideMode:
    """HP-06, EC-02, EC-03, EC-12 — dev serialises everything, and the fixed keys win."""

    def test_no_reserved_attribute_leaks_into_an_empty_record(self, wide: JSONFormatter) -> None:
        """HP-06 — no ``taskName``, ``args``, ``msg`` or ``created``."""
        assert set(parse_line(wide.format(make_record("x")))) == FIXED_KEYS

    def test_every_extra_is_kept(self, wide: JSONFormatter) -> None:
        """HP-06 against HP-04's record."""
        extra = {"duration_ms": 12, "status_code": 200, "method": "GET", "email": "a@example.com"}

        payload = parse_line(wide.format(make_record("x", extra=extra)))

        assert {key: payload.get(key) for key in extra} == extra

    def test_exc_info_is_the_full_traceback_with_its_message(self, wide: JSONFormatter) -> None:
        """HP-06 against HP-05's record."""
        info = _value_error_info()

        exc = parse_line(wide.format(make_record("x", exc_info=info))).get("exc_info")

        assert isinstance(exc, str)
        assert "Traceback (most recent call last)" in exc
        assert "ValueError: user a@example.com not found" in exc

    def test_a_colliding_extra_never_replaces_a_fixed_key(self, wide: JSONFormatter) -> None:
        """EC-02."""
        record = make_record(
            "real", name="us014.real", extra={"level": "x", "logger": "y", "timestamp": "z"}
        )

        payload = parse_line(wide.format(record))

        assert payload.get("level") == "WARNING"
        assert payload.get("logger") == "us014.real"
        assert TIMESTAMP.match(str(payload.get("timestamp")))
        assert list(payload)[-5:] == ["timestamp", "level", "logger", "message", "request_id"]

    def test_an_unserialisable_extra_is_its_str(
        self, wide: JSONFormatter, rf: RequestFactory
    ) -> None:
        """EC-03 — the request's repr, query string included."""
        request = rf.get("/probe/?q=1")
        marker = object()

        record = make_record("x", extra={"obj": marker, "request": request})
        payload = parse_line(wide.format(record))

        assert payload.get("obj") == str(marker)
        assert payload.get("request") == "<WSGIRequest: GET '/probe/?q=1'>"

    def test_a_tuple_keyed_extra_takes_the_fallback_and_keeps_every_extra(
        self, wide: JSONFormatter
    ) -> None:
        """EC-12, wide half."""
        payload = parse_line(wide.format(make_record("x", extra={"data": {(1, 2): 3}, "n": 1})))

        assert set(payload) == FIXED_KEYS | {"data", "n"}
        assert isinstance(payload["data"], str)
        assert "(1, 2)" in payload["data"]
        assert payload["n"] == 1

    def test_a_self_referencing_extra_takes_the_fallback_and_keeps_every_extra(
        self, wide: JSONFormatter
    ) -> None:
        """EC-12, wide half — the circular value is its text; its neighbours are untouched."""
        looped: dict[str, object] = {}  # DICT-OK: the hostile extra under test
        looped["self"] = looped

        payload = parse_line(wide.format(make_record("x", extra={"data": looped, "n": 1})))

        assert set(payload) == FIXED_KEYS | {"data", "n"}
        assert payload["data"] == "{'self': {...}}"
        assert payload["n"] == 1

    @pytest.mark.parametrize("value", [float("nan"), float("inf")])
    def test_a_non_finite_float_is_text_so_the_line_stays_json(
        self, wide: JSONFormatter, value: float
    ) -> None:
        """EC-12, wide half — nested too, since the fallback coerces the extra as a whole."""
        extra = {"ratio": value, "nested": {"v": value}, "n": 1}

        payload = parse_line(wide.format(make_record("x", extra=extra)))

        assert payload["ratio"] == str(value)
        assert isinstance(payload["nested"], str)
        assert payload["n"] == 1


class TestTheCap:
    """EC-13, EC-23 — line plus newline ≤ 16 384 bytes, measured on the escaped output."""

    def test_a_lone_surrogate_is_escaped_and_not_cut(self, minimal: JSONFormatter) -> None:
        """EC-13."""
        line = minimal.format(make_record("\ud800"))
        payload = parse_line(line)

        assert line.isascii()
        assert payload.get("message") == "\ud800"
        assert "truncated" not in payload

    def test_a_line_just_under_the_cap_is_not_cut(self, minimal: JSONFormatter) -> None:
        """EC-23, last record — the cap must not fire early."""
        overhead = line_bytes(minimal.format(make_record("a"))) - 1
        message = "a" * max(LINE_CAP - overhead - 32, 1)

        line = minimal.format(make_record(message))
        payload = parse_line(line)

        assert line_bytes(line) <= LINE_CAP
        assert "truncated" not in payload
        assert payload.get("message") == message


class TestTheFilter:
    """ES-01, ES-02, EC-01, EC-04, EC-07, EC-15 and the returned-error fallback."""

    def test_outside_a_request_request_id_is_present_and_null(self, minimal: JSONFormatter) -> None:
        """ES-01."""
        record = make_record("x")

        kept = RequestIDFilter().filter(record)
        payload = parse_line(minimal.format(record))

        assert kept is True
        assert "request_id" in payload
        assert payload["request_id"] is None

    @pytest.mark.parametrize(
        "level", [logging.DEBUG, logging.INFO, logging.ERROR, logging.CRITICAL]
    )
    @pytest.mark.parametrize("name", ["django.request", "root", "us014.any"])
    def test_never_drops_a_record_and_maps_empty_to_none(self, level: int, name: str) -> None:
        """ES-02 — ``current_request_id()`` is ``""`` outside a request."""
        record = make_record("x", level=level, name=name)

        assert RequestIDFilter().filter(record) is True
        assert getattr(record, "request_id", "missing") is None

    def test_the_formatter_alone_still_writes_request_id(self, minimal: JSONFormatter) -> None:
        """EC-04 — a handler built without the filter."""
        payload = parse_line(minimal.format(make_record("x")))

        assert "request_id" in payload
        assert payload["request_id"] is None

    def test_a_forged_request_id_is_overwritten(
        self, minimal: JSONFormatter, rf: RequestFactory
    ) -> None:
        """EC-01 — inside a request the middleware's value; outside, null."""
        lines: list[str] = []

        def view(request: HttpRequest) -> HttpResponse:
            record = make_record("x", extra={"request_id": "forged"})
            RequestIDFilter().filter(record)
            lines.append(minimal.format(record))
            return HttpResponse("ok")

        response = RequestIDMiddleware(view)(rf.get("/", HTTP_X_REQUEST_ID="real-id"))
        outside = make_record("x", extra={"request_id": "forged"})
        RequestIDFilter().filter(outside)

        assert parse_line(lines[0]).get("request_id") == response["X-Request-ID"] == "real-id"
        assert parse_line(minimal.format(outside)).get("request_id", "missing") is None

    def test_a_record_after_the_request_has_finished_is_null(self, rf: RequestFactory) -> None:
        """EC-07 — the middleware's reset holds; nothing leaks onto the next unit of work."""
        RequestIDMiddleware(lambda request: HttpResponse("ok"))(
            rf.get("/", HTTP_X_REQUEST_ID="leaky")
        )
        record = make_record("x")

        assert RequestIDFilter().filter(record) is True
        assert getattr(record, "request_id", "missing") is None

    def test_a_returned_error_record_takes_the_id_stored_on_the_request(
        self, rf: RequestFactory
    ) -> None:
        """Backend AC — logged after the middleware's ``finally``, so only the stored id is left."""
        served: list[HttpRequest] = []

        def view(request: HttpRequest) -> HttpResponse:
            served.append(request)
            return HttpResponseBadRequest("no")

        response = RequestIDMiddleware(view)(rf.get("/x/", HTTP_X_REQUEST_ID="bad id!"))
        record = make_record(
            "Bad Request: %s",
            args=("/x/",),
            name="django.request",
            extra={"request": served[0], "status_code": 400},
        )

        assert RequestIDFilter().filter(record) is True
        assert getattr(record, "request_id", None) == response["X-Request-ID"]
        assert record.request_id != "bad id!"  # type: ignore[attr-defined]

    @pytest.mark.parametrize("name", ["django.security.DisallowedHost", "django.request"])
    def test_a_request_extra_with_no_stored_id_is_null(
        self, minimal: JSONFormatter, name: str
    ) -> None:
        """EC-15 — the DisallowedHost shape, raised before ``RequestIDMiddleware`` runs."""
        record = make_record(
            "Invalid HTTP_HOST header", name=name, extra={"request": HttpRequest()}
        )

        assert RequestIDFilter().filter(record) is True
        payload = parse_line(minimal.format(record))
        assert "request_id" in payload
        assert payload["request_id"] is None
