# Release — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Version Bump

```text
/syntek-dev-suite:version bump [patch | minor | major]
```

This updates: `VERSION`, `VERSION-HISTORY.md`, `RELEASES.md`, `CHANGELOG.md`,
`code/src/backend/pyproject.toml`, `code/src/frontend/package.json`.

### Step 2 — Run Full Test Suite

```bash
docker compose exec backend pytest
docker compose exec frontend pnpm test
```

### Step 3 — Commit Version Files

```text
/syntek-dev-suite:git
```

### Step 4 — Deploy to Production

```bash
./production.sh
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
