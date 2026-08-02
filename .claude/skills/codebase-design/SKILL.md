---
name: codebase-design
description: >-
  The shared architecture vocabulary and design principles for <%PROJECT_NAME%> — module, interface,
  implementation, depth, seam, adapter, leverage, locality, and the rules that go with them (the
  deletion test, "the interface is the test surface", "one adapter is a hypothetical seam, two are
  real", design it twice). Load when reasoning about module depth during architecture, refactor, or
  review — or when the `improve-codebase-architecture` skill needs the vocabulary or its
  design-it-twice parallel sub-agent pattern. Cited by the refactor, review, planner, and
  code-reviewer agents. The canonical write-up is `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`.
---

# Codebase Design

The project's design vocabulary for talking about **depth** — putting a lot of behaviour behind a
small interface at a clean seam. Use these terms exactly, in every suggestion, review comment, and
plan. When a term isn't here, reach for one that is before inventing a new one.

Canonical source: **`code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`** ("Deep modules") and
**`code/docs/CODING-PRINCIPLES.md`** (YAGNI, CUPID, DDD). This skill is the portable summary the
agents load; the doc is the authority — keep them in step.

## Vocabulary — use exactly

- **module** — a unit that hides an implementation behind an interface. In this codebase a module is
  concrete: a **service** function/class (`apps/*/services/`), a Django Ninja endpoint, a
  django-component, an RLS predicate, a middleware. "Module" is the design noun; the artefact is the
  thing.
- **interface** — the surface a caller must learn: the public methods, their names and signatures.
- **implementation** — everything hidden behind the interface.
- **depth** — **leverage per unit of interface learned**. A deep module hides a multi-step
  operation, its transaction, and its side effects behind one method. Widening the interface to look
  substantial is the opposite of depth.
- **deep** / **shallow** — deep = small interface over large implementation. **Shallow** = interface
  nearly as complex as the implementation (a pass-through that forwards to the ORM adds no depth).
- **seam** — the boundary a module hides behaviour behind. A good seam is where the domain already
  has a name (read `CONTEXT.md` for the name before you invent one).
- **adapter** — one concrete implementation behind a seam (e.g. `StaffChatPolicy` behind the
  `ChatAccessPolicy` seam).
- **leverage** — one interface, N call sites. The payoff of depth: learn the interface once, reuse
  it everywhere.
- **locality** — related behaviour, and the bugs in it, concentrated in one module rather than
  smeared across call sites. Extracting a pure function for testability while the real bugs hide in
  how it's called trades locality away — a shallow move.

**Never substitute:** component / unit (for module, when you mean the design concept) · API,
signature (for interface) · boundary (for seam) · layer, wrapper (for a shallow module). "Service"
is a real project layer — keep it for the concrete artefact, not as a loose synonym for module.

## Principles — apply exactly

- **The deletion test.** Delete the module and inline it. If the same complexity reappears across N
  callers, it earned its keep. If nothing reappears, it was padding a seam that did not exist. A
  "yes, concentrates complexity" is the signal that a deepening is real.
- **The interface is the test surface.** Test a module through its public methods, never its
  internals. A test that must reach past the interface is telling you the boundary is wrong.
- **One adapter is a hypothetical seam; two adapters are a real seam.** Do not introduce an
  abstraction (base class, Protocol, strategy) until a second implementation actually varies — YAGNI
  (`code/docs/CODING-PRINCIPLES.md`). The `ChatAccessPolicy` Protocol earns its seam: `StaffChatPolicy`
  **and** `ClientSupportPolicy` vary behind it (plus `NullChatAccessPolicy` as the test double).
- **Design it twice.** For any non-obvious interface, sketch 2–3 radically different shapes before
  writing the implementation — one that minimises the interface, one that maximises flexibility, one
  that optimises the common caller — and choose between them. The parallel pattern is below.

## Anchors in this codebase (deep seams to reason from)

- **Service layer over thin endpoints** — business logic in `apps/*/services/`; the endpoint is a
  shallow adapter. The deletion test passes: inline a service and its transaction + audit + side
  effects reappear at every caller (`code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`).
- **`presentation.serialize_message` — the single decrypt boundary** in `apps/chat`: one seam owns
  decrypt + `public_id` mapping; nothing else decrypts.
- **The RLS `set_config('app.current_user_id', …)` context** — membership isolation hidden behind a
  per-transaction seam, not re-derived in every query (`code/docs/RLS-GUIDE.md`).
- **`EncryptedTextField`** — the whole Fernet pipeline behind a field interface
  (`code/docs/ENCRYPTION-GUIDE.md`).

## Design-it-twice parallel sub-agent pattern

When the interface is non-obvious (a new deepened module, a reshaped seam), design it twice
_in parallel_, then choose — do not iterate one shape:

1. Frame the module: its one job, its callers, the constraints (read the area's `CONTEXT.md` and any
   ADR first, so you don't re-litigate a settled decision).
2. Spawn 2–3 sub-agents with the **Agent tool** (`planner`, or `general-purpose`), one per angle:
   - **Minimal interface** — the smallest surface a caller could learn.
   - **Maximal flexibility** — the shape that absorbs the most future variation.
   - **Optimise the common caller** — the shape the dominant call site wants.
     Each returns: the interface sketch, what sits behind the seam, which tests survive, and the
     deletion-test verdict.
3. Judge across the three: pick the deepest shape that passes the deletion test and keeps the
   interface the test surface. Graft the best idea from the runners-up. One adapter only? Collapse
   the abstraction — YAGNI.

## When a decision crystallises

Naming a deepened module after a new concept, or settling a load-bearing trade-off, is a domain-model
change — run **`.claude/skills/domain-modelling`** to record it (add the term to the nearest
`CONTEXT.md`; offer an ADR for a decision future reviews must not re-suggest). Refresh the
code-review-graph after the doc change so structure and docs stay in lockstep
(`code/docs/CODE-REVIEW-GRAPH.md`).

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/11-refactor/` — reasoning about module depth before restructuring
- `code/workflows/07-review/` — the review lens on seams and boundaries
- `project-management/workflows/13-decisions/` — the vocabulary an ADR's options are argued in

## Cross-references

- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — the canonical "Deep modules" write-up
- `code/docs/ARCHITECTURE-PATTERNS.md` — the governing architecture guide (entry point)
- `code/docs/CODING-PRINCIPLES.md` — YAGNI, CUPID, DDD, function-length limits
- `.claude/skills/domain-modelling/SKILL.md` — record the names and decisions this design produces
- `.claude/skills/improve-codebase-architecture/SKILL.md` — the review that surfaces deepenings
