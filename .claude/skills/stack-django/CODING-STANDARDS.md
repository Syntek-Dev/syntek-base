# Stack: Django & Django Ninja — coding standards (<%PROJECT_NAME%>)

Part of the `stack-django` skill; `SKILL.md` is the index. The service-layer, Ninja, RLS and PII,
search and off-request idioms live here so the index stays within the instructional length
limit. The governing procedures and the `code/docs/` guides own the _why_; this states the shape.

---

## Django

- **Logic lives in the service layer or on models — never in endpoints.** Django Ninja
  endpoints stay thin: authenticate, authorise, validate, delegate to a service, shape
  the response. An endpoint with business logic in it is a refactor target.
- **Multi-write operations are wrapped in `transaction.atomic()`** in the service method,
  not scattered across the caller.
- **Aim for 3NF.** Add `db_index=True` / composite indexes for every field that filters or
  orders a hot query; add `constraints` for invariants the DB should enforce.
- **UUID primary keys on anything the API exposes** — never leak sequential IDs (IDOR and
  enumeration risk). <%PROJECT_NAME%> Admin surfaces UUIDs; see `code/docs/URL-STRATEGY.md`.
- Kill N+1s with `select_related` (FK/1:1) and `prefetch_related` (reverse/M2M) at the
  service boundary. See `code/docs/PERFORMANCE.md`. Bound every list query — keyset over
  offset for scale-readiness (`code/docs/architecture/CORE-AND-SCALING.md`).

## Service layer

- A service is a module of functions (or a class) under `apps/<app>/services/` that owns
  one domain's business rules. Endpoints and management commands call services; services
  call models. Nothing calls an endpoint.
- **Reuse first, create second.** Before adding a query scope, validator, or permission
  check, search for an existing manager method or service function — copy-pasted query
  logic or duplicated validation across endpoints is a red flag. Extract a shared manager,
  service method, or Policy class instead.
- **Every failure is classified into one of three trees**, all in
  `apps.core.services.errors`: a `ServiceError` subclass for a user error (4xx),
  `InvariantViolation` for a broken guarantee (500 and one tracker event), and
  `DependencyUnavailable` for an unreachable provider (503, raised in the adapter that owns
  the SDK). The latter two are **siblings of `ServiceError`, never members** — inside the
  tree, one broad `except ServiceError` turns a broken invariant into a friendly 400.
- **Guard the invariant at the top of one named method, with a `raise`.** `assert` is banned
  outside tests and ruff `S101` fails the build on it; an `AssertionError` cannot carry the
  register key, so it reaches the tracker naming nothing. The guard's only exit is the raise
  — never an early return, a confirming query, or a log.
- **`InvariantViolation` takes its register key first** —
  `InvariantViolation("order.total_matches_lines", …)` — and that key appears in exactly one
  `raise`. Add the row to `how-to/src/INVARIANTS.md` in the same change;
  `code/src/scripts/audits/negative-space.sh` fails on a key with no row, a row with no
  raise, and one key raised twice.

Read `code/docs/NEGATIVE-SPACE.md` before writing a guard or a constraint — it owns what
counts as an invariant, the single-enforcement-point rule, and the taxonomy above.

```python
"""Blog publication service — orchestrates draft-to-published transitions."""

from django.db import transaction
from django.utils import timezone

from apps.blogs.models import BlogPost
from apps.core.services.errors import ServiceValidationError


def publish(post: BlogPost, *, published_by_id: str) -> BlogPost:
    """Publish a draft blog post.

    Args:
        post: The draft post to publish.
        published_by_id: UUID of the authorising editor (for the audit trail).

    Returns:
        BlogPost: The saved, published post.

    Raises:
        ServiceValidationError: If the post is not in a publishable state.
    """
    if post.status != BlogPost.Status.DRAFT:
        raise ServiceValidationError("Only draft posts may be published.")

    with transaction.atomic():
        post.status = BlogPost.Status.PUBLISHED
        post.published_at = timezone.now()
        post.save(update_fields=["status", "published_at"])
    return post
```

## Django Ninja

- **Every state-changing endpoint has an explicit, named Policy permission check** (OWASP
  A01). No mutating endpoint resolves without one — this is a hard gate the `security` skill enforces.
- **Verify user-supplied IDs against the caller's ownership** before acting on them — no
  IDOR. Resolve the object _scoped to the caller_, never fetch-then-trust.
- Routers and Ninja `Schema` (Pydantic) models live in `apps/<app>/api.py`; split into an
  `api/` package (one router module per concern) once a file approaches the 750-line source limit.
- **Schemas subclass the bases in `apps.core.schemas`** — request bodies `Schema`, responses
  `OutSchema` or `ninja.ModelSchema`, `Query(...)` containers `QuerySchema`. Ruff `TID251`
  fails the build on a direct `ninja.Schema` import, because Ninja's own default **silently
  discards** unknown fields in a request body. `QuerySchema` deliberately accepts extras:
  Ninja hands Pydantic the whole query string, so forbidding them would 422 every inbound
  link carrying `?utm_source=…` (`code/docs/api-design/NINJA-CONVENTIONS.md`).
- Filter PII fields by permission **in the response Schema**, and guard PII endpoints with a
  permission check plus audit logging. See `code/docs/SECURITY.md` and `ENCRYPTION-GUIDE.md`.
- Return structured errors via Ninja exception handlers, not bare strings — follow the error
  conventions in `code/docs/API-DESIGN.md`.

```python
"""Blog endpoints — publish transition guarded by an explicit Policy check."""

from ninja import Router

from apps.core.schemas import Schema

from apps.blogs.models import BlogPost
from apps.blogs.policies import BlogPolicy
from apps.blogs.services import publication

router = Router(tags=["blogs"])


class BlogPostOut(Schema):
    id: str
    status: str
    published_at: str | None


@router.post("/posts/{post_id}/publish", response=BlogPostOut)
def publish_post(request, post_id: str) -> BlogPost:
    """Publish a draft post owned by the authenticated editor."""
    user = request.user
    # Ownership-scoped fetch — never trust a raw client-supplied ID.
    post = BlogPolicy.get_owned_or_403(user, post_id)
    BlogPolicy.require_can_publish(user, post)
    return publication.publish(post, published_by_id=str(user.id))
```

## Row-level security & PII

An **RLS context middleware**, registered after `AuthenticationMiddleware`, issues
`SET LOCAL` for the scope session variables inside the request transaction. A scoped table
reached without that context set is a security finding.

Set **only** the scope variables a policy actually reads, each derived from a field that
exists. A variable written but read by nothing looks like isolation, tests green, and
silently defaults. A scope column, its policy, its index, and the middleware that sets it are
added together or not at all.

Hash PII for lookup and encrypt it for storage via the field-encryption pipeline; encrypted
columns cannot be indexed, ordered, or searched. Full detail: `code/docs/DATABASE.md`,
`code/docs/RLS-GUIDE.md`, `code/docs/ENCRYPTION-GUIDE.md`.

## Search

Full-text search is PostgreSQL-native: a `SearchVectorField` with a `GinIndex`, ideally
maintained as a stored generated column so it cannot drift from its source. Supply the search
configuration explicitly — the implicit form is not immutable and a generated column will be
rejected. Add the GIN index concurrently on any populated table. `django.contrib.postgres`
must be in `INSTALLED_APPS` for any of it. See `code/docs/DATABASE.md` — _Search_.

## Off the request cycle

Work that runs without a request has no user to answer to, so the same three classes land
differently. Each surface has one owning guide; read it before writing on that surface.

- **Management commands** — `code/docs/MANAGEMENT-COMMANDS.md`. Subclass
  `apps.core.management.base.ManagementCommand`; ruff `TID251` fails the build on Django's
  `BaseCommand`, by either import path. Arguments are untrusted input — argparse **parses**,
  which is not validating, so a command-line identifier is exactly as unverified as one from
  a URL. Destructive work declares its bounds and takes `--dry-run`; the confirmation prompt
  is not the safety, because `--noinput`, a pipe and a scheduler all skip it. Exit 75
  (`EX_TEMPFAIL`) is the one code that carries meaning — a scheduler retries on it.
- **Background tasks** — `code/docs/TASK-AUTHORING.md`. Enqueue inside
  `transaction.on_commit()`, pass identifiers rather than instances, and re-read by primary
  key inside the task. The **user-error class is empty here**: a task has nobody to tell, so
  an argument it cannot act on was put there by code. A signature change is a two-release
  change — a rolling deploy has both live, so a queued message carries the previous shape.
- **Which process it runs in** — `code/docs/PROCESS-MODEL.md`. Worker class, the event loop,
  and the ORM's sync boundary; read it before choosing sync versus async or adding a process
  beyond the web one.
