---
type: guide
skills: [backend, stack-django]
model: opus
---

# Backend Coding Principles — Django / Python / Celery

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Standard backend code review, naming conventions, error handling patterns
**MCP Servers:** code-review-graph (structural analysis, design pattern detection)

Read alongside **[CODING-PRINCIPLES.md](CODING-PRINCIPLES.md)**. Apply when writing Django, Python,
or Celery code.

---

## Table of Contents

- [Class vs Function](#class-vs-function)
- [Decision Structuring: Boolean, Policy, and Strategy](#decision-structuring-boolean-policy-and-strategy)
- [Error Handling](#error-handling)
- [Naming Conventions](#naming-conventions)
- [Import Rules](#import-rules)
- [Logging](#logging)
- [Caching](#caching)
- [Code Review Checklist (Backend)](#code-review-checklist-backend)

---

## Class vs Function

The choice between a class and a function is primarily about **state and dependencies**. This applies
to all Django/Python code: utilities, services, views, permissions, managers, middleware,
authentication backends, and management commands.

**Use a function when:**

- The logic is stateless — takes inputs and returns an output with no retained state
- No dependencies need to be injected
- It is a one-off utility or predicate (`format_currency`, `is_expired`)

**Use a class when:**

- The code implements a `Protocol` (Policy, Strategy, or any other interface)
- The Django framework expects a class: views (`View`), permissions (`BasePermission`), managers
  (`Manager`), middleware, authentication backends, management commands
- Two or more related methods share state or injected dependencies
- You need `__init__` to receive and store dependencies for later use

The default in the Django service layer is a **class**, because service objects typically hold
injected dependencies (repositories, policy classes, external clients) constructed once per request.

```python
# Stateless utility — function
def format_currency(amount: Decimal, currency: str = "GBP") -> str:
    return f"£{amount:,.2f}"

# Holds injected dependencies, implements a Protocol — class
class RecordService:
    def __init__(self, deletion_policy: DeletionPolicy) -> None:
        self._policy = deletion_policy

    def delete(self, user: "User", record: "Record") -> None:
        if not self._policy.permits(user, record):
            raise PermissionDenied("Not permitted.")
        record.delete()
```

---

## Decision Structuring: Boolean, Policy, and Strategy

See the [global overview in CODING-PRINCIPLES.md](coding-principles/PRACTICAL-RULES.md#decision-structuring-boolean-pattern-matching-policy-and-strategy).
Django-specific implementation below.

### Policy — Python / Django

Use a `Protocol` for the interface and name the class after the business rule it encodes. Django's
own permission framework (`user.has_perm(...)`) and Django Ninja's per-endpoint auth callables are
the canonical Policy pattern. Django Ninja endpoints call a service that enforces the Policy — never
inline the permission check in the endpoint.

```python
from typing import Protocol
from django.core.exceptions import PermissionDenied

class DeletionPolicy(Protocol):
    def permits(self, user: "User", obj: object) -> bool: ...

class MFARequiredDeletionPolicy:
    def permits(self, user: "User", obj: object) -> bool:
        return user.mfa_verified_this_session

class RecordService:
    def __init__(self, deletion_policy: DeletionPolicy) -> None:
        self._policy = deletion_policy

    def delete(self, user: "User", record: "Record") -> None:
        if not self._policy.permits(user, record):
            raise PermissionDenied("You are not permitted to delete this record.")
        record.delete()
```

### Strategy — Python / Django

Django's `AUTHENTICATION_BACKENDS` setting is a first-class framework example of the Strategy
pattern — different backends, same `authenticate()` interface.

```python
from typing import Protocol
from django.db import transaction

class MFAStrategy(Protocol):
    def verify(self, user: "User", token: str) -> bool: ...

class TOTPStrategy:
    def verify(self, user: "User", token: str) -> bool:
        return pyotp.TOTP(user.totp_secret).verify(token)

class BackupCodeStrategy:
    def verify(self, user: "User", token: str) -> bool:
        with transaction.atomic():
            code = BackupCode.objects.select_for_update().filter(
                user=user, code=token, used=False
            ).first()
            if code is None:
                return False
            code.used = True
            code.save()
            return True

def get_mfa_strategy(user: "User") -> MFAStrategy:
    return TOTPStrategy() if user.totp_enabled else BackupCodeStrategy()
```

### Composition — Python / Django

Policy determines _whether_ an action is allowed; Strategy determines _how_ it is carried out.

```python
class MFARequiredDeletionPolicy:
    def __init__(self, mfa_strategy: MFAStrategy) -> None:
        self._strategy = mfa_strategy

    def permits(self, user: "User", token: str) -> bool:
        return self._strategy.verify(user, token)

# Wired together in the service layer:
strategy = get_mfa_strategy(user)
policy = MFARequiredDeletionPolicy(mfa_strategy=strategy)
service = RecordService(deletion_policy=policy)
service.delete(user, record, token)
```

The calling code reads as a sentence: the service enforces a Policy; the Policy delegates _how_ to
verify to the Strategy.

---

## Error Handling

See the [global rules in CODING-PRINCIPLES.md](coding-principles/PRACTICAL-RULES.md#error-handling). The following
Python-specific rules are critical — regressions here cause data integrity incidents.

> **`assert` is banned outside tests — always `raise`.** The rule, the three reasons, and the shape
> of the guard clause that replaces it are owned by [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md)
> § _The guard clause_. Enforced by ruff `S101`; a `# noqa: S101` is a finding, not a workaround.

### `except` clause syntax

**Python 3.14 ([PEP 758](https://docs.python.org/3.14/whatsnew/3.14.html)) allows `except` and
`except*` to list multiple exception types without brackets.** `except A, B:` is now valid and
**identical** to `except (A, B):` — both catch either type. (The old Python-2 `except A, e:`
_binding_ meaning is gone; bind with `as`.) `ruff format` targets 3.14 and **normalises to the
bracket-less form**, so that is the canonical style in this codebase — do not hand-add tuple
parentheses, the formatter strips them on the next run.

```python
# Canonical — what `ruff format` produces on Python 3.14
except ValueError, TypeError:
    ...

# Also valid, but `ruff format` rewrites it to the bracket-less form above
except (ValueError, TypeError):
    ...

# Binding with `as` — parentheses are REQUIRED (bracket-less is a SyntaxError here)
except (ValueError, TypeError) as exc:
    ...
```

The bracket-less form applies **only when there is no `as` binding**. When you bind the caught
exception with `as`, the parentheses are **mandatory** — `except A, B as e:` raises
`SyntaxError: multiple exception types must be parenthesized when using 'as'`, and `ruff format`
keeps the parentheses in that case. So across the codebase: non-binding multi-type excepts are
bracket-less; `as`-binding multi-type excepts keep their parentheses. Either way, `ruff format`
produces the canonical form — run it and do not hand-tune.

> Historical note: before 3.14, `except A, B:` was a `SyntaxError` and parentheses were mandatory.
> That is no longer the case — let `ruff format` decide the style and do not fight it.

When catching multiple exceptions that require different handling, use **separate `except` blocks**:

```python
except SomeModel.DoesNotExist:
    pass  # expected path
except SomeModel.MultipleObjectsReturned:
    logger.error("Data integrity violation — multiple rows matched lookup_key=%r", key)
    # then fall through or re-raise as appropriate
```

Silently `pass`-ing a `MultipleObjectsReturned` (or any data-integrity exception) is a bug — log it
at `ERROR` level first so incidents are visible in observability tooling.

### Multi-step operations must use `transaction.atomic()` (CRITICAL — recurring failure)

Any service method that performs two or more database writes must be wrapped in
`transaction.atomic()`. Without it, a failure partway through leaves the database in an inconsistent
state.

```python
# WRONG — if bulk_create fails, the delete has already happened
BackupCode.objects.filter(user=user).delete()
BackupCode.objects.bulk_create([...])

# CORRECT
with transaction.atomic():
    BackupCode.objects.filter(user=user).delete()
    BackupCode.objects.bulk_create([...])
```

This applies to: registration flows, provisioning, permission assignments, role deletions, and any
other mutation that touches more than one model or row. Missing `transaction.atomic()` on multi-step
writes will be caught at QA. Add it when writing the service, not after.

Use Django's exception hierarchy and Django Ninja's exception handlers (register them with
`@api.exception_handler(SomeError)` on the `NinjaAPI` instance). Log unexpected exceptions to
Sentry/GlitchTip before re-raising or returning error responses.

---

## Naming Conventions

See the [global conventions in CODING-PRINCIPLES.md](coding-principles/PRACTICAL-RULES.md#naming-conventions).
Python/Django specifics:

- `snake_case` for variables, functions, and modules
- `PascalCase` for classes
- `SCREAMING_SNAKE_CASE` for constants

---

## Import Rules

See the [global rule in CODING-PRINCIPLES.md](coding-principles/PRACTICAL-RULES.md#import-rules) — all imports must
appear at the top of the file. Python-specific ordering and exceptions below.

### Import order — Python

Enforced by `ruff` (isort-compatible):

```text
1. stdlib
2. third-party packages
3. local / project imports
```

```python
from __future__ import annotations  # always first if present

import logging                       # stdlib
import re

from ninja import Router             # third-party
from django.conf import settings

from apps.core.conf import get_setting  # local
```

### Python-specific exceptions

The following additional exceptions apply to Python files in the Django backend:

| Exception                                  | Rule                                                                                                                                                                                                                                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Django migration `RunPython` functions** | Imports inside the callable passed to `RunPython` are the standard Django migration pattern. The function runs in the migration executor's context, not the application's. Model imports must be done via `apps.get_model()` or local imports to avoid historical model state issues. |
| **`AppConfig.ready()`**                    | Imports for startup wiring (signal handlers, validation calls) must be deferred into `ready()`. Importing at module level in `apps.py` creates a circular import because Django has not finished loading the app registry when the file is first parsed.                              |

### Python — shadowing avoidance

When a top-level import would shadow a local variable or method parameter, rename the import with an
underscore prefix:

```python
# django.db.connection would shadow the `connection` parameter in reset_search_path()
from django.db import connection as _db_connection
```

---

## Logging

See the [global rules in CODING-PRINCIPLES.md](coding-principles/STYLE-AND-PROCESS.md#logging).

**Never use `print()` in committed code.** Always use the project logger so output flows through the
configured handlers and appears in `code/src/logs/` locally and in Loki in staging/prod. `print()`
bypasses every handler — it is invisible to observability tooling.

Temporary `print()` statements added while chasing a bug must be removed before the fix is
committed. They are not a substitute for a proper log statement.

---

## Caching

> See the caching decision record for the full decision and implementation patterns.

Caching strategy lives entirely in Django application code. Valkey is a coordination substrate —
it stores keys and enforces TTLs. The NixOS Valkey config is infrastructure, not strategy.

Key rules:

- Every `cache.set()` call must use a jittered TTL to prevent synchronised mass expiry
  (`base + random.randint(0, int(base * 0.1))`).
- Hot-path cache misses on expensive keys use a `get_or_set_coalesced()` helper (Valkey
  `SET NX` lock) — not bare `cache.get_or_set()` — to limit concurrent DB hits to one.
- Celery beat warmers refresh named hot keys before their TTL expires. TTL must be ≥ 3–5× the
  refresh interval. Warmer failures must trigger a GlitchTip/Prometheus alert.
- Namespace lock keys: request-path coalescing uses `key:lock`; warmer locks use `key:warm:lock`.
- Add layers incrementally only when measurements justify them — do not build all three upfront.

---

## Code Review Checklist (Backend)

In addition to the [global checklist in CODING-PRINCIPLES.md](coding-principles/STYLE-AND-PROCESS.md#code-review-checklist):

- [ ] `except` clauses follow `ruff format` — bracket-less multi-type form on Python 3.14 (PEP 758); bind with `as`
- [ ] `MultipleObjectsReturned` and other data-integrity exceptions are logged at `ERROR`, not silently passed
- [ ] Multi-step DB writes are wrapped in `transaction.atomic()`
- [ ] No `print()` in committed code
- [ ] Cache `set()` calls use a jittered TTL — no bare `timeout=N` without jitter
- [ ] Hot-path cache misses on expensive keys use `get_or_set_coalesced()`, not bare `get_or_set()`
- [ ] Warmer tasks have a GlitchTip/Prometheus heartbeat alert wired up before being deployed
