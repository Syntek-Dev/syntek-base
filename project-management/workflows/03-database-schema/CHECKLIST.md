# Database Schema Design — Checklist

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] All entities and fields documented with types, nullability, and defaults
- [ ] Relationships described clearly (one-to-many, many-to-many, etc.)
- [ ] Index strategy documented for foreign keys and high-frequency query fields
- [ ] Migration strategy documented if altering existing data
- [ ] Schema aligns with `code/docs/DATA-STRUCTURES.md` conventions
- [ ] Document saved at `project-management/src/DATABASE/DB-<FEATURE>-DD-MM-YYYY.md`

---

## Definition of Done

- [ ] Schema reviewed and signed off before any model code is written
- [ ] Document committed and pushed
- [ ] `code/workflows/09-database-migration/` triggered as the next step
