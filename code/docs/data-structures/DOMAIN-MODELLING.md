---
type: guide
agent: database
skills: [stack-django]
model: opus
---

# Data Structures — Domain Modelling

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Domain-driven modelling, ubiquitous language, business-aligned model naming

---

## Models Reflect the Business

A domain model should use the same language as the business. If stakeholders call it a "booking",
the model is `Booking`, not `Reservation`. If the business distinguishes between a "lead" and a
"customer", those are two models, not one model with a `type` field.

```python
class Booking(models.Model):
    guest = models.ForeignKey("Guest", on_delete=models.CASCADE)
    property = models.ForeignKey("Property", on_delete=models.CASCADE)
    check_in = models.DateField()
    check_out = models.DateField()
    status = models.CharField(max_length=20, choices=BookingStatus.choices)
```

**Bad — generic names that do not communicate intent:**

```python
class Item(models.Model):
    data = models.JSONField()
    type = models.CharField(max_length=50)
    ref = models.CharField(max_length=100)
```

---

## Value Objects

A value object is a small, immutable object defined by its attributes rather than its identity.
Use them for concepts like money, addresses, date ranges, and coordinates.

**Python:**

```python
from dataclasses import dataclass
from decimal import Decimal

@dataclass(frozen=True)
class Money:
    amount: Decimal
    currency: str

    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("Amount cannot be negative")
        if len(self.currency) != 3:
            raise ValueError("Currency must be a 3-letter ISO code")

    def add(self, other: "Money") -> "Money":
        if self.currency != other.currency:
            raise ValueError(f"Cannot add {self.currency} and {other.currency}")
        return Money(amount=self.amount + other.amount, currency=self.currency)
```

---

## Enumerations and Status Fields

Use explicit enumerations for any field with a fixed set of valid values. Never use raw strings or
magic numbers.

```python
class BookingStatus(models.TextChoices):
    PENDING = "pending", "Pending"
    CONFIRMED = "confirmed", "Confirmed"
    CHECKED_IN = "checked_in", "Checked In"
    CANCELLED = "cancelled", "Cancelled"

class Booking(models.Model):
    status = models.CharField(
        max_length=20, choices=BookingStatus.choices, default=BookingStatus.PENDING,
    )

    def confirm(self):
        if self.status != BookingStatus.PENDING:
            raise ValueError(f"Cannot confirm a booking with status {self.status}")
        self.status = BookingStatus.CONFIRMED
        self.save(update_fields=["status"])
```

State transitions should be explicit methods on the model or service, not arbitrary string
assignments.

---

## Aggregates and Boundaries

An aggregate is a cluster of domain objects treated as a single unit for data changes. External
code interacts with the aggregate root, never directly with its internals.

```python
class Order(models.Model):
    """Aggregate root. All modifications to order lines go through Order methods."""
    customer = models.ForeignKey("Customer", on_delete=models.CASCADE)
    status = models.CharField(max_length=20, choices=OrderStatus.choices)

    def add_line(self, product: "Product", quantity: int) -> "OrderLine":
        if self.status != OrderStatus.DRAFT:
            raise ValueError("Cannot modify a non-draft order")
        return OrderLine.objects.create(
            order=self, product=product, quantity=quantity, unit_price=product.price,
        )

    @property
    def total(self) -> Decimal:
        return sum(
            (line.unit_price * line.quantity for line in self.lines.all()),
            Decimal("0.00"),
        )


class OrderLine(models.Model):
    """Part of the Order aggregate. Never modify directly — use Order methods."""
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="lines")
    product = models.ForeignKey("Product", on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField()
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
```

If you find yourself writing `OrderLine.objects.create(...)` outside of the `Order` model, the
aggregate boundary is being violated.

---

## Django Ninja Schemas as Domain Contracts

A Django Ninja response `Schema` should reflect the domain, not the raw database row. A consumer
should not need to perform calculations or follow foreign keys. Compute derived fields with
`resolve_<field>` methods, and expose domain names rather than column names. Ninja publishes the
resulting contract as OpenAPI at `/api/docs`.

```python
from decimal import Decimal
from ninja import Schema


class OrderLineOut(Schema):
    product_name: str       # domain field, not product_id
    quantity: int
    line_total: Decimal     # computed, not unit_price


class OrderOut(Schema):
    id: int
    status: str
    total: Decimal
    can_be_cancelled: bool
    lines: list[OrderLineOut]

    @staticmethod
    def resolve_can_be_cancelled(obj) -> bool:
        return obj.status in ("pending", "confirmed")
```

The endpoint declares the schema as its `response`, so the contract is enforced on the way out:

```python
@router.get("/orders/{order_id}", response=OrderOut)
def get_order(request, order_id: int):
    # Every state-changing endpoint needs an explicit permission check;
    # a read like this still verifies ownership to prevent IDOR.
    return get_order_for_user(request.auth, order_id)
```

---

## The template is a consumer of the domain, not a second model

There is no client-side type layer to keep in step — the template renders the same Python objects
the services return. That removes a whole class of drift, but it introduces a different failure
mode: **the template quietly becomes the place the domain logic lives.**

```django
{# WRONG — the template is now deciding what "cancellable" means #}
{% if order.status == "pending" or order.status == "confirmed" %}
  <button>Cancel order</button>
{% endif %}
```

```python
# CORRECT — the rule lives on the aggregate; the template asks it
class Order(models.Model):
    @property
    def can_be_cancelled(self) -> bool:
        return self.status in (OrderStatus.PENDING, OrderStatus.CONFIRMED)
```

```django
{% if order.can_be_cancelled %}<button>Cancel order</button>{% endif %}
```

The test is simple: **a template may ask a question, never answer one.** A comparison, an
arithmetic expression, or a compound condition in a template is a domain rule that has escaped its
model — and one that no test will catch, because template logic is the least-tested code in the
project.

Where the same computed value is needed by both a template and a Ninja endpoint, put it on the
model or the service and let the `Schema` resolve it (above) — one definition, two consumers.

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
