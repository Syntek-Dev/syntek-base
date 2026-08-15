---
type: guide
skills: [database, stack-django, code-reviewer]
model: opus
---

# Types Over Dictionaries — When a Dictionary Is Right

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the legitimate uses, the confinement policy, and the `DICT-OK:` hatch

> **Forward-looking.** The Django surface ships no domain models, services or endpoints at
> baseline — `apps/core` holds the schema bases, the middleware, the error tree and the
> management-command base, and nothing else. This guide is the standard the first one is built
> to, not a description of code that exists.

The rule is stated by its sibling, and quoted here once because the exceptions are unreadable
without it:

> A dictionary is a data structure, not a type. When a set of keys is known at design time and
> carries meaning in the domain, it is a named type with named fields. Dictionaries are for keys
> that are genuinely data — unknown, dynamic, or supplied by the outside world.

A rule with no worked exceptions becomes cargo cult: reviewers start rejecting a `Counter`, and
authors start wrapping a lookup table in a class to get past them. This guide is the other half —
where a dictionary is the **right** answer, how far it may travel, and the one marker that makes a
deliberate choice legible to the next reader.

---

## The seven legitimate uses

### 1. Keys that are genuinely data

User-defined metadata, tag and attribute maps, translation catalogues, feature flags loaded at
runtime. The keys are the user's, not yours.

```python
def render_attributes(attributes: dict[str, str]) -> str:
    """`attributes` are the tenant's own field names, invented after this code shipped."""
    return "; ".join(f"{name}: {value}" for name, value in sorted(attributes.items()))
```

**Why a type would be worse:** a named field per key means a deploy every time a tenant invents a
tag. The set is open by design, and a type would freeze it.

### 2. A true mapping or index

An id-to-object lookup, a cache, a memoisation table, grouping and aggregation results, counters
and frequency tables. The dict **is** the algorithm.

```python
orders_by_id = {order.pk: order for order in orders}
lines_by_order = defaultdict(list)
for line in lines:
    lines_by_order[line.order_id].append(line)
```

**Why a type would be worse:** the keys are runtime values from the data. Naming them would fix
at design time exactly the set the lookup exists to keep open.

On the mobile surface the compiler already draws the line for you. `noUncheckedIndexedAccess`
(`code/src/mobile/tsconfig.json`) types every **index read** as `T | undefined`, which is
**correct** for a lookup — the key may be absent — and intolerable for a domain concept, where
every call site pays for a check the shape guarantees:

```typescript
const byId: Record<string, Order> = {};
for (const order of orders) {
  byId[order.id] = order;
}
const found = byId[id]; // Order | undefined — the flag is right, because a miss is real
```

The **value** type stays named even so: `Record<string, Order>` is an index,
`Record<string, unknown>` is an undeclared record and a clause `T1` finding.

### 3. The serialisation boundary, both directions

The moment before encoding to JSON, and the moment after decoding — **inside the boundary layer
only**. A payload arrives as a dict because that is what the codec produces; it stops being one on
the next line.

```python
from apps.core.schemas import OutSchema, Schema


class OrderIn(Schema):
    reference: str
    quantity: int


class OrderOut(OutSchema):
    reference: str


# DICT-OK: the decoded request body — confined to this function, which is the parse boundary
def accept(payload: dict[str, object]) -> Order:
    order_in = OrderIn.model_validate(payload)  # the dict dies here
    return create_order(reference=order_in.reference, quantity=order_in.quantity)


body = OrderOut.model_validate(order, from_attributes=True).model_dump()  # and is born here
```

**Why a type would be worse:** it would not be — a type is exactly what sits on both sides. The
dictionary's licence is that it exists only in the two lines either side of the codec. A parse
failure here is a **user error** (`ServiceError` tree, 422 on schema), not a broken invariant; the
taxonomy is [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)'s.

### 4. An opaque third-party payload

One this codebase neither owns nor interprets. Inventing a type for it is a lie about how stable
the shape is.

```python
# code/src/django/tests/e2e/test_e2e_a11y.py
AXE_OPTIONS: dict[str, Any] = {"runOnly": {"type": "tag", "values": list(AXE_TAGS)}}
violations: list[dict[str, Any]] = results.get("violations", [])
```

**Why a type would be worse:** axe-core versions its own result shape. A `TypedDict` here claims a
stability nobody promised, and breaks on the next upstream field.

**Not this, in the same file — and no longer there.** The scan fixture used to stash
`page.__dict__["_scan_project"]`: an undeclared private key on somebody else's object, read back
by the same literal three lines later. It is now a frozen `ScannedPage` record pairing the page
with its project. The vendor's payload is opaque; our own bookkeeping never was.

### 5. Configuration before validation, and `**kwargs` where the receiver owns the contract

Environment and settings maps are dictionaries until something validates them into a typed
settings object. A pass-through signature stays untyped when the **receiver** defines the
contract, not the caller.

```python
# code/src/django/apps/core/management/base.py
def execute(self, *args: Any, **options: Any) -> Any:
    close_old_connections()
    return super().execute(*args, **options)
```

**Why a type would be worse:** the signature is Django's. Narrowing it breaks `call_command()`,
which hands through whatever options a caller names ([`../MANAGEMENT-COMMANDS.md`](../MANAGEMENT-COMMANDS.md)).

### 6. Sparse or measured-hot

**Sparse or high-cardinality data**, where a fixed struct would be mostly empty — an override
table covering a fraction of a large key space, a permission matrix with a handful of exceptions.

```rust
// DICT-OK: sparse override table — confined to nativecore
let overrides: HashMap<u32, u8> = HashMap::new();
```

**A measured hot path**, where object allocation is demonstrably the bottleneck. **Measured** is
load-bearing: a profile in the pull request, or it is not this exception. "It felt faster" is not
an exception, it is the anti-pattern with a story attached.

**Why a type would be worse:** in the sparse case, a struct pays for every absent key; in the hot
case, the profile is the evidence, and without one there is nothing to weigh against the cost.

### 7. Test fixtures and throwaway scripts

The value is local, short-lived, and read by the person who wrote it in the same sitting.

```python
def test_rejects_negative_quantity(client):
    response = client.post("/api/orders", json={"reference": "A1", "quantity": -1})
    assert response.status_code == 422
```

**Why a type would be worse:** a fixture type is a second model of the domain that has to be kept
in step with the first, and it hides the literal the test is about.

**Not this.** The audit's first two findings were one shape twice: a module-level
`dict[str, dict[…]]` matrix in `code/src/django/tests/e2e/a11y_config.py`, and another in
`code/src/django/tests/e2e/conftest.py`, each read by literal key from a **different** module
(`project["viewport"]`). Shared, long-lived, and undocumented at the point of use — and
`a11y_config.py` already modelled `Suppression` as a `TypedDict`, so one module carried both
conventions. Both are typed now, against `Viewport` and `ScanProject` in
`code/src/django/tests/e2e/browser_types.py`. Being test code is not the exception; being
throwaway is.

---

## The confinement policy

A dictionary is acceptable only while **all three** hold:

1. It does not escape the layer that created it.
2. It is not the vehicle for a domain concept.
3. It does not require the caller to know undocumented keys.

**Two or more violated and it is a domain object.** One violated is a conversation; two is a
finding.

It is three tests rather than one because each is the failure mode of a **different reader**:

| Test        | Whose failure                                                                                             |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| **Escape**  | The **maintainer** — the shape is decided in one place and read in five, so no edit is ever provably safe |
| **Concept** | The **domain** — a concept with no name cannot be searched for, tested against, or reviewed as a whole    |
| **Keys**    | The **caller** — the contract lives in the producer's body, so every consumer reads it to use it          |

Collapsing them into a single "is it dynamic?" question loses two of the three. A dictionary can
have genuinely dynamic keys and still be a domain concept wearing a map (a pricing table), or be
perfectly confined and still make its caller guess (an internal helper returning
`{"ok": …, "reason": …}`).

**Scored against what the audit actually found**, so the tests read as a procedure rather than a
slogan. The first two rows are the code as it stands; the last two are the code **as the audit
found it**, both since converted:

| Dictionary                             | Escapes?        | A concept?         | Undocumented keys?         | Ruling                                 |
| -------------------------------------- | --------------- | ------------------ | -------------------------- | -------------------------------------- |
| `AXE_OPTIONS` (`test_e2e_a11y.py`)     | no — one module | no — a vendor call | no — axe-core documents it | **keep**, use 4                        |
| `**options` (`management/base.py`)     | no — passed on  | no — a call frame  | no — Django's contract     | **keep**, use 5                        |
| `SCAN_PROJECTS` (`e2e/a11y_config.py`) | **yes**         | **yes** — a matrix | **yes** — `["viewport"]`   | three of three → `tuple[ScanProject]`  |
| `VIEWPORTS` (`e2e/conftest.py`)        | **yes**         | **yes** — a matrix | **yes**                    | three of three → `dict[str, Viewport]` |

Note what the last row did **not** become. `VIEWPORTS` is still a dictionary, because the name a
test parametrises over is a genuine lookup key — use 2, and its own comment says so. What changed
is the **value**: a bare `{"width": …, "height": …}` was a record with known keys wearing a map.
That is the commonest ruling of all — the mapping was fine, the record inside it was not.

The two were the same defect twice — backlog rows 1 and 2 in
[`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md) — and the fix was already sitting in the
file beside them: the `Suppression` `TypedDict` in `a11y_config.py` showed what a matrix there
looks like. That is the tell worth learning. **A module that models one of its structures and not
the other** has not made a judgement; it has made two decisions on different days.

---

## The escape hatch

A dictionary that is one of the seven, but does not look like it at a glance, carries a marker:

```text
DICT-OK: <reason> — confined to <boundary>
```

| Surface         | Comment syntax | Example                                                                 |
| --------------- | -------------- | ----------------------------------------------------------------------- |
| Python          | `#`            | `# DICT-OK: axe-core result shape — confined to the e2e suite`          |
| TypeScript      | `//`           | `// DICT-OK: caller-supplied analytics props — confined to the tracker` |
| Rust            | `//`           | `// DICT-OK: sparse override table — confined to nativecore`            |
| JavaScript      | `//`           | `// DICT-OK: HTMX's own event.detail — confined to this handler`        |
| Django template | `{# #}`        | `{# DICT-OK: the view's own context map — confined to this template #}` |

**The reason is mandatory.** A bare `DICT-OK:` with nothing after it is itself a finding, on the
house rule the `slop-allow` and `token-allow` annotations already carry: an annotation carries a
reason or it is not an annotation (`code/src/scripts/audits/CLAUDE.md`). A marker with no words
after it is indistinguishable from someone silencing an audit they did not read.

**The boundary is mandatory.** "Confined to the parser" is a claim a reviewer can check by
opening the parser. "Confined to the codebase" is not a boundary, and neither is an empty one.

**It goes on the line, or the line above it** — the placement the `slop-allow` and `token-allow`
annotations already use, so there is one convention to remember rather than three. Which of the
seven uses is being claimed goes in the reason: `sparse`, `opaque payload`, `index` and so on read
back as a category, and a reason that names no category is usually one that has none.

**It is greppable on purpose** — the register of every deliberate dictionary in the project is one
command, not a memory:

```bash
grep -rn "DICT-OK:" code/src/
```

**Anything without the marker, outside the seven uses, is a review blocker.** Not a warning, not a
follow-up ticket: the change does not merge.

**It is never used to defer real modelling debt.** A dictionary that should be a type and is not
yet goes on the migration backlog in
[`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md), where it is visible and dated. The
marker says "this is correct"; the backlog says "this is not, yet". Using the first to mean the
second is how a standard rots.

---

## The gate

`code/src/scripts/audits/dict-discipline.sh` enforces the decidable half. Being honest about which
half that is, is what stops the script being trusted for judgements it cannot make.

**What a script can decide:**

- A bare `dict` return or a `dict[str, Any | object]` annotation in domain code — clauses `P1`
  and `P2`, the shape [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md) files under _Implicit Schema_ — plus
  legacy `typing.Dict` (`P3`).
- `HashMap<String, Value>` and `serde_json::Value` in Rust (`R1`, `R2`); `Record<string, any>`,
  the bare `object` type and `{ [key: string]: … }` index signatures in TypeScript (`T1`, `T2`).
- A `DICT-OK:` marker with **nothing after the colon** — clause `M`, the one clause no marker can
  suppress, because it _is_ the suppression check.

**What a script cannot decide:**

- **Whether the keys are genuinely dynamic.** `dict[str, str]` is identical in the source whether
  the keys are a tenant's invented tags or four field names somebody could not be bothered to
  declare.
- **Whether the dictionary escapes its layer.** Following a value across call sites is the
  reviewer's job, and the first of the three confinement tests is exactly that.
- **Whether a boundary is named at all, or is true.** Clause `M` fires on an empty marker and
  nothing more, so `DICT-OK: because` passes the script and fails review. The `confined to` half
  is a review rule; the marker's text is prose either way.
- **Anything under `tests/`, which it prunes** — along with `migrations/` and `__tests__/`, on
  use 7. Every worked example above therefore sits outside its scope: the audit that found them
  was a reading, not a run.

The undecidable half is why the confinement policy above exists as a review checklist rather than
as three more clauses.

**Self-guarding, and self-tested.** The script exits 0 with a note where its surface is absent, on
the house convention (`code/src/scripts/audits/CONTEXT.md`). It also carries `--self-test`, which
runs every clause over a known-positive and known-negative fixture pair — because this repository
ships almost no application code, and an ordinary run would be green for the whole life of the
rule having measured nothing. **A gate you have never watched fail is not a gate**
(`code/src/scripts/audits/CLAUDE.md`); fix the detector, never the fixtures.

---

## Cross-references

- [`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md) — the rule these are the exceptions
  to, the enum test, and the migration backlog
- [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md) — the failure shapes this guide's exceptions are measured
  against; owner of every one of them
- [`DOMAIN-MODELLING.md`](DOMAIN-MODELLING.md) — what a domain concept becomes once the second
  confinement test fails
- [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) — the three-class error taxonomy a boundary parse
  failure is classified under
- [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 3 — branded ID types
  **declined at baseline**, with the recorded trigger (they arrive with the mobile API client, at
  the one point that parses a response). Do not mandate them ahead of it
- [`../api-design/NINJA-CONVENTIONS.md`](../api-design/NINJA-CONVENTIONS.md) — the schema bases
  that make use 3's boundary a single line
- `code/src/scripts/audits/CLAUDE.md` — the annotation-carries-a-reason and watched-it-fail rules
  this guide's marker and gate inherit

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
