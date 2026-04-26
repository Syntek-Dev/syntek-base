# api/performance

**Last Updated**: 24/04/2026
**Version**: 1.0.0
**Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Directory Structure

```text
performance/
├── CONTEXT.md
├── load_test_endpoints.bru   # Runs key endpoints under sustained load
└── stress_test.bru           # Large page-size query to find breaking point
```

---

## Purpose

Bruno performance test request templates. Verify response time thresholds for health check and high-traffic endpoints.

---

## Notes

- Parent: `../CONTEXT.md`
- Run via Bruno CLI with `--reporter-json` to capture results for CI performance gates
- Performance thresholds are defined per request in the `.bru` scripts
- Integrate with the `api-tests.yaml` CI pipeline for automated performance gates
