# code/docs/architecture

Sub-documents for architecture patterns. Covers auth contracts, core scaling decisions, frontend state and routing, and service layer architecture.

## Directory Tree

```text
code/docs/architecture/
├── CLAUDE.md                 ← operating rules
├── CONTEXT.md                ← this file
├── AUTH-CONTRACT.md          ← AdminMember/ModulePermission auth contract
├── BUILD-OPERATE-SEAM.md     ← Build / operate / deploy ownership, the two bridge shapes
├── CORE-AND-SCALING.md       ← Decisions to settle before the first migration; scaling phase-gates
├── FRONTEND-PATTERNS.md      ← Frontend state (Django/HTMX/Alpine), routing, project structure
├── PROVIDER-NEUTRALITY.md    ← Seam vs substrate, the two evidence bars, how a guide expresses it
└── SERVICE-AND-MIDDLEWARE.md ← Service layer design and middleware patterns
```

## Cross-references

- `code/docs/ARCHITECTURE-PATTERNS.md` — the index these sub-documents belong to
- `code/docs/DISCOVERABILITY.md` — the SEO, JSON-LD and `.well-known` doctrine that used to live
  in `FRONTEND-PATTERNS.md`; routing for a marketing page is decided here, its `<head>` there
