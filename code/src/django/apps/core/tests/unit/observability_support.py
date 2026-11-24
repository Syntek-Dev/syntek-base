"""Shared fixtures-as-functions for the three US014 observability test modules.

Not collected (no ``test_`` prefix). Every expected value the tests compare against is a
literal from the line contract — ``ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md`` — never
recomputed the way the formatter computes it.
"""

from __future__ import annotations

import copy
import io
import json
import logging
import logging.config
import sys
import traceback
from pathlib import Path
from types import TracebackType
from typing import Any

import pytest

from apps.core.observability import JSONFormatter, RequestIDFilter

# The line contract's fixed keys and the off-dev allowlist (ADR-US014, the line contract table).
FIXED_KEYS = frozenset({"timestamp", "level", "logger", "message", "request_id"})
ALLOWLIST = frozenset({"duration_ms", "status_code", "method"})
EXC_KEYS = frozenset({"type", "frames", "cause", "context"})
FRAME_KEYS = frozenset({"filename", "lineno", "function"})
LINK_KEYS = frozenset({"type", "cause", "context"})

# Docker's json-file driver splits a line over 16 KiB; the cap counts the line plus its newline.
LINE_CAP = 16_384

ExcInfo = tuple[type[BaseException], BaseException, TracebackType | None]


def make_record(
    msg: object = "hello",
    *,
    args: tuple[object, ...] = (),
    level: int = logging.WARNING,
    name: str = "us014.test",
    exc_info: ExcInfo | tuple[None, None, None] | None = None,
    extra: dict[str, object] | None = None,  # DICT-OK: logging's own extra= contract
    sinfo: str | None = None,
) -> logging.LogRecord:
    """A record built the way ``Logger._log`` builds one, without a registered logger."""
    return logging.Logger(name).makeRecord(
        name, level, __file__, 1, msg, args, exc_info, func="t", extra=extra, sinfo=sinfo
    )


def exc_info_of(exc: BaseException) -> ExcInfo:
    """Raise ``exc`` so it carries a traceback, and return the triple a handler would see."""
    try:
        raise exc
    except BaseException:  # every kind is under test
        info = sys.exc_info()
    assert info[0] is not None and info[1] is not None
    return (info[0], info[1], info[2])


def innermost_frame(exc: BaseException) -> dict[str, object]:
    """The innermost frame as the contract writes it, read off the stdlib, not the formatter."""
    frame = traceback.extract_tb(exc.__traceback__)[-1]
    return {"filename": frame.filename, "lineno": frame.lineno, "function": frame.name}


def _reject_constant(name: str) -> object:
    """``NaN`` and ``Infinity`` are not JSON: Python's parser accepts them, LogQL's does not."""
    raise ValueError(f"non-standard JSON constant {name}")


def parse_line(line: str) -> dict[str, Any]:  # DICT-OK: a parsed JSON payload under test
    """One physical line holding one strict JSON object — or a test failure saying which not."""
    assert "\n" not in line, f"a formatted record must be one physical line: {line[:120]!r}"
    try:
        payload = json.loads(line, parse_constant=_reject_constant)
    except ValueError:
        pytest.fail(f"the line is not JSON: {line[:200]!r}")
    assert isinstance(payload, dict), f"the line is JSON but not an object: {line[:200]!r}"
    return payload


def line_bytes(line: str) -> int:
    """Bytes Docker reads for the line: the line plus its newline (ASCII under ensure_ascii)."""
    return len((line + "\n").encode())


def capturing_handler(mode: str = "minimal") -> tuple[logging.Handler, io.StringIO]:
    """A ``StringIO`` handler with the filter and formatter — ``caplog`` runs no handler filter."""
    stream = io.StringIO()
    handler = logging.StreamHandler(stream)
    handler.setFormatter(JSONFormatter(mode=mode))  # type: ignore[arg-type]
    handler.addFilter(RequestIDFilter())
    return handler, stream


def lines_of(stream: io.StringIO) -> list[dict[str, Any]]:  # DICT-OK: parsed payloads
    return [parse_line(line) for line in stream.getvalue().splitlines() if line.strip()]


class RaisingStr:
    """A value whose ``__str__`` raises — EC-17 (b) as an extra, (e) as the record's ``msg``."""

    def __str__(self) -> str:
        raise RuntimeError("str raised")


class _RaisingNameMeta(type):
    @property
    def __name__(cls) -> str:  # type: ignore[override]
        raise RuntimeError("type name raised")


class Hostile(metaclass=_RaisingNameMeta):
    """EC-17 (d) — ``__str__``, ``__repr__`` and the metaclass's ``__name__`` all raise."""

    def __str__(self) -> str:
        raise RuntimeError("str raised")

    def __repr__(self) -> str:
        raise RuntimeError("repr raised")


class _LongNamedMemberFailureForTheCapError(Exception):
    """A long type name, so 1000 member names cannot fit in 16 KiB whatever the separators."""


def _recurse(depth: int) -> int:
    return _recurse(depth + 1)


# EC-23's oversized records — every one must come back capped and marked "truncated".
CAPPED_RECORDS = (
    "64kib-message",
    "20000-e-acute",
    "5000-emoji",
    "recursion-error",
    "1000-member-group",
    "20kib-method",
    "fallback-tuple-keyed-status-code",
)


def capped_record(record_id: str) -> tuple[logging.LogRecord, BaseException | None]:
    """EC-23's records, plus EC-13's ``lone-surrogate`` — each with the exception it carries."""
    if record_id == "recursion-error":
        try:
            _recurse(0)
        except RecursionError as error:
            return make_record("x", exc_info=(RecursionError, error, error.__traceback__)), error
    if record_id == "1000-member-group":
        members = [_LongNamedMemberFailureForTheCapError() for _ in range(1000)]
        info = exc_info_of(ExceptionGroup("g", members))
        return make_record("x", exc_info=info), info[1]
    messages = {  # DICT-OK: a test-local lookup keyed by parametrize id — confined to this function
        "64kib-message": "a" * 65_536,
        "20000-e-acute": "é" * 20_000,
        "5000-emoji": "\U0001f600" * 5_000,
        "lone-surrogate": "\ud800",
    }
    if record_id in messages:
        return make_record(messages[record_id]), None
    if record_id == "20kib-method":
        return make_record("x", extra={"method": "G" * 20_480}), None
    if record_id == "fallback-tuple-keyed-status-code":
        tuple_keyed = {(i, i): "x" * 12 for i in range(3_000)}
        return make_record("a" * 65_536, extra={"status_code": tuple_keyed}), None
    pytest.fail(f"unknown record id {record_id!r}")


def build_handlers(
    env: str,
    config: dict[str, Any],  # DICT-OK: a dictConfig dict, the stdlib's own shape
    tmp_path: Path,
) -> dict[str, logging.Handler]:
    """Instantiate every formatter, filter and handler as ``dictConfig`` would, never calling it.

    ``DictConfigurator`` resolves ``()`` and ``ext://`` exactly as ``dictConfig`` does and leaves
    global logging untouched. It mutates what it is given, so it gets a deep copy; dev's file
    handler is pointed at ``tmp_path`` so no test writes into ``code/src/logs/``.
    """
    config = copy.deepcopy(config)
    for handler in config.get("handlers", {}).values():
        if "filename" in handler:
            handler["filename"] = str(tmp_path / f"{env}.log")
    configurator = logging.config.DictConfigurator(config)
    section = configurator.config
    formatters = section.get("formatters", {})
    for name in list(formatters):
        formatters[name] = configurator.configure_formatter(formatters[name])
    filters = section.get("filters", {})
    for name in list(filters):
        filters[name] = configurator.configure_filter(filters[name])
    handlers = section.get("handlers", {})
    return {name: configurator.configure_handler(handlers[name]) for name in list(handlers)}
