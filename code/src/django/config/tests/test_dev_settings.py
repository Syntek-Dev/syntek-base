"""``config.settings.dev`` — the CSRF trusted origins a worktree story stack needs.

A per-story dev stack is published on ``127.0.0.NNN:3080`` and advertised as
``http://dev-usNNN.<%PROJECT_SLUG%>.localhost:3080``. Dev nginx forwards ``Host`` without the
port, so the browser's ``Origin`` never matches the request host and the trusted list is the
only way a form POST gets through. The overlay supplies the extra origins through
``DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA``; ``dev.py`` appends them to the three ``:81`` defaults
and refuses anything that would silently widen the list.

Each case imports the settings module in a **fresh interpreter**. Importing ``dev`` in the
test process would mutate the ``TEMPLATES`` list it shares with ``config.settings.test``
(``string_if_invalid``) and so change every template test that runs after it.
"""

from __future__ import annotations

import os
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

import pytest

pytestmark = [pytest.mark.unit, pytest.mark.story("US008")]

ENV_VAR = "DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA"

# The main stack's origins — a known literal, never re-derived from dev.py.
MAIN_STACK_ORIGINS = (
    "http://dev.<%PROJECT_SLUG%>.localhost:81",
    "http://127.0.0.1:81",
    "http://localhost:81",
)

STORY_STACK_NAME = "http://dev-us008.<%PROJECT_SLUG%>.localhost:3080"
STORY_STACK_IP = "http://127.0.0.8:3080"

# code/src/django — the directory holding the ``config`` package.
DJANGO_ROOT = Path(__file__).resolve().parents[2]

_PROBE = (
    "import importlib\n"
    "module = importlib.import_module('config.settings.dev')\n"
    "for origin in module.CSRF_TRUSTED_ORIGINS:\n"
    "    print(origin)\n"
)


@dataclass(frozen=True)
class SettingsImport:
    """The outcome of importing ``config.settings.dev`` in a fresh interpreter."""

    succeeded: bool
    trusted_origins: tuple[str, ...]
    stderr: str


def _import_dev_settings(extra: str | None) -> SettingsImport:
    """Import the dev settings with ``DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA`` set to ``extra``.

    ``None`` means the variable is absent from the environment altogether.
    """
    env = os.environ.copy()
    env.pop(ENV_VAR, None)
    env.pop("DJANGO_SETTINGS_MODULE", None)
    if extra is not None:
        env[ENV_VAR] = extra
    completed = subprocess.run(  # noqa: S603 — fixed argv, no shell, no user input
        [sys.executable, "-c", _PROBE],
        cwd=DJANGO_ROOT,
        env=env,
        capture_output=True,
        text=True,
        timeout=60,
        check=False,
    )
    return SettingsImport(
        succeeded=completed.returncode == 0,
        trusted_origins=tuple(line for line in completed.stdout.splitlines() if line),
        stderr=completed.stderr,
    )


class TestDefaultsWithoutTheVariable:
    """Unset or empty means the main stack's three origins, exactly."""

    def test_unset_gives_exactly_the_main_stack_origins(self) -> None:
        result = _import_dev_settings(None)

        assert result.succeeded, result.stderr
        assert result.trusted_origins == MAIN_STACK_ORIGINS

    @pytest.mark.parametrize("blank", ["", "   ", ",", " , ,  "])
    def test_empty_or_blank_gives_exactly_the_main_stack_origins(self, blank: str) -> None:
        result = _import_dev_settings(blank)

        assert result.succeeded, result.stderr
        assert result.trusted_origins == MAIN_STACK_ORIGINS


class TestStoryStackOrigins:
    """The overlay's origins are appended; the defaults are never dropped."""

    def test_story_stack_origins_are_trusted_alongside_the_defaults(self) -> None:
        result = _import_dev_settings(f"{STORY_STACK_NAME},{STORY_STACK_IP}")

        assert result.succeeded, result.stderr
        assert result.trusted_origins == (*MAIN_STACK_ORIGINS, STORY_STACK_NAME, STORY_STACK_IP)

    def test_a_single_origin_is_trusted(self) -> None:
        result = _import_dev_settings(STORY_STACK_IP)

        assert result.succeeded, result.stderr
        assert result.trusted_origins == (*MAIN_STACK_ORIGINS, STORY_STACK_IP)

    def test_https_origin_without_a_port_is_trusted(self) -> None:
        result = _import_dev_settings("https://dev-us008.example.localhost")

        assert result.succeeded, result.stderr
        assert result.trusted_origins == (
            *MAIN_STACK_ORIGINS,
            "https://dev-us008.example.localhost",
        )

    def test_whitespace_is_stripped_and_empty_items_ignored(self) -> None:
        result = _import_dev_settings(f"  {STORY_STACK_NAME} , ,\t{STORY_STACK_IP}  ,")

        assert result.succeeded, result.stderr
        assert result.trusted_origins == (*MAIN_STACK_ORIGINS, STORY_STACK_NAME, STORY_STACK_IP)


class TestRefusesToWiden:
    """A wildcard or a malformed entry fails the import loudly — never a wider list."""

    @pytest.mark.parametrize(
        "wildcard",
        [
            "*",
            "http://*",
            "http://*.localhost:3080",
            "https://*.<%PROJECT_SLUG%>.localhost",
            f"{STORY_STACK_IP},*",
        ],
    )
    def test_a_wildcard_raises_improperly_configured(self, wildcard: str) -> None:
        result = _import_dev_settings(wildcard)

        assert not result.succeeded, f"imported with trusted origins {result.trusted_origins}"
        assert "ImproperlyConfigured" in result.stderr
        assert ENV_VAR in result.stderr

    @pytest.mark.parametrize(
        "malformed",
        [
            "dev-us008.example.localhost:3080",
            "127.0.0.8:3080",
            "http://",
            "http://dev-us008.example.localhost:3080/control/",
            "http://dev-us008.example.localhost:port",
            "not an origin",
            f"{STORY_STACK_IP},localhost:3080",
        ],
    )
    def test_a_malformed_entry_raises_improperly_configured(self, malformed: str) -> None:
        result = _import_dev_settings(malformed)

        assert not result.succeeded, f"imported with trusted origins {result.trusted_origins}"
        assert "ImproperlyConfigured" in result.stderr
        assert ENV_VAR in result.stderr
