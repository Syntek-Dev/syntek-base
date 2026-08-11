"""The base every management command subclasses — the error taxonomy's expression on the CLI.

A command has no HTTP status to carry the three classes
(``code/docs/NEGATIVE-SPACE.md`` § The error taxonomy), so the distinction has to be made in
what the operator reads and what a scheduler can act on. Making it here rather than in each
command is what stops thirty commands inventing thirty conventions; ruff ``TID251`` bans the
direct ``BaseCommand`` import so that this really is the only place it is decided.

Rule and rationale: ``code/docs/MANAGEMENT-COMMANDS.md``.
"""

from __future__ import annotations

from typing import Any

from django.core.management.base import BaseCommand, CommandError
from django.db import close_old_connections

from apps.core.services.errors import DependencyUnavailable, ServiceError

__all__ = ["EXIT_TEMPFAIL", "ManagementCommand"]

# EX_TEMPFAIL, from BSD `sysexits.h`. The one exit code worth distinguishing, because it is the
# only one anything downstream acts on differently: a scheduler retries on it and must not retry
# on the others. Every other failure keeps Django's exit 1 rather than inventing a code per class.
EXIT_TEMPFAIL = 75


class ManagementCommand(BaseCommand):
    """Maps the three error classes onto what an operator and a scheduler see.

    ``InvariantViolation`` is deliberately **not** handled below. A programmer error must reach
    the operator as a traceback and the tracker as an event; catching it here to print something
    tidier is the friendly-4xx failure in a different medium.
    """

    def execute(self, *args: Any, **options: Any) -> Any:
        # Django closes connections in `run_from_argv`, which `call_command()` never reaches — so
        # a command invoked from a task, a test, or another command would inherit whatever
        # connection state its caller left. Closing on entry is what makes the two invocation
        # paths equivalent, which is the rule `code/docs/PROCESS-MODEL.md` states and nothing
        # previously enforced.
        close_old_connections()
        try:
            return super().execute(*args, **options)
        except ServiceError as exc:
            # A user error: the operator asked for something this system will not do. One clean
            # line on stderr, exit 1. A traceback here would read as a defect in the command.
            raise CommandError(str(exc)) from exc
        except DependencyUnavailable as exc:
            # An environment error: nothing in this codebase is broken and the same invocation
            # may succeed in a minute. Exit 75 is what lets a scheduler tell that from the rest.
            raise CommandError(str(exc), returncode=EXIT_TEMPFAIL) from exc
        finally:
            close_old_connections()
