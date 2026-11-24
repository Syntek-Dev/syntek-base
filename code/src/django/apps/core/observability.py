"""Structured JSON log lines carrying a ``request_id`` — the formatter and filter ``LOGGING`` names.

The line contract is a published interface, documented in ``code/docs/logging/DJANGO-LOGGING.md``;
this module is its only implementation, and renaming or adding a key is a breaking change to every
documented query, which needs a superseding decision record rather than an edit here.

Two modes, chosen by each environment's own ``LOGGING`` through dictConfig's factory form,
``{"()": "apps.core.observability.JSONFormatter", "mode": "minimal"}``:

* ``minimal`` (staging, production) — the five fixed keys, only the allowlisted extras, a
  message-free ``exc_info``, and every line plus its newline held to 16 384 bytes.
* ``wide`` (dev) — every extra, the fixed keys written after them so none can be displaced,
  and the full traceback. Uncapped: the dev log never leaves the host.

The standard library only, by decision (ADR-US014 Option D): the contract-specific code — the
exception shape, the ordered cut and the never-raise fallback — would be ours under any library.
"""

from __future__ import annotations

import json
import logging
from collections.abc import Callable
from dataclasses import dataclass
from datetime import UTC, datetime
from types import TracebackType
from typing import Final, Literal

from apps.core.middleware import current_request_id

__all__ = ["ALLOWLIST", "LINE_CAP_BYTES", "JSONFormatter", "LineFields", "RequestIDFilter"]

Mode = Literal["minimal", "wide"]

# The payload is a dictionary by necessity: the fixed keys plus extras only known at runtime.
# DICT-OK: the json.dumps payload, fixed keys plus dynamic extras — confined to this module
Payload = dict[str, object]

# Docker's log copier splits a line that fills its 16 KiB buffer without a newline, so the
# bound counts the line plus the "\n" the handler appends (QA-PLAN-US014 AC-GAP-10).
LINE_CAP_BYTES: Final = 16_384

# The only extras that survive off dev — dropped, never masked (ADR-US014 Option K).
ALLOWLIST: Final = frozenset({"duration_ms", "status_code", "method"})

# Every attribute a bare LogRecord carries, derived rather than hand-copied so a Python release
# that adds one (3.12's ``taskName``) cannot leak it as an extra. ``message`` and ``asctime`` are
# written by ``Formatter.format``; ``request_id`` is a fixed key, never an extra.
_RESERVED: Final = frozenset(logging.makeLogRecord({}).__dict__) | {
    "message",
    "asctime",
    "request_id",
}

# A bound on the link walk, not a fit test: a type-only link is ~15 bytes, so a chain this long
# may still be cut by the cap, but the walk can never cost more than ~512 links per record.
_MAX_LINKS: Final = LINE_CAP_BYTES // 32

# The cut keeps this much message while frames, links and members are trimmed, and only then
# takes the rest — a long traceback should not erase the sentence that explains it first.
_MESSAGE_FLOOR: Final = 512

# The last-resort line bounds every string to this many characters; even fully escaped astral
# text (12 bytes a character) leaves the six bounded strings well under the cap.
_EMERGENCY_CHARS: Final = 128

# ``request_id`` is the join, so the last-resort line keeps it whole: the filter only ever writes
# a validated inbound id (at most 200 characters, ``middleware.py``) or a 32-character minted one.
_REQUEST_ID_CHARS: Final = 200

_UNPRINTABLE: Final = "<unprintable value>"

_LAST_RESORT_MESSAGE: Final = "log record could not be formatted"
_LAST_RESORT_LEVEL: Final = "ERROR"
_LAST_RESORT_LOGGER: Final = "apps.core.observability"

# The innermost line, written only when even the live last-resort line could not be built —
# still one JSON object of the fixed keys. Its epoch timestamp is a collector's to reject.
_LAST_RESORT: Final = json.dumps(
    {
        "timestamp": "1970-01-01T00:00:00.000+00:00",
        "level": _LAST_RESORT_LEVEL,
        "logger": _LAST_RESORT_LOGGER,
        "message": _LAST_RESORT_MESSAGE,
        "request_id": None,
    }
)


@dataclass(frozen=True, slots=True)
class LineFields:
    """The five keys every line carries, whatever the mode and whatever went wrong."""

    timestamp: str
    level: str
    logger: str
    message: str
    request_id: str | None

    def as_payload(self) -> Payload:
        """The fixed keys in contract order, ready to be merged with the extras."""
        return {
            "timestamp": self.timestamp,
            "level": self.level,
            "logger": self.logger,
            "message": self.message,
            "request_id": self.request_id,
        }


def _safe_text(value: object) -> str:
    """``str``, then ``repr``, then fixed text naming at most the type — it cannot raise."""
    for render in (str, repr):
        try:
            text = render(value)
        except Exception:  # noqa: S112 — a hostile __str__/__repr__ is the case guarded
            continue
        if isinstance(text, str):
            return text
    return _unprintable(value)


def _message_text(msg: object) -> str:
    """``str(record.msg)`` without its arguments, else the guard's fixed text (EC-17 (e)).

    No ``repr`` step: the contract's ``message`` is ``str(record.msg)``, and an object whose
    ``__str__`` raises gets the fixed text naming its type, never its repr.
    """
    try:
        text = str(msg)
    except Exception:  # a hostile __str__ is the case guarded
        return _unprintable(msg)
    return text if isinstance(text, str) else _unprintable(msg)


def _unprintable(value: object) -> str:
    """Fixed text naming at most the type — and still fixed text when naming the type raises."""
    try:
        name = type(value).__name__
        if isinstance(name, str):
            return f"<unprintable {name}>"
    except Exception:  # noqa: S110 — a metaclass can make even the type name raise
        pass
    return _UNPRINTABLE


def _type_name(exc: BaseException) -> str:
    """The class's ``__name__`` — never the message, and never an exception of its own."""
    try:
        name = type(exc).__name__
    except Exception:  # a hostile metaclass
        return "<unnamed exception>"
    return name if isinstance(name, str) else _safe_text(name)


def _frames(tb: TracebackType | None) -> list[Payload]:
    """``(filename, lineno, function)`` per frame, outermost first — no source text, no locals."""
    frames: list[Payload] = []
    while tb is not None:
        code = tb.tb_frame.f_code
        frames.append(
            {"filename": code.co_filename, "lineno": tb.tb_lineno, "function": code.co_name}
        )
        tb = tb.tb_next
    return frames


def _exception_shape(exc: BaseException) -> tuple[Payload, bool]:
    """The minimal ``exc_info``, and whether the link walk stopped at its bound.

    Iterative, so a 2000-link chain cannot raise ``RecursionError`` inside ``format()``; each
    exception is visited once, so a ``__context__`` cycle terminates. A link already visited
    (a cycle's back-edge) is omitted, as ``null`` would claim there is none; a link past the
    bound is omitted too, and that one the cap marks ``truncated``.
    """
    shape: Payload = {"type": _type_name(exc), "frames": _frames(exc.__traceback__)}
    seen = {id(exc)}
    budget = _MAX_LINKS
    walked_past_bound = False
    pending: list[tuple[BaseException, Payload]] = [(exc, shape)]
    while pending:
        current, holder = pending.pop()
        for key, child in (("cause", current.__cause__), ("context", current.__context__)):
            if child is None:
                holder[key] = None
            elif id(child) in seen:
                # A cycle's back-edge: the link exists, so it is omitted — ``null`` says "none".
                continue
            elif budget == 0:
                walked_past_bound = True
            else:
                seen.add(id(child))
                budget -= 1
                link: Payload = {"type": _type_name(child)}
                holder[key] = link
                pending.append((child, link))
    if isinstance(exc, BaseExceptionGroup):
        shape["members"] = [_type_name(member) for member in exc.exceptions]
    return shape, walked_past_bound


def _recorded_exception(record: logging.LogRecord) -> BaseException | None:
    """The exception a record carries; ``None`` for no ``exc_info``, ``(None, None, None)``, or
    anything that is not a triple — ``Logger._log`` always makes one, a hand-built record need not.
    """
    info = getattr(record, "exc_info", None)
    if not isinstance(info, tuple) or len(info) < 2:
        return None
    exc = info[1]
    return exc if isinstance(exc, BaseException) else None


def _serialise(payload: Payload) -> str:
    # allow_nan=False: NaN and Infinity are not JSON, and LogQL's ``| json`` would mark the line;
    # raising sends the record to the fallback, which writes the value as its text.
    return json.dumps(payload, default=str, ensure_ascii=True, allow_nan=False)


def _fits(payload: Payload) -> bool:
    # ensure_ascii keeps the line ASCII, so its length is its byte count.
    return len(_serialise(payload)) + 1 <= LINE_CAP_BYTES


def _largest_fitting(
    lo: int, hi: int, apply: Callable[[int], None], fits: Callable[[], bool]
) -> bool:
    """Apply the largest ``n`` in ``[lo, hi]`` that fits; else apply ``lo`` and return ``False``."""
    apply(hi)
    if fits():
        return True
    apply(lo)
    if lo >= hi or not fits():
        return False
    while hi - lo > 1:
        mid = (lo + hi) // 2
        apply(mid)
        if fits():
            lo = mid
        else:
            hi = mid
    apply(lo)
    return True


def _links_shallowest_first(shape: Payload) -> list[tuple[Payload, str, Payload]]:
    """Every ``(parent, key, link)`` under ``shape``, ordered so the deepest are cut first."""
    found: list[tuple[Payload, str, Payload]] = []
    level = [shape]
    while level:
        deeper: list[Payload] = []
        for holder in level:
            for key in ("cause", "context"):
                link = holder.get(key)
                if isinstance(link, dict):
                    found.append((holder, key, link))
                    deeper.append(link)
        level = deeper
    return found


def _cap(payload: Payload, walked_past_bound: bool) -> str:
    """Hold the line plus its newline to ``LINE_CAP_BYTES``, cutting in a fixed order.

    Message (down to a floor), outermost frames, deepest links, group members, oversized
    allowlisted extras, then the rest of the message. The outermost type, the innermost frame
    and every fixed key survive; a cut link is omitted, never written ``null`` ("no cause").
    """
    line = _serialise(payload)
    if len(line) + 1 <= LINE_CAP_BYTES and not walked_past_bound:
        return line
    # Re-read as plain JSON values, so every default=str coercion is a string the cut can shorten.
    cut: Payload = json.loads(line)
    cut["truncated"] = True

    def fits() -> bool:
        return _fits(cut)

    message = str(cut["message"])

    def keep_message(n: int) -> None:
        cut["message"] = message[:n]

    if _largest_fitting(min(len(message), _MESSAGE_FLOOR), len(message), keep_message, fits):
        return _serialise(cut)

    shape = cut.get("exc_info")
    if isinstance(shape, dict):
        frames = list(shape.get("frames") or [])

        def keep_frames(n: int) -> None:
            shape["frames"] = frames[len(frames) - n :]

        if frames and _largest_fitting(1, len(frames), keep_frames, fits):
            return _serialise(cut)

        links = _links_shallowest_first(shape)

        def keep_links(n: int) -> None:
            for index, (holder, key, link) in enumerate(links):
                if index < n:
                    holder[key] = link
                else:
                    holder.pop(key, None)

        if links and _largest_fitting(0, len(links), keep_links, fits):
            return _serialise(cut)

        members = list(shape.get("members") or [])

        def keep_members(n: int) -> None:
            shape["members"] = members[:n]

        if members and _largest_fitting(0, len(members), keep_members, fits):
            return _serialise(cut)

    for key in sorted(ALLOWLIST & cut.keys()):
        value = cut[key]
        text = value if isinstance(value, str) else json.dumps(value)

        def keep_extra(n: int, key: str = key, text: str = text) -> None:
            cut[key] = text[:n]

        if len(text) > _MESSAGE_FLOOR and _largest_fitting(0, len(text), keep_extra, fits):
            return _serialise(cut)

    if _largest_fitting(0, len(message), keep_message, fits):
        return _serialise(cut)
    return _emergency_line(cut)


def _emergency_line(cut: Payload) -> str:
    """Every fixed key, each string bounded, the outer type and innermost frame — always fits."""

    def bounded(value: object, limit: int = _EMERGENCY_CHARS, *, tail: bool = False) -> str | None:
        if value is None:
            return None
        text = str(value)
        return text[-limit:] if tail else text[:limit]

    line: Payload = {
        "timestamp": bounded(cut.get("timestamp")),
        "level": bounded(cut.get("level")),
        "logger": bounded(cut.get("logger")),
        "message": "",
        "request_id": bounded(cut.get("request_id"), _REQUEST_ID_CHARS),
    }
    shape = cut.get("exc_info")
    if isinstance(shape, dict):
        frames = shape.get("frames") or []
        innermost = frames[-1] if isinstance(frames, list) and frames else None
        kept: list[Payload] = []
        if isinstance(innermost, dict):
            kept.append(
                {
                    "filename": bounded(innermost.get("filename"), tail=True),
                    "lineno": _int_or_none(innermost.get("lineno")),
                    "function": bounded(innermost.get("function")),
                }
            )
        line["exc_info"] = {"type": bounded(shape.get("type")), "frames": kept}
    line["truncated"] = True
    return _serialise(line)


def _int_or_none(value: object) -> int | None:
    return value if isinstance(value, int) else None


class JSONFormatter(logging.Formatter):
    """One JSON object per record: ``minimal`` off dev (staging, production), ``wide`` in dev.

    Never delegates to ``logging.Formatter.format`` or ``formatException`` in minimal mode, and
    never raises: a record that cannot be serialised is written through a guarded fallback, so
    ``Handler.handleError`` — which prints the raw arguments to stderr — is never reached.
    """

    def __init__(self, mode: Mode = "minimal") -> None:
        if mode not in ("minimal", "wide"):
            raise ValueError(f"JSONFormatter mode must be 'minimal' or 'wide', not {mode!r}")
        super().__init__()
        self.mode: Mode = mode

    def format(self, record: logging.LogRecord) -> str:
        try:
            return self._format(record)
        except Exception:  # noqa: S110 — a log line must never cost the request
            pass
        try:
            return self._format_fallback(record)
        except Exception:  # noqa: S110 — the last resort follows
            pass
        return _last_resort(record)

    # ── The ordinary path ────────────────────────────────────────────────────

    def _format(self, record: logging.LogRecord) -> str:
        fields = LineFields(
            timestamp=_timestamp(record),
            level=record.levelname,
            logger=record.name,
            message=record.getMessage(),
            request_id=_request_id_of(record),
        )
        if self.mode == "wide":
            payload = {k: v for k, v in _extras(record).items() if k not in _FIXED}
            payload.update(fields.as_payload())
            exc = _recorded_exception(record)
            if exc is not None:
                payload["exc_info"] = self._traceback(exc)
            return _serialise(payload)

        payload = fields.as_payload()
        payload.update(_allowlisted(record))
        walked_past_bound = False
        exc = _recorded_exception(record)
        if exc is not None:
            payload["exc_info"], walked_past_bound = _exception_shape(exc)
        return _cap(payload, walked_past_bound)

    # ── The fallback: fixed keys and kept extras, every value coerced in place ──

    def _format_fallback(self, record: logging.LogRecord) -> str:
        try:
            message = record.getMessage()
        except Exception:  # bad %-args: the bare msg, never the arguments
            message = _message_text(record.msg)
        fields = LineFields(
            timestamp=_guarded_timestamp(record),
            level=_safe_text(getattr(record, "levelname", "")),
            logger=_safe_text(getattr(record, "name", "")),
            message=message if isinstance(message, str) else _safe_text(message),
            request_id=_guarded_request_id(record),
        )
        # The allowlist runs before coercion, so a dropped extra stays dropped here too.
        kept = _extras(record) if self.mode == "wide" else _allowlisted(record)
        coerced: Payload = {key: _json_value(value) for key, value in kept.items()}
        walked_past_bound = False
        exc_info: object = None
        exc = _recorded_exception(record)
        if exc is not None:
            try:
                if self.mode == "wide":
                    exc_info = self._traceback(exc)
                else:
                    exc_info, walked_past_bound = _exception_shape(exc)
            except Exception:  # the line still goes out without it
                exc_info = None
        if self.mode == "wide":
            payload = {k: v for k, v in coerced.items() if k not in _FIXED}
            payload.update(fields.as_payload())
        else:
            payload = fields.as_payload()
            payload.update(coerced)
        if exc_info is not None:
            payload["exc_info"] = exc_info
        if self.mode == "wide":
            return json.dumps(payload, ensure_ascii=True, allow_nan=False)
        return _cap(payload, walked_past_bound)

    def _traceback(self, exc: BaseException) -> str:
        """Dev only: the full traceback, message included — the wide line is never minimised."""
        return self.formatException((type(exc), exc, exc.__traceback__))


_FIXED: Final = frozenset(LineFields.__dataclass_fields__)


def _last_resort(record: logging.LogRecord) -> str:
    """The fixed five when both paths failed: the time now and whatever text the record still
    yields, each bounded — the constant only if even this cannot be built."""

    def text_or(name: str, default: str | None, limit: int) -> str | None:
        value = getattr(record, name, None)
        return value[:limit] if isinstance(value, str) and value else default

    try:
        return _serialise(
            LineFields(
                timestamp=datetime.now(tz=UTC).isoformat(timespec="milliseconds"),
                level=text_or("levelname", _LAST_RESORT_LEVEL, _EMERGENCY_CHARS) or "",
                logger=text_or("name", _LAST_RESORT_LOGGER, _EMERGENCY_CHARS) or "",
                message=_LAST_RESORT_MESSAGE,
                request_id=text_or("request_id", None, _REQUEST_ID_CHARS),
            ).as_payload()
        )
    except Exception:  # the innermost last resort is a constant
        return _LAST_RESORT


def _timestamp(record: logging.LogRecord) -> str:
    """ISO-8601 UTC to the millisecond, ``+00:00``, whatever ``TZ`` the process runs under."""
    return datetime.fromtimestamp(record.created, tz=UTC).isoformat(timespec="milliseconds")


def _guarded_timestamp(record: logging.LogRecord) -> str:
    try:
        return _timestamp(record)
    except Exception:  # a corrupted ``created`` still gets a timestamp
        return datetime.now(tz=UTC).isoformat(timespec="milliseconds")


def _request_id_of(record: logging.LogRecord) -> str | None:
    """What the filter wrote; ``None`` when no filter ran, so the key is never missing."""
    value = getattr(record, "request_id", None)
    if value is None or isinstance(value, str):
        return value or None
    return _safe_text(value)


def _guarded_request_id(record: logging.LogRecord) -> str | None:
    try:
        return _request_id_of(record)
    except Exception:  # a guard that raised would cost the line
        return None


def _extras(record: logging.LogRecord) -> Payload:
    """Every attribute ``extra=`` added — the record minus what a bare ``LogRecord`` carries."""
    return {key: value for key, value in record.__dict__.items() if key not in _RESERVED}


def _allowlisted(record: logging.LogRecord) -> Payload:
    return {key: value for key, value in _extras(record).items() if key in ALLOWLIST}


def _json_value(value: object) -> object:
    """The value itself where it serialises as JSON, else its guarded text."""
    try:
        json.dumps(value, ensure_ascii=True, allow_nan=False)
    except Exception:  # unserialisable, non-finite, or a hostile __str__ under default=
        return _safe_text(value)
    return value


class RequestIDFilter(logging.Filter):
    """Writes ``record.request_id`` from the request being served; never drops a record.

    Unconditional: an ``extra={"request_id": ...}`` is overwritten, so a caller cannot forge the
    join. ``""`` outside a request becomes ``None``. Django logs a returned 4xx/5xx after
    ``RequestIDMiddleware`` has reset its ``ContextVar``, so for a ``django.request`` record the
    filter falls back to the id the middleware stored on the request — validated or minted,
    never ``request.META``, which holds the raw inbound header a hostile client chose.
    """

    def filter(self, record: logging.LogRecord) -> bool:
        record.request_id = _correlation_id(record)
        return True


def _correlation_id(record: logging.LogRecord) -> str | None:
    try:
        request_id = current_request_id()
        if request_id:
            return request_id
        if record.name != "django.request":
            return None
        stored = getattr(record.__dict__.get("request"), "request_id", None)
    except Exception:  # a filter that raises loses the record
        return None
    return stored if isinstance(stored, str) and stored else None
