---
type: guide
skills: [backend, stack-django]
model: opus
---

# Management Commands

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus (argument validation, the exit classes, destructive-command safety)

**Status: the surface exists.** Unlike the task surface, which is
[declared and not wired](TASK-AUTHORING.md), `manage.py` runs today and every project gets it
free. `apps/core/management/base.py` ships; there are no project commands yet, because `core`
owns no domain.

The two surfaces are siblings — both run outside the request cycle, both take arguments nobody
in a browser typed — so this guide **routes to `TASK-AUTHORING.md` for everything they share**
and owns only what a command line has and a queue does not: an operator, a shell, and an exit
code.

## When work belongs in a command

| The work…                                            | Belongs in                                        |
| ---------------------------------------------------- | ------------------------------------------------- |
| Must outlive a request, or must not fail it          | a task ([`TASK-AUTHORING.md`](TASK-AUTHORING.md)) |
| Recurs on a schedule                                 | a task, on a beat schedule                        |
| A **person decides** to run, at a moment they choose | a command                                         |
| Is a one-off repair, backfill, or inspection         | a command                                         |

The distinction that matters is not "batch versus interactive" — it is **who chooses the
moment**. A command runs because someone with production credentials typed it, and that fact
decides everything below.

A command is the **third adapter over the service layer**, beside the Ninja endpoint and the
task. Its body parses arguments, calls a service, and reports. Business logic in a `handle()`
is logic no endpoint, task, or test can reach
([`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md)).

## Arguments are untrusted input

Not because the operator is hostile — because **argparse parses, and parsing is not
validation.** `type=int` proves a string was numeric; it says nothing about whether `-1`,
`0`, or `40000000` is a number this command may act on. The trust boundary is the same one
[`security/INPUT-AND-API.md`](security/INPUT-AND-API.md) § _Input Validation and Sanitisation_
draws for a request body, and its rules apply unchanged. Three things are specific to this
surface.

**An identifier from the command line is exactly as unverified as one from a URL.** A command
handed `--account 12` must check that account against whatever scope the operation requires,
for the same reason an endpoint must: the check is what makes the operation correct, and
neither surface gets it from the framework. IDOR does not become acceptable because the caller
had a shell.

**Identity is an argument, and it is data.** There is no `request.user`. A command that writes
an audit row, sends anything, or acts on someone's behalf takes the actor explicitly and
**verifies it**, rather than inferring it from the Unix user, an environment variable, or
"whoever is deploying". An unattributed write is an audit trail with a hole in it
([`security/AUDIT-TRAIL.md`](security/AUDIT-TRAIL.md)).

**Blast radius is the argument nobody passes.** The failure here is not a hostile value but a
plausible one — a missing `--since`, a typo'd `--limit`, a filter that matched everything.
So:

- **Anything destructive or irreversible takes `--dry-run`, and it reports what it _would_
  do.** A run that only counts is the cheapest review there is.
- **Bounds are declared, not discovered.** A command that walks a table takes an explicit
  limit or batch size rather than defaulting to "all of it", on the same reasoning
  [`DATABASE.md`](DATABASE.md) requires of a backfill: batched, idempotent, resumable.
- **The confirmation prompt is not the safety.** It is skipped by `--noinput`, by a pipe, and
  by a scheduler. The bound is the safety; the prompt is a courtesy.

## No request, no middleware

**Everything [`TASK-AUTHORING.md`](TASK-AUTHORING.md) § _No request, no middleware_ says holds
here unchanged** — no session, no authenticated user, no row-security session variable, no
automatic correlation. It is not restated; read it there. Two things differ:

- **Connections are this module's problem, and the base class solves it.** Django closes
  connections in `run_from_argv`, which `call_command()` never reaches — so a command invoked
  from a task, a test, or another command inherits its caller's connection state.
  `ManagementCommand.execute()` calls `close_old_connections()` on entry and exit, which is
  what makes the two invocation paths equivalent ([`PROCESS-MODEL.md`](PROCESS-MODEL.md)).
- **The permission decision is made _now_, not minutes ago.** A task re-checks authorisation
  because it may run long after it was enqueued. A command has no such gap — its risk is the
  opposite one, that nothing checked at all because a human was assumed to have thought
  about it.

## The error taxonomy on this surface

A command has no HTTP status, so the three classes
([`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) § _The error taxonomy_) are carried by **what the
operator reads** and **what a scheduler can act on**:

| Class                 | Raise                     | Operator sees                      | Exit |
| --------------------- | ------------------------- | ---------------------------------- | ---- |
| **User error**        | a `ServiceError` subclass | one line on stderr                 | 1    |
| **Environment error** | `DependencyUnavailable`   | one line on stderr                 | 75   |
| **Programmer error**  | `InvariantViolation`      | the traceback, and a tracker event | 1    |

**The classes are distinguished by type, not by exit code.** Only one code carries meaning:
**75**, `EX_TEMPFAIL` from BSD `sysexits.h`, because it is the only distinction anything
downstream acts on — a scheduler retries on it and must not retry on the other two. That is
the 503-versus-500 split of the HTTP table, expressed in the vocabulary a shell has. A code
per class was rejected: nothing reads it, so it would go wrong silently.

**A traceback is the correct output for a programmer error.** It is not untidiness to be
cleaned up — it is the one signal that says "this is a bug in the code, not in what you
typed", and it is what carries the register key to the tracker.

**All three classes exist here, which is what separates this surface from the task one.** A
task has no user, so a bad argument at run time is always a programmer error
([`TASK-AUTHORING.md`](TASK-AUTHORING.md) § _The error taxonomy on this surface_). A command's
operator is a real user, so `--since yesterday` when the flag takes a date is a user error and
must read like one.

### The base class, and why the import is banned

Every command subclasses **`ManagementCommand`** from `apps.core.management.base`. It maps the
table above and closes connections; nothing else.

**Ruff `TID251` bans importing Django's `BaseCommand` directly** — both
`django.core.management.base.BaseCommand` and the `django.core.management.BaseCommand`
re-export, because banning one path only would leave a one-word bypass. `pyproject.toml`
exempts exactly one file, `apps/core/management/base.py`.

The ban is what makes this a rule rather than a convention, and the reason is the failure
mode: subclassing Django's base directly **still works**. The command runs, the tests pass,
and the only difference is that a broken invariant now looks like every other traceback and a
transient outage exits 1 like a typo. Nothing fails until something needed to tell them apart.
This is the same mechanism, for the same reason, as the `ninja.Schema` ban
([`api-design/NINJA-CONVENTIONS.md`](api-design/NINJA-CONVENTIONS.md) § _Schema strictness_) —
a linter decides it, so review does not have to.

**What the ban does not cover, stated rather than discovered:** `LabelCommand` and
`AppCommand` are not banned. They are rarely the right base here, and adding them would trade
a clear rule for a longer one; a command that genuinely needs them is a review conversation.

## Testing

Commands are tested through `call_command()`, never a shell. Three things are worth asserting
and one is usually skipped:

| Level                 | What it tests                             | How                                                                 |
| --------------------- | ----------------------------------------- | ------------------------------------------------------------------- |
| **The service**       | The logic the command delegates to        | An ordinary service test. This is why command bodies stay thin      |
| **Argument handling** | Rejection of the values that must not run | `call_command()` with bad arguments; assert `CommandError`          |
| **The dry run**       | That `--dry-run` changed nothing          | Run it, then assert the database is byte-for-byte as it was         |
| **The exit class**    | That a dependency failure exits 75        | Make the adapter raise `DependencyUnavailable`; assert `returncode` |

The last one is the one people skip. It is also the only test that proves a scheduler will do
the right thing at three in the morning.

Tests run through `code/src/scripts/tests/backend.sh`, and count towards the same coverage
floors as everything else ([`testing/COVERAGE.md`](testing/COVERAGE.md)).

## What this guide does not own

| Concern                                       | Owner                                                                              |
| --------------------------------------------- | ---------------------------------------------------------------------------------- |
| Everything shared with the task surface       | [`TASK-AUTHORING.md`](TASK-AUTHORING.md)                                           |
| The three error classes themselves            | [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md)                                           |
| Where an invariant is enforced, and its key   | [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) · `how-to/src/INVARIANTS.md`              |
| Input validation rules in general             | [`security/INPUT-AND-API.md`](security/INPUT-AND-API.md)                           |
| The service layer a command calls             | [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) |
| Connection budgets and the process families   | [`PROCESS-MODEL.md`](PROCESS-MODEL.md) · [`DATABASE.md`](DATABASE.md)              |
| Batched backfills                             | `data-structures/SCHEMA-MIGRATIONS.md`                                             |
| What an audit row must contain                | [`security/AUDIT-TRAIL.md`](security/AUDIT-TRAIL.md)                               |
| `assert` versus `raise`, and the guard clause | [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) § _The guard clause_                      |

## Cross-references

- [`TASK-AUTHORING.md`](TASK-AUTHORING.md): the sibling surface — same taxonomy, expressed as
  retry classification rather than exit codes
- [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md): the taxonomy, the register, and the guard clause
- [`PROCESS-MODEL.md`](PROCESS-MODEL.md): where a command sits among the process families
- `code/src/django/apps/core/management/CONTEXT.md`: the shipped base class
- `.claude/skills/stack-django/SKILL.md`: the backend idioms loaded on demand

_Part of the `code/docs/` documentation family._
