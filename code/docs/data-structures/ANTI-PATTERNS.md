---
type: guide
skills: [database, stack-django]
model: opus
---

# Data Structures — Anti-Patterns

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Data structure anti-patterns and how to refactor away from them

---

## The God Dictionary / God Array

A single dictionary or object that accumulates every piece of state for a feature, passed around
through multiple functions, growing new keys as requirements change.

```python
# Bad — what keys does this dict have? What types? Nobody knows.
def process_order(context: dict) -> dict:
    context["total"] = sum(item["price"] for item in context["items"])
    context["tax"] = context["total"] * Decimal("0.2")
    context["processed"] = True
    return context


# Fix — replace with a typed structure
@dataclass
class OrderContext:
    items: list[OrderItem]
    total: Decimal = Decimal("0.00")
    tax: Decimal = Decimal("0.00")
    processed: bool = False
```

---

## Stringly Typed Data

Using strings for values that have a finite set of valid options.

```python
# Bad
user.role = "admn"  # typo — no error until runtime

# Good
user.role = UserRole.ADMIN  # typo caught by IDE and type checker
```

Enforce it in the database too — a bounded column takes a `CHECK` constraint, not just
`choices=`. Application-level validation alone lets a management command or a raw `UPDATE` write a
value the model would have rejected (`code/docs/DATABASE.md`).

---

## Primitive Obsession

Representing domain concepts as raw primitives instead of value objects.

```python
# Bad — what unit? Pounds? Pence? Dollars?
def apply_discount(price: float, discount: float) -> float:
    return price - discount


# Good — the type communicates the domain
def apply_discount(price: Money, discount: Money) -> Money:
    if price.currency != discount.currency:
        raise ValueError("Currency mismatch")
    return Money(amount=price.amount - discount.amount, currency=price.currency)
```

---

## Parallel Collections

Two or more lists that must be kept in sync by index.

```python
# Bad — names[i] corresponds to emails[i]. What if they get out of sync?
names = ["Alice", "Bob"]
emails = ["alice@example.com", "bob@example.com"]


# Good — one collection of structured objects
@dataclass(frozen=True)
class Contact:
    name: str
    email: str


contacts = [
    Contact(name="Alice", email="alice@example.com"),
    Contact(name="Bob", email="bob@example.com"),
]
```

This one hides especially well in templates: two lists zipped in the view, or worse, indexed
against each other with `forloop.counter0`, is the same defect wearing presentation clothes.

---

## Nested Dicts as Poor Man's Objects

Deeply nested dictionaries used in place of defined types.

```python
# Bad
user = {"name": "Alex", "profile": {"preferences": {"notifications": {"email": True}}}}


# Good — defined types
@dataclass
class NotificationPreferences:
    email: bool = True
    push: bool = False


@dataclass
class User:
    name: str
    profile: UserProfile = field(default_factory=UserProfile)
```

---

## The Mega-Model

A single Django model with 30+ fields covering multiple domain concepts.

```python
# Bad — User model that is also a profile, billing record, and preferences store
class User(models.Model):
    email = models.EmailField()
    bio = models.TextField()
    stripe_customer_id = models.CharField(max_length=100)
    subscription_plan = models.CharField(max_length=50)
    notification_email = models.BooleanField()
    theme = models.CharField(max_length=20)
    # ... 20 more fields


# Fix — split into focused models with one-to-one relationships
class User(models.Model):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=200)


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    bio = models.TextField(blank=True)


class Subscription(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="subscription")
    stripe_customer_id = models.CharField(max_length=100)
    plan = models.CharField(max_length=50, choices=PlanChoices.choices)
```

---

## Implicit Schema

Data structures whose shape is only known by reading the code that produces them.

```python
# Bad — what does this return? A dict of what?
def fetch_user(user_id: str):
    return {...}


# Good — the return type is explicit and checkable
def fetch_user(user_id: str) -> User: ...
```

A `dict[str, Any]` crossing a service boundary is the Python form of this anti-pattern. Return a
model, a dataclass, or a Ninja `Schema` — something basedpyright can check and a reader can look up.

---

## Comma-Separated Values in a Column

Storing multiple values in a single text column separated by commas.

```python
# Bad — violates 1NF, cannot join, cannot index, cannot enforce integrity
class Article(models.Model):
    tags = models.CharField(max_length=500)  # "python,django,web"


# Good — proper relationship
class Article(models.Model):
    tags = models.ManyToManyField("Tag", related_name="articles")
```

If you find yourself writing `.split(",")` to read data from a model field, the schema is wrong.

---

## Boolean Blindness

Using a boolean when the domain has more than two states, or when the boolean's meaning is
unclear at the call site.

```python
# Bad — what does True mean here?
process_order(order, True, False)

# Good — use enums or keyword arguments
process_order(order, priority=Priority.HIGH, send_notification=False)


# Bad — a boolean that will inevitably need a third state
class Order(models.Model):
    is_paid = models.BooleanField(default=False)
    # What about "partially paid"? "refunded"? "payment failed"?


# Good — explicit status
class PaymentStatus(models.TextChoices):
    UNPAID = "unpaid"
    PAID = "paid"
    PARTIALLY_REFUNDED = "partially_refunded"
    REFUNDED = "refunded"
    FAILED = "failed"
```

---

## Overloaded Status Fields

A single status field that encodes multiple independent dimensions.

```python
# Bad — status encodes both payment state and fulfilment state
class Order(models.Model):
    status = models.CharField(max_length=20)
    # "paid_shipped", "paid_unshipped", "unpaid_unshipped", ...


# Good — separate concerns into separate fields
class Order(models.Model):
    payment_status = models.CharField(max_length=20, choices=PaymentStatus.choices)
    fulfilment_status = models.CharField(max_length=20, choices=FulfilmentStatus.choices)
```

Two fields with 5 states each give you 25 combinations with 10 values. One combined field needs
25 separate values. Separate fields are easier to query, index, and reason about.

---

## The ID-or-Instance Parameter

A function that accepts either a primary key or the object it identifies.

```python
# Bad — every call site is ambiguous, and the body opens with a branch
def archive_order(order: Order | UUID) -> None:
    if isinstance(order, UUID):
        order = Order.objects.get(pk=order)
    order.archived_at = timezone.now()
    order.save()


# Good — pick one, and let the caller resolve
def archive_order(order: Order) -> None:
    order.archived_at = timezone.now()
    order.save()
```

The union costs more than the convenience returns. The two paths have **different query counts**
(one hits the database, one does not) and **different failure modes** (`DoesNotExist` raised
inside the function, or a stale instance passed in and written back over a newer row) — so the
caller cannot reason about either without reading the body. Every test doubles. The `isinstance`
branch is not domain logic and never becomes any.

Passing an identifier **instead of** an instance is a different thing and often right: across a
process boundary the instance is stale by construction, so a task takes the primary key and
re-reads it ([`../TASK-AUTHORING.md`](../TASK-AUTHORING.md)). That is one choice made
deliberately, not a signature that accepts both.

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
