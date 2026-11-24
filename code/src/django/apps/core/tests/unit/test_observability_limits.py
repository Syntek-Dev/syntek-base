"""US014 — the 16 KiB cap and the formatter that never raises, through a stdout handler.

Scenario IDs are ``QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md`` Section 2's: EC-13, EC-17 and
EC-23. Expected values are contract literals (``ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md``).

The handler here is built by hand — a ``StreamHandler`` on ``sys.stdout`` resolved **after**
``capsys`` has patched it, the minimal formatter and the filter, on an unregistered ``Logger``.
P3 rewrites the settings modules; until then no environment's dict names these classes, so the
U-capsys rows that build staging's own console entry land with P3 and read the same records.
"""

from __future__ import annotations

import logging
import sys
import time
from collections.abc import Callable
from datetime import datetime

import pytest

from apps.core.observability import JSONFormatter, RequestIDFilter, _emergency_line
from apps.core.tests.unit.observability_support import (
    CAPPED_RECORDS,
    FIXED_KEYS,
    LINE_CAP,
    Hostile,
    RaisingStr,
    capped_record,
    exc_info_of,
    innermost_frame,
    line_bytes,
    make_record,
    parse_line,
)

pytestmark = pytest.mark.story("US014")


def _stdout_handler() -> logging.Handler:
    """Minimal formatter and filter on whatever ``sys.stdout`` is now — ``capsys``'s, in a test."""
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(JSONFormatter(mode="minimal"))
    handler.addFilter(RequestIDFilter())
    return handler


def _stdout_logger() -> logging.Logger:
    """An unregistered ``Logger``, so nothing enters the logging registry."""
    logger = logging.Logger("us014")
    logger.addHandler(_stdout_handler())
    return logger


class TestTheFormatterNeverRaises:
    """EC-17 — one parseable line on stdout, nothing on stderr, ``handleError`` never reached."""

    @pytest.mark.parametrize(
        ("emit", "kept"),
        [
            pytest.param(lambda lg: lg.warning("%s %s", 1), set(), id="a-bad-percent-args"),
            pytest.param(
                lambda lg: lg.warning("x", extra={"status_code": RaisingStr()}),
                {"status_code"},
                id="b-extra-str-raises",
            ),
            pytest.param(lambda lg: lg.exception("x"), set(), id="c-exception-outside-except"),
            pytest.param(
                lambda lg: lg.warning("x", extra={"status_code": Hostile()}),
                {"status_code"},
                id="d-str-repr-and-type-name-raise",
            ),
            pytest.param(lambda lg: lg.warning(RaisingStr(), 1), set(), id="e-msg-str-raises"),
        ],
    )
    def test_one_line_with_the_ruled_key_set(
        self,
        capsys: pytest.CaptureFixture[str],
        emit: Callable[[logging.Logger], None],
        kept: set[str],
    ) -> None:
        """The fixed five plus the kept extras — no ``format_error`` or other marker key."""
        emit(_stdout_logger())

        out = capsys.readouterr()
        lines = out.out.splitlines()

        assert out.err == "", "Handler.handleError was reached"
        assert len(lines) == 1, out
        payload = parse_line(lines[0])
        assert set(payload) == FIXED_KEYS | kept
        assert isinstance(payload["message"], str)
        for key in kept:
            assert isinstance(payload[key], str)

    def test_bad_percent_args_log_the_bare_msg(self, capsys: pytest.CaptureFixture[str]) -> None:
        """EC-17 (a) — ``str(record.msg)`` without its arguments."""
        _stdout_logger().warning("%s %s", 1)

        assert parse_line(capsys.readouterr().out.strip())["message"] == "%s %s"

    def test_a_value_nothing_can_print_names_at_most_its_type(
        self, capsys: pytest.CaptureFixture[str]
    ) -> None:
        """EC-17 (d) — still written when even naming the type raises."""
        _stdout_logger().warning("x", extra={"status_code": Hostile()})

        value = parse_line(capsys.readouterr().out.strip())["status_code"]
        assert value == "<unprintable value>"

    def test_an_extra_whose_str_raises_is_its_guarded_repr(
        self, capsys: pytest.CaptureFixture[str]
    ) -> None:
        """EC-17 (b) — coerced in place through the guard's ``repr`` step, still allowlisted."""
        _stdout_logger().warning("x", extra={"status_code": RaisingStr(), "email": "a@x.test"})

        line = capsys.readouterr().out.strip()
        value = parse_line(line)["status_code"]
        assert value.startswith("<apps.core.tests.unit.observability_support.RaisingStr object")
        assert "a@x.test" not in line

    def test_a_msg_nothing_can_print_still_yields_a_message(
        self, capsys: pytest.CaptureFixture[str]
    ) -> None:
        """EC-17 (e) — the guard's fixed text, naming the type only."""
        _stdout_logger().warning(RaisingStr(), 1)

        assert parse_line(capsys.readouterr().out.strip())["message"] == "<unprintable RaisingStr>"

    def test_a_record_that_defeats_even_the_fallback_writes_the_last_resort(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """The constant line: still one JSON object of the fixed keys."""
        formatter = JSONFormatter(mode="minimal")

        def explode(record: logging.LogRecord) -> str:
            raise RuntimeError("both paths failed")

        monkeypatch.setattr(formatter, "_format", explode)
        monkeypatch.setattr(formatter, "_format_fallback", explode)

        record = make_record("x", level=logging.WARNING, name="us014.lost")
        record.request_id = "abc-123"
        before = time.time()
        payload = parse_line(formatter.format(record))

        assert set(payload) == FIXED_KEYS
        assert payload["message"] == "log record could not be formatted"
        # The record's own level, logger and id, and the time it was written — never 1970, which
        # a collector reading ``timestamp`` would reject as too old and lose the one warning line.
        assert (payload["level"], payload["logger"], payload["request_id"]) == (
            "WARNING",
            "us014.lost",
            "abc-123",
        )
        written = datetime.fromisoformat(payload["timestamp"]).timestamp()
        assert before - 1 <= written <= time.time() + 1

    def test_the_last_resort_falls_back_to_constants_for_unreadable_fields(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """A record whose level, name and id are not text still yields the fixed five."""
        formatter = JSONFormatter(mode="minimal")

        def explode(record: logging.LogRecord) -> str:
            raise RuntimeError("both paths failed")

        monkeypatch.setattr(formatter, "_format", explode)
        monkeypatch.setattr(formatter, "_format_fallback", explode)
        record = make_record("x")
        record.levelname = Hostile()  # type: ignore[assignment]
        record.name = Hostile()  # type: ignore[assignment]
        record.request_id = Hostile()

        payload = parse_line(formatter.format(record))
        assert set(payload) == FIXED_KEYS
        assert (payload["level"], payload["logger"], payload["request_id"]) == (
            "ERROR",
            "apps.core.observability",
            None,
        )

    @pytest.mark.parametrize("mode", ["minimal", "wide"])
    @pytest.mark.parametrize(
        "exc_info", [True, ValueError("bare"), (ValueError,)], ids=["true", "instance", "1-tuple"]
    )
    def test_a_malformed_exc_info_is_no_exception_not_a_lost_line(
        self, mode: str, exc_info: object
    ) -> None:
        """A hand-built record's ``exc_info`` that is not a triple — ``Logger._log`` never makes
        one, ``makeLogRecord`` can. The line keeps its message rather than the last resort."""
        # DICT-OK: makeLogRecord's own argument shape — confined to this test
        record = logging.makeLogRecord(
            {"msg": "kept", "levelname": "WARNING", "exc_info": exc_info}
        )

        payload = parse_line(JSONFormatter(mode=mode).format(record))  # type: ignore[arg-type]

        assert payload["message"] == "kept"
        assert payload["level"] == "WARNING"
        assert "exc_info" not in payload

    def test_an_unknown_mode_is_a_configuration_error(self) -> None:
        """Raised at construction — dictConfig fails at boot, never on a request."""
        with pytest.raises(ValueError, match="minimal"):
            JSONFormatter(mode="verbose")  # type: ignore[arg-type]


class TestTheCap:
    """EC-13, EC-23 — line plus newline ≤ 16 384 bytes, measured on the escaped output."""

    @pytest.mark.parametrize("record_id", CAPPED_RECORDS)
    def test_each_oversized_record_is_capped_and_marked(self, record_id: str) -> None:
        """EC-23 — non-ASCII input expands into the escaped output, so the cap counts that."""
        record, error = capped_record(record_id)

        line = JSONFormatter(mode="minimal").format(record)
        payload = parse_line(line)

        assert line.isascii()
        assert line_bytes(line) <= LINE_CAP, line_bytes(line)
        assert FIXED_KEYS <= set(payload)
        assert payload.get("truncated") is True
        if error is not None:
            assert payload["exc_info"]["type"] == type(error).__name__
            assert innermost_frame(error) in payload["exc_info"]["frames"]
        if record_id.startswith("fallback"):
            assert set(payload) == FIXED_KEYS | {"status_code", "truncated"}
            assert isinstance(payload["status_code"], str)

    def test_a_64_kib_message_is_cut_and_keeps_its_start(self) -> None:
        """EC-13 — the message is cut, never replaced."""
        line = JSONFormatter(mode="minimal").format(make_record("b" + "a" * 65_535))
        payload = parse_line(line)

        assert payload.get("truncated") is True
        assert str(payload["message"]).startswith("baaa")

    def test_a_line_at_the_cap_is_uncut_and_one_byte_over_is_cut(self) -> None:
        """The boundary is newline-inclusive: 16 383 bytes plus ``\\n`` travels whole."""
        formatter = JSONFormatter(mode="minimal")
        overhead = line_bytes(formatter.format(make_record(""))) - 1

        at_cap = formatter.format(make_record("a" * (LINE_CAP - 1 - overhead)))
        over = formatter.format(make_record("a" * (LINE_CAP - overhead)))

        assert line_bytes(at_cap) == LINE_CAP
        assert "truncated" not in parse_line(at_cap)
        assert parse_line(over).get("truncated") is True
        assert line_bytes(over) <= LINE_CAP

    def test_wide_mode_is_never_capped(self) -> None:
        """Dev's file never leaves the host; the cap is staging's and production's."""
        line = JSONFormatter(mode="wide").format(make_record("a" * 65_536))
        payload = parse_line(line)

        assert "truncated" not in payload
        assert len(str(payload["message"])) == 65_536

    def test_a_pathological_logger_name_still_fits(self) -> None:
        """Every cuttable field gone and still over: the bounded last-resort shape."""
        record = make_record("x", name="n" * 40_000, exc_info=exc_info_of(ValueError("v")))

        line = JSONFormatter(mode="minimal").format(record)
        payload = parse_line(line)

        assert line_bytes(line) <= LINE_CAP
        assert payload.get("truncated") is True
        assert FIXED_KEYS <= set(payload)
        assert payload["exc_info"]["type"] == "ValueError"
        assert len(payload["exc_info"]["frames"]) == 1

    def test_the_last_resort_frame_keeps_the_end_of_a_long_filename(self) -> None:
        """The innermost frame survives the cut — and a path's meaning is at its end."""
        filename = "/deep" * 60 + "/views.py"
        cut = {  # DICT-OK: a parsed minimal line, the shape _emergency_line reads — confined here
            "timestamp": "t",
            "level": "ERROR",
            "logger": "n" * 40_000,
            "message": "",
            "request_id": None,
            "exc_info": {
                "type": "ValueError",
                "frames": [{"filename": filename, "lineno": 7, "function": "view"}],
            },
        }

        payload = parse_line(_emergency_line(cut))

        frame = payload["exc_info"]["frames"][0]
        assert frame["filename"].endswith("/deep/views.py")
        assert (frame["lineno"], frame["function"]) == (7, "view")
        assert line_bytes(_emergency_line(cut)) <= LINE_CAP

    def test_the_last_resort_shape_keeps_a_full_length_request_id(self) -> None:
        """The join survives the cut: an inbound id may be 200 characters (``middleware.py``)."""
        request_id = "r" * 200
        record = make_record("x", name="n" * 40_000)
        record.request_id = request_id  # what the filter writes inside a request

        payload = parse_line(JSONFormatter(mode="minimal").format(record))

        assert payload.get("truncated") is True
        assert payload["request_id"] == request_id

    @pytest.mark.parametrize("record_id", [*CAPPED_RECORDS, "lone-surrogate"])
    def test_each_record_reaches_stdout_as_one_line(
        self, capsys: pytest.CaptureFixture[str], record_id: str
    ) -> None:
        """EC-13 and EC-23 through the handler — ``.out`` one line, ``.err`` empty."""
        record, _ = capped_record(record_id)

        _stdout_handler().handle(record)
        out = capsys.readouterr()

        assert out.err == ""
        assert len(out.out.splitlines()) == 1
        parse_line(out.out.splitlines()[0])
