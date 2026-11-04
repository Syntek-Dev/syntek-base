# Fixture — the owner, stating the absence-enum rule

This file is the registered owner of the `absence-enum` claim. Its statement is correct and must
not be a finding on its own.

```python
class VatNumberAbsence(StrEnum):
    NOT_SUPPLIED = "not-supplied"
    NOT_APPLICABLE = "not-applicable"
```
