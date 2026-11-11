# Fixture — a shape guide restating the absence-enum rule

A guide that owns what shape a value has states, by example, the rule that owns what an absence
means. Trips `doctrine-restated`.

```python
class DeliveryAbsence(Enum):
    NOT_YET = "not-yet"
    NOT_APPLICABLE = "not-applicable"
```
