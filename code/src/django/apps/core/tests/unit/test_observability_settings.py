"""US014 — each environment's ``LOGGING`` dict, and what its staging console writes.

Scenario IDs are ``QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md`` Section 2's. **``dictConfig`` is
never called**: it would rewrite this process's logging under every other test, and on dev's
dict open the ``RotatingFileHandler``. Each module is ``importlib``-imported and its entries
built through ``DictConfigurator`` (``observability_support.build_handlers``).

Importing ``config.settings.dev`` has two side effects, both harmless here: it creates
``code/src/logs/`` and sets ``TEMPLATES[0]["OPTIONS"]["string_if_invalid"]`` on the dict shared
with ``base`` — to the value ``test.py`` already sets.
"""

from __future__ import annotations

import copy
import importlib
import logging
from collections.abc import Callable
from pathlib import Path
from types import ModuleType
from typing import Any

import pytest

from apps.core.observability import JSONFormatter, RequestIDFilter
from apps.core.tests.unit.observability_support import (
    CAPPED_RECORDS,
    FIXED_KEYS,
    Hostile,
    RaisingStr,
    build_handlers,
    capped_record,
    exc_info_of,
    make_record,
    parse_line,
)

pytestmark = pytest.mark.story("US014")

ENVIRONMENTS = ("dev", "test", "staging", "production")
OFF_DEV = ("test", "staging", "production")
FILTER_FACTORY = "apps.core.observability.RequestIDFilter"
DJANGO_LOGGER = {"handlers": [], "level": "WARNING"}


def _settings(env: str) -> ModuleType:
    return importlib.import_module(f"config.settings.{env}")


def _logging(env: str) -> dict[str, Any]:  # DICT-OK: dictConfig's own shape
    module = _settings(env)
    assert hasattr(module, "LOGGING"), f"{env}: no LOGGING"
    return module.LOGGING


def logging_problems(env: str, config: dict[str, Any]) -> list[str]:  # DICT-OK: dictConfig
    """Every way ``config`` breaks the per-environment contract, each naming ``env``.

    HP-11's assertion; ES-04 and ES-05 prove it can go red.
    """
    problems: list[str] = []
    filter_ids = {
        fid for fid, entry in config.get("filters", {}).items() if entry.get("()") == FILTER_FACTORY
    }
    if not filter_ids:
        problems.append(f"{env}: no filter entry builds {FILTER_FACTORY}")
    for name, handler in config.get("handlers", {}).items():
        if not filter_ids.intersection(handler.get("filters", [])):
            problems.append(f"{env}: handler {name!r} lacks the request_id filter")
    loggers = config.get("loggers", {})
    for named in ("django.request", "api"):
        if named in loggers:
            problems.append(f"{env}: declares a {named!r} logger nothing writes to")
    if env != "dev":
        django = loggers.get("django")
        if django is None:
            problems.append(f"{env}: no 'django' logger declared")
        elif {k: v for k, v in django.items() if k != "propagate"} != DJANGO_LOGGER:
            problems.append(f"{env}: 'django' logger is {django!r}, not {DJANGO_LOGGER!r}")
        elif django.get("propagate", True) is False:
            problems.append(f"{env}: 'django' logger does not propagate")
        if config.get("root", {}).get("level") != "WARNING":
            problems.append(f"{env}: root is not at WARNING")
    return problems


class TestEveryEnvironmentsDict:
    """HP-11, ES-03 to ES-05, EC-14."""

    @pytest.mark.parametrize("env", ENVIRONMENTS)
    def test_every_handler_carries_the_filter(self, env: str) -> None:
        """HP-11 — and off dev the ``django`` logger holds no handler of its own."""
        assert logging_problems(env, _logging(env)) == []

    @pytest.mark.parametrize("env", OFF_DEV)
    def test_the_check_fails_naming_the_env_when_the_django_logger_goes(self, env: str) -> None:
        """ES-04."""
        config = _logging(env)
        assert logging_problems(env, config) == [], "the real dict must pass first"
        broken = copy.deepcopy(config)
        del broken["loggers"]["django"]

        assert f"{env}: no 'django' logger declared" in logging_problems(env, broken)

    @pytest.mark.parametrize("env", ENVIRONMENTS)
    def test_the_check_fails_naming_the_env_and_handler_without_the_filter(self, env: str) -> None:
        """ES-05."""
        config = _logging(env)
        assert logging_problems(env, config) == [], "the real dict must pass first"
        broken = copy.deepcopy(config)
        name = next(iter(broken["handlers"]))
        broken["handlers"][name]["filters"] = []

        assert f"{env}: handler {name!r} lacks the request_id filter" in logging_problems(
            env, broken
        )

    def test_staging_and_production_carry_one_identical_dict(self) -> None:
        """HP-11 — two hand-maintained copies that cannot drift."""
        staging = _logging("staging")

        assert logging_problems("staging", staging) == []
        assert staging == _logging("production")

    def test_dev_is_debug_with_its_django_loggers_unchanged(self) -> None:
        """HP-11 — root DEBUG; ``django`` INFO; ``django.db.backends`` WARNING, file only."""
        config = _logging("dev")

        assert logging_problems("dev", config) == []
        assert config["root"]["level"] == "DEBUG"
        assert config["loggers"]["django"]["level"] == "INFO"
        assert config["loggers"]["django.db.backends"] == {
            "handlers": ["file"],
            "level": "WARNING",
            "propagate": False,
        }

    def test_test_keeps_one_console_with_no_formatter(self) -> None:
        """Gherkin — the filter rides along only for the every-handler invariant."""
        config = _logging("test")

        assert logging_problems("test", config) == []
        assert list(config["handlers"]) == ["console"]
        assert "formatter" not in config["handlers"]["console"]

    @pytest.mark.parametrize("env", ["staging", "production"])
    def test_an_undeclared_app_logger_inherits_warning(self, env: str) -> None:
        """EC-14 — a project's INFO logger joins only once it is declared."""
        config = _logging(env)

        assert config.get("root", {}).get("level") == "WARNING"
        assert not [name for name in config.get("loggers", {}) if name.startswith("apps")]

    def test_base_assigns_no_logging(self) -> None:
        """ES-03."""
        base = _settings("base")
        source = Path(base.__file__ or "").read_text(encoding="utf-8")

        assert not hasattr(base, "LOGGING")
        assert "replaces this wholesale" not in source


class TestEveryEntryBuilds:
    """HP-11b, AC-GAP-12 — a misspelt path or kwarg is a boot failure the suite must see."""

    @pytest.mark.parametrize("env", ENVIRONMENTS)
    def test_each_entry_builds_and_maps_to_the_observability_classes(
        self, env: str, tmp_path: Path
    ) -> None:
        handlers = build_handlers(env, _logging(env), tmp_path)
        try:
            assert handlers, f"{env}: no handlers"
            for name, handler in handlers.items():
                assert any(isinstance(f, RequestIDFilter) for f in handler.filters), (env, name)
                if env == "test":
                    assert handler.formatter is None, (env, name)
                else:
                    assert isinstance(handler.formatter, JSONFormatter), (env, name)
        finally:
            for handler in handlers.values():
                handler.close()

    @pytest.mark.parametrize(
        ("env", "wide"), [("dev", True), ("staging", False), ("production", False)]
    )
    def test_each_environment_selects_its_line_shape(
        self, env: str, wide: bool, tmp_path: Path
    ) -> None:
        """Backend AC — the extras and exception shape are chosen by the environment's dict."""
        handlers = build_handlers(env, _logging(env), tmp_path)
        formatter = handlers["console"].formatter
        for handler in handlers.values():
            handler.close()
        assert formatter is not None, f"{env}: console has no formatter"
        error = ValueError("user a@example.com not found")
        record = make_record("x", extra={"email": "a@example.com"}, exc_info=exc_info_of(error))

        line = formatter.format(record)
        payload = parse_line(line)

        assert ("email" in payload) is wide
        assert ("user a@example.com not found" in line) is wide


def _staging_logger(tmp_path: Path) -> logging.Logger:
    """Staging's console handler, built after ``capsys`` has patched ``sys.stdout``.

    An unregistered ``Logger``, so nothing enters the logging registry.
    """
    handler = build_handlers("staging", _logging("staging"), tmp_path)["console"]
    logger = logging.Logger("us014")
    logger.addHandler(handler)
    return logger


class TestStagingConsoleUnderCapsys:
    """HP-12, EC-13, EC-17, EC-23 — stdout, one line each, and ``handleError`` never reached."""

    def test_one_json_line_on_stdout_and_nothing_on_stderr(
        self, capsys: pytest.CaptureFixture[str], tmp_path: Path
    ) -> None:
        """HP-12."""
        _staging_logger(tmp_path).warning("hello")

        out = capsys.readouterr()
        lines = out.out.splitlines()

        assert len(lines) == 1, out
        payload = parse_line(lines[0])
        assert "request_id" in payload
        assert payload["request_id"] is None
        assert out.err == ""

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
    def test_the_formatter_never_raises(
        self,
        capsys: pytest.CaptureFixture[str],
        tmp_path: Path,
        emit: Callable[[logging.Logger], None],
        kept: set[str],
    ) -> None:
        """EC-17 — the fallback writes the fixed five plus kept extras, no marker key."""
        emit(_staging_logger(tmp_path))

        out = capsys.readouterr()
        lines = out.out.splitlines()

        assert out.err == "", "Handler.handleError was reached"
        assert len(lines) == 1, out
        payload = parse_line(lines[0])
        assert set(payload) == FIXED_KEYS | kept
        assert isinstance(payload["message"], str)
        for key in kept:
            assert isinstance(payload[key], str)

    def test_bad_percent_args_log_the_bare_msg(
        self, capsys: pytest.CaptureFixture[str], tmp_path: Path
    ) -> None:
        """EC-17 (a) — ``str(record.msg)`` without its arguments."""
        _staging_logger(tmp_path).warning("%s %s", 1)

        assert parse_line(capsys.readouterr().out.strip()).get("message") == "%s %s"

    @pytest.mark.parametrize("record_id", [*CAPPED_RECORDS, "lone-surrogate"])
    def test_each_record_reaches_stdout_as_one_line(
        self, capsys: pytest.CaptureFixture[str], tmp_path: Path, record_id: str
    ) -> None:
        """EC-13 and EC-23, through the handler."""
        record, _ = capped_record(record_id)
        handler = build_handlers("staging", _logging("staging"), tmp_path)["console"]

        handler.handle(record)
        out = capsys.readouterr()

        assert out.err == ""
        assert len(out.out.splitlines()) == 1
        parse_line(out.out.splitlines()[0])
