---
workflow: 05-testing-and-coverage
phase: verify
skills: [qa-tester, global-workflow]
model: opus
---

# Testing & Coverage — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Reference guides** (CLI-TOOLING.md) · **Cross-layer references** (`code/docs/testing/COVERAGE.md`) · **External — Debugging** (pytest).

## Before

- [ ] Stack running and migrations current — environment failures ruled out first · _opus_
- [ ] The suite chosen matches the change (api for a contract, e2e for a page, mutmut for a doubted suite) · _opus_

## Running

- [ ] Every run went through `code/src/scripts/tests/*.sh` — no bare `pytest` · _opus_
- [ ] Core suite green before coverage was considered · _opus_
- [ ] Optional suites run where the change warranted them · _opus_

## Coverage

- [ ] Line coverage ≥ **75%** · _opus_
- [ ] Branch coverage ≥ **75%** — both sides of every `if`/`else` · _opus_
- [ ] Auth-related code ≥ **90%** · _opus_
- [ ] No floor was lowered to make the run pass · _opus_
- [ ] Assertions come from an independent source of truth, not recomputed the way the code computes them · _opus_
- [ ] Assertions go through the public interface, not private methods or internal fields · _opus_

## After

- [ ] Any failure routed to the right workflow (environmental → `08-debugging`; logical → `code/workflows/10-debug/`) · _opus_
- [ ] Coverage reports left in `code/src/scripts/tests/reports/` — generated, gitignored, never committed · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
