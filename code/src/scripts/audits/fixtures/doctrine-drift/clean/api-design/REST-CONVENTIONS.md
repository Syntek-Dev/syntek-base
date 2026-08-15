# Fixture — a guide that routes instead of restating

The error envelope is owned elsewhere and is not stated here. This file exists to prove two
things the scanner must get right.

**One: prose may discuss a rule freely.** There was a `{ "data": ... }` success envelope here
until it was retired, and narrating that is how the current rule stays legible. A guide that
cannot describe its own history loses the reasoning behind it. None of this is a finding.

**Two: an example that is not the rule is still allowed.** A success response is its schema:

```json
{
  "id": "ord_abc123",
  "status": "confirmed"
}
```
