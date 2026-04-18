# TDD Cycle — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Phase 1 — Red (Write Failing Tests)

```text
/syntek-dev-suite:test-writer [scope of work] --mode failing-first
```

Verify tests are red:

```bash
# Backend
docker compose exec backend pytest tests/<module>/ -v

# Frontend
docker compose exec frontend npm test -- --run
```

Do not proceed to Phase 2 until all new tests are red.

### Phase 2 — Green (Minimal Implementation)

```text
/syntek-dev-suite:backend [scope]   # for backend
/syntek-dev-suite:frontend [scope]  # for frontend
```

Write the **minimum** code to make tests pass. No gold-plating.

Run tests again — all must be green.

### Phase 3 — Refactor

```text
/syntek-dev-suite:refactor [scope]
```

Improve readability and structure. No new behaviour. Tests must remain green after refactor.

### Step 4 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
