# project-management/src

**Last Updated**: <%DATE%> · **Language**: British English (en_GB)

Source artefacts for project management, planning, and compliance — a base-repo
scaffold. The numbered folders run in **three tiers**: _specify_ (02–13), _decide &
plan_ (14–16), then _implement & record_ (17–22). `00-ASSETS` is pre-workflow reference.
Each compliance folder (09–13) carries per-story `PLANNING/` + `IMPLEMENTATION/`
templates, mirroring the 09-GDPR pattern. Everything from 02 to 21 is anchored to a
user story; **22-INCIDENTS is the one folder that is not**, because an incident is not
caused by, scoped to, or owned by a story.

**The stack these artefacts specify.** Every template here is written against one
server-rendered stack: **Django** (+ **Gunicorn**/**Uvicorn**) · **Django Ninja** for the
JSON API at `/api/` · **Django templates** + **django-components** · **HTMX** and
**Alpine** for interactivity · **vanilla token CSS** · **PostgreSQL** · **Valkey** ·
**Celery** for background and scheduled work (declared, not wired — a story that needs a task
also wires it: `how-to/docs/CELERY-FIRST-RUN.md`). On the **web surface** there is no client-side
framework and no build step — an artefact that assumes one is wrong. A project that opted into
the optional React Native **mobile surface** has a second delivery target with its own
toolchain; artefacts covering it must say so explicitly, because silence still means the web
surface. Interaction tiers and the page-vs-API split: `code/docs/RENDERING.md` ·
`code/docs/api-design/CLIENT-PATTERNS.md`.

---

## The three tiers

| Tier                       | Folders | What happens                                                                                                                                                      |
| -------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Specify**                | 02–13   | Write the story, organise sprints, and produce every design & compliance spec — DB, user flow, brand, components, wireframes, GDPR, security, QA, SEO, API design |
| **Decide & plan**          | 14–16   | Make the architectural decisions (ADRs), then plan each sprint, then plan each story — all **before any code**                                                    |
| **Implement & record**     | 17–21   | After code ships: record tests, reviews, findings, bugs, and refactoring, **per story**                                                                           |
| **Record (not per story)** | 22      | The PII-free incident register — declared incidents, their severity and outcome. No story anchor, and no workflow: an incident is unplanned                       |

The **story plan (16) is the master reference the developer codes from** — it points
back up to its sprint plan (15), the decisions (14), and every 02–13 spec. Sprint plans
(15) feed the story plans; the sprint plan sets the goal, story set, and sequence.

---

## Full Directory Tree

```text
project-management/src/
├── CLAUDE.md           ← operating rules
├── CONTEXT.md          ← this file
├── 00-ASSETS/          ← logos, brand assets, export scripts (pre-workflow reference)
│
│   ── Discover (01) ──
├── 01-FEATURE-MAPS/         ← MAP-<FEATURE>.md — wayfinder decision maps
│
│   ── Specify (02–13) ──
├── 02-STORIES/         ← US###.md (+ US000-TEMPLATE.md)
├── 03-SPRINTS/         ← SPRINT-##.md — backlog → sprint organisation (high-level)
│   (04–08 are three-stage: USER-STORY-IDEAS/ → CONSOLIDATED-IDEAS/ → IMPLEMENTATION/)
├── 04-DATABASE/        ← 3 stages + ERD-DIAGRAMS/ (cumulative)
├── 05-USER-FLOW/       ← 3 stages + DIAGRAMS/ (cumulative)
├── 06-BRAND-GUIDE/     ← 3 stages + guide-build/ (Python → LaTeX → PDF, cumulative)
├── 07-COMPONENTS/      ← 3 stages + component-build/ (Python → LaTeX → PDF, cumulative)
├── 08-WIREFRAMES/      ← 3 stages + SHARED/wireframe.css (cumulative)
├── 09-GDPR/            ← 6 register skeletons + PLANNING/ + IMPLEMENTATION/ (per story)
├── 10-SECURITY/        ← THREAT-MODEL/ ASSESSMENTS/ AUDITS/ VULNERABILITIES/
│                          (each PLANNING/ + IMPLEMENTATION/, per story)
├── 11-QA/              ← PLANNING/ + IMPLEMENTATION/ (per story)
├── 12-SEO/             ← PLANNING/ + IMPLEMENTATION/ (per story)
├── 13-API-DESIGN/      ← PLANNING/ + IMPLEMENTATION/ (per story)
│
│   ── Decide & plan (14–16) ──
├── 14-DECISIONS/       ← ADR-###-<TITLE>.md (architectural decision records)
├── 15-SPRINT-PLANS/    ← detailed sprint execution plans
├── 16-STORY-PLANS/     ← per-story implementation plan (the code master reference)
│
│   ── Implement & record, per story (17–21) ──
├── 17-TESTS/           ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
├── 18-REVIEWS/         ← REVIEW-US###-<DESCRIPTOR>.md
├── 19-FINDINGS/        ← FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
├── 20-BUGS/            ← BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md
├── 21-REFACTORING/     ← REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
│
│   ── Record, not per story (22) ──
└── 22-INCIDENTS/       ← INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md + INCIDENT-INDEX.md (PII-free)
```

Every folder carries a `CONTEXT.md` + `CLAUDE.md`; the 09–13 folders scaffold their
`PLANNING/` and `IMPLEMENTATION/` sub-folders with per-story `US000-TEMPLATE.md` files.

---

## The numbers here are frozen

**Append only. Never renumber a folder in this tree.**

`project-management/workflows/` numbers are a running order, and inserting one mid-sequence
legitimately renumbers the rest — those folders are documentation the template owns end to end.
These folders are different in kind: they hold **artefacts a developer wrote**, which the
template has never seen.

Renumbering one is therefore a **schema migration, and Copier cannot perform it.** On
`copier update` it moves the scaffolding it owns to the new path and deletes the old, while
every story, ADR and sprint record the developer created stays behind in a folder nothing
references any more. No conflict is raised, nothing fails, and the update reports success. The
work is silently orphaned — and the longer the project has run, the more of it goes.

So a new artefact folder takes the **next free number at the end**, even where that breaks the
workflow↔`src` mirroring. The mirroring is a convenience; the developer's work is not.

Enforced by `code/src/scripts/audits/template-orphans.sh`, which fails on any artefact sitting
in a directory the current template no longer defines.

---

## Where each artefact lives

| Pattern                                                                 | Directory                                                                                            |
| ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `US###.md`                                                              | `02-STORIES/`                                                                                        |
| `SPRINT-##.md`                                                          | `03-SPRINTS/`                                                                                        |
| `<TYPE>-IDEA-US###-*` · `<TYPE>-CONSOLIDATED-*` · `<TYPE>-IMPL-US###-*` | `04-DATABASE/` … `08-WIREFRAMES/` (TYPE ∈ DB, USER-FLOW, BRAND, COMP, WF)                            |
| `WF-###-<Screen-Name>.html`                                             | `08-WIREFRAMES/CONSOLIDATED-IDEAS/`                                                                  |
| `GDPR-PLAN-US###-*.md` · `GDPR-IMPL-US###-*.md`                         | `09-GDPR/PLANNING` · `/IMPLEMENTATION`                                                               |
| `<TYPE>-PLAN-US###-*.md` · `<TYPE>-IMPL-US###-*.md`                     | `10-SECURITY/<CATEGORY>/PLANNING` · `/IMPLEMENTATION` (TYPE ∈ THREAT-MODEL, ASSESSMENT, AUDIT, VULN) |
| `QA-PLAN-US###-*.md` · `QA-IMPL-US###-*.md`                             | `11-QA/PLANNING` · `/IMPLEMENTATION`                                                                 |
| `SEO-PLAN-US###-*.md` · `SEO-IMPL-US###-*.md`                           | `12-SEO/PLANNING` · `/IMPLEMENTATION`                                                                |
| `API-PLAN-US###-*.md` · `API-IMPL-US###-*.md`                           | `13-API-DESIGN/PLANNING` · `/IMPLEMENTATION`                                                         |
| `ADR-###-<TITLE>.md`                                                    | `14-DECISIONS/`                                                                                      |
| `##-SPRINT-PLAN-##.md`                                                  | `15-SPRINT-PLANS/`                                                                                   |
| `STORY-PLAN-US###-<DESCRIPTOR>.md`                                      | `16-STORY-PLANS/`                                                                                    |
| `US###-TEST-STATUS.md` · `US###-MANUAL-TESTING.md`                      | `17-TESTS/`                                                                                          |
| `REVIEW-US###-<DESCRIPTOR>.md`                                          | `18-REVIEWS/`                                                                                        |
| `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`                              | `19-FINDINGS/`                                                                                       |
| `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`                                  | `20-BUGS/`                                                                                           |
| `REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`                          | `21-REFACTORING/`                                                                                    |
| `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md` · `INCIDENT-INDEX.md`             | `22-INCIDENTS/` (no `US###` form — an incident is not owned by a story)                              |

Descriptors in `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY; story numbers zero-padded to three digits.

---

## The two sub-folder patterns

Design and compliance folders both tie artefacts to a user story — but the design folders carry
an extra stage, because design fragments across stories in a way compliance does not.

### Three-stage — `04-DATABASE` … `08-WIREFRAMES`

Stories are planned **one at a time** (`workflows/CONTEXT.md` → _The planning cadence_), so each
story designs the schema, flows, tokens, components, and screens it needs in isolation. That
drifts by construction. `17-consolidate-design-work` reconciles it once every story is planned.

| Sub-folder            | When           | Holds                                            |
| --------------------- | -------------- | ------------------------------------------------ |
| `USER-STORY-IDEAS/`   | workflow 04–08 | the per-story design — **frozen** once `17` runs |
| `CONSOLIDATED-IDEAS/` | workflow 17    | the unified design; **this is what gets built**  |
| `IMPLEMENTATION/`     | workflow 21    | the per-story record of what actually shipped    |

Each also keeps one **cumulative** asset outside the stages — `ERD-DIAGRAMS/`, `DIAGRAMS/`,
`guide-build/`, `component-build/`, `SHARED/wireframe.css`. The brand and component PDFs are
regenerated once, at consolidation.

### Two-stage — `09-GDPR` … `13-API-DESIGN`

| Sub-folder        | When to write                         | Holds                                                      |
| ----------------- | ------------------------------------- | ---------------------------------------------------------- |
| `PLANNING/`       | Pre-implementation, before code       | the per-story plan/design/spec                             |
| `IMPLEMENTATION/` | Post-implementation, during PR review | the per-story verification, closing the plan with evidence |

Applies to `09-GDPR/`, `10-SECURITY/` (each of its four categories), `11-QA/`, `12-SEO/`,
and `13-API-DESIGN/`. These need no consolidation stage: a GDPR lawful basis or an API contract
is genuinely per story and does not fragment a shared system.

There is no cross-cutting by-scope report folder in either pattern — the per-story artefacts
serve that role.

---

## Cross-references

- `project-management/CONTEXT.md` — full PM layer overview and workflow gates
- `project-management/docs/VERSIONING-GUIDE.md` — semantic versioning rules
- `project-management/docs/GIT-GUIDE.md` — branch naming and PR conventions
