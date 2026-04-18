---
description: Run backend and frontend test suites
usage: /test
---

Run the full test suite for both backend (pytest) and frontend (Vitest).

**Run:** `./test.sh`

**Backend only:**

- All tests: `docker compose exec backend pytest`
- With coverage: `docker compose exec backend pytest --cov=apps`
- Filter: `docker compose exec backend pytest -k "$ARGUMENTS"`

**Frontend only:**

- All tests: `docker compose exec frontend npm test`
- With coverage: `docker compose exec frontend npm run test:coverage`
- Watch mode: `docker compose exec frontend npm test -- --watch`

$ARGUMENTS
