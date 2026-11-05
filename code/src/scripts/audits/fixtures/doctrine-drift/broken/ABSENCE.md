# Fixture — the owner, stating the absence-enum rule

This file is the registered owner of the `absence-enum` claim. Its statement is correct and must
not be a finding on its own.

```python
class VatNumberAbsence(Enum):
    NOT_SUPPLIED = auto()
    NOT_APPLICABLE = auto()
```
