# project-management/workflows — Step-by-Step PM Guides

**Last Updated**: <%DATE%>

Twenty-four numbered procedures, and here the numbers really are the running order: `02`–`15`
run per story, `15`–`16` per sprint, `17` once the backlog is planned, and `18`–`23` build and
ship it.

## Why this layer exists

**A human thinks the work through before any code is written.** That is the whole bet.
Every gate here — schema, flow, brand, components, wireframes, GDPR, security, QA, SEO,
API contract, the decision records, the plans — exists so that by the time implementation
starts there is nothing left to decide. Done properly, writing the code becomes the easy
part: mechanical, unsurprising, and fast, because every question that would have stalled
it was answered upstream by a person.

The cost is real and worth stating plainly. This assumes genuine project-management and
software-development knowledge — it is built for someone who has it. Someone who does not
can still use it: the numbered gates, their `STEPS.md`, and their `CHECKLIST.md` carry you
through the questions you would not have known to ask. You will move slower and lean
harder on the grilling passes, and the output will still be a designed system rather than
an accreted one.

If that is too much for what you are doing — a spike, a proof of concept, a question you
want answered in an hour — use `/prototype` instead. The process is not the only option.

## Before the first feature — describe it, then size it

Two things run **once per project**, upstream of everything numbered here
(`how-to/workflows/01-first-time-setup/` Steps 7–8):

1. **Describe the project.** The brief in the root `CONTEXT.md` — what it does, who for, what it
   replaces, what it deliberately is not. It is the first thing every agent reads in every
   session, and the thing every scope decision is eventually measured against.
2. **Plan scale and architecture** — `/scale-planning`. Not for the server sizing, but for the
   questions it forces while everything is still cheap to change: how many users, what the
   read/write mix is, which scaling phase-gate the design must not foreclose.

The second is where **required versus not required** gets settled. A project sized for hundreds
of users does not need what one sized for hundreds of thousands needs, and knowing which you are
building is what stops the first feature carrying machinery it will never use. Answer these
after ten features and you are answering them against decisions already made.

## The planning cadence

**Plan one story at a time, all the way through.** Take a single user story from
`02-story-creation` through to `15-decisions` before starting the next one. Do not batch:
do not write every story, then every schema, then every flow.

The reason is compounding. Story 2 is planned with everything story 1 settled already in
hand — its tables, its flows, its tokens, its ADRs. Story 7 inherits six stories' worth of
resolved decisions. Batching throws that away and re-litigates the same questions at every
gate.

```text
01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11 → 12 → 13 → 14 → 15
                                                                        │
                                          sprint full? ─────────────────┤
                                            │            no → └─────────→ next story
                                           yes
                                            ↓
                                     16 → 17  (for that sprint's stories)
                                            │
                                            └→ next story
```

**When a sprint fills, plan it.** Each story that clears `15-decisions` is slotted into the
open `SPRINT-##.md` record with its story points. When the accepted total reaches
`<%SPRINT_CAPACITY_SP%>` SP — stretching to `<%SPRINT_GRACE_SP%>` only where the next
story would otherwise split badly — run `16-sprint-plans` and `17-story-plans` for that
sprint's stories before planning resumes. A completed sprint plan then informs the next
set of stories, the same way each story informs the next. Rules and the ceiling:
`project-management/docs/PLANNING-GUIDE.md`.

**Then consolidate.** Planning per story means design work arrives per story: five stories
produce five sets of tables, flows, tokens, components, and screens, and they will drift.
That is the accepted cost of the loop, not an accident. Once every story is through `16`,
`18-consolidate-design-work` reconciles the accumulated per-story work into one coherent
design. Only then does implementation begin.

Design and schema folders (`src/04`–`src/08`) carry that three-stage shape directly:

```text
USER-STORY-IDEAS/   →   CONSOLIDATED-IDEAS/   →   IMPLEMENTATION/
  stage 1, per story      stage 2, workflow 18      what shipped
  frozen once 16 runs
```

## Directory Tree

```text
project-management/workflows/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules for this folder
│
│   ── Discover, once per feature (01) ──
├── 01-feature-map/             ← wayfinder: chart the decision frontier, resolve it
│
│   ── Specify, one story at a time (02–14) ──
├── 02-story-creation/          ← write a well-formed user story with acceptance criteria
├── 03-sprint-planning/         ← open a sprint record; accumulate stories against capacity
├── 04-database-schema/         ← design and sign off this story's schema before coding
├── 05-user-flow-design/        ← map this story's user journeys before wireframing
├── 06-brand-guides/            ← the brand tokens this story needs
├── 07-component-designs/       ← the components this story needs
├── 08-wireframes/              ← this story's screens
├── 09-gdpr-compliance/         ← review this story for GDPR compliance
├── 10-security-checks/         ← threat model and security review of the design
├── 11-qa-checks/               ← QA planning from wireframes before development
├── 12-seo-checks/              ← verify SEO on any public-facing page
├── 13-api-design/              ← design the Django Ninja API contract
├── 14-logging-checks/          ← the story's log surface and its exclusion list
│
│   ── Decide & plan (15–17) ──
├── 15-decisions/               ← author an ADR; end of the per-story loop
├── 16-sprint-plans/            ← on sprint fill: the detailed sprint plan
├── 17-story-plans/             ← on sprint fill: the per-story implementation plan
│
│   ── Consolidate (17) ──
├── 18-consolidate-design-work/ ← unify the per-story design + schema work, once
│
│   ── Implement (19–21) ──
├── 19-backend-code/            ← implement Django models, services, and business logic
├── 20-api-code/                ← implement the Django Ninja API layer
├── 21-frontend-code/           ← implement Django templates + django-components
│
│   ── Record & ship (22–24) ──
├── 22-implementation-documentation/ ← update docs + write IMPLEMENTATION records
├── 23-pr-and-review/           ← create, review, and merge a feature PR
└── 24-release/                 ← cut a release (version bump, changelog, deployment)
```

Every folder carries `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and `CHECKLIST.md`.

| Workflow                           | Purpose                                                          |
| ---------------------------------- | ---------------------------------------------------------------- |
| `01-feature-map/`                  | Chart the feature's decision frontier with wayfinder, resolve it |
| `02-story-creation/`               | Write a well-formed user story with acceptance criteria          |
| `03-sprint-planning/`              | Open the sprint record and accumulate stories against capacity   |
| `04-database-schema/`              | Design and sign off this story's schema before coding            |
| `05-user-flow-design/`             | Map this story's journeys and data touchpoints                   |
| `06-brand-guides/`                 | The brand tokens this story introduces or consumes               |
| `07-component-designs/`            | The components this story introduces or reuses                   |
| `08-wireframes/`                   | This story's screens, on the components it needs                 |
| `09-gdpr-compliance/`              | Review this story for GDPR compliance                            |
| `10-security-checks/`              | Threat model and security review of the story's design           |
| `11-qa-checks/`                    | QA planning from wireframes — test scenarios before any code     |
| `12-seo-checks/`                   | Verify SEO on any public-facing page the story adds              |
| `13-api-design/`                   | Design the Django Ninja API contract for the story               |
| `14-logging-checks/`               | Set the story's log surface and what must never reach a log line |
| `15-decisions/`                    | Confirm the story's ADRs hold and don't clash — the loop's last  |
| `16-sprint-plans/`                 | On sprint fill: the detailed sprint plan                         |
| `17-story-plans/`                  | On sprint fill: the per-story implementation plan (code master)  |
| `18-consolidate-design-work/`      | Unify the per-story design and schema work into one system       |
| `19-backend-code/`                 | Implement Django models, services, and business logic (TDD)      |
| `20-api-code/`                     | Implement the Django Ninja API layer                             |
| `21-frontend-code/`                | Implement Django templates + django-components (HTMX/Alpine)     |
| `22-implementation-documentation/` | Update docs + write IMPLEMENTATION records after code            |
| `23-pr-and-review/`                | Create, review, and merge a feature PR                           |
| `24-release/`                      | Cut a release (version bump, changelog, deployment)              |

## Pairing with the code layer

These workflows are the **specify and gate** half of a two-layer chain; `code/workflows/` is the
**build and verify** half. The canonical pairing map — which PM workflow pairs with which code
workflow, which PM phase enters it, and who owns each fact — is in
[`REFERENCES.md` → Cross-layer workflow pairing](../../REFERENCES.md). Do not restate it here.

Three rules follow from it:

- **Design gates never trigger a code workflow directly.** `04-database-schema` and `08-wireframes`
  hand forward to the next gate, not to `code/workflows/`. Implementation is reached only through
  `19-backend-code`, `20-api-code`, and `21-frontend-code`, once `02`–`18` are complete.
- **`18-consolidate-design-work` is a hard gate on implementation.** No code starts from
  unconsolidated per-story design; that is what makes planning per story safe.
- **`22-implementation-documentation` owns the whole closeout** — records, findings,
  `GAPS.md`/`DEFERRED.md`, the `CONTEXT.md`/`CLAUDE.md` update, and the graph refresh. Workflow
  `22` verifies them; the code workflows hand off to `21` and restate nothing.

**The register is a loop, not a dead end.** `GAPS.md` and `DEFERRED.md` are written at `21` and
**read at `01`**: the discovery gate mines them for candidate features and triages every open
entry against the feature being charted — closes, blocks, or unrelated. `01` **claims**; only
`21` **closes**, against shipped code. Without the read half, the register accumulates while
features are chosen from memory.

## The numbers are the running order

Unlike `code/workflows/` and `how-to/workflows/` — which are catalogues entered by task type,
where numbers are stable identifiers and are never reused — **these numbers are a sequence**.
`02` runs before `03`; `17` gates `18`. Inserting a workflow mid-sequence therefore means
renumbering everything after it and sweeping every reference, including the skill definitions
in `.claude/skills/`, where a stale number is a silent routing failure. Do it deliberately or
not at all.

### …but `src/` numbers are frozen

**This applies to workflow folders only.** A workflow folder is a **procedure** — pure
documentation, wholly owned by the template, so renumbering it is a reference sweep and the
worst case is a broken link.

A `project-management/src/NN-…/` folder is a **data store**. It holds artefacts a developer
wrote — stories, ADRs, sprint records — that the template has never seen. Renumbering one is a
**schema migration, and Copier cannot perform it**: on `copier update` it moves the scaffolding
it owns to the new path and deletes the old, while every file the developer created stays
behind in a folder nothing points at any more. No conflict is raised. Nothing fails. The work is
simply orphaned, and the more of it there is, the more is lost.

So the `src/` numbers are **frozen — append only**, on the same rule `code/workflows/` and
`how-to/workflows/` already follow. A release may renumber the tree **only if it ships a
migration in the same commit** that carries the developer's files across — taken twice, at
v2.0.0 and v7.0.0, and never on the grounds that a migration could be written. If a new artefact folder is needed it takes the next free
number at the end, whatever the workflow order says. The workflow↔`src` mirroring is a
convenience, not an invariant; when the two disagree, the mirroring gives way, because one side
is documentation and the other is somebody's work.

Enforced by `code/src/scripts/audits/template-orphans.sh`.
