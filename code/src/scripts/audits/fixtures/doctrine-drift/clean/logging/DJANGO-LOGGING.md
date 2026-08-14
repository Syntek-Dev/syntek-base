# Fixture — a logging guide that shows only the logging

The handler body is elided, because the response shape belongs to the guide that owns it.

```python
@api.exception_handler(ValidationError)
def on_validation_error(request, exc):
    logger.info("api validation error", extra={"path": request.path})
    return api.create_response(request, VALIDATION_ENVELOPE, status=422)
```
