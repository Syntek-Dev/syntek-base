# Fixture — the competing spelling

The real instance: a logging guide carrying an API response body, in a shape no other guide
uses. Every file here is internally consistent, which is why nothing caught it.

Trips `doctrine-banned`.

```python
@api.exception_handler(ValidationError)
def on_validation_error(request, exc):
    return api.create_response(request, {"detail": exc.errors}, status=422)
```
