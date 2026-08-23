# code/docs/data-structures

Sub-documents for data structures and schema design. Covers anti-patterns, domain modelling,
fundamentals, refactoring techniques, database schema design, and the six-part
**types-over-dictionaries** standard.

Two groups, and the split matters when deciding where a rule belongs. The **original six**
describe how to think about data — what a good structure is, what a bad one looks like, and how a
PostgreSQL schema expresses either. The **`TYPES-*` family** is narrower and harder: one mandatory
rule, its exceptions, and its expression per surface, with a script behind it.

## Directory Tree

```text
code/docs/data-structures/
├── CLAUDE.md                   ← operating rules
├── CONTEXT.md                  ← this file
├── ANTI-PATTERNS.md            ← Common data structure anti-patterns and how to avoid them
├── DOMAIN-MODELLING.md         ← Domain-driven design and modelling techniques
├── FUNDAMENTALS.md             ← Core data structure concepts and principles
├── REFACTORING.md              ← Techniques for refactoring toward better structures
├── SCHEMA-DESIGN.md            ← Database schema design best practices
├── SCHEMA-MIGRATIONS.md        ← Migrating a deployed database — column additions, backfills, locks, maintenance windows
│   ── the types-over-dictionaries family ──
├── TYPES-OVER-DICTIONARIES.md  ← the standard: the principle, the enum test, the migration backlog, the checklist
├── TYPES-EXCEPTIONS.md         ← when a dictionary IS right — the seven uses and the DICT-OK: escape hatch
├── TYPES-PYTHON.md             ← the Django surface: dataclasses, NewType, TypedDict, StrEnum, match
├── TYPES-TYPESCRIPT.md         ← MOBILE-ONLY — discriminated unions, as const, unreachable()
├── TYPES-RUST.md               ← RUST-ONLY — newtypes, enums with data, the serde wire/domain seam
└── TYPES-BROWSER.md            ← Alpine.data contracts, frozen constants, the HTMX view-model pair
```

## Which file answers which question

| Question                                                 | File                          |
| -------------------------------------------------------- | ----------------------------- |
| Is this shape a known mistake, and what is the refactor? | `ANTI-PATTERNS.md`            |
| Should this be a type or a dictionary?                   | `TYPES-OVER-DICTIONARIES.md`  |
| I think this dictionary is legitimate — is it?           | `TYPES-EXCEPTIONS.md`         |
| How do I spell it in this language?                      | the `TYPES-<surface>.md` file |
| What should this concept be called?                      | `DOMAIN-MODELLING.md`         |
| Which structure is fastest for this operation?           | `FUNDAMENTALS.md`             |
| How does the database store it?                          | `SCHEMA-DESIGN.md`            |

## Cross-references

- `code/docs/DATA-STRUCTURES.md` — the index these sub-documents belong to
- `code/src/scripts/audits/dict-discipline.sh` — the gate behind the `TYPES-*` family
- `code/docs/NEGATIVE-SPACE.md` — the error taxonomy a boundary parse failure is classified by
