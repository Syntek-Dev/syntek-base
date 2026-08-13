---
type: guide
skills: [planner, stack-django, stack-htmx-templates]
model: fable
---

# Architecture Patterns — Service Layer and Middleware

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Service layer boundaries, business logic placement, middleware patterns

---

## Service Layer

Business logic lives in service classes or modules, not in views, Ninja endpoints, schemas,
models, or templates. This is the most important architectural boundary in the application.

### The rule

- **Views / Ninja endpoints** handle HTTP concerns: receiving requests, checking permissions,
  validating input, returning responses.
- **Services** handle business logic: orchestrating domain operations, enforcing business rules.
- **Models** handle data: persistence, relationships, simple computed properties. Models do not
  call external services, send emails, or dispatch events.
- **Schemas** (Ninja / Pydantic) handle transformation: validating and shaping the JSON that
  crosses the API boundary.

### Django

```python
# services/order_service.py
class OrderService:
    def create_order(self, customer: Customer, items: list[OrderItemInput]) -> Order:
        if not items:
            raise ValueError("Cannot create an order with no items")

        order = Order.objects.create(customer=customer, status=OrderStatus.DRAFT)
        for item in items:
            order.add_line(product=item.product, quantity=item.quantity)
        order.recalculate_total()

        send_order_confirmation.delay(order.id)  # async side effect
        return order
```

```python
# api.py — thin Ninja endpoint (input validated by the CreateOrderIn schema)
from ninja import Router

router = Router()

@router.post("/orders", response={201: OrderOut}, auth=session_auth)
def create_order(request, payload: CreateOrderIn):
    _require_user(request)  # explicit permission check on every state-changing endpoint

    service = OrderService()
    order = service.create_order(
        customer=request.auth,
        items=payload.items,
    )
    return 201, OrderOut.from_orm(order)
```

### Rules

- If a view method exceeds 10–15 lines of logic, extract it to a service.
- Services may call other services. Keep the dependency graph acyclic.
- Services must not access `request` directly. Pass the data they need as arguments.
- Wrap multi-step operations in database transactions. If any step fails, all steps roll back.
- Side effects (emails, webhooks, event dispatch) happen at the end of the service method, after
  the primary operation succeeds.
- **A service lives in the app that owns its data**, including the read-only ones. Report and
  dashboard aggregations are services like any other — they belong under the app whose records
  they summarise (analytics rollups in the analytics app, audit rollups in the audit app), not in
  a shared `reports/` module gathering queries from across the project. That module is where a
  cross-app query with no owner ends up, and it is how a scope filter gets forgotten: the app
  that owns a table is the one that knows which rows a caller may see.

### Service Exception Hierarchy

All service modules define typed exception classes inheriting from base classes in
`apps.core.services.errors`. This lets callers catch exceptions from any app uniformly.

| Base class               | Code                | Use for                          |
| ------------------------ | ------------------- | -------------------------------- |
| `ServiceError`           | `UNKNOWN_ERROR`     | Root base — subclass per app     |
| `ServicePermissionError` | `PERMISSION_DENIED` | ABAC / ownership failures        |
| `ServiceNotFoundError`   | `NOT_FOUND`         | Missing or soft-deleted resource |
| `ServiceValidationError` | `VALIDATION_ERROR`  | Field-level input validation     |

**These four ship** — `apps/core/services/errors.py` — alongside two classes that are
deliberately **outside** this tree: `InvariantViolation` (programmer error, 500) and
`DependencyUnavailable` (environment error, 503). Never move either inside it, and never
introduce a shared base over all three: one broad `except ServiceError` would then convert a
broken invariant into a friendly 400. The taxonomy is owned by
[`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) § _The error taxonomy_.

Each app defines a thin per-app base and inherits from there:

```python
# apps/orders/services/errors.py
from apps.core.services.errors import ServiceError

class OrderError(ServiceError):
    """Base for all order service errors."""

class OrderPermissionError(OrderError):
    code = "PERMISSION_DENIED"
    ...
```

The API layer (Ninja endpoints) catches specific app exceptions and maps them to HTTP responses.
Cross-app handlers can catch `ServicePermissionError` or `ServiceError` to handle any service
failure uniformly.

### Soft-Delete Queryset Convention

A soft-deleting model uses `SoftDeleteManager`, which returns a `SoftDeleteQuerySet`.

```python
# DO NOT replicate deleted_at__isnull=True by hand:
qs = Model.objects.filter(deleted_at__isnull=True)  # ✗

# Use the named method:
qs = Model.objects.not_deleted()   # ✓
qs = Model.objects.deleted()       # ✓ (for admin trash views)
```

`published_qs()` is the single authoritative definition of public-content visibility. It retains
its own filter. All other call sites must use `.not_deleted()`.

**A soft-deleting table's uniqueness constraint must be partial** —
`UniqueConstraint(condition=Q(deleted_at__isnull=True))` — or the table forbids re-creating a row
whose predecessor was soft-deleted. Stated in [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)
§ _The soft-delete trap_.

Where the same prefetch is needed across apps, define it **once** as a module-level constant beside
the model it traverses and import it — never re-declare the traversal at each call site, where the
copies drift apart silently.

### Audit Logging from Services

Service methods that write data must call `AuditService.log()` with a registered action constant
inside `transaction.atomic()`. The audit write is atomic with the data write — a failure rolls back
both.

```python
from apps.<%AUDIT_APP%> import constants as audit_constants
from apps.<%AUDIT_APP%>.services import AuditService

with transaction.atomic():
    order.save()
    AuditService.log(
        audit_constants.ORDER_CREATED,
        actor_id=actor.pk,
        actor_type="admin",
        target_type="order",
    )
```

All action strings must be declared in `apps/<%AUDIT_APP%>/constants.py` using
`DOMAIN.SUBJECT.VERB` format before use; `AuditService` raises `ValueError` for an unregistered
action. **The audit record's schema, write path, retention and PII rules are owned by
[`../security/AUDIT-TRAIL.md`](../security/AUDIT-TRAIL.md)** — this section states only that the
call sits inside the service method's transaction.

### Deep modules

A module is **deep** when it puts a lot of behaviour behind a **small interface** at a clean
**seam** — a service that hides a multi-step operation, its transaction, and its side effects
behind one method is deeper than a thin pass-through that merely forwards to the ORM. Depth is
**leverage per unit of interface learned**; widening the interface to look substantial is the
opposite of depth.

- **The deletion test.** Delete the module and inline it: if the same complexity reappears across
  N callers, it earned its keep; if nothing reappears, it was padding a seam that did not exist.
- **The interface is the test surface.** Test a service through its public methods, never its
  internals — a test that must reach past the interface is telling you the boundary is wrong.
- **One adapter is a hypothetical seam; two adapters are a real seam.** Do not introduce an
  abstraction (base class, protocol, strategy) until a second implementation actually varies —
  see YAGNI in [`../CODING-PRINCIPLES.md`](../CODING-PRINCIPLES.md).
- **Design it twice.** For any non-obvious interface, sketch 2–3 radically different shapes — one
  that minimises the interface, one that maximises flexibility, one that optimises the common
  caller — and choose between them before writing the implementation.

> These terms are the vocabulary of the `codebase-design` skill
> (`.claude/skills/codebase-design`); the `improve-codebase-architecture` review
> (`/improve-codebase-architecture`) surfaces where a module is shallow and proposes the deepening.

---

## Middleware and Request Pipeline

Middleware processes requests before they reach the controller. Order matters.

### Recommended middleware order

```text
1. Security headers (CSP, HSTS, X-Frame-Options)
2. CORS
3. Request logging / request ID injection
4. Authentication (verify token, populate user)
5. Tenant resolution (identify tenant from subdomain/header)
6. Rate limiting
7. CSRF verification (stateful routes only)
8. Authorisation (route-level permission check)
9. Input validation (via Django form / Ninja `Schema`)
```

### Rules

- Authentication middleware must run before authorisation, rate limiting, and tenant resolution.
- Tenant resolution middleware must run before any service or query that accesses tenant-scoped
  data.
- Do not put business logic in middleware. Middleware handles cross-cutting concerns only.
- Global middleware applies to every request. Do not apply expensive middleware globally if it is
  only needed on a subset of routes.

### Django middleware

```python
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.middleware.common.CommonMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "apps.<%AUDIT_APP%>.middleware.RLSMiddleware",
    "apps.tenants.middleware.TenantMiddleware",
    # custom middleware below framework middleware
]
```

---

## Background Job Patterns

### Job classification

| Type                | Description                                     | Queue           | Retry                           |
| ------------------- | ----------------------------------------------- | --------------- | ------------------------------- |
| **Fire-and-forget** | No result needed (email, webhook, audit log)    | Default         | Yes, with backoff               |
| **Deferred result** | Result needed later (report generation, export) | Dedicated queue | Yes, notify on failure          |
| **Scheduled**       | Runs on a cron schedule (daily digest, cleanup) | Scheduled       | Yes, alert on repeated failure  |
| **Chained**         | Sequence of dependent steps                     | Default         | Each step retries independently |

### Rules

- Each job has a single, clear responsibility.
- Chain jobs explicitly rather than having one job trigger the next implicitly.
- Failed jobs must be monitored. Set up alerts for job failure rates exceeding a threshold.
- Long-running jobs (> 30 seconds) must send heartbeats or progress updates.
- Jobs that interact with external APIs must implement circuit breaker patterns.

---

## Email and Notification Patterns

- Emails and notifications are always dispatched via queued jobs, never sent synchronously.
- Each notification type has a single class/function that encapsulates content, recipients, and
  delivery channels.

### Django

```python
# notifications/order_confirmed.py
@shared_task
def send_order_confirmed(order_id: int) -> None:
    order = Order.objects.select_related("customer").get(id=order_id)
    send_mail(
        subject=f"Order #{order.reference} confirmed",
        message=f"Hi {order.customer.name}, your order has been confirmed.",
        from_email="orders@example.com",
        recipient_list=[order.customer.email],
    )
```

### Rules

- Never put email content in controllers or services. It belongs in dedicated notification classes.
- All emails must have both HTML and plain-text versions.
- Use a logging or null mailer in development and test environments.

---

## File Processing Pipelines

### Pattern

1. **Accept** — validate and store the original file. Return immediately with a "processing" status.
2. **Queue** — dispatch a processing job with the file path and desired transformations.
3. **Process** — the job performs the transformation, stores the result, and updates status.
4. **Notify** — if the user is waiting, notify via WebSocket, polling, or email.

### Rules

- Store originals permanently. Store processed versions as derived artefacts.
- Process files in a background job, never in the request cycle.
- Set file size limits at the web server, application framework, and storage layer.
- Use streaming uploads for large files to avoid loading the entire file into memory.
- Clean up temporary files in a `finally` block, even if processing fails.

_Part of the `code/docs/` documentation family. See [`../ARCHITECTURE-PATTERNS.md`](../ARCHITECTURE-PATTERNS.md) for the full index._
